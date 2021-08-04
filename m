Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5973E042D
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 17:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239064AbhHDP2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 11:28:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239013AbhHDP2M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 11:28:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628090879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LJgh9mjHO8ByFvPxq85k4fwtp10zme6S7oZHzHIV1/k=;
        b=eNG3BYwDbwP/s2sUt8oDBsQ38UHLWNKLxv80NZRhoVpwVCrhGR34w0/hC5+fU+3ANxh61S
        q9DoZ3z8qGg/gKlVlhQTun5953bdJFZxxzU7VDfxV7kFth8ojBALoTrPmN5pFJ6t1iDAIo
        3w9C/R9dCQWV7i/2Bu06RXIy019rU5Y=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-gW22JPONPN6JhmAwFjiwRg-1; Wed, 04 Aug 2021 11:27:58 -0400
X-MC-Unique: gW22JPONPN6JhmAwFjiwRg-1
Received: by mail-ot1-f72.google.com with SMTP id a16-20020a0568300090b02904bbc3b57656so932893oto.9
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 08:27:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LJgh9mjHO8ByFvPxq85k4fwtp10zme6S7oZHzHIV1/k=;
        b=mkzSbfou3DYnR74HgbHJ5PDWrrfb05LsWeULTEtkxWrA6yD2+jblDHQD2s67Zl24cV
         zVcUYD0dTh/c9i7zG5OuJ4Teo85HTivaafMAnNy3LmGRggflpqe5ZbzslHhNPmJ4XNcI
         Iu8GZZiAQ0O7VDLtekZW+Ul9N97iKsu2uJTj3dqRxOZy49C4stu/pkVWEKXGT9TFmeKB
         kLW0RGDUkjOanRtS59ORE+6kyixktuqS3xWOrh51tPGGkSC1NxHkofxeJY/sW81vj1LI
         JNFHhdGQqH+R+BdJPoaJo2rewXsocoPb9Ej606NKpSRXTgjSKD+8a1PKvLxfl0AWzoYr
         +qFQ==
X-Gm-Message-State: AOAM530wnibKGL7QCoTmb8jUxKzu/lB0qmFcqpCnlK2EpO0RD1R0MhOD
        8Bg+M55U7QNEUYg+9m1VbrTnt+9Oq2c98Prq0ih4TMy/oUKFHXzC2W9Ugnu0xlm1lrgHq2wVWTx
        MgLFTF5WgVs7f
X-Received: by 2002:a9d:44e:: with SMTP id 72mr223078otc.100.1628090877865;
        Wed, 04 Aug 2021 08:27:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+ELgNsvSXCAHgSepllsqtC2aa3OhQCzSV6th0yNQiae9HZ8gXcohMgtqXW3cYn9gOCEu4dQ==
X-Received: by 2002:a9d:44e:: with SMTP id 72mr223040otc.100.1628090877509;
        Wed, 04 Aug 2021 08:27:57 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id f3sm463961otc.49.2021.08.04.08.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 08:27:57 -0700 (PDT)
Date:   Wed, 4 Aug 2021 09:27:54 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <maorg@nvidia.com>, <corbet@lwn.net>,
        <michal.lkml@markovi.net>, <bhelgaas@google.com>,
        <diana.craciun@oss.nxp.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <masahiroy@kernel.org>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 00/12] Introduce vfio_pci_core subsystem
Message-ID: <20210804092754.5f15b60e.alex.williamson@redhat.com>
In-Reply-To: <4580c83e-f3b1-0f93-d3ea-dc9cbdf6178d@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
        <4580c83e-f3b1-0f93-d3ea-dc9cbdf6178d@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 4 Aug 2021 16:41:34 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 7/21/2021 7:15 PM, Yishai Hadas wrote:
> > Prologue:
> >
> > This is the second series of three to send the "mlx5_vfio_pci" driver
> > that has been discussed on the list for a while now. It comes on top of
> > the first series (i.e. Reorganize reflck to support splitting vfio_pci)
> > that was sent already and pending merge [1].
> >
> >   - Split vfio_pci into vfio_pci/vfio_pci_core and provide infrastructure
> >     for non-generic VFIO PCI drivers.
> >   - The new driver mlx5_vfio_pci that is a full implementation of
> >     suspend/resume functionality for mlx5 devices.
> >
> > A preview of all the patches can be seen here:
> > https://github.com/jgunthorpe/linux/commits/mlx5_vfio_pci
> >
> > [1] https://lore.kernel.org/dri-devel/0-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com/T/#t
> > =====================
> >
> >  From Max Gurtovoy:
> > ====================
> > This series splits the vfio_pci driver into two parts, a PCI driver and
> > a subsystem driver that will also be library of code. The main PCI
> > driver, vfio_pci.ko, will remain as before and it will use the library
> > module vfio_pci_core.ko to help create the vfio_device.
> >
> > This series is intended to solve the issues that were raised in the
> > previous attempts for extending vfio-pci for device specific
> > functionality:
> >
> > 1. https://lore.kernel.org/kvm/20200518024202.13996-1-yan.y.zhao@intel.com
> >     by Yan Zhao
> > 2. https://lore.kernel.org/kvm/20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com
> >     by Longfang Liu
> >
> > Also to support proposed future changes to virtio and other common
> > protocols to support migration:
> >
> > https://lists.oasis-open.org/archives/virtio-comment/202106/msg00044.html
> >
> > This subsystem framework will also ease adding new device specific
> > functionality to VFIO devices in the future by allowing another module
> > to provide the pci_driver that can setup a number of details before
> > registering to the VFIO subsystem, such as injecting its own operations.
> >
> > This series also extends the "driver_override" mechanism. A flag is
> > added for PCI drivers that will declare themselves as "driver_override"
> > capable which sends their match table to the modules.alias file but
> > otherwise leaves them outside of the normal driver core auto-binding
> > world, like vfio_pci.
> >
> > In order to get the best match for "driver_override" drivers, one can
> > create a userspace program to inspect the modules.alias, an example can
> > be found at:
> >
> > https://github.com/maxgurtovoy/linux_tools/blob/main/vfio/bind_vfio_pci_driver.py
> >
> > Which finds the 'best match' according to a simple algorithm: "the
> > driver with the fewest '*' matches wins."
> >
> > For example, the vfio-pci driver will match to any pci device. So it
> > will have the maximal '*' matches.
> >
> > In case we are looking for a match to a mlx5 based device, we'll have a
> > match to vfio-pci.ko and mlx5-vfio-pci.ko. We'll prefer mlx5-vfio-pci.ko
> > since it will have less '*' matches (probably vendor and device IDs will
> > match). This will work in the future for NVMe/Virtio devices that can
> > match according to a class code or other criteria.
> >
> > Yishai
> >
> >
> > Jason Gunthorpe (2):
> >    vfio: Use select for eventfd
> >    vfio: Use kconfig if XX/endif blocks instead of repeating 'depends on'
> >
> > Max Gurtovoy (9):
> >    vfio/pci: Rename vfio_pci.c to vfio_pci_core.c
> >    vfio/pci: Rename vfio_pci_private.h to vfio_pci_core.h
> >    vfio/pci: Rename vfio_pci_device to vfio_pci_core_device
> >    vfio/pci: Rename ops functions to fit core namings
> >    vfio/pci: Include vfio header in vfio_pci_core.h
> >    vfio/pci: Split the pci_driver code out of vfio_pci_core.c
> >    vfio/pci: Move igd initialization to vfio_pci.c
> >    PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to struct pci_device_id
> >    vfio/pci: Introduce vfio_pci_core.ko
> >
> > Yishai Hadas (1):
> >    vfio/pci: Move module parameters to vfio_pci.c
> >
> >   Documentation/PCI/pci.rst                     |    1 +
> >   drivers/pci/pci-driver.c                      |   25 +-
> >   drivers/vfio/Kconfig                          |   29 +-
> >   drivers/vfio/fsl-mc/Kconfig                   |    3 +-
> >   drivers/vfio/mdev/Kconfig                     |    1 -
> >   drivers/vfio/pci/Kconfig                      |   39 +-
> >   drivers/vfio/pci/Makefile                     |    8 +-
> >   drivers/vfio/pci/vfio_pci.c                   | 2238 +----------------
> >   drivers/vfio/pci/vfio_pci_config.c            |   70 +-
> >   drivers/vfio/pci/vfio_pci_core.c              | 2138 ++++++++++++++++
> >   drivers/vfio/pci/vfio_pci_igd.c               |   19 +-
> >   drivers/vfio/pci/vfio_pci_intrs.c             |   42 +-
> >   drivers/vfio/pci/vfio_pci_rdwr.c              |   18 +-
> >   drivers/vfio/pci/vfio_pci_zdev.c              |    4 +-
> >   drivers/vfio/platform/Kconfig                 |    6 +-
> >   drivers/vfio/platform/reset/Kconfig           |    4 +-
> >   include/linux/mod_devicetable.h               |    7 +
> >   include/linux/pci.h                           |   27 +
> >   .../linux/vfio_pci_core.h                     |   89 +-
> >   scripts/mod/devicetable-offsets.c             |    1 +
> >   scripts/mod/file2alias.c                      |    8 +-
> >   21 files changed, 2496 insertions(+), 2281 deletions(-)
> >   create mode 100644 drivers/vfio/pci/vfio_pci_core.c
> >   rename drivers/vfio/pci/vfio_pci_private.h => include/linux/vfio_pci_core.h (56%)
> >  
> Hi Alex,
> 
> Based on the feedback that we got so far on this series, no functional 
> changes are expected in V2.
> 
> It may include the below minor changes:
> 
> - Drop DRIVER_VERSION as it's useless and not required any more. 
> (Patches #6, #12).
> 
> - Add the sequence of commands/algorithm that is required by userspace 
> to discover the matching driver to the commit message of patch #9.
> 
> Do we need to wait for more feedback or that we are fine to send V2 ?

 - Resolve Kconfig compatibility in patch 12

Patch 9 also depends on an ack from Bjorn, so whether you want to try
to get his buy-in before or after that patch gets updated to clarify
what it's trying to do and why, is up to you.  Thanks,

Alex

