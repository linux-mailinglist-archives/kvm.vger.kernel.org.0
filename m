Return-Path: <kvm+bounces-73244-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MJ+SJdGhrWkh5QEAu9opvQ
	(envelope-from <kvm+bounces-73244-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 17:20:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EBB52310E7
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 17:20:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 037423021732
	for <lists+kvm@lfdr.de>; Sun,  8 Mar 2026 16:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CC2D31A07B;
	Sun,  8 Mar 2026 16:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckvrrZMm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F692836B1;
	Sun,  8 Mar 2026 16:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772986819; cv=none; b=HbVrnyGUJeL1n2Mv1h+LJdWXy36KZldLnpPZLpDEVdq+Ugid++sbZUqnpkPQVgEMgCsFxWiVIqYQ/4hzB23YWAPFr8v0pwL8EP6gp3PnTGWykuAkk5JxMwDTLHP+43eO6YdSwIo/12FRF8d7fcFpeWCK4gSswOWb7+fPMEVRrV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772986819; c=relaxed/simple;
	bh=R/Gbmu7EugP+FFr64t/LMc3kWP95ehSCih+5FBcbyjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VKDFBqfgRJCbcAGHjLCchLcjXnHNnnQJgdYo3TxDVlgutZyXeLkNH5ZlT/ou+nxWeESVG+lwNi5cnEZAb3ZeJueeOBxm/d4GjzmOvwosQxydte0kCLa9xl6AlybJy5uJ/nUJ3t3DcmfKwWg9kCkI9NYfVjL6DeFx2YA+N8OBBdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckvrrZMm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211BCC116C6;
	Sun,  8 Mar 2026 16:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772986819;
	bh=R/Gbmu7EugP+FFr64t/LMc3kWP95ehSCih+5FBcbyjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ckvrrZMm35Os36QJd9rp5ICd3u4b+3/KrV6HXgsdtsLADujnDSp7b8tbqXjKsStw6
	 xK2npzP96RH4jjnDl9ZAXRfHrgD5Z6rKCxEy+bdsI7j3oQKF+Bg8WcRfxwQgkYGlGR
	 0xOM1uBO1R09IWyDQgDHqAkAIoVgWxRUj5LAhUnY=
Date: Sun, 8 Mar 2026 17:20:17 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Kirti Wankhede <kwankhede@nvidia.com>,
	"open list:VFIO MEDIATED DEVICE DRIVERS" <kvm@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio: mdev: replace mtty_dev->vd_class with a const
 struct class
Message-ID: <2026030833-encrust-cubical-61c8@gregkh>
References: <20260308133733.1110551-1-jkoolstra@xs4all.nl>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260308133733.1110551-1-jkoolstra@xs4all.nl>
X-Rspamd-Queue-Id: 3EBB52310E7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-73244-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[xs4all.nl];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	NEURAL_SPAM(0.00)[0.258];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+]
X-Rspamd-Action: no action

On Sun, Mar 08, 2026 at 02:37:33PM +0100, Jori Koolstra wrote:
> The class_create() call has been deprecated in favor of class_register()
> as the driver core now allows for a struct class to be in read-only
> memory. Replace mtty_dev->vd_class with a const struct class and drop the
> class_create() call.
> 
> Compile tested and found no errors/warns in dmesg after enabling
> CONFIG_VFIO and CONFIG_SAMPLE_VFIO_MDEV_MTTY.
> 
> Link: https://lore.kernel.org/all/2023040244-duffel-pushpin-f738@gregkh/
> 
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
> ---
>  samples/vfio-mdev/mtty.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index bd92c38379b8..792f5c212fd1 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -68,13 +68,16 @@
>   * Global Structures
>   */
>  
> +static const struct class mtty_class = {
> +	.name	= MTTY_CLASS_NAME
> +};
> +
>  static struct mtty_dev {
> -	dev_t		vd_devt;
> -	struct class	*vd_class;
> -	struct cdev	vd_cdev;
> -	struct idr	vd_idr;
> -	struct device	dev;
> -	struct mdev_parent parent;
> +	dev_t			vd_devt;
> +	struct cdev		vd_cdev;
> +	struct idr		vd_idr;
> +	struct device		dev;
> +	struct mdev_parent	parent;

No need to reformat this structure :(

thanks,

greg k-h

