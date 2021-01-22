Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA88C300D55
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 21:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbhAVUG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 15:06:28 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13316 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728779AbhAVUFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 15:05:16 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600b2fca0002>; Fri, 22 Jan 2021 12:04:26 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 22 Jan
 2021 20:04:26 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.56) by
 HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 22 Jan 2021 20:04:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fUaxEc96NFK6UR+1A9Lh9DLz5tBl8McaKudugngxAe1/I8PwaNkdMNIn9frnHqbyRCWj6MEgqgVb7A/r6O+a1ijL+6GNv3ZPRa3lDWI+WIo9tg4BfTZscbPkDBwvmKcjqwEIWw+3kcJAKpT3LUzeYZOVN0Hn9vjAlOZtINUz1EFv9iG0lrjg4epK7TtCnUxQWtO55yucePUddalyDaDE1E2jQsx3Uq1wtXgSXyXmSCiAmaJbgXlE01jF8SUOowcGXHGcY+ALaZ4DCL9jiSMwIO/LKwwgc5t6neX4cfIAFOXFwjjyNCaesUkHCY0ETN4jDOe1kgwGVOPapam7TwXvLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwae+nAkyaitQ5r/JDyXnK+1DFTHWiCNVWiQuy9YHOg=;
 b=hOz1J09YQ1yk2Q0qOXf1lTW5qJ6JglkauFOW4z81dhB8geVUR5CqARAwSoCWEOyL8Z1o80mwupN+zHvQPcD7b1UYOglNL5RwfCafSMSmwlikhM75nSzEhVua3H5XnvUss/UHbuwS46X+szlpLPXT52++ZMzLhbvWFjM/A35B8+9PC0kCfWd3WO/Tk2CUeQXh/XsyBkq53lluHfiNSXRBMiSLe04Ks1wqzwgT+1a4A2Hhmp+a2oD01xJ/0qgPr8iO/smIpmoagcFEblI0PSO7in2u2GMITaj9E32sSBnm8g67ADkykrbdZAK0/lzRvbtgkstQvlvIeSE9I/gPL/dJYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1548.namprd12.prod.outlook.com (2603:10b6:4:a::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.13; Fri, 22 Jan 2021 20:04:25 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.011; Fri, 22 Jan 2021
 20:04:23 +0000
Date:   Fri, 22 Jan 2021 16:04:21 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210122200421.GH4147@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
 <20210122122503.4e492b96@omen.home.shazbot.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210122122503.4e492b96@omen.home.shazbot.org>
X-ClientProxiedBy: MN2PR19CA0006.namprd19.prod.outlook.com
 (2603:10b6:208:178::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR19CA0006.namprd19.prod.outlook.com (2603:10b6:208:178::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 20:04:22 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l32fN-005clx-HC; Fri, 22 Jan 2021 16:04:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611345866; bh=vwae+nAkyaitQ5r/JDyXnK+1DFTHWiCNVWiQuy9YHOg=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=YvNzyBCzr2zuqD3nvxCRT3ycZznulK3wV7OWJQhvPTz8xd0zSvJ7BMTcuURxoNswv
         coAZWwrKAdII3fzI1JWhnSpHwsv/gW/Krr5vuanIbETxzcyk5+HhxpQ8uWw7T8n0Bm
         ypMQe9ubOd6MT66mijCpSL+70n+1e6B2CWmd106IuTy2S11xWokh0MayOIFbsZk7UK
         CZXzRWc+nhKSaeBVS7w4qes90I0jt3PvJG12ElzF9ZqhWcHX2TUEAAiU7dlraK2O5a
         X6F2JpO6Rvhf9RwakEQfj05vc/53/+IjpLdFlRiULXjp1m9kFoE1vYxjNOokxePMNM
         2R+iqJEeODXPA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 22, 2021 at 12:25:03PM -0700, Alex Williamson wrote:

> Is the only significant difference here the fact that function
> declarations remain in a private header?  Otherwise it seems to
> have all the risks of previous attempts, ie. exported symbols with a
> lot of implicit behavior shared between them.

If you want to use substantial amounts of vfio-pci for multiple
drivers then what other choice is there? You and I previously talked
about shrinking vfio-pci by moving things to common code, outside
VFIO, and you didn't like that direction either. 

So if this shared code lives in vfio-pci, vfio-pci must become a
library, because this code must be shared.

The big difference between the May patch series and this one, is to
actually starts down the path of turning vfio-pci into a proper
library.

The general long term goal is to make the interface exposed from the
vfio_pci_core.ko library well defined and sensible. Obviously the
first patches to make this split are not going to get eveything
polished, but set a direction for future work. 

This approach is actually pretty clean because only the ops are
exported and the ops API is already well defined by VFIO. The internal
bits of vfio-pci-core can remain hidden behind a defined/restricted
API.

The May series lacks a clear demark for where the library begins/ends
and vfio_pci.ko start, and doesn't really present a clean way to get
anywhere better.

Also the May series developed its own internalized copy of the driver
core, which is big no-no. Don't duplicate driver core functionality in
subsystems. This uses the driver core much closer to how it was
intended - only the dual binding is a bit odd, but necessary.

> noted in 2/3, IGD support could be a separate module, but that's a
> direct assignment driver, so then the user must decide to use vfio-pci
> or igd-vfio-pci, depending on which features they want.

Which I think actually makes sense. Having vfio-pci transparently do
more than just the basic PCI-sig defined stuff is a very confusing
path.

Trying to make vfio_pci do everything for everyone will just be a huge
incomprehensible mess.

> > This subsystem framework will also ease on adding vendor specific
> > functionality to VFIO devices in the future by allowing another module
> > to provide the pci_driver that can setup number of details before
> > registering to VFIO subsystem (such as inject its own operations).
> 
> Which leads us directly back to the problem that we then have numerous
> drivers that a user might choose for a given device.

Sure, but that is a problem that can be tackled in several different
ways from userspace. Max here mused about some general algorithm to
process aux device names, you could have userspace look in the module
data to find VFIO drivers and auto load them like everything else in
Linux, you could have some VFIO netlink thing, many options worth
exploring.

Solving the proliferation of VFIO drivers feels like a tangent - lets
first agree having multiple VFIO drivers is the right technical
direction within the Linux driver core model before we try to figure
out what to do for userspace.

> > In this way, we'll use the HW vendor driver core to manage the lifecycle
> > of these devices. This is reasonable since only the vendor driver knows
> > exactly about the status on its internal state and the capabilities of
> > its acceleratots, for example.
> 
> But mdev provides that too, or the vendor could write their own vfio

Not really, mdev has a completely different lifecycle model that is
not very compatible with what is required here.

And writing a VFIO driver is basically what this does, just a large
portion of the driver is reusing code from the normal vfio-pci cases.

Jason
