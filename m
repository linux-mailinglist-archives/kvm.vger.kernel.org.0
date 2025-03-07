Return-Path: <kvm+bounces-40317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D6007A562DA
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 09:46:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C11A170975
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 08:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31EB1DC99A;
	Fri,  7 Mar 2025 08:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c0U+srwr"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA76114D283
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 08:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741337158; cv=none; b=TlX2kry8oWcfUn7O0rXdt8FWFMbgPKqx3LHOYGTJmR1f4yMv5n6wlMgHk8xe8st/gpDHvoHXgxhu/+fmDaIijfHAcGZNEqM1Q07I1L1orKaBF4bh9nLzK7TNkTTcct/8kcNm2TdIx+yjcgMh3h+QWPthYHUCwjdjryhD6mfdAS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741337158; c=relaxed/simple;
	bh=0wioBYYJr+Fg2a4UNJF5orFJcsFCtBGCn81tgVFX+mo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=INKagu+Keruz4oToOmh3ZJ279i1KAr86yzujpLidOGO1BK3dVBkzp3tyrUuOG5gUw7oPvp2SGKvGbos2Fo6xm23NVFgU4/BAFcir5OQUCyJv6vi075EzSH5O3L2tWfu3nSJmeHlh2o9z3np/Eb9UIoThqvGKqjG/tjs8+y18528=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c0U+srwr; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 7 Mar 2025 09:45:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741337143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kz7tr3Ef4wRK05z0FEwMWNGvCaeHxB4UKfPnpbiiwqw=;
	b=c0U+srwrdTCvXelYlglJHrB+xNHlSsaPkftQptchw3kBq2mcWH0laSgUJd9NI8xpRCw5RL
	HPnrvN6Ls7xPWYjkrH0453InwYF+4w5Hc7P/GBp1ns1alCRkIBkutpXKq6qO4A1vOxEG2T
	Axzw8+2NADScVKg8Smqf+CZZwmg+GHA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	pbonzini@redhat.com, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	lvivier@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH] Makefile: Use CFLAGS in cc-option
Message-ID: <20250307-7a4556045a53c51e3150da2f@orel>
References: <20250307083952.40999-2-andrew.jones@linux.dev>
 <2c0bd772-0132-4053-bd22-aac88a8dcfee@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0bd772-0132-4053-bd22-aac88a8dcfee@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 07, 2025 at 09:42:03AM +0100, Thomas Huth wrote:
> On 07/03/2025 09.39, Andrew Jones wrote:
> > When cross compiling with clang we need to specify the target in
> > CFLAGS and cc-option will fail to recognize target-specific options
> > without it. Add CFLAGS to the CC invocation in cc-option.
> > 
> > Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> > ---
> >   Makefile | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/Makefile b/Makefile
> > index 78352fced9d4..9dc5d2234e2a 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -21,7 +21,7 @@ DESTDIR := $(PREFIX)/share/kvm-unit-tests/
> >   # cc-option
> >   # Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
> > -cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
> > +cc-option = $(shell if $(CC) $(CFLAGS) -Werror $(1) -S -o /dev/null -xc /dev/null \
> >                 > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
> >   libcflat := lib/libcflat.a
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Thanks, but I just found out that I was too hasty with this patch. I broke
x86,

/builds/jones-drew/kvm-unit-tests/x86/Makefile.common:105: *** Recursive variable 'CFLAGS' references itself (eventually).  Stop.

I'll try to sort that out and send a v2.

Thanks,
drew

