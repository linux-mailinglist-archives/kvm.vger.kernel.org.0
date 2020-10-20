Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8FD29439E
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 21:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbgJTT4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 15:56:05 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:20059 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729371AbgJTT4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 15:56:05 -0400
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8f40d30000>; Wed, 21 Oct 2020 03:56:03 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 20 Oct
 2020 19:56:01 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 20 Oct 2020 19:56:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+taRDna9QByTWCw5BRwnB/6RnltW8sR8CDpLUc4nn+ltjFUhvuzEhP2e1d5sWDCssr4llcJK+fIgyrz9W0EwQMjE1GYrfkipPaphogipyO+Kp85dxSZVmQFwAbJ6mMu3919yV5oarwLUqpPOkHyiLMniWH5R2gvd7M/BV+QwMk0HcJn/ZMQce3Syps6lVmtENIN7dGH09TsPxhhvx747U+pf3uVjTizfO3nsj2Rt5UR4nlFkRfh9VgKuLj/jqjDEL2pLyW1/TVdaRJyncmu0UtB9DMk2EygeV7qnQaJFcJ/Fk48dzrJuAuC8XL7an5bkbrxt9+be4KLB5Zu6f6Ftg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLP8vj/EWcL74dSbxidrd9H1JF3eBmAw8Q+6c1+42A4=;
 b=RE1cP8SqztaZQlOqqcOweojMw+GraVmVH289uMWBXnevgPZVSwkWFYYOuzMHWVMcQqoVX8rcenG7chkweof6vTPVbnD8fftbv9MXAamU0MuB8tSHuWgna/lKinRSUqvuDJHvhukIiKMV4huXoUot77gp/4HjTPEE4m1kDxp3IT7Hya+RgR2/o/yF3WqmuSTEGVadmIaon7KlF1kP5lggZ7NzDnGz7u1pY/X/NF6Gsr2EYVNEUjt2fNyVYgQm/olidsA46aqsmu2E66oIuyj+6tuH25wVpmH+nbWYJQsusuk6hpkde/smanjMhZwXMzdH+FR/xSjZfIsrUof+YHPuJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4338.namprd12.prod.outlook.com (2603:10b6:5:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Tue, 20 Oct
 2020 19:55:58 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 19:55:58 +0000
Date:   Tue, 20 Oct 2020 16:55:57 -0300
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
Message-ID: <20201020195557.GO6219@nvidia.com>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
 <MWHPR11MB1645AE971BD8DAF72CE3E1198C050@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201016153632.GM6219@nvidia.com>
 <DM5PR11MB1435A3AEC0637C4531F2FE92C31E0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201019142526.GJ6219@nvidia.com>
 <DM5PR11MB14354A8A126E686A5F20FEC2C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201020140217.GI6219@nvidia.com> <20201020162430.GA85321@otc-nc-03>
 <20201020170336.GK6219@nvidia.com> <20201020195146.GA86371@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201020195146.GA86371@otc-nc-03>
X-ClientProxiedBy: MN2PR17CA0028.namprd17.prod.outlook.com
 (2603:10b6:208:15e::41) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR17CA0028.namprd17.prod.outlook.com (2603:10b6:208:15e::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 20 Oct 2020 19:55:58 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kUxjh-0034TE-1q; Tue, 20 Oct 2020 16:55:57 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603223763; bh=SLP8vj/EWcL74dSbxidrd9H1JF3eBmAw8Q+6c1+42A4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=ViubdjgYnhDvH6EhxWAXHgjZhlSiLlTfaMAzKbqKAWLYasim5tAkd4AGKmRT0kgix
         yIOkten4m61q1A8YHSalKu2LzcsjMNKbN47yl684OlZszUZub9GDIQ/sqsMjWl2ySN
         VCzocR/wmatnErqiqQ5QCUvVkDEgYHdJuHY/O/xpP2J+buMikKJbNBh7RAqYSDbULE
         //A3ThtyxBNsVXf7OtYR/Cj66Lto5+HAbpcKQpFUbPInqtGWVGvbKVqvCZndsUio+l
         sd+MrGXhTUvK/leV3ysimjIG514f3Vnkas6yP0+Buk6ZljYm9RxzRkjlWRaESghZ79
         6dfqgceHtJMng==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 20, 2020 at 12:51:46PM -0700, Raj, Ashok wrote:
> I think we agreed (or agree to disagree and commit) for device types that 
> we have for SIOV, VFIO based approach works well without having to re-invent 
> another way to do the same things. Not looking for a shortcut by any means, 
> but we need to plan around existing hardware though. Looks like vDPA took 
> some shortcuts then to not abstract iommu uAPI instead :-)? When all
> necessary hardware was available.. This would be a solved puzzle. 

I think it is the opposite, vIOMMU and related has outgrown VFIO as
the "home" and needs to stand alone.

Apparently the HW that will need PASID for vDPA is Intel HW, so if
more is needed to do a good design you are probably the only one that
can get it/do it.

Jason
