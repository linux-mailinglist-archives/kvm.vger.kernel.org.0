Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C793ACF77
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 17:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235673AbhFRPyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 11:54:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235659AbhFRPyL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 11:54:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624031521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2JEl/D8fElGUs5qE1bIG8tGOHlH8JDuVtFpyPtPAcRM=;
        b=JEFPYe7eYkoNs0u1MF2VlyQ3u0ZtH+8Qz6FK7E9IFj6Vf7dGULakGJI49asSHs8uJYouXW
        fj/L9iteQXMWKHhQpcCPk598sJhvzbcCGhi1cXXZzt8CHX72ZI68u3vjlBC780B7frsuI1
        /TiZlB75ke9C+cwaQnw2Iwq/FM/U0LQ=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-outw4BwBOa-7vsWXLAW-Cw-1; Fri, 18 Jun 2021 11:52:00 -0400
X-MC-Unique: outw4BwBOa-7vsWXLAW-Cw-1
Received: by mail-io1-f71.google.com with SMTP id e20-20020a6b50140000b02904b13c0d0212so4419391iob.19
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 08:52:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2JEl/D8fElGUs5qE1bIG8tGOHlH8JDuVtFpyPtPAcRM=;
        b=m56ehyT/xLwxpwFp272UUPpGPIGXc6JVk7H8hRYbCPGfZSPYHtHX4+ICBqqosiGYGe
         e85khEckECdjNICGxTpKrn5QcimWO86JRCSbucYoVBguGYrGFouE0tz8Obstp6T7QASr
         0bsJc3det2dGgcUZnCYni6o8s1qN+JNpt59OmgAeHK5OnRqJ2RjNZDzD6/jRMY5e8LhT
         H1qpVt8pYpACxCuhObuqjPxN/U4Yor0B2hz/zld7TkoKLiVffFXsEO6xyltmaiAOF9zX
         oUpX40SYufXNBnl5ujwHKBBoAKL77l2v1inCjZUwOpWzog0oyiR4w2Ut3FxYkA0KHuG3
         SncQ==
X-Gm-Message-State: AOAM531lSzfbkAJ+3epFAgmHKCTCmxrzDsslCcDBFviRCPcHH52DmYpD
        GiL0bHpqH8Ef3e6iNgMohpN/8GluhWm8s5AaQ5UjTR0wAYX6HtfZ2HD63SVsZlfu63+RFvGm6cu
        ETbMBvuKQOFIT
X-Received: by 2002:a05:6e02:1383:: with SMTP id d3mr6838000ilo.172.1624031519706;
        Fri, 18 Jun 2021 08:51:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyba3VKvMFyZqbrNjMBnKEoGABQfH7jzv5PsLUxAyjyr9uMPZs6fX5eNRt3vqIMNQW+GtEqg==
X-Received: by 2002:a05:6e02:1383:: with SMTP id d3mr6837986ilo.172.1624031519497;
        Fri, 18 Jun 2021 08:51:59 -0700 (PDT)
Received: from redhat.com (c-73-14-100-188.hsd1.co.comcast.net. [73.14.100.188])
        by smtp.gmail.com with ESMTPSA id y13sm4516131ioa.51.2021.06.18.08.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 08:51:59 -0700 (PDT)
Date:   Fri, 18 Jun 2021 09:51:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
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
Message-ID: <20210618095157.131eb309.alex.williamson@redhat.com>
In-Reply-To: <20210618153735.GA37688@otc-nc-03>
References: <20210612105711.7ac68c83.alex.williamson@redhat.com>
        <20210614140711.GI1002214@nvidia.com>
        <20210614102814.43ada8df.alex.williamson@redhat.com>
        <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210615101215.4ba67c86.alex.williamson@redhat.com>
        <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210616133937.59050e1a.alex.williamson@redhat.com>
        <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <YMykBzUHmATPbmdV@8bytes.org>
        <20210618151506.GG1002214@nvidia.com>
        <20210618153735.GA37688@otc-nc-03>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Jun 2021 08:37:35 -0700
"Raj, Ashok" <ashok.raj@intel.com> wrote:

> On Fri, Jun 18, 2021 at 12:15:06PM -0300, Jason Gunthorpe wrote:
> > On Fri, Jun 18, 2021 at 03:47:51PM +0200, Joerg Roedel wrote:  
> > > Hi Kevin,
> > > 
> > > On Thu, Jun 17, 2021 at 07:31:03AM +0000, Tian, Kevin wrote:  
> > > > Now let's talk about the new IOMMU behavior:
> > > > 
> > > > -   A device is blocked from doing DMA to any resource outside of
> > > >     its group when it's probed by the IOMMU driver. This could be a
> > > >     special state w/o attaching to any domain, or a new special domain
> > > >     type which differentiates it from existing domain types (identity, 
> > > >     dma, or unmanged). Actually existing code already includes a
> > > >     IOMMU_DOMAIN_BLOCKED type but nobody uses it.  
> > > 
> > > There is a reason for the default domain to exist: Devices which require
> > > RMRR mappings to be present. You can't just block all DMA from devices
> > > until a driver takes over, we put much effort into making sure there is
> > > not even a small window in time where RMRR regions (unity mapped regions
> > > on AMD) are not mapped.  
> > 
> > Yes, I think the DMA blocking can only start around/after a VFIO type
> > driver has probed() and bound to a device in the group, not much
> > different from today.  
> 
> Does this mean when a device has a required "RMRR" that requires a unity
> mapping we block assigning those devices to guests? I remember we had some
> restriction but there was a need to go around it at some point in time.
> 
> - Either we disallow assigning devices with RMRR
> - Break that unity map when the device is probed and after which any RMRR
>   access from device will fault.

We currently disallow assignment of RMRR encumbered devices except for
the known cases of USB and IGD.  In the general case, an RMRR imposes
a requirement on the host system to maintain ranges of identity mapping
that is incompatible with userspace ownership of the device and IOVA
address space.  AFAICT, nothing changes in the /dev/iommu model that
would make it safe to entrust userspace with RMRR encumbered devices.
Thanks,

Alex

