Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005EE50A319
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 16:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389380AbiDUOuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 10:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389024AbiDUOuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 10:50:15 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1D02253A
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 07:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650552446; x=1682088446;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G5dmVB/FjzLMcuQKVvsBeNS8nK4DbM6r8xlxKw6syzU=;
  b=CAOVKzm0A1ruVVWAnlZBmSXT6A04XfKSxzSvkdov+NRHL4vqcw/dNWEJ
   9VqHU9Pz2Oxyk8cQtKsRmB1ViphtE/An3zx7dern+W/yC7UEeHVLiw1QD
   bJWJ+ecA+JRulHBQSwnoeQpLTZV3378kAvzC87vrkz15bCvLmqIacPUV/
   fakH/WHBdUGd69Bw9p5CcuMgIknivEWT+IRWBw9M7jE7kClDkIPRuIKW7
   n4wXWQJiJCIDUP6StaruS3QqLP9tWWkdIT0EHqs9rn3hDw2u1tXskRwWI
   pURo/RdFPoPexP05gATizlN9/xDJUfdmebzCUuFl3FOYanmoN+q+Ia981
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="261967708"
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="261967708"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 07:47:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="555804198"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 21 Apr 2022 07:47:12 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 21 Apr 2022 07:47:12 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 21 Apr 2022 07:47:12 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Apr 2022 07:47:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KbU0IdX5GjYhad9FfB4pRPtM2u4NknEvOyu2RgR+aCzmcqW/Xwgy8IuHVKcePeb8HWDGsLd+0/KAzgM5OgJITzvqTZRlNIvYKIAdD+6FRm7Yd2MdpAXlRPNLxX28HIFKLOgJnjMN9Am5NPMgK76Q8cPSrPXAhSssNq8AAQ9tJrnI2RL137GUbEB/Nm+jcgtzK6u5zhSD+0Qp10I+GKfIk0orMXLlV8RI8UssF/X0amRPauC4XAYKDwUYOtQBR35LBUySb4dLC20WnGOLOvYluDRfIDutODtKZsyLHArgTaPH0fclSzi7k637fHIYuoObyFyGaLmzR/UbOCylxG0hqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jfjbcc5UpclH1t0jo1Y6mvbcVLvx8B7DhbP11Y1HGu4=;
 b=ef2ugRr1PV38zVR2aqLncJOcPSK0v3nE+3dZU8qwO73nEUY+Ii5UYmhIzHKWWXLN70lmKRaXtYxcdhoG6OgO0XyOZRJZaBqrDt88aqDTbBSrceuJkjnX4LGrMBO/f7ttqf7CwaJXjGyhwi9VnOp8rGjG9EiIYMxU5qFJatdnknct+sz+gLq81ogpFezqnPgJS25pT9/0C41Ioq2TzqAIJ8BZV7OOOq8vv97VwNCbZwu27aAJC9qmg8l4R0QNhyxqNRGr/SestLiVKDXMPX3iXvsnFAHuz1qbH8kLpQc88DkyCHSm5KiLwNHvYj3kccZFJs8Rajapanor4Slw7H/kBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH0PR11MB4997.namprd11.prod.outlook.com (2603:10b6:510:31::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 14:47:08 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024%7]) with mapi id 15.20.5186.015; Thu, 21 Apr 2022
 14:47:08 +0000
Message-ID: <e43bd279-ebb0-5e46-dc0a-9e735d53320d@intel.com>
Date:   Thu, 21 Apr 2022 22:46:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v2 2/8] kvm/vfio: Store the struct file in the
 kvm_vfio_group
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Kevin Tian" <kevin.tian@intel.com>
References: <2-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <2-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR04CA0087.apcprd04.prod.outlook.com
 (2603:1096:202:15::31) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d16b5d15-06b8-4cec-f7aa-08da23a5cf8b
X-MS-TrafficTypeDiagnostic: PH0PR11MB4997:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB499728CE4042DABA300E2A3EC3F49@PH0PR11MB4997.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yjDKYI/2DW5UTyyhxtIvtAkvebvR1F4TMMAFP6GfBJbZDwDxJiKdhzqTEa7pl9aDmcvHAFmOP8Y+WUtLpehq+YC0YhJVs3IZ58UXt1KVta6Agrhp4h4AiaTkjb3PXR3HZGwM6oIbJVte0/lemd5yzVbgmIkhsUOXkcuCQiE3AoQT4p0mXG2vxKfZKf7+dhO8IAk7oBaTeknkhGy7KdaXiAgorHyNJDEXu7ua7H/vGVD+a18ahIH7emRWVQJUqFJ46RJTqco2TQ/R5fL58dFnLx0GyvjMCZ+ZiFG2V44hTvLhR/zhk6h+vg5xRH5BQbX4Vb1vCRZoKcB/SPCWR+y363qZZAK1drbYffYUKI3cgb1tQNjYevAbCHgI8fve0LmL+khMdOEDo/ha1dpjCd9aIulH3IKyH8HG++hp47XMttlw+IieQrPctURA6XqjPuB6kdPDJkL3gUM/IZRHt7i+j8npJOzwKelMjYJnJVe46P9+FKasWek9KsX3vJc/IzQdc0jCeJ0V4+lL2PS6dRu9t7BrJ1oFdBn7c5KYTJlM3cXQBuX1EVax9hhgVG/IB8TnAd8PDEeMCgP5qyEGU80YBYZV6tacHD5Mw6GXh+N4y8LiLDEMoNL5YNfSYwxKA1NGQvrziGifaQptvLwv/0cHgQPQsCEevx0pMEfzSxqX1gJbiBanb/fo3ZmVhUpCrnknZ1Qv4H92jd4RlnKmmwX2k/TXkUtsND8zBvkhzCZ09cYxB8P7F3/dhyLyLHoNZtdt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(53546011)(6512007)(26005)(38100700002)(6486002)(4744005)(5660300002)(8936002)(6666004)(2906002)(82960400001)(83380400001)(107886003)(86362001)(508600001)(2616005)(186003)(31696002)(31686004)(110136005)(316002)(66946007)(54906003)(36756003)(66476007)(66556008)(4326008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmlYL0FmdVovdGVZZHRsYjg4VEJPdTlKYTJjM1pkN2tOVnFyRTFlTGxRemlS?=
 =?utf-8?B?cjdrbUdIYUhRa3RiVjFrSStuY01JWWxBdHFHR2FMSFFnSUg0YWZtbUhzN2F4?=
 =?utf-8?B?SGJ5Ui9ieXhXdmNlQm5FQUR3VnE0aFE4VTFCTDBJSnhNdjlxMERxNTZmL1gy?=
 =?utf-8?B?ak9hYTdMRERJbXljbUxtSFQzdkM3NTRET2tBdHZTRzlUWGtiYmwvc0xyS0gz?=
 =?utf-8?B?ZnFTNzZoZGZlRlNGY21Pa2RSOHRPeW0rS1hKWHIxN3FKYlh3aE95emVWWEhv?=
 =?utf-8?B?RktVWmNVaSt4VXRjd1h6d0k2QXF2WTl5YWVRenUvKzRjQzNVUnBBSmd0YVY5?=
 =?utf-8?B?R3hTbHhDTmtUUTZLdnpST2tlbkhpRWNIVkhEKzgvcENjRTFQMHJ3c09CemRW?=
 =?utf-8?B?OW5QdU84TlhJWDBkTUQrWklPSENzZ1RDOXh2bE5xZ0ZmYTZpcEhLSEU5aTZJ?=
 =?utf-8?B?OW8yNE9INUpSY1Z3Mlh4Q1JqMTlZOFJ2cktKQjc5YTgwUnpLeCs0OTI3Sndo?=
 =?utf-8?B?c0NqVWRWWXdkUHc4VExoMmM3YVV3UjludDE4WkQyQktVajVHV0FSM3VFdXlH?=
 =?utf-8?B?OG5Zdk1waGpxRUdyVEhESkxkakFla0pWOGZlWFlOWGJwWk8wUTVvVUIwOStp?=
 =?utf-8?B?ZkFiZExQc3A3SDgwOGZlT05ib2prbnVabWRGTUJDcytYZTVTaHZ5OEhUSXZa?=
 =?utf-8?B?U2V5eG5YSUZGTmJpb0pvNWpNNlpVR25xd0lGQmhHN1EwYUpDWU9PcGtJSWMw?=
 =?utf-8?B?Vks2N1pkdFdrVHNaYjEycjNTYWJrMWFOa3NSVmJONWFDQ2ZwLzNrbmdVQm5V?=
 =?utf-8?B?MWtyQVZFajNsN0UvUjZUd0M1YmxCNFdKdVd1aFFMaEtxR2d4elZZV3VtTFVX?=
 =?utf-8?B?blJJdllubi9VTkNRTjR3U2RveGxhNkp1REthY0hrMnFIZWRoT3ZyY1BkcUcr?=
 =?utf-8?B?UUx3Y3JNUFhNYnpHWnI5RDNVY1RrRmNTT0VvNDZBaU8wV0ZPa1prcjFjWGpT?=
 =?utf-8?B?dndjbTJ2ZzVBbW1JdjYxdU5JbDFQWUtmWTZwOGF5QnJsUHpmQTI1ODRUSlFJ?=
 =?utf-8?B?bGRuRElmM1RPUHpnQnIwV1hyNUFVc2U4MXFpV3NjUzJhUkVzL1BJM096RUhW?=
 =?utf-8?B?ZWVjdzNQTEFKRDdtV0h5RFZEZHhBbGVRTkNtbWM3T0ZWdVpqT1J4YTVncEJs?=
 =?utf-8?B?bjRIZmV6YVFDQU5LMUV1MTlZTVo5TldlK29sWEJRM2EvcS9zTmdCcXpxSTh0?=
 =?utf-8?B?Q2o5dUtocXpnSFlySWV3SFZzVDNxdHZJSnNiRE41LzZyRm5GcXcyZTFpM1Zy?=
 =?utf-8?B?d1FhcXdnOHE3T3JTNWJXMmI1MVhUTjJmSUUrSGJ1V3o3TzRHVjVVQTlJNGRB?=
 =?utf-8?B?Y3YzaktsSlk5cUZHOWw5UThPdm5kMVhPZ0FuVmFMNE9WLzNOWHBrcW9FVkVm?=
 =?utf-8?B?ZUNLNEtlVTFnSm5GNHd1T3VjQ2Q5dzhHRlRnUzR4VXkwR1FxSnU4K1RLZy9F?=
 =?utf-8?B?MndCR21MNHdTVXNzckJ5aGc3L1R2U08xQldXTnBpS0tYdVNpYmdUY0Z6MTFP?=
 =?utf-8?B?Q0Q1YWVTSkhnUkxrZmg0d3BnakgvRWVEYysxaWlFNnBZZm5BRnZaOUwrQ2NM?=
 =?utf-8?B?WjZEYmtjR3ZSMkx0cytjZitBZm5oRkJHWEVPU2QzMldaMENZRjdtdnUrbEFX?=
 =?utf-8?B?cGJvaVRIL2RqYXloSmNDMHEzUlZWUU50VWJoU2Vhd2tRZEExVDFBVk5OSUpk?=
 =?utf-8?B?NFVQLzNCVVMzQ2dOYUVSTUFhTHltKzRBUUNCUkdFWGlCSkJ2b2NPOW9iZmlL?=
 =?utf-8?B?c1UzNnFBYTBxbFJzK3YrNzFpRUNwaEhOemN6YUp5cFNzbTREMHA3N1hhc1M3?=
 =?utf-8?B?SnJ3bW5UOGliWXRaZWhKN2IrRUNRQTMveXpkWmo5bGRMUGQ4SEVCbE9mODRm?=
 =?utf-8?B?MnlGSlJ0eklsZ0lsQU5FbzVaWkRNNWlIQ3oxM2NrZXVpWklMdCs5Y0ZzWnVp?=
 =?utf-8?B?SSs1NWwrWFkzMG01V0oweGNtM3BieUM5MEV5bUFZMS9IK3MrdWptUGJhRm1j?=
 =?utf-8?B?QVYyV2svaytWMUVodHNWaWt6VzdseVVuZTdjQUNkUWdoeFo0cGRhVUxYUGlT?=
 =?utf-8?B?alZkeXIvT0tXM1hPck0zQlhXOHBPQW5WZlc2WW9STDh5dFN3dWlPcnRQOFFl?=
 =?utf-8?B?SHZmbnhsN3k4UW9kL29heHhiRVl0aUprWDQ1VDF6NjY4UG1HMUNMTE1mMm1j?=
 =?utf-8?B?VGlnMGhxSC9jVC9DendaZUR4WTFUL3dBOVFueW53Szh5RjJxbC9DUnBvNnJ4?=
 =?utf-8?B?SGVhQnJiMnZoOThXa0ZNN3FpTWFDa2I4QUxyR25tWGpEZzVXbTZ4alBLbjVy?=
 =?utf-8?Q?2KYyzvCoijf5FFsU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d16b5d15-06b8-4cec-f7aa-08da23a5cf8b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 14:47:08.7634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hdPMmKpVbuvEsrwPcuWP0Yn7Cu/U8fJwcFBHBFZ47XIAtMp5srsiUEkW+9ycJ7LE1YTBxF8ywwi476p1NvEv3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4997
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/4/21 03:23, Jason Gunthorpe wrote:
> Following patches will change the APIs to use the struct file as the handle
> instead of the vfio_group, so hang on to a reference to it with the same
> duration of as the vfio_group.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   virt/kvm/vfio.c | 59 ++++++++++++++++++++++++-------------------------
>   1 file changed, 29 insertions(+), 30 deletions(-)


Reviewed-by: Yi Liu <yi.l.liu@intel.com>


-- 
Regards,
Yi Liu
