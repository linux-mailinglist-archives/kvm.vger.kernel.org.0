Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077E150DF55
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 13:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241786AbiDYLvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 07:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbiDYLvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 07:51:06 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4088F40A2F
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 04:46:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIu6pO603YKMKVfZrbzfBap9PL66Ywk8/CYkqkvMfUYXwjXRs54BSq7+EKSk97ptlTnqu4+XqQ4lIxFPEFgxr46s8XbZUBXYJGZ9y1uVbPbRiB4hp3lYnzXk9ocgG9ZX8VBdEQBJYiPxTe0er+6ksJjjh7QrVpOVgeU5g9qQ6lxl/NDBzy/0no3pJmAX539vzqxUyq1IRKNtvK75I3hmqxxMiev1+X6jhegLqDS2FFo9ucGchFjKZROBQXUYoi3RSdFY8m0gpss0SWihX0CtlU4nIBwJ/wFmxYCe6wtepSFmORDGLnsLc1A3FhlvkhQu0KVIvLTA5ahu5g/DQ8k0tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ifysPn+UzVElbSebOWLoX2+0oRU9G3Q7+70kyvRpnVk=;
 b=QcSQOS9mX34EjfJQkY4LcXep0kNtb44xd/nyKiXRFi3/bjzx++RWN3Jqq6hR2rgcFQ+e5akKP8YrfpICJzU7xt+xQJ8G3i1otBw3JmB0PVkEWsp3uIlyw1wKanLMj+18QDJ6gzO6GDOihUWAXKQAfRThz5kdrAVE8sxxcfCbpm33Mio8OVsfAeIEC94oKDIb+oSKqGUtKE3K+yZIkD2ZBDKXyBWSa1/m7dvVqiP+OZLPxe5t/D+Tv2xqhx+ydHMiCwftjtXKvhs93RZnyANnPOH8qbS3PdD3IAFlPpiyp2Q/qn+z7BF8IQLJOi+z4Kt/K5usXZXQGW/eJu4HZTNSxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifysPn+UzVElbSebOWLoX2+0oRU9G3Q7+70kyvRpnVk=;
 b=UoeYhH4tHnFxtieqEdEcvGcbM9KFNmpKlsd2B4XVUy8/cWfYkg2VOS4U9UnRM1pNIk5vb3bsACCi7ph/Y1eywcP+DBbhYfZb6vJCLW4wNQ/zvijQ1z68u8GCM/7rwO1qbG++fV+uXiPMIuCBuHmPVwk5pxmvaSG6bltPawb2BnU=
Received: from BN9P223CA0019.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::24)
 by MN2PR12MB3117.namprd12.prod.outlook.com (2603:10b6:208:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 11:46:46 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::b2) by BN9P223CA0019.outlook.office365.com
 (2603:10b6:408:10b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Mon, 25 Apr 2022 11:46:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 11:46:45 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 25 Apr
 2022 06:46:44 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests RESEND PATCH v3 6/8] x86: nSVM: Correct indentation for svm.c
Date:   Mon, 25 Apr 2022 11:44:15 +0000
Message-ID: <20220425114417.151540-7-manali.shukla@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9b1a215e-dc01-4dfb-f56f-08da26b1467b
X-MS-TrafficTypeDiagnostic: MN2PR12MB3117:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB31178F49260F8C8E93C99C8BFDF89@MN2PR12MB3117.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PKfVEppOiIazXRwfGA+ymi16eXOwzE1RSpfl9Ei6lqpsYqN0IU8kH0SfkxRJ/B5pS4MzZlGid5zAJXS/edbnI+QvMbN0opd3c5ZC2tqTapmAdg4PZ+Cfqw0ykDPQXh3To+kQKeoTwWQogt068t+mAbTOqLtdVkiGGADlNK0zD6wX0Ut5jvY/gnJuayXMkdQO7U150jZ/jzBvWkXPpDgG/XQunSzLbqm+TffFHrujXIqvWYyDiTAHyPc9tmunpA4i3N2PQLlcYVq5Ea5DdW+Ool8XW3sz4jpdUbwAvfbNyZ4Gz5Bnc0DYBE5zomVl4UAOMveTb7fRzJQdp83TTw4mY+G4HO8seH1G2SS7lCH3XbG4WNWOSclfCSl/mViOYPUmwENHeTbkCBtybLW49P7/UHQ76ZUMnJDm3n2jg5NkbQXW+8fWiB0+1fBspPPdHA0QUcHFjzSfpBx1TOFby6RPRsyuHdzzUrm8m9/7xtRk5BYkyUEM84wZ0F6Gq45gjCZWQnbAQIlrZGOfn+W+q/zs4oX0AUjFzGwT4/oP6Lkc7KWmnkDBSPb4emolcWeHAkaLHaPdwjJJ5y8UrBrD3RMAfshU4LGEVfT3wsE+nz0L4Pvbwy+3ws2JmeVCV5HHgKGIgv8Wa3UPxbBNrNcSH9dKn8CkuG26pNHD77XbXde6B0R8BMht3GJOYcgoyQRA2JFI9UdjPQhvp7NKMTQd5AddnA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(5660300002)(36756003)(2906002)(40460700003)(81166007)(356005)(47076005)(336012)(426003)(1076003)(110136005)(44832011)(316002)(2616005)(82310400005)(16526019)(7696005)(30864003)(6666004)(36860700001)(70206006)(4326008)(8676002)(70586007)(26005)(186003)(86362001)(83380400001)(508600001)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 11:46:45.9317
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b1a215e-dc01-4dfb-f56f-08da26b1467b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3117
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
indentation in svm.c file.

No functional changes intended.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm.c | 225 +++++++++++++++++++++++++++---------------------------
 1 file changed, 111 insertions(+), 114 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index e66c801..081a167 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -23,26 +23,26 @@ struct vmcb *vmcb;
 
 u64 *npt_get_pte(u64 address)
 {
-        return get_pte(npt_get_pml4e(), (void*)address);
+	return get_pte(npt_get_pml4e(), (void *)address);
 }
 
 u64 *npt_get_pde(u64 address)
 {
-    struct pte_search search;
-    search = find_pte_level(npt_get_pml4e(), (void*)address, 2);
-    return search.pte;
+	struct pte_search search;
+	search = find_pte_level(npt_get_pml4e(), (void *)address, 2);
+	return search.pte;
 }
 
 u64 *npt_get_pdpe(u64 address)
 {
-    struct pte_search search;
-    search = find_pte_level(npt_get_pml4e(), (void*)address, 3);
-    return search.pte;
+	struct pte_search search;
+	search = find_pte_level(npt_get_pml4e(), (void *)address, 3);
+	return search.pte;
 }
 
 u64 *npt_get_pml4e(void)
 {
-    return pml4e;
+	return pml4e;
 }
 
 bool smp_supported(void)
@@ -52,7 +52,7 @@ bool smp_supported(void)
 
 bool default_supported(void)
 {
-    return true;
+	return true;
 }
 
 bool vgif_supported(void)
@@ -62,25 +62,24 @@ bool vgif_supported(void)
 
 bool lbrv_supported(void)
 {
-    return this_cpu_has(X86_FEATURE_LBRV);
+	return this_cpu_has(X86_FEATURE_LBRV);
 }
 
 bool tsc_scale_supported(void)
 {
-    return this_cpu_has(X86_FEATURE_TSCRATEMSR);
+	return this_cpu_has(X86_FEATURE_TSCRATEMSR);
 }
 
 bool pause_filter_supported(void)
 {
-    return this_cpu_has(X86_FEATURE_PAUSEFILTER);
+	return this_cpu_has(X86_FEATURE_PAUSEFILTER);
 }
 
 bool pause_threshold_supported(void)
 {
-    return this_cpu_has(X86_FEATURE_PFTHRESHOLD);
+	return this_cpu_has(X86_FEATURE_PFTHRESHOLD);
 }
 
-
 void default_prepare(struct svm_test *test)
 {
 	vmcb_ident(vmcb);
@@ -92,7 +91,7 @@ void default_prepare_gif_clear(struct svm_test *test)
 
 bool default_finished(struct svm_test *test)
 {
-	return true; /* one vmexit */
+	return true;		/* one vmexit */
 }
 
 bool npt_supported(void)
@@ -121,7 +120,7 @@ void inc_test_stage(struct svm_test *test)
 }
 
 static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
-                         u64 base, u32 limit, u32 attr)
+			 u64 base, u32 limit, u32 attr)
 {
 	seg->selector = selector;
 	seg->attrib = attr;
@@ -131,7 +130,7 @@ static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
 
 inline void vmmcall(void)
 {
-	asm volatile ("vmmcall" : : : "memory");
+	asm volatile ("vmmcall":::"memory");
 }
 
 static test_guest_func guest_main;
@@ -165,15 +164,17 @@ void vmcb_ident(struct vmcb *vmcb)
 	struct descriptor_table_ptr desc_table_ptr;
 
 	memset(vmcb, 0, sizeof(*vmcb));
-	asm volatile ("vmsave %0" : : "a"(vmcb_phys) : "memory");
+	asm volatile ("vmsave %0"::"a" (vmcb_phys):"memory");
 	vmcb_set_seg(&save->es, read_es(), 0, -1U, data_seg_attr);
 	vmcb_set_seg(&save->cs, read_cs(), 0, -1U, code_seg_attr);
 	vmcb_set_seg(&save->ss, read_ss(), 0, -1U, data_seg_attr);
 	vmcb_set_seg(&save->ds, read_ds(), 0, -1U, data_seg_attr);
 	sgdt(&desc_table_ptr);
-	vmcb_set_seg(&save->gdtr, 0, desc_table_ptr.base, desc_table_ptr.limit, 0);
+	vmcb_set_seg(&save->gdtr, 0, desc_table_ptr.base, desc_table_ptr.limit,
+		     0);
 	sidt(&desc_table_ptr);
-	vmcb_set_seg(&save->idtr, 0, desc_table_ptr.base, desc_table_ptr.limit, 0);
+	vmcb_set_seg(&save->idtr, 0, desc_table_ptr.base, desc_table_ptr.limit,
+		     0);
 	ctrl->asid = 1;
 	save->cpl = 0;
 	save->efer = rdmsr(MSR_EFER);
@@ -186,14 +187,13 @@ void vmcb_ident(struct vmcb *vmcb)
 	save->g_pat = rdmsr(MSR_IA32_CR_PAT);
 	save->dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) |
-			  (1ULL << INTERCEPT_VMMCALL) |
-			  (1ULL << INTERCEPT_SHUTDOWN);
+	    (1ULL << INTERCEPT_VMMCALL) | (1ULL << INTERCEPT_SHUTDOWN);
 	ctrl->iopm_base_pa = virt_to_phys(io_bitmap);
 	ctrl->msrpm_base_pa = virt_to_phys(msr_bitmap);
 
 	if (npt_supported()) {
 		ctrl->nested_ctl = 1;
-		ctrl->nested_cr3 = (u64)pml4e;
+		ctrl->nested_cr3 = (u64) pml4e;
 		ctrl->tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
 	}
 }
@@ -207,32 +207,29 @@ struct regs get_regs(void)
 
 // rax handled specially below
 
-
 struct svm_test *v2_test;
 
-
 u64 guest_stack[10000];
 
 int __svm_vmrun(u64 rip)
 {
-	vmcb->save.rip = (ulong)rip;
-	vmcb->save.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
-	regs.rdi = (ulong)v2_test;
+	vmcb->save.rip = (ulong) rip;
+	vmcb->save.rsp = (ulong) (guest_stack + ARRAY_SIZE(guest_stack));
+	regs.rdi = (ulong) v2_test;
 
-	asm volatile (
-		ASM_PRE_VMRUN_CMD
-                "vmrun %%rax\n\t"               \
-		ASM_POST_VMRUN_CMD
-		:
-		: "a" (virt_to_phys(vmcb))
-		: "memory", "r15");
+	asm volatile (ASM_PRE_VMRUN_CMD
+			  "vmrun %%rax\n\t" \
+			  ASM_POST_VMRUN_CMD
+			  :
+			  :"a"(virt_to_phys(vmcb))
+			  :"memory", "r15");
 
 	return (vmcb->control.exit_code);
 }
 
 int svm_vmrun(void)
 {
-	return __svm_vmrun((u64)test_thunk);
+	return __svm_vmrun((u64) test_thunk);
 }
 
 extern u8 vmrun_rip;
@@ -246,40 +243,38 @@ static noinline void test_run(struct svm_test *test)
 
 	test->prepare(test);
 	guest_main = test->guest_func;
-	vmcb->save.rip = (ulong)test_thunk;
-	vmcb->save.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
-	regs.rdi = (ulong)test;
+	vmcb->save.rip = (ulong) test_thunk;
+	vmcb->save.rsp = (ulong) (guest_stack + ARRAY_SIZE(guest_stack));
+	regs.rdi = (ulong) test;
 	do {
 		struct svm_test *the_test = test;
 		u64 the_vmcb = vmcb_phys;
-		asm volatile (
-			"clgi;\n\t" // semi-colon needed for LLVM compatibility
-			"sti \n\t"
-			"call *%c[PREPARE_GIF_CLEAR](%[test]) \n \t"
-			"mov %[vmcb_phys], %%rax \n\t"
-			ASM_PRE_VMRUN_CMD
-			".global vmrun_rip\n\t"		\
-			"vmrun_rip: vmrun %%rax\n\t"    \
-			ASM_POST_VMRUN_CMD
-			"cli \n\t"
-			"stgi"
-			: // inputs clobbered by the guest:
-			"=D" (the_test),            // first argument register
-			"=b" (the_vmcb)             // callee save register!
-			: [test] "0" (the_test),
-			[vmcb_phys] "1"(the_vmcb),
-			[PREPARE_GIF_CLEAR] "i" (offsetof(struct svm_test, prepare_gif_clear))
-			: "rax", "rcx", "rdx", "rsi",
-			"r8", "r9", "r10", "r11" , "r12", "r13", "r14", "r15",
-			"memory");
+		asm volatile ("clgi;\n\t"	// semi-colon needed for LLVM compatibility
+			      "sti \n\t"
+			      "call *%c[PREPARE_GIF_CLEAR](%[test]) \n \t"
+			      "mov %[vmcb_phys], %%rax \n\t"
+			      ASM_PRE_VMRUN_CMD
+			      ".global vmrun_rip\n\t"       \
+			      "vmrun_rip: vmrun %%rax\n\t"  \
+			      ASM_POST_VMRUN_CMD "cli \n\t"
+			      "stgi"
+			      :	// inputs clobbered by the guest:
+			      "=D"(the_test),	// first argument register
+			      "=b"(the_vmcb)	// callee save register!
+			      :[test] "0"(the_test),
+			      [vmcb_phys] "1"(the_vmcb),
+			      [PREPARE_GIF_CLEAR]
+			      "i"(offsetof(struct svm_test, prepare_gif_clear))
+			      :"rax", "rcx", "rdx", "rsi", "r8", "r9", "r10",
+			      "r11", "r12", "r13", "r14", "r15", "memory");
 		++test->exits;
 	} while (!test->finished(test));
 	irq_enable();
 
 	report(test->succeeded(test), "%s", test->name);
 
-        if (test->on_vcpu)
-	    test->on_vcpu_done = true;
+	if (test->on_vcpu)
+		test->on_vcpu_done = true;
 }
 
 static void set_additional_vcpu_msr(void *msr_efer)
@@ -287,18 +282,19 @@ static void set_additional_vcpu_msr(void *msr_efer)
 	void *hsave = alloc_page();
 
 	wrmsr(MSR_VM_HSAVE_PA, virt_to_phys(hsave));
-	wrmsr(MSR_EFER, (ulong)msr_efer | EFER_SVME);
+	wrmsr(MSR_EFER, (ulong) msr_efer | EFER_SVME);
 }
 
-void setup_npt(void) {
-    u64 end_of_memory;
-    pml4e = alloc_page();
+void setup_npt(void)
+{
+	u64 end_of_memory;
+	pml4e = alloc_page();
 
-    end_of_memory = fwcfg_get_u64(FW_CFG_RAM_SIZE);
-    if (end_of_memory < (1ul << 32))
-        end_of_memory = (1ul << 32);
+	end_of_memory = fwcfg_get_u64(FW_CFG_RAM_SIZE);
+	if (end_of_memory < (1ul << 32))
+		end_of_memory = (1ul << 32);
 
-    setup_mmu_range(pml4e, 0, end_of_memory, true);
+	setup_mmu_range(pml4e, 0, end_of_memory, true);
 }
 
 static void setup_svm(void)
@@ -309,63 +305,64 @@ static void setup_svm(void)
 	wrmsr(MSR_VM_HSAVE_PA, virt_to_phys(hsave));
 	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
 
-	io_bitmap = (void *) ALIGN((ulong)io_bitmap_area, PAGE_SIZE);
+	io_bitmap = (void *)ALIGN((ulong) io_bitmap_area, PAGE_SIZE);
 
-	msr_bitmap = (void *) ALIGN((ulong)msr_bitmap_area, PAGE_SIZE);
+	msr_bitmap = (void *)ALIGN((ulong) msr_bitmap_area, PAGE_SIZE);
 
 	if (!npt_supported())
 		return;
 
 	for (i = 1; i < cpu_count(); i++)
-		on_cpu(i, (void *)set_additional_vcpu_msr, (void *)rdmsr(MSR_EFER));
+		on_cpu(i, (void *)set_additional_vcpu_msr,
+		       (void *)rdmsr(MSR_EFER));
 
 	printf("NPT detected - running all tests with NPT enabled\n");
 
 	/*
-	* Nested paging supported - Build a nested page table
-	* Build the page-table bottom-up and map everything with 4k
-	* pages to get enough granularity for the NPT unit-tests.
-	*/
+	 * Nested paging supported - Build a nested page table
+	 * Build the page-table bottom-up and map everything with 4k
+	 * pages to get enough granularity for the NPT unit-tests.
+	 */
 
-  setup_npt();
+	setup_npt();
 }
 
 int matched;
 
-static bool
-test_wanted(const char *name, char *filters[], int filter_count)
-{
-        int i;
-        bool positive = false;
-        bool match = false;
-        char clean_name[strlen(name) + 1];
-        char *c;
-        const char *n;
-
-        /* Replace spaces with underscores. */
-        n = name;
-        c = &clean_name[0];
-        do *c++ = (*n == ' ') ? '_' : *n;
-        while (*n++);
-
-        for (i = 0; i < filter_count; i++) {
-                const char *filter = filters[i];
-
-                if (filter[0] == '-') {
-                        if (simple_glob(clean_name, filter + 1))
-                                return false;
-                } else {
-                        positive = true;
-                        match |= simple_glob(clean_name, filter);
-                }
-        }
-
-        if (!positive || match) {
-                matched++;
-                return true;
-        } else {
-                return false;
-        }
+static bool test_wanted(const char *name, char *filters[], int filter_count)
+{
+	int i;
+	bool positive = false;
+	bool match = false;
+	char clean_name[strlen(name) + 1];
+	char *c;
+	const char *n;
+
+	/* Replace spaces with underscores. */
+	n = name;
+	c = &clean_name[0];
+	do
+		*c++ = (*n == ' ') ? '_' : *n;
+	while (*n++);
+
+	for (i = 0; i < filter_count; i++) {
+		const char *filter = filters[i];
+
+		if (filter[0] == '-') {
+			if (simple_glob(clean_name, filter + 1))
+				return false;
+		} else {
+			positive = true;
+			match |= simple_glob(clean_name, filter);
+		}
+	}
+
+	if (!positive || match) {
+		matched++;
+		return true;
+	} else {
+		return false;
+	}
 }
 
 int run_svm_tests(int ac, char **av)
@@ -393,11 +390,11 @@ int run_svm_tests(int ac, char **av)
 			if (svm_tests[i].on_vcpu) {
 				if (cpu_count() <= svm_tests[i].on_vcpu)
 					continue;
-				on_cpu_async(svm_tests[i].on_vcpu, (void *)test_run, &svm_tests[i]);
+				on_cpu_async(svm_tests[i].on_vcpu,
+					     (void *)test_run, &svm_tests[i]);
 				while (!svm_tests[i].on_vcpu_done)
 					cpu_relax();
-			}
-			else
+			} else
 				test_run(&svm_tests[i]);
 		} else {
 			vmcb_ident(vmcb);
-- 
2.30.2

