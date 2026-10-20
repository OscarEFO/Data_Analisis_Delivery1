using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.Networking;

public class AnalyticsManager : MonoBehaviour
{
    public static AnalyticsManager Instance { get; private set; }

    public string serverURL = "https://citmalumnes.upc.es/~oscaref1/AnalyticsTest.php";

    public Dictionary<uint, uint> SessionToPlayerMap { get; } = new Dictionary<uint, uint>();

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
    }

    private void OnEnable()
    {
        Simulator.OnNewPlayer += HandleNewPlayer;
        Simulator.OnNewSession += HandleNewSession;
        Simulator.OnEndSession += HandleEndSession;
        Simulator.OnBuyItem += HandleBuyItem;
    }

    private void OnDisable()
    {
        Simulator.OnNewPlayer -= HandleNewPlayer;
        Simulator.OnNewSession -= HandleNewSession;
        Simulator.OnEndSession -= HandleEndSession;
        Simulator.OnBuyItem -= HandleBuyItem;
    }

    void HandleNewPlayer(string name, string country, int age, float gender, DateTime date)
    {
        Send(new NewPlayerCommand(name, country, age, gender, date));
    }

    void HandleNewSession(DateTime date, uint playerID)
    {
        Send(new NewSessionCommand(playerID, date));
    }

    void HandleEndSession(DateTime date, uint sessionID)
    {
        Send(new EndSessionCommand(sessionID, date));
    }

    void HandleBuyItem(int itemID, DateTime date, uint sessionID)
    {
        Send(new BuyItemCommand(itemID, sessionID, date));
    }

    public void Send(IAnalyticsCommand command)
    {
        StartCoroutine(SendData(command));
    }

    private IEnumerator SendData(IAnalyticsCommand command)
    {
        using (UnityWebRequest www = UnityWebRequest.Post(serverURL, command.GetForm()))
        {
            yield return www.SendWebRequest();

            if (www.result != UnityWebRequest.Result.Success)
            {
                Debug.LogError($"Error sending {command.Action}: {www.error}");
            }
            else
            {
                string responseText = www.downloadHandler.text;
                Debug.Log($"Success sending {command.Action}! Response: {responseText}");

                uint newID = ParseIDFromResponse(responseText);

                if (newID == 0)
                    yield break;

                command.OnSuccess(newID);
            }
        }
    }

    [System.Serializable]
    private class ServerResponse
    {
        public bool success;
        public uint id;
        public string error;
    }

    private uint ParseIDFromResponse(string jsonResponse)
    {
        try
        {
            ServerResponse response = JsonUtility.FromJson<ServerResponse>(jsonResponse);
            if (response != null && response.success)
            {
                return response.id;
            }
            else
            {
                Debug.LogError($"Server error: {response?.error ?? "Unknown error"}");
                return 0;
            }
        }
        catch (Exception e)
        {
            Debug.LogError($"Failed to parse server response: {jsonResponse}. Error: {e.Message}");
            return 0;
        }
    }
}
