Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9B849BF5A
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 00:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbiAYXH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 18:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbiAYXH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 18:07:26 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D3DC06161C
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 15:07:26 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id q1-20020a17090a064100b001b4d85cbaf7so1837583pje.9
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 15:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=k8r4a6KDj+A3bJq0uWYzVTLx9UlIZS12qeMZsvsZ+XM=;
        b=jnefdm0C+V9iP4iGL/WX32AQPHb3iVkY25OBbDa2o9H/ul8PsrQkNm2S3RXn+4WP8w
         gN57MEPaRjpkS6DB1STzMX2ZcGsduCOxooTkGEaoC3XYhJT1kDtFSFGk6u/mlqI4wpAU
         R/kgrel+ULG17LmHMPvN2wHS6TFcC9qy7xQ0z7vLLLV6zGOGRaYSZSAWswRvXrKQx/re
         7FGMsL8/zv8jLG16DwYQXTFMqk6ycUaELYsrUVVIcTwo6LHGW4CMV6gD6LwFNPZeyVAx
         hV+10SJIw6JtKXK87gDm1ksy0Bdm+BzpOU9++K+WTCe1wnrhr7q0eWWtZgbtvDJFtZT1
         I1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=k8r4a6KDj+A3bJq0uWYzVTLx9UlIZS12qeMZsvsZ+XM=;
        b=w3hcjFo8efaKk6+9PmvRHhm6qUYYHEPmm9UBJJLXd2dQSJRpDEAA+ThYm95UAHi8Gq
         EHwG9qDzanDiNF+7fs9eZPFAV5HaMEVv5qYdHZViKzrviLf4BGZRzO5rBpw+GUjJCltV
         mzEv6MXABZbLDztGTSkYw5DgPJRhA07NgRQ4r92gZObfDZGIYjYza96RBkgY2IwNJGtS
         lRKRjdlYQQqjckkRmW4GWAS40W2y3jUUQyvb3SRSMX4CWvlLpKLriyKmyPUvN07rDRPE
         fr4DtDFJzPcJBI1r4fUcAjJmO1PEaOzZfdghnt458apwE8bmvNGQirNKJaMo1snsGP3N
         dFWA==
X-Gm-Message-State: AOAM5328JO+5W6nx8PeOy5oUsfHN8hXDf2WArYiaTWJcUBHNTBCaa/77
        t8D/O8kzzzKHqRJsK84XHDELa9cc06Ex2w==
X-Google-Smtp-Source: ABdhPJy1zTQMfkf7kCgc2vn5ZJMyFGvINsdueKjUcF7dgCgrt+idfZkgRkk68hoEgiIPkUKuvTe6+MxdG/mflQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:ab05:b0:14b:e74:d7bd with SMTP id
 ik5-20020a170902ab0500b0014b0e74d7bdmr20771642plb.126.1643152045888; Tue, 25
 Jan 2022 15:07:25 -0800 (PST)
Date:   Tue, 25 Jan 2022 23:07:23 +0000
Message-Id: <20220125230723.1701061-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 5/5] KVM: x86/mmu: Consolidate comments about {Host,MMU}-writable
From:   David Matlack <dmatlack@google.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate the large comment above DEFAULT_SPTE_HOST_WRITABLE with the
large comment above is_writable_pte() into one comment. This comment
explains the different reasons why an SPTE may be non-writable and KVM
keeps track of that with the {Host,MMU}-writable bits.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c  |  10 ++--
 arch/x86/kvm/mmu/spte.h | 105 +++++++++++++++++++++-------------------
 2 files changed, 60 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 88f3aa5f2a36..f8a508b3c3e7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -549,11 +549,9 @@ static u64 mmu_spte_update_no_track(u64 *sptep, u64 new_spte)
 /* Rules for using mmu_spte_update:
  * Update the state bits, it means the mapped pfn is not changed.
  *
- * Whenever we overwrite a writable spte with a read-only one we
- * should flush remote TLBs. Otherwise rmap_write_protect
- * will find a read-only spte, even though the writable spte
- * might be cached on a CPU's TLB, the return value indicates this
- * case.
+ * Whenever an MMU-writable SPTE is overwritten with a read-only SPTE, remote
+ * TLBs must be flushed. Otherwise rmap_write_protect will find a read-only
+ * spte, even though the writable spte might be cached on a CPU's TLB.
  *
  * Returns true if the TLB needs to be flushed
  */
@@ -5847,7 +5845,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	 * will clear a separate software-only bit (MMU-writable) and skip the
 	 * flush if-and-only-if this bit was already clear.
 	 *
-	 * See DEFAULT_SPTE_MMU_WRITABLE for more details.
+	 * See is_writable_pte() for more details.
 	 */
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index a179f089e3dd..08f471d8e409 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -75,28 +75,8 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 static_assert(!(SPTE_TDP_AD_MASK & SHADOW_ACC_TRACK_SAVED_MASK));
 
 /*
- * *_SPTE_HOST_WRITABLE (aka Host-writable) indicates whether the host permits
- * writes to the guest page mapped by the SPTE. This bit is cleared on SPTEs
- * that map guest pages in read-only memslots and read-only VMAs.
- *
- * Invariants:
- *  - If Host-writable is clear, PT_WRITABLE_MASK must be clear.
- *
- *
- * *_SPTE_MMU_WRITABLE (aka MMU-writable) indicates whether the shadow MMU
- * allows writes to the guest page mapped by the SPTE. This bit is cleared when
- * the guest page mapped by the SPTE contains a page table that is being
- * monitored for shadow paging. In this case the SPTE can only be made writable
- * by unsyncing the shadow page under the mmu_lock.
- *
- * Invariants:
- *  - If MMU-writable is clear, PT_WRITABLE_MASK must be clear.
- *  - If MMU-writable is set, Host-writable must be set.
- *
- * If MMU-writable is set, PT_WRITABLE_MASK is normally set but can be cleared
- * to track writes for dirty logging. For such SPTEs, KVM will locklessly set
- * PT_WRITABLE_MASK upon the next write from the guest and record the write in
- * the dirty log (see fast_page_fault()).
+ * {DEFAULT,EPT}_SPTE_{HOST,MMU}_WRITABLE are used to keep track of why a given
+ * SPTE is write-protected. See is_writable_pte() for details.
  */
 
 /* Bits 9 and 10 are ignored by all non-EPT PTEs. */
@@ -340,37 +320,64 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
 }
 
 /*
- * Currently, we have two sorts of write-protection, a) the first one
- * write-protects guest page to sync the guest modification, b) another one is
- * used to sync dirty bitmap when we do KVM_GET_DIRTY_LOG. The differences
- * between these two sorts are:
- * 1) the first case clears MMU-writable bit.
- * 2) the first case requires flushing tlb immediately avoiding corrupting
- *    shadow page table between all vcpus so it should be in the protection of
- *    mmu-lock. And the another case does not need to flush tlb until returning
- *    the dirty bitmap to userspace since it only write-protects the page
- *    logged in the bitmap, that means the page in the dirty bitmap is not
- *    missed, so it can flush tlb out of mmu-lock.
+ * An shadow-present leaf SPTE may be non-writable for 3 possible reasons:
+ *
+ *  1. To intercept writes for dirty logging. KVM write-protects huge pages
+ *     so that they can be split be split down into the dirty logging
+ *     granularity (4KiB) whenever the guest writes to them. KVM also
+ *     write-protects 4KiB pages so that writes can be recorded in the dirty log
+ *     (e.g. if not using PML). SPTEs are write-protected for dirty logging
+ *     during the VM-iotcls that enable dirty logging.
+ *
+ *  2. To intercept writes to guest page tables that KVM is shadowing. When a
+ *     guest writes to its page table the corresponding shadow page table will
+ *     be marked "unsync". That way KVM knows which shadow page tables need to
+ *     be updated on the next TLB flush, INVLPG, etc. and which do not.
+ *
+ *  3. To prevent guest writes to read-only memory, such as for memory in a
+ *     read-only memslot or guest memory backed by a read-only VMA. Writes to
+ *     such pages are disallowed entirely.
+ *
+ * To keep track of why a given SPTE is write-protected, KVM uses 2
+ * software-only bits in the SPTE:
+ *
+ *  shadow_mmu_writable_mask, aka MMU-writable -
+ *    Cleared on SPTEs that KVM is currently write-protecting for shadow paging
+ *    purposes (case 2 above).
+ *
+ *  shadow_host_writable_mask, aka Host-writable -
+ *    Cleared on SPTEs that are not host-writable (case 3 above)
+ *
+ * Note, not all possible combinations of PT_WRITABLE_MASK,
+ * shadow_mmu_writable_mask, and shadow_host_writable_mask are valid. A given
+ * SPTE can be in only one of the following states, which map to the
+ * aforementioned 3 cases:
+ *
+ *   shadow_host_writable_mask | shadow_mmu_writable_mask | PT_WRITABLE_MASK
+ *   ------------------------- | ------------------------ | ----------------
+ *   1                         | 1                        | 1       (writable)
+ *   1                         | 1                        | 0       (case 1)
+ *   1                         | 0                        | 0       (case 2)
+ *   0                         | 0                        | 0       (case 3)
  *
- * So, there is the problem: the first case can meet the corrupted tlb caused
- * by another case which write-protects pages but without flush tlb
- * immediately. In order to making the first case be aware this problem we let
- * it flush tlb if we try to write-protect a spte whose MMU-writable bit
- * is set, it works since another case never touches MMU-writable bit.
+ * The valid combinations of these bits are checked by
+ * check_spte_writable_invariants() whenever an SPTE is modified.
  *
- * Anyway, whenever a spte is updated (only permission and status bits are
- * changed) we need to check whether the spte with MMU-writable becomes
- * readonly, if that happens, we need to flush tlb. Fortunately,
- * mmu_spte_update() has already handled it perfectly.
+ * Clearing the MMU-writable bit is always done under the MMU lock and always
+ * accompanied by a TLB flush before dropping the lock to avoid corrupting the
+ * shadow page tables between vCPUs. Write-protecting an SPTE for dirty logging
+ * (which does not clear the MMU-writable bit), does not flush TLBs before
+ * dropping the lock, as it only needs to synchronize guest writes with the
+ * dirty bitmap.
  *
- * The rules to use MMU-writable and PT_WRITABLE_MASK:
- * - if we want to see if it has writable tlb entry or if the spte can be
- *   writable on the mmu mapping, check MMU-writable, this is the most
- *   case, otherwise
- * - if we fix page fault on the spte or do write-protection by dirty logging,
- *   check PT_WRITABLE_MASK.
+ * So, there is the problem: clearing the MMU-writable bit can encounter a
+ * write-protected SPTE while CPUs still have writable mappings for that SPTE
+ * cached in their TLB. To address this, KVM always flushes TLBs when
+ * write-protecting SPTEs if the MMU-writable bit is set on the old SPTE.
  *
- * TODO: introduce APIs to split these two cases.
+ * The Host-writable bit is not modified on present SPTEs, it is only set or
+ * cleared when an SPTE is first faulted in from non-present and then remains
+ * immutable.
  */
 static inline bool is_writable_pte(unsigned long pte)
 {
-- 
2.35.0.rc0.227.g00780c9af4-goog

