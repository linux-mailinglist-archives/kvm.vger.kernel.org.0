Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B80F18A0B7
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 17:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbgCRQiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 12:38:51 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:49197 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727403AbgCRQiu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 12:38:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584549528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NTTx0gFt1BNQy9yz70eSWdBTHINTMtF2M6zpCrKtOpo=;
        b=PExcmVJMO8ntLvayKObHTBOEKznwENlDiZQQ0rMgnptrrdYfV6os97nI33Dmc2ddN+OjOn
        unO+LK+RzfeH9FsTRU1uqTm5qnMHQxL9sQ/gFnSbmyXn11jYGuUGc+CAioZ/fIr57mZfoR
        YaqRzskD1v3tdYHZyjs6WduCUAz5r/k=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-enLrDIveOsOm-Ytq7tVxXw-1; Wed, 18 Mar 2020 12:38:46 -0400
X-MC-Unique: enLrDIveOsOm-Ytq7tVxXw-1
Received: by mail-wr1-f72.google.com with SMTP id c6so12532789wrm.18
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 09:38:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NTTx0gFt1BNQy9yz70eSWdBTHINTMtF2M6zpCrKtOpo=;
        b=ZCeYpfi/go+KP3E463haWDKAEEUQtcWzCVR2IrdkdBIkuqAtKub4fv/aIzO4fDK6ll
         6wnjDgBwGqhBw9xGSiYZEaFchzeq9FWdZnfzRKIIOjQ60e0eyTZNJBsP1L+f63MyTG6a
         TCRI8uVQ6B5r4amAXBNgVt/IqxQCwm9fWTRmeWsbHBv0TL2nGNXg9aczgTh5Ukyn0T1S
         accpRek0ziMiiebdnp60lSPf+ihaTCc9Ys+zJTu15XGFjNALKZ9TZCwCGSwfwfsBWaHl
         /UZB8KV6SfM0Y57oKhkSCy2zCxA5wuQMooKop7rWrPY3BJxYgHH7L/bCYFUJ7PF83Orc
         gTtg==
X-Gm-Message-State: ANhLgQ1nb/rxcj44ng+VbZTox1CmdGhjafi2BqrX+1+kcE/6noQxq4dZ
        lAlikXl+CCKmlGJiWCEvqLLA/zgvRkZeEsAQLWB2GL3KgB0RXukPSqUID+Gpt9TJCipQIFALm3e
        lalIk1QVi0XhA
X-Received: by 2002:a1c:1b0e:: with SMTP id b14mr6028741wmb.8.1584549524935;
        Wed, 18 Mar 2020 09:38:44 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtp/Hn1AjQfOstPVVK0jJX5kQdaqLsn8LtHJ7HD9qqYWySVZGKCP6EdLauGoAif7XNwvCMsaw==
X-Received: by 2002:a1c:1b0e:: with SMTP id b14mr6028693wmb.8.1584549524436;
        Wed, 18 Mar 2020 09:38:44 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id s131sm4740901wmf.35.2020.03.18.09.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 09:38:43 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 12/14] KVM: selftests: Add dirty ring buffer test
Date:   Wed, 18 Mar 2020 12:37:18 -0400
Message-Id: <20200318163720.93929-13-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318163720.93929-1-peterx@redhat.com>
References: <20200318163720.93929-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the initial dirty ring buffer test.

The current test implements the userspace dirty ring collection, by
only reaping the dirty ring when the ring is full.

So it's still running synchronously like this:

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
 tools/testing/selftests/kvm/dirty_log_test.c  | 201 +++++++++++++++++-
 .../testing/selftests/kvm/include/kvm_util.h  |   3 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  59 +++++
 .../selftests/kvm/lib/kvm_util_internal.h     |   4 +
 4 files changed, 265 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 94122c2e0185..e5857128b7d3 100644
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
 	LOG_MODE_CLEAR_LOG = 1,
 
+	/* Use dirty ring for logging */
+	LOG_MODE_DIRTY_RING = 2,
+
 	LOG_MODE_NUM,
 
 	/* Run all supported modes */
@@ -187,6 +198,120 @@ static void default_after_vcpu_run(struct kvm_vm *vm)
 		    exit_reason_str(run->exit_reason));
 }
 
+static bool dirty_ring_supported(void)
+{
+	return kvm_check_cap(KVM_CAP_DIRTY_LOG_RING);
+}
+
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
+static inline bool dirty_gfn_is_dirtied(struct kvm_dirty_gfn *gfn)
+{
+	return gfn->flags == KVM_DIRTY_GFN_F_DIRTY;
+}
+
+static inline void dirty_gfn_set_collected(struct kvm_dirty_gfn *gfn)
+{
+	gfn->flags = KVM_DIRTY_GFN_F_RESET;
+}
+
+static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
+				       int slot, void *bitmap,
+				       uint32_t num_pages, uint32_t *fetch_index)
+{
+	struct kvm_dirty_gfn *cur;
+	uint32_t count = 0;
+
+	while (true) {
+		cur = &dirty_gfns[*fetch_index % TEST_DIRTY_RING_COUNT];
+		if (!dirty_gfn_is_dirtied(cur))
+			break;
+		TEST_ASSERT(cur->slot == slot, "Slot number didn't match: "
+			    "%u != %u", cur->slot, slot);
+		TEST_ASSERT(cur->offset < num_pages, "Offset overflow: "
+			    "0x%llx >= 0x%x", cur->offset, num_pages);
+		pr_info("fetch 0x%x page %llu\n", *fetch_index, cur->offset);
+		set_bit(cur->offset, bitmap);
+		dirty_gfn_set_collected(cur);
+		(*fetch_index)++;
+		count++;
+	}
+
+	return count;
+}
+
+static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
+					   void *bitmap, uint32_t num_pages)
+{
+	/* We only have one vcpu */
+	static uint32_t fetch_index = 0;
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
+				       slot, bitmap, num_pages, &fetch_index);
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
+	pr_info("Iteration %ld collected %u pages\n", iteration, count);
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
+		pr_info("vcpu stops because dirty ring full...\n");
+		sem_wait(&dirty_ring_vcpu_cont);
+		pr_info("vcpu continues now.\n");
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
 	/* Return true if this mode is supported, otherwise false */
@@ -198,6 +323,7 @@ struct log_mode {
 				     void *bitmap, uint32_t num_pages);
 	/* Hook to call when after each vcpu run */
 	void (*after_vcpu_run)(struct kvm_vm *vm);
+	void (*before_vcpu_join) (void);
 } log_modes[LOG_MODE_NUM] = {
 	{
 		.name = "dirty-log",
@@ -211,6 +337,14 @@ struct log_mode {
 		.collect_dirty_pages = clear_log_collect_dirty_pages,
 		.after_vcpu_run = default_after_vcpu_run,
 	},
+	{
+		.name = "dirty-ring",
+		.supported = dirty_ring_supported,
+		.create_vm_done = dirty_ring_create_vm_done,
+		.collect_dirty_pages = dirty_ring_collect_dirty_pages,
+		.before_vcpu_join = dirty_ring_before_vcpu_join,
+		.after_vcpu_run = dirty_ring_after_vcpu_run,
+	},
 };
 
 /*
@@ -268,6 +402,14 @@ static void log_mode_after_vcpu_run(struct kvm_vm *vm)
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
@@ -325,14 +467,65 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
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
 			 */
-			TEST_ASSERT(*value_ptr == iteration ||
-				    *value_ptr == iteration - 1,
+			matched = (*value_ptr == iteration ||
+				   *value_ptr == iteration - 1);
+
+			if (host_log_mode == LOG_MODE_DIRTY_RING && !matched) {
+				if (*value_ptr == iteration - 2) {
+					/*
+					 * Short answer: this case is special
+					 * only for dirty ring test where the
+					 * page is the last page before a kvm
+					 * dirty ring full in iteration N-2.
+					 *
+					 * Long answer: Assuming ring size R,
+					 * one possible condition is:
+					 *
+					 *      main thr       vcpu thr
+					 *      --------       --------
+					 *    iter=1
+					 *                   write 1 to page 0~(R-1)
+					 *                   full, vmexit
+					 *    collect 0~(R-1)
+					 *    kick vcpu
+					 *                   write 1 to (R-1)~(2R-2)
+					 *                   full, vmexit
+					 *    iter=2
+					 *    collect (R-1)~(2R-2)
+					 *    kick vcpu
+					 *                   write 1 to (2R-2)
+					 *                   (NOTE!!! "1" cached in cpu reg)
+					 *                   write 2 to (2R-1)~(3R-3)
+					 *                   full, vmexit
+					 *    iter=3
+					 *    collect (2R-2)~(3R-3)
+					 *    (here if we read value on page
+					 *     "2R-2" is 1, while iter=3!!!)
+					 */
+					matched = true;
+				} else {
+					/*
+					 * This is also special for dirty ring
+					 * when this page is exactly the last
+					 * page touched before vcpu ring full.
+					 * If it happens, we should expect the
+					 * value to change in the next round.
+					 */
+					set_bit_le(page, host_bmap_track);
+					continue;
+				}
+			}
+
+			TEST_ASSERT(matched,
 				    "Set page %"PRIu64" value %"PRIu64
 				    " incorrect (iteration=%"PRIu64")",
 				    page, *value_ptr, iteration);
@@ -495,6 +688,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 
 	/* Tell the vcpu thread to quit */
 	host_quit = true;
+	log_mode_before_vcpu_join();
 	pthread_join(vcpu_thread, NULL);
 
 	pr_info("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
@@ -555,6 +749,9 @@ int main(int argc, char *argv[])
 	unsigned int mode;
 	int opt, i, j;
 
+	sem_init(&dirty_ring_vcpu_stop, 0, 0);
+	sem_init(&dirty_ring_vcpu_cont, 0, 0);
+
 #ifdef __x86_64__
 	guest_mode_init(VM_MODE_PXXV48_4K, true, true);
 #endif
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a99b875f50d2..554fdb294bef 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -62,6 +62,7 @@ enum vm_mem_backing_src_type {
 
 int kvm_check_cap(long cap);
 int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
+void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
 
 struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
 struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
@@ -71,6 +72,7 @@ void kvm_vm_release(struct kvm_vm *vmp);
 void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log);
 void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
 			    uint64_t first_page, uint32_t num_pages);
+uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm);
 
 int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, const vm_vaddr_t gva,
 		       size_t len);
@@ -192,6 +194,7 @@ void vcpu_nested_state_get(struct kvm_vm *vm, uint32_t vcpuid,
 int vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
 			  struct kvm_nested_state *state, bool ignore_error);
 #endif
+void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid);
 
 const char *exit_reason_str(unsigned int exit_reason);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 0cf98ad59e32..19bcc239527b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -85,6 +85,16 @@ int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
 	return ret;
 }
 
+void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
+{
+	struct kvm_enable_cap cap = { 0 };
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
@@ -295,6 +305,11 @@ void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
 		    __func__, strerror(-ret));
 }
 
+uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm)
+{
+	return ioctl(vm->fd, KVM_RESET_DIRTY_RINGS);
+}
+
 /*
  * Userspace Memory Region Find
  *
@@ -406,6 +421,13 @@ static void vm_vcpu_rm(struct kvm_vm *vm, uint32_t vcpuid)
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
@@ -1475,6 +1497,42 @@ int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid,
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
+		void *addr;
+
+		addr = mmap(NULL, size, PROT_READ,
+			    MAP_PRIVATE, vcpu->fd,
+			    vm->page_size * KVM_DIRTY_LOG_PAGE_OFFSET);
+		TEST_ASSERT(addr == MAP_FAILED, "Dirty ring mapped private");
+
+		addr = mmap(NULL, size, PROT_READ | PROT_EXEC,
+			    MAP_PRIVATE, vcpu->fd,
+			    vm->page_size * KVM_DIRTY_LOG_PAGE_OFFSET);
+		TEST_ASSERT(addr == MAP_FAILED, "Dirty ring mapped exec");
+
+		addr = mmap(NULL, size, PROT_READ | PROT_WRITE,
+			    MAP_SHARED, vcpu->fd,
+			    vm->page_size * KVM_DIRTY_LOG_PAGE_OFFSET);
+		TEST_ASSERT(addr != MAP_FAILED, "Dirty ring map failed");
+
+		vcpu->dirty_gfns = addr;
+		vcpu->dirty_gfns_count = size / sizeof(struct kvm_dirty_gfn);
+	}
+
+	return vcpu->dirty_gfns;
+}
+
 /*
  * VM Ioctl
  *
@@ -1569,6 +1627,7 @@ static struct exit_reason {
 	{KVM_EXIT_INTERNAL_ERROR, "INTERNAL_ERROR"},
 	{KVM_EXIT_OSI, "OSI"},
 	{KVM_EXIT_PAPR_HCALL, "PAPR_HCALL"},
+	{KVM_EXIT_DIRTY_RING_FULL, "DIRTY_RING_FULL"},
 #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
 	{KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
 #endif
diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
index ca56a0133127..22c84d9c8b03 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -28,6 +28,9 @@ struct vcpu {
 	uint32_t id;
 	int fd;
 	struct kvm_run *state;
+	struct kvm_dirty_gfn *dirty_gfns;
+	uint32_t fetch_index;
+	uint32_t dirty_gfns_count;
 };
 
 struct kvm_vm {
@@ -50,6 +53,7 @@ struct kvm_vm {
 	vm_paddr_t pgd;
 	vm_vaddr_t gdt;
 	vm_vaddr_t tss;
+	uint32_t dirty_ring_size;
 };
 
 struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid);
-- 
2.24.1

