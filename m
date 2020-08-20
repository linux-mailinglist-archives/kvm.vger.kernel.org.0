Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9CD24BB64
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 14:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbgHTM2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 08:28:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48545 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730119AbgHTM2G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Aug 2020 08:28:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597926484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U+EKqHWsk01YkJj3wPmRDZ+g8oOUui84dZ5XwbpxkVc=;
        b=fFGtlbpUaNsv3OlgSvEUC+K4Nns4QWWRQ+c4im4EV9t0ZmYCtr3n8IFFPbZ3bAsCcY8jhC
        UIQVee/vrFNyOBlKFEnhaf2kw6+1USGywJpnumlng7DVizx/GTo6KH5l5XDI9dU3bbN57K
        o0nqTDQUwjmhdCdkD56yqrTTWxd5kRE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-D72bZbJcN-iK6OAgEc8XzQ-1; Thu, 20 Aug 2020 08:27:59 -0400
X-MC-Unique: D72bZbJcN-iK6OAgEc8XzQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31B651074643;
        Thu, 20 Aug 2020 12:27:57 +0000 (UTC)
Received: from gondolin (ovpn-112-251.ams2.redhat.com [10.36.112.251])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 383C974E2A;
        Thu, 20 Aug 2020 12:27:43 +0000 (UTC)
Date:   Thu, 20 Aug 2020 14:27:40 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
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
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "devel@ovirt.org" <devel@ovirt.org>
Subject: Re: [ovirt-devel] Re: device compatibility interface for live
 migration with assigned devices
Message-ID: <20200820142740.6513884d.cohuck@redhat.com>
In-Reply-To: <c1d580dd-5c0c-21bc-19a6-f776617d4ec2@redhat.com>
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
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Aug 2020 17:28:38 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 2020/8/19 =E4=B8=8B=E5=8D=884:13, Yan Zhao wrote:
> > On Wed, Aug 19, 2020 at 03:39:50PM +0800, Jason Wang wrote: =20
> >> On 2020/8/19 =E4=B8=8B=E5=8D=882:59, Yan Zhao wrote: =20
> >>> On Wed, Aug 19, 2020 at 02:57:34PM +0800, Jason Wang wrote: =20
> >>>> On 2020/8/19 =E4=B8=8A=E5=8D=8811:30, Yan Zhao wrote: =20
> >>>>> hi All,
> >>>>> could we decide that sysfs is the interface that every VFIO vendor =
driver
> >>>>> needs to provide in order to support vfio live migration, otherwise=
 the
> >>>>> userspace management tool would not list the device into the compat=
ible
> >>>>> list?
> >>>>>
> >>>>> if that's true, let's move to the standardizing of the sysfs interf=
ace.
> >>>>> (1) content
> >>>>> common part: (must)
> >>>>>       - software_version: (in major.minor.bugfix scheme) =20
> >>>> This can not work for devices whose features can be negotiated/adver=
tised
> >>>> independently. (E.g virtio devices)

I thought the 'software_version' was supposed to describe kind of a
'protocol version' for the data we transmit? I.e., you add a new field,
you bump the version number.

> >>>> =20
> >>> sorry, I don't understand here, why virtio devices need to use vfio i=
nterface? =20
> >>
> >> I don't see any reason that virtio devices can't be used by VFIO. Do y=
ou?
> >>
> >> Actually, virtio devices have been used by VFIO for many years:
> >>
> >> - passthrough a hardware virtio devices to userspace(VM) drivers
> >> - using virtio PMD inside guest
> >> =20
> > So, what's different for it vs passing through a physical hardware via =
VFIO? =20
>=20
>=20
> The difference is in the guest, the device could be either real hardware=
=20
> or emulated ones.
>=20
>=20
> > even though the features are negotiated dynamically, could you explain
> > why it would cause software_version not work? =20
>=20
>=20
> Virtio device 1 supports feature A, B, C
> Virtio device 2 supports feature B, C, D
>=20
> So you can't migrate a guest from device 1 to device 2. And it's=20
> impossible to model the features with versions.

We're talking about the features offered by the device, right? Would it
be sufficient to mandate that the target device supports the same
features or a superset of the features supported by the source device?

>=20
>=20
> >
> > =20
> >>> I think this thread is discussing about vfio related devices.
> >>> =20
> >>>>>       - device_api: vfio-pci or vfio-ccw ...
> >>>>>       - type: mdev type for mdev device or
> >>>>>               a signature for physical device which is a counterpar=
t for
> >>>>> 	   mdev type.
> >>>>>
> >>>>> device api specific part: (must)
> >>>>>      - pci id: pci id of mdev parent device or pci id of physical p=
ci
> >>>>>        device (device_api is vfio-pci)API here. =20
> >>>> So this assumes a PCI device which is probably not true.
> >>>> =20
> >>> for device_api of vfio-pci, why it's not true?
> >>>
> >>> for vfio-ccw, it's subchannel_type. =20
> >>
> >> Ok but having two different attributes for the same file is not good i=
dea.
> >> How mgmt know there will be a 3rd type? =20
> > that's why some attributes need to be common. e.g.
> > device_api: it's common because mgmt need to know it's a pci device or a
> >              ccw device. and the api type is already defined vfio.h.
> > 	    (The field is agreed by and actually suggested by Alex in previous=
 mail)
> > type: mdev_type for mdev. if mgmt does not understand it, it would not
> >        be able to create one compatible mdev device.
> > software_version: mgmt can compare the major and minor if it understands
> >        this fields. =20
>=20
>=20
> I think it would be helpful if you can describe how mgmt is expected to=20
> work step by step with the proposed sysfs API. This can help people to=20
> understand.

My proposal would be:
- check that device_api matches
- check possible device_api specific attributes
- check that type matches [I don't think the combination of mdev types
  and another attribute to determine compatibility is a good idea;
  actually, the current proposal confuses me every time I look at it]
- check that software_version is compatible, assuming semantic
  versioning
- check possible type-specific attributes

>=20
> Thanks for the patience. Since sysfs is uABI, when accepted, we need=20
> support it forever. That's why we need to be careful.

Nod.

(...)

