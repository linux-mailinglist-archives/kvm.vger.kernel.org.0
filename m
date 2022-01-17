Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2490D490AC2
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 15:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237201AbiAQOwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 09:52:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237192AbiAQOwB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 09:52:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642431121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JYAtZcjyuoX0DjZkPIZLJjV+OOG9FhqW9aqSYkAjkg4=;
        b=SpfNsmbvV2Gzxzp+LuWQHOYRQecUsCh/V2jH0KmbV/omJCOZW7o44ZieLw6sXZ4pKORkP8
        7PbAqXWtRjNi7Qba4wbyAakJaKFJ5zLAGkoBJMFssXuwDyJua0GmedHKDHNB7y6d2Ecy/X
        iA2ro6C1TQJqRc6XstUPtzXVj7FgIUA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-UDry3s3lNO64r2aYtoOHBg-1; Mon, 17 Jan 2022 09:51:59 -0500
X-MC-Unique: UDry3s3lNO64r2aYtoOHBg-1
Received: by mail-wm1-f71.google.com with SMTP id a68-20020a1c9847000000b00346939a2d7cso12571wme.1
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 06:51:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JYAtZcjyuoX0DjZkPIZLJjV+OOG9FhqW9aqSYkAjkg4=;
        b=gdr8Li+YTRuFOoqqB6IvELzF+ggaJf5Qvo5FC007ocqIW7WiXPlY+TYh0ikTKzZz95
         PuxltZBTMNuZuqgC7ILc13LtRXaKk6hOPt5+Mdz9gBFCBFTf/AwA4h/7lfhQypcgTOv8
         JGWak1ArlF1wnbz2u8y8u0KPlrrUrc10DsvQzQfXj2DQ5REYFuhcH/zDkbd2f/K3FJ+1
         f//GUKrUNozn0m6hDj4vKC69Lt8KajBF7PEWRu6k7H3PEzfHMCoeulDjddLwZZxjRecE
         vtYic0Y5SQS4VeskA9fbTBizu93N48gYCgUEIKwMR25stQoL39pcb3jhoZ6/GQV4eTAc
         GO7A==
X-Gm-Message-State: AOAM530yJHfLjJwl80XbFhzJrHbGNfdWz5vSd7oeCSfN6jpuil2CXaq9
        yyiMDGATUTlsKAj6uxCcjH4zfBP+Ung8SdhVx5eW66lmc0A3PDb4c0QfXEm88aG1NVNtriy/mn2
        gYK8KYJRN+0cZ
X-Received: by 2002:a05:6000:101:: with SMTP id o1mr20002496wrx.173.1642431118294;
        Mon, 17 Jan 2022 06:51:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyayeNL3WusA1PdWvtbjUbFmtFwRg6j5ZoTNy/AM2OabqsS9JtSXb1LfP0FA4rQJR+v0S+8WQ==
X-Received: by 2002:a05:6000:101:: with SMTP id o1mr20002471wrx.173.1642431118056;
        Mon, 17 Jan 2022 06:51:58 -0800 (PST)
Received: from [192.168.8.100] (tmo-098-68.customers.d1-online.com. [80.187.98.68])
        by smtp.gmail.com with ESMTPSA id g13sm4945512wmq.22.2022.01.17.06.51.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 06:51:57 -0800 (PST)
Message-ID: <27a1db36-5664-6c90-ec39-aa6da5c23c31@redhat.com>
Date:   Mon, 17 Jan 2022 15:51:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 4/9] s390x/pci: enable for load/store intepretation
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220114203849.243657-1-mjrosato@linux.ibm.com>
 <20220114203849.243657-5-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220114203849.243657-5-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/2022 21.38, Matthew Rosato wrote:
> Use the associated vfio feature ioctl to enable interpretation for devices
> when requested.  As part of this process, we must use the host function
> handle rather than a QEMU-generated one -- this is provided as part of the
> ioctl payload.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-pci-bus.c          | 70 +++++++++++++++++++++++++++++++-
>   hw/s390x/s390-pci-inst.c         | 63 +++++++++++++++++++++++++++-
>   hw/s390x/s390-pci-vfio.c         | 52 ++++++++++++++++++++++++
>   include/hw/s390x/s390-pci-bus.h  |  1 +
>   include/hw/s390x/s390-pci-vfio.h | 15 +++++++
>   5 files changed, 199 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
> index 01b58ebc70..a39ccfee05 100644
> --- a/hw/s390x/s390-pci-bus.c
> +++ b/hw/s390x/s390-pci-bus.c
> @@ -971,12 +971,58 @@ static void s390_pci_update_subordinate(PCIDevice *dev, uint32_t nr)
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
> +     * The host device is already in an enabled state, but we always present
> +     * the initial device state to the guest as disabled (ZPCI_FS_DISABLED).
> +     * Therefore, mask off the enable bit from the passthrough handle until
> +     * the guest issues a CLP SET PCI FN later to enable the device.
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
> +         * If the relinquished idx is lower than next_idx, use it
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
> +
>   static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
>                                 Error **errp)
>   {
>       S390pciState *s = S390_PCI_HOST_BRIDGE(hotplug_dev);
>       PCIDevice *pdev = NULL;
>       S390PCIBusDevice *pbdev = NULL;
> +    int rc;
>   
>       if (object_dynamic_cast(OBJECT(dev), TYPE_PCI_BRIDGE)) {
>           PCIBridge *pb = PCI_BRIDGE(dev);
> @@ -1022,12 +1068,33 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
>           set_pbdev_info(pbdev);
>   
>           if (object_dynamic_cast(OBJECT(dev), "vfio-pci")) {
> -            pbdev->fh |= FH_SHM_VFIO;
> +            /*
> +             * By default, interpretation is always requested; if the available
> +             * facilities indicate it is not available, fallback to the
> +             * intercept model.
> +             */
> +            if (pbdev->interp && !s390_has_feat(S390_FEAT_ZPCI_INTERP)) {
> +                    DPRINTF("zPCI interpretation facilities missing.\n");
> +                    pbdev->interp = false;
> +                }

Wrong indentation in the above three lines.

> +            if (pbdev->interp) {
> +                rc = s390_pci_interp_plug(s, pbdev);
> +                if (rc) {
> +                    error_setg(errp, "zpci interp plug failed: %d", rc);

The error message is a little bit scarce for something that might be 
presented to the user - maybe write at least "interpretation" instead of 
"interp" ?

> +                    return;
> +                }
> +            }
>               pbdev->iommu->dma_limit = s390_pci_start_dma_count(s, pbdev);
>               /* Fill in CLP information passed via the vfio region */
>               s390_pci_get_clp_info(pbdev);
> +            if (!pbdev->interp) {
> +                /* Do vfio passthrough but intercept for I/O */
> +                pbdev->fh |= FH_SHM_VFIO;
> +            }
>           } else {
>               pbdev->fh |= FH_SHM_EMUL;
> +            /* Always intercept emulated devices */
> +            pbdev->interp = false;
>           }

  Thomas

