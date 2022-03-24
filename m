Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480804E6B08
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 00:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355650AbiCXXNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 19:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344431AbiCXXNf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 19:13:35 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2070.outbound.protection.outlook.com [40.107.96.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205D513E2B
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 16:12:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VuWBF3WW9nCosEPOdWapo1t/ZUPmmEFgJQrkVnzNE/48RCAiW3PYxx5pBvVwQJfOA22Ka1hUFx7DG9FB6qPzgc+blUSGHiOex6djw7sZHAcDbJgNKsxYl3JDklX6+aruD+Bv5LamlRxqJy5yGvGaMIf/V9Q4jbKTzvMTVwjeLet5IAjR7ZT6urTAXz0wQMk1X/bTJL2XxG70sDpM/5UBgVVv/huvPWI+DBLGBjpzupUb1NsJeXom9e7QS8j8JMDm9F0s3v+T12xXl8d0d3CeSgIfvj+49T4qvEUkVfUyLik4LNuuAdINw78KYt3YIQ2F0uvNWT/POIorS9HBD/tb9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a5C3I/x8fsN22LI/ybh42jBcVvj7lpmJwG8ZOG5xqmo=;
 b=Vx7YlswWRqbuEb+0sk4XXXdyYfxIxqB8Db8g+lVCJa+5qy6bnfsxNFXeiMbRC/fLOEgkJMK4aQ1zPp+B++Vdqs7o0FE3bZH3oXQwnYovzkzwHbwZp7PWJAYiYCAvwXnRw+877VsHUCOMwklXpnuCo4jwY4IBUaFfH9nkkeR3PizGpZ56cnmuGi58r34XVGOU8wuDoZwlbKp69zJ9hcu4Wcgv5rQhzwQCcvAiqyFUe1ziKofSUJE9xgbVl5Z6InMct7Jy8ECoVMDMyksblAdrc6XOmX7LxEPwEXZmZ9wP99KRshrUcEvd2dHtJwnL92le9peRXx7E5pPTwCWuJ18L1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5C3I/x8fsN22LI/ybh42jBcVvj7lpmJwG8ZOG5xqmo=;
 b=T8ShO00XsiXPzJ6AlgaRJO06y3kaQ9UrmOoS//nWu4Gb+WZpXV5aj4Hati95G6O1hD5zVHT7xQJsIUbhNgLHxeA/twV0VjC+nJYqxe7j4Vo6+QfJB7rGszWZBBHe6DRZEmM7WmMAwqRLjkoa2I6M25yz6HyzTh9UhSpnNwam8+5ZhKNBZd4xXmfuRqjghUVPlZ83NmpgoyNvE1E3rPYrOy8elex4by+FulxmPs//iUqtaM9fAQWVyCqqvjmBwKMHiCnWCmeoTN1DnsLqLOIP9ymylfnxLACD+RLSLY3kJxevK6wQ90b5NSneHu3w9cYe8ncypd4LAu8SMhI/21K62g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3033.namprd12.prod.outlook.com (2603:10b6:5:11e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Thu, 24 Mar
 2022 23:12:00 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%6]) with mapi id 15.20.5102.019; Thu, 24 Mar 2022
 23:12:00 +0000
Date:   Thu, 24 Mar 2022 20:11:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
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
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Message-ID: <20220324231159.GA11336@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
 <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324160403.42131028.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR22CA0026.namprd22.prod.outlook.com
 (2603:10b6:208:238::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ddeddb3-6eb5-469d-ba2f-08da0debb382
X-MS-TrafficTypeDiagnostic: DM6PR12MB3033:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB303373A7E3A502CA98BE831EC2199@DM6PR12MB3033.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d7Xd7gbhkThTYi4zt/bwfCedQLj+/6JO+O5p3dNCA9mgWVZdHALOPsKZvZ84UZNnWdbulrECBPLHDfHbiW1wFYPaVxDlgcTsX+2vcrmiy0XAcw0bJVzh7OyxbU3Ss63//zEeXxBYRklkayJ+gFC6OL0rzF7JwET9jvVcEOulTcQkyDgEJA2xB89uD2980KrhRFu+4oUN+g9kJW4nSi6beSHd3R6GwB9Mwal1Td1Itb5vDSb8DnuRLfEMyO/4b0xN3IVRCsb//1Gumt8fgyDy477i3H6z9F21YZoGDpsqBXSCdQ7yWGgXA3VUEM7vuWA2Dsk9FSfV0Y917aanANJteqM8ZT2iPwks+FW4l2AA1ujK8nyQ+/wYfXH3veBm/TxY0sDIWkaIdOc43IkOIXmU+dJJGST6jncoDYvJ+mk+Nc962fOHObpGOALvwAcnKByC2TubHFia1WLQ3IZcOikgjqbqokg1z049NdQtnvv2Te6wLb+7ddrgaF2QKtIu6HhZ7Kd7WgvBCZilT/zIvgTdiVl5UnRdYpGrIDbYiYZiU5uvRtw5n7ZGD0/kyvSZVy7IOdW5xthX0fsxI2FZ/Sbz2hnh06rOurdXzOPmPRi6EIRzj2RKkg5MY3S1apxaizNQwhwyU4MUyimeLv9x9G3ThQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(33656002)(186003)(26005)(83380400001)(5660300002)(8676002)(6506007)(4326008)(38100700002)(7416002)(66556008)(66946007)(508600001)(2906002)(66476007)(45080400002)(1076003)(8936002)(316002)(36756003)(6512007)(2616005)(86362001)(6916009)(54906003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?42ls4xPyZab5WR8wW+6vk107w29qYz1/F285oCT28S8l9QnIn7Ibk44rGnqJ?=
 =?us-ascii?Q?saWEda3R/Ns2F2/GmXh3ij2PGtB63OoR8qVzIqsxmJE89bajE31RAzRFEGxk?=
 =?us-ascii?Q?zl9gaO25wPuMgy6Ud2UWRCQhzYacG78Q8O1ciE0BdT+fEIodhZBpNkGuDrWL?=
 =?us-ascii?Q?/N9bc5yPtrLTir9S4VMXgQC7KmXHmesiSH/fPmEdYTbAXjwmNyxAJBjRGn48?=
 =?us-ascii?Q?bOm5yD4KTKsgrf7grq/QmAlckJksfb6eRN/y9ZjYGICbMu32PR5HtWQ7xu6s?=
 =?us-ascii?Q?Ti+rOXOtEGtfDaJ1MXVrnCNoURF2GyJHm+3XQtO4h3gfwPpBEvLprLKgc3aD?=
 =?us-ascii?Q?g7EbqEnckbHbEQ2WUowx7w3XGSBvtL8ZxQn0MZqoHRZpB107eEssbixJrOph?=
 =?us-ascii?Q?aVl7RTL26080vd0JV5QxzXIipfxAu/W1ekohHto6lHxQf32nEnbfNeXzAcJU?=
 =?us-ascii?Q?J94djqqRnTGzc/RdeHtK1Fllt5spQmQUlAjrsJdmeAW2J+2nsVYXVl1KY3wl?=
 =?us-ascii?Q?LlzW028ukPIDACuzr3q6JARfg8Y+xvHSCJVHV3HJ8b9V+9eKwzuUkS+uX9Ya?=
 =?us-ascii?Q?woxyNoezFDWL/CgEhNYvnBYXVHW/KiPfr+qhHJ298i0GvxDT2AtPyDEW7bVs?=
 =?us-ascii?Q?uZAVF02dpjLhsKUHOXc5EMXj2R8HRacaaBAQxgY812SG1FvF/IMZfvQxl6iX?=
 =?us-ascii?Q?cPGZcG82pgvae78CzubQPoMitReCjts4EcOhll7059Tr4uBLxrdSn0RmSZhy?=
 =?us-ascii?Q?nXPRGS6YlVSEWb86wq+ZzEbGqwwgribGw5j6ydJ+Bd5Jirmw6j6ml02ZbQ+g?=
 =?us-ascii?Q?wGXv7Tz8msKPbR6KLNKPOzj16/bT5gVtjyBqlLW0er9cFFL0gYWxKP2ZAFnc?=
 =?us-ascii?Q?BtMh1WZyD4MGhMAOGWMR0XrV4nM801enNmjHbIXUqatCgdHKvssyunvtb8Q6?=
 =?us-ascii?Q?Q2OZUI0V6lARtzSG2sg9CtLJR6yFKtQ1XeYkDRvb81BhDJ+F3lASPZAs5pq0?=
 =?us-ascii?Q?FlcSXrgml5EH0BoanyI0gQGyS3sUJkHsY8BILGztfkWiVII/fuP0IR/84eZW?=
 =?us-ascii?Q?frBaAL1Iu9PouSsFxq4lndcSaFyO1Jvrbq+Y+2U+3Bv6FhRTgENv8BL/dOPI?=
 =?us-ascii?Q?PBKfb2PMbKZV1xefBqjUvUZ7D3Ny0JjqA9pzrpcJVXGVajttEvD/F5ZMFv4b?=
 =?us-ascii?Q?H6lK3SxEEWOzEAUID88ltBVMRhywpjquEpMSma3YamA04mma7s/L6FuY5mXR?=
 =?us-ascii?Q?h123aluZTKoRrQau2Vhxa+8/BrQEgKSeIkEzfoWzoq7r2526wWia6T0LxOD3?=
 =?us-ascii?Q?bX6Asy9OIutGJUrK1wXEGtjPbO4nN7qYwyNiF/TBzF6yFmvkNHvYMgoFuX16?=
 =?us-ascii?Q?kX3b8MqGpf3dnH2H2NDSjRhMzpczmm14KvRWv4aSwnI9ET4jXYMEzLOFMoMX?=
 =?us-ascii?Q?lNwpDDm6avjoC905uDNwetcU7Cr6YAfC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ddeddb3-6eb5-469d-ba2f-08da0debb382
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 23:12:00.8397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HpdqQm+dcO+l7knzkCN6IDoWYXYaBu25PrBnQi4YVbeKtd8iDfgwZyenRwX279QR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3033
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 24, 2022 at 04:04:03PM -0600, Alex Williamson wrote:
> On Wed, 23 Mar 2022 21:33:42 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Mar 23, 2022 at 04:51:25PM -0600, Alex Williamson wrote:
> > 
> > > My overall question here would be whether we can actually achieve a
> > > compatibility interface that has sufficient feature transparency that we
> > > can dump vfio code in favor of this interface, or will there be enough
> > > niche use cases that we need to keep type1 and vfio containers around
> > > through a deprecation process?  
> > 
> > Other than SPAPR, I think we can.
> 
> Does this mean #ifdef CONFIG_PPC in vfio core to retain infrastructure
> for POWER support?

Certainly initialy - I have no ability to do better than that.

I'm hoping someone from IBM will be willing to work on this in the
long run and we can do better.

> > I don't think this is compatibility. No kernel today triggers qemu to
> > use this feature as no kernel supports live migration. No existing
> > qemu will trigger this feature with new kernels that support live
> > migration v2. Therefore we can adjust qemu's dirty tracking at the
> > same time we enable migration v2 in qemu.
> 
> I guess I was assuming that enabling v2 migration in QEMU was dependent
> on the existing type1 dirty tracking because it's the only means we
> have to tell QEMU that all memory is perpetually dirty when we have a
> DMA device.  Is that not correct?

I haven't looked closely at this part in qemu, but IMHO, if qemu sees
that it has VFIO migration support but does not have any DMA dirty
tracking capability it should not do precopy flows.

If there is a bug here we should certainly fix it before progressing
the v2 patches. I'll ask Yishai & Co to take a look.

> > Intel no-snoop is simple enough, just needs some Intel cleanup parts.

Patches for this exist now
 
> > mdev will come along with the final VFIO integration, all the really
> > hard parts are done already. The VFIO integration is a medium sized
> > task overall.
> > 
> > So, I'm not ready to give up yet :)
> 
> Ok, that's a more promising outlook than I was inferring from the long
> list of missing features.

Yeah, it is just long, but they are not scary things, just priorites
and patch planning.

> > I think we can get there pretty quickly, or at least I haven't got
> > anything that is scaring me alot (beyond SPAPR of course)
> > 
> > For the dpdk/etcs of the world I think we are already there.
> 
> That's essentially what I'm trying to reconcile, we're racing both
> to round out the compatibility interface to fully support QEMU, while
> also updating QEMU to use iommufd directly so it won't need that full
> support.  It's a confusing message.  Thanks,

The long term purpose of compatibility is to provide a config option
to allow type 1 to be turned off and continue to support old user
space (eg in containers) that is running old qemu/dpdk/spdk/etc.

This shows that we have a plan/path to allow a distro to support only
one iommu interface in their kernel should they choose without having
to sacrifice uABI compatibility.

As for racing, my intention is to leave the compat interface alone for
awhile - the more urgent things in on my personal list are the RFC
for dirty tracking, mlx5 support for dirty tracking, and VFIO preparation
for iommufd support.

Eric and Yi are focusing on userspace page tables and qemu updates.

Joao is working on implementing iommu driver dirty tracking

Lu and Jacob are working on getting PASID support infrastructure
together.

There is alot going on!

A question to consider is what would you consider the minimum bar for
merging?

Thanks,
Jason
