Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3421E443DC8
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 08:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbhKCHoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 03:44:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232111AbhKCHn6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 03:43:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635925281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BF5lx3uNgeDkI9ZmcBEpKRgjkBtUPwrKCz/rr1QJs1o=;
        b=P9oOBhHeHk5SovrK9pSZkUNV+SXMhGJmWbujUnYVWzlSySU/wDiDOOSlaraPeLbt67xe6h
        xtMGccsLefSXksOXckLXAK0VZDNX4X2uCaXryeV9Kb7e+ZuS1BDHzkQ4ed25Rc02OOdMiG
        jSKxPq2cHGhwbjv0nQVNGnGnFtdrQvc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-d2klVPHfMmuAoG6Wuz8-eQ-1; Wed, 03 Nov 2021 03:41:18 -0400
X-MC-Unique: d2klVPHfMmuAoG6Wuz8-eQ-1
Received: by mail-ed1-f72.google.com with SMTP id r25-20020a05640216d900b003dca3501ab4so1634287edx.15
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 00:41:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BF5lx3uNgeDkI9ZmcBEpKRgjkBtUPwrKCz/rr1QJs1o=;
        b=3oNg3Nsg8VdL2YDWlHtr0/IWym4yxGQL9oL8qpjtW1OkScwgHsVgDg09O9e0dfb0wA
         PdpPdEjoX9zJ6BE2OwNo/onkzHRtBvNPGfOnMfxBvZpgzfhiaWA4SM2c1ozAayq9l53N
         7ycP+0icnqhgbsdZfeYuEjDr1U13blJu8/ZN/IyvGOpeCLpnfnSJ+4yOn2QQehhepFkF
         6jIw0GEkk/A20Z4dhUq8VmbbxNti7k1aJyY1SMCHJjiYTXIBsqL55wYIdo/OF27YjFRq
         MX1NWyS+lFxh21DiI8jkZDVg5Q5nDlYNs3wcLvSUSmrGudigB+v1xRl/A23W1ePahy88
         QrMw==
X-Gm-Message-State: AOAM530U2K6zK1h96G8oXJnYVVg7X8XHkDzi0kgovjq4dij5NOXEI+7J
        z+TBbEGxJnGMJRoqc6gS0RBRS5x+PQRIWunZhljeM94NmTHePq+qDz77RLPl8FqqlTahp4f62tf
        Obi6KtVefrQn5
X-Received: by 2002:a17:906:c20e:: with SMTP id d14mr52645876ejz.207.1635925277067;
        Wed, 03 Nov 2021 00:41:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzt8dXYkG05JMkCgPhXLw0rBFT0TGtPI1gKNRGQ1upuPAnM1qoopVXJbAgBuE98SW9g8GMJNA==
X-Received: by 2002:a17:906:c20e:: with SMTP id d14mr52645860ejz.207.1635925276892;
        Wed, 03 Nov 2021 00:41:16 -0700 (PDT)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id oz13sm651758ejc.65.2021.11.03.00.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 00:41:16 -0700 (PDT)
Date:   Wed, 3 Nov 2021 08:41:14 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/7] arm: virtio: move VIRTIO transport
 initialization inside virtio-mmio
Message-ID: <20211103074114.45cv5mkdcksxg4az@gator.home>
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-2-git-send-email-pmorel@linux.ibm.com>
 <43587c22-e9c9-545d-1dad-5877b683a75c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43587c22-e9c9-545d-1dad-5877b683a75c@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 03, 2021 at 08:00:09AM +0100, Thomas Huth wrote:
> Sorry for the late reply - still trying to get my Inbox under control again ...
> 
> On 27/08/2021 12.17, Pierre Morel wrote:
> > To be able to use different VIRTIO transport in the future we need
> > the initialisation entry call of the transport to be inside the
> > transport file and keep the VIRTIO level transport agnostic.
> > 
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
> >   lib/virtio-mmio.c | 2 +-
> >   lib/virtio-mmio.h | 2 --
> >   lib/virtio.c      | 5 -----
> >   3 files changed, 1 insertion(+), 8 deletions(-)
> > 
> > diff --git a/lib/virtio-mmio.c b/lib/virtio-mmio.c
> > index e5e8f660..fb8a86a3 100644
> > --- a/lib/virtio-mmio.c
> > +++ b/lib/virtio-mmio.c
> > @@ -173,7 +173,7 @@ static struct virtio_device *virtio_mmio_dt_bind(u32 devid)
> >   	return &vm_dev->vdev;
> >   }
> > -struct virtio_device *virtio_mmio_bind(u32 devid)
> > +struct virtio_device *virtio_bind(u32 devid)
> >   {
> >   	return virtio_mmio_dt_bind(devid);
> >   }
> > diff --git a/lib/virtio-mmio.h b/lib/virtio-mmio.h
> > index 250f28a0..73ddbd23 100644
> > --- a/lib/virtio-mmio.h
> > +++ b/lib/virtio-mmio.h
> > @@ -60,6 +60,4 @@ struct virtio_mmio_device {
> >   	void *base;
> >   };
> > -extern struct virtio_device *virtio_mmio_bind(u32 devid);
> > -
> >   #endif /* _VIRTIO_MMIO_H_ */
> > diff --git a/lib/virtio.c b/lib/virtio.c
> > index 69054757..e10153b9 100644
> > --- a/lib/virtio.c
> > +++ b/lib/virtio.c
> > @@ -123,8 +123,3 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
> >   	return ret;
> >   }
> > -
> > -struct virtio_device *virtio_bind(u32 devid)
> > -{
> > -	return virtio_mmio_bind(devid);
> > -}
> > 
> 
> I agree that this needs to be improved somehow, but I'm not sure whether
> moving the function to virtio-mmio.c is the right solution. I guess the
> original idea was that virtio_bind() could cope with multiple transports,
> i.e. when there is support for virtio-pci, it could choose between mmio and
> pci on ARM, or between CCW and PCI on s390x.

That's right. If we wanted to use virtio-pci on ARM, then, after
implementing virtio_pci_bind(), we'd change this to

  struct virtio_device *virtio_bind(u32 devid)  
  {
      struct virtio_device *dev = virtio_mmio_bind(devid);

      if (!dev)
          dev = virtio_pci_bind(devid);

      return dev;
  }

Then, we'd use config selection logic in the test harness to decide how to
construct the QEMU command line in order to choose between mmio and pci.

> 
> So maybe this should rather get an "#if defined(__arm__) ||
> defined(__aarch64__)" instead? Drew, what's your opinion here?

Yup, but I think I'd prefer we do it in the header, like below, and
then also implement something like the above for virtio_bind().

diff --git a/lib/virtio-mmio.h b/lib/virtio-mmio.h
index 250f28a0d300..a0a3bf827156 100644
--- a/lib/virtio-mmio.h
+++ b/lib/virtio-mmio.h
@@ -60,6 +60,13 @@ struct virtio_mmio_device {
        void *base;
 };
 
+#if defined(__arm__) || defined(__aarch64__)
 extern struct virtio_device *virtio_mmio_bind(u32 devid);
+#else
+static inline struct virtio_device *virtio_mmio_bind(u32 devid)
+{
+        return NULL;
+}
+#endif
 
 #endif /* _VIRTIO_MMIO_H_ */


Thanks,
drew

