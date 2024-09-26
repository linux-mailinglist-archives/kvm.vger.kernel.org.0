Return-Path: <kvm+bounces-27549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85887986FB4
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 11:14:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5D851C20B07
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 09:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E5E71AB51F;
	Thu, 26 Sep 2024 09:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijv7+ahb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F1C15532A
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 09:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727342071; cv=none; b=e9MBCSAWxbTbn015FI4u0o2+uOjgHkfFuPb0n+T7zieV4SiwywTUwb8KMAyrFW9G6uSYvLIeH1cmxEvg2Sp3NlpuuLijXnArqrUs3USF9CaScTBHEI/hL2/1Cn7Wzc6halKODBLO4yaB3b8oHDhWzVyxSOj/D7hxBgmCMQ+CAsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727342071; c=relaxed/simple;
	bh=XS7pIhVuGftzBcIudpqgE2j6Up34ez13SrgcTZaEytE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrE7EhgWxQWk7yiOe3dN/xidaAfliXNdxnraC3KVgt+WqYt5tGFFAEN9uzHl9oL7SPZVyjnSo20Z7lG5Zw/Ft4kpgX8U0t8dmxcOazUOAu+fRRd9zlaoiq4Fo3PJG2OX+Ak+5uUQGjGUXzhwemSBYe1Kl8vOHOfooLQ57cBE9UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijv7+ahb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28295C4CEC5;
	Thu, 26 Sep 2024 09:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727342070;
	bh=XS7pIhVuGftzBcIudpqgE2j6Up34ez13SrgcTZaEytE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ijv7+ahb6OK1eg39Vq41t+Wcb0XJvjHAwuL1oa2X1qLY57SL8u0XqrTlLH5x9rum2
	 d2yfH23EOqxM4UfVS/CBi7Wb0Mblj0RpSoVxgdPLqmw6e5rIR30Mp3NobQiEjNxdBJ
	 s5z3JGrqKh6gzIhJIAcgrn2BvdeVuEx2z6n/lwqE=
Date: Thu, 26 Sep 2024 11:14:27 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Danilo Krummrich <dakr@kernel.org>, Zhi Wang <zhiw@nvidia.com>,
	kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, airlied@gmail.com,
	daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com,
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <2024092614-fossil-bagful-1d59@gregkh>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240923150140.GB9417@nvidia.com>

On Mon, Sep 23, 2024 at 12:01:40PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 23, 2024 at 10:49:07AM +0200, Danilo Krummrich wrote:
> > > 2. Proposal for upstream
> > > ========================
> > 
> > What is the strategy in the mid / long term with this?
> > 
> > As you know, we're trying to move to Nova and the blockers with the device /
> > driver infrastructure have been resolved and we're able to move forward. Besides
> > that, Dave made great progress on the firmware abstraction side of things.
> > 
> > Is this more of a proof of concept? Do you plan to work on Nova in general and
> > vGPU support for Nova?
> 
> This is intended to be a real product that customers would use, it is
> not a proof of concept. There is alot of demand for this kind of
> simplified virtualization infrastructure in the host side. The series
> here is the first attempt at making thin host infrastructure and
> Zhi/etc are doing it with an upstream-first approach.
> 
> >From the VFIO side I would like to see something like this merged in
> nearish future as it would bring a previously out of tree approach to
> be fully intree using our modern infrastructure. This is a big win for
> the VFIO world.
> 
> As a commercial product this will be backported extensively to many
> old kernels and that is harder/impossible if it isn't exclusively in
> C. So, I think nova needs to co-exist in some way.

Please never make design decisions based on old ancient commercial
kernels that have any relevance to upstream kernel development today.
If you care about those kernels, work with the companies that get paid
to support such things.  Otherwise development upstream would just
completely stall and never go forward, as you well know.

As it seems that future support for this hardware is going to be in
rust, just use those apis going forward and backport the small number of
missing infrastructure patches to the relevant ancient kernels as well,
it's not like that would even be noticed in the overall number of
patches they take for normal subsystem improvements :)

thanks,

greg k-h

