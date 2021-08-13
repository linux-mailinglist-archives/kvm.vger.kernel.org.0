Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6113EB125
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 09:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239253AbhHMHMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 03:12:55 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:32823 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239272AbhHMHMu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 03:12:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6FE451940835;
        Fri, 13 Aug 2021 03:12:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 13 Aug 2021 03:12:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=PW8UTbG0iLSxu2C357T+pCwEjX7jWrJwbYSMbSsSTFg=; b=abx8aJLB
        IVKtdxJbbdTbBCt3zt2DVw8tOciTgR48fy/3e0w9fVXuypRoCs5agW9/1UuB8n9i
        VLQWdeqSgcJwkZLo8NrclbmPvXP+mlnvC5TqTAjs8CZ+AeQe7tACXhFxr8N7rL/o
        /uUv+kl5OpnEBYU2R+TuXzAyPCjZSUcuqwsGH9kRGV5ndHPhI2+FiS7JCyi5djXa
        evT6YcxdxErHim1UuAYN37WPXZL9oG3xNsgI4mK4VgJBZo8wE948IYzJBvEeXv5r
        RS3b52q5pi+mwwq6nQTtagSUvSgrEasvy++HQpKytENFFzu4NLHCRL72KvSyzwRx
        Ydoe8UEsEVdQ4w==
X-ME-Sender: <xms:UxsWYX9AVksz7IfWmR1dJA_rjwDV0nQrivHT1zE9OKoRpiFDj0LDXw>
    <xme:UxsWYTustXBrLNNXkqdvHvzVDg8WNz1hZ2wAw3fdY19mPOtb7qTcY7hY9MB3vngiS
    eh_ra0eLCcGUIFNZik>
X-ME-Received: <xmr:UxsWYVCv2x1rauGOghlbAU3W-Hl8AmrDYcwlJ1oDmfTlEV03ZgmolRNgtz0uYDViU3tJW3wBwdO6vLrKbf0WwThK8BS2qWK9Nhpk3bZ4BfI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeeggdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtgho
    mh
X-ME-Proxy: <xmx:UxsWYTfxrliYVS_YnIbdev3zOnJ-HP0mMcgy-8VkRgSPwALzJM99Rw>
    <xmx:UxsWYcPiKzyzF-AahOH6Pv9ADlVy3E7RgWPe5DhCt6o_jYpVS-uqUg>
    <xmx:UxsWYVlbFbORJIlz6OGfC1KFJmZZo_M3chfEHumi8rsYHEfp5fGwbA>
    <xmx:VRsWYa2IgjxmmhbX428VeW19dxdJwNx1PTYpDqO8a9_XIRh388NFWlnAc4Y>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Aug 2021 03:12:18 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id c6770563;
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
        kvm@vger.kernel.org, David Edmondson <david.edmondson@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v4 3/4] KVM: x86: On emulation failure, convey the exit reason, etc. to userspace
Date:   Fri, 13 Aug 2021 08:12:10 +0100
Message-Id: <20210813071211.1635310-4-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813071211.1635310-1-david.edmondson@oracle.com>
References: <20210813071211.1635310-1-david.edmondson@oracle.com>
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
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/vmx/vmx.c          |  5 +--
 arch/x86/kvm/x86.c              | 73 ++++++++++++++++++++++++++-------
 include/uapi/linux/kvm.h        |  7 ++++
 4 files changed, 70 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e3c0788bcdc2..da2d8f3a2019 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1630,6 +1630,9 @@ extern u64 kvm_mce_cap_supported;
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
 					void *insn, int insn_len);
+void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
+					  u64 *data, u8 ndata);
+void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
 
 void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6e5706ecce0b..9d14f68651f1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5367,10 +5367,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 
 		if (vmx->emulation_required && !vmx->rmode.vm86_active &&
 		    vcpu->arch.exception.pending) {
-			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-			vcpu->run->internal.suberror =
-						KVM_INTERNAL_ERROR_EMULATION;
-			vcpu->run->internal.ndata = 0;
+			kvm_prepare_emulation_failure_exit(vcpu);
 			return 0;
 		}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5d5c5ed7dd4..35639391de7b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7465,29 +7465,78 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
 
-static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
+static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
+					   u8 ndata, u8 *insn_bytes, u8 insn_size)
 {
-	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
-	u32 insn_size = ctxt->fetch.end - ctxt->fetch.data;
 	struct kvm_run *run = vcpu->run;
+	u8 ndata_start;
+	u64 info[5];
+
+	/*
+	 * Zero the whole array used to retrieve the exit info, casting to u32
+	 * for select entries will leave some chunks uninitialized.
+	 */
+	memset(&info, 0, sizeof(info));
+
+	static_call(kvm_x86_get_exit_info)(vcpu, (u32 *)&info[0], &info[1],
+					   &info[2], (u32 *)&info[3],
+					   (u32 *)&info[4]);
 
 	run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 	run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	run->emulation_failure.ndata = 0;
+
+	/*
+	 * There's currently space for 13 entries, but 5 are used for the exit
+	 * reason and info.  Restrict to 4 to reduce the maintenance burden
+	 * when expanding kvm_run.emulation_failure in the future.
+	 */
+	if (WARN_ON_ONCE(ndata > 4))
+		ndata = 4;
+
+	/* Always include the flags as a 'data' entry. */
+	ndata_start = 1;
 	run->emulation_failure.flags = 0;
 
 	if (insn_size) {
-		run->emulation_failure.ndata = 3;
+		ndata_start += (sizeof(run->emulation_failure.insn_size) +
+				sizeof(run->emulation_failure.insn_bytes)) /
+			sizeof(u64);
 		run->emulation_failure.flags |=
 			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
 		run->emulation_failure.insn_size = insn_size;
 		memset(run->emulation_failure.insn_bytes, 0x90,
 		       sizeof(run->emulation_failure.insn_bytes));
-		memcpy(run->emulation_failure.insn_bytes,
-		       ctxt->fetch.data, insn_size);
+		memcpy(run->emulation_failure.insn_bytes, insn_bytes, insn_size);
 	}
+
+	memcpy(&run->internal.data[ndata_start], info, sizeof(info));
+	memcpy(&run->internal.data[ndata_start + ARRAY_SIZE(info)], data,
+	       ndata * sizeof(u64));
+
+	run->emulation_failure.ndata = ndata_start + ARRAY_SIZE(info) + ndata;
 }
 
+static void prepare_emulation_ctxt_failure_exit(struct kvm_vcpu *vcpu)
+{
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+
+	prepare_emulation_failure_exit(vcpu, NULL, 0, ctxt->fetch.data,
+				       ctxt->fetch.end - ctxt->fetch.data);
+}
+
+void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
+					  u8 ndata)
+{
+	prepare_emulation_failure_exit(vcpu, data, ndata, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(__kvm_prepare_emulation_failure_exit);
+
+void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
+{
+	__kvm_prepare_emulation_failure_exit(vcpu, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(kvm_prepare_emulation_failure_exit);
+
 static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -7502,16 +7551,14 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 
 	if (kvm->arch.exit_on_emulation_error ||
 	    (emulation_type & EMULTYPE_SKIP)) {
-		prepare_emulation_failure_exit(vcpu);
+		prepare_emulation_ctxt_failure_exit(vcpu);
 		return 0;
 	}
 
 	kvm_queue_exception(vcpu, UD_VECTOR);
 
 	if (!is_guest_mode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) == 0) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		prepare_emulation_ctxt_failure_exit(vcpu);
 		return 0;
 	}
 
@@ -12104,9 +12151,7 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 	 * doesn't seem to be a real use-case behind such requests, just return
 	 * KVM_EXIT_INTERNAL_ERROR for now.
 	 */
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	vcpu->run->internal.ndata = 0;
+	kvm_prepare_emulation_failure_exit(vcpu);
 
 	return 0;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6c79c1ce3703..e86cc2de7b5c 100644
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
@@ -408,6 +414,7 @@ struct kvm_run {
 					__u8  insn_bytes[15];
 				};
 			};
+			/* Arbitrary debug data may follow. */
 		} emulation_failure;
 		/* KVM_EXIT_OSI */
 		struct {
-- 
2.30.2

