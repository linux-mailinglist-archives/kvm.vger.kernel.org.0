Return-Path: <kvm+bounces-50813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 76BFAAE982C
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 10:24:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C49581C432B2
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 08:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48762701C7;
	Thu, 26 Jun 2025 08:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GVFekQ6f"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61C52356C0;
	Thu, 26 Jun 2025 08:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750926079; cv=none; b=mnqtx0y6nBPdNupfIBACbYxSBmKNBpRiKoQDvQOdpId9aBctv1imXG+utSauoUiSb09jcoukEn7aeU1aypNZmnEtfR9lxn+MlzBUl1PT5pYKTe4NWHlwb9rBU0UEhyc+UAhyu63xAZitp/G3Tdis+PfJYAu+13LbwVSOo/FLSIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750926079; c=relaxed/simple;
	bh=mS2rnH3fTEDroz6sbYHUy5zTCOw1PaG3HCJiJL66aVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EsnRm268kqN1aGzoCz5KKJKonI7Z+wmYqhDMKXLbuv38L+9j3dGvj1FYLYcfwWSjL2a8llXpUsMStDKbnFW2s/W9WmZbTReStQ4uqszG4uYoDN0NqPoyp/3dMtvJnELacsid5xovHGsoIqRlQuevIvZT6jV5nyFbR5NyommLgSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GVFekQ6f; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F93AC4CEEB;
	Thu, 26 Jun 2025 08:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750926079;
	bh=mS2rnH3fTEDroz6sbYHUy5zTCOw1PaG3HCJiJL66aVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GVFekQ6fGGRKvBKRNsCKK583D6A4cf6LjZ/xjYdaItUFnpA582ppkz2/t01OkedVy
	 tVdFBeAQztmQVF8mPZf0gCA7u6opaErBo20kT0U7jqIq/XloOVLX7gcraZYP/0Jvfk
	 WN0kqb8tc9LmceFmCTmvKi+xA86EOlePwQHMiIXveQsMI2ZkJuZszm4leFofSj1SE7
	 FGi3Cg96HpNGuHle8as1DK2ACot4PzZ6i93DRK1YZX0038nuBhCeNaStOdtxKnBWqs
	 Cs0r4fzPkrPpzJlBKYDxC3T3Boeo+flJc85jq8h/9Ir2IuvSOj1sErud6wwjrnbPK2
	 GcyMCr/PZz8yg==
Date: Thu, 26 Jun 2025 10:21:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] x86/sev/vc: fix efi runtime instruction emulation
Message-ID: <aF0C-wVwXWxFjgud@gmail.com>
References: <20250626074236.307848-1-kraxel@redhat.com>
 <20250626074236.307848-2-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250626074236.307848-2-kraxel@redhat.com>


* Gerd Hoffmann <kraxel@redhat.com> wrote:

> In case efi_mm is active go use the userspace instruction decoder which
> supports fetching instructions from active_mm.  This is needed to make
> instruction emulation work for EFI runtime code, so it can use cpuid
> and rdmsr.
> 
> EFI runtime code uses the cpuid instruction to gather information about
> the environment it is running in, such as SEV being enabled or not, and
> choose (if needed) the SEV code path for ioport access.
> 
> EFI runtime code uses the rdmsr instruction to get the location of the
> CAA page (see SVSM spec, section 4.2 - "Post Boot").
> 
> The big picture behind this is that the kernel needs to be able to
> properly handle #VC exceptions that come from EFI runtime services.
> Since EFI runtime services have a special page table mapping for the EFI
> virtual address space, the efi_mm context must be used when decoding
> instructions during #VC handling.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  arch/x86/coco/sev/vc-handle.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
> index 0989d98da130..e498a8965939 100644
> --- a/arch/x86/coco/sev/vc-handle.c
> +++ b/arch/x86/coco/sev/vc-handle.c
> @@ -17,6 +17,7 @@
>  #include <linux/mm.h>
>  #include <linux/io.h>
>  #include <linux/psp-sev.h>
> +#include <linux/efi.h>
>  #include <uapi/linux/sev-guest.h>
>  
>  #include <asm/init.h>
> @@ -178,9 +179,14 @@ static enum es_result __vc_decode_kern_insn(struct es_em_ctxt *ctxt)
>  		return ES_OK;
>  }
>  
> +/*
> + * User instruction decoding is also required for the EFI runtime. Even though
> + * EFI runtime is running in kernel mode, it uses special EFI virtual address

s/Even though EFI runtime
 /Even though the EFI runtime

> + * mappings that require the use of efi_mm to properly address and decode.
> + */
>  static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
>  {
> -	if (user_mode(ctxt->regs))
> +	if (user_mode(ctxt->regs) || current->active_mm == &efi_mm)

Instead of open-coding that condition, we have mm_is_efi() for that.

Thanks,

	Ingo

