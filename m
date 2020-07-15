Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E023D220933
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 11:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbgGOJu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 05:50:29 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33560 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730612AbgGOJu2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jul 2020 05:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594806626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ydFttueMnB9QE50pbDSZfOaR6o6M8obgxaWHaidDG2Q=;
        b=JsBG/JoarJjE3JQ323TT1hl+KmO+sc9Ws1cUt9TjQYpiNr2CRtB76zAxu8GuT1JqaSImBJ
        NaA3NIo0eIfMJy2ZGywoZDx4acMZwpO7zZBPVT2y5XgYZZ55F4/emuFYjL5fqVa6hBQXFv
        d6j85TyY93c2D9uQmrrNgMnHPlIfHZY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-jJr-xShhNg6WzmrbJcSr4w-1; Wed, 15 Jul 2020 05:50:24 -0400
X-MC-Unique: jJr-xShhNg6WzmrbJcSr4w-1
Received: by mail-wr1-f71.google.com with SMTP id y16so673473wrr.20
        for <kvm@vger.kernel.org>; Wed, 15 Jul 2020 02:50:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ydFttueMnB9QE50pbDSZfOaR6o6M8obgxaWHaidDG2Q=;
        b=Wr1dt37fWOutcSsYUhgWTntVhDCaJRiPtx9c6NZxyoi8DBoHS+7UlKDkozbW5kVM6w
         pCqBsWjdZe8XzaK1dIFbJU45X3BXsJTq3LnSREabyQhZaqBpQHh96fbbtSYb37nXNKXW
         nea0SwBqOg3er0qHNSsNZE90500sHnJc7SqKcpit2nJi0vMFGuHisLEl39uNicgZjEqo
         X8/fLUDsNfmwOm6om4GUmZPmHBoLYYN33IqJeVzT9rA7qMsr4DSmHv70Yqsl8Bn4GnpM
         gjAWQP1C9K6/jo8Ujw93lDYS5NEZl5LkLBYySPGcMsaZsD1uFy9LJrg0HtTzDYvNqnsu
         A6Ig==
X-Gm-Message-State: AOAM532B5IdRG8l45cGihqAd9sbML1+CzJe072hb+lKfjZ3RzNUINvA/
        Iu3TzXSGim9F52lIeALnbEfqYBkqYbvMN2BPo4Dnb/mm4xiOAeRV+OwHwfi3+YvZxPbuTk1Hz+B
        Al2V1lMFWvmQk
X-Received: by 2002:a5d:4607:: with SMTP id t7mr11055294wrq.251.1594806623781;
        Wed, 15 Jul 2020 02:50:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw20b6gyhY20GeUJvuPDUu72KPwVkCnwFQFKSJcxw9a/Ovrygxf08Gs5s2zyW8+HvaG4R7Z8Q==
X-Received: by 2002:a5d:4607:: with SMTP id t7mr11055275wrq.251.1594806623576;
        Wed, 15 Jul 2020 02:50:23 -0700 (PDT)
Received: from redhat.com (bzq-79-180-10-140.red.bezeqint.net. [79.180.10.140])
        by smtp.gmail.com with ESMTPSA id 14sm2563305wmk.19.2020.07.15.02.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 02:50:22 -0700 (PDT)
Date:   Wed, 15 Jul 2020 05:50:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, jasowang@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v7 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
Message-ID: <20200715054807-mutt-send-email-mst@kernel.org>
References: <1594801869-13365-1-git-send-email-pmorel@linux.ibm.com>
 <1594801869-13365-3-git-send-email-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594801869-13365-3-git-send-email-pmorel@linux.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 15, 2020 at 10:31:09AM +0200, Pierre Morel wrote:
> If protected virtualization is active on s390, the virtio queues are
> not accessible to the host, unless VIRTIO_F_IOMMU_PLATFORM has been
> negotiated. Use the new arch_validate_virtio_features() interface to
> fail probe if that's not the case, preventing a host error on access
> attempt.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Acked-by: Halil Pasic <pasic@linux.ibm.com>
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/mm/init.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> index 6dc7c3b60ef6..d39af6554d4f 100644
> --- a/arch/s390/mm/init.c
> +++ b/arch/s390/mm/init.c
> @@ -45,6 +45,7 @@
>  #include <asm/kasan.h>
>  #include <asm/dma-mapping.h>
>  #include <asm/uv.h>
> +#include <linux/virtio_config.h>
>  
>  pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
>  
> @@ -161,6 +162,33 @@ bool force_dma_unencrypted(struct device *dev)
>  	return is_prot_virt_guest();
>  }
>  
> +/*
> + * arch_validate_virtio_features
> + * @dev: the VIRTIO device being added
> + *
> + * Return an error if required features are missing on a guest running
> + * with protected virtualization.
> + */
> +int arch_validate_virtio_features(struct virtio_device *dev)
> +{
> +	if (!is_prot_virt_guest())
> +		return 0;
> +
> +	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> +		dev_warn(&dev->dev,
> +			 "legacy virtio not supported with protected virtualization\n");
> +		return -ENODEV;
> +	}
> +
> +	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
> +		dev_warn(&dev->dev,
> +			 "support for limited memory access required for protected virtualization\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
>  /* protected virtualization */
>  static void pv_init(void)
>  {

What bothers me here is that arch code depends on virtio now.
It works even with a modular virtio when functions are inline,
but it seems fragile: e.g. it breaks virtio as an out of tree module,
since layout of struct virtio_device can change.

I'm not sure what to do with this yet, will try to think about it
over the weekend. Thanks!


> -- 
> 2.25.1

