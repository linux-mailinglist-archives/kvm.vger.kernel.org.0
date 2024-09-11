Return-Path: <kvm+bounces-26478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B2C29974CD0
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 10:38:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 401A1B22B66
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C254C155A2F;
	Wed, 11 Sep 2024 08:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dLFst21f"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A2514A4C9
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 08:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726043898; cv=none; b=MLFldImhDjs60YWJMHhjpIsupqGZFSORhrdYKYvm+qHPxZPINfovU6druyBqOJIbZ/U7jNCXER8dqvglXyAUGL9C6Ec/21wU/uc/Ca/MYE3pjMyDQ41zHKbaZ4LQuhJMuAvFRuHEia9+f29zrzIO8aB4OQ0qfaYiPC1Go4y2uro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726043898; c=relaxed/simple;
	bh=IdHdgq6E2RHVSHfwO8hNCX+fp7yrK/BAhgYGZ0LZ1Kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ItzwZJoydVfQ9/vCCxyM17PkxKYjFQXiI812MULxdbandZD1KGPnqfCbjExf7v6SFSFX/P/lHzNHX8hK6eElAsZrhFlz1MlCk2QXo1REu8Noo8VN7CvwseSJL0XrwsHJK5QQYyxJYicvYNog6td5LZyb8OmwwnQzH1BnKtzTNus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dLFst21f; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 11 Sep 2024 10:38:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726043894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eE051snZh2bSVPZtNXYXpevYMjlqjSCHaQ5jftH77m4=;
	b=dLFst21f9dkGwqT9b5kRzvQBx43TFIVUUdMxnD+C4SKmbjrk48fJ5eIVyjJdoI+BLJRdCP
	f4A4eKaP9+jNOdvkbsY6+9exb8rV6s55PRN3h1vPXa4UajsEoZppzj7WZygHY8isWnMbNG
	JWLa+HSkeldLmLmaAZnCfB2YOeLRODI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	pbonzini@redhat.com, thuth@redhat.com, atishp@rivosinc.com, cade.richard@berkeley.edu, 
	jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH] lib/stack: Restrengthen base_address
Message-ID: <20240911-e6d3f3b2e9393c66e126d8e4@orel>
References: <20240904145107.2447876-2-andrew.jones@linux.dev>
 <D431NLP0XYPF.F69YFSU98T2G@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D431NLP0XYPF.F69YFSU98T2G@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 11, 2024 at 10:55:34AM GMT, Nicholas Piggin wrote:
> On Thu Sep 5, 2024 at 12:51 AM AEST, Andrew Jones wrote:
> > commit a1f2b0e1efd5 ("treewide: lib/stack: Make base_address arch
> > specific") made base_address() a weak function in order to allow
> > architectures to override it. Linking for EFI doesn't seem to figure
> > out the right one to use though [anymore?]. It must have worked at
> > one point because the commit calls outs EFI as the motivation.
> > Anyway, just drop the weakness in favor of another HAVE_ define.
> 
> I prefer HAVE_ style than weak so fine by me.
> 
> How is the linker not resolving it properly? Some calls still
> point to weak symbol despite non-weak symbol also existing?

Yeah, I noticed traces stopped working with EFI because it was using the
weak version of the function instead of the riscv non-weak version.
Since I'm 99% sure it used to work, then I need to find time to try and
figure out if it's something that changed in k-u-t that is now confusing
the toolchain or a toolchain regression. (It's on the TODO, but there's
lots of stuff on the TODO...)

> 
> 
> >
> > Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> > ---
> >  lib/riscv/asm/stack.h |  1 +
> >  lib/riscv/stack.c     |  2 +-
> >  lib/stack.c           | 10 ++++++----
> >  lib/stack.h           |  2 +-
> >  4 files changed, 9 insertions(+), 6 deletions(-)
> >
> > diff --git a/lib/riscv/asm/stack.h b/lib/riscv/asm/stack.h
> > index f003ca37c913..708fa4215007 100644
> > --- a/lib/riscv/asm/stack.h
> > +++ b/lib/riscv/asm/stack.h
> > @@ -8,5 +8,6 @@
> >  
> >  #define HAVE_ARCH_BACKTRACE_FRAME
> >  #define HAVE_ARCH_BACKTRACE
> > +#define HAVE_ARCH_BASE_ADDRESS
> >  
> >  #endif
> > diff --git a/lib/riscv/stack.c b/lib/riscv/stack.c
> > index 2cd7f012738b..a143c22a570a 100644
> > --- a/lib/riscv/stack.c
> > +++ b/lib/riscv/stack.c
> > @@ -5,7 +5,7 @@
> >  #ifdef CONFIG_RELOC
> >  extern char ImageBase, _text, _etext;
> >  
> > -bool arch_base_address(const void *rebased_addr, unsigned long *addr)
> > +bool base_address(const void *rebased_addr, unsigned long *addr)
> >  {
> >  	unsigned long ra = (unsigned long)rebased_addr;
> >  	unsigned long base = (unsigned long)&ImageBase;
> > diff --git a/lib/stack.c b/lib/stack.c
> > index 086fec544a81..e1c981085176 100644
> > --- a/lib/stack.c
> > +++ b/lib/stack.c
> > @@ -12,9 +12,10 @@
> >  #define MAX_DEPTH 20
> >  
> >  #ifdef CONFIG_RELOC
> > +#ifndef HAVE_ARCH_BASE_ADDRESS
> >  extern char _text, _etext;
> >  
> > -bool __attribute__((weak)) arch_base_address(const void *rebased_addr, unsigned long *addr)
> > +bool base_address(const void *rebased_addr, unsigned long *addr)
> >  {
> >  	unsigned long ra = (unsigned long)rebased_addr;
> >  	unsigned long start = (unsigned long)&_text;
> > @@ -26,8 +27,9 @@ bool __attribute__((weak)) arch_base_address(const void *rebased_addr, unsigned
> >  	*addr = ra - start;
> >  	return true;
> >  }
> > +#endif
> >  #else
> > -bool __attribute__((weak)) arch_base_address(const void *rebased_addr, unsigned long *addr)
> > +bool base_address(const void *rebased_addr, unsigned long *addr)
> >  {
> >  	*addr = (unsigned long)rebased_addr;
> >  	return true;
> 
> Shouldn't HAVE_ARCH_BASE_ADDRESS also cover this?

Yes, I suppose that would be the cleanest thing to do. And then in
lib/$ARCH/asm/stack.h we should have

#ifdef CONFIG_RELOC
#define HAVE_ARCH_BASE_ADDRESS
#endif

when the arch wants to use the implementation here (which is probably
would).

Thanks,
drew

