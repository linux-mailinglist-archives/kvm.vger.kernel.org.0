Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 775C21C755
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 12:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbfENK5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 06:57:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37644 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfENK5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 06:57:21 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EBF7FC045770;
        Tue, 14 May 2019 10:57:19 +0000 (UTC)
Received: from beluga.usersys.redhat.com (unknown [10.43.2.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 39A211001DE1;
        Tue, 14 May 2019 10:57:07 +0000 (UTC)
Date:   Tue, 14 May 2019 12:57:04 +0200
From:   Erik Skultety <eskultet@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "arei.gonglei@huawei.com" <arei.gonglei@huawei.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
Subject: Re: [PATCH v2 1/2] vfio/mdev: add version attribute for mdev device
Message-ID: <20190514105704.GA10926@beluga.usersys.redhat.com>
References: <20190510110838.2df4c4d0.cohuck@redhat.com>
 <20190510093608.GD2854@work-vm>
 <20190510114838.7e16c3d6.cohuck@redhat.com>
 <20190513132804.GD11139@beluga.usersys.redhat.com>
 <20190514061235.GC20407@joy-OptiPlex-7040>
 <20190514072039.GA2089@beluga.usersys.redhat.com>
 <20190514073219.GD20407@joy-OptiPlex-7040>
 <20190514074344.GB2089@beluga.usersys.redhat.com>
 <20190514074736.GE20407@joy-OptiPlex-7040>
 <20190514115135.078bbaf7.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190514115135.078bbaf7.cohuck@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 14 May 2019 10:57:20 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 14, 2019 at 11:51:35AM +0200, Cornelia Huck wrote:
> On Tue, 14 May 2019 03:47:36 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
>
> > On Tue, May 14, 2019 at 03:43:44PM +0800, Erik Skultety wrote:
> > > On Tue, May 14, 2019 at 03:32:19AM -0400, Yan Zhao wrote:
> > > > On Tue, May 14, 2019 at 03:20:40PM +0800, Erik Skultety wrote:
>
> > > > > That said, from libvirt POV as a consumer, I'd expect there to be truly only 2
> > > > > errors (I believe Alex has mentioned something similar in one of his responses
> > > > > in one of the threads):
> > > > >     a) read error indicating that an mdev type doesn't support migration
> > > > >         - I assume if one type doesn't support migration, none of the other
> > > > >           types exposed on the parent device do, is that a fair assumption?
>
> Probably; but there might be cases where the migratability depends not
> on the device type, but how the partitioning has been done... or is
> that too contrived?

No, you have a point - once again I let my thoughts be carried away by the idea
of heterogeneous setups, which is a discussion for another time anyway, I was
just thinking out loud.

>
> > > > >     b) write error indicating that the mdev types are incompatible for
> > > > >     migration
> > > > >
> > > > > Regards,
> > > > > Erik
> > > > Thanks for this explanation.
> > > > so, can we arrive at below agreements?
> > > >
> > > > 1. "not to define the specific errno returned for a specific situation,
> > > > let the vendor driver decide, userspace simply needs to know that an errno on
> > > > read indicates the device does not support migration version comparison and
> > > > that an errno on write indicates the devices are incompatible or the target
> > > > doesn't support migration versions. "
> > > > 2. vendor driver should log detailed error reasons in kernel log.
> > >
> > > That would be my take on this, yes, but I open to hear any other suggestions and
> > > ideas I couldn't think of as well.
>
> So, read to find out whether migration is supported at all, write to
> find out whether it is supported for that concrete pairing is
> reasonable for libvirt?

Yes, more specifically, in the prepare phase of migration, we'd retrieve the
string (potentially reporting an error like: "Failed to query migration
support: <errno translation>"), put the string into the migration cookie and
do the check with write on destination. The only thing is that if the error is
on the destination, the error message in kernel log lives only on the
destination, which doesn't help libvirt users, so it would require setting up
remote logging, but for layered products, this is not a problem since those
already utilize central logging nodes.

Then there are the libvirt-specific bits out of scope of this discussion,
whether we should only assume identical mdev type pairs, or whether we should
employ best effort approach and iterate over all the available types exposed by
the vendor and check whether any of the types would support this migration
(back to your note Connie, partitioning would come into the picture here).


>
> > >
> > > Erik
> > got it. thanks a lot!
> >
> > hi Cornelia and Dave,
> > do you also agree on:
> > 1. "not to define the specific errno returned for a specific situation,
> > let the vendor driver decide, userspace simply needs to know that an errno on
> > read indicates the device does not support migration version comparison and
> > that an errno on write indicates the devices are incompatible or the target
> > doesn't support migration versions. "
> > 2. vendor driver should log detailed error reasons in kernel log.
>
> Two questions:
> - How reasonable is it to refer to the system log in order to find out
>   what exactly went wrong?
> - If detailed error reporting is basically done to the syslog, do
>   different error codes still provide useful information? Or should the
>   vendor driver decide what it wants to do?

I'd leave anything beyond returning -1 on read/write from/to the sysfs to the
vendor driver, as user space has no control over it, even if there was a
facility to interpret different return codes for us, I'm not sure (in this
migration-related case) how much would userspace be able to recover or
fallback anyway, you either can or cannot migrate smoothely.

Regards,
Erik

