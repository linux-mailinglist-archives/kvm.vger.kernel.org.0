Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A208A26CB2C
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgIPUXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:23:19 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12387 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbgIPR2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 13:28:42 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f622a260000>; Wed, 16 Sep 2020 08:07:18 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 16 Sep 2020 08:08:01 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 16 Sep 2020 08:08:01 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Sep
 2020 15:07:57 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Sep 2020 15:07:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Do6zq8khFOpnnzo2NWCov1jrDnNvqkNamOKr9KL2pqTEX6MJNivyk3ZpDpyQrNWczLNq5bHIGxUgP6heEsGkjUfbynf9ZzwH0PHUz2TaF/TVHTUuZvRtpawcXmHPWNFZkI/1OjtS5DlIv6MBybkEBCUY7sw3bVh4kBJd0ErU+i1bn+BpRWpyO5/Zil+HE/Osfe2CHQzFHKSG7untaHop45oSgoCpFivNkiWAeJauQaprM8KH46ni3Ockf4TjB+YeJsE0ZLLkzLghfrjEBPZPa0PavwzbKXKRE08TRf/4NGFYzfnb3MZxJ43aLUkxvcYdeC1xmjw5Qg3zd7zJuOxKkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PkMCDccH8MUGCc5JuuAxb6fuZinMaZt/yYVXb3kLnIo=;
 b=A1qHHO1wdpgKljTM1wy8ouSUbhwxDgTyNEH0KA7p3e8/cm/uDvUhzFpnEO8OG9ld25CMP4XjMKlHjAUOVUoXDnL6mmtJYJqlKVIrUNpCJg2r08gXD6iMY7kfMei93i5N3AD6NgSo7HQE6k9TvjPbAR3cAZOrRjE1zi3ADHAK52PZezZ+JJO5U+6q4ywv6apTwyoMInIyv3Gno3GLnEFkoHHamOfnhp6vMBdoFIXE92cVhBmJp63Gx6CeVMNQ0kkujdzMJ+vIQKAslsxo2vbBzmyD0ONADH7lovWj2KGgYcTWpm3vOxjPAweNP8rtjuvN6heyb2pl+aE1fm4Q32b5Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3513.namprd12.prod.outlook.com (2603:10b6:5:18a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 16 Sep
 2020 15:07:56 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 15:07:55 +0000
Date:   Wed, 16 Sep 2020 12:07:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Jacob Pan (Jun)" <jacob.jun.pan@intel.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>, <eric.auger@redhat.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <kevin.tian@intel.com>, <jun.j.tian@intel.com>,
        <yi.y.sun@intel.com>, <peterx@redhat.com>, <hao.wu@intel.com>,
        <stefanha@gmail.com>, <iommu@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200916150754.GE6199@nvidia.com>
References: <20200914174121.GI904879@nvidia.com>
 <20200914122328.0a262a7b@x1.home> <20200914190057.GM904879@nvidia.com>
 <20200914224438.GA65940@otc-nc-03> <20200915113341.GW904879@nvidia.com>
 <20200915181154.GA70770@otc-nc-03> <20200915184510.GB1573713@nvidia.com>
 <20200915150851.76436ca1@jacob-builder> <20200915235126.GK1573713@nvidia.com>
 <20200915171319.00003f59@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200915171319.00003f59@linux.intel.com>
X-ClientProxiedBy: MN2PR15CA0062.namprd15.prod.outlook.com
 (2603:10b6:208:237::31) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR15CA0062.namprd15.prod.outlook.com (2603:10b6:208:237::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Wed, 16 Sep 2020 15:07:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kIZ2I-0003R1-8w; Wed, 16 Sep 2020 12:07:54 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4719228c-5725-4a27-2462-08d85a524a68
X-MS-TrafficTypeDiagnostic: DM6PR12MB3513:
X-Microsoft-Antispam-PRVS: <DM6PR12MB35133ACE65A598D2B7D1C87BC2210@DM6PR12MB3513.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tn8fiH/0pjOvkBf240CJLWI5LFvwioEMvaElu7Ygk8CGjptlNnXaGMCI6K8C2xzjkyP/h4k78137Jev0YHhxyv3C12E+k2O9HagKxKLX51UPNoo79VdSuEZExRs0jdnDVVmBm+bFqmlxgtlLdFXrf0tG3nNykGY3V75g5Ijf0QlhnCFwmbtGStkaeJ9sXdvol+wUBSJAwLfvzlwXeDWmd2GLrIp4Jx/JfALFf/nkvX02LuT2YHYs41KghwBxPyPMqpTA6JXXu45e9rZMSSvK7HnnOsqkM3Hrw7yhmO7uJ3gghzPC3FyIzdsA/zuxHZKjPxktABf62Hal4YDLbogqBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(2616005)(26005)(83380400001)(478600001)(4326008)(9746002)(426003)(54906003)(8936002)(316002)(9786002)(66946007)(66476007)(66556008)(186003)(6916009)(86362001)(36756003)(5660300002)(2906002)(8676002)(1076003)(7416002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: iAaBp4fpB11fH+7yEKopGW2bfYrrYHBvZsV26V+1baFlWXq2U1yPkesGVhdcMk7E5bkN5oAecW7+IhQQiqBpaPky87NS4+rq4C0u8DkMmDL0RI8cYUZ5XAV4lSng0nfoPubTugnAoKZnN0VybjQRr2MCviAii6SCDO9FH2xrWvHSId5Evy4DWTMTK/R3DgAt9EydpIAKEsVMSWsfe8PfyCJpFf2VFsM/l9NjK0IHp66X4pVT8FnCsLftGJq3fIZhqo1k5u/ggRzAmeUSeumeQsl24GW8TwzAGabjZ1+1IoQJ6/xe4OWjD6CBJ9cblMF9cQsDj8d+ot/+uz631gn+vs+C2w5KOh+HrUfXGKKrbF1y5AaDp3gjSxx071NQUEXil5hdP4ERm0IMWBGyPG3IJZWG+yHLeWuFl95JKZ53J3F6qU9U5+p2oHc0j7ARiHlzBQsS+37tMUMuwW/syHdwBPMxqdh8W1E2ydw8iymwLCgrk9k/ZbjFxscCPhFR+xhBOkmy9Crjlkjw6TjhtcuFT1zpyco8+HBKVLHco6aKPwb1HJ0OKsfw5XWrQQHtk+JSdJy4BWpHa9Ci+LtCsqkaKB7rYVLXZAT6NeMZ2zKHytRsHGE5AKlLt/mkznWHP2Jg0xkKc9YufgmnANuIOEBmbA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4719228c-5725-4a27-2462-08d85a524a68
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 15:07:55.8290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+6BvzE9eYs4nuEgB9BLqmDFasUS0pzII4H6kQypq1H20FLrlTbrPfmDhLE1iGBu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3513
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600268838; bh=PkMCDccH8MUGCc5JuuAxb6fuZinMaZt/yYVXb3kLnIo=;
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
        b=b1FBNJe6G71HSQymrynmFfzwEaVRHx0m0zvYKBFfDf/8aLI6XqPuZNtmVXL7t9YZq
         gLtTrzkC1/pIogPLwfAmToW5GydBXNNRDHIE/HWTsUKZjtZu7sy/GVV5fS8m2VTOzc
         w0sydwOdO5WX7mTEa6zJvTXzfIxb997Ds9pqjtTAMqdanzL1KjL1Cmpow6vw68X1qC
         vWokFgMTS9t7Gtw68dBxkknQCDA3P85tYo5wNGpkwHmk7B0hgPdHjWNnkUM8CsxIkS
         OJLb8xS2fI/p2ADGDwXnbKzvgQAMOCS2MMY8BZr656Ey6KnusCcjmsT4jRIQHnoKgQ
         zfq3CvtvCp9Cg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 05:22:26PM -0700, Jacob Pan (Jun) wrote:
> > If user space wants to bind page tables, create the PASID with
> > /dev/sva, use ioctls there to setup the page table the way it wants,
> > then pass the now configured PASID to a driver that can use it. 
> 
> Are we talking about bare metal SVA? 

What a weird term.

> If so, I don't see the need for userspace to know there is a
> PASID. All user space need is that my current mm is bound to a
> device by the driver. So it can be a one-step process for user
> instead of two.

You've missed the entire point of the conversation, VDPA already needs
more than "my current mm is bound to a device"

> > PASID managment and binding is seperated from the driver(s) that are
> > using the PASID.
> 
> Why separate? Drivers need to be involved in PASID life cycle
> management. For example, when tearing down a PASID, the driver needs to
> stop DMA, IOMMU driver needs to unbind, etc. If driver is the control
> point, then things are just in order. I am referring to bare metal SVA.

Drivers can be involved and still have the uAPIs seperate. It isn't hard.

Jason
