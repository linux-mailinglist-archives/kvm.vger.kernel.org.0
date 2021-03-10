Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08FF33402D
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 15:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhCJOTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 09:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbhCJOTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 09:19:17 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BE9C061760
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 06:19:17 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id y13so8695413pfr.0
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 06:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vD8bNQZYpK6enAELS11WH8dKPytWd/QQzAf3ztO/Tsc=;
        b=ZqUtZM8SWYps/i1skdan44n6BFyxssoVK/9H3VOqKk/fKeGkSSzOolw8uj9xZd0sw7
         gc35AtTIytXkIBrN+R/ZhzE8rVbspZAA8LjSiRfE3dpG1llrAzz3sFNS6GcRl6+fodwB
         SNGY3kupvxHdi5KaRH0jz1qSxPYYsr5mRaRML3ZUOP87+eu2a4rAsDZO6Luh1a0vz9Ve
         Gsxt2SsiEnwQTcz1fwJi1DTRYye5HYm0In4v5qQIB8Hk+e9ZWSKyTCCCcunpA1fR3+63
         VMgvXZOm9p5j2g+mQCYTfnJo0iLZjKI12SBNcKNUtPmEnlbGlQt1uSSmiaFTakdUgGP2
         tllg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vD8bNQZYpK6enAELS11WH8dKPytWd/QQzAf3ztO/Tsc=;
        b=AjVjok3yM8tbuNT+71voT3OPEs8wDvuKqd4Se6f55BTFiheyjZXDWf86bDuUGeNvgU
         f6gS81+yNzry0iDO78aG8jwY26dAmd+zrGHFG/9VY0o3LDsE5CkyF1jcS85s65nM2EpR
         Kw28KHtj0SDjwvc8kiPOlIx3ZDVPDLKKnbXHjwcXCeE2EaoqEOqRXnL2A57lXwg0rp6d
         8LX07ACwQAI+T9M00CMSnp8pHEVatFdyJLmUeHmlYn+gdGXDubyINgx0jUit7cntlqxK
         k3RwNckygjmFaz/M4SMj00nf+rIQJ3KT4isxxiFQD9w2wvmp+CW8Vhy2eD62+TgyTYXC
         2w+A==
X-Gm-Message-State: AOAM5331LV8ajtVyNI7HD2IVYhbr4fpS8KIKlA83aOQSq7gi7IgIp1uY
        AWP4zp3/cIR0rfNjMx74AUDiOQ==
X-Google-Smtp-Source: ABdhPJw0SErItSVYLUr8Z7WxgrRck1/ZEiTHake9hSiV2neo5nHA/YtRoB/ZV2h5gWw9q8uxW+pcnQ==
X-Received: by 2002:a63:fa05:: with SMTP id y5mr2976398pgh.154.1615385956320;
        Wed, 10 Mar 2021 06:19:16 -0800 (PST)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id c24sm6366733pjv.18.2021.03.10.06.19.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 06:19:15 -0800 (PST)
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor vfio_pci
 drivers
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, jgg@nvidia.com,
        alex.williamson@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com, hch@lst.de
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
 <20210309083357.65467-9-mgurtovoy@nvidia.com>
 <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
 <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Message-ID: <11ae505a-f9fe-f182-3864-cb25b342771f@ozlabs.ru>
Date:   Thu, 11 Mar 2021 01:19:05 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
MIME-Version: 1.0
In-Reply-To: <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/03/2021 23:57, Max Gurtovoy wrote:
> 
> On 3/10/2021 8:39 AM, Alexey Kardashevskiy wrote:
>>
>>
>> On 09/03/2021 19:33, Max Gurtovoy wrote:
>>> The new drivers introduced are nvlink2gpu_vfio_pci.ko and
>>> npu2_vfio_pci.ko.
>>> The first will be responsible for providing special extensions for
>>> NVIDIA GPUs with NVLINK2 support for P9 platform (and others in the
>>> future). The last will be responsible for POWER9 NPU2 unit (NVLink2 host
>>> bus adapter).
>>>
>>> Also, preserve backward compatibility for users that were binding
>>> NVLINK2 devices to vfio_pci.ko. Hopefully this compatibility layer will
>>> be dropped in the future
>>>
>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>> ---
>>>   drivers/vfio/pci/Kconfig                      |  28 +++-
>>>   drivers/vfio/pci/Makefile                     |   7 +-
>>>   .../pci/{vfio_pci_npu2.c => npu2_vfio_pci.c}  | 144 ++++++++++++++++-
>>>   drivers/vfio/pci/npu2_vfio_pci.h              |  24 +++
>>>   ...pci_nvlink2gpu.c => nvlink2gpu_vfio_pci.c} | 149 +++++++++++++++++-
>>>   drivers/vfio/pci/nvlink2gpu_vfio_pci.h        |  24 +++
>>>   drivers/vfio/pci/vfio_pci.c                   |  61 ++++++-
>>>   drivers/vfio/pci/vfio_pci_core.c              |  18 ---
>>>   drivers/vfio/pci/vfio_pci_core.h              |  14 --
>>>   9 files changed, 422 insertions(+), 47 deletions(-)
>>>   rename drivers/vfio/pci/{vfio_pci_npu2.c => npu2_vfio_pci.c} (64%)
>>>   create mode 100644 drivers/vfio/pci/npu2_vfio_pci.h
>>>   rename drivers/vfio/pci/{vfio_pci_nvlink2gpu.c => 
>>> nvlink2gpu_vfio_pci.c} (67%)
>>>   create mode 100644 drivers/vfio/pci/nvlink2gpu_vfio_pci.h
>>>
>>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>>> index 829e90a2e5a3..88c89863a205 100644
>>> --- a/drivers/vfio/pci/Kconfig
>>> +++ b/drivers/vfio/pci/Kconfig
>>> @@ -48,8 +48,30 @@ config VFIO_PCI_IGD
>>>           To enable Intel IGD assignment through vfio-pci, say Y.
>>>   -config VFIO_PCI_NVLINK2
>>> -    def_bool y
>>> +config VFIO_PCI_NVLINK2GPU
>>> +    tristate "VFIO support for NVIDIA NVLINK2 GPUs"
>>>       depends on VFIO_PCI_CORE && PPC_POWERNV
>>>       help
>>> -      VFIO PCI support for P9 Witherspoon machine with NVIDIA V100 GPUs
>>> +      VFIO PCI driver for NVIDIA NVLINK2 GPUs with specific extensions
>>> +      for P9 Witherspoon machine.
>>> +
>>> +config VFIO_PCI_NPU2
>>> +    tristate "VFIO support for IBM NPU host bus adapter on P9"
>>> +    depends on VFIO_PCI_NVLINK2GPU && PPC_POWERNV
>>> +    help
>>> +      VFIO PCI specific extensions for IBM NVLink2 host bus adapter 
>>> on P9
>>> +      Witherspoon machine.
>>> +
>>> +config VFIO_PCI_DRIVER_COMPAT
>>> +    bool "VFIO PCI backward compatibility for vendor specific 
>>> extensions"
>>> +    default y
>>> +    depends on VFIO_PCI
>>> +    help
>>> +      Say Y here if you want to preserve VFIO PCI backward
>>> +      compatibility. vfio_pci.ko will continue to automatically use
>>> +      the NVLINK2, NPU2 and IGD VFIO drivers when it is attached to
>>> +      a compatible device.
>>> +
>>> +      When N is selected the user must bind explicity to the module
>>> +      they want to handle the device and vfio_pci.ko will have no
>>> +      device specific special behaviors.
>>> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
>>> index f539f32c9296..86fb62e271fc 100644
>>> --- a/drivers/vfio/pci/Makefile
>>> +++ b/drivers/vfio/pci/Makefile
>>> @@ -2,10 +2,15 @@
>>>     obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
>>>   obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>>> +obj-$(CONFIG_VFIO_PCI_NPU2) += npu2-vfio-pci.o
>>> +obj-$(CONFIG_VFIO_PCI_NVLINK2GPU) += nvlink2gpu-vfio-pci.o
>>>     vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o 
>>> vfio_pci_rdwr.o vfio_pci_config.o
>>>   vfio-pci-core-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
>>> -vfio-pci-core-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2gpu.o 
>>> vfio_pci_npu2.o
>>>   vfio-pci-core-$(CONFIG_S390) += vfio_pci_zdev.o
>>>     vfio-pci-y := vfio_pci.o
>>> +
>>> +npu2-vfio-pci-y := npu2_vfio_pci.o
>>> +
>>> +nvlink2gpu-vfio-pci-y := nvlink2gpu_vfio_pci.o
>>> diff --git a/drivers/vfio/pci/vfio_pci_npu2.c 
>>> b/drivers/vfio/pci/npu2_vfio_pci.c
>>> similarity index 64%
>>> rename from drivers/vfio/pci/vfio_pci_npu2.c
>>> rename to drivers/vfio/pci/npu2_vfio_pci.c
>>> index 717745256ab3..7071bda0f2b6 100644
>>> --- a/drivers/vfio/pci/vfio_pci_npu2.c
>>> +++ b/drivers/vfio/pci/npu2_vfio_pci.c
>>> @@ -14,19 +14,28 @@
>>>    *    Author: Alex Williamson <alex.williamson@redhat.com>
>>>    */
>>>   +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>> +
>>> +#include <linux/module.h>
>>>   #include <linux/io.h>
>>>   #include <linux/pci.h>
>>>   #include <linux/uaccess.h>
>>>   #include <linux/vfio.h>
>>> +#include <linux/list.h>
>>>   #include <linux/sched/mm.h>
>>>   #include <linux/mmu_context.h>
>>>   #include <asm/kvm_ppc.h>
>>>     #include "vfio_pci_core.h"
>>> +#include "npu2_vfio_pci.h"
>>>     #define CREATE_TRACE_POINTS
>>>   #include "npu2_trace.h"
>>>   +#define DRIVER_VERSION  "0.1"
>>> +#define DRIVER_AUTHOR   "Alexey Kardashevskiy <aik@ozlabs.ru>"
>>> +#define DRIVER_DESC     "NPU2 VFIO PCI - User Level meta-driver for 
>>> POWER9 NPU NVLink2 HBA"
>>> +
>>>   EXPORT_TRACEPOINT_SYMBOL_GPL(vfio_pci_npu2_mmap);
>>>     struct vfio_pci_npu2_data {
>>> @@ -36,6 +45,10 @@ struct vfio_pci_npu2_data {
>>>       unsigned int link_speed; /* The link speed from DT's 
>>> ibm,nvlink-speed */
>>>   };
>>>   +struct npu2_vfio_pci_device {
>>> +    struct vfio_pci_core_device    vdev;
>>> +};
>>> +
>>>   static size_t vfio_pci_npu2_rw(struct vfio_pci_core_device *vdev,
>>>           char __user *buf, size_t count, loff_t *ppos, bool iswrite)
>>>   {
>>> @@ -120,7 +133,7 @@ static const struct vfio_pci_regops 
>>> vfio_pci_npu2_regops = {
>>>       .add_capability = vfio_pci_npu2_add_capability,
>>>   };
>>>   -int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device *vdev)
>>> +static int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device *vdev)
>>>   {
>>>       int ret;
>>>       struct vfio_pci_npu2_data *data;
>>> @@ -220,3 +233,132 @@ int vfio_pci_ibm_npu2_init(struct 
>>> vfio_pci_core_device *vdev)
>>>         return ret;
>>>   }
>>> +
>>> +static void npu2_vfio_pci_release(void *device_data)
>>> +{
>>> +    struct vfio_pci_core_device *vdev = device_data;
>>> +
>>> +    mutex_lock(&vdev->reflck->lock);
>>> +    if (!(--vdev->refcnt)) {
>>> +        vfio_pci_vf_token_user_add(vdev, -1);
>>> +        vfio_pci_core_spapr_eeh_release(vdev);
>>> +        vfio_pci_core_disable(vdev);
>>> +    }
>>> +    mutex_unlock(&vdev->reflck->lock);
>>> +
>>> +    module_put(THIS_MODULE);
>>> +}
>>> +
>>> +static int npu2_vfio_pci_open(void *device_data)
>>> +{
>>> +    struct vfio_pci_core_device *vdev = device_data;
>>> +    int ret = 0;
>>> +
>>> +    if (!try_module_get(THIS_MODULE))
>>> +        return -ENODEV;
>>> +
>>> +    mutex_lock(&vdev->reflck->lock);
>>> +
>>> +    if (!vdev->refcnt) {
>>> +        ret = vfio_pci_core_enable(vdev);
>>> +        if (ret)
>>> +            goto error;
>>> +
>>> +        ret = vfio_pci_ibm_npu2_init(vdev);
>>> +        if (ret && ret != -ENODEV) {
>>> +            pci_warn(vdev->pdev,
>>> +                 "Failed to setup NVIDIA NV2 ATSD region\n");
>>> +            vfio_pci_core_disable(vdev);
>>> +            goto error;
>>> +        }
>>> +        ret = 0;
>>> +        vfio_pci_probe_mmaps(vdev);
>>> +        vfio_pci_core_spapr_eeh_open(vdev);
>>> +        vfio_pci_vf_token_user_add(vdev, 1);
>>> +    }
>>> +    vdev->refcnt++;
>>> +error:
>>> +    mutex_unlock(&vdev->reflck->lock);
>>> +    if (ret)
>>> +        module_put(THIS_MODULE);
>>> +    return ret;
>>> +}
>>> +
>>> +static const struct vfio_device_ops npu2_vfio_pci_ops = {
>>> +    .name        = "npu2-vfio-pci",
>>> +    .open        = npu2_vfio_pci_open,
>>> +    .release    = npu2_vfio_pci_release,
>>> +    .ioctl        = vfio_pci_core_ioctl,
>>> +    .read        = vfio_pci_core_read,
>>> +    .write        = vfio_pci_core_write,
>>> +    .mmap        = vfio_pci_core_mmap,
>>> +    .request    = vfio_pci_core_request,
>>> +    .match        = vfio_pci_core_match,
>>> +};
>>> +
>>> +static int npu2_vfio_pci_probe(struct pci_dev *pdev,
>>> +        const struct pci_device_id *id)
>>> +{
>>> +    struct npu2_vfio_pci_device *npvdev;
>>> +    int ret;
>>> +
>>> +    npvdev = kzalloc(sizeof(*npvdev), GFP_KERNEL);
>>> +    if (!npvdev)
>>> +        return -ENOMEM;
>>> +
>>> +    ret = vfio_pci_core_register_device(&npvdev->vdev, pdev,
>>> +            &npu2_vfio_pci_ops);
>>> +    if (ret)
>>> +        goto out_free;
>>> +
>>> +    return 0;
>>> +
>>> +out_free:
>>> +    kfree(npvdev);
>>> +    return ret;
>>> +}
>>> +
>>> +static void npu2_vfio_pci_remove(struct pci_dev *pdev)
>>> +{
>>> +    struct vfio_device *vdev = dev_get_drvdata(&pdev->dev);
>>> +    struct vfio_pci_core_device *core_vpdev = vfio_device_data(vdev);
>>> +    struct npu2_vfio_pci_device *npvdev;
>>> +
>>> +    npvdev = container_of(core_vpdev, struct npu2_vfio_pci_device, 
>>> vdev);
>>> +
>>> +    vfio_pci_core_unregister_device(core_vpdev);
>>> +    kfree(npvdev);
>>> +}
>>> +
>>> +static const struct pci_device_id npu2_vfio_pci_table[] = {
>>> +    { PCI_VDEVICE(IBM, 0x04ea) },
>>> +    { 0, }
>>> +};
>>> +
>>> +static struct pci_driver npu2_vfio_pci_driver = {
>>> +    .name            = "npu2-vfio-pci",
>>> +    .id_table        = npu2_vfio_pci_table,
>>> +    .probe            = npu2_vfio_pci_probe,
>>> +    .remove            = npu2_vfio_pci_remove,
>>> +#ifdef CONFIG_PCI_IOV
>>> +    .sriov_configure    = vfio_pci_core_sriov_configure,
>>> +#endif
>>> +    .err_handler        = &vfio_pci_core_err_handlers,
>>> +};
>>> +
>>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>>> +struct pci_driver *get_npu2_vfio_pci_driver(struct pci_dev *pdev)
>>> +{
>>> +    if (pci_match_id(npu2_vfio_pci_driver.id_table, pdev))
>>> +        return &npu2_vfio_pci_driver;
>>> +    return NULL;
>>> +}
>>> +EXPORT_SYMBOL_GPL(get_npu2_vfio_pci_driver);
>>> +#endif
>>> +
>>> +module_pci_driver(npu2_vfio_pci_driver);
>>> +
>>> +MODULE_VERSION(DRIVER_VERSION);
>>> +MODULE_LICENSE("GPL v2");
>>> +MODULE_AUTHOR(DRIVER_AUTHOR);
>>> +MODULE_DESCRIPTION(DRIVER_DESC);
>>> diff --git a/drivers/vfio/pci/npu2_vfio_pci.h 
>>> b/drivers/vfio/pci/npu2_vfio_pci.h
>>> new file mode 100644
>>> index 000000000000..92010d340346
>>> --- /dev/null
>>> +++ b/drivers/vfio/pci/npu2_vfio_pci.h
>>> @@ -0,0 +1,24 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +/*
>>> + * Copyright (c) 2020, Mellanox Technologies, Ltd.  All rights 
>>> reserved.
>>> + *     Author: Max Gurtovoy <mgurtovoy@nvidia.com>
>>> + */
>>> +
>>> +#ifndef NPU2_VFIO_PCI_H
>>> +#define NPU2_VFIO_PCI_H
>>> +
>>> +#include <linux/pci.h>
>>> +#include <linux/module.h>
>>> +
>>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>>> +#if defined(CONFIG_VFIO_PCI_NPU2) || 
>>> defined(CONFIG_VFIO_PCI_NPU2_MODULE)
>>> +struct pci_driver *get_npu2_vfio_pci_driver(struct pci_dev *pdev);
>>> +#else
>>> +struct pci_driver *get_npu2_vfio_pci_driver(struct pci_dev *pdev)
>>> +{
>>> +    return NULL;
>>> +}
>>> +#endif
>>> +#endif
>>> +
>>> +#endif /* NPU2_VFIO_PCI_H */
>>> diff --git a/drivers/vfio/pci/vfio_pci_nvlink2gpu.c 
>>> b/drivers/vfio/pci/nvlink2gpu_vfio_pci.c
>>> similarity index 67%
>>> rename from drivers/vfio/pci/vfio_pci_nvlink2gpu.c
>>> rename to drivers/vfio/pci/nvlink2gpu_vfio_pci.c
>>> index 6dce1e78ee82..84a5ac1ce8ac 100644
>>> --- a/drivers/vfio/pci/vfio_pci_nvlink2gpu.c
>>> +++ b/drivers/vfio/pci/nvlink2gpu_vfio_pci.c
>>> @@ -1,6 +1,6 @@
>>>   // SPDX-License-Identifier: GPL-2.0-only
>>>   /*
>>> - * VFIO PCI NVIDIA Whitherspoon GPU support a.k.a. NVLink2.
>>> + * VFIO PCI NVIDIA NVLink2 GPUs support.
>>>    *
>>>    * Copyright (C) 2018 IBM Corp.  All rights reserved.
>>>    *     Author: Alexey Kardashevskiy <aik@ozlabs.ru>
>>> @@ -12,6 +12,9 @@
>>>    *    Author: Alex Williamson <alex.williamson@redhat.com>
>>>    */
>>>   +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>> +
>>> +#include <linux/module.h>
>>>   #include <linux/io.h>
>>>   #include <linux/pci.h>
>>>   #include <linux/uaccess.h>
>>> @@ -21,10 +24,15 @@
>>>   #include <asm/kvm_ppc.h>
>>>     #include "vfio_pci_core.h"
>>> +#include "nvlink2gpu_vfio_pci.h"
>>>     #define CREATE_TRACE_POINTS
>>>   #include "nvlink2gpu_trace.h"
>>>   +#define DRIVER_VERSION  "0.1"
>>> +#define DRIVER_AUTHOR   "Alexey Kardashevskiy <aik@ozlabs.ru>"
>>> +#define DRIVER_DESC     "NVLINK2GPU VFIO PCI - User Level 
>>> meta-driver for NVIDIA NVLink2 GPUs"
>>> +
>>>   EXPORT_TRACEPOINT_SYMBOL_GPL(vfio_pci_nvgpu_mmap_fault);
>>>   EXPORT_TRACEPOINT_SYMBOL_GPL(vfio_pci_nvgpu_mmap);
>>>   @@ -39,6 +47,10 @@ struct vfio_pci_nvgpu_data {
>>>       struct notifier_block group_notifier;
>>>   };
>>>   +struct nv_vfio_pci_device {
>>> +    struct vfio_pci_core_device    vdev;
>>> +};
>>> +
>>>   static size_t vfio_pci_nvgpu_rw(struct vfio_pci_core_device *vdev,
>>>           char __user *buf, size_t count, loff_t *ppos, bool iswrite)
>>>   {
>>> @@ -207,7 +219,8 @@ static int vfio_pci_nvgpu_group_notifier(struct 
>>> notifier_block *nb,
>>>       return NOTIFY_OK;
>>>   }
>>>   -int vfio_pci_nvidia_v100_nvlink2_init(struct vfio_pci_core_device 
>>> *vdev)
>>> +static int
>>> +vfio_pci_nvidia_v100_nvlink2_init(struct vfio_pci_core_device *vdev)
>>>   {
>>>       int ret;
>>>       u64 reg[2];
>>> @@ -293,3 +306,135 @@ int vfio_pci_nvidia_v100_nvlink2_init(struct 
>>> vfio_pci_core_device *vdev)
>>>         return ret;
>>>   }
>>> +
>>> +static void nvlink2gpu_vfio_pci_release(void *device_data)
>>> +{
>>> +    struct vfio_pci_core_device *vdev = device_data;
>>> +
>>> +    mutex_lock(&vdev->reflck->lock);
>>> +    if (!(--vdev->refcnt)) {
>>> +        vfio_pci_vf_token_user_add(vdev, -1);
>>> +        vfio_pci_core_spapr_eeh_release(vdev);
>>> +        vfio_pci_core_disable(vdev);
>>> +    }
>>> +    mutex_unlock(&vdev->reflck->lock);
>>> +
>>> +    module_put(THIS_MODULE);
>>> +}
>>> +
>>> +static int nvlink2gpu_vfio_pci_open(void *device_data)
>>> +{
>>> +    struct vfio_pci_core_device *vdev = device_data;
>>> +    int ret = 0;
>>> +
>>> +    if (!try_module_get(THIS_MODULE))
>>> +        return -ENODEV;
>>> +
>>> +    mutex_lock(&vdev->reflck->lock);
>>> +
>>> +    if (!vdev->refcnt) {
>>> +        ret = vfio_pci_core_enable(vdev);
>>> +        if (ret)
>>> +            goto error;
>>> +
>>> +        ret = vfio_pci_nvidia_v100_nvlink2_init(vdev);
>>> +        if (ret && ret != -ENODEV) {
>>> +            pci_warn(vdev->pdev,
>>> +                 "Failed to setup NVIDIA NV2 RAM region\n");
>>> +            vfio_pci_core_disable(vdev);
>>> +            goto error;
>>> +        }
>>> +        ret = 0;
>>> +        vfio_pci_probe_mmaps(vdev);
>>> +        vfio_pci_core_spapr_eeh_open(vdev);
>>> +        vfio_pci_vf_token_user_add(vdev, 1);
>>> +    }
>>> +    vdev->refcnt++;
>>> +error:
>>> +    mutex_unlock(&vdev->reflck->lock);
>>> +    if (ret)
>>> +        module_put(THIS_MODULE);
>>> +    return ret;
>>> +}
>>> +
>>> +static const struct vfio_device_ops nvlink2gpu_vfio_pci_ops = {
>>> +    .name        = "nvlink2gpu-vfio-pci",
>>> +    .open        = nvlink2gpu_vfio_pci_open,
>>> +    .release    = nvlink2gpu_vfio_pci_release,
>>> +    .ioctl        = vfio_pci_core_ioctl,
>>> +    .read        = vfio_pci_core_read,
>>> +    .write        = vfio_pci_core_write,
>>> +    .mmap        = vfio_pci_core_mmap,
>>> +    .request    = vfio_pci_core_request,
>>> +    .match        = vfio_pci_core_match,
>>> +};
>>> +
>>> +static int nvlink2gpu_vfio_pci_probe(struct pci_dev *pdev,
>>> +        const struct pci_device_id *id)
>>> +{
>>> +    struct nv_vfio_pci_device *nvdev;
>>> +    int ret;
>>> +
>>> +    nvdev = kzalloc(sizeof(*nvdev), GFP_KERNEL);
>>> +    if (!nvdev)
>>> +        return -ENOMEM;
>>> +
>>> +    ret = vfio_pci_core_register_device(&nvdev->vdev, pdev,
>>> +            &nvlink2gpu_vfio_pci_ops);
>>> +    if (ret)
>>> +        goto out_free;
>>> +
>>> +    return 0;
>>> +
>>> +out_free:
>>> +    kfree(nvdev);
>>> +    return ret;
>>> +}
>>> +
>>> +static void nvlink2gpu_vfio_pci_remove(struct pci_dev *pdev)
>>> +{
>>> +    struct vfio_device *vdev = dev_get_drvdata(&pdev->dev);
>>> +    struct vfio_pci_core_device *core_vpdev = vfio_device_data(vdev);
>>> +    struct nv_vfio_pci_device *nvdev;
>>> +
>>> +    nvdev = container_of(core_vpdev, struct nv_vfio_pci_device, vdev);
>>> +
>>> +    vfio_pci_core_unregister_device(core_vpdev);
>>> +    kfree(nvdev);
>>> +}
>>> +
>>> +static const struct pci_device_id nvlink2gpu_vfio_pci_table[] = {
>>> +    { PCI_VDEVICE(NVIDIA, 0x1DB1) }, /* GV100GL-A NVIDIA Tesla 
>>> V100-SXM2-16GB */
>>> +    { PCI_VDEVICE(NVIDIA, 0x1DB5) }, /* GV100GL-A NVIDIA Tesla 
>>> V100-SXM2-32GB */
>>> +    { PCI_VDEVICE(NVIDIA, 0x1DB8) }, /* GV100GL-A NVIDIA Tesla 
>>> V100-SXM3-32GB */
>>> +    { PCI_VDEVICE(NVIDIA, 0x1DF5) }, /* GV100GL-B NVIDIA Tesla 
>>> V100-SXM2-16GB */
>>
>>
>> Where is this list from?
>>
>> Also, how is this supposed to work at the boot time? Will the kernel 
>> try binding let's say this one and nouveau? Which one is going to win?
> 
> At boot time nouveau driver will win since the vfio drivers don't 
> declare MODULE_DEVICE_TABLE


ok but where is the list from anyway?


> 
> 
>>
>>
>>> +    { 0, }
>>
>>
>> Why a comma?
> 
> I'll remove the comma.
> 
> 
>>
>>> +};
>>
>>
>>
>>> +
>>> +static struct pci_driver nvlink2gpu_vfio_pci_driver = {
>>> +    .name            = "nvlink2gpu-vfio-pci",
>>> +    .id_table        = nvlink2gpu_vfio_pci_table,
>>> +    .probe            = nvlink2gpu_vfio_pci_probe,
>>> +    .remove            = nvlink2gpu_vfio_pci_remove,
>>> +#ifdef CONFIG_PCI_IOV
>>> +    .sriov_configure    = vfio_pci_core_sriov_configure,
>>> +#endif
>>
>>
>> What is this IOV business about?
> 
> from vfio_pci
> 
> #ifdef CONFIG_PCI_IOV
> module_param(enable_sriov, bool, 0644);
> MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV 
> configuration.  Enabling SR-IOV on a PF typically requires support of 
> the userspace PF driver, enabling VFs without such support may result in 
> non-functional VFs or PF.");
> #endif


I know what IOV is in general :) What I meant to say was that I am 
pretty sure these GPUs cannot do IOV so this does not need to be in 
these NVLink drivers.



> 
> 
>>
>>
>>> +    .err_handler        = &vfio_pci_core_err_handlers,
>>> +};
>>> +
>>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>>> +struct pci_driver *get_nvlink2gpu_vfio_pci_driver(struct pci_dev *pdev)
>>> +{
>>> +    if (pci_match_id(nvlink2gpu_vfio_pci_driver.id_table, pdev))
>>> +        return &nvlink2gpu_vfio_pci_driver;
>>
>>
>> Why do we need matching PCI ids here instead of looking at the FDT 
>> which will work better?
> 
> what is FDT ? any is it better to use it instead of match_id ?


Flattened Device Tree - a way for the firmware to pass the configuration 
to the OS. This data tells if there are NVLinks and what they are linked 
to. This defines if the feature is available as it should work with any 
GPU in this form factor.


> 
>>
>>
>>> +    return NULL;
>>> +}
>>> +EXPORT_SYMBOL_GPL(get_nvlink2gpu_vfio_pci_driver);
>>> +#endif
>>> +
>>> +module_pci_driver(nvlink2gpu_vfio_pci_driver);
>>> +
>>> +MODULE_VERSION(DRIVER_VERSION);
>>> +MODULE_LICENSE("GPL v2");
>>> +MODULE_AUTHOR(DRIVER_AUTHOR);
>>> +MODULE_DESCRIPTION(DRIVER_DESC);
>>> diff --git a/drivers/vfio/pci/nvlink2gpu_vfio_pci.h 
>>> b/drivers/vfio/pci/nvlink2gpu_vfio_pci.h
>>> new file mode 100644
>>> index 000000000000..ebd5b600b190
>>> --- /dev/null
>>> +++ b/drivers/vfio/pci/nvlink2gpu_vfio_pci.h
>>> @@ -0,0 +1,24 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +/*
>>> + * Copyright (c) 2020, Mellanox Technologies, Ltd.  All rights 
>>> reserved.
>>> + *     Author: Max Gurtovoy <mgurtovoy@nvidia.com>
>>> + */
>>> +
>>> +#ifndef NVLINK2GPU_VFIO_PCI_H
>>> +#define NVLINK2GPU_VFIO_PCI_H
>>> +
>>> +#include <linux/pci.h>
>>> +#include <linux/module.h>
>>> +
>>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>>> +#if defined(CONFIG_VFIO_PCI_NVLINK2GPU) || 
>>> defined(CONFIG_VFIO_PCI_NVLINK2GPU_MODULE)
>>> +struct pci_driver *get_nvlink2gpu_vfio_pci_driver(struct pci_dev 
>>> *pdev);
>>> +#else
>>> +struct pci_driver *get_nvlink2gpu_vfio_pci_driver(struct pci_dev *pdev)
>>> +{
>>> +    return NULL;
>>> +}
>>> +#endif
>>> +#endif
>>> +
>>> +#endif /* NVLINK2GPU_VFIO_PCI_H */
>>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>>> index dbc0a6559914..8e81ea039f31 100644
>>> --- a/drivers/vfio/pci/vfio_pci.c
>>> +++ b/drivers/vfio/pci/vfio_pci.c
>>> @@ -27,6 +27,10 @@
>>>   #include <linux/uaccess.h>
>>>     #include "vfio_pci_core.h"
>>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>>> +#include "npu2_vfio_pci.h"
>>> +#include "nvlink2gpu_vfio_pci.h"
>>> +#endif
>>>     #define DRIVER_VERSION  "0.2"
>>>   #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
>>> @@ -142,14 +146,48 @@ static const struct vfio_device_ops 
>>> vfio_pci_ops = {
>>>       .match        = vfio_pci_core_match,
>>>   };
>>>   +/*
>>> + * This layer is used for backward compatibility. Hopefully it will be
>>> + * removed in the future.
>>> + */
>>> +static struct pci_driver *vfio_pci_get_compat_driver(struct pci_dev 
>>> *pdev)
>>> +{
>>> +    switch (pdev->vendor) {
>>> +    case PCI_VENDOR_ID_NVIDIA:
>>> +        switch (pdev->device) {
>>> +        case 0x1db1:
>>> +        case 0x1db5:
>>> +        case 0x1db8:
>>> +        case 0x1df5:
>>> +            return get_nvlink2gpu_vfio_pci_driver(pdev);
>>
>> This does not really need a switch, could simply call these 
>> get_xxxx_vfio_pci_driver. Thanks,
> 
> maybe the result will be the same but I don't think we need to send all 
> NVIDIA devices or IBM devices to this function.

We can tolerate this on POWER (the check is really cheap) and for 
everybody else this driver won't even compile.


> we can maybe export the tables from the vfio_vendor driver and match it 
> here.


I am still missing the point of device matching. It won't bind by 
default at the boot time and it won't make the existing user life any 
easier as they use libvirt which overrides this anyway.


>>
>>
>>> +        default:
>>> +            return NULL;
>>> +        }
>>> +    case PCI_VENDOR_ID_IBM:
>>> +        switch (pdev->device) {
>>> +        case 0x04ea:
>>> +            return get_npu2_vfio_pci_driver(pdev);
>>> +        default:
>>> +            return NULL;
>>> +        }
>>> +    }
>>> +
>>> +    return NULL;
>>> +}
>>> +
>>>   static int vfio_pci_probe(struct pci_dev *pdev, const struct 
>>> pci_device_id *id)
>>>   {
>>>       struct vfio_pci_device *vpdev;
>>> +    struct pci_driver *driver;
>>>       int ret;
>>>         if (vfio_pci_is_denylisted(pdev))
>>>           return -EINVAL;
>>>   +    driver = vfio_pci_get_compat_driver(pdev);
>>> +    if (driver)
>>> +        return driver->probe(pdev, id);
>>> +
>>>       vpdev = kzalloc(sizeof(*vpdev), GFP_KERNEL);
>>>       if (!vpdev)
>>>           return -ENOMEM;
>>> @@ -167,14 +205,21 @@ static int vfio_pci_probe(struct pci_dev *pdev, 
>>> const struct pci_device_id *id)
>>>     static void vfio_pci_remove(struct pci_dev *pdev)
>>>   {
>>> -    struct vfio_device *vdev = dev_get_drvdata(&pdev->dev);
>>> -    struct vfio_pci_core_device *core_vpdev = vfio_device_data(vdev);
>>> -    struct vfio_pci_device *vpdev;
>>> -
>>> -    vpdev = container_of(core_vpdev, struct vfio_pci_device, vdev);
>>> -
>>> -    vfio_pci_core_unregister_device(core_vpdev);
>>> -    kfree(vpdev);
>>> +    struct pci_driver *driver;
>>> +
>>> +    driver = vfio_pci_get_compat_driver(pdev);
>>> +    if (driver) {
>>> +        driver->remove(pdev);
>>> +    } else {
>>> +        struct vfio_device *vdev = dev_get_drvdata(&pdev->dev);
>>> +        struct vfio_pci_core_device *core_vpdev;
>>> +        struct vfio_pci_device *vpdev;
>>> +
>>> +        core_vpdev = vfio_device_data(vdev);
>>> +        vpdev = container_of(core_vpdev, struct vfio_pci_device, vdev);
>>> +        vfio_pci_core_unregister_device(core_vpdev);
>>> +        kfree(vpdev);
>>> +    }
>>>   }
>>>     static int vfio_pci_sriov_configure(struct pci_dev *pdev, int 
>>> nr_virtfn)
>>> diff --git a/drivers/vfio/pci/vfio_pci_core.c 
>>> b/drivers/vfio/pci/vfio_pci_core.c
>>> index 4de8e352df9c..f9b39abe54cb 100644
>>> --- a/drivers/vfio/pci/vfio_pci_core.c
>>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>>> @@ -354,24 +354,6 @@ int vfio_pci_core_enable(struct 
>>> vfio_pci_core_device *vdev)
>>>           }
>>>       }
>>>   -    if (pdev->vendor == PCI_VENDOR_ID_NVIDIA &&
>>> -        IS_ENABLED(CONFIG_VFIO_PCI_NVLINK2)) {
>>> -        ret = vfio_pci_nvidia_v100_nvlink2_init(vdev);
>>> -        if (ret && ret != -ENODEV) {
>>> -            pci_warn(pdev, "Failed to setup NVIDIA NV2 RAM region\n");
>>> -            goto disable_exit;
>>> -        }
>>> -    }
>>> -
>>> -    if (pdev->vendor == PCI_VENDOR_ID_IBM &&
>>> -        IS_ENABLED(CONFIG_VFIO_PCI_NVLINK2)) {
>>> -        ret = vfio_pci_ibm_npu2_init(vdev);
>>> -        if (ret && ret != -ENODEV) {
>>> -            pci_warn(pdev, "Failed to setup NVIDIA NV2 ATSD region\n");
>>> -            goto disable_exit;
>>> -        }
>>> -    }
>>> -
>>>       return 0;
>>>     disable_exit:
>>> diff --git a/drivers/vfio/pci/vfio_pci_core.h 
>>> b/drivers/vfio/pci/vfio_pci_core.h
>>> index 8989443c3086..31f3836e606e 100644
>>> --- a/drivers/vfio/pci/vfio_pci_core.h
>>> +++ b/drivers/vfio/pci/vfio_pci_core.h
>>> @@ -204,20 +204,6 @@ static inline int vfio_pci_igd_init(struct 
>>> vfio_pci_core_device *vdev)
>>>       return -ENODEV;
>>>   }
>>>   #endif
>>> -#ifdef CONFIG_VFIO_PCI_NVLINK2
>>> -extern int vfio_pci_nvidia_v100_nvlink2_init(struct 
>>> vfio_pci_core_device *vdev);
>>> -extern int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device *vdev);
>>> -#else
>>> -static inline int vfio_pci_nvidia_v100_nvlink2_init(struct 
>>> vfio_pci_core_device *vdev)
>>> -{
>>> -    return -ENODEV;
>>> -}
>>> -
>>> -static inline int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device 
>>> *vdev)
>>> -{
>>> -    return -ENODEV;
>>> -}
>>> -#endif
>>>     #ifdef CONFIG_S390
>>>   extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device 
>>> *vdev,
>>>
>>

-- 
Alexey
