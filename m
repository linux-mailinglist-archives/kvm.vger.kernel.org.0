Return-Path: <kvm+bounces-65297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 68D95CA45F2
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 16:58:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 158E03015E25
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 15:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D31672D877F;
	Thu,  4 Dec 2025 15:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tTh5TxZk"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E6A26A0DD
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 15:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764863897; cv=none; b=CywhLwfVA9BLymPChtcBiywcRxrDkg2qZRWsxH0gbVAMTH80PkQF1rjGWnGQle/5SI2vl75EpSpY3M8QUvFM2lI2CydoYVSbbU5lJk9rVIUFQxTxFfp3RiAJuy2EyYVh9QGE2Lh2SInBgefH3zATlxuVZNnKl0stn0oxwNHzX/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764863897; c=relaxed/simple;
	bh=g/PEs9/vLCLpnZ9RgIfuakc6CgX32WkG66Lj++0qcnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aYSmCLLpcJy1Z+E/ay282uNSlaQ2T6YEM4Vyvt4fjNjUAc5MCFdTJ7JiqxCXhsNSVWphRyTUn0UbUTUEIddlsNNdZgi/P5/k8lYGE0icMr8wUnWnhew/uFUC4HZRBOK0VfnOVS2dzhK9XcwLHvS7YOEUx0nF2wdAg+d982x0Qcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tTh5TxZk; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 4 Dec 2025 09:58:06 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764863893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gdXUEEKBErHWyGlIxYPBcVm/0F2nPacKqrkL/H3iJa4=;
	b=tTh5TxZkWo58gbXm91Q1nAajo503l13+IkwkqLHKeECUq1b9Z9CSKYfjrHNyw8Pmp3lki4
	P0IwfZ7DJzReTpK/TtVCYL62xgtPrvHjUQ7iQTLnkrmwaGww7E1MMdOUojgOmBzoIreGNF
	CcDH68i8cEBeuWsIB7p5s6DCNXrS/q8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	maz@kernel.org, kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v4 01/11] arm64: set SCTLR_EL1 to a known
 value for secondary cores
Message-ID: <20251204-9af4476a5331949ba55baee8@orel>
References: <20251204142338.132483-1-joey.gouly@arm.com>
 <20251204142338.132483-2-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204142338.132483-2-joey.gouly@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 04, 2025 at 02:23:28PM +0000, Joey Gouly wrote:
> This ensures that primary and secondary cores will have the same values for
> SCTLR_EL1.

This almost deserves

Fixes: 10b65ce77ae7 ("arm64: Configure SCTLR_EL1 at boot")

> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>  arm/cstart64.S | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 014c9c7b..dcdd1516 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -185,6 +185,11 @@ get_mmu_off:
>  
>  .globl secondary_entry
>  secondary_entry:
> +	/* set SCTLR_EL1 to a known value */
> +	ldr	x0, =INIT_SCTLR_EL1_MMU_OFF
> +	msr	sctlr_el1, x0
> +	isb

It's indeed good practice to always follow msr with isb. In the past we've
been lazy and allowed subsequent msr writes before issuing the isb when we
knew it'd be issued before it's necessary, e.g. the cpacr_el1 write which
piggybacks on the isb in exceptions_init. But, since that's fragile, I
like the isb here and would even like to see the isb added to cpacr_el1,
and anywhere else we're currently neglecting it, done with a separate
patch.

> +
>  	/* enable FP/ASIMD and SVE */
>  	mov	x0, #(3 << 20)
>  	orr	x0, x0, #(3 << 16)
> -- 
> 2.25.1
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew


