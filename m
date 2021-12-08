Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631C646D16A
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 11:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhLHLAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 06:00:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:24648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229448AbhLHLAJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 06:00:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638960997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q5ClhyCGXrmZktq97iYYkzt/NJFw3ujqnADvCs/Dzzw=;
        b=FV0DU08LSJTaauecAwhbX6Bxc/BoEV3cSANtbAHJH7Pp/EEVVX16mTsjT5VCA5+Nfqavqy
        czdmMxLOK/4VBCaE3Kt5cE3KsSdq9Wb3kJR3qVZ4yLM6x2muVGPn2PzQu6QC9o0aUeXd9G
        puF+73457oFmMT2+ihnGHFhCL10reVQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-CajGVetOMS6GLA6csEptLA-1; Wed, 08 Dec 2021 05:56:36 -0500
X-MC-Unique: CajGVetOMS6GLA6csEptLA-1
Received: by mail-wm1-f71.google.com with SMTP id l6-20020a05600c4f0600b0033321934a39so1237470wmq.9
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 02:56:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=q5ClhyCGXrmZktq97iYYkzt/NJFw3ujqnADvCs/Dzzw=;
        b=tXDZXGMke0KJFved0PVLOY1+p5k/p021Yk1zMrrByyuYf5WCXrIsuuhF+HXM0bVNvS
         cz+En2x19q7odPewQf/pDGEXodNFmnFC0Wl7Mu+LSyqcZm7WXSbaKffMbOKInwTHdGhf
         42Ejil+742pdQOm157Hh8lZHsnI57g23LinkG8XIRMdSd6Ydjv5994HHbXdv3+4eTJ+r
         dz9ocgUW5I2ip1j6obxkokmjrzd+IsyeXjFltd7EPwR0AanBH0aPH0R01MrwNFOlBPsP
         BXeeljcS1gHiztRnwErikyiXqDxlo4wV9ORs0X8IAvgTi2enMUyHl3G7/1xJkHC3tsnI
         02MA==
X-Gm-Message-State: AOAM531khXGPKYEeaqyUTeghjC92/aFxn2yFceu32Ax2I6mpwplRklRp
        1x5R9J+XhSoXRqaeSheWgsC6vI/HiSH0JvQnnerLs86Ozc6wt/dhocFZsfMJOhG3VWp3VoVksum
        J6wxYe8UavW9g
X-Received: by 2002:a05:600c:4f0f:: with SMTP id l15mr14908754wmq.25.1638960995229;
        Wed, 08 Dec 2021 02:56:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxuH6/w5gdwKae12vopSKZ3jDJAEPn8ehe2ONl/VHm/nSErcvebzKNJ+7JHxbkm+G3+GpnWLA==
X-Received: by 2002:a05:600c:4f0f:: with SMTP id l15mr14908721wmq.25.1638960994987;
        Wed, 08 Dec 2021 02:56:34 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id n13sm2415163wrt.44.2021.12.08.02.56.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 02:56:34 -0800 (PST)
Message-ID: <a23e2c04-3db4-5c52-5196-7cf012e02ba1@redhat.com>
Date:   Wed, 8 Dec 2021 11:56:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
 <20211207210425.150923-8-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 07/12] s390x/pci: enable for load/store intepretation
In-Reply-To: <20211207210425.150923-8-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/2021 22.04, Matthew Rosato wrote:
> Use the associated vfio feature ioctl to enable interpretation for devices
> when requested.  As part of this process, we must use the host function
> handle rather than a QEMU-generated one -- this is provided as part of the
> ioctl payload.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-pci-bus.c          | 69 +++++++++++++++++++++++++++++++-
>   hw/s390x/s390-pci-inst.c         | 63 ++++++++++++++++++++++++++++-
>   hw/s390x/s390-pci-vfio.c         | 55 +++++++++++++++++++++++++
>   include/hw/s390x/s390-pci-bus.h  |  1 +
>   include/hw/s390x/s390-pci-vfio.h | 15 +++++++
>   5 files changed, 201 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
> index 01b58ebc70..451bd32d92 100644
> --- a/hw/s390x/s390-pci-bus.c
> +++ b/hw/s390x/s390-pci-bus.c
> @@ -971,12 +971,57 @@ static void s390_pci_update_subordinate(PCIDevice *dev, uint32_t nr)
>       }
>   }
>   
> +static int s390_pci_interp_plug(S390pciState *s, S390PCIBusDevice *pbdev)
> +{
> +    uint32_t idx;
> +    int rc;
> +
> +    rc = s390_pci_probe_interp(pbdev);
> +    if (rc) {
> +        return rc;
> +    }
> +
> +    rc = s390_pci_update_passthrough_fh(pbdev);
> +    if (rc) {
> +        return rc;
> +    }
> +
> +    /*
> +     * The host device is in an enabled state, but the device must
> +     * begin as disabled for the guest so mask off the enable bit
> +     * from the passthrough handle.
> +     */
> +    pbdev->fh &= ~FH_MASK_ENABLE;
> +
> +    /* Next, see if the idx is already in-use */
> +    idx = pbdev->fh & FH_MASK_INDEX;
> +    if (pbdev->idx != idx) {
> +        if (s390_pci_find_dev_by_idx(s, idx)) {
> +            return -EINVAL;
> +        }
> +        /*
> +         * Update the idx entry with the passed through idx
> +         * If the relinquised idx is lower than next_idx, use it

s/relinquised/relinquished/

> +         * to replace next_idx
> +         */
> +        g_hash_table_remove(s->zpci_table, &pbdev->idx);
> +        if (idx < s->next_idx) {
> +            s->next_idx = idx;
> +        }
> +        pbdev->idx = idx;
> +        g_hash_table_insert(s->zpci_table, &pbdev->idx, pbdev);
> +    }
> +
> +    return 0;
> +}
[...]
> diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
> index 6f80a47e29..78093aaac7 100644
> --- a/hw/s390x/s390-pci-vfio.c
> +++ b/hw/s390x/s390-pci-vfio.c
> @@ -97,6 +97,61 @@ void s390_pci_end_dma_count(S390pciState *s, S390PCIDMACount *cnt)
>       }
>   }
>   
> +int s390_pci_probe_interp(S390PCIBusDevice *pbdev)
> +{
> +    VFIOPCIDevice *vdev = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
> +    struct vfio_device_feature feat = {
> +        .argsz = sizeof(struct vfio_device_feature),
> +        .flags = VFIO_DEVICE_FEATURE_PROBE + VFIO_DEVICE_FEATURE_ZPCI_INTERP
> +    };
> +
> +    return ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, &feat);
> +}
> +
> +int s390_pci_set_interp(S390PCIBusDevice *pbdev, bool enable)
> +{
> +    VFIOPCIDevice *vdev = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
> +    g_autofree struct vfio_device_feature *feat;

IIRC there have been compiler versions that complain if a g_autofree 
variable is initialized at the point of declaration, so you might need to 
add the "= g_malloc0(size)" here already.

> +    struct vfio_device_zpci_interp *data;
> +    int size;
> +
> +    size = sizeof(*feat) + sizeof(*data);
> +    feat = g_malloc0(size);
> +    feat->argsz = size;
> +    feat->flags = VFIO_DEVICE_FEATURE_SET + VFIO_DEVICE_FEATURE_ZPCI_INTERP;
> +
> +    data = (struct vfio_device_zpci_interp *)&feat->data;
> +    if (enable) {
> +        data->flags = VFIO_DEVICE_ZPCI_FLAG_INTERP;
> +    } else {
> +        data->flags = 0;
> +    }
> +
> +    return ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, feat);
> +}
> +
> +int s390_pci_update_passthrough_fh(S390PCIBusDevice *pbdev)
> +{
> +    VFIOPCIDevice *vdev = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
> +    g_autofree struct vfio_device_feature *feat;

dito

> +    struct vfio_device_zpci_interp *data;
> +    int size, rc;
> +
> +    size = sizeof(*feat) + sizeof(*data);
> +    feat = g_malloc0(size);
> +    feat->argsz = size;
> +    feat->flags = VFIO_DEVICE_FEATURE_GET + VFIO_DEVICE_FEATURE_ZPCI_INTERP;
> +
> +    rc = ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, feat);
> +    if (rc) {
> +        return rc;
> +    }
> +
> +    data = (struct vfio_device_zpci_interp *)&feat->data;
> +    pbdev->fh = data->fh;
> +    return 0;
> +}

  Thomas

