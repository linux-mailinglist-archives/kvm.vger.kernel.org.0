Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74823BC92C
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 12:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhGFKPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 06:15:03 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:42519 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231299AbhGFKPC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 06:15:02 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 555C21940619;
        Tue,  6 Jul 2021 06:12:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 06 Jul 2021 06:12:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=50e02u+t8XVaFNF+IXucFs9YC7xNugTJ9Gt13UVtu6w=; b=Wm7bGfgV
        krUTAQV3tlyTyGAi3IO9PiZtgFDbRuL+KEqAoEF4Ninb/SFvZkaIzJ3VdaSw0Sve
        1J3b8Jgl68QFtDW6zl9I6UQ4EXFQpZYBA6nshmnl99+qngyzVj1L5F/0rN1tXN1n
        n/I1Vyi8ymuxmrsn7LhIO8LAwb7iJfR6oL72UOHJHdPVGtB4xp0St50nPbfePiWG
        sgh+x3oQxf+Yc2j2mSiWe5pv0svQ8WYi5rsgfbhJbfEn6c95p46n2ZnIGflOIo5j
        /nVAJFNbxHPPVrAIcM/fBlEtafE8XA3Gj+wvdW8rcYH41oIvB19OAJ1EFsjsGSRr
        HIXwCMiAvTx81g==
X-ME-Sender: <xms:hSzkYFjYv9assFpkZ24hJDI2aLX9yZsvC2_wcxsPyWUQYIJwPR4Vng>
    <xme:hSzkYKBJJNWk6xbwPaQoISGPZxzYIP8erp0-0v4yiz3wgswLkjZo64BS6UprP8Ld0
    RnlMW7zzlBy5CK_AnQ>
X-ME-Received: <xmr:hSzkYFFxefHIr9l16NyhF7Vr9mWDp0MIXyFUJo6iV6RbatpjNjKPqtuAhaoMMSwITScYyziyVcqg_0BJooMs5xTS-7x__8I69QbyzGlUHEM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeejiedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtgho
    mh
X-ME-Proxy: <xmx:hSzkYKRxE-ZV2IxOgpte1To-1X0YDeVsX-bn8AG4Z6yDOl5L7BovQA>
    <xmx:hSzkYCx_1KUYkvOKl1oLnI8Ujwgl06oioNiE1q9FTkmJ7MNkafAsYA>
    <xmx:hSzkYA5KMms0lWzGjAmFSSeNpGnTTB6b7Vv4yBWe_webuJM5rtQYww>
    <xmx:hyzkYMqepm5yhi9AtFyg8nD9xz6EYX8ovrD_yyDEB_8yUk8J02shZ9qXC5s>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Jul 2021 06:12:20 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id e125f3ea;
        Tue, 6 Jul 2021 10:12:07 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Edmondson <david.edmondson@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v2 2/2] KVM: x86: On emulation failure, convey the exit reason to userspace
Date:   Tue,  6 Jul 2021 11:12:07 +0100
Message-Id: <20210706101207.2993686-3-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706101207.2993686-1-david.edmondson@oracle.com>
References: <20210706101207.2993686-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Should instruction emulation fail, include the VM exit reason in the
emulation_failure data passed to userspace, in order that the VMM can
report it as a debugging aid when describing the failure.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/vmx/vmx.c          |  5 +----
 arch/x86/kvm/x86.c              | 22 +++++++++++++---------
 include/uapi/linux/kvm.h        |  7 +++++++
 4 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0ee580c68839..2e411e26e40e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1630,6 +1630,8 @@ extern u64 kvm_mce_cap_supported;
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
 					void *insn, int insn_len);
+void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
+					bool instruction_bytes);
 
 void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d9a4d6cf6406..4fb240204c2c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5367,10 +5367,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 
 		if (vmx->emulation_required && !vmx->rmode.vm86_active &&
 		    vcpu->arch.exception.pending) {
-			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-			vcpu->run->internal.suberror =
-						KVM_INTERNAL_ERROR_EMULATION;
-			vcpu->run->internal.ndata = 0;
+			kvm_prepare_emulation_failure_exit(vcpu, false);
 			return 0;
 		}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 17468d983fbd..bf30b445b65d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7452,7 +7452,8 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
 
-static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
+void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
+					bool instruction_bytes)
 {
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	u32 insn_size = ctxt->fetch.end - ctxt->fetch.data;
@@ -7463,7 +7464,7 @@ static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
 	run->emulation_failure.ndata = 0;
 	run->emulation_failure.flags = 0;
 
-	if (insn_size) {
+	if (insn_size && instruction_bytes) {
 		run->emulation_failure.ndata = 3;
 		run->emulation_failure.flags |=
 			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
@@ -7473,7 +7474,14 @@ static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
 		memcpy(run->emulation_failure.insn_bytes,
 		       ctxt->fetch.data, insn_size);
 	}
+
+	run->emulation_failure.ndata = 4;
+	run->emulation_failure.flags |=
+		KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON;
+	run->emulation_failure.exit_reason =
+		static_call(kvm_x86_get_exit_reason)(vcpu);
 }
+EXPORT_SYMBOL_GPL(kvm_prepare_emulation_failure_exit);
 
 static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 {
@@ -7489,16 +7497,14 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 
 	if (kvm->arch.exit_on_emulation_error ||
 	    (emulation_type & EMULTYPE_SKIP)) {
-		prepare_emulation_failure_exit(vcpu);
+		kvm_prepare_emulation_failure_exit(vcpu, true);
 		return 0;
 	}
 
 	kvm_queue_exception(vcpu, UD_VECTOR);
 
 	if (!is_guest_mode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) == 0) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		kvm_prepare_emulation_failure_exit(vcpu, false);
 		return 0;
 	}
 
@@ -12092,9 +12098,7 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 	 * doesn't seem to be a real use-case behind such requests, just return
 	 * KVM_EXIT_INTERNAL_ERROR for now.
 	 */
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	vcpu->run->internal.ndata = 0;
+	kvm_prepare_emulation_failure_exit(vcpu, false);
 
 	return 0;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d9e4aabcb31a..863195371272 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -282,6 +282,7 @@ struct kvm_xen_exit {
 
 /* Flags that describe what fields in emulation_failure hold valid data. */
 #define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
+#define KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON       (1ULL << 1)
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
@@ -404,6 +405,12 @@ struct kvm_run {
 			__u64 flags;
 			__u8  insn_size;
 			__u8  insn_bytes[15];
+			/*
+			 * The "exit reason" extracted from the
+			 * VMCS/VMCB that was the cause of attempted
+			 * emulation.
+			 */
+			__u64 exit_reason;
 		} emulation_failure;
 		/* KVM_EXIT_OSI */
 		struct {
-- 
2.30.2

