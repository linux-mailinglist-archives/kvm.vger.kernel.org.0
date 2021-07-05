Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E10C3BC2A0
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 20:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhGESaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 14:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229734AbhGESaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 14:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 806B56196C;
        Mon,  5 Jul 2021 18:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625509662;
        bh=0nqfZ/KCF7agW0Kpzhwp3WsLtkBGdLLdBogUImYWf5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KsgFp+lKiHt/k4fkAhVIoqwJCggTTMjGbRR+FrvV+RqmQCo4CZtV1Dp+lVn4CFDEV
         zzo3PNFMoDpa9tigHnA4Ua+if9XWjM2+tfOanpVSRSXC7Rxy9RFG1qppYTS2RE1COy
         HOVCkF04xQQqBozBWLOfDx9YAXTyWcFJOpNTuxH/nrEBcKrkjDx456P/FfP8fcT8jx
         fA8Y2ife7aViDhAhNbdSckSouwLeAjRkCEPxw8YJcwduBTknvoZAqzVyjv+NyAj8bE
         3WRJwELwyRuRk0ShGzT9e2E9CE8PjZRJcRxEEFfrvlkumIu13KCFlCX33bHNelBs2y
         iJxbEz8b8uG2Q==
Date:   Mon, 5 Jul 2021 21:27:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>, Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
Message-ID: <YONPGcwjGH+gImDj@unreal>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20210702095849.1610-2-shameerali.kolothum.thodi@huawei.com>
 <YOFdTnlkcDZzw4b/@unreal>
 <fc9d6b0b82254fbdb1cc96365b5bdef3@huawei.com>
 <d02dff3a-8035-ced1-7fc3-fcff791f9203@nvidia.com>
 <834a009bba0d4db1b7a1c32e8f20611d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <834a009bba0d4db1b7a1c32e8f20611d@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 05, 2021 at 10:18:59AM +0000, Shameerali Kolothum Thodi wrote:
> 
> 
> > -----Original Message-----
> > From: Max Gurtovoy [mailto:mgurtovoy@nvidia.com]
> > Sent: 05 July 2021 10:42
> > To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> > Leon Romanovsky <leon@kernel.org>
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-crypto@vger.kernel.org; alex.williamson@redhat.com; jgg@nvidia.com;
> > Linuxarm <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>;
> > Zengtao (B) <prime.zeng@hisilicon.com>; yuzenghui
> > <yuzenghui@huawei.com>; Jonathan Cameron
> > <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> > Subject: Re: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for HiSilicon
> > ACC devices
> > 
> > 
> > On 7/5/2021 11:47 AM, Shameerali Kolothum Thodi wrote:
> > >
> > >> -----Original Message-----
> > >> From: Leon Romanovsky [mailto:leon@kernel.org]
> > >> Sent: 04 July 2021 08:04
> > >> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> > >> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > >> linux-crypto@vger.kernel.org; alex.williamson@redhat.com;
> > jgg@nvidia.com;
> > >> mgurtovoy@nvidia.com; Linuxarm <linuxarm@huawei.com>; liulongfang
> > >> <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
> > >> yuzenghui <yuzenghui@huawei.com>; Jonathan Cameron
> > >> <jonathan.cameron@huawei.com>; Wangzhou (B)
> > <wangzhou1@hisilicon.com>
> > >> Subject: Re: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for
> > HiSilicon
> > >> ACC devices
> > >>
> > >> On Fri, Jul 02, 2021 at 10:58:46AM +0100, Shameer Kolothum wrote:
> > >>> Add a vendor-specific vfio_pci driver for HiSilicon ACC devices.
> > >>> This will be extended in follow-up patches to add support for
> > >>> vfio live migration feature.
> > >>>
> > >>> Signed-off-by: Shameer Kolothum
> > >> <shameerali.kolothum.thodi@huawei.com>
> > >>> ---
> > >>>   drivers/vfio/pci/Kconfig             |   9 +++
> > >>>   drivers/vfio/pci/Makefile            |   2 +
> > >>>   drivers/vfio/pci/hisi_acc_vfio_pci.c | 100
> > +++++++++++++++++++++++++++
> > >>>   3 files changed, 111 insertions(+)
> > >>>   create mode 100644 drivers/vfio/pci/hisi_acc_vfio_pci.c
> > >> <...>
> > >>
> > >>> +static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
> > >>> +	.name		= "hisi-acc-vfio-pci",
> > >>> +	.open		= hisi_acc_vfio_pci_open,
> > >>> +	.release	= vfio_pci_core_release,
> > >>> +	.ioctl		= vfio_pci_core_ioctl,
> > >>> +	.read		= vfio_pci_core_read,
> > >>> +	.write		= vfio_pci_core_write,
> > >>> +	.mmap		= vfio_pci_core_mmap,
> > >>> +	.request	= vfio_pci_core_request,
> > >>> +	.match		= vfio_pci_core_match,
> > >>> +	.reflck_attach	= vfio_pci_core_reflck_attach,
> > >> I don't remember what was proposed in vfio-pci-core conversion patches,
> > >> but would expect that default behaviour is to fallback to vfio_pci_core_*
> > API
> > >> if ".release/.ioctl/e.t.c" are not redefined.
> > > Yes, that would be nice, but don't think it does that in latest(v4).
> > >
> > > Hi Max,
> > > Could we please consider fall back to the core defaults, may be check and
> > assign defaults
> > > in vfio_pci_core_register_device() ?
> > 
> > I don't see why we should do this.
> > 
> > vfio_pci_core.ko is just a library driver. It shouldn't decide for the
> > vendor driver ops.
> > 
> > If a vendor driver would like to use its helper functions - great.
> > 
> > If it wants to override it - great.
> > 
> > If it wants to leave some op as NULL - it can do it also.
> 
> Based on the documentation of the vfio_device_ops callbacks,
> It looks like we already have a precedence in the case of reflck_attach
> callback where it uses the vfio core default one, if it is not implemented.

The reflck_attach pattern is pretty common pattern in the kernel to provide fallback.

> 
> Also I would imagine that in majority use cases the vendor drivers will be
> defaulting to core functions. 

Right, this is whole idea of having core functionality in one place, if
vendor wants/needs, he will overwrite.

> 
> I think, in any case, it would be good to update the Documentation based on
> which way we end up doing this.

The request to update Documentation can be seen as an example of
choosing not-good API decisions. Expectation to see all drivers to
use same callbacks with same vfio-core function calls sounds strange
to me.

Thanks

> 
> Thanks,
> Shameer 
> 
>  
> > 
> > 
> > >
> > > Thanks,
> > > Shameer
