Return-Path: <kvm+bounces-40684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75291A59A8E
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 17:00:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AE823AAFF7
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D72F122F386;
	Mon, 10 Mar 2025 15:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOUgLza4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F403222E3EA;
	Mon, 10 Mar 2025 15:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741622378; cv=none; b=fSxW7sqq2Qt5DaZu80Bv/aHtD5NOa0Aq6Go3nxlTu8hA85mTRF/chdPQ2Go+BIYrmOGT12bqyHzPN6r4hCgt+jC4qm5IfGvKUOPbuFVVF5GwARAHoUf+vjffQ1k/zvm5yFRV5yxAjsGxixc+zIDbLLVFsUIi8FofaOSk69kOYdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741622378; c=relaxed/simple;
	bh=EBdiWtBZsjV9l+VD6FfbfKEnQna0Mj2l44kwBSBVKVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UrlNSBfozMTrnhXTdgL2ISBLiZCBOmunzcjyU4WCvCDFcMO1dYeJbBu5mvnaVmVIqCmvuQKPh/ZEHPoZxOBrifjGH1JZm3eMmtjHjezV+fRGyzxTLPwA83kiKJuVIykXTRcmlOGkGTyHvcLDpC3t4hC4gKkj3XMvirIi3FW2Apg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOUgLza4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A90DC4CEE5;
	Mon, 10 Mar 2025 15:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741622377;
	bh=EBdiWtBZsjV9l+VD6FfbfKEnQna0Mj2l44kwBSBVKVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YOUgLza46P+/1QH9sbANY82RHUhPdqOJu4QkvdUBxKxUlNlmfMRRQCzEeAYrgvzAm
	 I9BYaiDUn0P4flP+/zRB9yWcUmo2wYk2M+XbkcHJzfcHIx5Nfef82dLJ3Km1iGpppm
	 qpSvQAlP78Vpl7w4GTjhKHQoqq+A8/8Qx2dIvDaA=
Date: Mon, 10 Mar 2025 16:59:30 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Christian Zigotzky <chzigotzky@xenosoft.de>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	regressions@lists.linux.dev, Trevor Dickinson <rtd2@xtra.co.nz>,
	mad skateman <madskateman@gmail.com>, hypexed@yahoo.com.au,
	Darren Stevens <darren@stevens-zone.net>
Subject: Re: [Kernel 6.12.17] [PowerPC e5500] KVM HV compilation error
Message-ID: <2025031024-dreamt-engulf-087b@gregkh>
References: <20250112095527.434998-4-pbonzini@redhat.com>
 <DDEA8D1B-0A0F-4CF3-9A73-7762FFEFD166@xenosoft.de>
 <2025030516-scoured-ethanol-6540@gregkh>
 <Z8hlXzQZwVEH11fB@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8hlXzQZwVEH11fB@google.com>

On Wed, Mar 05, 2025 at 06:53:19AM -0800, Sean Christopherson wrote:
> On Wed, Mar 05, 2025, Greg KH wrote:
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
> > Odd, what commit caused this problem?  Any hint as to what commit is
> > missing to fix it?
> 
> 833f69be62ac.  It most definitely should be reverted.  The "dependency" for commit
> 87ecfdbc699c ("KVM: e500: always restore irqs") is a superficial code conflict.
> 
> Oof.  The same buggy patch was queue/proposed for all stable trees from 5.4 onward,
> but it look like it only landed in 6.1, 6.6, and 6.12.  I'll send reverts.
> 
> commit 833f69be62ac366b5c23b4a6434389e470dd5c7f
> Author:     Sean Christopherson <seanjc@google.com>
> AuthorDate: Thu Oct 10 11:23:56 2024 -0700
> Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CommitDate: Mon Feb 17 10:04:56 2025 +0100
> 
>     KVM: PPC: e500: Use __kvm_faultin_pfn() to handle page faults
>     
>     [ Upstream commit 419cfb983ca93e75e905794521afefcfa07988bb ]
>     
>     Convert PPC e500 to use __kvm_faultin_pfn()+kvm_release_faultin_page(),
>     and continue the inexorable march towards the demise of
>     kvm_pfn_to_refcounted_page().
>     
>     Signed-off-by: Sean Christopherson <seanjc@google.com>
>     Tested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>     Message-ID: <20241010182427.1434605-55-seanjc@google.com>
>     Stable-dep-of: 87ecfdbc699c ("KVM: e500: always restore irqs")
>     Signed-off-by: Sasha Levin <sashal@kernel.org>

All now reverted, sorry about that.

greg k-h

