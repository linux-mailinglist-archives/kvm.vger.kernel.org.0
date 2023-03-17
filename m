Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D596BEDA9
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 17:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbjCQQFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 12:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbjCQQEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 12:04:55 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6267E10DE55;
        Fri, 17 Mar 2023 09:04:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8W62ZdaRbSIbuFg+2z/Ce3n5mAJu02qWfLY+2lVHlFlwVd424k/4FruXDVer6OilUqmN9+CO3CysRLi6o0M8XBKDf6FtuAZ9mVMYEMP8kjfWGAkz633bmlLIvseCTyZUt4qrUammxs6gnqhmgPWg+H4SgxnsmO4kcH7z/OZBExfgnbwQggmNkn8xPunLwYnNKu7bFSi24uT+rpGfIS0xB8F+kAnppMy+M9p/ouf6Tp5E8UcaXxtTv/+s2kvCrlqEFjy4Ob9iOlp+x5R7xhgY+fevrxhu3xHg/Z0TU5kJ4qYwGjNoj96Nv5xMzNT4U1O0Ld4Uj4cWIVwzh8dv0BIRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VMy3h3sdlock4qWRAGsHR1n5degwHKWnuD3orjubTKg=;
 b=L2c4qPrBiJiGmRuXyde/GSE7HveC4n2o+uPpXc+PAuWVSsqptw79MZCDufv1ZvR1EDFLAnmLiU1ez0O4c4Qv3ncPXLOIucLTShL7I9aSzYAHUJ0IpVjtxI9SeEXE3C5sIS5Q4CqX1zK4nmq7F3dTGi2Gx+z12//B0eRcY492nBimwzoU+A2r6ax1Egqsug9lWgJMNff0gt0ECWuJFVvD1BRN8VFPy2nboQtKTWsXX+zuMV2zkdAKibyHdIRvdOh2FRSyAtvackpq98tcUP0wKoGdiRAjb06UW8zxZr5HjtoO7P/wIqYQ48uB5q0St0S64tXUwz67VEllDOzOCCEvfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMy3h3sdlock4qWRAGsHR1n5degwHKWnuD3orjubTKg=;
 b=DOj/ZlsiTclkLJLbMc+Cj3hbGXBDUFkhYPF1/j9abttv0JiEhz6M9NaOQuNCC6+tQ7HSbA07k05rJvaBedeTLLWF+mtENHauO+n0gJI1ZcFnitKLACfMvAcPj5vIHqNzra0aziIn7xRRifdn1AdwiNrefhh5alVpz3a8fvRgkQs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB4123.namprd12.prod.outlook.com (2603:10b6:5:21f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 16:04:36 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60%5]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 16:04:36 +0000
Message-ID: <2261c530-ceef-18c9-ebb2-3355bab828c0@amd.com>
Date:   Fri, 17 Mar 2023 11:04:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v15 12/12] x86/smpboot: Allow parallel bringup for SEV-ES
Content-Language: en-US
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        tglx@linutronix.de, kim.phillips@amd.com, brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        seanjc@google.com, pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, gpiccoli@igalia.com,
        David Woodhouse <dwmw@amazon.co.uk>,
        Sabin Rapan <sabrapan@amazon.com>
References: <20230316222109.1940300-1-usama.arif@bytedance.com>
 <20230316222109.1940300-13-usama.arif@bytedance.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230316222109.1940300-13-usama.arif@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0098.namprd13.prod.outlook.com
 (2603:10b6:806:24::13) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DM6PR12MB4123:EE_
X-MS-Office365-Filtering-Correlation-Id: e81eee0b-dca0-4cbe-0252-08db27014e34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qtxRSxsGIiJol+s6pi0MdH87nDkOajyHtjSjVyySg6VWleU8KhWrUce6svT5iD3a9LQQEYTF5XBpKyBIecpnFFbwhINMdqyOgW8BNIM4lc7X/GuZuUFv5vKuGu8d5IhM+CuO8hE4OkIwo0zqkVi5VldyNSHMxSylTLs8PWhtPzvNRuSOXv/KC0IgMKqyIjf+AeX0xzxYC92SbCYm/k6P/dufl6UTZ+6rRH7EMk+vZB3Gy6B5KqKLRlm0L+kq/HYsHN1c0lClB1ET6JD0ZvNcJbdZOAyl/2zS/l5hKj/Ud+K/xmcttHyyPH/UoW5ZsndV5cCqkSbpzAlMWDT0E3DFwnKsuDhvdb9tkYLx6gX97mPYPVd8Zk5Ix+wdV9zl584JBSEKuYa8gJxggU9dOg6BglGCgSJS6fUdUpLqQf+Ify06cS8BXvUja7TaU7GAGqJM2Y6gpveBltwWQIcxXy16/XhxOetd4+TeCB2Vdq4NTNf6USK5QWk4pBWJQNtCZai3GNz9Fo3BaP3xNEdxXf87vVnj8yCcJ6HNrm4A3YG+It+CS2mYjYUU4PTlg5KFxhJSLQfynZ4qf77HNaz8IQEeVrOtyNBwwg+fslZ7xs93KrWX0vAHDcXkjDdPRcyoUXBDE0OlXuWW/kQS5zJ9tvu/lP/t6pWqKZVVLdByoAIJQyUAD/lawPu/0LoQ0yYQigCkBvc/9NhBk9BVDVVE+e2M52jdxgi1IiLcsV7wM3+mAlc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(396003)(136003)(346002)(39860400002)(451199018)(86362001)(38100700002)(31696002)(36756003)(2906002)(41300700001)(7416002)(8936002)(5660300002)(66476007)(66556008)(4326008)(6512007)(186003)(6506007)(2616005)(53546011)(26005)(83380400001)(316002)(54906003)(66946007)(8676002)(6486002)(6666004)(478600001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0c4b2hRNzR2UGVLTUhVcGJaRHFERlY2TUF4cml5SUNPbTBSQ2Nlbm1HOEIw?=
 =?utf-8?B?OFVmeU1WTjQrd1NzOEk5cEdmMUVaaW5zaWNuTGc5TTMzc0V0ZkRjc2dxOEF5?=
 =?utf-8?B?aVlQeHR0SDV3UnFjeUQ5bjlPUE1VRGhBL29NRlB6WHNqa1lXSWRLWXJ1aEFB?=
 =?utf-8?B?MFNFYnpmbWZlZDRqUXpwcFYvMnFTR1RXdnFRN1IyYWpKVVRyUHlxZUZLVW1K?=
 =?utf-8?B?U1Z4K1pGeEdESjl0d3ZpNG1SUG15RHZ3VXVRaEg1OW9wb2RraHJQSXFXV2Zh?=
 =?utf-8?B?ZVp2YUhNVVZwVUxJWVJlUjdieDNEdVZmVTVGRWxjdURiM0lKOUNzRyt5TkQv?=
 =?utf-8?B?Um9RV0FITVFxaWlmVm9qU1h0S0JWcGNnNDdFRXNBcitWTDFwekxnQXRzdWZ3?=
 =?utf-8?B?YWxDT1dZR1AyYWt5RnRuSWdaOXAraGMvQnI4bkZiNGJ5T1FuU3o0aXFXa000?=
 =?utf-8?B?a2s0eE5QbFVKZE1ZbVZ6MG5MSy9YR29qbS9VUklZYVdTTm1OY0pNQjRTN3Q1?=
 =?utf-8?B?TUVTeWNIdG9HQWdqU2h4V2NLV2VYN0hZQzQ2OXNtY2x6b2UybTlKYzlUaHBC?=
 =?utf-8?B?UVJ3TEZVS1h2aGdmYzYvMUtpU3RhZHVEK3FuU0p3QzNWblpEa0h5djRaWFJG?=
 =?utf-8?B?QmxYdkZhOWh4WHdCY0w4dXZjM05nWWJzRm5DL3hGTldYbEZVNE41QTNnM1lG?=
 =?utf-8?B?c09zbGFENzlGVGwzY2tmem1BZ2UrWlU3QzRLcjBFN09BcHprUGpqZmlaZERK?=
 =?utf-8?B?YzluWklyMVNqcHYrR2N1TS9QMFIzWHduSXR2RURKYm1Kays2TnJIM25LWTVO?=
 =?utf-8?B?UFhxLzkwemZERGxuVDlVU3puSitjc09YMUcrazJlSGhkSWN3alRBSkloSWtX?=
 =?utf-8?B?MmJadE8rSkcwNTZDOThnbzMyL3YyUWdkSUN6WXJEd0txVmxJK09kN0tudlFD?=
 =?utf-8?B?VFMvVENSVUFtK25FbWhWRGJEUHUxcUQvV0pIRDZrcEpkckdFbFZqZkVRTzVx?=
 =?utf-8?B?Y2Y2dXBpMzdRM2lOaGdOWFdzZVJzK1h5REhpUFRlbzRqMitzNzEyUlZVTS8r?=
 =?utf-8?B?eEc5UGwvRDdSZ3V4R3kwNDMvbmV4K3NvV0FXSWNCejFjYkVDc2Z1L2ZaYVZ5?=
 =?utf-8?B?K2puTUhPVGJkUXVGbitzT2Y5Tlc5Y2dzSS9mSzZPVGV0RzVEVTZ6cU5VQStn?=
 =?utf-8?B?dW10RHI5cUZUUTVJTkdzMXNycDJlem5oYkczdGh1SDVLSmQ2Yk15REtqOWQ3?=
 =?utf-8?B?WXRWNkxqbjVoTm9kZlJEMlpVNVAreUF2Q2dGdFVjc1JFM09uWHV6VnJLYlVi?=
 =?utf-8?B?a1MwK2VuTWNYaFpDK0Nkd3RlR3ZTMHc1ZGNSdHFMeGxwK3ZmeE9ITzJrWThV?=
 =?utf-8?B?NzVXOFRoOUlNa252amNUSGlzazgzRkZkNDN6RlJuRS9LdURGUDlLQ3VBZno2?=
 =?utf-8?B?dWVZVXpHOFA4Lzg5ZGRNdXpqbVcvdldIbTNuZHdRUStvWmkyN1lzREVuOG1h?=
 =?utf-8?B?SlVBOGsybWJXQ1JrcG9ieThTZElzczNhSWlLSXBVS1BoM3ExMzJxR2gzejI5?=
 =?utf-8?B?RnV0K0FrczBQakVFdXRIbldJOVU1VEFzSkMzNDcyREo5NzZvNUhRbkdOTUxi?=
 =?utf-8?B?bEdIdE5EYnZudlJIc2V4TzNOYkZXWHVybGlqMnpzV3UrOFprUys0ZFJHUlNy?=
 =?utf-8?B?ZGkwUGFrbG5mb1hFNTJXQTdySlgvTkIzTEtFYVliRElTRlhsVU4zNzdIdFBy?=
 =?utf-8?B?c3JiK0dmMzhjV05US29qZlZ5RWpVN3k4TlFidEVrcFlCZ2RkcVVnb0tYSE5w?=
 =?utf-8?B?M3JXN20zWFhWOHJvTDJIVUpmOGFLZkg4YTc4ckhBaXRlTFpTZklwdXdCZXpO?=
 =?utf-8?B?clR0NEFibVp4WTlBQ3BsU1h5V3lmOWVtWUhIeERNTnFVYjk3K2wvMEpMYis1?=
 =?utf-8?B?a2p1azZvcWU3cUp2ckFGZnVXK2FxbWRGWXFNRU5MbCtVNmdwRHl3clRMeWk1?=
 =?utf-8?B?N1JTd3pIRzRQWWhUN2duTkJFOUMzenpIejI2TEwvWlVHTzBuRkJWMDdzUjZr?=
 =?utf-8?B?R0FZaVFXQ2lpUDg1VWZpbFhDQ2lqUkRFTDRvM3FGcjlGNTh1VXBxZ0RDLzFQ?=
 =?utf-8?Q?1TFokZ3LYOLr4k/75BjsabCgV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e81eee0b-dca0-4cbe-0252-08db27014e34
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 16:04:36.5716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nqx93n0d1OtPNd+I1/URtRjn0gLFhrdibFnn0l3PPYcXZb2azWQmEU4+eKI/oCETEjU1PvHAR//L0E9kI52Dvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4123
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/23 17:21, Usama Arif wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Enable parallel bringup for SEV-ES guests. The APs can't actually
> execute the CPUID instruction directly during early startup, but they
> can make the GHCB call directly instead, just as the VC trap handler
> would do.
> 
> Thanks to Sabin for talking me through the way this works.
> 
> Suggested-by: Sabin Rapan <sabrapan@amazon.com>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/coco/core.c              |  5 ++++
>   arch/x86/include/asm/coco.h       |  1 +
>   arch/x86/include/asm/sev-common.h |  3 +++
>   arch/x86/include/asm/smp.h        |  5 +++-
>   arch/x86/kernel/head_64.S         | 30 ++++++++++++++++++++++++
>   arch/x86/kernel/smpboot.c         | 39 ++++++++++++++++++++++++++-----
>   6 files changed, 76 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> index 49b44f881484..0bab38efb15a 100644
> --- a/arch/x86/coco/core.c
> +++ b/arch/x86/coco/core.c
> @@ -129,6 +129,11 @@ u64 cc_mkdec(u64 val)
>   }
>   EXPORT_SYMBOL_GPL(cc_mkdec);
>   
> +enum cc_vendor cc_get_vendor(void)
> +{
> +	return vendor;
> +}
> +
>   __init void cc_set_vendor(enum cc_vendor v)
>   {
>   	vendor = v;
> diff --git a/arch/x86/include/asm/coco.h b/arch/x86/include/asm/coco.h
> index 3d98c3a60d34..0428d9712c96 100644
> --- a/arch/x86/include/asm/coco.h
> +++ b/arch/x86/include/asm/coco.h
> @@ -12,6 +12,7 @@ enum cc_vendor {
>   };
>   
>   void cc_set_vendor(enum cc_vendor v);
> +enum cc_vendor cc_get_vendor(void);
>   void cc_set_mask(u64 mask);
>   
>   #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index b8357d6ecd47..f25df4bd318e 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -70,6 +70,7 @@
>   	/* GHCBData[63:12] */				\
>   	(((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
>   
> +#ifndef __ASSEMBLY__
>   /*
>    * SNP Page State Change Operation
>    *
> @@ -160,6 +161,8 @@ struct snp_psc_desc {
>   
>   #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>   
> +#endif /* __ASSEMBLY__ */
> +
>   /*
>    * Error codes related to GHCB input that can be communicated back to the guest
>    * by setting the lower 32-bits of the GHCB SW_EXITINFO1 field to 2.
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index defe76ee9e64..1584f04a7007 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -204,7 +204,10 @@ extern unsigned int smpboot_control;
>   /* Control bits for startup_64 */
>   #define STARTUP_APICID_CPUID_0B	0x80000000
>   #define STARTUP_APICID_CPUID_01	0x40000000
> +#define STARTUP_APICID_SEV_ES	0x20000000
>   
> -#define STARTUP_PARALLEL_MASK (STARTUP_APICID_CPUID_01 | STARTUP_APICID_CPUID_0B)
> +#define STARTUP_PARALLEL_MASK (STARTUP_APICID_CPUID_01 | \
> +			       STARTUP_APICID_CPUID_0B | \
> +			       STARTUP_APICID_SEV_ES)
>   
>   #endif /* _ASM_X86_SMP_H */
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 65bca47d84a1..79a17e705f4e 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -26,6 +26,7 @@
>   #include <asm/nospec-branch.h>
>   #include <asm/fixmap.h>
>   #include <asm/smp.h>
> +#include <asm/sev-common.h>
>   
>   /*
>    * We are not able to switch in one step to the final KERNEL ADDRESS SPACE
> @@ -242,6 +243,7 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
>   	 *
>   	 * Bit 31	STARTUP_APICID_CPUID_0B flag (use CPUID 0x0b)
>   	 * Bit 30	STARTUP_APICID_CPUID_01 flag (use CPUID 0x01)
> +	 * Bit 29	STARTUP_APICID_SEV_ES flag (CPUID 0x0b via GHCB MSR)
>   	 * Bit 0-24	CPU# if STARTUP_APICID_CPUID_xx flags are not set
>   	 */
>   	movl	smpboot_control(%rip), %ecx
> @@ -249,6 +251,10 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
>   	jnz	.Luse_cpuid_0b
>   	testl	$STARTUP_APICID_CPUID_01, %ecx
>   	jnz	.Luse_cpuid_01
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +	testl	$STARTUP_APICID_SEV_ES, %ecx
> +	jnz	.Luse_sev_cpuid_0b
> +#endif
>   	andl	$0x0FFFFFFF, %ecx
>   	jmp	.Lsetup_cpu
>   
> @@ -259,6 +265,30 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
>   	shr	$24, %edx
>   	jmp	.Lsetup_AP
>   
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +.Luse_sev_cpuid_0b:
> +	/* Set the GHCB MSR to request CPUID 0xB_EDX */
> +	movl	$MSR_AMD64_SEV_ES_GHCB, %ecx
> +	movl	$(GHCB_CPUID_REQ_EDX << 30) | GHCB_MSR_CPUID_REQ, %eax
> +	movl	$0x0B, %edx
> +	wrmsr
> +
> +	/* Perform GHCB MSR protocol */
> +	rep; vmmcall		/* vmgexit */
> +
> +	/*
> +	 * Get the result. After the RDMSR:
> +	 *   EAX should be 0xc0000005
> +	 *   EDX should have the CPUID register value and since EDX
> +	 *   is the target register, no need to move the result.
> +	 */
> +	rdmsr
> +	andl	$GHCB_MSR_INFO_MASK, %eax
> +	cmpl	$GHCB_MSR_CPUID_RESP, %eax
> +	jne	1f
> +	jmp	.Lsetup_AP
> +#endif
> +
>   .Luse_cpuid_0b:
>   	mov	$0x0B, %eax
>   	xorl	%ecx, %ecx
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 0960fdec43c2..895395787afc 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -85,6 +85,7 @@
>   #include <asm/hw_irq.h>
>   #include <asm/stackprotector.h>
>   #include <asm/sev.h>
> +#include <asm/coco.h>
>   
>   /* representing HT siblings of each logical CPU */
>   DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_sibling_map);
> @@ -1513,15 +1514,36 @@ void __init smp_prepare_cpus_common(void)
>    * We can do 64-bit AP bringup in parallel if the CPU reports its APIC
>    * ID in CPUID (either leaf 0x0B if we need the full APIC ID in X2APIC
>    * mode, or leaf 0x01 if 8 bits are sufficient). Otherwise it's too
> - * hard. And not for SEV-ES guests because they can't use CPUID that
> - * early.
> + * hard.
>    */
>   static bool prepare_parallel_bringup(void)
>   {
> -	if (IS_ENABLED(CONFIG_X86_32) || cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
> +	bool has_sev_es = false;
> +
> +	if (IS_ENABLED(CONFIG_X86_32))
>   		return false;
>   
> -	if (x2apic_mode) {
> +	/*
> +	 * Encrypted guests other than SEV-ES (in the future) will need to
> +	 * implement an early way of finding the APIC ID, since they will
> +	 * presumably block direct CPUID too. Be kind to our future selves
> +	 * by warning here instead of just letting them break. Parallel
> +	 * startup doesn't have to be in the first round of enabling patches
> +	 * for any such technology.
> +	 */
> +	if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT)) {
> +		switch (cc_get_vendor()) {
> +		case CC_VENDOR_AMD:
> +			has_sev_es = true;
> +			break;
> +
> +		default:
> +			pr_info("Disabling parallel bringup due to guest state encryption\n");
> +			return false;
> +		}
> +	}
> +
> +	if (x2apic_mode || has_sev_es) {
>   		if (boot_cpu_data.cpuid_level < 0x0b)
>   			return false;
>   
> @@ -1530,8 +1552,13 @@ static bool prepare_parallel_bringup(void)
>   			return false;
>   		}
>   
> -		pr_debug("Using CPUID 0xb for parallel CPU startup\n");
> -		smpboot_control = STARTUP_APICID_CPUID_0B;
> +		if (has_sev_es) {
> +			pr_debug("Using SEV-ES CPUID 0xb for parallel CPU startup\n");
> +			smpboot_control = STARTUP_APICID_SEV_ES;
> +		} else {
> +			pr_debug("Using CPUID 0xb for parallel CPU startup\n");
> +			smpboot_control = STARTUP_APICID_CPUID_0B;
> +		}
>   	} else {
>   		/* Without X2APIC, what's in CPUID 0x01 should suffice. */
>   		if (boot_cpu_data.cpuid_level < 0x01)
