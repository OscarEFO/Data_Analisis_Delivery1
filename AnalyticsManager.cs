using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using UnityEngine.Networking;
using System.Globalization;

public class AnalyticsManager : MonoBehaviour
{
    public string serverURL = "https://github.com/OscarEFO/Data_Analisis_Delivery1";

    private Dictionary<uint, uint> _sessionToPlayerMap = new Dictionary<uint, uint>();
    private uint _currentPlayerIDForSession;

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
        WWWForm form = new WWWForm();
        form.AddField("action", "newPlayer");
        form.AddField("p_name", name);
        form.AddField("p_country", country);
        form.AddField("p_age", age);
        form.AddField("p_gender", gender.ToString(CultureInfo.InvariantCulture));
        form.AddField("p_date", date.ToString("yyyy-MM-dd HH:mm:ss"));

        StartCoroutine(SendData(form, "newPlayer"));
    }

    void HandleNewSession(DateTime date, uint playerID)
    {
        _currentPlayerIDForSession = playerID;

        WWWForm form = new WWWForm();
        form.AddField("action", "newSession");
        form.AddField("p_id", playerID.ToString());
        form.AddField("s_date", date.ToString("yyyy-MM-dd HH:mm:ss"));

        StartCoroutine(SendData(form, "newSession"));
    }

    void HandleEndSession(DateTime date, uint sessionID)
    {
        WWWForm form = new WWWForm();
        form.AddField("action", "endSession");
        form.AddField("s_id", sessionID.ToString());
        form.AddField("s_date", date.ToString("yyyy-MM-dd HH:mm:ss"));

        StartCoroutine(SendData(form, "endSession", sessionID));
    }

    void HandleBuyItem(int itemID, DateTime date, uint sessionID)
    {
        WWWForm form = new WWWForm();
        form.AddField("action", "buyItem");
        form.AddField("s_id", sessionID.ToString());
        form.AddField("item_id", itemID.ToString());
        form.AddField("b_date", date.ToString("yyyy-MM-dd HH:mm:ss"));

        StartCoroutine(SendData(form, "buyItem", sessionID));
    }

    private IEnumerator SendData(WWWForm form, string action, uint sessionID = 0)
    {
        using (UnityWebRequest www = UnityWebRequest.Post(serverURL, form))
        {
            yield return www.SendWebRequest();

            if (www.result != UnityWebRequest.Result.Success)
            {
                Debug.LogError($"Error sending {action}: {www.error}");
            }
            else
            {
                string responseText = www.downloadHandler.text;
                Debug.Log($"Success sending {action}! Response: {responseText}");

                uint newID = ParseIDFromResponse(responseText);

                switch (action)
                {
                    case "newPlayer":
                        CallbackEvents.OnAddPlayerCallback?.Invoke(newID);
                        break;

                    case "newSession":
                        _sessionToPlayerMap[newID] = _currentPlayerIDForSession;
                        CallbackEvents.OnNewSessionCallback?.Invoke(newID);
                        break;

                    case "buyItem":
                        CallbackEvents.OnItemBuyCallback?.Invoke(sessionID);
                        break;

                    case "endSession":
                        if (_sessionToPlayerMap.TryGetValue(sessionID, out uint playerID))
                        {
                            CallbackEvents.OnEndSessionCallback?.Invoke(playerID);
                            _sessionToPlayerMap.Remove(sessionID);
                        }
                        break;
                }
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