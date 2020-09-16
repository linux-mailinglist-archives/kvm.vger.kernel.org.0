Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622B826BDDC
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 09:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIPHVu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 03:21:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23298 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726068AbgIPHVr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Sep 2020 03:21:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600240905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=/ntZJ94sVhml7F6QGwY1ka6seOdgBVzBCWZIpJzkMdg=;
        b=hlAxkVmworZbdZFW/JswmDNH/ERmUq4Mof43jkLWVTrNtFB4LADGRknmro+DPIsUAf3UW6
        v1LIx7gh8cpQ6KRhLit2h93E5IosHqf6g5zfs59MMHnx+4WzDnKK/DXp3ND+ygmh9nrgFF
        jbiSbFUV1WiwdqR0nqZaDV2hc8bY34k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-BxoBUXjqOJK3Fe4PN3M0Sg-1; Wed, 16 Sep 2020 03:21:43 -0400
X-MC-Unique: BxoBUXjqOJK3Fe4PN3M0Sg-1
Received: by mail-wr1-f69.google.com with SMTP id a2so729053wrp.8
        for <kvm@vger.kernel.org>; Wed, 16 Sep 2020 00:21:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/ntZJ94sVhml7F6QGwY1ka6seOdgBVzBCWZIpJzkMdg=;
        b=RNXeIzugbaKT4+ET2V/Ejb2Cfc7AchcEPdPo2CMg55zPmpNlv4vPQQLR7Onj2IVf3R
         y8tuypU4XmmCUSkw+7utyIx2ep7M+LN3EaHawgulfGhaiG0Zu5u9xlj6E4R7BnqXe1Pd
         e41ZGQFsKmxG2d3ME0Lw6/nvYEnj3O6UNniZmyZ/BhsaHewCwM9xatu8UjS2BVA95our
         SnRVrCHrINiGueYH24191CBFp3yPWMTjSV96egoeM0Cfw2m1R2xk1ze1FvAV7pYzLRcI
         VJ+uGcV/CD52lGfWwEHTQFQt/bhN9uFM0ij2edcMkYIq/GPSR44gMLXQFsGlB9/ou10F
         nBXA==
X-Gm-Message-State: AOAM5315fhj20TnoWU0pPRVYMUHLAilO4F6tmoAl6l2SuYPRUhpWlLCc
        B31X6H+0NHaiTJD7UdrpC+oDdjK35uckJypaY02eh/UnDQCVW6+GZ1UVk8QAuM6/6gKA9oFfTc9
        Ly1R23fJCQzCA
X-Received: by 2002:adf:8405:: with SMTP id 5mr26544674wrf.143.1600240902583;
        Wed, 16 Sep 2020 00:21:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxveW5ZKttEfu6YcpwQp97AFO4qzv+g2WbKR94OvaPDa2bskx5HAVRXek7bCtck0hCXJNX1g==
X-Received: by 2002:adf:8405:: with SMTP id 5mr26544650wrf.143.1600240902384;
        Wed, 16 Sep 2020 00:21:42 -0700 (PDT)
Received: from [192.168.1.36] (65.red-83-57-170.dynamicip.rima-tde.net. [83.57.170.65])
        by smtp.gmail.com with ESMTPSA id u12sm3553135wrt.81.2020.09.16.00.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2020 00:21:41 -0700 (PDT)
Subject: Re: [PATCH v3 4/5] s390x/pci: Add routine to get the vfio dma
 available count
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        alex.williamson@redhat.com, cohuck@redhat.com
Cc:     thuth@redhat.com, kvm@vger.kernel.org, pmorel@linux.ibm.com,
        david@redhat.com, schnelle@linux.ibm.com, qemu-devel@nongnu.org,
        pasic@linux.ibm.com, borntraeger@de.ibm.com, qemu-s390x@nongnu.org,
        mst@redhat.com, pbonzini@redhat.com, rth@twiddle.net
References: <1600197283-25274-1-git-send-email-mjrosato@linux.ibm.com>
 <1600197283-25274-5-git-send-email-mjrosato@linux.ibm.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Autocrypt: addr=philmd@redhat.com; keydata=
 mQINBDXML8YBEADXCtUkDBKQvNsQA7sDpw6YLE/1tKHwm24A1au9Hfy/OFmkpzo+MD+dYc+7
 bvnqWAeGweq2SDq8zbzFZ1gJBd6+e5v1a/UrTxvwBk51yEkadrpRbi+r2bDpTJwXc/uEtYAB
 GvsTZMtiQVA4kRID1KCdgLa3zztPLCj5H1VZhqZsiGvXa/nMIlhvacRXdbgllPPJ72cLUkXf
 z1Zu4AkEKpccZaJspmLWGSzGu6UTZ7UfVeR2Hcc2KI9oZB1qthmZ1+PZyGZ/Dy+z+zklC0xl
 XIpQPmnfy9+/1hj1LzJ+pe3HzEodtlVA+rdttSvA6nmHKIt8Ul6b/h1DFTmUT1lN1WbAGxmg
 CH1O26cz5nTrzdjoqC/b8PpZiT0kO5MKKgiu5S4PRIxW2+RA4H9nq7nztNZ1Y39bDpzwE5Sp
 bDHzd5owmLxMLZAINtCtQuRbSOcMjZlg4zohA9TQP9krGIk+qTR+H4CV22sWldSkVtsoTaA2
 qNeSJhfHQY0TyQvFbqRsSNIe2gTDzzEQ8itsmdHHE/yzhcCVvlUzXhAT6pIN0OT+cdsTTfif
 MIcDboys92auTuJ7U+4jWF1+WUaJ8gDL69ThAsu7mGDBbm80P3vvUZ4fQM14NkxOnuGRrJxO
 qjWNJ2ZUxgyHAh5TCxMLKWZoL5hpnvx3dF3Ti9HW2dsUUWICSQARAQABtDJQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoUGhpbCkgPHBoaWxtZEByZWRoYXQuY29tPokCVQQTAQgAPwIbDwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQSJweePYB7obIZ0lcuio/1u3q3A3gUCXsfWwAUJ
 KtymWgAKCRCio/1u3q3A3ircD/9Vjh3aFNJ3uF3hddeoFg1H038wZr/xi8/rX27M1Vj2j9VH
 0B8Olp4KUQw/hyO6kUxqkoojmzRpmzvlpZ0cUiZJo2bQIWnvScyHxFCv33kHe+YEIqoJlaQc
 JfKYlbCoubz+02E2A6bFD9+BvCY0LBbEj5POwyKGiDMjHKCGuzSuDRbCn0Mz4kCa7nFMF5Jv
 piC+JemRdiBd6102ThqgIsyGEBXuf1sy0QIVyXgaqr9O2b/0VoXpQId7yY7OJuYYxs7kQoXI
 6WzSMpmuXGkmfxOgbc/L6YbzB0JOriX0iRClxu4dEUg8Bs2pNnr6huY2Ft+qb41RzCJvvMyu
 gS32LfN0bTZ6Qm2A8ayMtUQgnwZDSO23OKgQWZVglGliY3ezHZ6lVwC24Vjkmq/2yBSLakZE
 6DZUjZzCW1nvtRK05ebyK6tofRsx8xB8pL/kcBb9nCuh70aLR+5cmE41X4O+MVJbwfP5s/RW
 9BFSL3qgXuXso/3XuWTQjJJGgKhB6xXjMmb1J4q/h5IuVV4juv1Fem9sfmyrh+Wi5V1IzKI7
 RPJ3KVb937eBgSENk53P0gUorwzUcO+ASEo3Z1cBKkJSPigDbeEjVfXQMzNt0oDRzpQqH2vp
 apo2jHnidWt8BsckuWZpxcZ9+/9obQ55DyVQHGiTN39hkETy3Emdnz1JVHTU0Q==
Message-ID: <0b28ae63-faad-953d-85c2-04bcdefeb7bf@redhat.com>
Date:   Wed, 16 Sep 2020 09:21:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1600197283-25274-5-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/20 9:14 PM, Matthew Rosato wrote:
> Create new files for separating out vfio-specific work for s390
> pci. Add the first such routine, which issues VFIO_IOMMU_GET_INFO
> ioctl to collect the current dma available count.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  hw/s390x/meson.build     |  1 +
>  hw/s390x/s390-pci-vfio.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++
>  hw/s390x/s390-pci-vfio.h | 17 +++++++++++++++
>  3 files changed, 72 insertions(+)
>  create mode 100644 hw/s390x/s390-pci-vfio.c
>  create mode 100644 hw/s390x/s390-pci-vfio.h
> 
> diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
> index b63782d..ed2f66b 100644
> --- a/hw/s390x/meson.build
> +++ b/hw/s390x/meson.build
> @@ -10,6 +10,7 @@ s390x_ss.add(files(
>    's390-ccw.c',
>    's390-pci-bus.c',
>    's390-pci-inst.c',
> +  's390-pci-vfio.c',
>    's390-skeys.c',
>    's390-stattrib.c',
>    's390-virtio-hcall.c',
> diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
> new file mode 100644
> index 0000000..75e3ac1
> --- /dev/null
> +++ b/hw/s390x/s390-pci-vfio.c
> @@ -0,0 +1,54 @@
> +/*
> + * s390 vfio-pci interfaces
> + *
> + * Copyright 2020 IBM Corp.
> + * Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +
> +#include <sys/ioctl.h>
> +
> +#include "qemu/osdep.h"
> +#include "s390-pci-vfio.h"
> +#include "hw/vfio/vfio-common.h"
> +
> +/*
> + * Get the current DMA available count from vfio.  Returns true if vfio is
> + * limiting DMA requests, false otherwise.  The current available count read
> + * from vfio is returned in avail.
> + */
> +bool s390_pci_update_dma_avail(int fd, unsigned int *avail)
> +{
> +    g_autofree struct vfio_iommu_type1_info *info;
> +    uint32_t argsz;
> +    int ret;
> +
> +    assert(avail);
> +
> +    argsz = sizeof(struct vfio_iommu_type1_info);
> +    info = g_malloc0(argsz);
> +    info->argsz = argsz;
> +    /*
> +     * If the specified argsz is not large enough to contain all
> +     * capabilities it will be updated upon return.  In this case
> +     * use the updated value to get the entire capability chain.
> +     */
> +    ret = ioctl(fd, VFIO_IOMMU_GET_INFO, info);
> +    if (argsz != info->argsz) {
> +        argsz = info->argsz;
> +        info = g_realloc(info, argsz);

Do we need to bzero [sizeof(struct vfio_iommu_type1_info)..argsz[?

> +        info->argsz = argsz;
> +        ret = ioctl(fd, VFIO_IOMMU_GET_INFO, info);
> +    }
> +
> +    if (ret) {
> +        return false;
> +    }
> +
> +    /* If the capability exists, update with the current value */
> +    return vfio_get_info_dma_avail(info, avail);
> +}
> +
> diff --git a/hw/s390x/s390-pci-vfio.h b/hw/s390x/s390-pci-vfio.h
> new file mode 100644
> index 0000000..2a5a261
> --- /dev/null
> +++ b/hw/s390x/s390-pci-vfio.h
> @@ -0,0 +1,17 @@
> +/*
> + * s390 vfio-pci interfaces
> + *
> + * Copyright 2020 IBM Corp.
> + * Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +
> +#ifndef HW_S390_PCI_VFIO_H
> +#define HW_S390_PCI_VFIO_H
> +
> +bool s390_pci_update_dma_avail(int fd, unsigned int *avail);
> +
> +#endif
> 

