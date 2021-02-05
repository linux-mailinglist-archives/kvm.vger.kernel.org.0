Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A1B3116F1
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 00:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhBEXVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 18:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhBEKFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 05:05:12 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AB3C0613D6
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 02:03:54 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u15so3327853plf.1
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 02:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FilYAXp/1U5qgMafqsEdK0P1Xi4LY+vWvA6f43BJizM=;
        b=faL8C3H0CB0RFswE1zUeBVo0tQZy1gepj8Pag6DA5fjHi9zxp3oUCSc8ZMlR7qkBTG
         WXEN/PiFUOu2+I9YB3XYG/Xqu3pjuzh2Qh1AnecnVDW8CazR92SbGKEg0ruhqK4Ia9O2
         C3FQNkuTOMV826bhIWB2UqJcnmfcUypQle9KtQoHchRZ+vBYwPjfEJvX+y6XOikBhEKn
         vywkxb+2JwUbrEHofcJ2QFxlHLOnVfLsd4n5Xm5U/iCNXpgZd+KP81WZXkPaDBHzULj3
         +yaINCFXZ0kYX3x1+ZrGSmsA/F7idDddgZW9dyERwtS/VNN3DKW2q1pNpGM0PupEn5lw
         Ws9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FilYAXp/1U5qgMafqsEdK0P1Xi4LY+vWvA6f43BJizM=;
        b=hHW51/ZN+YCRLaKH6ZLJr+Av+eAjkEfSZVFpExIcxlTFBmygeZKBDh61PSoQ0nTThm
         JQs/s74abRwOmiZf/OqqMUJ06UK6YGcjF4Mz3dCJVDCglrsuWR3yrdq4RYS8gPSk0DVu
         Fta64i8sSTq9Ca2CKsiOjUyjtuvXXFTa9jnT4ZDIqhoq7/0xEzkWnoOCS8b7TDv+oycx
         14qXgT2xmdhjclIfl+46eX9SVgvBfGIoQDwDyMUC7KCjr5xtJMthg/ZqsOD0cyXue26G
         M4E6Rzi24ocsfWTOaSGULIlOZa5w1Ty8/21qoSAGqqCmsHzDHJPYdpYEDszejncdg2hK
         i32Q==
X-Gm-Message-State: AOAM531moyqM6/3T1wTJHtbEiVM1KFCrHLLKUMVhC4qn37ytFZdKQ261
        Eme+Y5F6mh2RVIM2qu6Ccpr07w==
X-Google-Smtp-Source: ABdhPJwJ+RppPaIaIRMKZIUyJquZunTClAkICW+cyTvTAP/CZWLkkYbKDuui7GMyunJ0b1yVwq9huQ==
X-Received: by 2002:a17:902:a710:b029:dc:3817:e7c2 with SMTP id w16-20020a170902a710b02900dc3817e7c2mr3515718plq.0.1612519434259;
        Fri, 05 Feb 2021 02:03:54 -0800 (PST)
Received: from C02CC49MMD6R.bytedance.net ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id l12sm8142562pjg.54.2021.02.05.02.03.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Feb 2021 02:03:53 -0800 (PST)
From:   Zhimin Feng <fengzhimin@bytedance.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        fweisbec@gmail.com, zhouyibo@bytedance.com,
        zhanghaozhong@bytedance.com, Zhimin Feng <fengzhimin@bytedance.com>
Subject: [RFC: timer passthrough 4/9] KVM: vmx: enable passth timer switch to sw timer
Date:   Fri,  5 Feb 2021 18:03:12 +0800
Message-Id: <20210205100317.24174-5-fengzhimin@bytedance.com>
X-Mailer: git-send-email 2.24.1 (Apple Git-126)
In-Reply-To: <20210205100317.24174-1-fengzhimin@bytedance.com>
References: <20210205100317.24174-1-fengzhimin@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Switch the guest timer to software timer when the
VCPU is scheduled.

Signed-off-by: Zhimin Feng <fengzhimin@bytedance.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 65 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              | 12 ++++++--
 3 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 500fa031297d..be8fc230f7c4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1305,6 +1305,7 @@ struct kvm_x86_ops {
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
 	void (*set_timer_passthrough)(struct kvm_vcpu *vcpu, bool enable);
 	int (*host_timer_can_passth)(struct kvm_vcpu *vcpu);
+	void (*switch_to_sw_timer)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 42cf0a3ad493..f824ee46e2d3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -28,6 +28,8 @@
 #include <linux/tboot.h>
 #include <linux/trace_events.h>
 #include <linux/entry-kvm.h>
+#include <linux/percpu.h>
+#include <linux/tick.h>
 
 #include <asm/apic.h>
 #include <asm/asm.h>
@@ -6702,6 +6704,27 @@ static void vmx_host_lapic_timer_offload(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void vmx_restore_passth_timer(struct kvm_vcpu *vcpu)
+{
+	struct timer_passth_info *local_timer_info;
+	u64 host_tscd;
+	u64 guest_tscd;
+
+	if (vcpu->arch.timer_passth_enable) {
+		local_timer_info = &per_cpu(passth_info, smp_processor_id());
+		host_tscd = local_timer_info->host_tscd;
+		rdmsrl(MSR_IA32_TSC_DEADLINE, guest_tscd);
+
+		if (guest_tscd != 0 &&
+			guest_tscd != host_tscd) {
+			vcpu->arch.tscd = guest_tscd;
+		}
+
+		if (host_tscd > rdtsc())
+			wrmsrl(MSR_IA32_TSC_DEADLINE, host_tscd);
+	}
+}
+
 static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 					struct vcpu_vmx *vmx)
 {
@@ -6836,6 +6859,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
 	vmx_vcpu_enter_exit(vcpu, vmx);
 
+	vmx_restore_passth_timer(vcpu);
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the
 	 * SPEC_CTRL MSR it may have left it on; save the value and
@@ -7589,11 +7613,50 @@ static void vmx_enable_log_dirty_pt_masked(struct kvm *kvm,
 	kvm_mmu_clear_dirty_pt_masked(kvm, memslot, offset, mask);
 }
 
+static void vmx_passth_switch_to_sw_timer(struct kvm_vcpu *vcpu)
+{
+	struct kvm_timer *ktimer;
+	ktime_t expire;
+	u64 guest_tscl;
+	ktime_t now;
+	u64 ns;
+	unsigned long flags;
+	unsigned long this_tsc_khz = vcpu->arch.virtual_tsc_khz;
+
+	ktimer = &vcpu->arch.apic->lapic_timer;
+	if (hrtimer_active(&ktimer->timer))
+		return;
+
+	local_irq_save(flags);
+	now = ktime_get();
+
+	guest_tscl = kvm_read_l1_tsc(vcpu, rdtsc());
+	ns = (vcpu->arch.tscd - guest_tscl) * 1000000ULL;
+	do_div(ns, this_tsc_khz);
+	if (likely(vcpu->arch.tscd > guest_tscl) &&
+		likely(ns > ktimer->timer_advance_ns)) {
+		expire = ktime_add_ns(now, ns);
+		expire = ktime_sub_ns(expire, ktimer->timer_advance_ns);
+		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS_PINNED);
+	} else {
+		if (vcpu->arch.tscd > 0) {
+			if (!atomic_read(&vcpu->arch.apic->lapic_timer.pending)) {
+				atomic_inc(&vcpu->arch.apic->lapic_timer.pending);
+				kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
+			}
+		}
+	}
+
+	local_irq_restore(flags);
+}
+
 static int vmx_pre_block(struct kvm_vcpu *vcpu)
 {
 	if (pi_pre_block(vcpu))
 		return 1;
 
+	vmx_passth_switch_to_sw_timer(vcpu);
+
 	if (kvm_lapic_hv_timer_in_use(vcpu))
 		kvm_lapic_switch_to_sw_timer(vcpu);
 
@@ -7722,6 +7785,7 @@ static void vmx_set_timer_passthrough(struct kvm_vcpu *vcpu, bool enable)
 	} else {
 		vmx_enable_intercept_for_msr(vcpu, MSR_IA32_TSC_DEADLINE,
 									 MSR_TYPE_RW);
+		vmx_passth_switch_to_sw_timer(vcpu);
 		vmcs_clear_bits(PIN_BASED_VM_EXEC_CONTROL,
 				PIN_BASED_VMX_PREEMPTION_TIMER);
 		vcpu->arch.timer_passth_enable = 0;
@@ -7877,6 +7941,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.msr_filter_changed = vmx_msr_filter_changed,
 	.set_timer_passthrough = vmx_set_timer_passthrough,
 	.host_timer_can_passth = vmx_host_timer_can_passth,
+	.switch_to_sw_timer = vmx_passth_switch_to_sw_timer,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e51fd52a4862..2b4aa925d6d9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9094,8 +9094,11 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 			r = vcpu_block(kvm, vcpu);
 		}
 
-		if (r <= 0)
+		if (r <= 0) {
+			if (kvm_x86_ops.switch_to_sw_timer)
+				kvm_x86_ops.switch_to_sw_timer(vcpu);
 			break;
+		}
 
 		kvm_clear_request(KVM_REQ_PENDING_TIMER, vcpu);
 		if (kvm_cpu_has_pending_timer(vcpu))
@@ -9106,14 +9109,19 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 			r = 0;
 			vcpu->run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
 			++vcpu->stat.request_irq_exits;
+			if (kvm_x86_ops.switch_to_sw_timer)
+				kvm_x86_ops.switch_to_sw_timer(vcpu);
 			break;
 		}
 
 		if (__xfer_to_guest_mode_work_pending()) {
 			srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 			r = xfer_to_guest_mode_handle_work(vcpu);
-			if (r)
+			if (r) {
+				if (kvm_x86_ops.switch_to_sw_timer)
+					kvm_x86_ops.switch_to_sw_timer(vcpu);
 				return r;
+			}
 			vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 		}
 	}
-- 
2.11.0

