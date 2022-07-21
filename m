Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C529057C148
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 02:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbiGUADe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 20:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbiGUAD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 20:03:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BF79747B4
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658361807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vEKhqgRr9e+FdFBlcgIQBne//MdIQ/2rpsCkqOHqxu0=;
        b=hdAv2Nh17lpT5EQ2hwK6Xy+3/l7ORwdLBze9txK7NdtZZZCPlfUypls0ws2KXQ+lQ8KfGq
        CZMbuk8yv1TeazgC1zfESCf3ypk2+TbX4JKSDYidZ+xscDGbQfw6fvn0YER8DcP+Ic567K
        cGMKy0A+xBMrBJo8pP3r8GaXMEeMWLc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-OKflfEbAO2uWCHgefk5rDQ-1; Wed, 20 Jul 2022 20:03:26 -0400
X-MC-Unique: OKflfEbAO2uWCHgefk5rDQ-1
Received: by mail-qk1-f199.google.com with SMTP id bi37-20020a05620a31a500b006b5ef0afedaso201275qkb.22
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:03:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vEKhqgRr9e+FdFBlcgIQBne//MdIQ/2rpsCkqOHqxu0=;
        b=Jkv7iYbPZZOP8tSzFGL2HJ0oOtsuARk/Ct/SMX1lUGw7nVC8p+y89Vpead00tYt4D7
         IWLkZon8oWXoZUMGPv2/Dgyxe/VZGlZAKTpH2KEspMHHqLpeUfldiAxIYO3Yk73NJP+r
         oYSvj4ygv9Q3TYqTQiWrF4pVKNC0HzZEPCu5PqCviCzEPuZVMveDVZH3546uOD6o4jgv
         sc75oLusdOTQEZktXqBhge1IsjcN4e09cbdLS9E2BBZ6GT/wxtMh4Jbl8rfe83/C6cou
         9RH90qmJSnOJA3EobhLk5LmUmM6MImMzcgiaMPqnys5qfo5GXFF/SGC7nmKg5vUo6rW7
         ohWg==
X-Gm-Message-State: AJIora+vPptX2Lyndc3yxhCb6OkpiZlOvoRKvvsTbWyIsWH5/91guWja
        wNLTlu4wo7N3WgrHYWMZrzG6eQhZND5REplyvV94e1D4ZsfrW2NbNE+YW1wURnIaQ0bgoMYW2r/
        cHimdyG36KRAk
X-Received: by 2002:a05:620a:410c:b0:6b2:82d8:dcae with SMTP id j12-20020a05620a410c00b006b282d8dcaemr26219833qko.259.1658361804830;
        Wed, 20 Jul 2022 17:03:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tKKR7T4A+w03q2sFw9EEHlT0lO0nSE92BRB0WQDe4C2KneGlhmAUXd/ls2kVGBH4CAIrGMMw==
X-Received: by 2002:a05:620a:410c:b0:6b2:82d8:dcae with SMTP id j12-20020a05620a410c00b006b282d8dcaemr26219802qko.259.1658361804490;
        Wed, 20 Jul 2022 17:03:24 -0700 (PDT)
Received: from localhost.localdomain (bras-base-aurron9127w-grc-37-74-12-30-48.dsl.bell.ca. [74.12.30.48])
        by smtp.gmail.com with ESMTPSA id g4-20020ac87f44000000b0031eb3af3ffesm418640qtk.52.2022.07.20.17.03.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 20 Jul 2022 17:03:23 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        John Hubbard <jhubbard@nvidia.com>,
        Sean Christopherson <seanjc@google.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v2 3/3] kvm/x86: Allow to respond to generic signals during slow page faults
Date:   Wed, 20 Jul 2022 20:03:18 -0400
Message-Id: <20220721000318.93522-4-peterx@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220721000318.93522-1-peterx@redhat.com>
References: <20220721000318.93522-1-peterx@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All the facilities should be ready for this, what we need to do is to add a
new "interruptible" flag showing that we're willing to be interrupted by
common signals during the __gfn_to_pfn_memslot() request, and wire it up
with a FOLL_INTERRUPTIBLE flag that we've just introduced.

Note that only x86 slow page fault routine will set this to true.  The new
flag is by default false in non-x86 arch or on other gup paths even for
x86.  It can actually be used elsewhere too but not yet covered.

When we see the PFN fetching was interrupted, do early exit to userspace
with an KVM_EXIT_INTR exit reason.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/arm64/kvm/mmu.c                   |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/x86/kvm/mmu/mmu.c                 | 16 ++++++++++++--
 include/linux/kvm_host.h               |  4 ++--
 virt/kvm/kvm_main.c                    | 30 ++++++++++++++++----------
 virt/kvm/kvm_mm.h                      |  4 ++--
 virt/kvm/pfncache.c                    |  2 +-
 8 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f5651a05b6a8..93f6b9bf1af1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1204,7 +1204,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	smp_rmb();
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
+	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
 				   write_fault, &writable, NULL);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 514fd45c1994..7aed5ef6588e 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -598,7 +598,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 		write_ok = true;
 	} else {
 		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
+		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
 					   writing, &write_ok, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 42851c32ff3b..9991f9d9ee59 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -845,7 +845,7 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 		unsigned long pfn;
 
 		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
+		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
 					   writing, upgrade_p, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 17252f39bd7c..aeafe0e9cfbf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3012,6 +3012,13 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			       unsigned int access)
 {
+	/* NOTE: not all error pfn is fatal; handle sigpending pfn first */
+	if (unlikely(is_sigpending_pfn(fault->pfn))) {
+		vcpu->run->exit_reason = KVM_EXIT_INTR;
+		++vcpu->stat.signal_exits;
+		return -EINTR;
+	}
+
 	/* The pfn is invalid, report the error! */
 	if (unlikely(is_error_pfn(fault->pfn)))
 		return kvm_handle_bad_page(vcpu, fault->gfn, fault->pfn);
@@ -3999,7 +4006,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	}
 
 	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, &async,
+	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
 					  fault->write, &fault->map_writable,
 					  &fault->hva);
 	if (!async)
@@ -4016,7 +4023,12 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 	}
 
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, NULL,
+	/*
+	 * Allow gup to bail on pending non-fatal signals when it's also allowed
+	 * to wait for IO.  Note, gup always bails if it is unable to quickly
+	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
+	 */
+	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
 					  fault->write, &fault->map_writable,
 					  &fault->hva);
 	return RET_PF_CONTINUE;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 06a5b17d3679..5bae753ebe48 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1158,8 +1158,8 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool atomic, bool *async, bool write_fault,
-			       bool *writable, hva_t *hva);
+			       bool atomic, bool interruptible, bool *async,
+			       bool write_fault, bool *writable, hva_t *hva);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a49df8988cd6..25deacc705b8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2445,7 +2445,7 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
  * 1 indicates success, -errno is returned if error is detected.
  */
 static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
-			   bool *writable, kvm_pfn_t *pfn)
+			   bool interruptible, bool *writable, kvm_pfn_t *pfn)
 {
 	unsigned int flags = FOLL_HWPOISON;
 	struct page *page;
@@ -2460,6 +2460,8 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 		flags |= FOLL_WRITE;
 	if (async)
 		flags |= FOLL_NOWAIT;
+	if (interruptible)
+		flags |= FOLL_INTERRUPTIBLE;
 
 	npages = get_user_pages_unlocked(addr, 1, &page, flags);
 	if (npages != 1)
@@ -2566,6 +2568,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
  * Pin guest page in memory and return its pfn.
  * @addr: host virtual address which maps memory to the guest
  * @atomic: whether this function can sleep
+ * @interruptible: whether the process can be interrupted by non-fatal signals
  * @async: whether this function need to wait IO complete if the
  *         host page is not in the memory
  * @write_fault: whether we should get a writable host page
@@ -2576,8 +2579,8 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
  * 2): @write_fault = false && @writable, @writable will tell the caller
  *     whether the mapping is writable.
  */
-kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
-		     bool write_fault, bool *writable)
+kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
+		     bool *async, bool write_fault, bool *writable)
 {
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn = 0;
@@ -2592,9 +2595,12 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	if (atomic)
 		return KVM_PFN_ERR_FAULT;
 
-	npages = hva_to_pfn_slow(addr, async, write_fault, writable, &pfn);
+	npages = hva_to_pfn_slow(addr, async, write_fault, interruptible,
+				 writable, &pfn);
 	if (npages == 1)
 		return pfn;
+	if (npages == -EINTR)
+		return KVM_PFN_ERR_SIGPENDING;
 
 	mmap_read_lock(current->mm);
 	if (npages == -EHWPOISON ||
@@ -2625,8 +2631,8 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 }
 
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool atomic, bool *async, bool write_fault,
-			       bool *writable, hva_t *hva)
+			       bool atomic, bool interruptible, bool *async,
+			       bool write_fault, bool *writable, hva_t *hva)
 {
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
 
@@ -2651,7 +2657,7 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 		writable = NULL;
 	}
 
-	return hva_to_pfn(addr, atomic, async, write_fault,
+	return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
 			  writable);
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
@@ -2659,20 +2665,22 @@ EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
-	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
-				    write_fault, writable, NULL);
+	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false,
+				    false, NULL, write_fault, writable, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, false, false, NULL, true,
+				    NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, true, false, NULL, true,
+				    NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 41da467d99c9..a1ab15006af3 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -24,8 +24,8 @@
 #define KVM_MMU_READ_UNLOCK(kvm)	spin_unlock(&(kvm)->mmu_lock)
 #endif /* KVM_HAVE_MMU_RWLOCK */
 
-kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
-		     bool write_fault, bool *writable);
+kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
+		     bool *async, bool write_fault, bool *writable);
 
 #ifdef CONFIG_HAVE_KVM_PFNCACHE
 void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index dd84676615f1..294808e77f44 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -123,7 +123,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, unsigned long uhva)
 		smp_rmb();
 
 		/* We always request a writeable mapping */
-		new_pfn = hva_to_pfn(uhva, false, NULL, true, NULL);
+		new_pfn = hva_to_pfn(uhva, false, false, NULL, true, NULL);
 		if (is_error_noslot_pfn(new_pfn))
 			break;
 
-- 
2.32.0

