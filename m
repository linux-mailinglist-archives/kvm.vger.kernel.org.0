Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B073DB4B7
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 09:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237961AbhG3HxL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 30 Jul 2021 03:53:11 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:12426 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhG3HxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 03:53:10 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GbfgK4T8pzcfbV;
        Fri, 30 Jul 2021 15:49:33 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 30 Jul 2021 15:53:03 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 30 Jul 2021 15:53:02 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2176.012; Fri, 30 Jul 2021 08:53:00 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>
CC:     "aviadye@nvidia.com" <aviadye@nvidia.com>,
        "oren@nvidia.com" <oren@nvidia.com>,
        "shahafs@nvidia.com" <shahafs@nvidia.com>,
        "parav@nvidia.com" <parav@nvidia.com>,
        "artemp@nvidia.com" <artemp@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "ACurrid@nvidia.com" <ACurrid@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "targupta@nvidia.com" <targupta@nvidia.com>,
        liulongfang <liulongfang@huawei.com>,
        "yan.y.zhao@intel.com" <yan.y.zhao@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>
Subject: RE: [RFC PATCH v4 00/11] Introduce vfio-pci-core subsystem
Thread-Topic: [RFC PATCH v4 00/11] Introduce vfio-pci-core subsystem
Thread-Index: AQHXWJLMh7u8kEfBQ0qOr84q2/p5ratbfFiw
Date:   Fri, 30 Jul 2021 07:53:00 +0000
Message-ID: <01765c3bb55f48cf866dc3732a483eff@huawei.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
In-Reply-To: <20210603160809.15845-1-mgurtovoy@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.81.115]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Max/ Yishai,

(Sorry I picked this thread instead of the [1] here as I don't have that
in my mailbox)

I see that an update to this series has been posted by Yishai [1] and it mentions
about a branch with all relevant patches,

" A preview of all the patches can be seen here:
https://github.com/jgunthorpe/linux/commits/mlx5_vfio_pci"

But sorry I couldn't find the patches in the branch above. Could you
please check and let me know.

Thanks,
Shameer

[1] https://lore.kernel.org/kvm/20210721161609.68223-1-yishaih@nvidia.com/#R


> -----Original Message-----
> From: Max Gurtovoy [mailto:mgurtovoy@nvidia.com]
> Sent: 03 June 2021 17:08
> To: alex.williamson@redhat.com; cohuck@redhat.com; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org; jgg@nvidia.com
> Cc: aviadye@nvidia.com; oren@nvidia.com; shahafs@nvidia.com;
> parav@nvidia.com; artemp@nvidia.com; kwankhede@nvidia.com;
> ACurrid@nvidia.com; cjia@nvidia.com; yishaih@nvidia.com;
> kevin.tian@intel.com; hch@infradead.org; targupta@nvidia.com; Shameerali
> Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>; liulongfang
> <liulongfang@huawei.com>; yan.y.zhao@intel.com; Max Gurtovoy
> <mgurtovoy@nvidia.com>
> Subject: [RFC PATCH v4 00/11] Introduce vfio-pci-core subsystem
> 
> Hi Alex, Cornelia, Jason and Co,
> 
> This series split the vfio_pci driver into 2 parts: pci drivers and a
> subsystem driver that will also be library of code. The main pci driver,
> vfio_pci.ko will be used as before and it will bind to the subsystem
> driver vfio_pci_core.ko to register to the VFIO subsystem.
> 
> This series is coming to solve some of the issues that were raised in
> the previous attempts for extending vfio-pci for vendor specific
> functionality:
> 1. https://lkml.org/lkml/2020/5/17/376 by Yan Zhao.
> 2. https://www.spinics.net/lists/kernel/msg3903996.html by Longfang Liu
> 
> This subsystem framework will also ease on adding new vendor specific
> functionality to VFIO devices in the future by allowing another module
> to provide the pci_driver that can setup number of details before
> registering to VFIO subsystem (such as inject its own operations).
> 
> This series also extends the "driver_override" mechanism. We added a flag
> for pci drivers that will declare themselves as "driver_override" capable
> and only declared drivers can use this mechanism in the PCI subsystem.
> Other drivers will not be able to bind to devices that use "driver_override".
> Also, the PCI driver matching will always look for ID table and will never
> generate dummy "match_all" ID table in the PCI subsystem layer. In this
> way, we ensure deterministic behaviour with no races with the original
> pci drivers. In order to get the best match for "driver_override" drivers,
> one can create a userspace program (example can be found at
> https://github.com/maxgurtovoy/linux_tools/blob/main/vfio/bind_vfio_pci_dr
> iver.py)
> that find the 'best match' according to simple algorithm: "the driver
> with the fewest '*' matches wins."
> For example, the vfio-pci driver will match to any pci device. So it
> will have the maximal '*' matches (for all matching IDs: vendor, device,
> subvendor, ...).
> In case we are looking for a match to mlx5 based device, we'll have a
> match to vfio-pci.ko and mlx5-vfio-pci.ko. We'll prefer mlx5-vfio-pci.ko
> since it will have less '*' matches (probably vendor and device IDs will
> match). This will work in the future for NVMe/Virtio devices that can
> match according to a class code or other criteria.
> 
> The main goal of this series is to agree on the vfio_pci module split and the
> "driver_override" extensions. The follow-up version will include an extended
> mlx5_vfio_pci driver that will support VF suspend/resume as well.
> 
> This series applied cleanly on top of vfio reflck re-design (still haven't sent
> for review) and can be found at:
> https://github.com/Mellanox/NVMEoF-P2P/tree/vfio-v4-external.
> 
> Max Gurtovoy (11):
>   vfio-pci: rename vfio_pci.c to vfio_pci_core.c
>   vfio-pci: rename vfio_pci_private.h to vfio_pci_core.h
>   vfio-pci: rename vfio_pci_device to vfio_pci_core_device
>   vfio-pci: rename ops functions to fit core namings
>   vfio-pci: include vfio header in vfio_pci_core.h
>   vfio-pci: introduce vfio_pci.c
>   vfio-pci: move igd initialization to vfio_pci.c
>   PCI: add flags field to pci_device_id structure
>   PCI: add matching checks for driver_override binding
>   vfio-pci: introduce vfio_pci_core subsystem driver
>   mlx5-vfio-pci: add new vfio_pci driver for mlx5 devices
> 
>  Documentation/ABI/testing/sysfs-bus-pci       |    6 +-
>  Documentation/PCI/pci.rst                     |    1 +
>  drivers/pci/pci-driver.c                      |   22 +-
>  drivers/vfio/pci/Kconfig                      |   27 +-
>  drivers/vfio/pci/Makefile                     |   12 +-
>  drivers/vfio/pci/mlx5_vfio_pci.c              |  130 +
>  drivers/vfio/pci/vfio_pci.c                   | 2329 +----------------
>  drivers/vfio/pci/vfio_pci_config.c            |   70 +-
>  drivers/vfio/pci/vfio_pci_core.c              | 2239 ++++++++++++++++
>  drivers/vfio/pci/vfio_pci_igd.c               |   16 +-
>  drivers/vfio/pci/vfio_pci_intrs.c             |   42 +-
>  drivers/vfio/pci/vfio_pci_rdwr.c              |   18 +-
>  drivers/vfio/pci/vfio_pci_zdev.c              |    4 +-
>  include/linux/mod_devicetable.h               |    9 +
>  include/linux/pci.h                           |   27 +
>  .../linux/vfio_pci_core.h                     |   93 +-
>  scripts/mod/devicetable-offsets.c             |    1 +
>  scripts/mod/file2alias.c                      |    8 +-
>  18 files changed, 2695 insertions(+), 2359 deletions(-)
>  create mode 100644 drivers/vfio/pci/mlx5_vfio_pci.c
>  create mode 100644 drivers/vfio/pci/vfio_pci_core.c
>  rename drivers/vfio/pci/vfio_pci_private.h => include/linux/vfio_pci_core.h
> (56%)
> 
> --
> 2.21.0

