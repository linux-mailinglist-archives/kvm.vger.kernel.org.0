Return-Path: <kvm+bounces-64447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D2FFC82EC1
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 01:21:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 26EEE4E1671
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 00:21:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 574BC1DF985;
	Tue, 25 Nov 2025 00:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I5mUCxnV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF031531C1;
	Tue, 25 Nov 2025 00:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764030098; cv=none; b=JJ0k2+L5HZfgE9grOhHQEZdSrYnVEaEAMOAdIoDIja12KbNqI/ml04micHqGPjZ6LUqVbuGtGos0j4XYUmGnmLUbrAFYfiO7IEs/tn5hx5+cNI8lEyI5aB+o5pcrk0f+VD4XdOX2saY//LMKlrKht0a8ZeWL9JN1I6CspxVPbqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764030098; c=relaxed/simple;
	bh=MjnAVAwG76gE4xW9KwwwUAFBvkWks0BkveYrnhgIxY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TcbqqtcZMrXHKGyxylAgHmM+91CZZhl591HUmDC0g1BcNxMZLyOC/6T0skKgyWvMvTngIcjd6LW93y4QDsJbdgzaT8cmOGTr6ZtRGlK5Fqv/ovJxoWptjgEXsHuX35ZzLhzmeAuRGjk8Bp+wdwKRpOAWkcLhmbQHIJQL6s7w0YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I5mUCxnV; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764030096; x=1795566096;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MjnAVAwG76gE4xW9KwwwUAFBvkWks0BkveYrnhgIxY8=;
  b=I5mUCxnVJ07HCbwLRf9awDlCs9bmmGYpkHxGmSINqHAvBg0YPmRwmKGI
   g2H+u29Mtxy/Lx2gOU0Xz6+pB+MVIC9TNMBvb4V9kjFiKpuEakB00P6aL
   CavLqcZK9okQS6wMBm9bNdnjbziX3AOFCy0fTVdfJT7qwVFVNwVzIVEhN
   e4rLnO6JmIdXMbu34Gmg4IwR26AecqlJbqnjOUDdvKAKH0dCGA9b/Exep
   MhnFfHPIMBKuLJiII2aWzzz4bYV5+jywyPzooixXmRfTUUBmLVWLF+Bwi
   YaBEQ9m7k625q8xjdElh2PRrE811YllG4GJooGw5TgYSDs6cCvoiIo++y
   Q==;
X-CSE-ConnectionGUID: jrxU4LQ6Ql2iDK04HbyQQw==
X-CSE-MsgGUID: GRUlJI7cQa29I2tq5kInKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76367165"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="76367165"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 16:21:35 -0800
X-CSE-ConnectionGUID: w3BcazH6RY68qjtmGhuuvQ==
X-CSE-MsgGUID: qs5c834QQl2ri8ds9abLZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="223154631"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 16:21:36 -0800
Date: Mon, 24 Nov 2025 16:21:30 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v4 02/11] x86/bhi: Move the BHB sequence to a macro for
 reuse
Message-ID: <20251125002130.2dfsa7buv4aps5js@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-2-1adad4e69ddc@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119-vmscape-bhb-v4-2-1adad4e69ddc@linux.intel.com>

On Wed, Nov 19, 2025 at 10:18:04PM -0800, Pawan Gupta wrote:
> In preparation to make clear_bhb_loop() work for CPUs with larger BHB, move
> the sequence to a macro. This will allow setting the depth of BHB-clearing
> easily via arguments.
> 
> No functional change intended.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
>  arch/x86/entry/entry_64.S | 37 +++++++++++++++++++++++--------------
>  1 file changed, 23 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 886f86790b4467347031bc27d3d761d5cc286da1..a62dbc89c5e75b955ebf6d84f20d157d4bce0253 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -1499,11 +1499,6 @@ SYM_CODE_END(rewind_stack_and_make_dead)
>   * from the branch history tracker in the Branch Predictor, therefore removing
>   * user influence on subsequent BTB lookups.
>   *
> - * It should be used on parts prior to Alder Lake. Newer parts should use the
> - * BHI_DIS_S hardware control instead. If a pre-Alder Lake part is being
> - * virtualized on newer hardware the VMM should protect against BHI attacks by
> - * setting BHI_DIS_S for the guests.
> - *
>   * CALLs/RETs are necessary to prevent Loop Stream Detector(LSD) from engaging
>   * and not clearing the branch history. The call tree looks like:
>   *
> @@ -1532,10 +1527,7 @@ SYM_CODE_END(rewind_stack_and_make_dead)
>   * Note, callers should use a speculation barrier like LFENCE immediately after
>   * a call to this function to ensure BHB is cleared before indirect branches.
>   */
> -SYM_FUNC_START(clear_bhb_loop)
> -	ANNOTATE_NOENDBR
> -	push	%rbp
> -	mov	%rsp, %rbp
> +.macro	CLEAR_BHB_LOOP_SEQ
>  	movl	$5, %ecx
>  	ANNOTATE_INTRA_FUNCTION_CALL
>  	call	1f
> @@ -1545,15 +1537,16 @@ SYM_FUNC_START(clear_bhb_loop)
>  	 * Shift instructions so that the RET is in the upper half of the
>  	 * cacheline and don't take the slowpath to its_return_thunk.
>  	 */
> -	.skip 32 - (.Lret1 - 1f), 0xcc
> +	.skip 32 - (.Lret1_\@ - 1f), 0xcc
>  	ANNOTATE_INTRA_FUNCTION_CALL
>  1:	call	2f
> -.Lret1:	RET
> +.Lret1_\@:
> +	RET
>  	.align 64, 0xcc
>  	/*
> -	 * As above shift instructions for RET at .Lret2 as well.
> +	 * As above shift instructions for RET at .Lret2_\@ as well.
>  	 *
> -	 * This should be ideally be: .skip 32 - (.Lret2 - 2f), 0xcc
> +	 * This should ideally be: .skip 32 - (.Lret2_\@ - 2f), 0xcc
>  	 * but some Clang versions (e.g. 18) don't like this.
>  	 */
>  	.skip 32 - 18, 0xcc
> @@ -1564,8 +1557,24 @@ SYM_FUNC_START(clear_bhb_loop)
>  	jnz	3b
>  	sub	$1, %ecx
>  	jnz	1b
> -.Lret2:	RET
> +.Lret2_\@:
> +	RET
>  5:
> +.endm
> +
> +/*
> + * This should be used on parts prior to Alder Lake. Newer parts should use the
> + * BHI_DIS_S hardware control instead. If a pre-Alder Lake part is being
> + * virtualized on newer hardware the VMM should protect against BHI attacks by
> + * setting BHI_DIS_S for the guests.
> + */
> +SYM_FUNC_START(clear_bhb_loop)
> +	ANNOTATE_NOENDBR
> +	push	%rbp
> +	mov	%rsp, %rbp
> +
> +	CLEAR_BHB_LOOP_SEQ
> +
>  	pop	%rbp
>  	RET
>  SYM_FUNC_END(clear_bhb_loop)

Dropping this and the next patch, they are not needed with globals for BHB
loop count.

