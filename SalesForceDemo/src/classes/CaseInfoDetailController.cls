public without sharing class CaseInfoDetailController {

  	// 検索条件を宣言する
   	public CaseInfoService caseInfoService{ get;set; }
    
    //案件基本情報
    public CaseBaseInfo__c caseBaseInfo{get; set;}
    
    /**
     * 初期化処理
     */
    public void init(){
        this.caseInfoService = new CaseInfoService();
        String selectedCaseId = ApexPages.currentPage().getParameters().get('selectedCaseId');
        caseBaseInfo = caseInfoService.getCaseInfoById(selectedCaseId);
    }
}