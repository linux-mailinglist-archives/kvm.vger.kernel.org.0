Return-Path: <kvm+bounces-49646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3C9FADBE0D
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 02:20:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66374174B8F
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 00:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35C3190477;
	Tue, 17 Jun 2025 00:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="V94SDnEx"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FC0176242;
	Tue, 17 Jun 2025 00:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750119591; cv=none; b=c0VH/QJf+JQUeURclxaELa6eIrj+eTcDyYIZc3b/YXnDqLbrtXaRWM85JslZHRe++dPVa9PST5bu82Q7bQE7SIQslVaVPTZOpVQMUiQjRMJd9kd4FHFTWHHeJrvvSLmM4uMS57661iTozJt42/lwLupD+d6UzXJjiSZLq2AG9TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750119591; c=relaxed/simple;
	bh=T/Gr48ND3A4WyiBUWW2KmyWwCKVHv9ZtQfX9Zdw6mmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V371qNlzOOiQLeSlJ2gZV8Zyn+Zv+3FPDKH8iokypFtneJSUyHLyrsgsI/3hDyBw/7BxP9qmSuV9rbmehe6lmSFAAqhJe24upSAbgfhNkPvSh855diA21fnPJd5u+HYTuANL6siv2hSZ8sU7fL+mgwasUMMvHfAUgbUV7xMT7tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=V94SDnEx; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=WNzy7vLWmMIYSpR8sckpB3oq8QRaDdGH/cqxGJeGb9k=; b=V94SDnExUvx13/Mk
	5HgHO16yHkhlOdbI2ifJr2ZJp/gLTld1uOYYeE8XtTtJrPqRzKNVHZaAzIIMAm5IyLtDS/J/EH2+N
	zsSUpvRZ/x73H5/x9Vam004vR+8/nMlD2M+lMZ+1tZ1MC7RyUf9yFJVcSaEP2YM8mUayJaAL0Dg7j
	EPF8WYifpznUvaBl8y15yFOAmYziyK+UxD7rosHuhIHXAYdYXPR+P6tbVslB5o72nFJveqxafkIkD
	1sUOO3ynazHMBd5ivYeEM0qtXgisKNcrkQEuCzA8jbD6fuGNVAOK3QP8u/6ARZu+PtFQjGxynFDFW
	6IKVXHTDdSfbQ9x7qw==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1uRK3G-009zqN-06;
	Tue, 17 Jun 2025 00:19:46 +0000
Date: Tue, 17 Jun 2025 00:19:45 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Simon Horman <horms@kernel.org>
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost: vringh: Remove unused functions
Message-ID: <aFC0obkaXV8ercyI@gallifrey>
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
X-Uptime: 00:19:12 up 50 days,  8:32,  1 user,  load average: 0.00, 0.00, 0.00
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
> 
> Otherwise this looks good to me.

V2 sent, see thread starting 20250617001838.114457-1-linux@treblig.org
I checked, gcc doesn't warn me on these!

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

