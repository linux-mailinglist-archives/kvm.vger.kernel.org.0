Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B263BC923
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 12:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhGFKPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 06:15:00 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:36041 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231208AbhGFKO7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 06:14:59 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 40D96194064B;
        Tue,  6 Jul 2021 06:12:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 06 Jul 2021 06:12:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=AB7bywVY7Zr+boVLEC44cCSzxbcEDr+ke7k5Ng1AMT8=; b=d+m08sSm
        AvvAsic00KvdNS7vUIYe3DnaVTsZ5tz0II8tamWouL6QMUhFnz2waciFhj0If0xd
        EXL/b3HT5QbyNYU3ClvuEyRSAEJvRz6MXISnp1dNUNObxkFTmSB+nSRunYPHrmW+
        kxGP9llWBRDpmYk5Xo+F2l0MBanfR2Lk5GIJIcdLf881S0+RfnrYtuAKbyKVpuWr
        TwSH0TFpP2uYcTWd5QzVqSugAONskbQ+rGRXr7BLS0u+ikXEBgktlwrePZRkelK7
        hj5lklh/uXosRbm28HdW/A12oP5laMu7QkWvyEcbU3YPn1QzHwoc6P63Quma3ynh
        nVXF3a4Ku6pTUQ==
X-ME-Sender: <xms:fCzkYEUiHb9Fkr-B1QhDnOokK1PXdbIVZC3yykDmFUaxN_-NUYKUbw>
    <xme:fCzkYImxw0E4WAlMbPUwsgrDj1ycTHotzBPLF9yJiGKOb-kFr9k61-_WqPx9AY3zu
    rd8UrchHW2zFKPwIwM>
X-ME-Received: <xmr:fCzkYIYFgEGNeWNOMZE9UrqhaSLUaemKx1-UGSvMOaLswE1UoioAxQpwPHrQN774pNl9_I9N-VnfaiNdpqrNoqLS2WI21kRALDU4tHjVfUM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeejiedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtgho
    mh
X-ME-Proxy: <xmx:fCzkYDUq5HhQ0A9KR0tUzyfaJLoabLZwisTr9l_LXzg74Wm7obxrtg>
    <xmx:fCzkYOlaMZJhafRi_yrS1zjt9XjRZjeKmCZKcxRKuff4nXSHivUxxQ>
    <xmx:fCzkYIenY_TvuVNinI_H3KrQYBM3j6GD1l2DixxbCI_ogoOfp1Kt7Q>
    <xmx:hCzkYMs0TPSNj5uMjitZxUPDBw7lLkiXs8xEtPsr6LaIiFOg0pQEMUYFIhQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Jul 2021 06:12:11 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 297c459c;
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
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v2 1/2] KVM: x86: Add kvm_x86_ops.get_exit_reason
Date:   Tue,  6 Jul 2021 11:12:06 +0100
Message-Id: <20210706101207.2993686-2-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706101207.2993686-1-david.edmondson@oracle.com>
References: <20210706101207.2993686-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a per-implementation static call which returns the cause of the
most recent VM exit.

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
index 8834822c00cd..2180729ddcb0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3988,6 +3988,11 @@ static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
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
@@ -4552,6 +4557,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_tss_addr = svm_set_tss_addr,
 	.set_identity_map_addr = svm_set_identity_map_addr,
 	.get_mt_mask = svm_get_mt_mask,
+	.get_exit_reason = svm_get_exit_reason,
 
 	.get_exit_info = svm_get_exit_info,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 927a552393b9..d9a4d6cf6406 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6997,6 +6997,11 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return (cache << VMX_EPT_MT_EPTE_SHIFT) | ipat;
 }
 
+static u64 vmx_get_exit_reason(struct kvm_vcpu *vcpu)
+{
+	return to_vmx(vcpu)->exit_reason.full;
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

