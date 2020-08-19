Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99C0249313
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 04:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgHSCyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 22:54:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30080 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726718AbgHSCyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 22:54:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597805670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OyfXHDOh3tadbBcQyUmurCPsA+lHPesiQMeXAJCp/nc=;
        b=OiJFqrqUeN8hDTapH/ujMRVmOQtv/EPJs7ua6I52WuT2TPZrnonb0zYfwvpgDQpMxvnmWH
        0xmAYRwY+wdzM+UCytm7+tKTTHNEwEdvUNR+Xn5Kht88CtZ5cTzYL1jUq5Qh6a1W+fml5J
        xt6ILlqrzTjQVHSS9lWmZXdByLxBjv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-Ay-EfPfqMQ6MMOO5kbt_wg-1; Tue, 18 Aug 2020 22:54:29 -0400
X-MC-Unique: Ay-EfPfqMQ6MMOO5kbt_wg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7656381F030;
        Wed, 19 Aug 2020 02:54:26 +0000 (UTC)
Received: from [10.72.13.88] (ovpn-13-88.pek2.redhat.com [10.72.13.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D15481B47B;
        Wed, 19 Aug 2020 02:54:08 +0000 (UTC)
Subject: Re: device compatibility interface for live migration with assigned
 devices
To:     Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Parav Pandit <parav@mellanox.com>, jian-feng.ding@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, hejie.xu@intel.com,
        bao.yumeng@zte.com.cn,
        Alex Williamson <alex.williamson@redhat.com>,
        eskultet@redhat.com, smooney@redhat.com,
        intel-gvt-dev@lists.freedesktop.org,
        Jiri Pirko <jiri@mellanox.com>, dinechin@redhat.com,
        devel@ovirt.org
References: <20200805075647.GB2177@nanopsycho>
 <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
 <20200805093338.GC30485@joy-OptiPlex-7040> <20200805105319.GF2177@nanopsycho>
 <20200810074631.GA29059@joy-OptiPlex-7040>
 <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
 <20200814051601.GD15344@joy-OptiPlex-7040>
 <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
 <20200818085527.GB20215@redhat.com>
 <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
 <20200818091628.GC20215@redhat.com>
 <20200818113652.5d81a392.cohuck@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e862b946-6688-0a75-47ae-9ca16a759c38@redhat.com>
Date:   Wed, 19 Aug 2020 10:54:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200818113652.5d81a392.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/8/18 下午5:36, Cornelia Huck wrote:
> On Tue, 18 Aug 2020 10:16:28 +0100
> Daniel P. Berrangé <berrange@redhat.com> wrote:
>
>> On Tue, Aug 18, 2020 at 05:01:51PM +0800, Jason Wang wrote:
>>>     On 2020/8/18 下午4:55, Daniel P. Berrangé wrote:
>>>
>>>   On Tue, Aug 18, 2020 at 11:24:30AM +0800, Jason Wang wrote:
>>>
>>>   On 2020/8/14 下午1:16, Yan Zhao wrote:
>>>
>>>   On Thu, Aug 13, 2020 at 12:24:50PM +0800, Jason Wang wrote:
>>>
>>>   On 2020/8/10 下午3:46, Yan Zhao wrote:
>>>   we actually can also retrieve the same information through sysfs, .e.g
>>>
>>>   |- [path to device]
>>>      |--- migration
>>>      |     |--- self
>>>      |     |   |---device_api
>>>      |    |   |---mdev_type
>>>      |    |   |---software_version
>>>      |    |   |---device_id
>>>      |    |   |---aggregator
>>>      |     |--- compatible
>>>      |     |   |---device_api
>>>      |    |   |---mdev_type
>>>      |    |   |---software_version
>>>      |    |   |---device_id
>>>      |    |   |---aggregator
>>>
>>>
>>>   Yes but:
>>>
>>>   - You need one file per attribute (one syscall for one attribute)
>>>   - Attribute is coupled with kobject
> Is that really that bad? You have the device with an embedded kobject
> anyway, and you can just put things into an attribute group?


Yes, but all of this could be done via devlink(netlink) as well with low 
overhead.


>
> [Also, I think that self/compatible split in the example makes things
> needlessly complex. Shouldn't semantic versioning and matching already
> cover nearly everything?


That's my question as well. E.g for virtio, versioning may not even 
work, some of features are negotiated independently:

Source features: A, B, C
Dest features: A, B, C, E

We just need to make sure the dest features is a superset of source then 
all set.


>   I would expect very few cases that are more
> complex than that. Maybe the aggregation stuff, but I don't think we
> need that self/compatible split for that, either.]
>
>>>   All of above seems unnecessary.
>>>
>>>   Another point, as we discussed in another thread, it's really hard to make
>>>   sure the above API work for all types of devices and frameworks. So having a
>>>   vendor specific API looks much better.
>>>
>>>   From the POV of userspace mgmt apps doing device compat checking / migration,
>>>   we certainly do NOT want to use different vendor specific APIs. We want to
>>>   have an API that can be used / controlled in a standard manner across vendors.
>>>
>>>     Yes, but it could be hard. E.g vDPA will chose to use devlink (there's a
>>>     long debate on sysfs vs devlink). So if we go with sysfs, at least two
>>>     APIs needs to be supported ...
>> NB, I was not questioning devlink vs sysfs directly. If devlink is related
>> to netlink, I can't say I'm enthusiastic as IMKE sysfs is easier to deal
>> with. I don't know enough about devlink to have much of an opinion though.
>> The key point was that I don't want the userspace APIs we need to deal with
>> to be vendor specific.
>  From what I've seen of devlink, it seems quite nice; but I understand
> why sysfs might be easier to deal with (especially as there's likely
> already a lot of code using it.)
>
> I understand that some users would like devlink because it is already
> widely used for network drivers (and some others), but I don't think
> the majority of devices used with vfio are network (although certainly
> a lot of them are.)


Note that though devlink could be popular only in network devices, 
netlink is widely used by a lot of subsystesm (e.g SCSI).

Thanks


>
>> What I care about is that we have a *standard* userspace API for performing
>> device compatibility checking / state migration, for use by QEMU/libvirt/
>> OpenStack, such that we can write code without countless vendor specific
>> code paths.
>>
>> If there is vendor specific stuff on the side, that's fine as we can ignore
>> that, but the core functionality for device compat / migration needs to be
>> standardized.
> To summarize:
> - choose one of sysfs or devlink
> - have a common interface, with a standardized way to add
>    vendor-specific attributes
> ?

