Return-Path: <kvm+bounces-40679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B56DA599D5
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:22:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A1DB1886966
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E853A22D4FA;
	Mon, 10 Mar 2025 15:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FHpWcWc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0267D22A4C3;
	Mon, 10 Mar 2025 15:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741620153; cv=none; b=L/FYvmc73zMyKJRxWl/wbeqbhybaXidD2SdqzRJlEkSRjECL2u3DeWp3oTlPgpVoSvFuV9+nuaEZVw7vaXBMr2s4cqzL2w43aIUtR1FNNyGiBWSujxJ5/5ZSeKM5wiJyulEXNCim2wE2QMXHjV1hzCY5G9wk5tFjQJJEGDAIckc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741620153; c=relaxed/simple;
	bh=Cv8m8jD7+RmPJkCj57aD0CpR1gxtDVWyCmNb4E+uGhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aepfbliWNJdA2VNw8Nb++cPhavgrFYWDMxWjckn/TtqPuaMtmQVDK+NDGnSpI0T+/vW4I6oywQA160SMOXJa27rz0XyOevoZjs/fGNQQ0a5clW9w/PJ3ar5pb/tFDNhALgbKj/+tjuLy45bYEZwwZ3vMrZYV5guJHU/iQy1QOQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FHpWcWc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2056DC4CEE5;
	Mon, 10 Mar 2025 15:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741620152;
	bh=Cv8m8jD7+RmPJkCj57aD0CpR1gxtDVWyCmNb4E+uGhU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0FHpWcWc7Qca61uQIH2Govy451NTIDVUxX2ga1F597qu9+ST0RzvlJXxvR0B48iFj
	 ofDf9PKmqRIuNmNpOjue02Gp0jrJ7v6bu+qrUShfMnC+4g3aTQAt3WRjNG3Apc6tpV
	 8mTflCuUbscJQpbTB2nbZKty+F5JMvp5PEU3hadk=
Date: Mon, 10 Mar 2025 16:22:29 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christian Zigotzky <chzigotzky@xenosoft.de>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	seanjc@google.com, linuxppc-dev@lists.ozlabs.org,
	regressions@lists.linux.dev, Trevor Dickinson <rtd2@xtra.co.nz>,
	mad skateman <madskateman@gmail.com>, hypexed@yahoo.com.au,
	Darren Stevens <darren@stevens-zone.net>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [Kernel 6.12.17] [PowerPC e5500] KVM HV compilation error
Message-ID: <2025031053-define-calamity-8115@gregkh>
References: <20250112095527.434998-4-pbonzini@redhat.com>
 <DDEA8D1B-0A0F-4CF3-9A73-7762FFEFD166@xenosoft.de>
 <2025030516-scoured-ethanol-6540@gregkh>
 <CABgObfb5U9zwTQBPkPB=mKu-vMrRspPCm4wfxoQpB+SyAnb5WQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfb5U9zwTQBPkPB=mKu-vMrRspPCm4wfxoQpB+SyAnb5WQ@mail.gmail.com>

On Wed, Mar 05, 2025 at 03:54:06PM +0100, Paolo Bonzini wrote:
> On Wed, Mar 5, 2025 at 3:19 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, Mar 05, 2025 at 03:14:13PM +0100, Christian Zigotzky wrote:
> > > Hi All,
> > >
> > > The stable long-term kernel 6.12.17 cannot compile with KVM HV support for e5500 PowerPC machines anymore.
> > >
> > > Bug report: https://github.com/chzigotzky/kernels/issues/6
> > >
> > > Kernel config: https://github.com/chzigotzky/kernels/blob/6_12/configs/x5000_defconfig
> > >
> > > Error messages:
> > >
> > > arch/powerpc/kvm/e500_mmu_host.c: In function 'kvmppc_e500_shadow_map':
> > > arch/powerpc/kvm/e500_mmu_host.c:447:9: error: implicit declaration of function '__kvm_faultin_pfn' [-Werror=implicit-function-declaration]
> > >    pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, NULL, &page);
> > >          ^~~~~~~~~~~~~~~~~
> > >   CC      kernel/notifier.o
> > > arch/powerpc/kvm/e500_mmu_host.c:500:2: error: implicit declaration of function 'kvm_release_faultin_page'; did you mean 'kvm_read_guest_page'? [-Werror=implicit-function-declaration]
> > >   kvm_release_faultin_page(kvm, page, !!ret, writable);
> > >
> > > After that, I compiled it without KVM HV support.
> > >
> > > Kernel config: https://github.com/chzigotzky/kernels/blob/6_12/configs/e5500_defconfig
> > >
> > > Please check the error messages.
> >
> > Odd, what commit caused this problem?
> 
> 48fe216d7db6b651972c1c1d8e3180cd699971b0
> 
> > Any hint as to what commit is missing to fix it?
> 
> A big-ass 90 patch series. __kvm_faultin_pfn and
> kvm_release_faultin_page were introduced in 6.13, as part of a big
> revamp of how KVM does page faults on all architectures.
> 
> Just revert all this crap and apply the version that I've just sent
> (https://lore.kernel.org/stable/20250305144938.212918-1-pbonzini@redhat.com/):
> 
> commit 48fe216d7db6b651972c1c1d8e3180cd699971b0
>     KVM: e500: always restore irqs
> 
> commit 833f69be62ac366b5c23b4a6434389e470dd5c7f
>     KVM: PPC: e500: Use __kvm_faultin_pfn() to handle page faults
>     Message-ID: <20241010182427.1434605-55-seanjc@google.com>
>     Stable-dep-of: 87ecfdbc699c ("KVM: e500: always restore irqs")
> 
> commit f2623aec7fdc2675667042c85f87502c9139c098
>     KVM: PPC: e500: Mark "struct page" pfn accessed before dropping mmu_lock
>     Message-ID: <20241010182427.1434605-54-seanjc@google.com>
>     Stable-dep-of: 87ecfdbc699c ("KVM: e500: always restore irqs")
> 
> commit dec857329fb9a66a5bce4f9db14c97ef64725a32
>     KVM: PPC: e500: Mark "struct page" dirty in kvmppc_e500_shadow_map()
>     Message-ID: <20241010182427.1434605-53-seanjc@google.com>
>     Stable-dep-of: 87ecfdbc699c ("KVM: e500: always restore irqs")
> 
> And this, ladies and gentlemen, is why I always include the apparently
> silly Message-ID trailer. Don't you just love how someone, whether
> script or human, cherry picked patches 53-55 without even wondering
> what was in the 52 before. I'm not sure if it'd be worse for it to be
> a human or a script... because if it's a script, surely the same level
> of sophistication could have been put into figuring out whether the
> thing even COMPILES.
> 
> Sasha, this wins the prize for most ridiculous automatic backport
> ever. Please stop playing maintainer if you can't be bothered to read
> the commit messages for random stuff that you apply.

Sasha, I thought we weren't taking any kvm patches that were not
explicitly tagged for stable?  The filter list says that...

Anyway, let me go revert these, thanks for the report.

thanks,

greg k-h

