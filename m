Return-Path: <kvm+bounces-27323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42164983A09
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 01:10:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CC3D2820C4
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 22:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D3AC126BE7;
	Mon, 23 Sep 2024 22:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljHHfAAt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F102E419
	for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 22:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727131861; cv=none; b=b0eyNeX+fz7ApJIBpIoiBm1KLQRGd3IQZqZasem/MCak3rzwEqyaZHUnLXkT8hw15pDtnig4LUB3Vd5VR861TtdANUXo848Ci7Dvf3TbXpdX5udyqpNbe22bYD6CXUhwTm7j9XElG80FhkFmh+EJNgGpZOP9VhOvhlWHgoGY9AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727131861; c=relaxed/simple;
	bh=8noWtyjIGux9sVydkc6f0bWiMNZS85PAHcHlmEf+12E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aUIkSo53KSsvP8i/MR2N4pWtbEOqaz2FpiRwXY8+TI10fSu7gCcsxt8xOghbiMIb1tlzurQTDw6ffVH0U9Jzs0VCaPsXyb72M7RF4tFajvbWX5rMI7eIMm50lcrlRpiO9o2v3PpeV2dfQPeozANKE5z71Jn9K5Q87kqWDdkbezc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljHHfAAt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622E3C4CEC4;
	Mon, 23 Sep 2024 22:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727131860;
	bh=8noWtyjIGux9sVydkc6f0bWiMNZS85PAHcHlmEf+12E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ljHHfAAt6110D1DNsnx+Su/WukODjxIzg9ZQa3AD6bMSdM0KAeojlK7TSSDxUTb2F
	 dS4WgMvbkT/qpC364ts2uKsCg1LgjvJS6gw75QIYMEmM0rn4jIrtpoQMNllRwxAWhU
	 /JSsrBUOwQcU210Wp/hmemvReJPFOkU/B0eylcq+7/p5iDf482VzCVXfBUZBXSFiS9
	 lnBMvtP5HRyX55asUu4NmYs82H4A4VWU4OyXABmN6OZSh8PcJg2LunISKiBc7pP9MM
	 //wm0ngHVDUk8K+m3ooTYgqybIxXRvQXVs+qHWvkpWJb7xVqtU3dHU6d1Gwe1rVtGX
	 1eEI2Vb/pM1uw==
Date: Tue, 24 Sep 2024 00:50:55 +0200
From: Danilo Krummrich <dakr@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Zhi Wang <zhiw@nvidia.com>, kvm@vger.kernel.org,
	nouveau@lists.freedesktop.org, alex.williamson@redhat.com,
	kevin.tian@intel.com, airlied@gmail.com, daniel@ffwll.ch,
	acurrid@nvidia.com, cjia@nvidia.com, smitra@nvidia.com,
	ankita@nvidia.com, aniketa@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <ZvHwzzp2F71W8TAs@pollux.localdomain>
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
> simplified virtualization infrastructure in the host side.

I see...

> The series
> here is the first attempt at making thin host infrastructure and
> Zhi/etc are doing it with an upstream-first approach.

This is great!

> 
> From the VFIO side I would like to see something like this merged in
> nearish future as it would bring a previously out of tree approach to
> be fully intree using our modern infrastructure. This is a big win for
> the VFIO world.
> 
> As a commercial product this will be backported extensively to many
> old kernels and that is harder/impossible if it isn't exclusively in
> C. So, I think nova needs to co-exist in some way.

We'll surely not support two drivers for the same thing in the long term,
neither does it make sense, nor is it sustainable.

We have a lot of good reasons why we decided to move forward with Nova as a
successor of Nouveau for GSP-based GPUs in the long term -- I also just held a
talk about this at LPC.

For the short/mid term I think it may be reasonable to start with Nouveau, but
this must be based on some agreements, for instance:

- take responsibility, e.g. commitment to help with maintainance with some of
  NVKM / NVIDIA GPU core (or whatever we want to call it) within Nouveau
- commitment to help with Nova in general and, once applicable, move the vGPU
  parts over to Nova

But I think the very last one naturally happens if we stop further support for
new HW in Nouveau at some point.

> 
> Jason
> 

