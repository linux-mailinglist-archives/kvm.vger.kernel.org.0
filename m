Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3AB35C719
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 15:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241811AbhDLNKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 09:10:12 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:34335 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241780AbhDLNKG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 09:10:06 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id E0CF61940D17;
        Mon, 12 Apr 2021 09:09:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 12 Apr 2021 09:09:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=PNPHfpaBHzXgU4hdFtTS8uZfK8FmZhnLclHnBghCsfo=; b=Svz0+dXo
        UwdN98T7fwKmqgNjKwpM+ifVjaK22nmQDZ7Q9iGXRztZOZNj9T3dcMSyIQibYPBI
        4WW1QPTTrsInZuoO7FfHDIQosFg0nOorMkT9qRIZ+zQkqjQrSHouTb4pTs0GZJvH
        eacW1K0vZQi0Ud/1PutZ41+7BUVPTVuAnb3fAj+pKDl7S8q7XN3zLLcx+YZk0GIF
        r/DhOFtF1v4xFhY+eeS8YNVF/7rF5ch1RUw+bsiEzbNilnunKFxQ/RKnNGlzSVBS
        7R72tFtSHQhnhPSi+6uKwy3ilVKLI1uDiCK0tJXAky25F9PuzvioVWCX6C6dkhvy
        7HobhbYYm1XsMQ==
X-ME-Sender: <xms:l0Z0YOOfSzTyLiLUMvPlBj_E0pxJk-sQVfukPRYt-fMZT_7uJIUcHw>
    <xme:l0Z0YO9wP_HP-LhuTuQFWT8f-g1kSeMj_fj-_dyoVL0U_rDsb_pBwuDaEBevCu-jD
    o2Dv3ZSZ6HL_ABCpMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekjedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:l0Z0YOpQQ34eNcb2CNOY3mAPJRqFfCx7XEco5J3bcMQv0CbL0FisFg>
    <xmx:l0Z0YA6lOGJD8KyX2x-qqvcl-iguym9XdiFDqeHxnT0sQ9vSZboq_Q>
    <xmx:l0Z0YOPH-8QP6smWAHhEKcNgeN_ZJ_D4NQWPZYNaZqJlbdWSA-Xmig>
    <xmx:mkZ0YGVQdMCULHVyh0RWo1WGySxKy2N8pHpPqGBZ5tKmPFEgEEsk9eUzy0E>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A20C108005F;
        Mon, 12 Apr 2021 09:09:42 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 213529a7;
        Mon, 12 Apr 2021 13:09:38 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH 3/6] KVM: x86: add emulation_reason to kvm_emulate_instruction()
Date:   Mon, 12 Apr 2021 14:09:34 +0100
Message-Id: <20210412130938.68178-4-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412130938.68178-1-david.edmondson@oracle.com>
References: <20210412130938.68178-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

Allow kvm_emulate_instruction() callers to provide the cause of
instruction emulation, which is then passed along to
x86_emulation_instruction().

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 10 ++++++++--
 arch/x86/kvm/svm/avic.c         |  2 +-
 arch/x86/kvm/svm/svm.c          | 12 ++++++------
 arch/x86/kvm/vmx/vmx.c          | 16 ++++++++--------
 arch/x86/kvm/x86.c              | 16 ++++++++++------
 5 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3768819693e5..556dc51e322a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1527,9 +1527,15 @@ extern u64 kvm_mce_cap_supported;
 #define EMULTYPE_VMWARE_GP	    (1 << 5)
 #define EMULTYPE_PF		    (1 << 6)
 
-int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
+enum {
+	EMULREASON_UNKNOWN = 0,
+};
+
+int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type,
+			    int emulation_reason);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
-					void *insn, int insn_len);
+					void *insn, int insn_len,
+					int emulation_reason);
 
 void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 78bdcfac4e40..31a17fa6a37c 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -558,7 +558,7 @@ int avic_unaccelerated_access_interception(struct vcpu_svm *svm)
 		ret = avic_unaccel_trap_write(svm);
 	} else {
 		/* Handling Fault */
-		ret = kvm_emulate_instruction(&svm->vcpu, 0);
+		ret = kvm_emulate_instruction(&svm->vcpu, 0, 0);
 	}
 
 	return ret;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58a45bb139f8..bba3b72390a8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -344,7 +344,7 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	}
 
 	if (!svm->next_rip) {
-		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
+		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP, 0))
 			return 0;
 	} else {
 		kvm_rip_write(vcpu, svm->next_rip);
@@ -2077,7 +2077,7 @@ static int io_interception(struct vcpu_svm *svm)
 		if (sev_es_guest(vcpu->kvm))
 			return sev_es_string_io(svm, size, port, in);
 		else
-			return kvm_emulate_instruction(vcpu, 0);
+			return kvm_emulate_instruction(vcpu, 0, 0);
 	}
 
 	svm->next_rip = svm->vmcb->control.exit_info_2;
@@ -2263,7 +2263,7 @@ static int gp_interception(struct vcpu_svm *svm)
 		 */
 		if (!is_guest_mode(vcpu))
 			return kvm_emulate_instruction(vcpu,
-				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
+				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE, 0);
 	} else
 		return emulate_svm_instr(vcpu, opcode);
 
@@ -2459,7 +2459,7 @@ static int invd_interception(struct vcpu_svm *svm)
 static int invlpg_interception(struct vcpu_svm *svm)
 {
 	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
-		return kvm_emulate_instruction(&svm->vcpu, 0);
+		return kvm_emulate_instruction(&svm->vcpu, 0, 0);
 
 	kvm_mmu_invlpg(&svm->vcpu, svm->vmcb->control.exit_info_1);
 	return kvm_skip_emulated_instruction(&svm->vcpu);
@@ -2467,12 +2467,12 @@ static int invlpg_interception(struct vcpu_svm *svm)
 
 static int emulate_on_interception(struct vcpu_svm *svm)
 {
-	return kvm_emulate_instruction(&svm->vcpu, 0);
+	return kvm_emulate_instruction(&svm->vcpu, 0, 0);
 }
 
 static int rsm_interception(struct vcpu_svm *svm)
 {
-	return kvm_emulate_instruction_from_buffer(&svm->vcpu, rsm_ins_bytes, 2);
+	return kvm_emulate_instruction_from_buffer(&svm->vcpu, rsm_ins_bytes, 2, 0);
 }
 
 static int rdpmc_interception(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 32cf8287d4a7..037b01b5a54b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1600,7 +1600,7 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 #endif
 		kvm_rip_write(vcpu, rip);
 	} else {
-		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
+		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP, 0))
 			return 0;
 	}
 
@@ -4738,7 +4738,7 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 	 * Cause the #SS fault with 0 error code in VM86 mode.
 	 */
 	if (((vec == GP_VECTOR) || (vec == SS_VECTOR)) && err_code == 0) {
-		if (kvm_emulate_instruction(vcpu, 0)) {
+		if (kvm_emulate_instruction(vcpu, 0, 0)) {
 			if (vcpu->arch.halt_request) {
 				vcpu->arch.halt_request = 0;
 				return kvm_vcpu_halt(vcpu);
@@ -4816,7 +4816,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
 			return 1;
 		}
-		return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
+		return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP, 0);
 	}
 
 	/*
@@ -4930,7 +4930,7 @@ static int handle_io(struct kvm_vcpu *vcpu)
 	++vcpu->stat.io_exits;
 
 	if (string)
-		return kvm_emulate_instruction(vcpu, 0);
+		return kvm_emulate_instruction(vcpu, 0, 0);
 
 	port = exit_qualification >> 16;
 	size = (exit_qualification & 7) + 1;
@@ -5004,7 +5004,7 @@ static int handle_set_cr4(struct kvm_vcpu *vcpu, unsigned long val)
 static int handle_desc(struct kvm_vcpu *vcpu)
 {
 	WARN_ON(!(vcpu->arch.cr4 & X86_CR4_UMIP));
-	return kvm_emulate_instruction(vcpu, 0);
+	return kvm_emulate_instruction(vcpu, 0, 0);
 }
 
 static int handle_cr(struct kvm_vcpu *vcpu)
@@ -5244,7 +5244,7 @@ static int handle_apic_access(struct kvm_vcpu *vcpu)
 			return kvm_skip_emulated_instruction(vcpu);
 		}
 	}
-	return kvm_emulate_instruction(vcpu, 0);
+	return kvm_emulate_instruction(vcpu, 0, 0);
 }
 
 static int handle_apic_eoi_induced(struct kvm_vcpu *vcpu)
@@ -5375,7 +5375,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	 * reconstruct the page fault error code.
 	 */
 	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
-		return kvm_emulate_instruction(vcpu, 0);
+		return kvm_emulate_instruction(vcpu, 0, 0);
 
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
@@ -5424,7 +5424,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		if (kvm_test_request(KVM_REQ_EVENT, vcpu))
 			return 1;
 
-		if (!kvm_emulate_instruction(vcpu, 0))
+		if (!kvm_emulate_instruction(vcpu, 0, 0))
 			return 0;
 
 		if (vmx->emulation_required && !vmx->rmode.vm86_active &&
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b9225012ebd2..88519bf6bd00 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6197,7 +6197,7 @@ int handle_ud(struct kvm_vcpu *vcpu)
 		emul_type = EMULTYPE_TRAP_UD_FORCED;
 	}
 
-	return kvm_emulate_instruction(vcpu, emul_type);
+	return kvm_emulate_instruction(vcpu, emul_type, 0);
 }
 EXPORT_SYMBOL_GPL(handle_ud);
 
@@ -7608,16 +7608,20 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return r;
 }
 
-int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type)
+int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type,
+			    int emulation_reason)
 {
-	return x86_emulate_instruction(vcpu, 0, emulation_type, 0, NULL, 0);
+	return x86_emulate_instruction(vcpu, 0, emulation_type,
+				       emulation_reason, NULL, 0);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_instruction);
 
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
-					void *insn, int insn_len)
+					void *insn, int insn_len,
+					int emulation_reason)
 {
-	return x86_emulate_instruction(vcpu, 0, 0, 0, insn, insn_len);
+	return x86_emulate_instruction(vcpu, 0, 0,
+				       emulation_reason, insn, insn_len);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_instruction_from_buffer);
 
@@ -9339,7 +9343,7 @@ static inline int complete_emulated_io(struct kvm_vcpu *vcpu)
 	int r;
 
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
-	r = kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
+	r = kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE, 0);
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 	return r;
 }
-- 
2.30.2

