Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F76268E2F
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 16:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgINOqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 10:46:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43464 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726660AbgINOqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 10:46:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600094783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+FTjA4enfFJIR63GYEIsWV3awMt+Q34RFrVM4vhT7s4=;
        b=Ok8Cv/2B3jYVWeZN+pX2SxWUYtZ0FOou6Wr9lP4dnIA85XN3dBcVvgR8AxiII0T8H0VOkg
        eNT+JMOyVdBt9cbM6ZjsFBmaKguBWEH9n8AcPrGBMWKEHvCtrAvol7Mt404y0IDqXcCaWK
        SAdynDVAOnHaN+ct+/El6bpzzIuFjBs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-1thlOCTkP76oOonY2-lLjw-1; Mon, 14 Sep 2020 10:46:20 -0400
X-MC-Unique: 1thlOCTkP76oOonY2-lLjw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A12778BF01D;
        Mon, 14 Sep 2020 14:44:57 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50F5D7BE49;
        Mon, 14 Sep 2020 14:44:50 +0000 (UTC)
Date:   Mon, 14 Sep 2020 08:44:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Zeng, Xin" <xin.zeng@intel.com>
Cc:     "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Daniel =?UTF-8?B?UC5CZXJyYW5nw6k=?=" <berrange@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Wang, Xin-ran" <xin-ran.wang@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "openstack-discuss@lists.openstack.org" 
        <openstack-discuss@lists.openstack.org>,
        "Feng, Shaohe" <shaohe.feng@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Ding, Jian-feng" <jian-feng.ding@intel.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Xu, Hejie" <hejie.xu@intel.com>,
        "bao.yumeng@zte.com.cn" <bao.yumeng@zte.com.cn>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "devel@ovirt.org" <devel@ovirt.org>
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200914084449.0182e8a9@x1.home>
In-Reply-To: <DM6PR11MB3500BAC3B7056E348002A7FD88230@DM6PR11MB3500.namprd11.prod.outlook.com>
References: <20200825163925.1c19b0f0.cohuck@redhat.com>
        <20200826064117.GA22243@joy-OptiPlex-7040>
        <20200828154741.30cfc1a3.cohuck@redhat.com>
        <8f5345be73ebf4f8f7f51d6cdc9c2a0d8e0aa45e.camel@redhat.com>
        <20200831044344.GB13784@joy-OptiPlex-7040>
        <20200908164130.2fe0d106.cohuck@redhat.com>
        <20200909021308.GA1277@joy-OptiPlex-7040>
        <20200910143822.2071eca4.cohuck@redhat.com>
        <7cebcb6c8d1a1452b43e8358ee6ee18a150a0238.camel@redhat.com>
        <20200910120244.71e7b630@w520.home>
        <20200911005559.GA3932@joy-OptiPlex-7040>
        <20200911105155.184e32a0@w520.home>
        <DM6PR11MB3500BAC3B7056E348002A7FD88230@DM6PR11MB3500.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Sep 2020 13:48:43 +0000
"Zeng, Xin" <xin.zeng@intel.com> wrote:

> On Saturday, September 12, 2020 12:52 AM
> Alex Williamson <alex.williamson@redhat.com> wrote:
> > To: Zhao, Yan Y <yan.y.zhao@intel.com>
> > Cc: Sean Mooney <smooney@redhat.com>; Cornelia Huck
> > <cohuck@redhat.com>; Daniel P.Berrang=C3=A9 <berrange@redhat.com>;
> > kvm@vger.kernel.org; libvir-list@redhat.com; Jason Wang
> > <jasowang@redhat.com>; qemu-devel@nongnu.org;
> > kwankhede@nvidia.com; eauger@redhat.com; Wang, Xin-ran <xin- =20
> > ran.wang@intel.com>; corbet@lwn.net; openstack- =20
> > discuss@lists.openstack.org; Feng, Shaohe <shaohe.feng@intel.com>; Tian,
> > Kevin <kevin.tian@intel.com>; Parav Pandit <parav@mellanox.com>; Ding,
> > Jian-feng <jian-feng.ding@intel.com>; dgilbert@redhat.com;
> > zhenyuw@linux.intel.com; Xu, Hejie <hejie.xu@intel.com>;
> > bao.yumeng@zte.com.cn; intel-gvt-dev@lists.freedesktop.org;
> > eskultet@redhat.com; Jiri Pirko <jiri@mellanox.com>; dinechin@redhat.co=
m;
> > devel@ovirt.org
> > Subject: Re: device compatibility interface for live migration with ass=
igned
> > devices
> >=20
> > On Fri, 11 Sep 2020 08:56:00 +0800
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >  =20
> > > On Thu, Sep 10, 2020 at 12:02:44PM -0600, Alex Williamson wrote: =20
> > > > On Thu, 10 Sep 2020 13:50:11 +0100
> > > > Sean Mooney <smooney@redhat.com> wrote:
> > > > =20
> > > > > On Thu, 2020-09-10 at 14:38 +0200, Cornelia Huck wrote: =20
> > > > > > On Wed, 9 Sep 2020 10:13:09 +0800
> > > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > =20
> > > > > > > > > still, I'd like to put it more explicitly to make ensure =
it's not =20
> > missed: =20
> > > > > > > > > the reason we want to specify compatible_type as a trait =
and =20
> > check =20
> > > > > > > > > whether target compatible_type is the superset of source
> > > > > > > > > compatible_type is for the consideration of backward =20
> > compatibility. =20
> > > > > > > > > e.g.
> > > > > > > > > an old generation device may have a mdev type xxx-v4-yyy,=
 =20
> > while a newer =20
> > > > > > > > > generation  device may be of mdev type xxx-v5-yyy.
> > > > > > > > > with the compatible_type traits, the old generation devic=
e is still
> > > > > > > > > able to be regarded as compatible to newer generation dev=
ice =20
> > even their =20
> > > > > > > > > mdev types are not equal. =20
> > > > > > > >
> > > > > > > > If you want to support migration from v4 to v5, can't the =
=20
> > (presumably =20
> > > > > > > > newer) driver that supports v5 simply register the v4 type =
as well, =20
> > so =20
> > > > > > > > that the mdev can be created as v4? (Just like QEMU version=
ed =20
> > machine =20
> > > > > > > > types work.) =20
> > > > > > >
> > > > > > > yes, it should work in some conditions.
> > > > > > > but it may not be that good in some cases when v5 and v4 in t=
he =20
> > name string =20
> > > > > > > of mdev type identify hardware generation (e.g. v4 for gen8, =
and v5 =20
> > for =20
> > > > > > > gen9)
> > > > > > >
> > > > > > > e.g.
> > > > > > > (1). when src mdev type is v4 and target mdev type is v5 as
> > > > > > > software does not support it initially, and v4 and v5 identif=
y =20
> > hardware =20
> > > > > > > differences. =20
> > > > > >
> > > > > > My first hunch here is: Don't introduce types that may be compa=
tible
> > > > > > later. Either make them compatible, or make them distinct by de=
sign,
> > > > > > and possibly add a different, compatible type later.
> > > > > > =20
> > > > > > > then after software upgrade, v5 is now compatible to v4, shou=
ld the
> > > > > > > software now downgrade mdev type from v5 to v4?
> > > > > > > not sure if moving hardware generation info into a separate =
=20
> > attribute =20
> > > > > > > from mdev type name is better. e.g. remove v4, v5 in mdev typ=
e, =20
> > while use =20
> > > > > > > compatible_pci_ids to identify compatibility. =20
> > > > > >
> > > > > > If the generations are compatible, don't mention it in the mdev=
 type.
> > > > > > If they aren't, use distinct types, so that management software=
 =20
> > doesn't =20
> > > > > > have to guess. At least that would be my naive approach here. =
=20
> > > > > yep that is what i would prefer to see too. =20
> > > > > > =20
> > > > > > >
> > > > > > > (2) name string of mdev type is composed by "driver_name + =20
> > type_name". =20
> > > > > > > in some devices, e.g. qat, different generations of devices a=
re =20
> > binding to =20
> > > > > > > drivers of different names, e.g. "qat-v4", "qat-v5".
> > > > > > > then though type_name is equal, mdev type is not equal. e.g.
> > > > > > > "qat-v4-type1", "qat-v5-type1". =20
> > > > > >
> > > > > > I guess that shows a shortcoming of that "driver_name + type_na=
me"
> > > > > > approach? Or maybe I'm just confused. =20
> > > > > yes i really dont like haveing the version in the mdev-type name
> > > > > i would stongly perfger just qat-type-1 wehere qat is just there =
as a way =20
> > of namespacing. =20
> > > > > although symmetric-cryto, asymmetric-cryto and compression woudl =
=20
> > be a better name then type-1, type-2, type-3 if =20
> > > > > that is what they would end up mapping too. e.g. qat-compression =
or =20
> > qat-aes is a much better name then type-1 =20
> > > > > higher layers of software are unlikely to parse the mdev names bu=
t as a =20
> > human looking at them its much eaiser to =20
> > > > > understand if the names are meaningful. the qat prefix i think is=
 =20
> > important however to make sure that your mdev-types =20
> > > > > dont colide with other vendeors mdev types. so i woudl encurage a=
ll =20
> > vendors to prefix there mdev types with etiher the =20
> > > > > device name or the vendor. =20
> > > >
> > > > +1 to all this, the mdev type is meant to indicate a software
> > > > compatible interface, if different hardware versions can be software
> > > > compatible, then don't make the job of finding a compatible device
> > > > harder.  The full type is a combination of the vendor driver name p=
lus
> > > > the vendor provided type name specifically in order to provide a ty=
pe
> > > > namespace per vendor driver.  That's done at the mdev core level.
> > > > Thanks, =20
> > >
> > > hi Alex,
> > > got it. so do you suggest that vendors use consistent driver name over
> > > generations of devices?
> > > for qat, they create different modules for each generation. This
> > > practice is not good if they want to support migration between devices
> > > of different generations, right?
> > >
> > > and can I understand that we don't want support of migration between
> > > different mdev types even in future ? =20
> >=20
> > You need to balance your requirements here.  If you're creating
> > different drivers per generation, that suggests different device APIs,
> > which is a legitimate use case for different mdev types.  However if
> > you're expecting migration compatibility, that must be seamless to the
> > guest, therefore the device API must be identical.  That suggests that
> > migration between different types doesn't make much sense.  If a new
> > generation device wants to expose a new mdev type with new features or
> > device API, yet also support migration with an older mdev type, why
> > wouldn't it simply expose both the old and the new type?   =20
>=20
> I think all of these make sense, and I am assuming it's also reasonable a=
nd=20
> common that each generation of  device has a separate device driver modul=
e.
> On the other hand, please be aware that, the mdev type is consisted of the
> driver name of the mdev's parent device and the name of a mdev type which
> the device driver specifies.=20
> If a new generation device driver wants to expose an old mdev type, it ha=
s to
> register  the same driver name as the old one so that the mdev type could=
=20
> be completely same. This doesn't make sense as a) driver name usually is
> unique for a device driver module. b) If a system has both these two=20
> generation devices, once one generation device driver is loaded, the othe=
r=20
> is not allowed to be loaded due to the same driver name. =20
> So to allow a new generation device to simply expose the old mdev type for
> compatibility like you proposed, is it possible to create the mdev type by
> another approach, e.g. device driver creates its own namespace for the
> mdev type instead of mdev's parent device driver name being used currentl=
y?

TBH, I don't think that it's reasonable or common that different
drivers are used for each generation of hardware.  Drivers typically
evolve to support new generations of hardware, often sharing
significant code between generations.  When we deal with mdev
migration, we have an opaque data stream managed by the driver, our
default assumption is therefore that the driver plays a significant
role in the composition of that data stream.  I'm not ruling out that
we should support some form of compatibility between types, but in the
described scenario it seems the development model of the vendor drivers
is not conducive to the most obvious form of compatibility checking.
Thanks,

Alex

