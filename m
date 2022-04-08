Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4D84F9586
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 14:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbiDHMXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 08:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbiDHMXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 08:23:17 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CF233D814
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 05:21:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCdFBrUkiA9LY9uVIKp8N6uszvKPIHjrZzkei8EYJyyYE8nPEritO9wlht9VQisbyGtOCR7zqgRSTp993N+1yts/UmX4s5JAljS1kURKiXj98VhJRIdqaP7DuMnMqVGn7io0cbeOE40a382RW90qjsPjTsrX6NsEP1DyUxePaftX2FFG9yFCn5/dEJFIHHOmulJRrF5WfLgrc1KtFqxkOrfk2jGxnwFXIWsxNUqPSqxS8KPrGAqZmQS1GH84bzHJp7pkArJre2TjsBfnXv9hygMbcTd/MzeZkA0YKFgz+PZEKaFjkA4CCct3ghYhG/ptR+ZW7CwoE/POniCFjeaVrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rtePp1+vmGOucLpnlw/uRqFdQ3mJhEzM68MzvOiSFHw=;
 b=MM1IUQmIe754nsafxPNCafivlG8qvR3XbZUfj/fIXtSwcVeLzTvyBFm/Q5gOg0RTcBX9oXxVdcYFCwODgeUiZtaT5WFz8QEFpyPtFVHEDNUIWTYwlOGhsLZXrsElaeyr8/oyMUiEv8OGXVC9IGntCoQLin5/5iZBPr0F8VXqvyRSOSKlKeu6PeX8qrkTt2jjSII6m7xOGMz9CgOsJ5LJ6A2ubphNTNNBDTNr/Egm1hzvuKJKdQpcxgUmHaQLKxbzQiYprvcqBfDNnJRkwXa6ggLQ/ecBUOTw5rUkJnigR6Bdw0qB+5gG5pdNI/DtMtA9704wIL+ZdLwzU2IrN/6HhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtePp1+vmGOucLpnlw/uRqFdQ3mJhEzM68MzvOiSFHw=;
 b=bJGu0gn1EPsZV+mx6n8x6xAPtryxv6ePehupLDJxpv5xdj3+88Lh0s7cniibmQcsR4VYLpuBEtqqLYUi+2QTSOeFCihtrkZ1ApfGqcAnNWaHjUwAsvTLRLi8EMA56wW6PTDmikyi8Q0ekD+9DCFHGOniESnSgC3TsvwWb52raJrvlMPIucrEOu0XhVALheM/ypvpag9X8J/Ikxo4JtixWOO9eNoElXfNnvnrxJLGah4+aRj5kmXZmJ0YZhIWlwNQNqTblq83ASY5QUtXa9HgyXcm6Q4/lyV7T5Yh8b7dkUX8hqe63z9h/vENxAHAnX2C3m6aPDHphvEHuiBWXUFxVQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1236.namprd12.prod.outlook.com (2603:10b6:404:1f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Fri, 8 Apr
 2022 12:21:11 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 12:21:11 +0000
Date:   Fri, 8 Apr 2022 09:21:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 3/4] iommu: Redefine IOMMU_CAP_CACHE_COHERENCY as the
 cap flag for IOMMU_CACHE
Message-ID: <20220408122110.GU2120790@nvidia.com>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <3-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <BN9PR11MB527673C3360785759CEFF5708CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527673C3360785759CEFF5708CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0028.namprd13.prod.outlook.com
 (2603:10b6:208:256::33) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e7055b9-f7b9-4cdd-4c19-08da195a449c
X-MS-TrafficTypeDiagnostic: BN6PR12MB1236:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1236564D862A325D33EE460AC2E99@BN6PR12MB1236.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xrcfZF4nIY66PL90D45OArXkwTC4mMjm+bL6eqsadhUQPM9An+wxfwqp++uMtTgXIICyxLVlGbyGmhq1OPgvFyLriK9ieDCNXoTEZ+Cr2ggXmHjL+NtRfQvsGa7Hk/GGxsD0RrJeAFwl0WjzrCwQKUN4A+2FdMvnRZX/5+sBtzwqj++GXh7q/Yy0RHpygyDgkQW6HAggD2e7BypFoGp0iBWLj6xeel/FUVeeH0FgcHTcgHwJcBKVD86HVZWdYeZBIRO/fjrIVjz3M4c0KQCdHP365PLo78eyuBuMHfi+8l/FCb+H/Y6oswP78Zfj+seQq1ge4DPGhAGFZXYyd8MqePLGWSCDOS56mSEz8gDtGxwCZQdRXNVYe3O6CjVGkO3vjIfsHd6+n4AfhypnLW+d/y7nq+fTZVmCu/POF1osxCVAHosXwKlfOL3Q0BuFAIdyffr1zTzykdcKMOpqsnBML8c9VsM3bG3xs/ce++FD2DABvKgm7bCAXDfv+ENO3tysztJiwSPwT1oMFP4voLZTnuY0lWxQE3cO62BQjFfr3lcBkwnAltXekhfc1Y1Ty+ijp+agWtps4NI3/OG9/hccJj1esup1dEt5K1/CooIqckdiUs0dV8aUFbfLnMkk9TYr5h5uPv19QtKxCM/TCVoKmdeVZ0znm61Yh671GF+zRyhaFoX5RouqlnxVvWBiaO350sRmK0kyy09UtxPurS3IZtjNup1Ms2GhkkFlM9EbLNc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(966005)(2906002)(6486002)(38100700002)(83380400001)(6916009)(33656002)(316002)(54906003)(8936002)(7416002)(66946007)(6506007)(6512007)(8676002)(4326008)(66476007)(2616005)(66556008)(508600001)(26005)(186003)(86362001)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pS/MrRKigIOcXfVLOfmSD2Q4jd86wj7CMxDbU5KpsW/WDqcPgVe8P+ZUsz+m?=
 =?us-ascii?Q?d3A9iR7C3hyGpL54HACZYNn2FW3P9LzogmYWV/T8TFvQZQCqGpms9hJO3n9E?=
 =?us-ascii?Q?YSpsxIdkBnlKp5kWW5wPND/bQCmvXElWHTL2gkPc3NopgSEinrnp1pQsxiiH?=
 =?us-ascii?Q?O6+fYbDREEhEmYcT90pfCJRKPFTaF5KwIsVHjQ6xUqnHvlxtWD2k3LT8Oa11?=
 =?us-ascii?Q?SPPqrOROuf5z0vs9mOyWB5tcKnav1aVunm7yFSSIzMXp/1OdK4mlEC0q7YjZ?=
 =?us-ascii?Q?RkQVi7HL3sOrtFLy/GLnc4djgm9VPYApGe06fiONyjcskkI1fGoXXXokXLLi?=
 =?us-ascii?Q?yXQtR/LXDm6TNOvaFnWvuSGURCiaFFiSVAVmXmRg458iNkUs87FpIbgD6kus?=
 =?us-ascii?Q?n+ncCRkRLr0cQshOV/nUsoN3Awm/YIOND0mgKEwVXbiAEs3KN/jcB2a9nATM?=
 =?us-ascii?Q?tLT6MbTCwuhSH7AvT/LnD6UDVQPgZvaVj5GUBPHbqkv3SCYRAsWf5DkNF/QK?=
 =?us-ascii?Q?WH4qHfZmxbAqTfGET4RiFw456Syaw7LANTQ+gCdjqYQ2y1WTOHl1cEWLLKV8?=
 =?us-ascii?Q?JpL5RTK1FwBs4sRnvVAg3EwuJmpLS+Dj4pQ5oHK2x8RSsLyhKusd2MFv5Rol?=
 =?us-ascii?Q?dxutYlqvDKTKIVzKv9E4vBLYdKuF5BDoCwCl1ftS3vvZP/ww0BzJnhfBRIGm?=
 =?us-ascii?Q?kdFFThNUjbsGGwFd7AIil+JiSjMjq9HGFfbFSWgR+WD5WtAUzkNAOtG2b9N2?=
 =?us-ascii?Q?Bnmqehp+WiPcR1/yyMetfbr6xACvh0vsOaCvJB8lgjg0L6aeRE2pt60NhkxI?=
 =?us-ascii?Q?VuxBv5raJ5dIH7FrAlovRNyc5qReGNh+keA9/TDRqRjPKcnDC8w6aZmtBmNy?=
 =?us-ascii?Q?WQdHHljuFsfXOD4sOiGTDnfI7MVCW0mP/Y7OqoWogxwI0UcldLbZD/NdCw9D?=
 =?us-ascii?Q?0xpAjQFNPcDgf4NaRl3HoZBdk5ExOmiTst8Q//LmMj31LqlMTVPHM7g1u+mE?=
 =?us-ascii?Q?PBL+KCTeJw6seiUJOV/EQBx6qASJYz5hR+0mYZPSlMPmB0bRi/nQtZYEP80l?=
 =?us-ascii?Q?uc6AnWjQPGgWFt0woypzbLrP1UTUF15s5Dyx18muosVckLUyzTaGovGXVeiA?=
 =?us-ascii?Q?qdWB+CI2iwb8gHRyvZcGJceoZ7xKsM8jXsL8NDILCZfDqKBil53pFiB5DYVO?=
 =?us-ascii?Q?2aUB3XP3ym0lm9iUa3Qw+imYcXDNVM62I8lSEmHMd3rurPcCD3lc34uMzftI?=
 =?us-ascii?Q?4zQtJvY6SwRBmZ4vvb06qlluIJPpd55/qsgVf9WxJZTvvWi4RPxR2+Or8y+J?=
 =?us-ascii?Q?1VrVA6p445zcnLqga87rkRxnFZEZQahZk24uxC1r289LSul9F/zUb4ofEimf?=
 =?us-ascii?Q?CrRBAx47YkesDHfp3ve4E2yYB5CXq6jHNr87MDXvfVcZ9vihvADJQJubpe8e?=
 =?us-ascii?Q?soQghCCVmCJHMDt2PN5MrFRTgPSk15mhZnkUjoddHMU5EG7wge3MFuVTylnA?=
 =?us-ascii?Q?mvUujddVUvRB2GTDweKefMYZEKjxvVY2epBP9/Ny46FJJOzmDLqrbvSHM1Ux?=
 =?us-ascii?Q?8RQE2VENLLGSMDntJg4kC3C0ZWijHyVZaE0OOOWNQZJUTIeW6Km0Eo3kH6Qf?=
 =?us-ascii?Q?R5omoYcd8jCGIiGZZmsfj9EvDKw1DuqRYwSzPKfJF0jUqaVFJfjl79rRIbhn?=
 =?us-ascii?Q?JkzYP1wyJjzSYLIulR5hW5rwi7BcFgoF/llfFkw2A9aYv9omdYOFHDxoEDm2?=
 =?us-ascii?Q?bjiAn0+1NA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e7055b9-f7b9-4cdd-4c19-08da195a449c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 12:21:11.6753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6kazQgqrhCMUkb81BqlYmLhfXycsW0tf/keoJP7AYdKXWlvHMRq4OfE6+ntlL/K8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1236
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 08, 2022 at 08:21:55AM +0000, Tian, Kevin wrote:
> (CC Jason Wang)
> 
> > From: Jason Gunthorpe
> > Sent: Thursday, April 7, 2022 11:24 PM
> > 
> > While the comment was correct that this flag was intended to convey the
> > block no-snoop support in the IOMMU, it has become widely implemented
> > and
> > used to mean the IOMMU supports IOMMU_CACHE as a map flag. Only the
> > Intel
> > driver was different.
> > 
> > Now that the Intel driver is using enforce_cache_coherency() update the
> > comment to make it clear that IOMMU_CAP_CACHE_COHERENCY is only
> > about
> > IOMMU_CACHE.  Fix the Intel driver to return true since IOMMU_CACHE
> > always
> > works.
> > 
> > The two places that test this flag, usnic and vdpa, are both assigning
> > userspace pages to a driver controlled iommu_domain and require
> > IOMMU_CACHE behavior as they offer no way for userspace to synchronize
> > caches.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> 
> btw the comment about vsnic and vdpa matches my thought. But
> a recent change in Qemu [1] possibly wants confirmation from
> Jason Wang.
> 
> [1] https://lore.kernel.org/all/20220304133556.233983-20-mst@redhat.com/

That patch seems to have run into the confusion this series is
addressing.

VFIO_DMA_CC_IOMMU and snoop control is absolutely not needed by
VDPA. We expect the VDPA kernel driver to be well behaved and not
cause its device to generate no-snoop TLPs.

VDPA needs IOMMU_CACHE only.

Jason
