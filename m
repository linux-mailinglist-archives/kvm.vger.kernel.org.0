Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E269824A534
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 19:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgHSRul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 13:50:41 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29356 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726435AbgHSRuk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Aug 2020 13:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597859437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8lNk6KAQT00fEGMmkwPt3Op+/FwJtuzhLJksYRjBXJw=;
        b=OuJGJmRZVzA8WvI/LU0KEtj6Yy+MBaY1538SdpZVltHd2VpascYUBjjyTIul432xr5GOUE
        2EXVf5Ru5b/DLCZ2W7s5UCGcnl3c4s9E8AkLQZx4wMg0Z0f5uUj41Or4/aoxGRhX8zvCFw
        aSnBDCqdHrYXR4VGA1g1faqnHh4Y3S8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-WDx2ksAmMAOFqsCXT9toUA-1; Wed, 19 Aug 2020 13:50:32 -0400
X-MC-Unique: WDx2ksAmMAOFqsCXT9toUA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CFB564080;
        Wed, 19 Aug 2020 17:50:30 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32D967DFDD;
        Wed, 19 Aug 2020 17:50:22 +0000 (UTC)
Date:   Wed, 19 Aug 2020 11:50:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Parav Pandit <parav@nvidia.com>, Cornelia Huck <cohuck@redhat.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
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
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "smooney@redhat.com" <smooney@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "devel@ovirt.org" <devel@ovirt.org>
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200819115021.004427a3@x1.home>
In-Reply-To: <20200819033035.GA21172@joy-OptiPlex-7040>
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
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Aug 2020 11:30:35 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Tue, Aug 18, 2020 at 09:39:24AM +0000, Parav Pandit wrote:
> > Hi Cornelia,
> >  =20
> > > From: Cornelia Huck <cohuck@redhat.com>
> > > Sent: Tuesday, August 18, 2020 3:07 PM
> > > To: Daniel P. Berrang=C3=A9 <berrange@redhat.com>
> > > Cc: Jason Wang <jasowang@redhat.com>; Yan Zhao
> > > <yan.y.zhao@intel.com>; kvm@vger.kernel.org; libvir-list@redhat.com;
> > > qemu-devel@nongnu.org; Kirti Wankhede <kwankhede@nvidia.com>;
> > > eauger@redhat.com; xin-ran.wang@intel.com; corbet@lwn.net; openstack-
> > > discuss@lists.openstack.org; shaohe.feng@intel.com; kevin.tian@intel.=
com;
> > > Parav Pandit <parav@mellanox.com>; jian-feng.ding@intel.com;
> > > dgilbert@redhat.com; zhenyuw@linux.intel.com; hejie.xu@intel.com;
> > > bao.yumeng@zte.com.cn; Alex Williamson <alex.williamson@redhat.com>;
> > > eskultet@redhat.com; smooney@redhat.com; intel-gvt-
> > > dev@lists.freedesktop.org; Jiri Pirko <jiri@mellanox.com>;
> > > dinechin@redhat.com; devel@ovirt.org
> > > Subject: Re: device compatibility interface for live migration with a=
ssigned
> > > devices
> > >=20
> > > On Tue, 18 Aug 2020 10:16:28 +0100
> > > Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:
> > >  =20
> > > > On Tue, Aug 18, 2020 at 05:01:51PM +0800, Jason Wang wrote: =20
> > > > >    On 2020/8/18 =E4=B8=8B=E5=8D=884:55, Daniel P. Berrang=C3=A9 w=
rote:
> > > > >
> > > > >  On Tue, Aug 18, 2020 at 11:24:30AM +0800, Jason Wang wrote:
> > > > >
> > > > >  On 2020/8/14 =E4=B8=8B=E5=8D=881:16, Yan Zhao wrote:
> > > > >
> > > > >  On Thu, Aug 13, 2020 at 12:24:50PM +0800, Jason Wang wrote:
> > > > >
> > > > >  On 2020/8/10 =E4=B8=8B=E5=8D=883:46, Yan Zhao wrote: =20
> > > > =20
> > > > >  we actually can also retrieve the same information through sysfs,
> > > > > .e.g
> > > > >
> > > > >  |- [path to device]
> > > > >     |--- migration
> > > > >     |     |--- self
> > > > >     |     |   |---device_api
> > > > >     |    |   |---mdev_type
> > > > >     |    |   |---software_version
> > > > >     |    |   |---device_id
> > > > >     |    |   |---aggregator
> > > > >     |     |--- compatible
> > > > >     |     |   |---device_api
> > > > >     |    |   |---mdev_type
> > > > >     |    |   |---software_version
> > > > >     |    |   |---device_id
> > > > >     |    |   |---aggregator
> > > > >
> > > > >
> > > > >  Yes but:
> > > > >
> > > > >  - You need one file per attribute (one syscall for one attribute)
> > > > >  - Attribute is coupled with kobject =20
> > >=20
> > > Is that really that bad? You have the device with an embedded kobject
> > > anyway, and you can just put things into an attribute group?
> > >=20
> > > [Also, I think that self/compatible split in the example makes things
> > > needlessly complex. Shouldn't semantic versioning and matching already
> > > cover nearly everything? I would expect very few cases that are more
> > > complex than that. Maybe the aggregation stuff, but I don't think we =
need
> > > that self/compatible split for that, either.]
> > >  =20
> > > > >
> > > > >  All of above seems unnecessary.
> > > > >
> > > > >  Another point, as we discussed in another thread, it's really ha=
rd
> > > > > to make  sure the above API work for all types of devices and
> > > > > frameworks. So having a  vendor specific API looks much better.
> > > > >
> > > > >  From the POV of userspace mgmt apps doing device compat checking=
 /
> > > > > migration,  we certainly do NOT want to use different vendor
> > > > > specific APIs. We want to  have an API that can be used / control=
led in a =20
> > > standard manner across vendors. =20
> > > > >
> > > > >    Yes, but it could be hard. E.g vDPA will chose to use devlink =
(there's a
> > > > >    long debate on sysfs vs devlink). So if we go with sysfs, at l=
east two
> > > > >    APIs needs to be supported ... =20
> > > >
> > > > NB, I was not questioning devlink vs sysfs directly. If devlink is
> > > > related to netlink, I can't say I'm enthusiastic as IMKE sysfs is
> > > > easier to deal with. I don't know enough about devlink to have much=
 of an =20
> > > opinion though. =20
> > > > The key point was that I don't want the userspace APIs we need to d=
eal
> > > > with to be vendor specific. =20
> > >=20
> > > From what I've seen of devlink, it seems quite nice; but I understand=
 why
> > > sysfs might be easier to deal with (especially as there's likely alre=
ady a lot of
> > > code using it.)
> > >=20
> > > I understand that some users would like devlink because it is already=
 widely
> > > used for network drivers (and some others), but I don't think the maj=
ority of
> > > devices used with vfio are network (although certainly a lot of them =
are.)
> > >  =20
> > > >
> > > > What I care about is that we have a *standard* userspace API for
> > > > performing device compatibility checking / state migration, for use=
 by
> > > > QEMU/libvirt/ OpenStack, such that we can write code without countl=
ess
> > > > vendor specific code paths.
> > > >
> > > > If there is vendor specific stuff on the side, that's fine as we can
> > > > ignore that, but the core functionality for device compat / migrati=
on
> > > > needs to be standardized. =20
> > >=20
> > > To summarize:
> > > - choose one of sysfs or devlink
> > > - have a common interface, with a standardized way to add
> > >   vendor-specific attributes
> > > ? =20
> >=20
> > Please refer to my previous email which has more example and details. =
=20
> hi Parav,
> the example is based on a new vdpa tool running over netlink, not based
> on devlink, right?
> For vfio migration compatibility, we have to deal with both mdev and phys=
ical
> pci devices, I don't think it's a good idea to write a new tool for it, g=
iven
> we are able to retrieve the same info from sysfs and there's already an
> mdevctl from Alex (https://github.com/mdevctl/mdevctl).
>=20
> hi All,
> could we decide that sysfs is the interface that every VFIO vendor driver
> needs to provide in order to support vfio live migration, otherwise the
> userspace management tool would not list the device into the compatible
> list?
>=20
> if that's true, let's move to the standardizing of the sysfs interface.
> (1) content
> common part: (must)
>    - software_version: (in major.minor.bugfix scheme)
>    - device_api: vfio-pci or vfio-ccw ...
>    - type: mdev type for mdev device or
>            a signature for physical device which is a counterpart for
> 	   mdev type.
>=20
> device api specific part: (must)
>   - pci id: pci id of mdev parent device or pci id of physical pci
>     device (device_api is vfio-pci)

As noted previously, the parent PCI ID should not matter for an mdev
device, if a vendor has a dependency on matching the parent device PCI
ID, that's a vendor specific restriction.  An mdev device can also
expose a vfio-pci device API without the parent device being PCI.  For
a physical PCI device, shouldn't the PCI ID be encompassed in the
signature?  Thanks,

Alex

>   - subchannel_type (device_api is vfio-ccw)=20
> =20
> vendor driver specific part: (optional)
>   - aggregator
>   - chpid_type
>   - remote_url
>=20
> NOTE: vendors are free to add attributes in this part with a
> restriction that this attribute is able to be configured with the same
> name in sysfs too. e.g.
> for aggregator, there must be a sysfs attribute in device node
> /sys/devices/pci0000:00/0000:00:02.0/882cc4da-dede-11e7-9180-078a62063ab1=
/intel_vgpu/aggregator,
> so that the userspace tool is able to configure the target device
> according to source device's aggregator attribute.
>=20
>=20
> (2) where and structure
> proposal 1:
> |- [path to device]
>   |--- migration
>   |     |--- self
>   |     |    |-software_version
>   |     |    |-device_api
>   |     |    |-type
>   |     |    |-[pci_id or subchannel_type]
>   |     |    |-<aggregator or chpid_type>
>   |     |--- compatible
>   |     |    |-software_version
>   |     |    |-device_api
>   |     |    |-type
>   |     |    |-[pci_id or subchannel_type]
>   |     |    |-<aggregator or chpid_type>
> multiple compatible is allowed.
> attributes should be ASCII text files, preferably with only one value
> per file.
>=20
>=20
> proposal 2: use bin_attribute.
> |- [path to device]
>   |--- migration
>   |     |--- self
>   |     |--- compatible
>=20
> so we can continue use multiline format. e.g.
> cat compatible
>   software_version=3D0.1.0
>   device_api=3Dvfio_pci
>   type=3Di915-GVTg_V5_{val1:int:1,2,4,8}
>   pci_id=3D80865963
>   aggregator=3D{val1}/2
>=20
> Thanks
> Yan
>=20

