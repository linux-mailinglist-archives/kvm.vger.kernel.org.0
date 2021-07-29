Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD743DA498
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237661AbhG2NqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:46:18 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:37821 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237667AbhG2NqK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 09:46:10 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7AF301AC08CD;
        Thu, 29 Jul 2021 09:39:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 29 Jul 2021 09:39:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=OqqvFekXD+nVhPuMLp9e9BqZ1ASRYrrx66uIHdn7InI=; b=Ma3BcMOB
        kumh7UMGyy4zPhDjBAIaA67r6RF5D6cfDQ/fR9jxixOYfQnlF0Pxs8exR13HLsgo
        OAbQShfPQEfXLn+PTHtS7rKyU7ubZECoT2OHVEdXruwVuRmHozkErxBzJb4wf2bQ
        i4HMsm7Cpi4s1lP5vTw85PTBa4PssKDuEirahmefAVItyM6MYNLVTWMia05X1m9s
        wPKXqU7bF/v1hYErsZgm6IdziMFDYOzTt3AzOY2PR/vazMg83jasvMEFPpvBL1i3
        U+YN5tEiNnWl8sCSUhBlvCi3cwrarxS87lOdFIyjeGB6iYeVCNpjFF67b8dk6D9E
        Pz3KPCCY82qmNg==
X-ME-Sender: <xms:ma8CYRQ37Rz3nK6j8gErXq0pPTzho0QW2F4JZcf0qdasa5mCp7B5qQ>
    <xme:ma8CYayH4tZwaJk-vRId9h07lQz8AmAZJyN-3grv6gvdl4EzhfwbGhktpKHSJrVX_
    pAXkUu1WrB_xCn9cGg>
X-ME-Received: <xmr:ma8CYW2kSDaoTPwY5qhi9P8fUDVmXm-Lfi0ooWhjWPZL8d1Ce-kgiyMo4hH5wmjtQwEhiKCg6xoQ3_slAAm3t8Pss723S3UtcEE7h0mhBao>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrheefgddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtg
    homheqnecuggftrfgrthhtvghrnhepudefteejgfefhfdtjefhhedtffethfetkeehgfel
    heffhfeihfeglefgjedtheeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepuggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgtohhm
X-ME-Proxy: <xmx:ma8CYZBcB8CX2NSm-lvXqcD_eDgELva3ffd42DwMSZHxwpclqHwfRA>
    <xmx:ma8CYaiNT9F3KK5Jseo6KpDBDOUfPhpRxQ_RDQeL2Iw0g0mr8W4oWg>
    <xmx:ma8CYdrc6l84mevh7qwpOBgSFs3MSJdJ68X40WlMpAIltIujxircWg>
    <xmx:o68CYfZ4IsRDPoyDCijCo07OKmd0KfrOLJ_mF38VzJFKul094_oXApzRwZ3LZchq>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Jul 2021 09:39:35 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id df542ca4;
        Thu, 29 Jul 2021 13:39:32 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v3 1/3] KVM: x86: kvm_x86_ops.get_exit_info should include the exit reason
Date:   Thu, 29 Jul 2021 14:39:29 +0100
Message-Id: <20210729133931.1129696-2-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210729133931.1129696-1-david.edmondson@oracle.com>
References: <20210729133931.1129696-1-david.edmondson@oracle.com>
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
 arch/x86/include/asm/kvm_host.h |  7 ++++---
 arch/x86/kvm/svm/svm.c          |  8 +++++---
 arch/x86/kvm/trace.h            | 11 ++++++-----
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  6 ++++--
 5 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 974cbfb1eefe..dfb902930cdc 100644
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
+	void (*get_exit_info)(struct kvm_vcpu *vcpu, u64 *reason,
+			      u64 *info1, u64 *info2,
 			      u32 *exit_int_info, u32 *exit_int_info_err_code);
 
 	int (*check_intercept)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 664d20f0689c..e5c4354dcc6f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3301,11 +3301,13 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 	return svm_exit_handlers[exit_code](vcpu);
 }
 
-static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
+static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *reason,
+			      u64 *info1, u64 *info2,
 			      u32 *intr_info, u32 *error_code)
 {
 	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
 
+	*reason = control->exit_code;
 	*info1 = control->exit_info_1;
 	*info2 = control->exit_info_2;
 	*intr_info = control->exit_int_info;
@@ -3322,7 +3324,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	struct kvm_run *kvm_run = vcpu->run;
 	u32 exit_code = svm->vmcb->control.exit_code;
 
-	trace_kvm_exit(exit_code, vcpu, KVM_ISA_SVM);
+	trace_kvm_exit(vcpu, KVM_ISA_SVM);
 
 	/* SEV-ES guests must use the CR write traps to track CR registers. */
 	if (!sev_es_guest(vcpu->kvm)) {
@@ -3335,7 +3337,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (is_guest_mode(vcpu)) {
 		int vmexit;
 
-		trace_kvm_nested_vmexit(exit_code, vcpu, KVM_ISA_SVM);
+		trace_kvm_nested_vmexit(vcpu, KVM_ISA_SVM);
 
 		vmexit = nested_svm_exit_special(svm);
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b484141ea15b..2228565beda2 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -273,11 +273,11 @@ TRACE_EVENT(kvm_apic,
 
 #define TRACE_EVENT_KVM_EXIT(name)					     \
 TRACE_EVENT(name,							     \
-	TP_PROTO(unsigned int exit_reason, struct kvm_vcpu *vcpu, u32 isa),  \
-	TP_ARGS(exit_reason, vcpu, isa),				     \
+	TP_PROTO(struct kvm_vcpu *vcpu, u32 isa),			     \
+	TP_ARGS(vcpu, isa),						     \
 									     \
 	TP_STRUCT__entry(						     \
-		__field(	unsigned int,	exit_reason	)	     \
+		__field(	u64,		exit_reason	)	     \
 		__field(	unsigned long,	guest_rip	)	     \
 		__field(	u32,	        isa             )	     \
 		__field(	u64,	        info1           )	     \
@@ -288,11 +288,12 @@ TRACE_EVENT(name,							     \
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
index 927a552393b9..fefdecb0ff3d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5617,11 +5617,13 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 static const int kvm_vmx_max_exit_handlers =
 	ARRAY_SIZE(kvm_vmx_exit_handlers);
 
-static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
+static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u64 *reason,
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

