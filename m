Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2FE220C26
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 13:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbgGOLvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 07:51:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37468 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726212AbgGOLvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 07:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594813897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r3FX3UuRCTo9UAVThurv1D/BIiQ0N6rOrGTWl0O4StY=;
        b=Ry0B7kwBPvO8OEY3orXXuVTOZhRxZ13ApjRYCZkoujMjI7mp9lKT+2beW1fRzvG9XFSSXv
        TAV88+Xp65xoReQeRZFbZHY9Cc6dNjQsK+1aVdwqWxvKxBxPxN2au9U4nMXcSebkuf6LyH
        ms3iho9oIUOhVrnMWm6mf0me8l+i9kA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-Pjg4aw5HNgaDkgIkku9G0w-1; Wed, 15 Jul 2020 07:51:36 -0400
X-MC-Unique: Pjg4aw5HNgaDkgIkku9G0w-1
Received: by mail-qt1-f199.google.com with SMTP id m25so1204644qtk.1
        for <kvm@vger.kernel.org>; Wed, 15 Jul 2020 04:51:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=r3FX3UuRCTo9UAVThurv1D/BIiQ0N6rOrGTWl0O4StY=;
        b=EPN7sLup0/7HSGgK5EQ7Z2LRV9cJn4m21SM1yCTaZMZre2i+rpzfiPcTJlrAAzHeJd
         zNWMENqGL9qCGMldy+mRO+rQF00irSwbWSKWIhrPVE8ctZ14GN/6Zcx7BfKM+QFDRs5G
         PBUQjis+cyVMV4LTGYaoSLhXrRzgxWBvSpxDXe58bDfIxHlsbEX2XQnAZCRrNDn2h0vL
         xKDuKN4FQhU7j5Yu3Oq0MWJXgOyo49wLFdSwXVtks1Juptm8rZwwG7zR0CLkuqP/WIGu
         4uSX2WGykahN6VAMeVXU0vKcRTJLRvJD3Bhy5bLaz9hOLs6ClSBoUfdohOl+KEgsKcLt
         AO3g==
X-Gm-Message-State: AOAM531fxCWixUL52kX0nz28rPMtJn4o0lhgzaT1JDdtKTc2Ppfmf30g
        A9pB1aMBdC6bxMVvknKuKBwZWbKebKTnDHtAt+XQ0SUlO0RaCKXo0hkfR3WFsmpyzSx5HPLDVIJ
        vSKES35DEiRAQ
X-Received: by 2002:a37:4249:: with SMTP id p70mr8978832qka.496.1594813895589;
        Wed, 15 Jul 2020 04:51:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyx1aUJiCqHYur0Jh6ZYxhkiq8X5xdMXXfCrNDK8eHV+0xFXx7Y6LeDlwk29NTSE0FYz2C5zw==
X-Received: by 2002:a37:4249:: with SMTP id p70mr8978802qka.496.1594813895270;
        Wed, 15 Jul 2020 04:51:35 -0700 (PDT)
Received: from redhat.com (bzq-79-180-10-140.red.bezeqint.net. [79.180.10.140])
        by smtp.gmail.com with ESMTPSA id n64sm2006264qke.77.2020.07.15.04.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 04:51:34 -0700 (PDT)
Date:   Wed, 15 Jul 2020 07:51:28 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, linux-kernel@vger.kernel.org,
        pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v7 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
Message-ID: <20200715074917-mutt-send-email-mst@kernel.org>
References: <1594801869-13365-1-git-send-email-pmorel@linux.ibm.com>
 <1594801869-13365-3-git-send-email-pmorel@linux.ibm.com>
 <20200715054807-mutt-send-email-mst@kernel.org>
 <bc5e09ad-faaf-8b38-83e0-5f4a4b1daeb0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc5e09ad-faaf-8b38-83e0-5f4a4b1daeb0@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 15, 2020 at 06:16:59PM +0800, Jason Wang wrote:
> 
> On 2020/7/15 下午5:50, Michael S. Tsirkin wrote:
> > On Wed, Jul 15, 2020 at 10:31:09AM +0200, Pierre Morel wrote:
> > > If protected virtualization is active on s390, the virtio queues are
> > > not accessible to the host, unless VIRTIO_F_IOMMU_PLATFORM has been
> > > negotiated. Use the new arch_validate_virtio_features() interface to
> > > fail probe if that's not the case, preventing a host error on access
> > > attempt.
> > > 
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> > > Acked-by: Halil Pasic <pasic@linux.ibm.com>
> > > Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > > ---
> > >   arch/s390/mm/init.c | 28 ++++++++++++++++++++++++++++
> > >   1 file changed, 28 insertions(+)
> > > 
> > > diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> > > index 6dc7c3b60ef6..d39af6554d4f 100644
> > > --- a/arch/s390/mm/init.c
> > > +++ b/arch/s390/mm/init.c
> > > @@ -45,6 +45,7 @@
> > >   #include <asm/kasan.h>
> > >   #include <asm/dma-mapping.h>
> > >   #include <asm/uv.h>
> > > +#include <linux/virtio_config.h>
> > >   pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
> > > @@ -161,6 +162,33 @@ bool force_dma_unencrypted(struct device *dev)
> > >   	return is_prot_virt_guest();
> > >   }
> > > +/*
> > > + * arch_validate_virtio_features
> > > + * @dev: the VIRTIO device being added
> > > + *
> > > + * Return an error if required features are missing on a guest running
> > > + * with protected virtualization.
> > > + */
> > > +int arch_validate_virtio_features(struct virtio_device *dev)
> > > +{
> > > +	if (!is_prot_virt_guest())
> > > +		return 0;
> > > +
> > > +	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> > > +		dev_warn(&dev->dev,
> > > +			 "legacy virtio not supported with protected virtualization\n");
> > > +		return -ENODEV;
> > > +	}
> > > +
> > > +	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
> > > +		dev_warn(&dev->dev,
> > > +			 "support for limited memory access required for protected virtualization\n");
> > > +		return -ENODEV;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > >   /* protected virtualization */
> > >   static void pv_init(void)
> > >   {
> > What bothers me here is that arch code depends on virtio now.
> > It works even with a modular virtio when functions are inline,
> > but it seems fragile: e.g. it breaks virtio as an out of tree module,
> > since layout of struct virtio_device can change.
> 
> 
> The code was only called from virtio.c so it should be fine.
> 
> And my understanding is that we don't need to care about the kABI issue
> during upstream development?
> 
> Thanks

No, but so far it has been convenient at least for me, for development,
to just be able to unload all of virtio and load a different version.


> 
> > 
> > I'm not sure what to do with this yet, will try to think about it
> > over the weekend. Thanks!
> > 
> > 
> > > -- 
> > > 2.25.1

