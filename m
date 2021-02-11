Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8C6318D72
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 15:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhBKOdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 09:33:18 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16335 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbhBKObh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 09:31:37 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60253f990000>; Thu, 11 Feb 2021 06:30:49 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 14:30:49 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 11 Feb 2021 14:30:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iv19qMUXecajA/tbymTlDKYJeNyQMTkg/I9kTXAWBrLLi7OsbaWaH4NxXH7UjIhB2Woj7HbHoxV5RrLv02m0N2575Brf7+/sqtDzn2/l36JhpyOvW6GSAbm5pNkpNica1oQgy4ezp+IScqO6MiGFpEXiHsmCIsNpOCUv/7DQVgI4vmASlfqLnr2M0TA3PlvbXEDhcV09ZOS+rWwoG4qqCFzNIxXwz0eLFy7gAMw5p2oLcuIs4dzUN0NrsVrrvt9xya7Ccc3iikNuOqWMeJ3ORMLlqmGZsgIP3LSN0/ge5VEHuQMTzoQc1NsBzgz1ldTSDUe1PG+DbuRIN0lJKtAT/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7nKd3dmyg2gLvH5i0GxKCYdZ6J7V3/q54MxPu5AyGw=;
 b=feM9Ba+dR/cDVqUBrWkftDrkLfYiX7MWcNC1J6LX2Q2gRft9AMe+liVp57ByGa+IxAccc6QPwLqBjlzrMLicg0DjD2lzI5MfPMnGpIROAt/kWaiSVRB27XXwXd7JbBWGoQHjsb92B8mTUe85Alh47sundjYiTTIZ1pNkwNOXFDemK2uEh/eQX3u/Yqurm2O/Zw5VR51JN1QFVbmfkqcgaFb1f9SlSXArB43qpo1ldKimflz9N+C0rcS66TaTVHqtqS4dJ2HIlygU2QMaBSo56J+LKZYuNBV7BC7DdNBLfPJpI/vzLlZRVFFOMxpzv30wjDZUuObs69AIG80Z92pgnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB3827.namprd12.prod.outlook.com (2603:10b6:a03:1ab::16)
 by BY5PR12MB3827.namprd12.prod.outlook.com (2603:10b6:a03:1ab::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 14:30:46 +0000
Received: from BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::10d:e939:2f8f:71ca]) by BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::10d:e939:2f8f:71ca%7]) with mapi id 15.20.3846.027; Thu, 11 Feb 2021
 14:30:46 +0000
Date:   Thu, 11 Feb 2021 10:30:44 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <aik@ozlabs.ru>
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210211143044.GL4247@nvidia.com>
References: <20210202105455.5a358980@omen.home.shazbot.org>
 <20210202185017.GZ4247@nvidia.com>
 <20210202123723.6cc018b8@omen.home.shazbot.org>
 <20210202204432.GC4247@nvidia.com>
 <5e9ee84e-d950-c8d9-ac70-df042f7d8b47@nvidia.com>
 <20210202143013.06366e9d@omen.home.shazbot.org>
 <20210202230604.GD4247@nvidia.com>
 <20210202165923.53f76901@omen.home.shazbot.org>
 <20210203135448.GG4247@nvidia.com> <20210211084703.GC2378134@infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210211084703.GC2378134@infradead.org>
X-ClientProxiedBy: BLAPR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:208:329::18) To BY5PR12MB3827.namprd12.prod.outlook.com
 (2603:10b6:a03:1ab::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0073.namprd03.prod.outlook.com (2603:10b6:208:329::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 14:30:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lACzU-006XwK-BW; Thu, 11 Feb 2021 10:30:44 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613053849; bh=U7nKd3dmyg2gLvH5i0GxKCYdZ6J7V3/q54MxPu5AyGw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=NJ9mFS1xoNChrioJDLDjYgOWP20ZAYXpq7ao7DBBs9Isjk+pB++FZMQj8GR71wA/S
         5QB+B2ZL8XIe9xp2BeIQwZqkfDVtdh4b8oy3VtybyBtavUVwfEP8L9F2inGjZVmBbe
         y0sXfVCpY94QtlJvuYIJ9bnEJG1beyLTL8H2Gn95GQbJVNfymHqmWvXnloyHZ0C+9B
         P7CfJdRc0ku2qEhgkLDzx1+XMDy8L8IY9j3tGZP/TnWdpUduuDU98Bro8Lxb6zPZN7
         mw59E3a2Yv36v6/Ftg/U/DyvzgEj/qt6uo+K+eGfCs4CiIEpAnHQwh1dZXQuvncN7+
         pIR+VpZDM+q4Q==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 11, 2021 at 08:47:03AM +0000, Christoph Hellwig wrote:
> On Wed, Feb 03, 2021 at 09:54:48AM -0400, Jason Gunthorpe wrote:
> > If people are accepting that these device-specific drivers are
> > required then we need to come to a community consensus to decide what
> > direction to pursue:
> > 
> > * Do we embrace the driver core and use it to load VFIO modules like a
> >   normal subsytem (this RFC)
> > 
> > OR 
> > 
> > * Do we make a driver-core like thing inside the VFIO bus drivers and
> >   have them run their own special driver matching, binding, and loading
> >   scheme. (May RFC)
> > 
> > Haven't heard a 3rd option yet..
> 
> The third option would be to use the driver core to bind the VFIO
> submodules.  Define a new bus for it, which also uses the normal PCI IDs
> for binding, and walk through those VFIO specific drivers when vfio_pci
> is bound to a device.  That would provide a pretty clean abstraction
> and could even keep the existing behavior of say bind to all VGA devices
> with an Intel vendor ID (even if I think that is a bad idea).

I think of this as some variant to the second option above.

Maximally using the driver core to make subdrivers still means the
VFIO side needs to reimplement all the existing matcher logic for PCI
(and it means we don't generalize, so future CXL/etc, will need more
VFIO special code)  It has to put this stuff on a new special bus and
somehow make names and match tables for it.

It also means we'd have to somehow fix vfio-pci to allow hot
plug/unplug of the subdriver. The driver core doesn't really run
synchronously for binding, so late binding would have to be
accommodated somehow. It feels like adding a lot of complexity for
very little gain to me.

Personally I dislike the subdriver direction of the May RFC quite a
bit, it has a lot of unfixable negatives for the admin side. The first
option does present some challenges for userspace but I belive we can
work through them.

Jason
