Return-Path: <kvm+bounces-8804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA1F985699D
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 17:32:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 820B72928A1
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 16:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 605E2135410;
	Thu, 15 Feb 2024 16:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xUlOuFte"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB94134743
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 16:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708014750; cv=none; b=FImcpT5mD9cgSFZwG/0cgiwYosKd+ULwOViM2k+PeugZRBmTHiyPLX/KzdY33Vw0Ci/ZRX5HuNHByy7UpbyzrXJDvxiK7fmNKEb8S6+CdI2K2tT/NOfDk7rdtRwPehXhMftl4llfEg+ZZ92Z9N2ZMU/1TUfL2peLy6Wx5R5rJN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708014750; c=relaxed/simple;
	bh=CxruYA+OrrvLMA5S8E475GmoqQ+PlGi068L7HZHtKeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o8Rpx4Lt3zL71KcvSOC9SC2erJGjlUmOUo0lX31Y0Y1K0/6jGJO24VFnrXYMqxMAsObner9GLdbCsK91+qyvQr2YNJ8HaoQgXGkXx0xxRugxiyWeJkmF8Q6hT/BMERECiqDPQeSCqL87FG2ixfGXOlqNxt0p3ormyrYAsTT2nok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xUlOuFte; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 15 Feb 2024 17:32:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708014745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9nDrLWNODQB4gIEiAg+xmECb4C6E0u4JtoN7PrlYcjo=;
	b=xUlOuFte1TswmrW+92nQal7/FJ55Q8NcyEV3ZdY3FBZdoEk3Drkbt5uhXHZbB7G36FxlGt
	5lrwCH1+sF1L4T9xqqXxYniRbHkFxEMRt5Q17VOD+GjoU6KA27Pgo2Qx0YTkGEEtliDDlR
	Nv6CgUi2wIf72KxvZGnrc7g6HcE2uI8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Shaoqin Huang <shahuang@redhat.com>, kvmarm@lists.linux.dev, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, Nadav Amit <namit@vmware.com>, kvm@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [kvm-unit-tests PATCH v1 01/18] Makefile: Define __ASSEMBLY__
 for assembly files
Message-ID: <20240215-f2a2e3798b1f64923417df00@orel>
References: <20231130090722.2897974-1-shahuang@redhat.com>
 <20231130090722.2897974-2-shahuang@redhat.com>
 <20240115-0c41f7d4aa09b7b82613faa8@orel>
 <Zc42ZJYMFpXpM4mD@raptor>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc42ZJYMFpXpM4mD@raptor>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 15, 2024 at 04:05:56PM +0000, Alexandru Elisei wrote:
> Hi Drew,
> 
> On Mon, Jan 15, 2024 at 01:44:17PM +0100, Andrew Jones wrote:
> > On Thu, Nov 30, 2023 at 04:07:03AM -0500, Shaoqin Huang wrote:
> > > From: Alexandru Elisei <alexandru.elisei@arm.com>
> > > 
> > > There are 25 header files today (found with grep -r "#ifndef __ASSEMBLY__)
> > > with functionality relies on the __ASSEMBLY__ prepocessor constant being
> > > correctly defined to work correctly. So far, kvm-unit-tests has relied on
> > > the assembly files to define the constant before including any header
> > > files which depend on it.
> > > 
> > > Let's make sure that nobody gets this wrong and define it as a compiler
> > > constant when compiling assembly files. __ASSEMBLY__ is now defined for all
> > > .S files, even those that didn't set it explicitely before.
> > > 
> > > Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > > Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> > > ---
> > >  Makefile           | 5 ++++-
> > >  arm/cstart.S       | 1 -
> > >  arm/cstart64.S     | 1 -
> > >  powerpc/cstart64.S | 1 -
> > >  4 files changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/Makefile b/Makefile
> > > index 602910dd..27ed14e6 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -92,6 +92,9 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
> > >  
> > >  autodepend-flags = -MMD -MP -MF $(dir $*).$(notdir $*).d
> > >  
> > > +AFLAGS  = $(CFLAGS)
> > > +AFLAGS += -D__ASSEMBLY__
> > > +
> > >  LDFLAGS += -nostdlib $(no_pie) -z noexecstack
> > >  
> > >  $(libcflat): $(cflatobjs)
> > > @@ -113,7 +116,7 @@ directories:
> > >  	@mkdir -p $(OBJDIRS)
> > >  
> > >  %.o: %.S
> > > -	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> > > +	$(CC) $(AFLAGS) -c -nostdlib -o $@ $<
> > 
> > I think we can drop the two hunks above from this patch and just rely on
> > the compiler to add __ASSEMBLY__ for us when compiling assembly files.
> 
> I think the precompiler adds __ASSEMBLER__, not __ASSEMBLY__ [1]. Am I
> missing something?
> 
> [1] https://gcc.gnu.org/onlinedocs/cpp/macros/predefined-macros.html#c.__ASSEMBLER__

You're right. I'm not opposed to changing all the __ASSEMBLY__ references
to __ASSEMBLER__. I'll try to do that at some point unless you beat me to
it.

Thanks,
drew

