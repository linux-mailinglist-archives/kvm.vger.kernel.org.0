Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 515A06EBCD
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 22:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731949AbfGSU5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 16:57:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43288 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728148AbfGSU5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 16:57:35 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 150374F655;
        Fri, 19 Jul 2019 20:57:34 +0000 (UTC)
Received: from x1.home (ovpn-116-35.phx2.redhat.com [10.3.116.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54CB419C68;
        Fri, 19 Jul 2019 20:57:33 +0000 (UTC)
Date:   Fri, 19 Jul 2019 14:57:32 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
Message-ID: <20190719145732.169fc4ba@x1.home>
In-Reply-To: <A2975661238FB949B60364EF0F2C257439FD665D@SHSMSX104.ccr.corp.intel.com>
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
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 19 Jul 2019 20:57:34 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Jul 2019 12:55:27 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> Hi Alex,
> 
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Friday, July 12, 2019 3:08 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> > 
> > On Thu, 11 Jul 2019 12:27:26 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > Hi Alex,
> > >  
> > > > From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On  
> > Behalf  
> > > > Of Alex Williamson
> > > > Sent: Friday, July 5, 2019 11:55 PM
> > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> > > >
> > > > On Thu, 4 Jul 2019 09:11:02 +0000
> > > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > > >  
> > > > > Hi Alex,
> > > > >  
> > > > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > > > Sent: Thursday, July 4, 2019 1:22 AM
> > > > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver  
> > > [...]  
> > > > >  
> > > > > > It's really unfortunate that we don't have the mdev inheriting the
> > > > > > iommu group of the iommu_device so that userspace can really understand
> > > > > > this relationship.  A separate group makes sense for the aux-domain
> > > > > > case, and is (I guess) not a significant issue in the case of a
> > > > > > singleton iommu_device group, but it's pretty awkward here.  Perhaps
> > > > > > this is something we should correct in design of iommu backed mdevs.  
> > > > >
> > > > > Yeah, for aux-domain case, it is not significant issue as aux-domain essentially
> > > > > means singleton iommu_devie group. And in early time, when designing the  
> > > > support  
> > > > > for wrap pci as a mdev, we also considered to let vfio-mdev-pci to reuse
> > > > > iommu_device group. But this results in an iommu backed group includes mdev  
> > and  
> > > > > physical devices, which might also be strange. Do you think it is valuable to  
> > > > reconsider  
> > > > > it?  
> > > >
> > > > From a group perspective, the cleanest solution would seem to be that
> > > > IOMMU backed mdevs w/o aux domain support should inherit the IOMMU
> > > > group of the iommu_device,  
> > >
> > > A confirm here. Regards to inherit the IOMMU group of iommu_device, do
> > > you mean mdev device should be added to the IOMMU group of iommu_device
> > > or maintain a parent and inheritor relationship within vfio? I guess you mean the
> > > later one? :-)  
> > 
> > I was thinking the former, I'm not sure what the latter implies.  There
> > is no hierarchy within or between IOMMU groups, it's simply a set of
> > devices.  
> 
> I have a concern on adding the mdev device to the iommu_group of
> iommu_device. In such configuration, a iommu backed group includes
> mdev devices and physical devices. Then it might be necessary to advertise
> the mdev info to the in-kernel software which want to loop all devices within
> such an iommu_group. An example I can see is the virtual SVA threads in
> community. e.g. for a guest pasid bind, the changes below loops all the
> devices within an iommu_group, and each loop will call into vendor iommu
> driver with a device structure passed in. It is quite possible that vendor
> iommu driver need to get something behind a physical device (e.g.
> intel_iommu structure). For a physical device, it is fine. While for mdev
> device, it would be a problem if no mdev info advertised to iommu driver. :-(
> Although we have agreement that PASID support should be disabled for
> devices which are from non-singleton group. But I don't feel like to rely on
> such assumptions when designing software flows. Also, it's just an example,
> we have no idea if there will be more similar flows which require to loop all
> devices in an iommu group in future. May be we want to avoid adding a mdev
> to an iommu backed group. :-) More replies to you response below.
> 
> +static long vfio_iommu_type1_bind_gpasid(struct vfio_iommu *iommu,
> +					    void __user *arg,
> +					    struct vfio_iommu_type1_bind *bind)
> + ...
> +	list_for_each_entry(domain, &iommu->domain_list, next) {
> +		list_for_each_entry(group, &domain->group_list, next) {
> +			ret = iommu_group_for_each_dev(group->iommu_group,
> +			   &guest_bind, vfio_bind_gpasid_fn);
> +			if (ret)
> +				goto out_unbind;
> +		}
> +	}
> + ...
> +}

Sorry for the delayed response.

I think you're right, making the IOMMU code understand virtual devices
in an IOMMU group makes traversing the group difficult for any layer
that doesn't understand the relationship of these virtual devices.  I
guess we can't go that route.

> > Maybe what you're getting at is that vfio needs to understand
> > that the mdev is a child of the endpoint device in its determination of
> > whether the group is viable.  
> 
> Is the group here the group of iommu_device or a group of a mdev device?
> :-) Actually, I think the group of a mdev device is always viable since
> it has only a device and mdev_driver will add the mdev device to vfio
> controlled scope to make the mdev group viable. Per my understanding,
> VFIO guarantees the isolation by two major arts. First is checking if
> group is viable before adding it to a container, second is preventing
> multiple opens to /dev/vfio/group_id by the vfio_group->opened field
> maintained in vfio.c.

Yes, minor nit, an mdev needs to be bound to vfio-mdev for the group to
be vfio "viable", we expect that there will eventually be non-vfio
drivers for mdev devices.

> Back to the configuration we are talking here (For example a group where
> one devices is bound to a native host driver and the other device bound
> to a vfio driver[1].), we have two groups( iommu backed one and mdev group).
> I think for iommu_device which wants to "donate" its iommu_group, the
> host driver should explicitly call vfio_add_group_dev() to add itself
> to the vfio controlled scope. And thus make its iommu backed group be
> viable. So that we can have two viable iommu groups. iommu backed group
> is viable by the host driver's vfio_add_group_dev() calling, and mdev
> group is naturally viable. Until now, we can passthru the devices
> (vfio-pci device and a mdev device) under this configuration to VM well.
> But we cannot prevent user to passthru the devices to different VMs since
> the two iommu groups are both viable. If I'm still understanding vfio
> correct until this line, I think we need to fail the attempt of passthru
> to multiple VMs in vfio_iommu_type1_attach_group() by checking the
> vfio_group->opened field which is maintained in vfio.c. e.g. let's say
> for iommu backed group, we have vfio_group#1 and mdev group, we have
> vfio_group#2 in vfio.c, then opening vfio_group#1 requires to inc the
> vfio_group#2->opened. And vice versa.
> 
> [1] the example from the previous reply of you.

I think there's a problem with incrementing the group, the user still
needs to be able to open the group for devices within the group that
may be bound to vfio-pci, so I don't think this plan really works.
Also, who would be responsible for calling vfio_add_group_dev(), the
vendor driver is just registering an mdev parent device, it doesn't
know that those devices will be used by vfio-mdev or some other mdev
bus driver.  I think that means that vfio-mdev would need to call this
for mdevs with an iommu_device after it registers the mdev itself.  The
vfio_device_ops it registers would need to essentially be stubbed out
too, in order to prevent direct vfio access to the backing device.

I wonder if the "inheritance" of a group could be isolated to vfio in
such a case.  The vfio group file for the mdev must exist for
userspace compatibility, but I wonder if we could manage to make that be
effectively an alias for the iommu device.  Using a device from a group
without actually opening the group still seems problematic too.  I'm
also wondering how much effort we want to go to in supporting this
versus mdev could essentially fail the call to register an iommu device
for an mdev if that iommu device is not in a singleton group.  It would
limit the application of vfio-mdev-pci, but already being proposed as a
proof of concept sample driver anyway.


> > That's true, but we can also have IOMMU
> > groups composed of SR-IOV VFs along with their parent PF if the root of
> > the IOMMU group is (for example) a downstream switch port above the PF.
> > So we can't simply look at the parent/child relationship within the
> > group, we somehow need to know that the parent device sharing the IOMMU
> > group is operating in host kernel space on behalf of the mdev.  
> 
> I think for such hardware configuration, we still have only two iommu
> group, a iommu backed one and a mdev group. May the idea above still
> applicable. :-)
> 
> > > > but I think the barrier here is that we have
> > > > a difficult time determining if the group is "viable" in that case.
> > > > For example a group where one devices is bound to a native host driver
> > > > and the other device bound to a vfio driver would typically be
> > > > considered non-viable as it breaks the isolation guarantees.  However  
> > >
> > > yes, this is how vfio guarantee the isolation before allowing user to further
> > > add a group to a vfio container and so on.
> > >  
> > > > I think in this configuration, the parent device is effectively
> > > > participating in the isolation and "donating" its iommu group on behalf
> > > > of the mdev device.  I don't think we can simultaneously use that iommu
> > > > group for any other purpose.  
> > >
> > > Agree. At least host cannot make use of the iommu group any more in such
> > > configuration.
> > >  
> > > > I'm sure we could come up with a way for
> > > > vifo-core to understand this relationship and add it to the white list,  
> > >
> > > The configuration is host driver still exists while we want to let mdev device
> > > to somehow "own" the iommu backed DMA isolation capability. So one possible
> > > way may be calling vfio_add_group_dev() which will creates a vfio_device instance
> > > for the iommu_device in vfio.c when creating a iommu backed mdev. Then the
> > > iommu group is fairly viable.  
> > 
> > "fairly viable" ;)  It's a correct use of the term, it's a little funny
> > though as "fairly" can also mean reasonably/sufficiently/adequately as
> > well as I think the intended use here equivalent to justly. </tangent>  
> 
> Aha, a nice "lesson" for me. Honestly, I have no idea how it came to me
> when trying to describe my idea with a moderate term either. Luckily,
> it made me well understood. :-)
> 
> > That's an interesting idea to do an implicit vfio_add_group_dev() on
> > the iommu_device in this case, if you've worked through how that could
> > play out, it'd be interesting to see.  
> 
> I've tried it in my vfio-mdev-pci driver probe() phase, it works well.
> And this is an explicit calling. And I guess we may really want host driver
> to do it explicitly instead of implicitly as host driver owns the choice
> of whether "donating" group or not. While for failing the
> vfio_iommu_type1_attach_group() to prevent user passthru the vfio-pci device
> and vfio-mdev-pci device (share iommu backed group) to different VMs, I'm
> doing some changes. If it's a correct way, I'll try to send out a new version
> for your further review. :-)

I'm interested to see it, but as above, I have some reservations.  And
as I mention, and mdev vendor driver cannot assume the device is used
by vfio-mdev.  I know Intel vGPUs not only assume vfio-mdev, but also
KVM and fail the device open if the constraints aren't met, but I don't
think we can start introducing that sort of vfio specific dependencies
on the mdev bus interface.  Thanks,

Alex
