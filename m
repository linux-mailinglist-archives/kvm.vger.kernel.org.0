Return-Path: <kvm+bounces-49616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F363ADB227
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 15:38:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C33117175E
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 13:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D0442DBF47;
	Mon, 16 Jun 2025 13:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="CUEIRWA7"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC341E501C;
	Mon, 16 Jun 2025 13:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750080833; cv=none; b=YxzJpd5x3p/b+9+Bsy1lKd5utuPPGw2mCASqgsaBqEco8ou9FGypBGxjKc7xdm9KqFB01MpxfANkpC3oxphEdhKfvk74cgJvnuZ5WiGQQcQsAIWpwlesP3pLMZNYnzNttf9RGE3f6CyyOzgs7kiPdfN7loA2Z1TxO1loGo3By7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750080833; c=relaxed/simple;
	bh=7Uh4wl+bZxAYid7tD4CNjfoTXFtY0GZCB/chxZADp1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qDSTMatRujwp1Ard0nuYqT/v2OcIYynHEsDjBB/GOWQnGjDdS+Mt2tv+GaKI6QEoC6w/sDEVeoBSV9wRW2G79GWN6UumNe0YaC6vJbrlrSBMNdVBMPfQ9KzeZVOGYUKU9ZLK/xh3nOBrab9t2eYW69qoOmtHrEG71+AgCCog4bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=CUEIRWA7; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=PedyKYKxhVciA5XH7zSyFmdlhe3gfVvHTDTykvt9wJk=; b=CUEIRWA7RI01UnQc
	ha/ApfjNN+QMKMoNSDTR891qol3XLFV9ArOT2a+XYIqSmL96ADkTXaHhc0NHCgUjRU0yoxadA5yFp
	saMv90HrpLA4I/2BXSbMBVW6GwX5U/ZyRMRIWuIwLWa1qMxQTrqgz2B1LUM3wYe9i1yUXvBNtXrPJ
	mvTttXYzTqADrr2QkXYwPz/fcdhup6bUqEyfN/mB+S9kKokvm13026cio2YorxA0GAnpWKyiP1NqI
	xrxm/Seq7gEPH5uk4V3WHRu8f7L9cSIQDw1k8WHDhaL8/nK5u4j0dMgQsrFgw3wIjyuZ77lxj1V0w
	Ul9DMSQnQbJ8eX2xtQ==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1uR9y1-009sVi-1O;
	Mon, 16 Jun 2025 13:33:41 +0000
Date: Mon, 16 Jun 2025 13:33:41 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Simon Horman <horms@kernel.org>
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost: vringh: Remove unused functions
Message-ID: <aFAdNYuBwMuluWBf@gallifrey>
References: <20250613230731.573512-1-linux@treblig.org>
 <20250613230731.573512-3-linux@treblig.org>
 <20250616131548.GB4750@horms.kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20250616131548.GB4750@horms.kernel.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-34-amd64 (x86_64)
X-Uptime: 13:33:13 up 49 days, 21:46,  1 user,  load average: 0.00, 0.01, 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* Simon Horman (horms@kernel.org) wrote:
> On Sat, Jun 14, 2025 at 12:07:31AM +0100, linux@treblig.org wrote:
> > From: "Dr. David Alan Gilbert" <linux@treblig.org>
> > 
> > The functions:
> >   vringh_abandon_kern()
> >   vringh_abandon_user()
> >   vringh_iov_pull_kern() and
> >   vringh_iov_push_kern()
> > were all added in 2013 by
> > commit f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> > but have remained unused.
> > 
> > Remove them.
> > 
> > Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> 
> Hi David,
> 
> With this patch (set) applied vlang flags the following.
> So I guess that xfer_kern can be removed too.
> 
>   .../vringh.c:887:19: warning: unused function 'xfer_kern' [-Wunused-function]
>     887 | static inline int xfer_kern(const struct vringh *vrh, void *src,
>         |                   ^~~~~~~~~
>   .../vringh.c:894:19: warning: unused function 'kern_xfer' [-Wunused-function]
>     894 | static inline int kern_xfer(const struct vringh *vrh, void *dst,
>         |                   ^~~~~~~~~

Oops, thanks - I should have spotted that; I'll check on it and repost.

> Otherwise this looks good to me.

Thanks for the reviews,

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

