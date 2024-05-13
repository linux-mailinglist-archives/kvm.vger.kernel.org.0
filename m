Return-Path: <kvm+bounces-17326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4F0C8C4390
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 16:57:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14D5F1C230E9
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 14:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8A8B4C7E;
	Mon, 13 May 2024 14:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oKcnMdMR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204884A1C;
	Mon, 13 May 2024 14:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715612228; cv=none; b=H/ALQzSLaYynpNszhXgLuU0Cwh8ZGmPCitxLzWhNJRnTbhxWa0lbXlc5qefIu4gdpNrhLxKiPSMrGALDDhHXnfn1RjH77eiYe3BC8dTOlg5CERsOkdW6KNuYBl6WNsQsrSbtaA4Xd/AMB2ywg33ABas3TBb2omROMJHa0aIu2qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715612228; c=relaxed/simple;
	bh=5ReINp8KqWZQ+gK5PgcYTLsssnjDvkcpDG2reGNNN1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rObKZKz2i3EtJC8VYRQngRtanDTtd2uFSUPDnkLI1WYlLBBcZzM8UlXL3ZhwewsENlGn1xZqVWUKtsm5M3XDv1+H9cEq9lTHrQblwAenehvOE5tBvU7zIV/3nlaFrhXkkED7Wx2ub1mLOEw3EZjRQoFfua2uEsiOiQQe1dFazEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oKcnMdMR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B41C113CC;
	Mon, 13 May 2024 14:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715612227;
	bh=5ReINp8KqWZQ+gK5PgcYTLsssnjDvkcpDG2reGNNN1g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oKcnMdMRkHrlF/yr1iPERoaUeBtW/Nd5emIrmdJWoouqDkhZRz3RZcOuNI/RBeXyC
	 sfW0/zZY11f33xjzNosAuz85upPHO42eymUzgZqtPsqd9jhMvXL/oZsGLxR715BYh7
	 URsHFZK7X5OiPTb1sMyalep4o+scHWWpXT8luToWuNCEyj6sIKSsjwuTde5CtX52cM
	 xDzz73joFsRdf7Bi+YPhxnYMhoIk2vW3hUvLYK1zstzxbFIBdLTY0JSO4WzxdV9K6A
	 KR/t0BRFn1x0ADlQNSQjPBjHC5E22bmXdgUgZQSDOecEBTUwcbdj8sjmasAk3DVCHN
	 V61BIn86rPD/g==
Date: Mon, 13 May 2024 15:57:02 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v3 08/12] arm64: Move esr_comment() to <asm/esr.h>
Message-ID: <20240513145702.GG28749@willie-the-truck>
References: <20240510112645.3625702-1-ptosi@google.com>
 <20240510112645.3625702-9-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240510112645.3625702-9-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 10, 2024 at 12:26:37PM +0100, Pierre-Clément Tosi wrote:
> As it is already defined twice and is about to be needed for kCFI error
> detection, move esr_comment() to a header for re-use, with a clearer
> name.

esr_comment() is defined twice? I only see one macro definition, but yes,
it's open-coded in nvhe_hyp_panic_handler too.

> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/include/asm/esr.h       | 5 +++++
>  arch/arm64/kernel/debug-monitors.c | 4 +---
>  arch/arm64/kernel/traps.c          | 8 +++-----
>  arch/arm64/kvm/handle_exit.c       | 2 +-
>  4 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index 81606bf7d5ac..2bcf216be376 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -379,6 +379,11 @@
>  #ifndef __ASSEMBLY__
>  #include <asm/types.h>
>  
> +static inline unsigned long esr_brk_comment(unsigned long esr)
> +{
> +	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
> +}
> +
>  static inline bool esr_is_data_abort(unsigned long esr)
>  {
>  	const unsigned long ec = ESR_ELx_EC(esr);
> diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
> index 64f2ecbdfe5c..024a7b245056 100644
> --- a/arch/arm64/kernel/debug-monitors.c
> +++ b/arch/arm64/kernel/debug-monitors.c
> @@ -312,9 +312,7 @@ static int call_break_hook(struct pt_regs *regs, unsigned long esr)
>  	 * entirely not preemptible, and we can use rcu list safely here.
>  	 */
>  	list_for_each_entry_rcu(hook, list, node) {
> -		unsigned long comment = esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
> -
> -		if ((comment & ~hook->mask) == hook->imm)
> +		if ((esr_brk_comment(esr) & ~hook->mask) == hook->imm)
>  			fn = hook->fn;
>  	}
>  
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index 215e6d7f2df8..2652247032ae 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -1105,8 +1105,6 @@ static struct break_hook ubsan_break_hook = {
>  };
>  #endif
>  
> -#define esr_comment(esr) ((esr) & ESR_ELx_BRK64_ISS_COMMENT_MASK)
> -
>  /*
>   * Initial handler for AArch64 BRK exceptions
>   * This handler only used until debug_traps_init().
> @@ -1115,15 +1113,15 @@ int __init early_brk64(unsigned long addr, unsigned long esr,
>  		struct pt_regs *regs)
>  {
>  #ifdef CONFIG_CFI_CLANG
> -	if ((esr_comment(esr) & ~CFI_BRK_IMM_MASK) == CFI_BRK_IMM_BASE)
> +	if ((esr_brk_comment(esr) & ~CFI_BRK_IMM_MASK) == CFI_BRK_IMM_BASE)
>  		return cfi_handler(regs, esr) != DBG_HOOK_HANDLED;
>  #endif
>  #ifdef CONFIG_KASAN_SW_TAGS
> -	if ((esr_comment(esr) & ~KASAN_BRK_MASK) == KASAN_BRK_IMM)
> +	if ((esr_brk_comment(esr) & ~KASAN_BRK_MASK) == KASAN_BRK_IMM)
>  		return kasan_handler(regs, esr) != DBG_HOOK_HANDLED;
>  #endif
>  #ifdef CONFIG_UBSAN_TRAP
> -	if ((esr_comment(esr) & ~UBSAN_BRK_MASK) == UBSAN_BRK_IMM)
> +	if ((esr_brk_comment(esr) & ~UBSAN_BRK_MASK) == UBSAN_BRK_IMM)
>  		return ubsan_handler(regs, esr) != DBG_HOOK_HANDLED;
>  #endif
>  	return bug_handler(regs, esr) != DBG_HOOK_HANDLED;
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 617ae6dea5d5..0bcafb3179d6 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -395,7 +395,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
>  	if (mode != PSR_MODE_EL2t && mode != PSR_MODE_EL2h) {
>  		kvm_err("Invalid host exception to nVHE hyp!\n");
>  	} else if (ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
> -		   (esr & ESR_ELx_BRK64_ISS_COMMENT_MASK) == BUG_BRK_IMM) {
> +		   esr_brk_comment(esr) == BUG_BRK_IMM) {
>  		const char *file = NULL;
>  		unsigned int line = 0;

With the commit message tweaked:

Acked-by: Will Deacon <will@kernel.org>

Will

