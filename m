Return-Path: <kvm+bounces-27414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BEE398576D
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 12:56:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4594D285425
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 10:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 338A6183CA1;
	Wed, 25 Sep 2024 10:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXVw64MJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D41515DBAE
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 10:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727261751; cv=none; b=j0IUEh9gVa7e7ElYUJd1bstD9MHuHHyp9lfSQMQQw2jZFHr+jqApXxI7naZOEGF2lJueYBNBg172xh+YJJnpG0/EmGYKdzwrMvb6/K/Yyn9lFkhfLqmN2WMy6+OZlekiE2ZwnsrWYWGgadqoh5roO7Mt4ZifJgHOwQqXimLJLHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727261751; c=relaxed/simple;
	bh=w59fsBYTm2jesRnmJ5WyaPgj8Bmrwwx6gRDeIrJFrxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T66NrH4S2acpeBmmCgj55Q/VdoXBk61TF5p5ax5KCBQNj3asSFpl6RnEiQeh9IBj7So4T2OL9ADdAomfDQV2jJt4pUsoM7I93Q/cz3tQaruiPm7Q4YVGeP/Wwr8SRBfHJXDXxkM8BvWXxQ3p6UG7kiLmNCJEukT5ehed8zxHagw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXVw64MJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E632C4CEC7;
	Wed, 25 Sep 2024 10:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727261750;
	bh=w59fsBYTm2jesRnmJ5WyaPgj8Bmrwwx6gRDeIrJFrxY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fXVw64MJk4YqlwPDzVRI0omGyDr7fUFkELy+vSfBpmAwUaFMZRF0TIFoDoBYJroPk
	 EtclFOr2lRCQrLD0hY9fAqjCSn4RFri/8wKDBA7Zu3f/D0LD9uBBPWcbr5ENAK9fqx
	 iwQHJGADlWjklHlrm1wUyczBUNl02y0cczQe/6GZski54AL92+PUr3xkcPb3INXXVR
	 OxpGCIA9ueXmNuKaTPZ8vqnxoGOcOYHxJw26TZuWSgY9164oQKRhfuy4Hnf9XTqQro
	 rm2f/0UGTbSrejLj9ucf296StNFjjWioNrAuaaDb8QTLxdFFFXe1t2CZ+Gde07rYr8
	 VjJoEayBpe3zQ==
Date: Wed, 25 Sep 2024 12:55:44 +0200
From: Danilo Krummrich <dakr@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Zhi Wang <zhiw@nvidia.com>, kvm@vger.kernel.org,
	nouveau@lists.freedesktop.org, alex.williamson@redhat.com,
	kevin.tian@intel.com, airlied@gmail.com, daniel@ffwll.ch,
	acurrid@nvidia.com, cjia@nvidia.com, smitra@nvidia.com,
	ankita@nvidia.com, aniketa@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <ZvPsMKytGbcSLACo@pollux>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
 <ZvHwzzp2F71W8TAs@pollux.localdomain>
 <20240924164151.GJ9417@nvidia.com>
 <ZvMZisyZFO888N0E@cassiopeiae>
 <20240925005319.GP9417@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240925005319.GP9417@nvidia.com>

On Tue, Sep 24, 2024 at 09:53:19PM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 24, 2024 at 09:56:58PM +0200, Danilo Krummrich wrote:
> 
> > Currently - and please correct me if I'm wrong - you make it sound to me as if
> > you're not willing to respect the decisions that have been taken by Nouveau and
> > DRM maintainers.
> 
> I've never said anything about your work, go do Nova, have fun.

See, that's the attitude that doesn't get us anywhere.

You act as if we'd just be toying around to have fun, position yourself as the
one who wants to do the "real deal" and just claim that our decisions would harm
users.

And at the same time you proof that you did not get up to speed on what were the
reasons to move in this direction and what are the problems we try to solve.

This just won't lead to a constructive discussion that addresses your concerns.

Try to not go like a bull at a gate. Instead start with asking questions to
understand why we chose this direction and then feel free to raise concerns.

I assure you, we will hear and recognize them! And I'm also sure that we'll find
solutions and compromises.

> 
> I'm just not agreeing to being forced into taking Rust dependencies in
> VFIO because Nova is participating in the Rust Experiment.
> 
> I think the reasonable answer is to accept some code duplication, or
> try to consolidate around a small C core. I understad this is
> different than you may have planned so far for Nova, but all projects
> are subject to community feedback, especially when faced with new
> requirements.

Fully agree, and I'm absolutely open to consider feedback and new requirements.

But again, consider what I said above -- you're creating counterproposals out of
thin air, without considering what we have planned for so far at all.

So, I wonder what kind of reaction you expect approaching things this way?

> 
> I think this discussion is getting a little overheated, there is lots
> of space here for everyone to do their things. Let's not get too
> excited.
> 
> > I encourage that NVIDIA wants to move things upstream and I'm absolutely willing
> > to collaborate and help with the use-cases and goals NVIDIA has. But it really
> > has to be a collaboration and this starts with acknowledging the goals of *each
> > other*.
> 
> I've always acknowledged Nova's goal - it is fine.
> 
> It is just quite incompatible with the VFIO side requirement of no
> Rust in our stack until the ecosystem can consume it.
> 
> I belive there is no reason we can't find an agreeable compromise.

I'm pretty sure we indeed can find agreeable compromise. But again, please
understand that the way of approaching this you've chosen so far won't get us
there.

> 
> > > I expect the core code would continue to support new HW going forward
> > > to support the VFIO driver, even if nouveau doesn't use it, until Rust
> > > reaches some full ecosystem readyness for the server space.
> > 
> > From an upstream perspective the kernel doesn't need to consider OOT drivers,
> > i.e. the guest driver.
> 
> ?? VFIO already took the decision that it is agnostic to what is
> running in the VM. Run Windows-only VMs for all we care, it is still
> supposed to be virtualized correctly.
> 
> > > There are going to be a lot of users of this code, let's not rush to
> > > harm them please.
> > 
> > Please abstain from such kind of unconstructive insinuations; it's ridiculous to
> > imply that upstream kernel developers and maintainers would harm the users of
> > NVIDIA GPUs.
> 
> You literally just said you'd want to effectively block usable VFIO
> support for new GPU HW when "we stop further support for new HW in
> Nouveau at some point" and "move the vGPU parts over to Nova(& rust)".

Well, working on a successor means that once it's in place the support for the
replaced thing has to end at some point.

This doesn't mean that we can't work out ways to address your concerns.

You just make it a binary thing and claim that if we don't choose 1 we harm
users.

This effectively denies looking for solutions of your concerns in the first
place. And again, this won't get us anywhere. It just creates the impression
that you're not interested in solutions, but push through your agenda.

> 
> I don't agree to that, it harms VFIO users, and is not acknowledging
> that conflicting goals exist.
> 
> VFIO will decide when it starts to depend on rust, Nova should not
> force that decision on VFIO. They are very different ecosystems with
> different needs.
> 
> Jason
> 

