Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F82352067
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 22:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235554AbhDAUJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 16:09:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34516 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235441AbhDAUJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 16:09:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 131K4ToN073826;
        Thu, 1 Apr 2021 20:09:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=OyfSkumGwoB6TlE1OOlaXy++iJqR4mB9HcHh/k8EHrE=;
 b=x7+538XEiMS++kaBY8Wfrp8ymQ6ROPBaoBM7v/NGQRB/VXZfRU8EpC4MDC0Wo1ITWlBE
 BUcPcH1yWTiY1bU0F2kYddlm4ViqseeQe5hA1QK2MwJ8Wl/Shstkmp9OpyzN9Kk6YV3/
 y5ObQDu0F986+c8FzQRlIdP2hAFU5AsPL6uEiFgSYxB1NCJwFofKW01V7q7pJDW4icFA
 AFGNftGQEvdjF6gH1grGjyqj9febDOKJa+Fi17XNxOuSG7fzmainPWQs3haKl9iahLw0
 WMBepq0mQNro5PuLE0sWHUs72t5UHIIINnsYaK80+CwJU9ixFiC1ylvBUzbe1NIcSseL VQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37n2a032cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Apr 2021 20:09:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 131K1c6v159072;
        Thu, 1 Apr 2021 20:09:23 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2054.outbound.protection.outlook.com [104.47.45.54])
        by userp3030.oracle.com with ESMTP id 37n2at944k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Apr 2021 20:09:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lm+LBkYTkC2zwZwIK2SjRAkcYyy2/N/vM83jnZLMYwSpTa1ZGy+fRji2QTtfmUAZotwxIaGP4sZF6tQxgFj6hySZo/8qHDHztCjgGQC7h9IA24MLl1Ytavs6XTQS/AfP2EQQ/OalhkNtdccvZ07pxEIT9S0kNXuoK5uMhLP1I3M2ovMdFiYIAUG3PE8fZQM7TKuc7XKVs4dVWNbf3EHh41CqMdWx6YrF04OjjsmrGAhrgB1DuuT2K1V4j4pIXpqFRS6UY9wKANWipcJLcLkl72mFBfPuMASuUjiYh+qPlD/kT3e2v8pMqGgDnGApBcTP2JTA9mX6fUG2jNyZaFKSRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyfSkumGwoB6TlE1OOlaXy++iJqR4mB9HcHh/k8EHrE=;
 b=KM/qmcn/VOgBe1SPWijbxsyU7ogte0hw+bzcG2zLPLrf6lAbV7MrgEUZZRsbT3RkzALZyIannurn3JrByuuDoKWn8mhJYiud723gUh7F7th63xlTgQBege8iK6J3aOQbLslMngr0TT3mDx5JaXPc2JyKMoXi6EV1R6xKBPYIV+0B2QPjsu7hJXvMucPXHELpfb57Jy1g9WzKV3Pm9K4SxQLD6OaNdeWhNzzuCDPD8kIZoZatJxQL2owU/eGAmjzhJM//RKHICv+qT0MWYyeWqFNfV/o3XRT6lKr1X+gNni2WW9Vm+tnaTob4i5zp+dhFbCreZ1Cm4uQj70l4n9/0FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyfSkumGwoB6TlE1OOlaXy++iJqR4mB9HcHh/k8EHrE=;
 b=Sr5kTMlDEWbdI74xTPFfgjGtLi3F5U2NY+50Z98y6vl5GQI965NmT4763WIxpmSuZa5hRH71UcShcTTjC4N7FjO9+Oy0hcTZkBHBrCKsiVsWnh57T0Ja8KZhUxc9Sv83+2OmAFO0l18w4u9zIeeHJKJ6SO2ktUDInXhXFLLMtWA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DM5PR1001MB2091.namprd10.prod.outlook.com (2603:10b6:4:2c::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.33; Thu, 1 Apr 2021 20:09:21 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::35bb:f60f:d7e1:7b2b]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::35bb:f60f:d7e1:7b2b%3]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 20:09:21 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 1/5 v5] KVM: SVM: Define actual size of IOPM and MSRPM tables
Date:   Thu,  1 Apr 2021 15:20:29 -0400
Message-Id: <20210401192033.91150-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210401192033.91150-1-krish.sadhukhan@oracle.com>
References: <20210401192033.91150-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR21CA0015.namprd21.prod.outlook.com
 (2603:10b6:a03:114::25) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR21CA0015.namprd21.prod.outlook.com (2603:10b6:a03:114::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.0 via Frontend Transport; Thu, 1 Apr 2021 20:09:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f39c292-2872-4ecf-3d7a-08d8f54a09a2
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2091:
X-Microsoft-Antispam-PRVS: <DM5PR1001MB20917D52334EACE119A8269E817B9@DM5PR1001MB2091.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m8QI6vYvAFGWBE4WSbnGgfGNwW+E/c3c2nb0CPsTbeWRdRDlbWc1knt6w8CN62FFlY56T6gt6eWtQY8S1FrEes1tdk2r4okzmqqXtmbUZXiHRmefGAAXEeMYFgspJnK3Q/BfZPqgwpUTB1tPjZCBYmpyhQxSOgJnGpRuTHgbxVLBjSnEwMo6EdJ7x9B16L5oC29RW+G7qovuWZ8DKYdYlmqHn2HUIsYSMEgGcBbLtYbjnrrzbGX41zzQ/LGjz1FK7jybMXhLGq7qXTX+FEqAQ75z4GLioAAq6V1ICfg3mrSK1A8CZC+m6l/xeINVRYHwOSK18qGJLeQVf1Fh2D3kHKRIPOFiGk3H5NwyyJK9R6izHx56fCzgNfbsLjoeyO0a2yQrJS0BmKmqXHGTm/OAdYLNG9QypmguiBvevRMgP+H3Ic1dB0SHwo7gSCG/zWUiaVb7AK99+4/mKzL7iykwBHdtLxwqF06KSengqg9zJAqBvUkyBNHtT1iIcYbim8VwFI4XdDUfk1ElRVGnmmM51ZiKW7aSa9W1ZfpO4neVOelBXMspOPdhHlkUxJ5bSpi1ecj6XDJboZLOEmepHkdCPRjUiDoGwL3Koney6NXE84otwU5fVD5QvtvKgECgjzOw7KjZnprlrBf+0HwHN13t0wEJ3djMkH8TgKRThUIA3Is=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(39860400002)(396003)(66476007)(86362001)(2616005)(66946007)(4326008)(2906002)(186003)(6486002)(36756003)(316002)(38100700001)(8936002)(7696005)(478600001)(5660300002)(8676002)(16526019)(66556008)(83380400001)(6916009)(44832011)(956004)(26005)(1076003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2MBMFTc0mLJR27l6RQdiOE7reBrr2RBofvi2t1+A123kuO2YgqNyxHGLPI89?=
 =?us-ascii?Q?uVFW9gXKF7LhVbYa6oLPWxod9+TubLLutJPjSkmG4mrPQB724BSN47MkfcU0?=
 =?us-ascii?Q?Sm882wLvZA4YM1JfCyv3ac4k/CWO+tRqY5iMavc6MqUArjXoWg5kYj2752Zk?=
 =?us-ascii?Q?kKiMoewqL4+n0vcDQ3kWxGMx0DLzwYJ4V8sA05h9WEi02hRjoQ7gZuxHK3oD?=
 =?us-ascii?Q?tXrkr3JYdMj8eqVGb39CVV8oDWCtQ6k1n7RkSy3Vzs4yAtl3zOvOQsCssVz2?=
 =?us-ascii?Q?8juB7GJLx4x9oNtMFVh5CSNOYS8pIY/GcQPNfBpTiDqjpakEb0nn2+yucc6p?=
 =?us-ascii?Q?2XoZ2YO1PKwHs0pLannvUEL0qQYuAwLIiE9AvMNplrDV7M48OmqVy3o2p+96?=
 =?us-ascii?Q?jfUiqVXjWjxIXBWPq7CdrQfaZSgR5LH3dujwY8fJ56G0A4XCfNBouQ+wuz+/?=
 =?us-ascii?Q?p7xVQtdM9CJYsoYVsJnp/I/ugcWiOIXcMSOK9nQcFPn8W1mAjcU6dt8uX4YP?=
 =?us-ascii?Q?zglWZNPyhzJsY6EE0xx2ZCKwRrPwTpE1o1FLHE15vvvtd7mTvFI1ntZS1tEz?=
 =?us-ascii?Q?AYcsPdirpp79NkB9wv8+Q2zWD3pP80BzCXC35/6WlZTMmiOFg623pwCAQ9HJ?=
 =?us-ascii?Q?/xgARRHN3w8pJGtnpdkIeOPC+HP1Ps+I0dD12k/UlZGrUW9jnzBqHA/T1hpf?=
 =?us-ascii?Q?jiDJkUtbC4RjRw2df3DrcRkPvOQoxeF4asYEToK5mfAI69plX12MHaLtsTy7?=
 =?us-ascii?Q?PQrGw4ctU+r491IXDRvvoK2I4zjWiCUhnTSfdBC+iYhmlXeKdrm6yGGDA71X?=
 =?us-ascii?Q?jn2Qli2pHGkvyFhbht01Z1WZYhsSBgGNjdKjXuNcGXmJKigPkrNBO9I9zKV9?=
 =?us-ascii?Q?9ZmaHuYOM2/a7+QCKTrCAxN58w8Eqiwb0EwUuMCG8W+2YI8znqxgO1Kyph5J?=
 =?us-ascii?Q?yeq8PpLspwc/fFV2Myr9TaH8RJYene2/fMeL64z2jG5fNDvO5gg7dn1tS4Ug?=
 =?us-ascii?Q?XFL2YAJvY8ylEuC0mC2HEOxRSYNpOQ7/JDdTJczjSrUn+xft52UhGdj2fY/c?=
 =?us-ascii?Q?S7xLmpWXZujRdyz59PLobTcIp/ekXkfmmFvKYPObV/AN/Oi59zkRR5kTVne4?=
 =?us-ascii?Q?lg7jpEOV4SGwO8xREuXqvBwdwUDs5GSTUIjU3973kv7TnoHR9LcqRd8Q2EBy?=
 =?us-ascii?Q?5aFtGNTs1i5wVijXpsjAdIL2Yujqx1R3yDJ5hFXIhDCUBHLuVrqoMEemrJqt?=
 =?us-ascii?Q?XWl2xfh7gYBb0Sko0GQfXUssWkur/uNbKHzwfeJMWY7nqlvTbPZuIOLIPGp6?=
 =?us-ascii?Q?sxcuc35n6VHjiss4vTp9y4fH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f39c292-2872-4ecf-3d7a-08d8f54a09a2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 20:09:21.3746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a6yXpgBSFFOa0zeQ6GSwvPrA8rgqo0ca8dVbCWbh4oGcc7g6nFDljP5pCroF5fKXxN9WEIB5p9clUbhd98Q75rA2jg1wn4v/n5koIKtE8+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104010128
X-Proofpoint-GUID: IW9CBTBnw2LZYNrYT0SDqdkYhz4_qX_B
X-Proofpoint-ORIG-GUID: IW9CBTBnw2LZYNrYT0SDqdkYhz4_qX_B
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 adultscore=0
 clxscore=1015 mlxlogscore=999 phishscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104010128
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

