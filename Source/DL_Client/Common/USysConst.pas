{*******************************************************************************
  ����: dmzn@ylsoft.com 2007-10-09
  ����: ��Ŀͨ�ó�,�������嵥Ԫ
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, ComCtrls;

const
  cSBar_Date            = 0;                         //�����������
  cSBar_Time            = 1;                         //ʱ���������
  cSBar_User            = 2;                         //�û��������
  cRecMenuMax           = 5;                         //���ʹ�õ����������Ŀ��
  cItemIconIndex        = 11;                        //Ĭ�ϵ�������б�ͼ��

const
  {*Frame ID*}
  cFI_FrameSysLog       = $0001;                     //ϵͳ��־
  cFI_FrameViewLog      = $0002;                     //������־
  cFI_FrameAuthorize    = $0003;                     //ϵͳ��Ȩ

  cFI_FrameCustomer     = $0010;                     //�ͻ�����
  cFI_FrameSalesMan     = $0011;                     //ҵ��Ա
  cFI_FrameMakeCard     = $0012;                     //����ſ�
  cFI_FrameBill         = $0013;                     //�������
  cFI_FrameBillPost     = $0015;                     //�ֶ�����
  cFI_FrameSaleOrderOther = $0016;                   //��ʱ���۶���

  cFI_FrameLadingDai    = $0030;                     //��װ���
  cFI_FramePoundQuery   = $0031;                     //������ѯ
  cFI_FrameFangHuiQuery = $0032;                     //�ŻҲ�ѯ
  cFI_FrameZhanTaiQuery = $0033;                     //ջ̨��ѯ
  cFI_FrameZTDispatch   = $0034;                     //ջ̨����
  cFI_FramePoundManual  = $0035;                     //�ֶ�����
  cFI_FramePoundAuto    = $0036;                     //�Զ�����

  cFI_FrameStock        = $0042;                     //Ʒ�ֹ���
  cFI_FrameStockRecord  = $0043;                     //�����¼
  cFI_FrameStockHuaYan  = $0045;                     //�����鵥
  cFI_FrameStockHY_Each = $0046;                     //�泵����
  cFI_FrameBatch        = $0047;                     //���ι���
  cFI_FrameBatchRecord  = $0048;                     //���λص�

  cFI_FrameTruckQuery   = $0050;                     //������ѯ
  cFI_FrameDispatchQuery = $0051;                    //���Ȳ�ѯ
  cFI_FrameSaleTotalQuery  = $0052;                  //�ۼƷ���
  cFI_FrameSaleDetailQuery = $0053;                  //������ϸ
  cFI_FrameOrderDetailQuery = $0057;                 //�ɹ���ϸ

  cFI_FrameProvider     = $0061;                     //��Ӧ
  cFI_FrameMaterails    = $0062;                     //ԭ����
  cFI_FrameMakeOCard    = $0064;                     //����ɹ��ſ�
  cFI_FrameOrder        = $0107;                     //�ɹ�����
  cFI_FrameOrderDetail  = $0109;                     //�ɹ���ϸ
  cFI_FrameQPoundTemp   = $1112;                      //��ʱ����
  CFI_FormMakeCardOther = $1113;                     //��ʱ����ҵ��
  cFI_FormGetPOrderBase = $1156;                     //�ɹ�����
  cFI_FormPurchase      = $1155;                     //�ɹ�����
  CFI_FormSearchCard    = $1157;                     //�ſ���ѯ

  cFI_FramePurchasePlan = $1158;                     //�ɹ���������
  cFI_FormPurchasePlan  = $1159;                     //�ɹ���������


  cFI_FrameTrucks       = $0070;                     //��������
  cFI_FrameUnloading    = $0071;                     //ж���ص�
  cFI_FrameTodo         = $0072;                     //�������¼�
  cFI_FrameWXAccount    = $0073;                     //΢���˻�
  cFI_FrameWXSendLog    = $0074;                     //������־
  cFI_FramePoundQueryOther=$0075;                    //��ɽ���˰�����ѯ

  cFI_FrameTruckXz      = $0076;                     //�������ع���
  cFI_FrameStockGroup   = $0077;                     //����Ʒ�ַ���
  cFI_FormStockGroup    = $0078;                     //����Ʒ�ַ���
  cFI_FrameSalePlan     = $0079;                     //���������ƻ�
  cFI_FormSalePlan      = $0080;                     //���������ƻ�
  cFI_FormEditStockGroup= $0081;                     //Ʒ�ַ���༭
  cFI_FormSalePlanDtl   = $0082;                     //�ͻ���Ʒ�ַ���������ϸ


  cFI_FormMemo          = $1000;                     //��ע����
  cFI_FormBackup        = $1001;                     //���ݱ���
  cFI_FormRestore       = $1002;                     //���ݻָ�
  cFI_FormIncInfo       = $1003;                     //��˾��Ϣ
  cFI_FormChangePwd     = $1005;                     //�޸�����
  cFI_FormOptions       = $1006;                     //����ѡ��
  cFI_FormOutOverTime   = $1007;                     //������ʱ

  cFI_FormBaseInfo      = $1017;                     //������Ϣ
  cFI_FormCustomer      = $1018;                     //�ͻ�����
  cFI_FormSaleMan       = $1009;                     //ҵ��Ա
  cFI_FormBill          = $1020;                     //�������
  cFI_FormTruckIn       = $1021;                     //��������
  cFI_FormTruckOut      = $1022;                     //��������
  cFI_FormVerifyCard    = $1023;                     //�ſ���֤
  cFI_FormAutoBFP       = $1024;                     //�Զ���Ƥ
  cFI_FormBangFangP     = $1025;                     //����Ƥ��
  cFI_FormBangFangM     = $1026;                     //����ë��
  cFI_FormLadDai        = $1027;                     //��װ���
  cFI_FormLadSan        = $1028;                     //ɢװ���
  cFI_FormJiShuQi       = $1029;                     //��������
  cFI_FormBFWuCha       = $1030;                     //�������
  cFI_FormBuDan         = $1032;                     //���۲���
  cFI_FormSaleOrderOther= $1033;                     //��ʱ���۶���

  cFI_FormMakeCard      = $1040;                     //����ſ�
  cFI_FormMakeRFIDCard  = $1041;                     //������ӱ�ǩ
  cFI_FormMakeLSCard    = $1042;                     //�������۰쿨
  cFI_FormSaleAdjust    = $1043;                     //���۵���
  cFI_FormTruckEmpty    = $1044;                     //�ճ�����
  cFI_FormReadCard      = $1045;                     //��ȡ�ſ�
  cFI_FormZTLine        = $1046;                     //װ����

  cFI_FormGetZhika      = $1050;                     //ѡ��ֽ��
  cFI_FormGetTruck      = $1051;                     //ѡ����
  cFI_FormGetContract   = $1052;                     //ѡ���ͬ
  cFI_FormGetCustom     = $1053;                     //ѡ��ͻ�
  cFI_FormGetStockNo    = $1054;                     //ѡ����
  cFI_FormGetUnloading  = $1055;                     //ж���ص�
  cFI_FormProvider      = $1056;                     //��Ӧ��
  cFI_FormMaterails     = $1057;                     //ԭ����
  cFI_FormGetWXAccount  = $1058;                     //��ȡ�̳�ע����Ϣ
  cFI_FormGetWTTruck    = $1059;                     //��ȡί�г���

  cFI_FormBatch         = $1060;                     //���ι���
  cFI_FormStockParam    = $1061;                     //Ʒ�ֹ���
  cFI_FormStockHuaYan   = $1062;                     //�����鵥
  cFI_FormStockHY_Each  = $1062;                     //�泵����

  cFI_FormTrucks        = $1070;                     //��������
  cFI_FormAuthorize     = $1071;                     //��ȫ��֤
  cFI_FormWXAccount     = $1072;                     //΢���˻�
  cFI_FormWXSendlog     = $1073;                     //΢����־
  cFI_FormTodo          = $1074;                     //���Ԥ�¼�
  cFI_FormTodoSend      = $1075;                     //�����¼�

  cFI_FormOrder         = $1083;                     //�ɹ�����
  cFI_FormModifyStock   = $1084;                     //�޸�����
  cFI_FormPoundKw       = $1085;                     //��������
  cFI_FormPoundKwOther  = $1086;                     //��������(��ʱ����)
  cFI_FormSaleKw        = $1087;                     //���ۿ���
  cFI_FormSaleModifyStock = $1088;                   //�����޸�����
  cFI_FormSaleKwOther   = $1089;                     //���ۿ���(����ҵ��)
  cFI_FormSaleBuDanOther= $1090;                     //���۲���(����ҵ��)

  cFI_FormTruckXz       = $1091;                     //�������ع���

  cFI_FormSealInfo      = $1096;                     //������Ϣ¼��
  {*Command*}
  cCmd_RefreshData      = $0002;                     //ˢ������
  cCmd_ViewSysLog       = $0003;                     //ϵͳ��־

  cCmd_ModalResult      = $1001;                     //Modal����
  cCmd_FormClose        = $1002;                     //�رմ���
  cCmd_AddData          = $1003;                     //�������
  cCmd_EditData         = $1005;                     //�޸�����
  cCmd_ViewData         = $1006;                     //�鿴����
  cCmd_GetData          = $1007;                     //ѡ������

  cSendWeChatMsgType_AddBill=1; //�������
  cSendWeChatMsgType_OutFactory=2; //��������
  cSendWeChatMsgType_Report=3; //����
  cSendWeChatMsgType_DelBill=4; //ɾ�����

  c_WeChatStatusCreateCard=0;  //�����Ѱ쿨
  c_WeChatStatusFinished=1;  //���������
  c_WeChatStatusDeleted=2;  //������ɾ��

type
  TSysParam = record
    FProgID     : string;                            //�����ʶ
    FAppTitle   : string;                            //�����������ʾ
    FMainTitle  : string;                            //���������
    FHintText   : string;                            //��ʾ�ı�
    FCopyRight  : string;                            //��������ʾ����

    FUserID     : string;                            //�û���ʶ
    FUserName   : string;                            //��ǰ�û�
    FUserPwd    : string;                            //�û�����
    FGroupID    : string;                            //������
    FIsAdmin    : Boolean;                           //�Ƿ����Ա
    FIsNormal   : Boolean;                           //�ʻ��Ƿ�����

    FRecMenuMax : integer;                           //����������
    FIconFile   : string;                            //ͼ�������ļ�
    FUsesBackDB : Boolean;                           //ʹ�ñ��ݿ�

    FLocalIP    : string;                            //����IP
    FLocalMAC   : string;                            //����MAC
    FLocalName  : string;                            //��������
    FMITServURL : string;                            //ҵ�����
    FHardMonURL : string;                            //Ӳ���ػ�
    FWechatURL  : string;                            //΢�ŷ���
    FHHJYURL    : string;                            //��Ӿ�Զ���ݷ���

    FFactNum    : string;                            //�������
    FSerialID   : string;                            //���Ա��
    FDepartment : string;                            //��������
    FIsManual   : Boolean;                           //�ֶ�����
    FAutoPound  : Boolean;                           //�Զ�����

    FPoundDaiZ  : Double;
    FPoundDaiZ_1: Double;                            //��װ�����
    FPoundDaiF  : Double;
    FPoundDaiF_1: Double;                            //��װ�����
    FDaiPercent : Boolean;                           //����������ƫ��
    FDaiWCStop  : Boolean;                           //�������װƫ��
    FPoundSanF  : Double;                            //ɢװ�����
    FTruckPWuCha: Double;                            //�ճ�Ƥ���
    FPicBase    : Integer;                           //ͼƬ����
    FPicPath    : string;                            //ͼƬĿ¼
    FVoiceUser  : Integer;                           //��������
    FProberUser : Integer;                           //���������
    FEmpTruckWc : Double;                            //�ճ��������

    FPrinterBill: string;                            //СƱ��ӡ��
    FPrinterHYDan : string;                          //���鵥��ӡ�� 
  end;
  //ϵͳ����

  TModuleItemType = (mtFrame, mtForm);
  //ģ������

  PMenuModuleItem = ^TMenuModuleItem;
  TMenuModuleItem = record
    FMenuID: string;                                 //�˵�����
    FModule: integer;                                //ģ���ʶ
    FItemType: TModuleItemType;                      //ģ������
  end;

//------------------------------------------------------------------------------
var
  gPath: string;                                     //��������·��
  gSysParam:TSysParam;                               //���򻷾�����
  gStatusBar: TStatusBar;                            //ȫ��ʹ��״̬��
  gMenuModule: TList = nil;                          //�˵�ģ��ӳ���

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //Ĭ�ϱ�ʶ
  sAppTitle           = 'DMZN';                      //�������
  sMainCaption        = 'DMZN';                      //�����ڱ���

  sHint               = '��ʾ';                      //�Ի������
  sWarn               = '����';                      //==
  sAsk                = 'ѯ��';                      //ѯ�ʶԻ���
  sError              = 'δ֪����';                  //����Ի���

  sDate               = '����:��%s��';               //����������
  sTime               = 'ʱ��:��%s��';               //������ʱ��
  sUser               = '�û�:��%s��';               //�������û�

  sLogDir             = 'Logs\';                     //��־Ŀ¼
  sLogExt             = '.log';                      //��־��չ��
  sLogField           = #9;                          //��¼�ָ���

  sImageDir           = 'Images\';                   //ͼƬĿ¼
  sReportDir          = 'Report\';                   //����Ŀ¼
  sBackupDir          = 'Backup\';                   //����Ŀ¼
  sBackupFile         = 'Bacup.idx';                 //��������
  sCameraDir          = 'Camera\';                   //ץ��Ŀ¼

  sConfigFile         = 'Config.Ini';                //�������ļ�
  sConfigSec          = 'Config';                    //������С��
  sVerifyCode         = ';Verify:';                  //У������

  sFormConfig         = 'FormInfo.ini';              //��������
  sSetupSec           = 'Setup';                     //����С��
  sDBConfig           = 'DBConn.ini';                //��������
  sDBConfig_bk        = 'isbk';                      //���ݿ�

  sExportExt          = '.txt';                      //����Ĭ����չ��
  sExportFilter       = '�ı�(*.txt)|*.txt|�����ļ�(*.*)|*.*';
                                                     //������������ 

  sInvalidConfig      = '�����ļ���Ч���Ѿ���';    //�����ļ���Ч
  sCloseQuery         = 'ȷ��Ҫ�˳�������?';         //�������˳�

implementation

//------------------------------------------------------------------------------
//Desc: ��Ӳ˵�ģ��ӳ����
procedure AddMenuModuleItem(const nMenu: string; const nModule: Integer;
 const nType: TModuleItemType = mtFrame);
var nItem: PMenuModuleItem;
begin
  New(nItem);
  gMenuModule.Add(nItem);

  nItem.FMenuID := nMenu;
  nItem.FModule := nModule;
  nItem.FItemType := nType;
end;

//Desc: �˵�ģ��ӳ���
procedure InitMenuModuleList;
begin
  gMenuModule := TList.Create;

  AddMenuModuleItem('MAIN_A01', cFI_FormIncInfo, mtForm);
  AddMenuModuleItem('MAIN_A02', cFI_FrameSysLog);
  AddMenuModuleItem('MAIN_A03', cFI_FormBackup, mtForm);
  AddMenuModuleItem('MAIN_A04', cFI_FormRestore, mtForm);
  AddMenuModuleItem('MAIN_A05', cFI_FormChangePwd, mtForm);
  AddMenuModuleItem('MAIN_A06', cFI_FormOptions, mtForm);
  AddMenuModuleItem('MAIN_A07', cFI_FrameAuthorize);
  AddMenuModuleItem('MAIN_A08', cFI_FormTodo, mtForm);
  AddMenuModuleItem('MAIN_A09', cFI_FrameTodo);
  AddMenuModuleItem('MAIN_A10', cFI_FormOutOverTime, mtForm);

  AddMenuModuleItem('MAIN_B01', cFI_FormBaseInfo, mtForm);
  AddMenuModuleItem('MAIN_B02', cFI_FrameCustomer);
  AddMenuModuleItem('MAIN_B03', cFI_FrameSalesMan);
  AddMenuModuleItem('MAIN_B04', cFI_FrameTrucks);
  AddMenuModuleItem('MAIN_B05', cFI_FrameUnloading);
  AddMenuModuleItem('MAIN_B06', CFI_FormSearchCard, mtForm);
  AddMenuModuleItem('MAIN_B07', cFI_FrameTruckXz);

  AddMenuModuleItem('MAIN_D02', cFI_FrameMakeCard);
  AddMenuModuleItem('MAIN_D03', cFI_FormBill, mtForm);
  AddMenuModuleItem('MAIN_D04', cFI_FormBill, mtForm);
  AddMenuModuleItem('MAIN_D06', cFI_FrameBill);
  AddMenuModuleItem('MAIN_D08', cFI_FormTruckEmpty, mtForm);
  AddMenuModuleItem('MAIN_D10', cFI_FrameBillPost);
  AddMenuModuleItem('MAIN_D11', cFI_FrameSaleOrderOther);

  AddMenuModuleItem('MAIN_D12', cFI_FrameStockGroup);
  AddMenuModuleItem('MAIN_D13', cFI_FormStockGroup, mtForm);
  AddMenuModuleItem('MAIN_D14', cFI_FrameSalePlan);
  AddMenuModuleItem('MAIN_D15', cFI_FormSalePlan, mtForm);

  AddMenuModuleItem('MAIN_E01', cFI_FramePoundManual);
  AddMenuModuleItem('MAIN_E02', cFI_FramePoundAuto);
  AddMenuModuleItem('MAIN_E03', cFI_FramePoundQuery);

  AddMenuModuleItem('MAIN_F01', cFI_FormLadDai, mtForm);
  AddMenuModuleItem('MAIN_F03', cFI_FrameZhanTaiQuery);
  AddMenuModuleItem('MAIN_F04', cFI_FrameZTDispatch);
  AddMenuModuleItem('MAIN_F05', cFI_FormPurchase,mtForm);
  AddMenuModuleItem('MAIN_F06', cFI_FormSealInfo, mtForm);
  
  AddMenuModuleItem('MAIN_G01', cFI_FormLadSan, mtForm);
  AddMenuModuleItem('MAIN_G02', cFI_FrameFangHuiQuery);

  AddMenuModuleItem('MAIN_K01', cFI_FrameStock);
  AddMenuModuleItem('MAIN_K02', cFI_FrameStockRecord);
  AddMenuModuleItem('MAIN_K03', cFI_FrameStockHuaYan);
  AddMenuModuleItem('MAIN_K04', cFI_FormStockHuaYan, mtForm);
  AddMenuModuleItem('MAIN_K05', cFI_FormStockHY_Each, mtForm);
  AddMenuModuleItem('MAIN_K06', cFI_FrameBatchRecord);
  AddMenuModuleItem('MAIN_K07', cFI_FrameBatch);
  AddMenuModuleItem('MAIN_K08', cFI_FormBatch, mtForm);

  AddMenuModuleItem('MAIN_L01', cFI_FrameTruckQuery);
  AddMenuModuleItem('MAIN_L05', cFI_FrameDispatchQuery);
  AddMenuModuleItem('MAIN_L06', cFI_FrameSaleDetailQuery);
  AddMenuModuleItem('MAIN_L07', cFI_FrameSaleTotalQuery);
  AddMenuModuleItem('MAIN_L10', cFI_FrameOrderDetailQuery);
  AddMenuModuleItem('MAIN_L11', cFI_FramePoundQueryOther);

  AddMenuModuleItem('MAIN_H01', cFI_FormTruckIn, mtForm);
  AddMenuModuleItem('MAIN_H02', cFI_FormTruckOut, mtForm);
  AddMenuModuleItem('MAIN_H03', cFI_FrameTruckQuery);

  AddMenuModuleItem('MAIN_J01', cFI_FrameTrucks);

  AddMenuModuleItem('MAIN_M01', cFI_FrameProvider);
  AddMenuModuleItem('MAIN_M02', cFI_FrameMaterails);
  AddMenuModuleItem('MAIN_M03', cFI_FrameMakeOCard); 
  AddMenuModuleItem('MAIN_M04', cFI_FrameOrder);
  AddMenuModuleItem('MAIN_M08', cFI_FrameOrderDetail);
  AddMenuModuleItem('MAIN_M13', cFI_FrameQPoundTemp);

  AddMenuModuleItem('MAIN_M14', cFI_FramePurchasePlan);
  AddMenuModuleItem('MAIN_M15', cFI_FormPurchasePlan, mtForm);


  AddMenuModuleItem('MAIN_W01', cFI_FrameWXAccount);
  AddMenuModuleItem('MAIN_W02', cFI_FrameWXSendLog);
end;

//Desc: ����ģ���б�
procedure ClearMenuModuleList;
var nIdx: integer;
begin
  for nIdx:=gMenuModule.Count - 1 downto 0 do
  begin
    Dispose(PMenuModuleItem(gMenuModule[nIdx]));
    gMenuModule.Delete(nIdx);
  end;

  FreeAndNil(gMenuModule);
end;

initialization
  InitMenuModuleList;
finalization
  ClearMenuModuleList;
end.


