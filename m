Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5667E73DE84
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 14:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjFZMKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 08:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjFZMKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 08:10:44 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4611E43;
        Mon, 26 Jun 2023 05:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687781443; x=1719317443;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Vt4FBiuxCltNHkGsxH2gkRa4CRkFoCfAh3mBYspjktw=;
  b=a92WC4YiHbHFBprxLabEgsH3Q77e2JSOfhexE3X2f/pKDNeU3TBzRNHz
   SeikomI6iLnwqiGFZLYdbTe2Kqc7urP/Z+HMCOTVkTDDgAkZyFQVUxCHi
   hODnCLonPyi0nxbhH8CkMRziJNZKEkdehcLiJwo6k1nemMmOrVNzSdMf/
   6bQGs8gwBqhO8vytbHhA4KLdwINYddi78KPC8YerHU2KCpwNN+tfbgW2u
   fnF1M5ykvH9n6BkOYZvXhEykhIq3gVvQ0j2Y8W0PRnMuE3GYizvYJLrVr
   vgHzhGewpForm0eN4E/WHc2z3uZbdaXsX92mCBuro+6uCyhWGaEhocoP8
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="341589218"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="341589218"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 05:10:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="786136313"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="786136313"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jun 2023 05:10:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 05:10:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 05:10:42 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 05:10:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMh1rPlbt1VL+aYh5+exYg5/a0to5ViWgokhtc0W4GccvIsB3jUy/iOlReazsf65QmWMIB2/GcRJavkcQBo2WOcpOcu5DFyFzBbZ2jxb4bppubH9J3kBvItuWvYCJVgPjh8m9iV5sCMtqYt+Pmv/yJtv5IN5mvVjDXWdC8Vbk+SniEYNYXFruMh48b2BEKH60t5+EnaYicSi5ksPJoH0zLX983NaKqaQ0E8NT+yvQsDEDkpUnW7ojcOjS04KpUOOaAJBDELVzrQJxI12trbU8OSYqpl6TeNWlDzjFbIdPi2bZ+K/URERGlziwT4fnXTFxr/QUkIFdZbGa4MYmUmz+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E2kfGmQKHOIeBpJ/EHGAKrY6bcWEkDrJweZRE8hd/28=;
 b=jqcEY+Vb2+VRO5/gkSw22a5eOF4shZCclTrIVtbsPxzPNlsEXsvD6K2ime0UoBi+X0SeIagtaVueZm/ssbuwnnkoMW3Na5D1fX9T00pm1Mih64zZpFjgAXv4UqqRyeQIF3g2tofnLKkXJE37clo9fp9N95QQ3qTm8h5WTL6DEBn3hWoVHGV8GmtVe0wEEtnTg2NpC3EOdSRkV1BsK/G6Dv07gJP0ZThhT2pVRUcraL5e8Ohbs+RCLsKU2hch/5t8g/31rFEYMAZJvASyPOFs16ajf1nO1GTG1QH/DTbJD+JtGB1kasWYdfvcZ6Pw7G9VIz8kYZCRvySLhKsglIuXaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB7173.namprd11.prod.outlook.com (2603:10b6:208:41b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Mon, 26 Jun
 2023 12:10:17 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6521.023; Mon, 26 Jun 2023
 12:10:16 +0000
Message-ID: <3b546ed7-145e-6cd2-effe-e17e958cc226@intel.com>
Date:   Mon, 26 Jun 2023 20:10:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 20/21] KVM:x86: Enable kernel IBT support for guest
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-21-weijiang.yang@intel.com>
 <ZJYyuBdh8Ob+zzT2@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZJYyuBdh8Ob+zzT2@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGXP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::19)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB7173:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eb42b67-f405-41a1-22ba-08db763e4d77
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P7Z59aG+5jJg+FDDK3j7hNyic78lr9v+HijdjK9MEkAX4Hz7cExaOu0JgkjCiMDQ6Efib9tA8MzkRQTxJep80Gg74XQmKfxFk6wq420wt8qq1ArhsusyJohwVetbUbdf3jy/L4rW2jSwAGpP+W98XQ0jbkmYLOw1NHZDelfV6QUVwUDtZ2skpK4VyPIwqWGPZh/XKqZqh3td/XBiXZ58eDEx6Z2/8aY272blceMnZFPC1O9UGRYkaEYUihjnDalHougL3YPOE7fDl3jP0RO2cH7DodZJNTE8w3zds2t4RuQDJfias4FeHfh8FrcjAaHujPgxWkUpMQXkGYjYKK+Yv7YSW7EZ5vcwj7SjNzN1V0dnj3n6CIAvtoDum+ow5mDwohkTdTYG8MT8HqbnF15LGjbrwHnVe4FXLNeeFQPx02KZqPsylGtGRBmN4B3VtiSi+zK16u6kUPAh9312QxKaQDSeqm5smwxvg7lo9eNBxyVRBQRxwRamfmrSPSckfEIKTND/qw1XRImVUTBsYXdAo/41fKfKTqPmyZ+FSpWpNKl9XMSzzXDjtSMicmLeFbK3rqkY7LJBPN81TVHKrCsmKkDRkpZsWoO5wTaua5XZsxLsHYlw/9i7auDc0+ahsiMJ9zWSxYGbXAxjBS6ubn1wOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199021)(2906002)(6486002)(6666004)(38100700002)(82960400001)(2616005)(83380400001)(6512007)(6506007)(26005)(53546011)(186003)(41300700001)(31696002)(86362001)(478600001)(316002)(36756003)(66556008)(4326008)(66946007)(6916009)(66476007)(31686004)(5660300002)(8676002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGgzai9YVTNHWTJsUHM3S3BUZjZzWXo4OE1EZ0QzNi9OVEtzUThYand5bjdl?=
 =?utf-8?B?Skk3VjhtV2Q5eHVmc1Y2M1BLeGJQS0VJUUd1NzMzWkpPdjhHVjBIc2c0WEVx?=
 =?utf-8?B?UEtaODBpUHcrQThSQWJxVVB3QXZ0bkc2N0pGaUZnVWg4dXlrNWNhTnBBRWts?=
 =?utf-8?B?eEYwY21acEZpN1pUU3V2TktyWnZ1WlNTa1p0SFA2ejlTTERCTXhQcDIrT1pj?=
 =?utf-8?B?WEpPVStTUzl4L2NHWlBHSXp1Y2ErU1B2d2YreERrQ0QwN3JzWldlVit5L0lH?=
 =?utf-8?B?cUFxZ055U2g5NWpoRDhiQ1NEUkxIOTZ4YitIRHBrVk9ES0o3WkhFaSt3MENV?=
 =?utf-8?B?dHBaZU1pc1p0cGZ0bjg4OFJXemdZblZOcmZVM213Mk9QNTJTRkxINVNhOFpx?=
 =?utf-8?B?SjJnVDIzSU5Uc1h3RW9LZkZwTUdvbkJCc2p5S09sYk5aalhHemhsMlVUTUlR?=
 =?utf-8?B?NUE0anZESy8yU2h5eWlVQkRjNno1dndzZ24ycEQ5TGJVK3FJQW9HSi8yb1M1?=
 =?utf-8?B?UVIxeWJRM0orOC9ESnVtb3RQU3B5Qm92OFdIMjBaTzl5dElaRzhWQlNiaHJD?=
 =?utf-8?B?R3hBYnhKbENvWG9WcXRocEtuYlZCdzZscytYQTBzT0dIYWduRUIzTEhaRXdY?=
 =?utf-8?B?TldNclBCcnFEbEw1dTk4YlBZK3YyT3l1RlQ3aDVkZHI3bVFTL1BYUVllM2Rs?=
 =?utf-8?B?QUxhdXJuN3VmWk1FYTdVMWlLdVVDZmd5Ykt0dzNoWXFlbWNiR2oxOXJLK3ZN?=
 =?utf-8?B?ajJTUjNGYnFXRFkwSFlrQ3d4Yzl3WW1qOWJLMGV5LzlQRndteU50VUhrbjNu?=
 =?utf-8?B?ZHZNSW05NTN6b2VidllwOTcvNmwwdlFVWE45WjJrM0hyZTd5ekJKZ0EzWlFV?=
 =?utf-8?B?a1NrT2pZazVuQnZTaytaOHpMaTN1OFFJbU5mTVprdlNXbG1GaUZMSktnT3Vk?=
 =?utf-8?B?cGlkT2ZNYXUyTFFRY2FlRGh5K3dwYVMvSlorSll2ejBXa2U4WGgyc1FiRVhn?=
 =?utf-8?B?emg1V2pWUXBqK3BWQlhIRjdtNFBwbkpLbWRXS3Y2R0F2b3NwMFlCdHlJaXJT?=
 =?utf-8?B?WTRzYW5VbmdPeEtSSEdFMmd1Q2tzemw2TmJHb3pLcVVhSTlaNEtSQ3dTMXVY?=
 =?utf-8?B?MDhSbklnQkRmR0haTGpFOUIrLzBMWi9tLzBBRTFrNm0vVitudDhjS1lDSXdW?=
 =?utf-8?B?ZTl0YkZsZHVuNU1MYXo3aUZVSzBkbStDVGVkNzNWa0JYdkliNkM5QzFYbFph?=
 =?utf-8?B?bmlkVjdEdGJYZG5LYnNBWHNzK0E0Vm5veWRwK0N6c0hQbHZROXFHTkJaOWdx?=
 =?utf-8?B?ZXpyWG9qcVVQZ2Vnem5xYnJVWXZ1R1Zxek5QMHNZV3JQekhVMWh2cjltd3Jk?=
 =?utf-8?B?WUZuQjd4VVpxUkwvcm9zdWNmZC9PYnJaYTBqYUNkRVRhT1FCZnBkYTNQVHZQ?=
 =?utf-8?B?SFJTU2F1M2VzOUNBYmpVc21wSGtnUWQ3MGpGMjgwQjVFWU9XSHVucW1rY0Rj?=
 =?utf-8?B?djdPRExOZTNuYzhuc1RCM0daQWFPMlZPbDM4TC9mZEEwTzhRdmVQNFhkRnd4?=
 =?utf-8?B?M280V0VjVCtHQ1VCZndPckQ1THdZMWVHZlZuSHpOVWY3akdQVlNnelpPeHV2?=
 =?utf-8?B?RXdiQlhoTmJYL20xaGpNc281OXpLbUhpendaS1FiSWpSQ3JNYitoVWRwNkVE?=
 =?utf-8?B?TmU0aWlXZ2lOTTQ4cnQyZWloRVRPMjNVWjU5bUxSOUFIUDVpZCtzckZ2MXY3?=
 =?utf-8?B?ZWhyRzF5eHRpUWpTYzRFR1h4Z0w1YTJ1RmRCc2hTNVdlVFBsTVhJK0psNUxr?=
 =?utf-8?B?eEpRL0dQV1VsU0V4VmdHbDNkRGhDbFQzY3VNMXhuWmFxT25XUlo2R2FuVVE0?=
 =?utf-8?B?c0NxamZTbEIwMm1hOSs3MWNRV2RzdVFUNHRPNmZ5T2tUY3FQNUN1bldtektG?=
 =?utf-8?B?QXVZR0dsRXJ1c2ZMaGZ4YWs2RXJoOHkxclYxZzFrNDJkV0l6ak5pOE1kQjdI?=
 =?utf-8?B?VnV2bXpXTHJCUmdIZFByQXFHbDFleE1tbkRGWjhwMW5Od1FzK1h1MmZmWHpr?=
 =?utf-8?B?azRUUWxBZmZsTmpIWFhsZFBJR0tUYWN1OVkrZWhRSlQ0RjlJamx5eGthc3l0?=
 =?utf-8?B?YTRBVmlWZzN3Y2RmZ0tzME1YMEJGVWdUR20zN1Y3WWI0Q0J3UFNsajlQbnh4?=
 =?utf-8?B?R0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb42b67-f405-41a1-22ba-08db763e4d77
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 12:10:16.7242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VRIyDSehn4Np02NQ+KAbHKPOXLQVOTQA2Y8/buDY/Pea8A/DtcPwN01Hff27FAgZs3WF1vuI6S2fQITHg7LRYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7173
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


On 6/24/2023 8:03 AM, Sean Christopherson wrote:
> On Thu, May 11, 2023, Yang Weijiang wrote:
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index a2494156902d..1d0151f9e575 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -711,6 +711,7 @@ static bool is_valid_passthrough_msr(u32 msr)
>>   		return true;
>>   	case MSR_IA32_U_CET:
>>   	case MSR_IA32_PL3_SSP:
>> +	case MSR_IA32_S_CET:
>>   		return true;
>>   	}
>>   
>> @@ -2097,14 +2098,18 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>>   		break;
>>   	case MSR_IA32_U_CET:
>> +	case MSR_IA32_S_CET:
>>   	case MSR_IA32_PL3_SSP:
>>   	case MSR_KVM_GUEST_SSP:
>>   		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
>>   			return 1;
>> -		if (msr_info->index == MSR_KVM_GUEST_SSP)
>> +		if (msr_info->index == MSR_KVM_GUEST_SSP) {
> Unnecessary curly braces.

Something in my mind must be wrong :-), will remove them.

>
>>   			msr_info->data = vmcs_readl(GUEST_SSP);
>> -		else
>> +		} else if (msr_info->index == MSR_IA32_S_CET) {
>> +			msr_info->data = vmcs_readl(GUEST_S_CET);
>> +		} else {
>>   			kvm_get_xsave_msr(msr_info);
>> +		}
>>   		break;
>>   	case MSR_IA32_DEBUGCTLMSR:
>>   		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>> @@ -2419,6 +2424,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   			vmx->pt_desc.guest.addr_a[index / 2] = data;
>>   		break;
>>   	case MSR_IA32_U_CET:
>> +	case MSR_IA32_S_CET:
>>   	case MSR_IA32_PL3_SSP:
>>   	case MSR_KVM_GUEST_SSP:
>>   		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
>> @@ -2430,10 +2436,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   		if ((msr_index == MSR_IA32_PL3_SSP ||
>>   		     msr_index == MSR_KVM_GUEST_SSP) && (data & GENMASK(2, 0)))
>>   			return 1;
>> -		if (msr_index == MSR_KVM_GUEST_SSP)
>> +		if (msr_index == MSR_KVM_GUEST_SSP) {
>>   			vmcs_writel(GUEST_SSP, data);
>> -		else
>> +		} else if (msr_index == MSR_IA32_S_CET) {
>> +			vmcs_writel(GUEST_S_CET, data);
>> +		} else {
> Same here.
>
>>   			kvm_set_xsave_msr(msr_info);
>> +		}
>>   		break;
>>   	case MSR_IA32_PERF_CAPABILITIES:
>>   		if (data && !vcpu_to_pmu(vcpu)->version)
>> @@ -7322,6 +7331,19 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>   
>>   	kvm_wait_lapic_expire(vcpu);
>>   
>> +	/*
>> +	 * Save host MSR_IA32_S_CET so that it can be reloaded at vm_exit.
>> +	 * No need to save the other two vmcs fields as supervisor SHSTK
>> +	 * are not enabled on Intel platform now.
>> +	 */
>> +	if (IS_ENABLED(CONFIG_X86_KERNEL_IBT) &&
>> +	    (vm_exit_controls_get(vmx) & VM_EXIT_LOAD_CET_STATE)) {
>> +		u64 msr;
>> +
>> +		rdmsrl(MSR_IA32_S_CET, msr);
> Reading the MSR on every VM-Enter can't possibly be necessary.  At the absolute
> minimum, this could be moved outside of the fastpath; if the kernel modifies S_CET
> from NMI context, KVM is hosed.  And *if* S_CET isn't static post-boot, this can
> be done in .prepare_switch_to_guest() so long as S_CET isn't modified from IRQ
> context.

Agree with you.

>
> But unless mine eyes deceive me, S_CET is only truly modified during setup_cet(),
> i.e. is static post boot, which means it can be read once at KVM load time, e.g.
> just like host_efer.

I think handling S_CET like host_efer from usage perspective is possible 
given currently only

kernel IBT is enabled in kernel, I'll remove the code and initialize the 
vmcs field once like host_efer.

>
> The kernel does save/restore IBT when making BIOS calls, but if KVM is running a
> vCPU across a BIOS call then we've got bigger issues.

What's the problem you're referring to?

>
>> +		vmcs_writel(HOST_S_CET, msr);
>> +	}
>> +
>>   	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
>>   	vmx_vcpu_enter_exit(vcpu, __vmx_vcpu_run_flags(vmx));
>>   
>> @@ -7735,6 +7757,13 @@ static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
>>   
>>   	incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>>   	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, incpt);
>> +
>> +	/*
>> +	 * If IBT is available to guest, then passthrough S_CET MSR too since
>> +	 * kernel IBT is already in mainline kernel tree.
>> +	 */
>> +	incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
>> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, incpt);
>>   }
>>   
>>   static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>> @@ -7805,7 +7834,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>   	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>>   	vmx_update_exception_bitmap(vcpu);
>>   
>> -	if (kvm_cet_user_supported())
>> +	if (kvm_cet_user_supported() || kvm_cpu_cap_has(X86_FEATURE_IBT))
> Yeah, kvm_cet_user_supported() simply looks wrong.

These are preconditions to set up CET MSRs for guest, in 
vmx_update_intercept_for_cet_msr(),

the actual MSR control is based on guest_cpuid_has() results.


