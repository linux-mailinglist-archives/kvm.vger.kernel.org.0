Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6561F249845
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 10:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgHSIby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 04:31:54 -0400
Received: from mga05.intel.com ([192.55.52.43]:29695 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbgHSIbw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 04:31:52 -0400
IronPort-SDR: rwxx89IJkhwdMT9hBD1x7R/f2MczJRXzhmmcNol8goMHuD+10vIwleryLFsiBBQQmCH5gyJKN/
 VCeasmvseHgA==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="239901285"
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="239901285"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 01:31:52 -0700
IronPort-SDR: P8GhNJa0pybFsVFQeXBZ6VfyAfT5bR3D7EMcPE0izClM8QfXnJdSbMVU00yMqLcYFboM63w4EJ
 v51ElA0fF7ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="327017546"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga008.jf.intel.com with ESMTP; 19 Aug 2020 01:31:45 -0700
Date:   Wed, 19 Aug 2020 16:13:39 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
        Parav Pandit <parav@nvidia.com>,
        "sm ooney@redhat.com" <smooney@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "devel@ovirt.org" <devel@ovirt.org>
Subject: Re: [ovirt-devel] Re: device compatibility interface for live
 migration with assigned devices
Message-ID: <20200819081338.GC21172@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
 <20200818085527.GB20215@redhat.com>
 <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
 <20200818091628.GC20215@redhat.com>
 <20200818113652.5d81a392.cohuck@redhat.com>
 <BY5PR12MB4322C9D1A66C4657776A1383DC5C0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200819033035.GA21172@joy-OptiPlex-7040>
 <e20812b7-994b-b7f9-2df4-a78c4d116c7f@redhat.com>
 <20200819065951.GB21172@joy-OptiPlex-7040>
 <d6f9a51e-80b3-44c5-2656-614b327dc080@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6f9a51e-80b3-44c5-2656-614b327dc080@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 19, 2020 at 03:39:50PM +0800, Jason Wang wrote:
> 
> On 2020/8/19 下午2:59, Yan Zhao wrote:
> > On Wed, Aug 19, 2020 at 02:57:34PM +0800, Jason Wang wrote:
> > > On 2020/8/19 上午11:30, Yan Zhao wrote:
> > > > hi All,
> > > > could we decide that sysfs is the interface that every VFIO vendor driver
> > > > needs to provide in order to support vfio live migration, otherwise the
> > > > userspace management tool would not list the device into the compatible
> > > > list?
> > > > 
> > > > if that's true, let's move to the standardizing of the sysfs interface.
> > > > (1) content
> > > > common part: (must)
> > > >      - software_version: (in major.minor.bugfix scheme)
> > > 
> > > This can not work for devices whose features can be negotiated/advertised
> > > independently. (E.g virtio devices)
> > > 
> > sorry, I don't understand here, why virtio devices need to use vfio interface?
> 
> 
> I don't see any reason that virtio devices can't be used by VFIO. Do you?
> 
> Actually, virtio devices have been used by VFIO for many years:
> 
> - passthrough a hardware virtio devices to userspace(VM) drivers
> - using virtio PMD inside guest
>
So, what's different for it vs passing through a physical hardware via VFIO?
even though the features are negotiated dynamically, could you explain
why it would cause software_version not work?


> 
> > I think this thread is discussing about vfio related devices.
> > 
> > > >      - device_api: vfio-pci or vfio-ccw ...
> > > >      - type: mdev type for mdev device or
> > > >              a signature for physical device which is a counterpart for
> > > > 	   mdev type.
> > > > 
> > > > device api specific part: (must)
> > > >     - pci id: pci id of mdev parent device or pci id of physical pci
> > > >       device (device_api is vfio-pci)API here.
> > > 
> > > So this assumes a PCI device which is probably not true.
> > > 
> > for device_api of vfio-pci, why it's not true?
> > 
> > for vfio-ccw, it's subchannel_type.
> 
> 
> Ok but having two different attributes for the same file is not good idea.
> How mgmt know there will be a 3rd type?
that's why some attributes need to be common. e.g.
device_api: it's common because mgmt need to know it's a pci device or a
            ccw device. and the api type is already defined vfio.h.
	    (The field is agreed by and actually suggested by Alex in previous mail)
type: mdev_type for mdev. if mgmt does not understand it, it would not
      be able to create one compatible mdev device.
software_version: mgmt can compare the major and minor if it understands
      this fields.
> 
> 
> > 
> > > >     - subchannel_type (device_api is vfio-ccw)
> > > > vendor driver specific part: (optional)
> > > >     - aggregator
> > > >     - chpid_type
> > > >     - remote_url
> > > 
> > > For "remote_url", just wonder if it's better to integrate or reuse the
> > > existing NVME management interface instead of duplicating it here. Otherwise
> > > it could be a burden for mgmt to learn. E.g vendor A may use "remote_url"
> > > but vendor B may use a different attribute.
> > > 
> > it's vendor driver specific.
> > vendor specific attributes are inevitable, and that's why we are
> > discussing here of a way to standardizing of it.
> 
> 
> Well, then you will end up with a very long list to discuss. E.g for
> networking devices, you will have "mac", "v(x)lan" and a lot of other.
> 
> Note that "remote_url" is not vendor specific but NVME (class/subsystem)
> specific.
> 
yes, it's just NVMe specific. I added it as an example to show what is
vendor specific.
if one attribute is vendor specific across all vendors, then it's not vendor specific,
it's already common attribute, right?

> The point is that if vendor/class specific part is unavoidable, why not
> making all of the attributes vendor specific?
>
some parts need to be common, as I listed above.

> 
> > our goal is that mgmt can use it without understanding the meaning of vendor
> > specific attributes.
> 
> 
> I'm not sure this is the correct design of uAPI. Is there something similar
> in the existing uAPIs?
> 
> And it might be hard to work for virtio devices.
> 
> 
> > 
> > > > NOTE: vendors are free to add attributes in this part with a
> > > > restriction that this attribute is able to be configured with the same
> > > > name in sysfs too. e.g.
> > > 
> > > Sysfs works well for common attributes belongs to a class, but I'm not sure
> > > it can work well for device/vendor specific attributes. Does this mean mgmt
> > > need to iterate all the attributes in both src and dst?
> > > 
> > no. just attributes under migration directory.
> > 
> > > > for aggregator, there must be a sysfs attribute in device node
> > > > /sys/devices/pci0000:00/0000:00:02.0/882cc4da-dede-11e7-9180-078a62063ab1/intel_vgpu/aggregator,
> > > > so that the userspace tool is able to configure the target device
> > > > according to source device's aggregator attribute.
> > > > 
> > > > 
> > > > (2) where and structure
> > > > proposal 1:
> > > > |- [path to device]
> > > >     |--- migration
> > > >     |     |--- self
> > > >     |     |    |-software_version
> > > >     |     |    |-device_api
> > > >     |     |    |-type
> > > >     |     |    |-[pci_id or subchannel_type]
> > > >     |     |    |-<aggregator or chpid_type>
> > > >     |     |--- compatible
> > > >     |     |    |-software_version
> > > >     |     |    |-device_api
> > > >     |     |    |-type
> > > >     |     |    |-[pci_id or subchannel_type]
> > > >     |     |    |-<aggregator or chpid_type>
> > > > multiple compatible is allowed.
> > > > attributes should be ASCII text files, preferably with only one value
> > > > per file.
> > > > 
> > > > 
> > > > proposal 2: use bin_attribute.
> > > > |- [path to device]
> > > >     |--- migration
> > > >     |     |--- self
> > > >     |     |--- compatible
> > > > 
> > > > so we can continue use multiline format. e.g.
> > > > cat compatible
> > > >     software_version=0.1.0
> > > >     device_api=vfio_pci
> > > >     type=i915-GVTg_V5_{val1:int:1,2,4,8}
> > > >     pci_id=80865963
> > > >     aggregator={val1}/2
> > > 
> > > So basically two questions:
> > > 
> > > - how hard to standardize sysfs API for dealing with compatibility check (to
> > > make it work for most types of devices)
> > sorry, I just know we are in the process of standardizing of it :)
> 
> 
> It's not easy. As I said, the current design can't work for virtio devices
> and it's not hard to find other examples. I remember some Intel devices have
> bitmask based capability registers.
> 
some Intel devices have bitmask based capability registers.
so what?
we have defined pci_id to identify the devices.
even two different devices have equal PCI IDs, we still allow them to
add vendor specific fields. e.g.
for QAT, they can add alg_set to identify hardware supported algorithms.

> 
> > 
> > > - how hard for the mgmt to learn with a vendor specific attributes (vs
> > > existing management API)
> > what is existing management API?
> 
> 
> It depends on the type of devices. E.g for NVME, we've already had one
> (/sys/kernel/config/nvme)?
>
if the device is binding to vfio or vfio-mdev, I believe this interface
is not there.


Thanks
Yan
