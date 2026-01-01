Return-Path: <kvm+bounces-66917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E021DCED027
	for <lists+kvm@lfdr.de>; Thu, 01 Jan 2026 13:52:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 660CF3009826
	for <lists+kvm@lfdr.de>; Thu,  1 Jan 2026 12:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF5E21FF4C;
	Thu,  1 Jan 2026 12:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="BkCfUyJt"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310451F4631;
	Thu,  1 Jan 2026 12:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767271916; cv=none; b=dOavlj0DNJ5qp0ZLkdAtyP+oO274cvhNiFBOaGl/gzZ07k5jYufAae+SrP34OtSCFB/+vxZBJeWpPZxyW7RhHB+QtdOUBhiz8SnCZD/2rJnKytCsksWPDBnfFxiLl6vIObRrbeI8Pej0F2W6r+5md8wj5EmsWz6LcoQocZQKIC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767271916; c=relaxed/simple;
	bh=4vwjL74CQeet3MPteeXfyXJy5ITdLU90puUUHGlztYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gt06nEnorp8Ok8EGag9BjWyFYSfKrPm31HIJTBlCoVHe0o6Rqn93LybJWzjMfUc+cYo44NlGfs5SMnRYt17stEaDL6YBZEm9Uy4cPSZf0lGyJ+eBIa34RCgiIKws6j0MKiH8hU2u3fmqn0lIWBXSijVUW/bShW6MuCVkGE3pcxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=BkCfUyJt; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E7E3240E0200;
	Thu,  1 Jan 2026 12:51:47 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id rbGD3wWICVv5; Thu,  1 Jan 2026 12:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1767271903; bh=cpg5DGsO1QP6pLaBpveq6Fku3nzdKAZKaQFJ4bffArw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BkCfUyJtZdHS5lIJmQyKOt5n5c9jRfEPOYIuY+Q46nXKsV20mge7ihYkR9J7rCXEb
	 BoUk/ffrzULzqNnbQrrkHMk1vAmCQtO07Uqjap3gBgcxZWEp9VNSwGgAqy7tUJThKv
	 ubfElJ7QlIHhpDoMyDIlBPZPAjvP+nddicCEL6nIRxLNetp19my+Qv/t7nypgJBgO1
	 1uO35NxBSl2ReyDTnQ3qV6FuC8QKkKV9qWJhp9BsmxLNhz3E0BQP3bT7soQtFRWTch
	 ZffWbEo/fT2IhDvdI+AwJfzXUFrf2z8XoR1Ac7nXwWNYdLqYFiCXNKBSrRnQ2x+++T
	 JKAQnzgzcZEIs+W7KWlgqU9M/oVRhLOpNfbg5xbMN8QIWdHEGI9ENCcWVVwikOiVGK
	 Pp5i9Ofkz+Uq4J3d70ds6JgLfV4BhFDl0UHOHdD7Z2XeA6tQQBM3JIyTo5FvvbXtxJ
	 GFWhKF+459pH/B+Snh2Q5D3egoZ45KfSDT43EJ3yqZoVh5H9e87FR1mjG1UKZWbwto
	 pjTITi2GGd52OKuNNYtVinxmu4FxDuFBqFRWFoKAySYxZO3n3T/oG8ZKf688L9HBTT
	 rx8Kbh4xhg4HZdz+T4XycqXJ5QCctd0r5tCIJP2liz8rxuusMHW5Nowsx/qHZQEwhC
	 gDPSssq4q8mRNlTU/ipudkiw=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 159A540E00DA;
	Thu,  1 Jan 2026 12:51:30 +0000 (UTC)
Date: Thu, 1 Jan 2026 13:51:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v6 1/9] x86/bhi: x86/vmscape: Move LFENCE out of
 clear_bhb_loop()
Message-ID: <20260101125122.GCaVZtysCPB0cljZJN@fat_crate.local>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
 <20251201-vmscape-bhb-v6-1-d610dd515714@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251201-vmscape-bhb-v6-1-d610dd515714@linux.intel.com>

On Mon, Dec 01, 2025 at 10:18:59PM -0800, Pawan Gupta wrote:
> In preparation for adding the support for BHB sequence (without LFENCE) on
> newer CPUs, move the LFENCE to the caller side after clear_bhb_loop() is
> executed. This allows callers to decide whether they need the LFENCE or

s/This allows/Allow/

> not. This does adds a few extra bytes to the call sites, but it obviates

s/This does adds/This adds/

> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index ed04a968cc7d0095ab0185b2e3b5beffb7680afd..886f86790b4467347031bc27d3d761d5cc286da1 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -1528,6 +1528,9 @@ SYM_CODE_END(rewind_stack_and_make_dead)
>   * refactored in the future if needed. The .skips are for safety, to ensure
>   * that all RETs are in the second half of a cacheline to mitigate Indirect
>   * Target Selection, rather than taking the slowpath via its_return_thunk.
> + *
> + * Note, callers should use a speculation barrier like LFENCE immediately after
> + * a call to this function to ensure BHB is cleared before indirect branches.
>   */

Comments do get missed. So, I'd call the function clear_bhb_loop_unfenced or
something to that effect so that it is perfectly clear that !BHI_DIS_S parts
will need the LFENCE at the end. This way it is in the name and should make
people think what they're calling. I'd hope...

>  SYM_FUNC_START(clear_bhb_loop)
>  	ANNOTATE_NOENDBR

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

