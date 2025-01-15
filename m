Return-Path: <kvm+bounces-35597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE34A12B11
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 19:41:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 441A17A1A59
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 18:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DCB21D63DA;
	Wed, 15 Jan 2025 18:41:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A50161D63D4
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 18:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736966467; cv=none; b=HVO7yD5eXd5QLzDnTbVkDCQGTw8hwyBsVytag3Iom3B1LdkV8m3xq1IQyqhOnTRqBTrTbGgntwz4mp850Dby7jf8abFewENNE06Db1lLjIsJST9J850idiWGXFVWtno3NxKTL56BBpqVXME/wE57UAKSeDJol52dOgk08kYRb2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736966467; c=relaxed/simple;
	bh=Irz6csypMe4iw0gBYK2n/Ki5RMnlJZMDUM/e5j5K6es=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fqdvB/OT+LXeNQS1rlBvf2mqrfrh/42oMniA36zzjm5bDP7r3GtubddDle/rmfIScCkHcgbc0oJCahF6snKhLjuLFotxselUSqnR+mxDooTv48xCGGt1xuHEQLi0dFjBCK8HjLIrPtqFVQPxPMlkeaqEnKC8/48l3UnL/wP6SkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 890F21F02;
	Wed, 15 Jan 2025 10:41:32 -0800 (PST)
Received: from donnerap.manchester.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A95E03F73F;
	Wed, 15 Jan 2025 10:41:02 -0800 (PST)
Date: Wed, 15 Jan 2025 18:41:00 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu
 <yuzenghui@huawei.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v2 03/17] arm64: sysreg: Add layout for ICH_MISR_EL2
Message-ID: <20250115184100.3c2450cc@donnerap.manchester.arm.com>
In-Reply-To: <20250112170845.1181891-4-maz@kernel.org>
References: <20250112170845.1181891-1-maz@kernel.org>
	<20250112170845.1181891-4-maz@kernel.org>
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

On Sun, 12 Jan 2025 17:08:31 +0000
Marc Zyngier <maz@kernel.org> wrote:

> The ICH_MISR_EL2-related macros are missing a number of status
> bits that we are about to handle. Take this opportunity to fully
> describe the layout of that register as part of the automatic
> generation infrastructure.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Compared against the ARM ARM:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Thanks,
Andre

> ---
>  arch/arm64/include/asm/sysreg.h       |  5 -----
>  arch/arm64/tools/sysreg               | 12 ++++++++++++
>  tools/arch/arm64/include/asm/sysreg.h |  5 -----
>  3 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index cf74ebcd46d95..815e9b0bdff27 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -561,7 +561,6 @@
>  
>  #define SYS_ICH_VSEIR_EL2		sys_reg(3, 4, 12, 9, 4)
>  #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
> -#define SYS_ICH_MISR_EL2		sys_reg(3, 4, 12, 11, 2)
>  #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
>  #define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
>  #define SYS_ICH_VMCR_EL2		sys_reg(3, 4, 12, 11, 7)
> @@ -991,10 +990,6 @@
>  #define TRFCR_ELx_E0TRE			BIT(0)
>  
>  /* GIC Hypervisor interface registers */
> -/* ICH_MISR_EL2 bit definitions */
> -#define ICH_MISR_EOI		(1 << 0)
> -#define ICH_MISR_U		(1 << 1)
> -
>  /* ICH_LR*_EL2 bit definitions */
>  #define ICH_LR_VIRTUAL_ID_MASK	((1ULL << 32) - 1)
>  
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index f5927d345eea3..a601231a088d7 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2974,6 +2974,18 @@ Res0	17:5
>  Field	4:0	ListRegs
>  EndSysreg
>  
> +Sysreg	ICH_MISR_EL2	3	4	12	11	2
> +Res0	63:8
> +Field	7	VGrp1D
> +Field	6	VGrp1E
> +Field	5	VGrp0D
> +Field	4	VGrp0E
> +Field	3	NP
> +Field	2	LRENP
> +Field	1	U
> +Field	0	EOI
> +EndSysreg
> +
>  Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
>  Fields	CONTEXTIDR_ELx
>  EndSysreg
> diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
> index f43e303d31d25..0169bd3137caf 100644
> --- a/tools/arch/arm64/include/asm/sysreg.h
> +++ b/tools/arch/arm64/include/asm/sysreg.h
> @@ -420,7 +420,6 @@
>  
>  #define SYS_ICH_VSEIR_EL2		sys_reg(3, 4, 12, 9, 4)
>  #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
> -#define SYS_ICH_MISR_EL2		sys_reg(3, 4, 12, 11, 2)
>  #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
>  #define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
>  #define SYS_ICH_VMCR_EL2		sys_reg(3, 4, 12, 11, 7)
> @@ -634,10 +633,6 @@
>  #define TRFCR_ELx_E0TRE			BIT(0)
>  
>  /* GIC Hypervisor interface registers */
> -/* ICH_MISR_EL2 bit definitions */
> -#define ICH_MISR_EOI		(1 << 0)
> -#define ICH_MISR_U		(1 << 1)
> -
>  /* ICH_LR*_EL2 bit definitions */
>  #define ICH_LR_VIRTUAL_ID_MASK	((1ULL << 32) - 1)
>  


