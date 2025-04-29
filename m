Return-Path: <kvm+bounces-44776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D500FAA0D92
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:38:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7CEA5A6AE5
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:37:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EF472C3768;
	Tue, 29 Apr 2025 13:38:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C8408BEE
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 13:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745933890; cv=none; b=EDUIwx0dhnUs21PUgHd6dLmCOTfJ6Vpvzrye9kslejeA8xVeCzl2jOpY3ZatuE6SPpXyg4oFeAdIsUTajLpfaUCUZeGIAvA+CyxNIBj67oSavyuKkTdfQm+dTdH1dzkXwBktmqMO9xnb4i7huYfmodARzRDY13DiRug94quVL8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745933890; c=relaxed/simple;
	bh=wB70FRP/aSmlCkRecgc26yX2ofUavoiKG/fAqHKjKFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=svtaMXrFCJwERF5ad95oIaG0+XP2uhzuMjb7Q8IgCYRXjQjIfq80rl5z5LLYa9V184He01PSYoVqtYsPU/mHfzZJPbjAvynv5x8B99WpKBe1o8HqaIHF90K6EGePeelOHHj+T3bkKrWSY/WuklpH7rRMSrppywN+Pomy1Z41/Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD6D81515;
	Tue, 29 Apr 2025 06:38:01 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 916F93F673;
	Tue, 29 Apr 2025 06:38:06 -0700 (PDT)
Date: Tue, 29 Apr 2025 14:38:03 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 02/42] arm64: sysreg: Update ID_AA64MMFR4_EL1
 description
Message-ID: <20250429133803.GB1859293@e124191.cambridge.arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426122836.3341523-3-maz@kernel.org>

On Sat, Apr 26, 2025 at 01:27:56PM +0100, Marc Zyngier wrote:
> Resync the ID_AA64MMFR4_EL1 with the architectue description.
> 
> This results in:
> 
> - the new PoPS field
> - the new NV2P1 value for the NV_frac field
> - the new RMEGDI field
> - the new SRMASK field
> 
> These fields have been generated from the reference JSON file.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/tools/sysreg | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index e5da8848b66b5..fce8328c7c00b 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -1946,12 +1946,21 @@ EndEnum
>  EndSysreg
>  
>  Sysreg	ID_AA64MMFR4_EL1	3	0	0	7	4
> -Res0	63:40
> +Res0	63:48
> +UnsignedEnum	47:44	SRMASK
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
> +Res0	43:40
>  UnsignedEnum	39:36	E3DSE
>  	0b0000	NI
>  	0b0001	IMP
>  EndEnum
> -Res0	35:28
> +Res0	35:32
> +UnsignedEnum	31:28	RMEGDI
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
>  SignedEnum	27:24	E2H0
>  	0b0000	IMP
>  	0b1110	NI_NV1
> @@ -1960,6 +1969,7 @@ EndEnum
>  UnsignedEnum	23:20	NV_frac
>  	0b0000	NV_NV2
>  	0b0001	NV2_ONLY
> +	0b0010	NV2P1
>  EndEnum
>  UnsignedEnum	19:16	FGWTE3
>  	0b0000	NI
> @@ -1979,7 +1989,10 @@ SignedEnum	7:4	EIESB
>  	0b0010	ToELx
>  	0b1111	ANY
>  EndEnum
> -Res0	3:0
> +UnsignedEnum	3:0	PoPS
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
>  EndSysreg
>  
>  Sysreg	SCTLR_EL1	3	0	1	0	0

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

