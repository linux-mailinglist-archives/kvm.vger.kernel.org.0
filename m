Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF26235D35E
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 00:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343826AbhDLWpZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 18:45:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51046 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241908AbhDLWpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 18:45:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CMdkDw170807;
        Mon, 12 Apr 2021 22:45:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Qt1atT6nGnA+nSM5q2cYpnvhJ0KIkqhsM4wVk4kPLxc=;
 b=ztF5i0F1PpPj8ICWLCE6y+k/IhYCBt6/WJk2jjgNfsyDaOMY+GHsFbDzSxjwu7g4643h
 YTPe/yacgWQXsdlYetMvKNWY/oh1sKiv7ylCxhKuthKjUmZKADoFwEhYAs6E+mJnQSwH
 /HM3CBsazmAmW0EgHr9O2wjEwuvxa4llKH9LSnyWjjL5h2XwG+rHpK80HsNQa3Fa+Wsv
 t8G0gjy8DqX2/K7i+JlyDh7Er+Sb4QFzbkxtqW/xKV1WLjx4S5clHKoD2Hx4bnXuc6Kq
 ipSk2krCLIIaw0/XBKFc5i2jufdIis8uaDxd4PbTI5hugWZQlManK1E3YwCIFKMdvLqj kQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37u3ymd9gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:45:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CMdc4E167396;
        Mon, 12 Apr 2021 22:45:02 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2057.outbound.protection.outlook.com [104.47.45.57])
        by aserp3020.oracle.com with ESMTP id 37unwxy5sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:45:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BiYFTJyaEDNgPdT0zZSAf6cmWKMkTEZs28K06pgeyZ1NghDEElfkhZJHszbezbF0LER0LTiN5AznhIl8uVziU+iRIJoTyRUVyVVRIiKjyY2w3ziG4SyNrRySyElLWIdJz/lr8xC3LUxccCUrb596vhig9hjmyid/Xt2pwvLqJPvk4aZ7lPkid/V+1Tdg0ciFlwzB9cMEseFu5p/tsd6Rvu+qfrTO9KJD8Xp64EPxlWKiI30dO/bF7mFumpGFzNXN7VYkAib80U7p5TL7x2CsNC2eOeCHFRQJyajDX3fUhbtQ0ilPcdI848rYlqcQbg+JBbJJo5W91+H+ji4h55/DEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qt1atT6nGnA+nSM5q2cYpnvhJ0KIkqhsM4wVk4kPLxc=;
 b=I0HMAbiSlMgbQ+jg9tf7+pMks7qoxVkA6RIQEffco6bVUDRY0+dI+xkRmcY9CyGBTeetGAVng0NLX2/kJ3a6rZJrHTp/dhHC8LTSL199WdDFeES7WzwqhXXj0vwbqAmhNhuTfk9JxlX0ahVO4V0uDEKHCwIEDoukrDrFlrIe8MraYEA8LS/YIMz1rplilNgr0TTr7CozQ0N9j4eU9OnMn1jAxcMBYRx8bP0+km1E53CmmXurWai/ESxuRwbZJn60MpgA02WdjNITcNzWb01rRo/0bJaCp8uA7+7OMjlrO/cbGT7KLPB4PsUUMYdH6u0fv45GL/ZgXHp5QoIAhuuNmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qt1atT6nGnA+nSM5q2cYpnvhJ0KIkqhsM4wVk4kPLxc=;
 b=ykdGwppETaM+Cd7fngZi8W2MnaSswSQNgFR0kZcfwqjZA2R5Rcqib2R20rXKl0kxnoeMyhqqke3Nd/6j/RKeAfvPb1bb74t6lD+HDy1jTLBDZNx+3cUSxt+e3w4a/SxrIgPX7w86amaLaupTpC03gVbTeMhnRHQtaABhchOSdgM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3088.namprd10.prod.outlook.com (2603:10b6:805:d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 22:44:59 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 22:44:59 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 1/7 v7] KVM: SVM: Define actual size of IOPM and MSRPM tables
Date:   Mon, 12 Apr 2021 17:56:05 -0400
Message-Id: <20210412215611.110095-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::35) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR06CA0058.namprd06.prod.outlook.com (2603:10b6:a03:14b::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 22:44:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dae410ed-f50a-40ec-ee86-08d8fe049a5e
X-MS-TrafficTypeDiagnostic: SN6PR10MB3088:
X-Microsoft-Antispam-PRVS: <SN6PR10MB3088F2B846EA91DA12DDB46A81709@SN6PR10MB3088.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fkyMPBlH1k+l0j+ITmm8JeEowPlITBNjxKpM+wb42o9ZYQxvt1G3euhHFFMPVHiItsEdvS9muCMjZ6frCAbHp721Fh98ITL3g4vWmJpmu8POfsEMLhiI8i8z3hNzQbgRP2CKUD4XxShk4BG8N2CCkbtFyfKyY00FXDDa7e7UY+msWzMNbqmr2FeatRe1O/QXaYKAjVPvlEivhwNlpZ3GRoUMQYGWQvb+vPTTvfpLHBBbVkc1cvLC/XdTfxILzFekNsHo5y6Gm8cCBPySC2bORWGV4joLgBT0k40XtXCYV6V23HfKThJoXTFgj2nsTeEujQ8jQWo8vGFHCkypPeW2zZ9iSB+DDw9QtC6NbN8nYwfK9g8uW+Mwro7dLxbLjiPs6ughsDJEDsohJMLDp/VzKt+ZUqk9iwIYNTXnhy9fGAdsTtaQxPUMq2oVFxZgHEsRPfPOTZ3EhFLGSRECzUCI1EDIFbiKXeQoV1qXXrNqyddwq8vZnmxj63OCKI065QlkGLVErPsqreTaNYwYlO589vQNCB1po3DLTVeeALOS8BKw4qoJHv/Fl0maSZ/Ovy1gNjTPyUpSKpKHGIFTaEWBzGjQxYUTV+9WOuCl2xJXDM2KK+A6nMmSX3omOMdWOOTN5S1UwMK6X2AWufWg2TxhJcj79ugf0Srk5ChpY4wUbQ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(39860400002)(396003)(83380400001)(86362001)(2906002)(956004)(316002)(1076003)(6666004)(2616005)(478600001)(4326008)(8676002)(7696005)(36756003)(6486002)(52116002)(26005)(5660300002)(186003)(16526019)(44832011)(66946007)(66556008)(38100700002)(6916009)(38350700002)(8936002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DIwURMVuPL/x+jon2lM3qDz4ZeK9Q4xJknOfNPiY4SBGc+jQIMgNu4PsvRGs?=
 =?us-ascii?Q?nslAJKgRFsUwT0Oydc0e9cPTv5erPUnLKaNxfEeYCYPBj3bwyHtkVbzJpVJd?=
 =?us-ascii?Q?xSB3lZLAMCqwNcf6BBSQMg7EuJyMOdsV3uYhMtTgPcWJZtjch1n8ce8n/LdH?=
 =?us-ascii?Q?rjPyMrJzZL0tqyE3lyrGS/iJyJFGgHEPQRrfvAYF53WZzAyxMloP5CCCQ4hz?=
 =?us-ascii?Q?Ontbk7/g2RJypcKz2J6xKZVfwmONRGt9VjfH8OzMaXZaEtir1OFNMBrtp88h?=
 =?us-ascii?Q?T1pePzcv2jyakwHmvqhYhniaHkS5iOmaT2gKBFFuqq4eJp8mQNSnEN5bfQQz?=
 =?us-ascii?Q?HidNcqAnKk4Rapzen8im+U49iWW6jteN/ZtSN85c+EZutfCZ4z4bO9Uwl65t?=
 =?us-ascii?Q?cRPSz9x8RuElSOo8t+9I/3OUwxNj8iIMoCX5aVSZ/g4d2To+v6z2DweXbLQr?=
 =?us-ascii?Q?cxNVUH8yD2VUh3a4A+IvTbvN/idKfKF1VyFTSzUGP9GO8thDVDwWt0y8iytY?=
 =?us-ascii?Q?sp/N5O4TZtnf/XX77lPkGv//1z/fdig3jRtrVgCmhu0+bFTUQPLIOkRSQTId?=
 =?us-ascii?Q?UHxFle4snjbq2duiHrMgnRxIaQ22dS7gCon6HdJ+RaJAxnJCZ7ryUAahtX5M?=
 =?us-ascii?Q?xPj4xLgdUobCckMHH547ZmEw6qI1hQYlU4WfK/dcq9zN3e5qarbZSOaNtCb/?=
 =?us-ascii?Q?B36ZWdUcHG8j9pZFUUtdNOkX/xMrrT1itk6P/ewmPctGDbMy2lWG1e3R5AW+?=
 =?us-ascii?Q?ZAPcH9tZUzRyedzNU/WQGAiuu61ZANkmZL0sqUWiqA+v9yEKvswnBklSv0gB?=
 =?us-ascii?Q?vCiqhgtPhV4thDt+sbwcfxaHIqzVttmhpEpWM3XnH3hBEtsyOI6i4SPRYJ/V?=
 =?us-ascii?Q?eVN1ko5RCGaknHoOcLEc+PJ7oRDVOX7Gnm9DNtFS+3Up2ByJvWv6g/7Qgx2C?=
 =?us-ascii?Q?FHYTBIfz+vQQmwK3x9JOV1m8OKjW5x6/ybt6zio5J/8jnnqkUWJ95/5MmU+N?=
 =?us-ascii?Q?J8k1d4PKoCt4waKWgACC2iOPTnXrUAL9nRoweugC2FLZsO0hRn2IJs3c/CC0?=
 =?us-ascii?Q?02bq9sfYmAfhDOOzf8l98ydKc9wKSCkHxUEpTq8mGrlzdwksl4OrRmaeHd1u?=
 =?us-ascii?Q?ufHe31vYqzfOQACHqJur/AITBi0Css/uBgnFt7OGJdrzJ16Vz5ZnOQaU1XUh?=
 =?us-ascii?Q?SDTjPnmOMIUBPRfXvxJ2R9Co3hNTVDk8V7SKAg42M/tt5ivMgc7rOwMpjjDs?=
 =?us-ascii?Q?X4l+TaYAn8aHQlaGsHpqTR3uosF2qc45D9Pcb7VLkUNoCsBqeSOqQct/olET?=
 =?us-ascii?Q?MyOxaeSq1fIDbM//23TI0Cgh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dae410ed-f50a-40ec-ee86-08d8fe049a5e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 22:44:59.8041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eTYcRd46ahDbe4Lq0BWHfvq/fHdwFyGHrW558DpDVD4FKj6duxJHX91nB/IpkisVSTc7+fP+3udJl7rLTAp7ld9nRS8SxBvVH8RBb8d563o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3088
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120146
X-Proofpoint-GUID: q9E_KlsPAMBV-ZODUvwACm_6wFYLe7EJ
X-Proofpoint-ORIG-GUID: q9E_KlsPAMBV-ZODUvwACm_6wFYLe7EJ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120146
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define the actual size of the IOPM and MSRPM tables so that the actual size
can be used when initializing them and when checking the consistency of their
physical address.
These #defines are placed in svm.h so that they can be shared.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/svm.c | 20 ++++++++++----------
 arch/x86/kvm/svm/svm.h |  3 +++
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 48b396f33bee..0fe60095ab67 100644
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
 
@@ -683,14 +680,15 @@ void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
 
 u32 *svm_vcpu_alloc_msrpm(void)
 {
-	struct page *pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
+	unsigned int order = get_order(MSRPM_SIZE);
+	struct page *pages = alloc_pages(GFP_KERNEL_ACCOUNT, order);
 	u32 *msrpm;
 
 	if (!pages)
 		return NULL;
 
 	msrpm = page_address(pages);
-	memset(msrpm, 0xff, PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER));
+	memset(msrpm, 0xff, PAGE_SIZE * (1 << order));
 
 	return msrpm;
 }
@@ -709,7 +707,7 @@ void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
 
 void svm_vcpu_free_msrpm(u32 *msrpm)
 {
-	__free_pages(virt_to_page(msrpm), MSRPM_ALLOC_ORDER);
+	__free_pages(virt_to_page(msrpm), get_order(MSRPM_SIZE));
 }
 
 static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
@@ -896,7 +894,8 @@ static void svm_hardware_teardown(void)
 	for_each_possible_cpu(cpu)
 		svm_cpu_uninit(cpu);
 
-	__free_pages(pfn_to_page(iopm_base >> PAGE_SHIFT), IOPM_ALLOC_ORDER);
+	__free_pages(pfn_to_page(iopm_base >> PAGE_SHIFT),
+	get_order(IOPM_SIZE));
 	iopm_base = 0;
 }
 
@@ -932,14 +931,15 @@ static __init int svm_hardware_setup(void)
 	struct page *iopm_pages;
 	void *iopm_va;
 	int r;
+	unsigned int order = get_order(IOPM_SIZE);
 
-	iopm_pages = alloc_pages(GFP_KERNEL, IOPM_ALLOC_ORDER);
+	iopm_pages = alloc_pages(GFP_KERNEL, order);
 
 	if (!iopm_pages)
 		return -ENOMEM;
 
 	iopm_va = page_address(iopm_pages);
-	memset(iopm_va, 0xff, PAGE_SIZE * (1 << IOPM_ALLOC_ORDER));
+	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
 	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
 
 	init_msrpm_offsets();
@@ -1425,7 +1425,7 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	sev_free_vcpu(vcpu);
 
 	__free_page(pfn_to_page(__sme_clr(svm->vmcb01.pa) >> PAGE_SHIFT));
-	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
+	__free_pages(virt_to_page(svm->msrpm), get_order(MSRPM_SIZE));
 }
 
 static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 02f8ece8c741..b07765c278fa 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -28,6 +28,9 @@ static const u32 host_save_user_msrs[] = {
 };
 #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
 
+#define	IOPM_SIZE PAGE_SIZE * 3
+#define	MSRPM_SIZE PAGE_SIZE * 2
+
 #define MAX_DIRECT_ACCESS_MSRS	20
 #define MSRPM_OFFSETS	16
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
-- 
2.27.0

