Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70A9245A98
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 04:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgHQCE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 22:04:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:7782 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgHQCE0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 22:04:26 -0400
IronPort-SDR: fLPgklD5sJkW3bGjWB/ZtLVeCw1hy0DnOwB/y6XKyA1GWkbAfOmfzke08ZDjYT/JB3at4jf/PO
 5pNlVB7NJRIw==
X-IronPort-AV: E=McAfee;i="6000,8403,9715"; a="142452868"
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="142452868"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2020 19:04:25 -0700
IronPort-SDR: S5k/19kCClm6ovv+d8ah7luP6CsvMjkNkmihpCmBdO7vghlRIgRTwLImn67Da2z4j6FdZHShkl
 WoFhGsjd97KQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="326271212"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga008.jf.intel.com with ESMTP; 16 Aug 2020 19:04:19 -0700
Date:   Mon, 17 Aug 2020 09:52:43 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Mooney <smooney@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, Jiri Pirko <jiri@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        eskultet@redhat.com, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Parav Pandit <parav@mellanox.com>, jian-feng.ding@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, hejie.xu@intel.com,
        bao.yumeng@zte.com.cn,
        Alex Williamson <alex.williamson@redhat.com>,
        intel-gvt-dev@lists.freedesktop.org, berrange@redhat.com,
        corbet@lwn.net, dinechin@redhat.com, devel@ovirt.org
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200817015243.GE15344@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200805021654.GB30485@joy-OptiPlex-7040>
 <2624b12f-3788-7e2b-2cb7-93534960bcb7@redhat.com>
 <20200805075647.GB2177@nanopsycho>
 <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
 <20200805093338.GC30485@joy-OptiPlex-7040>
 <20200805105319.GF2177@nanopsycho>
 <20200810074631.GA29059@joy-OptiPlex-7040>
 <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
 <20200814051601.GD15344@joy-OptiPlex-7040>
 <a4f4a3cf76b87346a4cc4c39c116f575eaab9bac.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4f4a3cf76b87346a4cc4c39c116f575eaab9bac.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 14, 2020 at 01:30:00PM +0100, Sean Mooney wrote:
> On Fri, 2020-08-14 at 13:16 +0800, Yan Zhao wrote:
> > On Thu, Aug 13, 2020 at 12:24:50PM +0800, Jason Wang wrote:
> > > 
> > > On 2020/8/10 下午3:46, Yan Zhao wrote:
> > > > > driver is it handled by?
> > > > 
> > > > It looks that the devlink is for network device specific, and in
> > > > devlink.h, it says
> > > > include/uapi/linux/devlink.h - Network physical device Netlink
> > > > interface,
> > > 
> > > 
> > > Actually not, I think there used to have some discussion last year and the
> > > conclusion is to remove this comment.
> > > 
> > > It supports IB and probably vDPA in the future.
> > > 
> > 
> > hmm... sorry, I didn't find the referred discussion. only below discussion
> > regarding to why to add devlink.
> > 
> > https://www.mail-archive.com/netdev@vger.kernel.org/msg95801.html
> > 	>This doesn't seem to be too much related to networking? Why can't something
> > 	>like this be in sysfs?
> > 	
> > 	It is related to networking quite bit. There has been couple of
> > 	iteration of this, including sysfs and configfs implementations. There
> > 	has been a consensus reached that this should be done by netlink. I
> > 	believe netlink is really the best for this purpose. Sysfs is not a good
> > 	idea
> > 
> > https://www.mail-archive.com/netdev@vger.kernel.org/msg96102.html
> > 	>there is already a way to change eth/ib via
> > 	>echo 'eth' > /sys/bus/pci/drivers/mlx4_core/0000:02:00.0/mlx4_port1
> > 	>
> > 	>sounds like this is another way to achieve the same?
> > 	
> > 	It is. However the current way is driver-specific, not correct.
> > 	For mlx5, we need the same, it cannot be done in this way. Do devlink is
> > 	the correct way to go.
> im not sure i agree with that.
> standardising a filesystem based api that is used across all vendors is also a valid
> option.  that said if devlink is the right choice form a kerenl perspective by all
> means use it but i have not heard a convincing argument for why it actually better.
> with tthat said we have been uing tools like ethtool to manage aspect of nics for decades
> so its not that strange an idea to use a tool and binary protocoal rather then a text
> based interface for this but there are advantages to both approches.
> >
Yes, I agree with you.

> > https://lwn.net/Articles/674867/
> > 	There a is need for some userspace API that would allow to expose things
> > 	that are not directly related to any device class like net_device of
> > 	ib_device, but rather chip-wide/switch-ASIC-wide stuff.
> > 
> > 	Use cases:
> > 	1) get/set of port type (Ethernet/InfiniBand)
> > 	2) monitoring of hardware messages to and from chip
> > 	3) setting up port splitters - split port into multiple ones and squash again,
> > 	   enables usage of splitter cable
> > 	4) setting up shared buffers - shared among multiple ports within one chip
> > 
> > 
> > 
> > we actually can also retrieve the same information through sysfs, .e.g
> > 
> > > - [path to device]
> > 
> >   |--- migration
> >   |     |--- self
> >   |     |   |---device_api
> >   |	|   |---mdev_type
> >   |	|   |---software_version
> >   |	|   |---device_id
> >   |	|   |---aggregator
> >   |     |--- compatible
> >   |     |   |---device_api
> >   |	|   |---mdev_type
> >   |	|   |---software_version
> >   |	|   |---device_id
> >   |	|   |---aggregator
> > 
> > 
> > 
> > > 
> > > >   I feel like it's not very appropriate for a GPU driver to use
> > > > this interface. Is that right?
> > > 
> > > 
> > > I think not though most of the users are switch or ethernet devices. It
> > > doesn't prevent you from inventing new abstractions.
> > 
> > so need to patch devlink core and the userspace devlink tool?
> > e.g. devlink migration
> and devlink python libs if openstack was to use it directly.
> we do have caes where we just frok a process and execaute a comannd in a shell
> with or without elevated privladge but we really dont like doing that due to 
> the performacne impacat and security implciations so where we can use python bindign
> over c apis we do. pyroute2 is the only python lib i know off of the top of my head
> that support devlink so we would need to enhacne it to support this new devlink api.
> there may be otherss i have not really looked in the past since we dont need to use
> devlink at all today.
> > 
> > > Note that devlink is based on netlink, netlink has been widely used by
> > > various subsystems other than networking.
> > 
> > the advantage of netlink I see is that it can monitor device status and
> > notify upper layer that migration database needs to get updated.
> > But not sure whether openstack would like to use this capability.
> > As Sean said, it's heavy for openstack. it's heavy for vendor driver
> > as well :)
> > 
> > And devlink monitor now listens the notification and dumps the state
> > changes. If we want to use it, need to let it forward the notification
> > and dumped info to openstack, right?
> i dont think we would use direct devlink monitoring in nova even if it was avaiable.
> we could but we already poll libvirt and the system for other resouce periodicly.
so, if we use file system based approach, could openstack periodically check and
update the migration info?
e.g.
every minute, read /sys/<path to device>/migration/self/*, and if there
are any file disappearing or appearing or content changes, just let the
placement know.

Then when about to start migration, check source device's
/sys/<path to src device>/migration/compatible/* and searches the
placement if there are existing device matching to it,
if yes, create vm with the device and migrate to it;
if not, and if it's an mdev, try to create a matching one and migrate to
it.
(to create a matching mdev, I guess openstack can follow below sequence:
1. find a target device with the same device id (e.g. parent pci id)
2. create an mdev with matching mdev type
3. adjust other vendor specific attributes
4. if 2 or 3 fails, go to 1 again
)

is this approach feasible?


> we likely wouldl just add monitoriv via devlink to that periodic task.
> we certenly would not use it to detect a migration or a need to update a migration database(not sure what that is)
by migration database, I meant the traits in the placement. :)

if a periodic monitoring or devlink is required, then periodically
monitor sysfs is also viable, right?
> 
> in reality if we can consume this info indirectly via a libvirt api that will
> be the appcoh we will take at least for the libvirt driver in nova. for cyborg
> they may take a different appoch. we already use pyroute2 in 2 projects, os-vif and
> neutron and it does have devlink support so the burden of using devlink is not that
> high for openstack but its a less frineadly interface for configuration tools like
> ansiable vs a filesystem based approch.
> > 

 
