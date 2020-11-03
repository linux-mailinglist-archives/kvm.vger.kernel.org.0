Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A1E2A4D78
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 18:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgKCRs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 12:48:59 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:17069 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727901AbgKCRs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 12:48:59 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1980a0000>; Wed, 04 Nov 2020 01:48:58 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 17:48:55 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 3 Nov 2020 17:48:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDxYyRy1xQoari4+JpC7Es1rNHQepteCOXVGYt7jOFQh/bIp3QZOh9wJcQF5cHkarBbRAtZ9J2jS4BTq1QR79bAeZE61Jbs0xV5WPNyhKsLaIFS7CkY3edIaWMMJjNZsWhnr+/vri3a5fMgNut5HsD6ee63CgDaKwfSRh7p5NJTt/ZWNVs6PJq31EemsEQ6U822d8wWSMgnazwmPHyeEr11GtrBOep8OgefLtIfHJsEdDVQCudgMyO7M8UqnnO0bclrp9oWdf6sslcKW4rHRQ1l8siTUeWhVuk+Ombq9NZOxWnLr1odYFv+0hqqSam1QGZZfyCZ37l8EgllivnKDrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sC2uAbdTvs/K1qkr9fwuV7dMmG1zUKG3QNxmdiVhw4E=;
 b=Q2SvuRIbC/sk7aMPV1CX4Jpno3+tJ6IxUeawORBnrSXzNyz2C8gPMbrEIGK4Fhtij6uV88WYnWuJlKTK3XwLJDHoPIG9N5jBsvPtAlblu3kr2UB1/YIpOj2EwVK8GbnTCjFhn7dgPhBNU7zAunhI/IIaKi2E+aQKTfPzQ/rccj9ZwERLdh/8UQWmbH0fCaV+W+aRpWWuyNqqeatVvN6CzyH+QMpbUsnBcwcYU16zGt26ozTHEcvNNm3ixPQy+xE2HPchZud2ePpvIrRaG1YJ+bkZjQSefPlX6hixun8c3VpLoU/yAG6TgqjpXW99uHZM7lBK4i2QfUxenTMwZ5Y0yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB3827.namprd12.prod.outlook.com (2603:10b6:a03:1ab::16)
 by BY5PR12MB4098.namprd12.prod.outlook.com (2603:10b6:a03:205::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Tue, 3 Nov
 2020 17:48:53 +0000
Received: from BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::2459:e095:ac09:34e5]) by BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::2459:e095:ac09:34e5%6]) with mapi id 15.20.3499.031; Tue, 3 Nov 2020
 17:48:53 +0000
Date:   Tue, 3 Nov 2020 13:48:51 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "joro@8bytes.org" <joro@8bytes.org>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Message-ID: <20201103174851.GS2620339@nvidia.com>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201103095208.GA22888@8bytes.org> <20201103125643.GN2620339@nvidia.com>
 <20201103131852.GE22888@8bytes.org> <20201103132335.GO2620339@nvidia.com>
 <20201103140318.GL22888@8bytes.org> <20201103140642.GQ2620339@nvidia.com>
 <20201103143532.GM22888@8bytes.org> <20201103152223.GR2620339@nvidia.com>
 <20201103165539.GN22888@8bytes.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201103165539.GN22888@8bytes.org>
X-ClientProxiedBy: MN2PR16CA0006.namprd16.prod.outlook.com
 (2603:10b6:208:134::19) To BY5PR12MB3827.namprd12.prod.outlook.com
 (2603:10b6:a03:1ab::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR16CA0006.namprd16.prod.outlook.com (2603:10b6:208:134::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 3 Nov 2020 17:48:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ka0QN-00G6Wc-73; Tue, 03 Nov 2020 13:48:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604425738; bh=sC2uAbdTvs/K1qkr9fwuV7dMmG1zUKG3QNxmdiVhw4E=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=LthxrhC1u4BG882dpQRLR0ro9hpDbqjHGU+44m6O4ZXSar//CnwosFFp7Eoxfohhg
         uJgpXlRPdHl7CLVCm00D3eFfoihx7ipEq6ZjCX9Kx8Cg5NTzD+2N+sHXGZzDqJKOy9
         mtYpjGF87trFgIozURvvaePlX7e3c3S4dcJ0bULaIl0E3y5GMTNMIhX6zfE7Oqz0wd
         oeorO9diTV/eTDPGxdrKrnXehmKQtqWvvGfnRAfAEGJ7dQTDfypCJVyZNuDX9P3z+y
         gTFUacpwdglv9TdMlMbNFEeXa2n5s8eyiJZNprbQ+Dm8FXAOfmYLaK0UVwaBHagDx4
         +KzNsv2u3x8eA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 05:55:40PM +0100, joro@8bytes.org wrote:
> On Tue, Nov 03, 2020 at 11:22:23AM -0400, Jason Gunthorpe wrote:
> > This whole thread was brought up by IDXD which has a SVA driver and
> > now wants to add a vfio-mdev driver too. SVA devices that want to be
> > plugged into VMs are going to be common - this architecture that a SVA
> > driver cannot cover the kvm case seems problematic.
> 
> Isn't that the same pattern as having separate drivers for VFs and the
> parent device in SR-IOV?

I think the same PCI driver with a small flag to support the PF or
VF is not the same as two completely different drivers in different
subsystems

Jason
