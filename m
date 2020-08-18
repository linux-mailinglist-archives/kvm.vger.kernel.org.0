Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B252480F9
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 10:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgHRI4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 04:56:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58260 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726145AbgHRI4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 04:56:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597740975;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YPZgXjQb52VhFVEetq2acOCAcagkGxS79k5We/M/mtA=;
        b=TVx9dwSHAb8B/cjYJcHZVgvA2lMeiWHHaxav1M1Vws496YMF9eAXXdHYhfUxmyaLdw1UEz
        z4t0mHNp5Gow4cciIluThDFRbDuTb6a5rsX/ADUPb3uriQ1lm81s/TGZd8BksH+kLh1dsO
        vvKOsoHy6DkCwqpKvBTfX44rmp/HoHk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-hyHtzCccOgKC8v6NfJ3lGw-1; Tue, 18 Aug 2020 04:55:48 -0400
X-MC-Unique: hyHtzCccOgKC8v6NfJ3lGw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E5AA81F012;
        Tue, 18 Aug 2020 08:55:46 +0000 (UTC)
Received: from redhat.com (unknown [10.36.110.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 68EC654596;
        Tue, 18 Aug 2020 08:55:30 +0000 (UTC)
Date:   Tue, 18 Aug 2020 09:55:27 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Parav Pandit <parav@mellanox.com>, jian-feng.ding@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, hejie.xu@intel.com,
        bao.yumeng@zte.com.cn,
        Alex Williamson <alex.williamson@redhat.com>,
        eskultet@redhat.com, smooney@redhat.com,
        intel-gvt-dev@lists.freedesktop.org,
        Cornelia Huck <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>, dinechin@redhat.com,
        devel@ovirt.org
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200818085527.GB20215@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20200805021654.GB30485@joy-OptiPlex-7040>
 <2624b12f-3788-7e2b-2cb7-93534960bcb7@redhat.com>
 <20200805075647.GB2177@nanopsycho>
 <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
 <20200805093338.GC30485@joy-OptiPlex-7040>
 <20200805105319.GF2177@nanopsycho>
 <20200810074631.GA29059@joy-OptiPlex-7040>
 <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
 <20200814051601.GD15344@joy-OptiPlex-7040>
 <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
User-Agent: Mutt/1.14.5 (2020-06-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 11:24:30AM +0800, Jason Wang wrote:
> 
> On 2020/8/14 下午1:16, Yan Zhao wrote:
> > On Thu, Aug 13, 2020 at 12:24:50PM +0800, Jason Wang wrote:
> > > On 2020/8/10 下午3:46, Yan Zhao wrote:
> > > > > driver is it handled by?
> > > > It looks that the devlink is for network device specific, and in
> > > > devlink.h, it says
> > > > include/uapi/linux/devlink.h - Network physical device Netlink
> > > > interface,
> > > 
> > > Actually not, I think there used to have some discussion last year and the
> > > conclusion is to remove this comment.
> > > 
> > > It supports IB and probably vDPA in the future.
> > > 
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
> 
> 
> See the discussion here:
> 
> https://patchwork.ozlabs.org/project/netdev/patch/20191115223355.1277139-1-jeffrey.t.kirsher@intel.com/
> 
> 
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
> > 
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
> > |- [path to device]
> >    |--- migration
> >    |     |--- self
> >    |     |   |---device_api
> >    |	|   |---mdev_type
> >    |	|   |---software_version
> >    |	|   |---device_id
> >    |	|   |---aggregator
> >    |     |--- compatible
> >    |     |   |---device_api
> >    |	|   |---mdev_type
> >    |	|   |---software_version
> >    |	|   |---device_id
> >    |	|   |---aggregator
> > 
> 
> Yes but:
> 
> - You need one file per attribute (one syscall for one attribute)
> - Attribute is coupled with kobject
> 
> All of above seems unnecessary.
> 
> Another point, as we discussed in another thread, it's really hard to make
> sure the above API work for all types of devices and frameworks. So having a
> vendor specific API looks much better.

From the POV of userspace mgmt apps doing device compat checking / migration,
we certainly do NOT want to use different vendor specific APIs. We want to
have an API that can be used / controlled in a standard manner across vendors.



Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

