Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FBB3049E5
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 21:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732210AbhAZFUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:20:41 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14513 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731076AbhAZCPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 21:15:16 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f66290001>; Mon, 25 Jan 2021 16:45:29 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 00:45:28 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 00:45:26 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 26 Jan 2021 00:45:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AY+amw+kPz/gXpM6Tn461MWjmzeR9nLE3qZp4uE3szwpiE2XBWIHZg/4hZeS6VL6DW+v11Rve8ENrGmobYvg803GRM2msAOcpdBAA99PAJMa+oBnWrweJflP3hrLA+hgLI8hRVhOr/gjXR6dGIE42Kbhx6g0XuC9HZgf/ldGRhJYQRb+eGTuFANFJoEjKCqyEwNijUIzVdhWX/O/w76lCAVQNaACn3HrcHO4Eqax7BVWAPMUERdb5HkXTt9jZKm5Rq1Mc7ohMMz8VUnqaWrty0DMOZJH00AQDHTkaiFTZl5wV9tqySzNe34ixqi7ek0GdksZjAfjUOYV50SNtgjEGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QhmjS2MZUZWBzoJ7bCYYMkTO08YBu4ofgJSaiEitzq8=;
 b=PMnrmN32n5WaeEAXRBp6DEUtoLPdbpc+L7ViVgCtinHTascAkJP97nqdwZZuKJZcxrk5NZ3BT7Z7QJMmubAbYsGJ0ODfecL3umB9K0Cch5/z7tQR/Pno0s4ydaQ0xqsPzZUka28hB6LlPfSbMuSkLmszXAz7XrJ53uhRtW620HQbq3GF49E9Cp/uRj2u4Db1KxqPlVlMujtiH+H4/DxXaN4En6pyANHSXbRMemM2NcMnfk/FCzoxz0WUbpialJwhF/92ZovZIJRc6q20yaUv082p84X8QqborTv9fVWb9YuSMmclerA0qjyGEO1Cu1yrHuAqlyz0w1vKp5m8rNquOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0204.namprd12.prod.outlook.com (2603:10b6:4:51::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Tue, 26 Jan
 2021 00:45:24 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 00:45:24 +0000
Date:   Mon, 25 Jan 2021 20:45:22 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210126004522.GD4147@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
 <20210122122503.4e492b96@omen.home.shazbot.org>
 <20210122200421.GH4147@nvidia.com>
 <20210125172035.3b61b91b.cohuck@redhat.com>
 <20210125180440.GR4147@nvidia.com>
 <20210125163151.5e0aeecb@omen.home.shazbot.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210125163151.5e0aeecb@omen.home.shazbot.org>
X-ClientProxiedBy: BL1PR13CA0151.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::6) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0151.namprd13.prod.outlook.com (2603:10b6:208:2bd::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.7 via Frontend Transport; Tue, 26 Jan 2021 00:45:23 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l4CTy-006syy-CG; Mon, 25 Jan 2021 20:45:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611621929; bh=QhmjS2MZUZWBzoJ7bCYYMkTO08YBu4ofgJSaiEitzq8=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=MR6BCwPR3+9b4q7M4t+gFdcglgAKx5CBtdskh53Mr/N1bXovIsNBH2RhWAwSqV4Nv
         a/2dfrQ2D9c7+5ctYCjjf6FpOCeDoBodq1FFLCyhGS6MU7XAm1jkn3Rnvn9BS8qHWI
         0bg+AAeOQacmEb+zu6KsJWmVXTVMC+6cey1PcghM1iRcyrYds3GnA1cSfWRjC596x3
         hODiwIRuDnoRfx9K0iWXK02Mr8U7Yv7T5L8+edT4fE92Szey4bhKSTQNYLVBuG5YM3
         cv99tPFiQjy96uZhsluY0Dl92jPSTELONewdtGo+dCRAJyOi5eDQ3TY5phlKwpIyff
         A2/042Azro33g==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021 at 04:31:51PM -0700, Alex Williamson wrote:

> We're supposed to be enlightened by a vendor driver that does nothing
> more than pass the opaque device_data through to the core functions,
> but in reality this is exactly the point of concern above.  At a
> minimum that vendor driver needs to look at the vdev to get the
> pdev,

The end driver already havs the pdev, the RFC doesn't go enough into
those bits, it is a good comment.

The dd_data pased to the vfio_create_pci_device() will be retrieved
from the ops to get back to the end drivers data. This can cleanly
include everything: the VF pci_device, PF pci_device, mlx5_core
pointer, vfio_device and vfio_pci_device.

This is why the example passes in the mvadev:

+	vdev = vfio_create_pci_device(pdev, &mlx5_vfio_pci_ops, mvadev);

The mvadev has the PF, VF, and mlx5 core driver pointer.

Getting that back out during the ops is enough to do what the mlx5
driver needs to do, which is relay migration related IOCTLs to the PF
function via the mlx5_core driver so the device can execute them on
behalf of the VF.

> but then what else does it look at, consume, or modify.  Now we have
> vendor drivers misusing the core because it's not clear which fields
> are private and how public fields can be used safely,

The kernel has never followed rigid rules for data isolation, it is
normal to have whole private structs exposed in headers so that
container_of can be used to properly compose data structures.

Look at struct device, for instance. Most of that is private to the
driver core.

A few 'private to vfio-pci-core' comments would help, it is good
feedback to make that more clear.

> extensions potentially break vendor drivers, etc.  We're only even hand
> waving that existing device specific support could be farmed out to new
> device specific drivers without even going to the effort to prove that.

This is a RFC, not a complete patch series. The RFC is to get feedback
on the general design before everyone comits alot of resources and
positions get dug in.

Do you really think the existing device specific support would be a
problem to lift? It already looks pretty clean with the
vfio_pci_regops, looks easy enough to lift to the parent.

> So far the TODOs rather mask the dirty little secrets of the
> extension rather than showing how a vendor derived driver needs to
> root around in struct vfio_pci_device to do something useful, so
> probably porting actual device specific support rather than further
> hand waving would be more helpful. 

It would be helpful to get actual feedback on the high level design -
someting like this was already tried in May and didn't go anywhere -
are you surprised that we are reluctant to commit alot of resources
doing a complete job just to have it go nowhere again?

Thanks,
Jason
