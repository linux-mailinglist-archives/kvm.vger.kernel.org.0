Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00868223F5A
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 17:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGQPTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 11:19:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45031 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726071AbgGQPTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 11:19:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594999140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qXUmWkPxibEzRGVIk03C1+SSnEHf2wvGfjHMihC3K8Y=;
        b=HimQfLFCadQjz/9x6ufplm8LLMksl3rCCI7uqCWYt+nwbZBa/Eo8y/ugZdtMUnFGRzzpVR
        rOjt8IO2eq2FbXlKbsICQrgj7R2FCTyAtGKDW95wvCwG66mWokhZoAyUFcd5ckZrCVTjp2
        wF0PydNWzer0N6LdQk24Jx6iIBgSm9E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-R_BVpnwAOcOsVB4VW6xx7g-1; Fri, 17 Jul 2020 11:18:58 -0400
X-MC-Unique: R_BVpnwAOcOsVB4VW6xx7g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C3161015DA1;
        Fri, 17 Jul 2020 15:18:56 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9F927BD47;
        Fri, 17 Jul 2020 15:18:54 +0000 (UTC)
Date:   Fri, 17 Jul 2020 09:18:54 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Alex Xu <soulxu@gmail.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com,
        "Wang, Xin-ran" <xin-ran.wang@intel.com>, corbet@lwn.net,
        openstack-discuss <openstack-discuss@lists.openstack.org>,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>, eskultet@redhat.com,
        "Ding, Jian-feng" <jian-feng.ding@intel.com>,
        zhenyuw@linux.intel.com, "Xu, Hejie" <hejie.xu@intel.com>,
        bao.yumeng@zte.com.cn, Sean Mooney <smooney@redhat.com>,
        intel-gvt-dev@lists.freedesktop.org, cohuck@redhat.com,
        dinechin@redhat.com, devel@ovirt.org
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200717091854.72013c91@x1.home>
In-Reply-To: <CAH7mGatPWsczh_rbVhx4a+psJXvkZgKou3r5HrEQTqE7SqZkKA@mail.gmail.com>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
        <20200714102129.GD25187@redhat.com>
        <20200714101616.5d3a9e75@x1.home>
        <20200714171946.GL2728@work-vm>
        <20200714145948.17b95eb3@x1.home>
        <CAH7mGatPWsczh_rbVhx4a+psJXvkZgKou3r5HrEQTqE7SqZkKA@mail.gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Jul 2020 15:37:19 +0800
Alex Xu <soulxu@gmail.com> wrote:

> Alex Williamson <alex.williamson@redhat.com> =E4=BA=8E2020=E5=B9=B47=E6=
=9C=8815=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=885:00=E5=86=99=E9=81=
=93=EF=BC=9A
>=20
> > On Tue, 14 Jul 2020 18:19:46 +0100
> > "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> > =20
> > > * Alex Williamson (alex.williamson@redhat.com) wrote: =20
> > > > On Tue, 14 Jul 2020 11:21:29 +0100
> > > > Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:
> > > > =20
> > > > > On Tue, Jul 14, 2020 at 07:29:57AM +0800, Yan Zhao wrote: =20
> > > > > > hi folks,
> > > > > > we are defining a device migration compatibility interface that=
 =20
> > helps upper =20
> > > > > > layer stack like openstack/ovirt/libvirt to check if two device=
s =20
> > are =20
> > > > > > live migration compatible.
> > > > > > The "devices" here could be MDEVs, physical devices, or hybrid =
of =20
> > the two. =20
> > > > > > e.g. we could use it to check whether
> > > > > > - a src MDEV can migrate to a target MDEV,
> > > > > > - a src VF in SRIOV can migrate to a target VF in SRIOV,
> > > > > > - a src MDEV can migration to a target VF in SRIOV.
> > > > > >   (e.g. SIOV/SRIOV backward compatibility case)
> > > > > >
> > > > > > The upper layer stack could use this interface as the last step=
 to =20
> > check =20
> > > > > > if one device is able to migrate to another device before =20
> > triggering a real =20
> > > > > > live migration procedure.
> > > > > > we are not sure if this interface is of value or help to you. =
=20
> > please don't =20
> > > > > > hesitate to drop your valuable comments.
> > > > > >
> > > > > >
> > > > > > (1) interface definition
> > > > > > The interface is defined in below way:
> > > > > >
> > > > > >              __    userspace
> > > > > >               /\              \
> > > > > >              /                 \write
> > > > > >             / read              \
> > > > > >    ________/__________       ___\|/_____________
> > > > > >   | migration_version |     | migration_version |-->check migra=
tion
> > > > > >   ---------------------     ---------------------   compatibili=
ty
> > > > > >      device A                    device B
> > > > > >
> > > > > >
> > > > > > a device attribute named migration_version is defined under eac=
h =20
> > device's =20
> > > > > > sysfs node. e.g. =20
> > (/sys/bus/pci/devices/0000\:00\:02.0/$mdev_UUID/migration_version). =20
> > > > > > userspace tools read the migration_version as a string from the=
 =20
> > source device, =20
> > > > > > and write it to the migration_version sysfs attribute in the =20
> > target device. =20
> > > > > >
> > > > > > The userspace should treat ANY of below conditions as two devic=
es =20
> > not compatible: =20
> > > > > > - any one of the two devices does not have a migration_version =
=20
> > attribute =20
> > > > > > - error when reading from migration_version attribute of one de=
vice
> > > > > > - error when writing migration_version string of one device to
> > > > > >   migration_version attribute of the other device
> > > > > >
> > > > > > The string read from migration_version attribute is defined by =
=20
> > device vendor =20
> > > > > > driver and is completely opaque to the userspace.
> > > > > > for a Intel vGPU, string format can be defined like
> > > > > > "parent device PCI ID" + "version of gvt driver" + "mdev type" =
+ =20
> > "aggregator count". =20
> > > > > >
> > > > > > for an NVMe VF connecting to a remote storage. it could be
> > > > > > "PCI ID" + "driver version" + "configured remote storage URL"
> > > > > >
> > > > > > for a QAT VF, it may be
> > > > > > "PCI ID" + "driver version" + "supported encryption set".
> > > > > >
> > > > > > (to avoid namespace confliction from each vendor, we may prefix=
 a =20
> > driver name to =20
> > > > > > each migration_version string. e.g. =20
> > i915-v1-8086-591d-i915-GVTg_V5_8-1) =20
> > > >
> > > > It's very strange to define it as opaque and then proceed to descri=
be
> > > > the contents of that opaque string.  The point is that its contents
> > > > are defined by the vendor driver to describe the device, driver =20
> > version, =20
> > > > and possibly metadata about the configuration of the device.  One
> > > > instance of a device might generate a different string from another.
> > > > The string that a device produces is not necessarily the only string
> > > > the vendor driver will accept, for example the driver might support
> > > > backwards compatible migrations. =20
> > >
> > > (As I've said in the previous discussion, off one of the patch series)
> > >
> > > My view is it makes sense to have a half-way house on the opaqueness =
of
> > > this string; I'd expect to have an ID and version that are human
> > > readable, maybe a device ID/name that's human interpretable and then a
> > > bunch of other cruft that maybe device/vendor/version specific.
> > >
> > > I'm thinking that we want to be able to report problems and include t=
he
> > > string and the user to be able to easily identify the device that was
> > > complaining and notice a difference in versions, and perhaps also use
> > > it in compatibility patterns to find compatible hosts; but that does
> > > get tricky when it's a 'ask the device if it's compatible'. =20
> >
> > In the reply I just sent to Dan, I gave this example of what a
> > "compatibility string" might look like represented as json:
> >
> > {
> >   "device_api": "vfio-pci",
> >   "vendor": "vendor-driver-name",
> >   "version": {
> >     "major": 0,
> >     "minor": 1
> >   },
> > =20
>=20
> The OpenStack Placement service doesn't support to filtering the target
> host by the semver syntax, altough we can code this filtering logic inside
> scheduler filtering by python code. Basically, placement only supports
> filtering the host by traits (it is same thing with labels, tags). The no=
va
> scheduler will call the placement service to filter the hosts first, then
> go through all the scheduler filters. That would be great if the placement
> service can filter out more hosts which isn't compatible first, and then =
it
> is better.
>=20
>=20
> >   "vfio-pci": { // Based on above device_api
> >     "vendor": 0x1234, // Values for the exposed device
> >     "device": 0x5678,
> >       // Possibly further parameters for a more specific match
> >   },
> > =20
>=20
> OpenStack already based on vendor and device id to separate the devices
> into the different resource pool, then the scheduler based on that to fil=
er
> the hosts, so I think it needn't be the part of this compatibility string.


This is the part of the string that actually says what the resulting
device is, so it's a rather fundamental part of the description.  This
is where we'd determine that a physical to mdev migration is possible
or that different mdev types result in the same guest PCI device,
possibly with attributes set as specified later in the output.


> >   "mdev_attrs": [
> >     { "attribute0": "VALUE" }
> >   ]
> > }
> >
> > Are you thinking that we might allow the vendor to include a vendor
> > specific array where we'd simply require that both sides have matching
> > fields and values?  ie.


That's what I'm defining in the below vendor_fields, the above
mdev_attrs would be specifying attributes of the device that must be
set in order to create the device with the compatibility described.
For example if we're describing compatibility for type foo-1, which is
a base type that can be equivalent to type foo-3 if type foo-1 is
created with aggregation=3D3, this is where that would be defined.
Thanks,

Alex

> >   "vendor_fields": [
> >     { "unknown_field0": "unknown_value0" },
> >     { "unknown_field1": "unknown_value1" },
> >   ]
> > =20
>=20
> Since the placement support traits (labels, tags), so the placement just =
to
> matching those fields, so it isn't problem of openstack, since openstack
> needn't to know the meaning of those fields. But the traits is just a
> label, it isn't key-value format. But also if we have to, we can code this
> scheduler filter by python code. But the same thing as above, the invalid
> host can't be filtered out in the first step placement service filtering.
>=20
>=20
> > We could certainly make that part of the spec, but I can't really
> > figure the value of it other than to severely restrict compatibility,
> > which the vendor could already do via the version.major value.  Maybe
> > they'd want to put a build timestamp, random uuid, or source sha1 into
> > such a field to make absolutely certain compatibility is only determined
> > between identical builds?  Thanks,
> >
> > Alex
> >
> > =20

