Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1817E196CD3
	for <lists+kvm@lfdr.de>; Sun, 29 Mar 2020 13:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgC2LIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 07:08:14 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:46338 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728080AbgC2LIO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 29 Mar 2020 07:08:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585480093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=so6oPgpGKXRDWC0ZEKgrl5SvpE7BFfs77Lp0kYlyQR0=;
        b=SC6WPEQp0f3ORcnUKbLSEGvXjkh4JJ6EDM31OcFwldqecmua3Xcnj7HZdlYXJw+TnFpwFg
        ZXAmHH9tG3iYBPvYQ1fGren30/RhGzN8Xqh2pmQDGwQfKN/O2jzbsQHf9WufZ2y0IpoLZx
        dVEngkv7eHK/FwG01ztnxUVNLdPpNEc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-ppgUogg9N3CMIQqZCvPh3A-1; Sun, 29 Mar 2020 07:07:50 -0400
X-MC-Unique: ppgUogg9N3CMIQqZCvPh3A-1
Received: by mail-wr1-f72.google.com with SMTP id h95so3117590wrh.11
        for <kvm@vger.kernel.org>; Sun, 29 Mar 2020 04:07:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=so6oPgpGKXRDWC0ZEKgrl5SvpE7BFfs77Lp0kYlyQR0=;
        b=MO6G03a2IHfVbZBDXHlkGQw4q3GEmIABUm485xfJ5+HNq0bnUSS1V3TiGuOCe3tg3u
         qCPQjT5LHI/neihtDZiZcTiU8eoF/46S6qcyLTe4RCkfxCSf2Q/F/D4z8xAwoEgektaX
         pwnx1q1c5k7yrcq4tpEnOOMs02tf114bX8bxrB1uHiLDB/lequPIbOCmK9ALLniQ4cv2
         q8zTtxyMutJG3vbpivhiwn1ySoy3zSfj9MCoHN3n90E4ePxtmNsY/HG98raRsv8DX8Nn
         111CBfr+35jarPx9PVfyIrLWd1nZduyeO7PDkZNwuLOzTRyotZi0Dsq+kTVEfOjCBm3n
         5ujw==
X-Gm-Message-State: ANhLgQ2OjMdbiHYs5OglJh3nmzpXME2N4xVqICC3Qsfil3Ed+vvUDW6N
        QZQBF+h7MfaBMUy5KoWsa9J+FRu8BZvuDxQ5ssizGUT87d+JJEx/U+n+kVT6JSwt+Mkup5ZQcQG
        Wjj7C0eAcZoIt
X-Received: by 2002:a05:600c:2294:: with SMTP id 20mr7856661wmf.130.1585480069503;
        Sun, 29 Mar 2020 04:07:49 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtpmHc7q71tZfa52hDIsGADz+VywTxSJQggO2ClhV/khVUbvfqHvN2yv7TOjCs3h8ScGHU9Tg==
X-Received: by 2002:a05:600c:2294:: with SMTP id 20mr7856614wmf.130.1585480069192;
        Sun, 29 Mar 2020 04:07:49 -0700 (PDT)
Received: from redhat.com (bzq-79-183-139-129.red.bezeqint.net. [79.183.139.129])
        by smtp.gmail.com with ESMTPSA id t21sm16054780wmt.43.2020.03.29.04.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 04:07:48 -0700 (PDT)
Date:   Sun, 29 Mar 2020 07:07:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com, gdawar@xilinx.com, saugatm@xilinx.com,
        vmireyno@marvell.com, zhangweining@ruijie.com.cn
Subject: Re: [PATCH V9 0/9] vDPA support
Message-ID: <20200329070130-mutt-send-email-mst@kernel.org>
References: <20200326140125.19794-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326140125.19794-1-jasowang@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 26, 2020 at 10:01:16PM +0800, Jason Wang wrote:
> Hi all:
> 
> This is an update version of vDPA support in kernel.

OK I put these in my next tree, with an eye towards merging them in 5.7.
Many thanks to everyone who reviewed the patches, especially to Jason
Gunthorpe for reviewing multiple versions of the patches, helping locate
and address the issues.


> vDPA device is a device that uses a datapath which complies with the
> virtio specifications with vendor specific control path. vDPA devices
> can be both physically located on the hardware or emulated by
> software. vDPA hardware devices are usually implemented through PCIE
> with the following types:
> 
> - PF (Physical Function) - A single Physical Function
> - VF (Virtual Function) - Device that supports single root I/O
>   virtualization (SR-IOV). Its Virtual Function (VF) represents a
>   virtualized instance of the device that can be assigned to different
>   partitions
> - ADI (Assignable Device Interface) and its equivalents - With
>   technologies such as Intel Scalable IOV, a virtual device (VDEV)
>   composed by host OS utilizing one or more ADIs. Or its equivalent
>   like SF (Sub function) from Mellanox.
> 
> >From a driver's perspective, depends on how and where the DMA
> translation is done, vDPA devices are split into two types:
> 
> - Platform specific DMA translation - From the driver's perspective,
>   the device can be used on a platform where device access to data in
>   memory is limited and/or translated. An example is a PCIE vDPA whose
>   DMA request was tagged via a bus (e.g PCIE) specific way. DMA
>   translation and protection are done at PCIE bus IOMMU level.
> - Device specific DMA translation - The device implements DMA
>   isolation and protection through its own logic. An example is a vDPA
>   device which uses on-chip IOMMU.
> 
> To hide the differences and complexity of the above types for a vDPA
> device/IOMMU options and in order to present a generic virtio device
> to the upper layer, a device agnostic framework is required.
> 
> This series introduces a software vDPA bus which abstracts the
> common attributes of vDPA device, vDPA bus driver and the
> communication method, the bus operations (vdpa_config_ops) between the
> vDPA device abstraction and the vDPA bus driver. This allows multiple
> types of drivers to be used for vDPA device like the virtio_vdpa and
> vhost_vdpa driver to operate on the bus and allow vDPA device could be
> used by either kernel virtio driver or userspace vhost drivers as:
> 
>    virtio drivers  vhost drivers
>           |             |
>     [virtio bus]   [vhost uAPI]
>           |             |
>    virtio device   vhost device
>    virtio_vdpa drv vhost_vdpa drv
>              \       /
>             [vDPA bus]
>                  |
>             vDPA device
>             hardware drv
>                  |
>             [hardware bus]
>                  |
>             vDPA hardware
> 
> virtio_vdpa driver is a transport implementation for kernel virtio
> drivers on top of vDPA bus operations. An alternative is to refactor
> virtio bus which is sub-optimal since the bus and drivers are designed
> to be use by kernel subsystem, a non-trivial major refactoring is
> needed which may impact a brunches of drivers and devices
> implementation inside the kernel. Using a new transport may grealy
> simply both the design and changes.
> 
> vhost_vdpa driver is a new type of vhost device which allows userspace
> vhost drivers to use vDPA devices via vhost uAPI (with minor
> extension). This help to minimize the changes of existed vhost drivers
> for using vDPA devices.
> 
> With the abstraction of vDPA bus and vDPA bus operations, the
> difference and complexity of the under layer hardware is hidden from
> upper layer. The vDPA bus drivers on top can use a unified
> vdpa_config_ops to control different types of vDPA device.
> 
> Two drivers were implemented with the framework introduced in this
> series:
> 
> - Intel IFC VF driver which depends on the platform IOMMU for DMA
>   translation
> - VDPA simulator which is a software test device with an emulated
>   onchip IOMMU
> 
> Future work:
> 
> - direct doorbell mapping support
> - control virtqueue support
> - dirty page tracking support
> - direct interrupt support
> - management API (devlink)
> 
> Please review.
> 
> Thanks
> 
> Changes from V8:
> 
> - switch to use devres for PCI resoureces of IFCVF (Jason)
> - require the caller of vdap_alloc_device() to use "struct foo"
>   instead of foo (Jason)
> - some tweaks on the IFCVF driver
> 
> Changes from V7:
> 
> - refine kconfig to solve the dependency issues on archs that lacks of
>   CONFIG_VIRTUALIZATION (kbuild)
> 
> Changes from V6:
> 
> - vdpa_alloc_device() will allocate parent strcture (Jason)
> - remove the vdpa core dev info in IFCVF patch (Jason)
> - provide a free method in the vdpa bus operations for drivet to free
>   private data
> - switch to use new layout in vdapsim and IFCVF
> - make IFCVF depends on PCI_MSI (kbuild)
> - some tweaks on the IFCVF driver
> 
> Changes from V5:
> 
> - include Intel IFCVF driver and vhost-vdpa drivers
> - add the platform IOMMU support for vhost-vdpa
> - check the return value of dev_set_name() (Jason)
> - various tweaks and fixes
> 
> Changes from V4:
> 
> - use put_device() instead of kfree when fail to register virtio
>   device (Jason)
> - simplify the error handling when allocating vdpasim device (Jason)
> - don't use device_for_each_child() during module exit (Jason)
> - correct the error checking for vdpa_alloc_device() (Harpreet, Lingshan)
> 
> Changes from V3:
> 
> - various Kconfig fixes (Randy)
> 
> Changes from V2:
> 
> - release idr in the release function for put_device() unwind (Jason)
> - don't panic when fail to register vdpa bus (Jason)
> - use unsigned int instead of int for ida (Jason)
> - fix the wrong commit log in virito_vdpa patches (Jason)
> - make vdpa_sim depends on RUNTIME_TESTING_MENU (Michael)
> - provide a bus release function for vDPA device (Jason)
> - fix the wrong unwind when creating devices for vDPA simulator (Jason)
> - move vDPA simulator to a dedicated directory (Lingshan)
> - cancel the work before release vDPA simulator
> 
> Changes from V1:
> 
> - drop sysfs API, leave the management interface to future development
>   (Michael)
> - introduce incremental DMA ops (dma_map/dma_unmap) (Michael)
> - introduce dma_device and use it instead of parent device for doing
>   IOMMU or DMA from bus driver (Michael, Jason, Ling Shan, Tiwei)
> - accept parent device and dma device when register vdpa device
> - coding style and compile fixes (Randy)
> - using vdpa_xxx instead of xxx_vdpa (Jason)
> - ove vDPA accessors to header and make it static inline (Jason)
> - split vdp_register_device() into two helpers vdpa_init_device() and
>   vdpa_register_device() which allows intermediate step to be done (Jason)
> - warn on invalidate queue state when fail to creating virtqueue (Jason)
> - make to_virtio_vdpa_device() static (Jason)
> - use kmalloc/kfree instead of devres for virtio vdpa device (Jason)
> - avoid using cast in vdpa bus function (Jason)
> - introduce module_vdpa_driver and fix module refcnt (Jason)
> - fix returning freed address in vdapsim coherent DMA addr allocation (Dan)
> - various other fixes and tweaks
> 
> V8: https://lkml.org/lkml/2020/3/25/125
> V7: https://lkml.org/lkml/2020/3/24/21
> V6: https://lkml.org/lkml/2020/3/18/88
> V5: https://lkml.org/lkml/2020/2/26/58
> V4: https://lkml.org/lkml/2020/2/20/59
> V3: https://lkml.org/lkml/2020/2/19/1347
> V2: https://lkml.org/lkml/2020/2/9/275
> V1: https://lkml.org/lkml/2020/1/16/353
> 
> Jason Wang (7):
>   vhost: refine vhost and vringh kconfig
>   vhost: allow per device message handler
>   vhost: factor out IOTLB
>   vringh: IOTLB support
>   vDPA: introduce vDPA bus
>   virtio: introduce a vDPA based transport
>   vdpasim: vDPA device simulator
> 
> Tiwei Bie (1):
>   vhost: introduce vDPA-based backend
> 
> Zhu Lingshan (1):
>   virtio: Intel IFC VF driver for VDPA
> 
>  MAINTAINERS                             |   2 +
>  arch/arm/kvm/Kconfig                    |   2 -
>  arch/arm64/kvm/Kconfig                  |   2 -
>  arch/mips/kvm/Kconfig                   |   2 -
>  arch/powerpc/kvm/Kconfig                |   2 -
>  arch/s390/kvm/Kconfig                   |   4 -
>  arch/x86/kvm/Kconfig                    |   4 -
>  drivers/Kconfig                         |   2 +
>  drivers/misc/mic/Kconfig                |   4 -
>  drivers/net/caif/Kconfig                |   4 -
>  drivers/vhost/Kconfig                   |  42 +-
>  drivers/vhost/Kconfig.vringh            |   6 -
>  drivers/vhost/Makefile                  |   6 +
>  drivers/vhost/iotlb.c                   | 177 +++++
>  drivers/vhost/net.c                     |   5 +-
>  drivers/vhost/scsi.c                    |   2 +-
>  drivers/vhost/vdpa.c                    | 883 ++++++++++++++++++++++++
>  drivers/vhost/vhost.c                   | 233 +++----
>  drivers/vhost/vhost.h                   |  45 +-
>  drivers/vhost/vringh.c                  | 421 ++++++++++-
>  drivers/vhost/vsock.c                   |   2 +-
>  drivers/virtio/Kconfig                  |  15 +
>  drivers/virtio/Makefile                 |   2 +
>  drivers/virtio/vdpa/Kconfig             |  37 +
>  drivers/virtio/vdpa/Makefile            |   4 +
>  drivers/virtio/vdpa/ifcvf/Makefile      |   3 +
>  drivers/virtio/vdpa/ifcvf/ifcvf_base.c  | 389 +++++++++++
>  drivers/virtio/vdpa/ifcvf/ifcvf_base.h  | 118 ++++
>  drivers/virtio/vdpa/ifcvf/ifcvf_main.c  | 435 ++++++++++++
>  drivers/virtio/vdpa/vdpa.c              | 180 +++++
>  drivers/virtio/vdpa/vdpa_sim/Makefile   |   2 +
>  drivers/virtio/vdpa/vdpa_sim/vdpa_sim.c | 629 +++++++++++++++++
>  drivers/virtio/virtio_vdpa.c            | 396 +++++++++++
>  include/linux/vdpa.h                    | 253 +++++++
>  include/linux/vhost_iotlb.h             |  47 ++
>  include/linux/vringh.h                  |  36 +
>  include/uapi/linux/vhost.h              |  24 +
>  include/uapi/linux/vhost_types.h        |   8 +
>  38 files changed, 4180 insertions(+), 248 deletions(-)
>  delete mode 100644 drivers/vhost/Kconfig.vringh
>  create mode 100644 drivers/vhost/iotlb.c
>  create mode 100644 drivers/vhost/vdpa.c
>  create mode 100644 drivers/virtio/vdpa/Kconfig
>  create mode 100644 drivers/virtio/vdpa/Makefile
>  create mode 100644 drivers/virtio/vdpa/ifcvf/Makefile
>  create mode 100644 drivers/virtio/vdpa/ifcvf/ifcvf_base.c
>  create mode 100644 drivers/virtio/vdpa/ifcvf/ifcvf_base.h
>  create mode 100644 drivers/virtio/vdpa/ifcvf/ifcvf_main.c
>  create mode 100644 drivers/virtio/vdpa/vdpa.c
>  create mode 100644 drivers/virtio/vdpa/vdpa_sim/Makefile
>  create mode 100644 drivers/virtio/vdpa/vdpa_sim/vdpa_sim.c
>  create mode 100644 drivers/virtio/virtio_vdpa.c
>  create mode 100644 include/linux/vdpa.h
>  create mode 100644 include/linux/vhost_iotlb.h
> 
> -- 
> 2.20.1

