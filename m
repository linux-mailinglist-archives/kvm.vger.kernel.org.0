Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC6335C71C
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 15:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241855AbhDLNKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 09:10:13 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:47791 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241785AbhDLNKH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 09:10:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 466AC16AE;
        Mon, 12 Apr 2021 09:09:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 12 Apr 2021 09:09:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=dN/QNHiyGToQXM6hoRPaubgFTy6JlFGJ5tVi33Nr9Qk=; b=IjPqjmdc
        fQr6R0d27isL50Bc8F3cCWghdQ9ZYZhM4o6dQEWWTO/BKvW9wbwizTw+NYsk8DTZ
        b1RrcQf8Q5CdYo5fpMwWkq5LGPwyOnWL7N4n3lBEf70a0s+fNdkvEqAAvov0Rsr3
        5sGBrXvfcKXuki1CPACTJAva5xHUmP8R0C6yk7qyIS41LR/WC9nmwsaAXpDEMq0w
        7dlI0lAZaylhBJR1GwK+3u2SHI0gQhsIodb2bRqisz5yFQlZeY1vHGnlNeXkN8O3
        TvSfYb4yGV7QUeeX22sG04D3/mGI5BXhp01CGyO7MGzXuOzJPdW0I1tjyPFVqOLH
        mahahAu9RsXL3g==
X-ME-Sender: <xms:mEZ0YEyfL1hqXLOZCfzTTkhvaDm6pGFzHxW8VhmjvPoV7VIfRSTLqA>
    <xme:mEZ0YIOc6n-zaxYLmFRlMroyCtpBpm83EQgmR4ci9FteO8b34GdeujuHgoPwZtKX4
    u3VgwXI2GTuii-aDV4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekjedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:mEZ0YDNLa8OrfrPN0R-lTIx48LLcIA4PTzVRU4f1sIjxWCDdaK2U2A>
    <xmx:mEZ0YKTD7ei3BJOKzUFSxjBGoP6bqNnyaT3LCeJB9mUhe6xnqB97Cg>
    <xmx:mEZ0YFCuMG0FpiNZ0yWJWszhHUIrxQ-eAwuy_RMbvii2bVwW3Q0mRw>
    <xmx:mUZ0YBU-8tHXnqI4X0NhhUcfw0mUbvw9HkVbmdYsB1TCdOoSFtPLBlNzgcmsG-o8>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id A921E1080068;
        Mon, 12 Apr 2021 09:09:43 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id abdc0c66;
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
Subject: [PATCH 5/6] KVM: SVM: pass a proper reason in kvm_emulate_instruction()
Date:   Mon, 12 Apr 2021 14:09:36 +0100
Message-Id: <20210412130938.68178-6-david.edmondson@oracle.com>
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
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/svm/avic.c         |  3 ++-
 arch/x86/kvm/svm/svm.c          | 26 +++++++++++++++-----------
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 79e9ca756742..e1284680cbdc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1535,6 +1535,12 @@ enum {
 	EMULREASON_IO_COMPLETE,
 	EMULREASON_UD,
 	EMULREASON_PF,
+	EMULREASON_SVM_NOASSIST,
+	EMULREASON_SVM_RSM,
+	EMULREASON_SVM_RDPMC,
+	EMULREASON_SVM_CR,
+	EMULREASON_SVM_DR,
+	EMULREASON_SVM_AVIC_UNACCEL,
 };
 
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type,
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 31a17fa6a37c..faa5d4db7ccc 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -558,7 +558,8 @@ int avic_unaccelerated_access_interception(struct vcpu_svm *svm)
 		ret = avic_unaccel_trap_write(svm);
 	} else {
 		/* Handling Fault */
-		ret = kvm_emulate_instruction(&svm->vcpu, 0, 0);
+		ret = kvm_emulate_instruction(&svm->vcpu, 0,
+					      EMULREASON_SVM_AVIC_UNACCEL);
 	}
 
 	return ret;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bba3b72390a8..2646aa2eae22 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -344,7 +344,8 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	}
 
 	if (!svm->next_rip) {
-		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP, 0))
+		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP,
+					     EMULREASON_SKIP))
 			return 0;
 	} else {
 		kvm_rip_write(vcpu, svm->next_rip);
@@ -2077,7 +2078,8 @@ static int io_interception(struct vcpu_svm *svm)
 		if (sev_es_guest(vcpu->kvm))
 			return sev_es_string_io(svm, size, port, in);
 		else
-			return kvm_emulate_instruction(vcpu, 0, 0);
+			return kvm_emulate_instruction(vcpu, 0,
+						       EMULREASON_IO);
 	}
 
 	svm->next_rip = svm->vmcb->control.exit_info_2;
@@ -2263,7 +2265,8 @@ static int gp_interception(struct vcpu_svm *svm)
 		 */
 		if (!is_guest_mode(vcpu))
 			return kvm_emulate_instruction(vcpu,
-				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE, 0);
+				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE,
+				EMULREASON_GP);
 	} else
 		return emulate_svm_instr(vcpu, opcode);
 
@@ -2459,20 +2462,21 @@ static int invd_interception(struct vcpu_svm *svm)
 static int invlpg_interception(struct vcpu_svm *svm)
 {
 	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
-		return kvm_emulate_instruction(&svm->vcpu, 0, 0);
+		return kvm_emulate_instruction(&svm->vcpu, 0, EMULREASON_SVM_NOASSIST);
 
 	kvm_mmu_invlpg(&svm->vcpu, svm->vmcb->control.exit_info_1);
 	return kvm_skip_emulated_instruction(&svm->vcpu);
 }
 
-static int emulate_on_interception(struct vcpu_svm *svm)
+static int emulate_on_interception(struct vcpu_svm *svm, int emulation_reason)
 {
-	return kvm_emulate_instruction(&svm->vcpu, 0, 0);
+	return kvm_emulate_instruction(&svm->vcpu, 0, emulation_reason);
 }
 
 static int rsm_interception(struct vcpu_svm *svm)
 {
-	return kvm_emulate_instruction_from_buffer(&svm->vcpu, rsm_ins_bytes, 2, 0);
+	return kvm_emulate_instruction_from_buffer(&svm->vcpu, rsm_ins_bytes, 2,
+						   EMULREASON_SVM_RSM);
 }
 
 static int rdpmc_interception(struct vcpu_svm *svm)
@@ -2480,7 +2484,7 @@ static int rdpmc_interception(struct vcpu_svm *svm)
 	int err;
 
 	if (!nrips)
-		return emulate_on_interception(svm);
+		return emulate_on_interception(svm, EMULREASON_SVM_RDPMC);
 
 	err = kvm_rdpmc(&svm->vcpu);
 	return kvm_complete_insn_gp(&svm->vcpu, err);
@@ -2516,10 +2520,10 @@ static int cr_interception(struct vcpu_svm *svm)
 	int err;
 
 	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
-		return emulate_on_interception(svm);
+		return emulate_on_interception(svm, EMULREASON_SVM_NOASSIST);
 
 	if (unlikely((svm->vmcb->control.exit_info_1 & CR_VALID) == 0))
-		return emulate_on_interception(svm);
+		return emulate_on_interception(svm, EMULREASON_SVM_CR);
 
 	reg = svm->vmcb->control.exit_info_1 & SVM_EXITINFO_REG_MASK;
 	if (svm->vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE)
@@ -2635,7 +2639,7 @@ static int dr_interception(struct vcpu_svm *svm)
 	}
 
 	if (!boot_cpu_has(X86_FEATURE_DECODEASSISTS))
-		return emulate_on_interception(svm);
+		return emulate_on_interception(svm, EMULREASON_SVM_NOASSIST);
 
 	reg = svm->vmcb->control.exit_info_1 & SVM_EXITINFO_REG_MASK;
 	dr = svm->vmcb->control.exit_code - SVM_EXIT_READ_DR0;
-- 
2.30.2

