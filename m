Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0892A0FAD
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 21:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgJ3UnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 16:43:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:37411 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbgJ3UnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 16:43:11 -0400
IronPort-SDR: pQFSjbidw7tmoGouIlf2OCtGGAG+xdDDfE2R4nd813O6cAOALjaxKlHq1mnG/nvj9dx94922d4
 8BCGzh9BWH+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="165165885"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="165165885"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 13:43:11 -0700
IronPort-SDR: 8VRd2G1+PEMMJU6CwFHYHQ46/+LDRIzmfAhkPV/csStSRz6ri7gJfEJcIVTCost1HGQkCPTVmX
 iPvNArqO/AlA==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="469634855"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 13:43:08 -0700
Date:   Fri, 30 Oct 2020 13:43:07 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        tglx@linutronix.de, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        Megha Dey <megha.dey@linux.intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20201030204307.GA683@otc-nc-03>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
 <20201030185858.GI2620339@nvidia.com>
 <c9303df4-3e57-6959-a89c-5fc98397ac70@intel.com>
 <20201030191706.GK2620339@nvidia.com>
 <20201030192325.GA105832@otc-nc-03>
 <20201030193045.GM2620339@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030193045.GM2620339@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30, 2020 at 04:30:45PM -0300, Jason Gunthorpe wrote:
> On Fri, Oct 30, 2020 at 12:23:25PM -0700, Raj, Ashok wrote:
> > On Fri, Oct 30, 2020 at 04:17:06PM -0300, Jason Gunthorpe wrote:
> > > On Fri, Oct 30, 2020 at 12:13:48PM -0700, Dave Jiang wrote:
> > > > 
> > > > 
> > > > On 10/30/2020 11:58 AM, Jason Gunthorpe wrote:
> > > > > On Fri, Oct 30, 2020 at 11:50:47AM -0700, Dave Jiang wrote:
> > > > > >   .../ABI/stable/sysfs-driver-dma-idxd          |    6 +
> > > > > >   Documentation/driver-api/vfio/mdev-idxd.rst   |  404 ++++++
> > > > > >   MAINTAINERS                                   |    1 +
> > > > > >   drivers/dma/Kconfig                           |    9 +
> > > > > >   drivers/dma/idxd/Makefile                     |    2 +
> > > > > >   drivers/dma/idxd/cdev.c                       |    6 +-
> > > > > >   drivers/dma/idxd/device.c                     |  294 ++++-
> > > > > >   drivers/dma/idxd/idxd.h                       |   67 +-
> > > > > >   drivers/dma/idxd/init.c                       |   86 ++
> > > > > >   drivers/dma/idxd/irq.c                        |    6 +-
> > > > > >   drivers/dma/idxd/mdev.c                       | 1121 +++++++++++++++++
> > > > > >   drivers/dma/idxd/mdev.h                       |  116 ++
> > > > > 
> > > > > Again, a subsytem driver belongs in the directory hierarchy of the
> > > > > subsystem, not in other random places. All this mdev stuff belongs
> > > > > under drivers/vfio
> > > > 
> > > > Alex seems to have disagreed last time....
> > > > https://lore.kernel.org/dmaengine/20200917113016.425dcde7@x1.home/
> > > 
> > > Nobody else in the kernel is splitting subsystems up anymore
> > >  
> > > > And I do agree with his perspective. The mdev is an extension of the PF
> > > > driver. It's a bit awkward to be a stand alone mdev driver under vfio/mdev/.
> > > 
> > > By this logic we'd have giagantic drivers under drivers/ethernet
> > > touching netdev, rdma, scsi, vdpa, etc just because that is where the
> > > PF driver came from.
> > 
> > What makes you think this is providing services like scsi/rdma/vdpa etc.. ?
> > 
> > for DSA this playes the exact same role, not a different function 
> > as you highlight above. these mdev's are creating DSA for virtualization
> > use. They aren't providing a completely different role or subsystem per-se.
> 
> It is a different subsystem, different maintainer, and different
> reviewers.
> 
> It is a development process problem, it doesn't matter what it is
> doing.

So drawing that parallel, do you expect all drivers that call
pci_register_driver() to be located in drivers/pci? Aren't they scattered
all over the place ata,scsi, platform drivers and such?

As Alex pointed out, i915 and handful of s390 drivers that are mdev users
are not in drivers/vfio. Are you sayint those drivers don't get reviewed? 

This is no different than PF driver offering VF services. Its a logical
extension. 

Reviews happen for mdev users today. What you suggest seems like cutting 
the feet to fit the shoe. Unless the maintainers are asking things 
to be split just because its calling mdev_register_device() that practice 
doesn't exist and would be totally weird if you want to move all callers of
pci_register_driver(). 

Your argument seems interesting even entertaining :-). But honestly i'm not finding it
practical :-). So every caller of mmu_register_notifier() needs to be in
mm? 

What you mention for different functions make absolute sense, not arguing
against that.  but this ain't that. 

And we just follow the asks of the maintainer. 

I know you aren't going to give up, but there is little we can do. I want
the maintainers to make that call and I'm not add more noise to this.

Cheers,
Ashok
