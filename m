Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AD23CA8C5
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 21:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242372AbhGOTCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 15:02:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:20112 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240846AbhGOTBh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 15:01:37 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FIvY2T023396;
        Thu, 15 Jul 2021 18:58:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=LZgy6xYj+35ZMRPS5LHmelT7OIaRVigcXUjqzM5BpC0=;
 b=OQT4t1AFm7XL8jWuZJMfpCDN0fL79MsBIeKHAg8O8PQA2ejbKljhgBoPfKXusWVnFnVt
 2FcUcD/PCXiggoL4XW5s8MwN1M2L40l+AOdrjA3QYK811YkQpXYmtUMdtLFmeogMRbn2
 ukG9Rph/3n4lU1xpnDNan2i3qo4NRDAEJP9SsoBJg0cb//139L/S8a1g0i9JeoNWS52t
 JExKn8NfOnEgNYhuTSS6UZBt+zqo+iBFQqvbbJSi3M9e/ob7k2b1h2fawaBbfKdiMTR9
 7KeKU6qPr+bDxwKBIAE5zsX8fxR7pPTxDLFUDT+aBggZpqCYf4HFmWQstYJqgq4O01YR Dg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=LZgy6xYj+35ZMRPS5LHmelT7OIaRVigcXUjqzM5BpC0=;
 b=K651e0JI29gBHqHOWTKNO2WpHuZX0ZF9LLPU3Ez778De+aIlzrVXXzGelIldnLuWW+P0
 sexcI9Os21F74PveoqGQNaB3W/t0PIlgGj7oBQG8IDRNnmzqKnp7XXyJKzwrbElqZoWw
 inGUaCobLKDEmt6X2R2sngllvM70ONsZ9tmVr1dUtn9Nth/fSw5GbMfoPMlixJaqPdWw
 bdlx+7JCosrCQoJw75btinnPsFlzeM9eQHCkwBwmYQyG1hF/hppnzn2XoPoTTGOfUy8B
 XDY6S7pp9v9OUYXgjjD8OIAK5+Hlkz/+le/GxeGChCU1OQWYwSnrLxm4FHgie3fZkRuV rA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39t77ut7am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 18:58:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16FIsouk050707;
        Thu, 15 Jul 2021 18:58:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3020.oracle.com with ESMTP id 39q3cjc79b-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 18:58:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQiByfCis8Y7csdNS0ZlPFjYrQ9kMZWfc31w/NzhYLQPbwLUkvnHbh0rPLvlc4QZb65qr6Tj426XuvNkLYKKiIILjMzC4kfniPH5C9bqGZGqaOKIIGV//jDk+DzmXIBbb76JZQW2mtpd5CjJ2WlJ2eo0+C47nfv/fT4YtZJaKa+Hg7qsjpo0OvD4HwM3H2UJK1Q4jWPoDCQVDztwYpnbMHZvyoXpJviPP9NcNgAFv543rOgcj6wBf2nXLP3E+Y8jpkiiwGH05IJHowil3WnxwijybAbUThypJ+tw0B4wBXRHeOX9L3oHbiJNCYqtf4sugUAtYODuaIC966SFv3Xb1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZgy6xYj+35ZMRPS5LHmelT7OIaRVigcXUjqzM5BpC0=;
 b=V1URtX+VVutQqxKNAZXkhqrkxaxxTREJ/6njarA9EDzWK+Vo+ujaesCRA1625euXyzlNzi1KVtqXeOd6DClu5t49UQQTbPkv4y3KWl2+QR9ioSS7QWbt32nImI2I109h+lBhavs8wwI3rSwFltjx+mnSXiBII4BezswilO8AAqIEXrLoM36eItT2L9MuU6xbkQsC7gWMXhGhoh4ZG/mvwVLak1AzhnCEo30UE8OhSZOmCTnAOcHl67CpWymQB5JDDnGNkCYW8MvEmL2p59yz6zmN4syDSOl4Ci/fEkcuK/k9xvKw5C8wqWYLhBykzNJ5tJSGTwhuoeIbj6kvtdSLHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZgy6xYj+35ZMRPS5LHmelT7OIaRVigcXUjqzM5BpC0=;
 b=fJAEIao+W0DPY+pEN+yZBKE/A+qm0PpLz2bC53nAFvU6TxVFxjar8S3L9Kh3EAtQxfSYcUCr5hHiStsu1xfm/rPHlqyPswKRca5uApJ1zGMaym3B46+5mt2qYDvM6Va+Yv/0TTOqeDbAvo1dVA8fkid0OEoHJ41XKVMbpm2iFTY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2558.namprd10.prod.outlook.com (2603:10b6:805:48::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 18:58:18 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4308.027; Thu, 15 Jul 2021
 18:58:18 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 2/2] Test: nSVM: Test the effect of guest EFLAGS.TF on VMRUN
Date:   Thu, 15 Jul 2021 14:08:24 -0400
Message-Id: <20210715180824.234781-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210715180824.234781-1-krish.sadhukhan@oracle.com>
References: <20210715180824.234781-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0114.namprd04.prod.outlook.com
 (2603:10b6:806:122::29) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN7PR04CA0114.namprd04.prod.outlook.com (2603:10b6:806:122::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Thu, 15 Jul 2021 18:58:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfb6ebab-6961-45d6-4a8a-08d947c28224
X-MS-TrafficTypeDiagnostic: SN6PR10MB2558:
X-Microsoft-Antispam-PRVS: <SN6PR10MB25589736EA7F77DA22B9FB7F81129@SN6PR10MB2558.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MGrAiaYlZ5Iccrr3d6YPKqsawubAmuXoIyLupRA1sjLLdpiiRoJyL8uSWtY9a07qbmKm/r3kgSyXC5aNwIOoU20j53b0KbBIZdxYlVF17lHoxbAisBoZckc8JPV87yrklBe2wnX/9hwC0ftQCL5N3bQWlJvR9rq79Dtj3VDkxlZKMONZMBYu/PyKmk+Ar6K0vBmJk4j1oF3q6PipOXsRRSQpJByO2SuuGcZg79e0GClDd5xeDN+BHqIslvkOGrrYQ4BSg0nnmm2Bm1Vy/g49rNMavG+2KUrZJOwCh9JmvgsnQFVrrBWuy64c9zn2MsUrwJgI8u2UCg9hjNBT+9AUsGBW9A1RCS1Mdu9w84Nb49g/8by3g/nXicY5sz1Hv/KGA0HG7/7JCUClRPXcljmmEWAUtSmIvUzDrzLqDpatK9L4ddI3JO6y1RKnuF2ItELoiKYqX0Mi4By+ZQNiADBubzMEdel69GXQDiqWDzGGwFnhfPGu4InEEkCKiZUUDYrYwF5+BHVABCP2pHilM4Wfa+lLJPais5pvjre6r68XaTVWWJS2QL8BkfewL4gOCqIAC/lexf+aFf17uFhiZ5Sb7j4ohEhIgDVkqHmmf5noyVi/zqtqHfvzBm/iOBkocdoIh7izwk3gq8efscRzYXQ46w6SGaFL1ZyQl7nf9ZiHu1SaRrbJMXFmjo3MEUy+lUSnLKloPi0NdhHtd1eyus8kYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39850400004)(396003)(376002)(136003)(38350700002)(2906002)(6666004)(86362001)(36756003)(38100700002)(1076003)(4326008)(8676002)(6486002)(6916009)(186003)(478600001)(26005)(44832011)(8936002)(5660300002)(52116002)(7696005)(66946007)(66556008)(66476007)(956004)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ULvyV3igQFVpK6J639TKHZ/ale4dXzVsCi5iTSz/edTavBNY3/Mp5RyzQyoz?=
 =?us-ascii?Q?/3fLFw/FslRSzoNgHyejJtENzog8NuNkv/NE7T4xN2IxGJaMT6HZPkLllwc+?=
 =?us-ascii?Q?e/m3TxukaVHcpkLsI5BDgiv3ZsEiIyg8slZbmXSwOBDyxDzAGUcX3hT1JcEC?=
 =?us-ascii?Q?pOi4CM2qSDsrNnbiBsnNEdA1waGCMbGf0iT0jN81H6Pfoh6vOQRX+LfINCzp?=
 =?us-ascii?Q?oXRQKueLWnCe/7XGSEkWMZs8MpbJUcPWiRxzmHE+Ieit1gvJo3P2g1BkUHvC?=
 =?us-ascii?Q?RTCXs7zN4qBS71oMnLDDY9gZ0hrwWCZym3Lw5oItntoU+NitMjvMKIJMUrHm?=
 =?us-ascii?Q?txJ4UI/OYqlFlslEh7eF9SDMG6kVrUlYJ2OscDm5zq52q+WMv5oT+4+FLIez?=
 =?us-ascii?Q?e2kmHGO1+gwFiF6tYvIXBhPD8216hz5ZoXCUpFCtDjiJfsJYZCfOFpYb9zhH?=
 =?us-ascii?Q?7yno2s/KnWQDRSaLkbD4LeuKLDXCPCJo+tPO4YpnPW7cUfJDUpHQIDQeDmOY?=
 =?us-ascii?Q?2ZFNl04KtgYbgex/rvsvbn/re924mTK2rkvkQ8bjBmtJ3AmfBs9OI5AuPthz?=
 =?us-ascii?Q?VXXgP9a0WBCY9qkHDgKOmnU3pRrj+sJw7CrcvPzp2p0NG4vNIuIQhM+/uV6f?=
 =?us-ascii?Q?9jwr+OdXZqSIxH7ZrK/6UYt6p6yvzjytPZzGi8+dn6UJqfG3Sx57N33n17sg?=
 =?us-ascii?Q?4pviBz4b9J/LdFRYaIqVTQtxFhRThogGlI3Z4tMXRykcZzUwRLdwDr97Tt2r?=
 =?us-ascii?Q?GU9omO4lEgEYH/As+7Caodni9UBeL6v+tADKr31l4WtI7mDHcwOme+qHb/8u?=
 =?us-ascii?Q?Qt0AWx4vPHh3o1riRKLGAf9gzjlM+SC6wat6a1LSHHtwchooJqHocEewMRan?=
 =?us-ascii?Q?opXvA2loGIOEo03KJUP0GNzt3kT3Q9yyA9YxfeSYey6YdM/TLvK0cNVaaZHc?=
 =?us-ascii?Q?GGJpHq1V2wn/blGCqZ5ZP4UnbJGxPTBRGuUhAlT8OZSry0Y9A19t2l2C1l0+?=
 =?us-ascii?Q?J9K2jfHNYBerbAm8JzSQisXb8lHP9XcikttpKfA6kV/NHh6nLxwS4MwHjZW+?=
 =?us-ascii?Q?wqORFxZWD6L+v53YUmECEyq5QYsENcxqgu6mCRGCRGZFb53B6VpRrdKR1p1R?=
 =?us-ascii?Q?8t8Ui/liL5xfBHKo+snVbJeVi6FzrD++mtQ60Bkp3QOEqdBylVpWyt654CM5?=
 =?us-ascii?Q?rFsJC9pc40E5nFaP8Zlqz+tNcjd3FUXrWGsLqEv4+77oRwO9ExmNB0RDw0b1?=
 =?us-ascii?Q?RppBX1KMQHIfy0S8g0mnYe6P7Ei8vP+q6yFua1LcuT69M69ZnWlrEcAW+Y86?=
 =?us-ascii?Q?E1jwf2z4GNZFIuKlzzCYqUi5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfb6ebab-6961-45d6-4a8a-08d947c28224
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 18:58:18.3838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: taj4LUZRF4IvUkljSXynt9ZLNtKPNgvnmAWA3Pk+sC7QvGiK5PelIEtuvMai1OGjm0ytjHE/5Xr4N40lKgedcrfeIvwrM2ZnN2Hhw5WU2ls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2558
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10046 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=899 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107150129
X-Proofpoint-GUID: c1UrNx3e3r7VeSFgTRem8RZ6BGNyq4Hr
X-Proofpoint-ORIG-GUID: c1UrNx3e3r7VeSFgTRem8RZ6BGNyq4Hr
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
index a56a197..2d06d9e 100644
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
+	report (svm_vmrun_custom((u64)guest_rflags_test_guest) == SVM_EXIT_VMMCALL &&
+		guest_rflags_test_trap_rip == (u64)&insn2,
+               "Test EFLAGS.TF on VMRUN: trap expected after completion of first guest instruction");
+	/*
+	 * No trap expected
+	 */
+	guest_rflags_test_trap_rip = 0;
+	vmcb->save.rip += 3;
+	vmcb->save.rflags |= X86_EFLAGS_TF;
+	report (svm_vmrun_custom(vmcb->save.rip) == SVM_EXIT_VMMCALL &&
+		guest_rflags_test_trap_rip == 0, "Test EFLAGS.TF on VMRUN: trap not expected");
+
+	/*
+	 * Let guest finish execution
+	 */
+	vmcb->save.rip += 3;
+	report (svm_vmrun_custom(vmcb->save.rip) == SVM_EXIT_VMMCALL &&
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

