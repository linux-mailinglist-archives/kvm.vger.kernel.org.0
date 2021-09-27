Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C166D419F04
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 21:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbhI0TVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 15:21:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39946 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236340AbhI0TVd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 15:21:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632770394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ytbf7mkDtKm4hXqfmsIh+zBdQwECAHFtYv2udg+9N/s=;
        b=gycSX+ht0iq0vyVLZMvUrd6m9OFSS6/vtex6QTrxw80cq1UjkzzFqGeqHLKgfg80A9vI8c
        z6f4R4QBi4GBCREDP25acLiudTXUceNX6FFjBtTc7xG8VgX6d1g79S2AG/wSdIzALHZxSF
        nPgVnOnF76fJ+2iZat6whiVvSuk5nVA=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-yhJHXH-9MvmZp4gI9U8phQ-1; Mon, 27 Sep 2021 15:19:52 -0400
X-MC-Unique: yhJHXH-9MvmZp4gI9U8phQ-1
Received: by mail-oi1-f198.google.com with SMTP id e186-20020acab5c3000000b00273804e72c8so14337169oif.11
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 12:19:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Ytbf7mkDtKm4hXqfmsIh+zBdQwECAHFtYv2udg+9N/s=;
        b=v248SfMo8wEYyaLKHQkExYeEXo3e5GDIQLqCjSmovlxqig6mfYmXjrgjvX2vFZrTxi
         W/QczRMXF4XtC7bvbQePqAEWtBjr6jb3gZn9oCRka/Mw+KtQa405ftJ1JQYMt3sssPO3
         2q7jV2V54ZNxuAxakkRyUDhXrE8qUDnNjp+2FaNKjbqGTG0wOUAP7RHIcA1haLi12nx5
         dUJQEGFEGF+ju7L0CavwKZYw9VnemW76Nnrfl0zqjUVaQulqilLxGyCWQd8pq4XyZ1lu
         y7Hmi8nd0E1f0IctWner2eojQfeBhNLfZSQX67lpv02L62teoToqK3moUI2sIXukOudR
         bWqA==
X-Gm-Message-State: AOAM531ILfr14TYnTKzWyCWj7qFOW/aZaTdAG1Ufur6kFitDcTIP8t3e
        KjKrv8qV1y4vp+6t2he7LjEoUKFkyyYk+hLbzy5loyIGxKpHiC/i59pMVG7AchQ7Mu74vSgAO1G
        1Bs3eTAVGibX4
X-Received: by 2002:a05:6808:d53:: with SMTP id w19mr565215oik.135.1632770392053;
        Mon, 27 Sep 2021 12:19:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIofVCTMGgEM5geBngT4Oh5jA/6Ys1igS7KsVTI4OQQbB1L1o1oifOGkhmTzaJZ7j5t45PYQ==
X-Received: by 2002:a05:6808:d53:: with SMTP id w19mr565205oik.135.1632770391818;
        Mon, 27 Sep 2021 12:19:51 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id bg36sm1238777oib.2.2021.09.27.12.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 12:19:51 -0700 (PDT)
Date:   Mon, 27 Sep 2021 13:19:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Message-ID: <20210927131949.052d8481.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB543327D25DCE242919F7909A8CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
        <20210919063848.1476776-7-yi.l.liu@intel.com>
        <20210921170943.GS327412@nvidia.com>
        <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210922123931.GI327412@nvidia.com>
        <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210927115342.GW964074@nvidia.com>
        <BN9PR11MB5433502FEF11940984774F278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210927130935.GZ964074@nvidia.com>
        <BN9PR11MB543327D25DCE242919F7909A8CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Sep 2021 13:32:34 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Jason Gunthorpe
> > Sent: Monday, September 27, 2021 9:10 PM
> > 
> > On Mon, Sep 27, 2021 at 01:00:08PM +0000, Tian, Kevin wrote:
> >   
> > > > I think for such a narrow usage you should not change the struct
> > > > device_driver. Just have pci_stub call a function to flip back to user
> > > > mode.  
> > >
> > > Here we want to ensure that kernel dma should be blocked
> > > if the group is already marked for user-dma. If we just blindly
> > > do it for any driver at this point (as you commented earlier):
> > >
> > > +       ret = iommu_set_kernel_ownership(dev);
> > > +       if (ret)
> > > +               return ret;
> > >
> > > how would pci-stub reach its function to indicate that it doesn't
> > > do dma and flip back?  
> >   
> > > Do you envision a simpler policy that no driver can be bound
> > > to the group if it's already set for user-dma? what about vfio-pci
> > > itself?  
> > 
> > Yes.. I'm not sure there is a good use case to allow the stub drivers
> > to load/unload while a VFIO is running. At least, not a strong enough
> > one to justify a global change to the driver core..  
> 
> I'm fine with not loading pci-stub. From the very 1st commit msg
> looks pci-stub was introduced before vfio to prevent host driver 
> loading when doing device assignment with KVM. I'm not sure 
> whether other usages are built on pci-stub later, but in general it's 
> not good to position devices in a same group into different usages.

IIRC, pci-stub was invented for legacy KVM device assignment because
KVM was never an actual device driver, it just latched onto and started
using the device.  If there was an existing driver for the device then
KVM would fail to get device resources.  Therefore the device needed to
be unbound from its standard host driver, but that left it susceptible
to driver loads usurping the device.  Therefore pci-stub came along to
essentially claim the device on behalf of KVM.

With vfio, there are a couple use cases of pci-stub that can be
interesting.  The first is that pci-stub is generally built into the
kernel, not as a module, which provides users the ability to specify a
list of ids for pci-stub to claim on the kernel command line with
higher priority than loadable modules.  This can prevent default driver
bindings to devices until tools like driverctl or boot time scripting
gets a shot to load the user designated driver for a device.

The other use case, is that if a group is composed of multiple devices
and all those devices are bound to vfio drivers, then the user can gain
direct access to each of those devices.  If we wanted to insert a
barrier to restrict user access to certain devices within a group, we'd
suggest binding those devices to pci-stub.  Obviously within a group, it
may still be possible to manipulate the device via p2p DMA, but the
barrier is much higher and device, if not platform, specific to
manipulate such devices.  An example use case might be a chipset
Ethernet controller grouped among system management function in a
multi-function root complex integrated endpoint.

> but I'm little worried that even vfio-pci itself cannot be bound now,
> which implies that all devices in a group which are intended to be
> used by the user must be bound to vfio-pci in a breath before the 
> user attempts to open any of them, i.e. late-binding and device-
> hotplug is disallowed after the initial open. I'm not sure how 
> important such an usage would be, but it does cause user-tangible
> semantics change.

Yep, a high potential to break userspace, especially as pci-stub has
been recommended for the cases noted above.  I don't expect that tools
like libvirt manage unassigned devices within a group, but that
probably means that there are all sorts of ad-hoc user mechanisms
beyond simply assigning all the devices.  Thanks,

Alex

