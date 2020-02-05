Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D67C51526C1
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 08:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgBEHRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 02:17:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33724 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725793AbgBEHRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 02:17:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580887026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AUYYDYCrK2cC9uPFN+Mov6qV7HoWj39WrJabiY6WXbQ=;
        b=CDyhg5Iv7Zdyu4NWfQ1guHUCZoAeGjf5zK/uRchxUpwF6GXRUHNUN3CZ763aqhRZuU6kds
        NPlZDrLU+//pYncXn+ZWOzPewzjEoYYGkJTym7x26w6KaxTv77JrBH/Rl4zx9bQ0dj/7p0
        QjnSkIts1VGU+ITRiCcQDEJP0RvM++4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-1vn-1KQiNzib8rN5mxY-Xg-1; Wed, 05 Feb 2020 02:17:05 -0500
X-MC-Unique: 1vn-1KQiNzib8rN5mxY-Xg-1
Received: by mail-qk1-f200.google.com with SMTP id m13so689314qka.9
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 23:17:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=AUYYDYCrK2cC9uPFN+Mov6qV7HoWj39WrJabiY6WXbQ=;
        b=VkDSwLC6JBZAl1JvUPVEfaABFTuwTbJcWixHA3C/T6peItn+wrug/Om7IvcJDtsQ1W
         aOUj7swmAHj/i9Pe5BxlGqnjd8RAV29AvmEsPG1jzdCPhH+e3biYijCcNXDsHQE0mcRg
         TQjluLPbnlGPhmIQg/Snw3Yn23RlZFRoJpTUdaX/LJgf7NALL4Fx7mN3fDI3mny+RmiX
         UMuUphJEV98jn7eSG56ipA3Y6WlamBhj5BpDcoFqZDxo1053OwDKS3gy2Gk0txkNXm3e
         UE35LwT4OhnejDR+6LiuNIMQBQ+fmNgA036UYUdU0jac8+jXNZiiikUhoZAqAzUcY9L2
         4Jbw==
X-Gm-Message-State: APjAAAVGxLkdnf7mfhl5I9wq1dpYq6tKj8M7efvLOPHH9I/BJim0aFIC
        WiUqWU9L4lhGjBX9WUIvyuDSBpq+3QQxPiSHV7uF8o8bgtKsGvD81d1ThuVzNksCWsXMKo8U/2T
        amfhSl8qBZDh/
X-Received: by 2002:a05:620a:21d4:: with SMTP id h20mr30574796qka.468.1580887024972;
        Tue, 04 Feb 2020 23:17:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqzEKzoKyfcbFGYqDxB2gYfRipDCYO1D0VQXc0nLsGPa3RFooMo/xVZkmNCTCYKTGNdfzll0uw==
X-Received: by 2002:a05:620a:21d4:: with SMTP id h20mr30574765qka.468.1580887024660;
        Tue, 04 Feb 2020 23:17:04 -0800 (PST)
Received: from redhat.com (bzq-79-176-41-183.red.bezeqint.net. [79.176.41.183])
        by smtp.gmail.com with ESMTPSA id y197sm3672395qka.65.2020.02.04.23.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 23:17:03 -0800 (PST)
Date:   Wed, 5 Feb 2020 02:16:57 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, shahafs@mellanox.com, jgg@mellanox.com,
        rob.miller@broadcom.com, haotian.wang@sifive.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        rdunlap@infradead.org, hch@infradead.org, jiri@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
Subject: Re: [PATCH] vhost: introduce vDPA based backend
Message-ID: <20200205020547-mutt-send-email-mst@kernel.org>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200204005306-mutt-send-email-mst@kernel.org>
 <cf485e7f-46e3-20d3-8452-e3058b885d0a@redhat.com>
 <20200205020555.GA369236@___>
 <798e5644-ca28-ee46-c953-688af9bccd3b@redhat.com>
 <20200205003048-mutt-send-email-mst@kernel.org>
 <eb53d1c2-92ae-febf-f502-2d3e107ee608@redhat.com>
 <20200205011935-mutt-send-email-mst@kernel.org>
 <2dd43fb5-6f02-2dcc-5c27-9f7419ef72fc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2dd43fb5-6f02-2dcc-5c27-9f7419ef72fc@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 05, 2020 at 02:49:31PM +0800, Jason Wang wrote:
> 
> On 2020/2/5 下午2:30, Michael S. Tsirkin wrote:
> > On Wed, Feb 05, 2020 at 01:50:28PM +0800, Jason Wang wrote:
> > > On 2020/2/5 下午1:31, Michael S. Tsirkin wrote:
> > > > On Wed, Feb 05, 2020 at 11:12:21AM +0800, Jason Wang wrote:
> > > > > On 2020/2/5 上午10:05, Tiwei Bie wrote:
> > > > > > On Tue, Feb 04, 2020 at 02:46:16PM +0800, Jason Wang wrote:
> > > > > > > On 2020/2/4 下午2:01, Michael S. Tsirkin wrote:
> > > > > > > > On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
> > > > > > > > > 5) generate diffs of memory table and using IOMMU API to setup the dma
> > > > > > > > > mapping in this method
> > > > > > > > Frankly I think that's a bunch of work. Why not a MAP/UNMAP interface?
> > > > > > > > 
> > > > > > > Sure, so that basically VHOST_IOTLB_UPDATE/INVALIDATE I think?
> > > > > > Do you mean we let userspace to only use VHOST_IOTLB_UPDATE/INVALIDATE
> > > > > > to do the DMA mapping in vhost-vdpa case? When vIOMMU isn't available,
> > > > > > userspace will set msg->iova to GPA, otherwise userspace will set
> > > > > > msg->iova to GIOVA, and vhost-vdpa module will get HPA from msg->uaddr?
> > > > > > 
> > > > > > Thanks,
> > > > > > Tiwei
> > > > > I think so. Michael, do you think this makes sense?
> > > > > 
> > > > > Thanks
> > > > to make sure, could you post the suggested argument format for
> > > > these ioctls?
> > > > 
> > > It's the existed uapi:
> > > 
> > > /* no alignment requirement */
> > > struct vhost_iotlb_msg {
> > >      __u64 iova;
> > >      __u64 size;
> > >      __u64 uaddr;
> > > #define VHOST_ACCESS_RO      0x1
> > > #define VHOST_ACCESS_WO      0x2
> > > #define VHOST_ACCESS_RW      0x3
> > >      __u8 perm;
> > > #define VHOST_IOTLB_MISS           1
> > > #define VHOST_IOTLB_UPDATE         2
> > > #define VHOST_IOTLB_INVALIDATE     3
> > > #define VHOST_IOTLB_ACCESS_FAIL    4
> > >      __u8 type;
> > > };
> > > 
> > > #define VHOST_IOTLB_MSG 0x1
> > > #define VHOST_IOTLB_MSG_V2 0x2
> > > 
> > > struct vhost_msg {
> > >      int type;
> > >      union {
> > >          struct vhost_iotlb_msg iotlb;
> > >          __u8 padding[64];
> > >      };
> > > };
> > > 
> > > struct vhost_msg_v2 {
> > >      __u32 type;
> > >      __u32 reserved;
> > >      union {
> > >          struct vhost_iotlb_msg iotlb;
> > >          __u8 padding[64];
> > >      };
> > > };
> > Oh ok.  So with a real device, I suspect we do not want to wait for each
> > change to be processed by device completely, so we might want an asynchronous variant
> > and then some kind of flush that tells device "you better apply these now".
> 
> 
> Let me explain:
> 
> There are two types of devices:
> 
> 1) device without on-chip IOMMU, DMA was done via IOMMU API which only
> support incremental map/unmap

Most IOMMUs have queues nowdays though. Whether APIs within kernel
expose that matters but we are better off on emulating
hardware not specific guest behaviour.

> 2) device with on-chip IOMMU, DMA could be done by device driver itself, and
> we could choose to pass the whole mappings to the driver at one time through
> vDPA bus operation (set_map)
> 
> For vhost-vpda, there're two types of memory mapping:
> 
> a) memory table, setup by userspace through VHOST_SET_MEM_TABLE, the whole
> mapping is updated in this way
> b) IOTLB API, incrementally done by userspace through vhost message
> (IOTLB_UPDATE/IOTLB_INVALIDATE)
> 
> The current design is:
> 
> - Reuse VHOST_SET_MEM_TABLE, and for type 1), we can choose to send diffs
> through IOMMU API or flush all the mappings then map new ones. For type 2),
> just send the whole mapping through set_map()

I know that at least for RDMA based things, you can't change
a mapping if it's active. So drivers will need to figure out the
differences which just looks ugly: userspace knows what
it was changing (really just adding/removing some guest memory).



> - Reuse vhost IOTLB, so for type 1), simply forward update/invalidate
> request via IOMMU API, for type 2), send IOTLB to vDPA device driver via
> set_map(), device driver may choose to send diffs or rebuild all mapping at
> their will
> 
> Technically we can use vhost IOTLB API (map/umap) for building
> VHOST_SET_MEM_TABLE, but to avoid device to process the each request, it
> looks to me we need new UAPI which seems sub optimal.
> 
> What's you thought?
> 
> Thanks

I suspect we can't completely avoid a new UAPI.

> 
> > 

