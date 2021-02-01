Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE3F30A0E0
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 05:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhBAEgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 23:36:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230085AbhBAEeI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Jan 2021 23:34:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612153957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qzKf3On6Ip3TaCvUnpGfIU2RRlLtYIfFb0S7/MeDIKE=;
        b=UCm8f/gshXmbg5sfxzY6L9wHjotk6O68c523tw1ppem3A71Mt3cLvqM41jRY+kXkxF5aEF
        6JLggwBcBfeINTLCM9rJSuBxx4aK8ncX6poZz/z9Vkzh6D1uuVJHeIGzRnR9+4jkE2VnMx
        4i7lBNae1pmL7hRnEOGrFDNLeBt6geY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-WhoTh_czMUSS5e_twC9zTA-1; Sun, 31 Jan 2021 23:32:32 -0500
X-MC-Unique: WhoTh_czMUSS5e_twC9zTA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 813DA801AC0;
        Mon,  1 Feb 2021 04:32:30 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F5BB10016F7;
        Mon,  1 Feb 2021 04:32:29 +0000 (UTC)
Date:   Sun, 31 Jan 2021 21:32:28 -0700
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
Message-ID: <20210131213228.0e0573f4@x1.home.shazbot.org>
In-Reply-To: <536caa01-7fef-7256-b281-03b40a6ca217@nvidia.com>
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
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 31 Jan 2021 20:46:40 +0200
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> On 1/28/2021 11:02 PM, Alex Williamson wrote:
> > On Thu, 28 Jan 2021 17:29:30 +0100
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >  
> >> On Tue, 26 Jan 2021 15:27:43 +0200
> >> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:  
> >>> On 1/26/2021 5:34 AM, Alex Williamson wrote:  
> >>>> On Mon, 25 Jan 2021 20:45:22 -0400
> >>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
> >>>>       
> >>>>> On Mon, Jan 25, 2021 at 04:31:51PM -0700, Alex Williamson wrote:  
> >>>>>> extensions potentially break vendor drivers, etc.  We're only even hand
> >>>>>> waving that existing device specific support could be farmed out to new
> >>>>>> device specific drivers without even going to the effort to prove that.  
> >>>>> This is a RFC, not a complete patch series. The RFC is to get feedback
> >>>>> on the general design before everyone comits alot of resources and
> >>>>> positions get dug in.
> >>>>>
> >>>>> Do you really think the existing device specific support would be a
> >>>>> problem to lift? It already looks pretty clean with the
> >>>>> vfio_pci_regops, looks easy enough to lift to the parent.
> >>>>>       
> >>>>>> So far the TODOs rather mask the dirty little secrets of the
> >>>>>> extension rather than showing how a vendor derived driver needs to
> >>>>>> root around in struct vfio_pci_device to do something useful, so
> >>>>>> probably porting actual device specific support rather than further
> >>>>>> hand waving would be more helpful.  
> >>>>> It would be helpful to get actual feedback on the high level design -
> >>>>> someting like this was already tried in May and didn't go anywhere -
> >>>>> are you surprised that we are reluctant to commit alot of resources
> >>>>> doing a complete job just to have it go nowhere again?  
> >>>> That's not really what I'm getting from your feedback, indicating
> >>>> vfio-pci is essentially done, the mlx stub driver should be enough to
> >>>> see the direction, and additional concerns can be handled with TODO
> >>>> comments.  Sorry if this is not construed as actual feedback, I think
> >>>> both Connie and I are making an effort to understand this and being
> >>>> hampered by lack of a clear api or a vendor driver that's anything more
> >>>> than vfio-pci plus an aux bus interface.  Thanks,  
> >>> I think I got the main idea and I'll try to summarize it:
> >>>
> >>> The separation to vfio-pci.ko and vfio-pci-core.ko is acceptable, and we
> >>> do need it to be able to create vendor-vfio-pci.ko driver in the future
> >>> to include vendor special souse inside.  
> >> One other thing I'd like to bring up: What needs to be done in
> >> userspace? Does a userspace driver like QEMU need changes to actually
> >> exploit this? Does management software like libvirt need to be involved
> >> in decision making, or does it just need to provide the knobs to make
> >> the driver configurable?  
> > I'm still pretty nervous about the userspace aspect of this as well.
> > QEMU and other actual vfio drivers are probably the least affected,
> > at least for QEMU, it'll happily open any device that has a pointer to
> > an IOMMU group that's reflected as a vfio group device.  Tools like
> > libvirt, on the other hand, actually do driver binding and we need to
> > consider how they make driver decisions. Jason suggested that the
> > vfio-pci driver ought to be only spec compliant behavior, which sounds
> > like some deprecation process of splitting out the IGD, NVLink, zpci,
> > etc. features into sub-drivers and eventually removing that device
> > specific support from vfio-pci.  Would we expect libvirt to know, "this
> > is an 8086 graphics device, try to bind it to vfio-pci-igd" or "uname
> > -m says we're running on s390, try to bind it to vfio-zpci"?  Maybe we
> > expect derived drivers to only bind to devices they recognize, so
> > libvirt could blindly try a whole chain of drivers, ending in vfio-pci.
> > Obviously if we have competing drivers that support the same device in
> > different ways, that quickly falls apart.  
> 
> I think we can leave common arch specific stuff, such as s390 (IIUC) in 
> the core driver. And only create vfio_pci drivers for 
> vendor/device/subvendor specific stuff.

So on one hand you're telling us that the design principles here can be
applied to various other device/platform specific support, but on the
other you're saying, but don't do that...
 
> Also, the competing drivers issue can also happen today, right ? after 
> adding new_id to vfio_pci I don't know how linux will behave if we'll 
> plug new device with same id to the system. which driver will probe it ?

new_id is non-deterministic, that's why we have driver_override.
 
> I don't really afraid of competing drivers since we can ask from vendor 
> vfio pci_drivers to add vendor_id, device_id, subsystem_vendor and 
> subsystem_device so we won't have this problem. I don't think that there 
> will be 2 drivers that drive the same device with these 4 ids.
> 
> Userspace tool can have a map of ids to drivers and bind the device to 
> the right vfio-pci vendor driver if it has one. if not, bind to vfio_pci.ko.

As I've outlined, the support is not really per device, there might be
a preferred default driver for the platform, ex. s390.

> > Libvirt could also expand its available driver models for the user to
> > specify a variant, I'd support that for overriding a choice that libvirt
> > might make otherwise, but forcing the user to know this information is
> > just passing the buck.  
> 
> We can add a code to libvirt as mentioned above.

That's rather the question here, what is that algorithm by which a
userspace tool such as libvirt would determine the optimal driver for a
device?

> > Some derived drivers could probably actually include device IDs rather
> > than only relying on dynamic ids, but then we get into the problem that
> > we're competing with native host driver for a device.  The aux bus
> > example here is essentially the least troublesome variation since it
> > works in conjunction with the native host driver rather than replacing
> > it.  Thanks,  
> 
> same competition after we add new_id to vfio_pci, right ?

new_id is already superseded by driver_override to avoid the ambiguity,
but to which driver does a userspace tool like libvirt define as the
ultimate target driver for a device and how?
 
> A pointer to needed additions to libvirt will be awsome (or any other hint).
> 
> I'll send the V2 soon and then move to libvirt.

The libvirt driver for a device likely needs to accept vfio variants
and allow users to specify a variant, but the real question is how
libvirt makes an educated guess which variant to use initially, which I
don't really have any good ideas to resolve.  Thanks,

Alex

