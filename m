Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4C5248203
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 11:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgHRJhS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 05:37:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28153 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726165AbgHRJhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 05:37:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597743436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uJjNy/iBoF2FonoLrwK5UsgI5KqHfrDJbMHahAh/X50=;
        b=P5grQXiJY/cQepGxtcf75Yfv/AZc9zXJbkrAV+ncf9O7WB2eM7y8JDlmXOodFSkQxyvoCV
        VGKwdkdXwtyWeXhyNshuhPxJ4zy8I7aHGqXW2MQwCbimtFL07s6w1h7ktIADM46tZCUZXG
        fdJicpSng0AsKAe5/pczGCgab5ZbRrg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-buTrGnQ6PEC5eD5s6IyfoQ-1; Tue, 18 Aug 2020 05:37:12 -0400
X-MC-Unique: buTrGnQ6PEC5eD5s6IyfoQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEEE2801ADD;
        Tue, 18 Aug 2020 09:37:09 +0000 (UTC)
Received: from gondolin (ovpn-112-221.ams2.redhat.com [10.36.112.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC6EE7D939;
        Tue, 18 Aug 2020 09:36:54 +0000 (UTC)
Date:   Tue, 18 Aug 2020 11:36:52 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com, qemu-devel@nongnu.org,
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
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200818113652.5d81a392.cohuck@redhat.com>
In-Reply-To: <20200818091628.GC20215@redhat.com>
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
        <20200818091628.GC20215@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Aug 2020 10:16:28 +0100
Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:

> On Tue, Aug 18, 2020 at 05:01:51PM +0800, Jason Wang wrote:
> >    On 2020/8/18 =E4=B8=8B=E5=8D=884:55, Daniel P. Berrang=C3=A9 wrote:
> >=20
> >  On Tue, Aug 18, 2020 at 11:24:30AM +0800, Jason Wang wrote:
> >=20
> >  On 2020/8/14 =E4=B8=8B=E5=8D=881:16, Yan Zhao wrote:
> >=20
> >  On Thu, Aug 13, 2020 at 12:24:50PM +0800, Jason Wang wrote:
> >=20
> >  On 2020/8/10 =E4=B8=8B=E5=8D=883:46, Yan Zhao wrote: =20
>=20
> >  we actually can also retrieve the same information through sysfs, .e.g
> >=20
> >  |- [path to device]
> >     |--- migration
> >     |     |--- self
> >     |     |   |---device_api
> >     |    |   |---mdev_type
> >     |    |   |---software_version
> >     |    |   |---device_id
> >     |    |   |---aggregator
> >     |     |--- compatible
> >     |     |   |---device_api
> >     |    |   |---mdev_type
> >     |    |   |---software_version
> >     |    |   |---device_id
> >     |    |   |---aggregator
> >=20
> >=20
> >  Yes but:
> >=20
> >  - You need one file per attribute (one syscall for one attribute)
> >  - Attribute is coupled with kobject

Is that really that bad? You have the device with an embedded kobject
anyway, and you can just put things into an attribute group?

[Also, I think that self/compatible split in the example makes things
needlessly complex. Shouldn't semantic versioning and matching already
cover nearly everything? I would expect very few cases that are more
complex than that. Maybe the aggregation stuff, but I don't think we
need that self/compatible split for that, either.]

> >=20
> >  All of above seems unnecessary.
> >=20
> >  Another point, as we discussed in another thread, it's really hard to =
make
> >  sure the above API work for all types of devices and frameworks. So ha=
ving a
> >  vendor specific API looks much better.
> >=20
> >  From the POV of userspace mgmt apps doing device compat checking / mig=
ration,
> >  we certainly do NOT want to use different vendor specific APIs. We wan=
t to
> >  have an API that can be used / controlled in a standard manner across =
vendors.
> >=20
> >    Yes, but it could be hard. E.g vDPA will chose to use devlink (there=
's a
> >    long debate on sysfs vs devlink). So if we go with sysfs, at least t=
wo
> >    APIs needs to be supported ... =20
>=20
> NB, I was not questioning devlink vs sysfs directly. If devlink is related
> to netlink, I can't say I'm enthusiastic as IMKE sysfs is easier to deal
> with. I don't know enough about devlink to have much of an opinion though.
> The key point was that I don't want the userspace APIs we need to deal wi=
th
> to be vendor specific.

=46rom what I've seen of devlink, it seems quite nice; but I understand
why sysfs might be easier to deal with (especially as there's likely
already a lot of code using it.)

I understand that some users would like devlink because it is already
widely used for network drivers (and some others), but I don't think
the majority of devices used with vfio are network (although certainly
a lot of them are.)

>=20
> What I care about is that we have a *standard* userspace API for performi=
ng
> device compatibility checking / state migration, for use by QEMU/libvirt/
> OpenStack, such that we can write code without countless vendor specific
> code paths.
>=20
> If there is vendor specific stuff on the side, that's fine as we can igno=
re
> that, but the core functionality for device compat / migration needs to be
> standardized.

To summarize:
- choose one of sysfs or devlink
- have a common interface, with a standardized way to add
  vendor-specific attributes
?

