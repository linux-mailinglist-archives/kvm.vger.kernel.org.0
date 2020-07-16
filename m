Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBA2222E1F
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 23:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgGPVq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 17:46:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35708 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726514AbgGPVqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jul 2020 17:46:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594935983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BEo6DsOD3gtcpeqatc/jWU3HzAeT6ubK4oUjqlbQ034=;
        b=ZzYdJTqBcoRbBkP7QZdrktSO39GYoDQ1TTyaKvhVA7nF0B2KGthyCG/tUqVHB/1N7zJwqs
        kSJ02ArN2cQbk1lFf6gvM9wxQnJ4u+wQAeTSpisbYPa9I8/8i7QwH5PXWBFXBjOvz0DLp3
        4vdFmWTOazjnKe6EpGoKegSOw0Y+b5U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-6qCoZWNHOZORz094V0W3QA-1; Thu, 16 Jul 2020 17:46:22 -0400
X-MC-Unique: 6qCoZWNHOZORz094V0W3QA-1
Received: by mail-wr1-f69.google.com with SMTP id c6so6275698wru.7
        for <kvm@vger.kernel.org>; Thu, 16 Jul 2020 14:46:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=BEo6DsOD3gtcpeqatc/jWU3HzAeT6ubK4oUjqlbQ034=;
        b=Ftpn5zRZtr6VrXUe7zFVhlchQbYzqOhbrLXkBhekgK8Z6gTYp9OnNZuw8MKicIvPxy
         UoThKppUVMHBgUSOLABCuZT8hfkI7MkBxuuVtRVMemSAw6t2nKtAoD9ejTolRi4uLJnM
         wUitqJcaFa1SAdg46AnH0yXaCkVgfbQb+a8ntO08UW//e5IJfSoOIUTnaZyERAo3PhSS
         cUhT5PNz40SdPFWOivwTnt00285eslabnXq9B6RSW1+JlDCRTJvuUEwH28BNaoYYYatt
         7AiDPMbapj8QIJYrRa4+zqvJ1T56tutBZiD22k1+RAyIDQPNpi66xfUoeIxJr55dfm1L
         zgZw==
X-Gm-Message-State: AOAM533yZ5gFVMo9XOoK6N5Lky0c5StebsGvKmNbZCeHEokUIql3k3hC
        6iHHavsIvzaPfy3MxCgY6FvXroCM345k9RI680ZftFgi2IF4b/afyCGG5nF6APKU3XRZPe8v9tQ
        hGUG1xZ52LIx1
X-Received: by 2002:a1c:3b02:: with SMTP id i2mr5994145wma.24.1594935980620;
        Thu, 16 Jul 2020 14:46:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykF2SVrQjmKDsKZhICrs30JZzeJmmbjM8l48AsSy4p8sKCLYwCNUjd1Gwxnb6QBEg+LM58nw==
X-Received: by 2002:a1c:3b02:: with SMTP id i2mr5994113wma.24.1594935980304;
        Thu, 16 Jul 2020 14:46:20 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id k4sm10900176wrp.86.2020.07.16.14.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 14:46:19 -0700 (PDT)
Date:   Thu, 16 Jul 2020 17:46:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v7 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
Message-ID: <20200716174603-mutt-send-email-mst@kernel.org>
References: <1594801869-13365-1-git-send-email-pmorel@linux.ibm.com>
 <1594801869-13365-3-git-send-email-pmorel@linux.ibm.com>
 <20200715054807-mutt-send-email-mst@kernel.org>
 <bc5e09ad-faaf-8b38-83e0-5f4a4b1daeb0@redhat.com>
 <20200715074917-mutt-send-email-mst@kernel.org>
 <3782338a-6491-dc35-7c66-97b91a20df0d@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3782338a-6491-dc35-7c66-97b91a20df0d@de.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 16, 2020 at 01:19:55PM +0200, Christian Borntraeger wrote:
> 
> 
> On 15.07.20 13:51, Michael S. Tsirkin wrote:
> > On Wed, Jul 15, 2020 at 06:16:59PM +0800, Jason Wang wrote:
> >>
> >> On 2020/7/15 下午5:50, Michael S. Tsirkin wrote:
> >>> On Wed, Jul 15, 2020 at 10:31:09AM +0200, Pierre Morel wrote:
> >>>> If protected virtualization is active on s390, the virtio queues are
> >>>> not accessible to the host, unless VIRTIO_F_IOMMU_PLATFORM has been
> >>>> negotiated. Use the new arch_validate_virtio_features() interface to
> >>>> fail probe if that's not the case, preventing a host error on access
> >>>> attempt.
> >>>>
> >>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> >>>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> >>>> Acked-by: Halil Pasic <pasic@linux.ibm.com>
> >>>> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >>>> ---
> >>>>   arch/s390/mm/init.c | 28 ++++++++++++++++++++++++++++
> >>>>   1 file changed, 28 insertions(+)
> >>>>
> >>>> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> >>>> index 6dc7c3b60ef6..d39af6554d4f 100644
> >>>> --- a/arch/s390/mm/init.c
> >>>> +++ b/arch/s390/mm/init.c
> >>>> @@ -45,6 +45,7 @@
> >>>>   #include <asm/kasan.h>
> >>>>   #include <asm/dma-mapping.h>
> >>>>   #include <asm/uv.h>
> >>>> +#include <linux/virtio_config.h>
> >>>>   pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
> >>>> @@ -161,6 +162,33 @@ bool force_dma_unencrypted(struct device *dev)
> >>>>   	return is_prot_virt_guest();
> >>>>   }
> >>>> +/*
> >>>> + * arch_validate_virtio_features
> >>>> + * @dev: the VIRTIO device being added
> >>>> + *
> >>>> + * Return an error if required features are missing on a guest running
> >>>> + * with protected virtualization.
> >>>> + */
> >>>> +int arch_validate_virtio_features(struct virtio_device *dev)
> >>>> +{
> >>>> +	if (!is_prot_virt_guest())
> >>>> +		return 0;
> >>>> +
> >>>> +	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> >>>> +		dev_warn(&dev->dev,
> >>>> +			 "legacy virtio not supported with protected virtualization\n");
> >>>> +		return -ENODEV;
> >>>> +	}
> >>>> +
> >>>> +	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
> >>>> +		dev_warn(&dev->dev,
> >>>> +			 "support for limited memory access required for protected virtualization\n");
> >>>> +		return -ENODEV;
> >>>> +	}
> >>>> +
> >>>> +	return 0;
> >>>> +}
> >>>> +
> >>>>   /* protected virtualization */
> >>>>   static void pv_init(void)
> >>>>   {
> >>> What bothers me here is that arch code depends on virtio now.
> >>> It works even with a modular virtio when functions are inline,
> >>> but it seems fragile: e.g. it breaks virtio as an out of tree module,
> >>> since layout of struct virtio_device can change.
> >>
> 
> If you prefer that, we can simply create an arch/s390/kernel/virtio.c ?

How would that address the issues above?

