Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3733D36BF33
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 08:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhD0GVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 02:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhD0GVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 02:21:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09B7D613B4;
        Tue, 27 Apr 2021 06:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619504465;
        bh=rYdc8pFyT7YhX0jVw5dkPFRTs7SVp1HJMn4kd3ZpzEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xvzRQw++N+rLjuj4DtiqNbHi8dtydp2DNUdqBh0lJ/BGfbzK85r0hJN+bt6XHWfYH
         a9QOa1480zrAA+VxJAcz5NtZWBEb7ShoyRP3a3Dm9HDqawWIlyhY7xx9ou7mce2X97
         c/YsqXgm6LniLheJsi7SjU8EUfNKM81MAW7nlhKI=
Date:   Tue, 27 Apr 2021 08:20:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Firas Ashkar <firas.ashkar@savoirfairelinux.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio: uio_pci_generic: add memory mappings
Message-ID: <YIetS88K/xLGHlXB@kroah.com>
References: <20210426190346.173919-1-firas.ashkar@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426190346.173919-1-firas.ashkar@savoirfairelinux.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 26, 2021 at 03:03:46PM -0400, Firas Ashkar wrote:
> import memory resources from underlying pci device, thus allowing
> userspace applications to memory map those resources.

You also did other things in this patch that have nothing to do with
this change, why?

Always describe what your patch does properly, otherwise we have to
ignore it.

> 
> Signed-off-by: Firas Ashkar <firas.ashkar@savoirfairelinux.com>
> ---
> :100644 100644 c7d681fef198 809eca95b5bb M	drivers/uio/uio_pci_generic.c
>  drivers/uio/uio_pci_generic.c | 52 +++++++++++++++++++++++++++++------
>  1 file changed, 43 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
> index c7d681fef198..809eca95b5bb 100644
> --- a/drivers/uio/uio_pci_generic.c
> +++ b/drivers/uio/uio_pci_generic.c
> @@ -24,9 +24,9 @@
>  #include <linux/slab.h>
>  #include <linux/uio_driver.h>
>  
> -#define DRIVER_VERSION	"0.01.0"
> -#define DRIVER_AUTHOR	"Michael S. Tsirkin <mst@redhat.com>"
> -#define DRIVER_DESC	"Generic UIO driver for PCI 2.3 devices"
> +#define DRIVER_VERSION "0.01.0"
> +#define DRIVER_AUTHOR "Michael S. Tsirkin <mst@redhat.com>"
> +#define DRIVER_DESC "Generic UIO driver for PCI 2.3 devices"


Like this, why change these lines???

thanks,

greg k-h
