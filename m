Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEAC494002
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 19:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356816AbiASSey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 13:34:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:24524 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245537AbiASSev (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 13:34:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642617290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7uL7ekrVpGyd9wrE+wQZfiU/sOhWuXp4UEaXWZQzwgQ=;
        b=RpGVJR7cLBya3mEQezWrNxgccTUqsiY3Uwu+NoUNyTbRdabxMA4/XlSg+0GsIvuPj+LQ/t
        mvVBHcbJsReW4jJI9pYnjO4ojSO7+SA0nlTMVHuq7Oq5j8UCSSSncOjtzd+PtIkEKD7Q5+
        uVX8gc03MVZFa9JtgmCxe2a/ine7qCQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-R4LvpXdbNkqOtepLIVekqw-1; Wed, 19 Jan 2022 13:34:45 -0500
X-MC-Unique: R4LvpXdbNkqOtepLIVekqw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B1B21006AA5;
        Wed, 19 Jan 2022 18:34:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA1957D3E1;
        Wed, 19 Jan 2022 18:34:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     yang.zhong@intel.com, seanjc@google.com
Subject: [PATCH] kvm: selftests: Do not indent with spaces
Date:   Wed, 19 Jan 2022 13:34:43 -0500
Message-Id: <20220119183443.1628596-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some indentation with spaces crept in, likely due to terminal-based
cut and paste.  Clean it up.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 10 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c    |  8 ++-
 .../selftests/kvm/lib/x86_64/processor.c      | 60 +++++++++----------
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |  4 +-
 .../kvm/x86_64/vmx_close_while_nested_test.c  |  4 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 34 +++++------
 6 files changed, 61 insertions(+), 59 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 122447827954..423d8a61bd2e 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -368,14 +368,14 @@ bool is_amd_cpu(void);
 
 static inline unsigned int x86_family(unsigned int eax)
 {
-        unsigned int x86;
+	unsigned int x86;
 
-        x86 = (eax >> 8) & 0xf;
+	x86 = (eax >> 8) & 0xf;
 
-        if (x86 == 0xf)
-                x86 += (eax >> 20) & 0xff;
+	if (x86 == 0xf)
+		x86 += (eax >> 20) & 0xff;
 
-        return x86;
+	return x86;
 }
 
 static inline unsigned int x86_model(unsigned int eax)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index c22a17aac6b0..8c53f96ab7fe 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -499,9 +499,11 @@ void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log)
 void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
 			    uint64_t first_page, uint32_t num_pages)
 {
-	struct kvm_clear_dirty_log args = { .dirty_bitmap = log, .slot = slot,
-		                            .first_page = first_page,
-	                                    .num_pages = num_pages };
+	struct kvm_clear_dirty_log args = {
+		.dirty_bitmap = log, .slot = slot,
+		.first_page = first_page,
+		.num_pages = num_pages
+	};
 	int ret;
 
 	ret = ioctl(vm->fd, KVM_CLEAR_DIRTY_LOG, &args);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 59dcfe1967cc..5c8c270a9158 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1144,25 +1144,25 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
 	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
 	list->nmsrs = nmsrs;
 	r = ioctl(vm->kvm_fd, KVM_GET_MSR_INDEX_LIST, list);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_MSR_INDEX_LIST, r: %i",
-                r);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_MSR_INDEX_LIST, r: %i",
+		    r);
 
 	state = malloc(sizeof(*state) + nmsrs * sizeof(state->msrs.entries[0]));
 	r = ioctl(vcpu->fd, KVM_GET_VCPU_EVENTS, &state->events);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_VCPU_EVENTS, r: %i",
-                r);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_VCPU_EVENTS, r: %i",
+		    r);
 
 	r = ioctl(vcpu->fd, KVM_GET_MP_STATE, &state->mp_state);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_MP_STATE, r: %i",
-                r);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_MP_STATE, r: %i",
+		    r);
 
 	r = ioctl(vcpu->fd, KVM_GET_REGS, &state->regs);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_REGS, r: %i",
-                r);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_REGS, r: %i",
+		    r);
 
 	r = vcpu_save_xsave_state(vm, vcpu, state);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_XSAVE, r: %i",
-                r);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_XSAVE, r: %i",
+		    r);
 
 	if (kvm_check_cap(KVM_CAP_XCRS)) {
 		r = ioctl(vcpu->fd, KVM_GET_XCRS, &state->xcrs);
@@ -1171,17 +1171,17 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
 	}
 
 	r = ioctl(vcpu->fd, KVM_GET_SREGS, &state->sregs);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_SREGS, r: %i",
-                r);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_SREGS, r: %i",
+		    r);
 
 	if (nested_size) {
 		state->nested.size = sizeof(state->nested_);
 		r = ioctl(vcpu->fd, KVM_GET_NESTED_STATE, &state->nested);
 		TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_NESTED_STATE, r: %i",
-			r);
+			    r);
 		TEST_ASSERT(state->nested.size <= nested_size,
-			"Nested state size too big, %i (KVM_CHECK_CAP gave %i)",
-			state->nested.size, nested_size);
+			    "Nested state size too big, %i (KVM_CHECK_CAP gave %i)",
+			    state->nested.size, nested_size);
 	} else
 		state->nested.size = 0;
 
@@ -1189,12 +1189,12 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
 	for (i = 0; i < nmsrs; i++)
 		state->msrs.entries[i].index = list->indices[i];
 	r = ioctl(vcpu->fd, KVM_GET_MSRS, &state->msrs);
-        TEST_ASSERT(r == nmsrs, "Unexpected result from KVM_GET_MSRS, r: %i (failed MSR was 0x%x)",
-                r, r == nmsrs ? -1 : list->indices[r]);
+	TEST_ASSERT(r == nmsrs, "Unexpected result from KVM_GET_MSRS, r: %i (failed MSR was 0x%x)",
+		    r, r == nmsrs ? -1 : list->indices[r]);
 
 	r = ioctl(vcpu->fd, KVM_GET_DEBUGREGS, &state->debugregs);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_DEBUGREGS, r: %i",
-                r);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_DEBUGREGS, r: %i",
+		    r);
 
 	free(list);
 	return state;
@@ -1207,7 +1207,7 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
 
 	r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
 	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i",
-                r);
+		    r);
 
 	r = ioctl(vcpu->fd, KVM_SET_MSRS, &state->msrs);
 	TEST_ASSERT(r == state->msrs.nmsrs,
@@ -1222,28 +1222,28 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
 
 	r = ioctl(vcpu->fd, KVM_SET_XSAVE, state->xsave);
 	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i",
-                r);
+		    r);
 
 	r = ioctl(vcpu->fd, KVM_SET_VCPU_EVENTS, &state->events);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_VCPU_EVENTS, r: %i",
-                r);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_VCPU_EVENTS, r: %i",
+		    r);
 
 	r = ioctl(vcpu->fd, KVM_SET_MP_STATE, &state->mp_state);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_MP_STATE, r: %i",
-                r);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_MP_STATE, r: %i",
+		    r);
 
 	r = ioctl(vcpu->fd, KVM_SET_DEBUGREGS, &state->debugregs);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_DEBUGREGS, r: %i",
-                r);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_DEBUGREGS, r: %i",
+		    r);
 
 	r = ioctl(vcpu->fd, KVM_SET_REGS, &state->regs);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_REGS, r: %i",
-                r);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_REGS, r: %i",
+		    r);
 
 	if (state->nested.size) {
 		r = ioctl(vcpu->fd, KVM_SET_NESTED_STATE, &state->nested);
 		TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_NESTED_STATE, r: %i",
-			r);
+			    r);
 	}
 }
 
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
index 5a6a662f2e59..a426078b16a3 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
@@ -77,8 +77,8 @@ static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid, int stage)
 	switch (get_ucall(vm, vcpuid, &uc)) {
 	case UCALL_SYNC:
 		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
-                            uc.args[1] == stage + 1, "Stage %d: Unexpected register values vmexit, got %lx",
-                            stage + 1, (ulong)uc.args[1]);
+			    uc.args[1] == stage + 1, "Stage %d: Unexpected register values vmexit, got %lx",
+			    stage + 1, (ulong)uc.args[1]);
 		return;
 	case UCALL_DONE:
 		return;
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
index 2835a17f1b7a..edac8839e717 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
@@ -30,8 +30,8 @@ static struct kvm_vm *vm;
 static void l2_guest_code(void)
 {
 	/* Exit to L0 */
-        asm volatile("inb %%dx, %%al"
-                     : : [port] "d" (PORT_L0_EXIT) : "rax");
+	asm volatile("inb %%dx, %%al"
+		     : : [port] "d" (PORT_L0_EXIT) : "rax");
 }
 
 static void l1_guest_code(struct vmx_pages *vmx_pages)
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 478e0ae8b93e..865e17146815 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -46,20 +46,20 @@ static struct kvm_vm *vm;
 #define MIN_STEAL_TIME		50000
 
 struct pvclock_vcpu_time_info {
-        u32   version;
-        u32   pad0;
-        u64   tsc_timestamp;
-        u64   system_time;
-        u32   tsc_to_system_mul;
-        s8    tsc_shift;
-        u8    flags;
-        u8    pad[2];
+	u32   version;
+	u32   pad0;
+	u64   tsc_timestamp;
+	u64   system_time;
+	u32   tsc_to_system_mul;
+	s8    tsc_shift;
+	u8    flags;
+	u8    pad[2];
 } __attribute__((__packed__)); /* 32 bytes */
 
 struct pvclock_wall_clock {
-        u32   version;
-        u32   sec;
-        u32   nsec;
+	u32   version;
+	u32   sec;
+	u32   nsec;
 } __attribute__((__packed__));
 
 struct vcpu_runstate_info {
@@ -74,11 +74,11 @@ struct arch_vcpu_info {
 };
 
 struct vcpu_info {
-        uint8_t evtchn_upcall_pending;
-        uint8_t evtchn_upcall_mask;
-        unsigned long evtchn_pending_sel;
-        struct arch_vcpu_info arch;
-        struct pvclock_vcpu_time_info time;
+	uint8_t evtchn_upcall_pending;
+	uint8_t evtchn_upcall_mask;
+	unsigned long evtchn_pending_sel;
+	struct arch_vcpu_info arch;
+	struct pvclock_vcpu_time_info time;
 }; /* 64 bytes (x86) */
 
 struct shared_info {
@@ -493,7 +493,7 @@ int main(int argc, char *argv[])
 
 	vm_ts.tv_sec = wc->sec;
 	vm_ts.tv_nsec = wc->nsec;
-        TEST_ASSERT(wc->version && !(wc->version & 1),
+	TEST_ASSERT(wc->version && !(wc->version & 1),
 		    "Bad wallclock version %x", wc->version);
 	TEST_ASSERT(cmp_timespec(&min_ts, &vm_ts) <= 0, "VM time too old");
 	TEST_ASSERT(cmp_timespec(&max_ts, &vm_ts) >= 0, "VM time too new");
-- 
2.31.1

