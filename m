Return-Path: <kvm+bounces-31276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35CB09C1FC8
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 15:57:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9E35B2393D
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 14:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012781F4FA3;
	Fri,  8 Nov 2024 14:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ne9MXo9X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173051F4701;
	Fri,  8 Nov 2024 14:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731077839; cv=none; b=lGkOEZETKwnydRZ9nvhFYbmPjb1j0SIdT2FxvUa+QUsLu42zQ8dUfqfdX0MZBzawt1dn+Lycwa6QXzFUjg9ltlgxeupu9DoNyExJZD+wB7ZAc8QEgWPurUlaZ5tbcW/V9g2rlY17psROv6B2ST+9sqsdZta1wGoahdMdAxZBhZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731077839; c=relaxed/simple;
	bh=GIBswxmrFxA/09nr/erPq2+MibYHZUJEtyV3ryd6FjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o9poLN4TJi2+3g4z4WuHhiZz5JLxGsY1utbLdMNru9novnJweEQOahxoFQquUz4zreivOQMc8mnzLExmGcJH9XifYGDm/HKcpNxzOtGHL+ThOTPECidCSM6YC1ZTK9s0DAiOg33NRHo967H0TgZMxn8Bd7o0X9bRkUYHQZhZU+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ne9MXo9X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD046C4CECD;
	Fri,  8 Nov 2024 14:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731077838;
	bh=GIBswxmrFxA/09nr/erPq2+MibYHZUJEtyV3ryd6FjU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ne9MXo9XrJJYLOVnJcDLyp/o0NetWYt7dWQGYa0FYG+vyek2SYPtJ9s0Wce5pjbw9
	 cFf1b1n2aoOLBpLemqWcQ/B8drIEXFubfu1RQKDahRgW1u2o/kU8q61ba3n4YePIQM
	 tLsL+karSwKGjCy53tmJSWyE7JrFHjqY4UW1baTccsOKrv0sumZYgPWDZ6BoLozuo1
	 ZT8IDs64F+OrTB8FDHFdCYYfmlRgl+Um00SPNPm/4d+6DrLAAkGfq/C7Em3ESnHYCt
	 Pg3+1nIBFEqB9EDJTqVMS5HwGSt/qRGYG1icV8Pu+by2gGqpE9X+Uwne9BjBxUn1xw
	 MBRkEr+rF5XmQ==
Date: Fri, 8 Nov 2024 07:57:16 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>, Fangrui Song <i@maskray.me>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, ndesaulniers@google.com,
	morbo@google.com, justinstitt@google.com, llvm@lists.linux.dev
Subject: Re: [PATCH 01/11] objtool: Generic annotation infrastructure
Message-ID: <20241108145716.GA2564051@thelio-3990X>
References: <20231204093702.989848513@infradead.org>
 <20231204093731.356358182@infradead.org>
 <20241108141600.GB6497@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108141600.GB6497@noisy.programming.kicks-ass.net>

On Fri, Nov 08, 2024 at 03:16:00PM +0100, Peter Zijlstra wrote:
> On Mon, Dec 04, 2023 at 10:37:03AM +0100, Peter Zijlstra wrote:
> > Avoid endless .discard.foo sections for each annotation, create a
> > single .discard.annotate section that takes an annotation type along
> > with the instruction.
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> > --- a/include/linux/objtool.h
> > +++ b/include/linux/objtool.h
> > @@ -57,6 +57,13 @@
> >  	".long 998b\n\t"						\
> >  	".popsection\n\t"
> >  
> > +#define ASM_ANNOTATE(x)						\
> > +	"911:\n\t"						\
> > +	".pushsection .discard.annotate,\"M\",@progbits,8\n\t"	\
> > +	".long 911b - .\n\t"					\
> > +	".long " __stringify(x) "\n\t"				\
> > +	".popsection\n\t"
> > +
> >  #else /* __ASSEMBLY__ */
> >  
> >  /*
> > @@ -146,6 +153,14 @@
> >  	.popsection
> >  .endm
> >  
> > +.macro ANNOTATE type:req
> > +.Lhere_\@:
> > +	.pushsection .discard.annotate,"M",@progbits,8
> > +	.long	.Lhere_\@ - .
> > +	.long	\type
> > +	.popsection
> > +.endm
> > +
> >  #endif /* __ASSEMBLY__ */
> >  
> >  #else /* !CONFIG_OBJTOOL */
> > @@ -167,6 +182,8 @@
> >  .endm
> >  .macro REACHABLE
> >  .endm
> > +.macro ANNOTATE
> > +.endm
> >  #endif
> >  
> >  #endif /* CONFIG_OBJTOOL */
> > --- a/tools/objtool/check.c
> > +++ b/tools/objtool/check.c
> > @@ -2308,6 +2308,41 @@ static int read_unwind_hints(struct objt
> >  	return 0;
> >  }
> >  
> > +static int read_annotate(struct objtool_file *file, void (*func)(int type, struct instruction *insn))
> > +{
> > +	struct section *rsec, *sec;
> > +	struct instruction *insn;
> > +	struct reloc *reloc;
> > +	int type;
> > +
> > +	rsec = find_section_by_name(file->elf, ".rela.discard.annotate");
> > +	if (!rsec)
> > +		return 0;
> > +
> > +	sec = find_section_by_name(file->elf, ".discard.annotate");
> > +	if (!sec)
> > +		return 0;
> > +
> > +	for_each_reloc(rsec, reloc) {
> > +		insn = find_insn(file, reloc->sym->sec,
> > +				 reloc->sym->offset + reloc_addend(reloc));
> > +		if (!insn) {
> > +			WARN("bad .discard.annotate entry: %d", reloc_idx(reloc));
> > +			return -1;
> > +		}
> > +
> > +		type = *(u32 *)(sec->data->d_buf + (reloc_idx(reloc) * sec->sh.sh_entsize) + 4);
> > +
> > +		func(type, insn);
> > +	}
> > +
> > +	return 0;
> > +}
> 
> So... ld.lld hates this :-(
> 
> From an LLVM=-19 build we can see that:
> 
> $ readelf -WS tmp-build/arch/x86/kvm/vmx/vmenter.o | grep annotate
>   [13] .discard.annotate PROGBITS        0000000000000000 00028c 000018 08   M  0   0  1
> 
> $ readelf -WS tmp-build/arch/x86/kvm/kvm-intel.o | grep annotate
>   [ 3] .discard.annotate PROGBITS        0000000000000000 069fe0 0089d0 00   M  0   0  1
> 
> Which tells us that the translation unit itself has a sh_entsize of 8,
> while the linked object has sh_entsize of 0.
> 
> This then completely messes up the indexing objtool does, which relies
> on it being a sane number.
> 
> GCC/binutils very much does not do this, it retains the 8.
> 
> Dear clang folks, help?

Perhaps Fangrui has immediate thoughts, since this appears to be an
ld.lld thing? Otherwise, I will see if I can dig into this in the next
couple of weeks (I have an LF webinar on Wednesday that I am still
prepping for). Is this reproducible with just defconfig or something
else?

Cheers,
Nathan

