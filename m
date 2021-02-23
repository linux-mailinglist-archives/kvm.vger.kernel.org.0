Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97E93231E4
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 21:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbhBWUKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 15:10:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41240 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbhBWUJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 15:09:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NK3woE091375;
        Tue, 23 Feb 2021 20:08:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=X6z1gAXO8hMUp5ADhTwYC5JrmdLMsJ/F4loi4h97qzc=;
 b=djGLKissKpyKut/RZzlTe/MGWemZC9UjhpYxaowAJUFUGRJ96gpuPt7ix38vWuzXUX/Z
 gtT0NSV2+QqxxVGymyPKQnatv4MO6SNH+xmCN7ER3VKB2EHiAMa9+YmRuIl6aLklpUru
 l/P4jSj49+O1dD7pgdN8sfMt9nMBk4P8Ar/kEoAFtQ+9UA6tRBhx9NMz4uW2S4qjjV+e
 F3zgdLWTp/gsJkgOYXCD1HAfGXD7w+nO09+8vlHjcBIlkpOiUhhmmF0dy7wondEtJlL+
 cZXNEG+sQY5FH+IyrxGJ/KkE4L77MT5+9nq2uV349Rdzs3y/lnS3LVeITgrYDVZOKCV4 uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36ttcm8pm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:08:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NK6VdA106920;
        Tue, 23 Feb 2021 20:08:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3030.oracle.com with ESMTP id 36ucbxyc3h-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:08:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWtQJACA/fwgf1ZfuXzls77J4LNgaJ2/gPzC4D1yzl4QJhLbsGYQKs4Hd6uXRaq4+5bMvMaBrKKiWqmTWWA/svMk0ZcgFsE8lU/zu/FOyT0cWuAg7Qh6U9qmum1N/AmxHVHyov0wnUpvZxBPfJ551yvCK0NdBIBPZ4CDQvsCRO545TDnuhfluo1D80dFdOkQnKV4w+j2CiC1K6bPv/iB8izoFY5AK1L2EPO55Tss+cTRkpDWT3SFbvwdJxp736frtsfkvjV/zDgztyM5bjJ5M9yHgqFrOSbKvhnj83++njU4EshvHHVhS794kqr5Ur5H7ekaSi7qx7kgOL2qQLbUiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6z1gAXO8hMUp5ADhTwYC5JrmdLMsJ/F4loi4h97qzc=;
 b=IeA+eicm/lM3TiyWwg6BhW155jAI9Lyb5NQlv9279VMP3Dp2Ts1oxoSIjlhaWK9IVcxQRg54qIiWyYRsdYJQNSkzK8iJEwcSfWountcdcCl1wy+jydX5udw+5w00g0VeiSsiEFF+m1a739c0nJ0Ellggo62Jd27FAJyZM8mK9dyzW0cxMGvqIUk5SezxiaiUnftw3skNvvZaMfUFleYQD90A41VEPyxP+20t8kG3n/6j2JPbkKA9PtKmYvOd9O8G3dYUzx4iA74MfaWH8A2XpeQEdvRyk/vT3eXb/UZLwGzfGTpBE8IvVk/jLhk1KEHM9p8XHP7lL4XdYi1YNuCKrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6z1gAXO8hMUp5ADhTwYC5JrmdLMsJ/F4loi4h97qzc=;
 b=GcVQOhl64DyYyKDLn1R71n2sQPGmjSsYVZ+LS1zXdbEfG+NrSF4rzopAdTohm+FHr4d6DgOONfZDMN2i1ck7iY0T83gDXHHZyrICROa4N+2cdRVWOtws7EeLLznLQTl1zemh/iY18jMVeVfMhRLKzN052FSZIts2yfHW9wNsqAQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Tue, 23 Feb
 2021 20:08:17 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 20:08:17 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 3/4 v3] KVM: nSVM: Add assembly label to VMRUN instruction
Date:   Tue, 23 Feb 2021 14:19:57 -0500
Message-Id: <20210223191958.24218-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210223191958.24218-1-krish.sadhukhan@oracle.com>
References: <20210223191958.24218-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: BY3PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:254::31) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by BY3PR05CA0026.namprd05.prod.outlook.com (2603:10b6:a03:254::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.10 via Frontend Transport; Tue, 23 Feb 2021 20:08:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d639a3bd-d187-4333-9ea7-08d8d836c26a
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:
X-Microsoft-Antispam-PRVS: <SN6PR10MB3022D0EC982871B7FA0D3A9D81809@SN6PR10MB3022.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n1fnfW1htOIZc32FkXITFrHbLQ92ZgcyGkldwmS03Akn+sCCP04AS7VTs5zv9iRJ/PWhWZqqLKNzpKArbNDeE8VEAoJVkO8ph+qcIl7OUKr/7+sAmmHf5V8f678qxInx4qZoG3DdaX8hRFSsXw3kqV9gBLkQePea2rb7Ae5fNZAuV2vv43aghLrxOR8DUEryrsr6CUhwWqdFzTznYXw/8VCtsKtgVYJ0WUyNtGAOHKHoIhw18BDVvdNW3ai1KDQKaA1byoN2g4akRiw7FqhN+xcHV1T1I4ZaXLMemvYK/fV6twnHM9vWkrXiOrkdUysv3hPdFx9I+N/Jf/1+FFQeugYr7SambY4OUTyv6TixTM45zqtzvb2n+tWkslqDENx2IH/RX1hWAAM1aRYGAeFzDm5fWCg/0qxi+EGnPxVOlqjd9BIaYNO6mfTCK7oLhaAlQkrcIzwIZzWfZeJ8iEzD7i39YJy01qVF98cV0nAyi84Lor38ri+UgZ3cnVS/uqb+BfLIU5I0pgmHYPfR0gOdUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(396003)(376002)(136003)(66946007)(26005)(86362001)(7696005)(66476007)(66556008)(52116002)(1076003)(186003)(44832011)(16526019)(36756003)(6666004)(316002)(956004)(2616005)(6916009)(5660300002)(6486002)(4326008)(83380400001)(2906002)(478600001)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eQE/FEZRPQVNUIi57ycInasCKuxghOsZWqgrYK5LrSI5CFMuOOSbu8913aTe?=
 =?us-ascii?Q?LKuMa3KCLVn77cuM3ikcsiyzbkHT4wLNU+t+ko2p9aAdtvQU2irdSJo3zs2a?=
 =?us-ascii?Q?lgJBBSyjtThcgh3O7NndRYyJDFtsd0NwQWbBmbeafW0XcdplETiW2Kf6igS6?=
 =?us-ascii?Q?a2T4ashrnuX6N5yVmOqy5DBd0qF1gkRagWti7vpVhFOmjEjs3P4M2i3uPnh4?=
 =?us-ascii?Q?DKue+y7HABqihh6WBNaJ6x2RJD+oQ2lo6+vOJGn6LAYMkfWlge3/atbspwtv?=
 =?us-ascii?Q?5Fuz5IFDB9/cqfelP1f/l9rBMbQwXeKIjCRz2EuIXMSgLIUHns/vt9i/WuaZ?=
 =?us-ascii?Q?yGnj0o5UTakJVi2MAHTVw1DH0Q3O0Yw1X7khzo8leGL8WROqtlZoXZZ4N/DF?=
 =?us-ascii?Q?iD1qFW+PI7Ot57ZFCK7szdrWPWzRyYU4XfrXROq9mnaxZwIj9LJwL4cdbApY?=
 =?us-ascii?Q?bydMB0DTo5bjSe1/4XDTaZkedgHKXRSAQxwJxbEJLjnQKZQG7UPjwrU7GN7M?=
 =?us-ascii?Q?9peuf3mRhE+uvyAB9Jc5GAP4pyyii7WD/sxKohOHqijwZ9zY8Pm/dVdUfnQh?=
 =?us-ascii?Q?IjKOGIAc3UMcF2VRti9oRgi7TSN2LiisWxXKPpXjJYX6yWx/RYdDxoAMARov?=
 =?us-ascii?Q?D/RzTYMdwcwoekDJl0ANnK+SUhcOKnY8kjqGBb6EJ/+cRQFIDcsmvepoe5Hd?=
 =?us-ascii?Q?qnQ7korNw16biEw5PwOdTxU739E4iGJFa8wnZnOrhP09HblVacvbn8BwTaRf?=
 =?us-ascii?Q?PbJk6wDtjOB2+wRxeIsGuJkPFIR0Y42qsP/JoDl7ieyqfgPuzU4AgXSAOIMa?=
 =?us-ascii?Q?0z3bY6zPxttuN1e2xd6SbfxghYfnzxh8OQhfnFI0ewNQ/9oP0fXlm1gGkqDF?=
 =?us-ascii?Q?4ytMwNBjTTmy/AcxTcRpGy2ypWeBxWHSyEj3MVaLp3byT6t0eYctAWH6yVPZ?=
 =?us-ascii?Q?xtB7Y5Dq9t2ujmC4Z+YsAaRvI7lKc6dZZnTf73XjA8t15lRAY9a5K2lCX7gf?=
 =?us-ascii?Q?EYkh0u+aZJUqu7MixOt5IR4kJWrESeHnGD73IfH3ghScENDg2aUafmJ2J/cg?=
 =?us-ascii?Q?mDQo80uJrFDSifmxRmHoJ84yABgePVl8oFrKBCOgbj6hyJGAsVrOshIONyVw?=
 =?us-ascii?Q?jBzQoQ7jU8v2s9kmbe6BrdzVt5eGihB184o6HGHOsJEP6vnHJq0zAKGA1j//?=
 =?us-ascii?Q?hrsXBw9kQ/HVc3DCtMc6Fzt6IC43aOKbXR0gWuH/3eu00TPrw3jHlb5Gq906?=
 =?us-ascii?Q?u5pS9RGVBIS/HOkWJEIRWvx+KXW8vvjX9XV0eBCMg0txLO/Z2ok5OathIPPB?=
 =?us-ascii?Q?S3Ux9f/0J5N51FldaJuthnzh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d639a3bd-d187-4333-9ea7-08d8d836c26a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 20:08:17.6964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ubuDQ1u0vIVLFrXDlbwRWGXq7rw/mxDDxYfFnBMs0Hc6KDkY2e2THfWQicU4BvEDJiyZ8HA6v41uBZfwJpmo+MPVKO2F0RXSljoRxmIUKLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3022
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230169
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230169
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an assembly label to the VMRUN instruction so that its RIP can be known
to test cases. This will be used by the test in the next patch.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index a1808c7..77fba8b 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -208,14 +208,15 @@ struct regs get_regs(void)
 
 struct svm_test *v2_test;
 
-#define ASM_VMRUN_CMD                           \
+#define ASM_PRE_VMRUN_CMD                       \
                 "vmload %%rax\n\t"              \
                 "mov regs+0x80, %%r15\n\t"      \
                 "mov %%r15, 0x170(%%rax)\n\t"   \
                 "mov regs, %%r15\n\t"           \
                 "mov %%r15, 0x1f8(%%rax)\n\t"   \
                 LOAD_GPR_C                      \
-                "vmrun %%rax\n\t"               \
+
+#define ASM_POST_VMRUN_CMD                      \
                 SAVE_GPR_C                      \
                 "mov 0x170(%%rax), %%r15\n\t"   \
                 "mov %%r15, regs+0x80\n\t"      \
@@ -232,7 +233,9 @@ int svm_vmrun(void)
 	regs.rdi = (ulong)v2_test;
 
 	asm volatile (
-		ASM_VMRUN_CMD
+		ASM_PRE_VMRUN_CMD
+                "vmrun %%rax\n\t"               \
+		ASM_POST_VMRUN_CMD
 		:
 		: "a" (virt_to_phys(vmcb))
 		: "memory", "r15");
@@ -240,6 +243,8 @@ int svm_vmrun(void)
 	return (vmcb->control.exit_code);
 }
 
+extern void *vmrun_rip;
+
 static void test_run(struct svm_test *test)
 {
 	u64 vmcb_phys = virt_to_phys(vmcb);
@@ -258,7 +263,10 @@ static void test_run(struct svm_test *test)
 			"sti \n\t"
 			"call *%c[PREPARE_GIF_CLEAR](%[test]) \n \t"
 			"mov %[vmcb_phys], %%rax \n\t"
-			ASM_VMRUN_CMD
+			ASM_PRE_VMRUN_CMD
+			".global vmrun_rip\n\t"		\
+			"vmrun_rip: vmrun %%rax\n\t"    \
+			ASM_POST_VMRUN_CMD
 			"cli \n\t"
 			"stgi"
 			: // inputs clobbered by the guest:
-- 
2.27.0

