Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4A91F4A6C
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 02:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgFJArk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 20:47:40 -0400
Received: from mga05.intel.com ([192.55.52.43]:30853 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgFJArh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 20:47:37 -0400
IronPort-SDR: qe3auWUc1RH0C0N8i4xQ0zF9HwseXneRt97DpO14F05zgxcKr4DvY1uqV5+6OYO+xOvfctU0yk
 yF50M750JVVQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 17:47:37 -0700
IronPort-SDR: QHcPfuhEyFKZBZGjv+AHLb7yD2CX3AfJvttvnBGdLUuD6msGHxR475WDT/GQscKUbvJDThKhXl
 p/p9QbJDCm7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,494,1583222400"; 
   d="scan'208";a="349688773"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga001.jf.intel.com with ESMTP; 09 Jun 2020 17:47:29 -0700
Date:   Tue, 9 Jun 2020 20:37:31 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
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
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "Zeng, Xin" <xin.zeng@intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
Subject: Re: [PATCH v5 0/4] introduction of migration_version attribute for
 VFIO live migration
Message-ID: <20200610003731.GA13961@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200429094844.GE2834@work-vm>
 <20200430003949.GN12879@joy-OptiPlex-7040>
 <20200602165527.34137955@x1.home>
 <20200603031948.GB12300@joy-OptiPlex-7040>
 <20200602215528.7a1008f0@x1.home>
 <20200603052443.GC12300@joy-OptiPlex-7040>
 <20200603102628.017e2896@x1.home>
 <20200605102224.GB2936@work-vm>
 <20200605083149.1809e783@x1.home>
 <20200605143950.GG2897@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605143950.GG2897@work-vm>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 05, 2020 at 03:39:50PM +0100, Dr. David Alan Gilbert wrote:
> > > > I tried to simplify the problem a bit, but we keep going backwards.  If
> > > > the requirement is that potentially any source device can migrate to any
> > > > target device and we cannot provide any means other than writing an
> > > > opaque source string into a version attribute on the target and
> > > > evaluating the result to determine compatibility, then we're requiring
> > > > userspace to do an exhaustive search to find a potential match.  That
> > > > sucks.   
> > >
hi Alex and Dave,
do you think it's good for us to put aside physical devices and mdev aggregation
for the moment, and use Alex's original idea that

+  Userspace should regard two mdev devices compatible when ALL of below
+  conditions are met:
+  (0) The mdev devices are of the same type
+  (1) success when reading from migration_version attribute of one mdev device.
+  (2) success when writing migration_version string of one mdev device to
+  migration_version attribute of the other mdev device.

and what about adding another sysfs attribute for vendors to put
recommended migration compatible device type. e.g.
#cat /sys/bus/pci/devices/0000:00:02.0/mdev_supported_types/i915-GVTg_V5_8/migration_compatible_devices
parent id: 8086 591d
mdev_type: i915-GVTg_V5_8

vendors are free to define the format and conent of this migration_compatible_devices
and it's even not to be a full list.

before libvirt or user to do live migration, they have to read and test
migration_version attributes of src/target devices to check migration compatibility.

Thanks
Yan


> > > Why is the mechanism a 'write and test' why isn't it a 'write and ask'?
> > > i.e. the destination tells the driver what type it's received from the
> > > source, and the driver replies with a set of compatible configurations
> > > (in some preferred order).
> > 
> > A 'write and ask' interface would imply some sort of session in order
> > to not be racy with concurrent users.  More likely this would imply an
> > ioctl interface, which I don't think we have in sysfs.  Where do we
> > host this ioctl?
> 
> Or one fd?
>   f=open()
>   write(f, "The ID I want")
>   do {
>      read(f, ...)  -> The IDs we're offering that are compatible
>   } while (!eof)
> 
> > > It's also not clear to me why the name has to be that opaque;
> > > I agree it's only got to be understood by the driver but that doesn't
> > > seem to be a reason for the driver to make it purposely obfuscated.
> > > I wouldn't expect a user to be able to parse it necessarily; but would
> > > expect something that would be useful for an error message.
> > 
> > If the name is not opaque, then we're going to rat hole on the format
> > and the fields and evolving that format for every feature a vendor
> > decides they want the user to be able to parse out of the version
> > string.  Then we require a full specification of the string in order
> > that it be parsed according to a standard such that we don't break
> > users inferring features in subtly different ways.
> > 
> > This is a lot like the problems with mdev description attributes,
> > libvirt complains they can't use description because there's no
> > standard formatting, but even with two vendors describing the same class
> > of device we don't have an agreed set of things to expose in the
> > description attribute.  Thanks,
> 
> I'm not suggesting anything in anyway machine parsable; just something
> human readable that you can present in a menu/choice/configuration/error
> message.  The text would be down to the vendor, and I'd suggest it start
> with the vendor name just as a disambiguator and to make it obvious when
> we get it grossly wrong.
> 
> Dave
> 
> > Alex
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
> _______________________________________________
> intel-gvt-dev mailing list
> intel-gvt-dev@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gvt-dev
