Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4862A3B6B2B
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 01:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236540AbhF1XLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 19:11:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40967 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230163AbhF1XLd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 19:11:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624921746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bF2HoCO0rfuA3mB1G6ApBaoajgUkNbQLpTT4TzE0yAY=;
        b=U2FlwEr1oBDeQ4N5yBqrUtXEukUbED1OU5TqO4VNyKNkVvoA2puTl2CNnBYTO3EAbAfaR8
        ugDyLxCOWotNDoZ3vC42dBN/2vNeeYkqrV1Fd++IST5Zp/8I77Akwm1KBJJ5+jLSJAj639
        T9zH6zh7PJwbs6jc/8LQEi3dsHHggDM=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-gHzWurBwOqOWN0F2tKRz1A-1; Mon, 28 Jun 2021 19:09:05 -0400
X-MC-Unique: gHzWurBwOqOWN0F2tKRz1A-1
Received: by mail-ot1-f72.google.com with SMTP id i25-20020a9d4a990000b0290304f00e3e3aso14130538otf.15
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 16:09:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bF2HoCO0rfuA3mB1G6ApBaoajgUkNbQLpTT4TzE0yAY=;
        b=rc8bR+f8qit1MmqclqiuUTL0C1wDSiQoOKcQeCJS618tAIzvJ9MivV9+SBXNywm0//
         wSWhoKPKAYnfsxt2zpG6Ktw66gkMVsnt7mMvMLJvVVPtQq+mIuVdoMlBlPtxY6lr0CB6
         M5p+C3IGcHTCUJsHgKFNzhFBhsHPvwn9zizNyvPnlrTP+PP+NMRyEKY1xMmkPUvj+0uP
         4xnUFM55hIoibkAPhH4XqvLU9HM7VIMXvBY6M0R5DMqPL82R70MUpzE6OHlCl1RRHcyh
         lXzSV1kKvfqOAyYJnOGlhuzQHfYM8UxidskM1CrMoby8WYyBS/rpPNh/BXLwpsINeRrA
         nvGQ==
X-Gm-Message-State: AOAM531aoSHjPkv6BehieLAQb980lR0QoCGChgM1TH+f4Jz9Lz61+H7Y
        74UvFQMzIg0Nu7Fiv8L+JToeB+bpM+py6RGOLG7AdcOdPsVDjgkudtY1ghY2ABGxO4Fg7rzchS/
        NJ4gTYG4B5Gc5
X-Received: by 2002:a9d:7610:: with SMTP id k16mr1750505otl.32.1624921744369;
        Mon, 28 Jun 2021 16:09:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwuuATEZpZywZp15nLfiJ8vJvsIoVIujDhp0c/KSUebMCjrJMYkGvLQVt9TLd7e8hFpk1nEUA==
X-Received: by 2002:a9d:7610:: with SMTP id k16mr1750476otl.32.1624921744164;
        Mon, 28 Jun 2021 16:09:04 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id c14sm1164262oic.50.2021.06.28.16.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 16:09:03 -0700 (PDT)
Date:   Mon, 28 Jun 2021 17:09:02 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210628170902.61c0aa1d.alex.williamson@redhat.com>
In-Reply-To: <20210628224818.GJ4459@nvidia.com>
References: <20210616133937.59050e1a.alex.williamson@redhat.com>
        <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210617151452.08beadae.alex.williamson@redhat.com>
        <20210618001956.GA1987166@nvidia.com>
        <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210618182306.GI1002214@nvidia.com>
        <BN9PR11MB5433B9C0577CF0BD8EFCC9BC8C069@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210625143616.GT2371267@nvidia.com>
        <BN9PR11MB5433D40116BC1939B6B297EA8C039@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210628163145.1a21cca9.alex.williamson@redhat.com>
        <20210628224818.GJ4459@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Jun 2021 19:48:18 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Jun 28, 2021 at 04:31:45PM -0600, Alex Williamson wrote:
> 
> > I'd expect that /dev/iommu will be used by multiple subsystems.  All
> > will want to bind devices to address spaces, so shouldn't binding a
> > device to an iommufd be an ioctl on the iommufd, ie.
> > IOMMU_BIND_VFIO_DEVICE_FD.  Maybe we don't even need "VFIO" in there and
> > the iommufd code can figure it out internally.  
> 
> It wants to be the other way around because iommu_fd is the lower
> level subsystem. We don't/can't teach iommu_fd how to convert a fd
> number to a vfio/vdpa/etc/etc, we teach all the things building on
> iommu_fd how to change a fd number to an iommu - they already
> necessarily have an inter-module linkage.

These seem like peer subsystems, like vfio and kvm.  vfio shouldn't
have any hard dependencies on the iommufd module, especially so long as
we have the legacy type1 code.  Likewise iommufd shouldn't have any on
vfio.  As much as you dislike the symbol_get hack of the kvm-vfio
device, it would be reasonable for iommufd to reach for a vfio symbol
when an IOMMU_BIND_VFIO_DEVICE_FD ioctl is called.

> There is a certain niceness to what you are saying but it is not so
> practical without doing something bigger..
> 
> > Ideally vfio would also at least be able to register a type1 IOMMU
> > backend through the existing uapi, backed by this iommu code, ie. we'd
> > create a new "iommufd" (but without the user visible fd),   
> 
> It would be amazing to be able to achieve this, at least for me there
> are too many details be able to tell what that would look like
> exactly. I suggested once that putting the container ioctl interface
> in the drivers/iommu code may allow for this without too much trouble..

If we can't achieve this, then type1 legacy code is going to need to
live through an extended deprecation period.  I'm hoping that between
type1 and a native interface we'll have two paths into iommufd to vet
the design.  Thanks,

Alex

