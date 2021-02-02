Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD1730CDF4
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 22:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhBBVbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 16:31:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33565 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229793AbhBBVbu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 16:31:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612301422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G0kfi1Ead2f7sUwvPloDcAYNgV5q97py1bBvH50YBqM=;
        b=NmLkaaWqbCyVkHZMQfmAj8qxIBEcezUC+3ma4Cecq5AfugalayzLz0o1TFNQNv5zMziw5G
        d52npFHtj4SMiCgsRKksoQQYEbdBAgb3+Qz9dt+zT69A2Lb6mNo4PNckCu2xds5MBX1S+d
        TCyTB0bx4yzTtK6AcgAfN5LkklQCiMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-tUNrQbiCMC6gMWru6ngMiA-1; Tue, 02 Feb 2021 16:30:17 -0500
X-MC-Unique: tUNrQbiCMC6gMWru6ngMiA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A781800D55;
        Tue,  2 Feb 2021 21:30:15 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E3901899A;
        Tue,  2 Feb 2021 21:30:14 +0000 (UTC)
Date:   Tue, 2 Feb 2021 14:30:13 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <aik@ozlabs.ru>
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210202143013.06366e9d@omen.home.shazbot.org>
In-Reply-To: <5e9ee84e-d950-c8d9-ac70-df042f7d8b47@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
        <20210201162828.5938-9-mgurtovoy@nvidia.com>
        <20210201181454.22112b57.cohuck@redhat.com>
        <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
        <20210201114230.37c18abd@omen.home.shazbot.org>
        <20210202170659.1c62a9e8.cohuck@redhat.com>
        <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
        <20210202105455.5a358980@omen.home.shazbot.org>
        <20210202185017.GZ4247@nvidia.com>
        <20210202123723.6cc018b8@omen.home.shazbot.org>
        <20210202204432.GC4247@nvidia.com>
        <5e9ee84e-d950-c8d9-ac70-df042f7d8b47@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Feb 2021 22:59:27 +0200
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> On 2/2/2021 10:44 PM, Jason Gunthorpe wrote:
> > On Tue, Feb 02, 2021 at 12:37:23PM -0700, Alex Williamson wrote:
> >  
> >> For the most part, this explicit bind interface is redundant to
> >> driver_override, which already avoids the duplicate ID issue.  
> > No, the point here is to have the ID tables in the PCI drivers because
> > they fundamentally only work with their supported IDs. The normal
> > driver core ID tables are a replacement for all the hardwired if's in
> > vfio_pci.
> >
> > driver_override completely disables all the ID checking, it seems only
> > useful for vfio_pci which works with everything. It should not be used
> > with something like nvlink_vfio_pci.ko that needs ID checking.  
> 
> This mechanism of driver_override seems weird to me. In case of hotplug 
> and both capable drivers (native device driver and vfio-pci) are loaded, 
> both will compete on the device.

How would the hot-added device have driver_override set?  There's no
competition, the native device driver would claim the device and the
user could set driver_override, unbind and re-probe to get their
specified driver.  Once a driver_override is set, there cannot be any
competition, driver_override is used for match exclusively if set.

> I think the proposed flags is very powerful and it does fix the original 
> concern Alex had ("if we start adding ids for vfio drivers then we 
> create conflicts with the native host driver") and it's very deterministic.
> 
> In this way we'll bind explicitly to a driver.
> 
> And the way we'll choose a vfio-pci driver is by device_id + vendor_id + 
> subsystem_device + subsystem_vendor.
> 
> There shouldn't be 2 vfio-pci drivers that support a device with same 
> above 4 ids.

It's entirely possible there could be, but without neural implant
devices to interpret the user's intentions, I think we'll have to
accept there could be non-determinism here.

The first set of users already fail this specification though, we can't
base it strictly on device and vendor IDs, we need wildcards, class
codes, revision IDs, etc., just like any other PCI drvier.  We're not
going to maintain a set of specific device IDs for the IGD extension,
nor I suspect the NVLINK support as that would require a kernel update
every time a new GPU is released that makes use of the same interface.

As I understand Jason's reply, these vendor drivers would have an ids
table and a user could look at modalias for the device to compare to
the driver supported aliases for a match.  Does kmod already have this
as a utility outside of modprobe?

> if you don't find a suitable vendor-vfio-pci.ko, you'll try binding 
> vfio-pci.ko.
> 
> Each driver will publish its supported ids in sysfs to help the user to 
> decide.

Seems like it would be embedded in the aliases for the module, with
this explicit binding flag being the significant difference that
prevents auto loading the device.  We still have one of the races that
driver_override resolves though, the proposed explicit bind flag is on
the driver not the device, so a native host driver being loaded due to
a hotplug operation or independent actions of different admins could
usurp the device between unbind of old driver and bind to new driver.

> > Yes, this DRIVER_EXPLICIT_BIND_ONLY idea somewhat replaces
> > driver_override because we could set the PCI any match on vfio_pci and
> > manage the driver binding explicitly instead.
> >  
> >> A driver id table doesn't really help for binding the device,
> >> ultimately even if a device is in the id table it might fail to
> >> probe due to the missing platform support that each of these igd and
> >> nvlink drivers expose,  
> > What happens depends on what makes sense for the driver, some missing
> > optional support could continue without it, or it could fail.
> >
> > IGD and nvlink can trivially go onwards and work if they don't find
> > the platform support.

This seems unpredictable from a user perspective.  In either the igd or
nvlink cases, if the platform features aren't available, the feature
set of the device is reduced.  That's not apparent until the user tries
to start interacting with the device if the device specific driver
doesn't fail the probe.  Userspace policy would need to decide if a
fallback driver is acceptable or the vendor specific driver failure is
fatal. Thanks,

Alex

