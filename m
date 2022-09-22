Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF1B5E599D
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 05:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiIVDXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 23:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiIVDVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 23:21:47 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF747979FC
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:22 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d7-20020a170903230700b00177f6dd8472so5050528plh.6
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=wOvJqpaUpWNmXTaeQLYHX/R0uq3MQAqpSBXIqnz7EEE=;
        b=FDFbw43anx8wQjNMHl5FvxPjR0mnnL3JzrsWexEyI6SAeV/qi59Sta3AGq0H/wawAj
         h6/s8Wtxn2ZiQ0a9xbUvhAgn021IDvnFcOOC4/xiMu7L862jku8ftCytcoR6NGXh0Vtx
         rzdekga6KBHt/vN5uHpMVx1211iAG3jXpApZCAueLhSscPow+i0R83ORdzSFpSDFUpSc
         zO05cvU77zy33RrFgTIHQtS9n09HVRVUiSZjUZ5GM5fZMHMM27nlPWVNvcQBdWKg4XwF
         d9M8bE71eTAO/fIDDEyhqDHtm3OeklDgzss852VeHml2fETitNHpg0W1LY8RXQ7r374n
         5nSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=wOvJqpaUpWNmXTaeQLYHX/R0uq3MQAqpSBXIqnz7EEE=;
        b=pE3dPvKKiu4SC7jr82nUR4pRRAN7lHrsWt2w/Tn5Lscm0ZLxFCqNFDfJ+THqD7hRZU
         Fa4iM42RIzWCfIIs+psTSiSvdnrgB6h3oCkGXVRRh9LHWoQY2m5TImrCYpb6UR9Xd9OH
         8uzC+y4GkmNU2Gxbs7YYQOkoMRu9iBNZkiP2rcT9liG8S+B+HPiqJoVinf7BtOf/0KxC
         QAZ8QbbShDI5pFrg42fHNaUbdjkeZUf3JROjnzQSL0E/w3mw+0ZkByb7fNrGip6nLSkF
         e2MRnDrUigomNibF61ifYyapXz1lH8RHIR0nAWWtfBN94q7Fu4rxcQIrj3OWlPV5uKp/
         tYkw==
X-Gm-Message-State: ACrzQf1Q3yeun9H4nqTI8E/d6p2KmaYhoQ5WozBhLkvnAABaDg8AXXl+
        k1Jlj90Au7vxQpzhaADhyQl3imTQd0kljL0I2mWJBcAmiqqJoLGjgNPxr8ZjPssFD7YKLERDMOX
        LJkm7sF9Mi7LEjjarRoaqOXIzdPTTxnl4H8EfIG7sUIKmQj4XmkFU0PME5mhInrQ=
X-Google-Smtp-Source: AMsMyM7M++VyhE+u0ZRa5gZVvCO3yWIPrkTIA+RzHB7+VFAe6FkeQUpocgc+W6OtqTgKd2qnFX13yXqeNrFtgw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:cd06:b0:203:ae0e:6a21 with SMTP
 id d6-20020a17090acd0600b00203ae0e6a21mr95244pju.0.1663816761578; Wed, 21 Sep
 2022 20:19:21 -0700 (PDT)
Date:   Thu, 22 Sep 2022 03:18:56 +0000
In-Reply-To: <20220922031857.2588688-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220922031857.2588688-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-14-ricarkol@google.com>
Subject: [PATCH v8 13/14] KVM: selftests: aarch64: Add readonly memslot tests
 into page_fault_test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add some readonly memslot tests into page_fault_test. Mark the data
and/or page-table memslots as readonly, perform some accesses, and check
that the right fault is triggered when expected (e.g., a store with no
write-back should lead to an mmio exit).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 101 +++++++++++++++++-
 1 file changed, 100 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 5f6e10a385a9..8f2a30402e27 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -41,6 +41,8 @@ static uint64_t *guest_test_memory = (uint64_t *)TEST_GVA;
 #define CHECK_FN_NR				10
 
 static struct event_cnt {
+	int mmio_exits;
+	int fail_vcpu_runs;
 	int uffd_faults;
 	/* uffd_faults is incremented from multiple threads. */
 	pthread_mutex_t uffd_faults_mutex;
@@ -57,6 +59,8 @@ struct test_desc {
 	uffd_handler_t uffd_data_handler;
 	void (*dabt_handler)(struct ex_regs *regs);
 	void (*iabt_handler)(struct ex_regs *regs);
+	void (*mmio_handler)(struct kvm_vm *vm, struct kvm_run *run);
+	void (*fail_vcpu_run_handler)(int ret);
 	uint32_t pt_memslot_flags;
 	uint32_t data_memslot_flags;
 	bool skip;
@@ -418,6 +422,31 @@ static bool punch_hole_in_memslot(struct kvm_vm *vm,
 	return true;
 }
 
+static void mmio_on_test_gpa_handler(struct kvm_vm *vm, struct kvm_run *run)
+{
+	struct userspace_mem_region *region;
+	void *hva;
+
+	region = vm_get_mem_region(vm, MEM_REGION_TEST_DATA);
+	hva = (void *)region->region.userspace_addr;
+
+	ASSERT_EQ(run->mmio.phys_addr, region->region.guest_phys_addr);
+
+	memcpy(hva, run->mmio.data, run->mmio.len);
+	events.mmio_exits += 1;
+}
+
+static void mmio_no_handler(struct kvm_vm *vm, struct kvm_run *run)
+{
+	uint64_t data;
+
+	memcpy(&data, run->mmio.data, sizeof(data));
+	pr_debug("addr=%lld len=%d w=%d data=%lx\n",
+			run->mmio.phys_addr, run->mmio.len,
+			run->mmio.is_write, data);
+	TEST_FAIL("There was no MMIO exit expected.");
+}
+
 static bool check_write_in_dirty_log(struct kvm_vm *vm,
 		struct userspace_mem_region *region, uint64_t host_pg_nr)
 {
@@ -465,6 +494,18 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 	return continue_test;
 }
 
+void fail_vcpu_run_no_handler(int ret)
+{
+	TEST_FAIL("Unexpected vcpu run failure\n");
+}
+
+void fail_vcpu_run_mmio_no_syndrome_handler(int ret)
+{
+	TEST_ASSERT(errno == ENOSYS,
+		"The mmio handler should have returned not implemented.");
+	events.fail_vcpu_runs += 1;
+}
+
 typedef uint32_t aarch64_insn_t;
 extern aarch64_insn_t __exec_test[2];
 
@@ -566,9 +607,20 @@ static void setup_memslots(struct kvm_vm *vm, struct test_params *p)
 	vm->memslots[MEM_REGION_TEST_DATA] = TEST_DATA_MEMSLOT;
 }
 
+static void setup_default_handlers(struct test_desc *test)
+{
+	if (!test->mmio_handler)
+		test->mmio_handler = mmio_no_handler;
+
+	if (!test->fail_vcpu_run_handler)
+		test->fail_vcpu_run_handler = fail_vcpu_run_no_handler;
+}
+
 static void check_event_counts(struct test_desc *test)
 {
 	ASSERT_EQ(test->expected_events.uffd_faults, events.uffd_faults);
+	ASSERT_EQ(test->expected_events.mmio_exits, events.mmio_exits);
+	ASSERT_EQ(test->expected_events.fail_vcpu_runs, events.fail_vcpu_runs);
 }
 
 static void print_test_banner(enum vm_guest_mode mode, struct test_params *p)
@@ -593,10 +645,18 @@ static void reset_event_counts(void)
 static void vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 		struct test_desc *test)
 {
+	struct kvm_run *run;
 	struct ucall uc;
+	int ret;
+
+	run = vcpu->run;
 
 	for (;;) {
-		vcpu_run(vcpu);
+		ret = _vcpu_run(vcpu);
+		if (ret) {
+			test->fail_vcpu_run_handler(ret);
+			goto done;
+		}
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_SYNC:
@@ -610,6 +670,10 @@ static void vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 			break;
 		case UCALL_DONE:
 			goto done;
+		case UCALL_NONE:
+			if (run->exit_reason == KVM_EXIT_MMIO)
+				test->mmio_handler(vm, run);
+			break;
 		default:
 			TEST_FAIL("Unknown ucall %lu", uc.cmd);
 		}
@@ -650,6 +714,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	load_exec_code_for_test(vm);
 	setup_uffd(vm, p, &pt_uffd, &data_uffd);
 	setup_abort_handlers(vm, vcpu, test);
+	setup_default_handlers(test);
 	vcpu_args_set(vcpu, 1, test);
 
 	vcpu_run_loop(vm, vcpu, test);
@@ -737,6 +802,25 @@ static void help(char *name)
 	.expected_events	= { 0 },					\
 }
 
+#define TEST_RO_MEMSLOT(_access, _mmio_handler, _mmio_exits)			\
+{										\
+	.name			= SCAT3(ro_memslot, _access, _with_af),		\
+	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.guest_prepare		= { _PREPARE(_access) },			\
+	.guest_test		= _access,					\
+	.mmio_handler		= _mmio_handler,				\
+	.expected_events	= { .mmio_exits = _mmio_exits },		\
+}
+
+#define TEST_RO_MEMSLOT_NO_SYNDROME(_access)					\
+{										\
+	.name			= SCAT2(ro_memslot_no_syndrome, _access),	\
+	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.guest_test		= _access,					\
+	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
+	.expected_events	= { .fail_vcpu_runs = 1 },			\
+}
+
 static struct test_desc tests[] = {
 
 	/* Check that HW is setting the Access Flag (AF) (sanity checks). */
@@ -805,6 +889,21 @@ static struct test_desc tests[] = {
 	TEST_DIRTY_LOG(guest_dc_zva, with_af, guest_check_write_in_dirty_log),
 	TEST_DIRTY_LOG(guest_st_preidx, with_af, guest_check_write_in_dirty_log),
 
+	/*
+	 * Try accesses when the data memslot is marked read-only (with
+	 * KVM_MEM_READONLY). Writes with a syndrome result in an MMIO exit,
+	 * writes with no syndrome (e.g., CAS) result in a failed vcpu run, and
+	 * reads/execs with and without syndroms do not fault.
+	 */
+	TEST_RO_MEMSLOT(guest_read64, 0, 0),
+	TEST_RO_MEMSLOT(guest_ld_preidx, 0, 0),
+	TEST_RO_MEMSLOT(guest_at, 0, 0),
+	TEST_RO_MEMSLOT(guest_exec, 0, 0),
+	TEST_RO_MEMSLOT(guest_write64, mmio_on_test_gpa_handler, 1),
+	TEST_RO_MEMSLOT_NO_SYNDROME(guest_dc_zva),
+	TEST_RO_MEMSLOT_NO_SYNDROME(guest_cas),
+	TEST_RO_MEMSLOT_NO_SYNDROME(guest_st_preidx),
+
 	{ 0 }
 };
 
-- 
2.37.3.968.ga6b4b080e4-goog

