Return-Path: <kvm+bounces-27587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AB25F987B38
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 00:43:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BBF69B22473
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 22:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61ABB1A0BF1;
	Thu, 26 Sep 2024 22:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N0lrvvWw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4A61A0BE4
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 22:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727390583; cv=none; b=e8dBbsiBt4PIq/BgzOQVv4LgZYpGZ8B1bDBYEkbZ8Q2QP9gELz3MqOb/79AVlRXPxZn/UhQq96iTdclif6Qm16448Ww/bTtDlx9OnC+gj4JXdHhdtFHBv4PyMgMsQWe5Ybk8m84XQn+CQw3QWJZyV00LjS3/aV/5y6Xs2pBCxXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727390583; c=relaxed/simple;
	bh=ic6z+f0J1Xsp+C21vp8z/xXHOYGJryS4zzfUY8FpcwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hE6seLQ+BmlJ55Lb1i0x+T1jz0Es/hHiOdwtxDWaMWJYJdAzJw20XXv9Qg/rmjGlJKfSNJ+7hpFc+wukbb8ajCY3kCm/Da4xgjCo+rzmRwFmEUZDVlrOQ4MfEKT9v+NsrQ89zzf9glIm+xdZgikhviBv0DjrTwsYvFrKjT/clPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N0lrvvWw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964E5C4CEC9;
	Thu, 26 Sep 2024 22:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727390582;
	bh=ic6z+f0J1Xsp+C21vp8z/xXHOYGJryS4zzfUY8FpcwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N0lrvvWwBH2z40tuwnArLpzYdIYn8YxUQ0Sv18u1UyYrfHGEkzmsy6+tWwAlGbEsy
	 pJNAx3ZWsFk+xbJyrQhJUL0AcG1sqYpTp3fNZHO7DfTtkczUuZQe7s9TDm6//Nxp7e
	 9cJ98hUPhBOZ53aFA9E2bZRY9FgjVdTQT9PPkxbaL4CrShl51q4HDJ3Dd/kFJWzWNw
	 3GhQlsmvY0UTlLLKKvxTbqjGKChl/JU98WlKGSbTRD/U4dC6AKBzWJCm6EN1A7eQRQ
	 eV3iauiYiqvuU1haZ3kEpeqJpEeeZBRc1/Cf0ZVCVNjzQdqANRsEDtriG2gDWs2JUP
	 9rG64TWRZIiyg==
Date: Fri, 27 Sep 2024 00:42:56 +0200
From: Danilo Krummrich <dakr@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Zhi Wang <zhiw@nvidia.com>,
	kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, airlied@gmail.com,
	daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com,
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <ZvXjcPOCVUSlALZZ@pollux.localdomain>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
 <2024092614-fossil-bagful-1d59@gregkh>
 <20240926124239.GX9417@nvidia.com>
 <2024092619-unglazed-actress-0a0f@gregkh>
 <20240926144057.GZ9417@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240926144057.GZ9417@nvidia.com>

On Thu, Sep 26, 2024 at 11:40:57AM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 26, 2024 at 02:54:38PM +0200, Greg KH wrote:
> > 
> > No, I do object to "we are ignoring the driver being proposed by the
> > developers involved for this hardware by adding to the old one instead"
> > which it seems like is happening here.
> 
> That is too harsh. We've consistently taken a community position that
> OOT stuff doesn't matter, and yes that includes OOT stuff that people
> we trust and respect are working on. Until it is ready for submission,
> and ideally merged, it is an unknown quantity. Good well meaning
> people routinely drop their projects, good projects run into
> unexpected roadblocks, and life happens.

That's not the point -- at least it never was my point.

Upstream has set a strategy, and it's totally fine to raise concerns, discuss
them, look for solutions, draw conclusions and do adjustments where needed.

But, we have to agree on a long term strategy and work towards the corresponding
goals *together*.

I don't want to end up in a situation where everyone just does their own thing.

So, when you say things like "go do Nova, have fun", it really just sounds like
as if you just want to do your own thing and ignore the existing upstream
strategy instead of collaborate and shape it.

