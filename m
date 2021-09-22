Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1447D4149DD
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236132AbhIVM6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:58:37 -0400
Received: from mail-bn8nam11on2080.outbound.protection.outlook.com ([40.107.236.80]:60341
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236045AbhIVM6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:58:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5gMXsiqcBdovlyU4GyMzTOoSKohVNDyTeKs4ADQwx0iLfQAGS1buE89nNX1Jh8QkTbyMrc5XDzbyqlPqvjEcKPO9UGgs2WmiFIifCcWqBs06mksj/7LWQK+3UvMVstj2llZDeptRi1K2DAEp0z5fFJSzEOXeapk4/aUoHAz9L3u8Xc71hki+2TL5T9cSZquqx6xi2QYvqpQGUZoJdprT0TzgH1kGvpsB0nw1IeO1VToSztZ6+6aeZc59A62plnCAUITJhFh2z0NhONBHAt8B5kSHFikcegBfVFjeVtP7IfzuKfY2FBTe2WxRiwfUAXPvXGtj98o5915XT7VGKWy0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=QxzBAnASWK9yOEgtkrDvAo9kTQhYI2DeenD1/jI9nUs=;
 b=KHAPG+ht6kIUVDBHh6DmASlJN+Y+CvKDdKqceCKs5rJykXlX2Lu+Nei1b2e7RVt+61ypC3xlTaaxG4j/MzluqRno+q/r9ELoh5frdzakXSI6kpboz4Kbr1tXPiAyopC+9PDab0T5W2G4jIeFKMYSErYnBiJhLlhtZ3Vuvprcs/exwDzv08PgGQozTDlFjpmGUs9F4gbBKBdZQgWO7/APaSUPYEod/jTjTG2YtyqWPaHfQFlJjB813soElaZBWhb7DpC97ynGAXlj2n/jcIGkzRXVo/3riEDSaofX4+xQaPRwXbyrLvkaW7FNygBAlNA2O/+Sr+XnqGHe9+TazMaTuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QxzBAnASWK9yOEgtkrDvAo9kTQhYI2DeenD1/jI9nUs=;
 b=Z/4ai/RzKg21dxdiMMGxfnygpXVU+yXu83/fCtGnZOP7wigTXQ98ISWY/wzw/kWZvoTkzAv1UjV57Z/bttgmuVqa8mgoE2tzxPoNJEEDthCItZWjLhQT/Dg3f7O3h8eB5W20oc5Ex9yctA/YVx459qLR4Ly1ZRR5xqfsyv4cV6eooQewuBb87pQBIwYKXMxrQGv2+Z8xRTGDH8RpcKh5UIuyv0/OVSCO37UKR+TdaqDBHabm6jgjbIyvt7/oOfxGRlHedFVfsJ2oRdeayNUfhXrsf3nUsqktTPSMXoVgGHfTzbeiIKXu40lwyoE1ogns3FH9oF/hKcuxesHozDQzKw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5363.namprd12.prod.outlook.com (2603:10b6:208:317::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 12:57:05 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 12:57:05 +0000
Date:   Wed, 22 Sep 2021 09:57:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 14/20] iommu/iommufd: Add iommufd_device_[de]attach_ioasid()
Message-ID: <20210922125704.GN327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-15-yi.l.liu@intel.com>
 <20210921180203.GY327412@nvidia.com>
 <BN9PR11MB54339FF0B126A917BF14B44E8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54339FF0B126A917BF14B44E8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR01CA0029.prod.exchangelabs.com (2603:10b6:208:71::42)
 To BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR01CA0029.prod.exchangelabs.com (2603:10b6:208:71::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 12:57:05 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mT1o8-003xHq-Gp; Wed, 22 Sep 2021 09:57:04 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05364708-7354-4c55-ceac-08d97dc87aa4
X-MS-TrafficTypeDiagnostic: BL1PR12MB5363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5363CF7D6E2DF6AA253F111DC2A29@BL1PR12MB5363.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KSYn1M7uRXNahl1UYRoaM0kyXY1gccf6ZxqXsb/tuOxJxzXUKt8KTq4y/KprGyIh62pqJ9uuYgyAtlrOmE4RqGpqy4rRwu88ZKAq+DlF7Shgy9ABp0U3/8z6luOf0EvnPSxHH0My5kgyE7gZVSNay4qWRWg1tuQWoHE5hX9UzxRnwpsQGK8OlIkrMv9fc+WQ7vdc9QlUEUFyg/RNthGjMK01TGqPq5jcU7yX7lAUQuM9MZVTNPEe9yzjlmh0mQ7zC05scm+GCcMQ+GY4ldDEDo6V3eTyd49ELBOIIkXETq7uyvkk3Y5gsdMOmtilwJvu9kW++FKt76hVlpwjTUYocOgqN308pqrx3c+nnpJ94CCA0evUz58SwIe8P6rRIRtS7on0+WpE7ibwTRk9WToEbtIl34msKxLB//L5MB+xI3/o3TnNx72UTTDEHclOUYYEXz2H3Z4Wf27qDSzZBD5rDZfujrafxqDDJMWkRTTuNXQ5MwQOHNOK5Q2Dw9qOeSGYvPQMWh1yP8AeNhOcaQV+qQntztWT/wefyVZ5onAzttJALUyIEZq+u1F2HP6I69QMdd+owsX/snqwhOMG3AOf1ohbnodoHbXgfXLDZ7DPsbtdl3TV/CG9lwRzxC93ToxTJKGPY1mpdfJtKgPoNWKA9fCKwCSKBltGjQAgDdAkgRfIZzKoGAQHwMha7V9z+0ez
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(66556008)(33656002)(8936002)(66476007)(2906002)(186003)(6916009)(54906003)(2616005)(26005)(8676002)(316002)(107886003)(508600001)(1076003)(9786002)(9746002)(38100700002)(426003)(4744005)(36756003)(7416002)(5660300002)(86362001)(66946007)(4326008)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YGhtE4b0i5YpNKPJGEJLpLKRxfkQPO8rmV/t6XaHjR8CQ7KUKxE0hMG9D/ww?=
 =?us-ascii?Q?Lo/0RJBuqjhFpAe4JWHIYWwfZZgbn+/tVeJ7ZYwnp6ku21mwxXZNileMr8XK?=
 =?us-ascii?Q?9JBWLtU2PW9oueYJL18ILWuRCM0AbaYLa/colimdOUI+9kd7WIUojo7fUZWu?=
 =?us-ascii?Q?vZfO4sRTxJy0L8ruSMUDcoaizDOncU8BwgMMmGT/DJrDWTld8mb3qac3ZeAm?=
 =?us-ascii?Q?LJTss89QYy1yCNXZb9mQ+GNejHNPN2aoSbM9DtAmidpM2yEV0NMAFUc+E6yF?=
 =?us-ascii?Q?4JwNzXQrrETa2c0SfnnG5HvW9yWzV0VzzssSCq6ylEFxE3yrwrgOMESxsyA6?=
 =?us-ascii?Q?oEa3F8J8peRcdGBQgwR1AuaofeNVA3FWDXBHZBcAptB7h3E0Zq3SRMQpVjGu?=
 =?us-ascii?Q?9lXCZXaOnv5GOcaZNAASQHk1gAiKgW7tm/OZlIH7lBlByYysi8oot633bdj9?=
 =?us-ascii?Q?K168KadO7i+C5Np0h+fsYUkH5KQ9DobwB/yYaxxldZudMKKyrcBsZVDlfeg4?=
 =?us-ascii?Q?DhrK1l7XDpDKPBXG/fmuO9Uyc9MV1DsznXv7ZMv6q6CbHMguWtFm6G5jmbkP?=
 =?us-ascii?Q?L1HsWEylDURGoe9m/GBcBMXrof8w33Ig8KKQEZ/wMAt+kQU1Th02Rt3ibjl1?=
 =?us-ascii?Q?/Wx4/E11H4K55fdtMUW2EhHfv96L8yAXTqTKAo5bJcLkA4az2nOb948Pwby+?=
 =?us-ascii?Q?+7dCsYCqfQSxcFiYpXYCDuvnfLA1cX5f8UKMBQSRpXlbk4CLqP2gfoPG5+au?=
 =?us-ascii?Q?Ysdj5+2Ja9J4j5CpoRE2tJ8N8Vg4V/cBAU8sWJF412E1kU9+I/hNOHYjQyqN?=
 =?us-ascii?Q?9iK9o9B6VjK0cihAWrbGX6YlmPUuHpKru5xlyP6khge99Of9MDBuxkevHrlQ?=
 =?us-ascii?Q?8pSYxiNirvO/C+R5Fvw+ZyEONRq9bC/qokjs4EP8bRcf9U9kk/FdAq6GuHoF?=
 =?us-ascii?Q?lMI4WHgGXdXU6xXmIuUCQZOzc5WeG5wvq70CbrUcwOoOnlAJFGUKwjc/07a3?=
 =?us-ascii?Q?X0FYUz97KC6QVa+3pWz23NBEB2B3BrNnfbv4Y7sMvzcDY9Lu1cEIjxJqw1+V?=
 =?us-ascii?Q?XJC1EX/+QFB1es+eKKgRNOqF8N3y/WmYdbs/q8mFfyLNylY0v9jETOnHiG3/?=
 =?us-ascii?Q?QWXMRbD0Mh+Xu3SWRit97bIyftx/lKuzZVK6QOKPUB//vjGqpvXSAMZvmRqF?=
 =?us-ascii?Q?N7/nyyjVusvIIYKmQg+1+HovgeisAmtpqW/SaknaX5nFfud2vdbVQJJ4Xfma?=
 =?us-ascii?Q?v2i7ZAviAvtCPnnc8i7Mpgq+m+SBqcCZWfOorPsFLiOagOPFSBWu4WaWDB5T?=
 =?us-ascii?Q?qmnq9WpNFyplJWuTBq1oLRpf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05364708-7354-4c55-ceac-08d97dc87aa4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 12:57:05.6956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YRwpr6fmHe+EhEpucJZxi8VMTd4JfaqFUm9U8y2WYS0+0bx74D6Lrncm20+yb8VP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5363
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 03:53:52AM +0000, Tian, Kevin wrote:

> Actually this was one open we closed in previous design proposal, but
> looks you have a different thought now.
> 
> vfio maintains one ioas per container. Devices in the container
> can be attached to different domains (e.g. due to snoop format). Every
> time when the ioas is updated, every attached domain is updated
> in accordance. 
> 
> You recommended one-ioas-one-domain model instead, i.e. any device 
> with a format incompatible with the one currently used in ioas has to 
> be attached to a new ioas, even if the two ioas's have the same mapping.
> This leads to compatibility check at attaching time.
> 
> Now you want returning back to the vfio model?

Oh, I thought we circled back again.. If we are all OK with one ioas
one domain then great.

> > If think sis taking in the iommfd_device then there isn't a logical
> > place to signal the PCIness
> 
> can you elaborate?

I mean just drop it and document it.

Jason
