Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45D53A1D58
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhFITAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 15:00:01 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:50724 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhFIS74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:59:56 -0400
Received: by mail-yb1-f201.google.com with SMTP id o12-20020a5b050c0000b02904f4a117bd74so32593367ybp.17
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=eACkUeFfuUiPlaNvgW9UxqbJ/GQZvO8YT90FWGwtv9Y=;
        b=BRh7I25eDc9/17l9JAfjS5kDUusX6T/ft5xtd1S5TOv0BpPXxAfn3kkS3vggUvg7QO
         /LwS3HL0tNSSTRYOQU7cbyZcogiNmF0Lz8kmIgQA8Y2Qd4IKH5aEtElLG2zB1F+btohz
         3lSPPYShgIpxGuxzw+ulMJiZdoGiXdUvMd2tpIP3O+wFXLKapqyCxuK5yQNA6R+rr5aq
         TF9Nhgx4gmu16UC0vQ3sXnjqYX76h9FA+jfM7j6py7/PUjc8zhibrr9HAtXcNeE0Sgf5
         0wwLsssWr7PgC4BvT99FcCgLYCHIBvCsgnrZmEnZpQY+Bh0fDAQNFEHV2hxyAaK2qMGB
         4+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=eACkUeFfuUiPlaNvgW9UxqbJ/GQZvO8YT90FWGwtv9Y=;
        b=P42aOScXtJkOdvzWH8zxd68Xkc91pRD1+U8a11pHAIDNQXIchhgRplsARw+IcLf9u4
         w4P5bGpqrbxMvQAT/G4euO5E1kF2qT1G5M0HUHilAsPm/lX9LbYW1sBHpYOmwvJIt3Re
         9i4BmBoQ7Dzfba0HYCaWgblPKL9XhVk+Y6RHjdrk40NrYYhZCDqUUr/isniBFArQJ7gm
         SA3gFcsHDWwrA2xcMPgWljp8mxDKac1nasVu1Wmse81AAiNlsXNRLx3EoUHkht/ZHc/X
         Ex+bZswVoRxQ0CA68RKXMgF+3tzoHmQdqZVT96ynnhFkRjJjLtVh8pB9v5YNuYvY6mOA
         K5pw==
X-Gm-Message-State: AOAM533ku7kdp5qALynoKzgDQXWuCVTMC2L6jUETsjHRDsH2+r/0PviG
        oaYvv9rCm9E/z+nziWHp0JHedNEBavU=
X-Google-Smtp-Source: ABdhPJyss4jj1Rs7sEaBXYb8PHmhAqS0JbST/Ve9yZfXRjVvFOOVJnNIrDCJxCgxCcejPvPTBI7ncUcHPZQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:bfdc:c2e5:77b1:8ef3])
 (user=seanjc job=sendgmr) by 2002:a25:488a:: with SMTP id v132mr1991471yba.467.1623265010531;
 Wed, 09 Jun 2021 11:56:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 11:56:19 -0700
In-Reply-To: <20210609185619.992058-1-seanjc@google.com>
Message-Id: <20210609185619.992058-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210609185619.992058-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 9/9] KVM: x86: Drop "pre_" from enter/leave_smm() helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that .post_leave_smm() is gone, drop "pre_" from the remaining
helpers.  The helpers aren't invoked purely before SMI/RSM processing,
e.g. both helpers are invoked after state is snapshotted (from regs or
SMRAM), and the RSM helper is invoked after some amount of register state
has been stuffed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  4 ++--
 arch/x86/include/asm/kvm_host.h    |  4 ++--
 arch/x86/kvm/emulate.c             |  6 +++---
 arch/x86/kvm/kvm_emulate.h         |  3 +--
 arch/x86/kvm/svm/svm.c             |  8 ++++----
 arch/x86/kvm/vmx/vmx.c             |  8 ++++----
 arch/x86/kvm/x86.c                 | 14 +++++++-------
 7 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index e7bef91cee04..99b0c80db311 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -106,8 +106,8 @@ KVM_X86_OP_NULL(set_hv_timer)
 KVM_X86_OP_NULL(cancel_hv_timer)
 KVM_X86_OP(setup_mce)
 KVM_X86_OP(smi_allowed)
-KVM_X86_OP(pre_enter_smm)
-KVM_X86_OP(pre_leave_smm)
+KVM_X86_OP(enter_smm)
+KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
 KVM_X86_OP_NULL(mem_enc_op)
 KVM_X86_OP_NULL(mem_enc_reg_region)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9c7ced0e3171..de43070afdb6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1363,8 +1363,8 @@ struct kvm_x86_ops {
 	void (*setup_mce)(struct kvm_vcpu *vcpu);
 
 	int (*smi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
-	int (*pre_enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
-	int (*pre_leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
+	int (*enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
+	int (*leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 
 	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 34c9f785d715..cb57ad5961d0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2677,11 +2677,11 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
 	}
 
 	/*
-	 * Give pre_leave_smm() a chance to make ISA-specific changes to the
-	 * vCPU state (e.g. enter guest mode) before loading state from the SMM
+	 * Give leave_smm() a chance to make ISA-specific changes to the vCPU
+	 * state (e.g. enter guest mode) before loading state from the SMM
 	 * state-save area.
 	 */
-	if (ctxt->ops->pre_leave_smm(ctxt, buf))
+	if (ctxt->ops->leave_smm(ctxt, buf))
 		goto emulate_shutdown;
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 31dc7ca4ff2b..3a2b6f5c7193 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -230,8 +230,7 @@ struct x86_emulate_ops {
 
 	unsigned (*get_hflags)(struct x86_emulate_ctxt *ctxt);
 	void (*exiting_smm)(struct x86_emulate_ctxt *ctxt);
-	int (*pre_leave_smm)(struct x86_emulate_ctxt *ctxt,
-			     const char *smstate);
+	int (*leave_smm)(struct x86_emulate_ctxt *ctxt, const char *smstate);
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
 };
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8c3918a11826..322a0baa4b37 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4249,7 +4249,7 @@ static int svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return !svm_smi_blocked(vcpu);
 }
 
-static int svm_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
+static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret;
@@ -4271,7 +4271,7 @@ static int svm_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	return 0;
 }
 
-static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
+static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_host_map map;
@@ -4544,8 +4544,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.setup_mce = svm_setup_mce,
 
 	.smi_allowed = svm_smi_allowed,
-	.pre_enter_smm = svm_pre_enter_smm,
-	.pre_leave_smm = svm_pre_leave_smm,
+	.enter_smm = svm_enter_smm,
+	.leave_smm = svm_leave_smm,
 	.enable_smi_window = svm_enable_smi_window,
 
 	.mem_enc_op = svm_mem_enc_op,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 50b42d7a8a11..06e084ab16de 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7541,7 +7541,7 @@ static int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return !is_smm(vcpu);
 }
 
-static int vmx_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
+static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -7555,7 +7555,7 @@ static int vmx_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	return 0;
 }
 
-static int vmx_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
+static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int ret;
@@ -7730,8 +7730,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.setup_mce = vmx_setup_mce,
 
 	.smi_allowed = vmx_smi_allowed,
-	.pre_enter_smm = vmx_pre_enter_smm,
-	.pre_leave_smm = vmx_pre_leave_smm,
+	.enter_smm = vmx_enter_smm,
+	.leave_smm = vmx_leave_smm,
 	.enable_smi_window = vmx_enable_smi_window,
 
 	.can_emulate_instruction = vmx_can_emulate_instruction,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 347849caf1df..7710932cc12a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7106,10 +7106,10 @@ static void emulator_exiting_smm(struct x86_emulate_ctxt *ctxt)
 	kvm_smm_changed(vcpu, false);
 }
 
-static int emulator_pre_leave_smm(struct x86_emulate_ctxt *ctxt,
+static int emulator_leave_smm(struct x86_emulate_ctxt *ctxt,
 				  const char *smstate)
 {
-	return static_call(kvm_x86_pre_leave_smm)(emul_to_vcpu(ctxt), smstate);
+	return static_call(kvm_x86_leave_smm)(emul_to_vcpu(ctxt), smstate);
 }
 
 static void emulator_triple_fault(struct x86_emulate_ctxt *ctxt)
@@ -7164,7 +7164,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.set_nmi_mask        = emulator_set_nmi_mask,
 	.get_hflags          = emulator_get_hflags,
 	.exiting_smm         = emulator_exiting_smm,
-	.pre_leave_smm       = emulator_pre_leave_smm,
+	.leave_smm           = emulator_leave_smm,
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
 };
@@ -8896,11 +8896,11 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 		enter_smm_save_state_32(vcpu, buf);
 
 	/*
-	 * Give pre_enter_smm() a chance to make ISA-specific changes to the
-	 * vCPU state (e.g. leave guest mode) after we've saved the state into
-	 * the SMM state-save area.
+	 * Give enter_smm() a chance to make ISA-specific changes to the vCPU
+	 * state (e.g. leave guest mode) after we've saved the state into the
+	 * SMM state-save area.
 	 */
-	static_call(kvm_x86_pre_enter_smm)(vcpu, buf);
+	static_call(kvm_x86_enter_smm)(vcpu, buf);
 
 	kvm_smm_changed(vcpu, true);
 	kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, buf, sizeof(buf));
-- 
2.32.0.rc1.229.g3e70b5a671-goog

