Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA7BB5F535
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 11:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfGDJLF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 4 Jul 2019 05:11:05 -0400
Received: from mga04.intel.com ([192.55.52.120]:35891 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726993AbfGDJLF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 05:11:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jul 2019 02:11:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,450,1557212400"; 
   d="scan'208";a="363302601"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga006.fm.intel.com with ESMTP; 04 Jul 2019 02:11:05 -0700
Received: from fmsmsx114.amr.corp.intel.com (10.18.116.8) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 4 Jul 2019 02:11:04 -0700
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 FMSMSX114.amr.corp.intel.com (10.18.116.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 4 Jul 2019 02:11:03 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.110]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.109]) with mapi id 14.03.0439.000;
 Thu, 4 Jul 2019 17:11:02 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: RE: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
Thread-Topic: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
Thread-Index: AQHVHsiVLTtm/WvGlEKSmQ2lKcl2F6ajfRGAgAC0NOCAAGOFgIABGcaQgAAh3QCABKzV8IAGRYaAgAfjTqCAAB3wAIABIjgQ
Date:   Thu, 4 Jul 2019 09:11:02 +0000
Message-ID: <A2975661238FB949B60364EF0F2C257439F1FF4E@SHSMSX104.ccr.corp.intel.com>
References: <1560000071-3543-1-git-send-email-yi.l.liu@intel.com>
        <1560000071-3543-10-git-send-email-yi.l.liu@intel.com>
        <20190619222647.72efc76a@x1.home>
        <A2975661238FB949B60364EF0F2C257439F0164E@SHSMSX104.ccr.corp.intel.com>
        <20190620150757.7b2fa405@x1.home>
        <A2975661238FB949B60364EF0F2C257439F02663@SHSMSX104.ccr.corp.intel.com>
        <20190621095740.41e6e98e@x1.home>
        <A2975661238FB949B60364EF0F2C257439F05415@SHSMSX104.ccr.corp.intel.com>
        <20190628090741.51e8d18e@x1.home>
        <A2975661238FB949B60364EF0F2C257439F1E9EC@SHSMSX104.ccr.corp.intel.com>
 <20190703112212.146ac71c@x1.home>
In-Reply-To: <20190703112212.146ac71c@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYThlMTYyM2ItODlhMS00ODllLThmZjUtOWZkYzJiY2EwNDJjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidDk1NUE1dGx5MUFVVkNHemZQZ0VFNFZQKzVEM3ZITmxscVQraUdjWWJTaGp6dGplaUZSVWVKSXlVZEs1TUY1UCJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Thursday, July 4, 2019 1:22 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> 
> On Wed, 3 Jul 2019 08:25:25 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > Hi Alex,
> >
> > Thanks for the comments. Have four inline responses below. And one
> > of them need your further help. :-)

[...]

> > > > >
> > > > > > > > > used iommu_attach_device() rather than iommu_attach_group()
> > > > > > > > > for non-aux mdev iommu_device.  Is there a requirement that
> > > > > > > > > the mdev parent device is in a singleton iommu group?
> > > > > > > >
> > > > > > > > I don't think there should have such limitation. Per my
> > > > > > > > understanding, vfio-mdev-pci should also be able to bind to
> > > > > > > > devices which shares iommu group with other devices. vfio-pci works
> well
> > > for such devices.
> > > > > > > > And since the two drivers share most of the codes, I think
> > > > > > > > vfio-mdev-pci should naturally support it as well.
> > > > > > >
> > > > > > > Yes, the difference though is that vfio.c knows when devices are
> > > > > > > in the same group, which mdev vfio.c only knows about the
> > > > > > > non-iommu backed group, not the group that is actually used for
> > > > > > > the iommu backing.  So we either need to enlighten vfio.c or
> > > > > > > further abstract those details in vfio_iommu_type1.c.
> > > > > >
> > > > > > Not sure if it is necessary to introduce more changes to vfio.c or
> > > > > > vfio_iommu_type1.c. If it's only for the scenario which two
> > > > > > devices share an iommu_group, I guess it could be supported by
> > > > > > using __iommu_attach_device() which has no device counting for the
> > > > > > group. But maybe I missed something here. It would be great if you
> > > > > > can elaborate a bit for it. :-)
> > > > >
> > > > > We need to use the group semantics, there's a reason
> > > > > __iommu_attach_device() is not exposed, it's an internal helper.  I
> > > > > think there's no way around that we need to somewhere track the
> > > > > actual group we're attaching to and have the smarts to re-use it for
> > > > > other devices in the same group.
> > > >
> > > > Hmmm, exposing __iommu_attach_device() is not good, let's forget it.
> > > > :-)
> > > >
> > > > > > > > > If this is a simplification, then vfio-mdev-pci should not
> > > > > > > > > bind to devices where this is violated since there's no way
> > > > > > > > > to use the device.  Can we support it though?
> > > > > > > >
> > > > > > > > yeah, I think we need to support it.
> >
> > I've already made vfio-mdev-pci driver work for non-singleton iommu
> > group. e.g. for devices in a single iommu group, I can bind the devices
> > to eithervfio-pci or vfio-mdev-pci and then passthru them to a VM. And
> > it will fail if user tries to passthru a vfio-mdev-pci device via vfio-pci
> > manner "-device vfio-pci,host=01:00.1". In other words, vfio-mdev-pci
> > device can only passthru via
> > "-device vfio-pci,sysfsdev=/sys/bus/mdev/devices/UUID". This is what
> > we expect.
> >
> > However, I encountered a problem when trying to prevent user from
> > passthru these devices to different VMs. I've tried in my side, and I
> > can passthru vfio-pci device and vfio-mdev-pci device to different
> > VMs. But actually this operation should be failed. If all the devices
> > are bound to vfio-pci, Qemu will open iommu backed group. So
> > Qemu can check if a given group has already been used by an
> > AddressSpace (a.ka. VM) in vfio_get_group() thus to prevent
> > user from passthru these devices to different VMs if the devices
> > are in the same iommu backed group. However, here for a
> > vfio-mdev-pci device, it has a new group and group ID, Qemu
> > will not be able to detect if the other devices (share iommu group
> > with vfio-mdev-pci device) are passthru to existing VMs. This is the
> > major problem for vfio-mdev-pci to support non-singleton group
> > in my side now. Even all devices are bound to vfio-mdev-pci driver,
> > Qemu is still unable to check since all the vfio-mdev-pci devices
> > have a separate mdev group.
> >
> > To fix it, may need Qemu to do more things. E.g. If it tries to use a
> > non-singleton iommu backed group, it needs to check if any mdev
> > group is created and used by an existing VM. Also it needs check if
> > iommu backed group is passthru to an existing VM when trying to
> > use a mdev group. For singleton iommu backed group and
> > aux-domain enabled physical device, still allow to passthru mdev
> > group to different VMs. To achieve these checks, Qemu may need
> > to have knowledge whether a group is iommu backed and singleton
> > or not. Do you think it is good to expose such info to userspace? or
> > any other idea? :-)
> 
> QEMU is never responsible for isolating a group, QEMU is just a
> userspace driver, it's vfio's responsibility to prevent the user from
> splitting groups in ways that are not allowed.  QEMU does not know the

yep, also my concern.

> true group association, it only knows the "virtual" group of the mdev
> device.  QEMU will create a container and add the mdev virtual group to
> the container.  In the kernel, the type1 backend should actually do an
> iommu_attach_group(), attaching the iommu_device group to the domain.
> When QEMU processes the next device, it will have a different group,
> but (assuming no vIOMMU) it will try to attach it to the same
> container, which should work because the iommu_device group backing the
> mdev virtual group is already attached to this domain.
> If we had two separate QEMU processes, each with an mdev device from a
> common group at the iommu_device level, the type1 backend should fail
> to attach the group to the container for the later caller.  I'd think
> this should fail at the iommu_attach_group() call since the group we're
> trying to attach is already attached to another domain.

Agree with you. At first, I want to fail it in similar way with vfio-pci devices.
For vfio-pci devices from a common group, vfio will fail the operation around
/dev/vfio/group_id open if user tries to assign the vfio-pci devices from common
group to multiple QEMU processes. Meanwhile, QEMU will avoid to open a
/dev/vfio/group_id multiple times, so current vfio/QEMU works well for 
non- singleton group (no vIOMMU). Unfortunately, looks like we have no way
to fail vfio-mdev-pci devices in similar mechanism as each mdev has a separate
group. So yes, I agree with you that we may fail it around the group attach
phase. Below is my draft idea:

In vfio_iommu_type1_attach_group(), we need to do the following checks.

if (mdev_group) {
	if (iommu_device group enabled aux-domain) {
		/*
		  * iommu_group enabled aux-domain means the iommu_devices
		  * in this group are aux-domain enabled. e.g. SIOV capable devices.
		  * Also, I think for aux-domain enabled group, it essentially means
		  * the group is a singleton group as SIOV capable devices require
		  * to be in a singleton group.
		  */
		 iommu_aux_attach_device();
	} else {
		/*
		  * needs to check the group->opened in vfio.c. Just like what
		  * vfio_group_fopen() does. May be a new VFIO interface required
		  * here since the group->opened is within vfio.c.
		  * vfio_iommu_device_group_opened_inc() will inc group->opened, so
		  * that other VM will fail when trying to open the group. And another
		  * VFIO interface is also required to dec group->opened when VM is
		  * down.
		  */
		if (vfio_iommu_device_group_opened_inc(iommu_device_group))
			return -EBUSY;
		iommu_attach_gorup(iommu_device_group);
	}
}

The concern here is the two new VFIO interfaces. Any thoughts on this proposal? :-)

> It's really unfortunate that we don't have the mdev inheriting the
> iommu group of the iommu_device so that userspace can really understand
> this relationship.  A separate group makes sense for the aux-domain
> case, and is (I guess) not a significant issue in the case of a
> singleton iommu_device group, but it's pretty awkward here.  Perhaps
> this is something we should correct in design of iommu backed mdevs.

Yeah, for aux-domain case, it is not significant issue as aux-domain essentially
means singleton iommu_devie group. And in early time, when designing the support
for wrap pci as a mdev, we also considered to let vfio-mdev-pci to reuse
iommu_device group. But this results in an iommu backed group includes mdev and
physical devices, which might also be strange. Do you think it is valuable to reconsider
it?

> Thanks,
> 
> Alex

Thanks,
Yi Liu
