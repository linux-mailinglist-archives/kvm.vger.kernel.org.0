Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9F54927EB
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 15:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244572AbiAROBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 09:01:48 -0500
Received: from mga05.intel.com ([192.55.52.43]:21745 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244509AbiAROBq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 09:01:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642514506; x=1674050506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=booVRCTBRMdNFhmPbPbA4vDnNfpxfjM7d6DdtywqoCk=;
  b=Gs+gXwdrfrCB6YN0sWPVZEER38/fgtcGjDU+pYEwGZeI8pfsjxvTvapo
   Ewln44OVrWbaW+I4M9f7bblEKC7P1ow3ZeC0K+oOfaXE/hPd1hTSAnxRW
   nj+kheJCNvg8s0fMbaveE8skgH/7Zbp5BQoGdsjnPNMJnXRAjx7h7Tvzf
   4J6GWxqe6UeHjGV52vJzgeePMjvIDgypmBEeuD+wpfY8idqwfYQlmYADK
   M1DMX9F4oHO6wFnTF4FQrMtaEaDhI0TzCQznuwGfyZ33VAdpwKex2tMYq
   HOWcs4/qoM980iP3wk+AzgXiwNjltUfTYAGA56zAMhzbCyufunYKtvd6K
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="331169018"
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="331169018"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 06:01:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="530299059"
Received: from 984fee00bf64.jf.intel.com ([10.165.54.77])
  by fmsmga007.fm.intel.com with ESMTP; 18 Jan 2022 06:01:45 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yang.zhong@intel.com
Subject: [PATCH 2/2] kvm: selftests: Use tabs to replace spaces
Date:   Tue, 18 Jan 2022 06:01:44 -0800
Message-Id: <20220118140144.58855-3-yang.zhong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220118140144.58855-1-yang.zhong@intel.com>
References: <20220118140144.58855-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only cleanup this processor.c by using tabs to replace spaces.

Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 70 +++++++++----------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index babb0f28575c..6aaa95b76d81 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1136,25 +1136,25 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
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
@@ -1163,17 +1163,17 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
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
 
@@ -1181,12 +1181,12 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
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
@@ -1199,7 +1199,7 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
 
 	r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
 	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i",
-                r);
+		    r);
 
 	r = ioctl(vcpu->fd, KVM_SET_MSRS, &state->msrs);
 	TEST_ASSERT(r == state->msrs.nmsrs,
@@ -1214,28 +1214,28 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
 
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
 
@@ -1485,14 +1485,14 @@ struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpui
 
 static inline unsigned x86_family(unsigned int eax)
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
 
 unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
