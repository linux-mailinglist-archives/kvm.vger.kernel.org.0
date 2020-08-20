Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDDB24AD48
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 05:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgHTD1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 23:27:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:61585 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgHTD1f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 23:27:35 -0400
IronPort-SDR: 5mq1DOsrYI9pbHQ2qRw3HxzBjRV8t2VM2vmmh5q/ufj+FnTXRdD8rcSx1UNn4dzyFznJYu2j+H
 5Q+Nlz5dexog==
X-IronPort-AV: E=McAfee;i="6000,8403,9718"; a="154497239"
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="154497239"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 20:27:35 -0700
IronPort-SDR: UqP0IOWieCFyHRnd1vZQD2aXoRbEIKc+/gr6oUyySSR3mhwyApXJ6ijvH5c/4s3hX8nJNnHCRQ
 2wmgSpyXPOOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="327281681"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga008.jf.intel.com with ESMTP; 19 Aug 2020 20:27:28 -0700
Date:   Thu, 20 Aug 2020 11:09:51 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>, Cornelia Huck <cohuck@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "xin-ran.wang@intel.com" <xin-ran.wang@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "openstack-discuss@lists.openstack.org" 
        <openstack-discuss@lists.openstack.org>,
        "shaohe.feng@intel.com" <shaohe.feng@intel.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "jian-feng.ding@intel.com" <jian-feng.ding@intel.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "hejie.xu@intel.com" <hejie.xu@intel.com>,
        "bao.yumeng@zte.com.cn" <bao.yumeng@zte.com.cn>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "smooney@redhat.com" <smooney@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "devel@ovirt.org" <devel@ovirt.org>
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200820030951.GA24121@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
 <20200818085527.GB20215@redhat.com>
 <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
 <20200818091628.GC20215@redhat.com>
 <20200818113652.5d81a392.cohuck@redhat.com>
 <BY5PR12MB4322C9D1A66C4657776A1383DC5C0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200819033035.GA21172@joy-OptiPlex-7040>
 <20200819115021.004427a3@x1.home>
 <20200820001810.GD21172@joy-OptiPlex-7040>
 <20200819211345.0d9daf03@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819211345.0d9daf03@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 19, 2020 at 09:13:45PM -0600, Alex Williamson wrote:
> On Thu, 20 Aug 2020 08:18:10 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Wed, Aug 19, 2020 at 11:50:21AM -0600, Alex Williamson wrote:
> > <...>
> > > > > > > What I care about is that we have a *standard* userspace API for
> > > > > > > performing device compatibility checking / state migration, for use by
> > > > > > > QEMU/libvirt/ OpenStack, such that we can write code without countless
> > > > > > > vendor specific code paths.
> > > > > > >
> > > > > > > If there is vendor specific stuff on the side, that's fine as we can
> > > > > > > ignore that, but the core functionality for device compat / migration
> > > > > > > needs to be standardized.    
> > > > > > 
> > > > > > To summarize:
> > > > > > - choose one of sysfs or devlink
> > > > > > - have a common interface, with a standardized way to add
> > > > > >   vendor-specific attributes
> > > > > > ?    
> > > > > 
> > > > > Please refer to my previous email which has more example and details.    
> > > > hi Parav,
> > > > the example is based on a new vdpa tool running over netlink, not based
> > > > on devlink, right?
> > > > For vfio migration compatibility, we have to deal with both mdev and physical
> > > > pci devices, I don't think it's a good idea to write a new tool for it, given
> > > > we are able to retrieve the same info from sysfs and there's already an
> > > > mdevctl from Alex (https://github.com/mdevctl/mdevctl).
> > > > 
> > > > hi All,
> > > > could we decide that sysfs is the interface that every VFIO vendor driver
> > > > needs to provide in order to support vfio live migration, otherwise the
> > > > userspace management tool would not list the device into the compatible
> > > > list?
> > > > 
> > > > if that's true, let's move to the standardizing of the sysfs interface.
> > > > (1) content
> > > > common part: (must)
> > > >    - software_version: (in major.minor.bugfix scheme)
> > > >    - device_api: vfio-pci or vfio-ccw ...
> > > >    - type: mdev type for mdev device or
> > > >            a signature for physical device which is a counterpart for
> > > > 	   mdev type.
> > > > 
> > > > device api specific part: (must)
> > > >   - pci id: pci id of mdev parent device or pci id of physical pci
> > > >     device (device_api is vfio-pci)  
> > > 
> > > As noted previously, the parent PCI ID should not matter for an mdev
> > > device, if a vendor has a dependency on matching the parent device PCI
> > > ID, that's a vendor specific restriction.  An mdev device can also
> > > expose a vfio-pci device API without the parent device being PCI.  For
> > > a physical PCI device, shouldn't the PCI ID be encompassed in the
> > > signature?  Thanks,
> > >   
> > you are right. I need to put the PCI ID as a vendor specific field.
> > I didn't do that because I wanted all fields in vendor specific to be
> > configurable by management tools, so they can configure the target device
> > according to the value of a vendor specific field even they don't know
> > the meaning of the field.
> > But maybe they can just ignore the field when they can't find a matching
> > writable field to configure the target.
> 
> 
> If fields can be ignored, what's the point of reporting them?  Seems
> it's no longer a requirement.  Thanks,
> 
sorry about the confusion. I mean this condition:
about to migrate, openstack searches if there are existing matching
MDEVs,
if yes, i.e. all common/vendor specific fields match, then just create
a VM with the matching target MDEV. (in this condition, the PCI ID field
is not ignored);
if not, openstack tries to create one MDEV according to mdev_type, and
configures MDEV according to the vendor specific attributes.
as PCI ID is not a configurable field, it just ignore the field.

Thanks
Yan

 
 
