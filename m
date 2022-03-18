Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB864DDD58
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 16:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238254AbiCRP5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 11:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbiCRP47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 11:56:59 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C0F6515A
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 08:55:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mey8PoYXI10B3bMTwnkhYmVlB5LTxUstjdf/Ja3Sesxahzu2WxXpw+xo0gm1oP/1mrbn4zKYlbn+WNmuxxm+i//p+nZ80NRBfjX37k+fbM9uPhUxIRAbujGROhcHUV4odVzxZT4Cd55F1EyVPyQeoMtvRIWvN2IdKf1Gzqd0eq49LT+24HG5X6H2S3yl9NoUCSI/04FwD4r45yrEAy+ONsZTJjzMcqZiQSwuizzaSlpCvuhGnacjpy8SNsGEu2IPI0gpF/IPrRyTQeB1R9RZgjIdXrprH4Yn4YRoPgnmr8lSrQUuqrCyaRnqMtdEtaOX1fGkhwYsE3S+F0fKdCXKAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1FEIqeZZONJYrqXAiRmXK8PVMbO9s7caN9U/p+ZDbQ=;
 b=TIFmscOSujxCDXJ5PddESdzT+1UAp7UGAvt4PBiHRhFtxKlYP1Nkn5CeGVLMjYZ8K4ruo0+VC9WDG3cZAjTTa0Qs6alzUcYWcU2n62+zBmkq5uBV+4XMwMOpFOsNwUo+nXxFBlt8McEz34MxkJMOrrpAq4ILdPWtXiYQHwjLlAkRcFjh37G6a0c3XY99CLDgVLasnsThvxJ3XqfX2l63Yt1hzQcDErdq6k7soqDqK4PCifgInBaAup5BvE313ip+yJ4eT1g2IRjsFOcOeLzdV6snXZZzcov/BQqe5efXvOQ2fnN1GSstTtDUVowcKBybmeT5Jq3hk4Zy8HtCkTAdzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1FEIqeZZONJYrqXAiRmXK8PVMbO9s7caN9U/p+ZDbQ=;
 b=KMIeRPJg3PXCrpnwlOqTmCkb6FQtgIXgw53Ii4LASBL3/8qxMLgSt6FrpJPnp7aOP8XLu+jcb9dLzp5GbOZAs95SlFdp6sbitn6JdwJfD0I98zJaYKf8p7Rwz+utgY5PPIQB3G0nE/YHt4JoMaNhYKkAAb0bBHSLOiyVSOkByZDbQoFR882lc/VwkjrcMU6ZhL/d4xigC+GtapFotKa+8OZDG6U4Gl7N+BKxFR7Kgy1Td1in9zf0wck8tPC611DYFNtz/35gCAGWFbXh0B3Bjqz4sGi0752pTLyE/LR/ek5MPsgu0aE9hNe1rjqVm1vt9uwpftbL4LKlBawP/qGvrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH0PR12MB5630.namprd12.prod.outlook.com (2603:10b6:510:143::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Fri, 18 Mar
 2022 15:55:38 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 15:55:37 +0000
Date:   Fri, 18 Mar 2022 12:55:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        John Levon <john.levon@nutanix.com>,
        "john.g.johnson@oracle.com" <john.g.johnson@oracle.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: iommufd dirty page logging overview
Message-ID: <20220318155536.GQ11336@nvidia.com>
References: <DM8PR02MB80050C48AF03C8772EB5988F8B119@DM8PR02MB8005.namprd02.prod.outlook.com>
 <20220316235044.GA388745@nvidia.com>
 <BN9PR11MB52765646E6837CE3BF5979988C139@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220318124108.GF11336@nvidia.com>
 <20220318090636.6ea05cfd.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318090636.6ea05cfd.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR01CA0038.prod.exchangelabs.com (2603:10b6:208:23f::7)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e65c709-48e6-4495-efb2-08da08f7beb1
X-MS-TrafficTypeDiagnostic: PH0PR12MB5630:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB56309E0111DB5124FFA30003C2139@PH0PR12MB5630.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YSCTC2ki/OSosjo3eDmKTpDnzRXKgTH+sHP7uz1fYIYEHz5pgLTFJQ+V7RE2IbnuDd2/OZkljxhDc2ymQax3C5NsZVsXYs9Px3cBDXAPGYBw2L0R5Q1okL/Qk4vXQOi0zirlkNgz95vOqCkK0Sk5kiSaUfX+NX1f/jcKkKnXV5X/B63nBGEbAx6RkbOgjmjyRq+O1d+VqWZVqaenHV7T3G3F11Ay0vulJi26xO+z7M8gYKKHwpKX1cwJH/ACjU5HLcvm+/i0kzM0ZB34Mixg177sgTOAZkz3S0DOHH2fz24rsnRRpYUoF2phVonHMfg4NpERqzlzDdmFuU/6DxM9oAbhgj5GmXWhRaFKMClfeurfMpAlDtXxcvcAaCFcHMwEcBKAAC6jn6zBSSGZC/uD1uYty4wiG5EknMXYqINJOmYJ9Oa3gXK6mWMzcgpiyGkB27eit8krb7gP+24txn5e+tqXNFEZSxNkOsmBf1DAqmsfRhahnxw3QAVqygUAU9FE9vHpaM5B2GZVJopBQfQQDWvHZbA73ALq3Gi2WtIxMFdJHY/YPmadhyXl+84zY7HxMHnjHBewuBn8u8vEyp08f7Wi4pOuflmfCferI2+JWmA7buwe7ur26P5QQI7m0ooQBq1v/o5PFbWP88pEnqPJF1e88S92+xFqRpb0LEKjL4OegTQYNV8HG6aeY/tPWCR2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(6512007)(54906003)(66476007)(8676002)(6506007)(4326008)(66556008)(33656002)(83380400001)(66946007)(38100700002)(2906002)(508600001)(316002)(6486002)(2616005)(5660300002)(8936002)(36756003)(7416002)(1076003)(86362001)(186003)(26005)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NGAZli1ljaRzeRiUX52W7EagZSCeCwP7xDUx3WgQp6OeoBulY5WdsL3QVL5B?=
 =?us-ascii?Q?tRhkygBb17tfeVdzDtNoUtToJSrywJ8Yio4ZW0M8z4FE7wBVmDU1yrHM7U3L?=
 =?us-ascii?Q?TlGltwnLPkjcuLRKdxJIHCgcoVYTOtQikiNXLtKKwvVso7qb+BuNKlUqgy6t?=
 =?us-ascii?Q?Jrsx6qndd8Z6WjMATm3HKBMm9oKHqxiIgmgv2Jb3sZ9sMFOZLk8poceIt/L7?=
 =?us-ascii?Q?oG/Hkrj3tTkgd6nP/nHwCwSZvdRu+q1aAMveFZzeV481LmhCsk6g78iWJyTA?=
 =?us-ascii?Q?EObE6aO4H2DlKSUDwQa3jT5SqhTHvQ+7NW6TUo06Um+yNkIgVJO1z1Lb83Li?=
 =?us-ascii?Q?RmKawh73GyULgIpGx1aISdkFqUiK+XJUf8UL7vQTT6ZQKzB7QJkbVjVB9ETL?=
 =?us-ascii?Q?zsi+A4YvPFbg3GtKvTdsB48gK9yRVwZyqb3hTFWdXF0WzivMLekNXBYnsuhV?=
 =?us-ascii?Q?Bz3KA+jehYDi7DQQhoyngFos18T2U/86eHmyCXRXRAvAgtbMrr0d9VxMM2/r?=
 =?us-ascii?Q?p+hSJGhNkIohEzeajVy2R5eU5+0fHzT2aLdRndz70mDqDsyRwglOg1Q4/xUS?=
 =?us-ascii?Q?8nssyJynRk2bSZ2I0c9IvWX07/KOQQ62bnSHbYC9GS1fDPMUz9BQtmX44HRD?=
 =?us-ascii?Q?Hbim/pCXb0RSpgbSzO2+GIRDUA7dBssfVqehbrwwbFy9DFKHsnrsr9IxINaj?=
 =?us-ascii?Q?36TQegp1DYOfdWYzrBEB5h5OyfB6PbtmWAnbmOSs2hAQAoNWmyPHgaeuO6wf?=
 =?us-ascii?Q?PsyL2vWfeUzHQILZF25ZpR8AgxCSz6bPASkxm2KKdpIWapx2X+zlBh85u7aq?=
 =?us-ascii?Q?xSp8SsahzBmDDO91RC8JOTxppD1X+WltuykSzDn2Q5MN5x9hyMoZSRtoVVo6?=
 =?us-ascii?Q?xVhnY8OfDXouqOmg2pUFkMeff4VEfxxic343Jb0cYnORA2dJtOuxYNTyK7Xy?=
 =?us-ascii?Q?NUDbMUJQs+uZFLkArYfpcRcrCzpiRzT4i59UHoTm7M5flR/g4aRXCw+ryrqH?=
 =?us-ascii?Q?Gwe5DQRkJy7lBgAoSC252bTTWvAJIrbSi4WUZsWuQPcyLmFWTyAhlf2xN0fq?=
 =?us-ascii?Q?hB0CjnppxehZsF7oyUmDdbpOoXLr8OJG9IMPlD/DcQEYMezptLBrUwyUrVwB?=
 =?us-ascii?Q?MYY+zyfwsAa+L6f7Z3FEBTuLXe7MNchTxB4rvNvFVw8Pd3gpXcswatB8l9iO?=
 =?us-ascii?Q?A53G5G94jkDqSQy8Y7NowNdJ0jbjlgcfN8NyvxcRecYamIJLxOcfH/OyQ01Q?=
 =?us-ascii?Q?fyyiPJ42GzHIn32mnuShetWIEK0H0nz2CnbZJPCzPv+3wEkOqDngQrcie+7i?=
 =?us-ascii?Q?eNKLEWWzFKcSG8F83Cv13ircAK1P+tpK1JkcuPDE901xIaZGVukEK1149Uia?=
 =?us-ascii?Q?ITMzWPuFb5nb6qLootSRbx77l66ZEL+qjXb6ugB7yPErSbSxFt/Lv+Oc75rI?=
 =?us-ascii?Q?DKy/zqB3A7ziGPTd1skWHZtnKaNtyuv3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e65c709-48e6-4495-efb2-08da08f7beb1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 15:55:37.7029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3yiXyqwpUAs1YCugpArZNbmAs0JRRHt65Sw+zWsgU9rI7x/j/GHqP4KEjvyYkhMx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5630
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 18, 2022 at 09:06:36AM -0600, Alex Williamson wrote:

> There are advantages to each, the 2nd option gives the user more
> visibility, more options to thread, but it also possibly duplicates
> significant data.

The coming mlx5 tracker won't require kernel storage at all, so I
think this is something to tackle if/when someone comes with a device
that uses the CPU to somehow track dirties (probably via a mdev that
is already tracking DMA?)

One thought is to let vfio coordinate a single allocation of a dirty
bitmap xarray among drivers.

Even in the worst case of duplicated bitmaps the memory usage is not
fatally terrible it is about 32MB per 1TB of guest memory.

> The unmap scenario above is also not quite as cohesive if the user
> needs to poll devices for dirty pages in the unmapped range after
> performing the unmap.  It might make sense if the iommufd could
> generate the merged bitmap on unmap as the threading optimization
> probably has less value in that case.

I don't think of it this way. The device tracker has no idea about
munmap/mmap, it just tracks IOVA dirties.

Which is a problem because any time we alter the IOVA to PFN map we
need to read the device dirties and correlate them back to the actual
CPU pages that were dirtied.

unmap is one case, but nested paging invalidation is another much
nastier problem. How exactly that can work is a bit of a mystery to me
as the ultimate IOVA to PFN mapping is rather fuzzy/racy from the view
of the hypervisor.

So, I wouldn't invest effort to make a special kernel API to link
unmap and leave invalidate unsolved. Just keeping them seperated seems
to make more sense, and userspace knows better what it is doing. Eg
vIOMMU cases need to synchronize the dirty, but other things like
memory unplug don't.

From another perspective, what we want is for the system iommu to be
as lean and fast as possible because in, say, 10 years it will be the
dominate way to do this job. This is another reason I'm reluctant to
co-mingle it with device trackers in a way that might limit it.

Though overall I think threading is the key argument. Given this is
time critical for stop copy, and all trackers can report fully in
parallel, we should strive to allow userspace to thread them.

Jason
