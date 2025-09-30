Return-Path: <kvm+bounces-59050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AEB0BBAACF9
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 02:41:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62C933C3A50
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 00:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25EFB15CD7E;
	Tue, 30 Sep 2025 00:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vQstJueR"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9207B15C158
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 00:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759192881; cv=none; b=OSHv/dHU7t/9OGFkV5o4Po23C9qeD6uvH+0ojwqYdDq+Dk4UMYaYkXHTZfs6QLXMHZ18MusEuIcjWnCpHZfXPr4f90IZ07PcaJ0U+BYltfWMLUAQawtQpKKU6VXnLs7f05gM1fo+5hJ20mc5osJgcFc9VcqBD4rh4X0eT0MoUew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759192881; c=relaxed/simple;
	bh=xNGfxvXwebFTFuKGAKsECpF1yxmK6Bzc5LgyjKt0Qjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HBjN4Z3+MTnNAElLTOunakmCdTnXdJZ4RVnnoRGRwjaUYnXDtTzuqdG93qctOiKdsOEF9X3akqkE2hTxve+QfyTbb/kFYcnbI5X3Q5JfBONgd5mi3cooeUdPCrSxsSpLgE0heetu3GwTsfMeRLbgiLj9ar5LMmkmwcZxaY5vzRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vQstJueR; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 29 Sep 2025 17:41:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759192867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=al7NVeWVCt6wvSuuBxYz51Qa667pYwu4Fk/SDCBU8o0=;
	b=vQstJueROGg1w9KYIsYzevZvj3jdAImXxYvZHg6r0xf7aDZpDUjKTklTa23GulRsOgMbzp
	4GJHGn7COhl1od6DtkQORkHPigpwCeXXC1lVpRpGNjgvHP+/0Aqm5ix8LMKrsGsxR+GiNH
	6XeSzLIpbzFIxKg4si7NhCs8RxIgtkg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 05/13] KVM: arm64: Add timer UAPI workaround to sysreg
 infrastructure
Message-ID: <aNsnHUTaHgrql07j@linux.dev>
References: <20250929160458.3351788-1-maz@kernel.org>
 <20250929160458.3351788-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929160458.3351788-6-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 29, 2025 at 05:04:49PM +0100, Marc Zyngier wrote:
> Amongst the numerous bugs that plague the KVM/arm64 UAPI, one of
> the most annoying thing is that the userspace view of the virtual
> timer has its CVAL and CNT encodings swapped.
> 
> In order to reduce the amount of code that has to know about this,
> start by adding handling for this bug in the sys_reg code.
> 
> Nothing is making use of it yet, as the code responsible for userspace
> interaction is catching the accesses early.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 33 ++++++++++++++++++++++++++++++---
>  arch/arm64/kvm/sys_regs.h |  6 ++++++
>  2 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9f2f4e0b042e8..8e6f50f54b4bf 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5231,15 +5231,28 @@ static int demux_c15_set(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
>  	}
>  }
>  
> +static u64 kvm_one_reg_to_id(const struct kvm_one_reg *reg)
> +{
> +	switch(reg->id) {
> +	case KVM_REG_ARM_TIMER_CVAL:
> +		return TO_ARM64_SYS_REG(CNTV_CVAL_EL0);
> +	case KVM_REG_ARM_TIMER_CNT:
> +		return TO_ARM64_SYS_REG(CNTVCT_EL0);
> +	default:
> +		return reg->id;
> +	}
> +}
> +

Seems like a good spot to name n' blame the commit that introduced this
bug as a comment.

Thanks,
Oliver

