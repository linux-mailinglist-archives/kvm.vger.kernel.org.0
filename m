Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37C82496DD
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 09:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHSHOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 03:14:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:21269 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726570AbgHSHOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 03:14:35 -0400
IronPort-SDR: zKM8CocMBkV5F4Gh4T6STG8QYBStDurDTZ80LoTnRb5i88YPbFCHUIBzFkuQGW2nT8QOdxgwHt
 2OMbWFX0p64Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="239893512"
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="239893512"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 00:14:35 -0700
IronPort-SDR: PAPOtQiS5AEH7w6GZmZ28FX+s6MpshHF1iZBNLdKvJlaDZP02BUDim8JqOPED1R5xUX76DUNVG
 +AppG9uv2lOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="326998478"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga008.jf.intel.com with ESMTP; 19 Aug 2020 00:14:28 -0700
Date:   Wed, 19 Aug 2020 14:59:51 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>, Cornelia Huck <cohuck@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
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
        "sm ooney@redhat.com" <smooney@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "devel@ovirt.org" <devel@ovirt.org>
Subject: Re: [ovirt-devel] Re: device compatibility interface for live
 migration with assigned devices
Message-ID: <20200819065951.GB21172@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
 <20200814051601.GD15344@joy-OptiPlex-7040>
 <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
 <20200818085527.GB20215@redhat.com>
 <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
 <20200818091628.GC20215@redhat.com>
 <20200818113652.5d81a392.cohuck@redhat.com>
 <BY5PR12MB4322C9D1A66C4657776A1383DC5C0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200819033035.GA21172@joy-OptiPlex-7040>
 <e20812b7-994b-b7f9-2df4-a78c4d116c7f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e20812b7-994b-b7f9-2df4-a78c4d116c7f@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 19, 2020 at 02:57:34PM +0800, Jason Wang wrote:
> 
> On 2020/8/19 上午11:30, Yan Zhao wrote:
> > hi All,
> > could we decide that sysfs is the interface that every VFIO vendor driver
> > needs to provide in order to support vfio live migration, otherwise the
> > userspace management tool would not list the device into the compatible
> > list?
> > 
> > if that's true, let's move to the standardizing of the sysfs interface.
> > (1) content
> > common part: (must)
> >     - software_version: (in major.minor.bugfix scheme)
> 
> 
> This can not work for devices whose features can be negotiated/advertised
> independently. (E.g virtio devices)
>
sorry, I don't understand here, why virtio devices need to use vfio interface?
I think this thread is discussing about vfio related devices.

> 
> >     - device_api: vfio-pci or vfio-ccw ...
> >     - type: mdev type for mdev device or
> >             a signature for physical device which is a counterpart for
> > 	   mdev type.
> > 
> > device api specific part: (must)
> >    - pci id: pci id of mdev parent device or pci id of physical pci
> >      device (device_api is vfio-pci)API here.
> 
> 
> So this assumes a PCI device which is probably not true.
> 
for device_api of vfio-pci, why it's not true?

for vfio-ccw, it's subchannel_type.

> 
> >    - subchannel_type (device_api is vfio-ccw)
> > vendor driver specific part: (optional)
> >    - aggregator
> >    - chpid_type
> >    - remote_url
> 
> 
> For "remote_url", just wonder if it's better to integrate or reuse the
> existing NVME management interface instead of duplicating it here. Otherwise
> it could be a burden for mgmt to learn. E.g vendor A may use "remote_url"
> but vendor B may use a different attribute.
> 
it's vendor driver specific.
vendor specific attributes are inevitable, and that's why we are
discussing here of a way to standardizing of it.
our goal is that mgmt can use it without understanding the meaning of vendor
specific attributes.

> 
> > 
> > NOTE: vendors are free to add attributes in this part with a
> > restriction that this attribute is able to be configured with the same
> > name in sysfs too. e.g.
> 
> 
> Sysfs works well for common attributes belongs to a class, but I'm not sure
> it can work well for device/vendor specific attributes. Does this mean mgmt
> need to iterate all the attributes in both src and dst?
>
no. just attributes under migration directory.

> 
> > for aggregator, there must be a sysfs attribute in device node
> > /sys/devices/pci0000:00/0000:00:02.0/882cc4da-dede-11e7-9180-078a62063ab1/intel_vgpu/aggregator,
> > so that the userspace tool is able to configure the target device
> > according to source device's aggregator attribute.
> > 
> > 
> > (2) where and structure
> > proposal 1:
> > |- [path to device]
> >    |--- migration
> >    |     |--- self
> >    |     |    |-software_version
> >    |     |    |-device_api
> >    |     |    |-type
> >    |     |    |-[pci_id or subchannel_type]
> >    |     |    |-<aggregator or chpid_type>
> >    |     |--- compatible
> >    |     |    |-software_version
> >    |     |    |-device_api
> >    |     |    |-type
> >    |     |    |-[pci_id or subchannel_type]
> >    |     |    |-<aggregator or chpid_type>
> > multiple compatible is allowed.
> > attributes should be ASCII text files, preferably with only one value
> > per file.
> > 
> > 
> > proposal 2: use bin_attribute.
> > |- [path to device]
> >    |--- migration
> >    |     |--- self
> >    |     |--- compatible
> > 
> > so we can continue use multiline format. e.g.
> > cat compatible
> >    software_version=0.1.0
> >    device_api=vfio_pci
> >    type=i915-GVTg_V5_{val1:int:1,2,4,8}
> >    pci_id=80865963
> >    aggregator={val1}/2
> 
> 
> So basically two questions:
> 
> - how hard to standardize sysfs API for dealing with compatibility check (to
> make it work for most types of devices)
sorry, I just know we are in the process of standardizing of it :)

> - how hard for the mgmt to learn with a vendor specific attributes (vs
> existing management API)
what is existing management API?

Thanks
