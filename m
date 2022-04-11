Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857344FBE68
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 16:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240109AbiDKONb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 10:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346970AbiDKONX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 10:13:23 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22F231923
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 07:11:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eK6MPQ4WQpJXjA2oI1qfone+/fJvaETlfyfU1KSD+3X7Y9NQfXT5YAkWY612AM4Irr9xR8YGBxVG5iL/+Dz652nhoQyFEsIazkMYmjnd6bvPyxoSkF35nIXu2HAW1FSd+R4Ziq1GTqe2iFkL8TOLArjhb/8zNd4xRbwcbdKhj4TP88z643TJXX+bueNd6N5FPLyUzLZhyFh7MGtyIj05OfTl67ORR9APQIU5P/81xskK0ieIfgcUFXIQ2q5KSeHKIqzWgjr7uB9M6gTxyO60BDFi5mwqRhl9Ccv/mi0xMxwjs3mIbA2iC13nt9NJgq3+yCe15h47GaYfRgQwvwgAoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ei4JhAskF7RzJgTGIN7T9AYSFEsiiAa62kbEEdShl3E=;
 b=MUWMcN/2KkEDcxBVzZjrsVF2uHRZl6N/PHjCZZKyq7PIGYVPfHxNyW8PUJhFxF3dEufVfPq1qXpExgtFwpWCZmo9jc8i0723WN2IRVdSDzGViHRdJTvHRs/j436yMKhpIETfcWg36kMvg+c7lsUwIWbZKr4XXPcYpq96gU4UgOVb1UMRVqLzSnxORXDKtbMHeFgtSSoULYU0vBliOgo3t1ifinEDMF3Pg8utbGO7k9OIw9zvrR47Z1ttvcj9JYsebhVx257xD3V8rCaoxDjYqdBWJQlzOHyyQdkrx2ap/KeRqv1y+9vfB1BW1yv5U3YmoatkzX1oU/baIhyMh8hrUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ei4JhAskF7RzJgTGIN7T9AYSFEsiiAa62kbEEdShl3E=;
 b=T9vKX/TXacvViJgPHEbLFin+p1j7sGOiE2gsQ2KvMqXZ6mXk1HXv5adA7vcM2NTnPgfIxnC3GqbBidh1Uvogagw2kb6b3vKkw4ocF4dm8uLxp4U0oH+OUiyTPOE9i6AxgeqRrDL4JRzvzUKbvrDIi6sSGLnt180EPcaaklfDgflq1F8eXG8g07Uc3xUaL2+gZI8kWHdmC4OqbLK5KCwTAM4vD3EhGiG49rgtoVLBc03z1o0dO6ROQaE6dCda8FiLd8TRzYAqDFXoioKBcZKeAQ+aEWOTqjJK8wCsb536GvNVNoNnhsK6GOJbHOCEabXd4BeE2JTCtP+2LVdlY6+Jkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH0PR12MB5452.namprd12.prod.outlook.com (2603:10b6:510:d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 14:11:07 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 14:11:07 +0000
Date:   Mon, 11 Apr 2022 11:11:06 -0300
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
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v2 1/4] iommu: Introduce the domain op
 enforce_cache_coherency()
Message-ID: <20220411141106.GA4085842@nvidia.com>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <1-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <BN9PR11MB5276FBFE9D5BC5039BA571A58CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276FBFE9D5BC5039BA571A58CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:208:236::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8df70fdf-0a56-4768-4662-08da1bc51f63
X-MS-TrafficTypeDiagnostic: PH0PR12MB5452:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB5452CBA84616FF98593FB549C2EA9@PH0PR12MB5452.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sFDUnBq4dwxb+2cbGGcjtdhcjEmbPJo5CO4F/5bmuZ2gPM0dPwKGy04zIN2VhMg+IDDj1Lm7SgWuOpp//mEd3U0ML35gE6t53pdbLngjug4aTRzW3d1qRT7Vgf9RdqeGnm3XASmBRl/3Nl5f3OqGT+wO117NgUO8wGQTDh8oILzFF9OnSj03aifdVAlAyN7MmOONLvIq/FsVTWWi9tvEaSD6sOEHQNLmGDp5T5UJ7WPyvbG+NGoxZM0HCt1WwIF+UwSSqudSLaBZsOh2TtoQGADiRYcUJJeYu8sRGH32MCxGGNeJXU3OPsj3xk3LxHyRrMnvIZ4+qek7t6j2iJ9i/iqDdj2FTcLEUqazP8yd668o3tUpQFMmuNK4bE0F8XcuiZHsxAcq8OOZ1zLJO3zi/TRJgWg1qyxoHAQk/clXOtRBkmRqc7lKh2ElRo4luU7TIfVCzoqBl9xRYqP7vcRp0AnrBM7bYJaXGxRxYJ18IrCyQiX4AnEixzLz3BfXfBwZtXN08WhhtSPhTw6MrOungMdPHqhPcF1y2e+LRuYkfHG3neeJFhMoZykKAmM7+zEZ0HTeYg9tQRhN/5FiVPi6lNZcrE00O586/LTrNRr3hzCRvBCqWN8LN0P8tSzFmLPDTHpB6KcN366WDABzoK1CbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(86362001)(26005)(1076003)(2906002)(2616005)(8936002)(36756003)(186003)(6512007)(6506007)(508600001)(6486002)(7416002)(5660300002)(33656002)(66946007)(4326008)(316002)(38100700002)(66556008)(54906003)(6916009)(66476007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g4u+GwksEGggsKIy1/o1YZyFUPa5T/zHK5ud0fGdXTS/Ee5Y6v+UhT+Iyqu8?=
 =?us-ascii?Q?e0e30RNtbmhgZdRFFFstqu8Ffj5uk71zmJYQIQ2My5k+2mUOjgmTlhLYMt9V?=
 =?us-ascii?Q?9FJcSfjo5j855lCe07vL5kXmE8KG9kiOHSnnf7eKYSfBfCDZ6Q/SP9npyM1u?=
 =?us-ascii?Q?aKQboAaN+Mp4MYSeoCHeM0jZxddUk3E/FeVfwlyn4U0CRE8wyrCnHcGUYbMj?=
 =?us-ascii?Q?3qPwZDV1H3TxJazvMM4Tu1A4gF+yFrcdlygy4Uq19oxZc8TsrUZsfUL6bDYE?=
 =?us-ascii?Q?GF5Pbix2AgO3rKTlcy+rBWyt4ei9ycsQQPUUdnopoDnGC+cVtWGdsfQRphyt?=
 =?us-ascii?Q?WMpDU7TMh+OoLhp2f41iT/5HKIdm35Lk5vnx7vMyPtU3xmV+BmiItps+AVn4?=
 =?us-ascii?Q?z9d2LpJDJ3ZVCtQqr6IKNSQ/4m3Nh6Zc74X5qzITgAo5Vqv6GLufymw47bjY?=
 =?us-ascii?Q?pw7HW6nph+QNG7AyMLJrQswNeIvPnumbTo2r2PQtlNdIoStcaMrlTsAJHbd1?=
 =?us-ascii?Q?mwdit3wWLC8yVK/7cYUeANTBcOxKYJvhqABaDkb+mMuZ/Kr14x8x0BUTTpoS?=
 =?us-ascii?Q?wIIdUvLVinoD3MdB1QW4gclNuwPs7v/Kbo3YyIyfHynLCW4p3Z1BI8Pxu/b/?=
 =?us-ascii?Q?FM5FxRYK8zYV1pcgJZclLKEtkCG82KP6s0c7n6XfMw11QayDv+OfowGseolG?=
 =?us-ascii?Q?2Qr20G5AWbzjGqeR2UzC0t//zZONWEktHctxLPzk4+FFdn1jD6/O8PHDtRxE?=
 =?us-ascii?Q?YsNsU9QyMXEG6q9e93TWTDYnNvihe27WWSxxgyM8tIe1mzRmq8XuKPUuPNtH?=
 =?us-ascii?Q?tNc1YD18y9ifrK+6Wan4Ua6/JDnHjAlNetQPTM4lOaUg3ElWEksxpj8J+KZj?=
 =?us-ascii?Q?Mz5coRpgdaxSeXyo41PLY5k6b5Y0Tobtk/vfoTvn85U2f+BRXk/ySMZ4QgtQ?=
 =?us-ascii?Q?BF/TBPgqvjNkUNxBJMINaqMabGU3AOdnJ7TSivfmFWsH1V6dWlUhiI91hzKA?=
 =?us-ascii?Q?F+7Latn5TRUaYOhuZCXDMeiM7URr6i1iFg+MDmpYYJrdS9nFF+A40j2yCGc5?=
 =?us-ascii?Q?ua9lICdU1eH3FZJSln+EsKjuLUe4O6v5CRFnH6kW7Tw+H4XA8PoXHekxSCv3?=
 =?us-ascii?Q?EKphzKzm7LK8TNgIQkpy+RGPxP36crU49fyl6EG6SEKswN5Iwsx1o32CbemI?=
 =?us-ascii?Q?BMe1G0UvjTJ+KN1LNGScQW8Dmiclw1FiQ3Swpr9jv/PXeOJcSuD0b6iJeIF0?=
 =?us-ascii?Q?9uoQ1yE4AlLGkQS3OCGP+PeLybXUAdCBXfyJc7WlDg+WouKt3/nDXf+aCEcX?=
 =?us-ascii?Q?BHx/SAZ0QeKqte7yhiY3mFKbSp81PFYvTgaxgIxVA09mpzjJD0XAiuH2gIGy?=
 =?us-ascii?Q?SE+EagG7zVjgA3TjTvGbILwSh8kL69/WhYDiK15O244igU81dVB6kB8sLqkJ?=
 =?us-ascii?Q?Ck+ne0p2ZBLnm+j7yxeYryjq4IiiVJQMB3rAQuAdPSKmVdM3vHuCvC026x+1?=
 =?us-ascii?Q?NrUcV7B8AwVG3vDNvp8RTEZGE9IS2kRwsuVPrYp9E3JtiuN0Du4ibGPi1/yB?=
 =?us-ascii?Q?P+2ZU6jKbp1CBLGMRCXnd2WhNDS51/vCwFrrWRPyi8rSHUngq1WbJwGxpbiq?=
 =?us-ascii?Q?39Hr8PM6HASJB31pl/1GGOWXCzIWZUsGaRr1pN4l766ufd4vWkvNwf6iPB07?=
 =?us-ascii?Q?MqjkdfpvLvcmlyAyU8uigQSV3kcsqYayXr/MU73bG4d1b6KF8AeBezlp0Zwn?=
 =?us-ascii?Q?JV9NaIZwmw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df70fdf-0a56-4768-4662-08da1bc51f63
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 14:11:07.6703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OP8I59ThZo9E4kv46j39SpjdiPP0xmC7OFbrNVjri/gziEQEU9g35m1t2OoAdgJQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5452
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 08, 2022 at 08:05:38AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, April 7, 2022 11:24 PM
> > 
> > This new mechanism will replace using IOMMU_CAP_CACHE_COHERENCY
> > and
> > IOMMU_CACHE to control the no-snoop blocking behavior of the IOMMU.
> > 
> > Currently only Intel and AMD IOMMUs are known to support this
> > feature. They both implement it as an IOPTE bit, that when set, will cause
> > PCIe TLPs to that IOVA with the no-snoop bit set to be treated as though
> > the no-snoop bit was clear.
> > 
> > The new API is triggered by calling enforce_cache_coherency() before
> > mapping any IOVA to the domain which globally switches on no-snoop
> > blocking. This allows other implementations that might block no-snoop
> > globally and outside the IOPTE - AMD also documents such a HW capability.
> > 
> > Leave AMD out of sync with Intel and have it block no-snoop even for
> > in-kernel users. This can be trivially resolved in a follow up patch.
> > 
> > Only VFIO will call this new API.
> 
> I still didn't see the point of mandating a caller for a new API (and as
> you pointed out iommufd will call it too).

The language is not to mandate, but to explain why this hasn't come
with a core iommu wrapper function to call it.

> it reads like no_snoop is the result of the enforcement... Probably
> force_snooping better matches the intention here.

Done

Thanks,
Jason 
