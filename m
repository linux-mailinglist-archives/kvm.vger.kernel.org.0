Return-Path: <kvm+bounces-49752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53C63ADDB8A
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 20:40:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D645162F48
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94DDC2F2711;
	Tue, 17 Jun 2025 18:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UgA1BsRe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4E427FD58;
	Tue, 17 Jun 2025 18:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750185465; cv=none; b=RDYQVxnaWq5xoGkApK0k2qGaD59cyqHxMPC1dTVGpSPsjGjbHgBrEdg1X3VgBajG4xzHGekL/4Ji6a77F9EZD3PZTVoBrRBW0KjsidztKnvKSH0n19eSUTMGNSUcaanXyRzTrwFN8RXtaj0bQfkIAl/JeEbp+7LpdJ0mhS4LbE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750185465; c=relaxed/simple;
	bh=vRMXvV+hLCzXEsUSwZA8PSD9NUAJa8mnTAp20kjQkRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GnG0N2lbw+xs0X2ui57dXdvCdF2BpaavOcftOeQM3gZrougyC7io7zIKAnIX9Ux3H+ENaicvPATIM1Yzl2yM5EflHttqRx754rpfSBsGTTKOito+O14Tnr7XZbSrKeb9cx0qjC2ymHeBEgejbalknh92mBZBRPkanOUOeQ8fSc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UgA1BsRe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71789C4CEE3;
	Tue, 17 Jun 2025 18:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750185465;
	bh=vRMXvV+hLCzXEsUSwZA8PSD9NUAJa8mnTAp20kjQkRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UgA1BsRerfxN1gGACB6pt6pwpd34FDWN8FKswypZJOPhnPDoROdTihb2z+YeXW/q1
	 vdmyMtB5Xw7Dx6co34CzG+cM6Ponw/6icj8oX5vVxzhZNXh90JGp1giqODr2TE2co3
	 zHTiIbPMLD/VMwtD7PFDywixHfk5xj2QSj7v8ElLItRXf1LP0tMD4LLWTg/U6FCcVk
	 ZPyqFJ+5d88PnS576TwDygUdR5zPVcejidc6hNQWSXCgI+CcmqAWN8CkF4CPO1eB2W
	 ZUGrBuQd417Chv1Dnyjd5TcvAtELZySs7k6VxZuDqG9Jdo2MZunBsnFrNAWsH+Hgok
	 NXLhlkucdIQlA==
Date: Tue, 17 Jun 2025 19:37:41 +0100
From: Simon Horman <horms@kernel.org>
To: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost: Fix typos in comments and clarity on alignof usage
Message-ID: <20250617183741.GD2545@horms.kernel.org>
References: <20250615173933.1610324-1-alok.a.tiwari@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250615173933.1610324-1-alok.a.tiwari@oracle.com>

On Sun, Jun 15, 2025 at 10:39:11AM -0700, Alok Tiwari wrote:
> This patch fixes multiple typos and improves comment clarity across
> vhost.c.
> - Correct spelling errors: "thead" -> "thread", "RUNNUNG" -> "RUNNING"
>   and "available".
> - Improve comment by replacing informal comment ("Supersize me!")
>   with a clear description.
> - Use __alignof__ correctly on dereferenced pointer types for better
>   readability and alignment with kernel documentation.

Could you expand on the last point?
I see that the patch uses __alignof__ with rather than without parentheses.
But I don't follow how that corresponds with the comment above.

> 
> These changes enhance code readability and maintainability.
> 
> Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>

...

> @@ -1898,8 +1898,8 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
>  		return -EFAULT;
>  
>  	/* Make sure it's safe to cast pointers to vring types. */
> -	BUILD_BUG_ON(__alignof__ *vq->avail > VRING_AVAIL_ALIGN_SIZE);
> -	BUILD_BUG_ON(__alignof__ *vq->used > VRING_USED_ALIGN_SIZE);
> +	BUILD_BUG_ON(__alignof__(*vq->avail) > VRING_AVAIL_ALIGN_SIZE);
> +	BUILD_BUG_ON(__alignof__(*vq->used) > VRING_USED_ALIGN_SIZE);
>  	if ((a.avail_user_addr & (VRING_AVAIL_ALIGN_SIZE - 1)) ||
>  	    (a.used_user_addr & (VRING_USED_ALIGN_SIZE - 1)) ||
>  	    (a.log_guest_addr & (VRING_USED_ALIGN_SIZE - 1)))

...

