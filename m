Return-Path: <kvm+bounces-27705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33F8F98AD38
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 21:48:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2A922818C9
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 19:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7A5D19DF61;
	Mon, 30 Sep 2024 19:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="da9EiT4s"
X-Original-To: kvm@vger.kernel.org
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8AE192D63;
	Mon, 30 Sep 2024 19:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727725684; cv=none; b=BRQkFQLWxpNSnnCkQYiP5aXIzHy/KYIoyZ6JdTJMOyo1YZOusrjPygfwUb5Hc3ChTbARArgCBeELyqlvQ4Xdo1q4sw+mGc1C1cqjsF9eqSA3CwuiV8fZA+Nm/EDL49FERFkFWh7hX1kVpsPdvzYmApI7QQHSVZIAGkDkBRq+e2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727725684; c=relaxed/simple;
	bh=zX7Xv4j1Jpsk1DHjtJhzuQXPGJa1B1XRYJxc7YlDcfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B90EBLgLzmkwuo4jAQ78rBg3OKoCxUGN2zFw5WUItTWE4NEx48R7jme69NjZch0H5yrvuT/R1e/qLaOc3B0PGnkoBPL3+CJKBFqx8dOyG/82upqBEz8wGyAvdQxW3gCEo1r35wy+zIXT+r/PTQEaTeU4lv/GJJ4v8GridSYFz08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=da9EiT4s; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=5pKQqLfBTINSnLOUO4PPSoPYAul9k4y7qrDes6Ya/zA=; b=da9EiT4smaqz9J4nKnLz9YIVEw
	wTkXmBPpdWjucPrSppu+46W3tMA/tggdniQKO9ztb3f+JC1cXdVp5ozLGE+x0VO02BB2fHW1hEtCs
	14BRvtpRB3FjgGjcEcPY9Iqqz1eA8854uSb/2gLFihLjtclXOSCQ08s+FlsKszzOUIJU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1svMNC-008eqQ-Lj; Mon, 30 Sep 2024 21:47:58 +0200
Date: Mon, 30 Sep 2024 21:47:58 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>, kuba@kernel.org,
	stefanha@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	mcgrof@kernel.org
Subject: Re: [PATCH v2] vhost/vsock: specify module version
Message-ID: <a4e8d2ac-a303-4c5b-9a1d-3ba6c09d92dc@lunn.ch>
References: <20240929182103.21882-1-aleksandr.mikhalitsyn@canonical.com>
 <w3fc6fwdwaakygtoktjzavm4vsqq2ks3lnznyfcouesuu7cqog@uiq3y4gjj5m3>
 <CAEivzxe6MJWMPCYy1TEkp9fsvVMuoUu-k5XOt+hWg4rKR57qTw@mail.gmail.com>
 <ib52jo3gqsdmr23lpmsipytbxhecwvmjbjlgiw5ygwlbwletlu@rvuyibtxezwl>
 <CAEivzxdP+7q9vDk-0V8tPuCo1mFw92jVx0u3B8jkyYKv8sLcdA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEivzxdP+7q9vDk-0V8tPuCo1mFw92jVx0u3B8jkyYKv8sLcdA@mail.gmail.com>

> > >Hi Stefano,
> > >
> > >>
> > >> I was looking at other commits to see how versioning is handled in order
> > >> to make sense (e.g. using the same version of the kernel), and I saw
> > >> many commits that are removing MODULE_VERSION because they say it
> > >> doesn't make sense in in-tree modules.
> > >
> > >Yeah, I agree absolutely. I guess that's why all vhost modules have
> > >had version 0.0.1 for years now
> > >and there is no reason to increment version numbers at all.
> >
> > Yeah, I see.
> >
> > >
> > >My proposal is not about version itself, having MODULE_VERSION
> > >specified is a hack which
> > >makes a built-in module appear in /sys/modules/ directory.
> >
> > Hmm, should we base a kind of UAPI on a hack?
> 
> Good question ;-)
> 
> >
> > I don't want to block this change, but I just wonder why many modules
> > are removing MODULE_VERSION and we are adding it instead.
> 
> Yep, that's a good point. I didn't know that other modules started to
> remove MODULE_VERSION.

As you said, all over vhost modules say version 0.0.1 for years. But
the kernel around these modules has had many changes. So 0.0.1 tells
you nothing useful. When a user reports a problem using vhost_vsock
version 0.0.1 your first question is going to be, what kernel version
from which distribution?

If the information is useless, let just remove it.

I would not base a kAPI around this. Isn't there a system call you can
perform and get an EOPNOTSUPP, ENODEV, EMORECOFFEE?

Also, at least in networking and probably in other subsystems,
performing an operation is often needed to trigger the module to
load. So it not being listed in /sys/modules does not mean the module
is missing, it could be its just not been needed until now.

Take a step back, what is your real use case here? Describe it and
maybe we can think of a better kAPI.

	Andrew


