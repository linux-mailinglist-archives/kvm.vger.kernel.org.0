Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B0C41528B
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 23:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237987AbhIVVSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 17:18:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32772 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237840AbhIVVSr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 17:18:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632345437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/gYLvFBwTWP63mHQyIOLQDvO3hmF+2iVnEein9qF53Y=;
        b=G9NZG6L/GhdGFp2d4yc9CQ4GNDzxJvhr/lIijCMfUKX2htWSvOl/974bv6FPF/qUoKqqlo
        uohIIlFQLsFlE6HbqRPVsVxMoP5+LYNCuXOY8RF0K1frItrU0+qPfDxMVjkFP6nv/opKGH
        3W6JDmDfI8YUc8NCcEmZUPL4XAAsRUI=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-7pENrMjGMQOlq32h3bovag-1; Wed, 22 Sep 2021 17:17:15 -0400
X-MC-Unique: 7pENrMjGMQOlq32h3bovag-1
Received: by mail-oo1-f69.google.com with SMTP id z23-20020a4ad597000000b0029174f63d3eso2462332oos.18
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 14:17:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/gYLvFBwTWP63mHQyIOLQDvO3hmF+2iVnEein9qF53Y=;
        b=dG73Kvy0aahEPN44SrIl10Afp/hd4rAwHfzWLn/6IUdzxjZ4hhEagFBfVk0Ry0aBez
         xDQby/Z+dsMSDDMYyyW3sgU7TBh/Wxwh9KTRzqJ0bacdXN5EGdgvWoS6JkRMxN+JEGzt
         ZBz7KQA4TZ52VMc23EY4REteb+guQw+cy+fb41SvX2U+lp7ecB75stiBvxB7ZpHIapfy
         qR9eUYSJ4c0vlLtVPxKPGrSYToJtqCLZh+/QKTQSNtN9yI7rZLDPCW5q5+9J8kylz4YJ
         gJtNM7SRgD1UwPY8gaGb3wcBaeVb/0OCHVAfieZnPpwoJRs9blpkfcqQldijmL3AzTli
         mROg==
X-Gm-Message-State: AOAM533hZz0iesioUnlZKng6Uk0Vri52qhxRWKxpCfHQ6btCOIRNFLV+
        rM+YKV1yX91MEww3PtoHzQM41JXJTxwqoRFHeO0L3Sm0B1hbluGSRPIaY/PSBSEImkKurQDMXEN
        sEYlVJiL+7tBQ
X-Received: by 2002:a05:6830:2486:: with SMTP id u6mr1135216ots.93.1632345435217;
        Wed, 22 Sep 2021 14:17:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxc6iyyZw+WQTCkXn6zRwyOEIFjLLsl9TFY8nydX9jzhc7fYSxkdPKhBdO818HVxgfS9lMqEQ==
X-Received: by 2002:a05:6830:2486:: with SMTP id u6mr1135191ots.93.1632345435007;
        Wed, 22 Sep 2021 14:17:15 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id j4sm802381oia.56.2021.09.22.14.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 14:17:14 -0700 (PDT)
Date:   Wed, 22 Sep 2021 15:17:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 05/20] vfio/pci: Register device to /dev/vfio/devices
Message-ID: <20210922151712.20162912.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5433D909662D484EFE9C82E28CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
        <20210919063848.1476776-6-yi.l.liu@intel.com>
        <20210921164001.GR327412@nvidia.com>
        <20210921150929.5977702c.alex.williamson@redhat.com>
        <BN9PR11MB5433D909662D484EFE9C82E28CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Sep 2021 01:19:08 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, September 22, 2021 5:09 AM
> > 
> > On Tue, 21 Sep 2021 13:40:01 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Sun, Sep 19, 2021 at 02:38:33PM +0800, Liu Yi L wrote:  
> > > > This patch exposes the device-centric interface for vfio-pci devices. To
> > > > be compatiable with existing users, vfio-pci exposes both legacy group
> > > > interface and device-centric interface.
> > > >
> > > > As explained in last patch, this change doesn't apply to devices which
> > > > cannot be forced to snoop cache by their upstream iommu. Such devices
> > > > are still expected to be opened via the legacy group interface.  
> > 
> > This doesn't make much sense to me.  The previous patch indicates
> > there's work to be done in updating the kvm-vfio contract to understand
> > DMA coherency, so you're trying to limit use cases to those where the
> > IOMMU enforces coherency, but there's QEMU work to be done to support
> > the iommufd uAPI at all.  Isn't part of that work to understand how KVM
> > will be told about non-coherent devices rather than "meh, skip it in the
> > kernel"?  Also let's not forget that vfio is not only for KVM.  
> 
> The policy here is that VFIO will not expose such devices (no enforce-snoop)
> in the new device hierarchy at all. In this case QEMU will fall back to the
> group interface automatically and then rely on the existing contract to connect 
> vfio and QEMU. It doesn't need to care about the whatever new contract
> until such devices are exposed in the new interface.
> 
> yes, vfio is not only for KVM. But here it's more a task split based on staging
> consideration. imo it's not necessary to further split task into supporting
> non-snoop device for userspace driver and then for kvm.

Patch 10 introduces an iommufd interface for QEMU to learn whether the
IOMMU enforces DMA coherency, at that point QEMU could revert to the
legacy interface, or register the iommufd with KVM, or otherwise
establish non-coherent DMA with KVM as necessary.  We're adding cruft
to the kernel here to enforce an unnecessary limitation.

If there are reasons the kernel can't support the device interface,
that's a valid reason not to present the interface, but this seems like
picking a specific gap that userspace is already able to detect from
this series at the expense of other use cases.  Thanks,

Alex

