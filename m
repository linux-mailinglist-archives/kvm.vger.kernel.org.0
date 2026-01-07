Return-Path: <kvm+bounces-67305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F2ADFD0070C
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 01:03:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A833F3068DE1
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 00:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DAD17261E;
	Thu,  8 Jan 2026 00:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aktech.ai header.i=@aktech.ai header.b="cPYedoDJ"
X-Original-To: kvm@vger.kernel.org
Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB1B1E86E
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 00:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767830457; cv=none; b=QG/EsZZTxqgG6aeeMC82mHhk0oX47ysOLqZe3m2RppinmzMnjiuAw+o8z9+SPaETCX1sNNYLXV6SwuRjppwsFECscXO7LdsfFojz1mtyS1eUXmsWLP3oGd+ws95c2p8FOur42i/ugWQ41nfJiGNnYrOLthsiRKYZFTu2b9L+13s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767830457; c=relaxed/simple;
	bh=aFgwOr/KqYX4ySBR1EKRazQg6NPWaa//WGgLoha+7c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onw5lqP2jivkzmsxy94weBg9SewjhgmjFNv4+zUP8ivODjp2nsxX6jTmwLhoYSTQhoC5G6JjUGeCnvtn1IHN1Mej07Gsu6iI2vt92e7lvJVyy68SthKDlykJcqIntGMwpxY+wouhvl8yvGAIKs/Gotu2tdJTp9WgCNBdUNQpTNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aktech.ai; spf=pass smtp.mailfrom=aktech.ai; dkim=pass (2048-bit key) header.d=aktech.ai header.i=@aktech.ai header.b=cPYedoDJ; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aktech.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aktech.ai
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id dWemvsjQcKXDJddSQvCJo7; Thu, 08 Jan 2026 00:00:54 +0000
Received: from gator4203.hostgator.com ([108.167.189.28])
	by cmsmtp with ESMTPS
	id ddSPvnw62K8vzddSPvGbdI; Thu, 08 Jan 2026 00:00:53 +0000
X-Authority-Analysis: v=2.4 cv=cJDgskeN c=1 sm=1 tr=0 ts=695ef3b5
 a=fpD4kzfX7W8RbeKAuMGPiQ==:117 a=fpD4kzfX7W8RbeKAuMGPiQ==:17
 a=vUbySO9Y5rIA:10 a=HaeQS5oA3WMA:10 a=pGLkceISAAAA:8 a=dFDANW6nmgN9SXOOpDQA:9
 a=tGAC0SnQRR4URLD-nMig:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aktech.ai;
	s=default; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3DhAKZzxj9aiyuEUKZsdfOvWpnqXVZ/er+xNTAr/J7U=; b=cPYedoDJlwIulfV9d55TQCSbfP
	3QHpUWirdN7yyXen9blVHGdjXvGo8+WanrqtqXShxTY8QmeelBUnm19V8U9nmkCePfxk2JS9C8FbU
	FGBdkDEY8cprP10uUdB+Tz9hqNssgMh4VqLdKuwgzgPssRpq81LDplNj0J2Bqw6FdlqHF9y/ckVmz
	7kWFTpGQ8nNHvNq6xPMzeNoyLZSct8SLAcZGzENoH1Q6FRge1Zd0Ajc5WMnEKAFkbys/Gzjzsw6ze
	e4XoKcxtcfvH/RJq7yzzbp36ewkhp+7jX2kYTl3F1v5G99JWoC3G5+QauwakfjQyf6N7y64wVZFqc
	+0K9B+rQ==;
Received: from fctnnbsc51w-159-2-155-244.dhcp-dynamic.fibreop.nb.bellaliant.net ([159.2.155.244]:49568 helo=owner-linux.home)
	by gator4203.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.99.1)
	(envelope-from <aidan@aktech.ai>)
	id 1vddSO-00000003d8m-1tuV;
	Wed, 07 Jan 2026 18:00:52 -0600
From: Aidan Khoury <aidan@aktech.ai>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Aidan Khoury <aidan@revers.engineering>,
	Nick Peterson <everdox@gmail.com>,
	Aidan Khoury <aidan@aktech.ai>
Subject: [PATCH v1 1/1] KVM: x86: Merge pending debug causes when vectoring #DB
Date: Wed,  7 Jan 2026 19:57:24 -0400
Message-ID: <20260107235724.28101-2-aidan@aktech.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260107235724.28101-1-aidan@aktech.ai>
References: <20260107235724.28101-1-aidan@aktech.ai>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4203.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - aktech.ai
X-BWhitelist: no
X-Source-IP: 159.2.155.244
X-Source-L: No
X-Exim-ID: 1vddSO-00000003d8m-1tuV
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: fctnnbsc51w-159-2-155-244.dhcp-dynamic.fibreop.nb.bellaliant.net (owner-linux.home) [159.2.155.244]:49568
X-Source-Auth: aidan@aktech.ai
X-Email-Count: 23
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: YWt0ZWNoYWk7YWt0ZWNoYWk7Z2F0b3I0MjAzLmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCxEj2noZqBkhWfWvxp8huKf4TsWKZQqmKR/RYz3TkFf+1LLImB7pxV5Bys6gJMv2QSputNW4VYvZfhHbUTimRQQFQvzRwFIpIHcR422P0/qsWK9FCyT
 tJgt1JJJdL1wcRDZs7Lt4HXdgIsmHIA4YixWGl4L10NWxwGn/9sVTT7DhZP1jq/NZ8R7b+b/RLpj7bGAdExE6CjmU0BmeGj8ks8=

Intel VMX records deferred debug exception causes in the VMCS field
GUEST_PENDING_DBG_EXCEPTIONS (B0-B3, enabled breakpoint, BS, RTM). This
state is used when debug exceptions are suppressed (e.g. by MOV SS / STI
interruptibility) and later become deliverable.

See Intel SDM Vol. 3C, 27.3.1.5 Checks on Guest Non-Register State
and Intel SDM Vol. 3C, 27.7.3 Delivery of Pending Debug Exceptions after VM Entry

KVM may vector a #DB exception after a VM-exit and/or instruction
emulation. In particular, after a MOV SS that encounters a data
breakpoint (and thus suppresses delivery for one instruction), the
following instruction may cause a VM-exit and be emulated (e.g. CPUID),
or it may be intercepted directly (e.g. ICEBP/INT1). In these flows,
VMX retains the deferred breakpoint cause in GUEST_PENDING_DBG_EXCEPTIONS
while KVM generates a #DB for single-step (BS). Prior to this change, the
resulting in guest DR6 missing B0-B3 even though bare metal reports the
combined reasons (e.g. BS+B0).

Fix this by merging pending debug causes from GUEST_PENDING_DBG_EXCEPTIONS
into the #DB payload when vectoring the #DB exception so the guest always
observes all accumulated reasons in DR6. The merging is done in the
kvm_deliver_exception_payload() function to cover all injection paths
where the payload may be consumed immediately by kvm_multiple_exception().

Reported-by: Nick Peterson <everdox@gmail.com>
Signed-off-by: Aidan Khoury <aidan@aktech.ai>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/vmx/main.c            |  9 +++++++++
 arch/x86/kvm/vmx/vmx.c             | 16 +++++++++++-----
 arch/x86/kvm/vmx/x86_ops.h         |  1 +
 arch/x86/kvm/x86.c                 | 12 ++++++++++++
 6 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index fdf178443f85..82fddf2fe61b 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -50,6 +50,7 @@ KVM_X86_OP(get_gdt)
 KVM_X86_OP(set_gdt)
 KVM_X86_OP(sync_dirty_debug_regs)
 KVM_X86_OP(set_dr7)
+KVM_X86_OP_OPTIONAL_RET0(get_pending_dbg_exceptions)
 KVM_X86_OP(cache_reg)
 KVM_X86_OP(get_rflags)
 KVM_X86_OP(set_rflags)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b74ae7183f3a..d4d0aa0a3a4a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1768,6 +1768,7 @@ struct kvm_x86_ops {
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
+	unsigned long (*get_pending_dbg_exceptions)(struct kvm_vcpu *vcpu);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 0eb2773b2ae2..1cd30f8e3625 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -465,6 +465,14 @@ static void vt_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 	vmx_set_dr7(vcpu, val);
 }
 
+static unsigned long vt_get_pending_dbg_exceptions(struct kvm_vcpu *vcpu)
+{
+	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		return 0;
+
+	return vmx_get_pending_dbg_exceptions(vcpu);
+}
+
 static void vt_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -907,6 +915,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.get_gdt = vt_op(get_gdt),
 	.set_gdt = vt_op(set_gdt),
 	.set_dr7 = vt_op(set_dr7),
+	.get_pending_dbg_exceptions = vt_op(get_pending_dbg_exceptions),
 	.sync_dirty_debug_regs = vt_op(sync_dirty_debug_regs),
 	.cache_reg = vt_op(cache_reg),
 	.get_rflags = vt_op(get_rflags),
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 91b6f2f3edc2..1b2e274fe317 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5300,13 +5300,13 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			 * have already expired.  Note, the CPU sets/clears BS
 			 * as appropriate for all other VM-Exits types.
 			 */
+			if ((vmx_get_rflags(vcpu) & X86_EFLAGS_TF) &&
+			    (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
+			     (GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS)))
+				vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
+				 vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) | DR6_BS);
 			if (is_icebp(intr_info))
 				WARN_ON(!skip_emulated_instruction(vcpu));
-			else if ((vmx_get_rflags(vcpu) & X86_EFLAGS_TF) &&
-				 (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
-				  (GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS)))
-				vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
-					    vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) | DR6_BS);
 
 			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
 			return 1;
@@ -5613,6 +5613,12 @@ void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 	vmcs_writel(GUEST_DR7, val);
 }
 
+unsigned long vmx_get_pending_dbg_exceptions(struct kvm_vcpu *vcpu)
+{
+	return vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) &
+		(DR6_RTM | DR6_BS | BIT(12) /*Enabled breakpoint*/ | DR_TRAP_BITS);
+}
+
 static int handle_tpr_below_threshold(struct kvm_vcpu *vcpu)
 {
 	kvm_apic_update_ppr(vcpu);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 9697368d65b3..365682799d05 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -75,6 +75,7 @@ void vmx_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val);
 void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val);
+unsigned long vmx_get_pending_dbg_exceptions(struct kvm_vcpu *vcpu);
 void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu);
 void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 19d2d6d9e64a..c889dffe4e59 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -765,11 +765,23 @@ static int exception_type(int vector)
 void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu,
 				   struct kvm_queued_exception *ex)
 {
+	unsigned long pending_dbg;
+
 	if (!ex->has_payload)
 		return;
 
 	switch (ex->vector) {
 	case DB_VECTOR:
+		/*
+		 * VMX records deferred debug causes (B0-B3, enabled breakpoint,
+		 * BS, RTM) in the vmcs.PENDING_DBG_EXCEPTIONS field.  Merge any
+		 * pending causes into the exception payload so the guest may
+		 * see all accumulated reasons in DR6 when the #DB is vectored.
+		 */
+		pending_dbg = kvm_x86_call(get_pending_dbg_exceptions)(vcpu);
+		if (pending_dbg)
+			ex->payload |= pending_dbg;
+
 		/*
 		 * "Certain debug exceptions may clear bit 0-3.  The
 		 * remaining contents of the DR6 register are never
-- 
2.43.0


