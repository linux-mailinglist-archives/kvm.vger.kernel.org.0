Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D602E2493A1
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 05:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgHSDsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 23:48:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:4059 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgHSDsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 23:48:19 -0400
IronPort-SDR: jQ5X9MU4sMDTfHUs9WryZ4mG3iwK92acDt/foSQMLqoWXXPUUFoh4/vLLYbkTofYIVFB1syxKt
 ba5e5gPBtCTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="155010939"
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="155010939"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 20:48:18 -0700
IronPort-SDR: gW+H1ML9Tmx47WL96J93dFo0ciNYOhkpFuZAl4nqL2XtlJ8DRNolmJwbwuEc4rcpbF72lKn+om
 M9Zzu2iLeBFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="326943564"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga008.jf.intel.com with ESMTP; 18 Aug 2020 20:48:12 -0700
Date:   Wed, 19 Aug 2020 11:30:35 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
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
        Alex Williamson <alex.williamson@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "smooney@redhat.com" <smooney@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "devel@ovirt.org" <devel@ovirt.org>
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200819033035.GA21172@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200805105319.GF2177@nanopsycho>
 <20200810074631.GA29059@joy-OptiPlex-7040>
 <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
 <20200814051601.GD15344@joy-OptiPlex-7040>
 <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
 <20200818085527.GB20215@redhat.com>
 <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
 <20200818091628.GC20215@redhat.com>
 <20200818113652.5d81a392.cohuck@redhat.com>
 <BY5PR12MB4322C9D1A66C4657776A1383DC5C0@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BY5PR12MB4322C9D1A66C4657776A1383DC5C0@BY5PR12MB4322.namprd12.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 09:39:24AM +0000, Parav Pandit wrote:
> Hi Cornelia,
> 
> > From: Cornelia Huck <cohuck@redhat.com>
> > Sent: Tuesday, August 18, 2020 3:07 PM
> > To: Daniel P. Berrangé <berrange@redhat.com>
> > Cc: Jason Wang <jasowang@redhat.com>; Yan Zhao
> > <yan.y.zhao@intel.com>; kvm@vger.kernel.org; libvir-list@redhat.com;
> > qemu-devel@nongnu.org; Kirti Wankhede <kwankhede@nvidia.com>;
> > eauger@redhat.com; xin-ran.wang@intel.com; corbet@lwn.net; openstack-
> > discuss@lists.openstack.org; shaohe.feng@intel.com; kevin.tian@intel.com;
> > Parav Pandit <parav@mellanox.com>; jian-feng.ding@intel.com;
> > dgilbert@redhat.com; zhenyuw@linux.intel.com; hejie.xu@intel.com;
> > bao.yumeng@zte.com.cn; Alex Williamson <alex.williamson@redhat.com>;
> > eskultet@redhat.com; smooney@redhat.com; intel-gvt-
> > dev@lists.freedesktop.org; Jiri Pirko <jiri@mellanox.com>;
> > dinechin@redhat.com; devel@ovirt.org
> > Subject: Re: device compatibility interface for live migration with assigned
> > devices
> > 
> > On Tue, 18 Aug 2020 10:16:28 +0100
> > Daniel P. Berrangé <berrange@redhat.com> wrote:
> > 
> > > On Tue, Aug 18, 2020 at 05:01:51PM +0800, Jason Wang wrote:
> > > >    On 2020/8/18 下午4:55, Daniel P. Berrangé wrote:
> > > >
> > > >  On Tue, Aug 18, 2020 at 11:24:30AM +0800, Jason Wang wrote:
> > > >
> > > >  On 2020/8/14 下午1:16, Yan Zhao wrote:
> > > >
> > > >  On Thu, Aug 13, 2020 at 12:24:50PM +0800, Jason Wang wrote:
> > > >
> > > >  On 2020/8/10 下午3:46, Yan Zhao wrote:
> > >
> > > >  we actually can also retrieve the same information through sysfs,
> > > > .e.g
> > > >
> > > >  |- [path to device]
> > > >     |--- migration
> > > >     |     |--- self
> > > >     |     |   |---device_api
> > > >     |    |   |---mdev_type
> > > >     |    |   |---software_version
> > > >     |    |   |---device_id
> > > >     |    |   |---aggregator
> > > >     |     |--- compatible
> > > >     |     |   |---device_api
> > > >     |    |   |---mdev_type
> > > >     |    |   |---software_version
> > > >     |    |   |---device_id
> > > >     |    |   |---aggregator
> > > >
> > > >
> > > >  Yes but:
> > > >
> > > >  - You need one file per attribute (one syscall for one attribute)
> > > >  - Attribute is coupled with kobject
> > 
> > Is that really that bad? You have the device with an embedded kobject
> > anyway, and you can just put things into an attribute group?
> > 
> > [Also, I think that self/compatible split in the example makes things
> > needlessly complex. Shouldn't semantic versioning and matching already
> > cover nearly everything? I would expect very few cases that are more
> > complex than that. Maybe the aggregation stuff, but I don't think we need
> > that self/compatible split for that, either.]
> > 
> > > >
> > > >  All of above seems unnecessary.
> > > >
> > > >  Another point, as we discussed in another thread, it's really hard
> > > > to make  sure the above API work for all types of devices and
> > > > frameworks. So having a  vendor specific API looks much better.
> > > >
> > > >  From the POV of userspace mgmt apps doing device compat checking /
> > > > migration,  we certainly do NOT want to use different vendor
> > > > specific APIs. We want to  have an API that can be used / controlled in a
> > standard manner across vendors.
> > > >
> > > >    Yes, but it could be hard. E.g vDPA will chose to use devlink (there's a
> > > >    long debate on sysfs vs devlink). So if we go with sysfs, at least two
> > > >    APIs needs to be supported ...
> > >
> > > NB, I was not questioning devlink vs sysfs directly. If devlink is
> > > related to netlink, I can't say I'm enthusiastic as IMKE sysfs is
> > > easier to deal with. I don't know enough about devlink to have much of an
> > opinion though.
> > > The key point was that I don't want the userspace APIs we need to deal
> > > with to be vendor specific.
> > 
> > From what I've seen of devlink, it seems quite nice; but I understand why
> > sysfs might be easier to deal with (especially as there's likely already a lot of
> > code using it.)
> > 
> > I understand that some users would like devlink because it is already widely
> > used for network drivers (and some others), but I don't think the majority of
> > devices used with vfio are network (although certainly a lot of them are.)
> > 
> > >
> > > What I care about is that we have a *standard* userspace API for
> > > performing device compatibility checking / state migration, for use by
> > > QEMU/libvirt/ OpenStack, such that we can write code without countless
> > > vendor specific code paths.
> > >
> > > If there is vendor specific stuff on the side, that's fine as we can
> > > ignore that, but the core functionality for device compat / migration
> > > needs to be standardized.
> > 
> > To summarize:
> > - choose one of sysfs or devlink
> > - have a common interface, with a standardized way to add
> >   vendor-specific attributes
> > ?
> 
> Please refer to my previous email which has more example and details.
hi Parav,
the example is based on a new vdpa tool running over netlink, not based
on devlink, right?
For vfio migration compatibility, we have to deal with both mdev and physical
pci devices, I don't think it's a good idea to write a new tool for it, given
we are able to retrieve the same info from sysfs and there's already an
mdevctl from Alex (https://github.com/mdevctl/mdevctl).

hi All,
could we decide that sysfs is the interface that every VFIO vendor driver
needs to provide in order to support vfio live migration, otherwise the
userspace management tool would not list the device into the compatible
list?

if that's true, let's move to the standardizing of the sysfs interface.
(1) content
common part: (must)
   - software_version: (in major.minor.bugfix scheme)
   - device_api: vfio-pci or vfio-ccw ...
   - type: mdev type for mdev device or
           a signature for physical device which is a counterpart for
	   mdev type.

device api specific part: (must)
  - pci id: pci id of mdev parent device or pci id of physical pci
    device (device_api is vfio-pci)
  - subchannel_type (device_api is vfio-ccw) 
 
vendor driver specific part: (optional)
  - aggregator
  - chpid_type
  - remote_url

NOTE: vendors are free to add attributes in this part with a
restriction that this attribute is able to be configured with the same
name in sysfs too. e.g.
for aggregator, there must be a sysfs attribute in device node
/sys/devices/pci0000:00/0000:00:02.0/882cc4da-dede-11e7-9180-078a62063ab1/intel_vgpu/aggregator,
so that the userspace tool is able to configure the target device
according to source device's aggregator attribute.


(2) where and structure
proposal 1:
|- [path to device]
  |--- migration
  |     |--- self
  |     |    |-software_version
  |     |    |-device_api
  |     |    |-type
  |     |    |-[pci_id or subchannel_type]
  |     |    |-<aggregator or chpid_type>
  |     |--- compatible
  |     |    |-software_version
  |     |    |-device_api
  |     |    |-type
  |     |    |-[pci_id or subchannel_type]
  |     |    |-<aggregator or chpid_type>
multiple compatible is allowed.
attributes should be ASCII text files, preferably with only one value
per file.


proposal 2: use bin_attribute.
|- [path to device]
  |--- migration
  |     |--- self
  |     |--- compatible

so we can continue use multiline format. e.g.
cat compatible
  software_version=0.1.0
  device_api=vfio_pci
  type=i915-GVTg_V5_{val1:int:1,2,4,8}
  pci_id=80865963
  aggregator={val1}/2

Thanks
Yan
