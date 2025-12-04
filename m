Return-Path: <kvm+bounces-65270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 01DD3CA33C5
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 11:32:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C4149302A751
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 10:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803E42DF143;
	Thu,  4 Dec 2025 10:32:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ADDC2DC328
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 10:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764844330; cv=none; b=AV2QmtSNB7UdE4ZNt5B8OZquM9+zlGliOXojw36MxmdqEIitid1yJuZE1Kb/R6Z8hjEOMtohIlZbBBDzfRXkmojq9PHIeUxG9SX1uex2aHETeyb3CqSf/ZjFG/xexfpih07slcRX5zgQ+qTzt6mNdV82rzpwrAD8Vkhn4UyKmuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764844330; c=relaxed/simple;
	bh=QwUIPIBLm9OAA0qqJ/xUY6DKTZhxaRq/wQV3yV8DIS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YaiuyQ38Nx/Ig6tBCkQWUTJ2ExsJftlyMe5LMseGhM60ED1gmvjmqdgE67BjB7qbj9u3HQxtsyjmZbsF/6/L9ENNcpD2jQVPUSp+sTanbBlQgzc9nvSsLeoqR9Cd8MH63VRzSAj3lZlOkh96RYPPOnvk3uT0lHp02uU6J8AAE6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79FB2339;
	Thu,  4 Dec 2025 02:32:00 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4010A3F73B;
	Thu,  4 Dec 2025 02:32:06 -0800 (PST)
Date: Thu, 4 Dec 2025 10:32:00 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: Re: [PATCH v3 1/9] arm64: Repaint ID_AA64MMFR2_EL1.IDS description
Message-ID: <20251204103200.GA98666@e124191.cambridge.arm.com>
References: <20251204094806.3846619-1-maz@kernel.org>
 <20251204094806.3846619-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204094806.3846619-2-maz@kernel.org>

On Thu, Dec 04, 2025 at 09:47:58AM +0000, Marc Zyngier wrote:
> ID_AA64MMFR2_EL1.IDS, as described in the sysreg file, is pretty horrible
> as it diesctly give the ESR value. Repaint it using the usual NI/IMP
typo:   directly
> identifiers to describe the absence/presence of FEAT_IDST.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 2 +-
>  arch/arm64/tools/sysreg            | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 82da9b03692d4..107d62921b168 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -134,7 +134,7 @@ static const struct pvm_ftr_bits pvmid_aa64mmfr2[] = {
>  	MAX_FEAT(ID_AA64MMFR2_EL1, UAO, IMP),
>  	MAX_FEAT(ID_AA64MMFR2_EL1, IESB, IMP),
>  	MAX_FEAT(ID_AA64MMFR2_EL1, AT, IMP),
> -	MAX_FEAT_ENUM(ID_AA64MMFR2_EL1, IDS, 0x18),
> +	MAX_FEAT_ENUM(ID_AA64MMFR2_EL1, IDS, IMP),
>  	MAX_FEAT(ID_AA64MMFR2_EL1, TTL, IMP),
>  	MAX_FEAT(ID_AA64MMFR2_EL1, BBM, 2),
>  	MAX_FEAT(ID_AA64MMFR2_EL1, E0PD, IMP),
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 1c6cdf9d54bba..3261e8791ac03 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2257,8 +2257,8 @@ UnsignedEnum	43:40	FWB
>  	0b0001	IMP
>  EndEnum
>  Enum	39:36	IDS
> -	0b0000	0x0
> -	0b0001	0x18
> +	0b0000	NI
> +	0b0001	IMP
>  EndEnum
>  UnsignedEnum	35:32	AT
>  	0b0000	NI
> -- 
> 2.47.3
> 

