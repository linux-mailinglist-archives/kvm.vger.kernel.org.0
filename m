Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C0C352523
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 03:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhDBBdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 21:33:03 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49780 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbhDBBdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 21:33:00 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1321Wr5m063887;
        Fri, 2 Apr 2021 01:32:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=OyfSkumGwoB6TlE1OOlaXy++iJqR4mB9HcHh/k8EHrE=;
 b=jNo5RH2ixc/1r/s8FKOu+QXCV96GW54FoZtBvowSP3s04vlu7idcXbuuHabJ9dt8+sCI
 7X9GAusT7Ees2hUWk0HtIduMoNP84ujFTwxJlInYcp6eQB6IetR5ZbS7iNYT8gwc7Kbm
 n80Y1zUNmeMRf0brFqwIgk3S6ArvIsajUJk6qQfyFbktiYVjJAu95H/m+JQxYZfOpWGJ
 0lPrC3WT6TSEjjfoVhPx/1SUYUSmq+xQN3+uuHU1Sc0juJmUFsy3ttP70ZCQL2WkoUwz
 vvZsF7J8DlqLr+/ykzo8yIJB8PXBFWbLc7bbqDiRoyUv/pZun23IHH82bFGI3aC0mYmp Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37n33dugm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 01:32:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1321Uw7M018855;
        Fri, 2 Apr 2021 01:32:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3020.oracle.com with ESMTP id 37n2abyytf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 01:32:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PtVB0ILd9sc70XNDsTSuB5AWi30SB2QHc9JCI0is0v9/ArZtLO5v6dyGJbJ19VWnUZH86Vg81U3rW0brur976KdD4naHWFb3Puuf7VKujfgyTyzlUFWKsq8uk7hWRYY8NkawUWsmkgDXKfkHNkgjDBqZpViBoI/YTtKajQ41WG40VNkvO6a45oOf6BEdBjyzrza9jlRcXtNFneExyxqjiEAQKLXplvVWopkZvyaRPaBTfo1OfFDrQuHwTywhBrkbMxgWQMGoXEGSlaQlVk5SJ9qdzKf2myUmNZbpLFDPHfTPQKdTN+sUjF3xuTI0VusgJ5hDp5jfnH3v8VRhgwIudQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyfSkumGwoB6TlE1OOlaXy++iJqR4mB9HcHh/k8EHrE=;
 b=TAII1ryUxAd7qHOXiaV9mai9mVvBJncSiDWE1WgGBrpuZaSZ+qqFLeqOkb4cuAamZphG6o/3G1uBUstwWqjrHziXvNaAoZftSZ+uR46G1ASAabreswkLPGRcdDrGZS544iZFGg2vBKUlD6iY57zMAmc/oiCzYmNx0R7YZ0jFNxcwWX9zxnmAGLAfVXn7G+ngkkQKsnxc3pWbVorhG0D9wedMVodCYlwAjh1JLA/F7MyUab95olncWpRjgndB9TdsrRhroNx0RBbRm3myF4dr26eCrkjkCs3ut09FyYi0irViOty6k9mU+5zC674Hko4TkI9pOdcCmtqT3HCc33XREg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyfSkumGwoB6TlE1OOlaXy++iJqR4mB9HcHh/k8EHrE=;
 b=vftsXn7U226XuwWUhlt4tcBQajz+UPm2+IgkEuJqzCjKXp/jTINCzslSwQhmOQ2Ns/PiWdz73fSTRJVdmTLA16UqsOwkrw+YhybLEyj39sTRED5KoLv6ykeJcjDCi8y68kwe1LQPbcZnE6Lo/U+tMk0XKEAkTCXxnPmicnYoisY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 01:32:52 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 01:32:52 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 1/5 v6] KVM: SVM: Define actual size of IOPM and MSRPM tables
Date:   Thu,  1 Apr 2021 20:43:27 -0400
Message-Id: <20210402004331.91658-2-krish.sadhukhan@oracle.com>
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
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SJ0PR13CA0024.namprd13.prod.outlook.com (2603:10b6:a03:2c0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Fri, 2 Apr 2021 01:32:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36ed3ced-e2d7-41cf-4024-08d8f5773b3c
X-MS-TrafficTypeDiagnostic: SA2PR10MB4795:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4795EBA4073203C944324236817A9@SA2PR10MB4795.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JuZLTw5P4O5/6qp/DVwwx664vdRnsZbkL/L7m8PSpAzL5zRd9DGvBALL7Rxl3S275xDvfqgsIB4bYJIxEzMU1qJvaf/qrTnmbMnJCzmZApopeXga6FEwSVfHe3gVuJypcKsmXDUYBXb2m4dE/+cofCC++GwEoyg9S8TBb3M1gvNwo2t+DrlRv0pPOitsmnSm7uX7yYoK6fH3+HqYwgZYbd6WjvR1d9LJv1AoeIhNw9UKsaaRXg6mLcBGqZ3vZHDfw56EtX39WopKf02iAKGrepf+9JZYBCEXJ/VwsF18lIGRhXJ3d5+Vyv3WY4Ttxa1D2VcH74a+NEvcKa53nCZ16CIuIR3oNN2UHyCxgVRpKgW8LcHedI85GpqiPB8owL/9Gu2mE1AweLoRXfF4zqX6MVPdA1oV5WgkirJe573TaVhVuuf8/uPoKpx1apz8ZFdpMu1CNzSDNXpJnVkWGqnzUx1ZeTpGnq3DQQEnDm4TYXlJkxrogvonVcqQqfDrtGlKHFbCabMlD77NE4XBXixvAnq5OGS7Qgz/CJoTeEgbiVDtqNqNz4qPuH3nlU4R/xGZlmwSFXBojw8nb9ibrgw70syJMW8BpUYMX9zyfPbDlvQZ3zNYvydJVeK6bfhoQpDqJYm01uFwmp4a9nQWfADN0L/CIg/X8d2Eg+SWoVeay54=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(396003)(39860400002)(136003)(6666004)(26005)(36756003)(316002)(83380400001)(1076003)(66556008)(5660300002)(16526019)(66476007)(186003)(7696005)(6486002)(2616005)(44832011)(52116002)(956004)(8936002)(38100700001)(8676002)(6916009)(2906002)(66946007)(86362001)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EVoIeqw780YxPZHTHElBFwW3Ppf4doLoFXQPuQ9Pd/N9Nsjtoq34t9asadjk?=
 =?us-ascii?Q?K7F4gY2c5R1STvd+lhYVMCVz4CP3p7pAIped+PXFrr79bDJls1D1jN/Tg/4n?=
 =?us-ascii?Q?ETPyG5W+wRoOuP0Fgfej2ZUijpUQ3yls6BEbEZx8ySKb2qXSOUCrlcgpWSR3?=
 =?us-ascii?Q?QPEwnA5paFkq69iibo12/lqIh5XvyNf6NYv4BDbpcb/uitvdRsjhwkENco+v?=
 =?us-ascii?Q?N3ujxf2AcUvrQkxz6sDfOc53BmUe+fNqH11G9DqU6ff+WbI08Isawjcnu78o?=
 =?us-ascii?Q?66CTCwAHpxAJf+MdlPbWW7Hi++WZOLucUxojnx50QCMyOXf2u92Ynaf7V9/F?=
 =?us-ascii?Q?5o6ynb6/huawiL4sWg7e4iaAdw2wBvCiftySvrhmsQxZGecCIhCb0PpZMfrr?=
 =?us-ascii?Q?n6hGJejFrfn34dnwdbK/smFNlGspSww7inh5VZ9TYNO8FAfdSiRlJDdMVWcp?=
 =?us-ascii?Q?sTTlP9EHpLVkIopXnVDHmpnzoIoRSc9Rq6BKFVM6pgNB8mwpFnQxtLJmxJyH?=
 =?us-ascii?Q?WVd0Vg7J0Y6NH8gP7DhcMMTpdYu80pNt/yeNYA/ZynKpfm1Qlb4sPCv6F1tR?=
 =?us-ascii?Q?WattUukUbc2x0TczO7AaQT9sE5+kNrLwxLWZaIbSCbK/9l6AnHXg9dJmgHnp?=
 =?us-ascii?Q?OUz3XNE2V3S1Zg9q6sU19zLTUIYpkMGGTNFCiRSPFuyr2sCNMUyse3NRPOao?=
 =?us-ascii?Q?qTVhcJX8oPysStz90TWesfUt0hR82He1C8JPLSmPYAMr+mmcOJMmALMpPyzi?=
 =?us-ascii?Q?HRucBOFznc+HKJJhNXAGB7bpOqUp5S/hKizvCTHNBqhprD5IaT/QO8+DMsn+?=
 =?us-ascii?Q?phNJuKQPYJ/oPZG8gJZnUL5D7nEqoR2B71736dNURzhKAsZxG/1GSBGHnDix?=
 =?us-ascii?Q?b06+8HCVmKWiOK4C1yEYngqh8YU8CtPPCPyyq6a5y+5palhn0H1LRs6PdCy8?=
 =?us-ascii?Q?eGXlWJLWXhASzWNgbApW38z+KEKnlyQPnEk11onYKE4b1bYhuHBZOK96Gno6?=
 =?us-ascii?Q?2/AmzSJVvGb4Dl6py8FFyuU0W29h2Bo9D8HRe9td223Fo1heGPFIlIMugeUR?=
 =?us-ascii?Q?oLO5MqCC8hdKJXxherPXgA/EXs/a9Dw819ZblIfdipRuZ3217VRnWMQfgzep?=
 =?us-ascii?Q?OSP1/2OjSdsmhkDkVfymewzslHgiD/1LmYMDSpc/CKkxWWv1Xz7smEn4fveT?=
 =?us-ascii?Q?U/zA1KGvso6FGivbXadXgqi21X6w48dMPbWUUvEKNB+HxXfB9LWD2UtU2vMI?=
 =?us-ascii?Q?xw9X0AMmX0QKem6kTy9cgWsT2eMyXXtqpGL+JJUQ8bjgBRJ4VMJotvPSoyAb?=
 =?us-ascii?Q?EF/OOZ3CeLTiziKruTlm3c1V?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36ed3ced-e2d7-41cf-4024-08d8f5773b3c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 01:32:51.9021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZctJulZQT23TyRuYG3/xOxYJRf7aLKy7tlle0n+5pRzK/PAbszxOGDwPhTg2Nyl98IGATWKjnOxPiGNYpbzbI6mvjWpPzTxkz0WRRHH0Sg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020008
X-Proofpoint-GUID: 7V4m2zuqMf4Z2s3fZfv1AhJ3CokvQ8PL
X-Proofpoint-ORIG-GUID: 7V4m2zuqMf4Z2s3fZfv1AhJ3CokvQ8PL
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020008
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define the actual size of the IOPM and MSRPM tables so that the actual size
can be used when initializing them and when checking the consistency of the
physical addresses. These #defines are placed in svm.h so that they can be
shared.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/svm.c | 20 ++++++++++----------
 arch/x86/kvm/svm/svm.h |  3 +++
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58a45bb139f8..d1dd6539ed00 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -56,9 +56,6 @@ static const struct x86_cpu_id svm_cpu_id[] = {
 MODULE_DEVICE_TABLE(x86cpu, svm_cpu_id);
 #endif
 
-#define IOPM_ALLOC_ORDER 2
-#define MSRPM_ALLOC_ORDER 1
-
 #define SEG_TYPE_LDT 2
 #define SEG_TYPE_BUSY_TSS16 3
 
@@ -681,14 +678,15 @@ void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
 
 u32 *svm_vcpu_alloc_msrpm(void)
 {
-	struct page *pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
+	unsigned int order = get_order(MSRPM_ALLOC_SIZE);
+	struct page *pages = alloc_pages(GFP_KERNEL_ACCOUNT, order);
 	u32 *msrpm;
 
 	if (!pages)
 		return NULL;
 
 	msrpm = page_address(pages);
-	memset(msrpm, 0xff, PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER));
+	memset(msrpm, 0xff, PAGE_SIZE * (1 << order));
 
 	return msrpm;
 }
@@ -707,7 +705,7 @@ void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
 
 void svm_vcpu_free_msrpm(u32 *msrpm)
 {
-	__free_pages(virt_to_page(msrpm), MSRPM_ALLOC_ORDER);
+	__free_pages(virt_to_page(msrpm), get_order(MSRPM_ALLOC_SIZE));
 }
 
 static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
@@ -894,7 +892,8 @@ static void svm_hardware_teardown(void)
 	for_each_possible_cpu(cpu)
 		svm_cpu_uninit(cpu);
 
-	__free_pages(pfn_to_page(iopm_base >> PAGE_SHIFT), IOPM_ALLOC_ORDER);
+	__free_pages(pfn_to_page(iopm_base >> PAGE_SHIFT),
+	    get_order(IOPM_ALLOC_SIZE));
 	iopm_base = 0;
 }
 
@@ -930,14 +929,15 @@ static __init int svm_hardware_setup(void)
 	struct page *iopm_pages;
 	void *iopm_va;
 	int r;
+	unsigned int order = get_order(IOPM_ALLOC_SIZE);
 
-	iopm_pages = alloc_pages(GFP_KERNEL, IOPM_ALLOC_ORDER);
+	iopm_pages = alloc_pages(GFP_KERNEL, order);
 
 	if (!iopm_pages)
 		return -ENOMEM;
 
 	iopm_va = page_address(iopm_pages);
-	memset(iopm_va, 0xff, PAGE_SIZE * (1 << IOPM_ALLOC_ORDER));
+	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
 	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
 
 	init_msrpm_offsets();
@@ -1408,7 +1408,7 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	sev_free_vcpu(vcpu);
 
 	__free_page(pfn_to_page(__sme_clr(svm->vmcb_pa) >> PAGE_SHIFT));
-	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
+	__free_pages(virt_to_page(svm->msrpm), get_order(MSRPM_ALLOC_SIZE));
 }
 
 static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 39e071fdab0c..d0a4d7ce8445 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -28,6 +28,9 @@ static const u32 host_save_user_msrs[] = {
 };
 #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
 
+#define IOPM_ALLOC_SIZE PAGE_SIZE * 3
+#define MSRPM_ALLOC_SIZE PAGE_SIZE * 2
+
 #define MAX_DIRECT_ACCESS_MSRS	18
 #define MSRPM_OFFSETS	16
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
-- 
2.27.0

