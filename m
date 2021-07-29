Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5B63DA495
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237662AbhG2NqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:46:13 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:47681 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237661AbhG2NqK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 09:46:10 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jul 2021 09:46:10 EDT
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id F30481AC085A;
        Thu, 29 Jul 2021 09:39:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 29 Jul 2021 09:39:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=dbxSlvCauQQwbKG7nfBtMKR3T/qgRW2Y67hYThu0ZP0=; b=LRXoR1eg
        Oy+WAxGhZe+9w6b30C0mquW66U4GnBenqCGXQu++wkI4SayI0UbGIuj402UrV66d
        sx4HJsqyPZ2wlp2AAhArvCe4PTqTMtBx6RRNNTI52mLsLnpY3beJ+uV0BBf955sx
        HJ44D4XFEsWVNIZyNtbrh0GRHFaSAYquoUCnQIRXuVjb9zJE6hvqTIAadjbyCfIh
        Jnxl2BTQ65Rb0EkMyGvUPalQQzgj3ECtKwr1WLmDDN1BdaTCleVzSwL+lAF+wems
        BNI4+F0GiAt8DS5OKTgdQJVckNLnlErTtP7J1rIOEMIWVRMk4mFm9SQvGfsiHyex
        VeLtJlAOhqdMSA==
X-ME-Sender: <xms:oa8CYRhfAazFd5HJ3bCI1coQZBup3pIYMgsGtq5jWuRLFMVHuhG1aw>
    <xme:oa8CYWApGzqoW1aSDKd-PxXvonwei1fCTGMZC7n_lj4SXEoe7mcHr5ydU2sNCfFZV
    CyWgPU-3t-dwuXLFdA>
X-ME-Received: <xmr:oa8CYRE2nYAoWHoetkwqWnCXkGw1EejCTfcK0f4T9uScrprOc_E0a3gh8xT7G_3Uie61f38veEW2bplSdn1OdlOMjRtf7PksbXQC6S0Z3e4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrheefgddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtg
    homheqnecuggftrfgrthhtvghrnhepudefteejgfefhfdtjefhhedtffethfetkeehgfel
    heffhfeihfeglefgjedtheeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepuggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgtohhm
X-ME-Proxy: <xmx:oa8CYWS3EtxqlMJvMnTDK02EzX1tweH0WfGUrRXjzcW2xZV2VatDOg>
    <xmx:oa8CYeyxL4nsKraKFkifHeVIvzLItGzAXUfBDRcobRpoU_IprdwLPw>
    <xmx:oa8CYc5ln3ESIgZSgK1ykHCNR9Upb5jP_YV5h_pBL-L40fqtPQpCpA>
    <xmx:oa8CYYro-Azog0oNZnij5a7n5iNHrobl_vOc2kDhp6JVpOAZRfRwHvGqseDHkX6K>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Jul 2021 09:39:43 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id b1e2ac23;
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
        David Edmondson <david.edmondson@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v3 2/3] KVM: x86: On emulation failure, convey the exit reason, etc. to userspace
Date:   Thu, 29 Jul 2021 14:39:30 +0100
Message-Id: <20210729133931.1129696-3-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210729133931.1129696-1-david.edmondson@oracle.com>
References: <20210729133931.1129696-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Should instruction emulation fail, include the VM exit reason, etc. in
the emulation_failure data passed to userspace, in order that the VMM
can report it as a debugging aid when describing the failure.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/include/asm/kvm_host.h |  5 ++++
 arch/x86/kvm/vmx/vmx.c          |  5 +---
 arch/x86/kvm/x86.c              | 53 ++++++++++++++++++++++++++-------
 include/uapi/linux/kvm.h        |  7 +++++
 4 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dfb902930cdc..17da43c1aa67 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1630,6 +1630,11 @@ extern u64 kvm_mce_cap_supported;
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
 					void *insn, int insn_len);
+void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
+					bool instruction_bytes,
+					void *data, unsigned int ndata);
+void kvm_prepare_emulation_failure_exit_with_reason(struct kvm_vcpu *vcpu,
+						    bool instruction_bytes);
 
 void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fefdecb0ff3d..a8d303c7c099 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5367,10 +5367,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 
 		if (vmx->emulation_required && !vmx->rmode.vm86_active &&
 		    vcpu->arch.exception.pending) {
-			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-			vcpu->run->internal.suberror =
-						KVM_INTERNAL_ERROR_EMULATION;
-			vcpu->run->internal.ndata = 0;
+			kvm_prepare_emulation_failure_exit_with_reason(vcpu, false);
 			return 0;
 		}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a4fd10604f72..a97bacd8922f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7456,7 +7456,9 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
 
-static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
+void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
+					bool instruction_bytes,
+					void *data, unsigned int ndata)
 {
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	u32 insn_size = ctxt->fetch.end - ctxt->fetch.data;
@@ -7464,10 +7466,10 @@ static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
 
 	run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 	run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	run->emulation_failure.ndata = 0;
+	run->emulation_failure.ndata = 1; /* Always include the flags. */
 	run->emulation_failure.flags = 0;
 
-	if (insn_size) {
+	if (instruction_bytes && insn_size) {
 		run->emulation_failure.ndata = 3;
 		run->emulation_failure.flags |=
 			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
@@ -7477,7 +7479,42 @@ static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
 		memcpy(run->emulation_failure.insn_bytes,
 		       ctxt->fetch.data, insn_size);
 	}
+
+	ndata = min((size_t)ndata, sizeof(run->internal.data) -
+		    run->emulation_failure.ndata * sizeof(u64));
+	if (ndata) {
+		unsigned int offset =
+			offsetof(struct kvm_run, emulation_failure.flags) +
+			run->emulation_failure.ndata * sizeof(u64);
+
+		memcpy((void *)run + offset, data, ndata);
+		run->emulation_failure.ndata += ndata / sizeof(u64);
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_prepare_emulation_failure_exit);
+
+void kvm_prepare_emulation_failure_exit_with_reason(struct kvm_vcpu *vcpu,
+						    bool instruction_bytes)
+{
+	struct {
+		__u64 exit_reason;
+		__u64 exit_info1;
+		__u64 exit_info2;
+		__u32 intr_info;
+		__u32 error_code;
+	} exit_reason;
+
+	static_call(kvm_x86_get_exit_info)(vcpu,
+					   &exit_reason.exit_reason,
+					   &exit_reason.exit_info1,
+					   &exit_reason.exit_info2,
+					   &exit_reason.intr_info,
+					   &exit_reason.error_code);
+
+	kvm_prepare_emulation_failure_exit(vcpu, instruction_bytes,
+					   &exit_reason, sizeof(exit_reason));
 }
+EXPORT_SYMBOL_GPL(kvm_prepare_emulation_failure_exit_with_reason);
 
 static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 {
@@ -7493,16 +7530,14 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 
 	if (kvm->arch.exit_on_emulation_error ||
 	    (emulation_type & EMULTYPE_SKIP)) {
-		prepare_emulation_failure_exit(vcpu);
+		kvm_prepare_emulation_failure_exit_with_reason(vcpu, true);
 		return 0;
 	}
 
 	kvm_queue_exception(vcpu, UD_VECTOR);
 
 	if (!is_guest_mode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) == 0) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		kvm_prepare_emulation_failure_exit_with_reason(vcpu, false);
 		return 0;
 	}
 
@@ -12095,9 +12130,7 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 	 * doesn't seem to be a real use-case behind such requests, just return
 	 * KVM_EXIT_INTERNAL_ERROR for now.
 	 */
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	vcpu->run->internal.ndata = 0;
+	kvm_prepare_emulation_failure_exit_with_reason(vcpu, false);
 
 	return 0;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d9e4aabcb31a..f1ef4117b824 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -397,6 +397,12 @@ struct kvm_run {
 		 * "ndata" is correct, that new fields are enumerated in "flags",
 		 * and that each flag enumerates fields that are 64-bit aligned
 		 * and sized (so that ndata+internal.data[] is valid/accurate).
+		 *
+		 * Space beyond the defined fields may be used to
+		 * store arbitrary debug information relating to the
+		 * emulation failure. It is accounted for in "ndata"
+		 * but otherwise unspecified and is not represented in
+		 * "flags".
 		 */
 		struct {
 			__u32 suberror;
@@ -404,6 +410,7 @@ struct kvm_run {
 			__u64 flags;
 			__u8  insn_size;
 			__u8  insn_bytes[15];
+			/* Arbitrary debug data may follow. */
 		} emulation_failure;
 		/* KVM_EXIT_OSI */
 		struct {
-- 
2.30.2

