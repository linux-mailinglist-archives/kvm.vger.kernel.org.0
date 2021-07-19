Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691663CEE45
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 23:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358090AbhGSUca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 16:32:30 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:63990 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1383543AbhGSR4V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 13:56:21 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JIV9RP018167;
        Mon, 19 Jul 2021 18:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=/GylK+0s0bDW45FrwyxAsNTVADBtJtBo2HyqLs7EcIk=;
 b=xdyVjAoDWe9mlO+ahk+CZFqR69nTG8axt/CzcwFcz+Vpx3wc2vkci8lvMUqQLk4+3XI9
 TkbkzQIRUpRhwRBCEygwAkfNrV5zKJdDu9RHS8o3UfSBMXHlaTfndcu/LUqr23QhzXQ9
 VjwXSgie+koelYH080QBqSrZZd6hlQtqNjzCZYygn1BEcGVGs+5OKoem0/KU1Weol+iD
 GJuMiCjZQr/suMqwsA/KV9yiHHmmdTvfu5qTeIMH8FbMCxCsBVAbvlnhO47uNDZBBV0Q
 ctxGAsji0n0xyD6cHtK+h6mqj3Jlr5TfK8GWoc//hlmYsXHLlDZCdeAMHuEJ4KPBts27 9w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=/GylK+0s0bDW45FrwyxAsNTVADBtJtBo2HyqLs7EcIk=;
 b=x00riqNoIYY1d7X1EosX/H/zE/R5CiM5iatOctIlDIV7BQRni6zRPuU7TA82sJGbkE0W
 hLGpED/FS12yWH2dCmBVfDqkTNGG5vMhk8lXGk7iWT0eoUkq3dK806JCYgO1h/gHx4u2
 +ZoSYQYW7lhIH7yy9Ph9rzZv4E7vsCFtwo+htJKDeKtbesCKINDTmdgK3ByUg/0UJHpD
 xq3oa9tWWjUOyB+WyEkk04bCQMQBgqKYzR/dD8Hd9tVcWsIwYoCFYasQXePikifdpvOy
 9XveP03rZVimMEIrvFfzY5PsOGHyMCHE1zfyflT98Av67JjXFYulhp0clGj1O7tL9heN AQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39w83crxh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 18:36:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16JIV3T6136392;
        Mon, 19 Jul 2021 18:36:16 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
        by aserp3020.oracle.com with ESMTP id 39uq156kk9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 18:36:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVFvWr2C4eioSVb1QaOh8gFFaKu6p8Fg5fBTmQ+AJedTuNk1eCMB95XXgiKd2dznU594asTLVqHlSGF2o/afBD0lATdxoxpIlZQxbyOTofd51c07YS1eIVa4dxxCMvSMaA/7HazSHPK2uM4LCdKzgBeDkxHpLQ0X0cda5RnOzjC94+82x1RM2GF6oxY7z5Hv76ezAiJ8YS6pRrxE07k51HbnuF29P5lGNxs/O7WHpNOlnug8kK1ydmJtwIOJDvdzd9dk+G6xLc3U+VqNQbadwrnFAMcZliPaY8qEpZKgWIGnlyU7R8J8ibOFmrxEZJ07TTHGdPqh+S7vdW3ARu6qdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GylK+0s0bDW45FrwyxAsNTVADBtJtBo2HyqLs7EcIk=;
 b=A18YKWOhhbV5SE3nM1YuTlfPjAcUAS69vkAjrkHpzxpMQhN0Bl1KdE+LGdUsyNta0exdixraE2pM0ETbqdTbDUz+d9AazweNKOiceLfph4AYl0P9lAGtZ/Ttq9RN+dKZs3BlEuiQi8z+KuTAjnFn5bPg+2osiZZ38zsBlqwSRXJdRfrQ8vkOCDQKOXPkF/piva16upv2cJplov6fDIYX1LtWNjq5WUOAeo5cv+ZF4o097CsB+1/bIe3zVpLyiNujFwbiKkb7pklTnBe9WrAtyplmhrQGqseF0jbsa+GVKICH98Yu5capTWCA3g76Oep8WZGecfaLaykGs9rmMM/bWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GylK+0s0bDW45FrwyxAsNTVADBtJtBo2HyqLs7EcIk=;
 b=gaRtd2idyTCCwsoTK+C2Eu7Hea2MIh9K1JnMa3iaFgUOyBSn68kTUd35JygJ/LQ7m/ZhW6bcmtdqoPOPJv2J4KJCYuTJ/W2eEOwIuytF9s6quK/soN6xmFgVD6mzriAjSNdAgRc/nXs2bjX1V9wseBbn7Y2FAh7DGIBv3Db/r18=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4538.namprd10.prod.outlook.com (2603:10b6:806:115::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Mon, 19 Jul
 2021 18:36:16 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 18:36:16 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 2/2 v2] Test: nSVM: Test the effect of guest EFLAGS.TF on VMRUN
Date:   Mon, 19 Jul 2021 13:46:17 -0400
Message-Id: <20210719174617.241568-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210719174617.241568-1-krish.sadhukhan@oracle.com>
References: <20210719174617.241568-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0066.prod.exchangelabs.com (2603:10b6:800::34) To
 SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN2PR01CA0066.prod.exchangelabs.com (2603:10b6:800::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Mon, 19 Jul 2021 18:36:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5e2cb39-2215-4b25-a4a6-08d94ae4178a
X-MS-TrafficTypeDiagnostic: SA2PR10MB4538:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4538919118F6C19E886643E681E19@SA2PR10MB4538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 258datAoVfpRLl85sn6TfJi6Hm0Kym5y+tAmfP5WU33SAEl/LvHAPomMY+mNtp5H9floKUtq+girxVj6LMfmaZ22qtlrB1mizRBI9e9ztfVMFDQGO+7KMZTCaitmoC2s7UXBexYnevK0K/Ckt8g7/Ik7W/8w898u9RuRTKT5rlPLuUiADKR/gHlpBauIxp16QK7mEMBt53YEvM2+RgLK5LSlI4lOCliFVm+Y+ye+l4skhbGmNWFCRhKrNX6+xLr6j6USRM3kxs23YaWOW5cSxEINJW+XKPG+31V6/2mUYXUxGtmK0mzorFpItZtE2UOPPHGjp0HxnCQKsQI+YV+sBnnEsBqwFXsBTafLXkIh0twJPCeedrpbcl9y+oiDwQ09gpf6mgZ8BKUToPZb2PVWvQO47fucHtE1MKcNo3Xd5wORKiCsFmT/P0gByzTuSrjB49fkvU54q7KGKJhxMM2zejtT/iMxuO7W15bRXtmAG7U42onTGLlas9Dt3AOrhUudlLKyn4nLgRj4PNwYWqlaXBjhGC3Zy9nPxsIXTG3AHDRC5pfWhEC1LCSkCDa0YXTurrcEEL78cL3YBQzmSFF35PaAh4k0JgLYCynFSe9k3jAn7o1M5b3TTzeasv4+a/zz936R6xvEtqPSwtKmbPoUzQaQtmI2fvx7B/4fN4XxM1Urt5IAy3i+M3N+c4e38IR0CQWXG0iPGhMlqf7gYrO4+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(478600001)(52116002)(38100700002)(316002)(38350700002)(8676002)(7696005)(26005)(86362001)(5660300002)(1076003)(186003)(4326008)(6486002)(36756003)(66476007)(66946007)(66556008)(956004)(2906002)(8936002)(44832011)(6916009)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nBo1obi2Uff0dHgHZoLZLJNdK8jGvDJN+45kQ6AaG8svc7Nf71lSHMZquFfQ?=
 =?us-ascii?Q?3C+MqyPUHGn37tYPrCFRwIzXGUF9LeiNCy9Ru55teor6i9zO/SNQUxicM0wU?=
 =?us-ascii?Q?4nbDJA+4Fs7aCUH0N6uORlfR7Gik/79Ml+nKnr7nHtPBbnAol8rixvLChfpj?=
 =?us-ascii?Q?FRsbk5HeVJMpUW6XaPlLAYX0fMtDcTvMLPpQzucw34oxYNCjSeOp/wgPYYoQ?=
 =?us-ascii?Q?lXyoD8YE4jFv1HMWajfRZxJvM8nD2qHpUUHYVxqxgMeVxbPQtUN/iOQ/iQWT?=
 =?us-ascii?Q?RimJx3rj2G9HGUvAfHThFDvjkj14Ybu7iLJXImHlBEnFccq9oAf2WjN8TUhD?=
 =?us-ascii?Q?E7wKuJCjbZeuMd/maIs9eLSDG2m0YrrbyH2YATWF3SmL9cKeQePAaKI18LHL?=
 =?us-ascii?Q?81uV2zRjzDe9v3dCffK8D6EwbUlx+5G0EdMSHBtr+1hIRl/65/gXT5F/LfjV?=
 =?us-ascii?Q?YdhK9uzYY43zq7poPoMnI5c1a5TfpYUGaWMINfP4Fy7hhvt8V/5H+AteaAfS?=
 =?us-ascii?Q?D+gAc0e8x4zdu87DWXgqO/qmJIeCka19HijKSZVJE2Bwuc7Ck9bd5A9Dcv8C?=
 =?us-ascii?Q?DwRdb+Ws5nidnDlyXur21k5hFiT5iRN7WmZiXqUf9YusaMFwp8GpWfotKour?=
 =?us-ascii?Q?oDIZNlF9ZWmwiPs1lJiTtCFFwoZ6lnEwjhTgQ8hbiZh725G+t8MDOOJlqAq7?=
 =?us-ascii?Q?7BUB7xnVuFpVipz3UMW2noYCi5DDPeW+ms/qrYj5TGa7DwKFIr2kaub3Hrrg?=
 =?us-ascii?Q?PPilsOmEjtgTpo24MGzc/w+neF5cIlATL0TSlEGXs9TVNhathJYrdOA4oH+i?=
 =?us-ascii?Q?DcRFBagcssCJvtJZ503WaOMSdV/mWT/mVJq1Uv1bDiADhsCVI4Q0R3mRG6mP?=
 =?us-ascii?Q?WJAR50+GUwqS+RIcyMEOkn+fpIr0SydvEFEx52LLEUUfTxXWCNFIJhpeKICZ?=
 =?us-ascii?Q?0NBTk/sOU97oGYpj7qX/SzBW3EKQfjYhkuQya22pQtVBZCunoL3jEsVV2c3G?=
 =?us-ascii?Q?2g/cgTPv1AMTxZQhIBBeapGciIi26eFFk5V70JAiFBg+KaxhHRG7YoGhxUhw?=
 =?us-ascii?Q?VrcUk+wP+vLdKCnQ+yeUffedXVVDL0nkdaEYHSfQYxLeNI5L7sdrrLsfqrKi?=
 =?us-ascii?Q?1Z8Okp1RwxKv7ZxOcaI/6EWre9FTBo9HQ9CDD+7NfotZRJgvKf3mTeIeVM85?=
 =?us-ascii?Q?raj7laiXaWr/AnP2ZG7HAoGzxOx8A7UFVvOu8FscJM4NBBUQWYXC2BlvYZUQ?=
 =?us-ascii?Q?63v8QsBC0l+0Xsm9NAbocXVwfDEvMaf6V31bYAQKByZl9BRrT7OwsQHBQljV?=
 =?us-ascii?Q?T5Q8daa2pghIWUUzmyKPTEqA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5e2cb39-2215-4b25-a4a6-08d94ae4178a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 18:36:15.9965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BGO9N4be+a5kGYcXF8e+Skqe8mB9XAy2ashH0PPBsKrmppSXQwCXBxjMwPbhZnW+sl55EbIiJZEG/AytX44Ot8EdHe9T6UD/AChzZQgZEII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4538
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=940 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107190105
X-Proofpoint-GUID: DtZxtpbbV7_99PldG3MHZwDFMwEGD4vn
X-Proofpoint-ORIG-GUID: DtZxtpbbV7_99PldG3MHZwDFMwEGD4vn
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "VMRUN and TF/RF Bits in EFLAGS." in APM vol 2,

     "When VMRUN loads a guest value of 1 in EFLAGS.TF, that value does not
      cause a trace trap between the VMRUN and the first guest instruction,
      but rather after completion of the first guest instruction."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index a56a197..7827d1e 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2491,6 +2491,66 @@ static void test_vmrun_canonicalization(void)
 	TEST_CANONICAL(vmcb->save.tr.base, "TR");
 }
 
+/*
+ * When VMRUN loads a guest value of 1 in EFLAGS.TF, that value does not
+ * cause a trace trap between the VMRUN and the first guest instruction, but
+ * rather after completion of the first guest instruction.
+ *
+ * [APM vol 2]
+ */
+u64 guest_rflags_test_trap_rip;
+
+static void guest_rflags_test_db_handler(struct ex_regs *r)
+{
+	guest_rflags_test_trap_rip = r->rip;
+	r->rflags &= ~X86_EFLAGS_TF;
+}
+
+extern void guest_rflags_test_guest(struct svm_test *test);
+extern u64 *insn2;
+extern u64 *guest_end;
+
+asm("guest_rflags_test_guest:\n\t"
+    "push %rbp\n\t"
+    ".global insn2\n\t"
+    "insn2:\n\t"
+    "mov %rsp,%rbp\n\t"
+    "vmmcall\n\t"
+    "vmmcall\n\t"
+    ".global guest_end\n\t"
+    "guest_end:\n\t"
+    "vmmcall\n\t"
+    "pop %rbp\n\t"
+    "ret");
+
+static void test_guest_rflags(void)
+{
+	handle_exception(DB_VECTOR, guest_rflags_test_db_handler);
+
+	/*
+	 * Trap expected after completion of first guest instruction
+	 */
+	vmcb->save.rflags |= X86_EFLAGS_TF;
+	report (__svm_vmrun((u64)guest_rflags_test_guest) == SVM_EXIT_VMMCALL &&
+		guest_rflags_test_trap_rip == (u64)&insn2,
+               "Test EFLAGS.TF on VMRUN: trap expected  after completion of first guest instruction");
+	/*
+	 * No trap expected
+	 */
+	guest_rflags_test_trap_rip = 0;
+	vmcb->save.rip += 3;
+	vmcb->save.rflags |= X86_EFLAGS_TF;
+	report (__svm_vmrun(vmcb->save.rip) == SVM_EXIT_VMMCALL &&
+		guest_rflags_test_trap_rip == 0, "Test EFLAGS.TF on VMRUN: trap not expected");
+
+	/*
+	 * Let guest finish execution
+	 */
+	vmcb->save.rip += 3;
+	report (__svm_vmrun(vmcb->save.rip) == SVM_EXIT_VMMCALL &&
+		vmcb->save.rip == (u64)&guest_end, "Test EFLAGS.TF on VMRUN: guest execution completion");
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
@@ -2501,6 +2561,7 @@ static void svm_guest_state_test(void)
 	test_dr();
 	test_msrpm_iopm_bitmap_addrs();
 	test_vmrun_canonicalization();
+	test_guest_rflags();
 }
 
 static void __svm_npt_rsvd_bits_test(u64 *pxe, u64 rsvd_bits, u64 efer,
-- 
2.27.0

