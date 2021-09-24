Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEBD41758D
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345870AbhIXNZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346009AbhIXNY6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:58 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6E6C08EB30
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:34 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id e5-20020ac84905000000b002a69dc43859so28868003qtq.10
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rJLpdf6u1WB31SB8LdZpMEp1sCxrtW/YQMF2TRdpoIw=;
        b=TexyxHJdUF1BKJ7n5bPF6ww67h6lEEzkA/FZiA0Gdq52o1XP4F9AnYzrMULrZjPCLZ
         vFKXDbAPKDTbWQQ1UjQrquLyqY8CWeKRdvSPk7EpWN8QlKGB63nXMTwW9QD8Cb3rwAoA
         D2v4S87wY6lsjeOwQYJK8yV+YDdG2sAlINVWFov6UWfLKHkM3tkFVbyoyWmP2SRCupQa
         7P3pwD5TDmIS4etf6pUSwQrsDQvM+HfDNSJ+LFWzcjNrqMqYrWVF/JnKLpC0Olhyc2xr
         PJ18FhnSNtm7gDIt6gNigyky/YyG7q1zBbVTQV2f+Qapp7lQgVnvbL5WjFFN8sNoHAA8
         tdRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rJLpdf6u1WB31SB8LdZpMEp1sCxrtW/YQMF2TRdpoIw=;
        b=KeI/knEScogZc//w+fSvuhOqQAz66jFkPOwXJ/yv5e9f8w/Vf9IJuVvIy20xn33bAC
         MowFtdYGs2CBdOIcz87uVKDWa6Ynd01mvKEkIRRdweHjOZmIaRCVETYVjd4jD9EVQ1Ui
         dv4m/ODaSoG38NuKlGdC8rsMaz83Ht0BCsuNCI6gCWJdMoLX+OsT6kstNPOZ8LH4t1Vk
         Ie2aD6hx6RrMDgznjsi7hhpPravXBaVrIH+JdyuLSwB20FZHyOPn270C2cQUQikIZZZ1
         hwZi/cwVT+bK9Snff5NdLwsxHRjBYQvBU4KeUEC2kLtU/rJrnv7iKv1DKu3Jf5wynHvU
         yjhQ==
X-Gm-Message-State: AOAM53161czfCO+/gxkEaKfo3HmO1S2Bj88jo+iZndRDLAODN+p27qDx
        RoZaUblsnS8JkFfn+V4zOp/g/ixK8g==
X-Google-Smtp-Source: ABdhPJwvUqf3HFnKY+dtVGjbluhQ8kvmArVd8MPsfCPGMinMVDjnOArEBYtnbUYdJdOADNOZ9fnGT01pEw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:1243:: with SMTP id
 q3mr9801960qvv.0.1632488073615; Fri, 24 Sep 2021 05:54:33 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:44 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-16-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 15/30] KVM: arm64: COCCI: vgic3_cpu.cocci: reduce scope
 of vgic v3
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vgic v3 interface functions are passed vcpu, when the state
that they need is the vgic interface, as well as the
kvm_cpu_context and the recently created vcpu_hyp_state. Reduce
the scope of its interface functions to these structs.

This applies the semantic patch with the following command:

spatch --sp-file cocci_refactor/vgic3_cpu.cocci arch/arm64/kvm/hyp/vgic-v3-sr.c --in-place

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 247 ++++++++++++++++++--------------
 1 file changed, 137 insertions(+), 110 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index d025a5830dcc..3e1951b04fce 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -471,11 +471,10 @@ static int __vgic_v3_bpr_min(void)
 	return 8 - vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
 }
 
-static int __vgic_v3_get_group(struct kvm_vcpu *vcpu)
+static int __vgic_v3_get_group(struct kvm_cpu_context *vcpu_ctxt,
+			       struct vcpu_hyp_state *vcpu_hyps)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u32 esr = kvm_hyp_state_get_esr(vcpu_hyps);
 	u8 crm = (esr & ESR_ELx_SYS64_ISS_CRM_MASK) >> ESR_ELx_SYS64_ISS_CRM_SHIFT;
 
 	return crm != 8;
@@ -483,10 +482,11 @@ static int __vgic_v3_get_group(struct kvm_vcpu *vcpu)
 
 #define GICv3_IDLE_PRIORITY	0xff
 
-static int __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu, u32 vmcr,
+static int __vgic_v3_highest_priority_lr(struct vgic_v3_cpu_if *cpu_if,
+					 u32 vmcr,
 					 u64 *lr_val)
 {
-	unsigned int used_lrs = vcpu->arch.vgic_cpu.vgic_v3.used_lrs;
+	unsigned int used_lrs = cpu_if->used_lrs;
 	u8 priority = GICv3_IDLE_PRIORITY;
 	int i, lr = -1;
 
@@ -522,10 +522,10 @@ static int __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu, u32 vmcr,
 	return lr;
 }
 
-static int __vgic_v3_find_active_lr(struct kvm_vcpu *vcpu, int intid,
+static int __vgic_v3_find_active_lr(struct vgic_v3_cpu_if *cpu_if, int intid,
 				    u64 *lr_val)
 {
-	unsigned int used_lrs = vcpu->arch.vgic_cpu.vgic_v3.used_lrs;
+	unsigned int used_lrs = cpu_if->used_lrs;
 	int i;
 
 	for (i = 0; i < used_lrs; i++) {
@@ -673,17 +673,18 @@ static int __vgic_v3_clear_highest_active_priority(void)
 	return GICv3_IDLE_PRIORITY;
 }
 
-static void __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_read_iar(struct vgic_v3_cpu_if *cpu_if,
+			       struct kvm_cpu_context *vcpu_ctxt,
+			       struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+			       int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 lr_val;
 	u8 lr_prio, pmr;
 	int lr, grp;
 
-	grp = __vgic_v3_get_group(vcpu);
+	grp = __vgic_v3_get_group(vcpu_ctxt, vcpu_hyps);
 
-	lr = __vgic_v3_highest_priority_lr(vcpu, vmcr, &lr_val);
+	lr = __vgic_v3_highest_priority_lr(cpu_if, vmcr, &lr_val);
 	if (lr < 0)
 		goto spurious;
 
@@ -733,10 +734,11 @@ static void __vgic_v3_bump_eoicount(void)
 	write_gicreg(hcr, ICH_HCR_EL2);
 }
 
-static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_dir(struct vgic_v3_cpu_if *cpu_if,
+				struct kvm_cpu_context *vcpu_ctxt,
+				struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 vid = ctxt_get_reg(vcpu_ctxt, rt);
 	u64 lr_val;
 	int lr;
@@ -749,7 +751,7 @@ static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	if (vid >= VGIC_MIN_LPI)
 		return;
 
-	lr = __vgic_v3_find_active_lr(vcpu, vid, &lr_val);
+	lr = __vgic_v3_find_active_lr(cpu_if, vid, &lr_val);
 	if (lr == -1) {
 		__vgic_v3_bump_eoicount();
 		return;
@@ -758,16 +760,17 @@ static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	__vgic_v3_clear_active_lr(lr, lr_val);
 }
 
-static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_eoir(struct vgic_v3_cpu_if *cpu_if,
+				 struct kvm_cpu_context *vcpu_ctxt,
+				 struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				 int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 vid = ctxt_get_reg(vcpu_ctxt, rt);
 	u64 lr_val;
 	u8 lr_prio, act_prio;
 	int lr, grp;
 
-	grp = __vgic_v3_get_group(vcpu);
+	grp = __vgic_v3_get_group(vcpu_ctxt, vcpu_hyps);
 
 	/* Drop priority in any case */
 	act_prio = __vgic_v3_clear_highest_active_priority();
@@ -780,7 +783,7 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	if (vmcr & ICH_VMCR_EOIM_MASK)
 		return;
 
-	lr = __vgic_v3_find_active_lr(vcpu, vid, &lr_val);
+	lr = __vgic_v3_find_active_lr(cpu_if, vid, &lr_val);
 	if (lr == -1) {
 		__vgic_v3_bump_eoicount();
 		return;
@@ -797,24 +800,27 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	__vgic_v3_clear_active_lr(lr, lr_val);
 }
 
-static void __vgic_v3_read_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_read_igrpen0(struct vgic_v3_cpu_if *cpu_if,
+				   struct kvm_cpu_context *vcpu_ctxt,
+				   struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				   int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	ctxt_set_reg(vcpu_ctxt, rt, !!(vmcr & ICH_VMCR_ENG0_MASK));
 }
 
-static void __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_read_igrpen1(struct vgic_v3_cpu_if *cpu_if,
+				   struct kvm_cpu_context *vcpu_ctxt,
+				   struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				   int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	ctxt_set_reg(vcpu_ctxt, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
 }
 
-static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_igrpen0(struct vgic_v3_cpu_if *cpu_if,
+				    struct kvm_cpu_context *vcpu_ctxt,
+				    struct vcpu_hyp_state *vcpu_hyps,
+				    u32 vmcr, int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 val = ctxt_get_reg(vcpu_ctxt, rt);
 
 	if (val & 1)
@@ -825,10 +831,11 @@ static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	__vgic_v3_write_vmcr(vmcr);
 }
 
-static void __vgic_v3_write_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_igrpen1(struct vgic_v3_cpu_if *cpu_if,
+				    struct kvm_cpu_context *vcpu_ctxt,
+				    struct vcpu_hyp_state *vcpu_hyps,
+				    u32 vmcr, int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 val = ctxt_get_reg(vcpu_ctxt, rt);
 
 	if (val & 1)
@@ -839,24 +846,27 @@ static void __vgic_v3_write_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	__vgic_v3_write_vmcr(vmcr);
 }
 
-static void __vgic_v3_read_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_read_bpr0(struct vgic_v3_cpu_if *cpu_if,
+				struct kvm_cpu_context *vcpu_ctxt,
+				struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	ctxt_set_reg(vcpu_ctxt, rt, __vgic_v3_get_bpr0(vmcr));
 }
 
-static void __vgic_v3_read_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_read_bpr1(struct vgic_v3_cpu_if *cpu_if,
+				struct kvm_cpu_context *vcpu_ctxt,
+				struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	ctxt_set_reg(vcpu_ctxt, rt, __vgic_v3_get_bpr1(vmcr));
 }
 
-static void __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_bpr0(struct vgic_v3_cpu_if *cpu_if,
+				 struct kvm_cpu_context *vcpu_ctxt,
+				 struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				 int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 val = ctxt_get_reg(vcpu_ctxt, rt);
 	u8 bpr_min = __vgic_v3_bpr_min() - 1;
 
@@ -872,10 +882,11 @@ static void __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	__vgic_v3_write_vmcr(vmcr);
 }
 
-static void __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_bpr1(struct vgic_v3_cpu_if *cpu_if,
+				 struct kvm_cpu_context *vcpu_ctxt,
+				 struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				 int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 val = ctxt_get_reg(vcpu_ctxt, rt);
 	u8 bpr_min = __vgic_v3_bpr_min();
 
@@ -894,13 +905,14 @@ static void __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	__vgic_v3_write_vmcr(vmcr);
 }
 
-static void __vgic_v3_read_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
+static void __vgic_v3_read_apxrn(struct vgic_v3_cpu_if *cpu_if,
+				 struct kvm_cpu_context *vcpu_ctxt,
+				 struct vcpu_hyp_state *vcpu_hyps, int rt,
+				 int n)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 val;
 
-	if (!__vgic_v3_get_group(vcpu))
+	if (!__vgic_v3_get_group(vcpu_ctxt, vcpu_hyps))
 		val = __vgic_v3_read_ap0rn(n);
 	else
 		val = __vgic_v3_read_ap1rn(n);
@@ -908,86 +920,94 @@ static void __vgic_v3_read_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
 	ctxt_set_reg(vcpu_ctxt, rt, val);
 }
 
-static void __vgic_v3_write_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
+static void __vgic_v3_write_apxrn(struct vgic_v3_cpu_if *cpu_if,
+				  struct kvm_cpu_context *vcpu_ctxt,
+				  struct vcpu_hyp_state *vcpu_hyps, int rt,
+				  int n)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 val = ctxt_get_reg(vcpu_ctxt, rt);
 
-	if (!__vgic_v3_get_group(vcpu))
+	if (!__vgic_v3_get_group(vcpu_ctxt, vcpu_hyps))
 		__vgic_v3_write_ap0rn(val, n);
 	else
 		__vgic_v3_write_ap1rn(val, n);
 }
 
-static void __vgic_v3_read_apxr0(struct kvm_vcpu *vcpu,
+static void __vgic_v3_read_apxr0(struct vgic_v3_cpu_if *cpu_if,
+				 struct kvm_cpu_context *vcpu_ctxt,
+					    struct vcpu_hyp_state *vcpu_hyps,
 					    u32 vmcr, int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-	__vgic_v3_read_apxrn(vcpu, rt, 0);
+	__vgic_v3_read_apxrn(cpu_if, vcpu_ctxt, vcpu_hyps, rt, 0);
 }
 
-static void __vgic_v3_read_apxr1(struct kvm_vcpu *vcpu,
+static void __vgic_v3_read_apxr1(struct vgic_v3_cpu_if *cpu_if,
+				 struct kvm_cpu_context *vcpu_ctxt,
+					    struct vcpu_hyp_state *vcpu_hyps,
 					    u32 vmcr, int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-	__vgic_v3_read_apxrn(vcpu, rt, 1);
+	__vgic_v3_read_apxrn(cpu_if, vcpu_ctxt, vcpu_hyps, rt, 1);
 }
 
-static void __vgic_v3_read_apxr2(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_read_apxr2(struct vgic_v3_cpu_if *cpu_if,
+				 struct kvm_cpu_context *vcpu_ctxt,
+				 struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				 int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-	__vgic_v3_read_apxrn(vcpu, rt, 2);
+	__vgic_v3_read_apxrn(cpu_if, vcpu_ctxt, vcpu_hyps, rt, 2);
 }
 
-static void __vgic_v3_read_apxr3(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_read_apxr3(struct vgic_v3_cpu_if *cpu_if,
+				 struct kvm_cpu_context *vcpu_ctxt,
+				 struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				 int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-	__vgic_v3_read_apxrn(vcpu, rt, 3);
+	__vgic_v3_read_apxrn(cpu_if, vcpu_ctxt, vcpu_hyps, rt, 3);
 }
 
-static void __vgic_v3_write_apxr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_apxr0(struct vgic_v3_cpu_if *cpu_if,
+				  struct kvm_cpu_context *vcpu_ctxt,
+				  struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				  int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-	__vgic_v3_write_apxrn(vcpu, rt, 0);
+	__vgic_v3_write_apxrn(cpu_if, vcpu_ctxt, vcpu_hyps, rt, 0);
 }
 
-static void __vgic_v3_write_apxr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_apxr1(struct vgic_v3_cpu_if *cpu_if,
+				  struct kvm_cpu_context *vcpu_ctxt,
+				  struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				  int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-	__vgic_v3_write_apxrn(vcpu, rt, 1);
+	__vgic_v3_write_apxrn(cpu_if, vcpu_ctxt, vcpu_hyps, rt, 1);
 }
 
-static void __vgic_v3_write_apxr2(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_apxr2(struct vgic_v3_cpu_if *cpu_if,
+				  struct kvm_cpu_context *vcpu_ctxt,
+				  struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				  int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-	__vgic_v3_write_apxrn(vcpu, rt, 2);
+	__vgic_v3_write_apxrn(cpu_if, vcpu_ctxt, vcpu_hyps, rt, 2);
 }
 
-static void __vgic_v3_write_apxr3(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_apxr3(struct vgic_v3_cpu_if *cpu_if,
+				  struct kvm_cpu_context *vcpu_ctxt,
+				  struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				  int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-	__vgic_v3_write_apxrn(vcpu, rt, 3);
+	__vgic_v3_write_apxrn(cpu_if, vcpu_ctxt, vcpu_hyps, rt, 3);
 }
 
-static void __vgic_v3_read_hppir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_read_hppir(struct vgic_v3_cpu_if *cpu_if,
+				 struct kvm_cpu_context *vcpu_ctxt,
+				 struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				 int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 lr_val;
 	int lr, lr_grp, grp;
 
-	grp = __vgic_v3_get_group(vcpu);
+	grp = __vgic_v3_get_group(vcpu_ctxt, vcpu_hyps);
 
-	lr = __vgic_v3_highest_priority_lr(vcpu, vmcr, &lr_val);
+	lr = __vgic_v3_highest_priority_lr(cpu_if, vmcr, &lr_val);
 	if (lr == -1)
 		goto spurious;
 
@@ -999,19 +1019,21 @@ static void __vgic_v3_read_hppir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	ctxt_set_reg(vcpu_ctxt, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
 }
 
-static void __vgic_v3_read_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_read_pmr(struct vgic_v3_cpu_if *cpu_if,
+			       struct kvm_cpu_context *vcpu_ctxt,
+			       struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+			       int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	vmcr &= ICH_VMCR_PMR_MASK;
 	vmcr >>= ICH_VMCR_PMR_SHIFT;
 	ctxt_set_reg(vcpu_ctxt, rt, vmcr);
 }
 
-static void __vgic_v3_write_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_pmr(struct vgic_v3_cpu_if *cpu_if,
+				struct kvm_cpu_context *vcpu_ctxt,
+				struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 val = ctxt_get_reg(vcpu_ctxt, rt);
 
 	val <<= ICH_VMCR_PMR_SHIFT;
@@ -1022,18 +1044,20 @@ static void __vgic_v3_write_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
 
-static void __vgic_v3_read_rpr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_read_rpr(struct vgic_v3_cpu_if *cpu_if,
+			       struct kvm_cpu_context *vcpu_ctxt,
+			       struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+			       int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 val = __vgic_v3_get_highest_active_priority();
 	ctxt_set_reg(vcpu_ctxt, rt, val);
 }
 
-static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_read_ctlr(struct vgic_v3_cpu_if *cpu_if,
+				struct kvm_cpu_context *vcpu_ctxt,
+				struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 vtr, val;
 
 	vtr = read_gicreg(ICH_VTR_EL2);
@@ -1053,10 +1077,11 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	ctxt_set_reg(vcpu_ctxt, rt, val);
 }
 
-static void __vgic_v3_write_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_ctlr(struct vgic_v3_cpu_if *cpu_if,
+				 struct kvm_cpu_context *vcpu_ctxt,
+				 struct vcpu_hyp_state *vcpu_hyps, u32 vmcr,
+				 int rt)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 val = ctxt_get_reg(vcpu_ctxt, rt);
 
 	if (val & ICC_CTLR_EL1_CBPR_MASK)
@@ -1074,16 +1099,18 @@ static void __vgic_v3_write_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	int rt;
 	u32 esr;
 	u32 vmcr;
-	void (*fn)(struct kvm_vcpu *, u32, int);
+	void (*fn)(struct vgic_v3_cpu_if *, struct kvm_cpu_context *,
+		   struct vcpu_hyp_state *, u32, int);
 	bool is_read;
 	u32 sysreg;
 
-	esr = kvm_vcpu_get_esr(vcpu);
+	esr = kvm_hyp_state_get_esr(vcpu_hyps);
 	if (ctxt_mode_is_32bit(vcpu_ctxt)) {
 		if (!kvm_condition_valid(vcpu)) {
 			__kvm_skip_instr(vcpu_ctxt, vcpu_hyps);
@@ -1195,8 +1222,8 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	}
 
 	vmcr = __vgic_v3_read_vmcr();
-	rt = kvm_vcpu_sys_get_rt(vcpu);
-	fn(vcpu, vmcr, rt);
+	rt = kvm_hyp_state_sys_get_rt(vcpu_hyps);
+	fn(cpu_if, vcpu_ctxt, vcpu_hyps, vmcr, rt);
 
 	__kvm_skip_instr(vcpu_ctxt, vcpu_hyps);
 
-- 
2.33.0.685.g46640cef36-goog

