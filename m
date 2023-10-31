Return-Path: <kvm+bounces-257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75AC77DD937
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 00:21:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D753FB210BE
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 23:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F30E2747D;
	Tue, 31 Oct 2023 23:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vMmU8ddb"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9571E53F
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 23:20:54 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99074FE
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:20:52 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da033914f7cso5994962276.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698794452; x=1699399252; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jk3ioDpEtTCZpNsR+wmjni3i8ZxnGGq+dju+UkWGXEw=;
        b=vMmU8ddbaDiurjtkNPsvdu9HV9cZI9wStrGH1ng/L3+0VIovJ0RR5+ZwPFR0I9Rboj
         Q65wMfBNBLSngN1jhHtK0ai0JUwHUHMzf+iQqUJ1H0g4EPmIWeCl5B6MmNqUGwpT5ZOQ
         5v/6+crpkhBR2ioHGB+Z4yM8+ryMMzzlxsOukDOmtbbpm/+AxPbjd3X/EevqiGs7qI5C
         UbiJz4xQQwbxT2Ypa8tmEE6P3FhNmNJQrgEcG8WdoZ8d0qN3qidgoWsdPs7fCDviwI2A
         d3gpIlHavPQQ3BY73Hry5bWgZbDJ7iQw1wEE//p+nL/5hdTqSbGb1cumUsQ8A59tFhsz
         2A/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698794452; x=1699399252;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jk3ioDpEtTCZpNsR+wmjni3i8ZxnGGq+dju+UkWGXEw=;
        b=TRdaM1pHv6S8sPnEYu+Jkl7WbhK+bB7vCPPbfgQ8X8Nn5c/on4MirKIm+55AxXtIvG
         io5rlo8dydwJx4/7BMx3CLA63k0gFlwfKDpavU0JAmvp5pLHxk28lpGL9bIIrVxjZ3+0
         hEq0do4tXrfP60H6ZP64+Db/r1usOvrY2zjmYcVVdz9jFYXPHarHKnuCXkKsa9664VLd
         X9WGkRNKWKm28CH+jUK5EL6xjdrAkkfXhoJ3nLJDhvA7s1Zgpcwe5k38Mw3iSW8c/CV/
         Z3opDxoAfZ5hdZmdEVZ+N0iP/sVirEIjvgooipMLQHnKPJrLWh6kM52LiHjhlcm+bHdD
         A6kQ==
X-Gm-Message-State: AOJu0YwHLATDjiiNsBfR3nbi4znMhjqsMedeLodMMKBPFMPNlE7NU2Gs
	sN/1qJIcjj3PFnvezBqO+O1QLZ5nWCc=
X-Google-Smtp-Source: AGHT+IFsU9imvyeie0l0m5PMcUEsU+Rf2khwwd7959bnnhM2277oOm3olVjq1EcfPc0Yw9dsn+JR+Ivbtlo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7909:0:b0:da3:ab41:304a with SMTP id
 u9-20020a257909000000b00da3ab41304amr24782ybc.4.1698794451745; Tue, 31 Oct
 2023 16:20:51 -0700 (PDT)
Date: Tue, 31 Oct 2023 16:20:50 -0700
In-Reply-To: <20231002095740.1472907-2-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231002095740.1472907-1-paul@xen.org> <20231002095740.1472907-2-paul@xen.org>
Message-ID: <ZUGL0syLTH09BbsI@google.com>
Subject: Re: [PATCH v7 01/11] KVM: pfncache: add a map helper function
From: Sean Christopherson <seanjc@google.com>
To: Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 02, 2023, Paul Durrant wrote:
> From: Paul Durrant <pdurrant@amazon.com>

Please make the changelog standalone, i.e. don't rely on the shortlog to provide
context.  Yeah, it can be silly and repetive sometimes, particularly when viewing
git commits where the shortlog+changelog are bundled fairly close together, but
when viewing patches in a mail client, e.g. when I'm doing initial review, the
shortlog is in the subject which may be far away or even completely hidden (as is
the case as I'm typing this).

I could have sworn I included this in Documentation/process/maintainer-kvm-x86.rst,
but I'm not finding it.

> We have an unmap helper but mapping is open-coded. Arguably this is fine

Pronouns.

> because mapping is done in only one place, hva_to_pfn_retry(), but adding
> the helper does make that function more readable.
> 
> No functional change intended.
> 
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/pfncache.c | 43 +++++++++++++++++++++++++------------------
>  1 file changed, 25 insertions(+), 18 deletions(-)
> 
> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index 2d6aba677830..0f36acdf577f 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -96,17 +96,28 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
>  }
>  EXPORT_SYMBOL_GPL(kvm_gpc_check);
>  
> -static void gpc_unmap_khva(kvm_pfn_t pfn, void *khva)
> +static void *gpc_map(kvm_pfn_t pfn)
> +{
> +	if (pfn_valid(pfn))
> +		return kmap(pfn_to_page(pfn));
> +#ifdef CONFIG_HAS_IOMEM
> +	else

There's no need for the "else", the happy path is terminal.

> +		return memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
> +#endif

This needs a return for CONFIG_HAS_IOMEM=n.  I haven't tried to compile, but I'm
guessing s390 won't be happy.

This?

static void *gpc_map(kvm_pfn_t pfn)
{
	if (pfn_valid(pfn))
		return kmap(pfn_to_page(pfn));

#ifdef CONFIG_HAS_IOMEM
	return memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
#else
	return NULL;
#endif
}

> +}
> +
> +static void gpc_unmap(kvm_pfn_t pfn, void *khva)
>  {
>  	/* Unmap the old pfn/page if it was mapped before. */
> -	if (!is_error_noslot_pfn(pfn) && khva) {
> -		if (pfn_valid(pfn))
> -			kunmap(pfn_to_page(pfn));
> +	if (is_error_noslot_pfn(pfn) || !khva)
> +		return;
> +
> +	if (pfn_valid(pfn))
> +		kunmap(pfn_to_page(pfn));
>  #ifdef CONFIG_HAS_IOMEM
> -		else
> -			memunmap(khva);
> +	else
> +		memunmap(khva);
>  #endif

I don't mind the refactoring, but it needs to be at least mentioned in the
changelog.  And if we're going to bother, it probably makes sense to add a WARN
in the CONFIG_HAS_IOMEM=n path, e.g.

	/* Unmap the old pfn/page if it was mapped before. */
	if (is_error_noslot_pfn(pfn) || !khva)
		return;

	if (pfn_valid(pfn))
		kunmap(pfn_to_page(pfn));
	else
#ifdef CONFIG_HAS_IOMEM
		memunmap(khva);
#else
		WARN_ON_ONCE(1);
#endif


