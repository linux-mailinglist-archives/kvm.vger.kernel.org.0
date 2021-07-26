Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A555E3D66F6
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 20:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbhGZSM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 14:12:58 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1960 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231612AbhGZSM5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 14:12:57 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QIjwVx005183;
        Mon, 26 Jul 2021 18:52:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=sCmBr6K6BBI6L0sZEyw1t+MibZyt4vKtfLIZKzBMC0Q=;
 b=xrTmy+GY/Z/KVuGrrVVPDJVtbX7SG/Dlv0nekU6dYpngD81l5zbuxlrAswCxEOWlFntC
 T31VbwDHNiZa/lDgxgWvBXTDY9IawOKkKhgxTOcuPbvTWnn0aklT145P87ENMlmOGvKj
 00p9gaaqIhX4I3E3x73IndSX/5y81BhP0pd25Cd0LNCXfy0px/OzgqBKcLGlf756tOiI
 2NmEyeHtdDMnMFCAIte3g12CzRuC3b896AE6xBm1dY8BvbxyBkjHljBP+F/uAMyi6GnV
 gU2cXDFjFwRGa3DUnQ0wQ9bHUfBEpacQQc29bqJg6STkBidP2a1dj0TEqq6UZhrXnd85 Ow== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=sCmBr6K6BBI6L0sZEyw1t+MibZyt4vKtfLIZKzBMC0Q=;
 b=aMOU7dCf5+su9Qgl5KZsAtnXhtgbSwMHzyzBzvA4YY6h3h3VUrOqJZFrGhZTt3kZcnMG
 UGipBqr7k3kVxARawIvCCOgmxbwrzwZ6jfGdRPOqBKG3y+xpx3AaJdehFwCQ9Lc0h3Pa
 GtHorV1I1qtrvLM1ISlgfFd7SAS+SWNbSJpGQcx78P1GfJgIPDKw/xMXezTdsnQ+O5ij
 84+c4bz7EL39+q0tM88zrzs7EWg3gYnx0hI7RRyzIiDcOm76bmZyb/by06+dKGpcE5nK
 Qiz3QJSQngdMbCL+BVKLnqxMN7niQNynl4uEPPozCELGnxGnrgMPqzJ780bYwJ11RHI+ QA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a1ktv22by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 18:52:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16QIonhK066804;
        Mon, 26 Jul 2021 18:52:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by userp3030.oracle.com with ESMTP id 3a07yw1y8r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 18:52:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXFWL6JIB8QNWLBVCIGc0G3w5Z8vtwAAba/fUsDj/OQmi90SJBdgAcyVbDfsr9z/AO69qGwvpJCyYVCW6WxN6NZmmZfsekRnf2aaEFuaBCqFu+0h+byYIRygMmvj9QyO1y8GH918a1STSQxiiLZHnS5xPoP/jeolwLfldvIQPUxV2zDZkB6upTj8j9TmmNyeXvvcFoGaSZm3dhS5UMZB+cJDYAoV85SjGBVSUpMpJ8HsqFAg+CVxgufzaYEw6wWBW4VSTFdeRYKyeS5Sh+wk2ZjcGL/ixRdQ7WZM1Q9ryWn2ve/yMlwZg7GYBLiK2d1ViK0IrL7qeJHJ9kBUVeMPKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCmBr6K6BBI6L0sZEyw1t+MibZyt4vKtfLIZKzBMC0Q=;
 b=mTiY+7k2yOTO5m6LlXiAc5VFxHkfBkWVOho2XdxQ4QigZ3yhQ+7SmISDlCuUvE0ShZAXnOP34pBqk4pXflnhCnxMXt9xTN8eZ50xapz5l6THw2pvBdEu6Xg54oDdjvchGRs8+5o+Kbi+qag5nRxb+5ObXfaz+ncorD3sektJt8N5TAaoSPTnnt2c5JCkKDMKvdHBV7V/Pb6BGXxvXFAI11FNAc/TSdKvx9QKhE23ahgIGQQAa2YDBCKX8zeWiGUg7dZfUHa+zsh81pSikb23GetgpEBc68l1WjXc3FgF6uAfI2vP6kKG8F/hwcU5zhT9w/xS39rUNPiTtb2vWS31Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCmBr6K6BBI6L0sZEyw1t+MibZyt4vKtfLIZKzBMC0Q=;
 b=rKmO5wH53MpJGELGn/FYVA+l5Y9ILwmX1GDLs/wzQSPWwAiI5Z10VWNJ+Vc/VTKJhAPOIe+UbrWOOszSExQgRWlBR7Pft6+KPWVsfoqk2gfOLLjg35vOOhbo0lPP6OB/cpK9AegBx+s+ZUZCj9VGQakzAnF8jicPyo8XCttJlf0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2765.namprd10.prod.outlook.com (2603:10b6:805:41::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 18:52:49 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 18:52:49 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        thomas.lendacky@amd.com
Subject: [PATCH 3/3] Test: nSVM: Test effects of host EFLAGS.RF on VMRUN
Date:   Mon, 26 Jul 2021 14:02:26 -0400
Message-Id: <20210726180226.253738-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210726180226.253738-1-krish.sadhukhan@oracle.com>
References: <20210726180226.253738-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::35) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BY5PR04CA0025.namprd04.prod.outlook.com (2603:10b6:a03:1d0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Mon, 26 Jul 2021 18:52:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69ba1b07-cbc7-427f-9ee1-08d95066904b
X-MS-TrafficTypeDiagnostic: SN6PR10MB2765:
X-Microsoft-Antispam-PRVS: <SN6PR10MB27652F60350D664DEA1A2BB081E89@SN6PR10MB2765.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o/ML6I78328Jf+ApVpseApjlgiG/9p2p/jL8WZCXCl/nuDx8WuMi87O1Yvwm2IFcoCUGZ1JN/4PYvgW5Tx5kWa7nTTNi2TrW9OmfS4p9I9cGZFOGR051FGDiRynvKgsQTLa/nfg8wKeH4nIgtQWRVXhzy/t2TLkGvSoeroxhpq8Dj6GG3VQUhIZcftXHJPHsE8MTMAo2pf6jOFjIDBw2L/b5I9TWeASkEmYvSxXUYQ7e77YwOcRCHieZwo5A/lOfxH1A6DCHkjdsEQf3VgNp+Z8Z/qgCwOt9BTl7vmH0V4mei+4gaAmejtkrA1o1X3UL+WcQ8IAZgH3170+jchaFIJ0eRPoi7Waa1deDYve2alLYYGW7YVpXZRG6Sqdv+Dx3Oz8UUTGG1lIyMIjNTxUZ1Ozbuf9tzm3qDM+E2u18DbKynn+brJ8YSEKrRQhTP4npblG7aLSlvyOoDITtyOTLYg+xhV9S++/H2DPAYtWYXDvleViUrgNjd2xv1CEzm237z66qc/U1e6m5n+syMAv3MubV4UOTBSYYl3OVI3Ru/9zxY0uL9kN9RUUhs0M2iB0trc6ga7pRSBgQrHyt9wD+RkmEVt2sLVxbTCFs3R6T3oiltJ4/geuldPXdwnayw2BcxbbAvvTWgSqdwuLGaoBuUyxV8TEjkdyKtHAovAwN/4+rn098XyFyt3h3JbrfOKs8J3x/7HBQ8fHKuypG3JKQtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(39860400002)(396003)(86362001)(8676002)(26005)(316002)(956004)(66946007)(66556008)(66476007)(2616005)(478600001)(4326008)(186003)(2906002)(83380400001)(7696005)(52116002)(36756003)(8936002)(6666004)(6916009)(44832011)(38100700002)(38350700002)(6486002)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/EX+N4HHyMrMfZ/CLdLCqRmyRJa5qsVkmEVPGWYfdozVZWpm0ceJcc3b00Ie?=
 =?us-ascii?Q?PL3ItM0bs8QDQAugYxKIiIdpPAvjCcKQdHEC4mh9DsznI2pqHDgpinTvCM/T?=
 =?us-ascii?Q?7NUpqyZ3byHQMhUS2hMpR07UPgaOY7NZq7yeIwDfW/pRRxyekGTq22pBt+yD?=
 =?us-ascii?Q?kBV8qWwhIu4MxCluMop0U6Rq0aIVy5W0oCDKiUIArH0zgaINwgk+HGiTx2wT?=
 =?us-ascii?Q?zUAGXS43X8WcEV5BdK3wXPhgt7HELrVTuKs/zCNiEUYkNHq2utJ/+h45RSxh?=
 =?us-ascii?Q?iv3oKGlT6nhsJIFaiDaBYKplFJwtaW8kEACe+VJsWtluGOQIiKRxn+6yCEps?=
 =?us-ascii?Q?UjmmYRyvenjaiF/Fk85PXXmSm9fq0S/6quHbndiE82ULip6YpD7/lDm5a48f?=
 =?us-ascii?Q?2Dl4Aq16QBj67KHvzHjY3+rwH3r0oMa1eZwO3lz9RLFMtwBWTO8Tfba/YKod?=
 =?us-ascii?Q?SrRLWB1XAIzS0NH4jDkUCqXPtnxPto7p3Ol0BoPNqydgQ2t62sVB+Y3aMaYS?=
 =?us-ascii?Q?QfMSfvTbXemIWe/Ngsm9Ev0qXtshRuv41tvr/lIdLyKwBumZqt9uVXNs3cEW?=
 =?us-ascii?Q?qcm/0E12A1oqmyFJIfHUSxzUvJHcr2VTx+GrPs4sdRyM/RscTgo0X7CJEAqX?=
 =?us-ascii?Q?gcyEX8OA9UkuU4WRtXhcxDbFTT8w93nwiThPTAi4PSvcETSKdQRrOTiIB/nf?=
 =?us-ascii?Q?XY2TqF0NZW3m5x3C+pHkyGtVicBRcbfyJgXLm9ZgH4/QNFDroSxF9rW2hKbA?=
 =?us-ascii?Q?SPgKFuPbqPEaeixIgKvjeUPZOClCYx6yL89TCIEv/QJoTP/hsxrRLCiDHtGN?=
 =?us-ascii?Q?aw2HS4SXeCJ5HRhAEICsg1bIj0Mgl8FQQT8tdg9tH3bUKhnucdoOyZNtcL+p?=
 =?us-ascii?Q?DRI0CEa5Lf0wCMqwvskw2x4rzBUD+ND3X6vFx52Ru70OnD855olXwbbgzbgT?=
 =?us-ascii?Q?1FVklmiQcPj5k5k0MHDgq3mSlvu8sh1Ty34/LcyWryU4YE44skqaqWbevHpH?=
 =?us-ascii?Q?Bsw/D/jcIGqEUFTXMYAMN/c6E0WbyoE4X6tCWy3u9FbsIM1oOGD9ZxTxRcM2?=
 =?us-ascii?Q?QQyPrhV3r3NGEBt7CbdAtXBk8ppWi7mNABgfDR0gmKw44ii8PRLGatDR1gm8?=
 =?us-ascii?Q?YrxunYytBUKv7v+CWZHO2nZz3O+OpuMww63qWUgaF8Si36kSxF+Oxk+WOX/x?=
 =?us-ascii?Q?9wcLvLgdhbhDf10x26IptiAbMd11RDapX6VG2L0QfJR5p6BpWmOa6A0TrO+W?=
 =?us-ascii?Q?+h63SH8O5KtmrIYtWmdn5EMUN1i8IAgqsVIb/Z0tpkDmf3Vf8yclJpdtBcRo?=
 =?us-ascii?Q?QGI3mnwsw3kS3TQpvDJzUjrV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ba1b07-cbc7-427f-9ee1-08d95066904b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 18:52:48.9066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: otLUwGWyKChZ2zb/pfzLG4zm0uSSxweoMXTqsxynAbOhj2J1mrlvo6Jo/cDgmVpKw4SGfqdp/jv+X8WlrNbJp2hPPxtARFQAXWJ6tSnZKUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2765
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107260110
X-Proofpoint-ORIG-GUID: Xv7MosAQl5XTy2atEWRYILJ5Q9GeO4jB
X-Proofpoint-GUID: Xv7MosAQl5XTy2atEWRYILJ5Q9GeO4jB
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "VMRUN and TF/RF Bits in EFLAGS" in APM vol 2,

    "EFLAGS.RF suppresses any potential instruction breakpoint match on
     the VMRUN. Completion of the VMRUN instruction clears the host
     EFLAGS.RF bit."

Test that the RIP detected by the #DB handler when a #DB is triggered by
configuring the debug registers, is the RIP of the VMRUN instruction and
that setting EFLAGS.RF in the #DB handler will no more trigger any #DB
following the completion of VMRUN. Also, test that the processor clears
EFLAGS.RF on completion of VMRUN.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 74 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 59 insertions(+), 15 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index a56a197..1f12504 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1965,6 +1965,10 @@ static bool init_intercept_check(struct svm_test *test)
  * Setting host EFLAGS.TF causes a #DB trap after the VMRUN completes on the
  * host side (i.e., after the #VMEXIT from the guest).
  *
+ * Setting host EFLAGS.RF suppresses any potential instruction breakpoint
+ * match on the VMRUN and completion of the VMRUN instruction clears the
+ * host EFLAGS.RF bit.
+ *
  * [AMD APM]
  */
 static volatile u8 host_rflags_guest_main_flag = 0;
@@ -1972,7 +1976,8 @@ static volatile u8 host_rflags_db_handler_flag = 0;
 static volatile bool host_rflags_ss_on_vmrun = false;
 static volatile bool host_rflags_vmrun_reached = false;
 static volatile bool host_rflags_set_tf = false;
-static u64 post_vmrun_rip;
+static volatile bool host_rflags_set_rf = false;
+static u64 rip_detected;
 
 extern u64 *vmrun_rip;
 
@@ -1980,11 +1985,27 @@ static void host_rflags_db_handler(struct ex_regs *r)
 {
 	if (host_rflags_ss_on_vmrun) {
 		if (host_rflags_vmrun_reached) {
-			r->rflags &= ~X86_EFLAGS_TF;
-			post_vmrun_rip = r->rip;
+			if (!host_rflags_set_rf) {
+				r->rflags &= ~X86_EFLAGS_TF;
+				rip_detected = r->rip;
+			} else {
+				r->rflags |= X86_EFLAGS_RF;
+				++host_rflags_db_handler_flag;
+			}
 		} else {
-			if (r->rip == (u64)&vmrun_rip)
+			if (r->rip == (u64)&vmrun_rip) {
 				host_rflags_vmrun_reached = true;
+
+				if (host_rflags_set_rf) {
+					host_rflags_guest_main_flag = 0;
+					rip_detected = r->rip;
+					r->rflags &= ~X86_EFLAGS_TF;
+
+					/* Trigger #DB via debug registers */
+					write_dr0((void *)&vmrun_rip);
+					write_dr7(0x403);
+				}
+			}
 		}
 	} else {
 		r->rflags &= ~X86_EFLAGS_TF;
@@ -2007,11 +2028,15 @@ static void host_rflags_prepare_gif_clear(struct svm_test *test)
 static void host_rflags_test(struct svm_test *test)
 {
 	while (1) {
-		if (get_test_stage(test) > 0 && host_rflags_set_tf &&
-		    (!host_rflags_ss_on_vmrun) &&
-		    (!host_rflags_db_handler_flag))
-			host_rflags_guest_main_flag = 1;
-		if (get_test_stage(test) == 3)
+		if (get_test_stage(test) > 0) {
+			if ((host_rflags_set_tf && (!host_rflags_ss_on_vmrun) &&
+			    (!host_rflags_db_handler_flag)) ||
+			    (host_rflags_set_rf &&
+			    host_rflags_db_handler_flag == 1))
+				host_rflags_guest_main_flag = 1;
+		}
+
+		if (get_test_stage(test) == 4)
 			break;
 		vmmcall();
 	}
@@ -2051,26 +2076,45 @@ static bool host_rflags_finished(struct svm_test *test)
 		break;
 	case 2:
 		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
-		    (post_vmrun_rip - (u64)&vmrun_rip) != 3) {
+		    (rip_detected - (u64)&vmrun_rip) != 3) {
 			report(false, "Unexpected VMEXIT or RIP mismatch."
-			    " Exit reason 0x%x, VMRUN RIP: %lx, post-VMRUN"
-			    " RIP: %lx", vmcb->control.exit_code,
-			    (u64)&vmrun_rip, post_vmrun_rip);
+			    " Exit reason 0x%x, RIP actual: %lx, RIP expected: "
+			    "%lx", vmcb->control.exit_code,
+			    (u64)&vmrun_rip, rip_detected - 3);
+			return true;
+		}
+		host_rflags_set_rf = true;
+		host_rflags_guest_main_flag = 0;
+		host_rflags_vmrun_reached = false;
+		vmcb->save.rip += 3;
+		break;
+	case 3:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
+		    rip_detected != (u64)&vmrun_rip ||
+		    host_rflags_guest_main_flag != 1 ||
+		    host_rflags_db_handler_flag > 1 ||
+		    read_rflags() & X86_EFLAGS_RF) {
+			report(false, "Unexpected VMEXIT or RIP mismatch or "
+			    "EFLAGS.RF not cleared."
+			    " Exit reason 0x%x, RIP actual: %lx, RIP expected: "
+			    "%lx", vmcb->control.exit_code,
+			    (u64)&vmrun_rip, rip_detected);
 			return true;
 		}
 		host_rflags_set_tf = false;
+		host_rflags_set_rf = false;
 		vmcb->save.rip += 3;
 		break;
 	default:
 		return true;
 	}
 	inc_test_stage(test);
-	return get_test_stage(test) == 4;
+	return get_test_stage(test) == 5;
 }
 
 static bool host_rflags_check(struct svm_test *test)
 {
-	return get_test_stage(test) == 3;
+	return get_test_stage(test) == 4;
 }
 
 #define TEST(name) { #name, .v2 = name }
-- 
2.27.0

