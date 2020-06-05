Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991871EFB77
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 16:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgFEOcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 10:32:09 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30767 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727114AbgFEOcI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 10:32:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591367524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nPd99vEQR7LXu9otpj3r6KO6UKcwRR4YSr+8/PRbl0o=;
        b=bNvTM5WrHpNLdKrpII+Ahrj4+RjwWjdLQy5sBW5+yvUbfmSlZEpwO05z4ZFP54+FlHXvWY
        Hc4Xp8SjvGrN5j8800FUtqi0xFgO6y1wvRhicUwRLJD1BMzV90ISVSz/lgUW0Ii7sp1pzO
        lgFYzpO7BfKNnQpPykHB0e+2vw9GRKc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-5rdVUQORN6-Qx6Pv_Rm8nA-1; Fri, 05 Jun 2020 10:32:03 -0400
X-MC-Unique: 5rdVUQORN6-Qx6Pv_Rm8nA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 871921009440;
        Fri,  5 Jun 2020 14:31:58 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EEB75C578;
        Fri,  5 Jun 2020 14:31:50 +0000 (UTC)
Date:   Fri, 5 Jun 2020 08:31:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, Cornelia Huck <cohuck@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Zeng, Xin" <xin.zeng@intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
Subject: Re: [PATCH v5 0/4] introduction of migration_version attribute for
 VFIO live migration
Message-ID: <20200605083149.1809e783@x1.home>
In-Reply-To: <20200605102224.GB2936@work-vm>
References: <20200429072616.GL12879@joy-OptiPlex-7040>
        <20200429082201.GA2834@work-vm>
        <20200429093555.GM12879@joy-OptiPlex-7040>
        <20200429094844.GE2834@work-vm>
        <20200430003949.GN12879@joy-OptiPlex-7040>
        <20200602165527.34137955@x1.home>
        <20200603031948.GB12300@joy-OptiPlex-7040>
        <20200602215528.7a1008f0@x1.home>
        <20200603052443.GC12300@joy-OptiPlex-7040>
        <20200603102628.017e2896@x1.home>
        <20200605102224.GB2936@work-vm>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 5 Jun 2020 11:22:24 +0100
"Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:

> * Alex Williamson (alex.williamson@redhat.com) wrote:
> > On Wed, 3 Jun 2020 01:24:43 -0400
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > On Tue, Jun 02, 2020 at 09:55:28PM -0600, Alex Williamson wrote:  
> > > > On Tue, 2 Jun 2020 23:19:48 -0400
> > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >     
> > > > > On Tue, Jun 02, 2020 at 04:55:27PM -0600, Alex Williamson wrote:    
> > > > > > On Wed, 29 Apr 2020 20:39:50 -0400
> > > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > >       
> > > > > > > On Wed, Apr 29, 2020 at 05:48:44PM +0800, Dr. David Alan Gilbert wrote:
> > > > > > > <snip>      
> > > > > > > > > > > > > > > > > > > > An mdev type is meant to define a software compatible interface, so in
> > > > > > > > > > > > > > > > > > > > the case of mdev->mdev migration, doesn't migrating to a different type
> > > > > > > > > > > > > > > > > > > > fail the most basic of compatibility tests that we expect userspace to
> > > > > > > > > > > > > > > > > > > > perform?  IOW, if two mdev types are migration compatible, it seems a
> > > > > > > > > > > > > > > > > > > > prerequisite to that is that they provide the same software interface,
> > > > > > > > > > > > > > > > > > > > which means they should be the same mdev type.
> > > > > > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > > > > > > In the hybrid cases of mdev->phys or phys->mdev, how does a        
> > > > > > > > > > > > > > > > > > > management        
> > > > > > > > > > > > > > > > > > > > tool begin to even guess what might be compatible?  Are we expecting
> > > > > > > > > > > > > > > > > > > > libvirt to probe ever device with this attribute in the system?  Is
> > > > > > > > > > > > > > > > > > > > there going to be a new class hierarchy created to enumerate all
> > > > > > > > > > > > > > > > > > > > possible migrate-able devices?
> > > > > > > > > > > > > > > > > > > >        
> > > > > > > > > > > > > > > > > > > yes, management tool needs to guess and test migration compatible
> > > > > > > > > > > > > > > > > > > between two devices. But I think it's not the problem only for
> > > > > > > > > > > > > > > > > > > mdev->phys or phys->mdev. even for mdev->mdev, management tool needs
> > > > > > > > > > > > > > > > > > > to
> > > > > > > > > > > > > > > > > > > first assume that the two mdevs have the same type of parent devices
> > > > > > > > > > > > > > > > > > > (e.g.their pciids are equal). otherwise, it's still enumerating
> > > > > > > > > > > > > > > > > > > possibilities.
> > > > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > > > on the other hand, for two mdevs,
> > > > > > > > > > > > > > > > > > > mdev1 from pdev1, its mdev_type is 1/2 of pdev1;
> > > > > > > > > > > > > > > > > > > mdev2 from pdev2, its mdev_type is 1/4 of pdev2;
> > > > > > > > > > > > > > > > > > > if pdev2 is exactly 2 times of pdev1, why not allow migration between
> > > > > > > > > > > > > > > > > > > mdev1 <-> mdev2.        
> > > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > > How could the manage tool figure out that 1/2 of pdev1 is equivalent 
> > > > > > > > > > > > > > > > > > to 1/4 of pdev2? If we really want to allow such thing happen, the best
> > > > > > > > > > > > > > > > > > choice is to report the same mdev type on both pdev1 and pdev2.        
> > > > > > > > > > > > > > > > > I think that's exactly the value of this migration_version interface.
> > > > > > > > > > > > > > > > > the management tool can take advantage of this interface to know if two
> > > > > > > > > > > > > > > > > devices are migration compatible, no matter they are mdevs, non-mdevs,
> > > > > > > > > > > > > > > > > or mix.
> > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > as I know, (please correct me if not right), current libvirt still
> > > > > > > > > > > > > > > > > requires manually generating mdev devices, and it just duplicates src vm
> > > > > > > > > > > > > > > > > configuration to the target vm.
> > > > > > > > > > > > > > > > > for libvirt, currently it's always phys->phys and mdev->mdev (and of the
> > > > > > > > > > > > > > > > > same mdev type).
> > > > > > > > > > > > > > > > > But it does not justify that hybrid cases should not be allowed. otherwise,
> > > > > > > > > > > > > > > > > why do we need to introduce this migration_version interface and leave
> > > > > > > > > > > > > > > > > the judgement of migration compatibility to vendor driver? why not simply
> > > > > > > > > > > > > > > > > set the criteria to something like "pciids of parent devices are equal,
> > > > > > > > > > > > > > > > > and mdev types are equal" ?
> > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > >         
> > > > > > > > > > > > > > > > > > btw mdev<->phys just brings trouble to upper stack as Alex pointed out.         
> > > > > > > > > > > > > > > > > could you help me understand why it will bring trouble to upper stack?
> > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > I think it just needs to read src migration_version under src dev node,
> > > > > > > > > > > > > > > > > and test it in target migration version under target dev node. 
> > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > after all, through this interface we just help the upper layer
> > > > > > > > > > > > > > > > > knowing available options through reading and testing, and they decide
> > > > > > > > > > > > > > > > > to use it or not.
> > > > > > > > > > > > > > > > >         
> > > > > > > > > > > > > > > > > > Can we simplify the requirement by allowing only mdev<->mdev and 
> > > > > > > > > > > > > > > > > > phys<->phys migration? If an customer does want to migrate between a 
> > > > > > > > > > > > > > > > > > mdev and phys, he could wrap physical device into a wrapped mdev 
> > > > > > > > > > > > > > > > > > instance (with the same type as the source mdev) instead of using vendor 
> > > > > > > > > > > > > > > > > > ops. Doing so does add some burden but if mdev<->phys is not dominant 
> > > > > > > > > > > > > > > > > > usage then such tradeoff might be worthywhile...
> > > > > > > > > > > > > > > > > >        
> > > > > > > > > > > > > > > > > If the interfaces for phys<->phys and mdev<->mdev are consistent, it makes no
> > > > > > > > > > > > > > > > > difference to phys<->mdev, right?
> > > > > > > > > > > > > > > > > I think the vendor string for a mdev device is something like:
> > > > > > > > > > > > > > > > > "Parent PCIID + mdev type + software version", and
> > > > > > > > > > > > > > > > > that for a phys device is something like:
> > > > > > > > > > > > > > > > > "PCIID + software version".
> > > > > > > > > > > > > > > > > as long as we don't migrate between devices from different vendors, it's
> > > > > > > > > > > > > > > > > easy for vendor driver to tell if a phys device is migration compatible
> > > > > > > > > > > > > > > > > to a mdev device according it supports it or not.        
> > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > It surprises me that the PCIID matching is a requirement; I'd assumed
> > > > > > > > > > > > > > > > with this clever mdev name setup that you could migrate between two
> > > > > > > > > > > > > > > > different models in a series, or to a newer model, as long as they
> > > > > > > > > > > > > > > > both supported the same mdev view.
> > > > > > > > > > > > > > > >         
> > > > > > > > > > > > > > > hi Dave
> > > > > > > > > > > > > > > the migration_version string is transparent to userspace, and is
> > > > > > > > > > > > > > > completely defined by vendor driver.
> > > > > > > > > > > > > > > I put it there just as an example of how vendor driver may implement it.
> > > > > > > > > > > > > > > e.g.
> > > > > > > > > > > > > > > the src migration_version string is "src PCIID + src software version", 
> > > > > > > > > > > > > > > then when this string is write to target migration_version node,
> > > > > > > > > > > > > > > the vendor driver in the target device will compare it with its own
> > > > > > > > > > > > > > > device info and software version.
> > > > > > > > > > > > > > > If different models are allowed, the write just succeeds even
> > > > > > > > > > > > > > > PCIIDs in src and target are different.
> > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > so, it is the vendor driver to define whether two devices are able to
> > > > > > > > > > > > > > > migrate, no matter their PCIIDs, mdev types, software versions..., which
> > > > > > > > > > > > > > > provides vendor driver full flexibility.
> > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > do you think it's good?        
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > > Yeh that's OK; I guess it's going to need to have a big table in their
> > > > > > > > > > > > > > with all the PCIIDs in.
> > > > > > > > > > > > > > The alternative would be to abstract it a little; e.g. to say it's
> > > > > > > > > > > > > > an Intel-gpu-core-v4  and then it would be less worried about the exact
> > > > > > > > > > > > > > clock speed etc - but yes you might be right htat PCIIDs might be best
> > > > > > > > > > > > > > for checking for quirks.
> > > > > > > > > > > > > >        
> > > > > > > > > > > > > glad that you are agreed with it:)
> > > > > > > > > > > > > I think the vendor driver still can choose a way to abstract a little
> > > > > > > > > > > > > (e.g. Intel-gpu-core-v4...) if they think it's better. In that case, the
> > > > > > > > > > > > > migration_string would be something like "Intel-gpu-core-v4 + instance
> > > > > > > > > > > > > number + software version".
> > > > > > > > > > > > > IOW, they can choose anything they think appropriate to identify migration
> > > > > > > > > > > > > compatibility of a device.
> > > > > > > > > > > > > But Alex is right, we have to prevent namespace overlapping. So I think
> > > > > > > > > > > > > we need to ensure src and target devices are from the same vendors.
> > > > > > > > > > > > > or, any other ideas?        
> > > > > > > > > > > > 
> > > > > > > > > > > > That's why I kept the 'Intel' in that example; or PCI vendor ID; I was        
> > > > > > > > > > > Yes, it's a good idea!
> > > > > > > > > > > could we add a line in the doc saying that
> > > > > > > > > > > it is the vendor driver to add a unique string to avoid namespace
> > > > > > > > > > > collision?        
> > > > > > > > > > 
> > > > > > > > > > So why don't we split the difference; lets say that it should start with
> > > > > > > > > > the hex PCI Vendor ID.
> > > > > > > > > >        
> > > > > > > > > The problem is for mdev devices, if the parent devices are not PCI devices, 
> > > > > > > > > they don't have PCI vendor IDs.        
> > > > > > > > 
> > > > > > > > Hmm it would be best not to invent a whole new way of giving unique
> > > > > > > > idenitifiers for vendors if we can.
> > > > > > > >         
> > > > > > > what about leveraging the flags in vfio device info ?
> > > > > > > 
> > > > > > > #define VFIO_DEVICE_FLAGS_RESET (1 << 0)        /* Device supports reset */
> > > > > > > #define VFIO_DEVICE_FLAGS_PCI   (1 << 1)        /* vfio-pci device */
> > > > > > > #define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)     /* vfio-platform device */
> > > > > > > #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)        /* vfio-amba device */
> > > > > > > #define VFIO_DEVICE_FLAGS_CCW   (1 << 4)        /* vfio-ccw device */
> > > > > > > #define VFIO_DEVICE_FLAGS_AP    (1 << 5)        /* vfio-ap device */
> > > > > > > 
> > > > > > > Then for migration_version string,
> > > > > > > The first 64 bits are for device type, the second 64 bits are for device id.
> > > > > > > e.g.
> > > > > > > for PCI devices, it could be
> > > > > > > VFIO_DEVICE_FLAGS_PCI + PCI ID.
> > > > > > > 
> > > > > > > Currently in the doc, we only define PCI devices to use PCI ID as the second
> > > > > > > 64 bits. In future, if other types of devices want to support migration,
> > > > > > > they can define their own parts of device id. e.g. use ACPI ID as the
> > > > > > > second 64-bit...
> > > > > > > 
> > > > > > > sounds good?      
> > > > > > 
> > > > > > [dead thread resurrection alert]
> > > > > > 
> > > > > > Not really.  We're deep into territory that we were trying to avoid.
> > > > > > We had previously defined the version string as opaque (not
> > > > > > transparent) specifically because we did not want userspace to make
> > > > > > assumptions about compatibility based on the content of the string.  It
> > > > > > was 100% left to the vendor driver to determine compatibility.  The
> > > > > > mdev type was the full extent of the first level filter that userspace
> > > > > > could use to narrow the set of potentially compatible devices.  If we
> > > > > > remove that due to physical device migration support, I'm not sure how
> > > > > > we simplify the problem for userspace.
> > > > > > 
> > > > > > We need to step away from PCI IDs and parent devices.  We're not
> > > > > > designing a solution that only works for PCI, there's no guarantee that
> > > > > > parent devices are similar or even from the same vendor.
> > > > > > 
> > > > > > Does the mdev type sufficiently solve the problem for mdev devices?  If
> > > > > > so, then what can we learn from it and how can we apply an equivalence
> > > > > > to physical devices?  For example, should a vfio bus driver (vfio-pci
> > > > > > or vfio-mdev) expose vfio_migration_type and vfio_migration_version
> > > > > > attributes under the device in sysfs where the _type provides the first
> > > > > > level, user transparent, matching string (ex. mdev type for mdev
> > > > > > devices) while the _version provides the user opaque, vendor known
> > > > > > compatibility test?
> > > > > > 
> > > > > > This pushes the problem out to the drivers where we can perhaps
> > > > > > incorporate the module name to avoid collisions.  For example Yan's
> > > > > > vendor extension proposal makes use of vfio-pci with extension modules
> > > > > > loaded via an alias incorporating the PCI vendor and device ID.  So
> > > > > > vfio-pci might use a type of "vfio-pci:$ALIAS".
> > > > > > 
> > > > > > It's still a bit messy that someone needs to go evaluate all these
> > > > > > types between devices that exist and mdev devices that might exist if
> > > > > > created, but I don't have any good ideas to resolve that (maybe a new
> > > > > > class hierarchy?).  Thanks,      
> > > > > 
> > > > > hi Alex
> > > > > 
> > > > > yes, with the same mdev_type, user still has to enumerate all parent
> > > > > devices and test between the supported mdev_types to know whether two mdev
> > > > > devices are compatible.
> > > > > maybe this is not a problem? in reality, it is the administrator that
> > > > > specifies two devices and the management tool feedbacks compatibility
> > > > > result. management tool is not required to pre-test and setup the
> > > > > compatibility map beforehand.    
> > > > 
> > > > That's exactly the purpose of this interface though is to give the
> > > > management tools some indication that a migration has a chance of
> > > > working.
> > > >      
> > > > > If so, then the only problem left is namespace collision. 
> > > > > given that the migration_version nodes is exported by vendor driver,
> > > > > maybe it can also embed its module name in the migration version string,
> > > > > like "i915" in "i915-GVTg_V5_8", as you suggested above.    
> > > > 
> > > > No, we've already decided that the version string is opaque, the user
> > > > is not to attempt to infer anything from it.  That's why I've suggested
> > > > another attribute in sysfs that does present type information that a
> > > > user can compare.  Thanks,
> > > > 
> > > > Alex
> > > >    
> > > ok. got it.
> > > one more thing I want to confirm is that do you think it's a necessary
> > > restriction that "The mdev devices are of the same type" ?
> > > could mdev and phys devices both expose "vfio_migration_type" and
> > > "vfio_migration_version" under device sysfs so that it may not be
> > > confined in mdev_type? (e.g. when aggregator is enabled, though two
> > > mdevs are of the same mdev_type, they are not actually compatible; and
> > > two mdevs are compatible though their mdev_type is not equal.) 
> > > 
> > > for mdev devices, we could still expose vfio_migration_version
> > > attribute under mdev_type for detection before mdev generated.  
> > 
> > I tried to simplify the problem a bit, but we keep going backwards.  If
> > the requirement is that potentially any source device can migrate to any
> > target device and we cannot provide any means other than writing an
> > opaque source string into a version attribute on the target and
> > evaluating the result to determine compatibility, then we're requiring
> > userspace to do an exhaustive search to find a potential match.  That
> > sucks.   
> 
> Why is the mechanism a 'write and test' why isn't it a 'write and ask'?
> i.e. the destination tells the driver what type it's received from the
> source, and the driver replies with a set of compatible configurations
> (in some preferred order).

A 'write and ask' interface would imply some sort of session in order
to not be racy with concurrent users.  More likely this would imply an
ioctl interface, which I don't think we have in sysfs.  Where do we
host this ioctl?

> It's also not clear to me why the name has to be that opaque;
> I agree it's only got to be understood by the driver but that doesn't
> seem to be a reason for the driver to make it purposely obfuscated.
> I wouldn't expect a user to be able to parse it necessarily; but would
> expect something that would be useful for an error message.

If the name is not opaque, then we're going to rat hole on the format
and the fields and evolving that format for every feature a vendor
decides they want the user to be able to parse out of the version
string.  Then we require a full specification of the string in order
that it be parsed according to a standard such that we don't break
users inferring features in subtly different ways.

This is a lot like the problems with mdev description attributes,
libvirt complains they can't use description because there's no
standard formatting, but even with two vendors describing the same class
of device we don't have an agreed set of things to expose in the
description attribute.  Thanks,

Alex

