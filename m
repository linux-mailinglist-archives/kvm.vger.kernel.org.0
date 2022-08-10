Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512B258E743
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 08:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiHJGUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 02:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiHJGUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 02:20:18 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE3EC31
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 23:20:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ElFucVa94K067FJWSeFc6H9LjkzKXsUuLnC5ZiwbcJ2oGG77P643bZB1kT02vczZTtxNckETNP0ZhMTocHXqeCi1PaPePuqXgnE9uUF/Mh97ErWVGRxsvpDd+7EGHAkloUw2bnuACG0C3cogT5vhryfZ4IoASaHUrIq4vP2vYboYoz5cp0fEcr0zQQAyP54mCaSLmeDOj/XFIksHOec6D93wy3FCPyXkOdPSo6g5P/VvvW/PywTGrpkLmMawJT6uXuoPVyYPwwv2+GpGKHcTuFWsz9ax6q4uq3tIN4sQSzv5+RYMrQXboUlopfmBvqoUGCpAz1V9JpJtof/JuGo4rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cFXThjCxJ7hZn7iIumEjqnI98K1cYRV2RX4moGpHqXQ=;
 b=aFP63engrYFVxwaG8npTSRrKAxPFkmzttUEArpJDth8c5RH63TqyFisTrmbstQxU2IhB5YvBTY4CWt0VzobH/bofVl7ZL0Ktkoqbw2URGvoZtgp6eNr0w29mzdV42iKNAlupT5/syWSoAGKOsJCzaSbV0BvADja+gomS0d0t4K7Z6J2x207D0TrQtS6lHsKSb5FjOcSkFNDT4fQGkoaFQ8esyHBLmdJKX1nJkBIGOgTNP4xGjafBp1MMutJ/hUDMXAdDGLUHeZqIGfMwoxDSXy1niDl3jPll8SZIb9o5rrK8EQ0pT1nSoW+UYCULNc1giZH/Cz6fRG91vmBm3zk/Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFXThjCxJ7hZn7iIumEjqnI98K1cYRV2RX4moGpHqXQ=;
 b=FKv71aQ2urD2qOderlrsKpYfggSy4WiFG4FGwjhK3qgf4VJp4TQJonogMkC1wodl8ZavBBIY+vFTBlUHIf5REhOxzJt3yKj8cEzQLXCVw0sCCjvnSdfD4A+5BlYBvDf9H3uRWYYMeO+YsMwnAfg95akmvovnfEGUaZ2TS95pJ4M=
Received: from BN8PR15CA0066.namprd15.prod.outlook.com (2603:10b6:408:80::43)
 by DM6PR12MB5567.namprd12.prod.outlook.com (2603:10b6:5:1ba::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 10 Aug
 2022 06:20:13 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::2b) by BN8PR15CA0066.outlook.office365.com
 (2603:10b6:408:80::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14 via Frontend
 Transport; Wed, 10 Aug 2022 06:20:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 06:20:12 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 10 Aug
 2022 01:19:31 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
        <santosh.shukla@amd.com>
Subject: [kvm-unit-tests PATCHv2] x86: nSVM: Add support for VNMI test
Date:   Wed, 10 Aug 2022 11:49:24 +0530
Message-ID: <20220810061924.1418-1-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbca61ae-7406-48a4-e257-08da7a986260
X-MS-TrafficTypeDiagnostic: DM6PR12MB5567:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C4//V4tPoWxLY/3nEjVMDTWzAsIY7iugIXgH+cqO0Nh0WTP+F3vibT8Rdnjq+IghneS8xQ52l5C13w80BvigT68MoGrRGpiINT8O8tgqZVgffM13PBPuJIJQGGHtnD3pZXNwk6LkXjLdcEJGumSZamriGM/b9d731/zN1DGiWWWPMfiI//JvIH3KDnw3o3xfsw6eByh97zhvsD6VcwDbJ8mc/JlLnnEq8vl8FRhW2UjW89X67ZDNyAaOM+qS09XomVCUZ5BAc3k4f3XqHUR4I1ShFF1hCO/emxt7cWJ7NdjYueMr3CtMrHWuMnPL98e77zPLoMc8N1ZvfmKYBUJtjTmKMdNXPPxhiCtr1N1kDCl2iPS/SOabjqb9v00BptQ94P3OzM4/PmkT70jRCM/zyywKMTz+G0Id3tKubCQ1zjUxjlVHADVpvMIGhTClMvUEe4IusMcajqNta2QiwnDuXOTFj8VECug1QKcO6US5QLtKjja2SAV9fJZpnnKeNtpY6H7HrdGbAnEvD9XdpqUeKHof3sH8CO9xMaMEY+PJpZOLoQF5/qMDUxN6yPGRG7WjFjuKKn78jW0eXOKgGcWi8zAFp7tegN0uZeu3UTrFzgql+VxLcqlo8lA4s0q/AhrF1MWTWHnxP33y+QfFrRrAbkMIHFIS0TIPybSoLUbEwCFTMTfL4dEpCBOrBMMXr/BMqzmVFDBc9GoafcesfnCi4d3LJRKG3gE628ItihnVPPH/hF0IXPMzZc3XM1K00V4fWNcYJGcZYE/ekjs6aH3nBvW5gubD3P1CtLKmDU3SL2eVQugUhEHBLVE+mFxjS3NHcgcRPd195GTuetgmkwCj+62AW6tvwBR8L0PB+GfCdVQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(396003)(376002)(46966006)(40470700004)(36840700001)(6666004)(2906002)(316002)(26005)(6916009)(426003)(2616005)(83380400001)(82310400005)(1076003)(86362001)(40480700001)(54906003)(966005)(40460700003)(7696005)(336012)(186003)(36756003)(44832011)(36860700001)(8936002)(70206006)(41300700001)(70586007)(81166007)(16526019)(5660300002)(478600001)(47076005)(356005)(4326008)(82740400003)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 06:20:12.9855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbca61ae-7406-48a4-e257-08da7a986260
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5567
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a VNMI test case to test Virtual NMI in a nested environment,
The test covers the Virtual NMI (VNMI) delivery.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
v2:
- Added test to test NMI_INTERCEPT unset case.
- Rebased on tip.

v1:
- https://www.spinics.net/lists/kvm/msg279165.html

 lib/x86/processor.h |  2 +-
 x86/svm.c           |  5 +++
 x86/svm.h           |  8 ++++
 x86/svm_tests.c     | 90 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 0324220630c6..e514abd2e6a3 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -265,7 +265,7 @@ static inline bool is_intel(void)
 #define X86_FEATURE_PAUSEFILTER		(CPUID(0x8000000A, 0, EDX, 10))
 #define X86_FEATURE_PFTHRESHOLD		(CPUID(0x8000000A, 0, EDX, 12))
 #define	X86_FEATURE_VGIF		(CPUID(0x8000000A, 0, EDX, 16))
-
+#define X86_FEATURE_V_NMI               (CPUID(0x8000000A, 0, EDX, 25))
 
 static inline bool this_cpu_has(u64 feature)
 {
diff --git a/x86/svm.c b/x86/svm.c
index ba435b4ac3af..022a0fde4336 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -99,6 +99,11 @@ bool npt_supported(void)
 	return this_cpu_has(X86_FEATURE_NPT);
 }
 
+bool vnmi_supported(void)
+{
+       return this_cpu_has(X86_FEATURE_V_NMI);
+}
+
 int get_test_stage(struct svm_test *test)
 {
 	barrier();
diff --git a/x86/svm.h b/x86/svm.h
index 766ff7e36449..91a0dee2c864 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -131,6 +131,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define V_INTR_MASKING_SHIFT 24
 #define V_INTR_MASKING_MASK (1 << V_INTR_MASKING_SHIFT)
 
+#define V_NMI_PENDING_SHIFT 11
+#define V_NMI_PENDING (1 << V_NMI_PENDING_SHIFT)
+#define V_NMI_MASK_SHIFT 12
+#define V_NMI_MASK (1 << V_NMI_MASK_SHIFT)
+#define V_NMI_ENABLE_SHIFT 26
+#define V_NMI_ENABLE (1 << V_NMI_ENABLE_SHIFT)
+
 #define SVM_INTERRUPT_SHADOW_MASK 1
 
 #define SVM_IOIO_STR_SHIFT 2
@@ -419,6 +426,7 @@ void default_prepare(struct svm_test *test);
 void default_prepare_gif_clear(struct svm_test *test);
 bool default_finished(struct svm_test *test);
 bool npt_supported(void);
+bool vnmi_supported(void);
 int get_test_stage(struct svm_test *test);
 void set_test_stage(struct svm_test *test, int s);
 void inc_test_stage(struct svm_test *test);
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index e2ec9541fd29..f83a2b56ce52 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1445,6 +1445,93 @@ static bool nmi_hlt_check(struct svm_test *test)
 	return get_test_stage(test) == 3;
 }
 
+static volatile bool vnmi_fired;
+static void vnmi_handler(isr_regs_t *regs)
+{
+    vnmi_fired = true;
+}
+
+static void vnmi_prepare(struct svm_test *test)
+{
+    default_prepare(test);
+    vnmi_fired = false;
+    vmcb->control.int_ctl = V_NMI_ENABLE;
+    vmcb->control.int_vector = NMI_VECTOR;
+    handle_irq(NMI_VECTOR, vnmi_handler);
+    set_test_stage(test, 0);
+}
+
+static void vnmi_test(struct svm_test *test)
+{
+    if (vnmi_fired) {
+        report(!vnmi_fired, "vNMI dispatched even before injection");
+        set_test_stage(test, -1);
+    }
+
+    vmmcall();
+
+    if (!vnmi_fired) {
+        report(vnmi_fired, "pending vNMI not dispatched");
+        set_test_stage(test, -1);
+    }
+    report(vnmi_fired, "vNMI delivered to guest");
+
+    vmmcall();
+}
+
+static bool vnmi_finished(struct svm_test *test)
+{
+    switch (get_test_stage(test)) {
+    case 0:
+        if (vmcb->control.exit_code != SVM_EXIT_ERR) {
+            report_fail("VMEXIT not due to error. Exit reason 0x%x",
+                        vmcb->control.exit_code);
+            return true;
+        }
+        report(!vnmi_fired, "vNMI enabled but NMI_INTERCEPT unset!");
+        vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
+        vmcb->save.rip += 3;
+        break;
+
+    case 1:
+        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+            report_fail("VMEXIT not due to error. Exit reason 0x%x",
+                        vmcb->control.exit_code);
+            return true;
+        }
+        report(!vnmi_fired, "vNMI with vector 2 not injected");
+        vmcb->control.int_ctl |= V_NMI_PENDING;
+        vmcb->save.rip += 3;
+        break;
+
+    case 2:
+        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+                        vmcb->control.exit_code);
+            return true;
+        }
+        if (vmcb->control.int_ctl & V_NMI_MASK) {
+            report_fail("V_NMI_MASK not cleared on VMEXIT");
+            return true;
+        }
+        report_pass("VNMI serviced");
+        vmcb->save.rip += 3;
+        break;
+
+    default:
+        return true;
+    }
+
+    inc_test_stage(test);
+
+    return get_test_stage(test) == 3;
+}
+
+static bool vnmi_check(struct svm_test *test)
+{
+    return get_test_stage(test) == 3;
+}
+
 static volatile int count_exc = 0;
 
 static void my_isr(struct ex_regs *r)
@@ -3363,6 +3450,9 @@ struct svm_test svm_tests[] = {
 	{ "nmi_hlt", smp_supported, nmi_prepare,
 	  default_prepare_gif_clear, nmi_hlt_test,
 	  nmi_hlt_finished, nmi_hlt_check },
+        { "vnmi", vnmi_supported, vnmi_prepare,
+          default_prepare_gif_clear, vnmi_test,
+          vnmi_finished, vnmi_check },
 	{ "virq_inject", default_supported, virq_inject_prepare,
 	  default_prepare_gif_clear, virq_inject_test,
 	  virq_inject_finished, virq_inject_check },
-- 
2.25.1

