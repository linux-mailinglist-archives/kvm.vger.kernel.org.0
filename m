Return-Path: <kvm+bounces-156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EBA17DC7CC
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 08:59:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28FDA2817A5
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 07:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6866E1118A;
	Tue, 31 Oct 2023 07:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FbVgxIVl"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E05DF6D
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:59:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2998A6
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 00:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698739151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hektqJYfBndJTIRB26QhmhfhD5dNFm+lfqbRs0QDUyk=;
	b=FbVgxIVlerBWtC23yUIwZnj2/SRHLYlNx8NccCIYDNkpI0Dl2xMO//0N1+6kzCNknA8Nlx
	XKMtYc7Fvd+VmOAXt2XQmuqNkqxT1xNqXLymaMPPqtJ4UgHrBzWJ3zU9Oub+0LbMUhGYvt
	xdcsJYSbkkiw4QCcSsMSFqig/ehKZA8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-G2tdIewSOI2IxqrmPcrZHg-1; Tue, 31 Oct 2023 03:59:10 -0400
X-MC-Unique: G2tdIewSOI2IxqrmPcrZHg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-32f68d3b788so2570610f8f.3
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 00:59:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698739149; x=1699343949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hektqJYfBndJTIRB26QhmhfhD5dNFm+lfqbRs0QDUyk=;
        b=J2CrbF1rgB6omKw8EVEiPJ4m2+xoNKUvAzHJaVbjjAUZ5xrQCo4JSZNDXi94/OYrLW
         mwqiNHw/3++WmkCtjEcZGJ3Ebi0We46ahKySBKbrrchN20XLIMSDojbIBMOEhPXPTvsY
         7R6WSi5OhYCG3299uDl+oYRC8ywW64ExNaLqOfnFGVZuWPl+6dSSrpU7FqXLFSjbJMJz
         c0PwBX3+n7uNoXOTuSffSTeqycKx1E9yztLJJAQqS1AzaOysmcvEDxF39UTqCC32g9vg
         DTe8Om6RXaoEW/Ji/01U6Ubo06Vx7G7asbMiniXj1Cfn4ouPD+uLAW25y62iOtabAjyH
         X7og==
X-Gm-Message-State: AOJu0YxQQEr8J9EkD1rBOjndRPMe23xGjxZN0bqRMcw+p8TewrtSxbAP
	fqebzeH6vI/3uMNARFQ33I+q7yDjDyYk2d044edUqH6QkIdiCyCuG3E0lYfDCUyO/Agir7kkd8V
	6LhjJXYAmc4dh
X-Received: by 2002:a05:6000:178e:b0:32f:8d4a:efa8 with SMTP id e14-20020a056000178e00b0032f8d4aefa8mr3007251wrg.23.1698739148857;
        Tue, 31 Oct 2023 00:59:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IElvP//AsawVxFiLZYbzjtueiSw9evjqF6N1p48fpjYeLUE2NWHwk7hrkP+j+8sU1dzNErG2g==
X-Received: by 2002:a05:6000:178e:b0:32f:8d4a:efa8 with SMTP id e14-20020a056000178e00b0032f8d4aefa8mr3007225wrg.23.1698739148545;
        Tue, 31 Oct 2023 00:59:08 -0700 (PDT)
Received: from redhat.com ([2.52.26.150])
        by smtp.gmail.com with ESMTPSA id i4-20020a5d4384000000b00326f0ca3566sm855421wrq.50.2023.10.31.00.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 00:59:08 -0700 (PDT)
Date: Tue, 31 Oct 2023 03:59:04 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Parav Pandit <parav@nvidia.com>
Cc: Yishai Hadas <yishaih@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>,
	Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH V2 vfio 2/9] virtio-pci: Introduce admin virtqueue
Message-ID: <20231031034833-mutt-send-email-mst@kernel.org>
References: <20231029155952.67686-1-yishaih@nvidia.com>
 <20231029155952.67686-3-yishaih@nvidia.com>
 <20231029161909-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54810E45C628DE3A5829D438DCA1A@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231030115759-mutt-send-email-mst@kernel.org>
 <PH0PR12MB548197CD7A10D5A89B7213CDDCA1A@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231030193110-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481F2851BF40C5BBD59909CDCA0A@PH0PR12MB5481.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB5481F2851BF40C5BBD59909CDCA0A@PH0PR12MB5481.namprd12.prod.outlook.com>

On Tue, Oct 31, 2023 at 03:11:57AM +0000, Parav Pandit wrote:
> 
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Tuesday, October 31, 2023 5:02 AM
> > 
> > On Mon, Oct 30, 2023 at 06:10:06PM +0000, Parav Pandit wrote:
> > >
> > >
> > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > Sent: Monday, October 30, 2023 9:29 PM On Mon, Oct 30, 2023 at
> > > > 03:51:40PM +0000, Parav Pandit wrote:
> > > > >
> > > > >
> > > > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > > > Sent: Monday, October 30, 2023 1:53 AM
> > > > > >
> > > > > > On Sun, Oct 29, 2023 at 05:59:45PM +0200, Yishai Hadas wrote:
> > > > > > > From: Feng Liu <feliu@nvidia.com>
> > > > > > >
> > > > > > > Introduce support for the admin virtqueue. By negotiating
> > > > > > > VIRTIO_F_ADMIN_VQ feature, driver detects capability and
> > > > > > > creates one administration virtqueue. Administration virtqueue
> > > > > > > implementation in virtio pci generic layer, enables multiple
> > > > > > > types of upper layer drivers such as vfio, net, blk to utilize it.
> > > > > > >
> > > > > > > Signed-off-by: Feng Liu <feliu@nvidia.com>
> > > > > > > Reviewed-by: Parav Pandit <parav@nvidia.com>
> > > > > > > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> > > > > > > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > > > > > > ---
> > > > > > >  drivers/virtio/virtio.c                | 37 ++++++++++++++--
> > > > > > >  drivers/virtio/virtio_pci_common.c     |  3 ++
> > > > > > >  drivers/virtio/virtio_pci_common.h     | 15 ++++++-
> > > > > > >  drivers/virtio/virtio_pci_modern.c     | 61
> > +++++++++++++++++++++++++-
> > > > > > >  drivers/virtio/virtio_pci_modern_dev.c | 18 ++++++++
> > > > > > >  include/linux/virtio_config.h          |  4 ++
> > > > > > >  include/linux/virtio_pci_modern.h      |  5 +++
> > > > > > >  7 files changed, 137 insertions(+), 6 deletions(-)
> > > > > > >
> > > > > > > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > > > > > > index
> > > > > > > 3893dc29eb26..f4080692b351 100644
> > > > > > > --- a/drivers/virtio/virtio.c
> > > > > > > +++ b/drivers/virtio/virtio.c
> > > > > > > @@ -302,9 +302,15 @@ static int virtio_dev_probe(struct device *_d)
> > > > > > >  	if (err)
> > > > > > >  		goto err;
> > > > > > >
> > > > > > > +	if (dev->config->create_avq) {
> > > > > > > +		err = dev->config->create_avq(dev);
> > > > > > > +		if (err)
> > > > > > > +			goto err;
> > > > > > > +	}
> > > > > > > +
> > > > > > >  	err = drv->probe(dev);
> > > > > > >  	if (err)
> > > > > > > -		goto err;
> > > > > > > +		goto err_probe;
> > > > > > >
> > > > > > >  	/* If probe didn't do it, mark device DRIVER_OK ourselves. */
> > > > > > >  	if (!(dev->config->get_status(dev) &
> > > > > > > VIRTIO_CONFIG_S_DRIVER_OK))
> > > > > >
> > > > > > Hmm I am not all that happy that we are just creating avq
> > unconditionally.
> > > > > > Can't we do it on demand to avoid wasting resources if no one uses it?
> > > > > >
> > > > > Virtio queues must be enabled before driver_ok as we discussed in
> > > > F_DYNAMIC bit exercise.
> > > > > So creating AQ when first legacy command is invoked, would be too late.
> > > >
> > > > Well we didn't release the spec with AQ so I am pretty sure there
> > > > are no devices using the feature. Do we want to already make an
> > > > exception for AQ and allow creating AQs after DRIVER_OK even without
> > F_DYNAMIC?
> > > >
> > > No. it would abuse the init time config registers for the dynamic things like
> > this.
> > > For flow filters and others there is need for dynamic q creation with multiple
> > physical address anyway.
> > 
> > That seems like a completely unrelated issue.
> > 
> It isn't.
> Driver requirements are:
> 1. Driver needs to dynamically create vqs
> 2. Sometimes this VQ needs to have multiple physical addresses
> 3. Driver needs to create them after driver is fully running, past the bootstrap stage using tiny config registers
> 
> Device requirements are:
> 1. Not to keep growing 64K VQs *(8+8+8) bytes of address registers + enable bit
> 2. Ability to return appropriate error code when fail to create queue
> 3. Above #2
> 
> Users of this new infrastructure are eth tx,rx queues, flow filter queues, aq, blk rq per cpu.
> AQs are just one of those.
> When a generic infrastructure for this will be built in the spec as we started that, all above use cases will be handled.
> 
> > > So creating virtqueues dynamically using a generic scheme is desired with
> > new feature bit.

Reducing config registers and returning errors should be handled by
a new transport.
VQ with multiple addresses - I can see how you would maybe only
support that with that new transport?


I think I can guess why you are tying multiple addresses to dynamic VQs -
you suspect that allocating huge half-megabyte VQs dynamically will fail if
triggered on a busy system. Is that the point?


In that case I feel it's a good argument to special-case
admin VQs because there's no real need to make them
huge at the moment - for example this driver just adds one at a time.
No?



-- 
MST


