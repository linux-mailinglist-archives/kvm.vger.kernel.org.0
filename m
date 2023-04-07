Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E1B6DB524
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 22:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjDGUUm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 16:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbjDGUU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 16:20:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5D0C176
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 13:20:11 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m6-20020a056902118600b00aeb1e3dbd1bso42431363ybu.9
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 13:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680898810; x=1683490810;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=88YN7x3qppPMVMra5pRzHHPVPBEL4gMuQXheETIYTNU=;
        b=OMW9kzjNG7JkuumKUv1gxM5ClRnzMIgI7kcKO2DxeN5LnLC/y/rEnRoSpywnKQs6hD
         xlQD/OsuGnJ5npkky5Zeo0idUTx/ZeUjWrN65bVSD+9YE94mwbexeVuduMYRcJXkdWR9
         c5e4/E0ZMYZkZuNx3ir9D1lXfiqPJjj8W9x34KqqTmzX6auXI6JlOD5uUwQyobkTZHkX
         GCYUe1C5vg1gq2woLG6c4aqn7ii1vyB75r4qVRPb3gbnB8AF+iJW/hONV03AuDt//Ykl
         +JKBwB+Km4olaMCfJvrbGcPiR60/pmR36bZ7vdgt09knNdseMPjEeCZ5XJB2aV2wWMRD
         M2Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680898810; x=1683490810;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=88YN7x3qppPMVMra5pRzHHPVPBEL4gMuQXheETIYTNU=;
        b=UGStVOCS4ZIE5Klb4AK4GUNjp6irhPpSY9GnmTfAR4eXUvHzHn2VSnk59b36/tyvuF
         24zXOQp07L0I2tZI5UjV9wClJJbS/f9hWvuIS23JRnml+oo/mTzRdTY8cVgCK4fx4+9B
         DuqwtO8wuexY5HgXVDQkiTDPrbnsW+axSqd1s6uIzP4IU+hC4wjRYgVtZM3lWHvQQmbE
         e9PxKB3X15HLZ3Bjhk7ra7kRPQSzFAPW7/707oaqnUc3BUZcSng2fmn9/HT6SsFJNYvr
         DH+Qq9WL/ewJZQ+yc8oP6LLujLpV2hjvjuovqPUwcYqEweVMpqjtLuiNRZo83v9dBGrv
         nXxA==
X-Gm-Message-State: AAQBX9ehnjJdD1z2RfqsG5ExubPBFHR9VfiolnXP+LeSpwgDupD2xDkR
        mAMlPg7Zae43oiZWJVTwif4tPpwc31XJ3qZAIqi+BbVMfS4Lz/4r9JzknGmawcTBDeWSXXQv2yL
        4X6CbUSIwZvXjr1W7+b9z/yZ+PxCVKXS+Ja22xW56IMpZB4WZPjzC7xg=
X-Google-Smtp-Source: AKy350Z518uI8iDZqsGbGxAPlrTG82u1+tzRRv9ENlxzq3lw1oRIWVZvb/x2syQmHk/sxAmaqvastUXjlQ==
X-Received: from sagi.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:241b])
 (user=sagis job=sendgmr) by 2002:a25:d958:0:b0:b75:3fd4:1b31 with SMTP id
 q85-20020a25d958000000b00b753fd41b31mr2479838ybg.1.1680898810376; Fri, 07 Apr
 2023 13:20:10 -0700 (PDT)
Date:   Fri,  7 Apr 2023 20:19:21 +0000
In-Reply-To: <20230407201921.2703758-1-sagis@google.com>
Mime-Version: 1.0
References: <20230407201921.2703758-1-sagis@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230407201921.2703758-6-sagis@google.com>
Subject: [RFC PATCH 5/5] KVM: TDX: Add core logic for TDX intra-host migration
From:   Sagi Shahar <sagis@google.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sagi Shahar <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds the core logic for transferring state between source and
destination TDs during intra-host migration.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 191 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 190 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0999a6d827c99..05b164a91437b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2834,9 +2834,198 @@ static __always_inline bool tdx_guest(struct kvm *kvm)
 	return tdx_kvm->finalized;
 }
 
+#define for_each_memslot_pair(memslots_1, memslots_2, memslot_iter_1, \
+			      memslot_iter_2)                         \
+	for (memslot_iter_1 = rb_first(&memslots_1->gfn_tree),        \
+	    memslot_iter_2 = rb_first(&memslots_2->gfn_tree);         \
+	     memslot_iter_1 && memslot_iter_2;                        \
+	     memslot_iter_1 = rb_next(memslot_iter_1),                \
+	    memslot_iter_2 = rb_next(memslot_iter_2))
+
 static int tdx_migrate_from(struct kvm *dst, struct kvm *src)
 {
-	return -EINVAL;
+	struct rb_node *src_memslot_iter, *dst_memslot_iter;
+	struct vcpu_tdx *dst_tdx_vcpu, *src_tdx_vcpu;
+	struct kvm_memslots *src_slots, *dst_slots;
+	struct kvm_vcpu *dst_vcpu, *src_vcpu;
+	struct kvm_tdx *src_tdx, *dst_tdx;
+	unsigned long i, j;
+	int ret;
+
+	src_tdx = to_kvm_tdx(src);
+	dst_tdx = to_kvm_tdx(dst);
+
+	src_slots = __kvm_memslots(src, 0);
+	dst_slots = __kvm_memslots(dst, 0);
+
+	ret = -EINVAL;
+
+	if (!src_tdx->finalized) {
+		pr_warn("Cannot migrate from a non finalized VM\n");
+		goto abort;
+	}
+
+	// Traverse both memslots in gfn order and compare them
+	for_each_memslot_pair(src_slots, dst_slots, src_memslot_iter, dst_memslot_iter) {
+		struct kvm_memory_slot *src_slot, *dst_slot;
+
+		src_slot =
+			container_of(src_memslot_iter, struct kvm_memory_slot,
+				     gfn_node[src_slots->node_idx]);
+		dst_slot =
+			container_of(src_memslot_iter, struct kvm_memory_slot,
+				     gfn_node[dst_slots->node_idx]);
+
+		if (src_slot->base_gfn != dst_slot->base_gfn ||
+		    src_slot->npages != dst_slot->npages) {
+			pr_warn("Cannot migrate between VMs with different memory slots configurations\n");
+			goto abort;
+		}
+
+		if (src_slot->flags != dst_slot->flags) {
+			pr_warn("Cannot migrate between VMs with different memory slots configurations\n");
+			goto abort;
+		}
+
+		if (src_slot->flags & KVM_MEM_PRIVATE) {
+			if (src_slot->restrictedmem.file->f_inode->i_ino !=
+			    dst_slot->restrictedmem.file->f_inode->i_ino) {
+				pr_warn("Private memslots points to different restricted files\n");
+				goto abort;
+			}
+
+			if (src_slot->restrictedmem.index != dst_slot->restrictedmem.index) {
+				pr_warn("Private memslots points to the restricted file at different offsets\n");
+				goto abort;
+			}
+		}
+	}
+
+	if (src_memslot_iter || dst_memslot_iter) {
+		pr_warn("Cannot migrate between VMs with different memory slots configurations\n");
+		goto abort;
+	}
+
+	dst_tdx->hkid = src_tdx->hkid;
+	dst_tdx->tdr_pa = src_tdx->tdr_pa;
+
+	dst_tdx->tdcs_pa = kcalloc(tdx_info.nr_tdcs_pages, sizeof(*dst_tdx->tdcs_pa),
+			  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!dst_tdx->tdcs_pa) {
+		ret = -ENOMEM;
+		goto late_abort;
+	}
+	memcpy(dst_tdx->tdcs_pa, src_tdx->tdcs_pa,
+	       tdx_info.nr_tdcs_pages * sizeof(*dst_tdx->tdcs_pa));
+
+	dst_tdx->tsc_offset = src_tdx->tsc_offset;
+	dst_tdx->attributes = src_tdx->attributes;
+	dst_tdx->xfam = src_tdx->xfam;
+	dst_tdx->kvm.arch.gfn_shared_mask = src_tdx->kvm.arch.gfn_shared_mask;
+
+	kvm_for_each_vcpu(i, src_vcpu, src)
+		tdx_flush_vp_on_cpu(src_vcpu);
+
+	/* Copy per-vCPU state */
+	kvm_for_each_vcpu(i, src_vcpu, src) {
+		src_tdx_vcpu = to_tdx(src_vcpu);
+		dst_vcpu = kvm_get_vcpu(dst, i);
+		dst_tdx_vcpu = to_tdx(dst_vcpu);
+
+		vcpu_load(dst_vcpu);
+
+		memcpy(dst_vcpu->arch.regs, src_vcpu->arch.regs,
+		       NR_VCPU_REGS * sizeof(src_vcpu->arch.regs[0]));
+		dst_vcpu->arch.regs_avail = src_vcpu->arch.regs_avail;
+		dst_vcpu->arch.regs_dirty = src_vcpu->arch.regs_dirty;
+
+		dst_vcpu->arch.tsc_offset = dst_tdx->tsc_offset;
+
+		dst_tdx_vcpu->interrupt_disabled_hlt = src_tdx_vcpu->interrupt_disabled_hlt;
+		dst_tdx_vcpu->buggy_hlt_workaround = src_tdx_vcpu->buggy_hlt_workaround;
+
+		dst_tdx_vcpu->tdvpr_pa = src_tdx_vcpu->tdvpr_pa;
+		dst_tdx_vcpu->tdvpx_pa = kcalloc(tdx_info.nr_tdvpx_pages,
+						 sizeof(*dst_tdx_vcpu->tdvpx_pa),
+						 GFP_KERNEL_ACCOUNT);
+		if (!dst_tdx_vcpu->tdvpx_pa) {
+			ret = -ENOMEM;
+			vcpu_put(dst_vcpu);
+			goto late_abort;
+		}
+		memcpy(dst_tdx_vcpu->tdvpx_pa, src_tdx_vcpu->tdvpx_pa,
+		       tdx_info.nr_tdvpx_pages * sizeof(*dst_tdx_vcpu->tdvpx_pa));
+
+		td_vmcs_write64(dst_tdx_vcpu, POSTED_INTR_DESC_ADDR, __pa(&dst_tdx_vcpu->pi_desc));
+
+		/* Copy private EPT tables */
+		if (kvm_mmu_move_private_pages_from(dst_vcpu, src_vcpu)) {
+			ret = -EINVAL;
+			vcpu_put(dst_vcpu);
+			goto late_abort;
+		}
+
+		for (j = 0; j < tdx_info.nr_tdvpx_pages; j++)
+			src_tdx_vcpu->tdvpx_pa[j] = 0;
+
+		src_tdx_vcpu->tdvpr_pa = 0;
+
+		vcpu_put(dst_vcpu);
+	}
+
+	for_each_memslot_pair(src_slots, dst_slots, src_memslot_iter,
+			      dst_memslot_iter) {
+		struct kvm_memory_slot *src_slot, *dst_slot;
+
+		src_slot = container_of(src_memslot_iter,
+					struct kvm_memory_slot,
+					gfn_node[src_slots->node_idx]);
+		dst_slot = container_of(src_memslot_iter,
+					struct kvm_memory_slot,
+					gfn_node[dst_slots->node_idx]);
+
+		for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
+			unsigned long ugfn;
+			int level = i + 1;
+
+			/*
+			 * If the gfn and userspace address are not aligned wrt each other, then
+			 * large page support should already be disabled at this level.
+			 */
+			ugfn = dst_slot->userspace_addr >> PAGE_SHIFT;
+			if ((dst_slot->base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE(level) - 1))
+				continue;
+
+			dst_slot->arch.lpage_info[i - 1] =
+				src_slot->arch.lpage_info[i - 1];
+			src_slot->arch.lpage_info[i - 1] = NULL;
+		}
+	}
+
+	dst->mem_attr_array.xa_head = src->mem_attr_array.xa_head;
+	src->mem_attr_array.xa_head = NULL;
+
+	dst_tdx->finalized = true;
+
+	/* Clear source VM to avoid freeing the hkid and pages on VM put */
+	src_tdx->hkid = -1;
+	src_tdx->tdr_pa = 0;
+	for (i = 0; i < tdx_info.nr_tdcs_pages; i++)
+		src_tdx->tdcs_pa[i] = 0;
+
+	return 0;
+
+late_abort:
+	/* If we aborted after the state transfer already started, the src VM
+	 * is no longer valid.
+	 */
+	kvm_vm_dead(src);
+
+abort:
+	dst_tdx->hkid = -1;
+	dst_tdx->tdr_pa = 0;
+
+	return ret;
 }
 
 int tdx_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
-- 
2.40.0.348.gf938b09366-goog

