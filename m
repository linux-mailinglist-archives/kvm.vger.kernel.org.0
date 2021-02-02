Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D638F30CFA0
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 00:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236066AbhBBXGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 18:06:53 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12505 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235664AbhBBXGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 18:06:49 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6019dae10000>; Tue, 02 Feb 2021 15:06:09 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 23:06:08 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 2 Feb 2021 23:06:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYk1yqceUNLtvTXR9+RwEfNiHXf1Mqv7UitCS55DYuZN6YzNSP/AYE7AtUPAFqR7aEDQNkBb8RgcqOwGk654sMWQn7jjEYI6mSXlnM6zIA25ftlNf/t9+72Led0v8TQt+l76BMDqjd4Z7iQpIX0kOEx7g9mdjSCbarqSK+3FRx/J6lqBEgyzXthvSRcFn5vixLFLIAJvypNf4u/5GGyeDMXPeq+wuJWjMpm9uoxoppecfun/2oFruys73500CbUh45iFS7ekhHlz8WZex0T5scl/9WPdkRvWZfhYYjxIA+0jrIOijE0XmWvK79re/eTYT3vMxhU5f/x3BKxLWUbxGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0dzWgfpjvflZLMuenj4hzoJICmlXcr+Cl1I7K83j5w=;
 b=Zl8JJvg7GsS2fSD5Ygv60OQmxOBWXb4dQzxt73n0DpTaDmO6s6ba/W4bGriRBVXdveL2zNelRFTng1hh7W8Aqf9VRIvVbnEUr6X4Z3QYPMH3BPpJs2/NHo5tomDgxnDWiEzfZwVWcmVqHfQej+q6BuNM+12H3hqWsBajFzXEeCkRJut7XM+bO6ykFHlbkOAJaVJX1YP+K/l4vM9SwjwvIO7LfPk90+G6KVGxjnL3d9jYH4xn7ms5JsWhGuK/NuUTdsZIvtcUfcqtUCyRB8O63i16xYj9v98K1+Vhw/E8PWuEuk3ICIOC+dFtL0qSADSEpfj/pTRuAGtHIX4RRVMcsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0203.namprd12.prod.outlook.com (2603:10b6:4:56::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Tue, 2 Feb
 2021 23:06:07 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3805.025; Tue, 2 Feb 2021
 23:06:07 +0000
Date:   Tue, 2 Feb 2021 19:06:04 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <aik@ozlabs.ru>
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210202230604.GD4247@nvidia.com>
References: <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
 <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
 <20210202105455.5a358980@omen.home.shazbot.org>
 <20210202185017.GZ4247@nvidia.com>
 <20210202123723.6cc018b8@omen.home.shazbot.org>
 <20210202204432.GC4247@nvidia.com>
 <5e9ee84e-d950-c8d9-ac70-df042f7d8b47@nvidia.com>
 <20210202143013.06366e9d@omen.home.shazbot.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210202143013.06366e9d@omen.home.shazbot.org>
X-ClientProxiedBy: MN2PR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:208:c0::30) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR05CA0017.namprd05.prod.outlook.com (2603:10b6:208:c0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.13 via Frontend Transport; Tue, 2 Feb 2021 23:06:06 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l74kG-002mC2-Gt; Tue, 02 Feb 2021 19:06:04 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612307169; bh=K0dzWgfpjvflZLMuenj4hzoJICmlXcr+Cl1I7K83j5w=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=Fdk9x+4pWbK0ODmWudsUpDrJ2eruqCvasfbAz3nBoTJaFRASOm2r515EISYdzkEXT
         olxLmbvmv7e3Jal0hnjZM02XRXDQg20X3KVjvXXvi7ikOrvDmfucHmzrnL+5R8DHbq
         8aw+n0o58qD+DNwiQZsjJ73kevc9udnrlzUXIFPFxM5gyyArs/pT66syLt/j0lwqLb
         IwmRyGx4WeqyJKg+2fIUQAyan0eU/Su9T+piWHcF10tvn86xL5rm3sL6H/+wGbYSEL
         w0lK1DdT4ejXKKUxE2VQdn5m9W9NXU0Be0MiWisAtkE0mSMulZTESDY0Qvu1PD53ii
         TrKOFeLd0XeOw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021 at 02:30:13PM -0700, Alex Williamson wrote:

> The first set of users already fail this specification though, we can't
> base it strictly on device and vendor IDs, we need wildcards, class
> codes, revision IDs, etc., just like any other PCI drvier.  We're not
> going to maintain a set of specific device IDs for the IGD
> extension,

The Intel GPU driver already has a include/drm/i915_pciids.h that
organizes all the PCI match table entries, no reason why VFIO IGD
couldn't include that too and use the same match table as the real GPU
driver. Same HW right?

Also how sure are you that this loose detection is going to work with
future Intel discrete GPUs that likely won't need vfio_igd?

> nor I suspect the NVLINK support as that would require a kernel update
> every time a new GPU is released that makes use of the same interface.

The nvlink device that required this special vfio code was a one
off. Current devices do not use it. Not having an exact PCI ID match
in this case is a bug.

> As I understand Jason's reply, these vendor drivers would have an ids
> table and a user could look at modalias for the device to compare to
> the driver supported aliases for a match.  Does kmod already have this
> as a utility outside of modprobe?

I think this is worth exploring.

One idea that fits nicely with the existing infrastructure is to add
to driver core a 'device mode' string. It would be "default" or "vfio"

devices in vfio mode only match vfio mode device_drivers.

devices in vfio mode generate a unique modalias string that includes
some additional 'mode=vfio' identifier

drivers that run in vfio mode generate a module table string that
includes the same mode=vfio

The driver core can trigger driver auto loading soley based on the
mode string, happens naturally.

All the existing udev, depmod/etc tooling will transparently work.

Like driver_override, but doesn't bypass all the ID and module loading
parts of the driver core.

(But lets not get too far down this path until we can agree that
embracing the driver core like the RFC contemplates is the agreed
direction)

> Seems like it would be embedded in the aliases for the module, with
> this explicit binding flag being the significant difference that
> prevents auto loading the device.  We still have one of the races that
> driver_override resolves though, the proposed explicit bind flag is on
> the driver not the device, so a native host driver being loaded due to
> a hotplug operation or independent actions of different admins could
> usurp the device between unbind of old driver and bind to new driver.

This is because the sysfs doesn't have an atomic way to bind and
rebind a device, teaching 'bind' to how to do that would also solve
this problem.

> This seems unpredictable from a user perspective.  In either the igd or
> nvlink cases, if the platform features aren't available, the feature
> set of the device is reduced.  That's not apparent until the user tries
> to start interacting with the device if the device specific driver
> doesn't fail the probe.  Userspace policy would need to decide if a
> fallback driver is acceptable or the vendor specific driver failure is
> fatal. Thanks,

It matches today's behavior, if it is a good idea to preserve it, then
it can be so without much effort.

I do prefer the explicitness because I think most use cases have a
user that requires the special driver to run. Explicitly binding a
the required driver seems preferable.

Certainly nvlink and mlx5 should fail probe and not fall back to plain
vfio-pci. If user wants plain vfio-pci user should ask explicitly. At
least for the mlx5 cases this is a completely reasonable thing to
do. I like that we can support this choice.

I'm not so clear on IGD, especially how it would interact with future
descrete cards that probably don't need it. IMHO, it would be fine if
it was different for some good reason.

Jason
