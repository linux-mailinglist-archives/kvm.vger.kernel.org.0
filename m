Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D84680E96
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 14:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbjA3NNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 08:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbjA3NN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 08:13:29 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6919811678;
        Mon, 30 Jan 2023 05:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675084408; x=1706620408;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eBDuGA2mKlS0PCvCzpe2VHb6OTp7cwa0RMXaKMlg+hg=;
  b=eY/idUU7gLfj6w6/xMgs/qgK7FSg/aaufVZQDPullW5D0z3a0nRAlqsS
   X5kvZS0lm0DbSUYlBkMSQjN7YQOVhICHoiS1e5/netJZ8dwC7h9dftAf4
   UvB4BskMSa0v050TOBQmDC8MWx5CKBZP79G/xoi4h7PCkAL15qzXYcsHn
   AaAaf60N/HkHszlCzRjhmusDGXj7qatPsc1rm3NU9BkEU99fb/+/b/yqa
   JHnIZ9x4CpsCjvP9KBAzPr/1hMyjNOmVqKgtrDmwXfGwEoSw/j88pSGsl
   e/tPFW6EpqntBqW9Gj0gXZD0+FnV6fGlLiHDj6LVtzZ16x78zfJujY+iZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="311171984"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="311171984"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 05:13:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="666067314"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="666067314"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jan 2023 05:13:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 05:13:27 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 05:13:27 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 05:13:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hz7/QrgYQFG3H7EZ73zsqCwXOzmqyYJAomhx9lw1RhmEgVNXDXe8SPGupq7DmuGZfmUK1vesM0yNBBcwCib5nOO9WuPoYRN9D/aFg6mKwr3wmxA3wRBDJ5Zxh+gZHZj9NeaCJ8Kv3GRX6gGenMFokp2C6sqE48Dl4e+p3RtrsSwcBiu/koWRmP+TTaim4lYghzNdzhXaqQRO09JZEPH+ddSIdFCMtjfrTjJszKKImUzlooypEjXl5MBjNEhnpjD+VGP9AK4Mh6w2NIH+qV9rFmR8O2CH+8UJTIR9TjvUypNmvAzaidWxUpzzunZvdyImZxwu7IQD4ux+1ul7LM2djQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d16pu9LH3kerUmcbVYeryN+xSkM34IsJXvQa3Efsprg=;
 b=fDeuqQKLMLFFdpcLsmcJwJf/WmSiaNptd4Z5a/ih/6BeyTuCvzSg1MUaBCEcxP4S4z4QSQK82DS+3DsxxxICZ88bMjUt8Q3XHyz9kooqFieDqJ/H5iamMtChasaCnbd1wnu508UMDe+Ygi276I+3qwX7OpHLDp9Invrxdn7LDOUxj5CYde9D8ux7l0qalYrRskMB7+h2F9DbeHpaVPxBqcnEgoLZsebj8FZ0yCKEQUHfxt19b3JVx852cJhvcDI4lc6aXdo39bddWwn319zRYeiIv8UqpwzQB2BL/kH1Ok/urwpGR2HNQ7VRdMuNhIUZ4TGNVVuDPPmzov8685W4Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB6142.namprd11.prod.outlook.com (2603:10b6:8:b2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 13:13:24 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf%2]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 13:13:23 +0000
Message-ID: <d4f2471a-b6ab-9e5b-8419-a35209d78125@intel.com>
Date:   Mon, 30 Jan 2023 21:13:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 11/15] KVM: x86: Add XSAVE Support for Architectural
 LBR
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <like.xu.linux@gmail.com>, <kan.liang@linux.intel.com>,
        <wei.w.wang@intel.com>, Like Xu <like.xu@linux.intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-12-weijiang.yang@intel.com>
 <Y9RLJsEGjXQ0IAlX@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <Y9RLJsEGjXQ0IAlX@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:3:17::22) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB6142:EE_
X-MS-Office365-Filtering-Correlation-Id: 41f9bed2-ed59-40ba-80e0-08db02c3c3a3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p5DeiG6OIPEPj1hwgNt9wRwuF7XDCH7/OOr8uoa90bVmvEVsaJ+lqM/PemTsZYeEID6rwNHM91GgVM7tlOhTUzTPF+WYePXijRZfllK5HKv1GNoFMkLui9B2QRH/c9Pb80yqqSG7hqxLm+zi2HBum4D4ppMvGCI8u7GbY4DvZqI61wUFDC36IkajhK/FXBbPUouSYRopZMa6NFEPBpn/TGBakbxkGmbySDGRxOQ4qLpkn/moihxoQVdTa4k6tN5VZ9HUNPZmoXyLLS4fzFIRxbGyc2Y9jH9cgQup8YeQYus+9hcf3jQLhEjghRDGZF3Y+3jZgpDGVGRHaOBJr+h94YdhQGM9s+XH5UbSAjDXI1NgOa87Gc28HBkq1xdO3/jw65oQrTizSiQpdVMckYrYdVGuu+CuUHxAif3T4oG6S9np1te2gJDYOPLknconmN0TGymHHzLgkOwVMou4hSTnbiK84bXF3PrFMOOAE8sasLkXJkN9cYtvjI8Bni/yXB2rEFoqJMHYXaX1OrPmk2IhyHKZgRax2xHiDXGPIVtsaEP17Mwz0HnE5H1ZTyEBxCCAKBknVnxbaqQ1kvYzAWYTmnRyUXVTMiY0NbUAOjbHYhlhPHYUMZdh72xFv6xrjJqcGg397VqOg4YbYOMRg4EZ2RjuedZ4xaItd2LRme2L2j+xrSjZ9bGJTpWSRwXZFGgVhBx4y3t4Hmk2e7mwOqsKy/oHtbhp5Nj4Skop4lhN1fI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(366004)(396003)(346002)(39860400002)(451199018)(83380400001)(86362001)(2616005)(31696002)(38100700002)(82960400001)(2906002)(36756003)(53546011)(6506007)(6512007)(26005)(186003)(478600001)(6486002)(6666004)(8676002)(6916009)(8936002)(66476007)(41300700001)(4326008)(31686004)(66556008)(5660300002)(66946007)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWpibjdPejduaHhBOWpCWVoyLzQvdjE2bDJBcXJrL1FUdzY2Y0djWXY2N094?=
 =?utf-8?B?YUgrL0JQbkNhYTRDSVJpTGtLMFo4UzVMK1kwa1Z0QWtwaVZDaGUrWkVvTTZU?=
 =?utf-8?B?b29CY3k4NzIweldmSUd3cW5PSW4rWFFEOG9LZUpUQkxBN0hDNHloTlRHc25s?=
 =?utf-8?B?em5pc3d5Z1Q1SkU0bklFV3FOM1VXMm1zWEg3aGFjd0lKR24wcXNIWXNON0Jk?=
 =?utf-8?B?S1NWZ1JtK2tIUEVyWFhmMzN3R2J4VkR1OGRKSUg2cjlzQVVRV3pGbDNaUlpX?=
 =?utf-8?B?ZitrVEtoNW1LaFlsS2w4S1ptRFpwL0RPZFQ3TVk4WEZzNU1GODRRaVdhdy9X?=
 =?utf-8?B?dzRhUERBUTVxaFNsSWV6Qkp4RmJSbFp2a25aN3JMTXArWEdrbXJObitCekFP?=
 =?utf-8?B?c3o0US9hYXgyWnA3bEVKeUVQWnN3WVc0UVRZS1VDV0dzcXVCaFgrbm9LWUxF?=
 =?utf-8?B?L3BtT05QZG55UVJIejF6dEhjTTBrdE9CUzJ1UTduSVY0NG1KOFpuL1BQeGx6?=
 =?utf-8?B?a1greTJtS2svOFEwTEw5K0pwa2RvajZjS1hpNGp1Q29kQWxFOXRmRXVmaHY3?=
 =?utf-8?B?VmFpTnRIemdzMjN1U0R0R3RsNkhud0NVaktMWWs0NGFQZ3hKZUh2MWxmdGoz?=
 =?utf-8?B?TXA1ZW5xWUE1M3V2emtlZWQ2K002M2I2WkhXMzQ3b0FhcmN1Unk0eTAxNVFY?=
 =?utf-8?B?bVFwTkM0dytEc2NHMkdoSFp6WWVGelJjNHdXMUoxNmlJQlY5eHZZc0hEN0p4?=
 =?utf-8?B?WjM4Ykd6MGtHc3pLTFdad1loSE04WG5sR0kxSEhxb29CT1V6bmhQNmJLODRT?=
 =?utf-8?B?T01EcGxKWDIyRUJjamNCNGk4OUl2aXJaSTc4YlIwL3dsOXFUR21zeXAyWWRG?=
 =?utf-8?B?QS9NZTAyRWszK29SV0lQVnRMcHZiNWZqSWhjR1RPTzlNRk5RdFovM2UzQjNu?=
 =?utf-8?B?eFQyRlZoSnk1REpyZHpaa1Y1dTFhZ3BvdHFRQlp6cS9KM1Z1VjN0Tkg2Mk9n?=
 =?utf-8?B?RFNpRGZDTXB4aUpZN2crSERVc0U5OG5sUlJCblQzcXZFQnFRZHdmTzZyOTdW?=
 =?utf-8?B?WlkwRktsVmNqRzRXSndGQk8yWnpSZkoycEtjOGhGYUoweFB6alhvQ29TaXJp?=
 =?utf-8?B?WW9MQXFjdGFnaVJySjd1NVVreG5iaGdpUTR3UEdiMk1Cb3lzYURVVElPenh2?=
 =?utf-8?B?RmZtZTJYOVRwN3lRRmZwN1JjY3BhNFg2SSs2ekw4Tmt4NHFteUFxRGNYYWUr?=
 =?utf-8?B?eCtQWjVCeGZyU0hHV0RrVFJRTVRHV0tpZE93RkRRUzVRMDFYbDE2UVFpM01s?=
 =?utf-8?B?T3p6MEZIUDZNQVVRMFhnaGJIbk1KV2o0d3owaFc3VkM3cFl3QjhJL0svN1lu?=
 =?utf-8?B?a1hFM05oY0RRY3RYZlI3YUJJcDgvcDRYQjRYdVRYQmxCOERENk10ZWVOc2Nr?=
 =?utf-8?B?cW1kZnd3N1ZGM2RxR0IzQ1hScEJWbW4zTWpWcFNVQUZXc0xXQTBYeFlMaGZv?=
 =?utf-8?B?amp1am1FREVtSXpWRVBoamVMY01TZllDK2lBWVRnenhIVk5CdlptZmIra2Jy?=
 =?utf-8?B?cytvV21oYjNmRXV0YUhnNk5JSGRkUDFSWVYzcWlKNEpJV0taMzBEVjE4K3k4?=
 =?utf-8?B?bWEySFBCRXFnOHRWWS9ESTlLeE5IUDk2TG5RVlk0bjdPWkp0VHFQUUd3VUxO?=
 =?utf-8?B?UWJuMWphTU5HWnlVOUZBMHd0ak9UcU12OXI0OWdBc2lMU0ZVQWRlNGMrRjV3?=
 =?utf-8?B?aUh2QnJTRGF3ajd1eEFxa1FnWVBheXFmdkJEb2dvWDlIVHhmVFNHMTdNVmJr?=
 =?utf-8?B?bnVjUjB4VVIwVEdwcGhML0ZiaC9YYnNhbTFLMG9PQ0JOMEN2cjJ3RHBiVDAw?=
 =?utf-8?B?QUZQYnpDazZYT2NPYjc0UEY5bzI5QVdqaUpNL0k0SXFQOEdPZFlvZUFIZkFx?=
 =?utf-8?B?aURrSG91dXFXN2Y5Wi82YzlTYTJraThrdDdvclBBL2prQWNabkt5WS9LM0hz?=
 =?utf-8?B?bDVnUHZ5ZHJLTTdteXYxVFI2em9Ha0dFVUhSdll0NENxTUdNajE3czlrdHQr?=
 =?utf-8?B?Uk9yRGxYR1dBcC9Ib1g0Z1dLUnNkNmhaemNCamFpc2VjbXgvRmMyZkdJOTVE?=
 =?utf-8?B?U0JKejMrK1I1U25ZaE5vZ2RlS1JKRlRMNnFWR3RrVis5TkFUNi9YUmlYTTE4?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f9bed2-ed59-40ba-80e0-08db02c3c3a3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 13:13:23.1112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aqOD511PDkUexExd4Ms2VT8YwhHGlx7jcizBSGpmCQMNn9QGJ0Lmlj8TIwEqM1xj7uM4/WVjeUt28Qz26/mt5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6142
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/28/2023 6:07 AM, Sean Christopherson wrote:
> On Thu, Nov 24, 2022, Yang Weijiang wrote:
>> From: Like Xu <like.xu@linux.intel.com>
>>
>> On processors supporting XSAVES and XRSTORS, Architectural LBR XSAVE
>> support is enumerated from CPUID.(EAX=0DH, ECX=1):ECX[bit 15].
>> The detailed sub-leaf for Arch LBR is enumerated in CPUID.(0DH, 0FH).
>>
>> XSAVES provides a faster means than RDMSR for guest to read all LBRs.
>> When guest IA32_XSS[bit 15] is set, the Arch LBR state can be saved using
>> XSAVES and restored by XRSTORS with the appropriate RFBM.
>>
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 4 ++++
>>   arch/x86/kvm/x86.c     | 2 +-
>>   2 files changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 359da38a19a1..3bc892e8cf7a 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7733,6 +7733,10 @@ static __init void vmx_set_cpu_caps(void)
>>   		kvm_cpu_cap_check_and_set(X86_FEATURE_DS);
>>   		kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
>>   	}
>> +	if (!cpu_has_vmx_arch_lbr()) {
>> +		kvm_cpu_cap_clear(X86_FEATURE_ARCH_LBR);
> No, this needs to be opt-in, not opt-out.  I.e. omit the flag from common CPUID
> code and set it if and only if it's fully supported.  It's not out of the realm
> of possibilities that AMD might want to support arch LBRs, at which point those
> CPUs would explode.

Will modify this patch.

>
>> +		kvm_caps.supported_xss &= ~XFEATURE_MASK_LBR;
>> +	}
>>   
>>   	if (!enable_pmu)
>>   		kvm_cpu_cap_clear(X86_FEATURE_PDCM);
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 889be0c9176d..38df08d9d0cb 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -217,7 +217,7 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>>   				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>>   				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>>   
>> -#define KVM_SUPPORTED_XSS     0
>> +#define KVM_SUPPORTED_XSS     XFEATURE_MASK_LBR
>>   
>>   u64 __read_mostly host_efer;
>>   EXPORT_SYMBOL_GPL(host_efer);
>> -- 
>> 2.27.0
>>
