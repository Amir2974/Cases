 #include <a_samp>

#define DIALOG_BR_CASES     9600
#define DIALOG_BR_INFO      9601
#define DIALOG_BR_WIN       9602

new PlayerText:CaseBox[MAX_PLAYERS];
new PlayerText:CaseTitle[MAX_PLAYERS];
new PlayerText:CaseItemText[MAX_PLAYERS];
new PlayerText:CaseSubText[MAX_PLAYERS];

new CaseTimer[MAX_PLAYERS];
new CaseStep[MAX_PLAYERS];
new CaseSelected[MAX_PLAYERS];
new bool:IsOpeningCase[MAX_PLAYERS];

new const CasePrices[4] = { 15000, 100000, 500000, 1500000 };

public OnFilterScriptInit()
{
    print(" [BR-Cases] Система кейсов Black Russia загружена!");
    return 1;
}

public OnPlayerConnect(playerid)
{
    IsOpeningCase[playerid] = false;
    CreateCaseTextDraws(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(IsOpeningCase[playerid]) KillTimer(CaseTimer[playerid]);
    IsOpeningCase[playerid] = false;
    return 1;
}

stock CreateCaseTextDraws(playerid)
{
    CaseBox[playerid] = CreatePlayerTextDraw(playerid, 320.0, 165.0, "_");
    PlayerTextDrawAlignment(playerid, CaseBox[playerid], 2);
    PlayerTextDrawUseBox(playerid, CaseBox[playerid], 1);
    PlayerTextDrawBoxColor(playerid, CaseBox[playerid], 0x151515EE);
    PlayerTextDrawTextSize(playerid, CaseBox[playerid], 0.0, 240.0);
    PlayerTextDrawLetterSize(playerid, CaseBox[playerid], 0.0, 9.5);

    CaseTitle[playerid] = CreatePlayerTextDraw(playerid, 320.0, 168.0, "~b~BLACK RUSSIA ~w~| ОТКРЫТИЕ КЕЙСА");
    PlayerTextDrawAlignment(playerid, CaseTitle[playerid], 2);
    PlayerTextDrawFont(playerid, CaseTitle[playerid], 1);
    PlayerTextDrawLetterSize(playerid, CaseTitle[playerid], 0.28, 1.3);
    PlayerTextDrawColor(playerid, CaseTitle[playerid], 0xFFFFFFFF);
    PlayerTextDrawSetOutline(playerid, CaseTitle[playerid], 1);

    CaseItemText[playerid] = CreatePlayerTextDraw(playerid, 320.0, 200.0, "~y~Крутим рулетку...");
    PlayerTextDrawAlignment(playerid, CaseItemText[playerid], 2);
    PlayerTextDrawFont(playerid, CaseItemText[playerid], 1);
    PlayerTextDrawLetterSize(playerid, CaseItemText[playerid], 0.36, 1.6);
    PlayerTextDrawColor(playerid, CaseItemText[playerid], 0xFFFFFFFF);
    PlayerTextDrawSetOutline(playerid, CaseItemText[playerid], 1);

    CaseSubText[playerid] = CreatePlayerTextDraw(playerid, 320.0, 232.0, "~w~Подождите, определяется ваш приз");
    PlayerTextDrawAlignment(playerid, CaseSubText[playerid], 2);
    PlayerTextDrawFont(playerid, CaseSubText[playerid], 1);
    PlayerTextDrawLetterSize(playerid, CaseSubText[playerid], 0.22, 1.1);
    PlayerTextDrawColor(playerid, CaseSubText[playerid], 0xCCCCCCFF);
    PlayerTextDrawSetOutline(playerid, CaseSubText[playerid], 0);
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/cases", true) || !strcmp(cmdtext, "/case", true) || !strcmp(cmdtext, "/roulette", true))
    {
        if(IsOpeningCase[playerid])
            return SendClientMessage(playerid, 0xFF0000FF, "[Кейсы] Вы уже открываете кейс!");

        ShowPlayerDialog(playerid, DIALOG_BR_CASES, DIALOG_STYLE_TABLIST_HEADERS,
            "{2ec4d6}Магазин кейсов | Amir Russia",
            "Кейс\tЦена\n\
            {808080}Кейс «Бомжа»\t{00FF00}15000 руб.\n\
            {FFFFFF}Стандартный кейс\t{00FF00}100000 руб.\n\
            {2ec4d6}Авто-кейс\t{00FF00}500000 руб.\n\
            {FFD700}Особый кейс\t{00FF00}1500000 руб.",
            "Выбрать", "Закрыть");
        return 1;
    }
    return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_BR_CASES && response)
    {
        CaseSelected[playerid] = listitem;
        switch(listitem)
        {
            case 0: ShowPlayerDialog(playerid, DIALOG_BR_INFO, DIALOG_STYLE_MSGBOX, "{2ec4d6}Информация о кейсе", "{FFFFFF}Вы выбрали: {808080}Кейс «Бомжа»\n{FFFFFF}Стоимость: {00FF00}15.000 руб.\n\n{CCCCCC}Возможный дроп:\n- Деньги до 50.000 руб.\n- Одежда работяги\n- Мопед Faggio", "Открыть", "Назад");
            case 1: ShowPlayerDialog(playerid, DIALOG_BR_INFO, DIALOG_STYLE_MSGBOX, "{2ec4d6}Информация о кейсе", "{FFFFFF}Вы выбрали: {FFFFFF}Стандартный кейс\n{FFFFFF}Стоимость: {00FF00}100.000 руб.\n\n{CCCCCC}Возможный дроп:\n- Деньги до 300.000 руб.\n- Брендовая одежда\n- Автомобиль Vincent", "Открыть", "Назад");
            case 2: ShowPlayerDialog(playerid, DIALOG_BR_INFO, DIALOG_STYLE_MSGBOX, "{2ec4d6}Информация о кейсе", "{FFFFFF}Вы выбрали: {2ec4d6}Авто-кейс\n{FFFFFF}Стоимость: {00FF00}500.000 руб.\n\n{CCCCCC}Возможный дроп:\n- Спорткары Sultan и Infernus\n- Компенсация 350.000 руб.", "Открыть", "Назад");
            case 3: ShowPlayerDialog(playerid, DIALOG_BR_INFO, DIALOG_STYLE_MSGBOX, "{2ec4d6}Информация о кейсе", "{FFFFFF}Вы выбрали: {FFD700}Особый кейс\n{FFFFFF}Стоимость: {00FF00}1.500.000 руб.\n\n{CCCCCC}Возможный дроп:\n- До 5.000.000 руб.\n- Скины Авторитета и Босса", "Открыть", "Назад");
        }
        return 1;
    }

    if(dialogid == DIALOG_BR_INFO)
    {
        if(!response) return OnPlayerCommandText(playerid, "/cases");

        new idx = CaseSelected[playerid];
        if(GetPlayerMoney(playerid) < CasePrices[idx])
            return SendClientMessage(playerid, 0xFF3333FF, "[Кейсы] Недостаточно средств на балансе!");

        GivePlayerMoney(playerid, -CasePrices[idx]);
        StartCaseAnimation(playerid);
        return 1;
    }
    return 0;
}

stock StartCaseAnimation(playerid)
{
    IsOpeningCase[playerid] = true;
    CaseStep[playerid] = 0;

    PlayerTextDrawShow(playerid, CaseBox[playerid]);
    PlayerTextDrawShow(playerid, CaseTitle[playerid]);
    PlayerTextDrawShow(playerid, CaseItemText[playerid]);
    PlayerTextDrawShow(playerid, CaseSubText[playerid]);

    CaseTimer[playerid] = SetTimerEx("UpdateCaseRoulette", 120, false, "i", playerid);
}

forward UpdateCaseRoulette(playerid);
public UpdateCaseRoulette(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    CaseStep[playerid]++;
    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

    if(CaseStep[playerid] < 18)
    {
        switch(random(6))
        {
            case 0: PlayerTextDrawSetString(playerid, CaseItemText[playerid], "~g~10.000 рублей");
            case 1: PlayerTextDrawSetString(playerid, CaseItemText[playerid], "~b~Скин: Мажор (ID 294)");
            case 2: PlayerTextDrawSetString(playerid, CaseItemText[playerid], "~y~Авто: Спорткар Sultan");
            case 3: PlayerTextDrawSetString(playerid, CaseItemText[playerid], "~g~350.000 рублей");
            case 4: PlayerTextDrawSetString(playerid, CaseItemText[playerid], "~y~Суперкар Infernus");
            case 5: PlayerTextDrawSetString(playerid, CaseItemText[playerid], "~p~5.000.000 рублей + Скин");
        }

        new next_delay = 110 + (CaseStep[playerid] * 18);
        CaseTimer[playerid] = SetTimerEx("UpdateCaseRoulette", next_delay, false, "i", playerid);
    }
    else
    {
        FinishCaseOpening(playerid);
    }
    return 1;
}

stock FinishCaseOpening(playerid)
{
    PlayerTextDrawHide(playerid, CaseBox[playerid]);
    PlayerTextDrawHide(playerid, CaseTitle[playerid]);
    PlayerTextDrawHide(playerid, CaseItemText[playerid]);
    PlayerTextDrawHide(playerid, CaseSubText[playerid]);

    IsOpeningCase[playerid] = false;
    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);

    new idx = CaseSelected[playerid];
    new rand = random(100);
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    switch(idx)
    {
        case 0:
        {
            if(rand < 60) { GivePlayerMoney(playerid, 10000); ShowPlayerDialog(playerid, DIALOG_BR_WIN, DIALOG_STYLE_MSGBOX, "{2ec4d6}Ваш выигрыш", "{FFFFFF}Из Кейса «Бомжа» вам выпало:\n\n{00FF00}10.000 рублей!", "Забрать", ""); }
            else if(rand < 90) { SetPlayerSkin(playerid, 78); ShowPlayerDialog(playerid, DIALOG_BR_WIN, DIALOG_STYLE_MSGBOX, "{2ec4d6}Ваш выигрыш", "{FFFFFF}Из Кейса «Бомжа» вам выпал:\n\n{2ec4d6}Скин работяги (ID 78)!", "Забрать", ""); }
            else { CreateVehicle(462, x+2.0, y, z, a, 1, 1, 600); ShowPlayerDialog(playerid, DIALOG_BR_WIN, DIALOG_STYLE_MSGBOX, "{2ec4d6}Ваш выигрыш", "{FFFFFF}ДЖЕКПОТ! Из Кейса «Бомжа» вам выпал:\n\n{FFD700}Мопед Faggio (доставлен рядом)!", "Забрать", ""); }
        }
        case 1:
        {
            if(rand < 55) { GivePlayerMoney(playerid, 80000); ShowPlayerDialog(playerid, DIALOG_BR_WIN, DIALOG_STYLE_MSGBOX, "{2ec4d6}Ваш выигрыш", "{FFFFFF}Из Стандартного кейса вам выпало:\n\n{00FF00}80.000 рублей!", "Забрать", ""); }
            else if(rand < 85) { SetPlayerSkin(playerid, 29); ShowPlayerDialog(playerid, DIALOG_BR_WIN, DIALOG_STYLE_MSGBOX, "{2ec4d6}Ваш выигрыш", "{FFFFFF}Из Стандартного кейса вам выпала:\n\n{2ec4d6}Модная одежда (ID 29)!", "Забрать", ""); }
            else { CreateVehicle(540, x+3.0, y, z, a, 3, 3, 600); ShowPlayerDialog(playerid, DIALOG_BR_WIN, DIALOG_STYLE_MSGBOX, "{2ec4d6}Ваш выигрыш", "{FFFFFF}ДЖЕКПОТ! Из Стандартного кейса вам выпал:\n\n{FFD700}Автомобиль Vincent (доставлен рядом)!", "Забрать", ""); }
        }
        case 2:
        {
            if(rand < 45) { GivePlayerMoney(playerid, 350000); ShowPlayerDialog(playerid, DIALOG_BR_WIN, DIALOG_STYLE_MSGBOX, "{2ec4d6}Ваш выигрыш", "{FFFFFF}Из Авто-кейса вам выпала компенсация:\n\n{00FF00}350.000 рублей!", "Забрать", ""); }
            else if(rand < 80) { CreateVehicle(560, x+3.0, y, z, a, 0, 0, 600); ShowPlayerDialog(playerid, DIALOG_BR_WIN, DIALOG_STYLE_MSGBOX, "{2ec4d6}Ваш выигрыш", "{FFFFFF}ПОЗДРАВЛЯЕМ! Из Авто-кейса вы выбили:\n\n{FFD700}Спорткар Sultan (доставлен рядом)!", "Забрать", ""); }
            else { CreateVehicle(411, x+3.0, y, z, a, 1, 1, 600); ShowPlayerDialog(playerid, DIALOG_BR_WIN, DIALOG_STYLE_MSGBOX, "{2ec4d6}Ваш выигрыш", "{FFFFFF}ЛЕГЕНДАРНЫЙ ДРОП! Из Авто-кейса вы выбили:\n\n{FFD700}Суперкар Infernus (доставлен рядом)!", "Забрать", ""); }
        }
        case 3:
        {
            if(rand < 50) { GivePlayerMoney(playerid, 1200000); ShowPlayerDialog(playerid, DIALOG_BR_WIN, DIALOG_STYLE_MSGBOX, "{2ec4d6}Ваш выигрыш", "{FFFFFF}Из Особого кейса вам выпало:\n\n{00FF00}1.200.000 рублей!", "Забрать", ""); }
            else if(rand < 85) { SetPlayerSkin(playerid, 294); ShowPlayerDialog(playerid, DIALOG_BR_WIN, DIALOG_STYLE_MSGBOX, "{2ec4d6}Ваш выигрыш", "{FFFFFF}Из Особого кейса вам выпал:\n\n{2ec4d6}Скин Авторитета (ID 294)!", "Забрать", ""); }
            else { GivePlayerMoney(playerid, 5000000); SetPlayerSkin(playerid, 299); ShowPlayerDialog(playerid, DIALOG_BR_WIN, DIALOG_STYLE_MSGBOX, "{2ec4d6}Ваш выигрыш", "{FFFFFF}СУПЕР-ДЖЕКПОТ! Вы сорвали куш:\n\n{FFD700}5.000.000 рублей + Скин Босса (ID 299)!", "Забрать", ""); }
        }
    }
}
new const CasePrices[] = { 15000, 100000, 500000, 1500000 };

       
