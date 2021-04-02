Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50849352522
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 03:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhDBBdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 21:33:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33978 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbhDBBdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 21:33:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1321W1kZ009888;
        Fri, 2 Apr 2021 01:32:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=loDUW8sWl+KyDRD60wmhRxXhecJPMSrqFNBuZsnGxXk=;
 b=Xj9EoPbPw6JZvUCE4LeeDI6aJMblteSBZrIh6wk7AP2EhGtoiK138l5/H2fv2z0XfPD+
 /D9kE6HmPH5IzxODI6o5eGE2g6F/UKfbKP8tSRoPImsbclCRd057dpxv7BQBeOGnQhgg
 6AdGgaxgsXGiCpBRx7Oc7jR+84wdT8hFAO/gE95inwB2/W+7PJmV0oeh8LJCAKbMQEv3
 StRiuOfdeaDxh2PtXCgLuVrXWmzhc9rTQ+pFKW0W+8bL8iIQa+z18RK8mum5l7FzJMsm
 9gmk9oKMKjMTIwNh+hvD7MY5WuDLsoktepxIrurtk+qWZbrc57OjlErKCai4M2bkKwTe QQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37n2akkk5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 01:32:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1321TkIq150731;
        Fri, 2 Apr 2021 01:32:55 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3030.oracle.com with ESMTP id 37n2at0196-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 01:32:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/KEqFFVz3OnOjJRABsqAx4Ndlww0TZ7bhkLIdDwvvLANCAgzyr3vsJpxTTJMZcc4nOYDkifJZSNrZk01eZjS2U0C+zd+hMdozfTepjI7neH3+Abf/7BoAAzGkUEWbhmYPYuEUwsreNcGGCdq0DFjIve06i5HsM/2AaDDdkpAbaspWfyRxFjKwUEizN+B8uVpSn7zXynK5kRqjJA00HsRuId43NSX84Vve2Si4Y/XuhGITauFLoL1oABtUYronmVRvd832lmxaEFyU7MCOPwkQoUmIgyJ5oQQNh0EK6yE++2a1HNlGGmLBWX3LZi1dI1lJu14nh2fB2lXq1tPJQd4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loDUW8sWl+KyDRD60wmhRxXhecJPMSrqFNBuZsnGxXk=;
 b=Ir31EPt+klErjeLYLNwig2zt/JGdDW4Z84Y0JgJV2I5C1RcO03FiqaOXMrk0D1iDSPS3hguBIjro9Ab7PR2B1stBTenTIMwDZ/DQqbvN5HAeiLdatK4/7PLk9PI7yMlFVujH+XjG1FI51on6BXEmk4asP3JqcOk7QKQUOWV30c66CEXeccawCgFXVEfjHZ7DRtMnoHGy0r1WisANuERVMAY0Ai6yZbfdBSDLymx+8AQEASdpWwwQqQ4vh9wnLMDB1uQwszye7AxAQklLmADCzi3AXqRCf6vkgiJ9/eMfFZO4R2Ft5eiI7spxlQCAgOsBMmKVrHLGVZxMv3ks2INefA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loDUW8sWl+KyDRD60wmhRxXhecJPMSrqFNBuZsnGxXk=;
 b=sA/ospFP2VeNXfyoM8Bfjdorvl0jympQgx7PAJe51JQVDUdsnGrJv5npV75B2d/635TkoF9GgiTCPOCJelyzC/zsIM2+a5ksLabrAKJmI5vcIPWRQFtgGqwG3x26X4DpQ4ViGstYyBdkH6pdCxYGbvIRPE0W1jh5nvXx0i/E1mo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 01:32:53 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 01:32:53 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 2/5 v6] nSVM: Check addresses of MSR and IO permission maps
Date:   Thu,  1 Apr 2021 20:43:28 -0400
Message-Id: <20210402004331.91658-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210402004331.91658-1-krish.sadhukhan@oracle.com>
References: <20210402004331.91658-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SJ0PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::29) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SJ0PR13CA0024.namprd13.prod.outlook.com (2603:10b6:a03:2c0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Fri, 2 Apr 2021 01:32:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4642ec84-5066-42fc-d929-08d8f5773c20
X-MS-TrafficTypeDiagnostic: SA2PR10MB4795:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4795B9CA64DC724643E103D4817A9@SA2PR10MB4795.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ilb7V8oDi3rlTm9HCCbAJ0qTjhXXp1QZ275apehPANJPEqPhMPJt8Msy5cZN9aO7Gkkhy/hWX225nOo8vaK5bAelkS9hCYl96AhytWE2FQ6OUcKiwswPyx6/QbhNSif1hsjEiOw8bXQwjhS4taTe9O1SOovHBnIhkJnj5YKK9XAVAWtsZThKFzsDuI21m/06Rez+04L4Lpp/fR223sXpHIo59vtzGqLXnv17TibRw913gQs2R3VxYeBFtYIN2DLxX7qhTuuF5l1IhR8vBMR/aa87k1VUvEMGTBGfISP7De6LvRQZBeZd1N9SWKbAe9z2NmM+3IYIFe+b1ej3VN9vWVKKrudc9WXWECp7/YwTrv3mTLqxc53WyX50Bvg0VMApteGIxxFhavliUrVQiv41Wnub1quRXsWSqlzC0MJg0O8jY3hk8QEnAbu45IEXeAMWVMSZUq4SMkCciBsCAJLTNS4DE9mraD9MIzazk+N8AEJcZiWuuu/Qf3Lzc/1DGOIUWF/Nzf4b+7bxo7jhyVIT0ZaEURS91J5e0SEUWPCA/WXRiuCKaGw866bUXIPrhoDl/UyaF9Kav7WwhzXCAw+nhHzgH3rHZBIjjb3G1PgKdKwxW12QZIpfABJx8+xBMAEhKyNUnuS7xFodyghPQp/qfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(396003)(39860400002)(136003)(6666004)(26005)(36756003)(316002)(83380400001)(1076003)(66556008)(5660300002)(16526019)(66476007)(186003)(7696005)(6486002)(2616005)(44832011)(52116002)(956004)(8936002)(38100700001)(8676002)(6916009)(2906002)(66946007)(86362001)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JJR6fw5ef+pwDK2O5D4V44FggQRdiDn4TIxb9zWDifusCjCRrRIpKrpWC7PM?=
 =?us-ascii?Q?1a7NXhEmVAdbNLsISgAVsozuvqXnJS/1Y/va0Z9HpX54oqxN7sngBoLNPyuu?=
 =?us-ascii?Q?CwHILjN+Xk/IUrc7loFZAgIR7IZ/RKBF4YkMjCtFzf6n6gXXfr0XCX4gXHsp?=
 =?us-ascii?Q?sa8i9U0EMyuUoQ6tzdEItHGmW9DP0C5wVDYHfZsvhlwTLn8pdVuEQ9vWUqei?=
 =?us-ascii?Q?2lYY/wIolG/GqeFMrQri7uwKx16SbkxAKi00ajXvXN0iwFfrkBdpDB0sPgjO?=
 =?us-ascii?Q?xqzTyN9GTUDKL3DL2696BOFyGq0Th9tzwxbcQ22E5hw68QDzEDtWVZup+14N?=
 =?us-ascii?Q?aa/Q2f9HDyfNjtjMkENPdCFV8c+lDtFiJuCNhDWMNqatzc5myeb9JFWdrTM9?=
 =?us-ascii?Q?H88op5vrrJul5KvrjCMQPtHMmvePPuHqyEChpdmA6p7NQ4lVNsSUAgQyaqre?=
 =?us-ascii?Q?dQeZPTuIZIGnBV/JTAWVTBLL1GLDoz3wBk4FDEn2teLyQmiizRKYIHkV+Tid?=
 =?us-ascii?Q?9NKo/4cncJz5vlG+rg4s27zuFTXLZi7xVb2974SCr6cDDpteCURjLzxE/D3o?=
 =?us-ascii?Q?tXyhDA1/bA5Cb0B1c2z5F3KQIzzSndeOOBMuEYOH8YrBqAxpOlFGG4XJpNmb?=
 =?us-ascii?Q?gB2DWKrVWiRvWbe3HQvK6yAYfEkVchP5JBE/KTSZcn5qDfI3DXLR3c85uKxy?=
 =?us-ascii?Q?m479WQMcvtNOAr+l5tTXBhWOj67v2sfP6S2qHX1BPp0P55d/2d2hNmsFRUri?=
 =?us-ascii?Q?ORU2CufUdk7zKiZPL6lGmfMhR1kpcYTM+aBhX3lKV5405Vy6Tsi499S9ZYnd?=
 =?us-ascii?Q?A03NFIE/Ky0BcQ+nvL+rk+GCtCaiqALfnaBIjCsDzNReORVc3eWrvQeQnPgN?=
 =?us-ascii?Q?gCy9xL6WixZK6wvKIw/OurvdBmMlEDB5hg0i01kYpMAKYKa3m14aSdlTCgEm?=
 =?us-ascii?Q?0AFrvowQJgXcWIlTj1lCj18CJUEntrSNQF6RLit6GWWin87dIQCvCsays5FG?=
 =?us-ascii?Q?QwyBn8h+nQ7Hd9/sIxRwxNi+zb2W5LrhKFK8abJPS9xoRj3lTgeDe33klY6l?=
 =?us-ascii?Q?XTuxRSn2pJZitjm18qXN1onwZQTKzWn7qd8DjM+GWoTtI5jE/FXHEcETcsCa?=
 =?us-ascii?Q?PYpYCmrEMRycS6sOlHWdfFL4WD/C2Fe+56syj2+Q3axsStBeK+L1alQmjO2r?=
 =?us-ascii?Q?v2xwyR2iLh/tlOzN+J+TuX2mfoq7nF0gE6kEK8M/qbXmaXJKbt4ADbCsyrtu?=
 =?us-ascii?Q?Bz7+BW0FiRNoqRQzEfdJZj3JouSkYedAWj/Dg7QZJxxwIYxNzUtFj00moDK0?=
 =?us-ascii?Q?8GJgkKTbsI+Yz5+4lcLKUVeO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4642ec84-5066-42fc-d929-08d8f5773c20
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 01:32:53.3802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mbch2/RbA7oBas52FwfaPooLgSvZsdOCNOaMVu8UH+diWwvXZjElibYygqnOs/MZpAMbu7oGgyKnluYUVMGOHU2cw2lHnzSO7RNNZRetmx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020008
X-Proofpoint-ORIG-GUID: _s8v65JdVeTJxjrrD4jeV894zAPmEEpa
X-Proofpoint-GUID: _s8v65JdVeTJxjrrD4jeV894zAPmEEpa
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 phishscore=0
 bulkscore=0 adultscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020008
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol 2,
the following guest state is illegal:

    "The MSR or IOIO intercept tables extend to a physical address that
     is greater than or equal to the maximum supported physical address."

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index fb204eaa8bb3..b3988b3a3fd5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -231,7 +231,15 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
+static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa,
+				       u32 size)
+{
+	u64 last_pa = PAGE_ALIGN(pa) + size - 1;
+	return (kvm_vcpu_is_legal_gpa(vcpu, last_pa));
+}
+
+static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
+				       struct vmcb_control_area *control)
 {
 	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
 		return false;
@@ -243,6 +251,13 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	    !npt_enabled)
 		return false;
 
+	if (!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
+	    MSRPM_ALLOC_SIZE))
+		return false;
+	if (!nested_svm_check_bitmap_pa(vcpu, control->iopm_base_pa,
+	    IOPM_ALLOC_SIZE - PAGE_SIZE + 1))
+		return false;
+
 	return true;
 }
 
@@ -275,7 +290,7 @@ static bool nested_vmcb_check_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 		    kvm_vcpu_is_illegal_gpa(vcpu, vmcb12->save.cr3))
 			return false;
 	}
-	if (!kvm_is_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
+	if (!kvm_is_valid_cr4(vcpu, vmcb12->save.cr4))
 		return false;
 
 	return true;
@@ -531,7 +546,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	load_nested_vmcb_control(svm, &vmcb12->control);
 
 	if (!nested_vmcb_check_save(svm, vmcb12) ||
-	    !nested_vmcb_check_controls(&svm->nested.ctl)) {
+	    !nested_vmcb_check_controls(&svm->vcpu, &svm->nested.ctl)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
 		vmcb12->control.exit_info_1  = 0;
@@ -1207,7 +1222,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		goto out_free;
 
 	ret = -EINVAL;
-	if (!nested_vmcb_check_controls(ctl))
+	if (!nested_vmcb_check_controls(vcpu, ctl))
 		goto out_free;
 
 	/*
-- 
2.27.0

