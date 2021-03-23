Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703293467DC
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 19:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhCWSjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 14:39:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60464 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhCWSi5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 14:38:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NIPMjF009484;
        Tue, 23 Mar 2021 18:38:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=DoLsFaw/3M7p92yrqsvpbA1Q/z6kTAeuUn6VDbkWP/0=;
 b=uj/yiCUVw/uTjR8zYJtgmEs1WSK1v+Qxw1V5aUJTUsbjVoJBvYUXdvBp23atO7yKgA4i
 GsUPX3jWlaP6uOlh24Z/O56TdojOW22yBOLDFDxDGqS31rJTLqRE8pmb3R0OJlnJXYkG
 quCoMsBoA7hYlMOIjv9fQRBCVYbt1JWq5ZTtzkA7CaD3JIyBTc1Epx6drj2xVJnCpkg1
 gYXSpNE5shizNxW1f9xlrpL1LOLQZER7CxVCKztmwDntoCz5IatRfQPpzVJlJaCoLgrZ
 KHMO0YkAI0U4SsFqOt5fE+3lix9oPmk0yglHDePuYgUuIJf8N3WuvGAFXlwoQGFYF+l9 Sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37d90mg6m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 18:38:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NIOkgm144196;
        Tue, 23 Mar 2021 18:38:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by userp3030.oracle.com with ESMTP id 37dtyxtv99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 18:38:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgBjM9LFCYsedeij8wDN/b/5Km7/mXdp/XpxnpDO8q1eRajObIja3qzjUDlVunLSu4hcfyhJ5NdIEprce2OOfCGQfyKsEKZLhJpM9nGNdhuSCnKLydP4X0GM+OgY9iEutds6ulA9ZiY/rMue80BSv8nOIKzyIOTANNowV5t7l05oy/+0uRaY5ZXq5vToZhb17rWpeV6hKeWJrEpgDRSeeHOlCcSNyN8dltiWREzmeKNES3QgzHoYWTjvGIjtlt0JT097YWPzI2s3OhVlRd8DKMzvV0a+CdmIJXA2vzOoNYjFoel1/WCeI+TodEbAE0AhsxrxcOFvCkYxnE13oyRyFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DoLsFaw/3M7p92yrqsvpbA1Q/z6kTAeuUn6VDbkWP/0=;
 b=KwkN2ys/w6mffF2HNF1KYgDreDfhu83xXcpVCvJmeW9GRGfHfiP90himCJoK2bB9kEjv/boYe/HVXC4Q2PMcG5Mp2G6wQ/HUVSq/7P71byFz2a/gF8irEHPxyQt9r0/d0NtN9G007xg5gbAHgx70dczgN678dG/q8TLSBgQT8DRyTjfJ2DCtYc/WGvBFp9qIaa+EwjbnZB41YecCjDlTcE6PvkGkcC6doDnPSddYUF68xzQL3eatUco5P7fvzs8vlvs8NHrzsoK9iPaN24Hhy/H82C/lEDZnRedB/cqc0zEaIaRoA8rJ2pV0cUu5z/ku5sqznaz2OJfF5MJAyWPzog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DoLsFaw/3M7p92yrqsvpbA1Q/z6kTAeuUn6VDbkWP/0=;
 b=qB+Xv8jXqpyHhgHu49tdwZ+r354Htk6WWJHORR27ql5oxIKFyqFqUfdTKMEApDABOgTxKyxrZFVsWiTQSYn1ck2xcZj/fd8KrPwD2SqFmP9OQdpvTNgH1I7ya9vuJQijTycnDBqld5P9vTGGRKalJ6MqMjYKriO75fQ4QLeTNtE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4682.namprd10.prod.outlook.com (2603:10b6:806:110::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 18:38:51 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Tue, 23 Mar 2021
 18:38:51 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 3/4 v5] KVM: nSVM: Add assembly label to VMRUN instruction
Date:   Tue, 23 Mar 2021 13:50:05 -0400
Message-Id: <20210323175006.73249-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210323175006.73249-1-krish.sadhukhan@oracle.com>
References: <20210323175006.73249-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BY5PR20CA0008.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::21) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BY5PR20CA0008.namprd20.prod.outlook.com (2603:10b6:a03:1f4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 23 Mar 2021 18:38:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe1d3d2e-8103-4495-5948-08d8ee2ae765
X-MS-TrafficTypeDiagnostic: SA2PR10MB4682:
X-Microsoft-Antispam-PRVS: <SA2PR10MB46820E168D26DBA5CD9639FD81649@SA2PR10MB4682.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Lq5xKD9AdgFRy09z9MpOa6Wv9LAST0yv5JPUfcjZpM6EzwEIMT2W22iO4pt3QsIhy+0NqlHi/yoHVC+rNul0ClNhUn7k1eXCN40o3fK5esblC0Xk2suRwUkLrBZi67QGxxCtNUsc33glvuIqb9ZNZcaUlHGhwRwLs55woRn5d3mpVfHTP3IfJPNcZht1cMlKgOZwiyWF3AvJjXAq5jGs6FZGCSHGG8Ax5FmCb4YLuMO1Zq4/xlKeiHENxEX9ZsYOzZ5GvKabt0wTI4qC1MqVya88B53Ujp44BcbqCqAiqZ4nnjlF5evCnLqgSOCH12ChLguOU3rm8hreAtwdZvVMYWdlML2f+6/3N5i3tDg1GfXymn+PPGE0BUH9v8r1VIaNeIWxggFsEGTIrAoDu/TT8YMqcYw8LGr85sf5jAo1ECzz9TC7FBze4a0FVWZ6hspy2CQyHG/2reS8YJYaOBdlGzVKd/hsRE/GF4bt+H5FGKGyy1J9g8KjPVK6gPVN5u6B2fJ+qq3IX2hGk0lUbU/119jm1g8wj18dWbEzn+NGo8fmSZpLpAy4+Np9xNo79EzOC5n6pMJUT1LKncItJRSeeLAD0Gv4ZcmIiKBr1HVKRx6iSfKS5vK4FueHZiISg/BmyIPiL213r7sfK8rdUIlLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(66946007)(44832011)(38100700001)(7696005)(6486002)(2906002)(4326008)(36756003)(956004)(86362001)(66476007)(83380400001)(66556008)(8936002)(2616005)(1076003)(52116002)(6666004)(186003)(5660300002)(26005)(478600001)(6916009)(316002)(8676002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?llzEkuF1D8ctu0SoI0vxaPGbPD0BLkTvQLpSkQOMMs9509iPW0Hwp03tac0T?=
 =?us-ascii?Q?vqg5vDIF51M46YX+rLxkMYQPjI2lOYP3BqZY29dPKLiH4AE4N5+Y2U7KK6bN?=
 =?us-ascii?Q?vGuv7ymYSSOs8DKp4PEOz3//Au9n4WU0r936oaUzX6j8agFdZxeami/zI98Z?=
 =?us-ascii?Q?IrY+9gtIZf2YCHW4g4FvnPVdKTLLXcQnm8QJ3DJW7EqiDrU2H7+gi4oCY71k?=
 =?us-ascii?Q?n4cm+rmob2bUwTmbubPtyWwoe14Jq4JzoceeYfq0JirwLxOXuDq4g015910e?=
 =?us-ascii?Q?YqftmL/aKcpduRzgyFIbKaDbnUFHSMasH+MbRTaEVpDi6pBeiNUs4uwAC9t2?=
 =?us-ascii?Q?6Vide4DPBMQb+D3lHSFAZaxhS1JUQwSspkNa3kk7pSLmLM02LJTTxslg+l4V?=
 =?us-ascii?Q?BV662hDIFkCfwWTT+wgpJIplHU8B8H3sweceFszXK+2A82JhRw383qpHT4v4?=
 =?us-ascii?Q?FhigY2EBVEdGzqGlu5oz0sO+8qQxcUy2GUrPEEUJXzvtyzLJR9M+cXf5n2mG?=
 =?us-ascii?Q?99dLtAMHqKE99R5W9eGAA04bm6CFK1z2QptCTve6cnmHpvSYoAJLDm7CBS+9?=
 =?us-ascii?Q?0pCrvB9JtYNtNxyj3utm6bGvgCxctf1iqku1Nxjor7UKB7Ztql7z+JZY2DKy?=
 =?us-ascii?Q?jHFoSIp6kBBGkCGmOjhYr3WRZzuYv7sJvp3HM+1ero8DZi51mURcsHzoMb/2?=
 =?us-ascii?Q?XbRr0VW9t+7bOuYzbOU9lNTB7a/v701Foh5S0nI73/NpgRrBOfBsiEPfnQbu?=
 =?us-ascii?Q?60m8ICHuYvOugJ81kxWC+sB2B0seueefLb0BOfEmKxuYu+XjcerswmsWQCiG?=
 =?us-ascii?Q?H4rd0Zkky4hX+s2Uv20a5JK60/p9oKq2Jo7sRioFkwKoONuZW3kKe3GfLMuJ?=
 =?us-ascii?Q?d3LG0pW839RVIxKrYxRKOOE48msK//WFRSVOfJ++9dqtnG8RpgHt2zidXz03?=
 =?us-ascii?Q?5CitAmIqqseMGRoP9tl6af+Bp2pi4Owl+2ont+GvZe4jak2qZ7wCMF2wnhch?=
 =?us-ascii?Q?GZqiNZB19Dshj2vV4G7ZRYK69LsYevv8YqUMh3Xg3+QhijYKJBw2Nm1+CZaD?=
 =?us-ascii?Q?xZyy/byHZPFrY8f9wruV4wFLtZ7mhTUpMVgO6VV/IB2PqcsXNyj9fLpFUqy8?=
 =?us-ascii?Q?UAGYF0i1+i6I15iiLcugmo8nuHjXIKBF46haKjbjre/alBDygEChMUcr5riz?=
 =?us-ascii?Q?txMLC8gMYDQYCTdGJ1AzKxJBcprp8nH+ADJbvQFBDZ8zQG0H+hEy4kqoYe3X?=
 =?us-ascii?Q?8I7v9RGimsliup3IEe8Mcf9RBGcqfBYPAk7Gxrjb3U3T2lo1Olf2zd6pV3GI?=
 =?us-ascii?Q?ZvUFFh2UB+DQxnZl/RPPNwwt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe1d3d2e-8103-4495-5948-08d8ee2ae765
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 18:38:51.6707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3KoQmEEAUATV0myhMdoULEWSD4OZ4Ijc2UQgaqap0vavaQ/1dkd4TKbEdTXaImumTzIYizv1E24cN4CnnjyfxZJYz82r6DhFgP0bw9KVmW4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4682
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230135
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230135
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
index a1808c7..0cf3b97 100644
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
 
+extern u64 *vmrun_rip;
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

