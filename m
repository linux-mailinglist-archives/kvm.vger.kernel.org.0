Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72784523A62
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 18:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344792AbiEKQcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 12:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344126AbiEKQcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 12:32:20 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2045.outbound.protection.outlook.com [40.107.95.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668562380CF
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 09:32:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwaR38epPRA5JS6+9s5h2ykSb35PVdJ0Njk3SRi8K5H2ujZkH2w7kxmd1LDd7TcnCFEkEg3fUb1JYhdQOdmrpttDfFuieqKc1KB+7ZoxxIEPyXEfIoiRJ8kEKOMNl+dW/nUCqON+MxtPCdS8jKVw/Yekc0FcoVd28LcxyMBozw18QA8UpvzZwju8WAsSsfQtoiBzYBVuBnwzkRuyQvUfp4DeRBY+FE8j7q0EYqDpAxwyRJaJ2XgOIG7Ak/ui5VnNRGDaV+R8HLF7YXmDgHBwtiySKKgAODhpE49JTawYprA/fFb4deSzWYiS4nXzt6StfyiapjqKiByBhT97yQ2/wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2D+KUqg9KGx12+rrDsqLbB63gy0tZKUaKlC7yTSyeBs=;
 b=XPuSKBlefsbM54R/iGZhACPf94lNkVYxMFjvCJnEYTT3QpKZDrYUY/PTWUfjNx+inHLnJXAwgH0/UyZzrbuipKKHeHWjLlKXpQFMxdi7yOUtc5eakHd/mRELo9lVThzbFhuIwMpo/gMBuKQiw7tWal/+iRO76cN2AAj/toUbKEadM6Ch/dh20apnOrFJyEIjXoCAHLjs4hpH9146Nh/fZ2PGniIyPcA6Z5dRX5cmYnUORT7zRvVrlZYp42kLUp8j0QqzDKeOja/1AwUN7H2hCW8sG2uoYk2RLyTT+/0+zQd6/ybetSci1auoCVgTNFDgrCZwHP8Oa+VTgcwmh3gfDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2D+KUqg9KGx12+rrDsqLbB63gy0tZKUaKlC7yTSyeBs=;
 b=SB5W77mwb0iIFkPuEKBoNghdwIKQe1J0MDbAJ/PI7BkoWX+SBs4OdPvhUvfygTkfFOeDsPuaG6U3aXtA7CL2o3mefwMZSndzZ1ix4VzrOMZdDHDXgl0C0Zsq0ACv/xsGoN64Jm+cdhxq4rzHgZ0fjaNdAAwRdF4B5+Q66t+AQjo0HlnOIU+ip1zdTOxgcqxw5jipQbTXhJJrGFeCj9UIwtZ83AUt0kZDAr/F8AbFL6bZXer5KcCtY3XkKMFzvv8+ZoCDYtFnl1sVWPVH1v0Ci9iHtRuED7x8CcWGA3efbzEView+Ffn2Djt7sh+OT+bZ0mGqkRDsci7aFHy1mpMgjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1582.namprd12.prod.outlook.com (2603:10b6:301:10::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Wed, 11 May
 2022 16:32:16 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 16:32:16 +0000
Date:   Wed, 11 May 2022 13:32:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Message-ID: <20220511163214.GC49344@nvidia.com>
References: <20220429124838.GW8364@nvidia.com>
 <Ym+IfTvdD2zS6j4G@yekko>
 <20220505190728.GV49344@nvidia.com>
 <YnSxL5KxwJvQzd2Q@yekko>
 <20220506124837.GB49344@nvidia.com>
 <YniuUMCBjy0BaJC6@yekko>
 <20220509140041.GK49344@nvidia.com>
 <YnoQREfceIoLATDA@yekko>
 <20220510190009.GO49344@nvidia.com>
 <BN9PR11MB52765D95C6172ABE43E236A38CC89@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52765D95C6172ABE43E236A38CC89@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0139.namprd03.prod.outlook.com
 (2603:10b6:208:32e::24) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7c8d591-3e07-40cf-84a3-08da336bcf56
X-MS-TrafficTypeDiagnostic: MWHPR12MB1582:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB158284C3FDA95394BFA2E264C2C89@MWHPR12MB1582.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U9pbJmyBEhtEQimrTIULOHJ2e5hAkjv0kUW8uulhSZflJvTUhnBvn50quYTGAjeFqJZcJpaUv8T808SrIOK3ITrCAXe/NUCLmkj8G5v2fDmoFrzy21A9KF+NTqLQ84o1WYpEn5/TLWRdKOY88kMPpzyJsI67f0l4ILWwPVL6xog2mG+7sbcq4RaiD/qApQ1krqAUaPfs7IFQ6C0evxLuFxy+k1f4t3/s3ahvRFUvuftyFZQWJwLHSfUIvYsfJf7nh8rBIKl6DbD/8mh9FQ1p+7AqKOH+P6p2mbkWUxmHC8Eg7m4r3fD2N4m5U76mQzzNk4+IZMmIzBjwUJZRGCmv5Y9uSQ1SIDxg16PiJccJpcq0k1Jndwefwe5qd8MdaHqjx5yO7Tp1/OUasN7QkZiXduO+vshkUHYS7B3grD19cfT64IU/Q+UnIdHqG1HYuiuXeQtBAyUOaqz+I7ngAeSMR9wqVigXBRsRO1eu4Oh30L74gRPgDxCURisXB/57DXZ5ufdx6i9/fP0sVKNTATkQAqXFTq3mGtypX6ntYDQKe9XRS14TyAPrQJFv7VdvC1NkInNM6mOJs/ZmT5HItbohHEVeItJ/wLDCLA/03AdeLqcZ5t2qV9DC4DPp8T02Tx789COXsOuYm0eDwiN25uSozA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(8676002)(66946007)(6506007)(6512007)(66556008)(66476007)(26005)(86362001)(54906003)(6916009)(38100700002)(316002)(508600001)(6486002)(2616005)(1076003)(83380400001)(33656002)(2906002)(186003)(7416002)(5660300002)(8936002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RQb4mSyBDru0b+A10qW7KqIYmeV72ItfYLPe1rbuQh0TKADYy8rGtCXOd5xD?=
 =?us-ascii?Q?emUgs+k73k0+6+GSVSPKUZsyfK0aSos7vkryCY/CKYqISQMrGMIZIJtexbJz?=
 =?us-ascii?Q?EeY2VNOw/KlQgkSbxMJyBo0kfx5yjwWTa5X8S8HsoraccyMZDqbp5aAaaAgE?=
 =?us-ascii?Q?k3cIFdOOzXZqedPRVW2Y/isAUfVQ4JBB18BtY0x09zHpk/Cuuw2mjudw2Ls/?=
 =?us-ascii?Q?DJE7lNFaxjQJ/E7eaL8wmatawF4YrpD84x3cxjTaxkOSpvJno/qdnz8d/HSB?=
 =?us-ascii?Q?N+OUm7JLgzrnrPPruG2LKx69QnsmY87a8w2S0sWYKAoAQaMsGWbJf28Rtd4Q?=
 =?us-ascii?Q?Aie8vpaSosmh50oHzzzJ5KiqFMiHUP+oVZQuAgnCNnRRoNKRREUIiTJFp5X9?=
 =?us-ascii?Q?6jKGNNS7k6ZJg8OkpvHPWAMyRV1vxEZsFXRfxFMeYW0OjNhaXfg0ue3imPTb?=
 =?us-ascii?Q?zd/Dp0Ek1c9+Ui3lJyk3erzn7gB5OXNPcUM14OmsEur2Z2nXjTWMySkaPX8j?=
 =?us-ascii?Q?01aJec3hbNh85tZIFv6+vYrYHUZNsjmC72BD8tL4PRkV+rAFryg6y9YgErly?=
 =?us-ascii?Q?g5y86z1c9Kh4FKhF2RYE6XarguMdBZJqm1ZaIuBlV+3vQJmYfVrR3Zfh4xjj?=
 =?us-ascii?Q?BebUQ7mobj0KU3yfjOsAeXm2DNiK6mmFzADcrHvgR1FqO6PFmdvRwODmzH3b?=
 =?us-ascii?Q?iDAVjcx8V7WJNp85nNsCUNZlJwxWmgaBs8WzE21pt0bleIBUcoLQHA3dch4P?=
 =?us-ascii?Q?WkfDHZqEPfWqUK60x9r8gxxuQWX9QYwSJILlqPqyaXH6fML5WAGNDHLXPkCs?=
 =?us-ascii?Q?QSWbw9DPkL89aJQMswVZX1oesIsqvEo5tMS8RpuRwxzmJ1gRsn6vRlNcNV0Z?=
 =?us-ascii?Q?gv6pgA1mV3hvTXxhLw4r/iXwlc9qFjBOzN93CvcBkvmo5U3coTUf4+VDbagW?=
 =?us-ascii?Q?heoc5TodvvSXmtg03T4t69IrVZlIr18BUTavW1qbi82FNQHhcAsda1gEE8PG?=
 =?us-ascii?Q?YbuvO5aP/km9kqP3la6UygH7mczGvh2fNYEAQS2P55GsCVcuQAtKiTBV1rf+?=
 =?us-ascii?Q?6l0ifxpqEr8SST0C5mx1T1VW6u+T2SmMgXAe8TmkjP+JbfBd/e6RBkgBo1PX?=
 =?us-ascii?Q?HRC4scQyyzSu7XaKAYV9SoC30pjTnZiAf7dOR1EpfCl0bsrltbASaue8yVBg?=
 =?us-ascii?Q?7tlHUs1++/yOdZgltSs/G1reohmLlgdvPEIrxRnVrpwOrXQlxI5EgQs59pqB?=
 =?us-ascii?Q?sRnj3mJhMh9afBvmOvUbXbr09b8osmzK+YuOyAURqdkq+lLLD+Bedkz2a6qg?=
 =?us-ascii?Q?Cc1TUBsEL0gkcxgQoNAJYgoBQq/I3gwaeTlKH123fD+1UIj6CAYIBogwBu2c?=
 =?us-ascii?Q?XTi8nSpzqvs4MOlksioKdz4e7TjR+tX9RU2L2O0q4UsXmsfX8TiGbvtkZmmT?=
 =?us-ascii?Q?TSaCZHlTdUA7HhHS0mj1S5C8CFoLbhOPmaRw4A4FX4jIM3ISv/dntsF2gTC6?=
 =?us-ascii?Q?sOmZcp5iDoMwyTj/cLaUV1QjHzfvVXIiLEatzqUJdsW9GKrau0X3D6HpdGpR?=
 =?us-ascii?Q?autyZ6y38/mXFCM4xoFfut6XhRfd8bLtlRvbW3ee+oQh0LwXh2Md5T75f7Gv?=
 =?us-ascii?Q?OxsDKvxd8FRhrf1DVbg5FZ68CE6LdiRGyvZZZyRZeom9xFhTDzH308KZUgUx?=
 =?us-ascii?Q?V4sYMI+6hcHtK3+5sdc0tqJb2s9Fimfl4tr7mOCDbrQxMm0wR6N7Lp0lboVx?=
 =?us-ascii?Q?pUVrrm0wkw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c8d591-3e07-40cf-84a3-08da336bcf56
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 16:32:16.0980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z8zO34bV1vQRHAxatkb24K58LvLrWc495eXaN8ozrMzDjidFuw5xGOn6AhUs9leb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1582
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 11, 2022 at 03:15:22AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, May 11, 2022 3:00 AM
> > 
> > On Tue, May 10, 2022 at 05:12:04PM +1000, David Gibson wrote:
> > > Ok... here's a revised version of my proposal which I think addresses
> > > your concerns and simplfies things.
> > >
> > > - No new operations, but IOAS_MAP gets some new flags (and IOAS_COPY
> > >   will probably need matching changes)
> > >
> > > - By default the IOVA given to IOAS_MAP is a hint only, and the IOVA
> > >   is chosen by the kernel within the aperture(s).  This is closer to
> > >   how mmap() operates, and DPDK and similar shouldn't care about
> > >   having specific IOVAs, even at the individual mapping level.
> > >
> > > - IOAS_MAP gets an IOMAP_FIXED flag, analagous to mmap()'s MAP_FIXED,
> > >   for when you really do want to control the IOVA (qemu, maybe some
> > >   special userspace driver cases)
> > 
> > We already did both of these, the flag is called
> > IOMMU_IOAS_MAP_FIXED_IOVA - if it is not specified then kernel will
> > select the IOVA internally.
> > 
> > > - ATTACH will fail if the new device would shrink the aperture to
> > >   exclude any already established mappings (I assume this is already
> > >   the case)
> > 
> > Yes
> > 
> > > - IOAS_MAP gets an IOMAP_RESERVE flag, which operates a bit like a
> > >   PROT_NONE mmap().  It reserves that IOVA space, so other (non-FIXED)
> > >   MAPs won't use it, but doesn't actually put anything into the IO
> > >   pagetables.
> > >     - Like a regular mapping, ATTACHes that are incompatible with an
> > >       IOMAP_RESERVEed region will fail
> > >     - An IOMAP_RESERVEed area can be overmapped with an IOMAP_FIXED
> > >       mapping
> > 
> > Yeah, this seems OK, I'm thinking a new API might make sense because
> > you don't really want mmap replacement semantics but a permanent
> > record of what IOVA must always be valid.
> > 
> > IOMMU_IOA_REQUIRE_IOVA perhaps, similar signature to
> > IOMMUFD_CMD_IOAS_IOVA_RANGES:
> > 
> > struct iommu_ioas_require_iova {
> >         __u32 size;
> >         __u32 ioas_id;
> >         __u32 num_iovas;
> >         __u32 __reserved;
> >         struct iommu_required_iovas {
> >                 __aligned_u64 start;
> >                 __aligned_u64 last;
> >         } required_iovas[];
> > };
> 
> As a permanent record do we want to enforce that once the required
> range list is set all FIXED and non-FIXED allocations must be within the
> list of ranges?

No, I would just use this as a guarntee that going forward any
get_ranges will always return ranges that cover the listed required
ranges. Ie any narrowing of the ranges will be refused.

map/unmap should only be restricted to the get_ranges output.

Wouldn't burn CPU cycles to nanny userspace here.

> If yes we can take the end of the last range as the max size of the iova
> address space to optimize the page table layout.

I think this API should not interact with the driver. Its only job is
to prevent devices from attaching that would narrow the ranges.

If we also use it to adjust the aperture of the created iommu_domain
then it looses its usefullness as guard since something like qemu
would have to leave room for hotplug as well.

I suppose optimizing the created iommu_domains should be some other
API, with a different set of ranges and the '# of bytes of IOVA' hint
as well.

> > > For (unoptimized) qemu it would be:
> > >
> > > 1. Create IOAS
> > > 2. IOAS_MAP(IOMAP_FIXED|IOMAP_RESERVE) the valid IOVA regions of
> > the
> > >    guest platform
> > > 3. ATTACH devices (this will fail if they're not compatible with the
> > >    reserved IOVA regions)
> > > 4. Boot the guest
> 
> I suppose above is only the sample flow for PPC vIOMMU. For non-PPC
> vIOMMUs regular mappings are required before booting the guest and
> reservation might be done but not mandatory (at least not what current
> Qemu vfio can afford as it simply replays valid ranges in the CPU address
> space).

I think qemu can always do it, it feels like it would simplify error
cases around aperture mismatches.

Jason
