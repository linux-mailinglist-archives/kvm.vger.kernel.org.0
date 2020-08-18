Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6B9247CBB
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 05:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgHRDZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 23:25:09 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52021 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726357AbgHRDZI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Aug 2020 23:25:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597721107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NN8cpkmmzd+gIshGfVJZRN/csbLtvOwEsIlzPP5rJmg=;
        b=LfiRjYxDyIYSeg2kgzg27ZBuiXG/Q3RbNWhIK1hbbo9PS6xE5ndynTRrvbPUF7iCqcTyfU
        W9fRsPzf2ZgmTJ6G2FN55qNzMF5NwNfJILmdh4Rlj+IrqMLk7pxktjJA5Ml+rcdS91AR4Y
        4UuTruwm33NeWBVPhuA7lTgUFY6GNQM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-Kx5BTRbaMhu7ueNFw8QxKA-1; Mon, 17 Aug 2020 23:24:52 -0400
X-MC-Unique: Kx5BTRbaMhu7ueNFw8QxKA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 474AB18686C6;
        Tue, 18 Aug 2020 03:24:50 +0000 (UTC)
Received: from [10.72.13.202] (ovpn-13-202.pek2.redhat.com [10.72.13.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4EA65D9D2;
        Tue, 18 Aug 2020 03:24:31 +0000 (UTC)
Subject: Re: device compatibility interface for live migration with assigned
 devices
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, eskultet@redhat.com,
        openstack-discuss@lists.openstack.org, shaohe.feng@intel.com,
        kevin.tian@intel.com, Parav Pandit <parav@mellanox.com>,
        jian-feng.ding@intel.com, dgilbert@redhat.com,
        zhenyuw@linux.intel.com, hejie.xu@intel.com, bao.yumeng@zte.com.cn,
        Alex Williamson <alex.williamson@redhat.com>,
        smooney@redhat.com, intel-gvt-dev@lists.freedesktop.org,
        berrange@redhat.com, Cornelia Huck <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>, dinechin@redhat.com,
        devel@ovirt.org
References: <20200804183503.39f56516.cohuck@redhat.com>
 <c178a0d3-269d-1620-22b1-9010f602d8ff@redhat.com>
 <20200805021654.GB30485@joy-OptiPlex-7040>
 <2624b12f-3788-7e2b-2cb7-93534960bcb7@redhat.com>
 <20200805075647.GB2177@nanopsycho>
 <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
 <20200805093338.GC30485@joy-OptiPlex-7040> <20200805105319.GF2177@nanopsycho>
 <20200810074631.GA29059@joy-OptiPlex-7040>
 <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
 <20200814051601.GD15344@joy-OptiPlex-7040>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
Date:   Tue, 18 Aug 2020 11:24:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200814051601.GD15344@joy-OptiPlex-7040>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/8/14 下午1:16, Yan Zhao wrote:
> On Thu, Aug 13, 2020 at 12:24:50PM +0800, Jason Wang wrote:
>> On 2020/8/10 下午3:46, Yan Zhao wrote:
>>>> driver is it handled by?
>>> It looks that the devlink is for network device specific, and in
>>> devlink.h, it says
>>> include/uapi/linux/devlink.h - Network physical device Netlink
>>> interface,
>>
>> Actually not, I think there used to have some discussion last year and the
>> conclusion is to remove this comment.
>>
>> It supports IB and probably vDPA in the future.
>>
> hmm... sorry, I didn't find the referred discussion. only below discussion
> regarding to why to add devlink.
>
> https://www.mail-archive.com/netdev@vger.kernel.org/msg95801.html
> 	>This doesn't seem to be too much related to networking? Why can't something
> 	>like this be in sysfs?
> 	
> 	It is related to networking quite bit. There has been couple of
> 	iteration of this, including sysfs and configfs implementations. There
> 	has been a consensus reached that this should be done by netlink. I
> 	believe netlink is really the best for this purpose. Sysfs is not a good
> 	idea


See the discussion here:

https://patchwork.ozlabs.org/project/netdev/patch/20191115223355.1277139-1-jeffrey.t.kirsher@intel.com/


>
> https://www.mail-archive.com/netdev@vger.kernel.org/msg96102.html
> 	>there is already a way to change eth/ib via
> 	>echo 'eth' > /sys/bus/pci/drivers/mlx4_core/0000:02:00.0/mlx4_port1
> 	>
> 	>sounds like this is another way to achieve the same?
> 	
> 	It is. However the current way is driver-specific, not correct.
> 	For mlx5, we need the same, it cannot be done in this way. Do devlink is
> 	the correct way to go.
>
> https://lwn.net/Articles/674867/
> 	There a is need for some userspace API that would allow to expose things
> 	that are not directly related to any device class like net_device of
> 	ib_device, but rather chip-wide/switch-ASIC-wide stuff.
>
> 	Use cases:
> 	1) get/set of port type (Ethernet/InfiniBand)
> 	2) monitoring of hardware messages to and from chip
> 	3) setting up port splitters - split port into multiple ones and squash again,
> 	   enables usage of splitter cable
> 	4) setting up shared buffers - shared among multiple ports within one chip
>
>
>
> we actually can also retrieve the same information through sysfs, .e.g
>
> |- [path to device]
>    |--- migration
>    |     |--- self
>    |     |   |---device_api
>    |	|   |---mdev_type
>    |	|   |---software_version
>    |	|   |---device_id
>    |	|   |---aggregator
>    |     |--- compatible
>    |     |   |---device_api
>    |	|   |---mdev_type
>    |	|   |---software_version
>    |	|   |---device_id
>    |	|   |---aggregator
>

Yes but:

- You need one file per attribute (one syscall for one attribute)
- Attribute is coupled with kobject

All of above seems unnecessary.

Another point, as we discussed in another thread, it's really hard to 
make sure the above API work for all types of devices and frameworks. So 
having a vendor specific API looks much better.


>
>>>    I feel like it's not very appropriate for a GPU driver to use
>>> this interface. Is that right?
>>
>> I think not though most of the users are switch or ethernet devices. It
>> doesn't prevent you from inventing new abstractions.
> so need to patch devlink core and the userspace devlink tool?
> e.g. devlink migration


It quite flexible, you can extend devlink, invent your own or let mgmt 
to establish devlink directly.


>
>> Note that devlink is based on netlink, netlink has been widely used by
>> various subsystems other than networking.
> the advantage of netlink I see is that it can monitor device status and
> notify upper layer that migration database needs to get updated.


I may miss something, but why this is needed?

 From device point of view, the following capability should be 
sufficient to support live migration:

- set/get device state
- report dirty page tracking
- set/get capability


> But not sure whether openstack would like to use this capability.
> As Sean said, it's heavy for openstack. it's heavy for vendor driver
> as well :)


Well, it depends several factors. Just counting LOCs, sysfs based 
attributes is not lightweight.

Thanks


>
> And devlink monitor now listens the notification and dumps the state
> changes. If we want to use it, need to let it forward the notification
> and dumped info to openstack, right?
>
> Thanks
> Yan
>

