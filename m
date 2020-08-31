Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0ED82571FD
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 05:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgHaDIX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Aug 2020 23:08:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36112 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726824AbgHaDIW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 30 Aug 2020 23:08:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598843299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qJUSyFAGtxYcMUIAK2A6tJE9bI47AKIWnz2EW0Z359s=;
        b=Qjhs6I6n5QF1/8muEsP17oMYgikCOXJQmtfNQCMc4ZJtropPPHRuwGxEDCaQwmaSt1bxAn
        KpHSLAASMRMuMkt/r205bJ/rBxKUMl+o3aeYh3PJu3B+2MOPDekGDAW0pFWrhRvAjBPVNe
        QRitoROKiUSMnF8JQWvtTkPNx6Syyaw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-luowdu28NMKyKl9wbnOv4A-1; Sun, 30 Aug 2020 23:08:17 -0400
X-MC-Unique: luowdu28NMKyKl9wbnOv4A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB802807331;
        Mon, 31 Aug 2020 03:08:13 +0000 (UTC)
Received: from [10.72.13.227] (ovpn-13-227.pek2.redhat.com [10.72.13.227])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31D353A40;
        Mon, 31 Aug 2020 03:07:54 +0000 (UTC)
Subject: Re: [ovirt-devel] Re: device compatibility interface for live
 migration with assigned devices
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
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
        Parav Pandit <parav@nvidia.com>,
        "sm ooney@redhat.com" <smooney@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "devel@ovirt.org" <devel@ovirt.org>
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
 <20200819081338.GC21172@joy-OptiPlex-7040>
 <c1d580dd-5c0c-21bc-19a6-f776617d4ec2@redhat.com>
 <20200820142740.6513884d.cohuck@redhat.com>
 <ea0e84c5-733a-2bdb-4c1e-95fd16698ed8@redhat.com>
 <20200821165255.53e26628.cohuck@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b9739032-9bc0-ec48-a4c7-36c055b91702@redhat.com>
Date:   Mon, 31 Aug 2020 11:07:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200821165255.53e26628.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/8/21 下午10:52, Cornelia Huck wrote:
> On Fri, 21 Aug 2020 11:14:41 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> On 2020/8/20 下午8:27, Cornelia Huck wrote:
>>> On Wed, 19 Aug 2020 17:28:38 +0800
>>> Jason Wang <jasowang@redhat.com> wrote:
>>>   
>>>> On 2020/8/19 下午4:13, Yan Zhao wrote:
>>>>> On Wed, Aug 19, 2020 at 03:39:50PM +0800, Jason Wang wrote:
>>>>>> On 2020/8/19 下午2:59, Yan Zhao wrote:
>>>>>>> On Wed, Aug 19, 2020 at 02:57:34PM +0800, Jason Wang wrote:
>>>>>>>> On 2020/8/19 上午11:30, Yan Zhao wrote:
>>>>>>>>> hi All,
>>>>>>>>> could we decide that sysfs is the interface that every VFIO vendor driver
>>>>>>>>> needs to provide in order to support vfio live migration, otherwise the
>>>>>>>>> userspace management tool would not list the device into the compatible
>>>>>>>>> list?
>>>>>>>>>
>>>>>>>>> if that's true, let's move to the standardizing of the sysfs interface.
>>>>>>>>> (1) content
>>>>>>>>> common part: (must)
>>>>>>>>>         - software_version: (in major.minor.bugfix scheme)
>>>>>>>> This can not work for devices whose features can be negotiated/advertised
>>>>>>>> independently. (E.g virtio devices)
>>> I thought the 'software_version' was supposed to describe kind of a
>>> 'protocol version' for the data we transmit? I.e., you add a new field,
>>> you bump the version number.
>>
>> Ok, but since we mandate backward compatibility of uABI, is this really
>> worth to have a version for sysfs? (Searching on sysfs shows no examples
>> like this)
> I was not thinking about the sysfs interface, but rather about the data
> that is sent over while migrating. E.g. we find out that sending some
> auxiliary data is a good idea and bump to version 1.1.0; version 1.0.0
> cannot deal with the extra data, but version 1.1.0 can deal with the
> older data stream.
>
> (...)


Well, I think what data to transmit during migration is the duty of qemu 
not kernel. And I suspect the idea of reading opaque data (with version) 
from kernel and transmit them to dest is the best approach.


>
>>>>>>>>>         - device_api: vfio-pci or vfio-ccw ...
>>>>>>>>>         - type: mdev type for mdev device or
>>>>>>>>>                 a signature for physical device which is a counterpart for
>>>>>>>>> 	   mdev type.
>>>>>>>>>
>>>>>>>>> device api specific part: (must)
>>>>>>>>>        - pci id: pci id of mdev parent device or pci id of physical pci
>>>>>>>>>          device (device_api is vfio-pci)API here.
>>>>>>>> So this assumes a PCI device which is probably not true.
>>>>>>>>      
>>>>>>> for device_api of vfio-pci, why it's not true?
>>>>>>>
>>>>>>> for vfio-ccw, it's subchannel_type.
>>>>>> Ok but having two different attributes for the same file is not good idea.
>>>>>> How mgmt know there will be a 3rd type?
>>>>> that's why some attributes need to be common. e.g.
>>>>> device_api: it's common because mgmt need to know it's a pci device or a
>>>>>                ccw device. and the api type is already defined vfio.h.
>>>>> 	    (The field is agreed by and actually suggested by Alex in previous mail)
>>>>> type: mdev_type for mdev. if mgmt does not understand it, it would not
>>>>>          be able to create one compatible mdev device.
>>>>> software_version: mgmt can compare the major and minor if it understands
>>>>>          this fields.
>>>> I think it would be helpful if you can describe how mgmt is expected to
>>>> work step by step with the proposed sysfs API. This can help people to
>>>> understand.
>>> My proposal would be:
>>> - check that device_api matches
>>> - check possible device_api specific attributes
>>> - check that type matches [I don't think the combination of mdev types
>>>     and another attribute to determine compatibility is a good idea;
>>
>> Any reason for this? Actually if we only use mdev type to detect the
>> compatibility, it would be much more easier. Otherwise, we are actually
>> re-inventing mdev types.
>>
>> E.g can we have the same mdev types with different device_api and other
>> attributes?
> In the end, the mdev type is represented as a string; but I'm not sure
> we can expect that two types with the same name, but a different
> device_api are related in any way.
>
> If we e.g. compare vfio-pci and vfio-ccw, they are fundamentally
> different.
>
> I was mostly concerned about the aggregation proposal, where type A +
> aggregation value b might be compatible with type B + aggregation value
> a.


Yes, that looks pretty complicated.


>
>>
>>>     actually, the current proposal confuses me every time I look at it]
>>> - check that software_version is compatible, assuming semantic
>>>     versioning
>>> - check possible type-specific attributes
>>
>> I'm not sure if this is too complicated. And I suspect there will be
>> vendor specific attributes:
>>
>> - for compatibility check: I think we should either modeling everything
>> via mdev type or making it totally vendor specific. Having something in
>> the middle will bring a lot of burden
> FWIW, I'm for a strict match on mdev type, and flexibility in per-type
> attributes.


I'm not sure whether the above flexibility can work better than encoding 
them to mdev type. If we really want ultra flexibility, we need making 
the compatibility check totally vendor specific.


>
>> - for provisioning: it's still not clear. As shown in this proposal, for
>> NVME we may need to set remote_url, but unless there will be a subclass
>> (NVME) in the mdev (which I guess not), we can't prevent vendor from
>> using another attribute name, in this case, tricks like attributes
>> iteration in some sub directory won't work. So even if we had some
>> common API for compatibility check, the provisioning API is still vendor
>> specific ...
> Yes, I'm not sure how to deal with the "same thing for different
> vendors" problem. We can try to make sure that in-kernel drivers play
> nicely, but not much more.


Then it's actually a subclass of mdev I guess in the future.

Thanks


