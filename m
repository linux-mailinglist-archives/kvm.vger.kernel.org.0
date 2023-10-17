Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614167CB836
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 04:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbjJQCA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 22:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjJQCA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 22:00:58 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFC9AF
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 19:00:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipDMvye+ZWRYNaaBvAH/AgpzE4ly+TEFoUCboXvCTRnPelNU9W6ABH8a0zvFfTcatRkENB6MYzca3wkWj+Mr738YTL+TEzbUzA7dXC/AlbKtgn86xGzMtQtK3RoH1DKvPoW7Hr1aXp5DI46v5/cQall5fxfnZsXpNJWNA9mfLsU2mESt8tHBcvG6nQ0EmW6xPM90c6PaC7A+rOws9/6UHj061oHh8ztsG2Fb44KvKSgX9U8hgS63CJBFPHuVY57Gzg2/JcUq2m3xJGwLssqSC9DtUgXF83lv90AprnHn+DJzGKcZyI2EQvJ+v6RjPgLWr4SRpp4hHRZX9P5kb3XHZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bldKFdnbnxjvoOM93p4btXqrcb28haN/7eS0TLoD7mA=;
 b=J1ugoDLxRC2k5ktpw/D7WBbenNRVGzWRkzN4INZoVhxPQJ5CNtKRblxf/LxNldHnvdxV301QCgxBATEMy+vfiPtPKhVi00A715Yx46cF2JRFSvgA/5bqb8SAe2AkFRArFPikyOziWEC2VCtYTWmBbildQ8Mu5ozIKAj6dOCgtwAxzHdbZ5aDS1tuprmN3qLTeAGTQMELWU1NyQevxY5tAvWajVgqlKbqAUxIIqpg6TspW1qycGk5nUZV4uc03AN52vql9adl88fsa1xiBGnRi1Rkx2Dk6DgvPYYOpw9J3EsHiZGsTPIHLVCcuWfnlKfI4r0/ZV1bWn0VOlm7/rKsoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bldKFdnbnxjvoOM93p4btXqrcb28haN/7eS0TLoD7mA=;
 b=2ftqMhB8N7P5T00twx/pFu8FIT/zOqeG/QQ2jzBjCAEPHBcU7xRonbOwMnGPHIBebN7hHfOn5d+jdpUc+RIcmvjVR1ZCq6sSlI8HjM2R7/odcjd5NjXfYpmM6hBQkdJWRgdlk2193SBzBkHcs63A98zeuZlJsDTVsQUQYe2O6oE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 MN0PR12MB6003.namprd12.prod.outlook.com (2603:10b6:208:37f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 17 Oct
 2023 02:00:50 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::90d5:d841:f95d:d414]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::90d5:d841:f95d:d414%6]) with mapi id 15.20.6886.034; Tue, 17 Oct 2023
 02:00:50 +0000
Message-ID: <6c1a0f25-f701-8448-d46c-15c9848f90a3@amd.com>
Date:   Tue, 17 Oct 2023 09:00:38 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 16/19] iommu/amd: Add domain_alloc_user based domain
 allocation
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-17-joao.m.martins@oracle.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20230923012511.10379-17-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0206.apcprd04.prod.outlook.com
 (2603:1096:4:187::21) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|MN0PR12MB6003:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f906074-c338-43b1-1101-08dbceb4e2b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 66EGT/NndEkFS8HzUCG7crsyk6ILxKl5oV7fycmJXrTKa8UUMKEg8Rw8ynd8GnR8fiKmJuvvyTDdUg6/EnhLrKaBkZO/mHZ8CY+jlloaaEbsbNfzPrcycnison6uHvQPW1zZqjKcFewCGx6iTPWlIW4q1aSQpNeZ6uNLwJh/IMwkeGBBCTbfMiRJcClb0QObNz+TgcZ+nRugOE938ePTppGmyGLKL0zyebtpQj+okrniEtuVBYV7HXyC+x+2fS5hW6lqSZ56Yd5K/9uPljQySU7gEgQIKPDO4SpbaZQUhGwtHr5aBSOj3Ac4BlkZa3kZlWFbaObCpK4+F5N7YGg0U4SlkrTnojxLhiKbtbjNV5mTK1/Z4aRHf2CVmy/4TEIkxZq4kCRSI7eDEPEnvGlGIaPG+QtE+RVKJCzNIXPUKG8vuIgvHU75Le+gR6ZFflbjXdMMUzcGNCAIPIu3h9JQ/53nQFUFSZGNAqE9FVXIUatNtC1bh7n50ZSSGkKKU8U6A6e8bLcGSCNNHgzN7nmV8CO7huxmNApHgSLTsoqpCKp6DZOllmamPX23T8R7EQjpQekvVKW7uYA1ohGio4/Wx93QXc9GQ1QAgFvrd4IcCFKYA0uCdFO5t/j/kWZr3Oa5HvoSuX6m8Bi1QCMWND7oaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(396003)(366004)(346002)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(53546011)(6512007)(6486002)(31696002)(478600001)(2616005)(83380400001)(66556008)(7416002)(316002)(5660300002)(8676002)(2906002)(54906003)(6666004)(66946007)(4326008)(66476007)(41300700001)(8936002)(38100700002)(26005)(86362001)(6506007)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZC85RzB2OXJUeHhTcmI1WE9zKzBtVXRQblR6bzlMZlREWjJwOVJTUWpRME4z?=
 =?utf-8?B?U2tiQVpNN3VSNm9nNjJFZXBBMFh6SG9CVmlJUlNDQmIyL1o3MmlNUGRlOWY1?=
 =?utf-8?B?N3ltckNEM1l2SHRFRnFDV0tZa2s4OS9TR1pZa0l5emdJMDEvamN6TEdjc210?=
 =?utf-8?B?d1J4YlY0Yk1qdjJaaHNYdmxSeXRtdzQ0QXplWVdBWDdLaUtUenlseWpDWjA1?=
 =?utf-8?B?SUcyc2VFTFZCeWlWYTIzSTR2M1lnaHdnMFB5VXY5QkdhdWdzSzNVWlRUSU93?=
 =?utf-8?B?U3RRNmY1WDIyaFNTU0tpY04ySDN6cmtyckRvcmk5dEZLSGpNWit6RHRPTWp2?=
 =?utf-8?B?ZUloZFQvSWpVTElsUVgwVFBiV3dCL1podU5waTFnVDBGY29IejlRZWxFWnRv?=
 =?utf-8?B?UU1QenVBakZZY205UWZNQzRVTytBSTRlMHU5VTQ5VWd6VE1nMWhqbFprY1FF?=
 =?utf-8?B?dHlEYTJLVmNUWXVGcFBzdC9kMlpJR1M4WG9XVTFhTi9BTG5udTVqQ0U1ZWtU?=
 =?utf-8?B?a0lQNEt6T3FLVnkxWHBBZHNyVU45NFhYR01NZWRta2J1Zk80NmhNWUt1SE5S?=
 =?utf-8?B?QThtbFlhNFI1UDNvUk1GZWVDTWNOUnN2ZGlaQ0t5WXBqNG9XUGFSTm5waVgy?=
 =?utf-8?B?T3MvdmM5NFlNZkhPY0Zaa1E1NXZ0OHluMUpLck9NNzB3dEVvM1dWTzVIWmhp?=
 =?utf-8?B?ekJFeWQ0NTNDenFSTEJ2eTJFZHcrR3dKUENIdzNQbVpsTFpuc0lIQUcxYUtr?=
 =?utf-8?B?UlBZSVovbkpRbEhMa2t5MVFydllLZFNHN2dHQzVLeVczUm5DTGJGZ3NYWUFF?=
 =?utf-8?B?VG9PQlowZTVpUUppT3VQNkRTV0pNMzZUOSsvTkg0WlpkRGpQSk5zQmhRaWxD?=
 =?utf-8?B?dFBIZnFyZDJzNjFFakFpN1A0WXc5YjdvNkQwRFJJSmZJWTVmcVJWQWF3TnBu?=
 =?utf-8?B?TVV3ODAwVFJTWlJYTmNGTEpWcnB4WXZlWU1PT0VtZWYxNGE1bTdvM1JWVk0z?=
 =?utf-8?B?V0VNQzhyU0xKc1ZwR2RPSmF0Nlk5OXg3dUFKZHpBVTVkTk1vSk0yVlNCV0pP?=
 =?utf-8?B?bDJoWERyQ3pRS2dsWkVSbnNlUFNjUDMxVEVsMEtEd2c4dlRkOVZHc0lpcmZN?=
 =?utf-8?B?dXpqa2ZkR2lzQTlhMTVDUCtRbUk2QU5xdmRtNzhOTllGYXR3N2RHWkF4MFRx?=
 =?utf-8?B?R1BDNlpISDJpY2YwaStQc0pvSFY2Z2dMOEZPcWJ4VHJ4WjJ4bUlzbGF3MFI1?=
 =?utf-8?B?bnFBRWxtc3hCNHZNYlgvUjRwTER2ZEs4NVFCeXFsV0FWcVhKSE9kTE42T1pj?=
 =?utf-8?B?Vjg1MTA5Myt5WFYrQWpNMTA1VmxVVytOSDFWeG1nMHUyL1ZzUjRWRGJjbDZi?=
 =?utf-8?B?aldYK2ZWZEN2cVZFWHhrbDVaMG1HNWtIbTJLTGdrWXEwb0JsWUJQNW93SjQ4?=
 =?utf-8?B?U0NXSmNvNFk0cmY2TG5VcUZZbnJRNXowQ0FtY0tPODh2TnowMlFxWnNHamJK?=
 =?utf-8?B?cXIyR2xma3FjMlBUK3N6dUM5OFhtaVVOYldETTlRclk2S3NsMlZxK2M3dEUy?=
 =?utf-8?B?bDFIYy8yMms4T2cyN3pDRHIvWkZnaEFnalJNL0F1SGRzOTJVNnJwMGlmRUho?=
 =?utf-8?B?cUlEUVNmaEM3VEg0N2pQSVI5UGZaLzZEejQ5bzhSZDg2c21aNXNhaU1oNlBR?=
 =?utf-8?B?Z0cwRGpEVVVWdkxCYzZ6R0MwczNBTTZ6Yy9MdzJackRtS2FpL0JmRENPM2lt?=
 =?utf-8?B?NzVVTER1eEpZNlFzSUVDcnVkbDJMR1ArbWhNcWk3NTRMWk1VRzgvKzJMUHAy?=
 =?utf-8?B?M21ySGNCOWtSc0svZThTc0hBR2w4a3c1MDcyakt2ZUs3cUYyOVUzRUZWMWtt?=
 =?utf-8?B?SG1mOEVCWUwzSjVqbnRBQkYrTndzcVVlckhacjkzaDJENytScUFNN05tbW1u?=
 =?utf-8?B?bDJ4c2dwcHFZQkk0a2FxRFRVb1BLdjNaQnlSUzliTDA2SjdYbHRPajcwdEY3?=
 =?utf-8?B?dVMrWjFLS0J1cnhxeXBEUUlQNzdZR1N5b1lUVTR5SEw1L1FkTGx1T1pUVDVm?=
 =?utf-8?B?VDUzNlU4ZUFtMjAzTWp0azFwanBiQWpBTTh1aGUrK1VVM3lLTDY3SVFKQ1Fx?=
 =?utf-8?Q?YdO8IV3O/MsKk/6UIZTpjjrLC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f906074-c338-43b1-1101-08dbceb4e2b6
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 02:00:49.9439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LvMYq0o5lV/QtwLl3IRqmwnyJiKOpgvgf7uEW7FoKhtvsOZLX+7lYGZBnTi8o1jefI048CXgk/CoNdd8NMIGgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6003
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joao,

On 9/23/2023 8:25 AM, Joao Martins wrote:
> Add the domain_alloc_user op implementation. To that end, refactor
> amd_iommu_domain_alloc() to receive a dev pointer and flags, while
> renaming it to .. such that it becomes a common function shared with
> domain_alloc_user() implementation. The sole difference with
> domain_alloc_user() is that we initialize also other fields that
> iommu_domain_alloc() does. It lets it return the iommu domain
> correctly initialized in one function.
> 
> This is in preparation to add dirty enforcement on AMD implementation
> of domain_alloc_user.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>   drivers/iommu/amd/iommu.c | 46 ++++++++++++++++++++++++++++++++++++---
>   1 file changed, 43 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 95bd7c25ba6f..af36c627022f 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -37,6 +37,7 @@
>   #include <asm/iommu.h>
>   #include <asm/gart.h>
>   #include <asm/dma.h>
> +#include <uapi/linux/iommufd.h>
>   
>   #include "amd_iommu.h"
>   #include "../dma-iommu.h"
> @@ -2155,7 +2156,10 @@ static inline u64 dma_max_address(void)
>   	return ((1ULL << PM_LEVEL_SHIFT(amd_iommu_gpt_level)) - 1);
>   }
>   
> -static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
> +static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
> +						  struct amd_iommu *iommu,
> +						  struct device *dev,
> +						  u32 flags)

Instead of passing in the struct amd_iommu here, what if we just derive 
it in the do_iommu_domain_alloc() as needed? This way, we don't need to 
... (see below)

>   {
>   	struct protection_domain *domain;
>   
> @@ -2164,19 +2168,54 @@ static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
>   	 * default to use IOMMU_DOMAIN_DMA[_FQ].
>   	 */
>   	if (amd_iommu_snp_en && (type == IOMMU_DOMAIN_IDENTITY))
> -		return NULL;
> +		return ERR_PTR(-EINVAL);
>   
>   	domain = protection_domain_alloc(type);
>   	if (!domain)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>   
>   	domain->domain.geometry.aperture_start = 0;
>   	domain->domain.geometry.aperture_end   = dma_max_address();
>   	domain->domain.geometry.force_aperture = true;
>   
> +	if (dev) {
> +		domain->domain.type = type;
> +		domain->domain.pgsize_bitmap =
> +			iommu->iommu.ops->pgsize_bitmap;
> +		domain->domain.ops =
> +			iommu->iommu.ops->default_domain_ops;
> +	}
> +
>   	return &domain->domain;
>   }
>   
> +static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
> +{
> +	struct iommu_domain *domain;
> +
> +	domain = do_iommu_domain_alloc(type, NULL, NULL, 0);

... pass iommu = NULL here unnecessarily.

> +	if (IS_ERR(domain))
> +		return NULL;
> +
> +	return domain;
> +}
> +
> +static struct iommu_domain *amd_iommu_domain_alloc_user(struct device *dev,
> +							u32 flags)
> +{
> +	unsigned int type = IOMMU_DOMAIN_UNMANAGED;
> +	struct amd_iommu *iommu;
> +
> +	iommu = rlookup_amd_iommu(dev);
> +	if (!iommu)
> +		return ERR_PTR(-ENODEV);

We should not need to derive this here.

Other than this part.

Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Thanks,
Suravee
