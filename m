Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D875447E90
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 12:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239048AbhKHLNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 06:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237770AbhKHLNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 06:13:33 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3E9C061570;
        Mon,  8 Nov 2021 03:10:49 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id h24so6797003pjq.2;
        Mon, 08 Nov 2021 03:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8jSSqeVy8vWxhQKpZjIVcISTXzXxWLvD+5Tyd52WajI=;
        b=CGXrL7Szqcey6rgixGKQRLBVzTHsQWPL3nQbTfFgYc4jhEzzC1ihIKy2IHLKlS1kQ1
         cPxqSSsbp0Mtv7lfxzmJCL+8H4LRrztFKqLlpF1+WpFNCCrXKr4TYmmjjknSuhih28pF
         morKn0BkZnmz8dSk/l6geeql4gGlJjiL09yAFxTnggzuSCmwZ1TT0/yYDIK3hi32L31j
         92oV9cF0IESXa4GIfcvYqwQIKM3ZxdSNt3VRIh4an3o1giJUI5m+PTSoO8yWLGxmjeyx
         Q+UAj/rgaL2mjkQGzdyFYvlNY0jJi2WUFbStU1uyd3rKMaQMYLFREDj2R6ysumJoTHdD
         LTag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8jSSqeVy8vWxhQKpZjIVcISTXzXxWLvD+5Tyd52WajI=;
        b=Hh93tjZzks+tfkk0iizo34X6fOi/wF6ibdIz84tuJ55Bny7nRHTs+nWpMvCeLXSKYk
         p8kVKEbp9vlymshBcHoH4dxRNEzE/wt6nlEplSSE9ZVmIGjOoYS+LQbP8ZAfJV6bCM7E
         c7qeX+QZo68fnEianQoVDK9EKWWzck6IkSXCTs03Q+PEFVzaa7LZEhf3mJIaGL/ubFi+
         11Kk5pS5v/NZksGLXaBz/CSs5IvDTZ1UsbtNJ+c7ycesqpIpOY6ZpCg+iS+xdKQZq28T
         q5hzXis3t0vheVhSvRAEFVYk88nYg5pCgNOvdrOO4aiIxGUhAB/gXW7xaSlI0uVmq8UR
         xFWw==
X-Gm-Message-State: AOAM530LsEqXwMJmIle4X6HX78eVnPTVxwtkl2p58fNDAFSJFBlhtz8j
        FjuDHlQs1sgpBPesvIOUhl4=
X-Google-Smtp-Source: ABdhPJwfsgObEbV71zo/CJG0ylW1SJSjPYgEPsT6egadU8EMfy5M8slXcPloLypAAy/NRaveL9UgDg==
X-Received: by 2002:a17:90a:509:: with SMTP id h9mr52021587pjh.114.1636369848586;
        Mon, 08 Nov 2021 03:10:48 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ne7sm16559483pjb.36.2021.11.08.03.10.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 03:10:48 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/7] KVM: x86: Fix WARNING that macros should not use a trailing semicolon
Date:   Mon,  8 Nov 2021 19:10:27 +0800
Message-Id: <20211108111032.24457-3-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108111032.24457-1-likexu@tencent.com>
References: <20211108111032.24457-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The scripts/checkpatch.pl complains about the macro KVM_X86_OP in this way:

WARNING: macros should not use a trailing semicolon
+#define KVM_X86_OP(func) \
+	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 218 ++++++++++++++---------------
 arch/x86/include/asm/kvm_host.h    |   4 +-
 arch/x86/kvm/x86.c                 |   2 +-
 3 files changed, 112 insertions(+), 112 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index cefe1d81e2e8..8f1035cc2c06 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -12,115 +12,115 @@ BUILD_BUG_ON(1)
  * case where there is no definition or a function name that
  * doesn't match the typical naming convention is supplied.
  */
-KVM_X86_OP_NULL(hardware_enable)
-KVM_X86_OP_NULL(hardware_disable)
-KVM_X86_OP_NULL(hardware_unsetup)
-KVM_X86_OP_NULL(cpu_has_accelerated_tpr)
-KVM_X86_OP(has_emulated_msr)
-KVM_X86_OP(vcpu_after_set_cpuid)
-KVM_X86_OP(vm_init)
-KVM_X86_OP_NULL(vm_destroy)
-KVM_X86_OP(vcpu_create)
-KVM_X86_OP(vcpu_free)
-KVM_X86_OP(vcpu_reset)
-KVM_X86_OP(prepare_guest_switch)
-KVM_X86_OP(vcpu_load)
-KVM_X86_OP(vcpu_put)
-KVM_X86_OP(update_exception_bitmap)
-KVM_X86_OP(get_msr)
-KVM_X86_OP(set_msr)
-KVM_X86_OP(get_segment_base)
-KVM_X86_OP(get_segment)
-KVM_X86_OP(get_cpl)
-KVM_X86_OP(set_segment)
-KVM_X86_OP_NULL(get_cs_db_l_bits)
-KVM_X86_OP(set_cr0)
-KVM_X86_OP(is_valid_cr4)
-KVM_X86_OP(set_cr4)
-KVM_X86_OP(set_efer)
-KVM_X86_OP(get_idt)
-KVM_X86_OP(set_idt)
-KVM_X86_OP(get_gdt)
-KVM_X86_OP(set_gdt)
-KVM_X86_OP(sync_dirty_debug_regs)
-KVM_X86_OP(set_dr7)
-KVM_X86_OP(cache_reg)
-KVM_X86_OP(get_rflags)
-KVM_X86_OP(set_rflags)
-KVM_X86_OP(tlb_flush_all)
-KVM_X86_OP(tlb_flush_current)
-KVM_X86_OP_NULL(tlb_remote_flush)
-KVM_X86_OP_NULL(tlb_remote_flush_with_range)
-KVM_X86_OP(tlb_flush_gva)
-KVM_X86_OP(tlb_flush_guest)
-KVM_X86_OP(run)
-KVM_X86_OP_NULL(handle_exit)
-KVM_X86_OP_NULL(skip_emulated_instruction)
-KVM_X86_OP_NULL(update_emulated_instruction)
-KVM_X86_OP(set_interrupt_shadow)
-KVM_X86_OP(get_interrupt_shadow)
-KVM_X86_OP(patch_hypercall)
-KVM_X86_OP(set_irq)
-KVM_X86_OP(set_nmi)
-KVM_X86_OP(queue_exception)
-KVM_X86_OP(cancel_injection)
-KVM_X86_OP(interrupt_allowed)
-KVM_X86_OP(nmi_allowed)
-KVM_X86_OP(get_nmi_mask)
-KVM_X86_OP(set_nmi_mask)
-KVM_X86_OP(enable_nmi_window)
-KVM_X86_OP(enable_irq_window)
-KVM_X86_OP(update_cr8_intercept)
-KVM_X86_OP(check_apicv_inhibit_reasons)
-KVM_X86_OP(refresh_apicv_exec_ctrl)
-KVM_X86_OP(hwapic_irr_update)
-KVM_X86_OP(hwapic_isr_update)
-KVM_X86_OP_NULL(guest_apic_has_interrupt)
-KVM_X86_OP(load_eoi_exitmap)
-KVM_X86_OP(set_virtual_apic_mode)
-KVM_X86_OP_NULL(set_apic_access_page_addr)
-KVM_X86_OP(deliver_posted_interrupt)
-KVM_X86_OP_NULL(sync_pir_to_irr)
-KVM_X86_OP(set_tss_addr)
-KVM_X86_OP(set_identity_map_addr)
-KVM_X86_OP(get_mt_mask)
-KVM_X86_OP(load_mmu_pgd)
-KVM_X86_OP_NULL(has_wbinvd_exit)
-KVM_X86_OP(get_l2_tsc_offset)
-KVM_X86_OP(get_l2_tsc_multiplier)
-KVM_X86_OP(write_tsc_offset)
-KVM_X86_OP(write_tsc_multiplier)
-KVM_X86_OP(get_exit_info)
-KVM_X86_OP(check_intercept)
-KVM_X86_OP(handle_exit_irqoff)
-KVM_X86_OP_NULL(request_immediate_exit)
-KVM_X86_OP(sched_in)
-KVM_X86_OP_NULL(update_cpu_dirty_logging)
-KVM_X86_OP_NULL(pre_block)
-KVM_X86_OP_NULL(post_block)
-KVM_X86_OP_NULL(vcpu_blocking)
-KVM_X86_OP_NULL(vcpu_unblocking)
-KVM_X86_OP_NULL(update_pi_irte)
-KVM_X86_OP_NULL(start_assignment)
-KVM_X86_OP_NULL(apicv_post_state_restore)
-KVM_X86_OP_NULL(dy_apicv_has_pending_interrupt)
-KVM_X86_OP_NULL(set_hv_timer)
-KVM_X86_OP_NULL(cancel_hv_timer)
-KVM_X86_OP(setup_mce)
-KVM_X86_OP(smi_allowed)
-KVM_X86_OP(enter_smm)
-KVM_X86_OP(leave_smm)
-KVM_X86_OP(enable_smi_window)
-KVM_X86_OP_NULL(mem_enc_op)
-KVM_X86_OP_NULL(mem_enc_reg_region)
-KVM_X86_OP_NULL(mem_enc_unreg_region)
-KVM_X86_OP(get_msr_feature)
-KVM_X86_OP(can_emulate_instruction)
-KVM_X86_OP(apic_init_signal_blocked)
-KVM_X86_OP_NULL(enable_direct_tlbflush)
-KVM_X86_OP_NULL(migrate_timers)
-KVM_X86_OP(msr_filter_changed)
-KVM_X86_OP_NULL(complete_emulated_msr)
+KVM_X86_OP_NULL(hardware_enable);
+KVM_X86_OP_NULL(hardware_disable);
+KVM_X86_OP_NULL(hardware_unsetup);
+KVM_X86_OP_NULL(cpu_has_accelerated_tpr);
+KVM_X86_OP(has_emulated_msr);
+KVM_X86_OP(vcpu_after_set_cpuid);
+KVM_X86_OP(vm_init);
+KVM_X86_OP_NULL(vm_destroy);
+KVM_X86_OP(vcpu_create);
+KVM_X86_OP(vcpu_free);
+KVM_X86_OP(vcpu_reset);
+KVM_X86_OP(prepare_guest_switch);
+KVM_X86_OP(vcpu_load);
+KVM_X86_OP(vcpu_put);
+KVM_X86_OP(update_exception_bitmap);
+KVM_X86_OP(get_msr);
+KVM_X86_OP(set_msr);
+KVM_X86_OP(get_segment_base);
+KVM_X86_OP(get_segment);
+KVM_X86_OP(get_cpl);
+KVM_X86_OP(set_segment);
+KVM_X86_OP_NULL(get_cs_db_l_bits);
+KVM_X86_OP(set_cr0);
+KVM_X86_OP(is_valid_cr4);
+KVM_X86_OP(set_cr4);
+KVM_X86_OP(set_efer);
+KVM_X86_OP(get_idt);
+KVM_X86_OP(set_idt);
+KVM_X86_OP(get_gdt);
+KVM_X86_OP(set_gdt);
+KVM_X86_OP(sync_dirty_debug_regs);
+KVM_X86_OP(set_dr7);
+KVM_X86_OP(cache_reg);
+KVM_X86_OP(get_rflags);
+KVM_X86_OP(set_rflags);
+KVM_X86_OP(tlb_flush_all);
+KVM_X86_OP(tlb_flush_current);
+KVM_X86_OP_NULL(tlb_remote_flush);
+KVM_X86_OP_NULL(tlb_remote_flush_with_range);
+KVM_X86_OP(tlb_flush_gva);
+KVM_X86_OP(tlb_flush_guest);
+KVM_X86_OP(run);
+KVM_X86_OP_NULL(handle_exit);
+KVM_X86_OP_NULL(skip_emulated_instruction);
+KVM_X86_OP_NULL(update_emulated_instruction);
+KVM_X86_OP(set_interrupt_shadow);
+KVM_X86_OP(get_interrupt_shadow);
+KVM_X86_OP(patch_hypercall);
+KVM_X86_OP(set_irq);
+KVM_X86_OP(set_nmi);
+KVM_X86_OP(queue_exception);
+KVM_X86_OP(cancel_injection);
+KVM_X86_OP(interrupt_allowed);
+KVM_X86_OP(nmi_allowed);
+KVM_X86_OP(get_nmi_mask);
+KVM_X86_OP(set_nmi_mask);
+KVM_X86_OP(enable_nmi_window);
+KVM_X86_OP(enable_irq_window);
+KVM_X86_OP(update_cr8_intercept);
+KVM_X86_OP(check_apicv_inhibit_reasons);
+KVM_X86_OP(refresh_apicv_exec_ctrl);
+KVM_X86_OP(hwapic_irr_update);
+KVM_X86_OP(hwapic_isr_update);
+KVM_X86_OP_NULL(guest_apic_has_interrupt);
+KVM_X86_OP(load_eoi_exitmap);
+KVM_X86_OP(set_virtual_apic_mode);
+KVM_X86_OP_NULL(set_apic_access_page_addr);
+KVM_X86_OP(deliver_posted_interrupt);
+KVM_X86_OP_NULL(sync_pir_to_irr);
+KVM_X86_OP(set_tss_addr);
+KVM_X86_OP(set_identity_map_addr);
+KVM_X86_OP(get_mt_mask);
+KVM_X86_OP(load_mmu_pgd);
+KVM_X86_OP_NULL(has_wbinvd_exit);
+KVM_X86_OP(get_l2_tsc_offset);
+KVM_X86_OP(get_l2_tsc_multiplier);
+KVM_X86_OP(write_tsc_offset);
+KVM_X86_OP(write_tsc_multiplier);
+KVM_X86_OP(get_exit_info);
+KVM_X86_OP(check_intercept);
+KVM_X86_OP(handle_exit_irqoff);
+KVM_X86_OP_NULL(request_immediate_exit);
+KVM_X86_OP(sched_in);
+KVM_X86_OP_NULL(update_cpu_dirty_logging);
+KVM_X86_OP_NULL(pre_block);
+KVM_X86_OP_NULL(post_block);
+KVM_X86_OP_NULL(vcpu_blocking);
+KVM_X86_OP_NULL(vcpu_unblocking);
+KVM_X86_OP_NULL(update_pi_irte);
+KVM_X86_OP_NULL(start_assignment);
+KVM_X86_OP_NULL(apicv_post_state_restore);
+KVM_X86_OP_NULL(dy_apicv_has_pending_interrupt);
+KVM_X86_OP_NULL(set_hv_timer);
+KVM_X86_OP_NULL(cancel_hv_timer);
+KVM_X86_OP(setup_mce);
+KVM_X86_OP(smi_allowed);
+KVM_X86_OP(enter_smm);
+KVM_X86_OP(leave_smm);
+KVM_X86_OP(enable_smi_window);
+KVM_X86_OP_NULL(mem_enc_op);
+KVM_X86_OP_NULL(mem_enc_reg_region);
+KVM_X86_OP_NULL(mem_enc_unreg_region);
+KVM_X86_OP(get_msr_feature);
+KVM_X86_OP(can_emulate_instruction);
+KVM_X86_OP(apic_init_signal_blocked);
+KVM_X86_OP_NULL(enable_direct_tlbflush);
+KVM_X86_OP_NULL(migrate_timers);
+KVM_X86_OP(msr_filter_changed);
+KVM_X86_OP_NULL(complete_emulated_msr);
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88fce6ab4bbd..c2a4a362f3e2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1532,14 +1532,14 @@ extern bool __read_mostly enable_apicv;
 extern struct kvm_x86_ops kvm_x86_ops;
 
 #define KVM_X86_OP(func) \
-	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
+	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func))
 #define KVM_X86_OP_NULL KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 
 static inline void kvm_ops_static_call_update(void)
 {
 #define KVM_X86_OP(func) \
-	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
+	static_call_update(kvm_x86_##func, kvm_x86_ops.func)
 #define KVM_X86_OP_NULL KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b..775051070627 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -125,7 +125,7 @@ EXPORT_SYMBOL_GPL(kvm_x86_ops);
 
 #define KVM_X86_OP(func)					     \
 	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
-				*(((struct kvm_x86_ops *)0)->func));
+				*(((struct kvm_x86_ops *)0)->func))
 #define KVM_X86_OP_NULL KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
-- 
2.33.0

