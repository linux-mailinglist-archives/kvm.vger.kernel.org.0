Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387535ECAE4
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 19:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbiI0Rds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 13:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbiI0Rdg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 13:33:36 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D976A1C770A
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 10:33:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6+/ULdZv0kzdMqRNOadv41C3W6+HD+aGnr4G9dufX6NHuG20HMxpj2/XDlUsU1cHF1AtL5ZGc+ds++O7K1UYX4HvyRDe9VFDzf+Ry+MrpnVqT5J4hAyWc3FoB5Lct3vN3iQygmxYq7EWCn7Fnn/sGwAz5rKx0M+jy+wXdFZEiW8r26gMOWzaYBR/llOjai0EcuNpRrh8NQz+at92WKd5B/X6AbNVPP6mi7mY8dhpEWqak93tA99NHnmG10bYWVguUZaweXCYbb4JXsDa49lZWXjX0nbDHrYprf8Dbukwc9O93t3TGpZZjrwW1VUHrlUeepEFYuU22ZDOJnN7d8dkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B5SETXuPicUGejmG7EFmq0Oq86QCaBkKAm/y2lg3HqA=;
 b=E22HRC3cASNQE7xZ1gDZ8Rqtb6mt8y9Bj6ebp7hMKdtX/NRKuvsJ8SloGQSh9rH8jsySjslLv9SxM3fQe/nuLG5Oy8wn8xBIMvX9pK7GgAnTW+ZOH00Md2ToN2fe3dHwTzRwF7ZrI0V0ou67jb8Ou+nlLXXDii/YlQR66WVPk6p0YlOGkuqktqZ5oluIH6m98JuUbZMjvvmJGRZ4ZHyyc/hoP0NuFZfKRMIKXqzB/ihnGrk8JMTBB1lJUhMV5fm/WOTHiBrM89rHdGjSeb1MspVrScqISPGS0PjoPNlCh7LMWpqYKuR8qbw4THZB7bnM9A3hvfdXEUkyszjh43+9Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B5SETXuPicUGejmG7EFmq0Oq86QCaBkKAm/y2lg3HqA=;
 b=hY6VvBj2fT68b723yfgRp6diJt49+CARsJ5DMT/B4o7kTYNonM5EYvxaPND2w5blqlV2+wByavmaIUUdVHVWOfVirIFweG6EMzSiey96oAC3g4ITNW1WKpMZaPOKFRAsLEXo6vIqynmZ7u2W0lJzw0YnyIAgaDF8dsqZ1ut7Jm0T2Mbt3TQgrkDGV3p6Zs/0ovPCdU4bPpovqrNTNc4L4O4mlA0IC4pEy4wcrICQCvbF/OXrPY9JGgM05PUUNebi6sTCTsXCMm1m/PTQyzLD036VU/ZXbBO06H4YqEgdxHINj9PltzaBVr1r/XqC1mv8yW2YhNoc7s/CVtis6Y4r0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB5772.namprd12.prod.outlook.com (2603:10b6:8:63::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Tue, 27 Sep
 2022 17:33:32 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5654.026; Tue, 27 Sep 2022
 17:33:32 +0000
Date:   Tue, 27 Sep 2022 14:33:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC v2 02/13] iommufd: Overview documentation
Message-ID: <YzMz63fmjDH+HRqr@nvidia.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <2-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <Yxf2Z+wVa8Os02Hp@yekko>
 <YxuLaxIRNsQRmqI5@nvidia.com>
 <Yx8MlOBPz1Zxig3V@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yx8MlOBPz1Zxig3V@yekko>
X-ClientProxiedBy: MN2PR12CA0026.namprd12.prod.outlook.com
 (2603:10b6:208:a8::39) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|DM4PR12MB5772:EE_
X-MS-Office365-Filtering-Correlation-Id: e54b530a-050a-4231-7ad1-08daa0ae65e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bgmBOpq8heI1Q2wNxK+6aTRAHtBNiysfHexd70fFFMO8FFEbqsiJtJ9Dt8dC+kfRx1FMT0nE3+fMOVPw9chwDi7HPKhP4IKsCnp5C1oRdYFgQZTdIQSyl1NArjU5DYgk5SSyrjUrIeVtSXadEXUp74NPViCEeAuvdtmarhrPRK6UkPSeVX4hPSXRVNaM8spiA4/kb5Y7hP31Exx1JlRjGx4SvEnRjBH9T9VtGVkkNVSQa1fb5FgAhGgXf3FZ7hpk0DDkQP665eqg6PH+JHrY6yt+M2V1IKwfLQ9/BQunr/XFb6YVX4iSoYk2AqWrrCX1ydfRlIxpClHTDAse8M0Kvo4/dO6YP3RVOKA9flbyY8PMXt9u29xXgk6SYesRcH1DNLLE57KtA7Gqf+gn0eqHTyKtupaRHMJQd2Os8O9vryhx0rVNt849ywXq3uepw9NOiH6WaVRKLgg1Z7XDTSmJ6jcD/g+LwKrWuiKmnjQDWkpOBQ8Q4KtMNhCyqwfozINJFT8qdwJ4i20GpMv7mSiF4cAuH5dJkWLIlSDMel+jKv7SwqNLgHU+uidg/Gj1/5Dd7BsINY4LOJoID9RxUuydzJPjtPSGRy3LXedvDVkApnjzb12hdDmdCpXLYxzmmZ6peC7jQWYaseG2AqKCyZPT13SVuxpkqqXsUalnVtclVX0Gc+slHxaNg7OSMoPFZ8CNDEMU72Unz86Cqk/LNpIInCKN/44U5SiLlhscvW+r70KiKxkx/LVONf4KWAM9XZb2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(451199015)(8676002)(26005)(6506007)(6512007)(186003)(2616005)(2906002)(5660300002)(7416002)(8936002)(54906003)(6486002)(83380400001)(66946007)(4326008)(478600001)(66476007)(66556008)(316002)(6916009)(41300700001)(86362001)(36756003)(38100700002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WrtBgVsA2g9NuHsCmKMxCiJxmKazUIt4eUNJzuxJAWk3nDcFKV9TpVKbJAih?=
 =?us-ascii?Q?06VRQG0Zv/r7shFmtsE9rNT1Eor0OoZ+dMdTtD/5tP8YXa326/F2Uo2hNlSC?=
 =?us-ascii?Q?d3fJK7fYQYAPCEr9wLjbN8pbgD90bXwVrS2aUIqDEQnZVQBOWyJmbNBqWZX6?=
 =?us-ascii?Q?w/VHG7M9AG3FF3SgKxtnsV/33fX/WAtyPTgwEdf7CduY7UReK0QGmMAtuACz?=
 =?us-ascii?Q?cNNtLdQ0Ty9LXQeiPye3TaAV3kUh48IVV0rBRg+x6I0++gbXuJvRgBl2GkiW?=
 =?us-ascii?Q?cSkXnk4ZxKmEOJN3zxHCi+PmCLAXFzzzBYI4bi/QBGHz6ZuldMq9xtwcyqPp?=
 =?us-ascii?Q?DD3vFmgJIwbKMZ4LPezFD+q+zvlAnE0m2BsmHPGjcNF86G5qVZfe0NRZF7GY?=
 =?us-ascii?Q?V9TG9N59bVbal/ESmFABqYp4FRPE5nCvtaju6oUPcFPhJQjPEBacBdGud3IL?=
 =?us-ascii?Q?37ZwCb+poketRpZu4435TbImXWh5q2pUwGpLzaRo19if8IeGwselZrJBDgLA?=
 =?us-ascii?Q?MU3DSwG2JyEdLzopR4cM+eTn3NZqbukouIXWEwqNgpRYzdgSy+RtCcg7fngZ?=
 =?us-ascii?Q?oly3w9BJp8T+xWXDculRMc+eVYgwou2krQ4UXvyKndkToyFF27miOC6bf4e8?=
 =?us-ascii?Q?zrqUpjQJftl1OOFaGC6BnrqlfMVGH3FGdzzwA7Y4v3tj4H4STHupR08oSmgo?=
 =?us-ascii?Q?8STzat2YtWSrTQ/jhEvBhIR3cwt8Phg9Ghu/tA1uGdJe+Dcs8Of2OB/Q9Leb?=
 =?us-ascii?Q?8UsXaJZ2Wab3djgnV5SYCjDMqVtiXNNZDZNm/OcZKhrE50YiQlm0SjQVJ1FX?=
 =?us-ascii?Q?wCMT26re6WTzR8fsMaKMwxBSStxisJZ4C/+IClZy6tjwkS54U4FPtvMcaO3x?=
 =?us-ascii?Q?s1Z8/GJXhzPgP99WTHYTf5G5jeTo46biYKlyOyEnxVBvRvNzj9g6E2yRzOEk?=
 =?us-ascii?Q?QE9Ch/nFjCX3qqgqRWh8Tq9AVPMfpv81ptDDTGS7uIlomXvnieBnbPCTH4Ua?=
 =?us-ascii?Q?KULhEbbbLcBD4MCWxmiqac+FWGADL42fK+19yeSkAX0xlVsKNsjCjVcDcKU7?=
 =?us-ascii?Q?lH01zoMNRnUKr4EuyCIGbLpcEzpMhBaHJqRWJXl/KehnAgY3LnYaBRoat3wW?=
 =?us-ascii?Q?GScZAGnM3/F8pjr68KEC3XqOH5VQNSFuMjcidvIy1KLDq5pSjBAjAQLKSiQs?=
 =?us-ascii?Q?WHBkVf2TwijXYjhYBXxcSdGjm5/MCgi/oBOR8a2Ebj5F0fE5VhsuVuie8Pkt?=
 =?us-ascii?Q?GWfgzjWJZJ39lp1wajpngLmRNpKNvxZYw189oFUDh/6D9unBNPB4QX9rPjyO?=
 =?us-ascii?Q?S2oAfUjhhJMoHQCb0cIuTSWuaQZ7HNjURABpbjI8VJ+EEGxQhMq8tSGCIeOX?=
 =?us-ascii?Q?gsqJtKcE5OUeTA98Vhuo8GBb2HsUmMX/5aec5Ye3B5ttQ0UPh3iNQgzdqJld?=
 =?us-ascii?Q?aVJ+PJt0+xX9SxqMwqL/6Gu03cVmSj7KCfhjSizfV83VESHTNCMupx9djIfL?=
 =?us-ascii?Q?5W4VC2tyeD4lWkErkLb/PhGH8oas2acKsPsF9IxjBamZoH4EJqkSavjeN1Gz?=
 =?us-ascii?Q?BvZd5gDQVptan1IybZo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e54b530a-050a-4231-7ad1-08daa0ae65e1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 17:33:32.1782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bQx8d6G7qi2qEspKcmLQq5SJkuC5+xwxmOK38NYXFxXZeT8Ix1Bk8SSORBjPuxWf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5772
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 12, 2022 at 08:40:20PM +1000, David Gibson wrote:

> > > > +The iopt_pages is the center of the storage and motion of PFNs. Each iopt_pages
> > > > +represents a logical linear array of full PFNs. PFNs are stored in a tiered
> > > > +scheme:
> > > > +
> > > > + 1) iopt_pages::pinned_pfns xarray
> > > > + 2) An iommu_domain
> > > > + 3) The origin of the PFNs, i.e. the userspace pointer
> > > 
> > > I can't follow what this "tiered scheme" is describing.
> > 
> > Hum, I'm not sure how to address this.
> > 
> > Is this better?
> > 
> >  1) PFNs that have been "software accessed" stored in theiopt_pages::pinned_pfns
> >     xarray
> >  2) PFNs stored inside the IOPTEs accessed through an iommu_domain
> >  3) The origin of the PFNs, i.e. the userspace VA in a mm_struct
> 
> Hmm.. only slightly.  What about:
> 
>    Each opt_pages represents a logical linear array of full PFNs.  The
>    PFNs are ultimately derived from userspave VAs via an mm_struct.
>    They are cached in .. <describe the pined_pfns and iommu_domain
>    data structures>

Ok, I have this now:

Each iopt_pages represents a logical linear array of full PFNs.  The PFNs are
ultimately derived from userspave VAs via an mm_struct. Once they have been
pinned the PFN is stored in an iommu_domain's IOPTEs or inside the pinned_pages
xarray if they are being "software accessed".

PFN have to be copied between all combinations of storage locations, depending
on what domains are present and what kinds of in-kernel "software access" users
exists. The mechanism ensures that a page is pinned only once.

Thanks
Jason 


