Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FFD26C808
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 20:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgIPSjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 14:39:20 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3123 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgIPSir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 14:38:47 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f625b8b0000>; Wed, 16 Sep 2020 11:38:03 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 16 Sep 2020 11:38:46 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 16 Sep 2020 11:38:46 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Sep
 2020 18:38:45 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Sep 2020 18:38:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l89qDrOQCanALn29CqqL9ZN799Cc0QW3VmoNuRz826TXUCWdqs7hD7s043BtnLBeeVFM0uh69FqvN0Mz0CjQvvIKJbrH0hSIe1aBHEohKqH+Q2LgFMIc+lkHdoFLV3sGozbF8Fg3PDMk6tdRG6/6x4daxG2Dz26IY8JzEd90uvD1MENattyWny7wEBB6gsgot/Agpk1dS26kLTQX5tVynrAu4TJ9BoD1vBQDRvzJLzCP05ThAkB9KPU+MgSgP3Y3gDucgYvz8oqymyGVGtypuzu8yvISg7w2aEDCTW+H7L9/v3JENZ+UylhoEwnHmxWkSX4f9nbp0ds/w2VVvWWNXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtDVr2z3YVSoZN/JwFf5gcY98bQed7J2EP1JqeVtHB4=;
 b=iyegTkp0eLadjwYKkgaGjvkOeb8YOkSsNmCA9a+i5RTE5a/j5Ri7OTOKWIC8px5jjhj5WnH3UDw6rUr/Xwop1D9qbszLPkhFWEFqriCv5X/1FmftLxcauHEbTphGX5FVqyhKR5sKugK9HmtcxWOW4gVkGtYSl4onmWWRWPNp+0JgJvluDsd2hqClSiuDbrEqMNTza4ZND23vY8x2QxJrhjbPaqJCftK8cYhQ2B5ZsK5/DpNrNuLcF3yjDN2fATPwvFrddqe6v9MV8XaR4Up6LmPcyzXwsAPO9/RTP5yiVGQ5ra+SdMg6JfO/eyMvixwAqyi9GU+D7zJ5JcNlKPj9mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1756.namprd12.prod.outlook.com (2603:10b6:3:108::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Wed, 16 Sep
 2020 18:38:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 18:38:43 +0000
Date:   Wed, 16 Sep 2020 15:38:41 -0300
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
Message-ID: <20200916183841.GI6199@nvidia.com>
References: <20200915113341.GW904879@nvidia.com>
 <20200915181154.GA70770@otc-nc-03> <20200915184510.GB1573713@nvidia.com>
 <20200915150851.76436ca1@jacob-builder> <20200915235126.GK1573713@nvidia.com>
 <20200915171319.00003f59@linux.intel.com> <20200916150754.GE6199@nvidia.com>
 <20200916163343.GA76252@otc-nc-03> <20200916170113.GD3699@nvidia.com>
 <20200916112110.000024ee@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200916112110.000024ee@intel.com>
X-ClientProxiedBy: BL0PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:208:91::20) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR05CA0010.namprd05.prod.outlook.com (2603:10b6:208:91::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Wed, 16 Sep 2020 18:38:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kIcKH-000Bfs-J4; Wed, 16 Sep 2020 15:38:41 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9520029b-f1ec-4565-5036-08d85a6fbd08
X-MS-TrafficTypeDiagnostic: DM5PR12MB1756:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1756011DEF544FA1E0CA1AB3C2210@DM5PR12MB1756.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0O96Niuv/djgnRWft+3NuALR4rqRfbRoEFELJLSJgTWZsJgQBlvqG2QojfeCMp8EA6gzKPscyDWvI9OLgo4WVaWDRQZcp/yfGFvwn+YQC8TbkvXidh5A3xZPQgB6iI6BB4zgwSZVTwNVLneGfMOzftE3NcubEwlVVhPIeNTeczWhmv9ZyOc9G1kEAyt/fTO4q8Hun05jUKT4ZLIJJj4V8PF2Fp9vZzSAbiEa+lJmSsDMksynLBTU3IWhKDGmGvxG3nHtDrPE7IShvCmrefs83n3ccRW94dqrnt7Md28n1tQaC6cVGhWJcB3A3/99kCXi+b9JmFvcu3TLfqLJDZ5P1x6vEDeMawf6tLlH/rk8UclpGgR2DtvutZXRdHosHSjm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(376002)(346002)(366004)(136003)(426003)(33656002)(54906003)(2616005)(83380400001)(86362001)(1076003)(36756003)(5660300002)(316002)(66476007)(66556008)(6916009)(4326008)(2906002)(186003)(26005)(8676002)(66946007)(9786002)(8936002)(478600001)(7416002)(9746002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kxAwg1oh+VUj0Kl5H71E9BqLG9ugF3664wldLj2t8Z8sGh8oL1zA3mScJfJR6QOvKWR991fwjZyX8vOZh5fu7BETuFHucCRB1qIIuKy6A2OZk4e2LLP2jmzMx6ZjFvL0gZscu9lznq/KCZp7ZNMpDdgSwnCE/vzT15VwluhsoxkRMY1jQnVQ0Bxr/aN1u7/FGFBIifcTuAkGtMIyflzH6E+cBjC+8SsEfs0uabOjqpUrPjwIADdfHDiiAlH8+3kk7C1NPFVRfSUfQxa5naFCK4sBipja7uNuC/l5/UrRmBdREpD2yA9k8tPJc+Aeazexl+Ykg2a+aGFPwYFpMwm0CGAoIThIRzR6UpLxtxcluUcrvDGlkrHKeK1NXYRDaZoWURTJhw/x3yCQY7rEizTKpp3mPSmwin9cAY+2igLHLa4bqTLU6To9slOpV0qzsMVpD0RvPGxyJOfLiw+wSQY7LxEfSfU3mP7H1EDscf0wvPZQcOJJy2TaVDLdprIFpx7kJ55CAwoHs1s/X2whSDrvg+aZxF54HybbPEnMhNi9m1AA41lc5vktebZmMthj7KwEaaOYeXabPv6dtBr/SLJkLfS1HyzGIuLsVfV+83ivkhF1Etep3FYdyYuefaoHznSAmZZxwEKG2L6h3Px+bVqExw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9520029b-f1ec-4565-5036-08d85a6fbd08
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 18:38:43.7130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z8qGEqNpWM+AqKhtpKG5xk5AfxfU8vjkfMgrU3ucs/VYK3KndyetPudOkjQ/znom
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1756
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600281483; bh=mtDVr2z3YVSoZN/JwFf5gcY98bQed7J2EP1JqeVtHB4=;
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
        b=iGs9o9KAXpTFTR1oueywG4rarko7YT3Y9dTuRNjQzdaz0xoR9CMhE/AvvRLPPe3lI
         8kCe8r9HJAwDJU5Anfgh+0HmEe7gvUsq8cf1cTRs9BbnDwp2TiqimhezkuGVIJc3VC
         RnpF0TkGLk+nd1k0rM6qMX78kgiA+FYTi8lIcxWQYdzD+ecgMAYPuI6p5xbFBJL1e8
         hEQd3LkxTFZ4WxTSsTRH/hIfVa1HtzNmgvxiZvxsEz+w+5cGvUje03Z6F34w3ULOhZ
         OSFlkSpu47m4fDnJVzZuMhL0XT8SYX33jSqbjdbqyuQFBegJXdSo3A7FBXWwCmDBrP
         MwrvsKf0cthng==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 16, 2020 at 11:21:10AM -0700, Jacob Pan (Jun) wrote:
> Hi Jason,
> On Wed, 16 Sep 2020 14:01:13 -0300, Jason Gunthorpe <jgg@nvidia.com>
> wrote:
> 
> > On Wed, Sep 16, 2020 at 09:33:43AM -0700, Raj, Ashok wrote:
> > > On Wed, Sep 16, 2020 at 12:07:54PM -0300, Jason Gunthorpe wrote:  
> > > > On Tue, Sep 15, 2020 at 05:22:26PM -0700, Jacob Pan (Jun) wrote:  
> > > > > > If user space wants to bind page tables, create the PASID with
> > > > > > /dev/sva, use ioctls there to setup the page table the way it
> > > > > > wants, then pass the now configured PASID to a driver that
> > > > > > can use it.   
> > > > > 
> > > > > Are we talking about bare metal SVA?   
> > > > 
> > > > What a weird term.  
> > > 
> > > Glad you noticed it at v7 :-) 
> > > 
> > > Any suggestions on something less weird than 
> > > Shared Virtual Addressing? There is a reason why we moved from SVM
> > > to SVA.  
> > 
> > SVA is fine, what is "bare metal" supposed to mean?
> > 
> What I meant here is sharing virtual address between DMA and host
> process. This requires devices perform DMA request with PASID and use
> IOMMU first level/stage 1 page tables.
> This can be further divided into 1) user SVA 2) supervisor SVA (sharing
> init_mm)
> 
> My point is that /dev/sva is not useful here since the driver can
> perform PASID allocation while doing SVA bind.

No, you are thinking too small.

Look at VDPA, it has a SVA uAPI. Some HW might use PASID for the SVA.

When VDPA is used by DPDK it makes sense that the PASID will be SVA and
1:1 with the mm_struct.

When VDPA is used by qemu it makes sense that the PASID will be an
arbitary IOVA map constructed to be 1:1 with the guest vCPU physical
map. /dev/sva allows a single uAPI to do this kind of setup, and qemu
can support it while supporting a range of SVA kernel drivers. VDPA
and vfio-mdev are obvious initial targets.

*BOTH* are needed.

In general any uAPI for PASID should have the option to use either the
mm_struct SVA PASID *OR* a PASID from /dev/sva. It costs virtually
nothing to implement this in the driver as PASID is just a number, and
gives so much more flexability.

> Yi can correct me but this set is is about VFIO-PCI, VFIO-mdev will be
> introduced later.

Last patch is:

  vfio/type1: Add vSVA support for IOMMU-backed mdevs

So pretty hard to see how this is not about vfio-mdev, at least a
little..

Jason
