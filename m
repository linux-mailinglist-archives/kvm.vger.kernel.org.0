Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993A33B67D6
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 19:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbhF1Rn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 13:43:29 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:59847 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234120AbhF1RnZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 13:43:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id A277819403E0;
        Mon, 28 Jun 2021 13:32:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Jun 2021 13:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=m5RQYIIxEWRaScv2dRV3lT42yMImRSZYD3RHWfud8VE=; b=vg2O7wc8
        tE8Nc4RD5fbxvgPjFhJH8BltktiCvcOyfC3vAQPdt/8wzoZgTMWvUMpsd6pM2AKk
        NOdN/4JVLjX1O5Nr18UGF3gXA1m6kTU8F+94r9wFALMRiVG9N5oJM6E1S6RswOYV
        fRlgmvYyhj9o6+F5ZL3rqzumQy6718lKPhOxLh7x8NIafgXOw5UCtNYqCt1aN95G
        KhscIhITMSoBAR0RCEMNKw9euh081MaWeKofLBLiPgKgniRciMmof22XwnC6bL1F
        YPbBb+ZylQu5im5eowsdqClotyWq3he3/5PD1VAr29ym7OzHxrdxC0Q6LA8vu19y
        l5UC3ZhBu/w9qQ==
X-ME-Sender: <xms:jAfaYBDpb-paINkTJu5Psjz70Pb3a9y_oL7RXf0CoWjcNYu36nFOcA>
    <xme:jAfaYPi3wF_fe2iQrSeYSWnxotuPu_yAG4IniN6KbAdIe504xnp582auKHn4Hw2FW
    UCG14Nj9cEEvHQqcVg>
X-ME-Received: <xmr:jAfaYMl8V4qoiD-6is_MOPWysCH8tX_1lsKgbHI9_xHjZ1KlH_dVATa37RXaSxQWuT5aD49JSlMaqKrR_7O5fpC-XMGxniLZV01gdK0DAvI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehgedguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrvhhi
    ugcugfgumhhonhgushhonhcuoegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvg
    drtghomheqnecuggftrfgrthhtvghrnhepudefteejgfefhfdtjefhhedtffethfetkeeh
    gfelheffhfeihfeglefgjedtheeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepuggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgt
    ohhm
X-ME-Proxy: <xmx:jAfaYLwjjB0iWJMDDKgT1PKdLVcdryfUuO5n-mrMzMJxf2hbfr59QA>
    <xmx:jAfaYGTjWbKac7BXTPsd338YGaqb77jZ6ADpPUhQXRKpxRg1UiUXOg>
    <xmx:jAfaYOZFqIvwbwu-RU2uDTGQpvlfQhWG4cks_yIIX4u_3PCTDzN1HQ>
    <xmx:kAfaYLIWUBZQCvKQo30Y4V7CogAbujFGVLh2NTqMWvwNmWEROQhYQeH2FeI>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Jun 2021 13:31:55 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id ca97c4c1;
        Mon, 28 Jun 2021 17:31:52 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH 1/2] KVM: x86: Add kvm_x86_ops.get_exit_reason
Date:   Mon, 28 Jun 2021 18:31:51 +0100
Message-Id: <20210628173152.2062988-2-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628173152.2062988-1-david.edmondson@oracle.com>
References: <20210628173152.2062988-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For later use.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 1 +
 arch/x86/kvm/svm/svm.c             | 6 ++++++
 arch/x86/kvm/vmx/vmx.c             | 6 ++++++
 4 files changed, 14 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index a12a4987154e..afb0917497c1 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -85,6 +85,7 @@ KVM_X86_OP_NULL(sync_pir_to_irr)
 KVM_X86_OP(set_tss_addr)
 KVM_X86_OP(set_identity_map_addr)
 KVM_X86_OP(get_mt_mask)
+KVM_X86_OP(get_exit_reason)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP_NULL(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 974cbfb1eefe..0ee580c68839 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1365,6 +1365,7 @@ struct kvm_x86_ops {
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
+	u64 (*get_exit_reason)(struct kvm_vcpu *vcpu);
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 616b9679ddcc..408c854b4ac9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4009,6 +4009,11 @@ static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return 0;
 }
 
+static u64 svm_get_exit_reason(struct kvm_vcpu *vcpu)
+{
+	return to_svm(vcpu)->vmcb->control.exit_code;
+}
+
 static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4573,6 +4578,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_tss_addr = svm_set_tss_addr,
 	.set_identity_map_addr = svm_set_identity_map_addr,
 	.get_mt_mask = svm_get_mt_mask,
+	.get_exit_reason = svm_get_exit_reason,
 
 	.get_exit_info = svm_get_exit_info,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 927a552393b9..a19b006c287a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6997,6 +6997,11 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return (cache << VMX_EPT_MT_EPTE_SHIFT) | ipat;
 }
 
+static u64 vmx_get_exit_reason(struct kvm_vcpu *vcpu)
+{
+	return to_vmx(vcpu)->exit_reason.basic;
+}
+
 static void vmcs_set_secondary_exec_control(struct vcpu_vmx *vmx)
 {
 	/*
@@ -7613,6 +7618,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
 	.get_mt_mask = vmx_get_mt_mask,
+	.get_exit_reason = vmx_get_exit_reason,
 
 	.get_exit_info = vmx_get_exit_info,
 
-- 
2.30.2

