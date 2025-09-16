Return-Path: <kvm+bounces-57724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AE33B59768
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 15:21:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E3B47AF1DE
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 13:19:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA2330BF58;
	Tue, 16 Sep 2025 13:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kpmN3gqc"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48126313262
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 13:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758028884; cv=none; b=Nj5WDKOEmQ9xE2UhLwY8w2mtLSI0rdUNDlHfnDpx7uAqRcP+WDa9J7H0wl0vMy9vU07ICtAhOiQeJsPbEbRlNDoWt1rRo79BESFGfzzJ8pA9VicphwrMj95+wflqQZiLZhzBiW86JiZHowcuL1ek3m+RamFQRZ99JqFmVQvXn2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758028884; c=relaxed/simple;
	bh=n1nbkJgnD44Cs2JBNyF6SKU+R9dsckfX1hSa9VE4PPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNOrE8RNU/g8MizwXWqq+P9vwH/BFKcIwl3CqowXVRJOe50oTfkn79ycckfpwkNBsZRm1/BSY48sZDa6ZEv9Om0qA7CX4Rd7fHymdz8zyeiXcz5ep9dCluqltSjl+Y9nEXzWAOpg+e+j898xwYYwxGgkMTUa8u49XWgBP1L0vVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kpmN3gqc; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 16 Sep 2025 08:21:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758028880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KvqaJ9UisNyY9DxVD3SpV0aVDxhbWCHafyy1tq+9pdY=;
	b=kpmN3gqcKFcZSooPyPkcSiC9VpncS4TmSB7x62lE5IG7KTWwZ6f5turMJNYvoN49bcgc9L
	MTq9Id2QApTdjrxs8b0/Ge97Su6JCzMacA9ch5DvyybsZX+9gcEgHt5ykCzzjVLiJgr0Zj
	rv1+Et12uODYKwHaqMVtj44AzZECnRk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] Better backtraces for leaf functions
Message-ID: <20250916-130b54e13138252a0eb76f8e@orel>
References: <20250724181759.1974692-1-minipli@grsecurity.net>
 <20250908-c34647c9836098b0484b7430@orel>
 <bad630f8-3223-4f58-a128-30761207f3d1@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bad630f8-3223-4f58-a128-30761207f3d1@grsecurity.net>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 15, 2025 at 11:27:56PM +0200, Mathias Krause wrote:
> Am 08.09.25 um 20:35 schrieb Andrew Jones:
> > On Thu, Jul 24, 2025 at 08:17:59PM +0200, Mathias Krause wrote:
> >> Leaf functions are problematic for backtraces as they lack the frame
> >> pointer setup epilogue. If such a function causes a fault, the original
> >> caller won't be part of the backtrace. That's problematic if, for
> >> example, memcpy() is failing because it got passed a bad pointer. The
> >> generated backtrace will look like this, providing no clue what the
> >> issue may be:
> >> [...]
> 
> >> +ifneq ($(KEEP_FRAME_POINTER),)
> >> +# Fake profiling to force the compiler to emit a frame pointer setup also in
> >> +# leaf function (-mno-omit-leaf-frame-pointer doesn't work, unfortunately).
> >> +#
> >> +# Note:
> >> +# We need to defer the cc-option test until -fno-pic or -no-pie have been
> >> +# added to CFLAGS as -mnop-mcount needs it. The lazy evaluation of CFLAGS
> >> +# during compilation makes this do "The Right Thing."
> >> +fomit_frame_pointer += $(call cc-option, -pg -mnop-mcount, "")
> >> +endif
> >> +
> 
> > 
> > My riscv cross compiler doesn't seem to need this, i.e. we already get
> > memcpy() in the trace with just -fno-omit-frame-pointer.
> 
> Yeah, noticing the same here. Apparently, RISCV has a debug-friendly
> default stack frame epilogue.
> 
> > 
> > Also, while arm doesn't currently have memcpy() in the trace, adding
> > -mno-omit-leaf-frame-pointer works for the cross compiler I'm using
> > for it.
> 
> Hmm, actually, ARM is failing hard on me, causing recursive faults,
> because of the truncated stack frame setup in leaf functions that lacks
> saving the return address on the stack, making the code follow "wild"
> pointers:
> 
> | Unhandled exception 4 (dabt)
> | Exception frame registers:
> | pc : [<40012614>]    lr : [<40010414>]    psr: 200001d3
> | sp : 4013fd94  ip : f4523f20  fp : 4013fd94
> | r10: 00000000  r9 : 00000000  r8 : 00000000
> | r7 : 00000000  r6 : 00000000  r5 : 40140000  r4 : 00000000
> | r3 : deadbeee  r2 : 00000029  r1 : deadbf18  r0 : f4523f21
> | Flags: nzCv  IRQs off  FIQs off  Mode SVC_32
> | Control: 00c50078  Table: 00000000  DAC: 00000000
> | DFAR: deadbeef    DFSR: 00000008
> | Unhandled exception 4 (dabt)
> | Exception frame registers:
> | pc : [<4001318c>]    lr : [<40117400>]    psr: 200001d3
> | sp : 4013fcd8  ip : ea000670  fp : 4013fcdc
> | r10: 00000000  r9 : 00000000  r8 : 00000000
> | r7 : 00000000  r6 : 4013fd94  r5 : 00000004  r4 : 4013fd48
> | r3 : e1a04000  r2 : 00000013  r1 : 4013fce8  r0 : 00000002
> | Flags: nzCv  IRQs off  FIQs off  Mode SVC_32
> | Control: 00c50078  Table: 00000000  DAC: 00000000
> | DFAR: ea000670    DFSR: 00000008
> | RECURSIVE STACK WALK!!!
> |   STACK: @4001318c
> | 0x4001318c: arch_backtrace_frame at lib/arm/stack.c:44
> |                   break;
> |       >       return_addrs[depth] = (void *)fp[0];
> |               if (return_addrs[depth] == 0)
> 
> Note the "RECURSIVE STACK WALK!!!" above.
> 
> I'm using "arm-linux-gnueabi-gcc (Debian 14.2.0-19) 14.2.0" here.
> 
> Also, -mno-omit-leaf-frame-pointer isn't supported for ARM but only
> AArch64. However, there it fixes the backtraces, indeed.

Thanks for checking arm. I was only checking aarch64 and then
mistakenly saying 'arm' when I meant 'arm64'.

> 
> > 
> > And, neither the riscv nor the arm cross compilers I'm using have
> > -mnop-mcount.
> > 
> > So, I think something like this should be put in arch-specific makefiles.
> 
> I added it on purpose to the top-level Makefile, willingly knowing that
> -mnop-mcount is an x86-specific option. However, arch Makefiles get
> included early, so the -fno-pic / -no-pie flags won't be in CFLAGS by
> the time of the test, nor would be the $(cc-option ...) helper be
> available. But yes, it's kinda ugly and, apparently, other architectures
> need fixing too, so I bit the bullet and did a different hack^W^W proper
> fix for em all (will post it in a few).

Thanks for that!

drew

