Return-Path: <kvm+bounces-59713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7D3BC91C8
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 14:48:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 266293A8DC5
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 12:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 222272E62B5;
	Thu,  9 Oct 2025 12:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="dwqhE/sO"
X-Original-To: kvm@vger.kernel.org
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97505BA3F;
	Thu,  9 Oct 2025 12:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760014081; cv=none; b=I0GKTdXi0CbKvEGwpS+HsrtBK42NaXrs3mscYrNLp17bFn2rimOO2LU64j6G2kxDaphEu1V/qW1+tZKIubWpBnYui7no8L8BL1UMzTl09f+prI5Ysnw+QZWmGBGlT+FCww//UODymT0grOin0XbSCS3YsDjvLYgvLBl725sWWnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760014081; c=relaxed/simple;
	bh=k8sU+bq8157+OitLUWgTfChNmvNmCTWggeAmvYB82tM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CStjdiWbeIXqZ738s7x5K6kGyDkijMyYrBnQMh7fZja4rNcND6+jKPLd5ZJVcWUDKKEINqi43NMPpJNNRST/5qtEC9KBzB8ekXaH8sh6vhGRlmN+GYVXg0Az8qjtOp8GDH0UhsPmwBPkL2tsWKs7Iu3LbTfhbpeiN1AWxyiuH6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=dwqhE/sO; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=YUpyyd67HoUtnYCpJnUaGRmwxPERukwal2oCb7xHnok=; b=dwqhE/sOu2CR0t52IOWxlfY5hO
	aSQsDujsiN6mqy2x9VjDDh6NR0dCySTEyHlfk3k0OHJKSJiH1vuDgPcZceFZ6LrrxQP8am2QBwurk
	tdUZobfNJCcTMibhLmkTuahZEIEpJuPI+EJYF5yl9oiEMfSUUWFMjKRet3hdrOGrXlyk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1v6q3l-00AWoZ-F0; Thu, 09 Oct 2025 14:47:53 +0200
Date: Thu, 9 Oct 2025 14:47:53 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH 3/3] vhost: use checked versions of VIRTIO_BIT
Message-ID: <d4fcd2d8-ac84-4d9f-a47a-fecc50e18e20@lunn.ch>
References: <cover.1760008797.git.mst@redhat.com>
 <6629538adfd821c8626ab8b9def49c23781e6775.1760008798.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6629538adfd821c8626ab8b9def49c23781e6775.1760008798.git.mst@redhat.com>

On Thu, Oct 09, 2025 at 07:24:16AM -0400, Michael S. Tsirkin wrote:
> This adds compile-time checked versions of VIRTIO_BIT that set bits in
> low and high qword, respectively.  Will prevent confusion when people
> set bits in the wrong qword.
> 
> Cc: "Paolo Abeni" <pabeni@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/net.c             | 4 ++--
>  include/linux/virtio_features.h | 9 +++++++++
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 43d51fb1f8ea..8b98e1a8baaa 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -76,8 +76,8 @@ static const u64 vhost_net_features[VIRTIO_FEATURES_QWORDS] = {
>  	(1ULL << VIRTIO_F_ACCESS_PLATFORM) |
>  	(1ULL << VIRTIO_F_RING_RESET) |
>  	(1ULL << VIRTIO_F_IN_ORDER),
> -	VIRTIO_BIT(VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO) |
> -	VIRTIO_BIT(VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO),
> +	VIRTIO_BIT_HI(VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO) |
> +	VIRTIO_BIT_HI(VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO),

How any bits in vhost_net_features are currently in use? How likely is
it to go from 2x 64bit words to 3x 64 bit words? Rather than _LO, _HI,
would _1ST, _2ND be better leaving it open for _3RD?

I would also be tempted to rename these macros to include _LO_ and
_HI_ in them. VIRTIO_BIT_HI(VIRTIO_LO_F_IN_ORDER) is more likely to be
spotted as wrong this way.

An alternative would be to convert to a linux bitmap, which is
arbitrary length so you just use bit number and leave the
implementation to map that to the correct offset in the underlying
data structure.

	Andrew

