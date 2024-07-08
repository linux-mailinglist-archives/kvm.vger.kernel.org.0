Return-Path: <kvm+bounces-21101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2A6192A5FB
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 17:45:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F4231C20B14
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 15:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55F84145B12;
	Mon,  8 Jul 2024 15:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sy+dVDPZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F074143C45;
	Mon,  8 Jul 2024 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720453495; cv=none; b=A0xjE23VXgCzpFTh0+ghW6sqf1C1MuUiauxtZmXRt04dDz3AgWl/8GlnVzZ2as3QSu+533wIXCBGpVvA+MV4ZzgBjPTlukb6MMYVEUW3AxKSo3T1VhMUVF8305XUyxsszWjsXDNH0F5cj8q0Ym2Yxe0NkM52Y+BFeHIiSqVfw0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720453495; c=relaxed/simple;
	bh=D8Xbgc7QO/XpodPOM7J+nYMvERnS5AGZFqZ3iGgsOI8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DOdfPNyV6R7/rtMLSOcUisBxhQObnhPcBDz/+lX59cu21fcOJd+D9N+LoSdBndOJV0aWo2JCgv71Hv48THppK4LuWiHeMPbHxNEw/jRpkUwOu8aTyNM5Vohj1OnvpIER+qDBUgACnjG5e3qH+yvNv/aMjA41YIBm2fETGQWuwOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sy+dVDPZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4CBC4AF0E;
	Mon,  8 Jul 2024 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720453495;
	bh=D8Xbgc7QO/XpodPOM7J+nYMvERnS5AGZFqZ3iGgsOI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sy+dVDPZuObk3y6KRA2ju03xHq6CjPmdWBMsw4WfVH1PsdpAahgW+4AwT0gcYV5Pp
	 +DlXI6AV+vKec+cdXoNuDOT5giGR/Nz0XKYStFIz+IDX5HkI35I3AHcbr/RM4TzH8B
	 5InaSad+TtFVJD79Uj32s3doF597kJ3e0xJ/QK7eODnUYnYghnzc+XAmZ4Y90bRs9J
	 LMNvNsj8amZtv3Ib/dkREKfXWyog+lsO/7woOWcEdQbnRu9L9rh4qJhT/JFr8KT1CG
	 OPaIBuC4P38q3OVB3XUxbcF+975CpBu2zGwH0V4HM2PxDaH+Mcmd+0oK/JJ6F5qo0W
	 CpwHKLV+NYx0A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sQqXt-00Ae1P-1A;
	Mon, 08 Jul 2024 16:44:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 3/7] KVM: arm64: Add save/restore support for FPMR
Date: Mon,  8 Jul 2024 16:44:34 +0100
Message-Id: <20240708154438.1218186-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240708154438.1218186-1-maz@kernel.org>
References: <20240708154438.1218186-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Just like the rest of the FP/SIMD state, FPMR needs to be context
switched.

The only interesting thing here is that we need to treat the pKVM
part a bit differently, as the host FP state is never written back
to the vcpu thread, but instead stored locally and eagerly restored.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h  | 10 ++++++++++
 arch/arm64/kvm/fpsimd.c            |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  4 ++++
 arch/arm64/kvm/hyp/nvhe/switch.c   | 10 ++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c    |  4 ++++
 5 files changed, 29 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a14c18e8b173a..764d23082eb91 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -599,6 +599,16 @@ struct kvm_host_data {
 		struct cpu_sve_state *sve_state;
 	};
 
+	union {
+		/* HYP VA pointer to the host storage for FPMR */
+		u64	*fpmr_ptr;
+		/*
+		 * Used by pKVM only, as it needs to provide storage
+		 * for the host
+		 */
+		u64	fpmr;
+	};
+
 	/* Ownership of the FP regs */
 	enum {
 		FP_STATE_FREE,
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 4cb8ad5d69a80..ea5484ce1f3ba 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -63,6 +63,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	 */
 	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
 	*host_data_ptr(fpsimd_state) = kern_hyp_va(&current->thread.uw.fpsimd_state);
+	*host_data_ptr(fpmr_ptr) = kern_hyp_va(&current->thread.uw.fpmr);
 
 	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f43d845f3c4ec..6b14a2c13e287 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -78,6 +78,10 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	else
 		__fpsimd_restore_state(*host_data_ptr(fpsimd_state));
 
+	if (system_supports_fpmr() &&
+	    kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64PFR2_EL1, FPMR, IMP))
+		write_sysreg_s(*host_data_ptr(fpmr), SYS_FPMR);
+
 	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6af179c6356d6..47d24ecd68fec 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -198,6 +198,16 @@ static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 	} else {
 		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
 	}
+
+	if (system_supports_fpmr() &&
+	    kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64PFR2_EL1, FPMR, IMP)) {
+		u64 fpmr = read_sysreg_s(SYS_FPMR);
+
+		if (unlikely(is_protected_kvm_enabled()))
+			*host_data_ptr(fpmr) = fpmr;
+		else
+			**host_data_ptr(fpmr_ptr) = fpmr;
+	}
 }
 
 static const exit_handler_fn hyp_exit_handlers[] = {
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 77010b76c150f..a307c1d5ac874 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -312,6 +312,10 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 {
 	__fpsimd_save_state(*host_data_ptr(fpsimd_state));
+
+	if (system_supports_fpmr() &&
+	    kvm_has_feat(vcpu->kvm, ID_AA64PFR2_EL1, FPMR, IMP))
+		**host_data_ptr(fpmr_ptr) = read_sysreg_s(SYS_FPMR);
 }
 
 static bool kvm_hyp_handle_tlbi_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
-- 
2.39.2


