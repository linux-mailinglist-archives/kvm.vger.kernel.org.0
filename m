Return-Path: <kvm+bounces-32109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F2649D3169
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 01:31:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D1528B20CD1
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 00:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C996EACD;
	Wed, 20 Nov 2024 00:31:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7371B191;
	Wed, 20 Nov 2024 00:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732062685; cv=none; b=FGtgpFOg92dQryVbQJ34vFebzyEQka2GaFnOVSYynJeJz9Xe9Y8itO7tK0sgW9hSwQe6laQ+RjOzdMm0MFICPWSnm9bCOuRcyouh4ANrGItzmy2LAE168Jw2nLGr9OxQiqMieZ5yfrbk+dHneDCwyJ2KZ+7mMrK0Pg3mcXnRRoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732062685; c=relaxed/simple;
	bh=MmFvQdctCXISMeSN6vO99yIvqNannejpEJfmA1KZahQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXzeuv846YKL0lenoChEqzg86YxiLKshia82RcpZjc+9v9QtYp+MskL2XVqrmd9M6AXJvOGTl6woetkxIM2VijFXEtp5CobgoVD6u1kcy+GXTKV+7u7dcnJ3G2mf+9Fo0w0KH4R5JiiSDEvfAXbj0D8ttLhF/CgbCyE1fXFPJxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BB7C4CECF;
	Wed, 20 Nov 2024 00:31:24 +0000 (UTC)
Date: Tue, 19 Nov 2024 16:31:23 -0800
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 01/12] objtool: Generic annotation infrastructure
Message-ID: <20241120003123.rhb57tk7mljeyusl@jpoimboe>
References: <20241111115935.796797988@infradead.org>
 <20241111125218.113053713@infradead.org>
 <20241115183828.6cs64mpbp5cqtce4@jpoimboe>
 <20241116093331.GG22801@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241116093331.GG22801@noisy.programming.kicks-ass.net>

On Sat, Nov 16, 2024 at 10:33:31AM +0100, Peter Zijlstra wrote:
> On Fri, Nov 15, 2024 at 10:38:28AM -0800, Josh Poimboeuf wrote:
> > On Mon, Nov 11, 2024 at 12:59:36PM +0100, Peter Zijlstra wrote:
> > > +#define ASM_ANNOTATE(x)						\
> > > +	"911:\n\t"						\
> > > +	".pushsection .discard.annotate,\"M\",@progbits,8\n\t"	\
> > > +	".long 911b - .\n\t"					\
> > > +	".long " __stringify(x) "\n\t"				\
> > > +	".popsection\n\t"
> > 
> > Why mergeable and progbits?
> 
> In order to get sh_entsize ?

Is that a guess?  If so, it's not very convincing as I don't see what
entsize would have to do with it.

-- 
Josh

