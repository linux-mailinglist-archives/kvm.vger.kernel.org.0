Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7FE29552B
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 01:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507138AbgJUXc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 19:32:26 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:41962 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2507094AbgJUXcZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 19:32:25 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f90c5070000>; Thu, 22 Oct 2020 07:32:23 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 21 Oct
 2020 23:32:22 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 21 Oct 2020 23:32:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bv9vUGzXW075GI9DmBUCc5wi8ALjnRedTgX5yMwkVm0DnYidY2xgw5S7e7DtqPwWcIylBeZ2EdG7lX2LWKm8/eVpLkzv73oQs5j2hG9LY5I8MLz6m9ZM0XwiwZ3kNk2zWZXgAdkYEymPzOq/+wxK7/5ldXtFeB2DYitzrgFUtkNM9ky9eI1kllOPg4t5nf4+hRkzlpocoIZ5oy/2S4h1diOHugYkktra5r3EX70LhQ86vuSlRpxSZNVLo0qbSCLe1taNVzqu6lxhUVSEOQzw/xzrzZTotV4WB0guEJu7/a6d10/R2DgvJYSgAwDh8g0Q2I8tScFwAvPitmgJyMP3mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9EhA+QL2tIBfp+kCC/XppT3SJ10Pns+uAIVnn7kCN6w=;
 b=JACUCAs7DnbXjO6aEz/iLS96fC0HY8yydBM5zy7DrGAq2QC1qQcboEoraQV2Q+bpDICz0UITzaLOb8ITKI2+9vQ0WAuoK2UX46S0bFSAkg88kkHKMFp9UMVuIM1jEfSMvperNvHBQZINvB0e2O999BZg0GPpPsf5E4vfzfkDUjUB1zqDuKxHPqpVVquOZnw+eMMmbKoOIhaeCm8j3Gmw/Hj634TFhwx6Y3Ysr6vBNMPVWGppantHS1YKxOcbTBeVpkrBn1g6jv3WQEgIPDgQT7s8J1JUazAI3bHgKmXfsY91xzJmbu1ghOdtSR5EWcXN9Vdh66UQ06Clu0tjVq1Deg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4041.namprd12.prod.outlook.com (2603:10b6:5:210::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Wed, 21 Oct
 2020 23:32:20 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 23:32:19 +0000
Date:   Wed, 21 Oct 2020 20:32:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>
Subject: Re: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Message-ID: <20201021233218.GV6219@nvidia.com>
References: <20201020170336.GK6219@nvidia.com>
 <20201020195146.GA86371@otc-nc-03> <20201020195557.GO6219@nvidia.com>
 <20201020200844.GC86371@otc-nc-03> <20201020201403.GP6219@nvidia.com>
 <20201020202713.GF86371@otc-nc-03> <20201021114829.GR6219@nvidia.com>
 <20201021175146.GA92867@otc-nc-03> <20201021182442.GU6219@nvidia.com>
 <20201021200315.GA93724@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201021200315.GA93724@otc-nc-03>
X-ClientProxiedBy: MN2PR15CA0005.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::18) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR15CA0005.namprd15.prod.outlook.com (2603:10b6:208:1b4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Wed, 21 Oct 2020 23:32:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kVNac-003kLj-7K; Wed, 21 Oct 2020 20:32:18 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603323143; bh=9EhA+QL2tIBfp+kCC/XppT3SJ10Pns+uAIVnn7kCN6w=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=MvOxGEgZ0dkh6aDDYt9AWkDFrxu5vuWyS3LrEvXqbwj89YZhFPsMK2J9N/+XifUOe
         EuCpZ11rxIeKLc4HaTS0oBEYkIxnItNgy3f4ke7TvcAyLSLk4K1fYPpoZa62KXhE18
         mSw/0tyJ7Zjk01fDu5M2gpGZ4M1lDWI2EmrMvpJp3LC+77tQqGLJ+Zt7xjG/Y+voR7
         Y6azWfKi7Ttp35GQYMAMv7cw43NsDVUPFnCA6XTkqhH/JGGLP5J780k7GMQJNXh6xX
         mYCYp1JkF4exOPYjMjSuuNFWh0BncJDOMXKBOffSAbvwAMDW/wzPozbw0YZJ/4T50O
         QwSRFAO2G0+tQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 01:03:15PM -0700, Raj, Ashok wrote:

> I'm not sure why you tie in IDXD and VDPA here. How IDXD uses native
> SVM is orthogonal to how we achieve mdev passthrough to guest and
> vSVM.

Everyone assumes that vIOMMU and SIOV aka PASID is going to be needed
on the VDPA side as well, I think that is why JasonW brought this up
in the first place.

We may not see vSVA for VDPA, but that seems like some special sub
mode of all the other vIOMMU and PASID stuff, and not a completely
distinct thing.

Jason
