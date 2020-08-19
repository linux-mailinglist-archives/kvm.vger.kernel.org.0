Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8550F2492EE
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 04:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgHSCil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 22:38:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726372AbgHSCik (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Aug 2020 22:38:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597804718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ahF9kHkk+KzE1v5hPws7TWhx97Oq/uytmMOo+VABGc=;
        b=WTK7VuCkQxOZCOiwhioTQvhRJSYuLLCOxCsaJRwibqSW7nnih1HOWmGpaLbZUpVTX0waU/
        CWzdFtOu4HjIGPgJ+SXsmOCHK+RTTdukc9hGr/O1kNJODnIkcX7Rt3ViPBLyP8OZ48nN4j
        oNwEuVMVCQfL38VDGtlC8ejrl3zBveE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-tVAsAyPbNA6-594zY0pgiQ-1; Tue, 18 Aug 2020 22:38:36 -0400
X-MC-Unique: tVAsAyPbNA6-594zY0pgiQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CC671DDF4;
        Wed, 19 Aug 2020 02:38:34 +0000 (UTC)
Received: from [10.72.13.88] (ovpn-13-88.pek2.redhat.com [10.72.13.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36A017DFDD;
        Wed, 19 Aug 2020 02:38:14 +0000 (UTC)
Subject: Re: device compatibility interface for live migration with assigned
 devices
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
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
        Cornelia Huck <cohuck@redhat.com>,
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5aea4ae6-e8c8-1120-453d-20a78cee6b20@redhat.com>
Date:   Wed, 19 Aug 2020 10:38:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200818091628.GC20215@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/8/18 下午5:16, Daniel P. Berrangé wrote:
> Your mail came through as HTML-only so all the quoting and attribution
> is mangled / lost now :-(


My bad, sorry.


>
> On Tue, Aug 18, 2020 at 05:01:51PM +0800, Jason Wang wrote:
>>     On 2020/8/18 下午4:55, Daniel P. Berrangé wrote:
>>
>>   On Tue, Aug 18, 2020 at 11:24:30AM +0800, Jason Wang wrote:
>>
>>   On 2020/8/14 下午1:16, Yan Zhao wrote:
>>
>>   On Thu, Aug 13, 2020 at 12:24:50PM +0800, Jason Wang wrote:
>>
>>   On 2020/8/10 下午3:46, Yan Zhao wrote:
>>   we actually can also retrieve the same information through sysfs, .e.g
>>
>>   |- [path to device]
>>      |--- migration
>>      |     |--- self
>>      |     |   |---device_api
>>      |    |   |---mdev_type
>>      |    |   |---software_version
>>      |    |   |---device_id
>>      |    |   |---aggregator
>>      |     |--- compatible
>>      |     |   |---device_api
>>      |    |   |---mdev_type
>>      |    |   |---software_version
>>      |    |   |---device_id
>>      |    |   |---aggregator
>>
>>
>>   Yes but:
>>
>>   - You need one file per attribute (one syscall for one attribute)
>>   - Attribute is coupled with kobject
>>
>>   All of above seems unnecessary.
>>
>>   Another point, as we discussed in another thread, it's really hard to make
>>   sure the above API work for all types of devices and frameworks. So having a
>>   vendor specific API looks much better.
>>
>>   From the POV of userspace mgmt apps doing device compat checking / migration,
>>   we certainly do NOT want to use different vendor specific APIs. We want to
>>   have an API that can be used / controlled in a standard manner across vendors.
>>
>>     Yes, but it could be hard. E.g vDPA will chose to use devlink (there's a
>>     long debate on sysfs vs devlink). So if we go with sysfs, at least two
>>     APIs needs to be supported ...
> NB, I was not questioning devlink vs sysfs directly. If devlink is related
> to netlink, I can't say I'm enthusiastic as IMKE sysfs is easier to deal
> with. I don't know enough about devlink to have much of an opinion though.
> The key point was that I don't want the userspace APIs we need to deal with
> to be vendor specific.
>
> What I care about is that we have a *standard* userspace API for performing
> device compatibility checking / state migration, for use by QEMU/libvirt/
> OpenStack, such that we can write code without countless vendor specific
> code paths.
>
> If there is vendor specific stuff on the side, that's fine as we can ignore
> that, but the core functionality for device compat / migration needs to be
> standardized.


Ok, I agree with you.

Thanks


>
> Regards,
> Daniel

