Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8FC48E0E7
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 00:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238234AbiAMXac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 18:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238218AbiAMXab (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 18:30:31 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30057C061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 15:30:31 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id i16-20020aa78d90000000b004be3e88d746so672384pfr.13
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 15:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KW0v15GQjuiGlKaCwQeCIorGmGTs86w3rhJM6nHYyNQ=;
        b=YfcwdgE8KS0HpGOyrh5RYFusKqiUJyUgWtBSWv0XYYHiVclzz4wFfPdzPgi26Jzoxm
         ItxtbB1Xz7kkQpgw+tBq8PMClIZXqcqWytRYmWn6wXoVW2jbBUw864Y8VXy1lgcR7GpW
         7nYBI4TJLrGkdpQY4adAmh+xcTVtHfyK/L2WFb8r1xzdDgih+lBzpGL11sAQS31jFQg/
         zEQ4QOhBeajgTT3rzoiwXOBAmsERLphX2M61Vsa1doTJ50DhYyUhNU/BQuy6CujSHHXs
         Mp9/p0MojHAE/YqWcHB6TbnpIq3y0pn++qtfz/Qzkasjr/0VIJPNW1Xd5//4dAM8oMj6
         pbXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KW0v15GQjuiGlKaCwQeCIorGmGTs86w3rhJM6nHYyNQ=;
        b=NvhjFLBfuaYR3JBM8J/jE7S6bHVgHtcRwt0bYsG0E99lhHvQjhFVeKOkJp2E2BvZfH
         XO1sPWKX7gRehUln5cdelI9dRmBeAGHv+lgf0ogGwZ+Q55KHIC/cPHn6p1/rPbvGbogt
         1w3f/My1mrhkgasi3rDOO8u3TgxPdSJQgqXqEOnqzlDmr0xoJA//0E+GHqCbA3prh9XL
         LbhUEosGoKmMjR+LSAgiTKK37g87jjxgasUJuSopZbC2MFDNs2is7aoI5LPuMHYC4gfP
         TvdnPUJCFrycvXzspyhpEYvhl/LP6unklrMcBqqPL0f0M3rnxImGJAPbJEGlPiHqCjr9
         7j6A==
X-Gm-Message-State: AOAM531HRy+3SdzMNsvR0Ugmh2gUkOnThlf/fi9MSGY/6iWtt+Oso2Gr
        nnCug2GeHNuhH92I654KjmhEiCeaAAP9cw==
X-Google-Smtp-Source: ABdhPJzDDEgArwcky65T79OA0kRIOnZD+q2jTxoEmCKozM9xku6MR7JE+xsFMZVQZqBlWT9ywM/VLkL5zT74cw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:3a83:: with SMTP id
 om3mr7585109pjb.186.1642116630704; Thu, 13 Jan 2022 15:30:30 -0800 (PST)
Date:   Thu, 13 Jan 2022 23:30:20 +0000
In-Reply-To: <20220113233020.3986005-1-dmatlack@google.com>
Message-Id: <20220113233020.3986005-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20220113233020.3986005-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 4/4] KVM: x86/mmu: Improve TLB flush comment in kvm_mmu_slot_remove_write_access()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rewrite the comment in kvm_mmu_slot_remove_write_access() that explains
why it is safe to flush TLBs outside of the MMU lock after
write-protecting SPTEs for dirty logging. The current comment is a long
run-on sentence that was difficult to understand. In addition it was
specific to the shadow MMU (mentioning mmu_spte_update()) when the TDP
MMU has to handle this as well.

The new comment explains:
 - Why the TLB flush is necessary at all.
 - Why it is desirable to do the TLB flush outside of the MMU lock.
 - Why it is safe to do the TLB flush outside of the MMU lock.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1d275e9d76b5..8ed2b42a7aa3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5756,6 +5756,7 @@ static bool __kvm_zap_rmaps(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 				continue;
 
 			flush = slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
+
 							PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL,
 							start, end - 1, true, flush);
 		}
@@ -5825,15 +5826,27 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	}
 
 	/*
-	 * We can flush all the TLBs out of the mmu lock without TLB
-	 * corruption since we just change the spte from writable to
-	 * readonly so that we only need to care the case of changing
-	 * spte from present to present (changing the spte from present
-	 * to nonpresent will flush all the TLBs immediately), in other
-	 * words, the only case we care is mmu_spte_update() where we
-	 * have checked Host-writable | MMU-writable instead of
-	 * PT_WRITABLE_MASK, that means it does not depend on PT_WRITABLE_MASK
-	 * anymore.
+	 * Flush TLBs if any SPTEs had to be write-protected to ensure that
+	 * guest writes are reflected in the dirty bitmap before the memslot
+	 * update completes, i.e. before enabling dirty logging is visible to
+	 * userspace.
+	 *
+	 * Perform the TLB flush outside the mmu_lock to reduce the amount of
+	 * time the lock is held. However, this does mean that another CPU can
+	 * now grab the mmu_lock and encounter an SPTE that is write-protected
+	 * while CPUs still have writable versions of that SPTE in their TLB.
+	 *
+	 * This is safe but requires KVM to be careful when making decisions
+	 * based on the write-protection status of an SPTE. Specifically, KVM
+	 * also write-protects SPTEs to monitor changes to guest page tables
+	 * during shadow paging, and must guarantee no CPUs can write to those
+	 * page before the lock is dropped. As mentioned in the previous
+	 * paragraph, a write-protected SPTE is no guarantee that CPU cannot
+	 * perform writes. So to determine if a TLB flush is truly required, KVM
+	 * will clear a separate software-only bit (MMU-writable) and skip the
+	 * flush if-and-only-if this bit was already clear.
+	 *
+	 * See DEFAULT_SPTE_MMU_WRITEABLE for more details.
 	 */
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
-- 
2.34.1.703.g22d0c6ccf7-goog

