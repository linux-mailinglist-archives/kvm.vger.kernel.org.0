Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8131F2A462B
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 14:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgKCNXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 08:23:44 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5499 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729009AbgKCNXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 08:23:43 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa159e30000>; Tue, 03 Nov 2020 05:23:47 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 13:23:39 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 3 Nov 2020 13:23:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=baoh+3G0UOEFC0x0pRkAlELZ28LTEjAgwW6AcPK9wNDoPLFUHE5GHOEEJ38SI2rKlbk9umJSLh/7NlBq7yg3G8LvcBDBtWqthHxLmYhNBxYVT1X0qS0VBcsw+8XtMiajArTUzija4YVD5rEpGmTr9VAUkJ1l892B1XZi87gCphtdAZwFULpRUs2+1LsiIAVJTCj0T50PGlNFh07SA7aOIxpM1Be6GpGPuWV4DX8TXa6e+F4f0737WdFWAY+mba7qnFdVjYLK/rWwielN0dUzZxL4lmXIbjpTCCyqK1nxrNhSfJqi9fFosxJ/Tvp2j3L3UOufVgzsHjAxkPCwIT/org==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPhr80/Zo4aBoI+9EqDjNUx3YiFdv6OFGK7F/cOYf78=;
 b=l8zf5SJhefDcEREGx3o7/BsuEsRpjFcKL330hvCAmXPNYvCUbFPGZiLvdrxnkYAMLpxXg97thYo0qy2YVwhSOrD+gVVc5KyqKtiA7K1tcxRhA9B/G+jU0Fl8Ovz9N6VHTuMbGPkNP0k8na0ZSttqyquPTVp9rF0L4lA5VcbylXVp0e3ulY0pbFXpAwS34CccRLXnuaPPs2MEMFMWG5+NjzOxNEs7wOW7+0QvW3gbB8CAHy+LbiUFzrMhz7n1XcA98L93llaWekerLpf357ZuNa+hqPhiOWQgtPi5z3CZva0q5eCHuOzlvei4RyRee+QIZJVVNtVNShu5U8pTKiIOkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB3827.namprd12.prod.outlook.com (2603:10b6:a03:1ab::16)
 by BY5PR12MB4097.namprd12.prod.outlook.com (2603:10b6:a03:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.22; Tue, 3 Nov
 2020 13:23:38 +0000
Received: from BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::2459:e095:ac09:34e5]) by BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::2459:e095:ac09:34e5%6]) with mapi id 15.20.3499.031; Tue, 3 Nov 2020
 13:23:38 +0000
Date:   Tue, 3 Nov 2020 09:23:35 -0400
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
Message-ID: <20201103132335.GO2620339@nvidia.com>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201103095208.GA22888@8bytes.org> <20201103125643.GN2620339@nvidia.com>
 <20201103131852.GE22888@8bytes.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201103131852.GE22888@8bytes.org>
X-ClientProxiedBy: BL0PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:208:2d::33) To BY5PR12MB3827.namprd12.prod.outlook.com
 (2603:10b6:a03:1ab::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR03CA0020.namprd03.prod.outlook.com (2603:10b6:208:2d::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 3 Nov 2020 13:23:37 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kZwHf-00Fu34-VJ; Tue, 03 Nov 2020 09:23:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604409827; bh=EPhr80/Zo4aBoI+9EqDjNUx3YiFdv6OFGK7F/cOYf78=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=Lipyw7vJ9UAzFb4X6yTeVG8Nyr9WEonStZBjUJQ9CfpP9thKM8nnQ5vTL661CWTPr
         9rvI9Fob8SFI5KWKKaA+/7pTxXqs1I6x93Jz3gaoTaOnoHsgkgV9qQQqnzO2ZI8oOc
         uGKCx23uS094uYZZb3vrg6xrClyi4/80K+badZ5S5yrcn2caxC6/tS+FNFtF6mxZH1
         y+iPD2B9iJ6bZcn5eA2byggl4aXovCOVJ+JABlfkQd+s0+P7MSu075uYpzQmqS/pTr
         b85HrXiwGY9XWnMNozZgSx0mGed4+1Imnw9K18tlX7tSs7w8BmWAeEIk8Bj87FwcuQ
         kPz6X3jUEMDYQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 02:18:52PM +0100, joro@8bytes.org wrote:
> On Tue, Nov 03, 2020 at 08:56:43AM -0400, Jason Gunthorpe wrote:
> > On Tue, Nov 03, 2020 at 10:52:09AM +0100, joro@8bytes.org wrote:
> > > So having said this, what is the benefit of exposing those SVA internals
> > > to user-space?
> > 
> > Only the device use of the PASID is device specific, the actual PASID
> > and everything on the IOMMU side is generic.
> > 
> > There is enough API there it doesn't make sense to duplicate it into
> > every single SVA driver.
> 
> What generic things have to be done by the drivers besides
> allocating/deallocating PASIDs and binding an address space to it?
> 
> Is there anything which isn't better handled in a kernel-internal
> library which drivers just use?

Userspace needs fine grained control over the composition of the page
table behind the PASID, 1:1 with the mm_struct is only one use case.

Userspace needs to be able to handle IOMMU faults, apparently

The Intel guys had a bunch of other stuff too, looking through the new
API they are proposing for vfio gives some flavour what they think is
needed..

Jason
