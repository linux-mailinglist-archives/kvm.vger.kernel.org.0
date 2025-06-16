Return-Path: <kvm+bounces-49614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12683ADB185
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 15:18:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D03E3B676E
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 13:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D095B2DF3E1;
	Mon, 16 Jun 2025 13:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PMTgw/2S"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FFB78F32;
	Mon, 16 Jun 2025 13:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750079753; cv=none; b=SfUP3jejDVdRP38uBRFK2KWc3Lsz0jAz/R+Y/7Ef5i8v8eKf1rtFpaYTshGp1Sh2rK+RXiOo+53mFIGUbNTl303Hxw9IM9vQ31883VeCeRfgkJV5zE8iLqx2bc5ZALM+J8UWUJEcNGWD0wxBSXqP/I1e2dWo3TTu+OXVb/sXQVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750079753; c=relaxed/simple;
	bh=FcobA1ZgRW244HLglcAveoXdgDqTrSjmOKZagUH5/u8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gJPoRWbi9fGmBj26skJWjktL/Zpn24ygPR8tmPKjyYnTMU+Lq4lK10znsOQGwqgV16hBvnPlHDLTvVuCW4AwCuP9xmwLXaH1iA7Jzz1sJflSCAckyeF+7aUtbLVEDM9OgRmzyNMiDNys6LOUn0ndPa99+bTrnWAwusk54uewwq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PMTgw/2S; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9754FC4CEEA;
	Mon, 16 Jun 2025 13:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750079752;
	bh=FcobA1ZgRW244HLglcAveoXdgDqTrSjmOKZagUH5/u8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PMTgw/2S11ARv/CXzZhr6fRYAYsuyvxKNC4sMsYVFgT/e9QHfWf7h0ipGpgvBdyan
	 piN9X5ddvHw41qjgPagUmKpwvhJ2t7Fhr9Ymki4Hpq/0zKg/Y3yk8wf3uUQuxOw1xs
	 QhYQKtO6zmk8WEJjq9X8xxqBMm52j5THlSys0I1DPr90ynQIbJlrkWMGOKsv6funtI
	 eCdaQXoLCPZjSoYHNzdMkNlsdre4Qdbt1kqmvaLOp0TQ5k78szFe0ipE4JEPDo7/ac
	 z4QSTnxxkDAvzCwdBIWKtBNJ9JjvazsX2xFbzyV/UeJO27A4gnAKmPz8JKCYgLAAXc
	 32+BtuuIKP9AQ==
Date: Mon, 16 Jun 2025 14:15:48 +0100
From: Simon Horman <horms@kernel.org>
To: linux@treblig.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost: vringh: Remove unused functions
Message-ID: <20250616131548.GB4750@horms.kernel.org>
References: <20250613230731.573512-1-linux@treblig.org>
 <20250613230731.573512-3-linux@treblig.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613230731.573512-3-linux@treblig.org>

On Sat, Jun 14, 2025 at 12:07:31AM +0100, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> The functions:
>   vringh_abandon_kern()
>   vringh_abandon_user()
>   vringh_iov_pull_kern() and
>   vringh_iov_push_kern()
> were all added in 2013 by
> commit f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> but have remained unused.
> 
> Remove them.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Hi David,

With this patch (set) applied vlang flags the following.
So I guess that xfer_kern can be removed too.

  .../vringh.c:887:19: warning: unused function 'xfer_kern' [-Wunused-function]
    887 | static inline int xfer_kern(const struct vringh *vrh, void *src,
        |                   ^~~~~~~~~
  .../vringh.c:894:19: warning: unused function 'kern_xfer' [-Wunused-function]
    894 | static inline int kern_xfer(const struct vringh *vrh, void *dst,
        |                   ^~~~~~~~~

Otherwise this looks good to me.

