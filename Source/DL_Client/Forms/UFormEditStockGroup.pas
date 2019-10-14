unit UFormEditStockGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels, UFormBase,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinsdxLCPainter, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, StdCtrls, dxLayoutControl;

type
  TfFormEditStockGroup = class(TfFormNormal)
    dxlytmLayout1Item3: TdxLayoutItem;
    lbl1: TLabel;
    dxlytmLayout1Item31: TdxLayoutItem;
    cbb_Group: TcxComboBox;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FID, FStockNo,FStockName:string;
  public
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormEditStockGroup: TfFormEditStockGroup;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun,UMgrControl, USysBusiness, USmallFunc, USysConst, USysDB,
  UDataModule, UAdjustForm;


class function TfFormEditStockGroup.FormID: integer;
begin
  Result := cFI_FormEditStockGroup;
end;

class function TfFormEditStockGroup.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP : PFormCommandParam;
begin
  Result := nil;

  if not Assigned(nParam) then
  begin
    New(nP);
    FillChar(nP^, SizeOf(TFormCommandParam), #0);
  end
  else nP := nParam;

  with TfFormEditStockGroup.Create(Application) do
  try
    begin
      FStockNo  := nP.FParamB;
      FStockName:= nP.FParamA;
      FID       := nP.FParamC;

      lbl1.Caption:= 'Ʒ�����ƣ�'+ nP.FParamA;
      LoadStockGroup(cbb_Group.Properties.Items);
      //xxxxx

      nP.FCommand:= ShowModal;
      nP.FParamA := ModalResult;
    end;
  finally
    Free;
  end;
end;

procedure TfFormEditStockGroup.BtnOKClick(Sender: TObject);
var nGno, nStockName, nSql, nStr : string;
begin
  if Trim(cbb_Group.Text)='' then
  begin
    nStr := 'ȷ������[ %s ]��������Ϊ�޷���ô?';
    nStr := Format(nStr, [ FStockName ]);
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nGno   := GetCtrlData(cbb_Group);
  if nGno='' then nGno:= 'Null';
  try
    nSql := 'UPDate %s Set D_ParamA=%s Where D_ID=%s And D_ParamB=''%s'' ';
    nSql := Format(nSql, [sTable_sysdict, nGno, FID, FStockNo]);

    FDM.ExecuteSQL(nSql);
    ModalResult := mrOk;
    ShowMsg('�����ɹ�', '��ʾ');
  except
    ShowMsg('����ʧ��', '��ʾ');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormEditStockGroup, TfFormEditStockGroup.FormID);

end.
