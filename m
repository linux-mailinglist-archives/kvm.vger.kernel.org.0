Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32DF673DAC2
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 11:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjFZJEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 05:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjFZJEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 05:04:00 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFF510DF;
        Mon, 26 Jun 2023 01:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687769972; x=1719305972;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qrq+FR3mWqtkJjkDtKb5PDfe4Ut9WEladyVkSlnDi5s=;
  b=cTEZtOSrtiyaB5E9Ti/M6ZTAiLFt77yYZbGei1umMm2Hvwfegi9e08mt
   qq3yBZ7vD0VwO3+nLAezpUZ3WuJX5w3NbLTFDJLRi9doAPkL2leIDKZbK
   TsR2lHdIlmWviXz5PHQ3HTX0EvTyBpaTcVC5EIhpMiG1wRN6eXl/qExP1
   lH7tX+HhK4taBjfzne40ybmAaYLjLGieQq8sELtYCCaYJ3/vGX78BHJ9+
   RLA4UL54vHlN5JF9JpEtN++N6KEZLzlzJYDbywRG57RqT9mbF7DyGfnIu
   bcUHHbbVM+1AN/3LU5+UkNxAURlml3aNUAB7qNd5Oe3/2pbGIF0aX+Uvs
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="364667098"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="364667098"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 01:59:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="829152793"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="829152793"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2023 01:59:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 01:59:24 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 01:59:24 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 01:59:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmP7rlLFuZGjdacW/bZjoDDXTEAVTF5utn49IjJbQQUIbqLtyNxZVtycQmG/j41CMaV0p/huWzwZsjjqk7Aeco/GnRw+nxz6NyRDpLn+fILEI8Y5KFFYkVZba6W3prYaIW7zbUfYo0XVOWHRfYVIoXvv6dpXlYfFWStZhcKJMIPusWP1UrMm3j3RBdqnEQkZfsfLTeEcgd0AHkm3uXNacCQNgt6Vd5IITEK/KXMj5D5RfNOQ7e4OL0qZ8VgaDVIvKoBgsE0vUbf4GTE6VGp2f9XDeylbjSjehpEd518F/RUTrwwO+TG1tNOzwcoC78m9ISad5TjfvBNinHE5OCHHLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxEowAZjsfC5JtWdf14/u4pnqr6edYdBZH+kCgQyKBE=;
 b=ZkV1xc15qkgpaucX65XFQhAxMr0WX+6YVC8xGzOn1JLOXXW5mLi3VhjtTxyred1l9bahoxnhF0AtcJ14IW/X2EcDF/qP6KxhYy9C4VRjK9KeTfXDYuW2SC/N64wNfxa9q/gtgD5Gixbk7aTgfitKh6zzhGm3vKU7Cz/eygkNYIGeBv0yA+9fXkpkrhfgVn5issife9k8rDbwabvIucOB7YRirrtqiS45Kx6qG42lLXcRjuT1ItfEG5A4+UPGC/mhiWmhSLCgfU6VHgnlY+95Z7KiMtU5EjZtAL2+o6Cjdwhlr3ZAgMnkgwCZ/gpn4LtKhB6oN8/7qk8eRmAzk3IazQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by MW3PR11MB4553.namprd11.prod.outlook.com (2603:10b6:303:2c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Mon, 26 Jun
 2023 08:59:21 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6521.023; Mon, 26 Jun 2023
 08:59:21 +0000
Message-ID: <945384ea-8a15-02cb-66b6-4ba4f22df3db@intel.com>
Date:   Mon, 26 Jun 2023 16:59:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 16/21] KVM:x86: Save/Restore GUEST_SSP to/from SMM
 state save area
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-17-weijiang.yang@intel.com>
 <ZJYc+4fN3K+h8VhM@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZJYc+4fN3K+h8VhM@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:4:197::17) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|MW3PR11MB4553:EE_
X-MS-Office365-Filtering-Correlation-Id: f96639b6-fef4-4583-5fd7-08db7623a181
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zoF8LNzqjCEEVmh4qSba/+jaO8fprdRkdE33E+dbgc5EOYaaQ0el+GGMEuN6lcPfTfj8w4VHg/9Uxe8TpoXJ6dxE+/WTIe4HmqKixhzAohBBx3SpAFGdNqCHZyQ3D2zj3n0fv52K8Va4N2F4I+bGSgjlNap5E75rwIbTFMVryihgaQXkc3DYDeXJ4j9ObHmeufgUYN3nMEcsVIkmmC/Cj/ZEwtL5vZyo3WyfnrDa7xNgXL+56tLs/7NV6GDfhnlJP7D4NeYYCaRXtUAZKf52Gpiyy6vD8ZOzWh+aK6pm+wKvA/gUATSO4hhosH0Nc7hhAChXlTtVejwYeR1tBb+IpyH1UNK//S4T6fEd8YK+wlj8ZsDckIl3hYtfjLgDSstNeXjur0bvfZyvimm2S/mf40W6XABNn1vzeSg7tJzFth7ySSy4UjaITHMjmIKk2/0JVVCRZMcxW7G8xli763BWpapO5F5Bd+ju3EMUah8pUfrmRHgfRTWmwpdq/Q+L6Jg3TaTF3O99w3SFUtVKmFGBcLsNBUHGElEFOZwD4Y1RCvHcC3LmMIdGwhAiD8LLLA416Y1H9WERrCDlkHxiUN/1xCm9JTmAArGU9KCn3nhcZQsNVAi8aadb1K5Zp5QS7KXEuI535PvE/fcheDfoei03ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(376002)(346002)(136003)(366004)(451199021)(2906002)(186003)(26005)(38100700002)(2616005)(53546011)(6512007)(6506007)(5660300002)(41300700001)(83380400001)(66946007)(66476007)(66556008)(8936002)(8676002)(36756003)(31696002)(6666004)(82960400001)(6486002)(86362001)(478600001)(4326008)(966005)(6916009)(316002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWcxVnVhVVJnVmQ2N0RqM1RJd0dLMWVsYVBYN3NpaWNJcThJYUlrQkIxTkg5?=
 =?utf-8?B?RnRiUDJwaml6QnB3OXpyVWxxaTZnYUg1VndjRTY2djNPQ2tyanRFUTJJTmgz?=
 =?utf-8?B?dTQxSlphN1RIaGh4OU4xWmdGWU9kdUpreVNEN0hyNG5WMmhUcFdYYkhCUEYw?=
 =?utf-8?B?dUV1TWc4cHZ0blhTMTh2NWRhNk9wdlhzMEl0clcwMytSdVkwYXhIdVI0SlRz?=
 =?utf-8?B?eFFnZUU4dVVTaVBmT3RTV2w5SCtwOXZscW5hdXcvRGo4R0RzMmR1NzRyVU5x?=
 =?utf-8?B?V2YwRUYwNHFrOWFRZkVsWlVlTFI2YitTYmZORUlsYlIvRnlIQkFNdUZyWnlj?=
 =?utf-8?B?UFFmdC9oVkp5aGloREpRdTUvRlNvR0tPdXpKb1lGcmI0VVI3cHZkZXczTTVm?=
 =?utf-8?B?Y0gzSGpMK2UrZVQ2OG1uV3ZabFVGWU1yRXNMbWRobXJUOURJZ21XNzRBSWtB?=
 =?utf-8?B?OEQ1UCtJQ1QyamlMZWZQSWdzVGxsdjF0RlQyb0RBZ1lScW83Z0UrUzk2NDZn?=
 =?utf-8?B?dFV2WDlrYjFiS1FvWWl6OTVGYXdNZVdTZDY1WGlRS25FWUN2SXFaTEc3SlRQ?=
 =?utf-8?B?d05mY1hGV2lrMS9oWjFPY2toVWV5bXp5WFJkdHRoeDRHUjVVWE5iK09Ecncr?=
 =?utf-8?B?a291enowK0V1cUI0UFVSMmlMS2FGV3YvMnBLb3FRcTdZRGJ3a29DRUtOUDFJ?=
 =?utf-8?B?S0RlNjVjUkx5bFFxUVhnd3grcmdUNFhMT0pXSmN1ODNiVkYxNWcxd1FPTmtL?=
 =?utf-8?B?Ylp0eXhrNkFIM2VOdjFZOTVGM0EzUTcrajVnd3E4YmxSYjYvWjhXL3k0bEhn?=
 =?utf-8?B?aGtFMndxNE5FVXZVRXRnQW42TFpvNUZuV0pzRHM5UWlKbDJqLzlMNkJtRnVP?=
 =?utf-8?B?aDl1blBjNmxiMW8zcGpVNVdzeU5XaC9Ga09qdmNOWHR3enVsUUNLVktsNENF?=
 =?utf-8?B?QU9IR3p3QkNUZjZmdGZQQnJPNFFGdnNaVWN1K0ZOd3U3cElGTThrOGNVZUdN?=
 =?utf-8?B?SnFQeTRhSVA5MG5lNG5IOVFSOGxMcHJyekFCOEtvaWRqYS9mcUZRN1ArYytB?=
 =?utf-8?B?UkpiUFdOaVNxWnE3L0FpcXJKQUhhVDZwRk84VWFWUXB3R01qT0NhSWxoS0I1?=
 =?utf-8?B?K0RxZmo4KzJmbjNvc0ZRdmcvSGlwR3BVTGFrdlpqM1BNbmpvRG1EVk9ZQUl1?=
 =?utf-8?B?bGtpYUhYb3pyQ05BRCtxdVhuRzBDVWVXWHJ5QjRmM3hGRGxwVjFwbWxqVzR1?=
 =?utf-8?B?NUNaM0ZncGxjK0phc1FoZ21sbnB1aDZZYUxHdGdEc0dTd1hBUGxiNXhOSlFI?=
 =?utf-8?B?TytKdHV1MHZPNDRFOTV2dHhYOXdpSE1zSVU3eU9wL2xSaXpsRkk4cDhWc1M1?=
 =?utf-8?B?cjdjSklKd01EdGYxOE1SanA0TEdQOUJJRi9oazlzVUU5cThXK2NpWVU5SFMv?=
 =?utf-8?B?cy94UldSVUttdXFGTFV6alFCeERmelluUndFV2lKUHN3UURaSExlRCtsbmho?=
 =?utf-8?B?ZnlXNTBUOHNIMGNST3oxY2tlckNyVXlnMmhySTV5b0Vrb25zTWFOaTJaZG5V?=
 =?utf-8?B?dFVUREp6UUVralNpVUNaRFkxU3VJZUtnd2M1Vmw3SzFTMmJ1OFBSRXNaRjVy?=
 =?utf-8?B?Zzg0NlpEN2o0NFRISm1rMUFPK013U1o1VnBXQk16OGZpMFV4UjA3R0ZIcUtS?=
 =?utf-8?B?S0dlR0JzQW1mWGJjVFNVeHlxSThEcXRnZUpabWVLRStrbjBiclRpc0g4c09X?=
 =?utf-8?B?RCtwYnF4SG9nYUl4Rkt6bnJXNEMweThOd0J1c0FHU3NnTXpQcE8zRGladGNP?=
 =?utf-8?B?MEVPZjA4R3BDUWJNb0s0eEVxL3BiSGR4U1hGSjJ3MmxTZlBrbkprcjZLR1VU?=
 =?utf-8?B?V0FVbnpEd1E2Q0YwaS9GQkFVUzRrMGhOdEE1Witmc1NRYnUrNGRHUWIvN0I1?=
 =?utf-8?B?YUdDbC9NV2FUbVRRZW1SMTZoblo1Q1hBWWRNWkRXL2cvcVlHeWxBakFjZnZx?=
 =?utf-8?B?T3FsWWZHUjNEMU9za3VqSTJzZzF0VGtLN3ZVdTBiaWVLZFludkx3dVY5RkZJ?=
 =?utf-8?B?dnpVRlVESkdrdTJqN3J3amNCMklOSmVVYWVHY0k1ejZhazBnMzBpWjBkTGRz?=
 =?utf-8?B?a1pzYTgvaFZDbU4wai9IWjhYRi9KajZhR3cvRmJaNm5ZRHFVTDZRSUdjeW1t?=
 =?utf-8?B?U1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f96639b6-fef4-4583-5fd7-08db7623a181
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 08:59:21.1795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aLVR++mNx7d/AInu5kOCqXoQQDrDn09M/zKRLrUs3qpKojurOqQX8quAqs29SRMVBZDHYRtDn0OEfefOkTFJpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4553
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


On 6/24/2023 6:30 AM, Sean Christopherson wrote:
> On Thu, May 11, 2023, Yang Weijiang wrote:
>> Save GUEST_SSP to SMM state save area when guest exits to SMM
>> due to SMI and restore it VMCS field when guest exits SMM.
> This fails to answer "Why does KVM need to do this?"

How about this:

Guest SMM mode execution is out of guest kernel, to avoid GUEST_SSP 
corruption,

KVM needs to save current normal mode GUEST_SSP to SMRAM area so that it can

restore original GUEST_SSP at the end of SMM.

>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/kvm/smm.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
>> index b42111a24cc2..c54d3eb2b7e4 100644
>> --- a/arch/x86/kvm/smm.c
>> +++ b/arch/x86/kvm/smm.c
>> @@ -275,6 +275,16 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>>   	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
>>   
>>   	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
>> +
>> +	if (kvm_cet_user_supported()) {
> This is wrong, KVM should not save/restore state that doesn't exist from the guest's
> perspective, i.e. this needs to check guest_cpuid_has().

Yes, the check missed the case that user space disables SHSTK. Will 
change it, thanks!

>
> On a related topic, I would love feedback on my series that adds a framework for
> features like this, where KVM needs to check guest CPUID as well as host support.
>
> https://lore.kernel.org/all/20230217231022.816138-1-seanjc@google.com

The framework looks good, will it be merged in kvm_x86?

>
>> +		struct msr_data msr;
>> +
>> +		msr.index = MSR_KVM_GUEST_SSP;
>> +		msr.host_initiated = true;
> Huh?
>
>> +		/* GUEST_SSP is stored in VMCS at vm-exit. */
> (a) this is not VMX code, i.e. referencing the VMCS is wrong, and (b) how the
> guest's SSP is managed is irrelevant, all that matters is that KVM can get the
> current guest value.

Sorry the comment is incorrect,  my original intent is: it's stored in 
VM control structure field, will change it.

>
>> +		static_call(kvm_x86_get_msr)(vcpu, &msr);
>> +		smram->ssp = msr.data;
>> +	}
>>   }
>>   #endif
>>   
>> @@ -565,6 +575,16 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
>>   	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
>>   	ctxt->interruptibility = (u8)smstate->int_shadow;
>>   
>> +	if (kvm_cet_user_supported()) {
>> +		struct msr_data msr;
>> +
>> +		msr.index = MSR_KVM_GUEST_SSP;
>> +		msr.host_initiated = true;
>> +		msr.data = smstate->ssp;
>> +		/* Mimic host_initiated access to bypass ssp access check. */
> No, masquerading as a host access is all kinds of wrong.  I have no idea what
> check you're trying to bypass, but whatever it is, it's wrong.  Per the SDM, the
> SSP field in SMRAM is writable, which means that KVM needs to correctly handle
> the scenario where SSP holds garbage, e.g. a non-canonical address.

MSR_KVM_GUEST_SSP is only accessible to user space, e.g., during LM, it's not
accessible to VM itself. So in kvm_cet_is_msr_accessible(), I added a check to
tell whether the access is initiated from user space or not, I tried to bypass
that check. Yes, I will add necessary checks here.

>
> Why can't this use kvm_get_msr() and kvm_set_msr()?

If my above assumption is correct, these helpers are passed by 
host_initiated=false and cannot meet the requirments.

