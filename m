Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1BB3E0883
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 21:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239251AbhHDTPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 15:15:20 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:53720 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239215AbhHDTPQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 15:15:16 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 174J6Ql6020559;
        Wed, 4 Aug 2021 19:14:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=MJM0rZi+/gqmTBLZP65KxYmzEJOOU8icc2QxO7bk3Dc=;
 b=J+Ws9RJ940NccoCZkxT84JDbp2F65MkbNAN2Temd4lpYpReK9TuHQ/wSqow1y+dnpupJ
 LqCnLY0nxUETckMWieR4oblTyCP9cUGI55bS615Ixr7ovAu+lJfpkPzEtBWpG2HTNoDr
 NxbjJkQ9XzGCAXwMitvZ08nYdt5xbMlpEyUKJ7PrSKCt79NLhC0U29BjZTA76LOBSgX5
 QYhfYCnC/Mxu+VTYm/MlSUy+93kbylQrxYIHlhwA/qA9TDtNTo18Bj0EeGpqenHrq201
 2t6E3l8uPsgLd3InHxSN2/k15BVsrcjGy+Xh9DN/FL+HWk1p4sdlCFDiRI/FX9p8M8Ni Ew== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=MJM0rZi+/gqmTBLZP65KxYmzEJOOU8icc2QxO7bk3Dc=;
 b=yYOLDa1lYqDCRAjVy7gklRI11yvCqPk07+6kLEy3vTxDpO4YsRxuP3d0hg7pX/iekL4X
 P7kcYzkMWXFvuCEN1WzG8hDf1P5xbSjPecd99hysvHzaqIUCdTLSMWk3tfMVtEO3QApA
 2zxDRVBxzqu5kiA3Szf8QxNEgGtzLNk+Q1EUuPw4Ju4C7uCDnf/MQbMG5lo50Ksph3eH
 uUvkxNkOvNUs8e1m+VUOXU1bO8fKT9Z3aJsGdApH5B/kldcRCufGSX3nIlmrNuJcVPa3
 gp3ahSwrr3cyvNlVVwqGF/VPzcky/Q4BplxWrEIV7KXHBuSorG9lN1NZ0prfZzzJ5r1W /g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7wqv0fxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Aug 2021 19:14:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 174J6Aju060708;
        Wed, 4 Aug 2021 19:14:08 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by aserp3030.oracle.com with ESMTP id 3a78d77yhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Aug 2021 19:14:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJcfR5NUWvVRVR9y1mK5RJKxycyOreL1amyEQwQRZAhDkJE9nQrKScpYGrVmFHEs6EFHyKNCk7pRRR6/Xujx26r+8uZbzfwcRD18CzWRbNSlRiyCflQaU5cwehFLAjv5d5VkF4MR3pQY/SPkG4GJITKOKiWLZEDKGOnjs4TqfqYYvX8hp7SlqgEbqhFzWrrO/BsORQLrC/n4ph8irBN4rcaiQNsdB8k6bKXmD+sYWo20YAyOTj30zj8aiVEfzLNQWM1pwuiXlRv3LA4ccbk6nU535XQ1iAyGmmUhG6KPOVTLrH8zOoVuTjtkrZtEBnchQPFknqbv9v/Wlz6x251uSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJM0rZi+/gqmTBLZP65KxYmzEJOOU8icc2QxO7bk3Dc=;
 b=fR2NTu1NqI0fjf33hZ1+nYzvcmFWVdI3He5T1yoA97p4L4H6QUdyc/pekR3ljzscSwXENN4y1AmhB9ydKh8HNOUBZ7/ZFWBwBfmQjVLimRp2j5Du9ebmnP63XiPaHfzPjhKUZML4cUFLSUbRML/12htyWXr7oPesSfXovnKqCwCaKBqzGDBqH5XbH/KdeFhJHbv5ygn4dJGF4ZjjDiDH2UmAuBGO2gJ75jPmhvZ6Krp98G2vHiBwcKcWACKVfmua07tstFp4fg6mpoj/GCM2sF/ndNlGSE9YaV4ecQb6C+XnzrjwwCTwG8IOq6hQnls/hDBwLXJrAfYHoxlRhB7EAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJM0rZi+/gqmTBLZP65KxYmzEJOOU8icc2QxO7bk3Dc=;
 b=kxECJ7STBNmKY9/rK82hEhM5t1BWylwyXTjGPXsAEpv20QuHmoILDUWuHAxj30fkVQIsENe5MnUseiYvhUdpTiSrzpOjeL1dl2LJ8uRjiPdHN9o9RFV422LfMKlBH0qC0ohwwBJubxb9CCgTBvnY9OVF81fQKoU1y9eDWwYtOd0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4811.namprd10.prod.outlook.com (2603:10b6:806:11f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Wed, 4 Aug
 2021 19:14:06 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c84a:b6c5:6a18:9226]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c84a:b6c5:6a18:9226%5]) with mapi id 15.20.4373.026; Wed, 4 Aug 2021
 19:14:06 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        thomas.lendacky@amd.com
Subject: [TEST PATCH] nSVM: Test the effect of EFLAGS.RF on guest code
Date:   Wed,  4 Aug 2021 14:20:37 -0400
Message-Id: <20210804182037.21209-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0086.namprd12.prod.outlook.com
 (2603:10b6:802:21::21) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN1PR12CA0086.namprd12.prod.outlook.com (2603:10b6:802:21::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 19:14:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4abd4803-8f42-4fbb-fccf-08d9577c072b
X-MS-TrafficTypeDiagnostic: SA2PR10MB4811:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4811929A3983262AF47B7E9681F19@SA2PR10MB4811.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iz1uGvxyVDPJntbtN7p6pinW7qDhY+21o6VVbLfuH+UtpZKDZ2zoeYpN5g1jqTHokJMEG0VEGe4wLyMGunqLP/h0UbsAq8X+0hkrG6SaJ7WhSC97OGFmy2TXHal0aTKDUbaqZk/xlwGQ8dWtnCWdV74bgg4skypAyuw8GWwhl34b7Y4eZ2khlEk+sRyLSWsHsxqdEfy1s5g0VkjdUgYV/X5GYK9nhGdEjWLqzkp4FeVAkBZf8lbuuNE/E/lf/vor6Sus/X4Qf8t67v0VhTLxBKhYykwPz17rtyDZpOrNidlWhWFJzBzqeEm4W3iyOtuAXNEPvRVvtnY79iTKlAallBZm9Jxq6yjdCe9t9Dm0kl7xuTElpyCaQhDIcgqQytPUsw3DemCIF5l2BV+PkT0jI9tTdocEMpK/hlZdLCMLFjyyfS+mYkSzcnXNXHwFQhOsWqZU8bMDToTGDV8Dlpc90NI4dsOUzfW0/FC5OO8S09N7o7CH72X9z1VYZt7wCwA6W1oBmK89PXQiDIbWOBON8C/J5keMLbT30m9IkH6ne8yYPswEuO7bNVskrz6UDyIevEvsn5UVQyFHCdUndi69hPgjMD8CK1lFN7tMyvIvx5Yni2NEfRV4j8hXJI2fyqP6B1rClRT8S9TaX5cYsU3ovlE1WsnKGDFK9ioOwyfyTVoDhYYuJpFC0XQmx/DDk54lM6v7A6ZiKL2NWZZZ0SDDMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(136003)(396003)(366004)(52116002)(38350700002)(6486002)(36756003)(1076003)(316002)(2616005)(8936002)(2906002)(44832011)(956004)(38100700002)(478600001)(6916009)(26005)(5660300002)(186003)(66476007)(66556008)(7696005)(66946007)(4326008)(8676002)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?98NOh+MR36Qrh2iU1jjuX52Y5eZ4ZOxVQcXztJ77nbsXQXCqh9gRpwYlU1S4?=
 =?us-ascii?Q?/cGBSLdz5HNfZ/QB5/JKf2B7599Qqk4eke4uQUPCqcD9OJcn+LLiglXvUnZf?=
 =?us-ascii?Q?iRJ+IDqbach7c6vdhMfO6J8DE9xwh8TXs7itj4q+dwZR6fSh07EmbndfeYyw?=
 =?us-ascii?Q?8f22jKo3iqm2FaPGEM6qv1rVa7rk8ymVKd2hw1kqP+YUQZNsQ6xKuGIgGQGi?=
 =?us-ascii?Q?fyr4zGcnTEqKN2L2uE5+PvzdOZDVvVU/i9NZiCgzowbzhnnKdQ9mRgRbRz1e?=
 =?us-ascii?Q?LouvYNaG5g3Mi9BIAmuVfFCnRyWQXNQ9LIYUPnkkwacBIU3H6PW32F78NTf3?=
 =?us-ascii?Q?xIMmX6uZCdCRUD22jkYAZF5l+rQbth3qD4v2kb0q6+/T/RytKd8/aZUu99Ot?=
 =?us-ascii?Q?dSsxAqkIkZW02iNXlmkzwKrfp0on7UAunhWQrPPFSmpnJv+tgxFchOANsUca?=
 =?us-ascii?Q?8S9gJKRu8Ez6nx8NrTwm1LIjju9vD1VxreyhCjbj6svLITdTAl8LYClTx2X5?=
 =?us-ascii?Q?Zuz1B55uAVffeJ/w2runpaW6ed9UOIttNyFisg/Qp1UcgxV0mi3Omm77BCrp?=
 =?us-ascii?Q?7YjrZnf57rT35t2Y8QdUNzCQOMy3+wUPCoLaZSXPgRHFI1a6byeGXq6sGKSO?=
 =?us-ascii?Q?FvzJXDxcMpuxy4ZPYXKOzcYonjXB7kuXweDVUDZ1hHYVFxXzT7wQwmJixSG/?=
 =?us-ascii?Q?MS+n2ppa1BYA9QO0SPh6NfewIfHplXT/0VA52FtDQrvZ4Y7jtdOUmX3peNcm?=
 =?us-ascii?Q?rAp1nLdICN8uZFuvoBLZzwEVBay5nZGUnyzldgdtAFf0mr0ugLRQVzT/qUSa?=
 =?us-ascii?Q?fY6E5rsOdC8/EY39O7knDe1LOWH7FFl4qaGEPDVZK94rSlz4tscmP4jG9gZF?=
 =?us-ascii?Q?n2bUpAMVopNTIJw4/RMVRztLEJFgnpgQ4WFXZSEhAj6agR8UdNROEek4PP9B?=
 =?us-ascii?Q?7c41sbhRa45/eTDzEWsvTV/qTidVqyrVrwYyd3Vqp2Iq490rEF7losAV7fv3?=
 =?us-ascii?Q?8rciM/DdT5GtdBwUEmHiDNMBzVYorCBYmfnAJFBVnsKtxeHWOz6U+nLngT2g?=
 =?us-ascii?Q?7DjWmRF5knKfur61Lo9kvderkOXhHwf2HivnKCY+3EWwpbdoKRtjGSSPewlh?=
 =?us-ascii?Q?MUYZ0feh7dglFdaALfXzS4MWO2pSeZ8qamHXGj+T3XPzGCsIAyc17IT/UtwY?=
 =?us-ascii?Q?xwUzry2I0XJoUvAGChWMl50giSp/WvuyJ/gUCMhLPW/GystUYuA38xW3WJct?=
 =?us-ascii?Q?YWL19h8laectVuZzZteMuMPAUFbITXxOTztykpiHjlKFj5P0/YAaxDFL4m6t?=
 =?us-ascii?Q?jenhIG3YhgNangSiIkpvQ8IL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4abd4803-8f42-4fbb-fccf-08d9577c072b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 19:14:06.2247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bl0LnGBEg5nWYoWqwocEgMnuDa8ymMQm+t/pMYIAh42LrEmktEsPzdvmd/SjXkcMggnW3kEIeIhYE12lbrxOTpS1ZBC4cPT77lYB7qNFrog=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4811
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10066 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108040114
X-Proofpoint-GUID: tpK-4SGEv4wjbb5fCa5nNC6mdSdcZpef
X-Proofpoint-ORIG-GUID: tpK-4SGEv4wjbb5fCa5nNC6mdSdcZpef
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "VMRUN and TF/RF Bits in EFLAGS." in APM vol 2,

    "When VMRUN loads a guest value of 1 for EFLAGS.RF, that value takes
     effect and suppresses any potential (guest) instruction breakpoint on
     the first guest instruction."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 7827d1e..b6bb529 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2496,14 +2496,25 @@ static void test_vmrun_canonicalization(void)
  * cause a trace trap between the VMRUN and the first guest instruction, but
  * rather after completion of the first guest instruction.
  *
+ * When VMRUN loads a guest value of 1 for EFLAGS.RF, that value takes effect
+ * and suppresses any potential (guest) instruction breakpoint on the first
+ * guest instruction.
+ *
  * [APM vol 2]
  */
 u64 guest_rflags_test_trap_rip;
+u8 guest_rflags_rf_test_counter = 0;
+bool guest_rflags_rf_test = false;
 
 static void guest_rflags_test_db_handler(struct ex_regs *r)
 {
 	guest_rflags_test_trap_rip = r->rip;
 	r->rflags &= ~X86_EFLAGS_TF;
+
+	if (guest_rflags_rf_test) {
+		++guest_rflags_rf_test_counter;
+		r->rflags |= X86_EFLAGS_RF;
+	}
 }
 
 extern void guest_rflags_test_guest(struct svm_test *test);
@@ -2542,6 +2553,7 @@ static void test_guest_rflags(void)
 	vmcb->save.rflags |= X86_EFLAGS_TF;
 	report (__svm_vmrun(vmcb->save.rip) == SVM_EXIT_VMMCALL &&
 		guest_rflags_test_trap_rip == 0, "Test EFLAGS.TF on VMRUN: trap not expected");
+	vmcb->save.rflags &= ~X86_EFLAGS_TF;
 
 	/*
 	 * Let guest finish execution
@@ -2549,6 +2561,32 @@ static void test_guest_rflags(void)
 	vmcb->save.rip += 3;
 	report (__svm_vmrun(vmcb->save.rip) == SVM_EXIT_VMMCALL &&
 		vmcb->save.rip == (u64)&guest_end, "Test EFLAGS.TF on VMRUN: guest execution completion");
+
+	/*
+	 * Trap expected before first guest instruction
+	 */
+	guest_rflags_rf_test = true;
+	vmcb->save.dr7 |= 0x403;
+	write_dr0(guest_rflags_test_guest);
+	write_dr7(0x403);
+	report (__svm_vmrun((u64)guest_rflags_test_guest) == SVM_EXIT_VMMCALL &&
+		guest_rflags_rf_test_counter == 1 &&
+		guest_rflags_test_trap_rip == (u64)&guest_rflags_test_guest,
+               "Test EFLAGS.RF on guest code: trap expected before execution of first guest instruction");
+	/*
+	 * No trap expected
+	 */
+	vmcb->save.rflags |= X86_EFLAGS_RF;
+	guest_rflags_rf_test_counter = 0;
+	report (__svm_vmrun((u64)guest_rflags_test_guest) == SVM_EXIT_VMMCALL &&
+		guest_rflags_rf_test_counter == 0,
+               "Test EFLAGS.RF on guest code: trap not expected");
+
+	/*
+	 * Let guest finish execution
+	 */
+	report (__svm_vmrun((u64)&guest_end) == SVM_EXIT_VMMCALL,
+               "Test guest EFLAGS.RF: Guest execution completion");
 }
 
 static void svm_guest_state_test(void)
-- 
2.27.0

