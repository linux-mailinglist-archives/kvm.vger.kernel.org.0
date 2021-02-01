Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709B930ADE2
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 18:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhBARb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 12:31:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44295 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232005AbhBARbM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 12:31:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612200584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cPLth25xiKH+71gcG9JvBxA1Cjds+f4mqnwUM89x7lw=;
        b=OFIvEpc3CQgwjzQAkcN5jOHD79hUBgw/cBaFqyjrXfLwW0fAh/VY0Ed9j8T/yZmknYf1J4
        4VyxVkC4Sal9uMBPJfKCXkAGwvKuRAF5Jp5gDFX2nxwkTH81QwqpAN2j7tNQXonmqQu+9/
        8kgKfgFLQdJqQwQKAydYML/2repKKrA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-F3oYr9W9NeSKpSsuM-JGhA-1; Mon, 01 Feb 2021 12:29:40 -0500
X-MC-Unique: F3oYr9W9NeSKpSsuM-JGhA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBBB21800D41;
        Mon,  1 Feb 2021 17:29:36 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99FEE648A8;
        Mon,  1 Feb 2021 17:29:35 +0000 (UTC)
Date:   Mon, 1 Feb 2021 10:29:34 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210201102934.354ad5df@omen.home.shazbot.org>
In-Reply-To: <44999661-5e15-deca-be22-545163d79919@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
        <20210122122503.4e492b96@omen.home.shazbot.org>
        <20210122200421.GH4147@nvidia.com>
        <20210125172035.3b61b91b.cohuck@redhat.com>
        <20210125180440.GR4147@nvidia.com>
        <20210125163151.5e0aeecb@omen.home.shazbot.org>
        <20210126004522.GD4147@nvidia.com>
        <20210125203429.587c20fd@x1.home.shazbot.org>
        <1419014f-fad2-9599-d382-9bba7686f1c4@nvidia.com>
        <20210128172930.74baff41.cohuck@redhat.com>
        <20210128140256.178d3912@omen.home.shazbot.org>
        <536caa01-7fef-7256-b281-03b40a6ca217@nvidia.com>
        <20210131213228.0e0573f4@x1.home.shazbot.org>
        <44999661-5e15-deca-be22-545163d79919@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 1 Feb 2021 11:40:45 +0200
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> On 2/1/2021 6:32 AM, Alex Williamson wrote:
> > On Sun, 31 Jan 2021 20:46:40 +0200
> > Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> > =20
> >> On 1/28/2021 11:02 PM, Alex Williamson wrote: =20
> >>> On Thu, 28 Jan 2021 17:29:30 +0100
> >>> Cornelia Huck <cohuck@redhat.com> wrote:
> >>>    =20
> >>>> On Tue, 26 Jan 2021 15:27:43 +0200
> >>>> Max Gurtovoy <mgurtovoy@nvidia.com> wrote: =20
> >>>>> On 1/26/2021 5:34 AM, Alex Williamson wrote: =20
> >>>>>> On Mon, 25 Jan 2021 20:45:22 -0400
> >>>>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
> >>>>>>         =20
> >>>>>>> On Mon, Jan 25, 2021 at 04:31:51PM -0700, Alex Williamson wrote: =
=20
> >>>>>>>> extensions potentially break vendor drivers, etc.  We're only ev=
en hand
> >>>>>>>> waving that existing device specific support could be farmed out=
 to new
> >>>>>>>> device specific drivers without even going to the effort to prov=
e that. =20
> >>>>>>> This is a RFC, not a complete patch series. The RFC is to get fee=
dback
> >>>>>>> on the general design before everyone comits alot of resources and
> >>>>>>> positions get dug in.
> >>>>>>>
> >>>>>>> Do you really think the existing device specific support would be=
 a
> >>>>>>> problem to lift? It already looks pretty clean with the
> >>>>>>> vfio_pci_regops, looks easy enough to lift to the parent.
> >>>>>>>         =20
> >>>>>>>> So far the TODOs rather mask the dirty little secrets of the
> >>>>>>>> extension rather than showing how a vendor derived driver needs =
to
> >>>>>>>> root around in struct vfio_pci_device to do something useful, so
> >>>>>>>> probably porting actual device specific support rather than furt=
her
> >>>>>>>> hand waving would be more helpful. =20
> >>>>>>> It would be helpful to get actual feedback on the high level desi=
gn -
> >>>>>>> someting like this was already tried in May and didn't go anywher=
e -
> >>>>>>> are you surprised that we are reluctant to commit alot of resourc=
es
> >>>>>>> doing a complete job just to have it go nowhere again? =20
> >>>>>> That's not really what I'm getting from your feedback, indicating
> >>>>>> vfio-pci is essentially done, the mlx stub driver should be enough=
 to
> >>>>>> see the direction, and additional concerns can be handled with TODO
> >>>>>> comments.  Sorry if this is not construed as actual feedback, I th=
ink
> >>>>>> both Connie and I are making an effort to understand this and being
> >>>>>> hampered by lack of a clear api or a vendor driver that's anything=
 more
> >>>>>> than vfio-pci plus an aux bus interface.  Thanks, =20
> >>>>> I think I got the main idea and I'll try to summarize it:
> >>>>>
> >>>>> The separation to vfio-pci.ko and vfio-pci-core.ko is acceptable, a=
nd we
> >>>>> do need it to be able to create vendor-vfio-pci.ko driver in the fu=
ture
> >>>>> to include vendor special souse inside. =20
> >>>> One other thing I'd like to bring up: What needs to be done in
> >>>> userspace? Does a userspace driver like QEMU need changes to actually
> >>>> exploit this? Does management software like libvirt need to be invol=
ved
> >>>> in decision making, or does it just need to provide the knobs to make
> >>>> the driver configurable? =20
> >>> I'm still pretty nervous about the userspace aspect of this as well.
> >>> QEMU and other actual vfio drivers are probably the least affected,
> >>> at least for QEMU, it'll happily open any device that has a pointer to
> >>> an IOMMU group that's reflected as a vfio group device.  Tools like
> >>> libvirt, on the other hand, actually do driver binding and we need to
> >>> consider how they make driver decisions. Jason suggested that the
> >>> vfio-pci driver ought to be only spec compliant behavior, which sounds
> >>> like some deprecation process of splitting out the IGD, NVLink, zpci,
> >>> etc. features into sub-drivers and eventually removing that device
> >>> specific support from vfio-pci.  Would we expect libvirt to know, "th=
is
> >>> is an 8086 graphics device, try to bind it to vfio-pci-igd" or "uname
> >>> -m says we're running on s390, try to bind it to vfio-zpci"?  Maybe we
> >>> expect derived drivers to only bind to devices they recognize, so
> >>> libvirt could blindly try a whole chain of drivers, ending in vfio-pc=
i.
> >>> Obviously if we have competing drivers that support the same device in
> >>> different ways, that quickly falls apart. =20
> >> I think we can leave common arch specific stuff, such as s390 (IIUC) in
> >> the core driver. And only create vfio_pci drivers for
> >> vendor/device/subvendor specific stuff. =20
> > So on one hand you're telling us that the design principles here can be
> > applied to various other device/platform specific support, but on the
> > other you're saying, but don't do that... =20
>=20
> I guess I was looking at nvlink2 as device specific.

It's device specific w/ platform dependencies as I see it.

> But let's update the nvlink2, s390 and IGD a bit:
>=20
> 1. s390 -=C2=A0 config VFIO_PCI_ZDEV rename to config VFIO_PCI_S390 (it w=
ill=20
> include all needed tweeks for S390)
>=20
> 2. nvlink2 - config VFIO_PCI_NVLINK2 rename to config VFIO_PCI_P9 (it=20
> will include all needed tweeks for P9)
>=20
> 3. igd - config VFIO_PCI_IGD rename to config VFIO_PCI_X86 (it will=20
> include all needed tweeks for X86)
>=20
> All the 3 stays in the vfio-pci-core.ko since we might need S390 stuff=20
> if we plug Network adapter from vendor-A or=C2=A0 NVMe adapter from vendo=
r-B=20
> for example. This is platform specific and we don't want to duplicate it=
=20
> in each vendor driver.
>=20
> Same for P9 (and nvlink2 is only a special case in there) and X86.

I'm not a fan of this, you're essentially avoiding the issue by turning
everything into an architecture specific version of the driver.  That
takes us down a path where everything gets added to vfio-pci-core with
a bunch of Kconfig switches, which seems to be exactly the opposite
direction of creating a core module as a library for derived device
and/or platform specific modules.  This also appears to be the opposite
of Jason's suggestion that vfio-pci become a pure PCI spec module
without various device/vendor quirks.

> >> Also, the competing drivers issue can also happen today, right ? after
> >> adding new_id to vfio_pci I don't know how linux will behave if we'll
> >> plug new device with same id to the system. which driver will probe it=
 ? =20
> > new_id is non-deterministic, that's why we have driver_override. =20
>=20
> I'm not sure I understand how driver_override help in the competition ?
>=20
> it's only enforce driver binding to a device.
>=20
> if we have device AAA0 that is driven by aaa.ko and we add AAA as new_id=
=20
> to vfio_pci and afterwards we plug AAA1 that is also driven by aaa.ko=20
> and can be driven by vfio_pci.ko. what will happen ? will it be the=20
> wanted behavior always ?

I think with AAA vs AAA0 and AAA1 you're suggesting a wildcard in
new_id where both the aaa.ko driver and vfio-pci.ko (once the wildcard
is added) could bind to the device.  At that point, which driver gets
first shot at a compatible device depends on the driver load order, ie.
if the aaa.ko module was loaded before vfio-pci.ko, it might win.  If
an event happens that causes the competing driver to be loaded between
setting a new_id and binding the device to the driver, that competing
module load could claim the device instead.  driver_override helps by
allowing the user to define that a device will match a driver rather
than a driver matching a device.  The user can write a driver name to
the driver_override of the device such that that device can only be
bound to the specified driver.

> We will have a competition in any case in the current linux design. Only=
=20
> now we add new players to the competition.
>=20
> how does libvirt use driver_override ?

Libvirt would write "vfio-pci" to the driver_override attribute for a
device such that when an unbind and drivers_probe occurs, that device
can only be bound to vfio-pci.  There is no longer a race with another
driver nor is there non-determinism based on module load order.
=20
> and why will it change in case of vendor specific vfio-pci driver ?

Libvirt needs to know *what* driver to set as the vendor_override, so
if we had vfio-pci, vfio-pci-zdev, vfio-zpci-ism, vfio-pci-igd,
vfio-pci-ppc-nvlink, etc., how does libvirt decide which driver it
should use?  The drivers themselves cannot populate their match ids or
else we get into the problem above where for example vfio-pci-igd could
possibly claim the Intel graphics device before i915 depending on the
module load order, which would be a support issue.

> >> I don't really afraid of competing drivers since we can ask from vendor
> >> vfio pci_drivers to add vendor_id, device_id, subsystem_vendor and
> >> subsystem_device so we won't have this problem. I don't think that the=
re
> >> will be 2 drivers that drive the same device with these 4 ids.
> >>
> >> Userspace tool can have a map of ids to drivers and bind the device to
> >> the right vfio-pci vendor driver if it has one. if not, bind to vfio_p=
ci.ko. =20
> > As I've outlined, the support is not really per device, there might be
> > a preferred default driver for the platform, ex. s390.
> > =20
> >>> Libvirt could also expand its available driver models for the user to
> >>> specify a variant, I'd support that for overriding a choice that libv=
irt
> >>> might make otherwise, but forcing the user to know this information is
> >>> just passing the buck. =20
> >> We can add a code to libvirt as mentioned above. =20
> > That's rather the question here, what is that algorithm by which a
> > userspace tool such as libvirt would determine the optimal driver for a
> > device? =20
>=20
> If exist, the optimal driver is the vendor driver according to mapping=20
> of device_id + vendor_id + subsystem_device + subsystem_vendor to=20
> vendor-vfio-pci.ko.

And how is that mapping done?  The only sane way would be depmod, but
that implies that vendor-vfio-pci.ko fills the ids table for that
device, which can only happen for devices that have no competing host
driver.  For example, how would Intel go about creating their vendor
vfio-pci module that can bind to and xl710 VF that wouldn't create
competition and non-determinism in module loading vs the existing
iavf.ko module?  This only works with your aux bus based driver, but
that's also the only vfio-pci derived driver proposed that can take
advantage of that approach.

> If not, bind to vfio-pci.ko.
>=20
> Platform specific stuff will be handled in vfio-pci-core.ko and not in a=
=20
> vendor driver. vendor drivers are for PCI devices and not platform tweeks.

I don't think that's the correct, or a sustainable approach.  vfio-pci
will necessarily make use of platform access functions, but trying to
loop in devices that have platform dependencies as platform extensions
of vfio-pci-core rather than vendor extensions for a device seems wrong
to me.
=20
> >>> Some derived drivers could probably actually include device IDs rather
> >>> than only relying on dynamic ids, but then we get into the problem th=
at
> >>> we're competing with native host driver for a device.  The aux bus
> >>> example here is essentially the least troublesome variation since it
> >>> works in conjunction with the native host driver rather than replacing
> >>> it.  Thanks, =20
> >> same competition after we add new_id to vfio_pci, right ? =20
> > new_id is already superseded by driver_override to avoid the ambiguity,
> > but to which driver does a userspace tool like libvirt define as the
> > ultimate target driver for a device and how? =20
>=20
> it will have a lookup table as mentioned above.

So the expectation is that each user application that manages binding
devices to vfio-pci derived drivers will have a lookup table that's
manually managed to provide an optimal device to driver mapping?
That's terrible.  Thanks,

Alex

