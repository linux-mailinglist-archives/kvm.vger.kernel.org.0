Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4252A4966
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 16:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgKCPWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 10:22:40 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:19793 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728128AbgKCPWf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 10:22:35 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa175b50000>; Tue, 03 Nov 2020 23:22:32 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 15:22:28 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.50) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 3 Nov 2020 15:22:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBpw/9U7MxGWo1oEJuhzooogF1Psr5UmirKKADi7OtnQYHHaXdIO9PC7bQUOk2/iQzXiBFIV3rfTtnnBr4nqXkwaJzcwWS+larmIUZTbbxySVjaduW8YnFrfoiUfRB8c2uDZvJnNiJIQ71Ao/EciIvQz/0wk5ms8s1SGXMuOeIzQHAiNVjz2eAz1VU2SR9Eb45rY/uA2mUsYxp0+M4iFrpUH0bX2nwJJrIPDGJWzeJgZTLpcNzILQWcph9T77fZWEtFHYM+XypgwbNbbq3tys8BL5rVK/zyzWeoO7pgYdc9EiBENFHYM64JOoniuvVNpXGfbjOgN4dHvZbN/C07B1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTB337qpENG6+Ub3MecN1tM4eUGLVriCkTyaDVGu/Nc=;
 b=V5NGjtdhtGPR93dDMRg9UZBG+dsHX3claSsaHdbp25ESz0VT8xAc5FPGEcWGhNszWGOfSNygLuW/FAMKBbwSe3pPcsKbbwoAI7qhVmvpBoeQt1uEjSfFVhe6TgIHFJyOFAGoSnj0cwRkN+PIx0HaCmILzz21PCPmfchr06AVEW9w8RtL54TxGiAQls8xjDk5+wfHImME6a/7glsIFs8KH9td3WmQnfu5X8ohUnDGrB763HQwnHWbMYyMnoCqpdUN3RUAquY8g83k5z+hyEyzQ0WF48EJCDD/CqSzpf8PNn5L3r1C8y+sX2h1ngHcg5mpXvYtoWM334HZGwasgPIv4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB3827.namprd12.prod.outlook.com (2603:10b6:a03:1ab::16)
 by BY5PR12MB3700.namprd12.prod.outlook.com (2603:10b6:a03:1a5::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 15:22:25 +0000
Received: from BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::2459:e095:ac09:34e5]) by BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::2459:e095:ac09:34e5%6]) with mapi id 15.20.3499.031; Tue, 3 Nov 2020
 15:22:25 +0000
Date:   Tue, 3 Nov 2020 11:22:23 -0400
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
Message-ID: <20201103152223.GR2620339@nvidia.com>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201103095208.GA22888@8bytes.org> <20201103125643.GN2620339@nvidia.com>
 <20201103131852.GE22888@8bytes.org> <20201103132335.GO2620339@nvidia.com>
 <20201103140318.GL22888@8bytes.org> <20201103140642.GQ2620339@nvidia.com>
 <20201103143532.GM22888@8bytes.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201103143532.GM22888@8bytes.org>
X-ClientProxiedBy: BL1PR13CA0171.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::26) To BY5PR12MB3827.namprd12.prod.outlook.com
 (2603:10b6:a03:1ab::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL1PR13CA0171.namprd13.prod.outlook.com (2603:10b6:208:2bd::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.10 via Frontend Transport; Tue, 3 Nov 2020 15:22:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kZy8d-00Fw0D-OO; Tue, 03 Nov 2020 11:22:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604416952; bh=kTB337qpENG6+Ub3MecN1tM4eUGLVriCkTyaDVGu/Nc=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=lC7TQy6xEH/zdcCUP9nabNZtNzwHIE0KCgh2M6go3va8h+Z6Lf3mewBtT5CG24bTt
         75/tsIQfMaFd8VHDoOxStwNwya/i16S1rdI8X0pRNtxTopVg5PVIDkWPU2uUtbmoCr
         0s+bf8CfhFF+p9cX6dQEHaIbBcnorUo7F85QH5p8x6xNDt9jPV3rg6lBgfk4oTA7/n
         mTqSQi+SaOkym9uVp+Jb1BOeQ2xnS7Xdy0KPRuqlt1JZgTwJ5pPcN8weE6Sbt5hXg4
         L4TO5tFXCyGW7I8zLzeCyk+6tR5tnMIxKFgmLfwWOrzisi/MlJbfFbNrF9e8IPBCgc
         fIVMSpQrR81Zw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 03:35:32PM +0100, joro@8bytes.org wrote:
> On Tue, Nov 03, 2020 at 10:06:42AM -0400, Jason Gunthorpe wrote:
> > The point is that other places beyond VFIO need this
> 
> Which and why?
>
> > Sure, but sometimes it is necessary, and in those cases the answer
> > can't be "rewrite a SVA driver to use vfio"
> 
> This is getting to abstract. Can you come up with an example where
> handling this in VFIO or an endpoint device kernel driver does not work?

This whole thread was brought up by IDXD which has a SVA driver and
now wants to add a vfio-mdev driver too. SVA devices that want to be
plugged into VMs are going to be common - this architecture that a SVA
driver cannot cover the kvm case seems problematic.

Yes, everything can have a SVA driver and a vfio-mdev, it works just
fine, but it is not very clean or simple.

Jason
