Return-Path: <kvm+bounces-27689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E60DE98A944
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 18:00:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23B301C23107
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 16:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E9E192B9A;
	Mon, 30 Sep 2024 16:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJTWCMdV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E236C192B90
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 16:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727712003; cv=none; b=EM8AnB4/DX2o38bp11P4qcPD6OA4/La+P0rOpm8WzYh8DVlIdbG+dO6C/6fW3Yz/1eI7uda4Fa+liVoj+ykHBmZsmWDnUea/IuSkNB28HPnhVfnCXud1VQfzSGq/6ZBjpTjm4rnVXWVCQgyGqnybDbNJ7VNzvO+fNdXUyuIGU5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727712003; c=relaxed/simple;
	bh=xpl15b9FyDkcN8x9JvtrD+Sty/utwKCzq04E/ZiAnmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MjUl1Fq1G5hnJztokIAhEZ6QFvJfblJ/8myyFcYMEbfogqLcWFjHivbe76eJ/6scu4ZKbfTRZ0IsA4rRtd55H1A/f+IC15PimaIyLviv75zyPbJxb169tHGS66ugKDQxcOKMTmAf1Tl/PWEeYiJcoYPyKZpV5XWLyaNHKZlyPzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lJTWCMdV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017BFC4CEC7;
	Mon, 30 Sep 2024 15:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727712002;
	bh=xpl15b9FyDkcN8x9JvtrD+Sty/utwKCzq04E/ZiAnmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lJTWCMdVUT1qkIF+nZtNE9OtRn9uJAp5uH9XE5HbZQU+zRc7ZoM5L4U3m7b3SYS0T
	 8h4bw4fjMuV9u8XnTgdSgB5RDJgBK8zUL4itI16ADTRme0clGjTHVwkMXYTVitIbv9
	 raPsNuNi5bNC1Cjy7WHFUBUp75+xVztFKQLs5Ih2MsAf6KYe8hN+weLY6/CIE18lNQ
	 wqjLQft2ypTXR8dq2C09Un1BpVi4ZRS17EPmi4YRVKTV1ukNnOEolr61sOzzgTbDsz
	 HkwDK9yrYKpeIVLDXG//sdfcfcRjzG5nvidJVqgG11DT/5Gs1GWvDtgBvLFYv+aan3
	 A51do83VMrxsg==
Date: Mon, 30 Sep 2024 17:59:56 +0200
From: Danilo Krummrich <dakr@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Zhi Wang <zhiw@nvidia.com>,
	kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, airlied@gmail.com,
	daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com,
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <ZvrK_H0RUpglhdaz@pollux>
References: <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
 <2024092614-fossil-bagful-1d59@gregkh>
 <20240926124239.GX9417@nvidia.com>
 <2024092619-unglazed-actress-0a0f@gregkh>
 <20240926144057.GZ9417@nvidia.com>
 <ZvXjcPOCVUSlALZZ@pollux.localdomain>
 <20240927125115.GZ9417@nvidia.com>
 <Zva_qP2B4rndSiCw@pollux>
 <20240927152724.GC4568@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240927152724.GC4568@nvidia.com>

On Fri, Sep 27, 2024 at 12:27:24PM -0300, Jason Gunthorpe wrote:
> On Fri, Sep 27, 2024 at 04:22:32PM +0200, Danilo Krummrich wrote:
> > > When you say things like this it comes across as though you are
> > > implying there are two tiers to the community. Ie those that set the
> > > strategy and those that don't.
> > 
> > This isn't true, I just ask you to consider the goals that have been set
> > already, because we have been working on this already.
> 
> Why do keep saying I haven't?

Because I haven't seen you to acknowlege that the current direction we're moving
to is that we're trying to move away from Nouveau and start over with a new
GSP-only solution.

Instead you propose a huge architectural rework of Nouveau, extract a core
driver from Nouveau and make this the long term solution.

> 
> I have no intention of becoming involved in your project or
> nouveau. My only interest here is to get an agreement that we can get
> a VFIO driver (to improve the VFIO subsystem and community!) in the
> near term on top of in-tree nouveau.

Two aspects about this.

First, Nova isn't a different project in this sense, it's the continuation of
Nouveau to overcome several problems we have with Nouveau.

Second, of course you have the intention of becoming involved in the Nouveau /
Nova project. You ask for huge architectural changes of Nouveau, including new
interfaces for a VFIO driver on top. If that's not becoming involved what else
would it be?

> 
> > > > But, we have to agree on a long term strategy and work towards the corresponding
> > > > goals *together*.
> > > 
> > > I think we went over all the options already. IMHO the right one is
> > > for nova and vfio to share some kind of core driver. The choice of
> > > Rust for nova complicates planning this, but it doesn't mean anyone is
> > > saying no to it.
> > 
> > This is the problem, you're many steps ahead.
> > 
> > You should start with understanding why we want the core driver to be in Rust.
> > You then can raise your concerns about it and then we can discuss them and see
> > if we can find solutions / consensus.
> 
> I don't want to debate with you about Nova. It is too far in the
> future, and it doesn't intersect with anything I am doing.

Sure it does. Again, Nova is intended to be the continuation of Nouveau. So, if
you want to do a major rework in Nouveau (and hence become involved in the
project) we have to make sure that we progress things in the same direction.

How do you expect the project to be successful in the long term, if the involved
parties are not willing to agree at a direction and common goals for the
project?

Or is it that you are simply not interested in long term? Do you have reasons to
think that the problems we have with Nouveau just go away in the long term? Do
you plan to solve them within Nouveau? If so, how do you plan to do that?

> 
> > But you're not even considering it, and instead start with a counter proposal.
> > This isn't acceptable to me.
> 
> I'm even agreeing to a transition into a core driver in Rust, someday,
> when the full community can agree it is the right time.
> 
> What more do you want from me?

I want that the people involved in the project seriously discuss and align on
the direction and goals for the project in the long term and work towards them
together.

