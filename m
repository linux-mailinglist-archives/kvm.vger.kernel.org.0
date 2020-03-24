Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30AC0190981
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 10:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgCXJXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 05:23:54 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:29523 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726697AbgCXJXy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 05:23:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585041833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rxSCaZCXJ96hzA7wzkiPyP7I+uQlkEYIo0ZxkJvFYKs=;
        b=bXtKNAuP0Ofe7p6hw4f1s+cec5ICw2B4LyD1rYC6NXQuGWL+HHrTh3Ol04zlK5qgeGyvRK
        lmjAS9AV7lBNPbqbxeC63a4jVKnqwsd5KdcoPj9CA3P3p+MLAAUsaVooBCBGueQG9N8LpO
        WDzVKbpQhuBg3pf3mKfGFlfohNTH8ug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-lpHPdBoCMjeuvmAaPQvy0g-1; Tue, 24 Mar 2020 05:23:51 -0400
X-MC-Unique: lpHPdBoCMjeuvmAaPQvy0g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5623D1B2C980;
        Tue, 24 Mar 2020 09:23:48 +0000 (UTC)
Received: from work-vm (ovpn-114-253.ams2.redhat.com [10.36.114.253])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 953BB5DA66;
        Tue, 24 Mar 2020 09:23:37 +0000 (UTC)
Date:   Tue, 24 Mar 2020 09:23:31 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>
Subject: Re: [PATCH v4 0/2] introduction of migration_version attribute for
 VFIO live migration
Message-ID: <20200324092331.GA2645@work-vm>
References: <20190531004438.24528-1-yan.y.zhao@intel.com>
 <20190603132932.1b5dc7fe@x1.home>
 <20190604003422.GA30229@joy-OptiPlex-7040>
 <20200323152959.1c39e9a7@w520.home>
 <20200324035316.GE5456@joy-OptiPlex-7040>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324035316.GE5456@joy-OptiPlex-7040>
User-Agent: Mutt/1.13.3 (2020-01-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Yan Zhao (yan.y.zhao@intel.com) wrote:
> On Tue, Mar 24, 2020 at 05:29:59AM +0800, Alex Williamson wrote:
> > On Mon, 3 Jun 2019 20:34:22 -0400
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > 
> > > On Tue, Jun 04, 2019 at 03:29:32AM +0800, Alex Williamson wrote:
> > > > On Thu, 30 May 2019 20:44:38 -0400
> > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >   
> > > > > This patchset introduces a migration_version attribute under sysfs of VFIO
> > > > > Mediated devices.
> > > > > 
> > > > > This migration_version attribute is used to check migration compatibility
> > > > > between two mdev devices of the same mdev type.
> > > > > 
> > > > > Patch 1 defines migration_version attribute in
> > > > > Documentation/vfio-mediated-device.txt
> > > > > 
> > > > > Patch 2 uses GVT as an example to show how to expose migration_version
> > > > > attribute and check migration compatibility in vendor driver.  
> > > > 
> > > > Thanks for iterating through this, it looks like we've settled on
> > > > something reasonable, but now what?  This is one piece of the puzzle to
> > > > supporting mdev migration, but I don't think it makes sense to commit
> > > > this upstream on its own without also defining the remainder of how we
> > > > actually do migration, preferably with more than one working
> > > > implementation and at least prototyped, if not final, QEMU support.  I
> > > > hope that was the intent, and maybe it's now time to look at the next
> > > > piece of the puzzle.  Thanks,
> > > > 
> > > > Alex  
> > > 
> > > Got it. 
> > > Also thank you and all for discussing and guiding all along:)
> > > We'll move to the next episode now.
> > 
> > Hi Yan,
> > 
> > As we're hopefully moving towards a migration API, would it make sense
> > to refresh this series at the same time?  I think we're still expecting
> > a vendor driver implementing Kirti's migration API to also implement
> > this sysfs interface for compatibility verification.  Thanks,
> >
> Hi Alex
> Got it!
> Thanks for reminding of this. And as now we have vfio-pci implementing
> vendor ops to allow live migration of pass-through devices, is it
> necessary to implement similar sysfs node for those devices?
> or do you think just PCI IDs of those devices are enough for libvirt to
> know device compatibility ?

Wasn't the problem that we'd have to know how to check for things like:
  a) Whether different firmware versions in the device were actually
compatible
  b) Whether minor hardware differences were compatible - e.g. some
hardware might let you migrate to the next version of hardware up.

Dave

> Thanks
> Yan
> 
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

