Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76FB766F4E
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 14:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfGLMzg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 12 Jul 2019 08:55:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:31003 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbfGLMzg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 08:55:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jul 2019 05:55:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,482,1557212400"; 
   d="scan'208";a="186599890"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga001.fm.intel.com with ESMTP; 12 Jul 2019 05:55:30 -0700
Received: from fmsmsx161.amr.corp.intel.com (10.18.125.9) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 12 Jul 2019 05:55:29 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 FMSMSX161.amr.corp.intel.com (10.18.125.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 12 Jul 2019 05:55:29 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.110]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.3]) with mapi id 14.03.0439.000;
 Fri, 12 Jul 2019 20:55:27 +0800
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
Thread-Index: AQHVHsiVLTtm/WvGlEKSmQ2lKcl2F6ajfRGAgAC0NOCAAGOFgIABGcaQgAAh3QCABKzV8IAGRYaAgAfjTqCAAB3wAIABIjgQgAHqLACACa6T4P//9UyAgAGTM3A=
Date:   Fri, 12 Jul 2019 12:55:27 +0000
Message-ID: <A2975661238FB949B60364EF0F2C257439FD665D@SHSMSX104.ccr.corp.intel.com>
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
In-Reply-To: <20190711130811.4e51437d@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzk1ODc0ODctYzY1Zi00MDg2LWIwNWQtYzVmZjQ1MWFhNzhkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiaVB4dnpXTzBld3lGT3A3eHM5bEc1c0xsNWtoRlwvOE9aUkFyYkVVS1d3bjNjUVNPNlp2SHFjZWNuS2swOWpxc3MifQ==
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
> Sent: Friday, July 12, 2019 3:08 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> 
> On Thu, 11 Jul 2019 12:27:26 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > Hi Alex,
> >
> > > From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On
> Behalf
> > > Of Alex Williamson
> > > Sent: Friday, July 5, 2019 11:55 PM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> > >
> > > On Thu, 4 Jul 2019 09:11:02 +0000
> > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > >
> > > > Hi Alex,
> > > >
> > > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > > Sent: Thursday, July 4, 2019 1:22 AM
> > > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > > Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> > [...]
> > > >
> > > > > It's really unfortunate that we don't have the mdev inheriting the
> > > > > iommu group of the iommu_device so that userspace can really understand
> > > > > this relationship.  A separate group makes sense for the aux-domain
> > > > > case, and is (I guess) not a significant issue in the case of a
> > > > > singleton iommu_device group, but it's pretty awkward here.  Perhaps
> > > > > this is something we should correct in design of iommu backed mdevs.
> > > >
> > > > Yeah, for aux-domain case, it is not significant issue as aux-domain essentially
> > > > means singleton iommu_devie group. And in early time, when designing the
> > > support
> > > > for wrap pci as a mdev, we also considered to let vfio-mdev-pci to reuse
> > > > iommu_device group. But this results in an iommu backed group includes mdev
> and
> > > > physical devices, which might also be strange. Do you think it is valuable to
> > > reconsider
> > > > it?
> > >
> > > From a group perspective, the cleanest solution would seem to be that
> > > IOMMU backed mdevs w/o aux domain support should inherit the IOMMU
> > > group of the iommu_device,
> >
> > A confirm here. Regards to inherit the IOMMU group of iommu_device, do
> > you mean mdev device should be added to the IOMMU group of iommu_device
> > or maintain a parent and inheritor relationship within vfio? I guess you mean the
> > later one? :-)
> 
> I was thinking the former, I'm not sure what the latter implies.  There
> is no hierarchy within or between IOMMU groups, it's simply a set of
> devices.

I have a concern on adding the mdev device to the iommu_group of
iommu_device. In such configuration, a iommu backed group includes
mdev devices and physical devices. Then it might be necessary to advertise
the mdev info to the in-kernel software which want to loop all devices within
such an iommu_group. An example I can see is the virtual SVA threads in
community. e.g. for a guest pasid bind, the changes below loops all the
devices within an iommu_group, and each loop will call into vendor iommu
driver with a device structure passed in. It is quite possible that vendor
iommu driver need to get something behind a physical device (e.g.
intel_iommu structure). For a physical device, it is fine. While for mdev
device, it would be a problem if no mdev info advertised to iommu driver. :-(
Although we have agreement that PASID support should be disabled for
devices which are from non-singleton group. But I don't feel like to rely on
such assumptions when designing software flows. Also, it's just an example,
we have no idea if there will be more similar flows which require to loop all
devices in an iommu group in future. May be we want to avoid adding a mdev
to an iommu backed group. :-) More replies to you response below.

+static long vfio_iommu_type1_bind_gpasid(struct vfio_iommu *iommu,
+					    void __user *arg,
+					    struct vfio_iommu_type1_bind *bind)
+ ...
+	list_for_each_entry(domain, &iommu->domain_list, next) {
+		list_for_each_entry(group, &domain->group_list, next) {
+			ret = iommu_group_for_each_dev(group->iommu_group,
+			   &guest_bind, vfio_bind_gpasid_fn);
+			if (ret)
+				goto out_unbind;
+		}
+	}
+ ...
+}

> Maybe what you're getting at is that vfio needs to understand
> that the mdev is a child of the endpoint device in its determination of
> whether the group is viable.

Is the group here the group of iommu_device or a group of a mdev device?
:-) Actually, I think the group of a mdev device is always viable since
it has only a device and mdev_driver will add the mdev device to vfio
controlled scope to make the mdev group viable. Per my understanding,
VFIO guarantees the isolation by two major arts. First is checking if
group is viable before adding it to a container, second is preventing
multiple opens to /dev/vfio/group_id by the vfio_group->opened field
maintained in vfio.c.

Back to the configuration we are talking here (For example a group where
one devices is bound to a native host driver and the other device bound
to a vfio driver[1].), we have two groups( iommu backed one and mdev group).
I think for iommu_device which wants to "donate" its iommu_group, the
host driver should explicitly call vfio_add_group_dev() to add itself
to the vfio controlled scope. And thus make its iommu backed group be
viable. So that we can have two viable iommu groups. iommu backed group
is viable by the host driver's vfio_add_group_dev() calling, and mdev
group is naturally viable. Until now, we can passthru the devices
(vfio-pci device and a mdev device) under this configuration to VM well.
But we cannot prevent user to passthru the devices to different VMs since
the two iommu groups are both viable. If I'm still understanding vfio
correct until this line, I think we need to fail the attempt of passthru
to multiple VMs in vfio_iommu_type1_attach_group() by checking the
vfio_group->opened field which is maintained in vfio.c. e.g. let's say
for iommu backed group, we have vfio_group#1 and mdev group, we have
vfio_group#2 in vfio.c, then opening vfio_group#1 requires to inc the
vfio_group#2->opened. And vice versa.

[1] the example from the previous reply of you.

> That's true, but we can also have IOMMU
> groups composed of SR-IOV VFs along with their parent PF if the root of
> the IOMMU group is (for example) a downstream switch port above the PF.
> So we can't simply look at the parent/child relationship within the
> group, we somehow need to know that the parent device sharing the IOMMU
> group is operating in host kernel space on behalf of the mdev.

I think for such hardware configuration, we still have only two iommu
group, a iommu backed one and a mdev group. May the idea above still
applicable. :-)

> > > but I think the barrier here is that we have
> > > a difficult time determining if the group is "viable" in that case.
> > > For example a group where one devices is bound to a native host driver
> > > and the other device bound to a vfio driver would typically be
> > > considered non-viable as it breaks the isolation guarantees.  However
> >
> > yes, this is how vfio guarantee the isolation before allowing user to further
> > add a group to a vfio container and so on.
> >
> > > I think in this configuration, the parent device is effectively
> > > participating in the isolation and "donating" its iommu group on behalf
> > > of the mdev device.  I don't think we can simultaneously use that iommu
> > > group for any other purpose.
> >
> > Agree. At least host cannot make use of the iommu group any more in such
> > configuration.
> >
> > > I'm sure we could come up with a way for
> > > vifo-core to understand this relationship and add it to the white list,
> >
> > The configuration is host driver still exists while we want to let mdev device
> > to somehow "own" the iommu backed DMA isolation capability. So one possible
> > way may be calling vfio_add_group_dev() which will creates a vfio_device instance
> > for the iommu_device in vfio.c when creating a iommu backed mdev. Then the
> > iommu group is fairly viable.
> 
> "fairly viable" ;)  It's a correct use of the term, it's a little funny
> though as "fairly" can also mean reasonably/sufficiently/adequately as
> well as I think the intended use here equivalent to justly. </tangent>

Aha, a nice "lesson" for me. Honestly, I have no idea how it came to me
when trying to describe my idea with a moderate term either. Luckily,
it made me well understood. :-)

> That's an interesting idea to do an implicit vfio_add_group_dev() on
> the iommu_device in this case, if you've worked through how that could
> play out, it'd be interesting to see.

I've tried it in my vfio-mdev-pci driver probe() phase, it works well.
And this is an explicit calling. And I guess we may really want host driver
to do it explicitly instead of implicitly as host driver owns the choice
of whether "donating" group or not. While for failing the
vfio_iommu_type1_attach_group() to prevent user passthru the vfio-pci device
and vfio-mdev-pci device (share iommu backed group) to different VMs, I'm
doing some changes. If it's a correct way, I'll try to send out a new version
for your further review. :-)

> > > I wonder though how confusing this might be to users who now understand
> > > the group/driver requirement to be "all endpoints bound to vfio
> > > drivers".  This might still be the best approach regardless of this.
> >
> > Yes, another thing I'm considering is how to prevent such a host driver from
> > issuing DMA. If we finally get a device bound to vfio-pci and another device
> > wrapped as mdev and passthru them to VM, the host driver is still capable to
> > issue DMA. Though IOMMU can block some DMAs, but not all of them. If a
> > DMA issued by host driver happens to have mapping in IOMMU side, then
> > host is kind of doing things on behalf on VM. Though we may trust the host
> > driver, but it looks to be a little bit awkward to me. :-(
> 
> vfio is allocating an iommu domain and placing the iommu_device into
> that domain, the user therefore own the iova context for the parent
> device, how would that not manage all DMA?   The vendor driver could
> theoretically also manipulate mappings within that domain, but that
> driver is a host kernel driver and therefore essentially trusted like
> any other host kernel driver.  The only unique thing here is that it's
> part of a channel providing access for an untrusted user, so it needs
> to be particularly concerned with keeping that user access within
> bounds.  Thanks,

Got it, thanks for the explanation. Looks like I overplayed the concern.

> 
> Alex

Regards,
Yi Liu
