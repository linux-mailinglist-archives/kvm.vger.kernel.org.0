Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5714E46D234
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 12:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhLHLdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 06:33:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37194 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232483AbhLHLdT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 06:33:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638962987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N2b62NQXKOt8ppnkv+Bg3xKl55NRicgHvHjq4fhYetg=;
        b=NnvIhmYG2ClL4IBmz45tjC9VNz27VnW5Tnnj0zKJaeUvy6K3l1CumpBB8w9/CSefLTAZgF
        LJUImsKkVbGUHSyatVmUuGkdNw19S1Ds1heNcuQL6ZDRuOj4eScG/ouhmc/8f6i5ShVeDP
        13kPv/h7IAgWitRAhfszv80qCKeuHAQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-8Lxksdw1MtqDK4Hx4POchA-1; Wed, 08 Dec 2021 06:29:46 -0500
X-MC-Unique: 8Lxksdw1MtqDK4Hx4POchA-1
Received: by mail-wr1-f69.google.com with SMTP id b1-20020a5d6341000000b001901ddd352eso308539wrw.7
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 03:29:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=N2b62NQXKOt8ppnkv+Bg3xKl55NRicgHvHjq4fhYetg=;
        b=UZItKHVdKVfickleTKnkih5cvNHJU0fnzcO88HEX7LuLzsNsMNE38ZTY+/dpgfmRGl
         mMcEAIDE5k2K7Np6wnDi44DQ0wuFn3li7/oq1nKXn1JRiAFUSlffjRnAsm8cL2WIEEgT
         hoeVp2jqlmUpyp9d8FVnlM7Rd16AUeQ9Amp0aSAfDaz/0O0vm8DMiHtT+OUqimKuBGNA
         1IKXAZzG5VjLXV1M91M35DGG6CGYETXgEY2D2XpVvu3BbCKfx7Y/yWiu/d+/4J0cnMr1
         ZPe7micJg3gZJIlF2OHURNoKg1nR3BEukjDAo6pJNTySdiUG0s0fEZTi26ZlAgqZqFwK
         CuFA==
X-Gm-Message-State: AOAM530kOfKM4AmqgCRS60zBnEkOOfB4ecYVUXN2GBXl9qiq0oWrzqRU
        51RarzvD1EVYv/2BaP0EUFOvGIx+vGfa9kYW0b/cZij2ujOCMrOTwPNY3ImZhj5hL3wQz/NrBZz
        wKilIH+/1UYh7
X-Received: by 2002:a05:600c:2292:: with SMTP id 18mr15358092wmf.6.1638962984929;
        Wed, 08 Dec 2021 03:29:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwDBkCT2nOYJ9nLv7falHMNfi4tp2O1mOqA3XtIs880cErvvJYO9FXvHpNY7ZCZk3BazlIczg==
X-Received: by 2002:a05:600c:2292:: with SMTP id 18mr15358051wmf.6.1638962984642;
        Wed, 08 Dec 2021 03:29:44 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id r8sm3060095wrz.43.2021.12.08.03.29.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 03:29:44 -0800 (PST)
Message-ID: <6e4e0755-3ecb-c9d8-6e09-9cee5c9f3fb7@redhat.com>
Date:   Wed, 8 Dec 2021 12:29:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 09/12] s390x/pci: enable adapter event notification for
 interpreted devices
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
 <20211207210425.150923-10-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20211207210425.150923-10-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/2021 22.04, Matthew Rosato wrote:
> Use the associated vfio feature ioctl to enable adapter event notification
> and forwarding for devices when requested.  This feature will be set up
> with or without firmware assist based upon the 'intassist' setting.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-pci-bus.c          | 24 +++++++--
>   hw/s390x/s390-pci-inst.c         | 54 +++++++++++++++++++-
>   hw/s390x/s390-pci-vfio.c         | 88 ++++++++++++++++++++++++++++++++
>   include/hw/s390x/s390-pci-bus.h  |  1 +
>   include/hw/s390x/s390-pci-vfio.h | 20 ++++++++
>   5 files changed, 182 insertions(+), 5 deletions(-)
[...]
> diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
> index 78093aaac7..6f9271df87 100644
> --- a/hw/s390x/s390-pci-vfio.c
> +++ b/hw/s390x/s390-pci-vfio.c
> @@ -152,6 +152,94 @@ int s390_pci_update_passthrough_fh(S390PCIBusDevice *pbdev)
>       return 0;
>   }
>   
> +int s390_pci_probe_aif(S390PCIBusDevice *pbdev)
> +{
> +    VFIOPCIDevice *vdev = container_of(pbdev->pdev, VFIOPCIDevice, pdev);

Should this use VFIO_PCI() instead of container_of ?

> +    struct vfio_device_feature feat = {
> +        .argsz = sizeof(struct vfio_device_feature),
> +        .flags = VFIO_DEVICE_FEATURE_PROBE + VFIO_DEVICE_FEATURE_ZPCI_AIF
> +    };
> +
> +    assert(vdev);

... then you could likely also drop the assert(), I think?

> +    return ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, &feat);
> +}
> +
> +int s390_pci_set_aif(S390PCIBusDevice *pbdev, ZpciFib *fib, bool enable,
> +                     bool assist)
> +{
> +    VFIOPCIDevice *vdev = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
> +    g_autofree struct vfio_device_feature *feat;
> +    struct vfio_device_zpci_aif *data;
> +    int size;
> +
> +    assert(vdev);

dito

> +    size = sizeof(*feat) + sizeof(*data);
> +    feat = g_malloc0(size);
> +    feat->argsz = size;
> +    feat->flags = VFIO_DEVICE_FEATURE_SET + VFIO_DEVICE_FEATURE_ZPCI_AIF;
> +
> +    data = (struct vfio_device_zpci_aif *)&feat->data;
> +    if (enable) {
> +        data->flags = VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT;
> +        if (!pbdev->intassist) {
> +            data->flags |= VFIO_DEVICE_ZPCI_FLAG_AIF_HOST;
> +        }
> +        /* Fill in the guest fib info */
> +        data->ibv = fib->aibv;
> +        data->sb = fib->aisb;
> +        data->noi = FIB_DATA_NOI(fib->data);
> +        data->isc = FIB_DATA_ISC(fib->data);
> +        data->sbo = FIB_DATA_AISBO(fib->data);
> +    } else {
> +        data->flags = 0;
> +    }
> +
> +    return ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, feat);
> +}
> +
> +int s390_pci_get_aif(S390PCIBusDevice *pbdev, bool enable, bool assist)
> +{
> +    VFIOPCIDevice *vdev = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
> +    g_autofree struct vfio_device_feature *feat;
> +    struct vfio_device_zpci_aif *data;
> +    int size, rc;
> +
> +    assert(vdev);

dito

> +    size = sizeof(*feat) + sizeof(*data);
> +    feat = g_malloc0(size);
> +    feat->argsz = size;
> +    feat->flags = VFIO_DEVICE_FEATURE_GET + VFIO_DEVICE_FEATURE_ZPCI_AIF;
> +
> +    rc = ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, feat);
> +    if (rc) {
> +        return rc;
> +    }
> +
> +    /* Determine if current interrupt settings match the host */
> +    data = (struct vfio_device_zpci_aif *)&feat->data;
> +    if (enable && (!(data->flags & VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT))) {
> +        rc = -EINVAL;
> +    } else if (!enable && (data->flags & VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT)) {
> +        rc = -EINVAL;
> +    }
> +
> +    /*
> +     * When enabled for interrupts, the assist and forced host-delivery are
> +     * mututally exclusive
> +     */
> +    if (enable && assist && (data->flags & VFIO_DEVICE_ZPCI_FLAG_AIF_HOST)) {
> +        rc = -EINVAL;
> +    } else if (enable && (!assist) && (!(data->flags &
> +                                         VFIO_DEVICE_ZPCI_FLAG_AIF_HOST))) {
> +        rc = -EINVAL;
> +    }
> +
> +    return rc;
> +}

  Thomas

