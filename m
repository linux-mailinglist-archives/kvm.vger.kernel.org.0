Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F6D1B19CF
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 00:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgDTW4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 18:56:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26193 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDTW4X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Apr 2020 18:56:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587423381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+6rx/b7kvEOxDoffPYjKOUpjUAof+LX7RGvD23w8b8o=;
        b=f0kOV4iULYQ7dTFtPtKufUhf3b27pMGhBimUY03roRfLpvCQAzKYbugathFQs+t/0B4+1y
        9EqHJsWECaFoeFtRYMfa5VT1EVbgbA1IWAJp6SnHiD6sTPSgXXAClZW/SSJEWIQR28taBj
        IIcg9fDiZmndWPyifvj/cxLSMQVFNx4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-vJCMrAUjOA-zQBEbwS3yOQ-1; Mon, 20 Apr 2020 18:56:19 -0400
X-MC-Unique: vJCMrAUjOA-zQBEbwS3yOQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A529C8017F5;
        Mon, 20 Apr 2020 22:56:14 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7990818A85;
        Mon, 20 Apr 2020 22:56:01 +0000 (UTC)
Date:   Mon, 20 Apr 2020 16:56:00 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Zeng, Xin" <xin.zeng@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>
Subject: Re: [PATCH v5 0/4] introduction of migration_version attribute for
 VFIO live migration
Message-ID: <20200420165600.4951ae82@w520.home>
In-Reply-To: <20200420012457.GE16688@joy-OptiPlex-7040>
References: <20200413055201.27053-1-yan.y.zhao@intel.com>
        <20200417104450.2d2f2fa9.cohuck@redhat.com>
        <20200417095202.GD16688@joy-OptiPlex-7040>
        <20200417132457.45d91fe3.cohuck@redhat.com>
        <20200420012457.GE16688@joy-OptiPlex-7040>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 19 Apr 2020 21:24:57 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Fri, Apr 17, 2020 at 07:24:57PM +0800, Cornelia Huck wrote:
> > On Fri, 17 Apr 2020 05:52:02 -0400
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > On Fri, Apr 17, 2020 at 04:44:50PM +0800, Cornelia Huck wrote:  
> > > > On Mon, 13 Apr 2020 01:52:01 -0400
> > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >     
> > > > > This patchset introduces a migration_version attribute under sysfs of VFIO
> > > > > Mediated devices.
> > > > > 
> > > > > This migration_version attribute is used to check migration compatibility
> > > > > between two mdev devices.
> > > > > 
> > > > > Currently, it has two locations:
> > > > > (1) under mdev_type node,
> > > > >     which can be used even before device creation, but only for mdev
> > > > >     devices of the same mdev type.
> > > > > (2) under mdev device node,
> > > > >     which can only be used after the mdev devices are created, but the src
> > > > >     and target mdev devices are not necessarily be of the same mdev type
> > > > > (The second location is newly added in v5, in order to keep consistent
> > > > > with the migration_version node for migratable pass-though devices)    
> > > > 
> > > > What is the relationship between those two attributes?
> > > >     
> > > (1) is for mdev devices specifically, and (2) is provided to keep the same
> > > sysfs interface as with non-mdev cases. so (2) is for both mdev devices and
> > > non-mdev devices.
> > > 
> > > in future, if we enable vfio-pci vendor ops, (i.e. a non-mdev device
> > > is binding to vfio-pci, but is able to register migration region and do
> > > migration transactions from a vendor provided affiliate driver),
> > > the vendor driver would export (2) directly, under device node.
> > > It is not able to provide (1) as there're no mdev devices involved.  
> > 
> > Ok, creating an alternate attribute for non-mdev devices makes sense.
> > However, wouldn't that rather be a case (3)? The change here only
> > refers to mdev devices.
> >  
> as you pointed below, (3) and (2) serve the same purpose. 
> and I think a possible usage is to migrate between a non-mdev device and
> an mdev device. so I think it's better for them both to use (2) rather
> than creating (3).

An mdev type is meant to define a software compatible interface, so in
the case of mdev->mdev migration, doesn't migrating to a different type
fail the most basic of compatibility tests that we expect userspace to
perform?  IOW, if two mdev types are migration compatible, it seems a
prerequisite to that is that they provide the same software interface,
which means they should be the same mdev type.

In the hybrid cases of mdev->phys or phys->mdev, how does a management
tool begin to even guess what might be compatible?  Are we expecting
libvirt to probe ever device with this attribute in the system?  Is
there going to be a new class hierarchy created to enumerate all
possible migrate-able devices?

I agree that there was a gap in the previous proposal for non-mdev
devices, but I think this bring a lot of questions that we need to
puzzle through and libvirt will need to re-evaluate how they might
decide to pick a migration target device.  For example, I'm sure
libvirt would reject any policy decisions regarding picking a physical
device versus an mdev device.  Had we previously left it that only a
layer above libvirt would select a target device and libvirt only tests
compatibility to that target device?

We also need to consider that this expands the namespace.  If we no
longer require matching types as the first level of comparison, then
vendor migration strings can theoretically collide.  How do we
coordinate that can't happen?  Thanks,

Alex

> > > > Is existence (and compatibility) of (1) a pre-req for possible
> > > > existence (and compatibility) of (2)?
> > > >    
> > > no. (2) does not reply on (1).  
> > 
> > Hm. Non-existence of (1) seems to imply "this type does not support
> > migration". If an mdev created for such a type suddenly does support
> > migration, it feels a bit odd.
> >   
> yes. but I think if the condition happens, it should be reported a bug
> to vendor driver.
> should I add a line in the doc like "vendor driver should ensure that the
> migration compatibility from migration_version under mdev_type should be
> consistent with that from migration_version under device node" ?
> 
> > (It obviously cannot be a prereq for what I called (3) above.)
> >   
> > >   
> > > > Does userspace need to check (1) or can it completely rely on (2), if
> > > > it so chooses?
> > > >    
> > > I think it can completely reply on (2) if compatibility check before
> > > mdev creation is not required.
> > >   
> > > > If devices with a different mdev type are indeed compatible, it seems
> > > > userspace can only find out after the devices have actually been
> > > > created, as (1) does not apply?    
> > > yes, I think so.   
> > 
> > How useful would it be for userspace to even look at (1) in that case?
> > It only knows if things have a chance of working if it actually goes
> > ahead and creates devices.
> >  
> hmm, is it useful for userspace to test the migration_version under mdev
> type before it knows what mdev device to generate ?
> like when the userspace wants to migrate an mdev device in src vm,
> but it has not created target vm and the target mdev device.
> 
> > >   
> > > > One of my worries is that the existence of an attribute with the same
> > > > name in two similar locations might lead to confusion. But maybe it
> > > > isn't a problem.
> > > >    
> > > Yes, I have the same feeling. but as (2) is for sysfs interface
> > > consistency, to make it transparent to userspace tools like libvirt,
> > > I guess the same name is necessary?  
> > 
> > What do we actually need here, I wonder? (1) and (2) seem to serve
> > slightly different purposes, while (2) and what I called (3) have the
> > same purpose. Is it important to userspace that (1) and (2) have the
> > same name?  
> so change (1) to migration_type_version and (2) to
> migration_instance_version?
> But as they are under different locations, could that location imply
> enough information?
> 
> 
> Thanks
> Yan
> 
> 

