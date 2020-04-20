Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFF21AFF91
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 03:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgDTBep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Apr 2020 21:34:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:63140 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgDTBep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Apr 2020 21:34:45 -0400
IronPort-SDR: ilo2tcV9WpSfoI465IuZrd8LwbT4scqENDkPDInjTKXR1u7VAuCDUlYWaf30onPBYAVmxp0pcu
 5NAtq4SyfHHw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2020 18:34:44 -0700
IronPort-SDR: mm9uYTLuqw3ULYhWUSIwaiLjiK6ca7daOboSjHKj+5Z0IuEY/WGDFtohzFWgugijJkXpwe1AdE
 F3ggOZbj3jVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,405,1580803200"; 
   d="scan'208";a="428940295"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga005.jf.intel.com with ESMTP; 19 Apr 2020 18:34:37 -0700
Date:   Sun, 19 Apr 2020 21:24:57 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     "intel-gvt-dev@lists.freedesktop.org" 
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
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Message-ID: <20200420012457.GE16688@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200413055201.27053-1-yan.y.zhao@intel.com>
 <20200417104450.2d2f2fa9.cohuck@redhat.com>
 <20200417095202.GD16688@joy-OptiPlex-7040>
 <20200417132457.45d91fe3.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417132457.45d91fe3.cohuck@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 17, 2020 at 07:24:57PM +0800, Cornelia Huck wrote:
> On Fri, 17 Apr 2020 05:52:02 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Fri, Apr 17, 2020 at 04:44:50PM +0800, Cornelia Huck wrote:
> > > On Mon, 13 Apr 2020 01:52:01 -0400
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >   
> > > > This patchset introduces a migration_version attribute under sysfs of VFIO
> > > > Mediated devices.
> > > > 
> > > > This migration_version attribute is used to check migration compatibility
> > > > between two mdev devices.
> > > > 
> > > > Currently, it has two locations:
> > > > (1) under mdev_type node,
> > > >     which can be used even before device creation, but only for mdev
> > > >     devices of the same mdev type.
> > > > (2) under mdev device node,
> > > >     which can only be used after the mdev devices are created, but the src
> > > >     and target mdev devices are not necessarily be of the same mdev type
> > > > (The second location is newly added in v5, in order to keep consistent
> > > > with the migration_version node for migratable pass-though devices)  
> > > 
> > > What is the relationship between those two attributes?
> > >   
> > (1) is for mdev devices specifically, and (2) is provided to keep the same
> > sysfs interface as with non-mdev cases. so (2) is for both mdev devices and
> > non-mdev devices.
> > 
> > in future, if we enable vfio-pci vendor ops, (i.e. a non-mdev device
> > is binding to vfio-pci, but is able to register migration region and do
> > migration transactions from a vendor provided affiliate driver),
> > the vendor driver would export (2) directly, under device node.
> > It is not able to provide (1) as there're no mdev devices involved.
> 
> Ok, creating an alternate attribute for non-mdev devices makes sense.
> However, wouldn't that rather be a case (3)? The change here only
> refers to mdev devices.
>
as you pointed below, (3) and (2) serve the same purpose. 
and I think a possible usage is to migrate between a non-mdev device and
an mdev device. so I think it's better for them both to use (2) rather
than creating (3).
> > 
> > > Is existence (and compatibility) of (1) a pre-req for possible
> > > existence (and compatibility) of (2)?
> > >  
> > no. (2) does not reply on (1).
> 
> Hm. Non-existence of (1) seems to imply "this type does not support
> migration". If an mdev created for such a type suddenly does support
> migration, it feels a bit odd.
> 
yes. but I think if the condition happens, it should be reported a bug
to vendor driver.
should I add a line in the doc like "vendor driver should ensure that the
migration compatibility from migration_version under mdev_type should be
consistent with that from migration_version under device node" ?

> (It obviously cannot be a prereq for what I called (3) above.)
> 
> > 
> > > Does userspace need to check (1) or can it completely rely on (2), if
> > > it so chooses?
> > >  
> > I think it can completely reply on (2) if compatibility check before
> > mdev creation is not required.
> > 
> > > If devices with a different mdev type are indeed compatible, it seems
> > > userspace can only find out after the devices have actually been
> > > created, as (1) does not apply?  
> > yes, I think so. 
> 
> How useful would it be for userspace to even look at (1) in that case?
> It only knows if things have a chance of working if it actually goes
> ahead and creates devices.
>
hmm, is it useful for userspace to test the migration_version under mdev
type before it knows what mdev device to generate ?
like when the userspace wants to migrate an mdev device in src vm,
but it has not created target vm and the target mdev device.

> > 
> > > One of my worries is that the existence of an attribute with the same
> > > name in two similar locations might lead to confusion. But maybe it
> > > isn't a problem.
> > >  
> > Yes, I have the same feeling. but as (2) is for sysfs interface
> > consistency, to make it transparent to userspace tools like libvirt,
> > I guess the same name is necessary?
> 
> What do we actually need here, I wonder? (1) and (2) seem to serve
> slightly different purposes, while (2) and what I called (3) have the
> same purpose. Is it important to userspace that (1) and (2) have the
> same name?
so change (1) to migration_type_version and (2) to
migration_instance_version?
But as they are under different locations, could that location imply
enough information?


Thanks
Yan


