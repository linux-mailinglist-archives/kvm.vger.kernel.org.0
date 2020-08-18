Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56282481BB
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 11:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgHRJQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 05:16:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26439 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726353AbgHRJQy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Aug 2020 05:16:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597742212;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HVFj7FoFlCmRwOr98i1isDMUsMu/x19B/RyjX8oAjpw=;
        b=FOBDaVOkaJoVHuBc9FFlVFwWgLFhqCfetCXvPeYtY0tN+hcrXoiy67ol4nKQpHbxS7fgrj
        0WW/3GcJhjQWVaJl7+VBm8sv1SV+U8Ze750L6GuOfijAfoZm/6YzO/JDu0LhamcdkLSx9h
        dvZRY45bsIK97J55l+pqRS2+WBY0sh4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-hPDVDA2kNsyMqa_cPBHKPg-1; Tue, 18 Aug 2020 05:16:50 -0400
X-MC-Unique: hPDVDA2kNsyMqa_cPBHKPg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48C781006701;
        Tue, 18 Aug 2020 09:16:48 +0000 (UTC)
Received: from redhat.com (unknown [10.36.110.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 43F0D5D757;
        Tue, 18 Aug 2020 09:16:31 +0000 (UTC)
Date:   Tue, 18 Aug 2020 10:16:28 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
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
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200818091628.GC20215@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20200805075647.GB2177@nanopsycho>
 <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
 <20200805093338.GC30485@joy-OptiPlex-7040>
 <20200805105319.GF2177@nanopsycho>
 <20200810074631.GA29059@joy-OptiPlex-7040>
 <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
 <20200814051601.GD15344@joy-OptiPlex-7040>
 <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
 <20200818085527.GB20215@redhat.com>
 <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
User-Agent: Mutt/1.14.5 (2020-06-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Your mail came through as HTML-only so all the quoting and attribution
is mangled / lost now :-(

On Tue, Aug 18, 2020 at 05:01:51PM +0800, Jason Wang wrote:
>    On 2020/8/18 下午4:55, Daniel P. Berrangé wrote:
> 
>  On Tue, Aug 18, 2020 at 11:24:30AM +0800, Jason Wang wrote:
> 
>  On 2020/8/14 下午1:16, Yan Zhao wrote:
> 
>  On Thu, Aug 13, 2020 at 12:24:50PM +0800, Jason Wang wrote:
> 
>  On 2020/8/10 下午3:46, Yan Zhao wrote:

>  we actually can also retrieve the same information through sysfs, .e.g
> 
>  |- [path to device]
>     |--- migration
>     |     |--- self
>     |     |   |---device_api
>     |    |   |---mdev_type
>     |    |   |---software_version
>     |    |   |---device_id
>     |    |   |---aggregator
>     |     |--- compatible
>     |     |   |---device_api
>     |    |   |---mdev_type
>     |    |   |---software_version
>     |    |   |---device_id
>     |    |   |---aggregator
> 
> 
>  Yes but:
> 
>  - You need one file per attribute (one syscall for one attribute)
>  - Attribute is coupled with kobject
> 
>  All of above seems unnecessary.
> 
>  Another point, as we discussed in another thread, it's really hard to make
>  sure the above API work for all types of devices and frameworks. So having a
>  vendor specific API looks much better.
> 
>  From the POV of userspace mgmt apps doing device compat checking / migration,
>  we certainly do NOT want to use different vendor specific APIs. We want to
>  have an API that can be used / controlled in a standard manner across vendors.
> 
>    Yes, but it could be hard. E.g vDPA will chose to use devlink (there's a
>    long debate on sysfs vs devlink). So if we go with sysfs, at least two
>    APIs needs to be supported ...

NB, I was not questioning devlink vs sysfs directly. If devlink is related
to netlink, I can't say I'm enthusiastic as IMKE sysfs is easier to deal
with. I don't know enough about devlink to have much of an opinion though.
The key point was that I don't want the userspace APIs we need to deal with
to be vendor specific.

What I care about is that we have a *standard* userspace API for performing
device compatibility checking / state migration, for use by QEMU/libvirt/
OpenStack, such that we can write code without countless vendor specific
code paths.

If there is vendor specific stuff on the side, that's fine as we can ignore
that, but the core functionality for device compat / migration needs to be
standardized.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

