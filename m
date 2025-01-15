Return-Path: <kvm+bounces-35596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E815A12B0C
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 19:40:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04C1E3A5ACB
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 18:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00F7D1D61A4;
	Wed, 15 Jan 2025 18:40:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3301C5F0E
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 18:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736966414; cv=none; b=T5Bq/ALl0dCd+iBHwzaVvXp/pQpaBC1AlqD9WknCd6gzq6R22M4yP+EYHaX6DNWCOOuc01M+xS8itvKyLxW6gNxV4euYL5lo16BAqSj6lL2vi8xNOP9+Fa+SrSUAyn2W8DYP382ZY4OsqLBfzXy+Yoh2mz2+itpauyxbDWymkto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736966414; c=relaxed/simple;
	bh=7JBJjwqTMb3HeF5TQo792I9cLwipWfYmG+VxILauegw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QjQ832Ecyf2axeeglhkJFGag8dbWQ5KcDAr2D02P4fYx/x0Itb/3G9iM3MLE/4SQ9MNdyulrfAUrborPMOvHI8hnMBsRS/OwhBM7Pb09ayEeY0Xqiy8EFNo9r4VbxFuG901dlBha/xq1EuATo1HdbuxLzsKYdn+7mEtfYyYgmBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5297512FC;
	Wed, 15 Jan 2025 10:40:40 -0800 (PST)
Received: from donnerap.manchester.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7DDA23F73F;
	Wed, 15 Jan 2025 10:40:10 -0800 (PST)
Date: Wed, 15 Jan 2025 18:40:07 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu
 <yuzenghui@huawei.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v2 02/17] arm64: sysreg: Add layout for ICH_VTR_EL2
Message-ID: <20250115184007.356a1ae4@donnerap.manchester.arm.com>
In-Reply-To: <20250112170845.1181891-3-maz@kernel.org>
References: <20250112170845.1181891-1-maz@kernel.org>
	<20250112170845.1181891-3-maz@kernel.org>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 12 Jan 2025 17:08:30 +0000
Marc Zyngier <maz@kernel.org> wrote:

> The ICH_VTR_EL2-related macros are missing a number of config
> bits that we are about to handle. Take this opportunity to fully
> describe the layout of that register as part of the automatic
> generation infrastructure.
> 
> This results in a bit of churn to repaint constants that are now
> generated with a different format.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Compared the new definitions against the ARM ARM and can confirm that the
rest indeed just got repainted.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  arch/arm64/include/asm/sysreg.h       | 13 -------------
>  arch/arm64/kvm/vgic-sys-reg-v3.c      |  8 ++++----
>  arch/arm64/kvm/vgic/vgic-v3.c         | 16 +++++++---------
>  arch/arm64/tools/sysreg               | 14 ++++++++++++++
>  tools/arch/arm64/include/asm/sysreg.h | 13 -------------
>  5 files changed, 25 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 3e84ef8f5b311..cf74ebcd46d95 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -561,7 +561,6 @@
>  
>  #define SYS_ICH_VSEIR_EL2		sys_reg(3, 4, 12, 9, 4)
>  #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
> -#define SYS_ICH_VTR_EL2			sys_reg(3, 4, 12, 11, 1)
>  #define SYS_ICH_MISR_EL2		sys_reg(3, 4, 12, 11, 2)
>  #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
>  #define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
> @@ -1030,18 +1029,6 @@
>  #define ICH_VMCR_ENG1_SHIFT	1
>  #define ICH_VMCR_ENG1_MASK	(1 << ICH_VMCR_ENG1_SHIFT)
>  
> -/* ICH_VTR_EL2 bit definitions */
> -#define ICH_VTR_PRI_BITS_SHIFT	29
> -#define ICH_VTR_PRI_BITS_MASK	(7 << ICH_VTR_PRI_BITS_SHIFT)
> -#define ICH_VTR_ID_BITS_SHIFT	23
> -#define ICH_VTR_ID_BITS_MASK	(7 << ICH_VTR_ID_BITS_SHIFT)
> -#define ICH_VTR_SEIS_SHIFT	22
> -#define ICH_VTR_SEIS_MASK	(1 << ICH_VTR_SEIS_SHIFT)
> -#define ICH_VTR_A3V_SHIFT	21
> -#define ICH_VTR_A3V_MASK	(1 << ICH_VTR_A3V_SHIFT)
> -#define ICH_VTR_TDS_SHIFT	19
> -#define ICH_VTR_TDS_MASK	(1 << ICH_VTR_TDS_SHIFT)
> -
>  /*
>   * Permission Indirection Extension (PIE) permission encodings.
>   * Encodings with the _O suffix, have overlays applied (Permission Overlay Extension).
> diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
> index 9e7c486b48c2e..5eacb4b3250a1 100644
> --- a/arch/arm64/kvm/vgic-sys-reg-v3.c
> +++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
> @@ -35,12 +35,12 @@ static int set_gic_ctlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
>  
>  	vgic_v3_cpu->num_id_bits = host_id_bits;
>  
> -	host_seis = FIELD_GET(ICH_VTR_SEIS_MASK, kvm_vgic_global_state.ich_vtr_el2);
> +	host_seis = FIELD_GET(ICH_VTR_EL2_SEIS, kvm_vgic_global_state.ich_vtr_el2);
>  	seis = FIELD_GET(ICC_CTLR_EL1_SEIS_MASK, val);
>  	if (host_seis != seis)
>  		return -EINVAL;
>  
> -	host_a3v = FIELD_GET(ICH_VTR_A3V_MASK, kvm_vgic_global_state.ich_vtr_el2);
> +	host_a3v = FIELD_GET(ICH_VTR_EL2_A3V, kvm_vgic_global_state.ich_vtr_el2);
>  	a3v = FIELD_GET(ICC_CTLR_EL1_A3V_MASK, val);
>  	if (host_a3v != a3v)
>  		return -EINVAL;
> @@ -68,10 +68,10 @@ static int get_gic_ctlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
>  	val |= FIELD_PREP(ICC_CTLR_EL1_PRI_BITS_MASK, vgic_v3_cpu->num_pri_bits - 1);
>  	val |= FIELD_PREP(ICC_CTLR_EL1_ID_BITS_MASK, vgic_v3_cpu->num_id_bits);
>  	val |= FIELD_PREP(ICC_CTLR_EL1_SEIS_MASK,
> -			  FIELD_GET(ICH_VTR_SEIS_MASK,
> +			  FIELD_GET(ICH_VTR_EL2_SEIS,
>  				    kvm_vgic_global_state.ich_vtr_el2));
>  	val |= FIELD_PREP(ICC_CTLR_EL1_A3V_MASK,
> -			  FIELD_GET(ICH_VTR_A3V_MASK, kvm_vgic_global_state.ich_vtr_el2));
> +			  FIELD_GET(ICH_VTR_EL2_A3V, kvm_vgic_global_state.ich_vtr_el2));
>  	/*
>  	 * The VMCR.CTLR value is in ICC_CTLR_EL1 layout.
>  	 * Extract it directly using ICC_CTLR_EL1 reg definitions.
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 6c21be12959d6..0bdecbbe74898 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -283,12 +283,10 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
>  		vgic_v3->vgic_sre = 0;
>  	}
>  
> -	vcpu->arch.vgic_cpu.num_id_bits = (kvm_vgic_global_state.ich_vtr_el2 &
> -					   ICH_VTR_ID_BITS_MASK) >>
> -					   ICH_VTR_ID_BITS_SHIFT;
> -	vcpu->arch.vgic_cpu.num_pri_bits = ((kvm_vgic_global_state.ich_vtr_el2 &
> -					    ICH_VTR_PRI_BITS_MASK) >>
> -					    ICH_VTR_PRI_BITS_SHIFT) + 1;
> +	vcpu->arch.vgic_cpu.num_id_bits = FIELD_GET(ICH_VTR_EL2_IDbits,
> +						    kvm_vgic_global_state.ich_vtr_el2);
> +	vcpu->arch.vgic_cpu.num_pri_bits = FIELD_GET(ICH_VTR_EL2_PRIbits,
> +						     kvm_vgic_global_state.ich_vtr_el2) + 1;
>  
>  	/* Get the show on the road... */
>  	vgic_v3->vgic_hcr = ICH_HCR_EL2_En;
> @@ -632,7 +630,7 @@ static const struct midr_range broken_seis[] = {
>  
>  static bool vgic_v3_broken_seis(void)
>  {
> -	return ((kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_SEIS_MASK) &&
> +	return ((kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_EL2_SEIS) &&
>  		is_midr_in_range_list(read_cpuid_id(), broken_seis));
>  }
>  
> @@ -706,10 +704,10 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  	if (vgic_v3_broken_seis()) {
>  		kvm_info("GICv3 with broken locally generated SEI\n");
>  
> -		kvm_vgic_global_state.ich_vtr_el2 &= ~ICH_VTR_SEIS_MASK;
> +		kvm_vgic_global_state.ich_vtr_el2 &= ~ICH_VTR_EL2_SEIS;
>  		group0_trap = true;
>  		group1_trap = true;
> -		if (ich_vtr_el2 & ICH_VTR_TDS_MASK)
> +		if (ich_vtr_el2 & ICH_VTR_EL2_TDS)
>  			dir_trap = true;
>  		else
>  			common_trap = true;
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 9938926421b5c..f5927d345eea3 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2960,6 +2960,20 @@ Field	1	UIE
>  Field	0	En
>  EndSysreg
>  
> +Sysreg	ICH_VTR_EL2	3	4	12	11	1
> +Res0	63:32
> +Field	31:29	PRIbits
> +Field	28:26	PREbits
> +Field	25:23	IDbits
> +Field	22	SEIS
> +Field	21	A3V
> +Field	20	nV4
> +Field	19	TDS
> +Field	18	DVIM
> +Res0	17:5
> +Field	4:0	ListRegs
> +EndSysreg
> +
>  Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
>  Fields	CONTEXTIDR_ELx
>  EndSysreg
> diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
> index d314ccab7560a..f43e303d31d25 100644
> --- a/tools/arch/arm64/include/asm/sysreg.h
> +++ b/tools/arch/arm64/include/asm/sysreg.h
> @@ -420,7 +420,6 @@
>  
>  #define SYS_ICH_VSEIR_EL2		sys_reg(3, 4, 12, 9, 4)
>  #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
> -#define SYS_ICH_VTR_EL2			sys_reg(3, 4, 12, 11, 1)
>  #define SYS_ICH_MISR_EL2		sys_reg(3, 4, 12, 11, 2)
>  #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
>  #define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
> @@ -673,18 +672,6 @@
>  #define ICH_VMCR_ENG1_SHIFT	1
>  #define ICH_VMCR_ENG1_MASK	(1 << ICH_VMCR_ENG1_SHIFT)
>  
> -/* ICH_VTR_EL2 bit definitions */
> -#define ICH_VTR_PRI_BITS_SHIFT	29
> -#define ICH_VTR_PRI_BITS_MASK	(7 << ICH_VTR_PRI_BITS_SHIFT)
> -#define ICH_VTR_ID_BITS_SHIFT	23
> -#define ICH_VTR_ID_BITS_MASK	(7 << ICH_VTR_ID_BITS_SHIFT)
> -#define ICH_VTR_SEIS_SHIFT	22
> -#define ICH_VTR_SEIS_MASK	(1 << ICH_VTR_SEIS_SHIFT)
> -#define ICH_VTR_A3V_SHIFT	21
> -#define ICH_VTR_A3V_MASK	(1 << ICH_VTR_A3V_SHIFT)
> -#define ICH_VTR_TDS_SHIFT	19
> -#define ICH_VTR_TDS_MASK	(1 << ICH_VTR_TDS_SHIFT)
> -
>  /*
>   * Permission Indirection Extension (PIE) permission encodings.
>   * Encodings with the _O suffix, have overlays applied (Permission Overlay Extension).


