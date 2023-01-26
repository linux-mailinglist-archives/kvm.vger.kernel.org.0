Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E3967D46B
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 19:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbjAZSku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 13:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbjAZSkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 13:40:49 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6D563857
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:40:47 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-507aac99fdfso29575247b3.11
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fYo1QkIhSVZeHSzALDDU8J+gIjGzOBs4iF8dI9WHJaI=;
        b=XtpoXrhy2rHdAzZgIBGT/PpU/B+14+2DiihYjtwNXYwCnPl93EFPcg73sjusrpK1EU
         JZTQ3FweXmy5njYY63ANBWzyE0RB8W3WxjKA87kjYxDBRGIvlMrKdHLjuAlIgG4h36mK
         NX62Y+rf9lcWKjwJxtJgr6FsDnQWFy39tkM07iygvyXBzqfnTgt3kK5jtKjE0IIZdkNr
         cqwEX4Qy+TOwmCam2ZyPnSSDvf18PHkpaIzO6gGANdQ/qsxR+mqmtq/nBfs9Sq2URXNK
         8CIXUdJneD8W2ZadFbp9a7eRtO+YWiliIEv6SZczVCGiis4I0cU5yUKEnRASzrtcFzh8
         uCOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fYo1QkIhSVZeHSzALDDU8J+gIjGzOBs4iF8dI9WHJaI=;
        b=sRzx/kEtH5XJMl8D7pr+OIT1/R7NCLGHJ4/oOfZSO/5RT7iO5rLLJVdHumIv1I6iVP
         PFZ3mae1736OBQruwJpmBSDOT+7uy3L8V+W2SoSkFgyZ9LyxzmHH9bQoL/zvFQJRThfQ
         l9CG7AZjkJufYe+dvgYveYjF6mRNCvXZORaThTiK5zO/PuAokTtBIiWmuvygPqqi0VLu
         TO/+pKIqAzKjM3A4F5FhqUoc1poVVp3fZMGIkT4hGwiYnMyj6OHcZnTvEm60PFN/rUeC
         jRksgVcStexTEmMeiVr48tPSKcxIydBVpoIgOVucAVh9L+sqgfk6u/dZyFb+AOtT9uvF
         5KJA==
X-Gm-Message-State: AFqh2kr4ik4Bvsjf1ICVHuEb0yFUyjnvXcQa84CakFqOivI/+d+nA4mK
        YWSsqKkAOgkMMH+XLRAnTvyhT7hGtFeqAg==
X-Google-Smtp-Source: AMrXdXt4+cEudOMUQ+wmd2s6+inK0nZHf04IpM9LI66+wdfbYuk0qDByjFe/kn38T2DiSoaNDbGQN4nimnoacw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:a87:0:b0:800:ea7e:bb0 with SMTP id
 129-20020a250a87000000b00800ea7e0bb0mr3066381ybk.516.1674758447197; Thu, 26
 Jan 2023 10:40:47 -0800 (PST)
Date:   Thu, 26 Jan 2023 10:40:22 -0800
In-Reply-To: <20230126184025.2294823-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230126184025.2294823-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126184025.2294823-5-dmatlack@google.com>
Subject: [PATCH v2 4/7] KVM: x86/mmu: Rename kvm_flush_remote_tlbs_with_address()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        David Matlack <dmatlack@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
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

Rename kvm_flush_remote_tlbs_with_address() to
kvm_flush_remote_tlbs_range(). This name is shorter, which reduces the
number of callsites that need to be broken up across multiple lines, and
more readable since it conveys a range of memory is being flushed rather
than a single address.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 14 +++++---------
 arch/x86/kvm/mmu/mmu_internal.h |  7 +++----
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b257f937d8a4..215a8b7f5e03 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -247,8 +247,7 @@ static inline bool kvm_available_flush_tlb_with_range(void)
 	return kvm_x86_ops.tlb_remote_flush_with_range;
 }
 
-void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
-		u64 start_gfn, u64 pages)
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages)
 {
 	struct kvm_tlb_range range;
 	int ret = -EOPNOTSUPP;
@@ -5826,9 +5825,8 @@ slot_handle_level_range(struct kvm *kvm, const struct kvm_memory_slot *memslot,
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
 			if (flush && flush_on_yield) {
-				kvm_flush_remote_tlbs_with_address(kvm,
-						start_gfn,
-						iterator.gfn - start_gfn + 1);
+				kvm_flush_remote_tlbs_range(kvm, start_gfn,
+							    iterator.gfn - start_gfn + 1);
 				flush = false;
 			}
 			cond_resched_rwlock_write(&kvm->mmu_lock);
@@ -6183,8 +6181,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	}
 
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
-						   gfn_end - gfn_start);
+		kvm_flush_remote_tlbs_range(kvm, gfn_start, gfn_end - gfn_start);
 
 	kvm_mmu_invalidate_end(kvm, 0, -1ul);
 
@@ -6573,8 +6570,7 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 	 * is observed by any other operation on the same memslot.
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
-	kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
-					   memslot->npages);
+	kvm_flush_remote_tlbs_range(kvm, memslot->base_gfn, memslot->npages);
 }
 
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index cc58631e2336..3bb21d29d84c 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -170,14 +170,13 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
 
-void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
-					u64 start_gfn, u64 pages);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages);
 
 /* Flush the given page (huge or not) of guest memory. */
 static inline void kvm_flush_remote_tlbs_gfn(struct kvm *kvm, gfn_t gfn, int level)
 {
-	kvm_flush_remote_tlbs_with_address(kvm, gfn_round_for_level(gfn, level),
-					   KVM_PAGES_PER_HPAGE(level));
+	kvm_flush_remote_tlbs_range(kvm, gfn_round_for_level(gfn, level),
+				    KVM_PAGES_PER_HPAGE(level));
 }
 
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
-- 
2.39.1.456.gfc5497dd1b-goog

