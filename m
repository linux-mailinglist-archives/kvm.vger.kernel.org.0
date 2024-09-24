Return-Path: <kvm+bounces-27389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB35984BD8
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 21:57:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E6DA28478F
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 19:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2722113AD20;
	Tue, 24 Sep 2024 19:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XxFXiFMw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5285A1386C9
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 19:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727207824; cv=none; b=E9SeZDlrd0rhtBHJSkgbw/j2CiEKLbypdSW9c2lA2C8QVjwo8NcXhNi8Pa8avsTJZhLzthxHYVt8oTaN8q3Dn3xCQpwM1RRXHJT2LCJ+M2zsg96aCw5ujP6Q8goNN27NYkxGvVKgcJTPnNPefgHeOziTFzDBnhSpPsOgrt54doI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727207824; c=relaxed/simple;
	bh=vs/Q00mpqMCANbeBETDP9iTGdVlpdkwKxWxZINpqxFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=st0L3COhM1WogciAh64q3lNTJTsFDA9IPYXIFqAwtXTF4p7rQ1aj5OW3BzKw2pHgQmmXEBIZ2ukbH9iFafigOz/7wbpxmrB8fWRSnKptIWaDBW10f/tdUUrKLTMrizL69KdBDZgKa6542okGX9KZ8HfmwWQUH9UQukVbEpnGOl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XxFXiFMw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DF2C4CEC4;
	Tue, 24 Sep 2024 19:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727207824;
	bh=vs/Q00mpqMCANbeBETDP9iTGdVlpdkwKxWxZINpqxFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XxFXiFMwZrSGnLiyTu2hLENoclsOGKfRdG0HohayTiJhJ0TO6sB6giHtySe0YMGMD
	 3u6j5C1iTmTRoYCDSM6ZdLr1x1JC0jHgPJ/cIhuu3PKQODIXMqJqNcjB91Rw5QYFqf
	 NXHmRcAvbCvSssZHAoXsGp+GyHoxU+zNWG2r3IRzBWzbwY5L9J3zMfYiCFUDNHrKDZ
	 XKHuTCtSwIrMOOpintYtxEQGuQRFyZf25xAarUqPbYjrgSbXOiHOo0va4BEwjAaF8H
	 v3e5DPlkXcw8bY9J589OVYFFezKSbLN/BWKDjSP34aJDmPH+me+5KsAALcE7kljel/
	 UFoH0kPPnL9Uw==
Date: Tue, 24 Sep 2024 21:56:58 +0200
From: Danilo Krummrich <dakr@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Zhi Wang <zhiw@nvidia.com>, kvm@vger.kernel.org,
	nouveau@lists.freedesktop.org, alex.williamson@redhat.com,
	kevin.tian@intel.com, airlied@gmail.com, daniel@ffwll.ch,
	acurrid@nvidia.com, cjia@nvidia.com, smitra@nvidia.com,
	ankita@nvidia.com, aniketa@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <ZvMZisyZFO888N0E@cassiopeiae>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
 <ZvHwzzp2F71W8TAs@pollux.localdomain>
 <20240924164151.GJ9417@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240924164151.GJ9417@nvidia.com>

On Tue, Sep 24, 2024 at 01:41:51PM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 24, 2024 at 12:50:55AM +0200, Danilo Krummrich wrote:
> 
> > > From the VFIO side I would like to see something like this merged in
> > > nearish future as it would bring a previously out of tree approach to
> > > be fully intree using our modern infrastructure. This is a big win for
> > > the VFIO world.
> > > 
> > > As a commercial product this will be backported extensively to many
> > > old kernels and that is harder/impossible if it isn't exclusively in
> > > C. So, I think nova needs to co-exist in some way.
> > 
> > We'll surely not support two drivers for the same thing in the long term,
> > neither does it make sense, nor is it sustainable.
> 
> What is being done here is the normal correct kernel thing to
> do. Refactor the shared core code into a module and stick higher level
> stuff on top of it. Ideally Nova/Nouveau would exist as peers
> implementing DRM subsystem on this shared core infrastructure. We've
> done this sort of thing before in other places in the kernel. It has
> been proven to work well.

So, that's where you have the wrong understanding of what we're working on: You
seem to think that Nova is just another DRM subsystem layer on top of the NVKM
parts (what you call the core driver) of Nouveau.

But the whole point of Nova is to replace the NVKM parts of Nouveau, since
that's where the problems we want to solve reside in.

> 
> So, I'm not sure why you think there should be two drivers in the long
> term? Do you have some technical reason why Nova can't fit into this
> modular architecture?

Like I said above, the whole point of Nova is to be the core driver, the DRM
parts on top are more like "the icing on the cake".

> 
> Regardless, assuming Nova will eventually propose merging duplicated
> bootup code then I suggest it should be able to fully replace the C
> code with a kconfig switch and provide C compatible interfaces for
> VFIO. When Rust is sufficiently mature we can consider a deprecation
> schedule for the C version.
> 
> I agree duplication doesn't make sense, but if it is essential to make
> everyone happy then we should do it to accommodate the ongoing Rust
> experiment.
> 
> > We have a lot of good reasons why we decided to move forward with Nova as a
> > successor of Nouveau for GSP-based GPUs in the long term -- I also just held a
> > talk about this at LPC.
> 
> I know, but this series is adding a VFIO driver to the kernel, and a

I have no concerns regarding the VFIO driver, this is about the new features
that you intend to add to Nouveau.

> complete Nova driver doesn't even exist yet. It is fine to think about
> future plans, but let's not get too far ahead of ourselves here..

Well, that's true, but we can't just add new features to something that has been
agreed to be replaced without having a strategy for this for the successor.

> 
> > For the short/mid term I think it may be reasonable to start with
> > Nouveau, but this must be based on some agreements, for instance:
> > 
> > - take responsibility, e.g. commitment to help with maintainance with some of
> >   NVKM / NVIDIA GPU core (or whatever we want to call it) within Nouveau
> 
> I fully expect NVIDIA teams to own this core driver and VFIO parts. I
> see there are no changes to the MAINTAINERs file in this RFC, that
> will need to be corrected.

Well, I did not say to just take over the biggest part of Nouveau.

Currently - and please correct me if I'm wrong - you make it sound to me as if
you're not willing to respect the decisions that have been taken by Nouveau and
DRM maintainers.

> 
> > - commitment to help with Nova in general and, once applicable, move the vGPU
> >   parts over to Nova
> 
> I think you will get help with Nova based on its own merit, but I
> don't like where you are going with this. Linus has had negative
> things to say about this sort of cross-linking and I agree with
> him. We should not be trying to extract unrelated promises on Nova as
> a condition for progressing a VFIO series. :\

No cross-linking, no unrelated promises.

Again, we're working on a successor of Nouveau and if we keep adding features to
Nouveau in the meantime, we have to have a strategy for the transition,
otherwise we're effectively just ignoring this decision.

So, I really need you to respect the fact that there has been a decision for a
successor and that this *is* in fact relevant for all major changes to Nouveau
as well.

Once you do this, we get the chance to work things out for the short/mid term
and for the long term and make everyone benefit.

I encourage that NVIDIA wants to move things upstream and I'm absolutely willing
to collaborate and help with the use-cases and goals NVIDIA has. But it really
has to be a collaboration and this starts with acknowledging the goals of *each
other*.

> 
> > But I think the very last one naturally happens if we stop further support for
> > new HW in Nouveau at some point.
> 
> I expect the core code would continue to support new HW going forward
> to support the VFIO driver, even if nouveau doesn't use it, until Rust
> reaches some full ecosystem readyness for the server space.

From an upstream perspective the kernel doesn't need to consider OOT drivers,
i.e. the guest driver.

This doesn't mean that we can't work something out for a seamless transition
though.

But again, this can only really work if we acknowledge the goals of each other.

> 
> There are going to be a lot of users of this code, let's not rush to
> harm them please.

Please abstain from such kind of unconstructive insinuations; it's ridiculous to
imply that upstream kernel developers and maintainers would harm the users of
NVIDIA GPUs.

> 
> Fortunately there is no use case for DRM and VFIO to coexist in a
> hypervisor, so this does not turn into a such a technical problem like
> most other dual-driver situations.
> 
> Jason
> 

