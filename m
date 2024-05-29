Return-Path: <kvm+bounces-18316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B33B48D3A0B
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 16:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A9661F2625E
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA32181CE7;
	Wed, 29 May 2024 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="roNxI5pD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0827417F39E;
	Wed, 29 May 2024 14:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716994596; cv=none; b=YakXOEkY++IzWg1BIgk0ehrhlPlDZSyqxpMOdn2Sb/nevYAeCqjxGmJXjaWwozM+9/ajbfXFUlVnMnxeCutYztsLHJiLhg4MKApqB70uta8s4s70Z65Zgi4n9ZxHpHsiOkfsxfV1gp3J6YHx3OkDKWO6Zd1ILfv52hRbheyZJVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716994596; c=relaxed/simple;
	bh=R248gaby0XedPY/sNz9iwnTRy32Bls10nlswI1GHrQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gnUEiC8Sh8qyEhhxs26Fo20vC2PuZPxS7aIW4CSHc+wRvlJNta/OpIWeV7gFb7ALurlbhLb6odGL9Njq70sv1UIJIY2idcZpoWH+wY7BNb3oFx+7YEkG61LKmw1FviqdUd516O1Ir55eyR/gKKt0rPuofw2o4uZD9kh9BlV7+Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=roNxI5pD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB8EC113CC;
	Wed, 29 May 2024 14:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716994595;
	bh=R248gaby0XedPY/sNz9iwnTRy32Bls10nlswI1GHrQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roNxI5pDSWMSsaBRBpiN2WxEJhNqr+c/D6CZ7IVoQ/GKUEtUUt0JwI5+GB548XrMr
	 wuiudtLpPTjIPsGa8tp+hkg50sUw6mbVxAhnv1piJT8ropXsk8UeI1qnBDlC8SiyRH
	 8CiFgLkJRENma//i7V6Rzaz+tX5UVZ/Ur2E3rYGRrXrEDCJ5n7YPfpmUbhO40AsK3n
	 JHsPVrJtnVMb4uaXa7riw+MGFCpuH+I99b7eg0GaCUJqdNtfnjNDPZpK9ozq1FClXr
	 ZFyvOzrsxdxAS05wPjnbBHvUmQ2y8Qu11LLr+nNlT6raxBMUwyDPw3Qk+8SMUoP0t3
	 r8q2ICsP2a2zA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sCKjB-00GekF-Pd;
	Wed, 29 May 2024 15:56:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 09/16] KVM: arm64: nv: Handle TLBI ALLE1{,IS} operations
Date: Wed, 29 May 2024 15:56:21 +0100
Message-Id: <20240529145628.3272630-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240529145628.3272630-1-maz@kernel.org>
References: <20240529145628.3272630-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

TLBI ALLE1* is a pretty big hammer that invalides all S1/S2 TLBs.

This translates into the unmapping of all our shadow S2 PTs, itself
resulting in the corresponding TLB invalidations.

Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22a3691ce248..d8d6380b7c66 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2757,6 +2757,29 @@ static bool kvm_supported_tlbi_s12_op(struct kvm_vcpu *vpcu, u32 instr)
 	return true;
 }
 
+static bool handle_alle1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+
+	if (!kvm_supported_tlbi_s12_op(vcpu, sys_encoding)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	write_lock(&vcpu->kvm->mmu_lock);
+
+	/*
+	 * Drop all shadow S2s, resulting in S1/S2 TLBIs for each of the
+	 * corresponding VMIDs.
+	 */
+	kvm_nested_s2_unmap(vcpu->kvm);
+
+	write_unlock(&vcpu->kvm->mmu_lock);
+
+	return true;
+}
+
 /* Only defined here as this is an internal "abstraction" */
 union tlbi_info {
 	struct {
@@ -2880,7 +2903,9 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_VALE1, handle_tlbi_el1),
 	SYS_INSN(TLBI_VAALE1, handle_tlbi_el1),
 
+	SYS_INSN(TLBI_ALLE1IS, handle_alle1is),
 	SYS_INSN(TLBI_VMALLS12E1IS, handle_vmalls12e1is),
+	SYS_INSN(TLBI_ALLE1, handle_alle1is),
 	SYS_INSN(TLBI_VMALLS12E1, handle_vmalls12e1is),
 };
 
-- 
2.39.2


