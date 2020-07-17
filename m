Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C61B224322
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 20:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgGQSap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 14:30:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34588 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726322AbgGQSap (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 14:30:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595010642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bFzNjvAF3MFfFTPXvtNZCYbvSi/p9PLzagDCtp1PoN0=;
        b=MLdUMyHzzFQ3JulZf7FFZBXTdoZpvbCXY0BKtLJdq+QCB/nPCCZHepxVhaystowF/bWP6+
        mvdjRVdSlssbitF/h8OHybhkkPAYwzgNdzjq2C5MXtprcS280m1McQkk0RZYcYQrWLVorm
        +bFm4r3jZdXpbjbSSmT+OkGU+zef3OU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-CgVIH5kTNBSvpUwoS3RLYA-1; Fri, 17 Jul 2020 14:30:37 -0400
X-MC-Unique: CgVIH5kTNBSvpUwoS3RLYA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E86DF1B18BC3;
        Fri, 17 Jul 2020 18:30:34 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E6ABB60E3E;
        Fri, 17 Jul 2020 18:30:26 +0000 (UTC)
Date:   Fri, 17 Jul 2020 12:30:26 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        devel@ovirt.org, openstack-discuss@lists.openstack.org,
        libvir-list@redhat.com, intel-gvt-dev@lists.freedesktop.org,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, smooney@redhat.com,
        eskultet@redhat.com, cohuck@redhat.com, dinechin@redhat.com,
        corbet@lwn.net, kwankhede@nvidia.com, eauger@redhat.com,
        jian-feng.ding@intel.com, hejie.xu@intel.com, kevin.tian@intel.com,
        zhenyuw@linux.intel.com, bao.yumeng@zte.com.cn,
        xin-ran.wang@intel.com, shaohe.feng@intel.com
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200717123026.6ab26442@x1.home>
In-Reply-To: <20200717180344.GD3294@work-vm>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
        <20200714102129.GD25187@redhat.com>
        <20200714101616.5d3a9e75@x1.home>
        <20200714171946.GL2728@work-vm>
        <20200714145948.17b95eb3@x1.home>
        <20200715082040.GA13136@joy-OptiPlex-7040>
        <20200717085935.224ffd46@x1.home>
        <20200717180344.GD3294@work-vm>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Jul 2020 19:03:44 +0100
"Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:

> * Alex Williamson (alex.williamson@redhat.com) wrote:
> > On Wed, 15 Jul 2020 16:20:41 +0800
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >  =20
> > > On Tue, Jul 14, 2020 at 02:59:48PM -0600, Alex Williamson wrote: =20
> > > > On Tue, 14 Jul 2020 18:19:46 +0100
> > > > "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> > > >    =20
> > > > > * Alex Williamson (alex.williamson@redhat.com) wrote:   =20
> > > > > > On Tue, 14 Jul 2020 11:21:29 +0100
> > > > > > Daniel P. Berrang=C3=83=C2=A9 <berrange@redhat.com> wrote:
> > > > > >      =20
> > > > > > > On Tue, Jul 14, 2020 at 07:29:57AM +0800, Yan Zhao wrote:    =
 =20
> > > > > > > > hi folks,
> > > > > > > > we are defining a device migration compatibility interface =
that helps upper
> > > > > > > > layer stack like openstack/ovirt/libvirt to check if two de=
vices are
> > > > > > > > live migration compatible.
> > > > > > > > The "devices" here could be MDEVs, physical devices, or hyb=
rid of the two.
> > > > > > > > e.g. we could use it to check whether
> > > > > > > > - a src MDEV can migrate to a target MDEV,
> > > > > > > > - a src VF in SRIOV can migrate to a target VF in SRIOV,
> > > > > > > > - a src MDEV can migration to a target VF in SRIOV.
> > > > > > > >   (e.g. SIOV/SRIOV backward compatibility case)
> > > > > > > >=20
> > > > > > > > The upper layer stack could use this interface as the last =
step to check
> > > > > > > > if one device is able to migrate to another device before t=
riggering a real
> > > > > > > > live migration procedure.
> > > > > > > > we are not sure if this interface is of value or help to yo=
u. please don't
> > > > > > > > hesitate to drop your valuable comments.
> > > > > > > >=20
> > > > > > > >=20
> > > > > > > > (1) interface definition
> > > > > > > > The interface is defined in below way:
> > > > > > > >=20
> > > > > > > >              __    userspace
> > > > > > > >               /\              \
> > > > > > > >              /                 \write
> > > > > > > >             / read              \
> > > > > > > >    ________/__________       ___\|/_____________
> > > > > > > >   | migration_version |     | migration_version |-->check m=
igration
> > > > > > > >   ---------------------     ---------------------   compati=
bility
> > > > > > > >      device A                    device B
> > > > > > > >=20
> > > > > > > >=20
> > > > > > > > a device attribute named migration_version is defined under=
 each device's
> > > > > > > > sysfs node. e.g. (/sys/bus/pci/devices/0000\:00\:02.0/$mdev=
_UUID/migration_version).
> > > > > > > > userspace tools read the migration_version as a string from=
 the source device,
> > > > > > > > and write it to the migration_version sysfs attribute in th=
e target device.
> > > > > > > >=20
> > > > > > > > The userspace should treat ANY of below conditions as two d=
evices not compatible:
> > > > > > > > - any one of the two devices does not have a migration_vers=
ion attribute
> > > > > > > > - error when reading from migration_version attribute of on=
e device
> > > > > > > > - error when writing migration_version string of one device=
 to
> > > > > > > >   migration_version attribute of the other device
> > > > > > > >=20
> > > > > > > > The string read from migration_version attribute is defined=
 by device vendor
> > > > > > > > driver and is completely opaque to the userspace.
> > > > > > > > for a Intel vGPU, string format can be defined like
> > > > > > > > "parent device PCI ID" + "version of gvt driver" + "mdev ty=
pe" + "aggregator count".
> > > > > > > >=20
> > > > > > > > for an NVMe VF connecting to a remote storage. it could be
> > > > > > > > "PCI ID" + "driver version" + "configured remote storage UR=
L"
> > > > > > > >=20
> > > > > > > > for a QAT VF, it may be
> > > > > > > > "PCI ID" + "driver version" + "supported encryption set".
> > > > > > > >=20
> > > > > > > > (to avoid namespace confliction from each vendor, we may pr=
efix a driver name to
> > > > > > > > each migration_version string. e.g. i915-v1-8086-591d-i915-=
GVTg_V5_8-1)     =20
> > > > > >=20
> > > > > > It's very strange to define it as opaque and then proceed to de=
scribe
> > > > > > the contents of that opaque string.  The point is that its cont=
ents
> > > > > > are defined by the vendor driver to describe the device, driver=
 version,
> > > > > > and possibly metadata about the configuration of the device.  O=
ne
> > > > > > instance of a device might generate a different string from ano=
ther.
> > > > > > The string that a device produces is not necessarily the only s=
tring
> > > > > > the vendor driver will accept, for example the driver might sup=
port
> > > > > > backwards compatible migrations.     =20
> > > > >=20
> > > > > (As I've said in the previous discussion, off one of the patch se=
ries)
> > > > >=20
> > > > > My view is it makes sense to have a half-way house on the opaquen=
ess of
> > > > > this string; I'd expect to have an ID and version that are human
> > > > > readable, maybe a device ID/name that's human interpretable and t=
hen a
> > > > > bunch of other cruft that maybe device/vendor/version specific.
> > > > >=20
> > > > > I'm thinking that we want to be able to report problems and inclu=
de the
> > > > > string and the user to be able to easily identify the device that=
 was
> > > > > complaining and notice a difference in versions, and perhaps also=
 use
> > > > > it in compatibility patterns to find compatible hosts; but that d=
oes
> > > > > get tricky when it's a 'ask the device if it's compatible'.   =20
> > > >=20
> > > > In the reply I just sent to Dan, I gave this example of what a
> > > > "compatibility string" might look like represented as json:
> > > >=20
> > > > {
> > > >   "device_api": "vfio-pci",
> > > >   "vendor": "vendor-driver-name",
> > > >   "version": {
> > > >     "major": 0,
> > > >     "minor": 1
> > > >   },
> > > >   "vfio-pci": { // Based on above device_api
> > > >     "vendor": 0x1234, // Values for the exposed device
> > > >     "device": 0x5678,
> > > >       // Possibly further parameters for a more specific match
> > > >   },
> > > >   "mdev_attrs": [
> > > >     { "attribute0": "VALUE" }
> > > >   ]
> > > > }
> > > >=20
> > > > Are you thinking that we might allow the vendor to include a vendor
> > > > specific array where we'd simply require that both sides have match=
ing
> > > > fields and values?  ie.
> > > >=20
> > > >   "vendor_fields": [
> > > >     { "unknown_field0": "unknown_value0" },
> > > >     { "unknown_field1": "unknown_value1" },
> > > >   ]
> > > >=20
> > > > We could certainly make that part of the spec, but I can't really
> > > > figure the value of it other than to severely restrict compatibilit=
y,
> > > > which the vendor could already do via the version.major value.  May=
be
> > > > they'd want to put a build timestamp, random uuid, or source sha1 i=
nto
> > > > such a field to make absolutely certain compatibility is only deter=
mined
> > > > between identical builds?  Thanks,
> > > >   =20
> > > Yes, I agree kernel could expose such sysfs interface to educate
> > > openstack how to filter out devices. But I still think the proposed
> > > migration_version (or rename to migration_compatibility) interface is
> > > still required for libvirt to do double check.
> > >=20
> > > In the following scenario:=20
> > > 1. openstack chooses the target device by reading sysfs interface (of=
 json
> > > format) of the source device. And Openstack are now pretty sure the t=
wo
> > > devices are migration compatible.
> > > 2. openstack asks libvirt to create the target VM with the target dev=
ice
> > > and start live migration.
> > > 3. libvirt now receives the request. so it now has two choices:
> > > (1) create the target VM & target device and start live migration dir=
ectly
> > > (2) double check if the target device is compatible with the source
> > > device before doing the remaining tasks.
> > >=20
> > > Because the factors to determine whether two devices are live migrati=
on
> > > compatible are complicated and may be dynamically changing, (e.g. dri=
ver
> > > upgrade or configuration changes), and also because libvirt should not
> > > totally rely on the input from openstack, I think the cost for libvir=
t is
> > > relatively lower if it chooses to go (2) than (1). At least it has no
> > > need to cancel migration and destroy the VM if it knows it earlier.
> > >=20
> > > So, it means the kernel may need to expose two parallel interfaces:
> > > (1) with json format, enumerating all possible fields and comparing
> > > methods, so as to indicate openstack how to find a matching target de=
vice
> > > (2) an opaque driver defined string, requiring write and test in targ=
et,
> > > which is used by libvirt to make sure device compatibility, rather th=
an
> > > rely on the input accurateness from openstack or rely on kernel driver
> > > implementing the compatibility detection immediately after migration
> > > start.
> > >=20
> > > Does it make sense? =20
> >=20
> > No, libvirt is not responsible for the success or failure of the
> > migration, it's the vendor driver's responsibility to encode
> > compatibility information early in the migration stream and error
> > should the incoming device prove to be incompatible.  It's not
> > libvirt's job to second guess the management engine and I would not
> > support a duplicate interface only for that purpose.  Thanks, =20
>=20
> libvirt does try to enforce it for other things; trying to stop a bad
> migration from starting.

Even if libvirt did want to verify why would we want to support a
separate opaque interface for that purpose versus a parse-able
interface?  If we get different results, we've failed.  Thanks,

Alex

