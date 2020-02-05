Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9CB15283B
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 10:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgBEJYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 04:24:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53364 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728148AbgBEJYQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 04:24:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580894655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wSY3Qv6hAFiMJ+ZMELgFgVfUvrY9dNbp0gOuOjqy//g=;
        b=ShYS5DVZZTP/6XCivo6Qwl3zfd5kqwwTN1w0x+NPpImbzR8KNSy6+og+akGt/fGjk36KhO
        l1L7tqP2xercSfYe3Jr8koZ16UhWrGQGYRZClBDlfUixFz8YBXx5Nxrs7mXmfRcc4j/5Mv
        FT1hlNFdeF1l/6+vZ1X5ks/dU+twmWs=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-EouTzEJpP1exE4ufEyKIFQ-1; Wed, 05 Feb 2020 04:24:07 -0500
X-MC-Unique: EouTzEJpP1exE4ufEyKIFQ-1
Received: by mail-qt1-f199.google.com with SMTP id k27so928222qtu.12
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 01:24:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wSY3Qv6hAFiMJ+ZMELgFgVfUvrY9dNbp0gOuOjqy//g=;
        b=Ig84GDXpfro8MeleeTVs7aAMIlO9e/Q1kXGWTRQHtXLeX3XHOhNiEifFTIRXZwEME0
         R5WGNCvedisxWicRJp43ve8uBZR6Ezh8h2ytAdms142r3k/aUmVZuHYsnpyE6fJtclQv
         QoRuaoYHeBYQ9n0mxb7XyRbejVJYL2FWsGPGXLnufDMq6tzi3GIgnlH4cuB5lE7KeTKd
         AIC9gemi3tbR8GD021G0waa/L/EHUjQCZO4nrwX/19ykSHd5/bvB15//XFprJsnCq8nh
         TK/mn5PHWVTwIh1AabCAb0hRmGwQADw7nT6GiUot8RgIlSr5jR0GwH7m3DU4wtE2caG7
         VvNA==
X-Gm-Message-State: APjAAAUBDPDA/bf9P+dY0EHQYeCbYYifxsGOWlWvGbNmD8MFkEHIEpRx
        SRAH09zRwwManipbJrhQcqsC86V/9HpBzEkY46Zx9Vw6TWt4RxQMiNBLrU8MxaQVH0mCWhv4jey
        psS1Q4A7pyE00
X-Received: by 2002:ac8:5353:: with SMTP id d19mr31605200qto.313.1580894647312;
        Wed, 05 Feb 2020 01:24:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqyyschR+1xoeOuBpiIeSRa2/qJVXKJqzZtd++LLazpwBb3n6x85V08OIQ0LHH/2pAjxc8X/nw==
X-Received: by 2002:ac8:5353:: with SMTP id d19mr31605178qto.313.1580894647051;
        Wed, 05 Feb 2020 01:24:07 -0800 (PST)
Received: from redhat.com (bzq-79-176-41-183.red.bezeqint.net. [79.176.41.183])
        by smtp.gmail.com with ESMTPSA id e130sm12534407qkb.72.2020.02.05.01.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 01:24:06 -0800 (PST)
Date:   Wed, 5 Feb 2020 04:23:59 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Shahaf Shuler <shahafs@mellanox.com>,
        Tiwei Bie <tiwei.bie@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "dan.daly@intel.com" <dan.daly@intel.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>
Subject: Re: [PATCH] vhost: introduce vDPA based backend
Message-ID: <20200205042259-mutt-send-email-mst@kernel.org>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200205020247.GA368700@___>
 <AM0PR0502MB37952015716C1D5E07E390B6C3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <112858a4-1a01-f4d7-e41a-1afaaa1cad45@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <112858a4-1a01-f4d7-e41a-1afaaa1cad45@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 05, 2020 at 03:50:14PM +0800, Jason Wang wrote:
> 
> On 2020/2/5 下午3:15, Shahaf Shuler wrote:
> > Wednesday, February 5, 2020 4:03 AM, Tiwei Bie:
> > > Subject: Re: [PATCH] vhost: introduce vDPA based backend
> > > 
> > > On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
> > > > On 2020/1/31 上午11:36, Tiwei Bie wrote:
> > > > > This patch introduces a vDPA based vhost backend. This backend is
> > > > > built on top of the same interface defined in virtio-vDPA and
> > > > > provides a generic vhost interface for userspace to accelerate the
> > > > > virtio devices in guest.
> > > > > 
> > > > > This backend is implemented as a vDPA device driver on top of the
> > > > > same ops used in virtio-vDPA. It will create char device entry named
> > > > > vhost-vdpa/$vdpa_device_index for userspace to use. Userspace can
> > > > > use vhost ioctls on top of this char device to setup the backend.
> > > > > 
> > > > > Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> > [...]
> > 
> > > > > +static long vhost_vdpa_do_dma_mapping(struct vhost_vdpa *v) {
> > > > > +	/* TODO: fix this */
> > > > 
> > > > Before trying to do this it looks to me we need the following during
> > > > the probe
> > > > 
> > > > 1) if set_map() is not supported by the vDPA device probe the IOMMU
> > > > that is supported by the vDPA device
> > > > 2) allocate IOMMU domain
> > > > 
> > > > And then:
> > > > 
> > > > 3) pin pages through GUP and do proper accounting
> > > > 4) store GPA->HPA mapping in the umem
> > > > 5) generate diffs of memory table and using IOMMU API to setup the dma
> > > > mapping in this method
> > > > 
> > > > For 1), I'm not sure parent is sufficient for to doing this or need to
> > > > introduce new API like iommu_device in mdev.
> > > Agree. We may also need to introduce something like the iommu_device.
> > > 
> > Would it be better for the map/umnap logic to happen inside each device ?
> > Devices that needs the IOMMU will call iommu APIs from inside the driver callback.
> 
> 
> Technically, this can work. But if it can be done by vhost-vpda it will make
> the vDPA driver more compact and easier to be implemented.
> 
> 
> > Devices that has other ways to do the DMA mapping will call the proprietary APIs.
> 
> 
> To confirm, do you prefer:
> 
> 1) map/unmap
> 
> or
> 
> 2) pass all maps at one time?
> 
> Thanks
> 
> 

I mean we really already have both right? ATM 1 is used with an iommu
and 2 without. I guess we can also have drivers ask for either or both
...

-- 
MST

