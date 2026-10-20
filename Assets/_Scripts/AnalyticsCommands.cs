using UnityEngine;
using System;
using System.Globalization;

public interface IAnalyticsCommand
{
    string Action { get; }
    WWWForm GetForm();
    void OnSuccess(uint id);
}

public class NewPlayerCommand : IAnalyticsCommand
{
    private readonly string _name;
    private readonly string _country;
    private readonly int _age;
    private readonly float _gender;
    private readonly DateTime _date;

    public NewPlayerCommand(string name, string country, int age, float gender, DateTime date)
    {
        _name = name;
        _country = country;
        _age = age;
        _gender = gender;
        _date = date;
    }

    public string Action => "newPlayer";

    public WWWForm GetForm()
    {
        WWWForm form = new WWWForm();
        form.AddField("action", Action);
        form.AddField("p_name", _name);
        form.AddField("p_country", _country);
        form.AddField("p_age", _age);
        form.AddField("p_gender", _gender.ToString(CultureInfo.InvariantCulture));
        form.AddField("p_date", _date.ToString("yyyy-MM-dd HH:mm:ss"));
        return form;
    }

    public void OnSuccess(uint playerID)
    {
        CallbackEvents.OnAddPlayerCallback?.Invoke(playerID);
    }
}

public class NewSessionCommand : IAnalyticsCommand
{
    private readonly uint _playerID;
    private readonly DateTime _date;

    public NewSessionCommand(uint playerID, DateTime date)
    {
        _playerID = playerID;
        _date = date;
    }

    public string Action => "newSession";

    public WWWForm GetForm()
    {
        WWWForm form = new WWWForm();
        form.AddField("action", Action);
        form.AddField("p_id", _playerID.ToString());
        form.AddField("s_date", _date.ToString("yyyy-MM-dd HH:mm:ss"));
        return form;
    }

    public void OnSuccess(uint sessionID)
    {
        AnalyticsManager.Instance.SessionToPlayerMap[sessionID] = _playerID;
        CallbackEvents.OnNewSessionCallback?.Invoke(sessionID);
    }
}

public class BuyItemCommand : IAnalyticsCommand
{
    private readonly int _itemID;
    private readonly uint _sessionID;
    private readonly DateTime _date;

    public BuyItemCommand(int itemID, uint sessionID, DateTime date)
    {
        _itemID = itemID;
        _sessionID = sessionID;
        _date = date;
    }

    public string Action => "buyItem";

    public WWWForm GetForm()
    {
        WWWForm form = new WWWForm();
        form.AddField("action", Action);
        form.AddField("s_id", _sessionID.ToString());
        form.AddField("item_id", _itemID.ToString());
        form.AddField("b_date", _date.ToString("yyyy-MM-dd HH:mm:ss"));
        return form;
    }

    public void OnSuccess(uint purchaseID)
    {
        CallbackEvents.OnItemBuyCallback?.Invoke(_sessionID);
    }
}

public class EndSessionCommand : IAnalyticsCommand
{
    private readonly uint _sessionID;
    private readonly DateTime _date;

    public EndSessionCommand(uint sessionID, DateTime date)
    {
        _sessionID = sessionID;
        _date = date;
    }

    public string Action => "endSession";

    public WWWForm GetForm()
    {
        WWWForm form = new WWWForm();
        form.AddField("action", Action);
        form.AddField("s_id", _sessionID.ToString());
        form.AddField("s_date", _date.ToString("yyyy-MM-dd HH:mm:ss"));
        return form;
    }

    public void OnSuccess(uint sessionID)
    {
        var map = AnalyticsManager.Instance.SessionToPlayerMap;
        if (map.TryGetValue(_sessionID, out uint playerID))
        {
            map.Remove(_sessionID);
            CallbackEvents.OnEndSessionCallback?.Invoke(playerID);
        }
    }
}
