Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAD11C702A
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 14:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgEFMTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 08:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725887AbgEFMTT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 08:19:19 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3FCC061A0F
        for <kvm@vger.kernel.org>; Wed,  6 May 2020 05:19:18 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id r26so2411786wmh.0
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 05:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q5Os8dyJUPDIZSodvUQVJilx4gN1PaRSjUCuQBbM0mQ=;
        b=Zl/YPtzCbjnKh6wZrq+ztO4RT2QB7HVj/Fm35cN0vmJFvqFi13cmxN5LIsm5d03CLI
         fu0+rrx1Vna/2asInbpRTI7RCxeXJxZP0zCB3nZd5VQhDpxdoXdyVeiO1IB9OQH13UYd
         NYEvcWGgcIQpfRFnxGg8STfhlrXBReejpxNtxUS+nmDTHfwJe6j00fFUYhxDcBQeH2bn
         pdy77N2b5mgi6C04szucCsLccyVT2OOlGN7ebAjodQWwjdo00MAXtUcmlZP3oYtz89pt
         iKd/8rTY2QlN0FnxTaFVTQzzm2qN6TTpzHTpF51Phw/g/i0Wn1opMGqz8Yh8AHFYdY94
         lirA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q5Os8dyJUPDIZSodvUQVJilx4gN1PaRSjUCuQBbM0mQ=;
        b=CpMRk7jM9v6LjAMdVkIlpiIbwyA9hYBJGauQjhdheuITh6e6m1bnyh7t46itOO9x+m
         6qANzUOIDgkHQtZttyr91eLM/mHY+4g+4mZoUMZnc/m//0jilqasRgpyj4haeEJIxMSu
         hXW/ZdRjT0ShKW1sXT72jV7KPE/x+UedE5ovQ18OzeHoFrWc5UIqFMospZQ/XOxXsCSl
         qP+wW/F3utQyGhRkB9e3jaExduCxF+kiP8OnC84rol0EMnV+5Pk0ak5oQmIAPrwh95L+
         iKpJdiwwfCB+3T4ZDv1YCX01n8ZZrUvphZ2mx4K5Ysx2EYcBPp2RoVRIJPPP5k8t5oz7
         p9CQ==
X-Gm-Message-State: AGi0PuZ8Ut+GQxrPUdrXjgjHauou862mZ1Iu+XRBNAjByOhhg2ZrerwQ
        bSlrICQgjpVyZT5IE2spDnhFSYLeEVvZmkGvzZEUxol5RHo=
X-Google-Smtp-Source: APiQypLeVpH913RfqJfPYP+brXYqrIS3pVomgf/Ib0DVEAcv2ZzAJrpwgG3sdpFOPJ5/HfFPbqmzCByzbt0QkhZ5Ytk=
X-Received: by 2002:a1c:3c08:: with SMTP id j8mr4111430wma.30.1588767557342;
 Wed, 06 May 2020 05:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200506094948.76388-1-david@redhat.com> <20200506094948.76388-16-david@redhat.com>
In-Reply-To: <20200506094948.76388-16-david@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Wed, 6 May 2020 14:19:06 +0200
Message-ID: <CAM9Jb+gZGjWUthoU4E3U4nAowa2Kr8_5PWBZ0VkdAtL86TPE2A@mail.gmail.com>
Subject: Re: [PATCH v1 15/17] pc: Support for virtio-mem-pci
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        kvm@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Markus Armbruster <armbru@redhat.com>, qemu-s390x@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Let's wire it up similar to virtio-pmem. Also disallow unplug, so it's
> harder for users to shoot themselves into the foot.
>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Cc: Eric Blake <eblake@redhat.com>
> Cc: Markus Armbruster <armbru@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  hw/i386/Kconfig |  1 +
>  hw/i386/pc.c    | 49 ++++++++++++++++++++++++++++---------------------
>  2 files changed, 29 insertions(+), 21 deletions(-)
>
> diff --git a/hw/i386/Kconfig b/hw/i386/Kconfig
> index c93f32f657..03e347b207 100644
> --- a/hw/i386/Kconfig
> +++ b/hw/i386/Kconfig
> @@ -35,6 +35,7 @@ config PC
>      select ACPI_PCI
>      select ACPI_VMGENID
>      select VIRTIO_PMEM_SUPPORTED
> +    select VIRTIO_MEM_SUPPORTED
>
>  config PC_PCI
>      bool
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index f6b8431c8b..588804f895 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -86,6 +86,7 @@
>  #include "hw/net/ne2000-isa.h"
>  #include "standard-headers/asm-x86/bootparam.h"
>  #include "hw/virtio/virtio-pmem-pci.h"
> +#include "hw/virtio/virtio-mem-pci.h"
>  #include "hw/mem/memory-device.h"
>  #include "sysemu/replay.h"
>  #include "qapi/qmp/qerror.h"
> @@ -1654,8 +1655,8 @@ static void pc_cpu_pre_plug(HotplugHandler *hotplug_dev,
>      numa_cpu_pre_plug(cpu_slot, dev, errp);
>  }
>
> -static void pc_virtio_pmem_pci_pre_plug(HotplugHandler *hotplug_dev,
> -                                        DeviceState *dev, Error **errp)
> +static void pc_virtio_md_pci_pre_plug(HotplugHandler *hotplug_dev,
> +                                      DeviceState *dev, Error **errp)
>  {
>      HotplugHandler *hotplug_dev2 = qdev_get_bus_hotplug_handler(dev);
>      Error *local_err = NULL;
> @@ -1666,7 +1667,8 @@ static void pc_virtio_pmem_pci_pre_plug(HotplugHandler *hotplug_dev,
>           * order. This should never be the case on x86, however better add
>           * a safety net.
>           */
> -        error_setg(errp, "virtio-pmem-pci not supported on this bus.");
> +        error_setg(errp,
> +                   "virtio based memory devices not supported on this bus.");
>          return;
>      }
>      /*
> @@ -1681,8 +1683,8 @@ static void pc_virtio_pmem_pci_pre_plug(HotplugHandler *hotplug_dev,
>      error_propagate(errp, local_err);
>  }
>
> -static void pc_virtio_pmem_pci_plug(HotplugHandler *hotplug_dev,
> -                                    DeviceState *dev, Error **errp)
> +static void pc_virtio_md_pci_plug(HotplugHandler *hotplug_dev,
> +                                  DeviceState *dev, Error **errp)
>  {
>      HotplugHandler *hotplug_dev2 = qdev_get_bus_hotplug_handler(dev);
>      Error *local_err = NULL;
> @@ -1700,17 +1702,17 @@ static void pc_virtio_pmem_pci_plug(HotplugHandler *hotplug_dev,
>      error_propagate(errp, local_err);
>  }
>
> -static void pc_virtio_pmem_pci_unplug_request(HotplugHandler *hotplug_dev,
> -                                              DeviceState *dev, Error **errp)
> +static void pc_virtio_md_pci_unplug_request(HotplugHandler *hotplug_dev,
> +                                            DeviceState *dev, Error **errp)
>  {
> -    /* We don't support virtio pmem hot unplug */
> -    error_setg(errp, "virtio pmem device unplug not supported.");
> +    /* We don't support hot unplug of virtio based memory devices */
> +    error_setg(errp, "virtio based memory devices cannot be unplugged.");
>  }
>
> -static void pc_virtio_pmem_pci_unplug(HotplugHandler *hotplug_dev,
> -                                      DeviceState *dev, Error **errp)
> +static void pc_virtio_md_pci_unplug(HotplugHandler *hotplug_dev,
> +                                    DeviceState *dev, Error **errp)
>  {
> -    /* We don't support virtio pmem hot unplug */
> +    /* We don't support hot unplug of virtio based memory devices */
>  }
>
>  static void pc_machine_device_pre_plug_cb(HotplugHandler *hotplug_dev,
> @@ -1720,8 +1722,9 @@ static void pc_machine_device_pre_plug_cb(HotplugHandler *hotplug_dev,
>          pc_memory_pre_plug(hotplug_dev, dev, errp);
>      } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
>          pc_cpu_pre_plug(hotplug_dev, dev, errp);
> -    } else if (object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI)) {
> -        pc_virtio_pmem_pci_pre_plug(hotplug_dev, dev, errp);
> +    } else if (object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI) ||
> +               object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_MEM_PCI)) {
> +        pc_virtio_md_pci_pre_plug(hotplug_dev, dev, errp);
>      }
>  }
>
> @@ -1732,8 +1735,9 @@ static void pc_machine_device_plug_cb(HotplugHandler *hotplug_dev,
>          pc_memory_plug(hotplug_dev, dev, errp);
>      } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
>          pc_cpu_plug(hotplug_dev, dev, errp);
> -    } else if (object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI)) {
> -        pc_virtio_pmem_pci_plug(hotplug_dev, dev, errp);
> +    } else if (object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI) ||
> +               object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_MEM_PCI)) {
> +        pc_virtio_md_pci_plug(hotplug_dev, dev, errp);
>      }
>  }
>
> @@ -1744,8 +1748,9 @@ static void pc_machine_device_unplug_request_cb(HotplugHandler *hotplug_dev,
>          pc_memory_unplug_request(hotplug_dev, dev, errp);
>      } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
>          pc_cpu_unplug_request_cb(hotplug_dev, dev, errp);
> -    } else if (object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI)) {
> -        pc_virtio_pmem_pci_unplug_request(hotplug_dev, dev, errp);
> +    } else if (object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI) ||
> +               object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_MEM_PCI)) {
> +        pc_virtio_md_pci_unplug_request(hotplug_dev, dev, errp);
>      } else {
>          error_setg(errp, "acpi: device unplug request for not supported device"
>                     " type: %s", object_get_typename(OBJECT(dev)));
> @@ -1759,8 +1764,9 @@ static void pc_machine_device_unplug_cb(HotplugHandler *hotplug_dev,
>          pc_memory_unplug(hotplug_dev, dev, errp);
>      } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
>          pc_cpu_unplug_cb(hotplug_dev, dev, errp);
> -    } else if (object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI)) {
> -        pc_virtio_pmem_pci_unplug(hotplug_dev, dev, errp);
> +    } else if (object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI) ||
> +               object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_MEM_PCI)) {
> +        pc_virtio_md_pci_unplug(hotplug_dev, dev, errp);
>      } else {
>          error_setg(errp, "acpi: device unplug for not supported device"
>                     " type: %s", object_get_typename(OBJECT(dev)));
> @@ -1772,7 +1778,8 @@ static HotplugHandler *pc_get_hotplug_handler(MachineState *machine,
>  {
>      if (object_dynamic_cast(OBJECT(dev), TYPE_PC_DIMM) ||
>          object_dynamic_cast(OBJECT(dev), TYPE_CPU) ||
> -        object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI)) {
> +        object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI) ||
> +        object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_MEM_PCI)) {
>          return HOTPLUG_HANDLER(machine);
>      }
>
> --

Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>

> 2.25.3
>
>
