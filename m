Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14CBA12868B
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 03:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfLUCE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 21:04:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20998 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726847AbfLUCE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 21:04:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576893897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WLmQ8TyXKCLVZ9KK4lxcbEuustqO7Se5qnqDEjLmEjI=;
        b=Vsm53kgqxCCb/q13Csy7gIM68k5OLVsWeTATt6DDnDn10UFZ0rnBct2OCfUzIQzkA1l39R
        1GjZ2/VSF1Ti7HdMNNQONWxyOJNw8sK+F2QOpQgQ7pfanW40hwFftU8LWI98Fx9pIYC1uj
        ZqJ3eBjvfubsbqqpcUmSDcZjNg0XB58=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-r8Jkl3cCNWa9Jgi1bDM37Q-1; Fri, 20 Dec 2019 21:04:56 -0500
X-MC-Unique: r8Jkl3cCNWa9Jgi1bDM37Q-1
Received: by mail-qk1-f197.google.com with SMTP id i135so6472498qke.14
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 18:04:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WLmQ8TyXKCLVZ9KK4lxcbEuustqO7Se5qnqDEjLmEjI=;
        b=Ciy+rtqQfM04/9XY8hGJ+SNDSBm11Jj75Jj9w35fzOs9TqxLjwZ+mdNUhEaGL/ILkX
         b2jmA3+vOx5jDfEA88ERSpwARlINf4mkONBX4ulf0wZ4gAvCTRnpTxZrlgIu6j270C8D
         C6a99tZshGbfO0Ya+7rc3H98DyI25E93WWqtSXiNDvND7oYpU0HYowoOF9ljOB9aQOXd
         1nN17OFDJu5PuWdRa5MZ6EU8Z7bQOGPWCDf1/F300yyQ5BPC1lSbNTRsi9PnrgLFFZaM
         KkLUoepHWU1qOjaE+G5rajb6N7arKsvr8YA/Vm0Bk/+ZHVHnvfzLaiHpFlu31ExcTlXX
         veIQ==
X-Gm-Message-State: APjAAAWyEpcc+yWTGDILIu3ISGLdLVFr8/CKdMRYzFiYmIRLR3NalCNq
        Neo62cWt0AB3UZE0dPhSRuwUyI5JbGDphI7/f5sCQKmfTtc1qp0g/DIQxQKCr2eUnkDEiCiDl44
        hgKOTmQIRxkTS
X-Received: by 2002:a05:6214:923:: with SMTP id dk3mr14496150qvb.96.1576893895673;
        Fri, 20 Dec 2019 18:04:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqyVu6khjbXguUutuhYrV6LFzUFWeAA/La1OzSXBUeq3PifaiHzjWXjVPdu83lYMGEHaT2O88Q==
X-Received: by 2002:a05:6214:923:: with SMTP id dk3mr14496114qvb.96.1576893895111;
        Fri, 20 Dec 2019 18:04:55 -0800 (PST)
Received: from xz-x1.hitronhub.home ([2607:9880:19c0:3f::2])
        by smtp.gmail.com with ESMTPSA id t7sm3400114qkm.136.2019.12.20.18.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 18:04:54 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Dr David Alan Gilbert <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RESEND v2 15/17] KVM: selftests: Add dirty ring buffer test
Date:   Fri, 20 Dec 2019 21:04:43 -0500
Message-Id: <20191221020445.60476-5-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221014938.58831-1-peterx@redhat.com>
References: <20191221020445.60476-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the initial dirty ring buffer test.

The current test implements the userspace dirty ring collection, by
only reaping the dirty ring when the ring is full.

So it's still running asynchronously like this:

            vcpu                             main thread

  1. vcpu dirties pages
  2. vcpu gets dirty ring full
     (userspace exit)

                                       3. main thread waits until full
                                          (so hardware buffers flushed)
                                       4. main thread collects
                                       5. main thread continues vcpu

  6. vcpu continues, goes back to 1

We can't directly collects dirty bits during vcpu execution because
otherwise we can't guarantee the hardware dirty bits were flushed when
we collect and we're very strict on the dirty bits so otherwise we can
fail the future verify procedure.  A follow up patch will make this
test to support async just like the existing dirty log test, by adding
a vcpu kick mechanism.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  | 174 +++++++++++++++++-
 .../testing/selftests/kvm/include/kvm_util.h  |   3 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  56 ++++++
 .../selftests/kvm/lib/kvm_util_internal.h     |   3 +
 4 files changed, 234 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 3542311f56ff..af9b1a16c7d1 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -12,8 +12,10 @@
 #include <unistd.h>
 #include <time.h>
 #include <pthread.h>
+#include <semaphore.h>
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
+#include <asm/barrier.h>
 
 #include "test_util.h"
 #include "kvm_util.h"
@@ -57,6 +59,8 @@
 # define test_and_clear_bit_le	test_and_clear_bit
 #endif
 
+#define TEST_DIRTY_RING_COUNT		1024
+
 /*
  * Guest/Host shared variables. Ensure addr_gva2hva() and/or
  * sync_global_to/from_guest() are used when accessing from
@@ -128,6 +132,10 @@ static uint64_t host_dirty_count;
 static uint64_t host_clear_count;
 static uint64_t host_track_next_count;
 
+/* Whether dirty ring reset is requested, or finished */
+static sem_t dirty_ring_vcpu_stop;
+static sem_t dirty_ring_vcpu_cont;
+
 enum log_mode_t {
 	/* Only use KVM_GET_DIRTY_LOG for logging */
 	LOG_MODE_DIRTY_LOG = 0,
@@ -135,6 +143,9 @@ enum log_mode_t {
 	/* Use both KVM_[GET|CLEAR]_DIRTY_LOG for logging */
 	LOG_MODE_CLERA_LOG = 1,
 
+	/* Use dirty ring for logging */
+	LOG_MODE_DIRTY_RING = 2,
+
 	LOG_MODE_NUM,
 };
 
@@ -177,6 +188,118 @@ static void default_after_vcpu_run(struct kvm_vm *vm)
 		    exit_reason_str(run->exit_reason));
 }
 
+static void dirty_ring_create_vm_done(struct kvm_vm *vm)
+{
+	/*
+	 * Switch to dirty ring mode after VM creation but before any
+	 * of the vcpu creation.
+	 */
+	vm_enable_dirty_ring(vm, TEST_DIRTY_RING_COUNT *
+			     sizeof(struct kvm_dirty_gfn));
+}
+
+static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
+				       struct kvm_dirty_ring_indices *indices,
+				       int slot, void *bitmap,
+				       uint32_t num_pages, int index)
+{
+	struct kvm_dirty_gfn *cur;
+	uint32_t avail, fetch, count = 0;
+
+	/*
+	 * We should keep it somewhere, but to be simple we read
+	 * fetch_index too.
+	 */
+	fetch = READ_ONCE(indices->fetch_index);
+	avail = READ_ONCE(indices->avail_index);
+
+	/* Make sure we read valid entries always */
+	rmb();
+
+	DEBUG("ring %d: fetch: 0x%x, avail: 0x%x\n", index, fetch, avail);
+
+	while (fetch != avail) {
+		cur = &dirty_gfns[fetch % TEST_DIRTY_RING_COUNT];
+		TEST_ASSERT(cur->pad == 0, "Padding is non-zero: 0x%x", cur->pad);
+		TEST_ASSERT(cur->slot == slot, "Slot number didn't match: "
+			    "%u != %u", cur->slot, slot);
+		TEST_ASSERT(cur->offset < num_pages, "Offset overflow: "
+			    "0x%llx >= 0x%llx", cur->offset, num_pages);
+		DEBUG("fetch 0x%x offset 0x%llx\n", fetch, cur->offset);
+		test_and_set_bit(cur->offset, bitmap);
+		fetch++;
+		count++;
+	}
+	WRITE_ONCE(indices->fetch_index, fetch);
+
+	return count;
+}
+
+static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
+					   void *bitmap, uint32_t num_pages)
+{
+	/* We only have one vcpu */
+	struct kvm_run *state = vcpu_state(vm, VCPU_ID);
+	uint32_t count = 0, cleared;
+
+	/*
+	 * Before fetching the dirty pages, we need a vmexit of the
+	 * worker vcpu to make sure the hardware dirty buffers were
+	 * flushed.  This is not needed for dirty-log/clear-log tests
+	 * because get dirty log will natually do so.
+	 *
+	 * For now we do it in the simple way - we simply wait until
+	 * the vcpu uses up the soft dirty ring, then it'll always
+	 * do a vmexit to make sure that PML buffers will be flushed.
+	 * In real hypervisors, we probably need a vcpu kick or to
+	 * stop the vcpus (before the final sync) to make sure we'll
+	 * get all the existing dirty PFNs even cached in hardware.
+	 */
+	sem_wait(&dirty_ring_vcpu_stop);
+
+	/* Only have one vcpu */
+	count = dirty_ring_collect_one(vcpu_map_dirty_ring(vm, VCPU_ID),
+				       &state->vcpu_ring_indices,
+				       slot, bitmap, num_pages, VCPU_ID);
+
+	cleared = kvm_vm_reset_dirty_ring(vm);
+
+	/* Cleared pages should be the same as collected */
+	TEST_ASSERT(cleared == count, "Reset dirty pages (%u) mismatch "
+		    "with collected (%u)", cleared, count);
+
+	DEBUG("Notifying vcpu to continue\n");
+	sem_post(&dirty_ring_vcpu_cont);
+
+	DEBUG("Iteration %ld collected %u pages\n", iteration, count);
+}
+
+static void dirty_ring_after_vcpu_run(struct kvm_vm *vm)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+
+	/* A ucall-sync or ring-full event is allowed */
+	if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
+		/* We should allow this to continue */
+		;
+	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL) {
+		sem_post(&dirty_ring_vcpu_stop);
+		DEBUG("vcpu stops because dirty ring full...\n");
+		sem_wait(&dirty_ring_vcpu_cont);
+		DEBUG("vcpu continues now.\n");
+	} else {
+		TEST_ASSERT(false, "Invalid guest sync status: "
+			    "exit_reason=%s\n",
+			    exit_reason_str(run->exit_reason));
+	}
+}
+
+static void dirty_ring_before_vcpu_join(void)
+{
+	/* Kick another round of vcpu just to make sure it will quit */
+	sem_post(&dirty_ring_vcpu_cont);
+}
+
 struct log_mode {
 	const char *name;
 	/* Hook when the vm creation is done (before vcpu creation) */
@@ -186,6 +309,7 @@ struct log_mode {
 				     void *bitmap, uint32_t num_pages);
 	/* Hook to call when after each vcpu run */
 	void (*after_vcpu_run)(struct kvm_vm *vm);
+	void (*before_vcpu_join) (void);
 } log_modes[LOG_MODE_NUM] = {
 	{
 		.name = "dirty-log",
@@ -199,6 +323,13 @@ struct log_mode {
 		.collect_dirty_pages = clear_log_collect_dirty_pages,
 		.after_vcpu_run = default_after_vcpu_run,
 	},
+	{
+		.name = "dirty-ring",
+		.create_vm_done = dirty_ring_create_vm_done,
+		.collect_dirty_pages = dirty_ring_collect_dirty_pages,
+		.before_vcpu_join = dirty_ring_before_vcpu_join,
+		.after_vcpu_run = dirty_ring_after_vcpu_run,
+	},
 };
 
 /*
@@ -245,6 +376,14 @@ static void log_mode_after_vcpu_run(struct kvm_vm *vm)
 		mode->after_vcpu_run(vm);
 }
 
+static void log_mode_before_vcpu_join(void)
+{
+	struct log_mode *mode = &log_modes[host_log_mode];
+
+	if (mode->before_vcpu_join)
+		mode->before_vcpu_join();
+}
+
 static void generate_random_array(uint64_t *guest_array, uint64_t size)
 {
 	uint64_t i;
@@ -292,14 +431,41 @@ static void vm_dirty_log_verify(unsigned long *bmap)
 		}
 
 		if (test_and_clear_bit_le(page, bmap)) {
+			bool matched;
+
 			host_dirty_count++;
+
 			/*
 			 * If the bit is set, the value written onto
 			 * the corresponding page should be either the
 			 * previous iteration number or the current one.
+			 *
+			 * (*value_ptr == iteration - 2) case is
+			 * special only for dirty ring test where the
+			 * page is the last page before a kvm dirty
+			 * ring full userspace exit of the 2nd
+			 * iteration, if without this we'll probably
+			 * fail on the 4th iteration.  Anyway, let's
+			 * just loose the test case a little bit for
+			 * all for simplicity.
 			 */
-			TEST_ASSERT(*value_ptr == iteration ||
-				    *value_ptr == iteration - 1,
+			matched = (*value_ptr == iteration ||
+				   *value_ptr == iteration - 1 ||
+				   *value_ptr == iteration - 2);
+
+			/*
+			 * This is the common path for dirty ring
+			 * where this page is exactly the last page
+			 * touched before KVM_EXIT_DIRTY_RING_FULL.
+			 * If it happens, we should expect it to be
+			 * there for the next round.
+			 */
+			if (host_log_mode == LOG_MODE_DIRTY_RING && !matched) {
+				set_bit_le(page, host_bmap_track);
+				continue;
+			}
+
+			TEST_ASSERT(matched,
 				    "Set page %"PRIu64" value %"PRIu64
 				    " incorrect (iteration=%"PRIu64")",
 				    page, *value_ptr, iteration);
@@ -460,6 +626,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 
 	/* Tell the vcpu thread to quit */
 	host_quit = true;
+	log_mode_before_vcpu_join();
 	pthread_join(vcpu_thread, NULL);
 
 	DEBUG("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
@@ -524,6 +691,9 @@ int main(int argc, char *argv[])
 	unsigned int host_ipa_limit;
 #endif
 
+	sem_init(&dirty_ring_vcpu_stop, 0, 0);
+	sem_init(&dirty_ring_vcpu_cont, 0, 0);
+
 #ifdef __x86_64__
 	vm_guest_mode_params_init(VM_MODE_PXXV48_4K, true, true);
 #endif
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 29cccaf96baf..4b78a8d3e773 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -67,6 +67,7 @@ enum vm_mem_backing_src_type {
 
 int kvm_check_cap(long cap);
 int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
+void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
 
 struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
 struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
@@ -76,6 +77,7 @@ void kvm_vm_release(struct kvm_vm *vmp);
 void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log);
 void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
 			    uint64_t first_page, uint32_t num_pages);
+uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm);
 
 int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, const vm_vaddr_t gva,
 		       size_t len);
@@ -137,6 +139,7 @@ void vcpu_nested_state_get(struct kvm_vm *vm, uint32_t vcpuid,
 int vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
 			  struct kvm_nested_state *state, bool ignore_error);
 #endif
+void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid);
 
 const char *exit_reason_str(unsigned int exit_reason);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 41cf45416060..a119717bc84c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -85,6 +85,26 @@ int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
 	return ret;
 }
 
+void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
+{
+	struct kvm_enable_cap cap = {};
+	int ret;
+
+	ret = kvm_check_cap(KVM_CAP_DIRTY_LOG_RING);
+
+	TEST_ASSERT(ret >= 0, "KVM_CAP_DIRTY_LOG_RING");
+
+	if (ret == 0) {
+		fprintf(stderr, "KVM does not support dirty ring, skipping tests\n");
+		exit(KSFT_SKIP);
+	}
+
+	cap.cap = KVM_CAP_DIRTY_LOG_RING;
+	cap.args[0] = ring_size;
+	vm_enable_cap(vm, &cap);
+	vm->dirty_ring_size = ring_size;
+}
+
 static void vm_open(struct kvm_vm *vm, int perm)
 {
 	vm->kvm_fd = open(KVM_DEV_PATH, perm);
@@ -297,6 +317,11 @@ void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
 		    strerror(-ret));
 }
 
+uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm)
+{
+	return ioctl(vm->fd, KVM_RESET_DIRTY_RINGS);
+}
+
 /*
  * Userspace Memory Region Find
  *
@@ -408,6 +433,13 @@ static void vm_vcpu_rm(struct kvm_vm *vm, uint32_t vcpuid)
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	int ret;
 
+	if (vcpu->dirty_gfns) {
+		ret = munmap(vcpu->dirty_gfns, vm->dirty_ring_size);
+		TEST_ASSERT(ret == 0, "munmap of VCPU dirty ring failed, "
+			    "rc: %i errno: %i", ret, errno);
+		vcpu->dirty_gfns = NULL;
+	}
+
 	ret = munmap(vcpu->state, sizeof(*vcpu->state));
 	TEST_ASSERT(ret == 0, "munmap of VCPU fd failed, rc: %i "
 		"errno: %i", ret, errno);
@@ -1409,6 +1441,29 @@ int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid,
 	return ret;
 }
 
+void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	struct vcpu *vcpu;
+	uint32_t size = vm->dirty_ring_size;
+
+	TEST_ASSERT(size > 0, "Should enable dirty ring first");
+
+	vcpu = vcpu_find(vm, vcpuid);
+
+	TEST_ASSERT(vcpu, "Cannot find vcpu %u", vcpuid);
+
+	if (!vcpu->dirty_gfns) {
+		vcpu->dirty_gfns_count = size / sizeof(struct kvm_dirty_gfn);
+		vcpu->dirty_gfns = mmap(NULL, size, PROT_READ | PROT_WRITE,
+					MAP_SHARED, vcpu->fd, vm->page_size *
+					KVM_DIRTY_LOG_PAGE_OFFSET);
+		TEST_ASSERT(vcpu->dirty_gfns != MAP_FAILED,
+			    "Dirty ring map failed");
+	}
+
+	return vcpu->dirty_gfns;
+}
+
 /*
  * VM Ioctl
  *
@@ -1503,6 +1558,7 @@ static struct exit_reason {
 	{KVM_EXIT_INTERNAL_ERROR, "INTERNAL_ERROR"},
 	{KVM_EXIT_OSI, "OSI"},
 	{KVM_EXIT_PAPR_HCALL, "PAPR_HCALL"},
+	{KVM_EXIT_DIRTY_RING_FULL, "DIRTY_RING_FULL"},
 #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
 	{KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
 #endif
diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
index ac50c42750cf..87edcc6746a2 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -39,6 +39,8 @@ struct vcpu {
 	uint32_t id;
 	int fd;
 	struct kvm_run *state;
+	struct kvm_dirty_gfn *dirty_gfns;
+	uint32_t dirty_gfns_count;
 };
 
 struct kvm_vm {
@@ -61,6 +63,7 @@ struct kvm_vm {
 	vm_paddr_t pgd;
 	vm_vaddr_t gdt;
 	vm_vaddr_t tss;
+	uint32_t dirty_ring_size;
 };
 
 struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid);
-- 
2.24.1

