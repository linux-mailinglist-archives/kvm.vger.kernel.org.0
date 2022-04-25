Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C73750DF5C
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 13:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239829AbiDYLvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 07:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237896AbiDYLvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 07:51:31 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2077.outbound.protection.outlook.com [40.107.95.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E08D41FA4
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 04:47:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cx8vHvFcyoBXGO2lFU0djLn9HtnQpDxsdgBN5eQ2XmSlPWsRBpczjsdAS2xGTqtMdu4SO+5qpyFRnrTn73g/wPhnHAujNmGdIPxpokW7efpz135Qjy8/9/N9dGuNuRdw4ikhOxXErztQ4xSJQC4G2RwyeI+KlfdKSZtEkN1JthnLPrp2FlD22e/IB3s/1Nxdb5jyy161u+g6FZAKHbEeRkN1BHtcPixZeH/zG3wsL/bO/DZoc1qA4/wMYvXd1VwktXzKisMmYNmSU9zhztNoShxAPMUrZPt20m9/d50LC5n1wAlWcz2/CVqCe+rUV1y3wG3ZF8kb58o8m8oUQvmIng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ZyUdMZXhDZ3eVjBca9+AUkg/ignXdNTjE+AYwfNzPg=;
 b=PzDw9rqGMNmG1nC14zLt0S+N0ADRBPVze9D6ZMoAR9zMYnSAjuIS0beHxAq5/3F/oH160oCEnpPCiB5bcJGoXLj7qSJPCaBDl72Kkcvqa09STu7jPLNx8GNKI83Ji1n+X6oNWsNjepogWlgIzmogXcydZy3J/8kdgLK+CUHe4ZFiWINOjlp6u2kwZ51k84PkWTT6+Wr8fuWz6kF4NCPGulf7vbiJD0ZeGZ6i35J1jH3Wxp1ZBCvVhTdvsmI7VDCQcsIJYJ7KARxLsIIGQn2Wje7swciUyX8db2MXd0tkOmlpBS6RWzRZR4j9u8JhYfYit+BQulTTLG+iGknX4a885w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ZyUdMZXhDZ3eVjBca9+AUkg/ignXdNTjE+AYwfNzPg=;
 b=JLPjznvCAq0dr934Utjy4O0bj8NN6BYfYux5JwLJBkB5FWKnb3Md43zHHd3P/R6FTVqZ9VMlNagY5f4AunqTCvcaL0NKTzZ1cvR1nyz8Agt73smKaVQebQT4I38lCCxNfiZHbO9mAdX09VRSdjCc370+EaQlrG2h/wek/1Qifgk=
Received: from BN8PR12CA0027.namprd12.prod.outlook.com (2603:10b6:408:60::40)
 by CY4PR12MB1160.namprd12.prod.outlook.com (2603:10b6:903:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Mon, 25 Apr
 2022 11:47:31 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::e3) by BN8PR12CA0027.outlook.office365.com
 (2603:10b6:408:60::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Mon, 25 Apr 2022 11:47:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 11:47:30 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 25 Apr
 2022 06:47:27 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests RESEND PATCH v3 8/8] x86: nSVM: Correct indentation for svm_tests.c part-2
Date:   Mon, 25 Apr 2022 11:44:17 +0000
Message-ID: <20220425114417.151540-9-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425114417.151540-1-manali.shukla@amd.com>
References: <20220425114417.151540-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a58e5aa2-99c3-4947-e899-08da26b16128
X-MS-TrafficTypeDiagnostic: CY4PR12MB1160:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB11609FED79B8764D37341DC4FDF89@CY4PR12MB1160.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kT2eUBQ4TA1KQmyKkt9fOBZtVH7zT7g41GNA4p0oY86Oyyt6wn4cAPnTP4aS9oeG4kMhf/v9y7UTx+E4g6pGSH6ZvSxCXT20QtH1tQsq1wgKJ/ZiavvHeysK3Q4r31ZqU4T5lv2IunRoxgO8Pp+aDP1hfFKOt5jodQuqMaClQrMLrZ178Ds4q/bhAUOChcPkoXWD9AQB9Uc09sEuPI1ndVHJpZb/ry9gtbzdelo3E2WNvbUrSrkSUZRE3UcrhTyLLKEhNlyXLjJUW7EROVNi8OrNEoTKpiVq/8dY+Ee5803xqGN4lGyWIn/Jo4DAaNSOfg/nCRBjH7T0DGU2ii87Z7fznxfole4FOAZOj0XHEuuCDUa4PwyfaSnAhqEeLun6Z1fT/rYe6WqN9ZR4cPU7HJu2FGWjRGTA43w468cA5F/qtHtm0NVWD++Urmm2PZxK/L9sit2kv7tVKgMg2LTb9iNKXik/kuc7pdmE/m+iD4PThqJeolB71ysxINbNQOisC9YRU3j2bllBQtLLJk8vS5hRrdzdhL8fTKJ5Cotn/H4vwBdTeep54e8bDXlrb0gSy64WT7DkcSr+i2aJrGuSwlOsjKquY2U/wf7SlckAxMaG0uArKvnsfQ6PdkorNl0knAxwyvXGitvdg65QCYI+dLG171JopFPjBAWMTFekmOsMkFb19v3xzBYZO6ONFHxSuE+37f2y2X+Vf12lsYOr1g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(2906002)(82310400005)(36860700001)(110136005)(81166007)(5660300002)(30864003)(44832011)(83380400001)(86362001)(8936002)(8676002)(4326008)(508600001)(47076005)(2616005)(70586007)(70206006)(1076003)(16526019)(336012)(186003)(426003)(40460700003)(356005)(316002)(36756003)(26005)(6666004)(7696005)(36900700001)(579004)(559001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 11:47:30.6703
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a58e5aa2-99c3-4947-e899-08da26b16128
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1160
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Used ./scripts/Lident script from linux kernel source base to correct the
indentation in svm_tests.c file.

No functional change intended.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm_tests.c | 884 ++++++++++++++++++++++++------------------------
 1 file changed, 439 insertions(+), 445 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 1813b97..52896fd 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1908,7 +1908,7 @@ static void host_rflags_db_handler(struct ex_regs *r)
 				++host_rflags_db_handler_flag;
 			}
 		} else {
-			if (r->rip == (u64)&vmrun_rip) {
+			if (r->rip == (u64) & vmrun_rip) {
 				host_rflags_vmrun_reached = true;
 
 				if (host_rflags_set_rf) {
@@ -1944,8 +1944,10 @@ static void host_rflags_test(struct svm_test *test)
 {
 	while (1) {
 		if (get_test_stage(test) > 0) {
-			if ((host_rflags_set_tf && !host_rflags_ss_on_vmrun && !host_rflags_db_handler_flag) ||
-			    (host_rflags_set_rf && host_rflags_db_handler_flag == 1))
+			if ((host_rflags_set_tf && !host_rflags_ss_on_vmrun
+			     && !host_rflags_db_handler_flag)
+			    || (host_rflags_set_rf
+				&& host_rflags_db_handler_flag == 1))
 				host_rflags_guest_main_flag = 1;
 		}
 
@@ -1989,11 +1991,11 @@ static bool host_rflags_finished(struct svm_test *test)
 		break;
 	case 2:
 		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
-		    rip_detected != (u64)&vmrun_rip + 3) {
+		    rip_detected != (u64) & vmrun_rip + 3) {
 			report_fail("Unexpected VMEXIT or RIP mismatch."
 				    " Exit reason 0x%x, RIP actual: %lx, RIP expected: "
 				    "%lx", vmcb->control.exit_code,
-				    (u64)&vmrun_rip + 3, rip_detected);
+				    (u64) & vmrun_rip + 3, rip_detected);
 			return true;
 		}
 		host_rflags_set_rf = true;
@@ -2003,7 +2005,7 @@ static bool host_rflags_finished(struct svm_test *test)
 		break;
 	case 3:
 		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
-		    rip_detected != (u64)&vmrun_rip ||
+		    rip_detected != (u64) & vmrun_rip ||
 		    host_rflags_guest_main_flag != 1 ||
 		    host_rflags_db_handler_flag > 1 ||
 		    read_rflags() & X86_EFLAGS_RF) {
@@ -2011,7 +2013,7 @@ static bool host_rflags_finished(struct svm_test *test)
 				    "EFLAGS.RF not cleared."
 				    " Exit reason 0x%x, RIP actual: %lx, RIP expected: "
 				    "%lx", vmcb->control.exit_code,
-				    (u64)&vmrun_rip, rip_detected);
+				    (u64) & vmrun_rip, rip_detected);
 			return true;
 		}
 		host_rflags_set_tf = false;
@@ -2074,7 +2076,6 @@ static void basic_guest_main(struct svm_test *test)
 {
 }
 
-
 #define SVM_TEST_REG_RESERVED_BITS(start, end, inc, str_name, reg, val,	\
 				   resv_mask)				\
 {									\
@@ -2128,10 +2129,10 @@ static void test_efer(void)
 	u64 efer_saved = vmcb->save.efer;
 	u64 efer = efer_saved;
 
-	report (svm_vmrun() == SVM_EXIT_VMMCALL, "EFER.SVME: %lx", efer);
+	report(svm_vmrun() == SVM_EXIT_VMMCALL, "EFER.SVME: %lx", efer);
 	efer &= ~EFER_SVME;
 	vmcb->save.efer = efer;
-	report (svm_vmrun() == SVM_EXIT_ERR, "EFER.SVME: %lx", efer);
+	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.SVME: %lx", efer);
 	vmcb->save.efer = efer_saved;
 
 	/*
@@ -2140,9 +2141,9 @@ static void test_efer(void)
 	efer_saved = vmcb->save.efer;
 
 	SVM_TEST_REG_RESERVED_BITS(8, 9, 1, "EFER", vmcb->save.efer,
-	    efer_saved, SVM_EFER_RESERVED_MASK);
+				   efer_saved, SVM_EFER_RESERVED_MASK);
 	SVM_TEST_REG_RESERVED_BITS(16, 63, 4, "EFER", vmcb->save.efer,
-	    efer_saved, SVM_EFER_RESERVED_MASK);
+				   efer_saved, SVM_EFER_RESERVED_MASK);
 
 	/*
 	 * EFER.LME and CR0.PG are both set and CR4.PAE is zero.
@@ -2159,7 +2160,7 @@ static void test_efer(void)
 	cr4 = cr4_saved & ~X86_CR4_PAE;
 	vmcb->save.cr4 = cr4;
 	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
-	    "CR0.PG=1 (%lx) and CR4.PAE=0 (%lx)", efer, cr0, cr4);
+	       "CR0.PG=1 (%lx) and CR4.PAE=0 (%lx)", efer, cr0, cr4);
 
 	/*
 	 * EFER.LME and CR0.PG are both set and CR0.PE is zero.
@@ -2172,7 +2173,7 @@ static void test_efer(void)
 	cr0 &= ~X86_CR0_PE;
 	vmcb->save.cr0 = cr0;
 	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
-	    "CR0.PG=1 and CR0.PE=0 (%lx)", efer, cr0);
+	       "CR0.PG=1 and CR0.PE=0 (%lx)", efer, cr0);
 
 	/*
 	 * EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero.
@@ -2186,8 +2187,8 @@ static void test_efer(void)
 	    SVM_SELECTOR_DB_MASK;
 	vmcb->save.cs.attrib = cs_attrib;
 	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
-	    "CR0.PG=1 (%lx), CR4.PAE=1 (%lx), CS.L=1 and CS.D=1 (%x)",
-	    efer, cr0, cr4, cs_attrib);
+	       "CR0.PG=1 (%lx), CR4.PAE=1 (%lx), CS.L=1 and CS.D=1 (%x)",
+	       efer, cr0, cr4, cs_attrib);
 
 	vmcb->save.cr0 = cr0_saved;
 	vmcb->save.cr4 = cr4_saved;
@@ -2206,21 +2207,17 @@ static void test_cr0(void)
 	cr0 |= X86_CR0_CD;
 	cr0 &= ~X86_CR0_NW;
 	vmcb->save.cr0 = cr0;
-	report (svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=1,NW=0: %lx",
-	    cr0);
+	report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=1,NW=0: %lx", cr0);
 	cr0 |= X86_CR0_NW;
 	vmcb->save.cr0 = cr0;
-	report (svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=1,NW=1: %lx",
-	    cr0);
+	report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=1,NW=1: %lx", cr0);
 	cr0 &= ~X86_CR0_NW;
 	cr0 &= ~X86_CR0_CD;
 	vmcb->save.cr0 = cr0;
-	report (svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=0,NW=0: %lx",
-	    cr0);
+	report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=0,NW=0: %lx", cr0);
 	cr0 |= X86_CR0_NW;
 	vmcb->save.cr0 = cr0;
-	report (svm_vmrun() == SVM_EXIT_ERR, "Test CR0 CD=0,NW=1: %lx",
-	    cr0);
+	report(svm_vmrun() == SVM_EXIT_ERR, "Test CR0 CD=0,NW=1: %lx", cr0);
 	vmcb->save.cr0 = cr0_saved;
 
 	/*
@@ -2229,7 +2226,7 @@ static void test_cr0(void)
 	cr0 = cr0_saved;
 
 	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "CR0", vmcb->save.cr0, cr0_saved,
-	    SVM_CR0_RESERVED_MASK);
+				   SVM_CR0_RESERVED_MASK);
 	vmcb->save.cr0 = cr0_saved;
 }
 
@@ -2242,11 +2239,11 @@ static void test_cr3(void)
 	u64 cr3_saved = vmcb->save.cr3;
 
 	SVM_TEST_CR_RESERVED_BITS(0, 63, 1, 3, cr3_saved,
-	    SVM_CR3_LONG_MBZ_MASK, SVM_EXIT_ERR, "");
+				  SVM_CR3_LONG_MBZ_MASK, SVM_EXIT_ERR, "");
 
 	vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_MBZ_MASK;
 	report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
-	    vmcb->save.cr3);
+	       vmcb->save.cr3);
 
 	/*
 	 * CR3 non-MBZ reserved bits based on different modes:
@@ -2262,11 +2259,12 @@ static void test_cr3(void)
 	if (this_cpu_has(X86_FEATURE_PCID)) {
 		vmcb->save.cr4 = cr4_saved | X86_CR4_PCIDE;
 		SVM_TEST_CR_RESERVED_BITS(0, 11, 1, 3, cr3_saved,
-		    SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_VMMCALL, "(PCIDE=1) ");
+					  SVM_CR3_LONG_RESERVED_MASK,
+					  SVM_EXIT_VMMCALL, "(PCIDE=1) ");
 
 		vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_RESERVED_MASK;
 		report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
-		    vmcb->save.cr3);
+		       vmcb->save.cr3);
 	}
 
 	vmcb->save.cr4 = cr4_saved & ~X86_CR4_PCIDE;
@@ -2278,7 +2276,8 @@ static void test_cr3(void)
 	pdpe[0] &= ~1ULL;
 
 	SVM_TEST_CR_RESERVED_BITS(0, 11, 1, 3, cr3_saved,
-	    SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_NPF, "(PCIDE=0) ");
+				  SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_NPF,
+				  "(PCIDE=0) ");
 
 	pdpe[0] |= 1ULL;
 	vmcb->save.cr3 = cr3_saved;
@@ -2289,7 +2288,8 @@ static void test_cr3(void)
 	pdpe[0] &= ~1ULL;
 	vmcb->save.cr4 = cr4_saved | X86_CR4_PAE;
 	SVM_TEST_CR_RESERVED_BITS(0, 2, 1, 3, cr3_saved,
-	    SVM_CR3_PAE_LEGACY_RESERVED_MASK, SVM_EXIT_NPF, "(PAE) ");
+				  SVM_CR3_PAE_LEGACY_RESERVED_MASK,
+				  SVM_EXIT_NPF, "(PAE) ");
 
 	pdpe[0] |= 1ULL;
 
@@ -2308,14 +2308,15 @@ static void test_cr4(void)
 	efer &= ~EFER_LME;
 	vmcb->save.efer = efer;
 	SVM_TEST_CR_RESERVED_BITS(12, 31, 1, 4, cr4_saved,
-	    SVM_CR4_LEGACY_RESERVED_MASK, SVM_EXIT_ERR, "");
+				  SVM_CR4_LEGACY_RESERVED_MASK, SVM_EXIT_ERR,
+				  "");
 
 	efer |= EFER_LME;
 	vmcb->save.efer = efer;
 	SVM_TEST_CR_RESERVED_BITS(12, 31, 1, 4, cr4_saved,
-	    SVM_CR4_RESERVED_MASK, SVM_EXIT_ERR, "");
+				  SVM_CR4_RESERVED_MASK, SVM_EXIT_ERR, "");
 	SVM_TEST_CR_RESERVED_BITS(32, 63, 4, 4, cr4_saved,
-	    SVM_CR4_RESERVED_MASK, SVM_EXIT_ERR, "");
+				  SVM_CR4_RESERVED_MASK, SVM_EXIT_ERR, "");
 
 	vmcb->save.cr4 = cr4_saved;
 	vmcb->save.efer = efer_saved;
@@ -2329,12 +2330,12 @@ static void test_dr(void)
 	u64 dr_saved = vmcb->save.dr6;
 
 	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "DR6", vmcb->save.dr6, dr_saved,
-	    SVM_DR6_RESERVED_MASK);
+				   SVM_DR6_RESERVED_MASK);
 	vmcb->save.dr6 = dr_saved;
 
 	dr_saved = vmcb->save.dr7;
 	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "DR7", vmcb->save.dr7, dr_saved,
-	    SVM_DR7_RESERVED_MASK);
+				   SVM_DR7_RESERVED_MASK);
 
 	vmcb->save.dr7 = dr_saved;
 }
@@ -2374,41 +2375,39 @@ static void test_msrpm_iopm_bitmap_addrs(void)
 	u64 addr = virt_to_phys(msr_bitmap) & (~((1ull << 12) - 1));
 
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
-			addr_beyond_limit - 2 * PAGE_SIZE, SVM_EXIT_ERR,
-			"MSRPM");
+			 addr_beyond_limit - 2 * PAGE_SIZE, SVM_EXIT_ERR,
+			 "MSRPM");
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
-			addr_beyond_limit - 2 * PAGE_SIZE + 1, SVM_EXIT_ERR,
-			"MSRPM");
+			 addr_beyond_limit - 2 * PAGE_SIZE + 1, SVM_EXIT_ERR,
+			 "MSRPM");
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
-			addr_beyond_limit - PAGE_SIZE, SVM_EXIT_ERR,
-			"MSRPM");
+			 addr_beyond_limit - PAGE_SIZE, SVM_EXIT_ERR, "MSRPM");
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT, addr,
-			SVM_EXIT_VMMCALL, "MSRPM");
+			 SVM_EXIT_VMMCALL, "MSRPM");
 	addr |= (1ull << 12) - 1;
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT, addr,
-			SVM_EXIT_VMMCALL, "MSRPM");
+			 SVM_EXIT_VMMCALL, "MSRPM");
 
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
-			addr_beyond_limit - 4 * PAGE_SIZE, SVM_EXIT_VMMCALL,
-			"IOPM");
+			 addr_beyond_limit - 4 * PAGE_SIZE, SVM_EXIT_VMMCALL,
+			 "IOPM");
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
-			addr_beyond_limit - 3 * PAGE_SIZE, SVM_EXIT_VMMCALL,
-			"IOPM");
+			 addr_beyond_limit - 3 * PAGE_SIZE, SVM_EXIT_VMMCALL,
+			 "IOPM");
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
-			addr_beyond_limit - 2 * PAGE_SIZE - 2, SVM_EXIT_VMMCALL,
-			"IOPM");
+			 addr_beyond_limit - 2 * PAGE_SIZE - 2,
+			 SVM_EXIT_VMMCALL, "IOPM");
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
-			addr_beyond_limit - 2 * PAGE_SIZE, SVM_EXIT_ERR,
-			"IOPM");
+			 addr_beyond_limit - 2 * PAGE_SIZE, SVM_EXIT_ERR,
+			 "IOPM");
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
-			addr_beyond_limit - PAGE_SIZE, SVM_EXIT_ERR,
-			"IOPM");
+			 addr_beyond_limit - PAGE_SIZE, SVM_EXIT_ERR, "IOPM");
 	addr = virt_to_phys(io_bitmap) & (~((1ull << 11) - 1));
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT, addr,
-			SVM_EXIT_VMMCALL, "IOPM");
+			 SVM_EXIT_VMMCALL, "IOPM");
 	addr |= (1ull << 12) - 1;
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT, addr,
-			SVM_EXIT_VMMCALL, "IOPM");
+			 SVM_EXIT_VMMCALL, "IOPM");
 
 	vmcb->control.intercept = saved_intercept;
 }
@@ -2425,7 +2424,6 @@ static void test_msrpm_iopm_bitmap_addrs(void)
 			"Successful VMRUN with noncanonical %s.base", msg); \
 	seg_base = saved_addr;
 
-
 #define TEST_CANONICAL_VMLOAD(seg_base, msg)					\
 	saved_addr = seg_base;					\
 	seg_base = (seg_base & ((1ul << addr_limit) - 1)) | noncanonical_mask; \
@@ -2497,10 +2495,7 @@ asm("guest_rflags_test_guest:\n\t"
     "vmmcall\n\t"
     "vmmcall\n\t"
     ".global guest_end\n\t"
-    "guest_end:\n\t"
-    "vmmcall\n\t"
-    "pop %rbp\n\t"
-    "ret");
+    "guest_end:\n\t" "vmmcall\n\t" "pop %rbp\n\t" "ret");
 
 static void svm_test_singlestep(void)
 {
@@ -2510,30 +2505,31 @@ static void svm_test_singlestep(void)
 	 * Trap expected after completion of first guest instruction
 	 */
 	vmcb->save.rflags |= X86_EFLAGS_TF;
-	report (__svm_vmrun((u64)guest_rflags_test_guest) == SVM_EXIT_VMMCALL &&
-		guest_rflags_test_trap_rip == (u64)&insn2,
-               "Test EFLAGS.TF on VMRUN: trap expected  after completion of first guest instruction");
+	report(__svm_vmrun((u64) guest_rflags_test_guest) == SVM_EXIT_VMMCALL &&
+	       guest_rflags_test_trap_rip == (u64) & insn2,
+	       "Test EFLAGS.TF on VMRUN: trap expected  after completion of first guest instruction");
 	/*
 	 * No trap expected
 	 */
 	guest_rflags_test_trap_rip = 0;
 	vmcb->save.rip += 3;
 	vmcb->save.rflags |= X86_EFLAGS_TF;
-	report (__svm_vmrun(vmcb->save.rip) == SVM_EXIT_VMMCALL &&
-		guest_rflags_test_trap_rip == 0, "Test EFLAGS.TF on VMRUN: trap not expected");
+	report(__svm_vmrun(vmcb->save.rip) == SVM_EXIT_VMMCALL &&
+	       guest_rflags_test_trap_rip == 0,
+	       "Test EFLAGS.TF on VMRUN: trap not expected");
 
 	/*
 	 * Let guest finish execution
 	 */
 	vmcb->save.rip += 3;
-	report (__svm_vmrun(vmcb->save.rip) == SVM_EXIT_VMMCALL &&
-		vmcb->save.rip == (u64)&guest_end, "Test EFLAGS.TF on VMRUN: guest execution completion");
+	report(__svm_vmrun(vmcb->save.rip) == SVM_EXIT_VMMCALL &&
+	       vmcb->save.rip == (u64) & guest_end,
+	       "Test EFLAGS.TF on VMRUN: guest execution completion");
 }
 
 static bool volatile svm_errata_reproduced = false;
 static unsigned long volatile physical = 0;
 
-
 /*
  *
  * Test the following errata:
@@ -2548,60 +2544,58 @@ static unsigned long volatile physical = 0;
 
 static void gp_isr(struct ex_regs *r)
 {
-    svm_errata_reproduced = true;
-    /* skip over the vmsave instruction*/
-    r->rip += 3;
+	svm_errata_reproduced = true;
+	/* skip over the vmsave instruction */
+	r->rip += 3;
 }
 
 static void svm_vmrun_errata_test(void)
 {
-    unsigned long *last_page = NULL;
-
-    handle_exception(GP_VECTOR, gp_isr);
+	unsigned long *last_page = NULL;
 
-    while (!svm_errata_reproduced) {
+	handle_exception(GP_VECTOR, gp_isr);
 
-        unsigned long *page = alloc_pages(1);
+	while (!svm_errata_reproduced) {
 
-        if (!page) {
-            report_pass("All guest memory tested, no bug found");
-            break;
-        }
+		unsigned long *page = alloc_pages(1);
 
-        physical = virt_to_phys(page);
+		if (!page) {
+			report_pass("All guest memory tested, no bug found");
+			break;
+		}
 
-        asm volatile (
-            "mov %[_physical], %%rax\n\t"
-            "vmsave %%rax\n\t"
+		physical = virt_to_phys(page);
 
-            : [_physical] "=m" (physical)
-            : /* no inputs*/
-            : "rax" /*clobbers*/
-        );
+		asm volatile ("mov %[_physical], %%rax\n\t"
+			      "vmsave %%rax\n\t":[_physical] "=m"(physical)
+			      :	/* no inputs */
+			      :"rax"	/*clobbers */
+		    );
 
-        if (svm_errata_reproduced) {
-            report_fail("Got #GP exception - svm errata reproduced at 0x%lx",
-                        physical);
-            break;
-        }
+		if (svm_errata_reproduced) {
+			report_fail
+			    ("Got #GP exception - svm errata reproduced at 0x%lx",
+			     physical);
+			break;
+		}
 
-        *page = (unsigned long)last_page;
-        last_page = page;
-    }
+		*page = (unsigned long)last_page;
+		last_page = page;
+	}
 
-    while (last_page) {
-        unsigned long *page = last_page;
-        last_page = (unsigned long *)*last_page;
-        free_pages_by_order(page, 1);
-    }
+	while (last_page) {
+		unsigned long *page = last_page;
+		last_page = (unsigned long *)*last_page;
+		free_pages_by_order(page, 1);
+	}
 }
 
 static void vmload_vmsave_guest_main(struct svm_test *test)
 {
 	u64 vmcb_phys = virt_to_phys(vmcb);
 
-	asm volatile ("vmload %0" : : "a"(vmcb_phys));
-	asm volatile ("vmsave %0" : : "a"(vmcb_phys));
+	asm volatile ("vmload %0"::"a" (vmcb_phys));
+	asm volatile ("vmsave %0"::"a" (vmcb_phys));
 }
 
 static void svm_vmload_vmsave(void)
@@ -2618,7 +2612,7 @@ static void svm_vmload_vmsave(void)
 	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
 	svm_vmrun();
 	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
-	    "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
+	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
 
 	/*
 	 * Enabling intercept for VMLOAD and VMSAVE causes respective
@@ -2627,252 +2621,248 @@ static void svm_vmload_vmsave(void)
 	vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
 	svm_vmrun();
 	report(vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
-	    "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
+	       "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
 	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
 	vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
 	svm_vmrun();
 	report(vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
-	    "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
+	       "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
 	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
 	svm_vmrun();
 	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
-	    "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
+	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
 
 	vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
 	svm_vmrun();
 	report(vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
-	    "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
+	       "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
 	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
 	svm_vmrun();
 	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
-	    "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
+	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
 
 	vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
 	svm_vmrun();
 	report(vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
-	    "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
+	       "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
 	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
 	svm_vmrun();
 	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
-	    "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
+	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
 
 	vmcb->control.intercept = intercept_saved;
 }
 
 static void prepare_vgif_enabled(struct svm_test *test)
 {
-    default_prepare(test);
+	default_prepare(test);
 }
 
 static void test_vgif(struct svm_test *test)
 {
-    asm volatile ("vmmcall\n\tstgi\n\tvmmcall\n\tclgi\n\tvmmcall\n\t");
+	asm volatile ("vmmcall\n\tstgi\n\tvmmcall\n\tclgi\n\tvmmcall\n\t");
 
 }
 
 static bool vgif_finished(struct svm_test *test)
 {
-    switch (get_test_stage(test))
-    {
-    case 0:
-        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report_fail("VMEXIT not due to vmmcall.");
-            return true;
-        }
-        vmcb->control.int_ctl |= V_GIF_ENABLED_MASK;
-        vmcb->save.rip += 3;
-        inc_test_stage(test);
-        break;
-    case 1:
-        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report_fail("VMEXIT not due to vmmcall.");
-            return true;
-        }
-        if (!(vmcb->control.int_ctl & V_GIF_MASK)) {
-            report_fail("Failed to set VGIF when executing STGI.");
-            vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
-            return true;
-        }
-        report_pass("STGI set VGIF bit.");
-        vmcb->save.rip += 3;
-        inc_test_stage(test);
-        break;
-    case 2:
-        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report_fail("VMEXIT not due to vmmcall.");
-            return true;
-        }
-        if (vmcb->control.int_ctl & V_GIF_MASK) {
-            report_fail("Failed to clear VGIF when executing CLGI.");
-            vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
-            return true;
-        }
-        report_pass("CLGI cleared VGIF bit.");
-        vmcb->save.rip += 3;
-        inc_test_stage(test);
-        vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
-        break;
-    default:
-        return true;
-        break;
-    }
-
-    return get_test_stage(test) == 3;
+	switch (get_test_stage(test)) {
+	case 0:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			report_fail("VMEXIT not due to vmmcall.");
+			return true;
+		}
+		vmcb->control.int_ctl |= V_GIF_ENABLED_MASK;
+		vmcb->save.rip += 3;
+		inc_test_stage(test);
+		break;
+	case 1:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			report_fail("VMEXIT not due to vmmcall.");
+			return true;
+		}
+		if (!(vmcb->control.int_ctl & V_GIF_MASK)) {
+			report_fail("Failed to set VGIF when executing STGI.");
+			vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
+			return true;
+		}
+		report_pass("STGI set VGIF bit.");
+		vmcb->save.rip += 3;
+		inc_test_stage(test);
+		break;
+	case 2:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			report_fail("VMEXIT not due to vmmcall.");
+			return true;
+		}
+		if (vmcb->control.int_ctl & V_GIF_MASK) {
+			report_fail
+			    ("Failed to clear VGIF when executing CLGI.");
+			vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
+			return true;
+		}
+		report_pass("CLGI cleared VGIF bit.");
+		vmcb->save.rip += 3;
+		inc_test_stage(test);
+		vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
+		break;
+	default:
+		return true;
+		break;
+	}
+
+	return get_test_stage(test) == 3;
 }
 
 static bool vgif_check(struct svm_test *test)
 {
-    return get_test_stage(test) == 3;
+	return get_test_stage(test) == 3;
 }
 
-
 static int pause_test_counter;
 static int wait_counter;
 
 static void pause_filter_test_guest_main(struct svm_test *test)
 {
-    int i;
-    for (i = 0 ; i < pause_test_counter ; i++)
-        pause();
+	int i;
+	for (i = 0; i < pause_test_counter; i++)
+		pause();
 
-    if (!wait_counter)
-        return;
+	if (!wait_counter)
+		return;
 
-    for (i = 0; i < wait_counter; i++)
-        ;
+	for (i = 0; i < wait_counter; i++) ;
 
-    for (i = 0 ; i < pause_test_counter ; i++)
-        pause();
+	for (i = 0; i < pause_test_counter; i++)
+		pause();
 
 }
 
-static void pause_filter_run_test(int pause_iterations, int filter_value, int wait_iterations, int threshold)
+static void pause_filter_run_test(int pause_iterations, int filter_value,
+				  int wait_iterations, int threshold)
 {
-    test_set_guest(pause_filter_test_guest_main);
+	test_set_guest(pause_filter_test_guest_main);
 
-    pause_test_counter = pause_iterations;
-    wait_counter = wait_iterations;
+	pause_test_counter = pause_iterations;
+	wait_counter = wait_iterations;
 
-    vmcb->control.pause_filter_count = filter_value;
-    vmcb->control.pause_filter_thresh = threshold;
-    svm_vmrun();
+	vmcb->control.pause_filter_count = filter_value;
+	vmcb->control.pause_filter_thresh = threshold;
+	svm_vmrun();
 
-    if (filter_value <= pause_iterations || wait_iterations < threshold)
-        report(vmcb->control.exit_code == SVM_EXIT_PAUSE, "expected PAUSE vmexit");
-    else
-        report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "no expected PAUSE vmexit");
+	if (filter_value <= pause_iterations || wait_iterations < threshold)
+		report(vmcb->control.exit_code == SVM_EXIT_PAUSE,
+		       "expected PAUSE vmexit");
+	else
+		report(vmcb->control.exit_code == SVM_EXIT_VMMCALL,
+		       "no expected PAUSE vmexit");
 }
 
 static void pause_filter_test(void)
 {
-    if (!pause_filter_supported()) {
-            report_skip("PAUSE filter not supported in the guest");
-            return;
-    }
-
-    vmcb->control.intercept |= (1 << INTERCEPT_PAUSE);
+	if (!pause_filter_supported()) {
+		report_skip("PAUSE filter not supported in the guest");
+		return;
+	}
 
-    // filter count more that pause count - no VMexit
-    pause_filter_run_test(10, 9, 0, 0);
+	vmcb->control.intercept |= (1 << INTERCEPT_PAUSE);
 
-    // filter count smaller pause count - no VMexit
-    pause_filter_run_test(20, 21, 0, 0);
+	// filter count more that pause count - no VMexit
+	pause_filter_run_test(10, 9, 0, 0);
 
+	// filter count smaller pause count - no VMexit
+	pause_filter_run_test(20, 21, 0, 0);
 
-    if (pause_threshold_supported()) {
-        // filter count smaller pause count - no VMexit +  large enough threshold
-        // so that filter counter resets
-        pause_filter_run_test(20, 21, 1000, 10);
+	if (pause_threshold_supported()) {
+		// filter count smaller pause count - no VMexit +  large enough threshold
+		// so that filter counter resets
+		pause_filter_run_test(20, 21, 1000, 10);
 
-        // filter count smaller pause count - no VMexit +  small threshold
-        // so that filter doesn't reset
-        pause_filter_run_test(20, 21, 10, 1000);
-    } else {
-        report_skip("PAUSE threshold not supported in the guest");
-        return;
-    }
+		// filter count smaller pause count - no VMexit +  small threshold
+		// so that filter doesn't reset
+		pause_filter_run_test(20, 21, 10, 1000);
+	} else {
+		report_skip("PAUSE threshold not supported in the guest");
+		return;
+	}
 }
 
-
 static int of_test_counter;
 
 static void guest_test_of_handler(struct ex_regs *r)
 {
-    of_test_counter++;
+	of_test_counter++;
 }
 
 static void svm_of_test_guest(struct svm_test *test)
 {
-    struct far_pointer32 fp = {
-        .offset = (uintptr_t)&&into,
-        .selector = KERNEL_CS32,
-    };
-    uintptr_t rsp;
+	struct far_pointer32 fp = {
+		.offset = (uintptr_t) && into,
+		.selector = KERNEL_CS32,
+	};
+	uintptr_t rsp;
 
-    asm volatile ("mov %%rsp, %0" : "=r"(rsp));
+	asm volatile ("mov %%rsp, %0":"=r" (rsp));
 
-    if (fp.offset != (uintptr_t)&&into) {
-        printf("Codee address too high.\n");
-        return;
-    }
+	if (fp.offset != (uintptr_t) && into) {
+		printf("Codee address too high.\n");
+		return;
+	}
 
-    if ((u32)rsp != rsp) {
-        printf("Stack address too high.\n");
-    }
+	if ((u32) rsp != rsp) {
+		printf("Stack address too high.\n");
+	}
 
-    asm goto("lcall *%0" : : "m" (fp) : "rax" : into);
-    return;
+	asm goto ("lcall *%0"::"m" (fp):"rax":into);
+	return;
 into:
 
-    asm volatile (".code32;"
-            "movl $0x7fffffff, %eax;"
-            "addl %eax, %eax;"
-            "into;"
-            "lret;"
-            ".code64");
-    __builtin_unreachable();
+	asm volatile (".code32;"
+		      "movl $0x7fffffff, %eax;"
+		      "addl %eax, %eax;" "into;" "lret;" ".code64");
+	__builtin_unreachable();
 }
 
 static void svm_into_test(void)
 {
-    handle_exception(OF_VECTOR, guest_test_of_handler);
-    test_set_guest(svm_of_test_guest);
-    report(svm_vmrun() == SVM_EXIT_VMMCALL && of_test_counter == 1,
-        "#OF is generated in L2 exception handler0");
+	handle_exception(OF_VECTOR, guest_test_of_handler);
+	test_set_guest(svm_of_test_guest);
+	report(svm_vmrun() == SVM_EXIT_VMMCALL && of_test_counter == 1,
+	       "#OF is generated in L2 exception handler0");
 }
 
 static int bp_test_counter;
 
 static void guest_test_bp_handler(struct ex_regs *r)
 {
-    bp_test_counter++;
+	bp_test_counter++;
 }
 
 static void svm_bp_test_guest(struct svm_test *test)
 {
-    asm volatile("int3");
+	asm volatile ("int3");
 }
 
 static void svm_int3_test(void)
 {
-    handle_exception(BP_VECTOR, guest_test_bp_handler);
-    test_set_guest(svm_bp_test_guest);
-    report(svm_vmrun() == SVM_EXIT_VMMCALL && bp_test_counter == 1,
-        "#BP is handled in L2 exception handler");
+	handle_exception(BP_VECTOR, guest_test_bp_handler);
+	test_set_guest(svm_bp_test_guest);
+	report(svm_vmrun() == SVM_EXIT_VMMCALL && bp_test_counter == 1,
+	       "#BP is handled in L2 exception handler");
 }
 
 static int nm_test_counter;
 
 static void guest_test_nm_handler(struct ex_regs *r)
 {
-    nm_test_counter++; 
-    write_cr0(read_cr0() & ~X86_CR0_TS);
-    write_cr0(read_cr0() & ~X86_CR0_EM);
+	nm_test_counter++;
+	write_cr0(read_cr0() & ~X86_CR0_TS);
+	write_cr0(read_cr0() & ~X86_CR0_EM);
 }
 
 static void svm_nm_test_guest(struct svm_test *test)
 {
-    asm volatile("fnop");
+	asm volatile ("fnop");
 }
 
 /* This test checks that:
@@ -2889,38 +2879,39 @@ static void svm_nm_test_guest(struct svm_test *test)
 
 static void svm_nm_test(void)
 {
-    handle_exception(NM_VECTOR, guest_test_nm_handler);
-    write_cr0(read_cr0() & ~X86_CR0_TS);
-    test_set_guest(svm_nm_test_guest);
+	handle_exception(NM_VECTOR, guest_test_nm_handler);
+	write_cr0(read_cr0() & ~X86_CR0_TS);
+	test_set_guest(svm_nm_test_guest);
 
-    vmcb->save.cr0 = vmcb->save.cr0 | X86_CR0_TS;
-    report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 1,
-        "fnop with CR0.TS set in L2, #NM is triggered");
+	vmcb->save.cr0 = vmcb->save.cr0 | X86_CR0_TS;
+	report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 1,
+	       "fnop with CR0.TS set in L2, #NM is triggered");
 
-    vmcb->save.cr0 = (vmcb->save.cr0 & ~X86_CR0_TS) | X86_CR0_EM;
-    report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 2,
-        "fnop with CR0.EM set in L2, #NM is triggered");
+	vmcb->save.cr0 = (vmcb->save.cr0 & ~X86_CR0_TS) | X86_CR0_EM;
+	report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 2,
+	       "fnop with CR0.EM set in L2, #NM is triggered");
 
-    vmcb->save.cr0 = vmcb->save.cr0 & ~(X86_CR0_TS | X86_CR0_EM);
-    report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 2,
-        "fnop with CR0.TS and CR0.EM unset no #NM excpetion");
+	vmcb->save.cr0 = vmcb->save.cr0 & ~(X86_CR0_TS | X86_CR0_EM);
+	report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 2,
+	       "fnop with CR0.TS and CR0.EM unset no #NM excpetion");
 }
 
-
-static bool check_lbr(u64 *from_excepted, u64 *to_expected)
+static bool check_lbr(u64 * from_excepted, u64 * to_expected)
 {
 	u64 from = rdmsr(MSR_IA32_LASTBRANCHFROMIP);
 	u64 to = rdmsr(MSR_IA32_LASTBRANCHTOIP);
 
-	if ((u64)from_excepted != from) {
-		report(false, "MSR_IA32_LASTBRANCHFROMIP, expected=0x%lx, actual=0x%lx",
-			(u64)from_excepted, from);
+	if ((u64) from_excepted != from) {
+		report(false,
+		       "MSR_IA32_LASTBRANCHFROMIP, expected=0x%lx, actual=0x%lx",
+		       (u64) from_excepted, from);
 		return false;
 	}
 
-	if ((u64)to_expected != to) {
-		report(false, "MSR_IA32_LASTBRANCHFROMIP, expected=0x%lx, actual=0x%lx",
-			(u64)from_excepted, from);
+	if ((u64) to_expected != to) {
+		report(false,
+		       "MSR_IA32_LASTBRANCHFROMIP, expected=0x%lx, actual=0x%lx",
+		       (u64) from_excepted, from);
 		return false;
 	}
 
@@ -2930,13 +2921,13 @@ static bool check_lbr(u64 *from_excepted, u64 *to_expected)
 static bool check_dbgctl(u64 dbgctl, u64 dbgctl_expected)
 {
 	if (dbgctl != dbgctl_expected) {
-		report(false, "Unexpected MSR_IA32_DEBUGCTLMSR value 0x%lx", dbgctl);
+		report(false, "Unexpected MSR_IA32_DEBUGCTLMSR value 0x%lx",
+		       dbgctl);
 		return false;
 	}
 	return true;
 }
 
-
 #define DO_BRANCH(branch_name) \
 	asm volatile ( \
 		# branch_name "_from:" \
@@ -2947,7 +2938,6 @@ static bool check_dbgctl(u64 dbgctl, u64 dbgctl_expected)
 		"nop\n" \
 	)
 
-
 extern u64 guest_branch0_from, guest_branch0_to;
 extern u64 guest_branch2_from, guest_branch2_to;
 
@@ -2971,13 +2961,13 @@ static void svm_lbrv_test_guest1(void)
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
 
 	if (dbgctl != DEBUGCTLMSR_LBR)
-		asm volatile("ud2\n");
+		asm volatile ("ud2\n");
 	if (rdmsr(MSR_IA32_DEBUGCTLMSR) != 0)
-		asm volatile("ud2\n");
-	if (rdmsr(MSR_IA32_LASTBRANCHFROMIP) != (u64)&guest_branch0_from)
-		asm volatile("ud2\n");
-	if (rdmsr(MSR_IA32_LASTBRANCHTOIP) != (u64)&guest_branch0_to)
-		asm volatile("ud2\n");
+		asm volatile ("ud2\n");
+	if (rdmsr(MSR_IA32_LASTBRANCHFROMIP) != (u64) & guest_branch0_from)
+		asm volatile ("ud2\n");
+	if (rdmsr(MSR_IA32_LASTBRANCHTOIP) != (u64) & guest_branch0_to)
+		asm volatile ("ud2\n");
 
 	asm volatile ("vmmcall\n");
 }
@@ -2993,13 +2983,12 @@ static void svm_lbrv_test_guest2(void)
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 
 	if (dbgctl != 0)
-		asm volatile("ud2\n");
-
-	if (rdmsr(MSR_IA32_LASTBRANCHFROMIP) != (u64)&host_branch2_from)
-		asm volatile("ud2\n");
-	if (rdmsr(MSR_IA32_LASTBRANCHTOIP) != (u64)&host_branch2_to)
-		asm volatile("ud2\n");
+		asm volatile ("ud2\n");
 
+	if (rdmsr(MSR_IA32_LASTBRANCHFROMIP) != (u64) & host_branch2_from)
+		asm volatile ("ud2\n");
+	if (rdmsr(MSR_IA32_LASTBRANCHTOIP) != (u64) & host_branch2_to)
+		asm volatile ("ud2\n");
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
@@ -3007,11 +2996,11 @@ static void svm_lbrv_test_guest2(void)
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
 
 	if (dbgctl != DEBUGCTLMSR_LBR)
-		asm volatile("ud2\n");
-	if (rdmsr(MSR_IA32_LASTBRANCHFROMIP) != (u64)&guest_branch2_from)
-		asm volatile("ud2\n");
-	if (rdmsr(MSR_IA32_LASTBRANCHTOIP) != (u64)&guest_branch2_to)
-		asm volatile("ud2\n");
+		asm volatile ("ud2\n");
+	if (rdmsr(MSR_IA32_LASTBRANCHFROMIP) != (u64) & guest_branch2_from)
+		asm volatile ("ud2\n");
+	if (rdmsr(MSR_IA32_LASTBRANCHTOIP) != (u64) & guest_branch2_to)
+		asm volatile ("ud2\n");
 
 	asm volatile ("vmmcall\n");
 }
@@ -3033,9 +3022,10 @@ static void svm_lbrv_test0(void)
 
 static void svm_lbrv_test1(void)
 {
-	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(1)");
+	report(true,
+	       "Test that without LBRV enabled, guest LBR state does 'leak' to the host(1)");
 
-	vmcb->save.rip = (ulong)svm_lbrv_test_guest1;
+	vmcb->save.rip = (ulong) svm_lbrv_test_guest1;
 	vmcb->control.virt_ext = 0;
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
@@ -3045,7 +3035,7 @@ static void svm_lbrv_test1(void)
 
 	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-		vmcb->control.exit_code);
+		       vmcb->control.exit_code);
 		return;
 	}
 
@@ -3055,9 +3045,10 @@ static void svm_lbrv_test1(void)
 
 static void svm_lbrv_test2(void)
 {
-	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(2)");
+	report(true,
+	       "Test that without LBRV enabled, guest LBR state does 'leak' to the host(2)");
 
-	vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
+	vmcb->save.rip = (ulong) svm_lbrv_test_guest2;
 	vmcb->control.virt_ext = 0;
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
@@ -3069,7 +3060,7 @@ static void svm_lbrv_test2(void)
 
 	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-		vmcb->control.exit_code);
+		       vmcb->control.exit_code);
 		return;
 	}
 
@@ -3084,8 +3075,9 @@ static void svm_lbrv_nested_test1(void)
 		return;
 	}
 
-	report(true, "Test that with LBRV enabled, guest LBR state doesn't leak (1)");
-	vmcb->save.rip = (ulong)svm_lbrv_test_guest1;
+	report(true,
+	       "Test that with LBRV enabled, guest LBR state doesn't leak (1)");
+	vmcb->save.rip = (ulong) svm_lbrv_test_guest1;
 	vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
 	vmcb->save.dbgctl = DEBUGCTLMSR_LBR;
 
@@ -3097,18 +3089,21 @@ static void svm_lbrv_nested_test1(void)
 
 	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-		vmcb->control.exit_code);
+		       vmcb->control.exit_code);
 		return;
 	}
 
 	if (vmcb->save.dbgctl != 0) {
-		report(false, "unexpected virtual guest MSR_IA32_DEBUGCTLMSR value 0x%lx", vmcb->save.dbgctl);
+		report(false,
+		       "unexpected virtual guest MSR_IA32_DEBUGCTLMSR value 0x%lx",
+		       vmcb->save.dbgctl);
 		return;
 	}
 
 	check_dbgctl(dbgctl, DEBUGCTLMSR_LBR);
 	check_lbr(&host_branch3_from, &host_branch3_to);
 }
+
 static void svm_lbrv_nested_test2(void)
 {
 	if (!lbrv_supported()) {
@@ -3116,13 +3111,14 @@ static void svm_lbrv_nested_test2(void)
 		return;
 	}
 
-	report(true, "Test that with LBRV enabled, guest LBR state doesn't leak (2)");
-	vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
+	report(true,
+	       "Test that with LBRV enabled, guest LBR state doesn't leak (2)");
+	vmcb->save.rip = (ulong) svm_lbrv_test_guest2;
 	vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
 
 	vmcb->save.dbgctl = 0;
-	vmcb->save.br_from = (u64)&host_branch2_from;
-	vmcb->save.br_to = (u64)&host_branch2_to;
+	vmcb->save.br_from = (u64) & host_branch2_from;
+	vmcb->save.br_to = (u64) & host_branch2_to;
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
 	DO_BRANCH(host_branch4);
@@ -3132,7 +3128,7 @@ static void svm_lbrv_nested_test2(void)
 
 	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-		vmcb->control.exit_code);
+		       vmcb->control.exit_code);
 		return;
 	}
 
@@ -3140,32 +3136,30 @@ static void svm_lbrv_nested_test2(void)
 	check_lbr(&host_branch4_from, &host_branch4_to);
 }
 
-
 // test that a nested guest which does enable INTR interception
 // but doesn't enable virtual interrupt masking works
 
 static volatile int dummy_isr_recevied;
-static void dummy_isr(isr_regs_t *regs)
+static void dummy_isr(isr_regs_t * regs)
 {
 	dummy_isr_recevied++;
 	eoi();
 }
 
-
 static volatile int nmi_recevied;
 static void dummy_nmi_handler(struct ex_regs *regs)
 {
 	nmi_recevied++;
 }
 
-
-static void svm_intr_intercept_mix_run_guest(volatile int *counter, int expected_vmexit)
+static void svm_intr_intercept_mix_run_guest(volatile int *counter,
+					     int expected_vmexit)
 {
 	if (counter)
 		*counter = 0;
 
-	sti();  // host IF value should not matter
-	clgi(); // vmrun will set back GI to 1
+	sti();			// host IF value should not matter
+	clgi();			// vmrun will set back GI to 1
 
 	svm_vmrun();
 
@@ -3177,19 +3171,20 @@ static void svm_intr_intercept_mix_run_guest(volatile int *counter, int expected
 	if (counter)
 		report(*counter == 1, "Interrupt is expected");
 
-	report (vmcb->control.exit_code == expected_vmexit, "Test expected VM exit");
-	report(vmcb->save.rflags & X86_EFLAGS_IF, "Guest should have EFLAGS.IF set now");
+	report(vmcb->control.exit_code == expected_vmexit,
+	       "Test expected VM exit");
+	report(vmcb->save.rflags & X86_EFLAGS_IF,
+	       "Guest should have EFLAGS.IF set now");
 	cli();
 }
 
-
 // subtest: test that enabling EFLAGS.IF is enought to trigger an interrupt
 static void svm_intr_intercept_mix_if_guest(struct svm_test *test)
 {
-	asm volatile("nop;nop;nop;nop");
+	asm volatile ("nop;nop;nop;nop");
 	report(!dummy_isr_recevied, "No interrupt expected");
 	sti();
-	asm volatile("nop");
+	asm volatile ("nop");
 	report(0, "must not reach here");
 }
 
@@ -3203,28 +3198,28 @@ static void svm_intr_intercept_mix_if(void)
 	vmcb->save.rflags &= ~X86_EFLAGS_IF;
 
 	test_set_guest(svm_intr_intercept_mix_if_guest);
-	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | 0x55, 0);
+	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED |
+		       0x55, 0);
 	svm_intr_intercept_mix_run_guest(&dummy_isr_recevied, SVM_EXIT_INTR);
 }
 
-
 // subtest: test that a clever guest can trigger an interrupt by setting GIF
 // if GIF is not intercepted
 static void svm_intr_intercept_mix_gif_guest(struct svm_test *test)
 {
 
-	asm volatile("nop;nop;nop;nop");
+	asm volatile ("nop;nop;nop;nop");
 	report(!dummy_isr_recevied, "No interrupt expected");
 
 	// clear GIF and enable IF
 	// that should still not cause VM exit
 	clgi();
 	sti();
-	asm volatile("nop");
+	asm volatile ("nop");
 	report(!dummy_isr_recevied, "No interrupt expected");
 
 	stgi();
-	asm volatile("nop");
+	asm volatile ("nop");
 	report(0, "must not reach here");
 }
 
@@ -3237,26 +3232,26 @@ static void svm_intr_intercept_mix_gif(void)
 	vmcb->save.rflags &= ~X86_EFLAGS_IF;
 
 	test_set_guest(svm_intr_intercept_mix_gif_guest);
-	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | 0x55, 0);
+	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED |
+		       0x55, 0);
 	svm_intr_intercept_mix_run_guest(&dummy_isr_recevied, SVM_EXIT_INTR);
 }
 
-
-
 // subtest: test that a clever guest can trigger an interrupt by setting GIF
 // if GIF is not intercepted and interrupt comes after guest
 // started running
 static void svm_intr_intercept_mix_gif_guest2(struct svm_test *test)
 {
-	asm volatile("nop;nop;nop;nop");
+	asm volatile ("nop;nop;nop;nop");
 	report(!dummy_isr_recevied, "No interrupt expected");
 
 	clgi();
-	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | 0x55, 0);
+	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED |
+		       0x55, 0);
 	report(!dummy_isr_recevied, "No interrupt expected");
 
 	stgi();
-	asm volatile("nop");
+	asm volatile ("nop");
 	report(0, "must not reach here");
 }
 
@@ -3272,23 +3267,22 @@ static void svm_intr_intercept_mix_gif2(void)
 	svm_intr_intercept_mix_run_guest(&dummy_isr_recevied, SVM_EXIT_INTR);
 }
 
-
 // subtest: test that pending NMI will be handled when guest enables GIF
 static void svm_intr_intercept_mix_nmi_guest(struct svm_test *test)
 {
-	asm volatile("nop;nop;nop;nop");
+	asm volatile ("nop;nop;nop;nop");
 	report(!nmi_recevied, "No NMI expected");
-	cli(); // should have no effect
+	cli();			// should have no effect
 
 	clgi();
-	asm volatile("nop");
+	asm volatile ("nop");
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI, 0);
-	sti(); // should have no effect
-	asm volatile("nop");
+	sti();			// should have no effect
+	asm volatile ("nop");
 	report(!nmi_recevied, "No NMI expected");
 
 	stgi();
-	asm volatile("nop");
+	asm volatile ("nop");
 	report(0, "must not reach here");
 }
 
@@ -3309,15 +3303,15 @@ static void svm_intr_intercept_mix_nmi(void)
 // and VMexits on SMI
 static void svm_intr_intercept_mix_smi_guest(struct svm_test *test)
 {
-	asm volatile("nop;nop;nop;nop");
+	asm volatile ("nop;nop;nop;nop");
 
 	clgi();
-	asm volatile("nop");
+	asm volatile ("nop");
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_SMI, 0);
-	sti(); // should have no effect
-	asm volatile("nop");
+	sti();			// should have no effect
+	asm volatile ("nop");
 	stgi();
-	asm volatile("nop");
+	asm volatile ("nop");
 	report(0, "must not reach here");
 }
 
@@ -3331,121 +3325,121 @@ static void svm_intr_intercept_mix_smi(void)
 
 int main(int ac, char **av)
 {
-    setup_vm();
-    return run_svm_tests(ac, av);
+	setup_vm();
+	return run_svm_tests(ac, av);
 }
 
 struct svm_test svm_tests[] = {
-    { "null", default_supported, default_prepare,
-      default_prepare_gif_clear, null_test,
-      default_finished, null_check },
-    { "vmrun", default_supported, default_prepare,
-      default_prepare_gif_clear, test_vmrun,
-       default_finished, check_vmrun },
-    { "ioio", default_supported, prepare_ioio,
-       default_prepare_gif_clear, test_ioio,
-       ioio_finished, check_ioio },
-    { "vmrun intercept check", default_supported, prepare_no_vmrun_int,
-      default_prepare_gif_clear, null_test, default_finished,
-      check_no_vmrun_int },
-    { "rsm", default_supported,
-      prepare_rsm_intercept, default_prepare_gif_clear,
-      test_rsm_intercept, finished_rsm_intercept, check_rsm_intercept },
-    { "cr3 read intercept", default_supported,
-      prepare_cr3_intercept, default_prepare_gif_clear,
-      test_cr3_intercept, default_finished, check_cr3_intercept },
-    { "cr3 read nointercept", default_supported, default_prepare,
-      default_prepare_gif_clear, test_cr3_intercept, default_finished,
-      check_cr3_nointercept },
-    { "cr3 read intercept emulate", smp_supported,
-      prepare_cr3_intercept_bypass, default_prepare_gif_clear,
-      test_cr3_intercept_bypass, default_finished, check_cr3_intercept },
-    { "dr intercept check", default_supported, prepare_dr_intercept,
-      default_prepare_gif_clear, test_dr_intercept, dr_intercept_finished,
-      check_dr_intercept },
-    { "next_rip", next_rip_supported, prepare_next_rip,
-      default_prepare_gif_clear, test_next_rip,
-      default_finished, check_next_rip },
-    { "msr intercept check", default_supported, prepare_msr_intercept,
-      default_prepare_gif_clear, test_msr_intercept,
-      msr_intercept_finished, check_msr_intercept },
-    { "mode_switch", default_supported, prepare_mode_switch,
-      default_prepare_gif_clear, test_mode_switch,
-       mode_switch_finished, check_mode_switch },
-    { "asid_zero", default_supported, prepare_asid_zero,
-      default_prepare_gif_clear, test_asid_zero,
-       default_finished, check_asid_zero },
-    { "sel_cr0_bug", default_supported, sel_cr0_bug_prepare,
-      default_prepare_gif_clear, sel_cr0_bug_test,
-       sel_cr0_bug_finished, sel_cr0_bug_check },
-    { "tsc_adjust", tsc_adjust_supported, tsc_adjust_prepare,
-      default_prepare_gif_clear, tsc_adjust_test,
-      default_finished, tsc_adjust_check },
-    { "latency_run_exit", default_supported, latency_prepare,
-      default_prepare_gif_clear, latency_test,
-      latency_finished, latency_check },
-    { "latency_run_exit_clean", default_supported, latency_prepare,
-      default_prepare_gif_clear, latency_test,
-      latency_finished_clean, latency_check },
-    { "latency_svm_insn", default_supported, lat_svm_insn_prepare,
-      default_prepare_gif_clear, null_test,
-      lat_svm_insn_finished, lat_svm_insn_check },
-    { "exc_inject", default_supported, exc_inject_prepare,
-      default_prepare_gif_clear, exc_inject_test,
-      exc_inject_finished, exc_inject_check },
-    { "pending_event", default_supported, pending_event_prepare,
-      default_prepare_gif_clear,
-      pending_event_test, pending_event_finished, pending_event_check },
-    { "pending_event_cli", default_supported, pending_event_cli_prepare,
-      pending_event_cli_prepare_gif_clear,
-      pending_event_cli_test, pending_event_cli_finished,
-      pending_event_cli_check },
-    { "interrupt", default_supported, interrupt_prepare,
-      default_prepare_gif_clear, interrupt_test,
-      interrupt_finished, interrupt_check },
-    { "nmi", default_supported, nmi_prepare,
-      default_prepare_gif_clear, nmi_test,
-      nmi_finished, nmi_check },
-    { "nmi_hlt", smp_supported, nmi_prepare,
-      default_prepare_gif_clear, nmi_hlt_test,
-      nmi_hlt_finished, nmi_hlt_check },
-    { "virq_inject", default_supported, virq_inject_prepare,
-      default_prepare_gif_clear, virq_inject_test,
-      virq_inject_finished, virq_inject_check },
-    { "reg_corruption", default_supported, reg_corruption_prepare,
-      default_prepare_gif_clear, reg_corruption_test,
-      reg_corruption_finished, reg_corruption_check },
-    { "svm_init_startup_test", smp_supported, init_startup_prepare,
-      default_prepare_gif_clear, null_test,
-      init_startup_finished, init_startup_check },
-    { "svm_init_intercept_test", smp_supported, init_intercept_prepare,
-      default_prepare_gif_clear, init_intercept_test,
-      init_intercept_finished, init_intercept_check, .on_vcpu = 2 },
-    { "host_rflags", default_supported, host_rflags_prepare,
-      host_rflags_prepare_gif_clear, host_rflags_test,
-      host_rflags_finished, host_rflags_check },
-    { "vgif", vgif_supported, prepare_vgif_enabled,
-      default_prepare_gif_clear, test_vgif, vgif_finished,
-      vgif_check },
-    TEST(svm_cr4_osxsave_test),
-    TEST(svm_guest_state_test),
-    TEST(svm_vmrun_errata_test),
-    TEST(svm_vmload_vmsave),
-    TEST(svm_test_singlestep),
-    TEST(svm_nm_test),
-    TEST(svm_int3_test),
-    TEST(svm_into_test),
-    TEST(svm_lbrv_test0),
-    TEST(svm_lbrv_test1),
-    TEST(svm_lbrv_test2),
-    TEST(svm_lbrv_nested_test1),
-    TEST(svm_lbrv_nested_test2),
-    TEST(svm_intr_intercept_mix_if),
-    TEST(svm_intr_intercept_mix_gif),
-    TEST(svm_intr_intercept_mix_gif2),
-    TEST(svm_intr_intercept_mix_nmi),
-    TEST(svm_intr_intercept_mix_smi),
-    TEST(svm_tsc_scale_test),
-    TEST(pause_filter_test),
-    { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
+	{ "null", default_supported, default_prepare,
+	 default_prepare_gif_clear, null_test,
+	 default_finished, null_check },
+	{ "vmrun", default_supported, default_prepare,
+	 default_prepare_gif_clear, test_vmrun,
+	 default_finished, check_vmrun },
+	{ "ioio", default_supported, prepare_ioio,
+	 default_prepare_gif_clear, test_ioio,
+	 ioio_finished, check_ioio },
+	{ "vmrun intercept check", default_supported, prepare_no_vmrun_int,
+	 default_prepare_gif_clear, null_test, default_finished,
+	 check_no_vmrun_int },
+	{ "rsm", default_supported,
+	 prepare_rsm_intercept, default_prepare_gif_clear,
+	 test_rsm_intercept, finished_rsm_intercept, check_rsm_intercept },
+	{ "cr3 read intercept", default_supported,
+	 prepare_cr3_intercept, default_prepare_gif_clear,
+	 test_cr3_intercept, default_finished, check_cr3_intercept },
+	{ "cr3 read nointercept", default_supported, default_prepare,
+	 default_prepare_gif_clear, test_cr3_intercept, default_finished,
+	 check_cr3_nointercept },
+	{ "cr3 read intercept emulate", smp_supported,
+	 prepare_cr3_intercept_bypass, default_prepare_gif_clear,
+	 test_cr3_intercept_bypass, default_finished, check_cr3_intercept },
+	{ "dr intercept check", default_supported, prepare_dr_intercept,
+	 default_prepare_gif_clear, test_dr_intercept, dr_intercept_finished,
+	 check_dr_intercept },
+	{ "next_rip", next_rip_supported, prepare_next_rip,
+	 default_prepare_gif_clear, test_next_rip,
+	 default_finished, check_next_rip },
+	{ "msr intercept check", default_supported, prepare_msr_intercept,
+	 default_prepare_gif_clear, test_msr_intercept,
+	 msr_intercept_finished, check_msr_intercept },
+	{ "mode_switch", default_supported, prepare_mode_switch,
+	 default_prepare_gif_clear, test_mode_switch,
+	 mode_switch_finished, check_mode_switch },
+	{ "asid_zero", default_supported, prepare_asid_zero,
+	 default_prepare_gif_clear, test_asid_zero,
+	 default_finished, check_asid_zero },
+	{ "sel_cr0_bug", default_supported, sel_cr0_bug_prepare,
+	 default_prepare_gif_clear, sel_cr0_bug_test,
+	 sel_cr0_bug_finished, sel_cr0_bug_check },
+	{ "tsc_adjust", tsc_adjust_supported, tsc_adjust_prepare,
+	 default_prepare_gif_clear, tsc_adjust_test,
+	 default_finished, tsc_adjust_check },
+	{ "latency_run_exit", default_supported, latency_prepare,
+	 default_prepare_gif_clear, latency_test,
+	 latency_finished, latency_check },
+	{ "latency_run_exit_clean", default_supported, latency_prepare,
+	 default_prepare_gif_clear, latency_test,
+	 latency_finished_clean, latency_check },
+	{ "latency_svm_insn", default_supported, lat_svm_insn_prepare,
+	 default_prepare_gif_clear, null_test,
+	 lat_svm_insn_finished, lat_svm_insn_check },
+	{ "exc_inject", default_supported, exc_inject_prepare,
+	 default_prepare_gif_clear, exc_inject_test,
+	 exc_inject_finished, exc_inject_check },
+	{ "pending_event", default_supported, pending_event_prepare,
+	 default_prepare_gif_clear,
+	 pending_event_test, pending_event_finished, pending_event_check },
+	{ "pending_event_cli", default_supported, pending_event_cli_prepare,
+	 pending_event_cli_prepare_gif_clear,
+	 pending_event_cli_test, pending_event_cli_finished,
+	 pending_event_cli_check },
+	{ "interrupt", default_supported, interrupt_prepare,
+	 default_prepare_gif_clear, interrupt_test,
+	 interrupt_finished, interrupt_check },
+	{ "nmi", default_supported, nmi_prepare,
+	 default_prepare_gif_clear, nmi_test,
+	 nmi_finished, nmi_check },
+	{ "nmi_hlt", smp_supported, nmi_prepare,
+	 default_prepare_gif_clear, nmi_hlt_test,
+	 nmi_hlt_finished, nmi_hlt_check },
+	{ "virq_inject", default_supported, virq_inject_prepare,
+	 default_prepare_gif_clear, virq_inject_test,
+	 virq_inject_finished, virq_inject_check },
+	{ "reg_corruption", default_supported, reg_corruption_prepare,
+	 default_prepare_gif_clear, reg_corruption_test,
+	 reg_corruption_finished, reg_corruption_check },
+	{ "svm_init_startup_test", smp_supported, init_startup_prepare,
+	 default_prepare_gif_clear, null_test,
+	 init_startup_finished, init_startup_check },
+	{ "svm_init_intercept_test", smp_supported, init_intercept_prepare,
+	 default_prepare_gif_clear, init_intercept_test,
+	 init_intercept_finished, init_intercept_check,.on_vcpu = 2 },
+	{ "host_rflags", default_supported, host_rflags_prepare,
+	 host_rflags_prepare_gif_clear, host_rflags_test,
+	 host_rflags_finished, host_rflags_check },
+	{ "vgif", vgif_supported, prepare_vgif_enabled,
+	 default_prepare_gif_clear, test_vgif, vgif_finished,
+	 vgif_check },
+	TEST(svm_cr4_osxsave_test),
+	TEST(svm_guest_state_test),
+	TEST(svm_vmrun_errata_test),
+	TEST(svm_vmload_vmsave),
+	TEST(svm_test_singlestep),
+	TEST(svm_nm_test),
+	TEST(svm_int3_test),
+	TEST(svm_into_test),
+	TEST(svm_lbrv_test0),
+	TEST(svm_lbrv_test1),
+	TEST(svm_lbrv_test2),
+	TEST(svm_lbrv_nested_test1),
+	TEST(svm_lbrv_nested_test2),
+	TEST(svm_intr_intercept_mix_if),
+	TEST(svm_intr_intercept_mix_gif),
+	TEST(svm_intr_intercept_mix_gif2),
+	TEST(svm_intr_intercept_mix_nmi),
+	TEST(svm_intr_intercept_mix_smi),
+	TEST(svm_tsc_scale_test),
+	TEST(pause_filter_test),
+	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
-- 
2.30.2

