Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536593EB128
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 09:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbhHMHM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 03:12:59 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:54909 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239269AbhHMHMu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 03:12:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 491B11940742;
        Fri, 13 Aug 2021 03:12:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 13 Aug 2021 03:12:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=v2qiHFOR2KzFV1BLgDMEgvFfyZj6RHF2F4xKQct7X8g=; b=D/frlrMK
        JvLYI5el5oAfl8zahd2cAAfQEM/gVmt0DkgEsYZQc6HM6WN2f0IklltfV+Ha9+N1
        BE/n/T53aRBeycbiBDJtf1J72Pjlc1V4UjWSuy38NkK1SK5MzqehctYsQQdp2JhS
        Kz9HIuFfdQTCZkELcp1qhuql80dY/tiW2pYqe7ePyfiohlLZJV0Umz//DPBNy0i4
        yQU/ck3dVIbXnFewvFLt+nhgujQt0ZxMeRautd00CpO+FwaB12CJlVSC4LnV3GgG
        tPNq6nqslsKaK2GEpcZgFvbY5uuTSIxZSEeDQmid2epJ+eUhutJkrkCENXxCpeY3
        n9yaUKW3VbR2FQ==
X-ME-Sender: <xms:UxsWYaBpj22wBSckIJ_cnzjltXKRWW46j4MQX840Ndy2-seRhRUy4Q>
    <xme:UxsWYUjVa-alDNbTA1YpPAYkcCJ70_GXsF2Y2v6a6ZZ9uNxXBWgM0C682t19f3QB5
    AeQKoIbZpiL0hqagYc>
X-ME-Received: <xmr:UxsWYdnXSANv0EcFOFlGRrBH8EBeaUAFOPRCidaRiwTy3B37gWK1ePiZMgyw3racfguDE1IPmPhazOUnGdZIbswA93W4Zv8xGeCr6ddJoMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeeggdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtgho
    mh
X-ME-Proxy: <xmx:UxsWYYxJ4EZRDP1LvUEMNKfCJHeok9Z4bO_0QCdyM-PCaKFHzkX49w>
    <xmx:UxsWYfTc5iBB2w4LkUg8nM5hnIq1yb68_q7tAz7hQi2FVQJntg7cvg>
    <xmx:UxsWYTbopTb5TbTtpE-yxxISYuTeYD7opUs5urduWaxeWmNFllIuUw>
    <xmx:VRsWYTIcREf4t97Kz7qhMyHIgD3XY83EeOqpfoDT7M-6BBQ9Lx5wD2nYIRA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Aug 2021 03:12:17 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 2bb086ed;
        Fri, 13 Aug 2021 07:12:12 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v4 2/4] KVM: x86: Get exit_reason as part of kvm_x86_ops.get_exit_info
Date:   Fri, 13 Aug 2021 08:12:09 +0100
Message-Id: <20210813071211.1635310-3-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813071211.1635310-1-david.edmondson@oracle.com>
References: <20210813071211.1635310-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the get_exit_info static call to provide the reason for the VM
exit. Modify relevant trace points to use this rather than extracting
the reason in the caller.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 7 ++++---
 arch/x86/kvm/svm/svm.c          | 8 +++++---
 arch/x86/kvm/trace.h            | 9 +++++----
 arch/x86/kvm/vmx/nested.c       | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 6 ++++--
 5 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 974cbfb1eefe..e3c0788bcdc2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1377,10 +1377,11 @@ struct kvm_x86_ops {
 	void (*write_tsc_multiplier)(struct kvm_vcpu *vcpu, u64 multiplier);
 
 	/*
-	 * Retrieve somewhat arbitrary exit information.  Intended to be used
-	 * only from within tracepoints to avoid VMREADs when tracing is off.
+	 * Retrieve somewhat arbitrary exit information.  Intended to
+	 * be used only from within tracepoints or error paths.
 	 */
-	void (*get_exit_info)(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
+	void (*get_exit_info)(struct kvm_vcpu *vcpu, u32 *reason,
+			      u64 *info1, u64 *info2,
 			      u32 *exit_int_info, u32 *exit_int_info_err_code);
 
 	int (*check_intercept)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e8ccab50ebf6..0df2fe5faa69 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3305,11 +3305,13 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 	return svm_exit_handlers[exit_code](vcpu);
 }
 
-static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
+static void svm_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+			      u64 *info1, u64 *info2,
 			      u32 *intr_info, u32 *error_code)
 {
 	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
 
+	*reason = control->exit_code;
 	*info1 = control->exit_info_1;
 	*info2 = control->exit_info_2;
 	*intr_info = control->exit_int_info;
@@ -3326,7 +3328,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	struct kvm_run *kvm_run = vcpu->run;
 	u32 exit_code = svm->vmcb->control.exit_code;
 
-	trace_kvm_exit(exit_code, vcpu, KVM_ISA_SVM);
+	trace_kvm_exit(vcpu, KVM_ISA_SVM);
 
 	/* SEV-ES guests must use the CR write traps to track CR registers. */
 	if (!sev_es_guest(vcpu->kvm)) {
@@ -3339,7 +3341,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (is_guest_mode(vcpu)) {
 		int vmexit;
 
-		trace_kvm_nested_vmexit(exit_code, vcpu, KVM_ISA_SVM);
+		trace_kvm_nested_vmexit(vcpu, KVM_ISA_SVM);
 
 		vmexit = nested_svm_exit_special(svm);
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 03ebe368333e..953b0fcb21ee 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -288,8 +288,8 @@ TRACE_EVENT(kvm_apic,
 
 #define TRACE_EVENT_KVM_EXIT(name)					     \
 TRACE_EVENT(name,							     \
-	TP_PROTO(unsigned int exit_reason, struct kvm_vcpu *vcpu, u32 isa),  \
-	TP_ARGS(exit_reason, vcpu, isa),				     \
+	TP_PROTO(struct kvm_vcpu *vcpu, u32 isa),			     \
+	TP_ARGS(vcpu, isa),						     \
 									     \
 	TP_STRUCT__entry(						     \
 		__field(	unsigned int,	exit_reason	)	     \
@@ -303,11 +303,12 @@ TRACE_EVENT(name,							     \
 	),								     \
 									     \
 	TP_fast_assign(							     \
-		__entry->exit_reason	= exit_reason;			     \
 		__entry->guest_rip	= kvm_rip_read(vcpu);		     \
 		__entry->isa            = isa;				     \
 		__entry->vcpu_id        = vcpu->vcpu_id;		     \
-		static_call(kvm_x86_get_exit_info)(vcpu, &__entry->info1,    \
+		static_call(kvm_x86_get_exit_info)(vcpu,		     \
+					  &__entry->exit_reason,	     \
+					  &__entry->info1,		     \
 					  &__entry->info2,		     \
 					  &__entry->intr_info,		     \
 					  &__entry->error_code);	     \
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1a52134b0c42..fbbc01e9570b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6025,7 +6025,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 		goto reflect_vmexit;
 	}
 
-	trace_kvm_nested_vmexit(exit_reason.full, vcpu, KVM_ISA_VMX);
+	trace_kvm_nested_vmexit(vcpu, KVM_ISA_VMX);
 
 	/* If L0 (KVM) wants the exit, it trumps L1's desires. */
 	if (nested_vmx_l0_wants_exit(vcpu, exit_reason))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 927a552393b9..6e5706ecce0b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5617,11 +5617,13 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 static const int kvm_vmx_max_exit_handlers =
 	ARRAY_SIZE(kvm_vmx_exit_handlers);
 
-static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
+static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+			      u64 *info1, u64 *info2,
 			      u32 *intr_info, u32 *error_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	*reason = vmx->exit_reason.full;
 	*info1 = vmx_get_exit_qual(vcpu);
 	if (!(vmx->exit_reason.failed_vmentry)) {
 		*info2 = vmx->idt_vectoring_info;
@@ -6748,7 +6750,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (likely(!vmx->exit_reason.failed_vmentry))
 		vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
-	trace_kvm_exit(vmx->exit_reason.full, vcpu, KVM_ISA_VMX);
+	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
 	if (unlikely(vmx->exit_reason.failed_vmentry))
 		return EXIT_FASTPATH_NONE;
-- 
2.30.2

