Return-Path: <kvm+bounces-8807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93C32856AB5
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 18:16:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CA0E1F21A78
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 17:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF377136676;
	Thu, 15 Feb 2024 17:16:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC2F0136640
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708017370; cv=none; b=TvdwzJvF5RECZCWT4U5tvdBaM0In2fUOe1nVWn0zkOiIf74geduJVnndI15NPUVwBZW47G1g/OHZPHA9X7GDem+psEPSpGGkJBpG6rsE+uD6EUmTqwivb+GwEVSyOWcKFMNbDjZ+ixf11FeTDqGMxWTS/6zcihiLaWV+VYnzzks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708017370; c=relaxed/simple;
	bh=zxz0QrYMAAaMuEw9ynoZ7NA8W5JxzJkBnWva1dxS7gU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nz01H7Hlv4pyxFCCjc4iGCjbCCyrRuQBzi7LGoTtJmXEaJEsBqzm+2h1yO6YVbc9P9WS7eN2+VFflR3zytgZEKtCxpM2JaSSgeLsP+MJ78sAmRchy+lIx1tT9wF05ALK+uCMbmDtcq1VSsoNS2HDLn1/W2FRBbxuXoIW59g75xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 127911FB;
	Thu, 15 Feb 2024 09:16:48 -0800 (PST)
Received: from raptor (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D392A3F766;
	Thu, 15 Feb 2024 09:16:04 -0800 (PST)
Date: Thu, 15 Feb 2024 17:16:01 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Shaoqin Huang <shahuang@redhat.com>, kvmarm@lists.linux.dev,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Nico Boehr <nrb@linux.ibm.com>, David Woodhouse <dwmw@amazon.co.uk>,
	Nadav Amit <namit@vmware.com>, kvm@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [kvm-unit-tests PATCH v1 01/18] Makefile: Define __ASSEMBLY__
 for assembly files
Message-ID: <Zc5G0Uu1QxJ1Qt36@raptor>
References: <20231130090722.2897974-1-shahuang@redhat.com>
 <20231130090722.2897974-2-shahuang@redhat.com>
 <20240115-0c41f7d4aa09b7b82613faa8@orel>
 <Zc42ZJYMFpXpM4mD@raptor>
 <20240215-f2a2e3798b1f64923417df00@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240215-f2a2e3798b1f64923417df00@orel>

Hi Drew,

On Thu, Feb 15, 2024 at 05:32:22PM +0100, Andrew Jones wrote:
> On Thu, Feb 15, 2024 at 04:05:56PM +0000, Alexandru Elisei wrote:
> > Hi Drew,
> > 
> > On Mon, Jan 15, 2024 at 01:44:17PM +0100, Andrew Jones wrote:
> > > On Thu, Nov 30, 2023 at 04:07:03AM -0500, Shaoqin Huang wrote:
> > > > From: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > 
> > > > There are 25 header files today (found with grep -r "#ifndef __ASSEMBLY__)
> > > > with functionality relies on the __ASSEMBLY__ prepocessor constant being
> > > > correctly defined to work correctly. So far, kvm-unit-tests has relied on
> > > > the assembly files to define the constant before including any header
> > > > files which depend on it.
> > > > 
> > > > Let's make sure that nobody gets this wrong and define it as a compiler
> > > > constant when compiling assembly files. __ASSEMBLY__ is now defined for all
> > > > .S files, even those that didn't set it explicitely before.
> > > > 
> > > > Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > > > Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> > > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> > > > ---
> > > >  Makefile           | 5 ++++-
> > > >  arm/cstart.S       | 1 -
> > > >  arm/cstart64.S     | 1 -
> > > >  powerpc/cstart64.S | 1 -
> > > >  4 files changed, 4 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/Makefile b/Makefile
> > > > index 602910dd..27ed14e6 100644
> > > > --- a/Makefile
> > > > +++ b/Makefile
> > > > @@ -92,6 +92,9 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
> > > >  
> > > >  autodepend-flags = -MMD -MP -MF $(dir $*).$(notdir $*).d
> > > >  
> > > > +AFLAGS  = $(CFLAGS)
> > > > +AFLAGS += -D__ASSEMBLY__
> > > > +
> > > >  LDFLAGS += -nostdlib $(no_pie) -z noexecstack
> > > >  
> > > >  $(libcflat): $(cflatobjs)
> > > > @@ -113,7 +116,7 @@ directories:
> > > >  	@mkdir -p $(OBJDIRS)
> > > >  
> > > >  %.o: %.S
> > > > -	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> > > > +	$(CC) $(AFLAGS) -c -nostdlib -o $@ $<
> > > 
> > > I think we can drop the two hunks above from this patch and just rely on
> > > the compiler to add __ASSEMBLY__ for us when compiling assembly files.
> > 
> > I think the precompiler adds __ASSEMBLER__, not __ASSEMBLY__ [1]. Am I
> > missing something?
> > 
> > [1] https://gcc.gnu.org/onlinedocs/cpp/macros/predefined-macros.html#c.__ASSEMBLER__
> 
> You're right. I'm not opposed to changing all the __ASSEMBLY__ references
> to __ASSEMBLER__. I'll try to do that at some point unless you beat me to
> it.

Actually, I quite prefer the Linux style of using __ASSEMBLY__ instead of
__ASSEMBLER__, because it makes reusing Linux files easier. That, and the
habit formed by staring at Linux assembly files.

Thanks,
Alex

