Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4BE7617B
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 11:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfGZJEy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 26 Jul 2019 05:04:54 -0400
Received: from mga06.intel.com ([134.134.136.31]:33796 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfGZJEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 05:04:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 02:04:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,310,1559545200"; 
   d="scan'208";a="161243261"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga007.jf.intel.com with ESMTP; 26 Jul 2019 02:04:52 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 26 Jul 2019 02:04:52 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 26 Jul 2019 02:04:52 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 26 Jul 2019 02:04:52 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.112]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.65]) with mapi id 14.03.0439.000;
 Fri, 26 Jul 2019 17:04:50 +0800
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
Thread-Index: AQHVHsiVLTtm/WvGlEKSmQ2lKcl2F6ajfRGAgAC0NOCAAGOFgIABGcaQgAAh3QCABKzV8IAGRYaAgAfjTqCAAB3wAIABIjgQgAHqLACACa6T4P//9UyAgAGTM3CACx4BAIAKpMDg
Date:   Fri, 26 Jul 2019 09:04:50 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A024545@SHSMSX104.ccr.corp.intel.com>
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
        <A2975661238FB949B60364EF0F2C257439F1FF4E@SHSMSX104.ccr.corp.intel.com>
        <20190705095520.548331c2@x1.home>
        <A2975661238FB949B60364EF0F2C257439F931F8@SHSMSX104.ccr.corp.intel.com>
        <20190711130811.4e51437d@x1.home>
        <A2975661238FB949B60364EF0F2C257439FD665D@SHSMSX104.ccr.corp.intel.com>
 <20190719145732.169fc4ba@x1.home>
In-Reply-To: <20190719145732.169fc4ba@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzA2MjU2ZjEtZTkyZS00MmZmLTgwMDEtOWQ3MzA4NThmYmE4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicEZaM1kxNWZZVWQrR1duUHJnZXY3cUpUcjUrRWtMMWxFeGkrN1l5RjdrUHROWTFud21lSmxrM09pdHZ5SDBJRCJ9
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
> Sent: Saturday, July 20, 2019 4:58 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> 
> On Fri, 12 Jul 2019 12:55:27 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > Hi Alex,
> >
> > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > Sent: Friday, July 12, 2019 3:08 AM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> > >
> > > On Thu, 11 Jul 2019 12:27:26 +0000
> > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > >
> > > > Hi Alex,
> > > >
> > > > > From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On
> > > Behalf
> > > > > Of Alex Williamson
> > > > > Sent: Friday, July 5, 2019 11:55 PM
> > > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > > Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> > > > >
> > > > > On Thu, 4 Jul 2019 09:11:02 +0000
> > > > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > > > >
> > > > > > Hi Alex,
> > > > > >
> > > > > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > > > > Sent: Thursday, July 4, 2019 1:22 AM
> > > > > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > > Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> > > > [...]
[...]
> > > Maybe what you're getting at is that vfio needs to understand
> > > that the mdev is a child of the endpoint device in its determination of
> > > whether the group is viable.
> >
> > Is the group here the group of iommu_device or a group of a mdev device?
> > :-) Actually, I think the group of a mdev device is always viable since
> > it has only a device and mdev_driver will add the mdev device to vfio
> > controlled scope to make the mdev group viable. Per my understanding,
> > VFIO guarantees the isolation by two major arts. First is checking if
> > group is viable before adding it to a container, second is preventing
> > multiple opens to /dev/vfio/group_id by the vfio_group->opened field
> > maintained in vfio.c.
> 
> Yes, minor nit, an mdev needs to be bound to vfio-mdev for the group to
> be vfio "viable", we expect that there will eventually be non-vfio
> drivers for mdev devices.

Then I guess the mdev group is non-viable per vfio's mind. :-)

> > Back to the configuration we are talking here (For example a group where
> > one devices is bound to a native host driver and the other device bound
> > to a vfio driver[1].), we have two groups( iommu backed one and mdev group).
> > I think for iommu_device which wants to "donate" its iommu_group, the
> > host driver should explicitly call vfio_add_group_dev() to add itself
> > to the vfio controlled scope. And thus make its iommu backed group be
> > viable. So that we can have two viable iommu groups. iommu backed group
> > is viable by the host driver's vfio_add_group_dev() calling, and mdev
> > group is naturally viable. Until now, we can passthru the devices
> > (vfio-pci device and a mdev device) under this configuration to VM well.
> > But we cannot prevent user to passthru the devices to different VMs since
> > the two iommu groups are both viable. If I'm still understanding vfio
> > correct until this line, I think we need to fail the attempt of passthru
> > to multiple VMs in vfio_iommu_type1_attach_group() by checking the
> > vfio_group->opened field which is maintained in vfio.c. e.g. let's say
> > for iommu backed group, we have vfio_group#1 and mdev group, we have
> > vfio_group#2 in vfio.c, then opening vfio_group#1 requires to inc the
> > vfio_group#2->opened. And vice versa.
> >
> > [1] the example from the previous reply of you.
> 
> I think there's a problem with incrementing the group, the user still
> needs to be able to open the group for devices within the group that
> may be bound to vfio-pci, so I don't think this plan really works.

Perhaps I failed to make it clear. Let me explain. By incrementing the
group, vfio can prevent the usage of passthru a single iommu group
to different QEMUs (VMs). Once a QEMU opens a group. It will not
open again. e.g. current QEMU implementation checks the
vfio_group_list in vfio_get_group() before opening group for an
assigned device. Thus it avoids to open multiple times in a QEMU
process. This makes sense since kernel VFIO will attach all the devices
within a given iommu group to the allocated unmanaged domain in
vfio_iommu_type1_attach_group(). Back to my plan. :-) Say I have a
iommu group with three devices. A device bound to vfio-pci, and two
devices bound to a host driver which will wrap itself as a mdev (e.g.
vfio-mdev-pci driver). So there will be finally three groups, an iommu
backed group, two mdev groups. As I mentioned I may be able to
make the iommu backed group be vfio viable with
vfio_add_group_dev(). Then my plan is simple. Let the three groups
shares a group->open field. When any of the three groups results in
a increment of iommu back group. Also before any open of the three
groups, vfio_group_fops_open() should check the iommu backed
group first. Alternatively, this check can also be done in
vfio_iommu_type1_attach_group(). Looks like it may be better to
happen in vfio_group_fops_open() since we may need to let vfio.c
understand the " inheritance" between the three groups.

> Also, who would be responsible for calling vfio_add_group_dev(), the
> vendor driver is just registering an mdev parent device, it doesn't

I think it should be the vendor driver since I believe it's vendor driver's
duty to make this decision. This would like the vendor driver wants to
"donate" its iommu group to a mdev device.

> know that those devices will be used by vfio-mdev or some other mdev
> bus driver.  I think that means that vfio-mdev would need to call this
> for mdevs with an iommu_device after it registers the mdev itself.  The

Hmmm, it may be a trouble if letting vfio-mdev call this for mdevs. I'm
not sure if vfio-mdev can have the knowledge that the mdev is backed
by an iommu device.

> vfio_device_ops it registers would need to essentially be stubbed out
> too, in order to prevent direct vfio access to the backing device.

yes, the vfio_device_ops would be a dummy. In order to prevent
direct vfio access to the backing device, the vfio_device_ops.open()
should be implemented as always fail the open attempt. Thus no direct
vfio access will be successful.

> I wonder if the "inheritance" of a group could be isolated to vfio in
> such a case.  The vfio group file for the mdev must exist for
> userspace compatibility, but I wonder if we could manage to make that be
> effectively an alias for the iommu device.  Using a device from a group
> without actually opening the group still seems problematic too.  I'm

Yeah, the "inheritance" of iommu backed group and mdev groups should
be kind of "alias".

> also wondering how much effort we want to go to in supporting this
> versus mdev could essentially fail the call to register an iommu device
> for an mdev if that iommu device is not in a singleton group.  It would
> limit the application of vfio-mdev-pci, but already being proposed as a
> proof of concept sample driver anyway.

Let me have a try and get back to you. :-)
 
> > > That's true, but we can also have IOMMU
> > > groups composed of SR-IOV VFs along with their parent PF if the root of
> > > the IOMMU group is (for example) a downstream switch port above the PF.
> > > So we can't simply look at the parent/child relationship within the
> > > group, we somehow need to know that the parent device sharing the IOMMU
> > > group is operating in host kernel space on behalf of the mdev.
> >
> > I think for such hardware configuration, we still have only two iommu
> > group, a iommu backed one and a mdev group. May the idea above still
> > applicable. :-)
> >
> > > > > but I think the barrier here is that we have
> > > > > a difficult time determining if the group is "viable" in that case.
> > > > > For example a group where one devices is bound to a native host driver
> > > > > and the other device bound to a vfio driver would typically be
> > > > > considered non-viable as it breaks the isolation guarantees.  However
> > > >
> > > > yes, this is how vfio guarantee the isolation before allowing user to further
> > > > add a group to a vfio container and so on.
> > > >
> > > > > I think in this configuration, the parent device is effectively
> > > > > participating in the isolation and "donating" its iommu group on behalf
> > > > > of the mdev device.  I don't think we can simultaneously use that iommu
> > > > > group for any other purpose.
> > > >
> > > > Agree. At least host cannot make use of the iommu group any more in such
> > > > configuration.
> > > >
> > > > > I'm sure we could come up with a way for
> > > > > vifo-core to understand this relationship and add it to the white list,
> > > >
> > > > The configuration is host driver still exists while we want to let mdev device
> > > > to somehow "own" the iommu backed DMA isolation capability. So one
> possible
> > > > way may be calling vfio_add_group_dev() which will creates a vfio_device
> instance
> > > > for the iommu_device in vfio.c when creating a iommu backed mdev. Then the
> > > > iommu group is fairly viable.
> > >
> > > "fairly viable" ;)  It's a correct use of the term, it's a little funny
> > > though as "fairly" can also mean reasonably/sufficiently/adequately as
> > > well as I think the intended use here equivalent to justly. </tangent>
> >
> > Aha, a nice "lesson" for me. Honestly, I have no idea how it came to me
> > when trying to describe my idea with a moderate term either. Luckily,
> > it made me well understood. :-)
> >
> > > That's an interesting idea to do an implicit vfio_add_group_dev() on
> > > the iommu_device in this case, if you've worked through how that could
> > > play out, it'd be interesting to see.
> >
> > I've tried it in my vfio-mdev-pci driver probe() phase, it works well.
> > And this is an explicit calling. And I guess we may really want host driver
> > to do it explicitly instead of implicitly as host driver owns the choice
> > of whether "donating" group or not. While for failing the
> > vfio_iommu_type1_attach_group() to prevent user passthru the vfio-pci device
> > and vfio-mdev-pci device (share iommu backed group) to different VMs, I'm
> > doing some changes. If it's a correct way, I'll try to send out a new version
> > for your further review. :-)
> 
> I'm interested to see it, but as above, I have some reservations.  And
> as I mention, and mdev vendor driver cannot assume the device is used
> by vfio-mdev.  I know Intel vGPUs not only assume vfio-mdev, but also
> KVM and fail the device open if the constraints aren't met, but I don't
> think we can start introducing that sort of vfio specific dependencies
> on the mdev bus interface.  Thanks,

Yeah, it's always bad to introduce specific dependencies. But here if
letting vendor driver to call the vfio_add_group_dev(), then it is still
agnostic to vfio-mdev and other potential vfio-mdev alike mdev drivers
in future. Not sure if this is correct, pls feel free correct me. :-)

> Alex

Thanks,
Yi Liu
