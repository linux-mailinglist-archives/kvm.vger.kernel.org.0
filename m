Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181D855C972
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345123AbiF1Lm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 07:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344628AbiF1Lm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 07:42:26 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48D22FE75
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 04:42:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTORnKlEFxUfzYep4ri73/WT4Wh4A7Nz3WxPiAOVvLMPv1OtTeuSf2PX8T0rthcXfWZsNlgKxf5HVZd3gNi9PuMNv6ClI8ys013aLYNeZLlU9TfAwWJXE6SVrlp9EkwFgBH3XDjx6VceBOwfPTjjeSE23qZ+sAqNkwqFyzQVeVylVZFgr2WuPxXaLkcU335xMZsYW/DeuSp1Dots5UxvLVXscXNY4SCB53uMXLxeEuN7povrrnz4NjfbhQRrDeCPyG21c1MZAmHh2AsExwkMnkg5lT+2yoD1sEVUNsCOYcVHiQUO7U1joda+LBdibpjMslux/sTJrU3zUgJyR120fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6RivgrolPWp8JH691cvFixYrDSyRvlwl4kF9orQwEUY=;
 b=nbYTetI1DqWe3L9m6aFM95HlRMrWiER15nfSEvOKyrtyfulzizruAnXkCw1SXhZH5H5cWckp8i7l11YI3vRhHx041BU8G+sp5m8xjVNmwBH+S7AxhPez0RMBI7ehCXIW65KjL/Dbe07XNg6E+UmtgeajjXYPZ5lqz7dSXC/US063P/9eUSgjzEc5oRS83FBw4DbsMAUhhX59V5eXXRwVbvTG4Sh6BU1/UCaw8E37bWdttvNQp4rN9RAFxaHymH4FVoytNJ6cJUDvmjn6zwrRiXFsU9uFLN2qTmB+39uh0Sz5jzrK4U3kn/jeL4P88ArvMBbsThf4Xj3vTTBVlfK1ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RivgrolPWp8JH691cvFixYrDSyRvlwl4kF9orQwEUY=;
 b=J+tcLPcZQySWECjlP02I2QNwa1uQxXysmaMKj047XjVC+0Qsi8ylkJUR8+apUoN/BOVYE7IUZ9niZfAzgHhzjCXI08Wgb1TDqe31BdbnSheNx2AKYD7jDQKDd4GcPQw4+KMJn2b0TM3ehZxJAy0VS/WPNccBU9ukGhtHWXOSMqI=
Received: from BN9PR03CA0145.namprd03.prod.outlook.com (2603:10b6:408:fe::30)
 by DM4PR12MB5296.namprd12.prod.outlook.com (2603:10b6:5:39d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 11:42:21 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::c1) by BN9PR03CA0145.outlook.office365.com
 (2603:10b6:408:fe::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16 via Frontend
 Transport; Tue, 28 Jun 2022 11:42:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 11:42:20 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 28 Jun
 2022 06:42:18 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v5 8/8] x86: nSVM: Correct indentation for svm_tests.c part-2
Date:   Tue, 28 Jun 2022 11:38:53 +0000
Message-ID: <20220628113853.392569-9-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628113853.392569-1-manali.shukla@amd.com>
References: <20220628113853.392569-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3116611-d9d1-4b6e-caf1-08da58fb42cf
X-MS-TrafficTypeDiagnostic: DM4PR12MB5296:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q5mSU+X4dxPdkxJ0lYFbkx5fVORFQymf/8qIfq2ONTMZoQe19G/RVOjA8bOx5RqYd+TO9/xe8TpQxBksPpC5WnU+nepiYHSG/rFD8V/7htOf7oM1on1w8YYDub8nyb0EXUBZiJpPpKNA86Du3rT26EsJe3YTdZaChF2REhMBVxSaneURE6n7FgxOcXCPZcHfP6T7jQ3MSzF99xFQYhK8TRBfn/UN09D8g0VRC8j8mjsfkhpLYX3JtsQ9IU/wqGj99NpmZdKou+6/l+lbbF0WdoOMAjdAzJisaAtdMZoo3MLN16Ts9g6sYRiFlW3NV5tWV0IMuNK6xbDfuLWF/oTtDzxEt63/FYzXLYHV6rf2fRbbz4t9nlTK7AlW/D+DUDqib2wzP2bxDz8mrbxNlyVDeMRbmcARbIfUMsIwb/pCEk/5shWkfzu0Q04NiBfHS/0I68oQKlin+qQGSk/Gk8PcoJTRxAuegQZnLY22zw/EJNX9QRaIrQb0xfYanJwsyqjijfs8Sfe+8ablwtmXiQI0FqEZ/zFptMKpB4pD3NgTvTlHy3rmawDn66XDe1Cp4tRZen+JPoYKeGsm69CIFx3kXpZP2Ic+wYBzoOXyIbShcUpA1x5yCE2r5YlCbvYk1bGvjP8OuPddYaKa7K0doHDDFZyptNgQHuFpA+D2GGP31U3QCB+JjKa37tz5vAXUlbwgvyaVRApdX1NF54fk1QFEVxLGYLkg4HA/MIaDbVaOVetSRYexf7BHeeD4QnZFxxpl+KM0SDwfWdr55DwW95lXohzhovMmWW9YUylT0B1HCLo6YB8m4eZXRX+2FS0YaIF5FPQPAB7F1atioJzXn2A8+g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(396003)(346002)(36840700001)(46966006)(40470700004)(7696005)(186003)(26005)(81166007)(110136005)(30864003)(47076005)(2616005)(2906002)(44832011)(70586007)(16526019)(70206006)(5660300002)(8676002)(426003)(1076003)(41300700001)(6666004)(8936002)(316002)(36860700001)(478600001)(4326008)(83380400001)(40460700003)(82310400005)(82740400003)(36756003)(356005)(86362001)(40480700001)(336012)(36900700001)(579004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 11:42:20.6671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3116611-d9d1-4b6e-caf1-08da58fb42cf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5296
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixed indentation errors in svm_tests.c

No functional change intended.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm_tests.c | 765 ++++++++++++++++++++++++------------------------
 1 file changed, 381 insertions(+), 384 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index f9e3f36..f953000 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2043,18 +2043,18 @@ static void basic_guest_main(struct svm_test *test)
 #define SVM_TEST_REG_RESERVED_BITS(start, end, inc, str_name, reg, val,	\
 				   resv_mask)				\
 {									\
-        u64 tmp, mask;							\
-        int i;								\
+	u64 tmp, mask;							\
+	int i;								\
 									\
-        for (i = start; i <= end; i = i + inc) {			\
-                mask = 1ull << i;					\
-                if (!(mask & resv_mask))				\
-                        continue;					\
-                tmp = val | mask;					\
+	for (i = start; i <= end; i = i + inc) {			\
+		mask = 1ull << i;					\
+		if (!(mask & resv_mask))				\
+			continue;					\
+		tmp = val | mask;					\
 		reg = tmp;						\
-		report(svm_vmrun() == SVM_EXIT_ERR, "Test %s %d:%d: %lx",\
-		    str_name, end, start, tmp);				\
-        }								\
+		report(svm_vmrun() == SVM_EXIT_ERR, "Test %s %d:%d: %lx", \
+		       str_name, end, start, tmp);			\
+	}								\
 }
 
 #define SVM_TEST_CR_RESERVED_BITS(start, end, inc, cr, val, resv_mask,	\
@@ -2080,7 +2080,7 @@ static void basic_guest_main(struct svm_test *test)
 			vmcb->save.cr4 = tmp;				\
 		}							\
 		r = svm_vmrun();					\
-		report(r == exit_code, "Test CR%d %s%d:%d: %lx, wanted exit 0x%x, got 0x%x",\
+		report(r == exit_code, "Test CR%d %s%d:%d: %lx, wanted exit 0x%x, got 0x%x", \
 		       cr, test_name, end, start, tmp, exit_code, r);	\
 	}								\
 }
@@ -2105,9 +2105,9 @@ static void test_efer(void)
 	efer_saved = vmcb->save.efer;
 
 	SVM_TEST_REG_RESERVED_BITS(8, 9, 1, "EFER", vmcb->save.efer,
-	    efer_saved, SVM_EFER_RESERVED_MASK);
+				   efer_saved, SVM_EFER_RESERVED_MASK);
 	SVM_TEST_REG_RESERVED_BITS(16, 63, 4, "EFER", vmcb->save.efer,
-	    efer_saved, SVM_EFER_RESERVED_MASK);
+				   efer_saved, SVM_EFER_RESERVED_MASK);
 
 	/*
 	 * EFER.LME and CR0.PG are both set and CR4.PAE is zero.
@@ -2124,7 +2124,7 @@ static void test_efer(void)
 	cr4 = cr4_saved & ~X86_CR4_PAE;
 	vmcb->save.cr4 = cr4;
 	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
-	    "CR0.PG=1 (%lx) and CR4.PAE=0 (%lx)", efer, cr0, cr4);
+	       "CR0.PG=1 (%lx) and CR4.PAE=0 (%lx)", efer, cr0, cr4);
 
 	/*
 	 * EFER.LME and CR0.PG are both set and CR0.PE is zero.
@@ -2137,7 +2137,7 @@ static void test_efer(void)
 	cr0 &= ~X86_CR0_PE;
 	vmcb->save.cr0 = cr0;
 	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
-	    "CR0.PG=1 and CR0.PE=0 (%lx)", efer, cr0);
+	       "CR0.PG=1 and CR0.PE=0 (%lx)", efer, cr0);
 
 	/*
 	 * EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero.
@@ -2148,11 +2148,11 @@ static void test_efer(void)
 	cr0 |= X86_CR0_PE;
 	vmcb->save.cr0 = cr0;
 	cs_attrib = cs_attrib_saved | SVM_SELECTOR_L_MASK |
-	    SVM_SELECTOR_DB_MASK;
+		SVM_SELECTOR_DB_MASK;
 	vmcb->save.cs.attrib = cs_attrib;
 	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
-	    "CR0.PG=1 (%lx), CR4.PAE=1 (%lx), CS.L=1 and CS.D=1 (%x)",
-	    efer, cr0, cr4, cs_attrib);
+	       "CR0.PG=1 (%lx), CR4.PAE=1 (%lx), CS.L=1 and CS.D=1 (%x)",
+	       efer, cr0, cr4, cs_attrib);
 
 	vmcb->save.cr0 = cr0_saved;
 	vmcb->save.cr4 = cr4_saved;
@@ -2172,20 +2172,20 @@ static void test_cr0(void)
 	cr0 &= ~X86_CR0_NW;
 	vmcb->save.cr0 = cr0;
 	report (svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=1,NW=0: %lx",
-	    cr0);
+		cr0);
 	cr0 |= X86_CR0_NW;
 	vmcb->save.cr0 = cr0;
 	report (svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=1,NW=1: %lx",
-	    cr0);
+		cr0);
 	cr0 &= ~X86_CR0_NW;
 	cr0 &= ~X86_CR0_CD;
 	vmcb->save.cr0 = cr0;
 	report (svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=0,NW=0: %lx",
-	    cr0);
+		cr0);
 	cr0 |= X86_CR0_NW;
 	vmcb->save.cr0 = cr0;
 	report (svm_vmrun() == SVM_EXIT_ERR, "Test CR0 CD=0,NW=1: %lx",
-	    cr0);
+		cr0);
 	vmcb->save.cr0 = cr0_saved;
 
 	/*
@@ -2194,7 +2194,7 @@ static void test_cr0(void)
 	cr0 = cr0_saved;
 
 	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "CR0", vmcb->save.cr0, cr0_saved,
-	    SVM_CR0_RESERVED_MASK);
+				   SVM_CR0_RESERVED_MASK);
 	vmcb->save.cr0 = cr0_saved;
 }
 
@@ -2207,11 +2207,11 @@ static void test_cr3(void)
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
@@ -2227,11 +2227,11 @@ static void test_cr3(void)
 	if (this_cpu_has(X86_FEATURE_PCID)) {
 		vmcb->save.cr4 = cr4_saved | X86_CR4_PCIDE;
 		SVM_TEST_CR_RESERVED_BITS(0, 11, 1, 3, cr3_saved,
-		    SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_VMMCALL, "(PCIDE=1) ");
+					  SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_VMMCALL, "(PCIDE=1) ");
 
 		vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_RESERVED_MASK;
 		report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
-		    vmcb->save.cr3);
+		       vmcb->save.cr3);
 	}
 
 	vmcb->save.cr4 = cr4_saved & ~X86_CR4_PCIDE;
@@ -2243,7 +2243,7 @@ static void test_cr3(void)
 	pdpe[0] &= ~1ULL;
 
 	SVM_TEST_CR_RESERVED_BITS(0, 11, 1, 3, cr3_saved,
-	    SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_NPF, "(PCIDE=0) ");
+				  SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_NPF, "(PCIDE=0) ");
 
 	pdpe[0] |= 1ULL;
 	vmcb->save.cr3 = cr3_saved;
@@ -2254,7 +2254,7 @@ static void test_cr3(void)
 	pdpe[0] &= ~1ULL;
 	vmcb->save.cr4 = cr4_saved | X86_CR4_PAE;
 	SVM_TEST_CR_RESERVED_BITS(0, 2, 1, 3, cr3_saved,
-	    SVM_CR3_PAE_LEGACY_RESERVED_MASK, SVM_EXIT_NPF, "(PAE) ");
+				  SVM_CR3_PAE_LEGACY_RESERVED_MASK, SVM_EXIT_NPF, "(PAE) ");
 
 	pdpe[0] |= 1ULL;
 
@@ -2273,14 +2273,14 @@ static void test_cr4(void)
 	efer &= ~EFER_LME;
 	vmcb->save.efer = efer;
 	SVM_TEST_CR_RESERVED_BITS(12, 31, 1, 4, cr4_saved,
-	    SVM_CR4_LEGACY_RESERVED_MASK, SVM_EXIT_ERR, "");
+				  SVM_CR4_LEGACY_RESERVED_MASK, SVM_EXIT_ERR, "");
 
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
@@ -2294,12 +2294,12 @@ static void test_dr(void)
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
@@ -2307,14 +2307,14 @@ static void test_dr(void)
 /* TODO: verify if high 32-bits are sign- or zero-extended on bare metal */
 #define	TEST_BITMAP_ADDR(save_intercept, type, addr, exit_code,		\
 			 msg) {						\
-	vmcb->control.intercept = saved_intercept | 1ULL << type;	\
-	if (type == INTERCEPT_MSR_PROT)					\
-		vmcb->control.msrpm_base_pa = addr;			\
-	else								\
-		vmcb->control.iopm_base_pa = addr;			\
-	report(svm_vmrun() == exit_code,				\
-	    "Test %s address: %lx", msg, addr);                         \
-}
+		vmcb->control.intercept = saved_intercept | 1ULL << type; \
+		if (type == INTERCEPT_MSR_PROT)				\
+			vmcb->control.msrpm_base_pa = addr;		\
+		else							\
+			vmcb->control.iopm_base_pa = addr;		\
+		report(svm_vmrun() == exit_code,			\
+		       "Test %s address: %lx", msg, addr);		\
+	}
 
 /*
  * If the MSR or IOIO intercept table extends to a physical address that
@@ -2339,41 +2339,41 @@ static void test_msrpm_iopm_bitmap_addrs(void)
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
+			 addr_beyond_limit - PAGE_SIZE, SVM_EXIT_ERR,
+			 "MSRPM");
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
+			 addr_beyond_limit - 2 * PAGE_SIZE - 2, SVM_EXIT_VMMCALL,
+			 "IOPM");
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
-			addr_beyond_limit - 2 * PAGE_SIZE, SVM_EXIT_ERR,
-			"IOPM");
+			 addr_beyond_limit - 2 * PAGE_SIZE, SVM_EXIT_ERR,
+			 "IOPM");
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
-			addr_beyond_limit - PAGE_SIZE, SVM_EXIT_ERR,
-			"IOPM");
+			 addr_beyond_limit - PAGE_SIZE, SVM_EXIT_ERR,
+			 "IOPM");
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
@@ -2382,22 +2382,22 @@ static void test_msrpm_iopm_bitmap_addrs(void)
  * Unlike VMSAVE, VMRUN seems not to update the value of noncanonical
  * segment bases in the VMCB.  However, VMENTRY succeeds as documented.
  */
-#define TEST_CANONICAL_VMRUN(seg_base, msg)					\
-	saved_addr = seg_base;					\
+#define TEST_CANONICAL_VMRUN(seg_base, msg)				\
+	saved_addr = seg_base;						\
 	seg_base = (seg_base & ((1ul << addr_limit) - 1)) | noncanonical_mask; \
-	return_value = svm_vmrun(); \
-	report(return_value == SVM_EXIT_VMMCALL, \
-			"Successful VMRUN with noncanonical %s.base", msg); \
+	return_value = svm_vmrun();					\
+	report(return_value == SVM_EXIT_VMMCALL,			\
+	       "Successful VMRUN with noncanonical %s.base", msg);	\
 	seg_base = saved_addr;
 
 
-#define TEST_CANONICAL_VMLOAD(seg_base, msg)					\
-	saved_addr = seg_base;					\
+#define TEST_CANONICAL_VMLOAD(seg_base, msg)				\
+	saved_addr = seg_base;						\
 	seg_base = (seg_base & ((1ul << addr_limit) - 1)) | noncanonical_mask; \
-	asm volatile ("vmload %0" : : "a"(vmcb_phys) : "memory"); \
-	asm volatile ("vmsave %0" : : "a"(vmcb_phys) : "memory"); \
-	report(is_canonical(seg_base), \
-			"Test %s.base for canonical form: %lx", msg, seg_base); \
+	asm volatile ("vmload %0" : : "a"(vmcb_phys) : "memory");	\
+	asm volatile ("vmsave %0" : : "a"(vmcb_phys) : "memory");	\
+	report(is_canonical(seg_base),					\
+	       "Test %s.base for canonical form: %lx", msg, seg_base);	\
 	seg_base = saved_addr;
 
 static void test_canonicalization(void)
@@ -2477,7 +2477,7 @@ static void svm_test_singlestep(void)
 	vmcb->save.rflags |= X86_EFLAGS_TF;
 	report (__svm_vmrun((u64)guest_rflags_test_guest) == SVM_EXIT_VMMCALL &&
 		guest_rflags_test_trap_rip == (u64)&insn2,
-               "Test EFLAGS.TF on VMRUN: trap expected  after completion of first guest instruction");
+		"Test EFLAGS.TF on VMRUN: trap expected  after completion of first guest instruction");
 	/*
 	 * No trap expected
 	 */
@@ -2513,52 +2513,52 @@ static unsigned long volatile physical = 0;
 
 static void gp_isr(struct ex_regs *r)
 {
-    svm_errata_reproduced = true;
-    /* skip over the vmsave instruction*/
-    r->rip += 3;
+	svm_errata_reproduced = true;
+	/* skip over the vmsave instruction*/
+	r->rip += 3;
 }
 
 static void svm_vmrun_errata_test(void)
 {
-    unsigned long *last_page = NULL;
+	unsigned long *last_page = NULL;
 
-    handle_exception(GP_VECTOR, gp_isr);
+	handle_exception(GP_VECTOR, gp_isr);
 
-    while (!svm_errata_reproduced) {
+	while (!svm_errata_reproduced) {
 
-        unsigned long *page = alloc_pages(1);
+		unsigned long *page = alloc_pages(1);
 
-        if (!page) {
-            report_pass("All guest memory tested, no bug found");
-            break;
-        }
+		if (!page) {
+			report_pass("All guest memory tested, no bug found");
+			break;
+		}
 
-        physical = virt_to_phys(page);
+		physical = virt_to_phys(page);
 
-        asm volatile (
-            "mov %[_physical], %%rax\n\t"
-            "vmsave %%rax\n\t"
+		asm volatile (
+			      "mov %[_physical], %%rax\n\t"
+			      "vmsave %%rax\n\t"
 
-            : [_physical] "=m" (physical)
-            : /* no inputs*/
-            : "rax" /*clobbers*/
-        );
+			      : [_physical] "=m" (physical)
+			      : /* no inputs*/
+			      : "rax" /*clobbers*/
+			      );
 
-        if (svm_errata_reproduced) {
-            report_fail("Got #GP exception - svm errata reproduced at 0x%lx",
-                        physical);
-            break;
-        }
+		if (svm_errata_reproduced) {
+			report_fail("Got #GP exception - svm errata reproduced at 0x%lx",
+				    physical);
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
@@ -2583,7 +2583,7 @@ static void svm_vmload_vmsave(void)
 	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
 	svm_vmrun();
 	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
-	    "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
+	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
 
 	/*
 	 * Enabling intercept for VMLOAD and VMSAVE causes respective
@@ -2592,102 +2592,101 @@ static void svm_vmload_vmsave(void)
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
-
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
+	switch (get_test_stage(test))
+		{
+		case 0:
+			if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+				report_fail("VMEXIT not due to vmmcall.");
+				return true;
+			}
+			vmcb->control.int_ctl |= V_GIF_ENABLED_MASK;
+			vmcb->save.rip += 3;
+			inc_test_stage(test);
+			break;
+		case 1:
+			if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+				report_fail("VMEXIT not due to vmmcall.");
+				return true;
+			}
+			if (!(vmcb->control.int_ctl & V_GIF_MASK)) {
+				report_fail("Failed to set VGIF when executing STGI.");
+				vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
+				return true;
+			}
+			report_pass("STGI set VGIF bit.");
+			vmcb->save.rip += 3;
+			inc_test_stage(test);
+			break;
+		case 2:
+			if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+				report_fail("VMEXIT not due to vmmcall.");
+				return true;
+			}
+			if (vmcb->control.int_ctl & V_GIF_MASK) {
+				report_fail("Failed to clear VGIF when executing CLGI.");
+				vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
+				return true;
+			}
+			report_pass("CLGI cleared VGIF bit.");
+			vmcb->save.rip += 3;
+			inc_test_stage(test);
+			vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
+			break;
+		default:
+			return true;
+			break;
+		}
+
+	return get_test_stage(test) == 3;
 }
 
 static bool vgif_check(struct svm_test *test)
 {
-    return get_test_stage(test) == 3;
+	return get_test_stage(test) == 3;
 }
 
 
@@ -2696,66 +2695,66 @@ static int wait_counter;
 
 static void pause_filter_test_guest_main(struct svm_test *test)
 {
-    int i;
-    for (i = 0 ; i < pause_test_counter ; i++)
-        pause();
+	int i;
+	for (i = 0 ; i < pause_test_counter ; i++)
+		pause();
 
-    if (!wait_counter)
-        return;
+	if (!wait_counter)
+		return;
 
-    for (i = 0; i < wait_counter; i++)
-        ;
+	for (i = 0; i < wait_counter; i++)
+		;
 
-    for (i = 0 ; i < pause_test_counter ; i++)
-        pause();
+	for (i = 0 ; i < pause_test_counter ; i++)
+		pause();
 
 }
 
 static void pause_filter_run_test(int pause_iterations, int filter_value, int wait_iterations, int threshold)
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
+		report(vmcb->control.exit_code == SVM_EXIT_PAUSE, "expected PAUSE vmexit");
+	else
+		report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "no expected PAUSE vmexit");
 }
 
 static void pause_filter_test(void)
 {
-    if (!pause_filter_supported()) {
-            report_skip("PAUSE filter not supported in the guest");
-            return;
-    }
+	if (!pause_filter_supported()) {
+		report_skip("PAUSE filter not supported in the guest");
+		return;
+	}
 
-    vmcb->control.intercept |= (1 << INTERCEPT_PAUSE);
+	vmcb->control.intercept |= (1 << INTERCEPT_PAUSE);
 
-    // filter count more that pause count - no VMexit
-    pause_filter_run_test(10, 9, 0, 0);
+	// filter count more that pause count - no VMexit
+	pause_filter_run_test(10, 9, 0, 0);
 
-    // filter count smaller pause count - no VMexit
-    pause_filter_run_test(20, 21, 0, 0);
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
 
 
@@ -2763,81 +2762,81 @@ static int of_test_counter;
 
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
+		.offset = (uintptr_t)&&into,
+		.selector = KERNEL_CS32,
+	};
+	uintptr_t rsp;
 
-    asm volatile ("mov %%rsp, %0" : "=r"(rsp));
+	asm volatile ("mov %%rsp, %0" : "=r"(rsp));
 
-    if (fp.offset != (uintptr_t)&&into) {
-        printf("Codee address too high.\n");
-        return;
-    }
+	if (fp.offset != (uintptr_t)&&into) {
+		printf("Codee address too high.\n");
+		return;
+	}
 
-    if ((u32)rsp != rsp) {
-        printf("Stack address too high.\n");
-    }
+	if ((u32)rsp != rsp) {
+		printf("Stack address too high.\n");
+	}
 
-    asm goto("lcall *%0" : : "m" (fp) : "rax" : into);
-    return;
+	asm goto("lcall *%0" : : "m" (fp) : "rax" : into);
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
+		      "addl %eax, %eax;"
+		      "into;"
+		      "lret;"
+		      ".code64");
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
+	       "#OF is generated in L2 exception handler");
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
+	asm volatile("int3");
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
+	asm volatile("fnop");
 }
 
 /* This test checks that:
@@ -2854,24 +2853,23 @@ static void svm_nm_test_guest(struct svm_test *test)
 
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
-        "fnop with CR0.TS and CR0.EM unset no #NM exception");
+	vmcb->save.cr0 = vmcb->save.cr0 & ~(X86_CR0_TS | X86_CR0_EM);
+	report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 2,
+	       "fnop with CR0.TS and CR0.EM unset no #NM excpetion");
 }
 
-
 static bool check_lbr(u64 *from_excepted, u64 *to_expected)
 {
 	u64 from = rdmsr(MSR_IA32_LASTBRANCHFROMIP);
@@ -2879,13 +2877,13 @@ static bool check_lbr(u64 *from_excepted, u64 *to_expected)
 
 	if ((u64)from_excepted != from) {
 		report(false, "MSR_IA32_LASTBRANCHFROMIP, expected=0x%lx, actual=0x%lx",
-			(u64)from_excepted, from);
+		       (u64)from_excepted, from);
 		return false;
 	}
 
 	if ((u64)to_expected != to) {
 		report(false, "MSR_IA32_LASTBRANCHFROMIP, expected=0x%lx, actual=0x%lx",
-			(u64)from_excepted, from);
+		       (u64)from_excepted, from);
 		return false;
 	}
 
@@ -2902,15 +2900,15 @@ static bool check_dbgctl(u64 dbgctl, u64 dbgctl_expected)
 }
 
 
-#define DO_BRANCH(branch_name) \
-	asm volatile ( \
-		# branch_name "_from:" \
-		"jmp " # branch_name  "_to\n" \
-		"nop\n" \
-		"nop\n" \
-		# branch_name  "_to:" \
-		"nop\n" \
-	)
+#define DO_BRANCH(branch_name)				\
+	asm volatile (					\
+		      # branch_name "_from:"		\
+		      "jmp " # branch_name  "_to\n"	\
+		      "nop\n"				\
+		      "nop\n"				\
+		      # branch_name  "_to:"		\
+		      "nop\n"				\
+		       )
 
 
 extern u64 guest_branch0_from, guest_branch0_to;
@@ -3010,7 +3008,7 @@ static void svm_lbrv_test1(void)
 
 	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-		vmcb->control.exit_code);
+		       vmcb->control.exit_code);
 		return;
 	}
 
@@ -3034,7 +3032,7 @@ static void svm_lbrv_test2(void)
 
 	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-		vmcb->control.exit_code);
+		       vmcb->control.exit_code);
 		return;
 	}
 
@@ -3062,7 +3060,7 @@ static void svm_lbrv_nested_test1(void)
 
 	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-		vmcb->control.exit_code);
+		       vmcb->control.exit_code);
 		return;
 	}
 
@@ -3074,6 +3072,7 @@ static void svm_lbrv_nested_test1(void)
 	check_dbgctl(dbgctl, DEBUGCTLMSR_LBR);
 	check_lbr(&host_branch3_from, &host_branch3_to);
 }
+
 static void svm_lbrv_nested_test2(void)
 {
 	if (!lbrv_supported()) {
@@ -3097,7 +3096,7 @@ static void svm_lbrv_nested_test2(void)
 
 	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-		vmcb->control.exit_code);
+		       vmcb->control.exit_code);
 		return;
 	}
 
@@ -3206,8 +3205,6 @@ static void svm_intr_intercept_mix_gif(void)
 	svm_intr_intercept_mix_run_guest(&dummy_isr_recevied, SVM_EXIT_INTR);
 }
 
-
-
 // subtest: test that a clever guest can trigger an interrupt by setting GIF
 // if GIF is not intercepted and interrupt comes after guest
 // started running
@@ -3296,121 +3293,121 @@ static void svm_intr_intercept_mix_smi(void)
 
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
+	  default_prepare_gif_clear, null_test,
+	  default_finished, null_check },
+	{ "vmrun", default_supported, default_prepare,
+	  default_prepare_gif_clear, test_vmrun,
+	  default_finished, check_vmrun },
+	{ "ioio", default_supported, prepare_ioio,
+	  default_prepare_gif_clear, test_ioio,
+	  ioio_finished, check_ioio },
+	{ "vmrun intercept check", default_supported, prepare_no_vmrun_int,
+	  default_prepare_gif_clear, null_test, default_finished,
+	  check_no_vmrun_int },
+	{ "rsm", default_supported,
+	  prepare_rsm_intercept, default_prepare_gif_clear,
+	  test_rsm_intercept, finished_rsm_intercept, check_rsm_intercept },
+	{ "cr3 read intercept", default_supported,
+	  prepare_cr3_intercept, default_prepare_gif_clear,
+	  test_cr3_intercept, default_finished, check_cr3_intercept },
+	{ "cr3 read nointercept", default_supported, default_prepare,
+	  default_prepare_gif_clear, test_cr3_intercept, default_finished,
+	  check_cr3_nointercept },
+	{ "cr3 read intercept emulate", smp_supported,
+	  prepare_cr3_intercept_bypass, default_prepare_gif_clear,
+	  test_cr3_intercept_bypass, default_finished, check_cr3_intercept },
+	{ "dr intercept check", default_supported, prepare_dr_intercept,
+	  default_prepare_gif_clear, test_dr_intercept, dr_intercept_finished,
+	  check_dr_intercept },
+	{ "next_rip", next_rip_supported, prepare_next_rip,
+	  default_prepare_gif_clear, test_next_rip,
+	  default_finished, check_next_rip },
+	{ "msr intercept check", default_supported, prepare_msr_intercept,
+	  default_prepare_gif_clear, test_msr_intercept,
+	  msr_intercept_finished, check_msr_intercept },
+	{ "mode_switch", default_supported, prepare_mode_switch,
+	  default_prepare_gif_clear, test_mode_switch,
+	  mode_switch_finished, check_mode_switch },
+	{ "asid_zero", default_supported, prepare_asid_zero,
+	  default_prepare_gif_clear, test_asid_zero,
+	  default_finished, check_asid_zero },
+	{ "sel_cr0_bug", default_supported, sel_cr0_bug_prepare,
+	  default_prepare_gif_clear, sel_cr0_bug_test,
+	  sel_cr0_bug_finished, sel_cr0_bug_check },
+	{ "tsc_adjust", tsc_adjust_supported, tsc_adjust_prepare,
+	  default_prepare_gif_clear, tsc_adjust_test,
+	  default_finished, tsc_adjust_check },
+	{ "latency_run_exit", default_supported, latency_prepare,
+	  default_prepare_gif_clear, latency_test,
+	  latency_finished, latency_check },
+	{ "latency_run_exit_clean", default_supported, latency_prepare,
+	  default_prepare_gif_clear, latency_test,
+	  latency_finished_clean, latency_check },
+	{ "latency_svm_insn", default_supported, lat_svm_insn_prepare,
+	  default_prepare_gif_clear, null_test,
+	  lat_svm_insn_finished, lat_svm_insn_check },
+	{ "exc_inject", default_supported, exc_inject_prepare,
+	  default_prepare_gif_clear, exc_inject_test,
+	  exc_inject_finished, exc_inject_check },
+	{ "pending_event", default_supported, pending_event_prepare,
+	  default_prepare_gif_clear,
+	  pending_event_test, pending_event_finished, pending_event_check },
+	{ "pending_event_cli", default_supported, pending_event_cli_prepare,
+	  pending_event_cli_prepare_gif_clear,
+	  pending_event_cli_test, pending_event_cli_finished,
+	  pending_event_cli_check },
+	{ "interrupt", default_supported, interrupt_prepare,
+	  default_prepare_gif_clear, interrupt_test,
+	  interrupt_finished, interrupt_check },
+	{ "nmi", default_supported, nmi_prepare,
+	  default_prepare_gif_clear, nmi_test,
+	  nmi_finished, nmi_check },
+	{ "nmi_hlt", smp_supported, nmi_prepare,
+	  default_prepare_gif_clear, nmi_hlt_test,
+	  nmi_hlt_finished, nmi_hlt_check },
+	{ "virq_inject", default_supported, virq_inject_prepare,
+	  default_prepare_gif_clear, virq_inject_test,
+	  virq_inject_finished, virq_inject_check },
+	{ "reg_corruption", default_supported, reg_corruption_prepare,
+	  default_prepare_gif_clear, reg_corruption_test,
+	  reg_corruption_finished, reg_corruption_check },
+	{ "svm_init_startup_test", smp_supported, init_startup_prepare,
+	  default_prepare_gif_clear, null_test,
+	  init_startup_finished, init_startup_check },
+	{ "svm_init_intercept_test", smp_supported, init_intercept_prepare,
+	  default_prepare_gif_clear, init_intercept_test,
+	  init_intercept_finished, init_intercept_check, .on_vcpu = 2 },
+	{ "host_rflags", default_supported, host_rflags_prepare,
+	  host_rflags_prepare_gif_clear, host_rflags_test,
+	  host_rflags_finished, host_rflags_check },
+	{ "vgif", vgif_supported, prepare_vgif_enabled,
+	  default_prepare_gif_clear, test_vgif, vgif_finished,
+	  vgif_check },
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

