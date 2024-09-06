Return-Path: <kvm+bounces-26047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 189FC96FE8D
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 01:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1D521F244BA
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 23:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89A4D15C151;
	Fri,  6 Sep 2024 23:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aUqxPU4e"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFF715B547;
	Fri,  6 Sep 2024 23:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725666000; cv=none; b=P1vtKJl07BGF+V9dGPivuxK7BQTk8nL3spf1T+oakge3OD7EAN1gaqYsW//xD1pi7dKgXsbQPrhNAFVkdiiBYr797LR+C9G231/2JVf2I/q/ZN1c3dznK1CZPaDaJ/LBPY3fzDaWQQExGIxPCwG/o8xnSJh7mVPKXlSM17Ytiz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725666000; c=relaxed/simple;
	bh=hMcMMc3MkfFHqrQ2mnexr17azQHrRCKNkfzIhM20zq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jV2qINie/a8LJG2F+lbt8yHWV/NjSzcEvjXxkCkGAPsFNA20vVotbMHbXvrRlHTnFqM9RfqpunA8ao1qbcSPe2cILu/4ixnfAUl8nxZ1wmQwEXnMHI5sb0gswaQ7KuiuM9jz3BF5//5jnoXfQ3alx6m2GjMG6RU5ls8gfvHe+V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aUqxPU4e; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7131C4CEC4;
	Fri,  6 Sep 2024 23:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725666000;
	bh=hMcMMc3MkfFHqrQ2mnexr17azQHrRCKNkfzIhM20zq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aUqxPU4eo+UHEB4+25Nsa3J5VXEiBtO5Zn0tIMvz//qNKqiAho6aoWjY8jdFqoloj
	 ma3w7Kif0kWJ+/gL2mcybS3wbdygVhLFo+JZSgzwc4G55zKPc2q+BUFAs3fQOhpjCV
	 WIixBSX0VXl4JPSPOl3JoUs0nInHCPMbdRcCGCMVIURvNtlxpBpvsUxFwDqQRkQZct
	 NvgfWj9KLtxCuuRlRTLfKCfKrNi5PQgdMeFyVcE3pjeUaECTo/iYMJFRJ4KCIMxBaq
	 9rpL3XN+6vooaVe4raSjzHig0PX2RtjUN+vk8ZV+He8QCmU7R1ZTeTaAbn8/HxuoMs
	 ozBD4iKyqtfUA==
Date: Fri, 6 Sep 2024 16:39:58 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [GIT PULL] KVM fixes for Linux 6.11-rc7
Message-ID: <20240906233958.GA1968981@thelio-3990X>
References: <20240906154517.191976-1-pbonzini@redhat.com>
 <CAHk-=wjK7HF3dQT8q_6fr3eLGvKS+c46PdYNVAsHRyQRgcgiyw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjK7HF3dQT8q_6fr3eLGvKS+c46PdYNVAsHRyQRgcgiyw@mail.gmail.com>

On Fri, Sep 06, 2024 at 03:38:16PM -0700, Linus Torvalds wrote:
> On Fri, 6 Sept 2024 at 08:45, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > - Specialize return value of KVM_CHECK_EXTENSION(KVM_CAP_READONLY_MEM),
> >   based on VM type
> 
> Grr. This actually causes a build warning with clang, but I didn't
> notice in my "between pulls" build check, because that is with gcc.
> 
> So now it's merged with this error:
> 
>    arch/x86/kvm/x86.c:4819:2: error: unannotated fall-through between
> switch labels [-Werror,-Wimplicit-fallthrough]
> 
> and I'm actually surprised that gcc didn't warn about this too.

Yeah, GCC does not warn when falling through to a break or return, as I
mention in the patch I sent for this (I was going to keep an eye out for
the pull request and comment before it went in but looks like I missed
it):

https://lore.kernel.org/kvm/20240905-kvm-x86-avoid-clang-implicit-fallthrough-v1-1-f2e785f1aa45@kernel.org/

> We definitely enable -Wimplicit-fallthrough on gcc too, but apparently
> it's not functional: falling through to a "break" statement seems to
> not warn with gcc. Which is nonsensical, but whatever.

This was brought up to GCC at one point and they considered its current
behavior as working as intended from my understanding:

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=91432

Cheers,
Nathan

