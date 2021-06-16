Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62ECF3A9B88
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 15:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhFPNJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 09:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233003AbhFPNJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 09:09:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A880C61166;
        Wed, 16 Jun 2021 13:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623848817;
        bh=l3BVCUTicXiNitfu26Uk7GtYcqn8uOw7hik+5CCmvhg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DKdUNdduS++XEpc7PJqJX2aFVa6EIEVqQeGNKi15vCvZwTMCneifVqOvyMRTNHWWr
         Zf+VxwATaut+GC8lSV94tAx0U8zTg16nkIBd5CNL1HxoUc6e0UvfsdUWy+gLoGQ9y3
         fHcdn/YSuYLHNwJMhO0KjlY62eptk6e5/dQpwcpURcdO84Le0Iwb/hgACEznSGgOuk
         tFl/46MKQEW+L/2II2sRdIMn5cYDscCeG0lOIKuC86bRoSWm88VSxU+EvMxpE99sl5
         N/p8c6niqh8Nk8xF27xToAoWQR/caRJxmIqcYot/NEAb5PTaprAQ5x9+dCrWjzkhDs
         GZSAdbq0/Gg4A==
Date:   Wed, 16 Jun 2021 16:06:52 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] vhost: add vhost_test to Kconfig & Makefile
Message-ID: <YMn3bGIhrMEzguP7@unreal>
References: <20210616120734.1050-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616120734.1050-1-caihuoqing@baidu.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 16, 2021 at 08:07:34PM +0800, Cai Huoqing wrote:
> When running vhost test, make it easier to config
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/vhost/Kconfig  | 12 ++++++++++++
>  drivers/vhost/Makefile |  3 +++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 587fbae06182..c93c12843a6f 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -61,6 +61,18 @@ config VHOST_VSOCK
>         To compile this driver as a module, choose M here: the module will be called
>         vhost_vsock.
>  
> +config VHOST_TEST
> +       tristate "vhost virtio-test driver"
> +       depends on EVENTFD
> +       select VHOST
> +       default n

You don't need to write explicitly "default n". "No" is already default.

Thanks

> +       help
> +       This kernel module can be loaded in the host kernel to test vhost function
> +       with tools/virtio-test.
> +
> +       To compile this driver as a module, choose M here: the module will be called
> +       vhost_test.
> +
>  config VHOST_VDPA
>         tristate "Vhost driver for vDPA-based backend"
>         depends on EVENTFD
> diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> index f3e1897cce85..cf31c1f2652d 100644
> --- a/drivers/vhost/Makefile
> +++ b/drivers/vhost/Makefile
> @@ -8,6 +8,9 @@ vhost_scsi-y := scsi.o
>  obj-$(CONFIG_VHOST_VSOCK) += vhost_vsock.o
>  vhost_vsock-y := vsock.o
>  
> +obj-$(CONFIG_VHOST_TEST) += vhost_test.o
> +vhost_test-y := test.o
> +
>  obj-$(CONFIG_VHOST_RING) += vringh.o
>  
>  obj-$(CONFIG_VHOST_VDPA) += vhost_vdpa.o
> -- 
> 2.22.0
> 
