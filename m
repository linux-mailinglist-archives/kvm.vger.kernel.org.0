Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6D83AA9AB
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 05:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhFQDn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 23:43:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:65473 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229666AbhFQDnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 23:43:25 -0400
IronPort-SDR: JmdZPV+TuBGTo4921QJgcR282Z4+jIdiUs2neGlUOXk1+3iV+rauT/MuuisuPek7Ialh7Dmzm1
 US/vDI1W8ZLQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10017"; a="206115029"
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="scan'208";a="206115029"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 20:41:14 -0700
IronPort-SDR: hN25HVOR5pyyyUc5hRQTXGQkq1gDSr9RlPJLy66VnJjxHqezpZCRSobBBy1gZXrmADMFAiH6S5
 PMhRF+fpwHHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="scan'208";a="472275347"
Received: from yiliu-dev.bj.intel.com (HELO yiliu-dev) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 16 Jun 2021 20:41:09 -0700
Date:   Thu, 17 Jun 2021 11:39:35 +0800
From:   Liu Yi L <yi.l.liu@linux.intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     yi.l.liu@intel.com, "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
        "Raj, Ashok" <ashok.raj@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210617113935.05c1b77c@yiliu-dev>
In-Reply-To: <20210616133937.59050e1a.alex.williamson@redhat.com>
References: <20210609150009.GE1002214@nvidia.com>
        <YMDjfmJKUDSrbZbo@8bytes.org>
        <20210609101532.452851eb.alex.williamson@redhat.com>
        <20210609102722.5abf62e1.alex.williamson@redhat.com>
        <20210609184940.GH1002214@nvidia.com>
        <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
        <20210611164529.GR1002214@nvidia.com>
        <20210611133828.6c6e8b29.alex.williamson@redhat.com>
        <20210612012846.GC1002214@nvidia.com>
        <20210612105711.7ac68c83.alex.williamson@redhat.com>
        <20210614140711.GI1002214@nvidia.com>
        <20210614102814.43ada8df.alex.williamson@redhat.com>
        <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210615101215.4ba67c86.alex.williamson@redhat.com>
        <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210616133937.59050e1a.alex.williamson@redhat.com>
Organization: IAGS/SSE(OTC)
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On Wed, 16 Jun 2021 13:39:37 -0600, Alex Williamson wrote:

> On Wed, 16 Jun 2021 06:43:23 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Wednesday, June 16, 2021 12:12 AM
> > > 
> > > On Tue, 15 Jun 2021 02:31:39 +0000
> > > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > >     
> > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > Sent: Tuesday, June 15, 2021 12:28 AM
> > > > >    
> > > > [...]    
> > > > > > IOASID. Today the group fd requires an IOASID before it hands out a
> > > > > > device_fd. With iommu_fd the device_fd will not allow IOCTLs until it
> > > > > > has a blocked DMA IOASID and is successefully joined to an iommu_fd.    
> > > > >
> > > > > Which is the root of my concern.  Who owns ioctls to the device fd?
> > > > > It's my understanding this is a vfio provided file descriptor and it's
> > > > > therefore vfio's responsibility.  A device-level IOASID interface
> > > > > therefore requires that vfio manage the group aspect of device access.
> > > > > AFAICT, that means that device access can therefore only begin when all
> > > > > devices for a given group are attached to the IOASID and must halt for
> > > > > all devices in the group if any device is ever detached from an IOASID,
> > > > > even temporarily.  That suggests a lot more oversight of the IOASIDs by
> > > > > vfio than I'd prefer.
> > > > >    
> > > >
> > > > This is possibly the point that is worthy of more clarification and
> > > > alignment, as it sounds like the root of controversy here.
> > > >
> > > > I feel the goal of vfio group management is more about ownership, i.e.
> > > > all devices within a group must be assigned to a single user. Following
> > > > the three rules defined by Jason, what we really care is whether a group
> > > > of devices can be isolated from the rest of the world, i.e. no access to
> > > > memory/device outside of its security context and no access to its
> > > > security context from devices outside of this group. This can be achieved
> > > > as long as every device in the group is either in block-DMA state when
> > > > it's not attached to any security context or attached to an IOASID context
> > > > in IOMMU fd.
> > > >
> > > > As long as group-level isolation is satisfied, how devices within a group
> > > > are further managed is decided by the user (unattached, all attached to
> > > > same IOASID, attached to different IOASIDs) as long as the user
> > > > understands the implication of lacking of isolation within the group. This
> > > > is what a device-centric model comes to play. Misconfiguration just hurts
> > > > the user itself.
> > > >
> > > > If this rationale can be agreed, then I didn't see the point of having VFIO
> > > > to mandate all devices in the group must be attached/detached in
> > > > lockstep.    
> > > 
> > > In theory this sounds great, but there are still too many assumptions
> > > and too much hand waving about where isolation occurs for me to feel
> > > like I really have the complete picture.  So let's walk through some
> > > examples.  Please fill in and correct where I'm wrong.    
> > 
> > Thanks for putting these examples. They are helpful for clearing the 
> > whole picture.
> > 
> > Before filling in let's first align on what is the key difference between
> > current VFIO model and this new proposal. With this comparison we'll
> > know which of following questions are answered with existing VFIO
> > mechanism and which are handled differently.
> > 
> > With Yi's help we figured out the current mechanism:
> > 
> > 1) vfio_group_viable. The code comment explains the intention clearly:
> > 
> > --
> > * A vfio group is viable for use by userspace if all devices are in
> >  * one of the following states:
> >  *  - driver-less
> >  *  - bound to a vfio driver
> >  *  - bound to an otherwise allowed driver
> >  *  - a PCI interconnect device
> > --
> > 
> > Note this check is not related to an IOMMU security context.  
> 
> Because this is a pre-requisite for imposing that IOMMU security
> context.
>  
> > 2) vfio_iommu_group_notifier. When an IOMMU_GROUP_NOTIFY_
> > BOUND_DRIVER event is notified, vfio_group_viable is re-evaluated.
> > If the affected group was previously viable but now becomes not 
> > viable, BUG_ON() as it implies that this device is bound to a non-vfio 
> > driver which breaks the group isolation.  
> 
> This notifier action is conditional on there being users of devices
> within a secure group IOMMU context.
> 
> > 3) vfio_group_get_device_fd. User can acquire a device fd only after
> > 	a) the group is viable;
> > 	b) the group is attached to a container;
> > 	c) iommu is set on the container (implying a security context
> > 	    established);  
> 
> The order is actually b) a) c) but arguably b) is a no-op until:
> 
>     d) a device fd is provided to the user

Per the code in QEMU vfio_get_group(). The order is a) b) c). In
vfio_connect_container(), group is attached to a container.

1959 VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp)
1960 {
         ...
1978     group = g_malloc0(sizeof(*group));
1979 
1980     snprintf(path, sizeof(path), "/dev/vfio/%d", groupid);
1981     group->fd = qemu_open_old(path, O_RDWR);
1982     if (group->fd < 0) {
1983         error_setg_errno(errp, errno, "failed to open %s", path);
1984         goto free_group_exit;
1985     }
1986 
1987     if (ioctl(group->fd, VFIO_GROUP_GET_STATUS, &status)) {
1988         error_setg_errno(errp, errno, "failed to get group %d status", groupid);
1989         goto close_fd_exit;
1990     }
1991 
1992     if (!(status.flags & VFIO_GROUP_FLAGS_VIABLE)) {
1993         error_setg(errp, "group %d is not viable", groupid);
1994         error_append_hint(errp,
1995                           "Please ensure all devices within the iommu_group "
1996                           "are bound to their vfio bus driver.\n");
1997         goto close_fd_exit;
1998     }
1999 
2000     group->groupid = groupid;
2001     QLIST_INIT(&group->device_list);
2002 
2003     if (vfio_connect_container(group, as, errp)) {
2004         error_prepend(errp, "failed to setup container for group %d: ",
2005                       groupid);
2006         goto close_fd_exit;
2007     }
2008 
         ...
2024 }

-- 
Regards,
Yi Liu
