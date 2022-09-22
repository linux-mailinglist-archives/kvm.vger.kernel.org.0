Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41065E59A0
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 05:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbiIVDXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 23:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiIVDVq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 23:21:46 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B004396FE4
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:18 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id rw5-20020a17090b2c4500b00203182a71baso4262439pjb.1
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=ZsvRywBcE5qQvrRqrWl+nkqxo36TRzMJs0PWzKRfSG4=;
        b=Kx7w7o2d7Od+f8/0WYcpTTDQHpW6w8eVecL1exxqnDJ1oRCSmFGT1HQx+qP76QNAmq
         robKojKFKdJ1qDEVYqRV3Mam0b8ui8A/UZ/VC+bNFh6Lqb/7U9rA5eyzVi43YRgrT4CL
         8XFynWbIXYfdWyCl0F0O6cxudCh2MhqAuWahUnrb2+xrLTAOVNhGlagdiH3YTYyY7z1b
         NokRoGF8M7bJo12uA47sbBffoWJ5wKmNJvA+qEmU5qJf1TZAPyY2jl/HNK7hiCKShXdl
         E1Z27Kuwies72yPOPJE6qySghix1VD3NjFsap2mzyqsTZv/Tx4OEIJWgvqLfYqFq3els
         r8kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=ZsvRywBcE5qQvrRqrWl+nkqxo36TRzMJs0PWzKRfSG4=;
        b=5VP8nMVQo0GyJeoXPd+rhcPSM+OL8wsQvZOdfZepkzcCTu+/hZzwo4baVEPyjTQmmk
         0Mxu0ySQvNwJIIGj/zmeaHacurjIuYANOWtL/mXYT9bGhEVgaA/hqd+m8v+2y97RSNIC
         DRfhCupB3UjJ+imI9k/EZ4Tes8JvZ7/xqhN7fVgzJOqT7MP92EpJT8tFs2HUCMcIB0RX
         28VqmPBcNLi2HQ0SjPMFRB8EfIB9lZHK4e/4vPKXHxNWt7llRHVrg8AlBBKwEz50G2HW
         nenDnnK92oT8gzdp7XSCuk/eNKD3w4I8HBiyj43hCO1Htfehl72DS4UOu4cg0lOaSHqF
         kF2A==
X-Gm-Message-State: ACrzQf2f4z+qFVKEKkc9oI102L29VTk6YAz4vnZ1gUIXPyxhrKUo3HOg
        SuWrPjnyKWRIVAtveG0xcuws3tK1X+IOZ5JwIutecU+K1vMiUG0zeRsnVJJXRySMr/r0MyFdbMa
        mcaQ5fX3wB+WrY/aW63MqBgLG+Wse+gZjK77tNhXLA3+Rlgdc3/HbYBWNijS7wM4=
X-Google-Smtp-Source: AMsMyM52hmfV8kkcmMM0mgRriIpcD5jJI5uyKfJtD6Sa1k6U9N+SM9KNm4rC372fcHo3uQpu60FtQvf4pBaKxQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:cc7:b0:200:3b3e:4e00 with SMTP id
 7-20020a17090a0cc700b002003b3e4e00mr12667762pjt.201.1663816758162; Wed, 21
 Sep 2022 20:19:18 -0700 (PDT)
Date:   Thu, 22 Sep 2022 03:18:54 +0000
In-Reply-To: <20220922031857.2588688-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220922031857.2588688-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-12-ricarkol@google.com>
Subject: [PATCH v8 11/14] KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
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

Add some userfaultfd tests into page_fault_test. Punch holes into the
data and/or page-table memslots, perform some accesses, and check that
the faults are taken (or not taken) when expected.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 190 +++++++++++++++++-
 1 file changed, 188 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 54321b15276e..75ad1440268a 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -35,6 +35,12 @@ static uint64_t *guest_test_memory = (uint64_t *)TEST_GVA;
 #define PREPARE_FN_NR				10
 #define CHECK_FN_NR				10
 
+static struct event_cnt {
+	int uffd_faults;
+	/* uffd_faults is incremented from multiple threads. */
+	pthread_mutex_t uffd_faults_mutex;
+} events;
+
 struct test_desc {
 	const char *name;
 	uint64_t mem_mark_cmd;
@@ -42,11 +48,14 @@ struct test_desc {
 	bool (*guest_prepare[PREPARE_FN_NR])(void);
 	void (*guest_test)(void);
 	void (*guest_test_check[CHECK_FN_NR])(void);
+	uffd_handler_t uffd_pt_handler;
+	uffd_handler_t uffd_data_handler;
 	void (*dabt_handler)(struct ex_regs *regs);
 	void (*iabt_handler)(struct ex_regs *regs);
 	uint32_t pt_memslot_flags;
 	uint32_t data_memslot_flags;
 	bool skip;
+	struct event_cnt expected_events;
 };
 
 struct test_params {
@@ -263,7 +272,110 @@ static void no_iabt_handler(struct ex_regs *regs)
 	GUEST_ASSERT_1(false, regs->pc);
 }
 
+static struct uffd_args {
+	char *copy;
+	void *hva;
+	uint64_t paging_size;
+} pt_args, data_args;
+
 /* Returns true to continue the test, and false if it should be skipped. */
+static int uffd_generic_handler(int uffd_mode, int uffd,
+		struct uffd_msg *msg, struct uffd_args *args,
+		bool expect_write)
+{
+	uint64_t addr = msg->arg.pagefault.address;
+	uint64_t flags = msg->arg.pagefault.flags;
+	struct uffdio_copy copy;
+	int ret;
+
+	TEST_ASSERT(uffd_mode == UFFDIO_REGISTER_MODE_MISSING,
+			"The only expected UFFD mode is MISSING");
+	ASSERT_EQ(!!(flags & UFFD_PAGEFAULT_FLAG_WRITE), expect_write);
+	ASSERT_EQ(addr, (uint64_t)args->hva);
+
+	pr_debug("uffd fault: addr=%p write=%d\n",
+			(void *)addr, !!(flags & UFFD_PAGEFAULT_FLAG_WRITE));
+
+	copy.src = (uint64_t)args->copy;
+	copy.dst = addr;
+	copy.len = args->paging_size;
+	copy.mode = 0;
+
+	ret = ioctl(uffd, UFFDIO_COPY, &copy);
+	if (ret == -1) {
+		pr_info("Failed UFFDIO_COPY in 0x%lx with errno: %d\n",
+				addr, errno);
+		return ret;
+	}
+
+	pthread_mutex_lock(&events.uffd_faults_mutex);
+	events.uffd_faults += 1;
+	pthread_mutex_unlock(&events.uffd_faults_mutex);
+	return 0;
+}
+
+static int uffd_pt_write_handler(int mode, int uffd, struct uffd_msg *msg)
+{
+	return uffd_generic_handler(mode, uffd, msg, &pt_args, true);
+}
+
+static int uffd_data_write_handler(int mode, int uffd, struct uffd_msg *msg)
+{
+	return uffd_generic_handler(mode, uffd, msg, &data_args, true);
+}
+
+static int uffd_data_read_handler(int mode, int uffd, struct uffd_msg *msg)
+{
+	return uffd_generic_handler(mode, uffd, msg, &data_args, false);
+}
+
+static void setup_uffd_args(struct userspace_mem_region *region,
+				struct uffd_args *args)
+{
+	args->hva = (void *)region->region.userspace_addr;
+	args->paging_size = region->region.memory_size;
+
+	args->copy = malloc(args->paging_size);
+	TEST_ASSERT(args->copy, "Failed to allocate data copy.");
+	memcpy(args->copy, args->hva, args->paging_size);
+}
+
+static void setup_uffd(struct kvm_vm *vm, struct test_params *p,
+		struct uffd_desc **pt_uffd, struct uffd_desc **data_uffd)
+{
+	struct test_desc *test = p->test_desc;
+
+	setup_uffd_args(vm_get_mem_region(vm, MEM_REGION_PT), &pt_args);
+	setup_uffd_args(vm_get_mem_region(vm, MEM_REGION_TEST_DATA), &data_args);
+
+	*pt_uffd = NULL;
+	if (test->uffd_pt_handler)
+		*pt_uffd = uffd_setup_demand_paging(
+				UFFDIO_REGISTER_MODE_MISSING, 0,
+				pt_args.hva, pt_args.paging_size,
+				test->uffd_pt_handler);
+
+	*data_uffd = NULL;
+	if (test->uffd_data_handler)
+		*data_uffd = uffd_setup_demand_paging(
+				UFFDIO_REGISTER_MODE_MISSING, 0,
+				data_args.hva, data_args.paging_size,
+				test->uffd_data_handler);
+}
+
+static void free_uffd(struct test_desc *test, struct uffd_desc *pt_uffd,
+			struct uffd_desc *data_uffd)
+{
+	if (test->uffd_pt_handler)
+		uffd_stop_demand_paging(pt_uffd);
+	if (test->uffd_data_handler)
+		uffd_stop_demand_paging(data_uffd);
+
+	free(pt_args.copy);
+	free(data_args.copy);
+}
+
+/* Returns false if the test should be skipped. */
 static bool punch_hole_in_memslot(struct kvm_vm *vm,
 				  struct userspace_mem_region *region)
 {
@@ -407,6 +519,11 @@ static void setup_memslots(struct kvm_vm *vm, struct test_params *p)
 	vm->memslots[MEM_REGION_TEST_DATA] = TEST_DATA_MEMSLOT;
 }
 
+static void check_event_counts(struct test_desc *test)
+{
+	ASSERT_EQ(test->expected_events.uffd_faults, events.uffd_faults);
+}
+
 static void print_test_banner(enum vm_guest_mode mode, struct test_params *p)
 {
 	struct test_desc *test = p->test_desc;
@@ -417,12 +534,17 @@ static void print_test_banner(enum vm_guest_mode mode, struct test_params *p)
 			vm_mem_backing_src_alias(p->src_type)->name);
 }
 
+static void reset_event_counts(void)
+{
+	memset(&events, 0, sizeof(events));
+}
+
 /*
  * This function either succeeds, skips the test (after setting test->skip), or
  * fails with a TEST_FAIL that aborts all tests.
  */
 static void vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
-			  struct test_desc *test)
+		struct test_desc *test)
 {
 	struct ucall uc;
 
@@ -457,6 +579,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct test_desc *test = p->test_desc;
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
+	struct uffd_desc *pt_uffd, *data_uffd;
 
 	print_test_banner(mode, p);
 
@@ -469,7 +592,16 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	ucall_init(vm, NULL);
 
+	reset_event_counts();
+
+	/*
+	 * Set some code in the data memslot for the guest to execute (only
+	 * applicable to the EXEC tests). This has to be done before
+	 * setup_uffd() as that function copies the memslot data for the uffd
+	 * handler.
+	 */
 	load_exec_code_for_test(vm);
+	setup_uffd(vm, p, &pt_uffd, &data_uffd);
 	setup_abort_handlers(vm, vcpu, test);
 	vcpu_args_set(vcpu, 1, test);
 
@@ -477,6 +609,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	ucall_uninit(vm);
 	kvm_vm_free(vm);
+	free_uffd(test, pt_uffd, data_uffd);
+
+	/*
+	 * Make sure we check the events after the uffd threads have exited,
+	 * which means they updated their respective event counters.
+	 */
+	if (!test->skip)
+		check_event_counts(test);
 }
 
 static void help(char *name)
@@ -492,6 +632,7 @@ static void help(char *name)
 #define SNAME(s)			#s
 #define SCAT2(a, b)			SNAME(a ## _ ## b)
 #define SCAT3(a, b, c)			SCAT2(a, SCAT2(b, c))
+#define SCAT4(a, b, c, d)		SCAT2(a, SCAT3(b, c, d))
 
 #define _CHECK(_test)			_CHECK_##_test
 #define _PREPARE(_test)			_PREPARE_##_test
@@ -510,7 +651,7 @@ static void help(char *name)
 #define _CHECK_with_af			guest_check_pte_af
 #define _CHECK_no_af			NULL
 
-/* Performs an access and checks that no faults were triggered. */
+/* Performs an access and checks that no faults (no events) were triggered. */
 #define TEST_ACCESS(_access, _with_af, _mark_cmd)				\
 {										\
 	.name			= SCAT3(_access, _with_af, #_mark_cmd),		\
@@ -519,6 +660,21 @@ static void help(char *name)
 	.mem_mark_cmd		= _mark_cmd,					\
 	.guest_test		= _access,					\
 	.guest_test_check	= { _CHECK(_with_af) },				\
+	.expected_events	= { 0 },					\
+}
+
+#define TEST_UFFD(_access, _with_af, _mark_cmd,					\
+		  _uffd_data_handler, _uffd_pt_handler, _uffd_faults)		\
+{										\
+	.name			= SCAT4(uffd, _access, _with_af, #_mark_cmd),	\
+	.guest_prepare		= { _PREPARE(_with_af),				\
+				    _PREPARE(_access) },			\
+	.guest_test		= _access,					\
+	.mem_mark_cmd		= _mark_cmd,					\
+	.guest_test_check	= { _CHECK(_with_af) },				\
+	.uffd_data_handler	= _uffd_data_handler,				\
+	.uffd_pt_handler	= _uffd_pt_handler,				\
+	.expected_events	= { .uffd_faults = _uffd_faults, },		\
 }
 
 static struct test_desc tests[] = {
@@ -544,6 +700,36 @@ static struct test_desc tests[] = {
 	TEST_ACCESS(guest_at, no_af, CMD_HOLE_DATA),
 	TEST_ACCESS(guest_dc_zva, no_af, CMD_HOLE_DATA),
 
+	/*
+	 * Punch holes in the test and PT memslots and mark them for
+	 * userfaultfd handling. This should result in 2 faults: the test
+	 * access and its respective S1 page table walk (S1PTW).
+	 */
+	TEST_UFFD(guest_read64, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
+			uffd_data_read_handler, uffd_pt_write_handler, 2),
+	/* no_af should also lead to a PT write. */
+	TEST_UFFD(guest_read64, no_af, CMD_HOLE_DATA | CMD_HOLE_PT,
+			uffd_data_read_handler, uffd_pt_write_handler, 2),
+	/* Note how that cas invokes the read handler. */
+	TEST_UFFD(guest_cas, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
+			uffd_data_read_handler, uffd_pt_write_handler, 2),
+	/*
+	 * Can't test guest_at with_af as it's IMPDEF whether the AF is set.
+	 * The S1PTW fault should still be marked as a write.
+	 */
+	TEST_UFFD(guest_at, no_af, CMD_HOLE_DATA | CMD_HOLE_PT,
+			uffd_data_read_handler, uffd_pt_write_handler, 1),
+	TEST_UFFD(guest_ld_preidx, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
+			uffd_data_read_handler, uffd_pt_write_handler, 2),
+	TEST_UFFD(guest_write64, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
+			uffd_data_write_handler, uffd_pt_write_handler, 2),
+	TEST_UFFD(guest_dc_zva, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
+			uffd_data_write_handler, uffd_pt_write_handler, 2),
+	TEST_UFFD(guest_st_preidx, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
+			uffd_data_write_handler, uffd_pt_write_handler, 2),
+	TEST_UFFD(guest_exec, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
+			uffd_data_read_handler, uffd_pt_write_handler, 2),
+
 	{ 0 }
 };
 
-- 
2.37.3.968.ga6b4b080e4-goog

