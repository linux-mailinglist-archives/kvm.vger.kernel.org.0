Return-Path: <kvm+bounces-12417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02122885CB7
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 16:55:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96B9EB23991
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E95E212C7E0;
	Thu, 21 Mar 2024 15:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eUBBdQ9s"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAAB12BF2F;
	Thu, 21 Mar 2024 15:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036474; cv=none; b=WaEi8WSCDNqdGDtiKRo1ozaYRQXjsmz/pAOr/AL4WlMFQ6zFvA4TGZ+FSe8utX5neRnQYEl8AwywsuQezMu5PBhmsGjnqEI6S3/a0uM1RXUhfRhRMWTYXDSQUt9VU4O9YTlxBNiDVL4RjlWLBivIFxlASfFDzkPZ0s1aRe509DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036474; c=relaxed/simple;
	bh=a1EZKWbXG+EBtjLQ+AYVHYib6EsPcSZP6QelcS//Wy4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MLtsfgYyD5w0NG6ZG0FL9Y/RVgLw//bvZv9HordX1JRkGD5ptnDpoOYHG2LE/B4MQajbbt75gDdWSJezzqRHOdadq0Hd140oiDgAM+ijjpLvpDmWRdOLuMVSsiluW2qegD2vJrmMFLpVGSyWY85+AvOUwhzxpBM3RR+o090P+7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eUBBdQ9s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB56C43601;
	Thu, 21 Mar 2024 15:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711036473;
	bh=a1EZKWbXG+EBtjLQ+AYVHYib6EsPcSZP6QelcS//Wy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUBBdQ9snlDxUl+bHFEmWy0XxFHzJDH9bVmBhDJ3lQP2+k3ykDMo82P07ugz3UVuW
	 UD5jLizVy585rid49jvOkOkUpLZVe4YLTgxWkXrCPoO0sc1+eFfyTnhcOBF48yaWp9
	 XMY2gCBA8Pdp+MobHx8aeuDS/jERMylwoWxl8d0L/t0OYkZ0liQi5k3G3vZ7QrW2Hf
	 VxXjiCMXCKoNmadGEI4rvnVbGTeaAbBL5JkISfBF3WsERquBvihhl3AWyA7/Kb+eA9
	 Xh47rJBMvLmWCpDV29c2C7x2PyLVJB5vMqaIAkz68CxCYa0V3II/HSKPReGcBzrn/H
	 Rp4ts3/VJ7V1Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rnKkS-00EEqz-2i;
	Thu, 21 Mar 2024 15:54:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 13/15] KVM: arm64: nv: Handle ERETA[AB] instructions
Date: Thu, 21 Mar 2024 15:53:54 +0000
Message-Id: <20240321155356.3236459-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240321155356.3236459-1-maz@kernel.org>
References: <20240321155356.3236459-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we have some emulation in place for ERETA[AB], we can
plug it into the exception handling machinery.

As for a bare ERET, an "easy" ERETAx instruction is processed as
a fixup, while something that requires a translation regime
transition or an exception delivery is left to the slow path.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 22 ++++++++++++++++++++--
 arch/arm64/kvm/handle_exit.c    |  3 ++-
 arch/arm64/kvm/hyp/vhe/switch.c | 13 +++++++++++--
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 63a74c0330f1..72d733c74a38 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2172,7 +2172,7 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 
 void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 {
-	u64 spsr, elr;
+	u64 spsr, elr, esr;
 
 	/*
 	 * Forward this trap to the virtual EL2 if the virtual
@@ -2181,12 +2181,30 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	if (forward_traps(vcpu, HCR_NV))
 		return;
 
+	/* Check for an ERETAx */
+	esr = kvm_vcpu_get_esr(vcpu);
+	if (esr_iss_is_eretax(esr) && !kvm_auth_eretax(vcpu, &elr)) {
+		/*
+		 * Oh no, ERETAx failed to authenticate.  If we have
+		 * FPACCOMBINE, deliver an exception right away.  If we
+		 * don't, then let the mangled ELR value trickle down the
+		 * ERET handling, and the guest will have a little surprise.
+		 */
+		if (kvm_has_pauth(vcpu->kvm, FPACCOMBINE)) {
+			esr &= ESR_ELx_ERET_ISS_ERETA;
+			esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_FPAC);
+			kvm_inject_nested_sync(vcpu, esr);
+			return;
+		}
+	}
+
 	preempt_disable();
 	kvm_arch_vcpu_put(vcpu);
 
 	spsr = __vcpu_sys_reg(vcpu, SPSR_EL2);
 	spsr = kvm_check_illegal_exception_return(vcpu, spsr);
-	elr = __vcpu_sys_reg(vcpu, ELR_EL2);
+	if (!esr_iss_is_eretax(esr))
+		elr = __vcpu_sys_reg(vcpu, ELR_EL2);
 
 	trace_kvm_nested_eret(vcpu, elr, spsr);
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 1ba2f788b2c3..407bdfbb572b 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -248,7 +248,8 @@ static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
 
 static int kvm_handle_eret(struct kvm_vcpu *vcpu)
 {
-	if (esr_iss_is_eretax(kvm_vcpu_get_esr(vcpu)))
+	if (esr_iss_is_eretax(kvm_vcpu_get_esr(vcpu)) &&
+	    !vcpu_has_ptrauth(vcpu))
 		return kvm_handle_ptrauth(vcpu);
 
 	/*
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 3ea9bdf6b555..49d36666040e 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -208,7 +208,8 @@ void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
 
 static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	u64 spsr, mode;
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+	u64 spsr, elr, mode;
 
 	/*
 	 * Going through the whole put/load motions is a waste of time
@@ -242,10 +243,18 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 		return false;
 	}
 
+	/* If ERETAx fails, take the slow path */
+	if (esr_iss_is_eretax(esr)) {
+		if (!(vcpu_has_ptrauth(vcpu) && kvm_auth_eretax(vcpu, &elr)))
+			return false;
+	} else {
+		elr = read_sysreg_el1(SYS_ELR);
+	}
+
 	spsr = (spsr & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
 
 	write_sysreg_el2(spsr, SYS_SPSR);
-	write_sysreg_el2(read_sysreg_el1(SYS_ELR), SYS_ELR);
+	write_sysreg_el2(elr, SYS_ELR);
 
 	return true;
 }
-- 
2.39.2


