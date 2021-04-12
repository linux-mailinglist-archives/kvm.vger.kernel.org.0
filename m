Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A4735C716
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 15:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241805AbhDLNKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 09:10:07 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:38679 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241764AbhDLNKE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 09:10:04 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailforward.west.internal (Postfix) with ESMTP id 388C41646;
        Mon, 12 Apr 2021 09:09:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Mon, 12 Apr 2021 09:09:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=rxrObZQedU/z7tCgm77WVlD0YetrXNOgn2ee61sfp4A=; b=joNyhsO/
        3wrGui5X+5el2vu/d76fkIdTYIgjhtWpcos5V8fuUWdrIJtIBsItrBWU3ZNRBqVP
        BQLJngzpyReV6PH+1j9ezqNaeU0M/lIYD4fyVYF9URb9xR5NTiyU/0eCq13SI3H3
        sVqBAz0S12xkRrfIwx1chSdrj6CSiSreSYfadhNzSNh22nbCb84TkRIkA2iUQ5Ki
        z2Yeu2uaE8BVr+sOquxppdjbO9f0Ff6e5SfOjHqcSJOX77vn/oc/usKrKheNeNRd
        tcllnQPaiH89VjrzdcSu8Ez8RHLyVdkONUq/EqmntnLDO0HQC9xN9em/gGf9Knt2
        Z0P1SSI15HsCbQ==
X-ME-Sender: <xms:lkZ0YHhet6EMe3ntOBcMSjYkGIepSs4zy7zw4DRTDE03DuUGrnds4g>
    <xme:lkZ0YO8nw0-W32WlqIt9OFFxR4MJ7DAHqFTuvOAtR-prcf0QQYz62weS1G6sHpDcj
    fPCt-3pl2GUlQ65xRc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekjedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:lkZ0YGExVWz5KV53CtYLxQxZtEvovG7Q08ThJTXn0jDHzdHjyM3ApA>
    <xmx:lkZ0YJkw3Uxz6j5-BG1gtMDoBIM4v_TNnDnRZKw4zil5z8MwyQvxZA>
    <xmx:lkZ0YCYDJ9r9jCMZRPXfNCeMJL1U8-vjP_bUMrjAMnUKI01SKt0oCQ>
    <xmx:l0Z0YOtHNEL0XOeS9hqqQLN1uRaXPAIMpfrQxtnsxzpALB0BHAyZLY3Lmhoz4WVQ>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id 02AEE1080066;
        Mon, 12 Apr 2021 09:09:40 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id f21f3cb5;
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
Subject: [PATCH 1/6] KVM: x86: add an emulation_reason to x86_emulate_instruction()
Date:   Mon, 12 Apr 2021 14:09:32 +0100
Message-Id: <20210412130938.68178-2-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412130938.68178-1-david.edmondson@oracle.com>
References: <20210412130938.68178-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

Emulation can happen for a variety of reasons, yet on error we have no
idea exactly what triggered it. Expand x86_emulate_instruction() to
carry an @emulation_reason argument.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 arch/x86/kvm/x86.c     | 7 ++++---
 arch/x86/kvm/x86.h     | 3 ++-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 951dae4e7175..515ff790b7c5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5056,8 +5056,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
 		emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
 emulate:
-	return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type, insn,
-				       insn_len);
+	return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type, 0,
+				       insn, insn_len);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eca63625aee4..87e76f3aee64 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7445,7 +7445,8 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 EXPORT_SYMBOL_GPL(x86_decode_emulated_instruction);
 
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-			    int emulation_type, void *insn, int insn_len)
+			    int emulation_type, int emulation_reason,
+			    void *insn, int insn_len)
 {
 	int r;
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
@@ -7604,14 +7605,14 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type)
 {
-	return x86_emulate_instruction(vcpu, 0, emulation_type, NULL, 0);
+	return x86_emulate_instruction(vcpu, 0, emulation_type, 0, NULL, 0);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_instruction);
 
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
 					void *insn, int insn_len)
 {
-	return x86_emulate_instruction(vcpu, 0, 0, insn, insn_len);
+	return x86_emulate_instruction(vcpu, 0, 0, 0, insn, insn_len);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_instruction_from_buffer);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 9035e34aa156..5686436c99da 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -276,7 +276,8 @@ void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_c
 int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 				    void *insn, int insn_len);
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-			    int emulation_type, void *insn, int insn_len);
+			    int emulation_type, int emulation_reason,
+			    void *insn, int insn_len);
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
 
 extern u64 host_xcr0;
-- 
2.30.2

