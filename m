Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9080512C66
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 09:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240547AbiD1HOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 03:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244888AbiD1HNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 03:13:54 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0657DAA9
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 00:10:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVwNcLxBjZmlV7W+g9nH76rceGYwpMGHlUIhAam9M2expqpZk9NgZZkbJ7G5nDRFysp6jxtQzAGJ/LDZSuiRkvA0cTi70ZU9R/QnHAbB5iQemTmSnmuxlJnnKekGTlMPTM7TbIJrtVFGbpEl2aGyJ376YWFjNaUhyNn0OeiHnCXcxdXOmhmP38aPweeifTwLEKzI1iuJaQWAfqvWIJXLlBWpFDyCDzXzqoqaDH8EWP4JtxwD26iLRWqTbkP/tQU6mGZnAz9yLf6TwGzIq4DRSBP31AOsT9w2SqmfqTgvhMzMRsVhDbYMC2JtP15URYP+2dlmmPy25eaTR7mMqQyw1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AwM8v+pzcMr43P6HV/X0kzpCt7h/5YUxliyQ2iltfbE=;
 b=KQs+NDf0VekZlSCrxjVrhOolMJJ6zLwEVqcE1tG65fT1Tt+AGBsGtM73svc4QWRc3USI1lTSYGcVWB9o7bSSq66v2zz7aNNm8ImE33+6xrKzBIhhLBFD8COz2pOSfxqudtmvvR+I3UagD22aSbMS8V9FJF++Pbt/3SIWSrmw5W80SXDPboINFjxOXemTst+OWsjTfukJJsMKZ6pdRrtyIvNVBxWshCBvwkv8XhI9LxCXB/TfWtascx0arhJxSmBS4VNj7XUrED4RV/mcZf7hA//rJxvSKs0ex2FkBUAnfBjQ7wAj9qYxxY0pGsYO65aoOZwEXGjXA8Urvi9DK9zs8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwM8v+pzcMr43P6HV/X0kzpCt7h/5YUxliyQ2iltfbE=;
 b=aWX/wi6D8UzjcBnydXVgaRmDj7RpRf86PqE2Dc8b3FsNZxHs1NMBZEja6+9AxbjsgVkV/3nDSIs62ct2i9tpVm04CB4vqFy45oVzwR/Ft6Lt5vAJ8G7yFjdwEy8/Me8uOloVHOF/QNBkD657qRg23d4D7FBWViUT+eWLNTFeiMs=
Received: from DS7PR05CA0085.namprd05.prod.outlook.com (2603:10b6:8:56::15) by
 BY5PR12MB4903.namprd12.prod.outlook.com (2603:10b6:a03:1d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 07:10:33 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:56:cafe::1e) by DS7PR05CA0085.outlook.office365.com
 (2603:10b6:8:56::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.6 via Frontend
 Transport; Thu, 28 Apr 2022 07:10:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5206.12 via Frontend Transport; Thu, 28 Apr 2022 07:10:32 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 28 Apr
 2022 02:10:30 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v4 2/8] x86: nSVM: Move all nNPT test cases from svm_tests.c to a separate file.
Date:   Thu, 28 Apr 2022 07:08:45 +0000
Message-ID: <20220428070851.21985-3-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220428070851.21985-1-manali.shukla@amd.com>
References: <20220428070851.21985-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1efb0b0-fe78-41d8-acb6-08da28e62f69
X-MS-TrafficTypeDiagnostic: BY5PR12MB4903:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB49032E9B661E60C38C342574FDFD9@BY5PR12MB4903.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FrEchAWtT79y+Or9hqx4pAhZg3/FJ4QwRVxw4IVf/M3HMTeJy2RT1UhOqqQ96CBy6TL4HWxXCFlKKhMF6sUjNecsX7qWBY2PU737o5AuhRKQLm/nr2FiP2VgNVPBJsGuHePwTfezdCgVAKhDHh7gbbiQoS7t3T41AUzUYkxOuUbi8IOVVN6R5GUzXjNSFQgR3Bt3Nw7kppE4MktXYbky4fh6Uu4L1A8/7zSjWEolOOtzMGJIfYBaGBk2uQqdG982p4i3Rb7VJJy+dcE4LpJV4ZYiQ0h5eYlLFbtRxDnTisWLpkWCZ8ik7OhkUnaeUdshHcUa/CczbJaNVm2m9GO8iA3UwOC7r64PSos4+CDioD3WTS4RPF892fBwxsnzHR4DTqLR/LgbVC/GFKqxEnHU5ffYpUJOaHndn6uUNXoC6sptzY4uYA7MNHs+D8Vr9Q2VzWOFnSwrLsUQaiBCEJY4RC1/6NmgfqUyThPlHsySUKaqYae5hni38chB6ONIIsUtyvn4/xBrldJXZPCzqGJkSevopt5Q4bunUc+H8/IpNKsCEvyk4Axa6P9cHKPAdtfhknkudQpxQ+1bk22MYKPNHoOuGQDlGi9Q4zcZYdbo+Gyivm2JB6amJxtuCZHzwoZmaj1eTiAl/bCWxA8TcWsP+VvPIR2HqQ1JqczF4f/9usO1MaYbIDtRWoBC7dfeE4JKUTkq2RoRlZ0uIxlIDWYJYg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(26005)(70206006)(70586007)(316002)(110136005)(40460700003)(4326008)(83380400001)(36860700001)(2616005)(1076003)(336012)(16526019)(81166007)(426003)(186003)(356005)(6666004)(7696005)(508600001)(86362001)(47076005)(2906002)(5660300002)(8936002)(82310400005)(44832011)(30864003)(36756003)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 07:10:32.8296
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1efb0b0-fe78-41d8-acb6-08da28e62f69
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4903
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nNPT test cases are moved to a separate file svm_npt.c
so that they can be run independently with PTE_USER_MASK disabled.

Rest of the test cases can be run with PTE_USER_MASK enabled.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/Makefile.common |   2 +
 x86/Makefile.x86_64 |   2 +
 x86/svm.c           |   8 -
 x86/svm_npt.c       | 390 ++++++++++++++++++++++++++++++++++++++++++++
 x86/svm_tests.c     | 371 +----------------------------------------
 x86/unittests.cfg   |   6 +
 6 files changed, 409 insertions(+), 370 deletions(-)
 create mode 100644 x86/svm_npt.c

diff --git a/x86/Makefile.common b/x86/Makefile.common
index b903988..5590afe 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -107,6 +107,8 @@ $(TEST_DIR)/access_test.$(bin): $(TEST_DIR)/access.o
 
 $(TEST_DIR)/vmx.$(bin): $(TEST_DIR)/access.o
 
+$(TEST_DIR)/svm_npt.$(bin): $(TEST_DIR)/svm.o
+
 $(TEST_DIR)/kvmclock_test.$(bin): $(TEST_DIR)/kvmclock.o
 
 $(TEST_DIR)/hyperv_synic.$(bin): $(TEST_DIR)/hyperv.o
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index f18c1e2..dbe5967 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -42,6 +42,7 @@ endif
 ifneq ($(CONFIG_EFI),y)
 tests += $(TEST_DIR)/access_test.$(exe)
 tests += $(TEST_DIR)/svm.$(exe)
+tests += $(TEST_DIR)/svm_npt.$(exe)
 tests += $(TEST_DIR)/vmx.$(exe)
 endif
 
@@ -55,3 +56,4 @@ $(TEST_DIR)/hyperv_clock.$(bin): $(TEST_DIR)/hyperv_clock.o
 
 $(TEST_DIR)/vmx.$(bin): $(TEST_DIR)/vmx_tests.o
 $(TEST_DIR)/svm.$(bin): $(TEST_DIR)/svm_tests.o
+$(TEST_DIR)/svm_npt.$(bin): $(TEST_DIR)/svm_npt.o
diff --git a/x86/svm.c b/x86/svm.c
index 299383c..ec825c7 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -440,11 +440,3 @@ int run_svm_tests(int ac, char **av)
 
 	return report_summary();
 }
-
-int main(int ac, char **av)
-{
-    pteval_t opt_mask = 0;
-
-    __setup_vm(&opt_mask);
-    return run_svm_tests(ac, av);
-}
diff --git a/x86/svm_npt.c b/x86/svm_npt.c
new file mode 100644
index 0000000..53e8a90
--- /dev/null
+++ b/x86/svm_npt.c
@@ -0,0 +1,390 @@
+#include "svm.h"
+#include "vm.h"
+#include "alloc_page.h"
+#include "vmalloc.h"
+
+static void *scratch_page;
+
+static void null_test(struct svm_test *test)
+{
+}
+
+static void npt_np_prepare(struct svm_test *test)
+{
+	u64 *pte;
+
+	scratch_page = alloc_page();
+	pte = npt_get_pte((u64) scratch_page);
+
+	*pte &= ~1ULL;
+}
+
+static void npt_np_test(struct svm_test *test)
+{
+	(void)*(volatile u64 *)scratch_page;
+}
+
+static bool npt_np_check(struct svm_test *test)
+{
+	u64 *pte = npt_get_pte((u64) scratch_page);
+
+	*pte |= 1ULL;
+
+	return (vmcb->control.exit_code == SVM_EXIT_NPF)
+	    && (vmcb->control.exit_info_1 == 0x100000004ULL);
+}
+
+static void npt_nx_prepare(struct svm_test *test)
+{
+	u64 *pte;
+
+	test->scratch = rdmsr(MSR_EFER);
+	wrmsr(MSR_EFER, test->scratch | EFER_NX);
+
+	/* Clear the guest's EFER.NX, it should not affect NPT behavior. */
+	vmcb->save.efer &= ~EFER_NX;
+
+	pte = npt_get_pte((u64) null_test);
+
+	*pte |= PT64_NX_MASK;
+}
+
+static bool npt_nx_check(struct svm_test *test)
+{
+	u64 *pte = npt_get_pte((u64) null_test);
+
+	wrmsr(MSR_EFER, test->scratch);
+
+	*pte &= ~PT64_NX_MASK;
+
+	return (vmcb->control.exit_code == SVM_EXIT_NPF)
+	    && (vmcb->control.exit_info_1 == 0x100000015ULL);
+}
+
+static void npt_us_prepare(struct svm_test *test)
+{
+	u64 *pte;
+
+	scratch_page = alloc_page();
+	pte = npt_get_pte((u64) scratch_page);
+
+	*pte &= ~(1ULL << 2);
+}
+
+static void npt_us_test(struct svm_test *test)
+{
+	(void)*(volatile u64 *)scratch_page;
+}
+
+static bool npt_us_check(struct svm_test *test)
+{
+	u64 *pte = npt_get_pte((u64) scratch_page);
+
+	*pte |= (1ULL << 2);
+
+	return (vmcb->control.exit_code == SVM_EXIT_NPF)
+	    && (vmcb->control.exit_info_1 == 0x100000005ULL);
+}
+
+static void npt_rw_prepare(struct svm_test *test)
+{
+
+	u64 *pte;
+
+	pte = npt_get_pte(0x80000);
+
+	*pte &= ~(1ULL << 1);
+}
+
+static void npt_rw_test(struct svm_test *test)
+{
+	u64 *data = (void *)(0x80000);
+
+	*data = 0;
+}
+
+static bool npt_rw_check(struct svm_test *test)
+{
+	u64 *pte = npt_get_pte(0x80000);
+
+	*pte |= (1ULL << 1);
+
+	return (vmcb->control.exit_code == SVM_EXIT_NPF)
+	    && (vmcb->control.exit_info_1 == 0x100000007ULL);
+}
+
+static void npt_rw_pfwalk_prepare(struct svm_test *test)
+{
+
+	u64 *pte;
+
+	pte = npt_get_pte(read_cr3());
+
+	*pte &= ~(1ULL << 1);
+}
+
+static bool npt_rw_pfwalk_check(struct svm_test *test)
+{
+	u64 *pte = npt_get_pte(read_cr3());
+
+	*pte |= (1ULL << 1);
+
+	return (vmcb->control.exit_code == SVM_EXIT_NPF)
+	    && (vmcb->control.exit_info_1 == 0x200000007ULL)
+	    && (vmcb->control.exit_info_2 == read_cr3());
+}
+
+static void npt_l1mmio_prepare(struct svm_test *test)
+{
+}
+
+u32 nested_apic_version1;
+u32 nested_apic_version2;
+
+static void npt_l1mmio_test(struct svm_test *test)
+{
+	volatile u32 *data = (volatile void *)(0xfee00030UL);
+
+	nested_apic_version1 = *data;
+	nested_apic_version2 = *data;
+}
+
+static bool npt_l1mmio_check(struct svm_test *test)
+{
+	volatile u32 *data = (volatile void *)(0xfee00030);
+	u32 lvr = *data;
+
+	return nested_apic_version1 == lvr && nested_apic_version2 == lvr;
+}
+
+static void npt_rw_l1mmio_prepare(struct svm_test *test)
+{
+
+	u64 *pte;
+
+	pte = npt_get_pte(0xfee00080);
+
+	*pte &= ~(1ULL << 1);
+}
+
+static void npt_rw_l1mmio_test(struct svm_test *test)
+{
+	volatile u32 *data = (volatile void *)(0xfee00080);
+
+	*data = *data;
+}
+
+static bool npt_rw_l1mmio_check(struct svm_test *test)
+{
+	u64 *pte = npt_get_pte(0xfee00080);
+
+	*pte |= (1ULL << 1);
+
+	return (vmcb->control.exit_code == SVM_EXIT_NPF)
+	    && (vmcb->control.exit_info_1 == 0x100000007ULL);
+}
+
+static void basic_guest_main(struct svm_test *test)
+{
+}
+
+static void __svm_npt_rsvd_bits_test(u64 * pxe, u64 rsvd_bits, u64 efer,
+				     ulong cr4, u64 guest_efer, ulong guest_cr4)
+{
+	u64 pxe_orig = *pxe;
+	int exit_reason;
+	u64 pfec;
+
+	wrmsr(MSR_EFER, efer);
+	write_cr4(cr4);
+
+	vmcb->save.efer = guest_efer;
+	vmcb->save.cr4 = guest_cr4;
+
+	*pxe |= rsvd_bits;
+
+	exit_reason = svm_vmrun();
+
+	report(exit_reason == SVM_EXIT_NPF,
+	       "Wanted #NPF on rsvd bits = 0x%lx, got exit = 0x%x", rsvd_bits,
+	       exit_reason);
+
+	if (pxe == npt_get_pdpe() || pxe == npt_get_pml4e()) {
+		/*
+		 * The guest's page tables will blow up on a bad PDPE/PML4E,
+		 * before starting the final walk of the guest page.
+		 */
+		pfec = 0x20000000full;
+	} else {
+		/* RSVD #NPF on final walk of guest page. */
+		pfec = 0x10000000dULL;
+
+		/* PFEC.FETCH=1 if NX=1 *or* SMEP=1. */
+		if ((cr4 & X86_CR4_SMEP) || (efer & EFER_NX))
+			pfec |= 0x10;
+
+	}
+
+	report(vmcb->control.exit_info_1 == pfec,
+	       "Wanted PFEC = 0x%lx, got PFEC = %lx, PxE = 0x%lx.  "
+	       "host.NX = %u, host.SMEP = %u, guest.NX = %u, guest.SMEP = %u",
+	       pfec, vmcb->control.exit_info_1, *pxe,
+	       !!(efer & EFER_NX), !!(cr4 & X86_CR4_SMEP),
+	       !!(guest_efer & EFER_NX), !!(guest_cr4 & X86_CR4_SMEP));
+
+	*pxe = pxe_orig;
+}
+
+static void _svm_npt_rsvd_bits_test(u64 * pxe, u64 pxe_rsvd_bits, u64 efer,
+				    ulong cr4, u64 guest_efer, ulong guest_cr4)
+{
+	u64 rsvd_bits;
+	int i;
+
+	/*
+	 * RDTSC or RDRAND can sometimes fail to generate a valid reserved bits
+	 */
+	if (!pxe_rsvd_bits) {
+		report_skip
+		    ("svm_npt_rsvd_bits_test: Reserved bits are not valid");
+		return;
+	}
+
+	/*
+	 * Test all combinations of guest/host EFER.NX and CR4.SMEP.  If host
+	 * EFER.NX=0, use NX as the reserved bit, otherwise use the passed in
+	 * @pxe_rsvd_bits.
+	 */
+	for (i = 0; i < 16; i++) {
+		if (i & 1) {
+			rsvd_bits = pxe_rsvd_bits;
+			efer |= EFER_NX;
+		} else {
+			rsvd_bits = PT64_NX_MASK;
+			efer &= ~EFER_NX;
+		}
+		if (i & 2)
+			cr4 |= X86_CR4_SMEP;
+		else
+			cr4 &= ~X86_CR4_SMEP;
+		if (i & 4)
+			guest_efer |= EFER_NX;
+		else
+			guest_efer &= ~EFER_NX;
+		if (i & 8)
+			guest_cr4 |= X86_CR4_SMEP;
+		else
+			guest_cr4 &= ~X86_CR4_SMEP;
+
+		__svm_npt_rsvd_bits_test(pxe, rsvd_bits, efer, cr4,
+					 guest_efer, guest_cr4);
+	}
+}
+
+static u64 get_random_bits(u64 hi, u64 low)
+{
+	unsigned retry = 5;
+	u64 rsvd_bits = 0;
+
+	if (this_cpu_has(X86_FEATURE_RDRAND)) {
+		do {
+			rsvd_bits = (rdrand() << low) & GENMASK_ULL(hi, low);
+			retry--;
+		} while (!rsvd_bits && retry);
+	}
+
+	if (!rsvd_bits) {
+		retry = 5;
+		do {
+			rsvd_bits = (rdtsc() << low) & GENMASK_ULL(hi, low);
+			retry--;
+		} while (!rsvd_bits && retry);
+	}
+
+	return rsvd_bits;
+}
+
+static void svm_npt_rsvd_bits_test(void)
+{
+	u64 saved_efer, host_efer, sg_efer, guest_efer;
+	ulong saved_cr4, host_cr4, sg_cr4, guest_cr4;
+
+	if (!npt_supported()) {
+		report_skip("NPT not supported");
+		return;
+	}
+
+	saved_efer = host_efer = rdmsr(MSR_EFER);
+	saved_cr4 = host_cr4 = read_cr4();
+	sg_efer = guest_efer = vmcb->save.efer;
+	sg_cr4 = guest_cr4 = vmcb->save.cr4;
+
+	test_set_guest(basic_guest_main);
+
+	/*
+	 * 4k PTEs don't have reserved bits if MAXPHYADDR >= 52, just skip the
+	 * sub-test.  The NX test is still valid, but the extra bit of coverage
+	 * isn't worth the extra complexity.
+	 */
+	if (cpuid_maxphyaddr() >= 52)
+		goto skip_pte_test;
+
+	_svm_npt_rsvd_bits_test(npt_get_pte((u64) basic_guest_main),
+				get_random_bits(51, cpuid_maxphyaddr()),
+				host_efer, host_cr4, guest_efer, guest_cr4);
+
+skip_pte_test:
+	_svm_npt_rsvd_bits_test(npt_get_pde((u64) basic_guest_main),
+				get_random_bits(20, 13) | PT_PAGE_SIZE_MASK,
+				host_efer, host_cr4, guest_efer, guest_cr4);
+
+	_svm_npt_rsvd_bits_test(npt_get_pdpe(),
+				PT_PAGE_SIZE_MASK |
+				(this_cpu_has(X86_FEATURE_GBPAGES) ?
+				 get_random_bits(29, 13) : 0), host_efer,
+				host_cr4, guest_efer, guest_cr4);
+
+	_svm_npt_rsvd_bits_test(npt_get_pml4e(), BIT_ULL(8),
+				host_efer, host_cr4, guest_efer, guest_cr4);
+
+	wrmsr(MSR_EFER, saved_efer);
+	write_cr4(saved_cr4);
+	vmcb->save.efer = sg_efer;
+	vmcb->save.cr4 = sg_cr4;
+}
+
+int main(int ac, char **av)
+{
+	pteval_t opt_mask = 0;
+
+	__setup_vm(&opt_mask);
+	return run_svm_tests(ac, av);
+}
+
+#define TEST(name) { #name, .v2 = name }
+
+struct svm_test svm_tests[] = {
+	{ "npt_nx", npt_supported, npt_nx_prepare,
+	 default_prepare_gif_clear, null_test,
+	 default_finished, npt_nx_check },
+	{ "npt_np", npt_supported, npt_np_prepare,
+	 default_prepare_gif_clear, npt_np_test,
+	 default_finished, npt_np_check },
+	{ "npt_us", npt_supported, npt_us_prepare,
+	 default_prepare_gif_clear, npt_us_test,
+	 default_finished, npt_us_check },
+	{ "npt_rw", npt_supported, npt_rw_prepare,
+	 default_prepare_gif_clear, npt_rw_test,
+	 default_finished, npt_rw_check },
+	{ "npt_rw_pfwalk", npt_supported, npt_rw_pfwalk_prepare,
+	 default_prepare_gif_clear, null_test,
+	 default_finished, npt_rw_pfwalk_check },
+	{ "npt_l1mmio", npt_supported, npt_l1mmio_prepare,
+	 default_prepare_gif_clear, npt_l1mmio_test,
+	 default_finished, npt_l1mmio_check },
+	{ "npt_rw_l1mmio", npt_supported, npt_rw_l1mmio_prepare,
+	 default_prepare_gif_clear, npt_rw_l1mmio_test,
+	 default_finished, npt_rw_l1mmio_check },
+	TEST(svm_npt_rsvd_bits_test),
+	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
+};
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 6a9b03b..f0eeb1d 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -10,11 +10,10 @@
 #include "isr.h"
 #include "apic.h"
 #include "delay.h"
+#include "vmalloc.h"
 
 #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
 
-static void *scratch_page;
-
 #define LATENCY_RUNS 1000000
 
 extern u16 cpu_online_count;
@@ -698,181 +697,6 @@ static bool sel_cr0_bug_check(struct svm_test *test)
     return vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE;
 }
 
-static void npt_nx_prepare(struct svm_test *test)
-{
-    u64 *pte;
-
-    test->scratch = rdmsr(MSR_EFER);
-    wrmsr(MSR_EFER, test->scratch | EFER_NX);
-
-    /* Clear the guest's EFER.NX, it should not affect NPT behavior. */
-    vmcb->save.efer &= ~EFER_NX;
-
-    pte = npt_get_pte((u64)null_test);
-
-    *pte |= PT64_NX_MASK;
-}
-
-static bool npt_nx_check(struct svm_test *test)
-{
-    u64 *pte = npt_get_pte((u64)null_test);
-
-    wrmsr(MSR_EFER, test->scratch);
-
-    *pte &= ~PT64_NX_MASK;
-
-    return (vmcb->control.exit_code == SVM_EXIT_NPF)
-           && (vmcb->control.exit_info_1 == 0x100000015ULL);
-}
-
-static void npt_np_prepare(struct svm_test *test)
-{
-    u64 *pte;
-
-    scratch_page = alloc_page();
-    pte = npt_get_pte((u64)scratch_page);
-
-    *pte &= ~1ULL;
-}
-
-static void npt_np_test(struct svm_test *test)
-{
-    (void) *(volatile u64 *)scratch_page;
-}
-
-static bool npt_np_check(struct svm_test *test)
-{
-    u64 *pte = npt_get_pte((u64)scratch_page);
-
-    *pte |= 1ULL;
-
-    return (vmcb->control.exit_code == SVM_EXIT_NPF)
-           && (vmcb->control.exit_info_1 == 0x100000004ULL);
-}
-
-static void npt_us_prepare(struct svm_test *test)
-{
-    u64 *pte;
-
-    scratch_page = alloc_page();
-    pte = npt_get_pte((u64)scratch_page);
-
-    *pte &= ~(1ULL << 2);
-}
-
-static void npt_us_test(struct svm_test *test)
-{
-    (void) *(volatile u64 *)scratch_page;
-}
-
-static bool npt_us_check(struct svm_test *test)
-{
-    u64 *pte = npt_get_pte((u64)scratch_page);
-
-    *pte |= (1ULL << 2);
-
-    return (vmcb->control.exit_code == SVM_EXIT_NPF)
-           && (vmcb->control.exit_info_1 == 0x100000005ULL);
-}
-
-static void npt_rw_prepare(struct svm_test *test)
-{
-
-    u64 *pte;
-
-    pte = npt_get_pte(0x80000);
-
-    *pte &= ~(1ULL << 1);
-}
-
-static void npt_rw_test(struct svm_test *test)
-{
-    u64 *data = (void*)(0x80000);
-
-    *data = 0;
-}
-
-static bool npt_rw_check(struct svm_test *test)
-{
-    u64 *pte = npt_get_pte(0x80000);
-
-    *pte |= (1ULL << 1);
-
-    return (vmcb->control.exit_code == SVM_EXIT_NPF)
-           && (vmcb->control.exit_info_1 == 0x100000007ULL);
-}
-
-static void npt_rw_pfwalk_prepare(struct svm_test *test)
-{
-
-    u64 *pte;
-
-    pte = npt_get_pte(read_cr3());
-
-    *pte &= ~(1ULL << 1);
-}
-
-static bool npt_rw_pfwalk_check(struct svm_test *test)
-{
-    u64 *pte = npt_get_pte(read_cr3());
-
-    *pte |= (1ULL << 1);
-
-    return (vmcb->control.exit_code == SVM_EXIT_NPF)
-           && (vmcb->control.exit_info_1 == 0x200000007ULL)
-	   && (vmcb->control.exit_info_2 == read_cr3());
-}
-
-static void npt_l1mmio_prepare(struct svm_test *test)
-{
-}
-
-u32 nested_apic_version1;
-u32 nested_apic_version2;
-
-static void npt_l1mmio_test(struct svm_test *test)
-{
-    volatile u32 *data = (volatile void*)(0xfee00030UL);
-
-    nested_apic_version1 = *data;
-    nested_apic_version2 = *data;
-}
-
-static bool npt_l1mmio_check(struct svm_test *test)
-{
-    volatile u32 *data = (volatile void*)(0xfee00030);
-    u32 lvr = *data;
-
-    return nested_apic_version1 == lvr && nested_apic_version2 == lvr;
-}
-
-static void npt_rw_l1mmio_prepare(struct svm_test *test)
-{
-
-    u64 *pte;
-
-    pte = npt_get_pte(0xfee00080);
-
-    *pte &= ~(1ULL << 1);
-}
-
-static void npt_rw_l1mmio_test(struct svm_test *test)
-{
-    volatile u32 *data = (volatile void*)(0xfee00080);
-
-    *data = *data;
-}
-
-static bool npt_rw_l1mmio_check(struct svm_test *test)
-{
-    u64 *pte = npt_get_pte(0xfee00080);
-
-    *pte |= (1ULL << 1);
-
-    return (vmcb->control.exit_code == SVM_EXIT_NPF)
-           && (vmcb->control.exit_info_1 == 0x100000007ULL);
-}
-
 #define TSC_ADJUST_VALUE    (1ll << 32)
 #define TSC_OFFSET_VALUE    (~0ull << 48)
 static bool ok;
@@ -2672,169 +2496,6 @@ static void svm_test_singlestep(void)
 		vmcb->save.rip == (u64)&guest_end, "Test EFLAGS.TF on VMRUN: guest execution completion");
 }
 
-static void __svm_npt_rsvd_bits_test(u64 *pxe, u64 rsvd_bits, u64 efer,
-				     ulong cr4, u64 guest_efer, ulong guest_cr4)
-{
-	u64 pxe_orig = *pxe;
-	int exit_reason;
-	u64 pfec;
-
-	wrmsr(MSR_EFER, efer);
-	write_cr4(cr4);
-
-	vmcb->save.efer = guest_efer;
-	vmcb->save.cr4  = guest_cr4;
-
-	*pxe |= rsvd_bits;
-
-	exit_reason = svm_vmrun();
-
-	report(exit_reason == SVM_EXIT_NPF,
-	       "Wanted #NPF on rsvd bits = 0x%lx, got exit = 0x%x", rsvd_bits, exit_reason);
-
-	if (pxe == npt_get_pdpe() || pxe == npt_get_pml4e()) {
-		/*
-		 * The guest's page tables will blow up on a bad PDPE/PML4E,
-		 * before starting the final walk of the guest page.
-		 */
-		pfec = 0x20000000full;
-	} else {
-		/* RSVD #NPF on final walk of guest page. */
-		pfec = 0x10000000dULL;
-
-		/* PFEC.FETCH=1 if NX=1 *or* SMEP=1. */
-		if ((cr4 & X86_CR4_SMEP) || (efer & EFER_NX))
-			pfec |= 0x10;
-
-	}
-
-	report(vmcb->control.exit_info_1 == pfec,
-	       "Wanted PFEC = 0x%lx, got PFEC = %lx, PxE = 0x%lx.  "
-	       "host.NX = %u, host.SMEP = %u, guest.NX = %u, guest.SMEP = %u",
-	       pfec, vmcb->control.exit_info_1, *pxe,
-	       !!(efer & EFER_NX), !!(cr4 & X86_CR4_SMEP),
-	       !!(guest_efer & EFER_NX), !!(guest_cr4 & X86_CR4_SMEP));
-
-	*pxe = pxe_orig;
-}
-
-static void _svm_npt_rsvd_bits_test(u64 *pxe, u64 pxe_rsvd_bits,  u64 efer,
-				    ulong cr4, u64 guest_efer, ulong guest_cr4)
-{
-	u64 rsvd_bits;
-	int i;
-
-	/*
-	 * RDTSC or RDRAND can sometimes fail to generate a valid reserved bits
-	 */
-	if (!pxe_rsvd_bits) {
-		report_skip("svm_npt_rsvd_bits_test: Reserved bits are not valid");
-		return;
-	}
-
-	/*
-	 * Test all combinations of guest/host EFER.NX and CR4.SMEP.  If host
-	 * EFER.NX=0, use NX as the reserved bit, otherwise use the passed in
-	 * @pxe_rsvd_bits.
-	 */
-	for (i = 0; i < 16; i++) {
-		if (i & 1) {
-			rsvd_bits = pxe_rsvd_bits;
-			efer |= EFER_NX;
-		} else {
-			rsvd_bits = PT64_NX_MASK;
-			efer &= ~EFER_NX;
-		}
-		if (i & 2)
-			cr4 |= X86_CR4_SMEP;
-		else
-			cr4 &= ~X86_CR4_SMEP;
-		if (i & 4)
-			guest_efer |= EFER_NX;
-		else
-			guest_efer &= ~EFER_NX;
-		if (i & 8)
-			guest_cr4 |= X86_CR4_SMEP;
-		else
-			guest_cr4 &= ~X86_CR4_SMEP;
-
-		__svm_npt_rsvd_bits_test(pxe, rsvd_bits, efer, cr4,
-					 guest_efer, guest_cr4);
-	}
-}
-
-static u64 get_random_bits(u64 hi, u64 low)
-{
-	unsigned retry = 5;
-	u64 rsvd_bits = 0;
-
-	if (this_cpu_has(X86_FEATURE_RDRAND)) {
-		do {
-			rsvd_bits = (rdrand() << low) & GENMASK_ULL(hi, low);
-			retry--;
-		} while (!rsvd_bits && retry);
-	}
-
-	if (!rsvd_bits) {
-		retry = 5;
-		do {
-			rsvd_bits = (rdtsc() << low) & GENMASK_ULL(hi, low);
-			retry--;
-		} while (!rsvd_bits && retry);
-	}
-
-	return rsvd_bits;
-}
-
-
-static void svm_npt_rsvd_bits_test(void)
-{
-	u64   saved_efer, host_efer, sg_efer, guest_efer;
-	ulong saved_cr4,  host_cr4,  sg_cr4,  guest_cr4;
-
-	if (!npt_supported()) {
-		report_skip("NPT not supported");
-		return;
-	}
-
-	saved_efer = host_efer  = rdmsr(MSR_EFER);
-	saved_cr4  = host_cr4   = read_cr4();
-	sg_efer    = guest_efer = vmcb->save.efer;
-	sg_cr4     = guest_cr4  = vmcb->save.cr4;
-
-	test_set_guest(basic_guest_main);
-
-	/*
-	 * 4k PTEs don't have reserved bits if MAXPHYADDR >= 52, just skip the
-	 * sub-test.  The NX test is still valid, but the extra bit of coverage
-	 * isn't worth the extra complexity.
-	 */
-	if (cpuid_maxphyaddr() >= 52)
-		goto skip_pte_test;
-
-	_svm_npt_rsvd_bits_test(npt_get_pte((u64)basic_guest_main),
-				get_random_bits(51, cpuid_maxphyaddr()),
-				host_efer, host_cr4, guest_efer, guest_cr4);
-
-skip_pte_test:
-	_svm_npt_rsvd_bits_test(npt_get_pde((u64)basic_guest_main),
-				get_random_bits(20, 13) | PT_PAGE_SIZE_MASK,
-				host_efer, host_cr4, guest_efer, guest_cr4);
-
-	_svm_npt_rsvd_bits_test(npt_get_pdpe(),
-				PT_PAGE_SIZE_MASK |
-					(this_cpu_has(X86_FEATURE_GBPAGES) ? get_random_bits(29, 13) : 0),
-				host_efer, host_cr4, guest_efer, guest_cr4);
-
-	_svm_npt_rsvd_bits_test(npt_get_pml4e(), BIT_ULL(8),
-				host_efer, host_cr4, guest_efer, guest_cr4);
-
-	wrmsr(MSR_EFER, saved_efer);
-	write_cr4(saved_cr4);
-	vmcb->save.efer = sg_efer;
-	vmcb->save.cr4  = sg_cr4;
-}
-
 static bool volatile svm_errata_reproduced = false;
 static unsigned long volatile physical = 0;
 
@@ -3634,6 +3295,14 @@ static void svm_intr_intercept_mix_smi(void)
 	svm_intr_intercept_mix_run_guest(NULL, SVM_EXIT_SMI);
 }
 
+int main(int ac, char **av)
+{
+    pteval_t opt_mask = 0;
+
+    __setup_vm(&opt_mask);
+    return run_svm_tests(ac, av);
+}
+
 struct svm_test svm_tests[] = {
     { "null", default_supported, default_prepare,
       default_prepare_gif_clear, null_test,
@@ -3677,27 +3346,6 @@ struct svm_test svm_tests[] = {
     { "sel_cr0_bug", default_supported, sel_cr0_bug_prepare,
       default_prepare_gif_clear, sel_cr0_bug_test,
        sel_cr0_bug_finished, sel_cr0_bug_check },
-    { "npt_nx", npt_supported, npt_nx_prepare,
-      default_prepare_gif_clear, null_test,
-      default_finished, npt_nx_check },
-    { "npt_np", npt_supported, npt_np_prepare,
-      default_prepare_gif_clear, npt_np_test,
-      default_finished, npt_np_check },
-    { "npt_us", npt_supported, npt_us_prepare,
-      default_prepare_gif_clear, npt_us_test,
-      default_finished, npt_us_check },
-    { "npt_rw", npt_supported, npt_rw_prepare,
-      default_prepare_gif_clear, npt_rw_test,
-      default_finished, npt_rw_check },
-    { "npt_rw_pfwalk", npt_supported, npt_rw_pfwalk_prepare,
-      default_prepare_gif_clear, null_test,
-      default_finished, npt_rw_pfwalk_check },
-    { "npt_l1mmio", npt_supported, npt_l1mmio_prepare,
-      default_prepare_gif_clear, npt_l1mmio_test,
-      default_finished, npt_l1mmio_check },
-    { "npt_rw_l1mmio", npt_supported, npt_rw_l1mmio_prepare,
-      default_prepare_gif_clear, npt_rw_l1mmio_test,
-      default_finished, npt_rw_l1mmio_check },
     { "tsc_adjust", tsc_adjust_supported, tsc_adjust_prepare,
       default_prepare_gif_clear, tsc_adjust_test,
       default_finished, tsc_adjust_check },
@@ -3749,7 +3397,6 @@ struct svm_test svm_tests[] = {
       vgif_check },
     TEST(svm_cr4_osxsave_test),
     TEST(svm_guest_state_test),
-    TEST(svm_npt_rsvd_bits_test),
     TEST(svm_vmrun_errata_test),
     TEST(svm_vmload_vmsave),
     TEST(svm_test_singlestep),
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 3701797..1828d2c 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -258,6 +258,12 @@ file = svm.flat
 extra_params = -cpu max,+svm -overcommit cpu-pm=on -m 4g -append pause_filter_test
 arch = x86_64
 
+[svm_npt]
+file = svm_npt.flat
+smp = 2
+extra_params = -cpu max,+svm -m 4g
+arch = x86_64
+
 [taskswitch]
 file = taskswitch.flat
 arch = i386
-- 
2.30.2

