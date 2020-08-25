Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40BA251AFF
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 16:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgHYOjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 10:39:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28189 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726119AbgHYOjr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Aug 2020 10:39:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598366385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QPdYh1VB2wpc3IYjObXT6GDVs2MbdPO5hiSctsLyL8M=;
        b=YPJbnrV7tRXKYLfKTwTf6Jz+G6dlA9P6Bpi/QHEQljflIj/VIWfmehqMLl4VLWCMx2ZAXi
        2nPNKOCkC8lTz7EIDo/0ZwQZra60wZSCU96JjFSwvsfbXrZgTa6qF+aoADkMnI8ilQWQI6
        2z3znplRxtQQi+XKuab7YBBVZRKGdrQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-8x5CwBgFP1eJWXLuDrlbMA-1; Tue, 25 Aug 2020 10:39:43 -0400
X-MC-Unique: 8x5CwBgFP1eJWXLuDrlbMA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6907A1007467;
        Tue, 25 Aug 2020 14:39:41 +0000 (UTC)
Received: from gondolin (ovpn-112-248.ams2.redhat.com [10.36.112.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF2DB1014161;
        Tue, 25 Aug 2020 14:39:27 +0000 (UTC)
Date:   Tue, 25 Aug 2020 16:39:25 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com,
        Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Parav Pandit <parav@mellanox.com>, jian-feng.ding@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, hejie.xu@intel.com,
        bao.yumeng@zte.com.cn, smooney@redhat.com,
        intel-gvt-dev@lists.freedesktop.org, eskultet@redhat.com,
        Jiri Pirko <jiri@mellanox.com>, dinechin@redhat.com,
        devel@ovirt.org
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200825163925.1c19b0f0.cohuck@redhat.com>
In-Reply-To: <20200820031621.GA24997@joy-OptiPlex-7040>
References: <20200810074631.GA29059@joy-OptiPlex-7040>
        <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
        <20200814051601.GD15344@joy-OptiPlex-7040>
        <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
        <20200818085527.GB20215@redhat.com>
        <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
        <20200818091628.GC20215@redhat.com>
        <20200818113652.5d81a392.cohuck@redhat.com>
        <20200820003922.GE21172@joy-OptiPlex-7040>
        <20200819212234.223667b3@x1.home>
        <20200820031621.GA24997@joy-OptiPlex-7040>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Aug 2020 11:16:21 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Wed, Aug 19, 2020 at 09:22:34PM -0600, Alex Williamson wrote:
> > On Thu, 20 Aug 2020 08:39:22 +0800
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >  =20
> > > On Tue, Aug 18, 2020 at 11:36:52AM +0200, Cornelia Huck wrote: =20
> > > > On Tue, 18 Aug 2020 10:16:28 +0100
> > > > Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:
> > > >    =20
> > > > > On Tue, Aug 18, 2020 at 05:01:51PM +0800, Jason Wang wrote:   =20
> > > > > >    On 2020/8/18 =E4=B8=8B=E5=8D=884:55, Daniel P. Berrang=C3=A9=
 wrote:
> > > > > >=20
> > > > > >  On Tue, Aug 18, 2020 at 11:24:30AM +0800, Jason Wang wrote:
> > > > > >=20
> > > > > >  On 2020/8/14 =E4=B8=8B=E5=8D=881:16, Yan Zhao wrote:
> > > > > >=20
> > > > > >  On Thu, Aug 13, 2020 at 12:24:50PM +0800, Jason Wang wrote:
> > > > > >=20
> > > > > >  On 2020/8/10 =E4=B8=8B=E5=8D=883:46, Yan Zhao wrote:     =20
> > > > >    =20
> > > > > >  we actually can also retrieve the same information through sys=
fs, .e.g
> > > > > >=20
> > > > > >  |- [path to device]
> > > > > >     |--- migration
> > > > > >     |     |--- self
> > > > > >     |     |   |---device_api
> > > > > >     |    |   |---mdev_type
> > > > > >     |    |   |---software_version
> > > > > >     |    |   |---device_id
> > > > > >     |    |   |---aggregator
> > > > > >     |     |--- compatible
> > > > > >     |     |   |---device_api
> > > > > >     |    |   |---mdev_type
> > > > > >     |    |   |---software_version
> > > > > >     |    |   |---device_id
> > > > > >     |    |   |---aggregator
> > > > > >=20
> > > > > >=20
> > > > > >  Yes but:
> > > > > >=20
> > > > > >  - You need one file per attribute (one syscall for one attribu=
te)
> > > > > >  - Attribute is coupled with kobject   =20
> > > >=20
> > > > Is that really that bad? You have the device with an embedded kobje=
ct
> > > > anyway, and you can just put things into an attribute group?
> > > >=20
> > > > [Also, I think that self/compatible split in the example makes thin=
gs
> > > > needlessly complex. Shouldn't semantic versioning and matching alre=
ady
> > > > cover nearly everything? I would expect very few cases that are more
> > > > complex than that. Maybe the aggregation stuff, but I don't think we
> > > > need that self/compatible split for that, either.]   =20
> > > Hi Cornelia,
> > >=20
> > > The reason I want to declare compatible list of attributes is that
> > > sometimes it's not a simple 1:1 matching of source attributes and tar=
get attributes
> > > as I demonstrated below,
> > > source mdev of (mdev_type i915-GVTg_V5_2 + aggregator 1) is compatibl=
e to
> > > target mdev of (mdev_type i915-GVTg_V5_4 + aggregator 2),
> > >                (mdev_type i915-GVTg_V5_8 + aggregator 4)
> > >=20
> > > and aggragator may be just one of such examples that 1:1 matching doe=
s not
> > > fit. =20
> >=20
> > If you're suggesting that we need a new 'compatible' set for every
> > aggregation, haven't we lost the purpose of aggregation?  For example,
> > rather than having N mdev types to represent all the possible
> > aggregation values, we have a single mdev type with N compatible
> > migration entries, one for each possible aggregation value.  BTW, how do
> > we have multiple compatible directories?  compatible0001,
> > compatible0002? Thanks,
> >  =20
> do you think the bin_attribute I proposed yesterday good?
> Then we can have a single compatible with a variable in the mdev_type and
> aggregator.
>=20
>    mdev_type=3Di915-GVTg_V5_{val1:int:2,4,8}
>    aggregator=3D{val1}/2

I'm not really a fan of binary attributes other than in cases where we
have some kind of binary format to begin with.

IIUC, we basically have:
- different partitioning (expressed in the mdev_type)
- different number of partitions (expressed via the aggregator)
- devices being compatible if the partitioning:aggregator ratio is the
  same

(The multiple mdev_type variants seem to come from avoiding extra
creation parameters, IIRC?)

Would it be enough to export
base_type=3Di915-GVTg_V5
aggregation_ratio=3D<integer>

to express the various combinations that are compatible without the
need for multiple sets of attributes?

