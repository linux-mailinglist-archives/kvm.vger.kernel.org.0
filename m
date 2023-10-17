Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D697CB969
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 05:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbjJQDsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 23:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbjJQDsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 23:48:35 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2050.outbound.protection.outlook.com [40.107.95.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D84C83
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 20:48:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qiklgj1cWTF9X8VNKSMSAwAnbRQQPavfPGrdkGipfx1Xo2Pjn5HGn9WfWpH/14ttwFkvf8Jg8wAibKfOZDLO/WLAgyI+Hf6fRuN8hKw4+NxQ+kGkn6dyWsyu0AbJ1mqfEo9RjGzG9fFCe4y2GfFWUiQVk8tq1WaIOE10+LJdza77r6vwbPqG9iazp993nBiSEFOHTwC0erKKzXOyMLgmHWPH9OJHZYmSPt9f7MN9UmOf/2tRi4TYLxODO0OqhIStzjq5yssLmIN9eN3glv59coUTz6Ciw7tPXQRgnnJ2IIloep/n9NyHvaeVCXSU62s+40UfHr1Is/MBlbDMHvxgOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9OvywPabUvuPH9/oseWq2v57kSp5kSTKt/awSo49xco=;
 b=ImeqkXFDcr2ypJS7d0485fqss9JxxoyOtxHHLg5mnSOdY9uPRw4+9ZpSph/kmxsfmfLx4VRJfMmmmohkRqCXYrFvV3BKvhTdLUENrVhoW8BKeNCfv5UTidLjP/HVgB8HES0rDML6UXzl5OeZIZa9Re0Oc2JTRMYIsii5dHlFxarzZ6M9gqlGPljsDqCZW8h1hjaartHdTkunR2FzJJHHzqz7WfKrtmjCyn+uKoYmICARau3X/dtY1+9p5dFfA7x2an9K53BSZqXwCBBRnzNLTAnFdn5FbMQwIbzcqr9SHElPhncZA3DdJeGvmPykDYOsbVNrZRkXrRgHh2k3zmUDfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OvywPabUvuPH9/oseWq2v57kSp5kSTKt/awSo49xco=;
 b=G+ontFmn8/JwfyvHIh3fw6IVFaP+073kTmo7Q4cmZpU1CxgkUgUNM1ElZ57JS9x7jFzDv/EQfQLIQlZr+bW35lk1DrxX8iA16HOLtofFifWLHUDaVJuk5mPT83G//GgNZgHmMVQpUHZmEZ1yV/mqNnWJLnd2XQfTD0dggDWCato=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 SA1PR12MB8117.namprd12.prod.outlook.com (2603:10b6:806:334::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Tue, 17 Oct
 2023 03:48:30 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::90d5:d841:f95d:d414]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::90d5:d841:f95d:d414%6]) with mapi id 15.20.6886.034; Tue, 17 Oct 2023
 03:48:30 +0000
Message-ID: <8a74396d-9b43-057b-fe88-3f58ec8eeea7@amd.com>
Date:   Tue, 17 Oct 2023 10:48:19 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 18/19] iommu/amd: Print access/dirty bits if supported
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
 <20230923012511.10379-19-joao.m.martins@oracle.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20230923012511.10379-19-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0206.apcprd04.prod.outlook.com
 (2603:1096:4:187::21) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|SA1PR12MB8117:EE_
X-MS-Office365-Filtering-Correlation-Id: d132b39d-ec79-4900-65d9-08dbcec3ed57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gFJXBOVYXQFvyGcJEuYeevF07N5mV3S52k4NFHBzNJzDqCi46eioMbb7hsNoz1pmRL5hGinTt5YgHBk5FvPkDnL8oRZ/EJiiuSLANivHpXX5HkQr0tDzVEH3cKIpINp5U+cDZQj4iSydGwyTS6EwMENwTBNdvAFFIg2TrOvkoa1sYlvAZI5z5RaS2qrGF1Aq1LMj3MfuVrVrFXyRz8iCoBNIBlwxZnxRdE2qL+lkXwHgVtVAJRIzAFXusSxtGFYXUwLZDzuOz37Qz9Q4WUqMYgelf08PYClTprLJej23IO2ghihBP2FYAq8S1k1UVAbhwER/7NyhD1CQ4KTjvqYuiE2J7aYl9FmPT9T9I+Nya0uwPFyFXaVvYD49sU8eDaZk4WwSnq9OkIAA7ag3WQBi3L8Uv13KKAB5N8jP/jUJ5SDYCYe94kmjk/l8T6l7CJic8lQp+YLYCXMUzubEO1oRkrq9SDE1mhzNpZ+tacJAzTfKpn4lPc9N5CPLy+DB5+dr35FIhlbwnaUobMGy21Zncx/rOeEPBzVoCHzDTBgw6us1vNGJRN1/14csmtzUzO9zmnNq/O+J5dTmrHAv8f3I83XM81IDxuqEL/enjp9n1UqofmoY3stOuZV2yJ1JUiSlr8IzC5a1BaAJ+2FnXS7WtlBYjOBWsGMQkHNOWn+57Jc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(376002)(366004)(136003)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(6486002)(66476007)(54906003)(316002)(31696002)(66946007)(2616005)(66556008)(6506007)(53546011)(478600001)(26005)(6666004)(2906002)(6512007)(8936002)(5660300002)(8676002)(4326008)(7416002)(4744005)(41300700001)(86362001)(36756003)(38100700002)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STM4ZlAwRktrUzIrVkxOTmZBYUdsRmdtMTN3NS9mZzhTaXdRRHpXejRMdnpP?=
 =?utf-8?B?YVJMUTZsaklYSXhJQVVrc0ZHVGIyVWxUdWdjeWpQQ040UUVRTFpCUHIyNEcv?=
 =?utf-8?B?MDdMeVBqK0dQVHZYMlpKZ3pObjdyU2NBZGJhMVNIQ2RTc2NjeGNhRWxTY0Va?=
 =?utf-8?B?YUo4VzZ6T1NCVG1HZHJaWnUzUDVqNGN1NVVBZWIwcUdvZjJvREVOZGtEdmky?=
 =?utf-8?B?eHhDSTU4NUY1MmtwUVpzNDBIMG8rS1YxYTI5RmpBTG9xdm0wRFVoenVqUUNx?=
 =?utf-8?B?NEVqb1dsNTB4T3hzR2hwOE4rZmpqa3JsaTNpWkluZlhnME9mNUVMOFVuUitw?=
 =?utf-8?B?YmRHV0dYZFc2SVhRMFkwSDM1NVZxQkx3L2NMSXZpbXhpZjBUU2hpclFQeTF5?=
 =?utf-8?B?ei9YWUlmbUs4d21wenIzVlhxdytDNW1hMkwralJBU2kzWG91YkFMY3lmTWJp?=
 =?utf-8?B?SHI1VFdtWFJCVWlOVVhMS1JiaU9XalZCQll5VFUzV0NZcHF2T3ZKcmxiajVL?=
 =?utf-8?B?WVFrQkJveHZ3MkU1Tm5DeElkZDBaTGY4cG1GK3B2eGwyc3VwK2MvbFRVR2dl?=
 =?utf-8?B?Z243U2ZkeHRMbUdsMXpxdWE3amUrbFd0b1V3MURLWXdLaTc5RlJ2Qy9FRE5N?=
 =?utf-8?B?VGVCa2dPbVB4Q0tRWmY4NFNMYmx4d2NHdkJ5NGxuUDZpM1RISHNVNEJ0N0tF?=
 =?utf-8?B?RnlDb0E5clFhbkNYQzU3bUlSb0toRWJOdXRGMXNPRGVEZndNSVNKUDFtNjcz?=
 =?utf-8?B?VUpDUHNEWENTaHl4R29kbUhjQWlkL0tnd0QzaUtidmM4VHRGR3JYWkh2ZzVI?=
 =?utf-8?B?anhpZjZPQm1HWUMrb25SMXgyWTBQQk5GK21ocUN3VU8zWER1aXpndFBCSUF1?=
 =?utf-8?B?M3hmNlZyR0FodVRhVnZzME9oMGdGTW1KbDI2SUVyNjVwZlRlWEt6QkwwMzNJ?=
 =?utf-8?B?c2ZMQ3U3YlV4a0lRYkhoMHpwWVdNZm94UzdzaFBxR2RFaENJT0paMGgvVndu?=
 =?utf-8?B?SFFZTzFrWko1RDhrL01UYkVHakFod1NDYlh2OHY3NGhzVjZXYVMwYW50OHRS?=
 =?utf-8?B?WEl3bXdPZXVpNkRzSEQ5OUlmc055d21XcEpnRnEyRmp2VDN5NVFhYVFQVTNM?=
 =?utf-8?B?aWJ4M0l4SmllUHZ1eVBvbmhVbURXMld2STgzc0h0VXUrRytmVUlUU2Jpekha?=
 =?utf-8?B?YmRDbjhScVZiVE96L2RJclIwZUprY2lNek16MlV1ZnRmcG1sUytIZUJsUGFi?=
 =?utf-8?B?ZHQ3OGlPTWxWaTJvWXZZSFN4TWFLSUxyU1VscnRodnJwWkViTmlyaXhIQlJ5?=
 =?utf-8?B?QkR1Y1EweFhYRVYrMnVNUkdzblFWdE1Nd3p4eXk3eUJuRXE2Q2Z1c3BKeW05?=
 =?utf-8?B?VmtYaTR6NnR5Q0pJeEFiZmd6a2lESW9TSElBRFlaZ0JXUmw0RUdEbGtyVHBV?=
 =?utf-8?B?Ni85NTRIMm5iUDEyWTJSNEdqYWVCNHlvTE90NDdBU0puRFJUK2VSZmRtYlJw?=
 =?utf-8?B?YmllSmlEN2cxd3B3YThqSW13amhVNldsb010Vy82YTg3Wm1LdE1YQ0dIU1di?=
 =?utf-8?B?NWFVUmJsMWZLVDRSdi9nbDJLR1RiYk9qMWFlOG03M0JjZCtqZHlpOFUrMFZk?=
 =?utf-8?B?bFo1SngwaXQ5SkdZdlVpcitsWjFkQWRqdTV4L2YrRFh4TFJrQ3Y1K3UxWldr?=
 =?utf-8?B?aGJXby9tMjk4WVNKdmExL2tza0YwVTUxdE1ocUlHeXlEUmV1V2ZlVGdOeTVt?=
 =?utf-8?B?a1dibUtFb0xCeTdPeVQ0OURCVEdtMzIxMjhWQ25hZFhvZTRRTVFsd3YvSEZM?=
 =?utf-8?B?RXY5OGRteHRsc29jQlVsTG92elJFbFBmM29YLzRxdUc2eG0yZVE0T2FWamFy?=
 =?utf-8?B?K0VJZldZTHprU0c0ekY0QXo4YVYvRXhvK0VmWjFSVGVCWEhjRG4rK2RiSjBX?=
 =?utf-8?B?SitBelluNHRndmIxZFdvdWpEa2U5Yjc1UW5qZmVhNVNXeXRMOFVzRGUrcHZm?=
 =?utf-8?B?bVQ4NGQwMFlBcUxvSnhzQ0NaQ2c5eUtBcXhNcVcxcVBCcFZaSHJIdFlBZ0RH?=
 =?utf-8?B?K1c3ZEtUQnJMUGNvbjNiMlNUcWcwNmF5bUdOZExxOWxqVDhrTm4yT3Nod2RY?=
 =?utf-8?Q?BiOjvc5zpHJWFwDaXrSwvoyS9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d132b39d-ec79-4900-65d9-08dbcec3ed57
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 03:48:30.2264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5t6TDH36JxfjasGpbYemDGRsvjhwTEyNQUpcSbV0glAv4kjfbLEY27ayKznIYzcA4Hu8SSGbBVTdEjg9PMQ6Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8117
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/23/2023 8:25 AM, Joao Martins wrote:
> Print the feature, much like other kernel-supported features.
> 
> One can still probe its actual hw support via sysfs, regardless
> of what the kernel does.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>   drivers/iommu/amd/init.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index 45efb7e5d725..b091a3d10819 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -2208,6 +2208,10 @@ static void print_iommu_info(void)
>   
>   			if (iommu->features & FEATURE_GAM_VAPIC)
>   				pr_cont(" GA_vAPIC");
> +			if (iommu->features & FEATURE_HASUP)
> +				pr_cont(" HASup");
> +			if (iommu->features & FEATURE_HDSUP)
> +				pr_cont(" HDSup");
>   
>   			if (iommu->features & FEATURE_SNP)
>   				pr_cont(" SNP");

Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Thanks,
Suravee
