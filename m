Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70901310186
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 01:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhBEAT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 19:19:29 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52428 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbhBEATZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 19:19:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 115096lG135348;
        Fri, 5 Feb 2021 00:18:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=yUy8J/YAkGqXYEoo/qNBXTcqBD+jvJnriSoJQOPuS1Q=;
 b=TvEebbP2uMZqBCA1fWyM92d77DjUDJI93ZjNhqw/0JbsM63KgKXI4RGIqudFeRDMazDN
 DfvdeUW5syvzstuSMnfP00jMAFOYxlhW2CXhwoVvcvyGAQkpd3LGW98ulgQwNFRpByPL
 tCB7/7o5v0pe4bWBvgE3tL0jr8xG8yUCXylYWn5/j0A2omXokA6AZYQubetcSc6ea9O1
 JMTHifi9IWv0ew1Xtzq0g7Cb8C4QidJmuiaTDYewnNpVn2OgU3u2TwMw6DAAZAFZsXfu
 fCWykXagU+5KZIiVKtkHegKmNPrxB3ex5rlC1RMwL9IHHBB6Qv+K75Q7lbj2l4PAI1rO Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36cydm7s5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 00:18:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1150AgxL144708;
        Fri, 5 Feb 2021 00:18:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3030.oracle.com with ESMTP id 36dhd24npv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 00:18:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eMVRtvrlxu02eXHoIZ8rbI6QAFqlDXXciS+EnSo+K7bNiudMWaEBFKzWUMasHfdrz+OfxV50spsCX9G1KQ0wBHQmteUOcCzwYquE2uDCvpIog6GN5AdVFtXm0VWxdXdjdPzcXKWkaB31C3M5sIxlhA6XHCpZQ0EwKw4WyxWBfNG6c0H7PyeXlTB75ieq5RcQbXGPqaio9icNjN0Ha2YhVjUfAG2ommz383fd9Ts0J2+Xgcr+QQe4NWVQ2oxkDxyLelehXrVsl72FZTIFQ7jl0qeluidoniOao1Q41zYD96MEP6prsGIHkz/bovNcT1CQkgUJAfdnJW3jg7AfQLF4UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUy8J/YAkGqXYEoo/qNBXTcqBD+jvJnriSoJQOPuS1Q=;
 b=WeCcWC/oNK95WZW9JjO2slPgel9ghAh9ZRY6ZH/qgXlIvkUf52zaEP8uuETmk8n7bnNWrdrEHJwAS3lVDeQzLHG82Blp5IuLqzKY0Ik4U8Aqrp2ufwUsC7pZJZdGcixrIs/IrGj8xf5tt3xpjd5q0bix5xOoQK+V4sf1GvuB59vOLqZe0dq4uPSNV9kW3I9g4uLFSGsMVn/scIDCtzgsYhGito1KGSPIck5igZtJpD1AmGAIe0VM9AwScwMLZD0HPGD0Ivg66tE3GDkkinUwb1nsrHqjW+CC+vCuNKph73HgcXIeMliTHO22Yi8vto0mY62wcANZ7r35eO5oFVcr7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUy8J/YAkGqXYEoo/qNBXTcqBD+jvJnriSoJQOPuS1Q=;
 b=bN2oTT7QnwC2xE+cEziseu0NpdZg1RsL+huxDwSdzkPC5mvj9QcGYgo+zVwaBA3qAj3tXYI4XmdKkWVbgTKSAb98EpxXdL5hLR7vslj4Slw9vOTuqg+a9MlNshV69QRebPBGxNoryIKlzri0/psDQP0O9ANrgvT6JwUpJ6RKvy4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2702.namprd10.prod.outlook.com (2603:10b6:805:48::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Fri, 5 Feb
 2021 00:18:36 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 00:18:36 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 1/1 v2] nSVM: Test effect of host RFLAGS.TF on VMRUN
Date:   Thu,  4 Feb 2021 18:29:51 -0500
Message-Id: <20210204232951.104755-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210204232951.104755-1-krish.sadhukhan@oracle.com>
References: <20210204232951.104755-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Fri, 5 Feb 2021 00:18:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0008100b-346a-428e-9b83-08d8c96b92c7
X-MS-TrafficTypeDiagnostic: SN6PR10MB2702:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2702C6CBD21F4E84642AA4C281B29@SN6PR10MB2702.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pc2G+xlz5UWtWJ0RHPQt/sOxolMoaJMOY5fAgT4ZZ7wQEjSs7ih37sUUfOxz5VCkcyJsepmyLb6BsxScDBvsrr1yaNdwkf/BU1/8RBwzaokuuMeqnd2JWNl0/rsMOzBvBvTxRMN00tNXMrBbrgSdmb4sgLep6GobYwU0W7GQFJcoBtcoSVKDirQzpRhvZ39fpEtfrgqTC6jl2Lwyu147DW2cQs9HAlmYIg6fhrTLt+bZc4pEtk7bO6MCFAPT3YEiUs90j2q+7wa+209EZHAaNezPpAOQVlA4ShK5g/INqsujYQsHdBzy1R9NaMSxXdIVJyC/sC+q+lpNgoo4FO9rZNewFb7UW9lS1wxGwqOyaklrAVdjiJt1ePubmny6AUBsl4SPqxn++vE2NNFYqtlbxTunMCCx6IzTEbXK59qQ3WumozyE0tOV6wEas+X4F1KLLqt+Y5iTHxOuEH1KFq5+dG4oEBeCAO+Wcd6OpRppNR7tW7blcKyieGpB1KgJuJgWfrAcabqxdEt8TtTWak9GkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(346002)(136003)(376002)(44832011)(2616005)(956004)(26005)(83380400001)(36756003)(8936002)(7696005)(52116002)(1076003)(186003)(16526019)(6666004)(86362001)(2906002)(5660300002)(66946007)(316002)(8676002)(478600001)(66476007)(6916009)(4326008)(66556008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ycDw3yoMQ5iFPXIb0tW1Zo2Wbs7cX9qIgI7xoKAihljC+17ttg+lDLsC3KLH?=
 =?us-ascii?Q?RVzeIgsRJPOdGQDzAZ0MR/KMyDYrQsTXROibNxlQkh0Zd9a1mB7b4EqMje/M?=
 =?us-ascii?Q?+jkCYV1OBxNPPHuuppoHTnPfV+c7KDd4xcuikf+DAz28sZbnGtCziryS9F9w?=
 =?us-ascii?Q?DBQpUgg29RJxJ1yYpYU8mzs1zBn//AOoLDmYd0LcQBMAvpje0hfqKrlMtrNd?=
 =?us-ascii?Q?J26966tnfCs3tMZOhb1WU4TAztkAvbc5wgmqn1ohG2CRYH2p1C+tIhlmvqu/?=
 =?us-ascii?Q?aOrkx+WLrcNKPG+wiacGzfTCoNhUksaVWGn2JVHhqkYkrgVjUQXCbWgBBkC3?=
 =?us-ascii?Q?1BsOd0bgt9jFtquQJCXwwUx2fRtyGitrrHjqvylnwKZAKvnel1hXBbmn+trY?=
 =?us-ascii?Q?VPFTmzfVSJj67AVUO1DV0u2u9Qe1YLBsCkzybEQqOSAG8dnUUoGF2/8vwG0D?=
 =?us-ascii?Q?V9uKghhDq9+DSTxpMyV1Eh6PdBaCcGH3qHfYz1eExQxVl3WGCV9XUQQeNH7C?=
 =?us-ascii?Q?Qz8fMDES+XUyMKcgXVHUM+fCXmZ88KL/xAH4nVXpUD+xawyq9qDI04N1JmJ5?=
 =?us-ascii?Q?2mMswj+vckEn9scMYFlo6pww1VoaW7F0FSNpwCHYTZvnctIzFj9vju8CJ/Fn?=
 =?us-ascii?Q?psZVJKEohmoxTFI0YmYk2OrC2yzVrmw4QEnYurXnUYhpuEP/rfoxlDEXA4b9?=
 =?us-ascii?Q?wMEkqvRTeFsQSZzO3Ep0XAgSOGQn37Ql0NIeiCJ7oi4qcMRQHjw4hsA0LpNR?=
 =?us-ascii?Q?0b7WuvBchqmf/JEe22keS4dLQAhikpguZxqte4+bByuhvOwfmlkHp3NsSnSx?=
 =?us-ascii?Q?2qWU7cvHGYw4HDmEaZTUnx1QOWiImSp+IfjVlEIcpvV4vjqM5m6b3FTZ72D6?=
 =?us-ascii?Q?AfRia+cUGu4DSfhXSdpzBMDqjqKO6tqsGs3vTCTBdqlLdZLgLJBJaCnJPFuL?=
 =?us-ascii?Q?GN43r0rlyg2D2eWVH6qyiWE8SfC8nBoWe8POJ3b5yCaCB924isZB4c+BwoRq?=
 =?us-ascii?Q?CqxpKTaTJ5BdxaT9pMW+4jTfnMgwGrwCHSjjqI2gSMZbDj5SNAlK45BhwBcd?=
 =?us-ascii?Q?wuGFcTCm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0008100b-346a-428e-9b83-08d8c96b92c7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 00:18:36.5485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jRDzpdoZ3sivRsWfuJR6lod6FH1Iha7EIy33aYta4iLyYWr4QmwJprV2CJVshw2mVACDPSo/hVu55R8rBZl7J77TqPKpQZIwe/CuqTl+vSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2702
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040148
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040148
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "VMRUN and TF/RF Bits in EFLAGS" in AMD APM vol 2,

    "From the host point of view, VMRUN acts like a single instruction,
     even though an arbitrary number of guest instructions may execute
     before a #VMEXIT effectively completes the VMRUN. As a single
     host instruction, VMRUN interacts with EFLAGS.TF like ordinary
     instructions. EFLAGS.TF causes a #DB trap after the VMRUN completes
     on the host side (i.e., after the #VMEXIT from the guest).

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 129 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 29a0b59..def5880 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2002,6 +2002,132 @@ static bool init_intercept_check(struct svm_test *test)
     return init_intercept;
 }
 
+/*
+ * Setting host EFLAGS.TF causes a #DB trap after the VMRUN completes on the
+ * host side (i.e., after the #VMEXIT from the guest).
+ *
+ * [AMD APM]
+ */
+static volatile u8 host_rflags_guest_main_flag = 0;
+static volatile u8 host_rflags_db_handler_flag = 0;
+static volatile bool host_rflags_ss_on_vmrun = false;
+static u64 vmrun_rip;
+static volatile bool host_rflags_vmrun_reached = false;
+static volatile bool host_rflags_set_tf = false;
+
+static void host_rflags_ud_handler(struct ex_regs *r)
+{
+	vmrun_rip = r->rip;
+	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
+}
+
+static void host_rflags_db_handler(struct ex_regs *r)
+{
+	if (host_rflags_ss_on_vmrun) {
+		if (host_rflags_vmrun_reached) {
+			host_rflags_db_handler_flag =
+			    (host_rflags_guest_main_flag == 1) ? 2 : 1;
+			r->rflags &= ~X86_EFLAGS_TF;
+		} else {
+			if (r->rip == vmrun_rip) {
+				host_rflags_guest_main_flag =
+				    host_rflags_db_handler_flag = 0;
+				host_rflags_vmrun_reached = true;
+			}
+		}
+	} else {
+		host_rflags_db_handler_flag =
+		    (host_rflags_guest_main_flag == 1) ? 2 : 1;
+		r->rflags &= ~X86_EFLAGS_TF;
+	}
+}
+
+static void host_rflags_prepare(struct svm_test *test)
+{
+	default_prepare(test);
+	handle_exception(DB_VECTOR, host_rflags_db_handler);
+	set_test_stage(test, 0);
+	/*
+	 * We trigger a #UD in order to find out the RIP of VMRUN instruction
+	 */
+	wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
+	handle_exception(UD_VECTOR, host_rflags_ud_handler);
+}
+
+static void host_rflags_prepare_gif_clear(struct svm_test *test)
+{
+	if (host_rflags_set_tf) {
+		write_rflags(read_rflags() | X86_EFLAGS_TF);
+	}
+}
+
+static void host_rflags_test(struct svm_test *test)
+{
+	while (1) {
+		if (get_test_stage(test) > 0)
+			host_rflags_guest_main_flag =
+			    (host_rflags_db_handler_flag == 1) ? 2 : 1;
+		vmmcall();
+		if (get_test_stage(test) == 3)
+			break;
+	}
+}
+
+static bool host_rflags_finished(struct svm_test *test)
+{
+	switch (get_test_stage(test)) {
+	case 0:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL &&
+		    host_rflags_db_handler_flag != 0 && host_rflags_guest_main_flag != 0) {
+			report(false, "Unexpected VMEXIT. Exit reason 0x%x",
+			    vmcb->control.exit_code);
+			return true;
+		}
+		vmcb->save.rip += 3;
+		/*
+		 * Setting host EFLAGS.TF not immediately before VMRUN, causes
+		 * #DB trap before first guest instruction is executed
+		 */
+		host_rflags_set_tf = true;
+		break;
+	case 1:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL &&
+		    host_rflags_db_handler_flag != 1 && host_rflags_guest_main_flag != 2) {
+			report(false, "Unexpected VMEXIT. Exit reason 0x%x",
+			    vmcb->control.exit_code);
+			return true;
+		}
+		host_rflags_guest_main_flag = host_rflags_db_handler_flag = 0;
+		vmcb->save.rip += 3;
+		/*
+		 * Setting host EFLAGS.TF immediately before VMRUN, causes #DB
+		 * trap after VMRUN completes on the host side (i.e., after
+		 * VMEXIT from guest).
+		 */
+		host_rflags_ss_on_vmrun = true;
+		break;
+	case 2:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL &&
+		    host_rflags_db_handler_flag != 2 && host_rflags_guest_main_flag != 1) {
+			report(false, "Unexpected VMEXIT. Exit reason 0x%x",
+			    vmcb->control.exit_code);
+			return true;
+		}
+		host_rflags_set_tf = false;
+		vmcb->save.rip += 3;
+		break;
+	default:
+		return true;
+	}
+	inc_test_stage(test);
+	return get_test_stage(test) == 4;
+}
+
+static bool host_rflags_check(struct svm_test *test)
+{
+	return get_test_stage(test) == 3;
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /*
@@ -2492,6 +2618,9 @@ struct svm_test svm_tests[] = {
     { "svm_init_intercept_test", smp_supported, init_intercept_prepare,
       default_prepare_gif_clear, init_intercept_test,
       init_intercept_finished, init_intercept_check, .on_vcpu = 2 },
+    { "host_rflags", default_supported, host_rflags_prepare,
+      host_rflags_prepare_gif_clear, host_rflags_test,
+      host_rflags_finished, host_rflags_check },
     TEST(svm_cr4_osxsave_test),
     TEST(svm_guest_state_test),
     TEST(svm_vmrun_errata_test),
-- 
2.27.0

