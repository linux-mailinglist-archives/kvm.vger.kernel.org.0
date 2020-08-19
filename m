Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0360B2495C5
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 08:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgHSG6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 02:58:20 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22285 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728059AbgHSG57 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Aug 2020 02:57:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597820278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Lte0Le0tQOTwg3GCjf5K9DLhD9D0DGvYXpctcNdHNE=;
        b=TkDKJBCYyFimIppWKNm0eM0X0pe1gZhEV6lkM7LEkMQbfKu41pj1PBWQyDNx78auuA5Dzl
        AcvmXBARRRGMhkkg8UoBlMJZ56ZWttF+u9tqoDYSHZDdtbPeRMC+GeAwM/yYnqXLzrb5Jn
        nIIVPEACn19uuu3L1NlmcgXiYdfHjK0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-Yqk9eoRWOLuTkaN8dzj4QQ-1; Wed, 19 Aug 2020 02:57:56 -0400
X-MC-Unique: Yqk9eoRWOLuTkaN8dzj4QQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2628781F021;
        Wed, 19 Aug 2020 06:57:54 +0000 (UTC)
Received: from [10.72.13.88] (ovpn-13-88.pek2.redhat.com [10.72.13.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3447767CE8;
        Wed, 19 Aug 2020 06:57:35 +0000 (UTC)
Subject: Re: [ovirt-devel] Re: device compatibility interface for live
 migration with assigned devices
To:     Yan Zhao <yan.y.zhao@intel.com>, Parav Pandit <parav@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
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
 <20200819033035.GA21172@joy-OptiPlex-7040>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e20812b7-994b-b7f9-2df4-a78c4d116c7f@redhat.com>
Date:   Wed, 19 Aug 2020 14:57:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200819033035.GA21172@joy-OptiPlex-7040>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/8/19 上午11:30, Yan Zhao wrote:
> hi All,
> could we decide that sysfs is the interface that every VFIO vendor driver
> needs to provide in order to support vfio live migration, otherwise the
> userspace management tool would not list the device into the compatible
> list?
>
> if that's true, let's move to the standardizing of the sysfs interface.
> (1) content
> common part: (must)
>     - software_version: (in major.minor.bugfix scheme)


This can not work for devices whose features can be 
negotiated/advertised independently. (E.g virtio devices)


>     - device_api: vfio-pci or vfio-ccw ...
>     - type: mdev type for mdev device or
>             a signature for physical device which is a counterpart for
> 	   mdev type.
>
> device api specific part: (must)
>    - pci id: pci id of mdev parent device or pci id of physical pci
>      device (device_api is vfio-pci)API here.


So this assumes a PCI device which is probably not true.


>    - subchannel_type (device_api is vfio-ccw)
>   
> vendor driver specific part: (optional)
>    - aggregator
>    - chpid_type
>    - remote_url


For "remote_url", just wonder if it's better to integrate or reuse the 
existing NVME management interface instead of duplicating it here. 
Otherwise it could be a burden for mgmt to learn. E.g vendor A may use 
"remote_url" but vendor B may use a different attribute.


>
> NOTE: vendors are free to add attributes in this part with a
> restriction that this attribute is able to be configured with the same
> name in sysfs too. e.g.


Sysfs works well for common attributes belongs to a class, but I'm not 
sure it can work well for device/vendor specific attributes. Does this 
mean mgmt need to iterate all the attributes in both src and dst?


> for aggregator, there must be a sysfs attribute in device node
> /sys/devices/pci0000:00/0000:00:02.0/882cc4da-dede-11e7-9180-078a62063ab1/intel_vgpu/aggregator,
> so that the userspace tool is able to configure the target device
> according to source device's aggregator attribute.
>
>
> (2) where and structure
> proposal 1:
> |- [path to device]
>    |--- migration
>    |     |--- self
>    |     |    |-software_version
>    |     |    |-device_api
>    |     |    |-type
>    |     |    |-[pci_id or subchannel_type]
>    |     |    |-<aggregator or chpid_type>
>    |     |--- compatible
>    |     |    |-software_version
>    |     |    |-device_api
>    |     |    |-type
>    |     |    |-[pci_id or subchannel_type]
>    |     |    |-<aggregator or chpid_type>
> multiple compatible is allowed.
> attributes should be ASCII text files, preferably with only one value
> per file.
>
>
> proposal 2: use bin_attribute.
> |- [path to device]
>    |--- migration
>    |     |--- self
>    |     |--- compatible
>
> so we can continue use multiline format. e.g.
> cat compatible
>    software_version=0.1.0
>    device_api=vfio_pci
>    type=i915-GVTg_V5_{val1:int:1,2,4,8}
>    pci_id=80865963
>    aggregator={val1}/2


So basically two questions:

- how hard to standardize sysfs API for dealing with compatibility check 
(to make it work for most types of devices)
- how hard for the mgmt to learn with a vendor specific attributes (vs 
existing management API)

Thanks


>
> Thanks
> Yan

