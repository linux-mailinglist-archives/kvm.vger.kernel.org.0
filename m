Return-Path: <kvm+bounces-62454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 472FDC44407
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:19:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 02E724EA574
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDFA330FC08;
	Sun,  9 Nov 2025 17:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CVc1eMT1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE6530EF7F;
	Sun,  9 Nov 2025 17:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708598; cv=none; b=lEroFcXUclDblZImWJcBIOB5O4Usg+EpnQtsYBGaJUds/UZSvpuyqEzBd+imAGS71L9R+wP2eytIgEmm4vDTcX2g9EbPra043YUMxI/LoalaD5dxQh8R1TrgebydryKJ8baxH/RcGNjJ0+mNhFA+f2oS3MXsACXMdI8L6NP1vCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708598; c=relaxed/simple;
	bh=0Cx21DFv+o0C6Y+UxV0ERfuwdJ4fIlnLl2DzexkfE94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJFyQ7Jv59PBjexge2WVuXgEgtX0RP9x9Yhjfl09Ew1UknqcXVp76xBKNfwrqoWX6h7Wy44AUfEZTZC0dxZIsPhuiTSTCx9E3KOGeL+FZfskHAhOBgTOZV7Bg06dXI8UoXXRxbmJauLMIPGxNEL5SRV3m3EBkfanI+fXVxHFaWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CVc1eMT1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8097FC19425;
	Sun,  9 Nov 2025 17:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708597;
	bh=0Cx21DFv+o0C6Y+UxV0ERfuwdJ4fIlnLl2DzexkfE94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVc1eMT1KGPi/Z7ZsokwNoR8uaruXjv/TL+jtaJub5ZYjCloE9+cJPMhUPi2YZMzI
	 sGJjVAZd6Qh6AHVCB5e7Tdv9cJsa125NubfgnYfdNPCW4t4Oat+rSkVf6Mm1emP/2T
	 cLEMgY0SG7+u/SIo/2rQeaxId3y2G0iOyuesLtIuuSVbz+Q/n+g6PBtt33T0maawS/
	 d0uQYWBAACdqAXybTe4N3TnIA/XybW9gLT2/KXVAoGJa2B7ORDc4wZoLqwlw8kh+pd
	 YZElFgAasJkFe91XmOhLxgyPGXvmQw+47TrWaExcjvuUaA055TBhOj7R8/Wtm4jnPH
	 ilJMtyJa9Kuaw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91n-00000003exw-2xHU;
	Sun, 09 Nov 2025 17:16:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v2 31/45] KVM: arm64: GICv3: Handle in-LR deactivation when possible
Date: Sun,  9 Nov 2025 17:16:05 +0000
Message-ID: <20251109171619.1507205-32-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109171619.1507205-1-maz@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Even when we have either an LR overflow or SPIs in flight, it is
extremely likely that the interrupt being deactivated is still in
the LRs, and that going all the way back to the the generic trap
handling code is a waste of time.

Instead, try and deactivate in place when possible, and only if
this fails, perform a full exit.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 38 ++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 8d3f4c069ea63..e950efa225478 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -792,7 +792,7 @@ static void __vgic_v3_bump_eoicount(void)
 	write_gicreg(hcr, ICH_HCR_EL2);
 }
 
-static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static int ___vgic_v3_write_dir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u32 vid = vcpu_get_reg(vcpu, rt);
 	u64 lr_val;
@@ -800,19 +800,25 @@ static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 	/* EOImode == 0, nothing to be done here */
 	if (!(vmcr & ICH_VMCR_EOIM_MASK))
-		return;
+		return 1;
 
 	/* No deactivate to be performed on an LPI */
 	if (vid >= VGIC_MIN_LPI)
-		return;
+		return 1;
 
 	lr = __vgic_v3_find_active_lr(vcpu, vid, &lr_val);
-	if (lr == -1) {
-		__vgic_v3_bump_eoicount();
-		return;
+	if (lr != -1) {
+		__vgic_v3_clear_active_lr(lr, lr_val);
+		return 1;
 	}
 
-	__vgic_v3_clear_active_lr(lr, lr_val);
+	return 0;
+}
+
+static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+{
+	if (!___vgic_v3_write_dir(vcpu, vmcr, rt))
+		__vgic_v3_bump_eoicount();
 }
 
 static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
@@ -1247,9 +1253,21 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	case SYS_ICC_DIR_EL1:
 		if (unlikely(is_read))
 			return 0;
-		/* Full exit if required to handle overflow deactivation... */
-		if (vcpu->arch.vgic_cpu.vgic_v3.vgic_hcr & ICH_HCR_EL2_TDIR)
-			return 0;
+		/*
+		 * Full exit if required to handle overflow deactivation,
+		 * unless we can emulate it in the LRs (likely the majority
+		 * of the cases).
+		 */
+		if (vcpu->arch.vgic_cpu.vgic_v3.vgic_hcr & ICH_HCR_EL2_TDIR) {
+			int ret;
+
+			ret = ___vgic_v3_write_dir(vcpu, __vgic_v3_read_vmcr(),
+						   kvm_vcpu_sys_get_rt(vcpu));
+			if (ret)
+				__kvm_skip_instr(vcpu);
+
+			return ret;
+		}
 		fn = __vgic_v3_write_dir;
 		break;
 	case SYS_ICC_RPR_EL1:
-- 
2.47.3


