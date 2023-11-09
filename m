Return-Path: <kvm+bounces-1378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9772C7E7351
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 22:04:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F0CBDB212D4
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 21:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37D9939865;
	Thu,  9 Nov 2023 21:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PSGytOLE"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E3738F8B
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 21:03:51 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFFD447BD
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 13:03:50 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7aa161b2fso18303697b3.2
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 13:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563830; x=1700168630; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tlWksH+O+8+jt38vfCEwQsu3wHCerzCA31np5Nu9t24=;
        b=PSGytOLEQIdUKGXv6hJ28KEXRCWxR/5K/muuPxNaYKqNP4/W5XqaBWuha82d9cP6BB
         5/Z3OXEwxB8Rk+eODFm/m8U7CFiXIGyZlrOKfZ9Gxetp/carJc3b1x0QIIbOvw0gJ18N
         qLR0zSyjTar29aJepSaf01z3sU0I+4Xt4Cz3g1Pdz6FN8LqgouE4a4S0XjYKJcQPTP7/
         ephZenANHH6pcV7U+W4rJ4+m17FH/VhpKdF9mCkdX5B91KdToCKihTWQS0V/P7Uh8hKY
         3FAPA/rdj1MosVB1XHOKWIb1FlSGDKngTpobexIUG3rTZHINXYlz5Nl04zfb1XLuDSdY
         MUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563830; x=1700168630;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tlWksH+O+8+jt38vfCEwQsu3wHCerzCA31np5Nu9t24=;
        b=RoFHHTygQSUZHRmhwD5o6EV8OcoMiy4Omsp3cFL6cGex+20Y6DhAbUarznFtRUTGaq
         dJxR5DwK/B84I1EtKjmihdhAcMffWg0g6M7i4MQOzfoUlRoKflc4pyuGZSr7Mo3bIxcP
         E4zqIy6aiDlK1kDcArx5B29T5UJpuD1uBjowkYOmc8Tr7MBM6gGTO0ez+cZs18jtQkQ2
         v5IXWHQTcpQ1iuBdq7UosrpqwYRlejbgs9XXxdHuzDuhKJIlcYiGXsi5HY/PKToCniXA
         hzjVKaVcceb9jqat1yj1UWaRY4SxLYObQ2+8repBoPGcXIai7ZwzqfQMRCtHv0XsgtcL
         urZA==
X-Gm-Message-State: AOJu0YzWJVuhjXy4jRKvgGIsO6CmVB+Bvs5uzs6ozXrbYvhD96QeK0jz
	+PPR9Wrx5dmuaZTWIHGB7wTbkrT9l5U1GA==
X-Google-Smtp-Source: AGHT+IFrJ5ArL9n6cHRfgoq9hKPNizot9gzZMyLlmN/VSIZQOIylWEKuTRLp3pCBLCLxFUTt+QtCu0l3X16Kkg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:d7c8:0:b0:d9a:58e1:bb52 with SMTP id
 o191-20020a25d7c8000000b00d9a58e1bb52mr163014ybg.6.1699563829970; Thu, 09 Nov
 2023 13:03:49 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:17 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-7-amoorthy@google.com>
Subject: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an exit
 on missing hva mappings
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Allowing KVM to fault in pages during vcpu-context guest memory accesses
can be undesirable: during userfaultfd-based postcopy, it can cause
significant performance issues due to vCPUs contending for
userfaultfd-internal locks.

Add a new memslot flag (KVM_MEM_EXIT_ON_MISSING) through which userspace
can indicate that KVM_RUN should exit instead of faulting in pages
during vcpu-context guest memory accesses. The unfaulted pages are
reported by the accompanying KVM_EXIT_MEMORY_FAULT_INFO, allowing
userspace to determine and take appropriate action.

The basic implementation strategy is to check the memslot flag from
within __gfn_to_pfn_memslot() and override the caller-provided arguments
accordingly. Some callers (such as kvm_vcpu_map()) must be able to opt
out of this behavior, and do so by passing can_exit_on_missing=false.

No functional change intended: nothing sets KVM_MEM_EXIT_ON_MISSING or
passes can_exit_on_missing=true to __gfn_to_pfn_memslot().

Suggested-by: James Houghton <jthoughton@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst         | 28 +++++++++++++++++++++++---
 arch/arm64/kvm/mmu.c                   |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/x86/kvm/mmu/mmu.c                 |  4 ++--
 include/linux/kvm_host.h               | 12 ++++++++++-
 include/uapi/linux/kvm.h               |  2 ++
 virt/kvm/Kconfig                       |  3 +++
 virt/kvm/kvm_main.c                    | 25 ++++++++++++++++++-----
 9 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a07964f601de..1457865f6e98 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1365,6 +1365,8 @@ yet and must be cleared on entry.
   /* for kvm_userspace_memory_region::flags */
   #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
   #define KVM_MEM_READONLY	(1UL << 1)
+  #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
+  #define KVM_MEM_EXIT_ON_MISSING  (1UL << 3)
 
 This ioctl allows the user to create, modify or delete a guest physical
 memory slot.  Bits 0-15 of "slot" specify the slot id and this value
@@ -1395,12 +1397,16 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.
 
-The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
-KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
+The flags field supports four flags
+
+1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
 writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
-use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
+use it.
+2.  KVM_MEM_READONLY: can be set, if KVM_CAP_READONLY_MEM capability allows it,
 to make a new slot read-only.  In this case, writes to this memory will be
 posted to userspace as KVM_EXIT_MMIO exits.
+3.  KVM_MEM_GUEST_MEMFD
+4.  KVM_MEM_EXIT_ON_MISSING: see KVM_CAP_EXIT_ON_MISSING for details.
 
 When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
 the memory region are automatically reflected into the guest.  For example, an
@@ -8059,6 +8065,22 @@ error/annotated fault.
 
 See KVM_EXIT_MEMORY_FAULT for more information.
 
+7.35 KVM_CAP_EXIT_ON_MISSING
+----------------------------
+
+:Architectures: None
+:Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
+
+The presence of this capability indicates that userspace may set the
+KVM_MEM_EXIT_ON_MISSING flag on memslots. Said flag will cause KVM_RUN to fail
+(-EFAULT) in response to guest-context memory accesses which would require KVM
+to page fault on the userspace mapping.
+
+The range of guest physical memory causing the fault is advertised to userspace
+through KVM_CAP_MEMORY_FAULT_INFO. Userspace should take appropriate action.
+This could mean, for instance, checking that the fault is resolvable, faulting
+in the relevant userspace mapping, then retrying KVM_RUN.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4e41ceed5468..13066a6fdfff 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1486,7 +1486,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmap_read_unlock(current->mm);
 
 	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-				   write_fault, &writable, NULL);
+				   write_fault, &writable, false, NULL);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index efd0ebf70a5e..2ce0e1d3f597 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -613,7 +613,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 	} else {
 		/* Call KVM generic code to do the slow-path check */
 		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-					   writing, &write_ok, NULL);
+					   writing, &write_ok, false, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 572707858d65..9d40ca02747f 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -847,7 +847,7 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 
 		/* Call KVM generic code to do the slow-path check */
 		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-					   writing, upgrade_p, NULL);
+					   writing, upgrade_p, false, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4de7670d5976..b1e5e42bdeb4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4375,7 +4375,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	async = false;
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
 					  fault->write, &fault->map_writable,
-					  &fault->hva);
+					  false, &fault->hva);
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
@@ -4397,7 +4397,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 */
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
 					  fault->write, &fault->map_writable,
-					  &fault->hva);
+					  false, &fault->hva);
 	return RET_PF_CONTINUE;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5201400358da..e8e30088289e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1219,7 +1219,8 @@ kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool interruptible, bool *async,
-			       bool write_fault, bool *writable, hva_t *hva);
+			       bool write_fault, bool *writable,
+			       bool can_exit_on_missing, hva_t *hva);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
@@ -2423,4 +2424,13 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
+/*
+ * Whether vCPUs should exit upon trying to access memory for which the
+ * userspace mappings are missing.
+ */
+static inline bool kvm_is_slot_exit_on_missing(const struct kvm_memory_slot *slot)
+{
+	return slot && slot->flags & KVM_MEM_EXIT_ON_MISSING;
+}
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index bda5622a9c68..18546cbada61 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -116,6 +116,7 @@ struct kvm_userspace_memory_region2 {
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
 #define KVM_MEM_GUEST_MEMFD	(1UL << 2)
+#define KVM_MEM_EXIT_ON_MISSING	(1UL << 3)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -1231,6 +1232,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_EXIT_ON_MISSING 236
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 2c964586aa14..241f524a4e9d 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -109,3 +109,6 @@ config KVM_GENERIC_PRIVATE_MEM
        select KVM_GENERIC_MEMORY_ATTRIBUTES
        select KVM_PRIVATE_MEM
        bool
+
+config HAVE_KVM_EXIT_ON_MISSING
+       bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 725191333c4e..faaccdba179c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1614,7 +1614,7 @@ static void kvm_replace_memslot(struct kvm *kvm,
  * only allows these.
  */
 #define KVM_SET_USER_MEMORY_REGION_V1_FLAGS \
-	(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)
+	(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY | KVM_MEM_EXIT_ON_MISSING)
 
 static int check_memory_region_flags(struct kvm *kvm,
 				     const struct kvm_userspace_memory_region2 *mem)
@@ -1632,6 +1632,9 @@ static int check_memory_region_flags(struct kvm *kvm,
 	valid_flags |= KVM_MEM_READONLY;
 #endif
 
+	if (IS_ENABLED(CONFIG_HAVE_KVM_EXIT_ON_MISSING))
+		valid_flags |= KVM_MEM_EXIT_ON_MISSING;
+
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
 
@@ -3047,7 +3050,8 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
 
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool interruptible, bool *async,
-			       bool write_fault, bool *writable, hva_t *hva)
+			       bool write_fault, bool *writable,
+			       bool can_exit_on_missing, hva_t *hva)
 {
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
 
@@ -3070,6 +3074,15 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 		writable = NULL;
 	}
 
+	if (!atomic && can_exit_on_missing
+	    && kvm_is_slot_exit_on_missing(slot)) {
+		atomic = true;
+		if (async) {
+			*async = false;
+			async = NULL;
+		}
+	}
+
 	return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
 			  writable);
 }
@@ -3079,21 +3092,21 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
 	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, false,
-				    NULL, write_fault, writable, NULL);
+				    NULL, write_fault, writable, false, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	return __gfn_to_pfn_memslot(slot, gfn, false, false, NULL, true,
-				    NULL, NULL);
+				    NULL, false, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	return __gfn_to_pfn_memslot(slot, gfn, true, false, NULL, true,
-				    NULL, NULL);
+				    NULL, false, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
@@ -4898,6 +4911,8 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_has_private_mem(kvm);
 #endif
+	case KVM_CAP_EXIT_ON_MISSING:
+		return IS_ENABLED(CONFIG_HAVE_KVM_EXIT_ON_MISSING);
 	default:
 		break;
 	}
-- 
2.42.0.869.gea05f2083d-goog


