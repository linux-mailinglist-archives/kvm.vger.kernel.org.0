Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC4B35C71D
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 15:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241864AbhDLNKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 09:10:14 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:43285 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241792AbhDLNKI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 09:10:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 2D49216CB;
        Mon, 12 Apr 2021 09:09:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 12 Apr 2021 09:09:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=pP3D8CfwuZ5Kl25pMI94SawFWsdT3QpkB6qg7VJ6HYk=; b=KqbW9iMC
        UA2yDlHut02bEfBXwAoWdZe230Poru68UG+lAS7NdgXUXolqnHKAHI5N1HiIx5Eb
        Nrvc2lbOpuCRflO3QJxCSL2QqDihw073CX1ImLsx9g3P1TJpf3ftk/RHU4FhTdAM
        7yyxFDAwiXBpi532A9L8gW9QPSu+wsH5PsqXw3xd9fUQB4ht0l3aTzm8u0q9SJDr
        EIvJRZQqg73Zo/EI9GMfoAs+7M+llqrA5EQti0+Gik5VlJTijgCkEbJA23l0RUNQ
        O1TyO354pscXs9bYvw7IH3o8jqjww7N9KZsjjYYEYbZD3ZYYIECoyeCf6nx2gxrp
        l/wWW48f5yuiIw==
X-ME-Sender: <xms:mUZ0YO8oov26y0qjhiQ9g3x6msVMDFbfK4oz50GdpAGAP3pr6Bd62g>
    <xme:mUZ0YAuTSClDctmK9pNxNTTnEeg45gbbdTZvOEg9eMYlro3rX2THZOG73-859b-jI
    4zwPVSBvsMyOC3RFxY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekjedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:mUZ0YNb-m0ipyqHrtjiPk95_nuDT8x_kHYRjzUh0HF_oq22Fsls54w>
    <xmx:mUZ0YIq6zDMdjJRtvU8ra8pzZoou5tT9Mr8SDGeO5ekDmFKtWfEzHw>
    <xmx:mUZ0YK9VpmK7-XcBvxtur1_PR41FWT80oUGg8lvQGfn-qK_PFrlbTg>
    <xmx:mkZ0YLG244jUY2V8c0icIpyz4S1jB40lIyKYTG9loe3xiBUpVCCLQP9VwYDoVGx1>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id EB3C9240068;
        Mon, 12 Apr 2021 09:09:43 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id aaae85f0;
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
Subject: [PATCH 6/6] KVM: VMX: pass a proper reason in kvm_emulate_instruction()
Date:   Mon, 12 Apr 2021 14:09:37 +0100
Message-Id: <20210412130938.68178-7-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412130938.68178-1-david.edmondson@oracle.com>
References: <20210412130938.68178-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

Declare various causes of emulation and use them as appropriate.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++++
 arch/x86/kvm/vmx/vmx.c          | 17 +++++++++--------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e1284680cbdc..f401e7c79ded 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1541,6 +1541,11 @@ enum {
 	EMULREASON_SVM_CR,
 	EMULREASON_SVM_DR,
 	EMULREASON_SVM_AVIC_UNACCEL,
+	EMULREASON_VMX_APIC_ACCESS,
+	EMULREASON_VMX_EPT_VIOLATION,
+	EMULREASON_VMX_DESC,
+	EMULREASON_VMX_INV_GUEST,
+	EMULREASON_VMX_RMODE_EX,
 };
 
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 037b01b5a54b..799eb0713b76 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1600,7 +1600,7 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 #endif
 		kvm_rip_write(vcpu, rip);
 	} else {
-		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP, 0))
+		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP, EMULREASON_SKIP))
 			return 0;
 	}
 
@@ -4738,7 +4738,7 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 	 * Cause the #SS fault with 0 error code in VM86 mode.
 	 */
 	if (((vec == GP_VECTOR) || (vec == SS_VECTOR)) && err_code == 0) {
-		if (kvm_emulate_instruction(vcpu, 0, 0)) {
+		if (kvm_emulate_instruction(vcpu, 0, EMULREASON_VMX_RMODE_EX)) {
 			if (vcpu->arch.halt_request) {
 				vcpu->arch.halt_request = 0;
 				return kvm_vcpu_halt(vcpu);
@@ -4816,7 +4816,8 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
 			return 1;
 		}
-		return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP, 0);
+		return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP,
+					       EMULREASON_GP);
 	}
 
 	/*
@@ -4930,7 +4931,7 @@ static int handle_io(struct kvm_vcpu *vcpu)
 	++vcpu->stat.io_exits;
 
 	if (string)
-		return kvm_emulate_instruction(vcpu, 0, 0);
+		return kvm_emulate_instruction(vcpu, 0, EMULREASON_IO);
 
 	port = exit_qualification >> 16;
 	size = (exit_qualification & 7) + 1;
@@ -5004,7 +5005,7 @@ static int handle_set_cr4(struct kvm_vcpu *vcpu, unsigned long val)
 static int handle_desc(struct kvm_vcpu *vcpu)
 {
 	WARN_ON(!(vcpu->arch.cr4 & X86_CR4_UMIP));
-	return kvm_emulate_instruction(vcpu, 0, 0);
+	return kvm_emulate_instruction(vcpu, 0, EMULREASON_VMX_DESC);
 }
 
 static int handle_cr(struct kvm_vcpu *vcpu)
@@ -5244,7 +5245,7 @@ static int handle_apic_access(struct kvm_vcpu *vcpu)
 			return kvm_skip_emulated_instruction(vcpu);
 		}
 	}
-	return kvm_emulate_instruction(vcpu, 0, 0);
+	return kvm_emulate_instruction(vcpu, 0, EMULREASON_VMX_APIC_ACCESS);
 }
 
 static int handle_apic_eoi_induced(struct kvm_vcpu *vcpu)
@@ -5375,7 +5376,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	 * reconstruct the page fault error code.
 	 */
 	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
-		return kvm_emulate_instruction(vcpu, 0, 0);
+		return kvm_emulate_instruction(vcpu, 0, EMULREASON_VMX_EPT_VIOLATION);
 
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
@@ -5424,7 +5425,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		if (kvm_test_request(KVM_REQ_EVENT, vcpu))
 			return 1;
 
-		if (!kvm_emulate_instruction(vcpu, 0, 0))
+		if (!kvm_emulate_instruction(vcpu, 0, EMULREASON_VMX_INV_GUEST))
 			return 0;
 
 		if (vmx->emulation_required && !vmx->rmode.vm86_active &&
-- 
2.30.2

