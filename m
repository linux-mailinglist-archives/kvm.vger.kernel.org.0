Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F094EDA1B
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 14:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236537AbiCaNAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 09:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236515AbiCaNAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 09:00:38 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2044.outbound.protection.outlook.com [40.107.101.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA014186149
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 05:58:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEd6lxmngoK0wDcx7lcA/oI5t+s/zM6MszPthhrbi3SahuAniq5jKHUWO1tCkkE21ZqIj6yOTTuRl9hxDCI98qnovtfywRvuY62uFf+VmQXk50NNUw75+sjAe0Ib16QTu/ME9DcQg3zuN0XTiQcPG8G5e+6NkWx8GVeR7AKK+j8heR1N6Wk1lwoHNZo5O/Ia6EIg263OOpuD10H+pTqPY+JMwUkEe+kNOPYvLd9u+RAeoNeI9O3McCQ6oYj1qv0cBJheQ7qqe+57MWAWyYfKZxpGnIQ1TPdGd/MS1gLwCzMQw9NjQ5OIv2gN43Hon954UUmu6YTOCKuJHeISDdrbrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+zp1xfqic6TylpcNDTxkN867fzMs5FwTVyqecMcgw8=;
 b=FucemQl8PiNMFljaH3Rss5xxyAT7c3j1Ch8QcucvOxFXZcqKRP2H2YvDfk3CR8zl0jMy0Ecs4WIcVfaFGQxrkMGUOCaD9Gve26dKFOonvTkZCmDIsDbEgybQvSHlF7g7gRN8RtDw3zXGxULlfA7aNyGZFY4V7ceDeRwEgZC82EhfJl/NWByTzcRhhVL7NOaoiBrwxxV5J1MsK5LxUXj+zRrfMpgTDNlrcadC8Avv7yPyNqKuejwRFTi+Y+BEVWjcCDKbDLaUzgKms6sUQ9AqDx4dTs6iif7BXEDiRbdCayIgA1P1K7OSnA5Wb2zPw0hCmdq1/VyGJX88nbHt+0NOkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+zp1xfqic6TylpcNDTxkN867fzMs5FwTVyqecMcgw8=;
 b=Ah4BhmkOqMfM3cervzr37SjbjSl/fOlXnrRfO4xj1xZIi0LDvqFJJ+kS1c8yIyIhFxpVijvvNO5ZZNDixOtDpTu0fA0gk4eMu+z/FuH9E0/8c6L3Z7UXHUPRuvcWyWT7Ja37RehtQhzRoQGYgX2DW4yst3En2CtZ+/Y9rRgcUVT/wPFbSe9nPja1eI3rCLERMVoFSZ8pZt1IEcvyj0jR06NF/ZHfgGBuU+QvikSdcmY1xjPHv1h/xpDuBHow2vLZiG4InWo5YkSEjJq3iKbuwRwOk65CY9YMQWI91OgtIqEJKjsUgv7EOUyzj7I7J3APWnRX6ObdPhj2xYGyLXU5LA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB5901.namprd12.prod.outlook.com (2603:10b6:510:1d5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.23; Thu, 31 Mar
 2022 12:58:43 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%5]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 12:58:43 +0000
Date:   Thu, 31 Mar 2022 09:58:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
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
Subject: Re: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Message-ID: <20220331125841.GG2120790@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <YkUvzfHM00FEAemt@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkUvzfHM00FEAemt@yekko>
X-ClientProxiedBy: BL1PR13CA0376.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 195538a2-0d54-406a-37fb-08da13162f3a
X-MS-TrafficTypeDiagnostic: PH7PR12MB5901:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB59011F6C7F8E4E4F2E65EE1AC2E19@PH7PR12MB5901.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w4lRaE3yaLnHgnK4w3tBU23waKbntty8sWtoeEnPf/jV6qTUfbHmQ1t8BKaailXXqyGrqx1XY+ClmP217leDiTtQIvAT52jN8bGh/TarzbdbsWzw8jTatdPiuNDY4v54aRfY2Gg0WiKCVveNEVf9URUC5oX2S9fTNoH+TvCQFhtYtC7cskiWGWoszuroJNYKGD0dYvPicUaA6BkUFKZWwN4AdPMimFSG1L8Ac4bGD/KjRGkua291J4chPK+D7yTsefyrovx0/aT3Ir/hxJLZm+O9cvVREKaxHzWgaQCafomm3z0NVv1Atc9RzCTvTr4Nf80EXj7VANcfeJmDT7auT4bFI7GUQ2CH4RtY6bx4BxbODBHDV5PN/Q9WG9u+Jrn5MjJrG15hqfYTnMrUDoTCRjasZDEOZu4YLtMN99M7qZuBieaQhl9TUhg6gRWw3GBUahS8nj0bFsO494XwE+tN/s6mOBOCZTCoviPpxPACBXMVkO4IBAaWGvA+dRKIdog1/jHlokfm51VlrwUGiLnml4Zh67Tki5oi++GioUIZqf/n0dKQPCQY/vxukfiR+yD9MqhF22Z5hK00sSR3ZHQkmCZf7wYbvCb8DUXzDb04ohWtPigfeeZYb403r8MkGfWIzUu09TrvLyMXzizmzjBfmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(54906003)(38100700002)(86362001)(316002)(4326008)(8936002)(8676002)(66946007)(66556008)(1076003)(66476007)(2616005)(26005)(186003)(5660300002)(83380400001)(508600001)(6486002)(6512007)(6506007)(33656002)(36756003)(7416002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gZb/cFJJcKETLfVeXY4M4bueDl2+XvgDVG1AKfXlWhG5rJLuyfSw8G2D1JzK?=
 =?us-ascii?Q?KOCOH1vo1gs9+GSdo0SZOjo5uUeSlCNieuOkuKOKi3RHj3dhLN087S7m6HiK?=
 =?us-ascii?Q?4Y2+XN4dWGIwO5ke/+helpwlhlrcoODSnGoxkg11MZEtLGhVQRATQkAgOqtB?=
 =?us-ascii?Q?tSkLF4yi4P8bUIuZh0kb7+xlY6jEsNnowfF6UBEsRkaaVp6IVxdP3WqP23FC?=
 =?us-ascii?Q?XioG0ZtjyGbj87qdyjTlTSq29jJYuS4zNJVrozeG/T/jZpxQbbi+2LUkokiE?=
 =?us-ascii?Q?v06rzw/uVt42lbU9i/ms5QvshHBPPH7L2amK0uA0epQ87DucmZUy2auAykjA?=
 =?us-ascii?Q?8JPr2GuvN3JUT76GbSXQ+QN9JIZ/NHOQ71K5zggqGOiePqRixYVbFxTDxFJa?=
 =?us-ascii?Q?V87aSI+mq/1Kw3J66XF8YwQuz2nSZHIsrpZyHs8OM4yDlqnJOVp+tXV0tRhn?=
 =?us-ascii?Q?uXN7BAOmForqKxvyeLOgz9r7wuSC9FvXMoUfDrGSrb70f65ZWVgZUV2Yhb23?=
 =?us-ascii?Q?fUptAr5EC2+0pSLMU3OZdqFnpOqNtrq3jQ0Yt5lgkwviN+0O/JpvHTDfk34t?=
 =?us-ascii?Q?ytLCHq23mqxmzHLLxY0xqq5gSNfnPP13s9a2rG6r51DFctpVyja4ExzVw7To?=
 =?us-ascii?Q?Ulw9hI/mp+i8rMJmuurh67buW8iULQIMPwkrebJ5RGW2cragVxbko10HIwJf?=
 =?us-ascii?Q?msxvfgaTb0vNWLJhW4ttc/hB6W7SCiFawQIxCmvh8WyJSDlGZvgX/h8UQlgE?=
 =?us-ascii?Q?HKD3chBIoSvMhIxHetE6fU+KOcH6MV92ahI3uXDixsok9vBFMzLyg05j2Ser?=
 =?us-ascii?Q?OAs53Gft06jOQuEOrFeSjaWzXz59pgrKjDEjskeNkqk4eJ21gLrG6AJMRzzq?=
 =?us-ascii?Q?067EHb7TfjI7stYmXTqOLPpBHdoOyqncGJDO3t2e76jeBv5/cl5+RYlDSdxV?=
 =?us-ascii?Q?o2A/n882FOqHj4VDaj0TfWX7Jatm5TrB07g8kBxntFn1s2rUnbuI9mAUh+29?=
 =?us-ascii?Q?QJRm1vERS1GzNgFm5qqnAonFmQYhH2f1hULC8SexELM7GA4ENi8uLdBfMxTc?=
 =?us-ascii?Q?Q9uc2vjT2mxsKYlO+SpewOA8FheFggZTXrm64LKSM7Fx6rMRrLBntRmyrB+W?=
 =?us-ascii?Q?nhVPZi3lfRi9joYMk2M0iFk3j6ZNZgub/ZurRwtxSXssiSOjwuTwr9jRrR1c?=
 =?us-ascii?Q?W5t7MMuzUnC6JjBJ5qjCOMcklnaYFL4+x+x+XFgd8P1I7oEsOaBTU4ZA+9NK?=
 =?us-ascii?Q?zqoL0rXUDSZlZ59aFsOF/Wn3q1dY9BrXRwC9/oRI0QW7exJpt14A8t64nO+d?=
 =?us-ascii?Q?2M8TTBpeySmN0odYrWRtlsmQghxvFYtTYtZOug1yuxqh0ywy3K7UoOH/Gg/B?=
 =?us-ascii?Q?pSmMn8fEk3nvltWzoDtXd15U1Cy5G2FMjKR7m2WN/VyJfolTOT/61ZWGQ0JR?=
 =?us-ascii?Q?7/ekacPOkZGcyyqglEHIhILchrn1dYj9ide4SYUMnj5luH3ocdXvJ8fhVfnL?=
 =?us-ascii?Q?+sqrolmeW0VuZuikWBYwNbiwiXnp6OA7HzKJMFiA/mm5sLZQXuQI4s7wbAgs?=
 =?us-ascii?Q?6SasnrQH3dXJ+VwI7y+SzAROXj+o657jB150KGXBIsQFqfdOh6T53uuB3Cl9?=
 =?us-ascii?Q?CmPcCnGIt8SAvLp4p07cLTbmWpYhPMBVCkxJqVPhL3+yg4n1r0aKinZK+gAk?=
 =?us-ascii?Q?qGzoFfJNAtfdCJ4kI6JacPLNwosifWbiaFQcB5fqQ9tTpgwziGqaCvLaziE/?=
 =?us-ascii?Q?o6OLnXRwmw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 195538a2-0d54-406a-37fb-08da13162f3a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 12:58:43.1724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BzzbRiluNtjlvOTvrG47dP9uduA1tTj/Yxv/dOHphqvPuUJ3jScaulxH8wIfEj3J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5901
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 31, 2022 at 03:36:29PM +1100, David Gibson wrote:

> > +/**
> > + * struct iommu_ioas_iova_ranges - ioctl(IOMMU_IOAS_IOVA_RANGES)
> > + * @size: sizeof(struct iommu_ioas_iova_ranges)
> > + * @ioas_id: IOAS ID to read ranges from
> > + * @out_num_iovas: Output total number of ranges in the IOAS
> > + * @__reserved: Must be 0
> > + * @out_valid_iovas: Array of valid IOVA ranges. The array length is the smaller
> > + *                   of out_num_iovas or the length implied by size.
> > + * @out_valid_iovas.start: First IOVA in the allowed range
> > + * @out_valid_iovas.last: Inclusive last IOVA in the allowed range
> > + *
> > + * Query an IOAS for ranges of allowed IOVAs. Operation outside these ranges is
> > + * not allowed. out_num_iovas will be set to the total number of iovas
> > + * and the out_valid_iovas[] will be filled in as space permits.
> > + * size should include the allocated flex array.
> > + */
> > +struct iommu_ioas_iova_ranges {
> > +	__u32 size;
> > +	__u32 ioas_id;
> > +	__u32 out_num_iovas;
> > +	__u32 __reserved;
> > +	struct iommu_valid_iovas {
> > +		__aligned_u64 start;
> > +		__aligned_u64 last;
> > +	} out_valid_iovas[];
> > +};
> > +#define IOMMU_IOAS_IOVA_RANGES _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_IOVA_RANGES)
> 
> Is the information returned by this valid for the lifeime of the IOAS,
> or can it change?  If it can change, what events can change it?
>
> If it *can't* change, then how do we have enough information to
> determine this at ALLOC time, since we don't necessarily know which
> (if any) hardware IOMMU will be attached to it.

It is a good point worth documenting. It can change. Particularly
after any device attachment.

I added this:

 * Query an IOAS for ranges of allowed IOVAs. Mapping IOVA outside these ranges
 * is not allowed. out_num_iovas will be set to the total number of iovas and
 * the out_valid_iovas[] will be filled in as space permits. size should include
 * the allocated flex array.
 *
 * The allowed ranges are dependent on the HW path the DMA operation takes, and
 * can change during the lifetime of the IOAS. A fresh empty IOAS will have a
 * full range, and each attached device will narrow the ranges based on that
 * devices HW restrictions.


> > +#define IOMMU_IOAS_COPY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_COPY)
> 
> Since it can only copy a single mapping, what's the benefit of this
> over just repeating an IOAS_MAP in the new IOAS?

It causes the underlying pin accounting to be shared and can avoid
calling GUP entirely.

Thanks,
Jason
