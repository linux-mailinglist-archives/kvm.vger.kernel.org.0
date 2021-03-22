Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E4D344F64
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 19:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhCVS7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 14:59:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53996 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbhCVS6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 14:58:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MInvlX005241;
        Mon, 22 Mar 2021 18:58:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=kJcYqcSQYGBtDVjs9sSZ/xT/IydNqFtYLSf3Epfj+M4=;
 b=MIpmKzEeibB2jVI+171LpaO7koFkLA4AgpEneigsZkOF9yc5Ff0Sgeec/tjbHGvVIEAR
 4CIeZEtDHqU5baP/itOhqvZwmj0vP3nuA3EeAYg2PeXP8AYEdl2iZX/2NzF033wrSG3j
 Z0mgj79e43L5uMmhb9tp80kO5b3vXvQkM5KD3GILHRkftDEypaObdpnrX9QJZPQY3qSI
 4amwxwCo1lwvgZvWABxEulKRxs/d/B3ACrhmZUnM+T19F+WCBz07bRFadG3zzy6aCpOY
 4/u7JSvVa1dKQdUBAEmScyng9Nv2Lyz5o/b6KBpt4IiRHMoC07AJgHhPtTjcfvGmENOA 0g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37d9pmvg4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 18:58:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MIo6TY134562;
        Mon, 22 Mar 2021 18:58:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3020.oracle.com with ESMTP id 37dttqxydk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 18:58:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B1GLmBSpOe173cngIRoIHsZnO0e9QFE/dVwPKLZhrRcvL6RtQYjIWL+E0TY/NYhwc+06ZQeu+XnMM9wtBM4kbv3Tb2houxzk0DO33XfiPQgAVUlwXpiPqM+wTAdQXIZQqM/sNzcRAhi4HWN3GskrGWkwTr9YXBfBqP16/Bfi1SX94q3IbPRc3GsaMMiXggzJQBKlMmuPh9h06NGMgeMV7G3Ax+IhQ0YoQT6TLrlJT64dJZlFPJwbp+7AbXQU2WyIT0C+vU3bhHrikMZ6HwPRtacpT8dX3T2LoW3ug9yjjsaZhWM+kLPAs1ly+r+AHEgODhXVlcVk2RVY7L3aW5lwLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJcYqcSQYGBtDVjs9sSZ/xT/IydNqFtYLSf3Epfj+M4=;
 b=ZoHNpPFKphYpyopeC4x7ShFeG5rKiwJmgECxqRtJC6D2R+gFf4TzzhcBzsdwfiTYhQC3CmD6V+q0hae6FSqfKrojXKb0PBMQDxbThTvblKzCaglc9UJGs3KFfF9J9fUun2GHyhbKa99Pu+owms8qO7H7JOhvFyRCrDsFUc0A7Ae67cYYGzVLJChxjcph+etUzjNFdPAfRgDVG/g59AdtAOyCNuCKIX1424Hvc5tjoWhF8+NOpBPsPqET6zXprc2OjwjSW+OBj9mMVA8rG+cbc/cnUhMS0uRlJRehpnjTceBF4CRvHFIq7n3j9rYzUvjNqChl7pukTZauRSR4lrxdsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJcYqcSQYGBtDVjs9sSZ/xT/IydNqFtYLSf3Epfj+M4=;
 b=RS8CgTNPy7KMXWfG9TtJqIss5X5NBc5aKPn93KLivEzsUfRW4MIVuykzSlG4bDiI6T5ndVLrMZMWOK6WPzalD5Kt0N6zhOU/3EBzuk2l/QrWqvGtKvhB6Uo7NnFR7gXrly3m1LivF438BF9juBU+bM6ABq1Eomo/oaR0mtkuoo4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 18:58:43 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 18:58:43 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 3/4 v4] nSVM: Add assembly label to VMRUN instruction
Date:   Mon, 22 Mar 2021 14:10:06 -0400
Message-Id: <20210322181007.71519-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210322181007.71519-1-krish.sadhukhan@oracle.com>
References: <20210322181007.71519-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: CH2PR14CA0021.namprd14.prod.outlook.com
 (2603:10b6:610:60::31) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by CH2PR14CA0021.namprd14.prod.outlook.com (2603:10b6:610:60::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 18:58:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0937393e-8ea0-4e67-4ce2-08d8ed6483a0
X-MS-TrafficTypeDiagnostic: SA2PR10MB4795:
X-Microsoft-Antispam-PRVS: <SA2PR10MB47955DA1643EB728989FDC6381659@SA2PR10MB4795.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2qbtK5s2MaLbyHK1LxJZE6iYESoVltlR+6lfEEswM5/nqwuOtfqU4/2Xh2VC4UMW1eJoB9vFJLO2L8aBPDxls8LR3l0Y+Xw67MPAWG+r117S0MkFO82ZKrKn1Hq3qtM8SkZlpQft1KTCVZaoN98tX+KxzhFVGHK9NTyIarx6Yuls8a8s0njMCBlH/Gc5GL8ZIcke1iyGzo6Q4EWRL/6xxlCyanl+TEpcNM9IsO/F0hd9usjMbjKoOXmSC55/JfbgMewVJxR/0/zeiQDd5YxlFQmvYdlA7NNwyYKkj6JpAVVuIwJVZYaVEpnQ8Y6hBIPlz4Tx+hV2Ra60f7gTuw+i0S9unaBQZVSD6TojD68a8l2yyoSn5mXh/OiQ4OkWhwoHinnh/O7E98f6h9J63xIfz5sxWF5UzsW72IgHo9jglOgAZu2VOABUYWLRmhT+NbqZs9KsfZ7VCxCtYiBliVnu6vzrIp0di42Rqfme3OipWyG/GBQwrjGo9aK9Kcr6qPGrKw/65nMLty8FKSJxDJl/3EzO+6JGtVbwq94DkT74wbStfpJ1JU2HzzGwsXVb5fEDLCdDGvg3MoT+mG7jAHjRP6ZMf/sKMj9BvAizSf81YQqtfRM+eGLbg7vZaGLWUWr9/vgUFFjBQbpqofxjf0fRuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(396003)(376002)(39860400002)(6486002)(2906002)(16526019)(186003)(6666004)(26005)(44832011)(5660300002)(66556008)(86362001)(52116002)(4326008)(2616005)(316002)(8936002)(1076003)(7696005)(38100700001)(36756003)(478600001)(66946007)(8676002)(956004)(66476007)(83380400001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JngtrAZ9AlmVvMipFdEKm+EXFJ/NbMY+176Lf9VpBG4ykInwDJ+gCkDhZNHD?=
 =?us-ascii?Q?MjOPMmxrXiIttWK1jVz7U4pD6F0/pdVzQyxqShF5qKhhtDjRXJrTrGN0D4bw?=
 =?us-ascii?Q?LgofzJHcOCBwWLxesbZQuUBwxr/AyjZAuQ7KxWkzmS6wo0Jo+u4qYIM7sIe2?=
 =?us-ascii?Q?+MYmHDsUh2lx4uAnvUWy7me8sXNO1G4mzntkK/Muvo2JKrnoZ/p1eBzvLqWd?=
 =?us-ascii?Q?5Pmcr8T7gtjREzndXV9NFS3n9Ah0GiL98BTsvLLYpyjjNF5C8Bt5l/NfP1lc?=
 =?us-ascii?Q?oUlsXVWqrJan27z7g/XkKYF7KC6b56x/lZ1zyCvNDpMLjS5kTpbNZW1gLvTI?=
 =?us-ascii?Q?YHM2X9sb3mGxi2EmVx91JbV0sH+c/XQHh9uDrlUgy3wSS58fm+GmcI1IMJ6p?=
 =?us-ascii?Q?mSyntloRa3VRNca7wmlUR+q4gM5m9P2YP5J2LGNmTgEtuiSmVSfxJwzFvatM?=
 =?us-ascii?Q?WX7etXLlNwEUq8wMBB9eePui23GNH/k0TjqUlocmVEn0mZBr/SpgXcwQYOtI?=
 =?us-ascii?Q?DHEkon8+RCvKIKyE4EKfbO3WqCcdiBFsJrV0XSK+Gm8UG0F21lhOiIN3O15d?=
 =?us-ascii?Q?1wQahC5PV0ODOBu6tAini5FldTzmKaiojo+9+i/z3dMRHpdF+sySCUuilVdo?=
 =?us-ascii?Q?M0N5vya61AoV1waRwUagEVeycSwLfz8+lE4vXXxjJjMVyaNFoSYeagiFRvPM?=
 =?us-ascii?Q?Fwk1cPPutb40gfUL4WPt70T5N+D3yNhTiqoR4QYGg7yVIiiVih+rca2aQtvp?=
 =?us-ascii?Q?UrqulFtieDaa9bqxw3SDNJX9KjGxc322179l0Kj1/I0h+4e0fMa30YoNdk37?=
 =?us-ascii?Q?RuHDndPjsgBAaJODOHACxLmJV0fOFGkUysIIXBi+hAUp4JeANgfahYBWE7Qn?=
 =?us-ascii?Q?L14U+Ab5BC6GUtmFiuEuPWAigDt04ZiViNrCEVl3+4eD8Z4R5SYJhgoz/PkU?=
 =?us-ascii?Q?vWMc7E3gvb6mGKTQLsDORZLAdiGyzktG+xsp0FlJo3eHyXL07Kq7yXLiPWOa?=
 =?us-ascii?Q?7wEozTvS8uXlWZG0tqOPS64SqUKvX62mQvpYJlP5Rzq9/PYZhSdDc2/ztlO2?=
 =?us-ascii?Q?UfDYo75fxsbtvUtyvM4M4T+y/Y644YvjaMRZXFd7TJPj+PZJtvotw0uAtg9O?=
 =?us-ascii?Q?RU1wJEDCKGhPclhRW+YeMW92Qhw6JAN0VHDFFtiGoQfnUZ59WD8Y/sNg3Smv?=
 =?us-ascii?Q?Ldot87YzHUDYj2+DeTyyhTIHIuxoLtUTOr8fxNrC3ZGaXex9tOLM/COFJnpg?=
 =?us-ascii?Q?rI1FkzUz8EbzWPWq26UA+m8rXXwoeMkXfa36VLC/+/i8hhuYXHkvEvGAhPuu?=
 =?us-ascii?Q?U+mxS6cpQSciRm3lPfzYKuRx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0937393e-8ea0-4e67-4ce2-08d8ed6483a0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 18:58:43.5967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCmAChhKMZfGz1+osGy91K/X0LeAASRZ10TSOsdIijhpRwIl4DqqbkSGiByVTpn58s2tryWhofCrFkoD19urZW+V5dWY+5dx5bliBvOfqDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220136
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220136
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an assembly label to the VMRUN instruction so that its RIP can be known
to test cases. This will be used by the test in the next patch.

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

