Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB5626C54A
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 18:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgIPQpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 12:45:45 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:4356 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgIPQda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 12:33:30 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f623e340000>; Thu, 17 Sep 2020 00:32:52 +0800
Received: from HKMAIL103.nvidia.com ([10.18.16.12])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Wed, 16 Sep 2020 09:32:52 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Wed, 16 Sep 2020 09:32:52 -0700
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Sep
 2020 16:32:50 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Sep 2020 16:32:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9CwzWQodcMoC6fpiQLjyJYN8+5JOqtjhUJ9tllmWXJhK3T2f5KBN53Dv+hYILxM58PRHrRT/3L/B/CPJuuMDLGjyd2bVRak2jbLgHdk48ZwH0bsoiCq2odptLmbLvJf4Vf7PajEzNbTsLP0hGS7T669S8wRs35kMQe5PXIc8hKKBo7igCLlToT0uHj4QmbH9mfCKnZCt0bB30SWtREmVg0ic8zUK5QDz4OCi7xKS//MirHJdNfiW+CNFiyZHsKYLVV9/cEmEn7Cq24TH59G7H1LfIiZG7LvWubP/qwIzm/OMXCRrAyFnWrCVUrt3hLgHaa7jPIrfh+D8ZMO/E80Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPRXU3d7kZ8NOgReGG773i7RFqKldXjhhu16Kxzb11g=;
 b=cX69Wyd9vKMzoTOoz7Ea8cNm9ptCCsR75oG7jLikx/SOVptFv09TEd7gGONHcwdoOnEydqP5RQgyfezRi6GXiPxXyXjB/a0CPIzReWWmU6cRsbSuVjC/oNFCmtt/f9xSMC2qoNHJ0B4houDzP+v4w6vxyEcimoCTvQigaNBja+852rmJovIPf/k4C5vujqq+2PuHPLKkBddlTSg5tTf7b4UixyMKCRcHL2PTSHkvre46wedzTfSrVcm6gBp39qPjkuKNKvJTlHgtZoyZRMjEfsx9FgBEAiUiMVHrg44BJZQ99DOvGjuUaiOBpCzsuzzcgdyP+MrSYqbA9MsKZLvgCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4265.namprd12.prod.outlook.com (2603:10b6:5:211::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Wed, 16 Sep
 2020 16:32:47 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 16:32:47 +0000
Date:   Wed, 16 Sep 2020 13:32:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200916163246.GC3699@nvidia.com>
References: <20200914105857.3f88a271@x1.home>
 <20200914174121.GI904879@nvidia.com> <20200914122328.0a262a7b@x1.home>
 <20200914190057.GM904879@nvidia.com> <20200914163310.450c8d6e@x1.home>
 <20200915142906.GX904879@nvidia.com>
 <MWHPR11MB1645934DB27033011316059B8C210@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200916083217.GA5316@myrica> <20200916145148.GD6199@nvidia.com>
 <20200916162052.GE5316@myrica>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200916162052.GE5316@myrica>
X-ClientProxiedBy: BL0PR0102CA0045.prod.exchangelabs.com
 (2603:10b6:208:25::22) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR0102CA0045.prod.exchangelabs.com (2603:10b6:208:25::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Wed, 16 Sep 2020 16:32:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kIaMQ-0004qL-6o; Wed, 16 Sep 2020 13:32:46 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e9e48f5-48d0-447f-0c38-08d85a5e2564
X-MS-TrafficTypeDiagnostic: DM6PR12MB4265:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4265BA2849653D16F55FC0A6C2210@DM6PR12MB4265.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k4wKUhGEOLjkuN152OUoI6RbQDGEoXTPK0A1Tm6FwJkB1r4uXHl5lsRFrgMw1YZV7L9HU8CAKKl+8UgtWY19Tzktk7vBn8Fy8AUSVxvW39e6rbPSGcS+Gs6HCUiluIVbG+OjUNrEhLL94zuirkCkLWc147IValVOsr/W4+m7BzSqg0o4Y0cgTp4JLlJmFOQa1FF7bjshGgw89uZj3txKScwPsRd2HxlOHMxDj2/+C4s8orPodp/m5JAWEETrFQ52VTGehpGbjGqONkPKqghPd7SWXT4Y5vEuQ/CBH3Q2bxb3ndlAv0LuXxdw9mJGyLyfUl1tbDqGpZYmvIyUichTPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(4326008)(186003)(8676002)(36756003)(9786002)(9746002)(86362001)(33656002)(316002)(6916009)(478600001)(26005)(5660300002)(54906003)(66556008)(426003)(66476007)(66946007)(1076003)(7416002)(2616005)(8936002)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IyfvYqvinpdM6hpO/aBkVFEPDwyPcuFK2smWfrUWlHAgxqc9dhkrndobFgw6j+Tt9eL1InHfAG3gEB9cVSBtkb53vAKD1t8Uitgcv/SaIXVJ/NZRB3KZOMb9J8kshM7SjN9nXFV27X5e2T6aTf8o9wJfTryuTjFj24AD8O3F0p4rN4nrC6F0oDI4tfX/g8IC0c2JQUW+2oHGHbUcXzTMDhVCBwDoCs2cP79VIeZ9wjxFRxZJMvXuIaU40mEVQM9rID2pgALNnw8zkTR7nboQTAfaZ8SWlwFVa/K9feu34PLO3GtIwVoltNJLVtqyG/DISqDP8qCnDrbeCoGRJssBrC/BBWnGGsajVXz2Wk0dWug0Vya1hkA6Q34k8f98GAwTMU36vl7tuidfFg5w5H3BME+QmGX/qHljHh1uMFC8/wvUhzG7JCWEqJJpI3CzL+eKV8UcM4ydvo6dI1q6htzYtYj3Xyas/mSCzG/uucmM/ZWkP9lqIv0PLX41HlSZQI/4swGLeFccPS+1PdLRciHy04V22bXx/iJmwdvWMmRtXg4zx0XsDYypM0Q/8Cv26oZdHeevduyLUIL8UktfxfozD8zcR/0QzWZ7YIgH7WQRTFKeDUJRF14Bcl7RUpXqqBEj3T6fnHczyNsmkYh6Pf0jmg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e9e48f5-48d0-447f-0c38-08d85a5e2564
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 16:32:47.6123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CzUTsuN0zDxK0yWySe5S0UQ5mh8fdp16aL/hxodSS0RqqFQoW/57NR3JrKY8mUzr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4265
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600273972; bh=dPRXU3d7kZ8NOgReGG773i7RFqKldXjhhu16Kxzb11g=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=afDXwjuP7DaNVKDMfp2KcGG4nfRP/3mBGIXSFtg5VNoEeddLbZbvhx3NCWZR4ITO4
         Ya3YYawZtPuHIU3C9ScCgEYd8DRELwq/VyV782/uiORjLn9+yc3QN8MIKRp6LG0yVM
         IMrC8Vnc5hk2xPzng+sW7UlnTs9w6WPdlBCIgEj/sMwo7cUCPYW/ogmFgvB+eWQVD0
         HNBp0AIrZJ2+iK4TWYDyOwC+DWV/XfdI+tgtccetDApVV3nyg6s6J1rMdIFrYUiLXT
         5/gk6k/Mq18GzB1kiit2+LhhtNpTayzWhXY37clkYP7M0Kow7jyOEW+a/t/5XDD8s0
         stKMU9WXO3q4Q==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 16, 2020 at 06:20:52PM +0200, Jean-Philippe Brucker wrote:
> On Wed, Sep 16, 2020 at 11:51:48AM -0300, Jason Gunthorpe wrote:
> > On Wed, Sep 16, 2020 at 10:32:17AM +0200, Jean-Philippe Brucker wrote:
> > > And this is the only PASID model for Arm SMMU (and AMD IOMMU, I believe):
> > > the PASID space of a PCI function cannot be shared between host and guest,
> > > so we assign the whole PASID table along with the RID. Since we need the
> > > BIND, INVALIDATE, and report APIs introduced here to support nested
> > > translation, a /dev/sva interface would need to support this mode as well.
> > 
> > Well, that means this HW cannot support PASID capable 'SIOV' style
> > devices in guests.
> 
> It does not yet support Intel SIOV, no. It does support the standards,
> though: PCI SR-IOV to partition a device and PASIDs in a guest.

SIOV is basically standards based, it is better thought of as a
cookbook on how to use PASID and IOMMU together.

> > I admit whole function PASID delegation might be something vfio-pci
> > should handle - but only if it really doesn't fit in some /dev/sva
> > after we cover the other PASID cases.
> 
> Wouldn't that be the duplication you're trying to avoid?  A second
> channel for bind, invalidate, capability and fault reporting
> mechanisms?

Yes, which is why it seems like it would be nicer to avoid it. Why I
said "might" :)

> If we extract SVA parts of vfio_iommu_type1 into a separate chardev,
> PASID table pass-through [1] will have to use that.

Yes, '/dev/sva' (which is a terrible name) would want to be the uAPI
entry point for controlling the vIOMMU related to PASID.

Does anything in the [1] series have tight coupling to VFIO other than
needing to know a bus/device/function? It looks like it is mostly
exposing iommu_* functions as uAPI?

Jason
