{*******************************************************************************
  ����: juner11212436@163.com 2018-10-25
  ����: ��Ӿ�Զ���ҵ������ݴ���
*******************************************************************************}
unit UWorkerBussinessHHJY;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, SysUtils, DB, ADODB, NativeXml, UBusinessWorker,
  UBusinessPacker, UBusinessConst, UMgrDBConn, UMgrParam, UFormCtrl, USysLoger,
  ZnMD5, ULibFun, USysDB, UMITConst, UMgrChannel, UWorkerBusiness,IdHTTP,Graphics,
  Variants, uLkJSON,DateUtils, V_Sys_Materiel_Intf, T_Sys_SaleCustomer_Intf,
  T_SupplyProvider_Intf, V_SaleConsignPlanBill_Intf, V_SaleValidConsignPlanBill_Intf,
  T_SaleConsignBill_Intf, V_QControlWareNumberNoticeBill_Intf,
  T_SaleTransportForCustomer_Intf, V_SupplyMaterialEntryPlan_Intf,
  T_SupplyMaterialReceiveBill_Intf, V_SupplyMaterialTransferPlan_Intf,
  T_SupplyMaterialTransferBill_Intf, T_SupplyWeighBill_Intf, T_SaleScheduleVan_Intf,
  V_QChemistryTestBill_Intf, V_QPhysicsRecord_Intf, V_QPhysicsWRONCRecord_Intf,
  V_QPhysicsSettingTimeRecord_Intf,V_QPhysicsFinenessRecord_Intf,
  V_QPhysicsSpecificSurfaceAreaRecord_Intf,V_QPhysicsIntensityRecord_Intf,
  QAdmixtureDataBrief_WS_Intf,QAdmixtureDataDetail_WS_Intf, xxykt_Intf;

type
  TMITDBWorker = class(TBusinessWorkerBase)
  protected
    FErrNum: Integer;
    //������
    FDBConn: PDBWorker;
    //����ͨ��
    FXXChannel: PChannelItem;
    FDataIn,FDataOut: PBWDataBase;
    //��γ���
    FDataOutNeedUnPack: Boolean;
    //��Ҫ���
    FPackOut: Boolean;
    procedure GetInOutData(var nIn,nOut: PBWDataBase); virtual; abstract;
    //�������
    function VerifyParamIn(var nData: string): Boolean; virtual;
    //��֤���
    function DoDBWork(var nData: string): Boolean; virtual; abstract;
    function DoAfterDBWork(var nData: string; nResult: Boolean): Boolean; virtual;
    //����ҵ��
  public
    function DoWork(var nData: string): Boolean; override;
    //ִ��ҵ��
    procedure WriteLog(const nEvent: string);
    //��¼��־
  end;

  TBusWorkerBusinessHHJY = class(TMITDBWorker)
  private
    FListA,FListB,FListC,FListD,FListE,FListF,FListG: TStrings;
    //list
    FIn: TWorkerHHJYData;
    FOut: TWorkerHHJYData;
    //in out
  protected
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;
    //base funciton
    function GetCusName(nCusID: string): string;
    function SyncHhSaleMateriel(var nData:string):boolean;
    //ͬ����������
    function SyncHhCustomer(var nData:string):boolean;
    //ͬ�����ۿͻ�
    function SyncHhProvider(var nData:string):boolean;
    //ͬ����Ӧ��
    function SyncHhSalePlan(var nData:string):boolean;
    //ͬ�����ۼƻ�
    function PoundVerifyHhSalePlan(var nData:string):boolean;
    //���ۼƻ�����У��
    function BillVerifyHhSalePlan(var nData:string):boolean;
    //���ۼƻ�����У��
    function SyncHhSaleDetail(var nData: string): Boolean;
    //ͬ�����۷�����ϸ
    function IsHhSaleDetailExits(var nData: string): Boolean;
    //��ѯ���۷�����ϸ
    function GetHhSaleDetailID(var nData: string): Boolean;
    //��ȡ�������۷�����ϸID
    function GetHhSaleWareNumber(var nData: string): Boolean;
    //��ȡ���κ�
    function GetHhSaleWTTruck(var nData: string): Boolean;
    //��ȡ�ɳ���
    function SyncHhSaleWareNumber(var nData: string): Boolean;
    //ͬ�����κ�
    function GetHhSaleRealPrice(var nData: string): Boolean;
    //��ȡ���¼۸�
    function GetSaleDetailJSonString(const nLID, nDelete: string; var nExits: Boolean;
                                     var nInit: string; var nNewStr: string): string;
    function GetMoney(const nPrice, nValue: string) : string;
    //������
    function SyncHhOrderPlan(var nData: string): Boolean;
    //��ȡ��ͨԭ���Ͻ����ƻ�
    function SyncHhOrderDetail(var nData: string): Boolean;
    //ͬ����ͨԭ�����ջ���ϸ
    function IsHhOrderDetailExits(var nData: string): Boolean;
    //��ѯ��ͨԭ�����ջ���ϸ
    function GetHhOrderDetailID(var nData: string): Boolean;
    //��ȡ������ͨԭ�����ջ���ϸID
    function GetOrderDetailJSonString(const nLID, nDelete: string; var nExits: Boolean;
                                     var nInit: string; var nNewStr: string): string;
    //��ȡ��ͨԭ���ϲɹ����ϴ���ϸ����
    function SyncHhNdOrderPlan(var nData: string): Boolean;
    //��ȡ�ڵ�ԭ���Ͻ����ƻ�
    function SyncHhNdOrderDetail(var nData: string): Boolean;
    //ͬ���ڵ�ԭ�����ջ���ϸ
    function IsHhNdOrderDetailExits(var nData: string): Boolean;
    //��ѯ�ڵ�ԭ�����ջ���ϸ
    function GetHhNdOrderDetailID(var nData: string): Boolean;
    //��ȡ�����ڵ�ԭ�����ջ���ϸID
    function GetNdOrderDetailJSonString(const nLID, nDelete: string; var nExits: Boolean;
                                     var nInit: string; var nNewStr: string): string;
    //��ȡ�ڵ�ԭ���ϲɹ����ϴ���ϸ����
    function SyncHhOtherOrderDetail(var nData: string): Boolean;
    //ͬ���ڵ�ԭ�����ջ���ϸ
    function IsHhOtherOrderDetailExits(var nData: string): Boolean;
    //��ѯ�ڵ�ԭ�����ջ���ϸ
    function GetHhOtherOrderDetailID(var nData: string): Boolean;
    //��ȡ�����ڵ�ԭ�����ջ���ϸID
    function GetOtherOrderDetailJSonString(const nLID, nDelete: string; var nExits: Boolean;
                                     var nInit: string; var nNewStr: string): string;
    //��ȡ�ڵ�ԭ���ϲɹ����ϴ���ϸ����
    function NewHhWTDetail(var nData: string): Boolean;
    //�����ɳ�����ϸ�������ɳ���ID
    function SaveHhHYData(var nData: string): Boolean;
    //��ȡ�����滯�鵥����
    function GetHhHYHxDetail(var nData: string): Boolean;
    //��ȡ���鵥��ѧ��������
    function GetHhHYWlDetail(var nData: string): Boolean;
    //��ȡ���鵥�����������
    function GetHhHYWlBZCD(var nData: string): Boolean;
    //��ȡ���鵥����������ݱ�׼�����ˮ��
    function GetHhHYWlNjTime(var nData: string): Boolean;
    //��ȡ���鵥���������������ʱ��
    function GetHhHYWlXD(var nData: string): Boolean;
    //��ȡ���鵥�����������ϸ��
    function GetHhHYWlBiBiao(var nData: string): Boolean;
    //��ȡ���鵥����������ݱȱ����
    function GetHhHYWlQD(var nData: string): Boolean;
    //��ȡ���鵥�����������ǿ��
    function GetHhHYHhcDetail(var nData: string): Boolean;
    //��ȡ���鵥��ϲ�
    function GetHhHYHhcRecord(var nData: string): Boolean;
    //��ȡ���鵥��ϲ���ϸ
  public
    constructor Create; override;
    destructor destroy; override;
    //new free
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
    //base function
    class function CallMe(const nCmd: Integer; const nData,nExt: string;
      const nOut: PWorkerBusinessCommand): Boolean;
    //local call
  end;

implementation

//Date: 2012-3-13
//Parm: ���������
//Desc: ��ȡ�������ݿ��������Դ
function TMITDBWorker.DoWork(var nData: string): Boolean;
begin
  Result := False;
  FDBConn := nil;
  FXXChannel := nil;

  with gParamManager.ActiveParam^ do
  try
    FDBConn := gDBConnManager.GetConnection(FDB.FID, FErrNum);
    if not Assigned(FDBConn) then
    begin
      nData := '�������ݿ�ʧ��(DBConn Is Null).';
      Exit;
    end;

    if not FDBConn.FConn.Connected then
      FDBConn.FConn.Connected := True;
    //conn db

    FXXChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(FXXChannel) then
    begin
      nData := '����ERP����ʧ��(Wechat Web Service No Channel).';
      Exit;
    end;

    with FXXChannel^ do
    begin
      if not Assigned(FChannel) then
        FChannel := Coxxykt.Create(FMsg, FHttp);
      FHttp.TargetUrl := gSysParam.FERPSrv;
    end; //config web service channel

    FDataOutNeedUnPack := True;
    GetInOutData(FDataIn, FDataOut);
    FPacker.UnPackIn(nData, FDataIn);

    with FDataIn.FVia do
    begin
      FUser   := gSysParam.FAppFlag;
      FIP     := gSysParam.FLocalIP;
      FMAC    := gSysParam.FLocalMAC;
      FTime   := FWorkTime;
      FKpLong := FWorkTimeInit;
    end;

    {$IFDEF DEBUG}
    WriteLog('Fun: '+FunctionName+' InData:'+ FPacker.PackIn(FDataIn, False));
    {$ENDIF}
    if not VerifyParamIn(nData) then Exit;
    //invalid input parameter

    FPacker.InitData(FDataOut, False, True, False);
    //init exclude base
    FDataOut^ := FDataIn^;

    Result := DoDBWork(nData);
    //execute worker

    if Result then
    begin
      if FDataOutNeedUnPack then
        FPacker.UnPackOut(nData, FDataOut);
      //xxxxx

      Result := DoAfterDBWork(nData, True);
      if not Result then Exit;

      with FDataOut.FVia do
        FKpLong := GetTickCount - FWorkTimeInit;
      if FPackOut then
      begin
        WriteLog('���');
        nData := FPacker.PackOut(FDataOut);
      end;

      {$IFDEF DEBUG}
      WriteLog('Fun: '+FunctionName+' OutData:'+ FPacker.PackOut(FDataOut, False));
      {$ENDIF}
    end else DoAfterDBWork(nData, False);
  finally
    gDBConnManager.ReleaseConnection(FDBConn);
    gChannelManager.ReleaseChannel(FXXChannel);
  end;
end;

//Date: 2012-3-22
//Parm: �������;���
//Desc: ����ҵ��ִ����Ϻ����β����
function TMITDBWorker.DoAfterDBWork(var nData: string; nResult: Boolean): Boolean;
begin
  Result := True;
end;

//Date: 2012-3-18
//Parm: �������
//Desc: ��֤��������Ƿ���Ч
function TMITDBWorker.VerifyParamIn(var nData: string): Boolean;
begin
  Result := True;
end;

//Desc: ��¼nEvent��־
procedure TMITDBWorker.WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TMITDBWorker, FunctionName, nEvent);
end;

//------------------------------------------------------------------------------
class function TBusWorkerBusinessHHJY.FunctionName: string;
begin
  Result := sBus_BusinessHHJY;
end;

constructor TBusWorkerBusinessHHJY.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  FListD := TStringList.Create;
  FListE := TStringList.Create;
  FListF := TStringList.Create;
  FListG := TStringList.Create;
  inherited;
end;

destructor TBusWorkerBusinessHHJY.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  FreeAndNil(FListD);
  FreeAndNil(FListE);
  FreeAndNil(FListF);
  FreeAndNil(FListG);
  inherited;
end;

function TBusWorkerBusinessHHJY.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessHHJY;
  end;
end;

procedure TBusWorkerBusinessHHJY.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2014-09-15
//Parm: ����;����;����;���
//Desc: ���ص���ҵ�����
class function TBusWorkerBusinessHHJY.CallMe(const nCmd: Integer;
  const nData, nExt: string; const nOut: PWorkerBusinessCommand): Boolean;
var nStr: string;
    nIn: TWorkerHHJYData;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPacker := nil;
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessHHJY);
    nPacker.InitData(@nIn, True, False);
    //init

    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessHHJY);
    //get worker

    Result := nWorker.WorkActive(nStr);
    if Result then
         nPacker.UnPackOut(nStr, nOut)
    else nOut.FData := nStr;
  finally
    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2012-3-22
//Parm: ��������
//Desc: ִ��nDataҵ��ָ��
function TBusWorkerBusinessHHJY.DoDBWork(var nData: string): Boolean;
begin
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := 'ҵ��ִ�гɹ�.';
  end;
  FPackOut := True;

//  case FIn.FCommand of
//   cBC_SyncHhSaleDetail        : FPackOut := False;
//  end;

  case FIn.FCommand of
   cBC_SyncHhSaleMateriel      : Result := SyncHhSaleMateriel(nData);
   cBC_SyncHhCustomer          : Result := SyncHhCustomer(nData);
   cBC_SyncHhProvider          : Result := SyncHhProvider(nData);
   cBC_GetHhSalePlan           : Result := SyncHhSalePlan(nData);
   cBC_PoundVerifyHhSalePlan   : Result := PoundVerifyHhSalePlan(nData);
   cBC_BillVerifyHhSalePlan    : Result := BillVerifyHhSalePlan(nData);
   cBC_SyncHhSaleDetail        : Result := SyncHhSaleDetail(nData);
   cBC_IsHhSaleDetailExits     : Result := IsHhSaleDetailExits(nData);
   cBC_GetHhSaleDetailID       : Result := GetHhSaleDetailID(nData);
   cBC_GetHhSaleWareNumber     : Result := GetHhSaleWareNumber(nData);
   cBC_SyncHhSaleWTTruck       : Result := GetHhSaleWTTruck(nData);
   cBC_SyncHhSaleWareNumber    : Result := SyncHhSaleWareNumber(nData);
   cBC_GetHhSaleRealPrice      : Result := GetHhSaleRealPrice(nData);

   cBC_GetHhOrderPlan          : Result := SyncHhOrderPlan(nData);
   cBC_SyncHhOrderPoundData    : Result := SyncHhOrderDetail(nData);
   cBC_IsHhOrderDetailExits    : Result := IsHhOrderDetailExits(nData);
   cBC_GetHhOrderDetailID      : Result := GetHhOrderDetailID(nData);

   cBC_GetHhNeiDaoOrderPlan    : Result := SyncHhNdOrderPlan(nData);
   cBC_SyncHhNdOrderPoundData  : Result := SyncHhNdOrderDetail(nData);
   cBC_IsHhNdOrderDetailExits  : Result := IsHhNdOrderDetailExits(nData);
   cBC_GetHhNdOrderDetailID    : Result := GetHhNdOrderDetailID(nData);

   cBC_SyncHhOtOrderPoundData  : Result := SyncHhOtherOrderDetail(nData);
   cBC_IsHhOtherOrderDetailExits: Result := IsHhOtherOrderDetailExits(nData);
   cBC_GetHhOtherOrderDetailID : Result := GetHhOtherOrderDetailID(nData);

   cBC_NewHhWTDetail           : Result := NewHhWTDetail(nData);

   cBC_SaveHhHyData            : Result := SaveHhHYData(nData);
   cBC_GetHhHyHxDetail         : Result := GetHhHYHxDetail(nData);

   cBC_GetHhHyWlDetail         : Result := GetHhHYWlDetail(nData);
   cBC_GetHhHyWlBZCD           : Result := GetHhHYWlBZCD(nData);
   cBC_GetHhHyWlNjTime         : Result := GetHhHYWlNjTime(nData);
   cBC_GetHhHyWlXD             : Result := GetHhHyWlXD(nData);
   cBC_GetHhHyWlBiBiao         : Result := GetHhHyWlBiBiao(nData);
   cBC_GetHhHyWlQD             : Result := GetHhHyWlQD(nData);

   cBC_GetHhHyHhcDetail        : Result := GetHhHyHhcDetail(nData);
   cBC_GetHhHyHhcRecord        : Result := GetHhHyHhcRecord(nData);
  else
    begin
      Result := False;
      nData := '��Ч��ҵ�����(Code: %d Invalid Command).';
      nData := Format(nData, [FIn.FCommand]);
    end;
  end;
end;

function TBusWorkerBusinessHHJY.SyncHhSaleMateriel(
  var nData: string): boolean;
var nStr,nType: string;
    nInt, nIdx: Integer;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
begin
  Result := False;

  WriteLog('ͬ���������'+nStr);

  nStr := Ixxykt(FXXChannel^.FChannel).Load_Inv('03');

  nStr := UTF8Encode(nStr);
  try
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    if not Assigned(nJS) then
    begin
      nData := 'ͬ�����Ͻӿڵ����쳣.��ʽ�޷�����:' + nStr;
      WriteLog(nData);
      Exit;
    end;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := 'ͬ�����Ͻӿڵ����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    FListB.Clear;
    FListC.Clear;

    if nJS.Field['DATA'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['DATA'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := 'ͬ�����Ͻӿڵ����쳣.' + FIn.FData + 'Data�ڵ�Ϊ��';
        WriteLog(nData);
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        FListA.Clear;
        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListA.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;

        if Pos('��',FListA.Values['cInvName']) > 0 then
          nType := sFlag_Dai
        else
          nType := sFlag_San;

        nStr := SF('D_ParamB', FListA.Values['cInvCode']);
        nStr := MakeSQLByStr([SF('D_Value',
                FListA.Values['cInvName']),
                SF('D_Memo', nType)
                ], sTable_SysDict, nStr, False);
        //xxxxx
        FListB.Add(nStr);

        nStr := MakeSQLByStr([SF('D_Name', 'StockItem'),
                SF('D_ParamB', FListA.Values['cInvCode']),
                SF('D_Value', FListA.Values['cInvName']),
                SF('D_Memo', nType)
                ], sTable_SysDict, '', True);
        //xxxxx
        FListC.Add(nStr);
      end;
    end
    else
    begin
      nData := '�ӿڵ����쳣.Data�ڵ��쳣';
      WriteLog(nData);
      Exit;
    end;

    if FListB.Count > 0 then
    try
      FDBConn.FConn.BeginTrans;

      for nIdx:=0 to FListB.Count - 1 do
      begin
        if gDBConnManager.WorkerExec(FDBConn,FListB[nIdx]) <= 0 then
        begin
          gDBConnManager.WorkerExec(FDBConn, FListC[nIdx]);
        end;
      end;
      FDBConn.FConn.CommitTrans;
    except
      if FDBConn.FConn.InTransaction then
        FDBConn.FConn.RollbackTrans;
      raise;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    if Assigned(nJS) then
      nJS.Free;
  end;
end;

function TBusWorkerBusinessHHJY.SyncHhCustomer(
  var nData: string): boolean;
var nStr: string;
    nInt, nIdx: Integer;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
begin
  Result := False;
  nStr := PackerDecodeStr(FIn.FData);


  try
    WriteLog('ͬ�����ۿͻ����'+nStr);

    nStr := Ixxykt(FXXChannel^.FChannel).Load_Cus(nStr);


    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    if not Assigned(nJS) then
    begin
      nData := 'ͬ���ͻ������ӿڵ����쳣.��ʽ�޷�����:' + nStr;
      WriteLog(nData);
      Exit;
    end;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := 'ͬ�����ۿͻ��ӿڵ����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    FListB.Clear;
    FListC.Clear;

    if nJS.Field['DATA'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['DATA'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := 'ͬ�����ۿͻ��ӿڵ����쳣.' + FIn.FData + 'Data�ڵ�Ϊ��';
        WriteLog(nData);
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        FListA.Clear;
        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListA.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;

        nStr := SF('C_ID', FListA.Values['cCusCode']);
        nStr := MakeSQLByStr([
                SF('C_Name', FListA.Values['cCusName']),
                SF('C_PY', GetPinYinOfStr(FListA.Values['cCusName'])),
                SF('C_Addr', FListA.Values['FAddress']),
                SF('C_Phone', FListA.Values['FOfficeTelCode']),
                SF('C_Tax', FListA.Values['FFaxCode']),
                SF('C_Bank', FListA.Values['FBankNames']),
                SF('C_Memo', FListA.Values['FCustomerCode']),
                SF('C_Account', FListA.Values['FIDcardnumber'])
                ], sTable_Customer, nStr, False);
        FListB.Add(nStr);

        nStr := MakeSQLByStr([SF('C_ID', FListA.Values['cCusCode']),
                SF('C_Name', FListA.Values['cCusName']),
                SF('C_PY', GetPinYinOfStr(FListA.Values['cCusName'])),
                SF('C_Addr', FListA.Values['FAddress']),
                SF('C_Phone', FListA.Values['FOfficeTelCode']),
                SF('C_Tax', FListA.Values['FFaxCode']),
                SF('C_Bank', FListA.Values['FBankNames']),
                SF('C_Account', FListA.Values['FIDcardnumber']),
                SF('C_Memo', FListA.Values['FCustomerCode']),
                SF('C_XuNi', sFlag_No)
                ], sTable_Customer, '', True);
        FListC.Add(nStr);
      end;
    end
    else
    begin
      nData := '�ӿڵ����쳣.Data�ڵ��쳣';
      WriteLog(nData);
      Exit;
    end;

    if FListB.Count > 0 then
    try
      FDBConn.FConn.BeginTrans;

      for nIdx:=0 to FListB.Count - 1 do
      begin
        if gDBConnManager.WorkerExec(FDBConn,FListB[nIdx]) <= 0 then
        begin
          gDBConnManager.WorkerExec(FDBConn, FListC[nIdx]);
        end;
      end;
      FDBConn.FConn.CommitTrans;
    except
      if FDBConn.FConn.InTransaction then
        FDBConn.FConn.RollbackTrans;
      raise;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    if Assigned(nJS) then
      nJS.Free;
  end;
end;

function TBusWorkerBusinessHHJY.SyncHhProvider(
  var nData: string): boolean;
var nStr: string;
    nInt, nIdx: Integer;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
begin
  Result := False;

  nStr := PackerDecodeStr(FIn.FData);

  WriteLog('ͬ����Ӧ�����'+nStr);

  nStr := Ixxykt(FXXChannel^.FChannel).Load_Ven(nStr);
  WriteLog('ͬ����Ӧ�̳���'+nStr);

  nStr := UTF8Encode(nStr);
  try
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    if not Assigned(nJS) then
    begin
      nData := 'ͬ����Ӧ�̽ӿڵ����쳣.��ʽ�޷�����:' + nStr;
      WriteLog(nData);
      Exit;
    end;

    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := 'ͬ����Ӧ�̽ӿڵ����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    FListB.Clear;
    FListC.Clear;

    if nJS.Field['DATA'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['DATA'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := 'ͬ����Ӧ�̽ӿڵ����쳣.' + FIn.FData + 'Data�ڵ�Ϊ��';
        WriteLog(nData);
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        FListA.Clear;
        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListA.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;

        nStr := SF('P_ID', FListA.Values['cVenCode']);
        nStr := MakeSQLByStr([
                SF('P_Name', FListA.Values['cVenName']),
                SF('P_Memo', FListA.Values['FProviderNumber']),
                SF('P_PY', GetPinYinOfStr(FListA.Values['cVenName']))
                ], sTable_Provider, nStr, False);
        FListB.Add(nStr);

        nStr := MakeSQLByStr([SF('P_ID', FListA.Values['cVenCode']),
                SF('P_Name', FListA.Values['cVenName']),
                SF('P_Memo', FListA.Values['FProviderNumber']),
                SF('P_PY', GetPinYinOfStr(FListA.Values['cVenName']))
                ], sTable_Provider, '', True);
        FListC.Add(nStr);
      end;
    end
    else
    begin
      nData := '��Ӧ�̽ӿڵ����쳣.Data�ڵ��쳣';
      WriteLog(nData);
      Exit;
    end;

    if FListB.Count > 0 then
    try
      FDBConn.FConn.BeginTrans;

      for nIdx:=0 to FListB.Count - 1 do
      begin
        if gDBConnManager.WorkerExec(FDBConn,FListB[nIdx]) <= 0 then
        begin
          gDBConnManager.WorkerExec(FDBConn, FListC[nIdx]);
        end;
      end;
      FDBConn.FConn.CommitTrans;
    except
      if FDBConn.FConn.InTransaction then
        FDBConn.FConn.RollbackTrans;
      raise;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    if Assigned(nJS) then
      nJS.Free;
  end;
end;

function TBusWorkerBusinessHHJY.SyncHhSalePlan(
  var nData: string): boolean;
var nStr, nCusID, nCusName, nType, nArea: string;
    nInt, nIdx: Integer;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nMoney, nYf: Double;
    nOut: TWorkerBusinessCommand;
    nOnlYMoney : Boolean;
begin
  Result := False;
  //����ģʽ
  if gSysParam.FERPType = 0 then
  begin
    nData              := IntToStr(1000000);
    Result             := True;
    FOut.FData         := nData;
    FOut.FBase.FResult := True;
    Exit;
  end;

  nCusID := PackerDecodeStr(FIn.FData);
  nOnlYMoney := FIn.FExtParam = sFlag_Yes;
  if Trim(nCusID) = '' then
    Exit;

  nCusName := GetCusName(nCusID);

  try
    WriteLog('��ȡ���۶������'+nCusID+','+nCusName);

    nStr := Ixxykt(FXXChannel^.FChannel).Customer_YE(nCusID);

    WriteLog('��ȡ���۶�������'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    if not Assigned(nJS) then
    begin
      nData := 'ͬ�����۶����ӿڵ����쳣.��ʽ�޷�����:' + nStr;
      WriteLog(nData);
      Exit;
    end;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ���۶����ӿڵ����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if not IsNumber(VarToStr(nJS.Field['Money'].Value), True) then
    begin
      nData := '��ȡ���۶����ӿڵ����쳣.�ͻ����Ƿ�' + VarToStr(nJS.Field['Money'].Value);
      WriteLog(nData);
      Exit;
    end;
    nMoney := StrToFloat(VarToStr(nJS.Field['Money'].Value));

//    if nMoney < 0 then
//      nMoney := 0 - nMoney;

    if nOnlYMoney then
    begin
      nData := VarToStr(nJS.Field['Money'].Value);
      Result := True;
      FOut.FData := nData;
      FOut.FBase.FResult := True;
      Exit;
    end;

    if not IsNumber(VarToStr(nJS.Field['yunfei'].Value), True) then
    begin
      nData := '��ȡ���۶����ӿڵ����쳣.�ͻ��˷ѷǷ�' + VarToStr(nJS.Field['yunfei'].Value);
      WriteLog(nData);
      Exit;
    end;
    nYf := StrToFloat(VarToStr(nJS.Field['yunfei'].Value));

    nArea := VarToStr(nJS.Field['diqu'].Value);

    nStr := 'Update %s Set O_Valid = ''%s'' Where O_CusID=''%s''';
    nStr := Format(nStr, [sTable_SalesOrder, sFlag_No, nCusID]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    if nJS.Field['DATA'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['DATA'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ȡ���۶����ӿڵ����쳣.' + FIn.FData + 'Data�ڵ�Ϊ��';
        WriteLog(nData);
        Exit;
      end;

      FDBConn.FConn.BeginTrans;
      try
        for nIdx := 0 to nJSRow.Count - 1 do
        begin
          nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

          FListA.Clear;
          for nInt := 0 to nJSCol.Count - 1 do
          begin
            FListA.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
          end;

          if Pos('��', FListA.Values['cInvName']) > 0 then
            nType := sFlag_Dai
          else
            nType := sFlag_San;

          nStr := SF('O_CusID', nCusID) + ' and '+SF('O_StockID', FListA.Values['cInvCode']);
          nStr := MakeSQLByStr([
                  SF('O_Factory', FListA.Values['FFactoryName']),
                  SF('O_CusName', nCusName),
                  SF('O_ConsignCusName', FListA.Values['FConsignName']),
                  SF('O_StockName', FListA.Values['cInvName']),
                  SF('O_StockType', nType),
                  SF('O_Lading', '����'),
                  SF('O_CusPY', GetPinYinOfStr(nCusName)),
                  SF('O_PlanAmount', FListA.Values['FPlanAmount']),
                  SF('O_PlanDone', FListA.Values['FBillAmount']),
                  SF('O_PlanRemain', FListA.Values['FRemainAmount']),
                  SF('O_PlanBegin', StrToDateDef(FListA.Values['FBeginDate'],Now),sfDateTime),
                  SF('O_PlanEnd', StrToDateDef(FListA.Values['FEndDate'],Now),sfDateTime),
                  SF('O_Company', FListA.Values['FCompanyName']),
                  SF('O_Depart', FListA.Values['FSaleOrgName']),
                  SF('O_SaleMan', FListA.Values['FSaleManID']),
                  SF('O_Remark', FListA.Values['FRemark']),
                  SF('O_Price', StrToFloatDef(FListA.Values['iInvSCost'],0),sfVal),
                  SF('O_Valid', sFlag_Yes),
                  SF('O_CompanyID', FListA.Values['FCompanyID']),
                  SF('O_CusID', nCusID),
                  SF('O_StockID', FListA.Values['cInvCode']),
                  SF('O_PackingID', FListA.Values['FPackingID']),
                  SF('O_FactoryID', FListA.Values['FFactoryID']),
                  SF('O_Money', nMoney ,sfVal),
                  SF('O_YF', nYf, sfVal),
                  SF('O_SaleArea', nArea),
                  SF('O_Create', StrToDateDef(FListA.Values['FCreateTime'],Now),sfDateTime),
                  SF('O_Modify', StrToDateDef(FListA.Values['FModifyTime'],Now),sfDateTime)
                  ], sTable_SalesOrder, nStr, False);

          if gDBConnManager.WorkerExec(FDBConn,nStr) <= 0 then
          begin
            FListC.Clear;
            FListC.Values['Group'] :=sFlag_BusGroup;
            FListC.Values['Object'] := sFlag_SaleOrderNo;
            //to get serial no

            if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
                  FListC.Text, sFlag_Yes, @nOut) then
              raise Exception.Create(nOut.FData);
            //xxxxx

            nStr := MakeSQLByStr([SF('O_Order', nOut.FData),
                    SF('O_Factory', FListA.Values['FFactoryName']),
                    SF('O_CusName', nCusName),
                    SF('O_ConsignCusName', FListA.Values['FConsignName']),
                    SF('O_StockName', FListA.Values['cInvName']),
                    SF('O_StockType', nType),
                    SF('O_Lading', '����'),
                    SF('O_CusPY', GetPinYinOfStr(nCusName)),
                    SF('O_PlanAmount', FListA.Values['FPlanAmount']),
                    SF('O_PlanDone', FListA.Values['FBillAmount']),
                    SF('O_PlanRemain', FListA.Values['FRemainAmount']),
                    SF('O_PlanBegin', StrToDateDef(FListA.Values['FBeginDate'],Now),sfDateTime),
                    SF('O_PlanEnd', StrToDateDef(FListA.Values['FEndDate'],Now),sfDateTime),
                    SF('O_Company', FListA.Values['FCompanyName']),
                    SF('O_Depart', FListA.Values['FSaleOrgName']),
                    SF('O_SaleMan', FListA.Values['FSaleManID']),
                    SF('O_Remark', FListA.Values['FRemark']),
                    SF('O_Price', StrToFloatDef(FListA.Values['iInvSCost'],0),sfVal),
                    SF('O_Valid', sFlag_Yes),
                    SF('O_CompanyID', FListA.Values['FCompanyID']),
                    SF('O_CusID', nCusID),
                    SF('O_StockID', FListA.Values['cInvCode']),
                    SF('O_PackingID', FListA.Values['FPackingID']),
                    SF('O_FactoryID', FListA.Values['FFactoryID']),
                    SF('O_Money', nMoney ,sfVal),
                    SF('O_YF', nYf, sfVal),
                    SF('O_SaleArea', nArea),
                    SF('O_Create', StrToDateDef(FListA.Values['FCreateTime'],Now),sfDateTime),
                    SF('O_Modify', StrToDateDef(FListA.Values['FModifyTime'],Now),sfDateTime)
                    ], sTable_SalesOrder, '', True);
            gDBConnManager.WorkerExec(FDBConn,nStr)
          end;
        end;

        FDBConn.FConn.CommitTrans;
      except
        if FDBConn.FConn.InTransaction then
          FDBConn.FConn.RollbackTrans;
        raise;
      end;
    end
    else
    begin
      nData := '��ȡ���۶����ӿڵ����쳣.Data�ڵ��쳣';
      WriteLog(nData);
      Exit;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    if Assigned(nJS) then
      nJS.Free;
  end;
end;

function TBusWorkerBusinessHHJY.PoundVerifyHhSalePlan(
  var nData: string): boolean;
var nStr, nUrl: string;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  nUrl := '';

  FListD.Clear;
  FListD.Text := PackerDecodeStr(FIn.FData);

  nStr := 'FBillCode = ''%s''';
  nStr := Format(nStr, [FListD.Values['FConsignPlanNumber']]);

  if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhSalePlan
           ,PackerEncodeStr(nStr),'',@nOut) then
  begin
    nData := '�������[ %s ]��ȡ��ǰ����[ %s ]��Ϣʧ��.';
    nData := Format(nData, [FListD.Values['FBillNumber'],
                             FListD.Values['FConsignPlanNumber']]);
    WriteLog(nData);
    Exit;
  end;
  FListB.Clear;
  FListB.Text := PackerDecodeStr(nOut.FData);

  if FListD.Values['FPriceDate'] = '' then
    FListD.Values['FPriceDate'] := FormatDateTime('YYYY-MM-DD HH:MM:SS', Now);

  FListB.Values['FPriceDate'] := FListD.Values['FPriceDate'];

  WriteLog('�ͻ�����:' + FListB.Values['FCustomerTypeID']);

  if FListB.Values['FCustomerTypeID'] = '1' then
  begin
    if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhSaleRealPrice
             ,PackerEncodeStr(FListB.Text),'',@nOut) then
    begin
      nData := '�������[ %s ]��ȡʵʱ�۸�ʧ��.';
      nData := Format(nData, [FListD.Values['FBillNumber']]);
      WriteLog(nData);
      Exit;
    end;

    FListB.Clear;
    FListB.Text := PackerDecodeStr(nOut.FData);

    nStr := '�������[ %s ]ԭʼ�۸�[ %s ]���¼۸�[ %s ]�����[ %s ]';
    nStr := Format(nStr, [FListD.Values['FBillNumber'],
                          FListD.Values['FGoodsPrice'],
                          FListB.Values['FGoodsPrice'],
                          FListD.Values['FPoundValue']]);

    WriteLog(nStr);
                          
    if not IsNumber(FListB.Values['FGoodsPrice'], True) then
    begin
      nData := '�������[ %s ]ʵʱ�۸�Ƿ�����.';
      nData := Format(nData, [FListD.Values['FBillNumber']]);
      WriteLog(nData);
      Exit;
    end;

    nStr :='update %s set L_Price=%s where L_ID = ''%s'' ';
    nStr := Format(nStr,[sTable_Bill, FListB.Values['FGoodsPrice'],
                                      FListD.Values['FBillNumber']]);

    gDBConnManager.WorkerExec(FDBConn,nStr);

    FListD.Values['FMoney'] := Format('%.2f', [StrToFloat(FListB.Values['FGoodsPrice'])
                                              * StrToFloat(FListD.Values['FPoundValue'])]);
  end;

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;
    nStr := '����У�����۶������:FCustomerID[ %s ],FMoney[ %s ],FBillID[ %s ],FSaleManID[ %s ]';
    nStr := Format(nStr,[FListD.Values['FCustomerID'],FListD.Values['FMoney'],
                         FListD.Values['FBillID'],FListD.Values['FSaleManID']]);
    WriteLog(nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoV_SaleConsignPlanBill.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IV_SaleConsignPlanBill(nHHJYChannel^.FChannel).P_SaleComputCredit(nSoapHeader,
                                   FListD.Values['FCustomerID'],
                                   FListD.Values['FMoney'],
                                   FListD.Values['FBillID'],
                                   FListD.Values['FSaleManID']);

    WriteLog('����У�����۶�������'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '����У�����۶��������쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if Trim(VarToStr(nJS.Field['Data'].Value)) <> '' then
    begin
      nData := '����У�����۶���ʧ��.' + VarToStr(nJS.Field['Data'].Value);
      WriteLog(nData);
      Exit;
    end;

    Result := True;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.BillVerifyHhSalePlan(
  var nData: string): boolean;
var nStr, nUrl: string;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';
  FListA.Text := PackerDecodeStr(FIn.FData);
                           //1003415304
  FListA.Values['Order'] := '1015578701';
  FListA.Values['Value'] := '10';

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    WriteLog('����У�����۶������'+FListA.Text);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoV_SaleValidConsignPlanBill.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IV_SaleValidConsignPlanBill(nHHJYChannel^.FChannel).ValidConsignPlanBill(nSoapHeader,
                                   1003415304,
                                   1);

    WriteLog('����У�����۶�������'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '����У�����۶��������쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['Data'].Value))) <= 0 then
    begin
      nData := '����У�����۶���ʧ��.' + VarToStr(nJS.Field['Data'].Value);
      WriteLog(nData);
      Exit;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.SyncHhSaleDetail(
  var nData: string): boolean;
var nStr,nDateStr,nPack,nType,nDelete: string;
    nInt, nIdx: Integer;
    nJS: TlkJSONobject;
    nDMoney,nYFMoney: Double;
begin
  Result := False;

  FListD.Text := PackerDecodeStr(FIn.FData);

  nDelete := '1';

  nDMoney := 0;
  nYFMoney := 0;

  nStr := 'Select L_Pack,L_Type From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, FListD.Values['ID']]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '������[ %s ]����Ч.';
      nData := Format(nData, [FListD.Values['ID']]);
      Exit;
    end;
    nPack := Fields[0].AsString;
    nType := Fields[1].AsString;
  end;

  if nType = sFlag_Dai then
  begin
    nStr := 'Select D_ParamA From %s Where D_Name=''%s'' and D_Value=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_PackType, nPack]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := Format('��װ����[ %s ]������.', [nPack]);
        Exit;
      end;
      nDMoney := Fields[0].AsFloat;
    end;
  end;

  try
    WriteLog('ͬ����������'+FListD.Text);

    nStr := 'Select L_ID,L_ZhiKa,L_CusID,L_CusName,L_Type,L_StockNo,' +
            'L_StockName,L_Truck,L_Value,L_Price,L_ZKMoney,L_Status,' +
            'L_NextStatus,L_Card,L_IsVIP,L_PValue,L_MValue,L_PrintHY,' +
            'L_HYDan,L_Seal,L_NewID,L_TruckEmpty,L_WebOrderID,L_MDate,' +
            'L_CalYF,L_YunFei,L_Pack,L_OutFact,L_Date,L_LadeLine From $Bill b ';
    //xxxxx

    nStr := nStr + 'Where L_ID=''$CD''';

    nStr := MacroValue(nStr, [MI('$Bill', sTable_Bill), MI('$CD', FListD.Values['ID'])]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if FListD.Values['Status'] = '1' then//������Ϣ
        nDateStr := FieldByName('L_OutFact').AsString
      else
        nDateStr := FieldByName('L_Date').AsString;

      if FieldByName('L_Type').AsString = sFlag_Dai then
      begin
        nDMoney := nDMoney * FieldByName('L_Value').AsFloat;
      end
      else
        nDMoney := 0;

      if FieldByName('L_CalYF').AsString = sFlag_Yes then
      begin
        nYFMoney := FieldByName('L_YunFei').AsFloat * FieldByName('L_Value').AsFloat;
      end;

      if (FieldByName('L_TruckEmpty').AsString = sFlag_Yes) or
         (FListD.Values['Delete'] = sFlag_Yes) then
        nDelete := '0';

      nStr := Ixxykt(FXXChannel^.FChannel).Insert_Sale(nDelete, nDateStr,
              FieldByName('L_CusID').AsString,FieldByName('L_CusName').AsString,
              FieldByName('L_StockNo').AsString,FieldByName('L_StockName').AsString,
              FieldByName('L_LadeLine').AsString,FieldByName('L_Value').AsString,
              FieldByName('L_Pack').AsString,FloatToStr(nDMoney),
              FloatToStr(nYFMoney),FieldByName('L_ID').AsString,
              FieldByName('L_Truck').AsString);

      WriteLog('ͬ�����������'+nStr);

      nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

      if not Assigned(nJS) then
      begin
        nData := '�ϴ����۵��ݽӿڵ����쳣.��ʽ�޷�����:' + nStr;
        WriteLog(nData);
        Exit;
      end;

      nStr := VarToStr(nJS.Field['IsSuccess'].Value);

      if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
      begin
        nData := 'ͬ������������쳣.' + VarToStr(nJS.Field['Message'].Value);
        WriteLog(nData);
        Exit;
      end;

      if FListD.Values['Status'] = '1' then//������Ϣ
      begin
        nStr :='update %s set L_BDAX=''1'',L_BDNUM=L_BDNUM+1 where L_ID = ''%s'' ';
        nStr := Format(nStr,[sTable_Bill,FListD.Values['ID']]);

        gDBConnManager.WorkerExec(FDBConn,nStr);
      end;

      FOut.FData := '';
      FOut.FBase.FResult := True;
      Result := True;
    end;
  finally
    if Assigned(nJS) then
      nJS.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetMoney(const nPrice,
  nValue: string): string;
var nMoney : Double;
begin
  Result := '0';
  try
    nMoney := StrToFloat(nPrice) * StrToFloat(nValue);
    nMoney := Float2PInt(nMoney, cPrecision, False) / cPrecision;
    Result := FloatToStr(nMoney);
  except
  end;
end;

function TBusWorkerBusinessHHJY.GetSaleDetailJSonString(const nLID, nDelete: string;
 var nExits: Boolean; var nInit, nNewStr: string): string;
var nStr, nSQL, nUrl, nDate: string;
    nInt, nIdx: Integer;
    nJSInit, nJSNew: TlkJSONobject;
    nOut: TWorkerBusinessCommand;
begin
  Result := '';
  FListA.Clear;
  FListB.Clear;
  FListC.Clear;

  nExits := TBusWorkerBusinessHHJY.CallMe(cBC_IsHhSaleDetailExits
           ,PackerEncodeStr(nLID),'',@nOut);
  if nExits then
    FListB.Text := PackerDecodeStr(nOut.FData);


  nSQL := 'select * From %s where L_ID = ''%s'' ';

  nSQL := Format(nSQL,[sTable_Bill, nLID]);
  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  begin
    if RecordCount < 1 then
    begin
      Result := '�������[ %s ]������.';
      Result := Format(Result, [nLID]);
      Exit;
    end;

    FListA.Values['FConsignPlanNumber']     := FieldByName('L_Order').AsString;
    FListA.Values['FBillID']                := FieldByName('L_ID').AsString;
    FListA.Values['FBillNumber']            := FieldByName('L_ID').AsString;
    FListA.Values['FOldNumber']             := FieldByName('L_WT').AsString;

    FListA.Values['FGrossSign']             := '0';
    FListA.Values['FTareSign']              := '0';
    FListA.Values['FTare']                  := '0';
    FListA.Values['FGross']                 := '0';

    FListA.Values['FAuditingSign']          := '0';

    FListA.Values['FStatus']                := '1';

    FListA.Values['FGrossPerson']           := FieldByName('L_MMan').AsString;
    FListA.Values['FGrossTime']             := FieldByName('L_MDate').AsString;
    FListA.Values['FGrossName']             := FieldByName('L_MMan').AsString;


    FListA.Values['FTarePerson']            := FieldByName('L_PMan').AsString;
    FListA.Values['FTareTime']              := FieldByName('L_PDate').AsString;
    FListA.Values['FTareName']              := FieldByName('L_PMan').AsString;
    FListA.Values['FPlanAmount']            := FieldByName('L_PreValue').AsString;
    FListA.Values['FSuttle']                := FieldByName('L_Value').AsString;
    FListA.Values['FDeliveryAmount']        := FieldByName('L_Value').AsString;

    FListA.Values['FCreator']               := FieldByName('L_Man').AsString;
    FListA.Values['FCreateTime']            := FieldByName('L_Date').AsString;
    FListA.Values['FTransportNumber']       := FieldByName('L_Truck').AsString;

    try
      nDate := FormatDateTime('DD',FieldByName('L_Date').AsDateTime);
      if StrToIntDef(nDate,0) > 25 then
       nDate := FormatDateTime('YYYY-MM',IncMonth(FieldByName('L_Date').AsDateTime))
      else
       nDate := FormatDateTime('YYYY-MM',FieldByName('L_Date').AsDateTime);
    except
       nDate := FormatDateTime('YYYY-MM',FieldByName('L_Date').AsDateTime);
    end;

    if FieldByName('L_OutFact').AsString <> '' then
    begin
      FListA.Values['FGrossSign']             := '1';
      if FieldByName('L_MValue').AsString <> ''  then
        FListA.Values['FGross']               := FieldByName('L_MValue').AsString;

      FListA.Values['FTareSign']              := '1';
      if FieldByName('L_PValue').AsString <> ''  then
        FListA.Values['FTare']                := FieldByName('L_PValue').AsString;

      FListA.Values['FAuditingSign']          := '1';
      FListA.Values['FAssessor']              := FieldByName('L_MMan').AsString;
      FListA.Values['FAuditingTime']          := FieldByName('L_MDate').AsString;

      FListA.Values['FStatus']                := '2';

      FListA.Values['FDeliveryer']            := FieldByName('L_MMan').AsString;
      FListA.Values['FDeliveryTime']          := FieldByName('L_OutFact').AsString;
      FListA.Values['FKeepDate']              := FormatDateTime('YYYY-MM-DD',
                                               FieldByName('L_OutFact').AsDateTime);
      FListA.Values['FGoodsPrice']            := FieldByName('L_Price').AsString;

      try
        nDate := FormatDateTime('DD',FieldByName('L_OutFact').AsDateTime);
        if StrToIntDef(nDate,0) > 25 then
         nDate := FormatDateTime('YYYY-MM',IncMonth(FieldByName('L_OutFact').AsDateTime))
        else
         nDate := FormatDateTime('YYYY-MM',FieldByName('L_OutFact').AsDateTime);
      except
         nDate := FormatDateTime('YYYY-MM',FieldByName('L_OutFact').AsDateTime);
      end;
    end;

    {$IFDEF BatchInHYOfBill}
    FListA.Values['FWareNumber']            := FieldByName('L_HYDan').AsString;
    {$ELSE}
    FListA.Values['FWareNumber']            := FieldByName('L_Seal').AsString;
    {$ENDIF}
    FListA.Values['FType']                  := FieldByName('L_Type').AsString;

    FListA.Values['FYearPeriod']            := nDate;

    if FieldByName('L_Type').AsString = sFlag_Dai then
      FListA.Values['FBagAmount']           := IntToStr(Round(
                                            FieldByName('L_Value').AsFloat * 200))
    else
      FListA.Values['FBagAmount']           := '0';

    if nDelete = sFlag_Yes then
    begin
      FListA.Values['FIsdelete']            := '1';
      FListA.Values['FDeleteName']          := FieldByName('L_MMan').AsString;
      FListA.Values['FDeleteTime']          := FieldByName('L_MDate').AsString;
    end
    else
      FListA.Values['FIsdelete']            := '0';

    FListA.Values['FDataSign']              := '0';
    FListA.Values['FGoodsSign']             := '0';
    FListA.Values['FCFreightSign']          := '0';
    FListA.Values['FTFreightSign']          := '0';
    FListA.Values['FBackSign']              := '0';
    FListA.Values['FBangChSign']            := '0';
    FListA.Values['FScheduleVanID']         := FieldByName('L_WT').AsString;
    FListA.Values['FRemainder']             := '0.0000';
    FListA.Values['FGroupNO']               := '0';
    FListA.Values['FFactGross']             := FieldByName('L_MValue').AsString;
    FListA.Values['FDepotID']               := '-1';
    FListA.Values['FIsReSave']              := '0';
    FListA.Values['FChangeBalanceSign']     := '0';

    FListA.Values['FMidWaySign']            := '0';
    FListA.Values['FUnloadSign']            := '0';
  end;

  if FListA.Values['FConsignPlanNumber'] = '' then
  begin
    Result := '�������[ %s ]��ǰ������Ϊ��.';
    Result := Format(Result, [nLID]);
    Exit;
  end;

  nSQL := 'FBillCode = ''%s''';
  nSQL := Format(nSQL, [FListA.Values['FConsignPlanNumber']]);

  if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhSalePlan
           ,PackerEncodeStr(nSQL),'',@nOut) then
  begin
    Result := '�������[ %s ]��ȡ��ǰ����[ %s ]��Ϣʧ��.';
    Result := Format(Result, [nLID, FListA.Values['FConsignPlanNumber']]);
    Exit;
  end;

  FListC.Text := PackerDecodeStr(nOut.FData);

  if FListA.Values['FKeepDate'] <> '' then//�ѳ���
  begin
    if FListC.Values['FCustomerTypeID'] = '1' then
    begin
      if FListA.Values['FGoodsPrice'] = '' then
      begin
        Result := '�������[ %s ]���¼۸�[ %s ]�쳣.';
        Result := Format(Result, [nLID, FListA.Values['FGoodsPrice']]);
        Exit;
      end;
      FListC.Values['FGoodsPrice'] := FListA.Values['FGoodsPrice'];
    end;
  end;

  try
    if nExits then//���ϴ�
    begin
      nJSInit := TlkJSONobject.Create();

      with nJSInit do//ԭʼ����
      begin
        Add('FBillID', FListB.Values['FBillID']);//�����ID
        Add('FBillNumber', FListA.Values['FBillID']);//�������
        Add('FBillTypeID', '3');
        Add('FAccountCompID', FListB.Values['FAccountCompID']);
        Add('FCompanyID', FListB.Values['FCompanyID']);

        Add('FFactoryID', FListB.Values['FFactoryID']);
        Add('FShopID', FListB.Values['FShopID']);
        Add('FDepartmentID', FListB.Values['FDepartmentID']);
        Add('FSaleManID', FListB.Values['FSaleManID']);
        Add('FCustomerID', FListB.Values['FCustomerID']);

        Add('FConsignCustomerID', FListB.Values['FConsignCustomerID']);
        Add('FConsignName', FListB.Values['FConsignName']);
        Add('FConsignPlanID', FListB.Values['FConsignPlanID']);
        Add('FContractDetailID', FListB.Values['FContractDetailID']);
        Add('FTContractDetailID', FListB.Values['FTContractDetailID']);

        Add('FCurrencyID', '1');
        Add('FConsignPlanNumber', FListB.Values['FConsignPlanNumber']);
        Add('FMainUnit', '');
        Add('FAuxiliaryUnit', '');
        Add('FCoefficient', '');

        Add('FMaterielID', FListB.Values['FMaterielID']);
        Add('FTransportID', FListB.Values['FTransportID']);
        Add('FPriceModeID', FListB.Values['FPriceModeID']);
        Add('FInvoiceModeID', FListB.Values['FInvoiceModeID']);
        Add('FPackingID', FListB.Values['FPackingID']);

        Add('FDeliveryID', FListB.Values['FDeliveryID']);
        Add('FCarrierID', FListB.Values['FCarrierID']);
        Add('FTAreaID', FListB.Values['FTAreaID']);
        Add('FAddressID', FListB.Values['FAddressID']);
        Add('FDeliveryAddress', FListB.Values['FDeliveryAddress']);

        Add('FTransportNumber', FListB.Values['FTransportNumber']);
        Add('FPlanAmount', FListB.Values['FPlanAmount']);
        Add('FGross', FListB.Values['FGross']);
        Add('FTare', FListB.Values['FTare']);
        Add('FSuttle', FListB.Values['FSuttle']);

        Add('FDeliveryAmount', FListB.Values['FDeliveryAmount']);
        Add('FBagAmount', FListB.Values['FBagAmount']);
        Add('FCFreightAmount', '');
        Add('FWareNumber', FListB.Values['FWareNumber']);
        Add('FLoadingSiteID', FListB.Values['FLoadingSiteID']);

        Add('FYearPeriod', FListB.Values['FYearPeriod']);
        Add('FCreateTime', FListB.Values['FCreateTime']);
        Add('FCreator', FListB.Values['FCreator']);

        Add('FGoodsPrice', FListB.Values['FGoodsPrice']);
        Add('FCGoodsprice', FListB.Values['FCGoodsprice']);
        Add('FCFreightPrice', FListB.Values['FCFreightPrice']);
        Add('FTFreightPrice', FListB.Values['FTFreightPrice']);
        Add('FMidWayPrice', FListB.Values['FMidWayPrice']);
        Add('FUnloadPrice', FListB.Values['FUnloadPrice']);

        Add('FGoodsMoney', FListB.Values['FGoodsMoney']);
        Add('FCFreightMoney', FListB.Values['FCFreightMoney']);
        Add('FTFreightMoney', FListB.Values['FTFreightMoney']);
        Add('FMidWayMoney', FListB.Values['FMidWayMoney']);
        Add('FUnloadMoney', FListB.Values['FUnloadMoney']);

        Add('FTareSign', FListB.Values['FTareSign']);
        Add('FTarePerson', FListB.Values['FTarePerson']);
        Add('FTareTime', FListB.Values['FTareTime']);
        Add('FTareName', FListB.Values['FTareName']);
        Add('FGrossSign', FListB.Values['FGrossSign']);
        Add('FGrossPerson', FListB.Values['FGrossPerson']);
        Add('FGrossTime', FListB.Values['FGrossTime']);
        Add('FGrossName', FListB.Values['FGrossName']);
        Add('FDeliveryer', FListB.Values['FDeliveryer']);
        Add('FDeliveryTime', FListB.Values['FDeliveryTime']);
        Add('FAuditingSign', FListB.Values['FAuditingSign']);

        Add('FAssessor', FListB.Values['FAssessor']);
        Add('FAuditingTime', FListB.Values['FAuditingTime']);
        Add('FDataSign', FListB.Values['FDataSign']);
        Add('FStatus', FListB.Values['FStatus']);
        Add('FIsdelete', FListB.Values['FIsdelete']);

        Add('FGoodsSign', FListB.Values['FGoodsSign']);
        Add('FCFreightSign', FListB.Values['FCFreightSign']);
        Add('FTFreightSign', FListB.Values['FTFreightSign']);
        Add('FMidWaySign', FListB.Values['FMidWaySign']);
        Add('FUnloadSign', FListB.Values['FUnloadSign']);

        Add('FUnloadDate', '');
        Add('FBackSign', '0');
        Add('FBackPerson', '');
        Add('FBackTime', '');
        Add('FBangChSign', '0');

        Add('FScheduleVanID', FListB.Values['FScheduleVanID']);
        Add('FRemark', FListB.Values['FRemark']);
        Add('FRemainder', '0');
        Add('FGroupNO', '0');
        Add('FFactGross', FListB.Values['FFactGross']);

        Add('FDeleteName', FListB.Values['FDeleteName']);
        Add('FDeleteTime', FListB.Values['FDeleteTime']);
        Add('FKeepDate', FListB.Values['FKeepDate']);
        Add('FDepotID', '-1');
        Add('FConsignDepositBillID', '1');

        Add('FConsignDepositNumber', '');
        Add('FMaterielChangeID', '-1');
        Add('FIsReSave', '0');
        Add('FOldNumber', '');
        Add('FMender', FListB.Values['FMender']);

        Add('FModifyTime', FListB.Values['FModifyTime']);
        Add('FChangeBalanceSign', '0');
        Add('FDescription', '');
        Add('FIshedge', '0');
        Add('FOrigBillID', '-1');

        Add('FOrigBillNumber', '');
        Add('FSplitSign', '-1');
        Add('FCloseSign', '0');
        Add('FVer', FListB.Values['FVer']);
      end;

      nInit := TlkJSON.GenerateText(nJSInit);
      nInit := UTF8Decode(nInit);
      WriteLog('������ϴ�ԭʼ����:' + nInit);

      nJSNew := TlkJSONobject.Create();

      with nJSNew do
      begin
        Add('FBillID', FListB.Values['FBillID']);//�����ID
        Add('FBillNumber', FListA.Values['FBillID']);//�������
        Add('FBillTypeID', '3');
        Add('FAccountCompID', FListC.Values['FAccountCompID']);
        Add('FCompanyID', FListC.Values['FCompanyID']);

        Add('FFactoryID', FListC.Values['FFactoryID']);
        Add('FShopID', FListC.Values['FFactoryID']);
        Add('FDepartmentID', FListC.Values['FDepartmentID']);
        Add('FSaleManID', FListC.Values['FSaleManID']);
        Add('FCustomerID', FListC.Values['FCustomerID']);

        Add('FConsignCustomerID', FListC.Values['FConsignCustomerID']);
        Add('FConsignName', FListC.Values['FConsignName']);
        Add('FConsignPlanID', FListC.Values['FBillID']);
        Add('FContractDetailID', FListC.Values['FContractDetailID']);
        Add('FTContractDetailID', FListC.Values['FTContractDetailID']);

        Add('FCurrencyID', '1');
        Add('FConsignPlanNumber', FListC.Values['FBillCode']);
        Add('FMainUnit', '');
        Add('FAuxiliaryUnit', '');
        Add('FCoefficient', '');

        Add('FMaterielID', FListC.Values['FMaterielID']);
        Add('FTransportID', FListC.Values['FTransportID']);
        Add('FPriceModeID', FListC.Values['FPriceModeID']);
        Add('FInvoiceModeID', FListC.Values['FInvoiceModeID']);
        Add('FPackingID', FListC.Values['FPackingID']);

        Add('FDeliveryID', FListC.Values['FDeliveryID']);
        Add('FCarrierID', FListC.Values['FCarrierID']);
        Add('FTAreaID', FListC.Values['FTransportAreaID']);
        Add('FAddressID', FListC.Values['FAdressID']);
        Add('FDeliveryAddress', FListC.Values['FDeliveryAddress']);

        Add('FTransportNumber', FListA.Values['FTransportNumber']);
        Add('FPlanAmount', FListA.Values['FPlanAmount']);
        Add('FGross', FListA.Values['FGross']);
        Add('FTare', FListA.Values['FTare']);
        Add('FSuttle', FListA.Values['FSuttle']);

        Add('FDeliveryAmount', FListA.Values['FDeliveryAmount']);
        Add('FBagAmount', FListA.Values['FBagAmount']);
        Add('FCFreightAmount', '');
        Add('FWareNumber', FListA.Values['FWareNumber']);
        Add('FLoadingSiteID', FListC.Values['FLoadingSiteID']);

        Add('FYearPeriod', FListA.Values['FYearPeriod']);
        Add('FCreateTime', FListA.Values['FCreateTime']);
        Add('FCreator', FListA.Values['FCreator']);

        Add('FGoodsPrice', FListC.Values['FGoodsPrice']);
        Add('FCGoodsprice', FListC.Values['FCGoodsprice']);
        Add('FCFreightPrice', FListC.Values['FCFreightPrice']);
        Add('FTFreightPrice', FListC.Values['FTFreightPrice']);
        Add('FMidWayPrice', FListC.Values['FMidWayPrice']);
        Add('FUnloadPrice', FListC.Values['FUnloadPrice']);

        Add('FGoodsMoney', GetMoney(FListC.Values['FGoodsPrice'],
                                    FListA.Values['FSuttle']));
        Add('FCFreightMoney', GetMoney(FListC.Values['FCFreightPrice'],
                                    FListA.Values['FSuttle']));
        Add('FTFreightMoney', GetMoney(FListC.Values['FTFreightPrice'],
                                    FListA.Values['FSuttle']));
        Add('FMidWayMoney', GetMoney(FListC.Values['FMidWayPrice'],
                                    FListA.Values['FSuttle']));
        Add('FUnloadMoney', GetMoney(FListC.Values['FUnloadPrice'],
                                    FListA.Values['FSuttle']));

        Add('FTareSign', FListA.Values['FTareSign']);
        Add('FTarePerson', FListA.Values['FTarePerson']);
        Add('FTareTime', FListA.Values['FTareTime']);
        Add('FTareName', FListA.Values['FTareName']);
        Add('FGrossSign', FListA.Values['FGrossSign']);
        Add('FGrossPerson', FListA.Values['FGrossPerson']);
        Add('FGrossTime', FListA.Values['FGrossTime']);
        Add('FGrossName', FListA.Values['FGrossName']);
        Add('FDeliveryer', FListA.Values['FDeliveryer']);
        Add('FDeliveryTime', FListA.Values['FDeliveryTime']);
        Add('FAuditingSign', FListA.Values['FAuditingSign']);

        Add('FAssessor', FListA.Values['FAssessor']);
        Add('FAuditingTime', FListA.Values['FAuditingTime']);
        Add('FDataSign', FListB.Values['FDataSign']);
        Add('FStatus', FListA.Values['FStatus']);
        Add('FIsdelete', FListA.Values['FIsdelete']);

        Add('FGoodsSign', FListB.Values['FGoodsSign']);
        Add('FCFreightSign', FListB.Values['FCFreightSign']);
        Add('FTFreightSign', FListB.Values['FTFreightSign']);
        Add('FMidWaySign', FListB.Values['FMidWaySign']);
        Add('FUnloadSign', FListB.Values['FUnloadSign']);

        Add('FUnloadDate', '');
        Add('FBackSign', '0');
        Add('FBackPerson', '');
        Add('FBackTime', '');
        Add('FBangChSign', '0');

        Add('FScheduleVanID', FListA.Values['FOldNumber']);
        Add('FRemark', FListC.Values['FRemark']);
        Add('FRemainder', '0');
        Add('FGroupNO', '0');
        Add('FFactGross', FListA.Values['FFactGross']);

        Add('FDeleteName', FListB.Values['FDeleteName']);
        Add('FDeleteTime', FListB.Values['FDeleteTime']);
        Add('FKeepDate', FListA.Values['FKeepDate']);
        Add('FDepotID', '-1');
        Add('FConsignDepositBillID', '1');

        Add('FConsignDepositNumber', '');
        Add('FMaterielChangeID', '-1');
        Add('FIsReSave', '0');
        Add('FOldNumber', '');
        Add('FMender', FListA.Values['FCreator']);

        Add('FModifyTime', FListA.Values['FCreateTime']);
        Add('FChangeBalanceSign', '0');
        Add('FDescription', '');
        Add('FIshedge', '0');
        Add('FOrigBillID', '-1');

        Add('FOrigBillNumber', '');
        Add('FSplitSign', '-1');
        Add('FCloseSign', '0');
        Add('FVer', FListC.Values['FVer']);
      end;
      nNewStr := TlkJSON.GenerateText(nJSNew);
      nNewStr := UTF8Decode(nNewStr);
      WriteLog('������ϴ���ǰ����:' + nNewStr);
    end
    else
    begin
      if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhSaleDetailID,
           '','',@nOut) then
      begin
        Result := '[' + nLID + ']��ȡ���������IDʧ��.';
        Exit;
      end;

      nStr := PackerDecodeStr(nOut.FData);
      nJSNew := TlkJSONobject.Create();

      with nJSNew do
      begin
        Add('FBillID', nStr);//�����ID
        Add('FBillNumber', FListA.Values['FBillID']);//�������
        Add('FBillTypeID', '3');
        Add('FAccountCompID', FListC.Values['FAccountCompID']);
        Add('FCompanyID', FListC.Values['FCompanyID']);

        Add('FFactoryID', FListC.Values['FFactoryID']);
        Add('FShopID', FListC.Values['FFactoryID']);
        Add('FDepartmentID', FListC.Values['FDepartmentID']);
        Add('FSaleManID', FListC.Values['FSaleManID']);
        Add('FCustomerID', FListC.Values['FCustomerID']);

        Add('FConsignCustomerID', FListC.Values['FConsignCustomerID']);
        Add('FConsignName', FListC.Values['FConsignName']);
        Add('FConsignPlanID', FListC.Values['FBillID']);
        Add('FContractDetailID', FListC.Values['FContractDetailID']);
        Add('FTContractDetailID', FListC.Values['FTContractDetailID']);

        Add('FCurrencyID', '1');
        Add('FConsignPlanNumber', FListC.Values['FBillCode']);
        Add('FMainUnit', '');
        Add('FAuxiliaryUnit', '');
        Add('FCoefficient', '');

        Add('FMaterielID', FListC.Values['FMaterielID']);
        Add('FTransportID', FListC.Values['FTransportID']);
        Add('FPriceModeID', FListC.Values['FPriceModeID']);
        Add('FInvoiceModeID', FListC.Values['FInvoiceModeID']);
        Add('FPackingID', FListC.Values['FPackingID']);

        Add('FDeliveryID', FListC.Values['FDeliveryID']);
        Add('FCarrierID', FListC.Values['FCarrierID']);
        Add('FTAreaID', FListC.Values['FTransportAreaID']);
        Add('FAddressID', FListC.Values['FAdressID']);
        Add('FDeliveryAddress', FListC.Values['FDeliveryAddress']);

        Add('FTransportNumber', FListA.Values['FTransportNumber']);
        Add('FPlanAmount', FListA.Values['FPlanAmount']);
        Add('FGross', FListA.Values['FGross']);
        Add('FTare', FListA.Values['FTare']);
        Add('FSuttle', FListA.Values['FSuttle']);

        Add('FDeliveryAmount', FListA.Values['FDeliveryAmount']);
        Add('FBagAmount', FListA.Values['FBagAmount']);
        Add('FCFreightAmount', '');
        Add('FWareNumber', FListA.Values['FWareNumber']);
        Add('FLoadingSiteID', FListC.Values['FLoadingSiteID']);

        Add('FYearPeriod', FListA.Values['FYearPeriod']);
        Add('FCreateTime', FListA.Values['FCreateTime']);
        Add('FCreator', FListA.Values['FCreator']);

        Add('FGoodsPrice', FListC.Values['FGoodsPrice']);
        Add('FCGoodsprice', FListC.Values['FCGoodsprice']);
        Add('FCFreightPrice', FListC.Values['FCFreightPrice']);
        Add('FTFreightPrice', FListC.Values['FTFreightPrice']);
        Add('FMidWayPrice', FListC.Values['FMidWayPrice']);
        Add('FUnloadPrice', FListC.Values['FUnloadPrice']);

        Add('FGoodsMoney', GetMoney(FListC.Values['FGoodsPrice'],
                                    FListA.Values['FSuttle']));
        Add('FCFreightMoney', GetMoney(FListC.Values['FCFreightPrice'],
                                    FListA.Values['FSuttle']));
        Add('FTFreightMoney', GetMoney(FListC.Values['FTFreightPrice'],
                                    FListA.Values['FSuttle']));
        Add('FMidWayMoney', GetMoney(FListC.Values['FMidWayPrice'],
                                    FListA.Values['FSuttle']));
        Add('FUnloadMoney', GetMoney(FListC.Values['FUnloadPrice'],
                                    FListA.Values['FSuttle']));

        Add('FTareSign', FListA.Values['FTareSign']);
        Add('FTarePerson', FListA.Values['FTarePerson']);
        Add('FTareTime', FListA.Values['FTareTime']);
        Add('FTareName', FListA.Values['FTareName']);
        Add('FGrossSign', FListA.Values['FGrossSign']);
        Add('FGrossPerson', FListA.Values['FGrossPerson']);
        Add('FGrossTime', FListA.Values['FGrossTime']);
        Add('FGrossName', FListA.Values['FGrossName']);
        Add('FDeliveryer', FListA.Values['FDeliveryer']);
        Add('FDeliveryTime', FListA.Values['FDeliveryTime']);
        Add('FAuditingSign', '0');

        Add('FAssessor', FListA.Values['FAssessor']);
        Add('FAuditingTime', FListA.Values['FAuditingTime']);
        Add('FDataSign', FListA.Values['FDataSign']);
        Add('FStatus', FListA.Values['FStatus']);
        Add('FIsdelete', FListA.Values['FIsdelete']);

        Add('FGoodsSign', FListA.Values['FGoodsSign']);
        Add('FCFreightSign', FListA.Values['FCFreightSign']);
        Add('FTFreightSign', FListA.Values['FTFreightSign']);
        Add('FMidWaySign', FListA.Values['FMidWaySign']);
        Add('FUnloadSign', FListA.Values['FUnloadSign']);

        Add('FUnloadDate', '');
        Add('FBackSign', '0');
        Add('FBackPerson', '');
        Add('FBackTime', '');
        Add('FBangChSign', '0');

        Add('FScheduleVanID', FListA.Values['FOldNumber']);
        Add('FRemark', FListC.Values['FRemark']);
        Add('FRemainder', '0');
        Add('FGroupNO', '0');
        Add('FFactGross', FListA.Values['FFactGross']);

        Add('FDeleteName', FListA.Values['FDeleteName']);
        Add('FDeleteTime', FListA.Values['FDeleteTime']);
        Add('FKeepDate', FListA.Values['FKeepDate']);
        Add('FDepotID', '-1');
        Add('FConsignDepositBillID', '1');

        Add('FConsignDepositNumber', '');
        Add('FMaterielChangeID', '-1');
        Add('FIsReSave', '0');
        Add('FOldNumber', '');
        Add('FMender', FListA.Values['FCreator']);

        Add('FModifyTime', FListA.Values['FCreateTime']);
        Add('FChangeBalanceSign', '0');
        Add('FDescription', '');
        Add('FIshedge', '0');
        Add('FOrigBillID', '-1');

        Add('FOrigBillNumber', '');
        Add('FSplitSign', '-1');
        Add('FCloseSign', '0');
        Add('FVer', FListC.Values['FVer']);
      end;
      nNewStr := TlkJSON.GenerateText(nJSNew);
      nNewStr := UTF8Decode(nNewStr);
      WriteLog('������ϴ���ǰ����:' + nNewStr);
    end;
    finally
    if Assigned(nJSInit) then
      nJSInit.Free;
    if Assigned(nJSNew) then
      nJSNew.Free;
  end;
end;

function TBusWorkerBusinessHHJY.IsHhSaleDetailExits(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nNode, nRoot: TXmlNode;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';
  FListA.Clear;
  nStr := 'FBillNumber = ''%s''';
  nStr := Format(nStr,[PackerDecodeStr(FIn.FData)]);

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    WriteLog('��ѯ���ϴ���������'+nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoT_SaleConsignBill.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IT_SaleConsignBill(nHHJYChannel^.FChannel).RetrieveList(nSoapHeader,
                                   nStr, '');

    WriteLog('��ѯ���ϴ����������'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ѯ���ϴ�����������쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ѯ���ϴ�����������쳣.Data�ڵ�Ϊ��';
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListA.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListA.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;
      end;
    end;
    nData := PackerEncodeStr(FListA.Text);

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetHhSaleDetailID(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';
  FListE.Clear;

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    WriteLog('��ȡ���������ID���'+nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoT_SaleConsignBill.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IT_SaleConsignBill(nHHJYChannel^.FChannel).InitializationModel(nSoapHeader);

    WriteLog('��ȡ���������ID����'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ���������ID�����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    nJsCol := nJS.Field['Data'] as TlkJSONobject;

    nStr := VarToStr(nJSCol.Field['FBillID'].Value);

    if nStr = '' then
    begin
      nData := '��ȡ���������ID�ӿڵ����쳣.Data�ڵ�FBillIDΪ��';
      Exit;
    end;

    nData := PackerEncodeStr(nStr);

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;


function TBusWorkerBusinessHHJY.GetHhSaleWareNumber(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nNode, nRoot: TXmlNode;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';
  FListA.Text := PackerDecodeStr(FIn.FData);
//  FlistA.Values['FactoryID'] := '100000104';
//  FlistA.Values['PackingID'] := '1';
//  FlistA.Values['StockID'] := '11';

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    WriteLog('��ȡ���κ����'+FListA.Text);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoV_QControlWareNumberNoticeBill.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IV_QControlWareNumberNoticeBill(nHHJYChannel^.FChannel).GetWareNumberNoticeBill(nSoapHeader,
                                   FlistA.Values['FactoryID'],
                                   FlistA.Values['StockID'],
                                   FlistA.Values['PackingID']);

    WriteLog('��ȡ���κų���'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ���κŵ����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ȡ���κŵ����쳣.Data�ڵ�Ϊ��';
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListA.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListA.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;
      end;
    end;
    nData := PackerEncodeStr(FListA.Text);

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetHhSaleWTTruck(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nNode, nRoot: TXmlNode;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';
  FListA.Text := PackerDecodeStr(FIn.FData);
//  FlistA.Values['FactoryID'] := '100000104';
//  FlistA.Values['PackingID'] := '1';
//  FlistA.Values['StockID'] := '11';

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    WriteLog('��ȡί�е����'+FListA.Text);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoT_SaleTransportForCustomer.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IT_SaleTransportForCustomer(nHHJYChannel^.FChannel).GetTransportListForCustomer(nSoapHeader,
                                   FlistA.Values['CusID'],
                                   FlistA.Values['SaleManID'],
                                   FlistA.Values['StockID'],
                                   FlistA.Values['PackingID']);

    WriteLog('��ȡί�е�����'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡί�е������쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ȡί�е������쳣.Data�ڵ�Ϊ��';
        Exit;
      end;
      FListB.Clear;
      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListA.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListA.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;
        FListB.Add(PackerEncodeStr(FListA.Text));
      end;
    end;
    nData := PackerEncodeStr(FListB.Text);

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.SyncHhSaleWareNumber(
  var nData: string): boolean;
var nStr, nUrl: string;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';
  FListA.Text := PackerDecodeStr(FIn.FData);

  WriteLog('ͬ����������κ����:' + FListA.Text);

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoV_QControlWareNumberNoticeBill.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel

    nStr := IV_QControlWareNumberNoticeBill(nHHJYChannel^.FChannel).P_SaleUpdateQControlWareNumber(nSoapHeader,
                                   FlistA.Values['FFactoryID'],
                                   FlistA.Values['FMaterielID'],
                                   FlistA.Values['FPackingID'],
                                   FlistA.Values['FWareNumber'],
                                   FlistA.Values['FConsignBillID']);


    WriteLog('ͬ����������κų���'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := 'ͬ����������κŵ����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := 'ͬ����������κŵ����쳣.Data�ڵ�Ϊ��';
        Exit;
      end;
      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListA.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListA.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;
      end;

      nStr := FlistA.Values['FResult'];

      if Length(nStr) > 0 then
      begin
        nData := 'ͬ����������κ�ʧ��,���ؽ��:[' + nStr + ']' + ',ˮ����δ�ҵ�����ע��';
        Exit;
      end;

      Result := True;
      FOut.FData := '';
      FOut.FBase.FResult := True;
    end;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetHhSaleRealPrice(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nNode, nRoot: TXmlNode;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';

  FListE.Clear;
  FListE.Text := PackerDecodeStr(FIn.FData);

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    nStr := '��ȡ�������¼۸����:FContractDetailID[ %s ],' +
            'FTContractDetailID[ %s ],FLoadingSiteID[ %s ]dateTime[ %s ]';
    nStr := Format(nStr,[FListE.Values['FContractDetailID'],
                         FListE.Values['FTContractDetailID'],
                         FListE.Values['FLoadingSiteID'],
                         FListE.Values['FPriceDate']]);
    WriteLog(nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoV_SaleConsignPlanBill.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IV_SaleConsignPlanBill(nHHJYChannel^.FChannel).F_Sale_GetPriceForConsignBill(nSoapHeader,
                                   FlistE.Values['FContractDetailID'],
                                   FlistE.Values['FTContractDetailID'],
                                   FlistE.Values['FLoadingSiteID'],
                                   FListE.Values['FPriceDate']);

    WriteLog('��ȡ�������¼۸����'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ�������¼۸�����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ȡ�������¼۸�����쳣.Data�ڵ�Ϊ��';
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListE.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListE.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;
      end;
    end;

    nData := PackerEncodeStr(FListE.Text);

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.SyncHhOrderPlan(
  var nData: string): boolean;
var nStr: string;
    nInt, nIdx: Integer;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nValue: Double;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  nStr := PackerDecodeStr(FIn.FData);

  FListD.Clear;

  FListD.Text := nStr;

  //����ģʽ
  if gSysParam.FERPType = 0 then
  begin
    FListA.Clear;
    FListC.Clear;
    
    nStr := ' Select * From $Pound pl ';
    nStr := nStr + ' Where L_ProID = ''$CD''';

    nStr := MacroValue(nStr, [MI('$Pound', sTable_OrderLocal), MI('$CD', FListD.Values['ProviderNo'])]);

    WriteLog('�ɹ�������ѯSQL:' + nStr);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      First;
      while not Eof do
      begin
        FListB.Clear;
        with FListB do
        begin
          Values['Order']         := FieldByName('L_Order').AsString;
          Values['ProName']       := FListD.Values['ProviderName'];
          Values['ProID']         := FListD.Values['ProviderNo'];
          Values['StockName']     := FieldByName('L_StockName').AsString;
          Values['StockID']       := FieldByName('L_StockID').AsString;
          Values['StockNo']       := FieldByName('L_StockNo').AsString;

          Values['Value']         := '10000';//ʣ����

          FListA.Add(PackerEncodeStr(FListB.Text));
        end;
        Next;
      end;
      nData := PackerEncodeStr(FListA.Text);
    end;
    
    Result             := True;
    FOut.FData         := nData;
    FOut.FBase.FResult := True;
    Exit;
  end;

  try
    WriteLog('��ȡ��ͨԭ���϶������'+nStr);

    nStr := Ixxykt(FXXChannel^.FChannel).VenInv(FListD.Values['ProviderNo']);

    WriteLog('��ȡ��ͨԭ���϶�������'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    if not Assigned(nJS) then
    begin
      nData := 'ͬ�����۶����ӿڵ����쳣.��ʽ�޷�����:' + nStr;
      WriteLog(nData);
      Exit;
    end;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ��ͨԭ���϶����ӿڵ����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['DATA'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['DATA'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ȡ��ͨԭ���϶����ӿڵ����쳣.' + FIn.FData + 'Data�ڵ�Ϊ��';
        WriteLog(nData);
        Exit;
      end;

    FListA.Clear;
    FListC.Clear;
    FListE.Clear;
    FListF.Clear;
    FListG.Clear;

    FDBConn.FConn.BeginTrans;
    try
      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        FListB.Clear;
        FListC.Clear;
        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListC.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;

        with FListB do
        begin
          Values['Order']         := FListC.Values['Order'];
          Values['ProName']       := FListD.Values['ProviderName'];
          Values['ProID']         := FListD.Values['ProviderNo'];
          Values['StockName']     := FListC.Values['cInvName'];
          Values['StockID']       := FListC.Values['cInvCode'];
          Values['StockNo']       := FListC.Values['cInvCode'];

          Values['Value']         := '10000';//ʣ����

          FListA.Add(PackerEncodeStr(FListB.Text));
        end;
        //�洢�������ݿ�
        nStr := SF('L_ProID', FListD.Values['ProviderNo']) + ' and '+SF('L_StockID', FListC.Values['cInvCode']);
        nStr := MakeSQLByStr([
              SF('L_ProName',   FListD.Values['ProviderName']),
              SF('L_ProID',     FListD.Values['ProviderNo']),
              SF('L_StockName', FListC.Values['cInvName']),
              SF('L_StockID',   FListC.Values['cInvCode']),
              SF('L_StockNo',   FListC.Values['cInvCode']),
              SF('L_Value',     '10000')
              ], sTable_OrderLocal, nStr, False);

          if gDBConnManager.WorkerExec(FDBConn,nStr) <= 0 then
          begin
            FListG.Clear;
            FListG.Values['Group']  :=sFlag_BusGroup;
            FListG.Values['Object'] := sFlag_WTNo;
            //to get serial no

            if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
                  FListG.Text, sFlag_Yes, @nOut) then
              raise Exception.Create(nOut.FData);
            //xxxxx

            nStr := MakeSQLByStr([
                SF('L_Order',     nOut.FData),
                SF('L_ProName',   FListD.Values['ProviderName']),
                SF('L_ProID',     FListD.Values['ProviderNo']),
                SF('L_StockName', FListC.Values['cInvName']),
                SF('L_StockID',   FListC.Values['cInvCode']),
                SF('L_StockNo',   FListC.Values['cInvCode']),
                SF('L_Value',     '10000')
                ], sTable_OrderLocal, '', True);
            gDBConnManager.WorkerExec(FDBConn,nStr)
          end;
      end;
      FDBConn.FConn.CommitTrans;
      except
        if FDBConn.FConn.InTransaction then
          FDBConn.FConn.RollbackTrans;
        raise;
      end;
      nData := PackerEncodeStr(FListA.Text);
    end
    else
    begin
      nData := '��ȡ��ͨԭ���϶����ӿڵ����쳣.Data�ڵ��쳣';
      WriteLog(nData);
      Exit;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    if Assigned(nJS) then
      nJS.Free;
  end;
end;

function TBusWorkerBusinessHHJY.IsHhOrderDetailExits(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nNode, nRoot: TXmlNode;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';
  FListA.Clear;
  nStr := 'FBillNumber = ''%s''';
  nStr := Format(nStr,[PackerDecodeStr(FIn.FData)]);

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    WriteLog('��ѯ���ϴ���ͨԭ���ϲɹ������'+nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoT_SupplyMaterialReceiveBill.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IT_SupplyMaterialReceiveBill(nHHJYChannel^.FChannel).RetrieveList(nSoapHeader,
                                   nStr, '');

    WriteLog('��ѯ���ϴ���ͨԭ���ϲɹ�������'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ѯ���ϴ���ͨԭ���ϲɹ��������쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ѯ���ϴ���ͨԭ���ϲɹ��������쳣.Data�ڵ�Ϊ��';
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListA.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListA.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;
      end;
    end;
    nData := PackerEncodeStr(FListA.Text);

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetHhOrderDetailID(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';
  FListE.Clear;

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    WriteLog('��ȡ������ͨԭ���ϲɹ���ID���'+nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoT_SupplyMaterialReceiveBill.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IT_SupplyMaterialReceiveBill(nHHJYChannel^.FChannel).InitializationModel(nSoapHeader);

    WriteLog('��ȡ������ͨԭ���ϲɹ���ID����'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ������ͨԭ���ϲɹ���ID�����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    nJsCol := nJS.Field['Data'] as TlkJSONobject;

    nStr := VarToStr(nJSCol.Field['FBillID'].Value);

    if nStr = '' then
    begin
      nData := '��ȡ������ͨԭ���ϲɹ���ID�ӿڵ����쳣.Data�ڵ�FBillIDΪ��';
      Exit;
    end;

    nData := PackerEncodeStr(nStr);

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.SyncHhOrderDetail(
  var nData: string): boolean;
var nStr,nDateStr,nDelete: string;
    nInt, nIdx: Integer;
    nJS: TlkJSONobject;
begin
  Result := False;

  FListD.Text := PackerDecodeStr(FIn.FData);

  nDelete := '1';

  try
    WriteLog('ͬ��ԭ���ϰ������'+FListD.Text);

    nStr := 'Select P_ID,P_Truck,P_CusID,P_MID,P_UnLoad,P_YSResult,' +
            ' (P_MValue-P_PValue- isnull(P_KzValue,0)) As P_NetWeight,' +
            ' case when (pl.P_PDate IS not null) and (pl.P_MDate IS not null)'+
            ' then (case when pl.P_PDate > pl.P_MDate then pl.P_PDate else'+
            ' pl.P_MDate end) else pl.P_MDate end as P_Date '+
            ' From $Pound pl ';
    //xxxxx

    nStr := nStr + 'Where P_ID=''$CD''';

    nStr := MacroValue(nStr, [MI('$Pound', sTable_PoundLog), MI('$CD', FListD.Values['ID'])]);

    WriteLog('ԭ���ϲ�ѯSQL:' + nStr);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if (FieldByName('P_YSResult').AsString = sFlag_No) or
         (FListD.Values['Delete'] = sFlag_Yes) then
        nDelete := '0';
      nDateStr := FieldByName('P_Date').AsString;

      nStr := Ixxykt(FXXChannel^.FChannel).Insert_Rd01(nDelete, nDateStr,
              FieldByName('P_ID').AsString,FieldByName('P_CusID').AsString,
              FieldByName('P_Truck').AsString,FieldByName('P_MID').AsString,
              FieldByName('P_NetWeight').AsString,'0',
              '0',FieldByName('P_UnLoad').AsString);

      WriteLog('ͬ��ԭ���ϰ�������'+nStr);

      nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

      if not Assigned(nJS) then
      begin
        nData := '�ϴ�ԭ���ϰ����ӿڵ����쳣.��ʽ�޷�����:' + nStr;
        WriteLog(nData);
        Exit;
      end;

      nStr := VarToStr(nJS.Field['IsSuccess'].Value);

      if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
      begin
        nData := 'ͬ��ԭ���ϰ��������쳣.' + VarToStr(nJS.Field['Message'].Value);
        WriteLog(nData);
        Exit;
      end;

      nStr :='update %s set P_BDAX=''1'',P_BDNUM=P_BDNUM+1 where P_ID = ''%s'' ';
      nStr := Format(nStr,[sTable_PoundLog,FListD.Values['ID']]);

      gDBConnManager.WorkerExec(FDBConn,nStr);

      FOut.FData := '';
      FOut.FBase.FResult := True;
      Result := True;
    end;
  finally
    if Assigned(nJS) then
      nJS.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetOrderDetailJSonString(const nLID, nDelete: string;
 var nExits: Boolean; var nInit, nNewStr: string): string;
var nStr, nSQL, nUrl, nDate: string;
    nInt, nIdx: Integer;
    nJSInit, nJSNew: TlkJSONobject;
    nOut: TWorkerBusinessCommand;
    nPDate, nMDate: TDateTime;
    nDepot: string;
begin
  Result := '';
  FListA.Clear;
  FListB.Clear;
  FListC.Clear;

  nSQL := 'Select D_Value From %s Where D_Name=''%s'' and D_Memo=''%s'' ';
  nSQL := Format(nSQL, [sTable_SysDict, sFlag_SysParam, sFlag_HHJYDepotID]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  begin
    if RecordCount < 1 then
    begin
      Result := '������Ϊ[ %s ]�Ĵ����ID������.';
      Result := Format(Result, [nLID]);
      Exit;
    end;
    nDepot := Fields[0].AsString;
  end;

  nExits := TBusWorkerBusinessHHJY.CallMe(cBC_IsHhOrderDetailExits
           ,PackerEncodeStr(nLID),'',@nOut);
  if nExits then
    FListB.Text := PackerDecodeStr(nOut.FData);


  nSQL := 'select *,(P_MValue-P_PValue - isnull(P_KZValue,0)) as D_NetWeight From %s a,'+
  ' %s b, %s c where a.D_OID=b.O_ID and a.D_ID=c.P_OrderBak and c.P_ID = ''%s'' ';

  nSQL := Format(nSQL,[sTable_OrderDtl,sTable_Order,sTable_PoundLog,nLID]);
  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  begin
    if RecordCount < 1 then
    begin
      Result := '������Ϊ[ %s ]�Ĳɹ�����������.';
      Result := Format(Result, [nLID]);
      Exit;
    end;

    FListA.Clear;

    FListA.Values['FEntryPlanNumber']       := FieldByName('P_BID').AsString;
    FListA.Values['FBillID']                := FieldByName('P_ID').AsString;
    FListA.Values['FBillNumber']            := FieldByName('P_ID').AsString;
    FListA.Values['FPoundID']               := FieldByName('P_ID').AsString;
    FListA.Values['FAuditID']               := FieldByName('P_ID').AsString;
    FListA.Values['FBillTypeID']            := '36';

    FListA.Values['FGrossWeightStatus']     := '1';
    FListA.Values['FGrossWeightPersonnel']  := FieldByName('P_MMan').AsString;
    FListA.Values['FGrossWeightTime']       := FieldByName('P_MDate').AsString;

    if FieldByName('P_MValue').AsString = '' then
      FListA.Values['FReceiveGrossWeight']    := '0'
    else
      FListA.Values['FReceiveGrossWeight']    := FieldByName('P_MValue').AsString;

    FListA.Values['FReceivePersonnel']      := FieldByName('P_MMan').AsString;
    try
      nPDate := FieldByName('P_PDate').AsDateTime;
      nMDate := FieldByName('P_MDate').AsDateTime;
      if nMDate > nPDate then
        nDate := FieldByName('P_MDate').AsString
      else
        nDate := FieldByName('P_PDate').AsString;
    except
        nDate := FieldByName('P_PDate').AsString;
    end;

    FListA.Values['FReceiveTime']           := nDate;

    FListA.Values['FTareStatus']            := '1';
    FListA.Values['FTarePersonnel']         := FieldByName('P_PMan').AsString;
    FListA.Values['FTareTime']              := FieldByName('P_PDate').AsString;

    if FieldByName('P_PValue').AsString = '' then
      FListA.Values['FReceiveTare']    := '0'
    else
      FListA.Values['FReceiveTare']    := FieldByName('P_PValue').AsString;

    if FieldByName('D_NetWeight').AsString = '' then
      FListA.Values['FReceiveNetWeight']    := '0'
    else
      FListA.Values['FReceiveNetWeight']    := FieldByName('D_NetWeight').AsString;

    FListA.Values['FCreator']               := FieldByName('P_PMan').AsString;
    FListA.Values['FCreateTime']            := nDate;
    FListA.Values['FShipNumber']            := FieldByName('P_Ship').AsString;
    FListA.Values['FConveyanceNumber']      := FieldByName('P_Truck').AsString;
    FListA.Values['FImpurity']              := FloatToStr(StrToFLoatDef(
                                         FieldByName('D_KZValue').AsString,0));
    FListA.Values['FDeductAmount']          := '0';
    FListA.Values['FStatus']                := '254';
    FListA.Values['FDepotID']               := nDepot;

    if nDelete = sFlag_Yes then
    begin
      FListA.Values['FCancelStatus']        := '1';
      FListA.Values['FCancelPersonnel']     := FieldByName('P_PMan').AsString;
      FListA.Values['FCancelTime']          := nDate;
    end
    else
      FListA.Values['FCancelStatus']          := '0';
      
    FListA.Values['FDataStatus']            := '0';
    FListA.Values['FMaterialStockInStatus'] := '0';
    FListA.Values['FFreightStockInStatus']  := '0';
    FListA.Values['FLabStatus']             := '0';
  end;

  if FListA.Values['FEntryPlanNumber'] = '' then
  begin
    Result := '��ͨԭ���ϲɹ�����[ %s ]��ǰ������Ϊ��.';
    Result := Format(Result, [nLID]);
    Exit;
  end;

  nSQL := 'FEntryPlanNumber = ''%s''';
  nSQL := Format(nSQL, [FListA.Values['FEntryPlanNumber']]);

  if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhOrderPlan
           ,PackerEncodeStr(nSQL),'',@nOut) then
  begin
    Result := '��ͨԭ���ϲɹ�����[ %s ]��ȡ��ǰ����[ %s ]��Ϣʧ��.';
    Result := Format(Result, [nLID, FListA.Values['FEntryPlanNumber']]);
    Exit;
  end;

  FListC.Text := PackerDecodeStr(nOut.FData);

  try
    if nExits then//���ϴ�
    begin
      nJSInit := TlkJSONobject.Create();

      with nJSInit do//ԭʼ����
      begin
        Add('FBillID', FListB.Values['FBillID']);//�����ID
        Add('FBillNumber', FListA.Values['FBillID']);//�������
        Add('FBillTypeID', '36');
        Add('FCompanyID', FListB.Values['FCompanyID']);
        Add('FUseDepartmentID', FListB.Values['FUseDepartmentID']);

        Add('FDepotID', FListB.Values['FDepotID']);//???
        Add('FYearPeriod', FListB.Values['FYearPeriod']);
        Add('FMaterielID', FListB.Values['FMaterielID']);
        Add('FUnitID', FListB.Values['FUnitID']);
        Add('FUnitID_Auxiliary', FListB.Values['FUnitID_Auxiliary']);

        Add('FUnitIsFloat', FListB.Values['FUnitIsFloat']);
        Add('FUnitCoefficient', FListB.Values['FUnitCoefficient']);
        Add('FValueID', FListB.Values['FValueID']);

        Add('FEntryPlanID', FListB.Values['FEntryPlanID']);
        Add('FRequirementPlanID', FListB.Values['FRequirementPlanID']);
        Add('FRequirementPlanDetailID', FListB.Values['FRequirementPlanDetailID']);

        Add('FMaterialProviderID', FListB.Values['FMaterialProviderID']);
        Add('FMaterialContractDetailID', FListB.Values['FMaterialContractDetailID']);
        Add('FProducerID', FListB.Values['FProducerID']);

        Add('FMaterialPriceTax', FListB.Values['FMaterialPriceTax']);
        Add('FMaterialMoneyTax', FListB.Values['FMaterialMoneyTax']);

        Add('FMaterialInvoiceTypeID', FListB.Values['FMaterialInvoiceTypeID']);
        Add('FMaterialInvoiceClassID', FListB.Values['FMaterialInvoiceClassID']);
        Add('FMaterialTaxRate', FListB.Values['FMaterialTaxRate']);

        Add('FMaterialPrice', FListB.Values['FMaterialPrice']);
        Add('FMaterialMoney', FListB.Values['FMaterialMoney']);

        Add('FFreightProviderID', FListB.Values['FFreightProviderID']);
        Add('FFreightContractDetailID', FListB.Values['FFreightContractDetailID']);

        Add('FFreightPriceTax', FListB.Values['FFreightPriceTax']);
        Add('FFreightMoneyTax', FListB.Values['FFreightMoneyTax']);

        Add('FFreightInvoiceTypeID', FListB.Values['FFreightInvoiceTypeID']);
        Add('FFreightInvoiceClassID', FListB.Values['FFreightInvoiceClassID']);
        Add('FFreightTaxRate', FListB.Values['FFreightTaxRate']);

        Add('FFreightPrice', FListB.Values['FFreightPrice']);
        Add('FFreightMoney', FListB.Values['FFreightMoney']);

        Add('FBillAmount', FListB.Values['FReceiveNetWeight']);
        Add('FBillAmount_Auxiliary', FListB.Values['FBillAmount_Auxiliary']);
        Add('FReceiveGrossWeight', FListB.Values['FReceiveGrossWeight']);
        Add('FReceiveGrossWeight_Auxiliary', FListB.Values['FReceiveGrossWeight_Auxiliary']);
        Add('FReceiveTare', FListB.Values['FReceiveTare']);
        Add('FReceiveTare_Auxiliary', FListB.Values['FReceiveTare_Auxiliary']);
        Add('FImpurity', FListB.Values['FImpurity']);
        Add('FImpurity_Auxiliary', FListB.Values['FImpurity_Auxiliary']);
        Add('FDeductAmount', FListB.Values['FDeductAmount']);
        Add('FDeductAmount_Auxiliary', FListB.Values['FDeductAmount_Auxiliary']);
        Add('FReceiveNetWeight', FListB.Values['FReceiveNetWeight']);
        Add('FReceiveNetWeight_Auxiliary', FListB.Values['FReceiveNetWeight_Auxiliary']);

        Add('FConsignmentGrossWeight', FListB.Values['FConsignmentGrossWeight']);
        Add('FConsignmentGrossWeight_Auxiliary', FListB.Values['FConsignmentGrossWeight_Auxiliary']);
        Add('FConsignmentTare', FListB.Values['FConsignmentTare']);
        Add('FConsignmentTare_Auxiliary', FListB.Values['FConsignmentTare_Auxiliary']);
        Add('FConsignmentNetWeight', FListB.Values['FConsignmentNetWeight']);
        Add('FConsignmentNetWeight_Auxiliary', FListB.Values['FConsignmentNetWeight_Auxiliary']);

        Add('FDock', FListB.Values['FDock']);//???
        Add('FConveyanceNumber', FListB.Values['FConveyanceNumber']);
        Add('FShipNumber', FListB.Values['FShipNumber']);

        Add('FMaterialSettlementFashion', FListB.Values['FMaterialSettlementFashion']);
        Add('FMaterialSettlementRate', FListB.Values['FMaterialSettlementRate']);
        Add('FFreightSettlementFashion', FListB.Values['FFreightSettlementFashion']);
        Add('FFreightSettlementRate', FListB.Values['FFreightSettlementRate']);

        Add('FArrivePortBillID', FListB.Values['FArrivePortBillID']);//???
        Add('FDisembarkFlag', FListB.Values['FDisembarkFlag']);//???
        Add('FEntryFactoryWeighFashion', FListB.Values['FEntryFactoryWeighFashion']);//???
        Add('FDisembarkGetAmountFashion', FListB.Values['FDisembarkGetAmountFashion']);//???

        Add('FGrossWeightStatus_Consignment', FListB.Values['FGrossWeightStatus_Consignment']);
        Add('FGrossWeightPersonnel_Consignment', FListB.Values['FGrossWeightPersonnel_Consignment']);
        Add('FGrossWeightTime_Consignment', FListB.Values['FGrossWeightTime_Consignment']);
        Add('FTareStatus_Consignment', FListB.Values['FTareStatus_Consignment']);
        Add('FTarePersonnel_Consignment', FListB.Values['FTarePersonnel_Consignment']);
        Add('FTareTime_Consignment ', FListB.Values['FTareTime_Consignment']);

        Add('FGrossWeightStatus', FListB.Values['FGrossWeightStatus']);
        Add('FGrossWeightPersonnel', FListB.Values['FGrossWeightPersonnel']);
        Add('FGrossWeightTime', FListB.Values['FGrossWeightTime']);
        Add('FAgainWeightStatus', FListB.Values['FAgainWeightStatus']);//???
        Add('FTareStatus', FListB.Values['FTareStatus']);
        Add('FTarePersonnel', FListB.Values['FTarePersonnel']);
        Add('FTareTime ', FListB.Values['FTareTime']);

        Add('FIsManpowerUnload', FListB.Values['FIsManpowerUnload']);//???
        Add('FUnloadMoney', FListB.Values['FUnloadMoney']);//???

        Add('FReceivePersonnel', FListB.Values['FReceivePersonnel']);
        Add('FReceiveTime', FListB.Values['FReceiveTime']);

        Add('FMaterialSettlementStatus', FListB.Values['FMaterialSettlementStatus']);//???
        Add('FMaterialSettlementPersonnel', FListB.Values['FMaterialSettlementPersonnel']);//???
        Add('FMaterialSettlementTime', FListB.Values['FMaterialSettlementTime']);//???
        Add('FFreightSettlementStatus', FListB.Values['FFreightSettlementStatus']);//???
        Add('FFreightSettlementPersonnel', FListB.Values['FFreightSettlementPersonnel']);//???
        Add('FFreightSettlementTime', FListB.Values['FFreightSettlementTime']);//???

        Add('FDataStatus', FListB.Values['FDataStatus']);
        Add('FUnloadMoney', FListB.Values['FUnloadMoney']);//???
        Add('FIsManpowerUnload', FListB.Values['FIsManpowerUnload']);//???
        Add('FMaterialStockInStatus', FListB.Values['FMaterialStockInStatus']);//???
        Add('FFreightStockInStatus', FListB.Values['FFreightStockInStatus']);//???
        Add('FLabStatus', FListB.Values['FLabStatus']);//???
        Add('FStatus', FListB.Values['FStatus']);

        Add('FCancelStatus', FListB.Values['FCancelStatus']);
        Add('FCancelPersonnel', FListB.Values['FCancelPersonnel']);
        Add('FCancelTime', FListB.Values['FCancelTime']);
        Add('FCreator', FListB.Values['FCreator']);
        Add('FCreateTime', FListB.Values['FCreateTime']);

        Add('FRemark', FListB.Values['FRemark']);
        Add('FVer', FListB.Values['FVer']);
      end;

      nInit := TlkJSON.GenerateText(nJSInit);
      nInit := UTF8Decode(nInit);
      WriteLog('��ͨԭ���ϲɹ����ϴ�ԭʼ����:' + nInit);

      nJSNew := TlkJSONobject.Create();

      with nJSNew do
      begin
        Add('FBillID', FListB.Values['FBillID']);//�����ID
        Add('FBillNumber', FListA.Values['FBillID']);//�������
        Add('FBillTypeID', '36');
        Add('FCompanyID', FListC.Values['FCompanyID']);
        Add('FUseDepartmentID', FListC.Values['FUseDepartmentID']);

        Add('FDepotID', FListA.Values['FDepotID']);//???
        Add('FYearPeriod', FListC.Values['FYearPeriod']);
        Add('FMaterielID', FListC.Values['FMaterielID']);
        Add('FUnitID', FListC.Values['FUnitID']);
        Add('FUnitID_Auxiliary', FListC.Values['FUnitID_Auxiliary']);

        Add('FUnitIsFloat', FListC.Values['FUnitIsFloat']);
        Add('FUnitCoefficient', FListC.Values['FUnitCoefficient']);
        Add('FValueID', FListC.Values['FValueID']);

        Add('FEntryPlanID', FListC.Values['FEntryPlanID']);
        Add('FRequirementPlanID', FListC.Values['FRequirementPlanID']);
        Add('FRequirementPlanDetailID', FListC.Values['FRequirementPlanDetailID']);

        Add('FMaterialProviderID', FListC.Values['FMaterialProviderID']);
        Add('FMaterialContractDetailID', FListC.Values['FMaterialContractDetailID']);
        Add('FProducerID', FListC.Values['FProducerID']);

        Add('FMaterialPriceTax', FListC.Values['FMaterialPriceTax']);
        Add('FMaterialMoneyTax', GetMoney(FListC.Values['FMaterialPriceTax'],
                                    FListA.Values['FReceiveNetWeight']));

        Add('FMaterialInvoiceTypeID', FListC.Values['FMaterialInvoiceTypeID']);
        Add('FMaterialInvoiceClassID', FListC.Values['FMaterialInvoiceClassID']);
        Add('FMaterialTaxRate', FListC.Values['FMaterialTaxRate']);

        Add('FMaterialPrice', FListC.Values['FMaterialPrice']);
        Add('FMaterialMoney', GetMoney(FListC.Values['FMaterialPrice'],
                                    FListA.Values['FReceiveNetWeight']));

        Add('FFreightProviderID', FListC.Values['FFreightProviderID']);
        Add('FFreightContractDetailID', FListC.Values['FFreightContractDetailID']);

        Add('FFreightPriceTax', FListC.Values['FFreightPriceTax']);
        Add('FFreightMoneyTax', GetMoney(FListC.Values['FFreightPriceTax'],
                                    FListA.Values['FReceiveNetWeight']));

        Add('FFreightInvoiceTypeID', FListC.Values['FFreightInvoiceTypeID']);
        Add('FFreightInvoiceClassID', FListC.Values['FFreightInvoiceClassID']);
        Add('FFreightTaxRate', FListC.Values['FFreightTaxRate']);

        Add('FFreightPrice', FListC.Values['FFreightPrice']);
        Add('FFreightMoney', GetMoney(FListC.Values['FFreightPrice'],
                                    FListA.Values['FReceiveNetWeight']));

        Add('FBillAmount', FListA.Values['FReceiveNetWeight']);
        Add('FBillAmount_Auxiliary', FListA.Values['FReceiveNetWeight']);
        Add('FReceiveGrossWeight', FListA.Values['FReceiveGrossWeight']);
        Add('FReceiveGrossWeight_Auxiliary', FListA.Values['FReceiveGrossWeight']);
        Add('FReceiveTare', FListA.Values['FReceiveTare']);
        Add('FReceiveTare_Auxiliary', FListA.Values['FReceiveTare']);
        Add('FImpurity', FListA.Values['FImpurity']);
        Add('FImpurity_Auxiliary', FListA.Values['FImpurity']);
        Add('FDeductAmount', FListA.Values['FDeductAmount']);
        Add('FDeductAmount_Auxiliary', FListA.Values['FDeductAmount']);
        Add('FReceiveNetWeight', FListA.Values['FReceiveNetWeight']);
        Add('FReceiveNetWeight_Auxiliary', FListA.Values['FReceiveNetWeight']);

        Add('FConsignmentGrossWeight', FListA.Values['FReceiveGrossWeight']);
        Add('FConsignmentGrossWeight_Auxiliary', FListA.Values['FReceiveGrossWeight']);
        Add('FConsignmentTare', FListA.Values['FReceiveTare']);
        Add('FConsignmentTare_Auxiliary', FListA.Values['FReceiveTare']);
        Add('FConsignmentNetWeight', FListA.Values['FReceiveNetWeight']);
        Add('FConsignmentNetWeight_Auxiliary', FListA.Values['FReceiveNetWeight']);

        Add('FDock', FListA.Values['FDock']);
        Add('FConveyanceNumber', FListA.Values['FConveyanceNumber']);
        Add('FShipNumber', FListA.Values['FShipNumber']);

        Add('FMaterialSettlementFashion', FListC.Values['FMaterialSettlementFashion']);
        Add('FMaterialSettlementRate', FListC.Values['FMaterialSettlementRate']);
        Add('FFreightSettlementFashion', FListC.Values['FFreightSettlementFashion']);
        Add('FFreightSettlementRate', FListC.Values['FFreightSettlementRate']);

        Add('FArrivePortBillID', '-1');
        Add('FDisembarkFlag', '0');
        Add('FEntryFactoryWeighFashion', '0');
        Add('FDisembarkGetAmountFashion', '0');

        Add('FGrossWeightStatus_Consignment', FListA.Values['FGrossWeightStatus']);
        Add('FGrossWeightPersonnel_Consignment', FListA.Values['FGrossWeightPersonnel']);
        Add('FGrossWeightTime_Consignment', FListA.Values['FGrossWeightTime']);
        Add('FTareStatus_Consignment', FListA.Values['FTareStatus']);
        Add('FTarePersonnel_Consignment', FListA.Values['FTarePersonnel']);
        Add('FTareTime_Consignment ', FListA.Values['FTareTime']);

        Add('FGrossWeightStatus', FListA.Values['FGrossWeightStatus']);
        Add('FGrossWeightPersonnel', FListA.Values['FGrossWeightPersonnel']);
        Add('FGrossWeightTime', FListA.Values['FGrossWeightTime']);
        Add('FAgainWeightStatus', '0');
        Add('FTareStatus', FListA.Values['FTareStatus']);
        Add('FTarePersonnel', FListA.Values['FTarePersonnel']);
        Add('FTareTime ', FListA.Values['FTareTime']);

        Add('FIsManpowerUnload', '0');
        Add('FUnloadMoney', '0');

        Add('FReceivePersonnel', FListA.Values['FTarePersonnel']);
        Add('FReceiveTime', FListA.Values['FReceiveTime']);

        Add('FMaterialSettlementStatus', '0');
        Add('FMaterialSettlementPersonnel', '');
        Add('FMaterialSettlementTime', '');
        Add('FFreightSettlementStatus', '0');
        Add('FFreightSettlementPersonnel', '');
        Add('FFreightSettlementTime', '');

        Add('FDataStatus', FListA.Values['FDataStatus']);
        Add('FUnloadMoney', '0');
        Add('FIsManpowerUnload', '0');
        Add('FMaterialStockInStatus', FListA.Values['FMaterialStockInStatus']);
        Add('FFreightStockInStatus', FListA.Values['FFreightStockInStatus']);
        Add('FLabStatus', FListA.Values['FLabStatus']);
        Add('FStatus', FListA.Values['FStatus']);

        Add('FCancelStatus', FListA.Values['FCancelStatus']);
        Add('FCancelPersonnel', FListA.Values['FCancelPersonnel']);
        Add('FCancelTime', FListA.Values['FCancelTime']);
        Add('FCreator', FListA.Values['FCreator']);
        Add('FCreateTime', FListA.Values['FCreateTime']);

        Add('FRemark', FListC.Values['FRemark']);
        Add('FVer', FListC.Values['FVer']);
      end;
      nNewStr := TlkJSON.GenerateText(nJSNew);
      nNewStr := UTF8Decode(nNewStr);
      WriteLog('��ͨԭ���ϲɹ����ϴ���ǰ����:' + nNewStr);
    end
    else
    begin
      if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhOrderDetailID,
           '','',@nOut) then
      begin
        Result := '[' + nLID + ']��ȡ������ͨԭ���ϲɹ���IDʧ��.';
        Exit;
      end;

      nStr := PackerDecodeStr(nOut.FData);
      nJSNew := TlkJSONobject.Create();

      with nJSNew do
      begin
        Add('FBillID', nStr);//�����ID
        Add('FBillNumber', FListA.Values['FBillID']);//�������
        Add('FBillTypeID', '36');
        Add('FCompanyID', FListC.Values['FCompanyID']);
        Add('FUseDepartmentID', FListC.Values['FUseDepartmentID']);

        Add('FDepotID', FListA.Values['FDepotID']);//???
        Add('FYearPeriod', FListC.Values['FYearPeriod']);
        Add('FMaterielID', FListC.Values['FMaterielID']);
        Add('FUnitID', FListC.Values['FUnitID']);
        Add('FUnitID_Auxiliary', FListC.Values['FUnitID_Auxiliary']);

        Add('FUnitIsFloat', FListC.Values['FUnitIsFloat']);
        Add('FUnitCoefficient', FListC.Values['FUnitCoefficient']);
        Add('FValueID', FListC.Values['FValueID']);

        Add('FEntryPlanID', FListC.Values['FEntryPlanID']);
        Add('FRequirementPlanID', FListC.Values['FRequirementPlanID']);
        Add('FRequirementPlanDetailID', FListC.Values['FRequirementPlanDetailID']);

        Add('FMaterialProviderID', FListC.Values['FMaterialProviderID']);
        Add('FMaterialContractDetailID', FListC.Values['FMaterialContractDetailID']);
        Add('FProducerID', FListC.Values['FProducerID']);

        Add('FMaterialPriceTax', FListC.Values['FMaterialPriceTax']);
        Add('FMaterialMoneyTax', GetMoney(FListC.Values['FMaterialPriceTax'],
                                    FListA.Values['FReceiveNetWeight']));

        Add('FMaterialInvoiceTypeID', FListC.Values['FMaterialInvoiceTypeID']);
        Add('FMaterialInvoiceClassID', FListC.Values['FMaterialInvoiceClassID']);
        Add('FMaterialTaxRate', FListC.Values['FMaterialTaxRate']);

        Add('FMaterialPrice', FListC.Values['FMaterialPrice']);
        Add('FMaterialMoney', GetMoney(FListC.Values['FMaterialPrice'],
                                    FListA.Values['FReceiveNetWeight']));

        Add('FFreightProviderID', FListC.Values['FFreightProviderID']);
        Add('FFreightContractDetailID', FListC.Values['FFreightContractDetailID']);

        Add('FFreightPriceTax', FListC.Values['FFreightPriceTax']);
        Add('FFreightMoneyTax', GetMoney(FListC.Values['FFreightPriceTax'],
                                    FListA.Values['FReceiveNetWeight']));

        Add('FFreightInvoiceTypeID', FListC.Values['FFreightInvoiceTypeID']);
        Add('FFreightInvoiceClassID', FListC.Values['FFreightInvoiceClassID']);
        Add('FFreightTaxRate', FListC.Values['FFreightTaxRate']);

        Add('FFreightPrice', FListC.Values['FFreightPrice']);
        Add('FFreightMoney', GetMoney(FListC.Values['FFreightPrice'],
                                    FListA.Values['FReceiveNetWeight']));

        Add('FBillAmount', FListA.Values['FReceiveNetWeight']);
        Add('FBillAmount_Auxiliary', FListA.Values['FReceiveNetWeight']);
        Add('FReceiveGrossWeight', FListA.Values['FReceiveGrossWeight']);
        Add('FReceiveGrossWeight_Auxiliary', FListA.Values['FReceiveGrossWeight']);
        Add('FReceiveTare', FListA.Values['FReceiveTare']);
        Add('FReceiveTare_Auxiliary', FListA.Values['FReceiveTare']);
        Add('FImpurity', FListA.Values['FImpurity']);
        Add('FImpurity_Auxiliary', FListA.Values['FImpurity']);
        Add('FDeductAmount', FListA.Values['FDeductAmount']);
        Add('FDeductAmount_Auxiliary', FListA.Values['FDeductAmount']);
        Add('FReceiveNetWeight', FListA.Values['FReceiveNetWeight']);
        Add('FReceiveNetWeight_Auxiliary', FListA.Values['FReceiveNetWeight']);

        Add('FConsignmentGrossWeight', FListA.Values['FReceiveGrossWeight']);
        Add('FConsignmentGrossWeight_Auxiliary', FListA.Values['FReceiveGrossWeight']);
        Add('FConsignmentTare', FListA.Values['FReceiveTare']);
        Add('FConsignmentTare_Auxiliary', FListA.Values['FReceiveTare']);
        Add('FConsignmentNetWeight', FListA.Values['FReceiveNetWeight']);
        Add('FConsignmentNetWeight_Auxiliary', FListA.Values['FReceiveNetWeight']);

        Add('FDock', FListA.Values['FDock']);
        Add('FConveyanceNumber', FListA.Values['FConveyanceNumber']);
        Add('FShipNumber', FListA.Values['FShipNumber']);

        Add('FMaterialSettlementFashion', FListC.Values['FMaterialSettlementFashion']);
        Add('FMaterialSettlementRate', FListC.Values['FMaterialSettlementRate']);
        Add('FFreightSettlementFashion', FListC.Values['FFreightSettlementFashion']);
        Add('FFreightSettlementRate', FListC.Values['FFreightSettlementRate']);

        Add('FArrivePortBillID', '-1');
        Add('FDisembarkFlag', '0');
        Add('FEntryFactoryWeighFashion', '0');
        Add('FDisembarkGetAmountFashion', '0');

        Add('FGrossWeightStatus_Consignment', FListA.Values['FGrossWeightStatus']);
        Add('FGrossWeightPersonnel_Consignment', FListA.Values['FGrossWeightPersonnel']);
        Add('FGrossWeightTime_Consignment', FListA.Values['FGrossWeightTime']);
        Add('FTareStatus_Consignment', FListA.Values['FTareStatus']);
        Add('FTarePersonnel_Consignment', FListA.Values['FTarePersonnel']);
        Add('FTareTime_Consignment ', FListA.Values['FTareTime']);

        Add('FGrossWeightStatus', FListA.Values['FGrossWeightStatus']);
        Add('FGrossWeightPersonnel', FListA.Values['FGrossWeightPersonnel']);
        Add('FGrossWeightTime', FListA.Values['FGrossWeightTime']);
        Add('FAgainWeightStatus', '0');
        Add('FTareStatus', FListA.Values['FTareStatus']);
        Add('FTarePersonnel', FListA.Values['FTarePersonnel']);
        Add('FTareTime ', FListA.Values['FTareTime']);

        Add('FIsManpowerUnload', '0');
        Add('FUnloadMoney', '0');

        Add('FReceivePersonnel', FListA.Values['FTarePersonnel']);
        Add('FReceiveTime', FListA.Values['FReceiveTime']);

        Add('FMaterialSettlementStatus', '0');
        Add('FMaterialSettlementPersonnel', '');
        Add('FMaterialSettlementTime', '');
        Add('FFreightSettlementStatus', '0');
        Add('FFreightSettlementPersonnel', '');
        Add('FFreightSettlementTime', '');

        Add('FDataStatus', FListA.Values['FDataStatus']);
        Add('FUnloadMoney', '0');
        Add('FIsManpowerUnload', '0');
        Add('FMaterialStockInStatus', FListA.Values['FMaterialStockInStatus']);
        Add('FFreightStockInStatus', FListA.Values['FFreightStockInStatus']);
        Add('FLabStatus', FListA.Values['FLabStatus']);
        Add('FStatus', FListA.Values['FStatus']);

        Add('FCancelStatus', FListA.Values['FCancelStatus']);
        Add('FCancelPersonnel', FListA.Values['FCancelPersonnel']);
        Add('FCancelTime', FListA.Values['FCancelTime']);
        Add('FCreator', FListA.Values['FCreator']);
        Add('FCreateTime', FListA.Values['FCreateTime']);

        Add('FRemark', FListC.Values['FRemark']);
        Add('FVer', FListC.Values['FVer']);
      end;
      nNewStr := TlkJSON.GenerateText(nJSNew);
      nNewStr := UTF8Decode(nNewStr);
      WriteLog('��ͨԭ���ϲɹ����ϴ���ǰ����:' + nNewStr);
    end;
  finally
    if Assigned(nJSInit) then
      nJSInit.Free;
    if Assigned(nJSNew) then
      nJSNew.Free;
  end;
end;

function TBusWorkerBusinessHHJY.SyncHhNdOrderPlan(
  var nData: string): boolean;
var nStr, nUrl: string;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
    nValue: Double;
begin
  Result := False;
  nUrl := '';
  nStr := PackerDecodeStr(FIn.FData);

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        if nStr = '' then
          nStr := FDefWhere
        else
        if FDefWhere <> '' then
          nStr := nStr + ' And ' + FDefWhere;
        Break;
      end;
    end;

    WriteLog('��ȡ�ڵ�ԭ���϶������'+nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

        FChannel := CoV_SupplyMaterialTransferPlan.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IV_SupplyMaterialTransferPlan(nHHJYChannel^.FChannel).RetrieveList(nSoapHeader,
                            nStr, '');

    if Pos('FBillNumber', PackerDecodeStr(FIn.FData)) > 0 then
      WriteLog('��ȡ�ڵ�ԭ���϶�������'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ�ڵ�ԭ���϶����ӿڵ����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ȡ�ڵ�ԭ���϶����ӿڵ����쳣.' + FIn.FData + 'Data�ڵ�Ϊ��';
        WriteLog(nData);
        Exit;
      end;

      if Pos('FBillNumber', PackerDecodeStr(FIn.FData)) > 0 then
      begin
        for nIdx := 0 to nJSRow.Count - 1 do
        begin
          nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

          FListE.Clear;
          for nInt := 0 to nJSCol.Count - 1 do
          begin
            FListE.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
          end;
          nData := PackerEncodeStr(FListE.Text);
        end;
      end
      else
      begin
        FListA.Clear;
        FListC.Clear;
        for nIdx := 0 to nJSRow.Count - 1 do
        begin
          nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

          FListB.Clear;
          FListC.Clear;
          for nInt := 0 to nJSCol.Count - 1 do
          begin
            FListC.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
          end;

          with FListB do
          begin
            Values['Order']         := FListC.Values['FBillNumber'];
            Values['StockName']     := FListC.Values['FMaterielName'];
            Values['StockID']       := FListC.Values['FMaterielID'];
            Values['StockNo']       := FListC.Values['FMaterielNumber'];
            try
              nValue := StrToFloat(FListC.Values['FApproveAmount'])
                        - StrToFloat(FListC.Values['FExecuteAmount']);
              nValue := Float2PInt(nValue, cPrecision, False) / cPrecision;
            except
              nValue := 0;
            end;
            Values['PlanValue']     := FListC.Values['FApproveAmount'];//������
            Values['EntryValue']    := FListC.Values['FExecuteAmount'];//�ѽ�����
            Values['Value']         := FloatToStr(nValue);//ʣ����
            Values['Model']         := FListC.Values['FModel'];//�ͺ�

            FListA.Add(PackerEncodeStr(FListB.Text));
          end;
        end;
        nData := PackerEncodeStr(FListA.Text);
      end;
    end
    else
    begin
      nData := '��ȡ�ڵ�ԭ���϶����ӿڵ����쳣.Data�ڵ��쳣';
      WriteLog(nData);
      Exit;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.IsHhNdOrderDetailExits(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nNode, nRoot: TXmlNode;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';
  FListA.Clear;
  nStr := 'FBillNumber = ''%s''';
  nStr := Format(nStr,[PackerDecodeStr(FIn.FData)]);

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    WriteLog('��ѯ���ϴ��ڵ�ԭ���ϲɹ������'+nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoT_SupplyMaterialTransferBill.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IT_SupplyMaterialTransferBill(nHHJYChannel^.FChannel).RetrieveList(nSoapHeader,
                                   nStr, '');

    WriteLog('��ѯ���ϴ��ڵ�ԭ���ϲɹ�������'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ѯ���ϴ��ڵ�ԭ���ϲɹ��������쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ѯ���ϴ��ڵ�ԭ���ϲɹ��������쳣.Data�ڵ�Ϊ��';
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListA.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListA.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;
      end;
    end;
    nData := PackerEncodeStr(FListA.Text);

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetHhNdOrderDetailID(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';
  FListE.Clear;

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    WriteLog('��ȡ�����ڵ�ԭ���ϲɹ���ID���'+nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoT_SupplyMaterialTransferBill.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IT_SupplyMaterialTransferBill(nHHJYChannel^.FChannel).InitializationModel(nSoapHeader);

    WriteLog('��ȡ�����ڵ�ԭ���ϲɹ���ID����'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ�����ڵ�ԭ���ϲɹ���ID�����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    nJsCol := nJS.Field['Data'] as TlkJSONobject;

    nStr := VarToStr(nJSCol.Field['FBillID'].Value);

    if nStr = '' then
    begin
      nData := '��ȡ�����ڵ�ԭ���ϲɹ���ID�ӿڵ����쳣.Data�ڵ�FBillIDΪ��';
      Exit;
    end;

    nData := PackerEncodeStr(nStr);

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.SyncHhNdOrderDetail(
  var nData: string): boolean;
var nStr, nUrl: string;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
    nExits: Boolean;
    nInitStr, nNewStr: string;
begin
  Result := False;
  nExits := False;
  nUrl := '';
  FListD.Text := PackerDecodeStr(FIn.FData);

  WriteLog('ͬ���ڵ�ԭ���ϲɹ���׼���������:' + FListD.Text);

  nData := GetNdOrderDetailJSonString(FListD.Values['ID'], FListD.Values['Delete'], nExits,
                                    nInitStr, nNewStr);
  if nData <> '' then
  begin
    WriteLog('ͬ���ڵ�ԭ���ϲɹ���׼�����ݽ��:' + nData);
    Exit;
  end;

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    WriteLog('ͬ���ڵ�ԭ���ϲɹ������'+FListD.Text);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoT_SupplyMaterialTransferBill.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel

    if nExits then
    begin
      nStr := IT_SupplyMaterialTransferBill(nHHJYChannel^.FChannel).Update(nSoapHeader,
                                     nInitStr, nNewStr);
    end
    else
    begin
      nStr := IT_SupplyMaterialTransferBill(nHHJYChannel^.FChannel).Insert(nSoapHeader,
                                     nNewStr);
    end;

    WriteLog('ͬ���ڵ�ԭ���ϲɹ�������'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := 'ͬ���ڵ�ԭ���ϲɹ��������쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    nStr :='update %s set P_BDAX=''1'',P_BDNUM=P_BDNUM+1 where P_ID = ''%s'' ';
    nStr := Format(nStr,[sTable_PoundLog,FListD.Values['ID']]);

    gDBConnManager.WorkerExec(FDBConn,nStr);

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetNdOrderDetailJSonString(const nLID, nDelete: string;
 var nExits: Boolean; var nInit, nNewStr: string): string;
var nStr, nSQL, nUrl, nDate: string;
    nInt, nIdx: Integer;
    nJSInit, nJSNew: TlkJSONobject;
    nOut: TWorkerBusinessCommand;
    nPDate, nMDate: TDateTime;
begin
  Result := '';
  FListA.Clear;
  FListB.Clear;
  FListC.Clear;

  nExits := TBusWorkerBusinessHHJY.CallMe(cBC_IsHhNdOrderDetailExits
           ,PackerEncodeStr(nLID),'',@nOut);
  if nExits then
    FListB.Text := PackerDecodeStr(nOut.FData);


  nSQL := 'select *,(P_MValue-P_PValue - isnull(P_KZValue,0)) as D_NetWeight From %s a,'+
  ' %s b, %s c where a.D_OID=b.O_ID and a.D_ID=c.P_OrderBak and c.P_ID = ''%s'' ';

  nSQL := Format(nSQL,[sTable_OrderDtl,sTable_Order,sTable_PoundLog,nLID]);
  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  begin
    if RecordCount < 1 then
    begin
      Result := '������Ϊ[ %s ]�Ĳɹ�����������.';
      Result := Format(Result, [nLID]);
      Exit;
    end;

    FListA.Clear;

    FListA.Values['FTransferPlanNumber']    := FieldByName('P_BID').AsString;
    FListA.Values['FBillID']                := FieldByName('P_ID').AsString;
    FListA.Values['FBillNumber']            := FieldByName('P_ID').AsString;
    FListA.Values['FPoundID']               := FieldByName('P_ID').AsString;
    FListA.Values['FAuditID']               := FieldByName('P_ID').AsString;
    FListA.Values['FBillTypeID']            := '49';

    FListA.Values['FConsignmentGrossWeightStatus']     := '1';
    FListA.Values['FConsignmentGrossWeightPersonnel']  := FieldByName('P_MMan').AsString;
    FListA.Values['FConsignmentGrossWeightTime']       := FieldByName('P_MDate').AsString;

    if FieldByName('P_MValue').AsString = '' then
      FListA.Values['FConsignmentGrossWeight']    := '0'
    else
      FListA.Values['FConsignmentGrossWeight']    := FieldByName('P_MValue').AsString;

    FListA.Values['FConsignmentStatus']         := '1';
    FListA.Values['FConsignmentPersonnel']      := FieldByName('P_MMan').AsString;
    try
      nPDate := FieldByName('P_PDate').AsDateTime;
      nMDate := FieldByName('P_MDate').AsDateTime;
      if nMDate > nPDate then
        nDate := FieldByName('P_MDate').AsString
      else
        nDate := FieldByName('P_PDate').AsString;
    except
        nDate := FieldByName('P_PDate').AsString;
    end;

    FListA.Values['FConsignmentTime']           := nDate;

    FListA.Values['FConsignmentTareStatus']            := '1';
    FListA.Values['FConsignmentTarePersonnel']         := FieldByName('P_PMan').AsString;
    FListA.Values['FConsignmentTareTime']              := FieldByName('P_PDate').AsString;

    if FieldByName('P_PValue').AsString = '' then
      FListA.Values['FConsignmentTare']    := '0'
    else
      FListA.Values['FConsignmentTare']    := FieldByName('P_PValue').AsString;

    if FieldByName('D_NetWeight').AsString = '' then
      FListA.Values['FConsignmentNetWeight']    := '0'
    else
      FListA.Values['FConsignmentNetWeight']    := FieldByName('D_NetWeight').AsString;

    FListA.Values['FReceiveGrossWeightStatus']     := '1';
    FListA.Values['FReceiveGrossWeightPersonnel']  := FieldByName('P_MMan').AsString;
    FListA.Values['FReceiveGrossWeightTime']       := FieldByName('P_MDate').AsString;

    if FieldByName('P_MValue').AsString = '' then
      FListA.Values['FReceiveGrossWeight']    := '0'
    else
      FListA.Values['FReceiveGrossWeight']    := FieldByName('P_MValue').AsString;

    FListA.Values['FReceiveStatus']         := '1';
    FListA.Values['FReceivePersonnel']      := FieldByName('P_MMan').AsString;
    FListA.Values['FReceiveTime']           := nDate;

    FListA.Values['FReceiveTareStatus']            := '1';
    FListA.Values['FReceiveTarePersonnel']         := FieldByName('P_PMan').AsString;
    FListA.Values['FReceiveTareTime']              := FieldByName('P_PDate').AsString;

    if FieldByName('P_PValue').AsString = '' then
      FListA.Values['FReceiveTare']    := '0'
    else
      FListA.Values['FReceiveTare']    := FieldByName('P_PValue').AsString;

    if FieldByName('D_NetWeight').AsString = '' then
      FListA.Values['FReceiveNetWeight']    := '0'
    else
      FListA.Values['FReceiveNetWeight']    := FieldByName('D_NetWeight').AsString;

    FListA.Values['FCreator']               := FieldByName('P_PMan').AsString;
    FListA.Values['FCreateTime']            := nDate;
    FListA.Values['FConveyanceNumber']      := FieldByName('P_Truck').AsString;
    FListA.Values['FStatus']                := '254';
    if nDelete = sFlag_Yes then
    begin
      FListA.Values['FCancelStatus']        := '1';
      FListA.Values['FCancelPersonnel']     := FieldByName('P_PMan').AsString;
      FListA.Values['FCancelTime']          := nDate;
    end
    else
      FListA.Values['FCancelStatus']          := '0';

    FListA.Values['FDataStatus']            := '0';
  end;

  if FListA.Values['FTransferPlanNumber'] = '' then
  begin
    Result := '�ڵ�ԭ���ϲɹ�����[ %s ]��ǰ������Ϊ��.';
    Result := Format(Result, [nLID]);
    Exit;
  end;

  nSQL := 'FBillNumber = ''%s''';
  nSQL := Format(nSQL, [FListA.Values['FTransferPlanNumber']]);

  if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhNeiDaoOrderPlan
           ,PackerEncodeStr(nSQL),'',@nOut) then
  begin
    Result := '�ڵ�ԭ���ϲɹ�����[ %s ]��ȡ��ǰ����[ %s ]��Ϣʧ��.';
    Result := Format(Result, [nLID, FListA.Values['FTransferPlanNumber']]);
    Exit;
  end;

  FListC.Text := PackerDecodeStr(nOut.FData);

  try
    if nExits then//���ϴ�
    begin
      nJSInit := TlkJSONobject.Create();

      with nJSInit do//ԭʼ����
      begin
        Add('FBillID', FListB.Values['FBillID']);//�����ID
        Add('FBillNumber', FListA.Values['FBillID']);//�������
        Add('FBillTypeID', '49');
        Add('FCompanyID', FListB.Values['FCompanyID']);

        Add('FTransferPlanID', FListB.Values['FBillID']);
        Add('FYearPeriod', FListB.Values['FYearPeriod']);
        Add('FMaterielID', FListB.Values['FMaterielID']);
        Add('FValueID', FListB.Values['FValueID']);

        Add('FUnitID', FListB.Values['FUnitID']);
        Add('FUnitID_Auxiliary', FListB.Values['FUnitID_Auxiliary']);
        Add('FUnitIsFloat', FListB.Values['FUnitIsFloat']);
        Add('FUnitCoefficient', FListB.Values['FUnitCoefficient']);

        Add('FProducerID', FListB.Values['FProducerID']);
        Add('FFreightProviderID', FListB.Values['FFreightProviderID']);
        Add('FFreightContractDetailID', FListB.Values['FFreightContractDetailID']);
        Add('FConveyanceNumber', FListB.Values['FConveyanceNumber']);

        Add('FFreightPriceTax', FListB.Values['FFreightPriceTax']);
        Add('FFreightMoneyTax', FListB.Values['FFreightMoneyTax']);

        Add('FFreightInvoiceTypeID', FListB.Values['FFreightInvoiceTypeID']);
        Add('FFreightInvoiceClassID', FListB.Values['FFreightInvoiceClassID']);
        Add('FFreightTaxRate', FListB.Values['FFreightTaxRate']);

        Add('FFreightPrice', FListB.Values['FFreightPrice']);
        Add('FFreightMoney', FListB.Values['FFreightMoney']);

        Add('FFreightSettlementFashion', FListB.Values['FFreightSettlementFashion']);
        Add('FFreightSettlementStatus', FListB.Values['FFreightSettlementStatus']);//???
        Add('FWeightFashion', FListB.Values['FWeightFashion']);

        Add('FConsignmentDepartmentID', FListB.Values['FConsignmentDepartmentID']);
        Add('FConsignmentDepotID', FListB.Values['FConsignmentDepotID']);
        Add('FConsignmentGrossWeight', FListB.Values['FConsignmentGrossWeight']);
        Add('FConsignmentGrossWeight_Auxiliary', FListB.Values['FConsignmentGrossWeight']);
        Add('FConsignmentTare', FListB.Values['FConsignmentTare']);
        Add('FConsignmentTare_Auxiliary', FListB.Values['FConsignmentTare']);
        Add('FConsignmentNetWeight', FListB.Values['FConsignmentNetWeight']);
        Add('FConsignmentNetWeight_Auxiliary', FListB.Values['FConsignmentNetWeight']);
        Add('FConsignmentAgainWeightStatus', FListB.Values['FConsignmentAgainWeightStatus']);
        Add('FConsignmentGrossWeightStatus', FListB.Values['FConsignmentGrossWeightStatus']);
        Add('FConsignmentGrossWeightPersonnel', FListB.Values['FConsignmentGrossWeightPersonnel']);
        Add('FConsignmentGrossWeightTime', FListB.Values['FConsignmentGrossWeightTime']);
        Add('FConsignmentTareStatus', FListB.Values['FConsignmentTareStatus']);
        Add('FConsignmentTarePersonnel', FListB.Values['FConsignmentTarePersonnel']);
        Add('FConsignmentTareTime ', FListB.Values['FConsignmentTareTime']);
        Add('FConsignmentStatus', FListB.Values['FConsignmentStatus']);
        Add('FConsignmentPersonnel ', FListB.Values['FConsignmentPersonnel']);
        Add('FConsignmentTime', FListB.Values['FConsignmentTime']);

        Add('FReceiveDepartmentID', FListB.Values['FReceiveDepartmentID']);
        Add('FReceiveDepotID', FListB.Values['FReceiveDepotID']);
        Add('FReceiveGrossWeight', FListB.Values['FReceiveGrossWeight']);
        Add('FReceiveGrossWeight_Auxiliary', FListB.Values['FReceiveGrossWeight']);
        Add('FReceiveTare', FListB.Values['FReceiveTare']);
        Add('FReceiveTare_Auxiliary', FListB.Values['FReceiveTare']);
        Add('FReceiveNetWeight', FListB.Values['FReceiveNetWeight']);
        Add('FReceiveNetWeight_Auxiliary', FListB.Values['FReceiveNetWeight']);
        Add('FReceiveAgainWeightStatus', FListB.Values['FReceiveAgainWeightStatus']);
        Add('FReceiveGrossWeightStatus', FListB.Values['FReceiveGrossWeightStatus']);
        Add('FReceiveGrossWeightPersonnel', FListB.Values['FReceiveGrossWeightPersonnel']);
        Add('FReceiveGrossWeightTime', FListB.Values['FReceiveGrossWeightTime']);
        Add('FReceiveTareStatus', FListB.Values['FReceiveTareStatus']);
        Add('FReceiveTarePersonnel', FListB.Values['FReceiveTarePersonnel']);
        Add('FReceiveTareTime ', FListB.Values['FReceiveTareTime']);
        Add('FReceiveStatus', FListB.Values['FReceiveStatus']);
        Add('FReceivePersonnel ', FListB.Values['FReceivePersonnel']);
        Add('FReceiveTime', FListB.Values['FReceiveTime']);

        Add('FCancelStatus', FListB.Values['FCancelStatus']);
        Add('FCancelPersonnel', FListB.Values['FCancelPersonnel']);
        Add('FCancelTime', FListB.Values['FCancelTime']);
        Add('FCreator', FListB.Values['FCreator']);
        Add('FCreateTime', FListB.Values['FCreateTime']);

        Add('FRemark', FListB.Values['FRemark']);
        Add('FVer', FListB.Values['FVer']);
      end;

      nInit := TlkJSON.GenerateText(nJSInit);
      nInit := UTF8Decode(nInit);
      WriteLog('�ڵ�ԭ���ϲɹ����ϴ�ԭʼ����:' + nInit);

      nJSNew := TlkJSONobject.Create();

      with nJSNew do
      begin
        Add('FBillID', FListB.Values['FBillID']);//�����ID
        Add('FBillNumber', FListA.Values['FBillID']);//�������
        Add('FBillTypeID', '49');
        Add('FCompanyID', FListC.Values['FCompanyID']);

        Add('FTransferPlanID', FListC.Values['FBillID']);
        Add('FYearPeriod', FListC.Values['FYearPeriod']);
        Add('FMaterielID', FListC.Values['FMaterielID']);
        Add('FValueID', FListC.Values['FValueID']);

        Add('FUnitID', FListC.Values['FUnitID']);
        Add('FUnitID_Auxiliary', FListC.Values['FUnitID_Auxiliary']);
        Add('FUnitIsFloat', FListC.Values['FUnitIsFloat']);
        Add('FUnitCoefficient', FListC.Values['FUnitCoefficient']);

        Add('FProducerID', FListC.Values['FProducerID']);
        Add('FFreightProviderID', FListC.Values['FFreightProviderID']);
        Add('FFreightContractDetailID', FListC.Values['FFreightContractDetailID']);
        Add('FConveyanceNumber', FListA.Values['FConveyanceNumber']);

        Add('FFreightPriceTax', FListC.Values['FFreightPriceTax']);
        Add('FFreightMoneyTax', GetMoney(FListC.Values['FFreightPriceTax'],
                                    FListA.Values['FReceiveNetWeight']));

        Add('FFreightInvoiceTypeID', FListC.Values['FFreightInvoiceTypeID']);
        Add('FFreightInvoiceClassID', FListC.Values['FFreightInvoiceClassID']);
        Add('FFreightTaxRate', FListC.Values['FFreightTaxRate']);

        Add('FFreightPrice', FListC.Values['FFreightPrice']);
        Add('FFreightMoney', GetMoney(FListC.Values['FFreightPrice'],
                                    FListA.Values['FReceiveNetWeight']));

        Add('FFreightSettlementFashion', FListC.Values['FFreightSettlementFashion']);
        Add('FFreightSettlementStatus', '0');//???
        Add('FWeightFashion', FListC.Values['FWeightFashion']);

        Add('FConsignmentDepartmentID', FListC.Values['FConsignmentDepartmentID']);
        Add('FConsignmentDepotID', FListC.Values['FConsignmentDepotID']);
        Add('FConsignmentGrossWeight', FListA.Values['FConsignmentGrossWeight']);
        Add('FConsignmentGrossWeight_Auxiliary', FListA.Values['FConsignmentGrossWeight']);
        Add('FConsignmentTare', FListA.Values['FConsignmentTare']);
        Add('FConsignmentTare_Auxiliary', FListA.Values['FConsignmentTare']);
        Add('FConsignmentNetWeight', FListA.Values['FConsignmentNetWeight']);
        Add('FConsignmentNetWeight_Auxiliary', FListA.Values['FConsignmentNetWeight']);
        Add('FConsignmentAgainWeightStatus', '0');
        Add('FConsignmentGrossWeightStatus', FListA.Values['FConsignmentGrossWeightStatus']);
        Add('FConsignmentGrossWeightPersonnel', FListA.Values['FConsignmentGrossWeightPersonnel']);
        Add('FConsignmentGrossWeightTime', FListA.Values['FConsignmentGrossWeightTime']);
        Add('FConsignmentTareStatus', FListA.Values['FConsignmentTareStatus']);
        Add('FConsignmentTarePersonnel', FListA.Values['FConsignmentTarePersonnel']);
        Add('FConsignmentTareTime ', FListA.Values['FConsignmentTareTime']);
        Add('FConsignmentStatus', FListA.Values['FConsignmentStatus']);
        Add('FConsignmentPersonnel ', FListA.Values['FConsignmentPersonnel']);
        Add('FConsignmentTime', FListA.Values['FConsignmentTime']);

        Add('FReceiveDepartmentID', FListC.Values['FReceiveDepartmentID']);
        Add('FReceiveDepotID', FListC.Values['FReceiveDepotID']);
        Add('FReceiveGrossWeight', FListA.Values['FReceiveGrossWeight']);
        Add('FReceiveGrossWeight_Auxiliary', FListA.Values['FReceiveGrossWeight']);
        Add('FReceiveTare', FListA.Values['FReceiveTare']);
        Add('FReceiveTare_Auxiliary', FListA.Values['FReceiveTare']);
        Add('FReceiveNetWeight', FListA.Values['FReceiveNetWeight']);
        Add('FReceiveNetWeight_Auxiliary', FListA.Values['FReceiveNetWeight']);
        Add('FReceiveAgainWeightStatus', '0');
        Add('FReceiveGrossWeightStatus', FListA.Values['FReceiveGrossWeightStatus']);
        Add('FReceiveGrossWeightPersonnel', FListA.Values['FReceiveGrossWeightPersonnel']);
        Add('FReceiveGrossWeightTime', FListA.Values['FReceiveGrossWeightTime']);
        Add('FReceiveTareStatus', FListA.Values['FReceiveTareStatus']);
        Add('FReceiveTarePersonnel', FListA.Values['FReceiveTarePersonnel']);
        Add('FReceiveTareTime ', FListA.Values['FReceiveTareTime']);
        Add('FReceiveStatus', FListA.Values['FReceiveStatus']);
        Add('FReceivePersonnel ', FListA.Values['FReceivePersonnel']);
        Add('FReceiveTime', FListA.Values['FReceiveTime']);

        Add('FCancelStatus', FListA.Values['FCancelStatus']);
        Add('FCancelPersonnel', FListA.Values['FCancelPersonnel']);
        Add('FCancelTime', FListA.Values['FCancelTime']);
        Add('FCreator', FListA.Values['FCreator']);
        Add('FCreateTime', FListA.Values['FCreateTime']);

        Add('FRemark', FListC.Values['FRemark']);
        Add('FVer', FListC.Values['FVer']);
      end;
      nNewStr := TlkJSON.GenerateText(nJSNew);
      nNewStr := UTF8Decode(nNewStr);
      WriteLog('�ڵ�ԭ���ϲɹ����ϴ���ǰ����:' + nNewStr);
    end
    else
    begin
      if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhNdOrderDetailID,
           '','',@nOut) then
      begin
        Result := '[' + nLID + ']��ȡ�����ڵ�ԭ���ϲɹ���IDʧ��.';
        Exit;
      end;

      nStr := PackerDecodeStr(nOut.FData);
      nJSNew := TlkJSONobject.Create();

      with nJSNew do
      begin
        Add('FBillID', nStr);//�����ID
        Add('FBillNumber', FListA.Values['FBillID']);//�������
        Add('FBillTypeID', '49');
        Add('FCompanyID', FListC.Values['FCompanyID']);

        Add('FTransferPlanID', FListC.Values['FBillID']);
        Add('FYearPeriod', FListC.Values['FYearPeriod']);
        Add('FMaterielID', FListC.Values['FMaterielID']);
        Add('FValueID', FListC.Values['FValueID']);

        Add('FUnitID', FListC.Values['FUnitID']);
        Add('FUnitID_Auxiliary', FListC.Values['FUnitID_Auxiliary']);
        Add('FUnitIsFloat', FListC.Values['FUnitIsFloat']);
        Add('FUnitCoefficient', FListC.Values['FUnitCoefficient']);

        Add('FProducerID', FListC.Values['FProducerID']);
        Add('FFreightProviderID', FListC.Values['FFreightProviderID']);
        Add('FFreightContractDetailID', FListC.Values['FFreightContractDetailID']);
        Add('FConveyanceNumber', FListA.Values['FConveyanceNumber']);

        Add('FFreightPriceTax', FListC.Values['FFreightPriceTax']);
        Add('FFreightMoneyTax', GetMoney(FListC.Values['FFreightPriceTax'],
                                    FListA.Values['FReceiveNetWeight']));

        Add('FFreightInvoiceTypeID', FListC.Values['FFreightInvoiceTypeID']);
        Add('FFreightInvoiceClassID', FListC.Values['FFreightInvoiceClassID']);
        Add('FFreightTaxRate', FListC.Values['FFreightTaxRate']);

        Add('FFreightPrice', FListC.Values['FFreightPrice']);
        Add('FFreightMoney', GetMoney(FListC.Values['FFreightPrice'],
                                    FListA.Values['FReceiveNetWeight']));

        Add('FFreightSettlementFashion', FListC.Values['FFreightSettlementFashion']);
        Add('FFreightSettlementStatus', '0');//???
        Add('FWeightFashion', FListC.Values['FWeightFashion']);

        Add('FConsignmentDepartmentID', FListC.Values['FConsignmentDepartmentID']);
        Add('FConsignmentDepotID', FListC.Values['FConsignmentDepotID']);
        Add('FConsignmentGrossWeight', FListA.Values['FConsignmentGrossWeight']);
        Add('FConsignmentGrossWeight_Auxiliary', FListA.Values['FConsignmentGrossWeight']);
        Add('FConsignmentTare', FListA.Values['FConsignmentTare']);
        Add('FConsignmentTare_Auxiliary', FListA.Values['FConsignmentTare']);
        Add('FConsignmentNetWeight', FListA.Values['FConsignmentNetWeight']);
        Add('FConsignmentNetWeight_Auxiliary', FListA.Values['FConsignmentNetWeight']);
        Add('FConsignmentAgainWeightStatus', '0');
        Add('FConsignmentGrossWeightStatus', FListA.Values['FConsignmentGrossWeightStatus']);
        Add('FConsignmentGrossWeightPersonnel', FListA.Values['FConsignmentGrossWeightPersonnel']);
        Add('FConsignmentGrossWeightTime', FListA.Values['FConsignmentGrossWeightTime']);
        Add('FConsignmentTareStatus', FListA.Values['FConsignmentTareStatus']);
        Add('FConsignmentTarePersonnel', FListA.Values['FConsignmentTarePersonnel']);
        Add('FConsignmentTareTime ', FListA.Values['FConsignmentTareTime']);
        Add('FConsignmentStatus', FListA.Values['FConsignmentStatus']);
        Add('FConsignmentPersonnel ', FListA.Values['FConsignmentPersonnel']);
        Add('FConsignmentTime', FListA.Values['FConsignmentTime']);

        Add('FReceiveDepartmentID', FListC.Values['FReceiveDepartmentID']);
        Add('FReceiveDepotID', FListC.Values['FReceiveDepotID']);
        Add('FReceiveGrossWeight', FListA.Values['FReceiveGrossWeight']);
        Add('FReceiveGrossWeight_Auxiliary', FListA.Values['FReceiveGrossWeight']);
        Add('FReceiveTare', FListA.Values['FReceiveTare']);
        Add('FReceiveTare_Auxiliary', FListA.Values['FReceiveTare']);
        Add('FReceiveNetWeight', FListA.Values['FReceiveNetWeight']);
        Add('FReceiveNetWeight_Auxiliary', FListA.Values['FReceiveNetWeight']);
        Add('FReceiveAgainWeightStatus', '0');
        Add('FReceiveGrossWeightStatus', FListA.Values['FReceiveGrossWeightStatus']);
        Add('FReceiveGrossWeightPersonnel', FListA.Values['FReceiveGrossWeightPersonnel']);
        Add('FReceiveGrossWeightTime', FListA.Values['FReceiveGrossWeightTime']);
        Add('FReceiveTareStatus', FListA.Values['FReceiveTareStatus']);
        Add('FReceiveTarePersonnel', FListA.Values['FReceiveTarePersonnel']);
        Add('FReceiveTareTime ', FListA.Values['FReceiveTareTime']);
        Add('FReceiveStatus', FListA.Values['FReceiveStatus']);
        Add('FReceivePersonnel ', FListA.Values['FReceivePersonnel']);
        Add('FReceiveTime', FListA.Values['FReceiveTime']);

        Add('FCancelStatus', FListA.Values['FCancelStatus']);
        Add('FCancelPersonnel', FListA.Values['FCancelPersonnel']);
        Add('FCancelTime', FListA.Values['FCancelTime']);
        Add('FCreator', FListA.Values['FCreator']);
        Add('FCreateTime', FListA.Values['FCreateTime']);

        Add('FRemark', FListC.Values['FRemark']);
        Add('FVer', FListC.Values['FVer']);
      end;
      nNewStr := TlkJSON.GenerateText(nJSNew);
      nNewStr := UTF8Decode(nNewStr);
      WriteLog('�ڵ�ԭ���ϲɹ����ϴ���ǰ����:' + nNewStr);
    end;
  finally
    if Assigned(nJSInit) then
      nJSInit.Free;
    if Assigned(nJSNew) then
      nJSNew.Free;
  end;
end;

function TBusWorkerBusinessHHJY.IsHhOtherOrderDetailExits(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nNode, nRoot: TXmlNode;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';
  FListA.Clear;
  nStr := 'FBillNumber = ''%s''';
  nStr := Format(nStr,[PackerDecodeStr(FIn.FData)]);

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    WriteLog('��ѯ���ϴ���ʱ���زɹ������'+nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoT_SupplyWeighBill.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IT_SupplyWeighBill(nHHJYChannel^.FChannel).RetrieveList(nSoapHeader,
                                   nStr, '');

    WriteLog('��ѯ���ϴ���ʱ���زɹ�������'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ѯ���ϴ���ʱ���زɹ��������쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ѯ���ϴ���ʱ���زɹ��������쳣.Data�ڵ�Ϊ��';
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListA.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListA.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;
      end;
    end;
    nData := PackerEncodeStr(FListA.Text);

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetHhOtherOrderDetailID(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';
  FListE.Clear;

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    WriteLog('��ȡ������ʱ���زɹ���ID���'+nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoT_SupplyWeighBill.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IT_SupplyWeighBill(nHHJYChannel^.FChannel).InitializationModel(nSoapHeader);

    WriteLog('��ȡ������ʱ���زɹ���ID����'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ������ʱ���زɹ���ID�����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    nJsCol := nJS.Field['Data'] as TlkJSONobject;

    nStr := VarToStr(nJSCol.Field['FBillID'].Value);

    if nStr = '' then
    begin
      nData := '��ȡ������ʱ���زɹ���ID�ӿڵ����쳣.Data�ڵ�FBillIDΪ��';
      Exit;
    end;

    nData := PackerEncodeStr(nStr);

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.SyncHhOtherOrderDetail(
  var nData: string): boolean;
var nStr, nUrl: string;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
    nExits: Boolean;
    nInitStr, nNewStr: string;
begin
  Result := False;
  nExits := False;
  nUrl := '';
  FListD.Text := PackerDecodeStr(FIn.FData);

  WriteLog('ͬ����ʱ���زɹ���׼���������:' + FListD.Text);

  nData := GetOtherOrderDetailJSonString(FListD.Values['ID'], FListD.Values['Delete'], nExits,
                                    nInitStr, nNewStr);
  if nData <> '' then
  begin
    WriteLog('ͬ����ʱ���زɹ���׼�����ݽ��:' + nData);
    Exit;
  end;

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    WriteLog('ͬ����ʱ���زɹ������'+FListD.Text);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoT_SupplyWeighBill.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel

    if nExits then
    begin
      nStr := IT_SupplyWeighBill(nHHJYChannel^.FChannel).Update(nSoapHeader,
                                     nInitStr, nNewStr);
    end
    else
    begin
      nStr := IT_SupplyWeighBill(nHHJYChannel^.FChannel).Insert(nSoapHeader,
                                     nNewStr);
    end;

    WriteLog('ͬ����ʱ���زɹ�������'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := 'ͬ����ʱ���زɹ��������쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    nStr :='update %s set P_BDAX=''1'',P_BDNUM=P_BDNUM+1 where P_ID = ''%s'' ';
    nStr := Format(nStr,[sTable_PoundLog,FListD.Values['ID']]);

    gDBConnManager.WorkerExec(FDBConn,nStr);

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetOtherOrderDetailJSonString(const nLID, nDelete: string;
 var nExits: Boolean; var nInit, nNewStr: string): string;
var nStr, nSQL, nUrl, nDate: string;
    nInt, nIdx: Integer;
    nJSInit, nJSNew: TlkJSONobject;
    nOut: TWorkerBusinessCommand;
    nPDate, nMDate: TDateTime;
    nCompany, nVer: string;
begin
  Result := '';
  FListA.Clear;
  FListB.Clear;
  FListC.Clear;

  nSQL := 'Select D_ParamB,D_Desc From %s Where D_Name=''%s'' and D_Memo=''%s'' ';
  nSQL := Format(nSQL, [sTable_SysDict, sFlag_SysParam, sFlag_FactoryName]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  begin
    if RecordCount < 1 then
    begin
      Result := '������Ϊ[ %s ]�Ĺ�˾ID���汾�Ų�����.';
      Result := Format(Result, [nLID]);
      Exit;
    end;
    nCompany := Fields[0].AsString;
    nVer := Fields[1].AsString;
  end;

  nExits := TBusWorkerBusinessHHJY.CallMe(cBC_IsHhOtherOrderDetailExits
           ,PackerEncodeStr(nLID),'',@nOut);
  if nExits then
    FListB.Text := PackerDecodeStr(nOut.FData);


  nSQL := 'select *,(P_MValue-P_PValue - isnull(P_KZValue,0)) as D_NetWeight From %s a,'+
  ' %s b where a.R_ID=b.P_OrderBak and b.P_ID = ''%s'' ';

  nSQL := Format(nSQL,[sTable_CardOther,sTable_PoundLog,nLID]);
  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  begin
    if RecordCount < 1 then
    begin
      Result := '������Ϊ[ %s ]�Ĳɹ�����������.';
      Result := Format(Result, [nLID]);
      Exit;
    end;

    FListA.Clear;

    FListA.Values['FBillID']                := FieldByName('P_ID').AsString;
    FListA.Values['FBillNumber']            := FieldByName('P_ID').AsString;
    FListA.Values['FPoundID']               := FieldByName('P_ID').AsString;
    FListA.Values['FAuditID']               := FieldByName('P_ID').AsString;

    FListA.Values['FFirstWeighStatus']      := '1';
    FListA.Values['FFirstWeighPersonnel']   := FieldByName('P_MMan').AsString;
    FListA.Values['FFirstWeighTime']        := FieldByName('P_MDate').AsString;
    if FieldByName('P_MValue').AsString = '' then
      FListA.Values['FGrossWeight']    := '0'
    else
      FListA.Values['FGrossWeight']    := FieldByName('P_MValue').AsString;

    FListA.Values['FSecondWeighStatus']     := '1';
    FListA.Values['FSecondWeighPersonnel']  := FieldByName('P_PMan').AsString;
    FListA.Values['FSecondWeighTime']       := FieldByName('P_PDate').AsString;
    if FieldByName('P_PValue').AsString = '' then
      FListA.Values['FTare']    := '0'
    else
      FListA.Values['FTare']    := FieldByName('P_PValue').AsString;

    if FieldByName('D_NetWeight').AsString = '' then
      FListA.Values['FNetWeight']    := '0'
    else
      FListA.Values['FNetWeight']    := FieldByName('D_NetWeight').AsString;

    FListA.Values['FCreator']               := FieldByName('O_Man').AsString;
    FListA.Values['FCreateTime']            := FieldByName('O_Date').AsString;

    FListA.Values['FConveryanceNumber']     := FieldByName('P_Truck').AsString;
    FListA.Values['FCompanyID']             := nCompany;
    FListA.Values['FVer']                   := nVer;
    FListA.Values['FReamrk']                := '';
    FListA.Values['FStatus']                := '254';
    FListA.Values['FWeighTimes']            := '2';
    FListA.Values['FMaterielName']          := FieldByName('P_MName').AsString;

    FListA.Values['FConsignmentCompanyName']:= FieldByName('P_CusName').AsString;
    FListA.Values['FReceiveCompanyName']    := FieldByName('O_RevName').AsString;
  end;

  try
    if nExits then//���ϴ�
    begin
      nJSInit := TlkJSONobject.Create();

      with nJSInit do//ԭʼ����
      begin
        Add('FBillID', FListB.Values['FBillID']);//�����ID
        Add('FBillNumber', FListA.Values['FBillID']);//�������
        Add('FBillTypeID', '3011');
        Add('FCompanyID', FListB.Values['FCompanyID']);
        Add('FMaterielName', FListB.Values['FMaterielName']);
        Add('FConveryanceNumber', FListB.Values['FConveryanceNumber']);
        Add('FConsignmentCompanyName', FListB.Values['FConsignmentCompanyName']);
        Add('FReceiveCompanyName', FListB.Values['FReceiveCompanyName']);
        Add('FWeighTimes', FListB.Values['FWeighTimes']);
        Add('FWeighMoney', FListB.Values['FWeighMoney']);
        Add('FGrossWeight', FListB.Values['FGrossWeight']);
        Add('FTare', FListB.Values['FTare']);
        Add('FNetWeight', FListB.Values['FNetWeight']);
        Add('FFirstWeighStatus', FListB.Values['FFirstWeighStatus']);
        Add('FFirstWeighPersonnel', FListB.Values['FFirstWeighPersonnel']);
        Add('FFirstWeighTime', FListB.Values['FFirstWeighTime']);
        Add('FSecondWeighStatus', FListB.Values['FSecondWeighStatus']);
        Add('FSecondWeighPersonnel', FListB.Values['FSecondWeighPersonnel']);
        Add('FSecondWeighTime', FListB.Values['FSecondWeighTime']);

        Add('FStatus', FListB.Values['FStatus']);
        Add('FCreator', FListB.Values['FCreator']);
        Add('FCreateTime', FListB.Values['FCreateTime']);
        Add('FVer', FListB.Values['FVer']);
      end;

      nInit := TlkJSON.GenerateText(nJSInit);
      nInit := UTF8Decode(nInit);
      WriteLog('��ʱ���زɹ����ϴ�ԭʼ����:' + nInit);

      nJSNew := TlkJSONobject.Create();

      with nJSNew do
      begin
        Add('FBillID', FListB.Values['FBillID']);//�����ID
        Add('FBillNumber', FListA.Values['FBillID']);//�������
        Add('FBillTypeID', '3011');
        Add('FCompanyID', FListA.Values['FCompanyID']);
        Add('FMaterielName', FListA.Values['FMaterielName']);
        Add('FConveryanceNumber', FListA.Values['FConveryanceNumber']);
        Add('FConsignmentCompanyName', FListA.Values['FConsignmentCompanyName']);
        Add('FReceiveCompanyName', FListA.Values['FReceiveCompanyName']);
        Add('FWeighTimes', FListA.Values['FWeighTimes']);
        Add('FWeighMoney', '0');
        Add('FGrossWeight', FListA.Values['FGrossWeight']);
        Add('FTare', FListA.Values['FTare']);
        Add('FNetWeight', FListA.Values['FNetWeight']);
        Add('FFirstWeighStatus', FListA.Values['FFirstWeighStatus']);
        Add('FFirstWeighPersonnel', FListA.Values['FFirstWeighPersonnel']);
        Add('FFirstWeighTime', FListA.Values['FFirstWeighTime']);
        Add('FSecondWeighStatus', FListA.Values['FSecondWeighStatus']);
        Add('FSecondWeighPersonnel', FListA.Values['FSecondWeighPersonnel']);
        Add('FSecondWeighTime', FListA.Values['FSecondWeighTime']);

        Add('FStatus', FListA.Values['FStatus']);
        Add('FCreator', FListA.Values['FCreator']);
        Add('FCreateTime', FListA.Values['FCreateTime']);
        Add('FVer', FListA.Values['FVer']);
      end;
      nNewStr := TlkJSON.GenerateText(nJSNew);
      nNewStr := UTF8Decode(nNewStr);
      WriteLog('��ʱ���زɹ����ϴ���ǰ����:' + nNewStr);
    end
    else
    begin
      if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhOtherOrderDetailID,
           '','',@nOut) then
      begin
        Result := '[' + nLID + ']��ȡ������ʱ���زɹ���IDʧ��.';
        Exit;
      end;

      nStr := PackerDecodeStr(nOut.FData);
      nJSNew := TlkJSONobject.Create();

      with nJSNew do
      begin
        Add('FBillID', nStr);//�����ID
        Add('FBillNumber', FListA.Values['FBillID']);//�������
        Add('FBillTypeID', '3011');
        Add('FCompanyID', FListA.Values['FCompanyID']);
        Add('FMaterielName', FListA.Values['FMaterielName']);
        Add('FConveryanceNumber', FListA.Values['FConveryanceNumber']);
        Add('FConsignmentCompanyName', FListA.Values['FConsignmentCompanyName']);
        Add('FReceiveCompanyName', FListA.Values['FReceiveCompanyName']);
        Add('FWeighTimes', FListA.Values['FWeighTimes']);
        Add('FWeighMoney', '0');
        Add('FGrossWeight', FListA.Values['FGrossWeight']);
        Add('FTare', FListA.Values['FTare']);
        Add('FNetWeight', FListA.Values['FNetWeight']);
        Add('FFirstWeighStatus', FListA.Values['FFirstWeighStatus']);
        Add('FFirstWeighPersonnel', FListA.Values['FFirstWeighPersonnel']);
        Add('FFirstWeighTime', FListA.Values['FFirstWeighTime']);
        Add('FSecondWeighStatus', FListA.Values['FSecondWeighStatus']);
        Add('FSecondWeighPersonnel', FListA.Values['FSecondWeighPersonnel']);
        Add('FSecondWeighTime', FListA.Values['FSecondWeighTime']);

        Add('FStatus', FListA.Values['FStatus']);
        Add('FCreator', FListA.Values['FCreator']);
        Add('FCreateTime', FListA.Values['FCreateTime']);
        Add('FVer', FListA.Values['FVer']);
      end;
      nNewStr := TlkJSON.GenerateText(nJSNew);
      nNewStr := UTF8Decode(nNewStr);
      WriteLog('��ʱ���زɹ����ϴ���ǰ����:' + nNewStr);
    end;
  finally
    if Assigned(nJSInit) then
      nJSInit.Free;
    if Assigned(nJSNew) then
      nJSNew.Free;
  end;
end;

function TBusWorkerBusinessHHJY.NewHhWTDetail(
  var nData: string): boolean;
var nStr, nUrl, nWTID, nWTNo: string;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS, nJSNew: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  nUrl := '';
  FListD.Text := PackerDecodeStr(FIn.FData);

  WriteLog('�����ɳ�����ϸ���:' + FListD.Text);

  nStr := 'FBillCode = ''%s''';
  nStr := Format(nStr, [FListD.Values['FConsignPlanNumber']]);

  if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhSalePlan
           ,PackerEncodeStr(nStr),'',@nOut) then
  begin
    nData := '��ȡ��ǰ����[ %s ]��Ϣʧ��.';
    nData := Format(nData, [FListD.Values['FConsignPlanNumber']]);
    Exit;
  end;

  FListA.Text := PackerDecodeStr(nOut.FData);

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoT_SaleScheduleVan.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel

    WriteLog('��ȡ�����ɳ���ID���');

    nStr := IT_SaleScheduleVan(nHHJYChannel^.FChannel).InitializationModel(nSoapHeader);

    WriteLog('��ȡ�����ɳ���ID����'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ�����ɳ���ID�����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    nJsCol := nJS.Field['Data'] as TlkJSONobject;

    nWTID := VarToStr(nJSCol.Field['FBillID'].Value);
    nWTNo := VarToStr(nJSCol.Field['FBillCode'].Value);
    if (nWTID = '') or (nWTNo = '') then
    begin
      nData := '��ȡ�����ɳ���ID�ӿڵ����쳣.Data�ڵ�FBillID��FBillCodeΪ��';
      Exit;
    end;

    nJSNew := TlkJSONobject.Create();

    with nJSNew do
    begin
      Add('FBillID', nWTID);//�ɳ���ID
      Add('FBillCode', nWTNo);//�ɳ�����
      Add('FBillTypeID', '105');
      Add('FConsignPlanID', FListA.Values['FBillID']);
      Add('FConsignPlanCode', FListA.Values['FBillCode']);

      Add('FDeptID', FListA.Values['FDepartmentID']);
      Add('FSaleManID', FListA.Values['FSaleManID']);
      Add('FCustomerID', FListA.Values['FCustomerID']);
      Add('FMaterielID', FListA.Values['FMaterielID']);
      Add('FPackingID', FListA.Values['FPackingID']);

      Add('FOrgBillCode', FListA.Values['FOrgBillCode']);
      Add('FTransportation', FListD.Values['Truck']);
      Add('FTransportTypeID', '1');
      Add('FLinkMan', '');
      Add('FMobilephone', '');

      Add('FBeginDate', FormatDateTime('YYYY-MM-DD HH:MM:SS', Now));
      Add('FEndDate', FormatDateTime('YYYY-MM-DD HH:MM:SS', IncDay(Now, 1)));
      Add('FVerifyCode', '');
      Add('FAmount', FListD.Values['Value']);
      Add('FIsLimit', '1');
      Add('FCount', '1');
      Add('FUsedCount', '0');

      Add('FCreator', FIn.FBase.FFrom.FUser);
      Add('FCreateTime', FormatDateTime('YYYY-MM-DD HH:MM:SS', Now));
      Add('FMender', '');
      //Add('FModifyTime', '');
      Add('FDeleteMan', '');
      //Add('FDeleteTime', '');
      Add('FAssessor', FIn.FBase.FFrom.FUser);
      Add('FAuditingTime', FormatDateTime('YYYY-MM-DD HH:MM:SS', Now));

      Add('FAppTypeID', '2');
      Add('FStatus', '0');
      Add('FAuditingSign', '1');
      Add('FIsDelete', '0');
      Add('FRemark', '');
      Add('FVer', FListA.Values['FVer']);
    end;
    nStr := TlkJSON.GenerateText(nJSNew);
    nStr := UTF8Decode(nStr);

    WriteLog('�����ɳ������:' + nStr);

    nStr := IT_SaleScheduleVan(nHHJYChannel^.FChannel).Insert(nSoapHeader,
                                   nStr);

    WriteLog('�����ɳ�������'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '�����ɳ��������쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    nData := nWTID;
    
    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    if Assigned(nJSNew) then
      nJSNew.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.SaveHhHYData(
  var nData: string): boolean;
var nStr, nMID, nDate, nHYDan, nHhcStr: string;
    nOut: TWorkerBusinessCommand;
    nIdx: Integer;
begin
  Result := False;

  FListA.Clear;

  FListA.Text := PackerDecodeStr(FIn.FData);
  nMID   := FListA.Values['StockID'];
  nDate  := FListA.Values['Date'];
  nHYDan := FListA.Values['HYDan'];

  FListA.Clear;

  //1
  if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhHyHxDetail
           ,nHYDan,'',@nOut) then
  begin
    nData := '���κ�[ %s ]��ȡ���鵥��ѧ��������ʧ��.';
    nData := Format(nData, [nHYDan]);
    Exit;
  end;
  FListA.Text := PackerDecodeStr(nOut.FData);//ALL

  //2
  if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhHyWlDetail
           ,nHYDan,'',@nOut) then
  begin
    nData := '���κ�[ %s ]��ȡ���鵥��������ܼ�¼����ʧ��.';
    nData := Format(nData, [nHYDan]);
    Exit;
  end;

  FListB.Clear;
  FListB.Text := PackerDecodeStr(nOut.FData);

  FListA.Values['WlRecord'] := FListB.Values['FRecordID'];//����������

  //2.1
  if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhHyWlBZCD
           ,FListA.Values['WlRecord'],'',@nOut) then
  begin
    nData := '���κ�[ %s ]��ȡ���鵥���������׼�������ʧ��.';
    nData := Format(nData, [nHYDan]);
    Exit;
  end;

  FListB.Clear;
  FListB.Text := PackerDecodeStr(nOut.FData);

  FListA.Values['FWRONC'] := FListB.Values['FWRONC'];//��׼���

  //2.2
  if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhHyWlNjTime
           ,FListA.Values['WlRecord'],'',@nOut) then
  begin
    nData := '���κ�[ %s ]��ȡ���鵥�����������ʱ������ʧ��.';
    nData := Format(nData, [nHYDan]);
    Exit;
  end;

  FListB.Clear;
  FListB.Text := PackerDecodeStr(nOut.FData);

  FListA.Values['FInitialSetResult'] := FListB.Values['FInitialSetResult'];//����ʱ��
  FListA.Values['FFinalSetResult'] := FListB.Values['FFinalSetResult'];//����ʱ��

  //2.3
  if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhHyWlXD
           ,FListA.Values['WlRecord'],'',@nOut) then
  begin
    nData := '���κ�[ %s ]��ȡ���鵥�������ϸ������ʧ��.';
    nData := Format(nData, [nHYDan]);
    Exit;
  end;

  FListB.Clear;
  FListB.Text := PackerDecodeStr(nOut.FData);

  FListA.Values['FXDResult'] := FListB.Values['FResult'];//ϸ��

  //2.3
  if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhHyWlBiBiao
           ,FListA.Values['WlRecord'],'',@nOut) then
  begin
    nData := '���κ�[ %s ]��ȡ���鵥��������ȱ��������ʧ��.';
    nData := Format(nData, [nHYDan]);
    Exit;
  end;

  FListB.Clear;
  FListB.Text := PackerDecodeStr(nOut.FData);

  FListA.Values['FSampleDensity'] := FListB.Values['FSampleDensity'];//�ܶ�
  FListA.Values['FSpecificSurfaceAreaAverage']
                                  := FListB.Values['FSpecificSurfaceAreaAverage'];//�ȱ����

  //2.4
  if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhHyWlQD
           ,FListA.Values['WlRecord'],'',@nOut) then
  begin
    nData := '���κ�[ %s ]��ȡ���鵥�������ǿ������ʧ��.';
    nData := Format(nData, [nHYDan]);
    Exit;
  end;

  FListB.Clear;
  FListB.Text := PackerDecodeStr(nOut.FData);

  FListA.Values['FFluidityAverage'] := FListB.Values['FFluidityAverage'];//������

  FListA.Values['FRuptureStrength3D1'] := FListB.Values['FRuptureStrength3D1'];//3�쿹��
  FListA.Values['FRuptureStrength3D2'] := FListB.Values['FRuptureStrength3D2'];
  FListA.Values['FRuptureStrength3D3'] := FListB.Values['FRuptureStrength3D3'];
  FListA.Values['FRuptureStrength3DAverage'] := FListB.Values['FRuptureStrength3DAverage'];

  FListA.Values['FRuptureStrength28D1'] := FListB.Values['FRuptureStrength28D1'];//28�쿹��
  FListA.Values['FRuptureStrength28D2'] := FListB.Values['FRuptureStrength28D2'];
  FListA.Values['FRuptureStrength28D3'] := FListB.Values['FRuptureStrength28D3'];
  FListA.Values['FRuptureStrength28DAverage'] := FListB.Values['FRuptureStrength28DAverage'];

  FListA.Values['FCompressiveStrength3D1'] := FListB.Values['FCompressiveStrength3D1'];//3�쿹ѹ
  FListA.Values['FCompressiveStrength3D2'] := FListB.Values['FCompressiveStrength3D2'];
  FListA.Values['FCompressiveStrength3D3'] := FListB.Values['FCompressiveStrength3D3'];
  FListA.Values['FCompressiveStrength3D4'] := FListB.Values['FCompressiveStrength3D4'];
  FListA.Values['FCompressiveStrength3D5'] := FListB.Values['FCompressiveStrength3D5'];
  FListA.Values['FCompressiveStrength3D6'] := FListB.Values['FCompressiveStrength3D6'];
  FListA.Values['FCompressiveStrength3DAverage'] := FListB.Values['FCompressiveStrength3DAverage'];

  FListA.Values['FCompressiveStrength28D1'] := FListB.Values['FCompressiveStrength28D1'];//3�쿹ѹ
  FListA.Values['FCompressiveStrength28D2'] := FListB.Values['FCompressiveStrength28D2'];
  FListA.Values['FCompressiveStrength28D3'] := FListB.Values['FCompressiveStrength28D3'];
  FListA.Values['FCompressiveStrength28D4'] := FListB.Values['FCompressiveStrength28D4'];
  FListA.Values['FCompressiveStrength28D5'] := FListB.Values['FCompressiveStrength28D5'];
  FListA.Values['FCompressiveStrength28D6'] := FListB.Values['FCompressiveStrength28D6'];
  FListA.Values['FCompressiveStrength28DAverage'] := FListB.Values['FCompressiveStrength28DAverage'];

  //3
  if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhHyHhcDetail
           ,nHYDan,'',@nOut) then
  begin
    nData := '���κ�[ %s ]��ȡ���鵥��ϲ��ܼ�¼����ʧ��.';
    nData := Format(nData, [nHYDan]);
    Exit;
  end;

  FListB.Clear;
  FListB.Text := PackerDecodeStr(nOut.FData);

  FListA.Values['HhcRecord'] := FListB.Values['FRecordID'];//��ϲĽ������

  //3.1
  if not TBusWorkerBusinessHHJY.CallMe(cBC_GetHhHyHhcRecord
           ,FListA.Values['HhcRecord'],'',@nOut) then
  begin
    nData := '���κ�[ %s ]��ȡ���鵥��ϲ���ϸ����ʧ��.';
    nData := Format(nData, [nHYDan]);
    Exit;
  end;
  nHhcStr := nOut.FData;

  FListB.Clear;
  FListC.Clear;


  nStr := SF('R_SerialNo', nHYDan);
  nStr := MakeSQLByStr([
          SF('R_SGType', ''),
          SF('R_SGValue', ''),
          SF('R_HHCType', ''),
          SF('R_HHCValue', ''),
          SF('R_MgO', FListA.Values['FMgO']),
          SF('R_SO3', FListA.Values['FSO3']),
          SF('R_ShaoShi', FListA.Values['FLOSS']),
          SF('R_CL', FListA.Values['FCL_Ion']),
          SF('R_BiBiao', FListA.Values['FSpecificSurfaceAreaAverage']),
          SF('R_ChuNing', FListA.Values['FInitialSetResult']),
          SF('R_ZhongNing', FListA.Values['FFinalSetResult']),
          SF('R_AnDing', ''),
          SF('R_XiDu', FListA.Values['FXDResult']),
          SF('R_MIDu', FListA.Values['FSampleDensity']),
          SF('R_Jian', FListA.Values['FR2O']),
          SF('R_ChouDu', FListA.Values['FWRONC']),
          SF('R_BuRong', ''),
          SF('R_YLiGai', FListA.Values['FF_CaO']),
          SF('R_FC3A', FListA.Values['FC3A']),
          SF('R_Water', ''),
          SF('R_KuangWu', ''),
          SF('R_GaiGui', ''),
          SF('R_Liudong', FListA.Values['FFluidityAverage']),
          SF('R_3DZhe1', FListA.Values['FRuptureStrength3D1']),
          SF('R_3DZhe2', FListA.Values['FRuptureStrength3D2']),
          SF('R_3DZhe3', FListA.Values['FRuptureStrength3D3']),
          SF('R_28Zhe1', FListA.Values['FRuptureStrength28D1']),
          SF('R_28Zhe2', FListA.Values['FRuptureStrength28D2']),
          SF('R_28Zhe3', FListA.Values['FRuptureStrength28D3']),
          SF('R_3DZheAve', FListA.Values['FRuptureStrength3DAverage']),
          SF('R_28DZheAve', FListA.Values['FRuptureStrength28DAverage']),
          SF('R_3DYa1', FListA.Values['FCompressiveStrength3D1']),
          SF('R_3DYa2', FListA.Values['FCompressiveStrength3D2']),
          SF('R_3DYa3', FListA.Values['FCompressiveStrength3D3']),
          SF('R_3DYa4', FListA.Values['FCompressiveStrength3D4']),
          SF('R_3DYa5', FListA.Values['FCompressiveStrength3D5']),
          SF('R_3DYa6', FListA.Values['FCompressiveStrength3D6']),
          SF('R_28Ya1', FListA.Values['FCompressiveStrength28D1']),
          SF('R_28Ya2', FListA.Values['FCompressiveStrength28D2']),
          SF('R_28Ya3', FListA.Values['FCompressiveStrength28D3']),
          SF('R_28Ya4', FListA.Values['FCompressiveStrength28D4']),
          SF('R_28Ya5', FListA.Values['FCompressiveStrength28D5']),
          SF('R_28Ya6', FListA.Values['FCompressiveStrength28D6']),
          SF('R_3DYaAve', FListA.Values['FCompressiveStrength3DAverage']),
          SF('R_28DYaAve', FListA.Values['FCompressiveStrength28DAverage']),
          SF('R_Date', StrToDateDef(FListA.Values['FTestTime'],Now),sfDateTime),
          SF('R_Man', FListA.Values['FTester'])
          ], sTable_StockRecord, nStr, False);
  FListB.Add(nStr);

  nStr := MakeSQLByStr([SF('R_SerialNo', nHYDan),
          SF('R_SGType', ''),
          SF('R_SGValue', ''),
          SF('R_HHCType', ''),
          SF('R_HHCValue', ''),
          SF('R_MgO', FListA.Values['FMgO']),
          SF('R_SO3', FListA.Values['FSO3']),
          SF('R_ShaoShi', FListA.Values['FLOSS']),
          SF('R_CL', FListA.Values['FCL_Ion']),
          SF('R_BiBiao', FListA.Values['FSpecificSurfaceAreaAverage']),
          SF('R_ChuNing', FListA.Values['FInitialSetResult']),
          SF('R_ZhongNing', FListA.Values['FFinalSetResult']),
          SF('R_AnDing', ''),
          SF('R_XiDu', FListA.Values['FXDResult']),
          SF('R_MIDu', FListA.Values['FSampleDensity']),
          SF('R_Jian', FListA.Values['FR2O']),
          SF('R_ChouDu', FListA.Values['FWRONC']),
          SF('R_BuRong', ''),
          SF('R_YLiGai', FListA.Values['FF_CaO']),
          SF('R_FC3A', FListA.Values['FC3A']),
          SF('R_Water', ''),
          SF('R_KuangWu', ''),
          SF('R_GaiGui', ''),
          SF('R_Liudong', FListA.Values['FFluidityAverage']),
          SF('R_3DZhe1', FListA.Values['FRuptureStrength3D1']),
          SF('R_3DZhe2', FListA.Values['FRuptureStrength3D2']),
          SF('R_3DZhe3', FListA.Values['FRuptureStrength3D3']),
          SF('R_28Zhe1', FListA.Values['FRuptureStrength28D1']),
          SF('R_28Zhe2', FListA.Values['FRuptureStrength28D2']),
          SF('R_28Zhe3', FListA.Values['FRuptureStrength28D3']),
          SF('R_3DZheAve', FListA.Values['FRuptureStrength3DAverage']),
          SF('R_28DZheAve', FListA.Values['FRuptureStrength28DAverage']),
          SF('R_3DYa1', FListA.Values['FCompressiveStrength3D1']),
          SF('R_3DYa2', FListA.Values['FCompressiveStrength3D2']),
          SF('R_3DYa3', FListA.Values['FCompressiveStrength3D3']),
          SF('R_3DYa4', FListA.Values['FCompressiveStrength3D4']),
          SF('R_3DYa5', FListA.Values['FCompressiveStrength3D5']),
          SF('R_3DYa6', FListA.Values['FCompressiveStrength3D6']),
          SF('R_28Ya1', FListA.Values['FCompressiveStrength28D1']),
          SF('R_28Ya2', FListA.Values['FCompressiveStrength28D2']),
          SF('R_28Ya3', FListA.Values['FCompressiveStrength28D3']),
          SF('R_28Ya4', FListA.Values['FCompressiveStrength28D4']),
          SF('R_28Ya5', FListA.Values['FCompressiveStrength28D5']),
          SF('R_28Ya6', FListA.Values['FCompressiveStrength28D6']),
          SF('R_3DYaAve', FListA.Values['FCompressiveStrength3DAverage']),
          SF('R_28DYaAve', FListA.Values['FCompressiveStrength28DAverage']),
          SF('R_Date', StrToDateDef(FListA.Values['FTestTime'],Now),sfDateTime),
          SF('R_Man', FListA.Values['FTester'])
          ], sTable_StockRecord, '', True);
  FListC.Add(nStr);

  if FListB.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;

    for nIdx:=0 to FListB.Count - 1 do
    begin
      if gDBConnManager.WorkerExec(FDBConn,FListB[nIdx]) <= 0 then
      begin
        gDBConnManager.WorkerExec(FDBConn, FListC[nIdx]);
      end;
    end;

    if nHhcStr <> '' then
    begin
      nStr := 'Update %s Set %s where R_SerialNo =''%s''';
      nStr := Format(nStr, [sTable_StockRecord, nHhcStr, nHYDan]);
      WriteLog('��ϵ�����Sql:' + nStr);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;

    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;

  Result := True;
  FOut.FData := nData;
  FOut.FBase.FResult := True;
end;

function TBusWorkerBusinessHHJY.GetHhHYHxDetail(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nNode, nRoot: TXmlNode;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    nStr := 'FTestSampleCode = ''%s'' ';
    nStr := Format(nStr, [FIn.FData]);

    WriteLog('��ȡ���鵥��ѧ�������:' + nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoV_QChemistryTestBill.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IV_QChemistryTestBill(nHHJYChannel^.FChannel).RetrieveList(nSoapHeader,
                                  nStr, '');

    WriteLog('��ȡ���鵥��ѧ��������'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ���鵥��ѧ���������쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ȡ���鵥��ѧ���������쳣.Data�ڵ�Ϊ��';
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListB.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListB.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;
        nData := PackerEncodeStr(FListB.Text);
      end;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetHhHYWlDetail(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nNode, nRoot: TXmlNode;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    nStr := 'FTestSampleCode = ''%s'' ';
    nStr := Format(nStr, [FIn.FData]);

    WriteLog('��ȡ���鵥����������:' + nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoV_QPhysicsRecord.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IV_QPhysicsRecord(nHHJYChannel^.FChannel).RetrieveList(nSoapHeader,
                                  nStr, '');

    WriteLog('��ȡ���鵥�����������'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ���鵥������������쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ȡ���鵥������������쳣.Data�ڵ�Ϊ��';
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListB.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListB.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;
        nData := PackerEncodeStr(FListB.Text);
      end;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetHhHYWlBZCD(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nNode, nRoot: TXmlNode;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    nStr := 'FRecordID = ''%s'' ';
    nStr := Format(nStr, [FIn.FData]);

    WriteLog('��ȡ���鵥���������׼������:' + nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoV_QPhysicsWRONCRecord.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IV_QPhysicsWRONCRecord(nHHJYChannel^.FChannel).RetrieveList(nSoapHeader,
                                  nStr, '');

    WriteLog('��ȡ���鵥���������׼��ȳ���'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ���鵥���������׼��ȵ����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ȡ���鵥���������׼��ȵ����쳣.Data�ڵ�Ϊ��';
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListB.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListB.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;
        nData := PackerEncodeStr(FListB.Text);
      end;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetHhHYWlNjTime(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nNode, nRoot: TXmlNode;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    nStr := 'FRecordID = ''%s'' ';
    nStr := Format(nStr, [FIn.FData]);

    WriteLog('��ȡ���鵥�����������ʱ�����:' + nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoV_QPhysicsSettingTimeRecord.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IV_QPhysicsSettingTimeRecord(nHHJYChannel^.FChannel).RetrieveList(nSoapHeader,
                                  nStr, '');

    WriteLog('��ȡ���鵥�����������ʱ�����'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ���鵥�����������ʱ������쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ȡ���鵥�����������ʱ������쳣.Data�ڵ�Ϊ��';
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListB.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListB.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;
        nData := PackerEncodeStr(FListB.Text);
      end;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetHhHYWlXD(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nNode, nRoot: TXmlNode;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    nStr := 'FRecordID = ''%s'' ';
    nStr := Format(nStr, [FIn.FData]);

    WriteLog('��ȡ���鵥�������ϸ�����:' + nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoV_QPhysicsFinenessRecord.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IV_QPhysicsFinenessRecord(nHHJYChannel^.FChannel).RetrieveList(nSoapHeader,
                                  nStr, '');

    WriteLog('��ȡ���鵥�������ϸ�ȳ���'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ���鵥�������ϸ�ȵ����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ȡ���鵥�������ϸ�ȵ����쳣.Data�ڵ�Ϊ��';
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListB.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListB.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;
        nData := PackerEncodeStr(FListB.Text);
      end;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetHhHYWlBiBiao(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nNode, nRoot: TXmlNode;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    nStr := 'FRecordID = ''%s'' ';
    nStr := Format(nStr, [FIn.FData]);

    WriteLog('��ȡ���鵥��������ȱ�������:' + nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoV_QPhysicsSpecificSurfaceAreaRecord.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IV_QPhysicsSpecificSurfaceAreaRecord(nHHJYChannel^.FChannel).RetrieveList(nSoapHeader,
                                  nStr, '');

    WriteLog('��ȡ���鵥��������ȱ��������'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ���鵥��������ȱ���������쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ȡ���鵥��������ȱ���������쳣.Data�ڵ�Ϊ��';
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListB.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListB.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;
        nData := PackerEncodeStr(FListB.Text);
      end;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetHhHYWlQD(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nNode, nRoot: TXmlNode;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    nStr := 'FRecordID = ''%s'' ';
    nStr := Format(nStr, [FIn.FData]);

    WriteLog('��ȡ���鵥�������ǿ�����:' + nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoV_QPhysicsSpecificSurfaceAreaRecord.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IV_QPhysicsSpecificSurfaceAreaRecord(nHHJYChannel^.FChannel).RetrieveList(nSoapHeader,
                                  nStr, '');

    WriteLog('��ȡ���鵥�������ǿ�ȳ���'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ���鵥�������ǿ�ȵ����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ȡ���鵥�������ǿ�ȵ����쳣.Data�ڵ�Ϊ��';
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListB.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListB.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;
        nData := PackerEncodeStr(FListB.Text);
      end;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetHhHYHhcDetail(
  var nData: string): Boolean;
var nStr, nUrl: string;
    nNode, nRoot: TXmlNode;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    nStr := 'FTestSampleCode = ''%s'' ';
    nStr := Format(nStr, [FIn.FData]);

    WriteLog('��ȡ���鵥��ϲ����:' + nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoQAdmixtureDataBrief_WS.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IQAdmixtureDataBrief_WS(nHHJYChannel^.FChannel).RetrieveList(nSoapHeader,
                                  nStr, '');

    WriteLog('��ȡ���鵥��ϲĳ���'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ���鵥��ϲĵ����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ȡ���鵥��ϲĵ����쳣.Data�ڵ�Ϊ��';
        Exit;
      end;

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListB.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListB.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;
        nData := PackerEncodeStr(FListB.Text);
      end;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetHhHYHhcRecord(
  var nData: string): Boolean;
var nStr, nUrl, nUpDate: string;
    nNode, nRoot: TXmlNode;
    nInt, nIdx: Integer;
    nSoapHeader: MySoapHeader;
    nJS: TlkJSONobject;
    nJSRow: TlkJSONlist;
    nJSCol: TlkJSONobject;
    nHHJYChannel: PChannelItem;
begin
  Result := False;
  nUrl := '';

  nSoapHeader := MySoapHeader.Create;

  try
    for nInt := Low(gSysParam.FHHJYUrl) to High(gSysParam.FHHJYUrl) do
    with gSysParam.FHHJYUrl[nInt] do
    begin
      if FIn.FCommand = FCID then
      begin
        nSoapHeader.Password := FPassword;
        nUrl := FURL;
        Break;
      end;
    end;

    nStr := 'FRecordID = ''%s'' ';
    nStr := Format(nStr, [FIn.FData]);

    WriteLog('��ȡ���鵥��ϲ���ϸ���:' + nStr);

    nHHJYChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(nHHJYChannel) then
    begin
      nData := '���Ӻ�Ӿ�Զ����ʧ��(HHJY Web Service No Channel).';
      Exit;
    end;

    with nHHJYChannel^ do
    begin
      if Assigned(FChannel) then
        FChannel := nil;

      FChannel := CoQAdmixtureDataDetail_WS.Create(FMsg, FHttp);
      FHttp.TargetUrl := nUrl;
    end; //config web service channel


    nStr := IQAdmixtureDataDetail_WS(nHHJYChannel^.FChannel).RetrieveList(nSoapHeader,
                                  nStr, '');

    WriteLog('��ȡ���鵥��ϲ���ϸ����'+nStr);

    nStr := UTF8Encode(nStr);
    nJS := TlkJSON.ParseText(nStr) as TlkJSONobject;

    nStr := VarToStr(nJS.Field['IsSuccess'].Value);

    if Pos('TRUE', UpperCase(VarToStr(nJS.Field['IsSuccess'].Value))) <= 0 then
    begin
      nData := '��ȡ���鵥��ϲ���ϸ�����쳣.' + VarToStr(nJS.Field['Message'].Value);
      WriteLog(nData);
      Exit;
    end;

    if nJS.Field['Data'] is TlkJSONlist then
    begin
      nJSRow := nJS.Field['Data'] as TlkJSONlist;

      if nJSRow.Count <= 0 then
      begin
        nData := '��ȡ���鵥��ϲ���ϸ�����쳣.Data�ڵ�Ϊ��';
        Exit;
      end;

      FListB.Clear;
      nUpDate := '';

      for nIdx := 0 to nJSRow.Count - 1 do
      begin
        FListC.Clear;
        nJSCol:= nJSRow.Child[nIdx] as TlkJSONobject;

        for nInt := 0 to nJSCol.Count - 1 do
        begin
          FListC.Values[nJSCol.NameOf[nInt]] := VarToStr(nJSCol.Field[nJSCol.NameOf[nInt]].Value);
        end;

        if FListC.Values['FMaterielNumber'] = '' then
          Continue;

        nStr := 'Select D_Value From %s ' +
                'Where D_Name=''%s'' And D_Memo=''%s''';
        nStr := Format(nStr, [sTable_SysDict, sFlag_HhcField,
                              FListC.Values['FMaterielNumber']]);

        with gDBConnManager.WorkerQuery(FDBConn, nStr) do
        if RecordCount > 0 then
        begin
          nStr := '%s=''%s'',';
          nStr := Format(nStr,[Fields[0].AsString,FListC.Values['FPercent']]);
          nUpDate := nUpDate + nStr;
        end;
      end;
      nData := '';
      if nUpDate <> '' then
      begin
        if Copy(nUpDate, Length(nUpDate), 1) = ',' then
          System.Delete(nUpDate, Length(nUpDate), 1);
        nData := nUpDate;
      end;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    gChannelManager.ReleaseChannel(nHHJYChannel);
    if Assigned(nJS) then
      nJS.Free;
    nSoapHeader.Free;
  end;
end;

function TBusWorkerBusinessHHJY.GetCusName(nCusID: string): string;
var nStr: string;
begin
  Result := '';
  nStr := 'Select C_Name From %s Where C_ID=''%s'' ';
  nStr := Format(nStr, [sTable_Customer, nCusID]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsString;
  end;
end;

initialization
  gBusinessWorkerManager.RegisteWorker(TBusWorkerBusinessHHJY, sPlug_ModuleBus);
end.
