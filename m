Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5276F1C79BB
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 20:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbgEFS5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 14:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728142AbgEFS53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 14:57:29 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A814C061A0F
        for <kvm@vger.kernel.org>; Wed,  6 May 2020 11:57:29 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e26so3701637wmk.5
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 11:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WVXFa/Ih8rhQRBzuo6JtPiH45Ty8rPU5DLOU2EGBzig=;
        b=Rn7Tr9nBLuXRSd6jud3gci9DBsFUfdSUupgw/VnvsFn6RntPjO4dfFR7jDbhy3jn7s
         0gQi6/YhBMueg8mGnnf/eixavS7YSw9sgYT/t3NHN+YtAlM3KGmpA2qyiNfQO81/Gtrb
         vdOYlZ7uYObGMeX3dBm0nHF/Am1dP9FIA1OLg+io+H6LiIxpdNVZ/8RBDs2XvHJii2Zp
         /AtoHb6M9ThEQaglfMLdXZTrQrz0y5ciKCOy/IzqpDbXMJdIBU+GsLraspg8zFYwsQZJ
         NTW46hDQOyfZP+c1xP6wg7TZM61wR7QyGvlH5sEzV0QAtCIGj12QngO6x16dW8e+xGLv
         THNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WVXFa/Ih8rhQRBzuo6JtPiH45Ty8rPU5DLOU2EGBzig=;
        b=PB1EG4hlXl1dHPW0oZDmjCevlGqFQaYEVE8XHhIOq72DK4ZEZBFcsMmFGfRe7/s/GR
         K/qx3hJgoJvv7IXSeaQ1Ec+8k5g1oKhoLQi7sy74frjb8oX/+i2PfsDgMlECmueicPbl
         YthlbuH8l7Vhd5Er/KYJOfLIyQBFondAU6sNfNI5MPnbycxeVReAo2qWWYg+ya+LUoEV
         BP8uDqK2EYRDwHFpJZC0BvOIsu/YUTRlueeTQlhgcfWLaXZqs0CoE1yi5jvQkCxQmB0A
         ivJYc/mKZpFBtF+wX3rhDn81uZ92T52m+qjB2wwscFAGymIalc40RgLWpjwH9uOttBUY
         NFdw==
X-Gm-Message-State: AGi0Pua3PrUVNIGDX7YlzXoP5WmjJHRngDdj1+uJGrw8TS2lmM46NVYE
        ZH2shgWxP82MeK3UqGUkWwnTu7KRuGRUMUi21Js=
X-Google-Smtp-Source: APiQypLhcud8MP8CSdZJaxnEHMHoAmtleMZUO8gIQZY5EYQVFvnEPMt4xGby0ZFI+FIzZSM1C7WN8zKj1wjI8z2AGh4=
X-Received: by 2002:a1c:3c08:: with SMTP id j8mr5917736wma.30.1588791447879;
 Wed, 06 May 2020 11:57:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200506094948.76388-1-david@redhat.com> <20200506094948.76388-12-david@redhat.com>
In-Reply-To: <20200506094948.76388-12-david@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Wed, 6 May 2020 20:57:16 +0200
Message-ID: <CAM9Jb+g-mFxY+seJAPcpdavSW-_XicFbq+xfk6nis4otUQZ4VQ@mail.gmail.com>
Subject: Re: [PATCH v1 11/17] virtio-pci: Proxy for virtio-mem
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Let's add a proxy for virtio-mem, make it a memory device, and
> pass-through the properties.
>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Cc: Igor Mammedov <imammedo@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  hw/virtio/Makefile.objs    |   1 +
>  hw/virtio/virtio-mem-pci.c | 131 +++++++++++++++++++++++++++++++++++++
>  hw/virtio/virtio-mem-pci.h |  33 ++++++++++
>  include/hw/pci/pci.h       |   1 +
>  4 files changed, 166 insertions(+)
>  create mode 100644 hw/virtio/virtio-mem-pci.c
>  create mode 100644 hw/virtio/virtio-mem-pci.h
>
> diff --git a/hw/virtio/Makefile.objs b/hw/virtio/Makefile.objs
> index 7df70e977e..b9661f9c01 100644
> --- a/hw/virtio/Makefile.objs
> +++ b/hw/virtio/Makefile.objs
> @@ -19,6 +19,7 @@ obj-$(call land,$(CONFIG_VHOST_USER_FS),$(CONFIG_VIRTIO_PCI)) += vhost-user-fs-p
>  obj-$(CONFIG_VIRTIO_IOMMU) += virtio-iommu.o
>  obj-$(CONFIG_VHOST_VSOCK) += vhost-vsock.o
>  obj-$(CONFIG_VIRTIO_MEM) += virtio-mem.o
> +common-obj-$(call land,$(CONFIG_VIRTIO_MEM),$(CONFIG_VIRTIO_PCI)) += virtio-mem-pci.o
>
>  ifeq ($(CONFIG_VIRTIO_PCI),y)
>  obj-$(CONFIG_VHOST_VSOCK) += vhost-vsock-pci.o
> diff --git a/hw/virtio/virtio-mem-pci.c b/hw/virtio/virtio-mem-pci.c
> new file mode 100644
> index 0000000000..a47d21c81f
> --- /dev/null
> +++ b/hw/virtio/virtio-mem-pci.c
> @@ -0,0 +1,131 @@
> +/*
> + * Virtio MEM PCI device
> + *
> + * Copyright (C) 2020 Red Hat, Inc.
> + *
> + * Authors:
> + *  David Hildenbrand <david@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.
> + * See the COPYING file in the top-level directory.
> + */
> +
> +#include "qemu/osdep.h"
> +
Don't think we need the blank line here.

> +#include "virtio-mem-pci.h"
> +#include "hw/mem/memory-device.h"
> +#include "qapi/error.h"
> +
> +static void virtio_mem_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
> +{
> +    VirtIOMEMPCI *mem_pci = VIRTIO_MEM_PCI(vpci_dev);
> +    DeviceState *vdev = DEVICE(&mem_pci->vdev);
> +
> +    qdev_set_parent_bus(vdev, BUS(&vpci_dev->bus));
> +    object_property_set_bool(OBJECT(vdev), true, "realized", errp);
> +}
> +
> +static void virtio_mem_pci_set_addr(MemoryDeviceState *md, uint64_t addr,
> +                                    Error **errp)
> +{
> +    object_property_set_uint(OBJECT(md), addr, VIRTIO_MEM_ADDR_PROP, errp);
> +}
> +
> +static uint64_t virtio_mem_pci_get_addr(const MemoryDeviceState *md)
> +{
> +    return object_property_get_uint(OBJECT(md), VIRTIO_MEM_ADDR_PROP,
> +                                    &error_abort);
> +}
> +
> +static MemoryRegion *virtio_mem_pci_get_memory_region(MemoryDeviceState *md,
> +                                                      Error **errp)
> +{
> +    VirtIOMEMPCI *pci_mem = VIRTIO_MEM_PCI(md);
> +    VirtIOMEM *vmem = VIRTIO_MEM(&pci_mem->vdev);
> +    VirtIOMEMClass *vmc = VIRTIO_MEM_GET_CLASS(vmem);
> +
> +    return vmc->get_memory_region(vmem, errp);
> +}
> +
> +static uint64_t virtio_mem_pci_get_plugged_size(const MemoryDeviceState *md,
> +                                                Error **errp)
> +{
> +    return object_property_get_uint(OBJECT(md), VIRTIO_MEM_SIZE_PROP,
> +                                    errp);
> +}
> +
> +static void virtio_mem_pci_fill_device_info(const MemoryDeviceState *md,
> +                                            MemoryDeviceInfo *info)
> +{
> +    VirtioMEMDeviceInfo *vi = g_new0(VirtioMEMDeviceInfo, 1);
> +    VirtIOMEMPCI *pci_mem = VIRTIO_MEM_PCI(md);
> +    VirtIOMEM *vmem = VIRTIO_MEM(&pci_mem->vdev);
> +    VirtIOMEMClass *vpc = VIRTIO_MEM_GET_CLASS(vmem);
> +    DeviceState *dev = DEVICE(md);
> +
> +    if (dev->id) {
> +        vi->has_id = true;
> +        vi->id = g_strdup(dev->id);
> +    }
> +
> +    /* let the real device handle everything else */
> +    vpc->fill_device_info(vmem, vi);
> +
> +    info->u.virtio_mem.data = vi;
> +    info->type = MEMORY_DEVICE_INFO_KIND_VIRTIO_MEM;
> +}
> +
> +static void virtio_mem_pci_class_init(ObjectClass *klass, void *data)
> +{
> +    DeviceClass *dc = DEVICE_CLASS(klass);
> +    VirtioPCIClass *k = VIRTIO_PCI_CLASS(klass);
> +    PCIDeviceClass *pcidev_k = PCI_DEVICE_CLASS(klass);
> +    MemoryDeviceClass *mdc = MEMORY_DEVICE_CLASS(klass);
> +
> +    k->realize = virtio_mem_pci_realize;
> +    set_bit(DEVICE_CATEGORY_MISC, dc->categories);
> +    pcidev_k->vendor_id = PCI_VENDOR_ID_REDHAT_QUMRANET;
> +    pcidev_k->device_id = PCI_DEVICE_ID_VIRTIO_MEM;
> +    pcidev_k->revision = VIRTIO_PCI_ABI_VERSION;
> +    pcidev_k->class_id = PCI_CLASS_OTHERS;
> +
> +    mdc->get_addr = virtio_mem_pci_get_addr;
> +    mdc->set_addr = virtio_mem_pci_set_addr;
> +    mdc->get_plugged_size = virtio_mem_pci_get_plugged_size;
> +    mdc->get_memory_region = virtio_mem_pci_get_memory_region;
> +    mdc->fill_device_info = virtio_mem_pci_fill_device_info;
> +}
> +
> +static void virtio_mem_pci_instance_init(Object *obj)
> +{
> +    VirtIOMEMPCI *dev = VIRTIO_MEM_PCI(obj);
> +
> +    virtio_instance_init_common(obj, &dev->vdev, sizeof(dev->vdev),
> +                                TYPE_VIRTIO_MEM);
> +    object_property_add_alias(obj, VIRTIO_MEM_BLOCK_SIZE_PROP,
> +                              OBJECT(&dev->vdev),
> +                              VIRTIO_MEM_BLOCK_SIZE_PROP, &error_abort);
> +    object_property_add_alias(obj, VIRTIO_MEM_SIZE_PROP, OBJECT(&dev->vdev),
> +                              VIRTIO_MEM_SIZE_PROP, &error_abort);
> +    object_property_add_alias(obj, VIRTIO_MEM_REQUESTED_SIZE_PROP,
> +                              OBJECT(&dev->vdev),
> +                              VIRTIO_MEM_REQUESTED_SIZE_PROP, &error_abort);
> +}
> +
> +static const VirtioPCIDeviceTypeInfo virtio_mem_pci_info = {
> +    .base_name = TYPE_VIRTIO_MEM_PCI,
> +    .generic_name = "virtio-mem-pci",
> +    .instance_size = sizeof(VirtIOMEMPCI),
> +    .instance_init = virtio_mem_pci_instance_init,
> +    .class_init = virtio_mem_pci_class_init,
> +    .interfaces = (InterfaceInfo[]) {
> +        { TYPE_MEMORY_DEVICE },
> +        { }
> +    },
> +};
> +
> +static void virtio_mem_pci_register_types(void)
> +{
> +    virtio_pci_types_register(&virtio_mem_pci_info);
> +}
> +type_init(virtio_mem_pci_register_types)
> diff --git a/hw/virtio/virtio-mem-pci.h b/hw/virtio/virtio-mem-pci.h
> new file mode 100644
> index 0000000000..8820cd6628
> --- /dev/null
> +++ b/hw/virtio/virtio-mem-pci.h
> @@ -0,0 +1,33 @@
> +/*
> + * Virtio MEM PCI device
> + *
> + * Copyright (C) 2020 Red Hat, Inc.
> + *
> + * Authors:
> + *  David Hildenbrand <david@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.
> + * See the COPYING file in the top-level directory.
> + */
> +
> +#ifndef QEMU_VIRTIO_MEM_PCI_H
> +#define QEMU_VIRTIO_MEM_PCI_H
> +
> +#include "hw/virtio/virtio-pci.h"
> +#include "hw/virtio/virtio-mem.h"
> +
> +typedef struct VirtIOMEMPCI VirtIOMEMPCI;
> +
> +/*
> + * virtio-mem-pci: This extends VirtioPCIProxy.
> + */
> +#define TYPE_VIRTIO_MEM_PCI "virtio-mem-pci-base"
> +#define VIRTIO_MEM_PCI(obj) \
> +        OBJECT_CHECK(VirtIOMEMPCI, (obj), TYPE_VIRTIO_MEM_PCI)
> +
> +struct VirtIOMEMPCI {
> +    VirtIOPCIProxy parent_obj;
> +    VirtIOMEM vdev;
> +};
> +
> +#endif /* QEMU_VIRTIO_MEM_PCI_H */
> diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
> index cfedf5a995..fec72d5a31 100644
> --- a/include/hw/pci/pci.h
> +++ b/include/hw/pci/pci.h
> @@ -87,6 +87,7 @@ extern bool pci_available;
>  #define PCI_DEVICE_ID_VIRTIO_VSOCK       0x1012
>  #define PCI_DEVICE_ID_VIRTIO_PMEM        0x1013
>  #define PCI_DEVICE_ID_VIRTIO_IOMMU       0x1014
> +#define PCI_DEVICE_ID_VIRTIO_MEM         0x1015
>
>  #define PCI_VENDOR_ID_REDHAT             0x1b36
>  #define PCI_DEVICE_ID_REDHAT_BRIDGE      0x0001
> --
> 2.25.3
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
