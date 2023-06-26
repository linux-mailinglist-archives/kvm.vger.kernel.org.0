Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A6373E191
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 16:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjFZOHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 10:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjFZOHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 10:07:52 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CB1E7E;
        Mon, 26 Jun 2023 07:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687788470; x=1719324470;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bP6cXtU0J0gQ2sp2xYfnQhQerZcIa+R7rAym3aw1bkw=;
  b=UhYjAqIrooBKrTMs5blEXXkQk3sBZ58m8Ks2yrzuUlXqOYSrwMORuxU5
   nUWP9i6BouLlGjCGWylxzw9717mBVmSMsgkAM4yeTBZCNHjkewC+5grO+
   C1D7/cVmQf4LhNZiTHS6yadusoNoKmyqpi4BTicXethp12WfuiGES+/q9
   oRN73cJZfgAEhoWE4NOPxQn2TR6D3+epR3pZ7rwN6qhgEZcjmektdVDcQ
   9NWJWa+gMpOgDhPISM8Rulc4291+XqIzDIEB5lCEbPft/sSr/kTcLii8z
   joScOmKjwwk9bor0JtQDoGP2lR53GJlavNK3Qzr28xIlNsxhGNBAPN4u4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="424947076"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="424947076"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:06:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="745804310"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="745804310"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 26 Jun 2023 07:06:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 07:06:03 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 07:06:03 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 07:06:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NK67Evi1BcoaBDPfgcFoHMusn2oge1ZA/+IXKaQQIZs3JbZvim/b/iwPXDRH+sGoIVwez7Wj/1Mus9lJb9pJ7YxxLOf3ZPxFDELY5i39BC85XKOKxLcZXw/9PikHE6NFU5wq/y1gmPT5LNP2STq2I6/46Li04x9ga4koYdlOQe9Ydt97boW4DVQhq/QjWa8LgOQNjq1sCIIE4JBGbof8zCkBnh+Vvq400oSGIdp61kuHT8yKdW3kaJ65zkJ0HGEc/VNBeBIwPsLcP5enW3tNqWz142FPqW7rb7OvQSim3nhwu7ppWjYVotmT1FGAR7Dd6jQkYmBHfpqkekCyHov77A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xYBqDFwcqwUTldbVMF/JEDhDZkd4s/vNpmWjVuwq4YI=;
 b=DzOIA1EZSs2OfCVdSX5JUx7hAEAsm3N0Icpwe3wFsEIHm/CNno48gbQOGRAKLvMGzxoBGkjLehlDIuLk7YHq0IjjdJIheqCl2ksKivCba5gkELkQfq866h4jCfiL7Cncqu8ifpBAW179pO0RSCN38u+CuUWGOPUQqrWSiW2d3HAXQ3jxOWWRH+fuUeQXK/vzO5SAQ/rRs8+2begmx6U/pGGdv2U/lHUx5bn7Eb6bWppoE+c1xT/3DkbW27oa3Phf7ziW3rFBmm3cw76V2sH7FWPEr/yY2aCw8pw0CrZSUFR654429+H9LfnIFwmBJ6Ft+5Qyd7l4xRwwpw7fQgJ/2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Mon, 26 Jun
 2023 14:05:56 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6521.023; Mon, 26 Jun 2023
 14:05:56 +0000
Message-ID: <9b12207f-7aec-7d46-9b7a-99355bc9d38d@intel.com>
Date:   Mon, 26 Jun 2023 22:05:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 13/21] KVM:VMX: Emulate reads and writes to CET MSRs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-14-weijiang.yang@intel.com>
 <ZJYwg3Lnq3nJZgQf@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZJYwg3Lnq3nJZgQf@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0013.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::12) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB7925:EE_
X-MS-Office365-Filtering-Correlation-Id: 56a78ec1-b2c9-462d-95a1-08db764e75f9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MugaQrwui7rnpWXWZ+EmWl4GMbDSEI2pUU1hBBZ/UMA6IhaQ0HSceiDUHvL0yeUYN2CK8iS8bGKv+S4XD9pAWGBK0B5uxTW512gSQkWretS+MK0rKyFIXF3bwY0J1Uzwan5Xz1zuo0BojR3dX+V1s2sO5YSgKEkw+DlsvVytAUaWyrrYMkvoHYKjr8zaNhJ4Tl6lrHPDwKIJRbYEn6R6rFwAlKsBkIAjuJbNFgy2NKTKp04NNcLbmSwJCraJ5HC/bO6uBky3ivY6LsKVeN5Ug8hklZzDOVdJxHL6SfLbn/efJMYeEpd6t0a6U4aBpAy8dnpRpdIEEiaYmWHsb6nNksWCwPTw3SPjF2NMctG3hM314aSjWJz8MFX0HS6aNPUbJxn6t67uAwEGxwxCp57in/YUcLzS/2QBjRsApwu/ZcIz88ibC+7vZ6xODuzPMcIvXPLliKEsTk8KnJw54pP1OfNKLzCIb/vKww7pA9Gn+beOT643NJqWrQ0KSoF6yRKqyBCvLrReuHlCdlcvL1ekIr7tZ4PHPNaMD3jUaeBvLTiC/pa+Ex0+I5lKqWa/tvsVpDiHW08hwDF2JOzdnfx8Scwz1AwVF1YOrVS6C+PAvuutvzGDuq42qUP0Y4176zxfmwgoRZIRNrYl5Mmi43cwyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199021)(31686004)(5660300002)(4326008)(66946007)(66556008)(6916009)(66476007)(478600001)(36756003)(316002)(66899021)(8676002)(8936002)(2906002)(31696002)(86362001)(41300700001)(6486002)(53546011)(6512007)(6506007)(26005)(186003)(82960400001)(38100700002)(2616005)(6666004)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFFUM2loYVJlU09qSE04WDZaOUV6N0tkeUQxNHV5VGNPWTcxUVFqOWxhYUVB?=
 =?utf-8?B?alVzUGdNRUpjczA5NjJTRFdDQmZEdDRJVXJSTjJCMVFNV3N5RHhGNVUyNExB?=
 =?utf-8?B?bHZ2TFBKRkhGTE5acVlWZU8xVnZGa1BxMFBNNFJmUE9Kb2ZTNm41enhUVGtB?=
 =?utf-8?B?UjhqTFVQUnhpSnNmcFp1RXpRVFNXQTA2dHJBcTVWR0pFTnFvSmJtQ2FaelBP?=
 =?utf-8?B?bjV2M29kYy9vT2JSM3N3Tmp5M0ZCVmduaU5rVFJhTmVsTlk0dzh1VWtEb3Bk?=
 =?utf-8?B?TDUzSitQN3BmM21oclNWUkozL3RYRjBOdnJyMWdQMW95dG1sZitERE1UWnJI?=
 =?utf-8?B?RmFlbGc0Sy9Qckp5WWlzMTBzajBDQlRaTGZweUtKdGp3c2NBaUlvS0xVN2hG?=
 =?utf-8?B?VDFneEJpeUptaXQvbU55dUF5anQrdUlvQVpNN1ZuWDNORzhPQmFhL2NrSnZS?=
 =?utf-8?B?RDRtbGk3N2VUVG13cWR4enk1ZzdUcldIQUZkNm5hMEJMeWFuUG5WRU1nSDBm?=
 =?utf-8?B?M0JVVWpTQ3dhWWFVekZIN1JYdGkyUW03NFRLNFhHY1B1QkZ2WEE4NlBWWlFV?=
 =?utf-8?B?ZUM2YkFHSzlzYzhKZ0Rzd3A5RnJzWTZZSFhVck1NVnJVV01qRHhraG96b1pr?=
 =?utf-8?B?K1R6U1pOY3NkdU1wN3V4SmljS2xJVVIzNDF5OEhmdUxBTmEzaXczbFNrc0c5?=
 =?utf-8?B?aWNaOXhHWWtYV0Y1bXk0UnBRVjVwTUdURzB3NWQ1SXBpSGFnUTAxL3E1Qjhj?=
 =?utf-8?B?ME1lb1FMeGJ5c1d3b3VQOFJJT2dxZWhlTy95T0IyeThNUms1b1JPZDFqY0Ji?=
 =?utf-8?B?dmtLQi9Ucm1XZjh3VHNDOWdtY0g5QVN1RVFJdmVpTXROWlBkVnR0dDB5TWxs?=
 =?utf-8?B?VzFTcU1EVXRYOE5UM1puUnFwTlJwc2FzdXZVcll5RTNSdDNvbVBRYXU1dkpH?=
 =?utf-8?B?cEVPWmxxZW5zQ2tnMm4zRHFjakw1TWNheG92R2k2RkdqVW1jTWhsdnY5a3Jv?=
 =?utf-8?B?bmZJVnY1SkZ6MFEvVDEzZE8xT0JUeTRwSVRGRG9GZWxvUHBUVXFWNDUyV0RD?=
 =?utf-8?B?S2dBSk5aQkFjOUlEeHJZQXFJNGJTYXF6bVhFcEdUeUx1MVVkWHFJdkJrQm0w?=
 =?utf-8?B?Kzg3NjdFMXFPWmZkM1lCaXBmRFAyNnQyVlFHUFBsVXNhS3dpNnFnanMxVmsx?=
 =?utf-8?B?S2Y0ZEIycnlCNmU5cVlYTnhwdmtJcVp3MU8zRmp2NHg1MUpHWlV1Z1ltMXhD?=
 =?utf-8?B?MlJGM1J5NUtiR3ExUEhMNE1jVnE0a2phVlhFeCtiNHdVVE5WU2hBb0ZwUE1H?=
 =?utf-8?B?YjZzSUpselpMN3FtVlFROThCVWhPc2FhQ1VKN0pvc2dxY0hoS2NZKzdMTGNy?=
 =?utf-8?B?N1pncjEvR2Q4ZWNWUHVPYkFVaFhZRzZsaG1EUWFiUDFEei9NQkJaNGtPME84?=
 =?utf-8?B?YTMwdkhSMDkxRVZHcUh2WFNielhGZGwwWVJlRFhPNnQyb2JIS1R4aWcwNmty?=
 =?utf-8?B?RTc1QmlUV01EQTRJMlJwRG82SW9iOXZqREM0bFZKV0Q0OEpvdWNFRjFOelRp?=
 =?utf-8?B?ZTdNTk1LMGpPZERreG9FbnZXRkNTbUg0c29Kc3p2WFBxK3gvWWIwNEo4aEcw?=
 =?utf-8?B?ZTU1VWg3SHhWZXdLK1RoRlNBVTQ1RXVMa0V4VVlyTHJaUFlFZThWQ3FHVi9i?=
 =?utf-8?B?TFl6N0Z3M0NZLzJHbHdGWnB6L0VoSHJuZG9LU05YQjBOWkpOT2I1YzR4ODAy?=
 =?utf-8?B?ZzVOaG5VMlVxSm5rU1RWQ2FwNlNVTUNIWjNYQ2NTaXppVXl5bG5ZUUJ0U3lV?=
 =?utf-8?B?eDN4K0NPWkFCbDBaZGJZc3NhTVRPUlJCbUpjZnFxS0JvcEl1QkVwbEtqMkVy?=
 =?utf-8?B?NFhveDNaak1ueFJTbUw1b21jMHNROWU2UFN0RTdRSjdtNUY3ZHkxekdIZGRR?=
 =?utf-8?B?MXEwOE1OT0I3QXMxOVB1TWo0MnFPeXcyVGE5Vm42c0dZRmhnN21YVWJKcHIy?=
 =?utf-8?B?WmJiSHBSK0pRZ1llZ2lTT0FkcTZhNm12Qno1MHdEQlRtYllzMG9GQjVmNm83?=
 =?utf-8?B?ZTBRUi9mSkJVMUVHVEpSQkhVYTI4V1RtTFpoQk5YaG9kS3pRbDhwWFVjVWpZ?=
 =?utf-8?B?OXQ0alQrMVNXQWVDaGlWbk1aS281eDQ0bWN3aXhEZVExTzBQSk1XeUlRWWNF?=
 =?utf-8?B?amc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 56a78ec1-b2c9-462d-95a1-08db764e75f9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 14:05:56.5021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0lxENx5rpSQuATKIhjM1lCS4x/Ch55gsNbzPvjb3e4hXjwSR4iPmwF2jEyX2JDGqDC+T14MSOc6S3qPtrsZDmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7925
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/24/2023 7:53 AM, Sean Christopherson wrote:
> On Thu, May 11, 2023, Yang Weijiang wrote:
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index c872a5aafa50..0ccaa467d7d3 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2093,6 +2093,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   		else
>>   			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>>   		break;
>> +	case MSR_IA32_U_CET:
>> +	case MSR_IA32_PL3_SSP:
>> +		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
>> +			return 1;
>> +		kvm_get_xsave_msr(msr_info);
>> +		break;
> Please put as much MSR handling in x86.c as possible.  We quite obviously know
> that AMD support is coming along, there's no reason to duplicate all of this code.
> And unless I'm missing something, John's series misses several #GP checks, e.g.
> for MSR_IA32_S_CET reserved bits, which means that providing a common implementation
> would actually fix bugs.

OK, will move the common part to x86.c

>
> For MSRs that require vendor input and/or handling, please follow what was
> recently done for MSR_IA32_CR_PAT, where the common bits are handled in common
> code, and vendor code does its updates.
>
> The divergent alignment between AMD and Intel could get annoying, but I'm sure
> we can figure out a solution.
Got it, will refer to the PAT handling.
>
>>   	case MSR_IA32_DEBUGCTLMSR:
>>   		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>>   		break;
>> @@ -2405,6 +2411,18 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   		else
>>   			vmx->pt_desc.guest.addr_a[index / 2] = data;
>>   		break;
>> +	case MSR_IA32_U_CET:
>> +	case MSR_IA32_PL3_SSP:
>> +		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
>> +			return 1;
>> +		if (is_noncanonical_address(data, vcpu))
>> +			return 1;
>> +		if (msr_index == MSR_IA32_U_CET && (data & GENMASK(9, 6)))
>> +			return 1;
>> +		if (msr_index == MSR_IA32_PL3_SSP && (data & GENMASK(2, 0)))
> Please #define reserved bits, ideally using the inverse of the valid masks.  And
> for SSP, it might be better to do IS_ALIGNED(data, 8) (or 4, pending my question
> about the SDM's wording).

OK.

>
> Side topic, what on earth does the SDM mean by this?!?
>
>    The linear address written must be aligned to 8 bytes and bits 2:0 must be 0
>    (hardware requires bits 1:0 to be 0).
>
> I know Intel retroactively changed the alignment requirements, but the above
> is nonsensical.  If ucode prevents writing bits 2:0, who cares what hardware
> requires?

So do I ;-/

>
>> +			return 1;
>> +		kvm_set_xsave_msr(msr_info);
>> +		break;
>>   	case MSR_IA32_PERF_CAPABILITIES:
>>   		if (data && !vcpu_to_pmu(vcpu)->version)
>>   			return 1;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index b6eec9143129..2e3a39c9297c 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -13630,6 +13630,26 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>>   
>> +bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr)
>> +{
>> +	if (!kvm_cet_user_supported())
> This feels wrong.  KVM should differentiate between SHSTK and IBT in the host.
> E.g. if running in a VM with SHSTK but not IBT, or vice versa, KVM should allow
> writes to non-existent MSRs.

I don't follow you, in this case, which part KVM is on behalf of? guest 
or user space?

> I.e. this looks wrong:
>
> 	/*
> 	 * If SHSTK and IBT are available in KVM, clear CET user bit in
> 	 * kvm_caps.supported_xss so that kvm_cet_user_supported() returns
> 	 * false when called.
> 	 */
> 	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> 	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> 		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_USER;

The comment is wrong, it should be "are not available in KVM". My intent 
is,  if both features are not

available in KVM, then clear the precondition bit so that all dependent 
checks will fail quickly.

>
> and by extension, all dependent code is also wrong.  IIRC, there's a virtualization
> hole, but I don't see any reason why KVM has to make the hole even bigger.

Do you mean the issue that both SHSTK and IBT share one control MSR? 
i.e., U_CET/S_CET?

>
>> +		return false;
>> +
>> +	if (msr->host_initiated)
>> +		return true;
>> +
>> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
>> +	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
>> +		return false;
>> +
>> +	if (msr->index == MSR_IA32_PL3_SSP &&
>> +	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> I probably asked this long ago, but if I did I since forgot.  Is it really just
> PL3_SSP that depends on SHSTK?  I would expect all shadow stack MSRs to depend
> on SHSTK.

All PL{0,1,2,3}_SSP plus INT_SSP_TAB msr depend on SHSTK. In patch 21, I 
added more

MSRs in this helper.

>> @@ -546,5 +557,25 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
>>   int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>>   			 unsigned int port, void *data,  unsigned int count,
>>   			 int in);
>> +bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr);
>> +
>> +/*
>> + * We've already loaded guest MSRs in __msr_io() after check the MSR index.
> Please avoid pronouns

OK.

>> + * In case vcpu has been preempted, we need to disable preemption, check
> vCPU.  And this doesn't make any sense.  The "vCPU" being preempted doesn't matter,
> it's KVM, i.e. the task that's accessing vCPU state that cares about preemption.
> I *think* what you're trying to say is that preemption needs to be disabled to
> ensure that the guest values are resident.

Sorry the comment is broken, I meant to say between kvm_load_guest_fpu() 
and the

place to use this helper, the vCPU could have been preempted, so need to 
reload fpu with

fpregs_lock_and_load() and disable preemption now before access MSR.


>> + * and reload the guest fpu states before read/write xsaves-managed MSRs.
>> + */
>> +static inline void kvm_get_xsave_msr(struct msr_data *msr_info)
>> +{
>> +	fpregs_lock_and_load();
> KVM already has helpers that do exactly this, and they have far better names for
> KVM: kvm_fpu_get() and kvm_fpu_put().  Can you convert kvm_fpu_get() to
> fpregs_lock_and_load() and use those isntead? And if the extra consistency checks
> in fpregs_lock_and_load() fire, we definitely want to know, as it means we probably
> have bugs in KVM.

Do you want me to do some experiments to make sure the WARN()  in 
fpregs_lock_and load() would be

triggered or not?

If no WARN() trigger, then replace 
fpregs_lock_and_load()/fpregs_unlock() with kvm_fpu_get()/

kvm_fpu_put()?

