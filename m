Return-Path: <kvm+bounces-26474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23161974C7C
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 10:22:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA646287B5A
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 094C1154434;
	Wed, 11 Sep 2024 08:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t+AyMumf"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B8E13B7BC
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 08:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726042908; cv=none; b=bvuZNGsucdXgcwm2oOd8Dn0FBLMdtFTIDwvbLQHQ4E4SZ4BVHwsAZilHtbQAh4UD8Ae/kBkkx4RDjJ8k7CHe1jOeqlqUXUzHDTZbnWUOwnqlDZy0HQ/EytClDXFR0kiZJybgwelkASdlsvuzN0Ttzva3vyP7vdbnpGZaznFYrPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726042908; c=relaxed/simple;
	bh=QOMzxbspnSOacWFLMtjRS9wrXz7Po7uBsyhgSf1eOSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfYANj+LHwsAR8+jNiOU1AyL1aUhsxJF41JhFA26/IhsopPOo73pzcgXLIRP1t7hv2arjyUYGMendPYpg34w7FofvWOPB3+XkzuYsk+gSzSz7SidrPBQZpfRDWIGlADbHrTnb6iX3r0pB0bn3gXuLr8/8DTI2V0b6YCGRzeqXjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t+AyMumf; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 11 Sep 2024 10:21:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726042903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K/VWIG/hvcTo6bq0O/qN91HDvQ0nDTdxNF7MsK1tCQY=;
	b=t+AyMumfV9i65niZfYRKpAR2lPpmH6iNk00zAsgE0AsXC6V+SHXS1KVqOGT0NPOxV1flwM
	dRTjnI2A5vdwboFeqJcvLv7ICGEyGcnBoza2+xjSOHdtAZShTkvnR1Vg1+34F16cpx/2At
	Yl4s7zguwXQ8GX5+PRJswJhmqdFkZko=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	pbonzini@redhat.com, thuth@redhat.com, lvivier@redhat.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, nrb@linux.ibm.com, atishp@rivosinc.com, 
	cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH v2 2/4] Makefile: Prepare for clang EFI
 builds
Message-ID: <20240911-7187cf8364de8a30b0419fac@orel>
References: <20240904105020.1179006-6-andrew.jones@linux.dev>
 <20240904105020.1179006-8-andrew.jones@linux.dev>
 <D430XMRU4FZD.1FFPMW6WVWRSD@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D430XMRU4FZD.1FFPMW6WVWRSD@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 11, 2024 at 10:21:39AM GMT, Nicholas Piggin wrote:
> On Wed Sep 4, 2024 at 8:50 PM AEST, Andrew Jones wrote:
> > clang complains about GNU extensions such as variable sized types not
> > being at the end of structs unless -Wno-gnu is used. We may
> > eventually want -Wno-gnu, but for now let's just handle the warnings
> > as they come. Add -Wno-gnu-variable-sized-type-not-at-end to avoid
> > the warning issued for the initrd_dev_path struct.
> 
> You could also make a variant of struct efi_vendor_dev_path with no
> vendordata just for initrd_dev_path?
> 
> It's taken from Linux or some efi upstream though so maybe it's annoying
> to make such changes here. Okay in that case since it's limited to EFI.

I should have mentioned in the commit message that efi_vendor_dev_path is
a direct import of the Linux code and that we'd rather keep it that way.
I can do that for v2.

> 
> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
drew

> 
> 
> >
> > Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> > ---
> >  Makefile | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/Makefile b/Makefile
> > index 3d51cb726120..7471f7285b78 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -50,6 +50,8 @@ EFI_CFLAGS += -fshort-wchar
> >  # EFI applications use PIC as they are loaded to dynamic addresses, not a fixed
> >  # starting address
> >  EFI_CFLAGS += -fPIC
> > +# Avoid error with the initrd_dev_path struct
> > +EFI_CFLAGS += -Wno-gnu-variable-sized-type-not-at-end
> >  # Create shared library
> >  EFI_LDFLAGS := -Bsymbolic -shared -nostdlib
> >  endif
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

