Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA86765C2EA
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 16:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbjACPWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 10:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238093AbjACPV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 10:21:57 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2077.outbound.protection.outlook.com [40.107.95.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D931135
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 07:21:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YiSBl5jKFQ0hmElx1BlU6HR0gkpk0ceDgOCRnkxjAGaxWEilqvb9BBLggb8v1UnlDJ6l4hYYRP5gjDE1ahA3yEAEaH2e7LqLP+g+TUwKSl6Lxxozh3Il1Tmk+q2kr/Wsu6l/bnwr+Pibv8MU2Xn8j6HvT95n9i/jkXmZPSw6OQZBPe6T7wtVYpELTmvfSIKDY6svSoaPkFrD2rm12yiBwMO4ohB20RyJD49gtWOqWbeQwfWXfrrW3+Y9AqDH19yUgqE6kJgjA/9V9hXz3c2vvmCHIZsJO77+jC33U1xe76+05pCAWDtr+3bRVJjXbJVEtMf+f+s1Gq6zF8Gux7Tq0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MR45Ib2lhphn4d3gp+LP6Bvr6uklvNFejK0jmVL4YuQ=;
 b=nHeODIJkBrYWqG8ia0wwXP7szO94WQ6+mpmTnX/KtlI8mkUHl3llB3I+i/GqtgIlw6QEL5ZEgT7WyeshCjJrZYMsGD1outcGFn1Jf85P/zwiapKBOT78I4uk5nLhqpCTyyV6wVmNWtklJyrYcTglYbVOahv/3c+j8mEYrIfPgqos3nAj3JgyYJWpYx0Os0JxGxRXlYa4bXNO4jqBONF7v/gOViu7TDN4MeOeuUHErp+DE5RbD0G/dCdb5ccS8aCUDX7QDcIJt9/SwEPtPBjhzXheFr2xVP/ue+dNzthIZNrBsYpBFgkjGQas9YDLZA5xbV+dA18uHsF6iJ6cLP4zkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MR45Ib2lhphn4d3gp+LP6Bvr6uklvNFejK0jmVL4YuQ=;
 b=IjzpREKryQF3kGfOI+wGDG4Vz+glgVtbyrgpHe/Aw9vazKoTIecjKO9QfmaFGTcKy9TsJR8oDLHfIxeMHGC5aPeaLJfoLCbms8mWHV+4SDWxlynecLMuiGlTA/Z5f+KzrufoxjTuoVqf8CQZ8qbNu5tCiAida1Cf6pLLPrfN0yDdCLn4g2JX3niFIPrd8A4iH+ru9nCmj1OdqM+3RFBojp9xRnSV3z+Iuz39uBZyz4L20OCcKeG1BkxohKc5MsoUDL9jkFA8FyZkK9ZFagshnq977X7WXRNrMZwB2EfqAJD/Mdm3mMe053Ylz6vghz64reyG7V1gZo9xxg5xM/LAtA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5379.namprd12.prod.outlook.com (2603:10b6:208:317::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 15:21:54 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 15:21:54 +0000
Date:   Tue, 3 Jan 2023 11:21:53 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V7 3/7] vfio/type1: track locked_vm per dma
Message-ID: <Y7RIEeQW5L+qFt9a@nvidia.com>
References: <1671568765-297322-1-git-send-email-steven.sistare@oracle.com>
 <1671568765-297322-4-git-send-email-steven.sistare@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1671568765-297322-4-git-send-email-steven.sistare@oracle.com>
X-ClientProxiedBy: BL0PR0102CA0070.prod.exchangelabs.com
 (2603:10b6:208:25::47) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5379:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c1e318e-e1a9-4421-a774-08daed9e3f06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BUx5zQHBk21Mb3mcMEuY2kXPleDgOL46vf24GPtIYn52UatlnAqfSutxEB+JymKjjTC7pebIpmobmcIBoX76tQj71Lpq66TTws3CqgtmpdBiwG/lYKD8sE0hzHfW/e6/AtuC5Ogl+AmSU897cHKfRdVde25xfUbh+vBKGVhYg35uEQ+5VGv/p8O66tofo3CYRnupBkrbF+vYsaa5/bk+MrHjx6n0cK1Xj8ZwU0jQeMBFs0BTn/lcB0vHfqQA3h989wThxgGbPWbGqiiZ9GNDsA6edMpPR5yXOps7BekGDk20UugJRV7Ubvl42PincmdtKRKXVTBShB/T6pvHVhwI/B6z4uwF9ila/WsSpepl56/t8hO/d83hfVzP6XGfBdx/d8vXwIobTyGO5snaX9ysrfs5ywMpZoB/Dt2Zht0Y6p+kOng/fIQ+oWmza4o3IyYF6pdCOGeKWDZOPEU5nIRLr8L1DYB1tJ23FM2LgS2HeCCdEsnJQTOU1Yo+bexXnr9V1ouJZpjHPXR/ypxD5T7cGcW3r2iM6trcJrDia7A/GYMA6uqtsu0xdaec+vhX93hKbxMnndJMZLnFx8L/+AafPN8cKmMi+h3xZbOyXAB2yr+X2YBy2uw94K5gmoqUfcnN6Af+qOT+3px+rLaDw14rEUmQbKWRB/qRLO7i8lUlc6YChfNXdIRrvl0Jsuay36nKs4+OpH3Y04v8CK8+b34trA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(39860400002)(396003)(136003)(346002)(451199015)(5660300002)(2906002)(8936002)(4326008)(8676002)(41300700001)(478600001)(316002)(66476007)(54906003)(66946007)(6916009)(66556008)(6486002)(26005)(6512007)(6506007)(83380400001)(186003)(38100700002)(2616005)(86362001)(36756003)(22166006)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R7484/+XY96sElyJv9piRb44hRSaoepIJczJDXMQiEMZHf/DOUB/OmHdbkmJ?=
 =?us-ascii?Q?rfnrg8JLD/XbOej/cKaES2siE3lNWyUNrByatHGG/vXpKlDJKyhmOW93GZM5?=
 =?us-ascii?Q?ziUfQa8Z59A5xs9TN009AfM6k4MRl1ZzQiLkMFrbl4j7gsfXHfZYnwEskHMY?=
 =?us-ascii?Q?916oRCeq4sZ56dGVL65w/D0cCtKdEVhyjcbsyYB1zuNGMGj7L4w56aIM0APt?=
 =?us-ascii?Q?WV3pbQk7OyCMxHD/HAD+BrExZqYZrIlfSTM+DZIWoLxPoHv4q85Dj3Y2oqMS?=
 =?us-ascii?Q?Y8R3pf3gG/9mBB14vCkpmpdzAQdUoItTQg5YujUd4aMkgxPFJ7RB00fzO/aD?=
 =?us-ascii?Q?AHisQwQIgciI3ctEhsE9Q1IM+UbOnwojqDU6J1q8HleQjKXfFcRJWlGvnO+l?=
 =?us-ascii?Q?AG0rkBeazwmbxlxYg3lbRvIouE72bDZO5G6dSJachy6YUErNNOWNulQJbrHU?=
 =?us-ascii?Q?h/LLhELkLGFkCc117ifWNJ+9ulWj47OxexFUSmGMWsN7tZK8146eDXqDyoak?=
 =?us-ascii?Q?qUJ5SAbV0hFf0LkPo+LROF+FDtKRLc81TuppBRHwveqLtzA+r4N1KecjDoww?=
 =?us-ascii?Q?vCZ+EkQKjJRY7eFkCvlYagEU8btTuZzgtmW57IM1MKHgvxtqoxlHtQhkZZaY?=
 =?us-ascii?Q?Tr9rBg/b+hJLb8PcCs5HB4dYEIp6nTmh3b3KZYQPNw9YgXAA241yhbJmWWz9?=
 =?us-ascii?Q?kQWjo3ZL4uO3C3V4k6HCMZ+o4kACjcpjl4mRNQn6fc4EkYijKqfXWsHzlmGl?=
 =?us-ascii?Q?YpHdA2rqrXUDbY7/CyM0Jg6XrV9jL2j2sf4EGkRx9l9kpRYAeikiehpSJT3x?=
 =?us-ascii?Q?7Los4rIMmmqDl5MQl0Gt+FhBkBjARDo+BAfIlD6WRQSqjtP9vwT45I6NxPLB?=
 =?us-ascii?Q?7OBL7TTcJg2N/9UDTReyr77+3xFdoBhBn42+Q6QEgXlqPaDI2BNIaxF6yQXY?=
 =?us-ascii?Q?OLwCzJM+2cuHh5+xH4mYRGi9gVvXzxUuXF2PCCDcWyr4DE02CznykJju62tD?=
 =?us-ascii?Q?wewYVsCwo7H0svMG24wvgNeFa95pQ9jhgSJOMEPTgYfd1AYxpTZrmQ98w0R/?=
 =?us-ascii?Q?puB5+9/SJhCA+qMD/qJtPcQUKDalg3N9uNXqVDoXJ8yrxtyObujJhG7LN1z8?=
 =?us-ascii?Q?k1YG/MeKHg6rOszb+5jnYvxc2wPYCdgBvNP+UCHj3eRkiN+Rom6WDBf4XUNU?=
 =?us-ascii?Q?iSMyPDaraRC8XyKX+x77ArPeVr838rjTFOrYy3odfzLvmemO9mbb25tj6Krt?=
 =?us-ascii?Q?hovSdvglSuLhoXXUowsmWm/ZwJ3VXAREfuhJSCBt27TRV1o7WWRP2e0rS9PK?=
 =?us-ascii?Q?i4ItZc5+A946XsP+yurKWHUEKzT1dgg2Ofgt8ndMOU3TtyIlctEBbKI+G3nN?=
 =?us-ascii?Q?lE9eNFN1BQ/oHZDhwp2pJ2/Hg4UDKpX0/Dfb3w7RKo3hfPGXQ6dD8wUtZ2I3?=
 =?us-ascii?Q?qshNPJPXV6yHaoJPo89ZBTloIMBlxOgMh0VGzyXg5RDiMo9IjlLDtGCRahQq?=
 =?us-ascii?Q?4soSwzmuO0oArd6GjyP974M9QNDPE2aqKtuQaiGreDo7CWQpn5yt4GR0pnft?=
 =?us-ascii?Q?q8cONIzhNiJAkNr2s/MMsPKh/Aqo0ujyaOFJ8DW0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c1e318e-e1a9-4421-a774-08daed9e3f06
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 15:21:54.5925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hlZA0udsRFVnxKiFzaUzn3wNdHuYz4gB5QYB/bWpRsTWoQSh0JexAHWMV/itqb8+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5379
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 20, 2022 at 12:39:21PM -0800, Steve Sistare wrote:
> Track locked_vm per dma struct, and create a new subroutine, both for use
> in a subsequent patch.  No functional change.
> 
> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
> Cc: stable@vger.kernel.org
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 71f980b..588d690 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -101,6 +101,7 @@ struct vfio_dma {
>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>  	unsigned long		*bitmap;
>  	struct mm_struct	*mm;
> +	long			locked_vm;

Why is it long? Can it be negative?

>  };
>  
>  struct vfio_batch {
> @@ -413,22 +414,21 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
>  	return ret;
>  }
>  
> -static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
> +static int mm_lock_acct(struct task_struct *task, struct mm_struct *mm,
> +			bool lock_cap, long npage, bool async)
>  {

Now async is even more confusing, the caller really should have a
valid handle on the mm before using it as an argument like this.

Jason
