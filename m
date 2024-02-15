Return-Path: <kvm+bounces-8818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DE4C856D6E
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 20:13:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0B2A1C2181E
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 19:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D9A1139567;
	Thu, 15 Feb 2024 19:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KcGlo1nP"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6DA3D6D
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 19:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708024419; cv=none; b=g5SRIRsgCvuudUM6WyU++WRyJFNW0bBRfXiCF4tT0/xQocNS31Z7MiGXaINPmyuPZ4YoTU8KvBtW/HUUIJ0mUN9Sx2mEJP6aqwdOiOyL1PVToygYygkVdA7VQ/JPTkk1aZJbxJ0BKmP2DCb4a3fGHxzhBW7shOsedU5izRHl2h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708024419; c=relaxed/simple;
	bh=UOfSR5dAnNwpx93Y4Nky26QyqpwV840FSSHolrLdk6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FKQjzoTgRcS2NKnWBZ6S0igGITQfE6XxFtGnQaFv9kjj/qygpZgeBzekBXCZCE0zeyo6Y6XiMCddmKihCRzVp3AevUvIqsl59zDLbcDhMAnMYayEvJauvN8C4kx5/meymJIVV1V3KD8FyZjRkvQ28mdEVeU1VsedhyKf85P+vpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KcGlo1nP; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 15 Feb 2024 20:13:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708024415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+sM3XuJbo/imwLbmrYIvBwXd4yxReBWwfCSoEs0rupM=;
	b=KcGlo1nPfVAJTNCWIozLp9o1WacJwy2+q4qL5TI39E572kA1yum8gibQzOeDIt4S3m0L9K
	AO16faP/P32D3nwchObpTbH95lbSluFZjkM2ognP472qS0mPc7gwiKBVMSnHUmTSpYm+GK
	D4NiqzXqoZAJv1AF4Z0mYzOs94ox/lo=
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
Message-ID: <20240215-8527d5fd0c830d5d8d07f668@orel>
References: <20231130090722.2897974-1-shahuang@redhat.com>
 <20231130090722.2897974-2-shahuang@redhat.com>
 <20240115-0c41f7d4aa09b7b82613faa8@orel>
 <Zc42ZJYMFpXpM4mD@raptor>
 <20240215-f2a2e3798b1f64923417df00@orel>
 <Zc5G0Uu1QxJ1Qt36@raptor>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc5G0Uu1QxJ1Qt36@raptor>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 15, 2024 at 05:16:01PM +0000, Alexandru Elisei wrote:
> Hi Drew,
> 
> On Thu, Feb 15, 2024 at 05:32:22PM +0100, Andrew Jones wrote:
> > On Thu, Feb 15, 2024 at 04:05:56PM +0000, Alexandru Elisei wrote:
> > > Hi Drew,
> > > 
> > > On Mon, Jan 15, 2024 at 01:44:17PM +0100, Andrew Jones wrote:
> > > > On Thu, Nov 30, 2023 at 04:07:03AM -0500, Shaoqin Huang wrote:
> > > > > From: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > > 
> > > > > There are 25 header files today (found with grep -r "#ifndef __ASSEMBLY__)
> > > > > with functionality relies on the __ASSEMBLY__ prepocessor constant being
> > > > > correctly defined to work correctly. So far, kvm-unit-tests has relied on
> > > > > the assembly files to define the constant before including any header
> > > > > files which depend on it.
> > > > > 
> > > > > Let's make sure that nobody gets this wrong and define it as a compiler
> > > > > constant when compiling assembly files. __ASSEMBLY__ is now defined for all
> > > > > .S files, even those that didn't set it explicitely before.
> > > > > 
> > > > > Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > > > > Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> > > > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > > Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> > > > > ---
> > > > >  Makefile           | 5 ++++-
> > > > >  arm/cstart.S       | 1 -
> > > > >  arm/cstart64.S     | 1 -
> > > > >  powerpc/cstart64.S | 1 -
> > > > >  4 files changed, 4 insertions(+), 4 deletions(-)
> > > > > 
> > > > > diff --git a/Makefile b/Makefile
> > > > > index 602910dd..27ed14e6 100644
> > > > > --- a/Makefile
> > > > > +++ b/Makefile
> > > > > @@ -92,6 +92,9 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
> > > > >  
> > > > >  autodepend-flags = -MMD -MP -MF $(dir $*).$(notdir $*).d
> > > > >  
> > > > > +AFLAGS  = $(CFLAGS)
> > > > > +AFLAGS += -D__ASSEMBLY__
> > > > > +
> > > > >  LDFLAGS += -nostdlib $(no_pie) -z noexecstack
> > > > >  
> > > > >  $(libcflat): $(cflatobjs)
> > > > > @@ -113,7 +116,7 @@ directories:
> > > > >  	@mkdir -p $(OBJDIRS)
> > > > >  
> > > > >  %.o: %.S
> > > > > -	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> > > > > +	$(CC) $(AFLAGS) -c -nostdlib -o $@ $<
> > > > 
> > > > I think we can drop the two hunks above from this patch and just rely on
> > > > the compiler to add __ASSEMBLY__ for us when compiling assembly files.
> > > 
> > > I think the precompiler adds __ASSEMBLER__, not __ASSEMBLY__ [1]. Am I
> > > missing something?
> > > 
> > > [1] https://gcc.gnu.org/onlinedocs/cpp/macros/predefined-macros.html#c.__ASSEMBLER__
> > 
> > You're right. I'm not opposed to changing all the __ASSEMBLY__ references
> > to __ASSEMBLER__. I'll try to do that at some point unless you beat me to
> > it.
> 
> Actually, I quite prefer the Linux style of using __ASSEMBLY__ instead of
> __ASSEMBLER__, because it makes reusing Linux files easier. That, and the
> habit formed by staring at Linux assembly files.

Those are good arguments and also saves the churn. OK, let's keep this
patch and __ASSEMBLY__

Thanks,
drew

