Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA9682DF4D
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 16:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfE2OI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 10:08:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58834 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbfE2OI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 10:08:59 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C629130044C9;
        Wed, 29 May 2019 14:08:47 +0000 (UTC)
Received: from x1.home (ovpn-116-22.phx2.redhat.com [10.3.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B9C560FAF;
        Wed, 29 May 2019 14:08:36 +0000 (UTC)
Date:   Wed, 29 May 2019 08:08:36 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Boris Fiuczynski <fiuczy@linux.ibm.com>
Cc:     "cjia@nvidia.com" <cjia@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "arei.gonglei@huawei.com" <arei.gonglei@huawei.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        Krowiak <akrowiak@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
Subject: Re: [libvirt] [PATCH v2 1/2] vfio/mdev: add version attribute for
 mdev device
Message-ID: <20190529080836.007b8755@x1.home>
In-Reply-To: <0c1f5f03-1895-b9a2-999f-f611dd295732@linux.ibm.com>
References: <20190506014514.3555-1-yan.y.zhao@intel.com>
 <20190506014904.3621-1-yan.y.zhao@intel.com>
 <20190507151826.502be009@x1.home>
 <20190508112740.GA24397@joy-OptiPlex-7040>
 <20190508152242.4b54a5e7@x1.home>
 <5eac912c-e753-b5f6-83a4-b646f991d858@linux.ibm.com>
 <20190514093140.68cc6f7a@x1.home>
 <0c1f5f03-1895-b9a2-999f-f611dd295732@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 29 May 2019 14:08:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 May 2019 22:57:15 +0200
Boris Fiuczynski <fiuczy@linux.ibm.com> wrote:

> On 5/14/19 5:31 PM, Alex Williamson wrote:
> > On Wed, 8 May 2019 17:27:47 +0200
> > Boris Fiuczynski <fiuczy@linux.ibm.com> wrote:
> >   
> >> On 5/8/19 11:22 PM, Alex Williamson wrote:  
> >>>>> I thought there was a request to make this more specific to migration
> >>>>> by renaming it to something like migration_version.  Also, as an
> >>>>>        
> >>>> so this attribute may not only include a mdev device's parent device info and
> >>>> mdev type, but also include numeric software version of vendor specific
> >>>> migration code, right?  
> >>> It's a vendor defined string, it should be considered opaque to the
> >>> user, the vendor can include whatever they feel is relevant.
> >>>      
> >> Would a vendor also be allowed to provide a string expressing required
> >> features as well as containing backend resource requirements which need
> >> to be compatible for a successful migration? Somehow a bit like a cpu
> >> model... maybe even as json or xml...
> >> I am asking this with vfio-ap in mind. In that context checking
> >> compatibility of two vfio-ap mdev devices is not as simple as checking
> >> if version A is smaller or equal to version B.  
> > 
> > Two pieces to this, the first is that the string is opaque exactly so
> > that the vendor driver can express whatever they need in it.  The user
> > should never infer that two devices are compatible.  The second is that  
> I agree.
> 
> > this is not a resource availability or reservation interface.  The fact  
> I also agree. The migration_version (version in this case is not really 
> a good fit) is a summary of requirements the source mdev has which a 
> target mdev needs to be able to fulfill in order to allow migration.
> The target mdev already exists and was already configured by other means 
> not involved in the migration check process.

Just a nit here (I hope), the target mdev does not necessarily exist at
the time we're testing migration version compatibility.  The intention
is that this feature can be used to select a target host system which
can possibly generate a compatible target mdev device before committing
to create that device.  For instance a management tool might test for
migration compatibility across a data center, narrowing the set of
potential target hosts, then proceed to select a best choice based on
factors including the ability to actually instantiate such a device on
the host.

> Using the migrations_version as some kind of configuration transport 
> and/or reservation mechanism wasn't my intention and IMHO would both be 
> wrong.

Sounds good.  Thanks,

Alex

> > that a target device would be compatible for migration should not take
> > into account whether the target has the resources to actually create
> > such a device.  Doing so would imply some sort of resource reservation
> > support that does not exist.  Matrix devices are clearly a bit
> > complicated here since maybe the source is expressing a component of
> > the device that doesn't exist on the target.  In such a "resource not
> > available at all" case, it might be fair to nak the compatibility test,
> > but a "ok, but resource not currently available" case should pass,
> > imo.  Thanks,
> > 
> > Alex
> > 
> > --
> > libvir-list mailing list
> > libvir-list@redhat.com
> > https://www.redhat.com/mailman/listinfo/libvir-list
> >   
> 
> 

