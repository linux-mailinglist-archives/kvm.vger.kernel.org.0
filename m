Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0343BABBA
	for <lists+kvm@lfdr.de>; Sun,  4 Jul 2021 09:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhGDHGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jul 2021 03:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhGDHGV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jul 2021 03:06:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEA4D61410;
        Sun,  4 Jul 2021 07:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625382226;
        bh=b8XVHGyZOCv+C7LBpwt09ABzteCGstaAK7JZyHp9rtg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dD44pccav971s0KZD7H/ju5q1Cj2Sr3P2hJs/LCj3/DrF9P+6vAfRieF6FTGlJbks
         6Oe3p9s/yMrvyK0UTFtfZipXkRDq8bdkEm0faVpFo41soJjQqTg+xfXXK412RbIId5
         4pG5T6C1uGjl0oz31n5Y8AEtiZ1ZvDfYI1w+Y7hJpoisU3BQAVmASs7j7Z2RNzcG76
         BVOuN2QLP32kWh0WHyxGk7ubqvIKbwah38cLKL1dZL4kao2ngIbOYfEkZLHT8w4tyE
         8rdCQP52Y98w/gMlsEzB/6MU2nYb415owoORHRrEkBkYnNq7/iSgXAc3zO/TRQtTuC
         0wSfPrw6TJ+1Q==
Date:   Sun, 4 Jul 2021 10:03:42 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, alex.williamson@redhat.com,
        jgg@nvidia.com, mgurtovoy@nvidia.com, linuxarm@huawei.com,
        liulongfang@huawei.com, prime.zeng@hisilicon.com,
        yuzenghui@huawei.com, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
Message-ID: <YOFdTnlkcDZzw4b/@unreal>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20210702095849.1610-2-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702095849.1610-2-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 02, 2021 at 10:58:46AM +0100, Shameer Kolothum wrote:
> Add a vendor-specific vfio_pci driver for HiSilicon ACC devices.
> This will be extended in follow-up patches to add support for
> vfio live migration feature.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/vfio/pci/Kconfig             |   9 +++
>  drivers/vfio/pci/Makefile            |   2 +
>  drivers/vfio/pci/hisi_acc_vfio_pci.c | 100 +++++++++++++++++++++++++++
>  3 files changed, 111 insertions(+)
>  create mode 100644 drivers/vfio/pci/hisi_acc_vfio_pci.c

<...>

> +static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
> +	.name		= "hisi-acc-vfio-pci",
> +	.open		= hisi_acc_vfio_pci_open,
> +	.release	= vfio_pci_core_release,
> +	.ioctl		= vfio_pci_core_ioctl,
> +	.read		= vfio_pci_core_read,
> +	.write		= vfio_pci_core_write,
> +	.mmap		= vfio_pci_core_mmap,
> +	.request	= vfio_pci_core_request,
> +	.match		= vfio_pci_core_match,
> +	.reflck_attach	= vfio_pci_core_reflck_attach,

I don't remember what was proposed in vfio-pci-core conversion patches,
but would expect that default behaviour is to fallback to vfio_pci_core_* API
if ".release/.ioctl/e.t.c" are not redefined.

Thanks
