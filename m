Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2621443DBC
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 08:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhKCHg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 03:36:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232055AbhKCHg4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 03:36:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635924859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2evzeN2dUJ97RkJYIYZWd1y4ZdCaTHeSbdPXFeoqPXY=;
        b=SebnF1PktGsv7KYc26W1XANb0FtlWABmYo4ZAc4lvp4HjMqNyezxMeuvFM0AOYCYFLiSeM
        QIo+DuVwYfdJzbEsnf3JDwTY3wv+VsnX4vf6SICrQVvjyChoSDvoXCPjtgfz7xQBCXFMPu
        aLGQofRn+QiPHwCpJrJZuQXpks9X5IA=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-AZRO9K0ON5y7JBFuXSqAQQ-1; Wed, 03 Nov 2021 03:34:18 -0400
X-MC-Unique: AZRO9K0ON5y7JBFuXSqAQQ-1
Received: by mail-lj1-f197.google.com with SMTP id n9-20020a2e9049000000b00212acec7473so711771ljg.22
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 00:34:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2evzeN2dUJ97RkJYIYZWd1y4ZdCaTHeSbdPXFeoqPXY=;
        b=Tsbeleb6U/zCvcFT+7PYbRbShaLlJBuB4udzzMUCHgPxmEb9ftn/9KoJQtCAOHefAW
         iXIRO12pIyh9j+k1Z7Wfz8f2RP3c9jc023aKJHC5rhhPUtAItBNaD/KF/1aPNLKwjcsL
         2ETxsuWztvkAqmyavc0nwW2G/Ez7ZjJ8LVb08sgAL62fckQjOb/GODhdpYl2NQSYi9xM
         +7k01g/JTFgLyd49sUDMKBqJMh8tynOR0BYL9ZdHlYrX0xeocYLAcKCRpWdUd+lx9bnH
         KZXyLX/GjM4Et7mZCWQ9PvSjiBjW9UXFoISfwHXKAQAfYYdkEJVK8hAfSsbiiswaJkkb
         3PlA==
X-Gm-Message-State: AOAM533xX+HUfWmAV6bNSNBMaVPslliFMyQ1n9ncabTTnA7GdD5D46el
        Z+NjA2lN9a8CbWlwIz8Tw8lmKECYSg5Y6pmBkFvPrx3bFvHv27cChPiCTfjeeclbmOYabc2mxDk
        MBtXD1Abta4BFF0Ku6dAIlZ3h8CGS
X-Received: by 2002:a2e:9155:: with SMTP id q21mr44928354ljg.217.1635924856991;
        Wed, 03 Nov 2021 00:34:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxgumhOzJkMB3252KusefaLzXeoNl6AE+RgxHii73ou3HxIh+V3ny7+BZb0pyCgH7dvZNxuJB7iyjgLMLh5hNQ=
X-Received: by 2002:a2e:9155:: with SMTP id q21mr44928307ljg.217.1635924856684;
 Wed, 03 Nov 2021 00:34:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200326140125.19794-1-jasowang@redhat.com> <20200326140125.19794-8-jasowang@redhat.com>
 <20211101141133.GA1073864@nvidia.com> <CACGkMEtbs3u7J7krpkusfqczTU00+6o_YtZjD8htC=+Un9cNew@mail.gmail.com>
 <20211102155611.GL2744544@nvidia.com>
In-Reply-To: <20211102155611.GL2744544@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 3 Nov 2021 15:34:05 +0800
Message-ID: <CACGkMEt35cLjb-YRD34yhyo2oiK5YqVozsg5t45a0oThiAKS4A@mail.gmail.com>
Subject: Re: [PATCH V9 7/9] vhost: introduce vDPA-based backend
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     mst <mst@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>, zhihong.wang@intel.com,
        rob.miller@broadcom.com, Xiao W Wang <xiao.w.wang@intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        eperezma <eperezma@redhat.com>, Cindy Lu <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ariel Adam <aadam@redhat.com>, jiri@mellanox.com,
        shahafs@mellanox.com, Harpreet Singh Anand <hanand@xilinx.com>,
        mhabets@solarflare.com, Gautam Dawar <gdawar@xilinx.com>,
        Saugat Mitra <saugatm@xilinx.com>, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, Tiwei Bie <tiwei.bie@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 2, 2021 at 11:56 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Tue, Nov 02, 2021 at 11:52:20AM +0800, Jason Wang wrote:
> > On Mon, Nov 1, 2021 at 10:11 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > On Thu, Mar 26, 2020 at 10:01:23PM +0800, Jason Wang wrote:
> > > > From: Tiwei Bie <tiwei.bie@intel.com>
> > > >
> > > > This patch introduces a vDPA-based vhost backend. This backend is
> > > > built on top of the same interface defined in virtio-vDPA and provides
> > > > a generic vhost interface for userspace to accelerate the virtio
> > > > devices in guest.
> > > >
> > > > This backend is implemented as a vDPA device driver on top of the same
> > > > ops used in virtio-vDPA. It will create char device entry named
> > > > vhost-vdpa-$index for userspace to use. Userspace can use vhost ioctls
> > > > on top of this char device to setup the backend.
> > > >
> > > > Vhost ioctls are extended to make it type agnostic and behave like a
> > > > virtio device, this help to eliminate type specific API like what
> > > > vhost_net/scsi/vsock did:
> > > >
> > > > - VHOST_VDPA_GET_DEVICE_ID: get the virtio device ID which is defined
> > > >   by virtio specification to differ from different type of devices
> > > > - VHOST_VDPA_GET_VRING_NUM: get the maximum size of virtqueue
> > > >   supported by the vDPA device
> > > > - VHSOT_VDPA_SET/GET_STATUS: set and get virtio status of vDPA device
> > > > - VHOST_VDPA_SET/GET_CONFIG: access virtio config space
> > > > - VHOST_VDPA_SET_VRING_ENABLE: enable a specific virtqueue
> > > >
> > > > For memory mapping, IOTLB API is mandated for vhost-vDPA which means
> > > > userspace drivers are required to use
> > > > VHOST_IOTLB_UPDATE/VHOST_IOTLB_INVALIDATE to add or remove mapping for
> > > > a specific userspace memory region.
> > > >
> > > > The vhost-vDPA API is designed to be type agnostic, but it allows net
> > > > device only in current stage. Due to the lacking of control virtqueue
> > > > support, some features were filter out by vhost-vdpa.
> > > >
> > > > We will enable more features and devices in the near future.
> > >
> > > [..]
> > >
> > > > +static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
> > > > +{
> > > > +     struct vdpa_device *vdpa = v->vdpa;
> > > > +     const struct vdpa_config_ops *ops = vdpa->config;
> > > > +     struct device *dma_dev = vdpa_get_dma_dev(vdpa);
> > > > +     struct bus_type *bus;
> > > > +     int ret;
> > > > +
> > > > +     /* Device want to do DMA by itself */
> > > > +     if (ops->set_map || ops->dma_map)
> > > > +             return 0;
> > > > +
> > > > +     bus = dma_dev->bus;
> > > > +     if (!bus)
> > > > +             return -EFAULT;
> > > > +
> > > > +     if (!iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
> > > > +             return -ENOTSUPP;
> > > > +
> > > > +     v->domain = iommu_domain_alloc(bus);
> > > > +     if (!v->domain)
> > > > +             return -EIO;
> > > > +
> > > > +     ret = iommu_attach_device(v->domain, dma_dev);
> > > > +     if (ret)
> > > > +             goto err_attach;
> > > >
> > >
> > > I've been looking at the security of iommu_attach_device() users, and
> > > I wonder if this is safe?
> > >
> > > The security question is if userspace is able to control the DMA
> > > address the devices uses? Eg if any of the cpu to device ring's are in
> > > userspace memory?
> > >
> > > For instance if userspace can tell the device to send a packet from an
> > > arbitrary user controlled address.
> >
> > The map is validated via pin_user_pages() which guarantees that the
> > address is not arbitrary and must belong to userspace?
>
> That controls what gets put into the IOMMU, it doesn't restrict what
> DMA the device itself can issue.
>
> Upon investigating more it seems the answer is that
> iommu_attach_device() requires devices to be in singleton groups, so
> there is no leakage from rouge DMA

Yes, I think so.

Thanks

>
> Jason
>

