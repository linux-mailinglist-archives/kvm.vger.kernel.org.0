Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D39E30D15E
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 03:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhBCCTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 21:19:39 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51138 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhBCCTf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 21:19:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1132EuGG006449;
        Wed, 3 Feb 2021 02:18:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ModOCWIXpk1rwpr2dJxzdupuucZ9YJ+Tx7/IW3ncBjo=;
 b=s7/2jkFdofFuSOiVFG2txppP3spNvPrBmHuT+YJiZIgGzUaSl7ZBvB4SIqUV7f2S3XW8
 LLVF/ygjzZEebn/1L3VodMyjaKUJKGRUUbKIHdUL3Io/zDIpj+VLwjjp33Ct89IZpF0S
 wz7B20UMbxSBZLy7oe6lu0JN+8LvLjnJA4e1mQRyW6IA5RbI4RDCxvqY/h81lsk0nPcU
 CZbAQGld0rqFmbpdKqeHtC8p1WRVL25s9nA8kvDz1mjgceEUuc2csE6evW+kGNxv+7km
 1tZEjyhom+HTrXWrN3YK0C7yQeYUNvRxSMHgVpMTaa/tEDnlrD5xeIR9bS3G+e6k+7su WQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36cydkwq46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 02:18:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1132Eanc110778;
        Wed, 3 Feb 2021 02:16:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3030.oracle.com with ESMTP id 36dhcxqdsa-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 02:16:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJRwOY1NXsy4yKFLJxgEtz5TarN9SNputqNcW+188RzS2oUAwX3RqNhHr8pnBzk05DfJQDpcMqScKgQXgqdOL2jVIlcJAv8vSaj1iBq7A7nUnNVUufmfpPr30T20O9za04OgDZAP50p+recNfM7MIAk2/uMrzoHXtZewlPTFUKFSCccBJqXy2UjKDg0drbJI5zD4hg160KZSvY4h7aY8PVhU4K3tO9HgQIMI0lT93qcwyz6VUBsd+5ive6yoCQwFbsGFarSiT80JhR3Qt/qJ+UJA3prspPvEZgOHSEtycSK774GXWG/Ngn21bPYWFv92rj6ndpCJKnUBqlbe/yw3ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ModOCWIXpk1rwpr2dJxzdupuucZ9YJ+Tx7/IW3ncBjo=;
 b=Ml8CW5M/KZocFyKR9Kw0LclwfwWi3BCE3jvy8jcSb/ZjW6Uy0PU7OsRdSw8KZ9bxFKDI/mPyYlZcBppw/WLkuP2GciNn+T0ZpNETvywWSKZRDpJbQBVE2ky+WfBUM8zh5I5IcpC/ICbMF5s7TtluH+m1/gJdaa2CnX3IuHodpZoTILAN5DnOo8YeoNYmH1sj9L//Ne0sGdDuqcfGvv79fU4UUH5hi+F5bC8IshIeCl+VXRuXV/xofIPCvXoSZHPvwbRB54B76hEn0KhQQQtBT8xUkHI857E2as8eUy1GattozjVH0e1K0mUEzmUFmmtxa5fp7KddVYyh4s6wM7raLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ModOCWIXpk1rwpr2dJxzdupuucZ9YJ+Tx7/IW3ncBjo=;
 b=GQ+TiyenJVEBe0+0Z5Eb/hQ8gptCU/FH6JBryH8CL6MFLmgxJzZWWjgEQONewdIMKRx+Q4HluVC4wbwkv/Qgv18vlQYFyI5t4vgRykk9iaNBt+r35cWGTuML2uER6F2V4ccLwEhe2ZGsDUE1nKxsY7Y7hlkoXhB3NJNBQSSm4P4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4793.namprd10.prod.outlook.com (2603:10b6:806:110::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Wed, 3 Feb
 2021 02:16:48 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3825.020; Wed, 3 Feb 2021
 02:16:48 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 2/3] nVMX: Add helper functions to set/unset host RFLAGS.TF on the VMRUN instruction
Date:   Tue,  2 Feb 2021 20:28:41 -0500
Message-Id: <20210203012842.101447-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210203012842.101447-1-krish.sadhukhan@oracle.com>
References: <20210203012842.101447-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: SJ0PR03CA0096.namprd03.prod.outlook.com
 (2603:10b6:a03:333::11) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by SJ0PR03CA0096.namprd03.prod.outlook.com (2603:10b6:a03:333::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 02:16:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16d09636-a85e-45d7-d614-08d8c7e9c2a9
X-MS-TrafficTypeDiagnostic: SA2PR10MB4793:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4793CC9BD914977039054A7581B49@SA2PR10MB4793.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nfT5MHn40KNgzEEKfz978HxkPe3ohazgL+rh0G6363uvz92THc28Q+bW81ESB5w7X6gRBE57h+cQKzHtCP4YZoppCOJp7Vr71xN/1fny9pFz97BqiBo+d6u8gl4Sv5Boi7vNZ0kuanOcWXb6W9sLcg/60hrVIpBOeogunCJ64z9iONKygU78uU6qaJRhy6cd1Rr4NyMK0/MAcLt2bkyRi7Gur5raHoM0qZg3+GORDj2AdhN9Hw6p7myJ9zEMTo5HxlFNaIg8CsuXhFkaJ/5Macz36AadhNixyhAogpCzYjrNeFolCOZQzFdl7OOPuz7gJNLGNz8rbIspIuHzcsUz29RzA/R7wU/176XKEsi5l5G+jp63onZYPUimxcqFs0Pvr0iDowIH1Vz6waCqMdAmoailBgFWs/48f+od11jdq9/ouH4uMGbaf2r5sJswdBcg4G0AYT+2Ha1Isjyq2Ajo0M6Iev0UXKNzXd0Y+vmBO6HCs+H0xXKwOtk6/IWZrROn40LVvZYTeO0mHfbRVTTCqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(346002)(396003)(136003)(316002)(6666004)(36756003)(8676002)(66946007)(16526019)(66476007)(6486002)(7696005)(83380400001)(4326008)(6916009)(2906002)(86362001)(5660300002)(956004)(186003)(1076003)(44832011)(52116002)(8936002)(26005)(478600001)(2616005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HhnyPd8XCP72VRI8ZDPT4OgpzgjlTHd6QUcZm7yf2xGbwNo7gwKBZGangOEj?=
 =?us-ascii?Q?VmVcmL2+5M/mqm1PBqxDT+B6HToA/OXFWToiIqWDSvzBjl0Lt4M8IgBGhMJM?=
 =?us-ascii?Q?+4HKi+JY+e0jq8Q2J3EHdPqqE48K8wSQdCOStV3scgsQoV3iGY215lHggsJS?=
 =?us-ascii?Q?BaofBDEMQkjiTyJdzL6bT62CXnfnohSW/DhEsE1mVjyFf7hqDyQYDUGFa+Fw?=
 =?us-ascii?Q?Vtx/lj4S0dMtcrsPCRnA4SGRmfJIEgjRDpJz94sDSdlUjhVY8TCe+9d9Zbti?=
 =?us-ascii?Q?xBxsV4H8NfPsxrWL0ev7fhheQw1t0H1qceQG9vjJlK4ipumYZKHxKfaPKjNf?=
 =?us-ascii?Q?ehpoDtAP64Orb0mdGb4SyGeUPLjsyz3Z6gTEtZaN4mFJfAdCtCEO8btlEpSg?=
 =?us-ascii?Q?2PQk2ASoSuhKbwbc99gJrWRmYQiQKuJW00rCRDF/5qaqNY1W18xCvA4ioxby?=
 =?us-ascii?Q?oDG0w245SS8e4qBl0enWAyiPo46a7ZQKtff1jgplE6WowoREW2ao63iPfT/5?=
 =?us-ascii?Q?jBDmaE4QFagf7X0liHGiDo3UWHghw7bwFK/p970UzrZR8hXGJ5MY/YU3Hgjv?=
 =?us-ascii?Q?5YCLoOG6KAV0NLVWEGHci+AEPy2E0JmnGwcplxba6q40tCYWaznJdoWRUgC3?=
 =?us-ascii?Q?xZRiuXOhME+yxsHWr+K0r2Dz4kZbI6qTsRBLAAh/Tdq+oWp6nI45o+JTP5Px?=
 =?us-ascii?Q?uU2+naelCSju3lm5cyvRq1RLfniFOGivdmYFCfQlCAGWKY3fjSpb06eKMqXX?=
 =?us-ascii?Q?qjoXf3jq+OCfo/aDpr1PtXTGr/9I/svuBDMNSrtPKzv16OYhm8R/ebzWGI27?=
 =?us-ascii?Q?XGP5Ku46p6Lt0OHtAbaspAa+jxkOi8L6nUfsSu8rrQe/j32oM2ORgVsvxCel?=
 =?us-ascii?Q?UISqqd5uzmgkiKYD2hP41RXr+FCHSrXnCpWooHW4M0elyL7UaZLLsfuKUInv?=
 =?us-ascii?Q?jeGpen8cpc+ZRcgncuLzz/2GD/eCS+ZLomam4sN/AbwkOFIrsN0vBYaSHSaS?=
 =?us-ascii?Q?wlYcLA/JMpd1srzGbHPjJmmBRBZT+nhl4ch71oCUIuCDMqTTsdhdC/iDmYQs?=
 =?us-ascii?Q?9hi24O5g?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16d09636-a85e-45d7-d614-08d8c7e9c2a9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 02:16:48.2421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m9EeoeQEvyu+PxRfIP5ym7yWJO/EljHlBVCVY3HAsNMVd6x2hqFYzy8PcVuJtDlQy+/1bMgQIsfL23DTp7a5VXYw4nCFQBXhdr7NFXYPIV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4793
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030007
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030007
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helper functions to set host RFLAGS.TF immediately before the VMRUN
instruction. These will be used  by the next patch to test Single Stepping
on the VMRUN instruction from the host's perspective.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm.c       | 24 ++++++++++++++++++++++--
 x86/svm.h       |  3 +++
 x86/svm_tests.c |  1 -
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index a1808c7..547f62a 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -179,6 +179,17 @@ void vmcb_ident(struct vmcb *vmcb)
 	}
 }
 
+static bool ss_bp_on_vmrun = false;
+void set_ss_bp_on_vmrun(void)
+{
+	ss_bp_on_vmrun = true;
+}
+
+void unset_ss_bp_on_vmrun(void)
+{
+	ss_bp_on_vmrun = false;
+}
+
 struct regs regs;
 
 struct regs get_regs(void)
@@ -215,6 +226,12 @@ struct svm_test *v2_test;
                 "mov regs, %%r15\n\t"           \
                 "mov %%r15, 0x1f8(%%rax)\n\t"   \
                 LOAD_GPR_C                      \
+                "cmpb $0, %[ss_bp]\n\t"         \
+                "je 1f\n\t"                     \
+                "pushf; pop %%r8\n\t"           \
+                "or $0x100, %%r8\n\t"           \
+                "push %%r8; popf\n\t"           \
+                "1: "                           \
                 "vmrun %%rax\n\t"               \
                 SAVE_GPR_C                      \
                 "mov 0x170(%%rax), %%r15\n\t"   \
@@ -234,7 +251,8 @@ int svm_vmrun(void)
 	asm volatile (
 		ASM_VMRUN_CMD
 		:
-		: "a" (virt_to_phys(vmcb))
+		: "a" (virt_to_phys(vmcb)),
+		[ss_bp]"m"(ss_bp_on_vmrun)
 		: "memory", "r15");
 
 	return (vmcb->control.exit_code);
@@ -253,6 +271,7 @@ static void test_run(struct svm_test *test)
 	do {
 		struct svm_test *the_test = test;
 		u64 the_vmcb = vmcb_phys;
+
 		asm volatile (
 			"clgi;\n\t" // semi-colon needed for LLVM compatibility
 			"sti \n\t"
@@ -266,7 +285,8 @@ static void test_run(struct svm_test *test)
 			"=b" (the_vmcb)             // callee save register!
 			: [test] "0" (the_test),
 			[vmcb_phys] "1"(the_vmcb),
-			[PREPARE_GIF_CLEAR] "i" (offsetof(struct svm_test, prepare_gif_clear))
+			[PREPARE_GIF_CLEAR] "i" (offsetof(struct svm_test, prepare_gif_clear)),
+			[ss_bp]"m"(ss_bp_on_vmrun)
 			: "rax", "rcx", "rdx", "rsi",
 			"r8", "r9", "r10", "r11" , "r12", "r13", "r14", "r15",
 			"memory");
diff --git a/x86/svm.h b/x86/svm.h
index a0863b8..d521972 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -391,6 +391,9 @@ void vmcb_ident(struct vmcb *vmcb);
 struct regs get_regs(void);
 void vmmcall(void);
 int svm_vmrun(void);
+int svm_vmrun1(void);
+void set_ss_bp_on_vmrun(void);
+void unset_ss_bp_on_vmrun(void);
 void test_set_guest(test_guest_func func);
 
 extern struct vmcb *vmcb;
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 29a0b59..7bf3624 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2046,7 +2046,6 @@ static void basic_guest_main(struct svm_test *test)
 {
 }
 
-
 #define SVM_TEST_REG_RESERVED_BITS(start, end, inc, str_name, reg, val,	\
 				   resv_mask)				\
 {									\
-- 
2.27.0

