Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78369F5848
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 21:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731847AbfKHUM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 15:12:58 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40235 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730018AbfKHUM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 15:12:57 -0500
Received: by mail-qt1-f193.google.com with SMTP id o49so7851524qta.7
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 12:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NLzzQDU72ig8KfWmw87Ix0K7Ft/g9vtt1FAkWohl1xA=;
        b=VhVO5jt8rk/A1fGmGergGSo2tNtd7es7msTyv5T1NZHnq75PZOeDBFvB3w+Gy3vz3V
         9DG7xGFANVYqlZRbzQC5AFklqZmhTsgHAFznUmcpwJkKkQ85V//ouTf6ogzQRuODNUgS
         9uJQB3YS42w4UT96goDlzmIVE68Di/3ljrEWyA91KKj3c2/fy4l3QOWGBPJS4Ek1dM3g
         dTmSHMQur2JIR2OsDA1pIqqdtXZMESgGEtvDIzk+QfkWw03oJ6VXrpSvtzCilMVBHTl2
         IyWLRM+RKNMOlK2RycR+rpNptAK6+JSj8PkcSBY71fPoNcOTnYy6mAy9TWU2MQ3dHTZO
         2n8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NLzzQDU72ig8KfWmw87Ix0K7Ft/g9vtt1FAkWohl1xA=;
        b=JdTpF0tsvVy1f7byfJRc8v7KfIfjM+cEpK4flzIAl7LcKikwMFmXulSCuaDPjlCPMs
         tSkpqrgtiwBcKjC2YbGwv0xafoqtDGx01mduUgdt9ttQcKoWfZ4KrEM6dX8HNVLlWgSJ
         TKjWkEyKH12kqHgYb1DbHguPb+CPwDzNJO25w7I7zHZGzeG0CIvh2mfWWmH+v+1Qi2kN
         sZ82zQSojzxHUE8oubzigAo7sU76R9OgPOlfMgrS3kKlET/UpKCqDKB3K4OK1OY/9NZ4
         lWYFBtqwzOrPWGQXwbRXv8vx1RGlHwpdOMb42WzreTukEFndwMD+oKMu0VSjufUoFPhd
         FAwg==
X-Gm-Message-State: APjAAAV7NDaF18D+mYUC9ja68PPf6cyyuQ7P0aHQWxD14CLGe2vt7Cmu
        3hbGUSjDKVNF8gBytd/OXk/TZw==
X-Google-Smtp-Source: APXvYqxrTTvHwI6sqCWDAIuQw5CJ/CEsII1bP7ILXwgGxNSEeoHzmzvOA37vnD/EU3697mSCPuAkiw==
X-Received: by 2002:ac8:7550:: with SMTP id b16mr31008qtr.286.1573243974947;
        Fri, 08 Nov 2019 12:12:54 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id k40sm4132449qta.76.2019.11.08.12.12.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Nov 2019 12:12:54 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iTAcn-00054i-KZ; Fri, 08 Nov 2019 16:12:53 -0400
Date:   Fri, 8 Nov 2019 16:12:53 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Parav Pandit <parav@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108201253.GE10956@ziepe.ca>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
 <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108111238.578f44f1@cakuba>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 08, 2019 at 11:12:38AM -0800, Jakub Kicinski wrote:
> On Fri, 8 Nov 2019 15:40:22 +0000, Parav Pandit wrote:
> > > The new intel driver has been having a very similar discussion about how to
> > > model their 'multi function device' ie to bind RDMA and other drivers to a
> > > shared PCI function, and I think that discussion settled on adding a new bus?
> > > 
> > > Really these things are all very similar, it would be nice to have a clear
> > > methodology on how to use the device core if a single PCI device is split by
> > > software into multiple different functional units and attached to different
> > > driver instances.
> > > 
> > > Currently there is alot of hacking in this area.. And a consistent scheme
> > > might resolve the ugliness with the dma_ops wrappers.
> > > 
> > > We already have the 'mfd' stuff to support splitting platform devices, maybe
> > > we need to create a 'pci-mfd' to support splitting PCI devices?
> > > 
> > > I'm not really clear how mfd and mdev relate, I always thought mdev was
> > > strongly linked to vfio.
> > >
> >
> > Mdev at beginning was strongly linked to vfio, but as I mentioned
> > above it is addressing more use case.
> > 
> > I observed that discussion, but was not sure of extending mdev further.
> > 
> > One way to do for Intel drivers to do is after series [9].
> > Where PCI driver says, MDEV_CLASS_ID_I40_FOO
> > RDMA driver mdev_register_driver(), matches on it and does the probe().
> 
> Yup, FWIW to me the benefit of reusing mdevs for the Intel case vs
> muddying the purpose of mdevs is not a clear trade off.

IMHO, mdev has amdev_parent_ops structure clearly intended to link it
to vfio, so using a mdev for something not related to vfio seems like
a poor choice.

I suppose this series is the start and we will eventually see the
mlx5's mdev_parent_ops filled in to support vfio - but *right now*
this looks identical to the problem most of the RDMA capable net
drivers have splitting into a 'core' and a 'function'

> IMHO MFD should be of more natural use for Intel, since it's about
> providing different functionality rather than virtual slices of the
> same device.

I don't think the 'different functionality' should matter much. 

Generally these multi-function drivers are build some some common
'core' language like queues interrupts, BAR space, etc and then these
common things can be specialized into netdev, rdma, scsi, etc. So we
see a general rough design with a core layer managing the raw HW then
drivers on top of that (including netdev) using that API.

The actual layering doesn't come through in the driver model,
generally people put all the core stuff in with the netdev and then
try and shuffle the netdev around as the 'handle' for that core API.

These SFs are pretty similar in that the core physical driver
continues to provide some software API support to the SF children (at
least for mlx it is a small API)

For instance mdev has no generic way to learn the BAR struct
resources, so there is some extra API around the side that does this -
in this series it is done by hackily co-opting the drvdata to
something owned by the struct device instead of the device_driver and
using that to access the API surface on 'struct mlx5_sf *', which
includes the BAR info and so forth.

This is probably the main difference from MFD. At least the few
drivers I looked at, did not try and expose an SW API from the 'core'
to the 'part', everything was usual generic driver resource stuff.

Jason
