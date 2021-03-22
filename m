Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC7D3448F4
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 16:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbhCVPNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 11:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231548AbhCVPMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 11:12:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2B9861990;
        Mon, 22 Mar 2021 15:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616425965;
        bh=XaGJOXpYJ2i+MQsioxl6Tg28Kym8UEMe4b4RpcUBm8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I4suPRlqsJeGbJ3kRh4ME6/eP0O/yqXU+Rr96XxgbYcvuIrIDXw4eyoxUAx3shFY3
         EKQL2w6YUEMhzsE51MWi0icihMdRehucbnlG5qw1sdZzfAj/vvYpPzhT2/9Vzwoh7k
         dHoP/0Vx5qwqfEnfs1Yzmdpu1roVfSG7U9Med5yw=
Date:   Mon, 22 Mar 2021 16:12:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: remove the nvlink2 pci_vfio subdriver
Message-ID: <YFiz6sIJluL/u2Cu@kroah.com>
References: <20210322150155.797882-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322150155.797882-1-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021 at 04:01:53PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> the nvlink2 vfio subdriver is a weird beast.  It supports a hardware
> feature without any open source component - what would normally be
> the normal open source userspace that we require for kernel drivers,
> although in this particular case user space could of course be a
> kernel driver in a VM.  It also happens to be a complete mess that
> does not properly bind to PCI IDs, is hacked into the vfio_pci driver
> and also pulles in over 1000 lines of code always build into powerpc
> kernels that have Power NV support enabled.  Because of all these
> issues and the lack of breaking userspace when it is removed I think
> the best idea is to simply kill.
> 
> Diffstat:
>  arch/powerpc/platforms/powernv/npu-dma.c     |  705 ---------------------------
>  b/arch/powerpc/include/asm/opal.h            |    3 
>  b/arch/powerpc/include/asm/pci-bridge.h      |    1 
>  b/arch/powerpc/include/asm/pci.h             |    7 
>  b/arch/powerpc/platforms/powernv/Makefile    |    2 
>  b/arch/powerpc/platforms/powernv/opal-call.c |    2 
>  b/arch/powerpc/platforms/powernv/pci-ioda.c  |  185 -------
>  b/arch/powerpc/platforms/powernv/pci.c       |   11 
>  b/arch/powerpc/platforms/powernv/pci.h       |   17 
>  b/arch/powerpc/platforms/pseries/pci.c       |   23 
>  b/drivers/vfio/pci/Kconfig                   |    6 
>  b/drivers/vfio/pci/Makefile                  |    1 
>  b/drivers/vfio/pci/vfio_pci.c                |   18 
>  b/drivers/vfio/pci/vfio_pci_private.h        |   14 
>  b/include/uapi/linux/vfio.h                  |   40 -
>  drivers/vfio/pci/vfio_pci_nvlink2.c          |  490 ------------------
>  16 files changed, 8 insertions(+), 1517 deletions(-)

I thought this was supposed to be removed a few years ago!

Anyway, no objection from me:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
