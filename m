Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D8930D158
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 03:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhBCCRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 21:17:38 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39128 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhBCCRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 21:17:37 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1132EEPd076995;
        Wed, 3 Feb 2021 02:16:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=gNcp1na4roEqmZPxwEkHPczpoNecuvyQsv2WBpPdlWw=;
 b=UP1iVKyPuQ+JBUU5qx+XQJ36VCy4CNJTZBUVRfb7TF4xxHNWx98xGwKR/rGG4Lxw1DO5
 OAiH5+ylLH0d6IxlAH1q8I0BzLUrEJcsh8pr5+SI0eA9W/ZdoedykaR6xrPke8Ybyeni
 mB+wyOIzTd+dX/R5Rx4T0e0e5hknb+lwgWW8XJOq6i70wGHGtWePga3T4anLV5sI/pNX
 j70PqEzpevno8NebL314B353rK4Fju11WuvUhh8NbHivALv4fSu/PCtj8FUQaCfaBwk2
 epKYI/DEpev7uNTkm8qsJF6DTmWspm6H0uR7VNXZBa/t25GA1Aun3abyMmKgMGGbsI3f lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36dn4wkkat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 02:16:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1132Eand110778;
        Wed, 3 Feb 2021 02:16:50 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3030.oracle.com with ESMTP id 36dhcxqdsa-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 02:16:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLDdm6iPkZQHEYdN3DwLDYCj4acspCIBMWcz28zFpvFuOEe1ZZ0rM82moN9DyR5pmF2Bi2QsqwqUuzUOON9G9KX04m/Oh7Jbj/S309SOIPQ3nxPt9N9ZafAsE2cGwupZ/UQ6Kr4Dax9tYBNgxCvEqSS/bJDYmcbqMn7SzN1RNCyOKFX1BA+Zk2DFsAd1pvzRqC+Wnml6/jEBPVZZwqwAM9wR9U0TPuEn+40LvtOYZYoxckKI8BU5p8g8CsaCrBXoM38mKbp/KORUzJOcyW9inKGU1vBVSmrs2SOU4FBCm9ZL8fn/mQeRNpigqjIkTqzWFJbyoIPTzx+erq+LCLfkMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gNcp1na4roEqmZPxwEkHPczpoNecuvyQsv2WBpPdlWw=;
 b=QO33GORZFp4+zTgnEdH3MkjwubMgep7BBEm4ha8UvFMmIaGdf2maHlVyWmJ8lssmdGkHuPdLOMzmiLcphL9sqdTr+C1Bp1hjAeo+76WgokY5rH32k0V20I+nridkUlt+9tOoWKk3uM6nLVD/RD84pBaI90IgBPTD4KMpwysymrjUYc3cK35OE4Sdp3DVEwe1XOGHWA9USKms6VmwUdXynBMdKqU5apzupRhnCfxROzxh4V4DzHWKFS1RW4UPFvMXBelPfbOrvwbwK85cMGbjV/RuGU/v9aYtK3mOsWpsmtv13Szjf+9I5DEVs5+cIFKdP19j43AuaIXhfOKYQvm81g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gNcp1na4roEqmZPxwEkHPczpoNecuvyQsv2WBpPdlWw=;
 b=ITwm2+BF0kWGfJBBPaaNF8dE+ZbGDGbrySPBzqKKqIgSOrYgAKsVqulR1R4oAWaWkKqEJUj7+Sh2OSYoLKf3hjuy5parKRJfwhkmqWPfNKp/pdIidmrrjFSL4e71o4j1LHowiHHXPTiBwMXa1v7c+jhTczeTPO1BMk1NUsctfiM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4793.namprd10.prod.outlook.com (2603:10b6:806:110::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Wed, 3 Feb
 2021 02:16:49 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3825.020; Wed, 3 Feb 2021
 02:16:49 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 3/3] nSVM: Test effect of host RFLAGS.TF on VMRUN
Date:   Tue,  2 Feb 2021 20:28:42 -0500
Message-Id: <20210203012842.101447-4-krish.sadhukhan@oracle.com>
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
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by SJ0PR03CA0096.namprd03.prod.outlook.com (2603:10b6:a03:333::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 02:16:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88b90c1f-1723-4982-a76c-08d8c7e9c352
X-MS-TrafficTypeDiagnostic: SA2PR10MB4793:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4793DFCFF0EFF3672B435A9281B49@SA2PR10MB4793.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nXeS5UdIfxRTE9egvs8EyMpo2StQsoS6+y1vvP1WEwV3yhGm3lvLgdlchAhcwRz85pw0hE1Tm1Ta1fNehsZb7zgMtcYXrxKkFlnz3rLX1I1CkbwHvoAsbkWNZawdTMRedsc1WNYaZY6PaDe9+rXu04LiUfWVkGawNzu+khPr/vZBQtuEXiw0STVFgfAllzy4diAb6gtpp1L39rxAydOym6M3ELwpCWZIm9KFw/ruZgnjfLGTetMVzHRachIZbhEOYNbKTvUNAq+G/DLFXnuDLuEomLSHXdBUAYhFQUi5o2ZgakWJ/8FKBwK2dLSFt1TJUFw5z1R5/l/h40/lHZ2lQpyR2YfiRL5WYVvjVQToOh4gM28W+e5hW76xZoZJsvIzR6dSDg+KfsiOG3mnCByZcUtUdatvHgqB45bPZm8PUy4NbGJcydeop4Xev090o05RXtpP09k7tlM3sXnqIzKPEMamM1lr32Q4D4SQfNqHfhalmF1vnRDjywBausDSV0oEabGS7l7VpZa/yLZASUwnYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(346002)(396003)(136003)(316002)(6666004)(36756003)(8676002)(66946007)(16526019)(66476007)(6486002)(7696005)(83380400001)(4326008)(6916009)(2906002)(86362001)(5660300002)(956004)(186003)(1076003)(44832011)(52116002)(8936002)(26005)(478600001)(2616005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pNFvZADbnM6GG1a/ZGIkVarUgGhDS1ivfafn7vLY3xHeQZkdBpEoUpKetFEa?=
 =?us-ascii?Q?HqIe0QNJGCWtM+KwAE12mziwfnlSFBD1ktFDM+v7VkHU3/RQP5r2j3h6iZyv?=
 =?us-ascii?Q?YdHkFkcXal3Ko2RJo1Ch83hOFdf035MpilDF+yG8iN0xaV21ihN3GaL1q2pH?=
 =?us-ascii?Q?F3cwRCHyUd+FxzEGGIbj8Pqefk+Hj29XEkucmMJruPvj41Q8JdBzFr2eHCBx?=
 =?us-ascii?Q?UyXcg6eVUhGKMk00SIbocrfWzK+8Cth/9/F0XbvvZYvUvevM8vbtTsBLv8eb?=
 =?us-ascii?Q?kIkJfY7RXpwmLSNn2ThlJXvKDVwP5D4euFUiKBiXmqA18nAjtiC6xeUNckxD?=
 =?us-ascii?Q?8nJRS7YH99ZybIarn5ngWXOJHytJf56z/XRQhndobgs3EgJLi3mMkIxGOY7A?=
 =?us-ascii?Q?PC9cg41fopFYHiQ9d0pj2L2iLxPUp7PugBQ0BfLnQ/ibJohVh9GYWCpb2BMa?=
 =?us-ascii?Q?Lbs7iSD+LRi/9axOVvUZhz/Cb51bP0CBS52w0xD+33Uw/rnZrXhZYZEFuLea?=
 =?us-ascii?Q?E940cDUJ1DTAfj1/J01mljMdDIk+2d1s5hE9LM/gvzeECyB/ZSWSRtnE9tkB?=
 =?us-ascii?Q?57nGT6/ZJRnN9nE6yJVi7nIR+UU8DZ67EXas0zFMu3hh/J3jUU9QYi558eog?=
 =?us-ascii?Q?Qn65MkMZUZn6zrsdCZakUuDsX9tVl7JL9jok+fLcgsuHp6kbDOWYYIbgbdua?=
 =?us-ascii?Q?4O9mTvYQbNEqxpBZChI9s07vOmV9gXJsvOazIqyer/pqVchN7emIEOpgJ08C?=
 =?us-ascii?Q?qxTYiwUoY2sYEAmamR5YzBLysSZi7jvYpyj+lsn9LpWLAanXSdeszFlJKRe1?=
 =?us-ascii?Q?W6gOKbiAzkf5rckJSaS1Wp2BREl03Oqg9VUQMxDZkEQGlQsrEmF3xmu8DXsd?=
 =?us-ascii?Q?MWMB0EliF9UkLkY0sWYBd8vJ7S6UVqdE+h519eSY+LtEgFYUUGygN4BrFEos?=
 =?us-ascii?Q?dMudW3RZW0MuBNkV6lm/zgTG+OJkD+H2Do/3fphKmHT6wIL6DsLDS49NBg9q?=
 =?us-ascii?Q?a+zFzerGQ3K/dryyLWjhDfDJHjX2UiWadlIdOxl16CJyYDGYf78Sb4oBXltE?=
 =?us-ascii?Q?zO3Q6GkJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88b90c1f-1723-4982-a76c-08d8c7e9c352
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 02:16:49.3745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ff5FgoAqil06PntecgQIHfcvF7GRl/nc2Z8N98eGdPrrdVuXyMH+cEmS4OIFBkiD1llixtrCMA/h7Z5G/dPwWR1b82AOet0ovNpjcMd4wc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4793
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030007
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030007
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

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 7bf3624..73bffe6 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2002,6 +2002,96 @@ static bool init_intercept_check(struct svm_test *test)
     return init_intercept;
 }
 
+/*
+ * Setting host EFLAGS.TF causes a #DB trap after the VMRUN completes on the
+ * host side (i.e., after the #VMEXIT from the guest).
+ *
+ * [AMD APM]
+ */
+static volatile u8 host_rflags_guest_flag = 0;
+static volatile u8 host_rflags_isr_flag = 0;
+static void ss_bp_isr(struct ex_regs *r)
+{
+	host_rflags_isr_flag = (host_rflags_guest_flag == 1) ? 2 : 1;
+	r->rflags &= ~X86_EFLAGS_TF;
+}
+
+static void host_rflags_prepare(struct svm_test *test)
+{
+	default_prepare(test);
+	handle_exception(DB_VECTOR, ss_bp_isr);
+	host_rflags_guest_flag = host_rflags_isr_flag = 0;
+	set_test_stage(test, 0);
+}
+
+static void host_rflags_test(struct svm_test *test)
+{
+	while (1) {
+		if (get_test_stage(test) > 0)
+			host_rflags_guest_flag =
+			    (host_rflags_isr_flag == 1) ? 2 : 1;
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
+		    host_rflags_isr_flag != 0 && host_rflags_guest_flag != 0) {
+			report(false, "Unexpected VMEXIT. Exit reason 0x%x",
+			    vmcb->control.exit_code);
+			return true;
+		}
+		/*
+		 * Setting host EFLAGS.TF not immediately before VMRUN, causes
+		 * #DB trap before first guest instruction is executed
+		 */
+		write_rflags(read_rflags() | X86_EFLAGS_TF);
+		vmcb->save.rip += 3;
+		break;
+	case 1:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL &&
+		    host_rflags_isr_flag != 1 && host_rflags_guest_flag != 2) {
+			report(false, "Unexpected VMEXIT. Exit reason 0x%x",
+			    vmcb->control.exit_code);
+			return true;
+		}
+		host_rflags_guest_flag = host_rflags_isr_flag = 0;
+		vmcb->save.rip += 3;
+		/*
+		 * Setting host EFLAGS.TF immediately before VMRUN, causes #DB
+		 * trap after VMRUN completes on the host side (i.e., after
+		 * VMEXIT from guest).
+		 */
+		set_ss_bp_on_vmrun();
+		break;
+	case 2:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL &&
+		    host_rflags_isr_flag != 2 && host_rflags_guest_flag != 1) {
+			report(false, "Unexpected VMEXIT. Exit reason 0x%x",
+			    vmcb->control.exit_code);
+			return true;
+		}
+		host_rflags_guest_flag = host_rflags_isr_flag = 0;
+		vmcb->save.rip += 3;
+		unset_ss_bp_on_vmrun();
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
@@ -2491,6 +2581,9 @@ struct svm_test svm_tests[] = {
     { "svm_init_intercept_test", smp_supported, init_intercept_prepare,
       default_prepare_gif_clear, init_intercept_test,
       init_intercept_finished, init_intercept_check, .on_vcpu = 2 },
+    { "host_rflags", default_supported, host_rflags_prepare,
+      default_prepare_gif_clear, host_rflags_test,
+      host_rflags_finished, host_rflags_check },
     TEST(svm_cr4_osxsave_test),
     TEST(svm_guest_state_test),
     TEST(svm_vmrun_errata_test),
-- 
2.27.0

