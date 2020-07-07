Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C17216B3A
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 13:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgGGLPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 07:15:01 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43690 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728145AbgGGLPB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 07:15:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594120499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2SkfEvXWOe57lsdbNZpY7pfaCzkWkPb715oD3Syj+e4=;
        b=PJ9aj/Gc138FAGBigVkowKwj3rXCuyVQqxBrRaB40v4M141ix0sksxBFJetUxDl1w4TeLf
        qfNQOLZgyWrqCs4luF0DkSAGRXqFhkAez7FAbi/Y1ztImiDXiT60YSqXrXWH1vunJ6HKAg
        fLUbVJ8M57gyivJj7w7L3FnZBkMiKp8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-9CXXS0W-NVixjkb0hy8M4A-1; Tue, 07 Jul 2020 07:14:57 -0400
X-MC-Unique: 9CXXS0W-NVixjkb0hy8M4A-1
Received: by mail-wr1-f72.google.com with SMTP id b14so48452633wrp.0
        for <kvm@vger.kernel.org>; Tue, 07 Jul 2020 04:14:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2SkfEvXWOe57lsdbNZpY7pfaCzkWkPb715oD3Syj+e4=;
        b=rpKpRGtvLGAdia9XGTzEU9gMhJTwon2+TqHQrK8/K99bxPbaIrKQq1f5xrCiMdkm/J
         eZD7Lklaersj+IG8uKrZbIFxZRG+seVc/4NazmM0bo/fdDZ7HKjZHBlCCvqfYA7xXfYM
         s1thsvJVXR+fycasktLu5oTh/l/5/lTq8LsVXCMbpHvj8iu7dwOQiduzbycXWAI8zOfp
         4XQbf0iwNLfPEm8jFZQc1sFY8DI+fkwm+QtVZLEIB14h2JkqsM+iPFaesST3G9kEReAp
         WKT3VJeR41XySwDgYfyvmmd2jk50iY8/i6PtpJRUDjqvl6+QWtQvs/+H9PSz5MrrmuYn
         EGCw==
X-Gm-Message-State: AOAM532atELOwqm75aPnv5mneR2Y3fIXz7O75Sk8FqgeAUBzGFPzBhq5
        qsylpcZMtVpNyfABupbmHbvGQnI8lPypzmFqr01HSYCbB4x/u40Wsor94hra7FzA4hY4cJYBDNO
        OdRHo2n9JoHlV
X-Received: by 2002:adf:de01:: with SMTP id b1mr52165607wrm.305.1594120495882;
        Tue, 07 Jul 2020 04:14:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfrgQVHW0xPEz2qK4WxsyK5VqMd4mfiVNX7Uo+QjneR39/UAS7kA8HbpUGWt9XZF4TGRAOtA==
X-Received: by 2002:adf:de01:: with SMTP id b1mr52165596wrm.305.1594120495667;
        Tue, 07 Jul 2020 04:14:55 -0700 (PDT)
Received: from redhat.com (bzq-79-182-109-139.red.bezeqint.net. [79.182.109.139])
        by smtp.gmail.com with ESMTPSA id 92sm597206wrr.96.2020.07.07.04.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 04:14:54 -0700 (PDT)
Date:   Tue, 7 Jul 2020 07:14:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, linux-kernel@vger.kernel.org,
        pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v4 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
Message-ID: <20200707060838-mutt-send-email-mst@kernel.org>
References: <1594111477-15401-1-git-send-email-pmorel@linux.ibm.com>
 <1594111477-15401-3-git-send-email-pmorel@linux.ibm.com>
 <20200707114633.68122a00.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707114633.68122a00.cohuck@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 07, 2020 at 11:46:33AM +0200, Cornelia Huck wrote:
> On Tue,  7 Jul 2020 10:44:37 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
> > S390, protecting the guest memory against unauthorized host access
> > needs to enforce VIRTIO I/O device protection through the use of
> > VIRTIO_F_VERSION_1 and VIRTIO_F_IOMMU_PLATFORM.
> 
> Hm... what about:
> 
> "If protected virtualization is active on s390, the virtio queues are
> not accessible to the host, unless VIRTIO_F_IOMMU_PLATFORM has been
> negotiated. Use the new arch_validate_virtio_features() interface to
> enforce this."

s/enforce this/fail probe if that's not the case, preventing a host error on access attempt/



> > 
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
> >  arch/s390/kernel/uv.c | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> > 
> > diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> > index c296e5c8dbf9..106330f6eda1 100644
> > --- a/arch/s390/kernel/uv.c
> > +++ b/arch/s390/kernel/uv.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/memblock.h>
> >  #include <linux/pagemap.h>
> >  #include <linux/swap.h>
> > +#include <linux/virtio_config.h>
> >  #include <asm/facility.h>
> >  #include <asm/sections.h>
> >  #include <asm/uv.h>
> > @@ -413,3 +414,27 @@ static int __init uv_info_init(void)
> >  }
> >  device_initcall(uv_info_init);
> >  #endif
> > +
> > +/*
> > + * arch_validate_virtio_iommu_platform
> 
> s/arch_validate_virtio_iommu_platform/arch_validate_virtio_features/
> 
> > + * @dev: the VIRTIO device being added
> > + *
> > + * Return value: returns -ENODEV if any features of the
> > + *               device breaks the protected virtualization
> > + *               0 otherwise.
> 
> I don't think you need to specify the contract here: that belongs to
> the definition in the virtio core. What about simply adding a sentence
> "Return an error if required features are missing on a guest running
> with protected virtualization." ?
> 
> > + */
> > +int arch_validate_virtio_features(struct virtio_device *dev)
> > +{
> 
> Maybe jump out immediately if the guest is not protected?
> 
> > +	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> > +		dev_warn(&dev->dev, "device must provide VIRTIO_F_VERSION_1\n");
> > +		return is_prot_virt_guest() ? -ENODEV : 0;
> > +	}
> > +
> > +	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
> > +		dev_warn(&dev->dev,
> > +			 "device must provide VIRTIO_F_IOMMU_PLATFORM\n");
> > +		return is_prot_virt_guest() ? -ENODEV : 0;
> > +	}
> 
> if (!is_prot_virt_guest())
> 	return 0;
> 
> if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> 	dev_warn(&dev->dev,
>                  "legacy virtio is incompatible with protected guests");
> 	return -ENODEV;
> }
> 
> if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
> 	dev_warn(&dev->dev,
> 		 "device does not work with limited memory access in protected guests");
> 	return -ENODEV;
> }
> 
> > +
> > +	return 0;
> > +}

