Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75A0740DB3
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 11:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbjF1JsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 05:48:23 -0400
Received: from mga03.intel.com ([134.134.136.65]:26972 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235792AbjF1JgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 05:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687944985; x=1719480985;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vbrvBG42qX1W9FVxLGl05dO1FXcwC7xjXmb2XUGzGZM=;
  b=Sk1CYDsiFOCUiMAO3MjDozaI8QwtZnUz0a8n8iHdp+ZFIkCGlAUT54E2
   iKlLeHeQkubKbhdAg0hxu/23hmIjGfzBqaDQsgrRZ+zgCsl83Da2ZpzQK
   QU2ugnm3rqooo75X5aXElC6P1FB+Dm16yuhQcNeiAKoz4Bz938eZ0/+vy
   bOsN2P434GljP5riufoOysd4sAnste5A7ZbDBF/5kmlsV7exykRuHMSfR
   nlPqG8kbWGGns7RAzNg0DJ0pSGCIs9HTZ6V0gYOwHNDnbeqCLuca92+S+
   lK+G/zGok2GdFaJjsknk2YGd0zdvcRzjVBaffIOif+MhGMNRldouiqvn6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="365255946"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="365255946"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 02:27:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="786985561"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="786985561"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 28 Jun 2023 02:27:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 02:27:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 02:27:46 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 02:27:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RrV3DDDVb24ECbmB0P6OUvlL5/2++Ve6sU3B1y34p1PJpeZWWw3dKU0sw8OrOLIu3x+v8EZ1jmIX4lWVEKkczoO+abR2emdXcRGLiXcSuEZKfMm7Mze0Uu/KERDZJNIEGpd05yPN7rgzH2g1qgirtsvV4cq4tFjZjQ3Xm3fAtveJCQ7N6Ydj9VbSujYZR/K0mwcIsbG6WOmf+Ihvg5w+baYzwpIa4V8h7lTOsuQNmrmnBLgDiDcpIECsioY3TFuqVAlatukZCGcQNfE42HtEtSdG14/yr5tJTfDUsY9eO+A1FR/O3oVn3U4Xr7PTbzAh28vvY2+C1u3Nx51oYUDx0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+o47zKiZx9t1x5/nKkzTe59s5PZk+btB4dEIkMEuoxU=;
 b=moENvGHIpGpNXT+32wwOpudI4yUnVdhx7s024dX/KyIvPyPue1JN7x+Lum7pKZYiu1GEP1pUkCqu+rhoGbPWXaFRNoNA1cuTHVYLTqKu4EusK1++of+uS4kO9hMfqfanselZtXHN5I04sNgMafY7vetQvuO8MYIAxeKhsYSFJCRczeXM9beYpNKhiteYx6mArwHKC9BlQjKf9TPYQuSOBbroOkT4cMKuKGoM/L5Tf5UAv4cBcd5qRZ6p+/MMhTEDJ0NRNbc7r4BKvYgyAy411EBJ7WmqeppcUvcr8LWPG7ZtCF5hTMwnZKlUgarNTmmJDcZkFO75//UN1AN34FqEXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH3PR11MB7275.namprd11.prod.outlook.com (2603:10b6:610:14c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 28 Jun
 2023 09:27:43 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6544.012; Wed, 28 Jun 2023
 09:27:43 +0000
Message-ID: <b4dac7d8-06d7-6d16-117d-5953cd37c34f@intel.com>
Date:   Wed, 28 Jun 2023 17:27:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 4/4] KVM: selftests: Add test case for guest and host LBR
 preemption
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230616113353.45202-1-xiong.y.zhang@intel.com>
 <20230616113353.45202-5-xiong.y.zhang@intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20230616113353.45202-5-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0032.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::19)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH3PR11MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: 724c813b-3f96-40f3-8f33-08db77b9ed17
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MLKHInjMxrlKWj27YrJfcXtaeiu5/atAxYhVOPRyfCO+4cjiPzH2U6x/dYcZIo3lcYk27l2yIt2E9Rx+B3T9B2rjeTVB7Ruks4val5LPKz2xOGypcpmj1GbJHif4SkL3C0WVyUBeoPbaofvTGd95Xa906EptunMxNmEvC30A9XwbcfzwGZftXAIygzgTG33h7bR1J4HN7si5B5Cjw98etCXLDkWsGxGSAgeX1Zj9nCnq0m1A9O69nEf6NlqJ0Lt9vDB8M0WsoSnr2lMvV2waGC/QwB1f8DbBp+BzzX572W/M40Dg+gcXpQPkRhyz0oiuR9BrOe6ymoQWYEEij/PihE5LzUCjjqduaBlXsaJNClLij+HyTras+f63z2ViIsmQ50yQ6Mvff/igmVbDGpNccHqWSkCCwLfGsO90niwwSWcvR8dCm1PVVyaxgu6gcKL5Q8sJYaNkibU6qJUo7VAVyGdXJ86QLFmr4EoIMNy9+ekF2Ymsxj6VHsRH0pjvPEIsIZx+R7ItJb399F9oUSF1wwaUx2+K3kMWDnii0kRC5eR27IltQnqKH3jnL9hgPNYFZqtPMuE1pGWUDg/xVDVLictP2aP++gDfxjj2sC2ZY+ppUMCQccFz84s3L3YIHVS6GifeK1+Wpb39a7jfEMcaHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199021)(31686004)(186003)(2906002)(5660300002)(66476007)(6862004)(26005)(82960400001)(6666004)(36756003)(6636002)(316002)(37006003)(54906003)(31696002)(6486002)(8676002)(86362001)(4326008)(478600001)(2616005)(38100700002)(66946007)(41300700001)(8936002)(66556008)(83380400001)(6512007)(6506007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWdqWGNvSnZEQlhkeXdtbjlNU0VpUHA0VnNOVm5saGRKUjVhMldKYWsvRHgr?=
 =?utf-8?B?NXJtS3g2SFRUTXd1UnJNeWxKSVdrRmkvbndNNHY3c1lja0U4dGtTSkhTOG82?=
 =?utf-8?B?NXNEd3o4SWlrK2ZxVVQzVGhGWjBhcWVvWVpIY3dOOFdTZDVJK1cwQVpOMHBq?=
 =?utf-8?B?aW5RRmlEMXMrZ0diQTBIMFJsemVtMUhnb2VycnFpeWNyblI3ZHgzeEVlVzA0?=
 =?utf-8?B?Z3lXRllPaEcxTURMSUNMbG53ZEhyWmJkUnVrK3FNa3FuRFZIeG5nbE1hci91?=
 =?utf-8?B?Z0s3eDBzTms2VzB4L1NXVGZYRW5KbWNGQzZRZDZNQ28wUlhHYUJMQ3U0L21U?=
 =?utf-8?B?RVJOY0pScFVDOUhyYTZMVkNYNEpoanU2b1pPYzd0a0xZKzBwd2dUZHdLa3dR?=
 =?utf-8?B?bWZ6UDk1Z3IzTE1mS3ZkdSt2dXhWdlpZbjZjTThrQ3VYbzBrUHhzN2hFRnRk?=
 =?utf-8?B?YXQvRGtOZ25maUpBODRSNlFQbW9VYmVLSS95VlA0M0E3RmYrdlkya011K2xG?=
 =?utf-8?B?MDA4a0hDOTFkN3B5L0ozMFVjanpzMkFwL0ljd1VNd0IwdDZGckV1b0UxdE1z?=
 =?utf-8?B?UEhZVXN6TitPWWE5Tm9KMzZqazVvdm5CZmRvL092UUtVcVNmSkJBRHMwY1NB?=
 =?utf-8?B?ZUxzVlRZaEU5S3BMT1czc3owZ3R4WXNXYXVscjRqUVdIaWhrT25ORlRUeUlz?=
 =?utf-8?B?N2ZJR0g3MDh5MzZ2UXlFTkQxN09wTWVueStFYlJWOUhmWmhMVmZ6S2pObUxQ?=
 =?utf-8?B?WGpUVEZPTFpnSzdOVlFpZGFRWTRyeDZJWngrckdBQmxiaDh4aldMMElWRnRI?=
 =?utf-8?B?Y240SmJUbDE4eCsvSzRabW5GMjBHWGg4TnFRK1ZxRnR4a05sUlNCQkVHeDVl?=
 =?utf-8?B?VjRZbU45UkYvaWM1MW84eGJHRkd0VFBxeWZhcHlsendnY0FJT1BTbDVxUnpS?=
 =?utf-8?B?Y1k2NWZtcENGL1pidzMvN3ZVLytYRVo4WEloQkZRTlFHRE5abkZlb1pvMWYr?=
 =?utf-8?B?bGQ5MTdRQlo1bmJWZGthVHhFWmJQQm9GT3pSTU83bFN3UXYxRGd3UFd6NEFI?=
 =?utf-8?B?cFdNM0ZJaTdLdEZGWHdxcXlSMis4ZlcxZU9XR3hZWFR2SGhhanpjQlBCcWV6?=
 =?utf-8?B?NjJQUnRTVmkxcEZwbU1EejltVkdyaC9vNm5jS1ZJTDFUbjFReGlIQjIwYjdz?=
 =?utf-8?B?ZW50d2NiK1VzbHpVQzRFcGVobWRzNFFiVktiakhoSzAvT3ZIcExlWGp5b0xR?=
 =?utf-8?B?ZmFLUDQ3VGcyeWNSeUs2aDVOK3VBdURnMDZsVWRVeDN3TGpSNTd0dDlRdFo3?=
 =?utf-8?B?QWFoTEJBcG5hMVhpVXRkWDNKZWdwSFVFMW9rTnV5L212Q3BBeWtXbVFCcjNu?=
 =?utf-8?B?NEpBeUFRUUwvRmVERFNmV0JuZ3htUG1LTzUvVW9WZmk3Qjk0YzJyTUNKN0I4?=
 =?utf-8?B?eHdTVUowN0xhNHJzZmZyS1dxdDBJTlhHbitVRUlUcVJBVHlkUG12ekYxZ1RR?=
 =?utf-8?B?NHN4U1AzYnhBNjkvY1BVUzZpNmdEQWFpdXc0Tkx1WWZsYVpobkR3cGdreWRk?=
 =?utf-8?B?NTRxdC92WHZ2VmsxYnNkcEplblQwdkhjY0tHY2lOR3ZWWFArMy9Mcmx4ZVNk?=
 =?utf-8?B?Wi9DRkFrYi9FYVBGSU5Ia0ZlYk1TZkU2azlFa0lWYk5IQmxCdWZkMVpvZUVV?=
 =?utf-8?B?TDNPRng1cUtDdmxXTTdMUWtyOHptS1Byb3Y0MTBZUGVOVEc4VnRKVkl6K09G?=
 =?utf-8?B?cmMxYS9seTVkQ2wreUJWQ0M1SGh4a0M3dHZhWDZNakMzajZTMDZicHdnb3gz?=
 =?utf-8?B?ajJWcFpMWWZFU3F6a0hUaUoyZXhzRVJNNjh0a1dmWmFmeHJEby9yMHora2NF?=
 =?utf-8?B?Y0RLbmZaQ3grY2dIeHAyQWFzbmt5RWJGOG1GMWFMZ3BvTHA3NnMwbkVFTDFx?=
 =?utf-8?B?L0FIYmgrOGRLZGNxQUgxREN4dFU4RTBlVEhTSHhZUFN3UGtLYzJscVFFaytk?=
 =?utf-8?B?eCt0SHRiUVJBNDZGcEVmV1MvVHh6dE9PSkYvSVJPT1pqcXYwNHlJZk9CbUt3?=
 =?utf-8?B?emJ1YWo4ZGRCNzU0Uy9lRkx6MVVXeDcySStKQUw4Um5neE53MlpOMDYvREpp?=
 =?utf-8?B?Y0Y5czRGbDFsWTVacE5qYnoxZi9RbHRZSUUxSTJhNEUwbE9DZ0RGTGliRFFy?=
 =?utf-8?B?OGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 724c813b-3f96-40f3-8f33-08db77b9ed17
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2023 09:27:43.7788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +83PL2T8lq+7WCC9apxa44an/pXb9i5dd9oW+e1sM1GjfZASvwUAMDCeLWGhjvBt4jYrscVf/tBkQDRkLkwPDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7275
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

What kind of issues you expect this selftest to find?

IMO, it verifies the generic perf schedule rules but cannot find 
specific issues.

e.g., whether the LBR data is corrupted in some cases. If the selftest 
can verify whether

guest/host data is maintained correctly in a high contention env., that 
can be better to

sever the purpose of selftest.


On 6/16/2023 7:33 PM, Xiong Zhang wrote:
> When guest access LBR msr at the first time, kvm will create a vLBR event,
> vLBR event joins perf scheduler and occupy physical LBR for guest usage.
> Once vLBR event is active and own LBR, guest could access LBR msr.
>
> But vLBR event is per process pinned event, perf has higher priority event:
> per cpu pinned LBR event, perf has lower priority events also: per cpu LBR
> event and per process LBR event.
> So if host doesn't have higher priority per cpu pinned LBR event, vLBR
> event could occupy physical LBR always. But once per cpu pinned LBR event
> is active, vLBR event couldn't be active anymore, then guest couldn't
> access LBR msr.
>
> This commit adds test case to cover guest and host lbr contend.
>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../selftests/kvm/include/ucall_common.h      |  17 ++
>   .../kvm/x86_64/pmu_event_filter_test.c        |  16 --
>   .../kvm/x86_64/vmx_pmu_lbr_contend.c          | 171 ++++++++++++++++++
>   4 files changed, 189 insertions(+), 16 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_pmu_lbr_contend.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 4761b768b773..422bbc16ba2a 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -100,6 +100,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_exception_with_invalid_guest_state
>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_msrs_test
>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_invalid_nested_guest_state
> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_lbr_contend
>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index 1a6aaef5ccae..c1bb0cacf390 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -35,6 +35,23 @@ void ucall(uint64_t cmd, int nargs, ...);
>   uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
>   void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
>   
> +/*
> + * Run the VM to the next GUEST_SYNC(value), and return the value passed
> + * to the sync. Any other exit from the guest is fatal.
> + */
> +static inline uint64_t run_vcpu_to_sync(struct kvm_vcpu *vcpu)
> +{
> +	struct ucall uc;
> +
> +	vcpu_run(vcpu);
> +	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> +	get_ucall(vcpu, &uc);
> +	TEST_ASSERT(uc.cmd == UCALL_SYNC,
> +		    "Received ucall other than UCALL_SYNC: %lu", uc.cmd);
> +
> +	return uc.args[1];
> +}
> +
>   /*
>    * Perform userspace call without any associated data.  This bare call avoids
>    * allocating a ucall struct, which can be useful if the atomic operations in
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index 40507ed9fe8a..8c68029cfb4b 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -177,22 +177,6 @@ static void amd_guest_code(void)
>   	}
>   }
>   
> -/*
> - * Run the VM to the next GUEST_SYNC(value), and return the value passed
> - * to the sync. Any other exit from the guest is fatal.
> - */
> -static uint64_t run_vcpu_to_sync(struct kvm_vcpu *vcpu)
> -{
> -	struct ucall uc;
> -
> -	vcpu_run(vcpu);
> -	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> -	get_ucall(vcpu, &uc);
> -	TEST_ASSERT(uc.cmd == UCALL_SYNC,
> -		    "Received ucall other than UCALL_SYNC: %lu", uc.cmd);
> -	return uc.args[1];
> -}
> -
>   static void run_vcpu_and_sync_pmc_results(struct kvm_vcpu *vcpu)
>   {
>   	uint64_t r;
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_lbr_contend.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_lbr_contend.c
> new file mode 100644
> index 000000000000..a6a793f08515
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_lbr_contend.c
> @@ -0,0 +1,171 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Test for host and guest LBR preemption
> + *
> + * Copyright (C) 2021 Intel Corporation
> + *
> + */
> +
> +#define _GNU_SOURCEGG
> +
> +#include <linux/perf_event.h>
> +#include <sys/syscall.h>
> +#include <sys/sysinfo.h>
> +#include <unistd.h>
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +
> +static void create_perf_events(int *fds, int cpu_num, bool pinned)
> +{
> +	struct perf_event_attr attr = {
> +		.type = PERF_TYPE_HARDWARE,
> +		.size = sizeof(attr),
> +		.config = PERF_COUNT_HW_CPU_CYCLES,
> +		.sample_type = PERF_SAMPLE_BRANCH_STACK,
> +		.sample_period = 1000,
> +		.pinned = pinned,
> +		.branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
> +				      PERF_SAMPLE_BRANCH_USER |
> +				      PERF_SAMPLE_BRANCH_KERNEL,
> +	};
> +	int i;
> +
> +	for (i = 0; i < cpu_num; i++) {
> +		fds[i] = syscall(__NR_perf_event_open, &attr, -1, i, -1, PERF_FLAG_FD_CLOEXEC);
> +		TEST_ASSERT(fds[i] != -1, "Failed to create lbr event on cpu%d", i);
> +	}
> +}
> +
> +static void release_perf_events(int *fds, int cpu_num)
> +{
> +	int i;
> +
> +	for (i = 0; i < cpu_num; i++)
> +		close(fds[i]);
> +}
> +
> +#define PERF_CAP_LBR_FMT_MASK  0x1F
> +
> +#define LBR_NOT_SUPPORTED  0xFFFE
> +#define LBR_MSR_WRITE_ERROR 0xFFFD
> +
> +#define LBR_MODE_CHECK_PASS 0x0
> +#define LBR_MSR_WRITE_SUCC  0x1
> +
> +static bool check_lbr_msr(void)
> +{
> +	uint64_t v, old_val;
> +
> +	old_val = rdmsr(MSR_LBR_TOS);
> +
> +	v  = old_val ^ 0x3UL;
> +
> +	wrmsr(MSR_LBR_TOS, v);
> +	if (rdmsr(MSR_LBR_TOS) != v)
> +		return false;
> +
> +	wrmsr(MSR_LBR_TOS, old_val);
> +	if (rdmsr(MSR_LBR_TOS) != old_val)
> +		return false;
> +
> +	return true;
> +}
> +
> +static void guest_code(void)
> +{
> +	uint64_t v;
> +
> +	v = rdmsr(MSR_IA32_PERF_CAPABILITIES);
> +	if ((v & PERF_CAP_LBR_FMT_MASK) == 0)
> +		GUEST_SYNC(LBR_NOT_SUPPORTED);
> +
> +	GUEST_SYNC(LBR_MODE_CHECK_PASS);
> +
> +	while (1) {
> +		if (!check_lbr_msr()) {
> +			GUEST_SYNC(LBR_MSR_WRITE_ERROR);
> +			continue;
> +		}
> +
> +		/* Enable LBR to avoid KVM recyling LBR. */
> +		 v = rdmsr(MSR_IA32_DEBUGCTLMSR);
> +		 v |= DEBUGCTLMSR_LBR;
> +		 wrmsr(MSR_IA32_DEBUGCTLMSR, v);
> +
> +		GUEST_SYNC(LBR_MSR_WRITE_SUCC);
> +	}
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int *fds, ncpus;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	uint64_t r;
> +
> +	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
> +	TEST_REQUIRE(host_cpu_is_intel);
> +	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION));
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +	r = run_vcpu_to_sync(vcpu);
> +	TEST_ASSERT(r == LBR_MODE_CHECK_PASS,
> +		    "LBR format in guest PERF_CAP msr isn't correct");
> +
> +	ncpus = get_nprocs();
> +	fds = malloc(sizeof(int) * ncpus);
> +	TEST_ASSERT(fds != NULL, "Failed to create fds for all cpus");
> +
> +	/* Create per cpu pinned LBR event, then it will own LBR. */
> +	create_perf_events(fds, ncpus, true);
> +
> +	/* Since LBR is owned by per cpu pinned LBR event, guest couldn't get it,
> +	 * so guest couldn't access LBR_TOS msr.
> +	 */
> +	r = run_vcpu_to_sync(vcpu);
> +	TEST_ASSERT(r == LBR_MSR_WRITE_ERROR,
> +		    "1. Unexpected successfully read/write guest LBR_TO msr");
> +
> +	release_perf_events(fds, ncpus);
> +
> +	/* Since per cpu pinned event is closed and LBR is free, guest could get it,
> +	 * so guest could access LBR_TOS msr.
> +	 */
> +	r = run_vcpu_to_sync(vcpu);
> +	TEST_ASSERT(r == LBR_MSR_WRITE_SUCC,
> +		    "2. Failed to read/write guest LBR_TO msr");
> +
> +	/* Create per cpu LBR event, its priority is lower than vLBR event, and it
> +	 *  couldn't get LBR back from vLBR
> +	 */
> +	create_perf_events(fds, ncpus, false);
> +
> +	/* LBR is still owned by guest, So guest could access LBR_TOS successfully. */
> +	r = run_vcpu_to_sync(vcpu);
> +	TEST_ASSERT(r == LBR_MSR_WRITE_SUCC,
> +		    "3. Failed read/write guest LBR_TO msr");
> +
> +	release_perf_events(fds, ncpus);
> +
> +	/* Create per cpu pinned LBR event, its priority is higher than vLBR event,
> +	 * so it will get LBR back from vLBR.
> +	 */
> +	create_perf_events(fds, ncpus, true);
> +
> +	/* LBR is preepmted by per cpu pinned LBR event, guest couldn't access
> +	 * LBR_TOS msr.
> +	 */
> +	r = run_vcpu_to_sync(vcpu);
> +	TEST_ASSERT(r == LBR_MSR_WRITE_ERROR,
> +		    "4. Unexpected successfully read/write guest LBR_TO msr");
> +
> +	release_perf_events(fds, ncpus);
> +
> +	kvm_vm_free(vm);
> +
> +	free(fds);
> +
> +	return 0;
> +}
