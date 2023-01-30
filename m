Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971ED680DDD
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 13:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236179AbjA3MiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 07:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235297AbjA3MiD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 07:38:03 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8705FC7;
        Mon, 30 Jan 2023 04:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675082281; x=1706618281;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3xpIH0vR0A9sJ+Bo185+DebsLQm3E/0JqdJIAa4iY24=;
  b=YST/jrnurAKRb5HlRakNF6z0ao4Cp2tZsqipk+W4o/sBaEJ81rgtKx8M
   6SPw8Zx1ypjgc7pbn3+3IhEF6y7DvEA0TXSgQ/D0cyn8aacXyeHoev5DN
   6Ocx1rrrVKwuawv19WdS3bD1BU73qoKg/yd3XLm5FJbqTmA+YsZtLfCbj
   ezgMocRgvCchpLZ1I6IHzw9Ev4uLjA0jNQXZGPgVFpY3lbHD74e0+rHFQ
   bstZ7P3GHrI70kdqrT6e0LrOP1eE15wGs4O4E7zVT6AG/rPj4+cnkoKki
   RE0wfVE2k2YoTiBiSMfgibVhcHbVhvN2Q+/FDsuUqkG0BTKahKI/giCqe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="325242702"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="325242702"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 04:37:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="837954333"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="837954333"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 30 Jan 2023 04:37:30 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 04:37:29 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 04:37:29 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 04:37:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXUGvuCdJXvq9PIvQdahurtDUtR2melVqg9VxB7j4KGtmX/8fz5XC4lwIRg0gAKpXSo1CEjt5RdCqrZpQGL9dMIWQ1MKLapkBsZeY3qTyWRdTC5VHwmO6SsQ0X2QcpgDO48yyokHHtw6TDopM1Y/U4MtWy16vwytFCFy3pFP2mPORIzHQRhpEfFem4Vod6MzJ9aVUZoi3l4d0B8yCzc0g9YzpI0toNkDog+aJNrKWkg3B7xzahMNS9PPXFkkk6Eht1K43jy5MKxQezGvQbwHGyqf9zUqLw290DN01I587vRT/4/RHbBXg0jewxqarPyLKqD6zQjidkJ+aJy8R0GKzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HMjy+UOUxFCXKHwR1xxrUDnYn8LKBpOipcXkyXcOAzg=;
 b=RcpgReSnFqW4ETD3Xxj6FPKip5ml3vE8KUoaa9eMG1b/jFH54k8+nmRPH3ZpHZw59h+r5UCQNnXsM2ffL0k94PNLpWSj8dV6d/7VZ9tr3TF7JQUX3Ze0XBgIhKVzTofyhOL3SfBIB2s+Vk8eqVM5QQMlmV+2jCOJIWWM8vbylfu+01TnIcnYb33mhkk4904/EKtIaNXi7CJhJkNwjUf1EGRAFb9JR0eMKx+rVgiO2aX59yI1fVxDGCV6LxUXTvVOQ1rKuke2NqQUQQfQ8kUXg+7SciXW9KJ8yhIftNHY90MAslPLeOUcevCNdISC0uLJxlbTPHPU2ChJgS+SJRkQmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH0PR11MB5460.namprd11.prod.outlook.com (2603:10b6:610:d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 12:37:26 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf%2]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 12:37:26 +0000
Message-ID: <3b08788a-5f61-3846-19f4-63185d42ba80@intel.com>
Date:   Mon, 30 Jan 2023 20:37:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 09/15] KVM: x86: Refine the matching and clearing logic
 for supported_xss
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <like.xu.linux@gmail.com>, <kan.liang@linux.intel.com>,
        <wei.w.wang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-10-weijiang.yang@intel.com>
 <Y9RGHeXUVsQCpYBF@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <Y9RGHeXUVsQCpYBF@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0183.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::16) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH0PR11MB5460:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f894d11-da9f-41d4-1eba-08db02bebe19
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UwVbw8M6nY8ydkRksFaA1doxcT+E/SzXR7ZIzC5RQRjphPMkLAYeE1DvekkpCpeoTO1nSVtaGGu9kTzQJjOLwrycJkukx+SswN58ZqCqE6ul1UW5yWQ6QidNe/tXzAGFjGKOVrQNBAwgcqPn0jP3WxIgotIsJHkwtIdcwIWklZwASAONUGEwQvxko5TGywsPkbj/UJm7cfzgNu5wOSwpolD33eu5ZrrtW/juTRwNsoCkI7v0DftHjParpHaEKA5jNyJ9EM8NQ1go+uaHN8Mk6jtObDYPBLIxJ8Man3Wmt2gd/6ANfBwdiPTTrvCsR48MOUT6Ccmd0Z3MTSzyMYNmMPMGXcKOsQ8wwTm4WHG6faDMj40F4jZVxrMODR3tl0nWO4U3dMwOuRSF5P9rDrhXjbt/N0n+OGj9CP4k/3enJQ2Rpn/twiKCVrzwncKVRIblShHfZer+s03SyFF8Rdt9E1qLytoNvRvQD8dDpI9bMWzsMf3sImsV8IJbFR15hWGmMHDT6y3agK4oAfzImIlFZObP649/qCglB76+olW9vIuq0LGDFtJHsjZlP21c+cGzKdAdSgkenbfNMnvoZp9G0SxPMx1U3IK1u+SoH8HEGhsVpksfCcptLPoN5ArK1JeqeOvc+oN4W0QvE4rpxTd/b4OIZmyE44x7h4qVZ1Tr8O/PSuwwApISiggA5MO4kuAQXE5fkClLk5EFYVUpJiscdz1ZrT78ljHizdfzqGFl5Rg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(376002)(396003)(346002)(39860400002)(451199018)(83380400001)(2616005)(86362001)(31696002)(38100700002)(82960400001)(2906002)(36756003)(53546011)(6506007)(26005)(186003)(6512007)(478600001)(6666004)(8676002)(66476007)(6916009)(66556008)(8936002)(4326008)(41300700001)(31686004)(66946007)(6486002)(5660300002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmtESUQxTTluRUJDeDNGck8xd2tmK3dkZGZWT25wd1pNS2FjSDNyTFZTaldj?=
 =?utf-8?B?dEJ3UDVOakFKTDgvak5uSDVlU1ZrZXJrazIwRDI1RDVmUGJIOFVqdTlDSnpq?=
 =?utf-8?B?WWU0TVBNMjlXWUtOL2tBMU5OK3VFeTRhMi9RK0Ryc2ttTmxYMURVR0JseXkx?=
 =?utf-8?B?bEZ1eURDV1R5T0Z5bGFSR0YyZzFuNkprTG5YSk90dFdZQTBxSTZQYzRTdWRr?=
 =?utf-8?B?dFh3ZS9ZbkU4TXY2WHhSZjNZVzQ0SUpuaWdHNmJpWkxvR2k3WHNNRzdyc3NK?=
 =?utf-8?B?aTBNT0VjcXBwMVFtQXpvRzRFYnVwN1Y3VVlDMTg1WnpabzFMM3IxRWt2TlJZ?=
 =?utf-8?B?MjJWU0tJaEhYYVNCcHI3WXd0NlViUGxBRklJcnMxS3htRkpQZTNEU3A2L2tU?=
 =?utf-8?B?U280YnVQVkZuRnFNZWVFUEo5bFpBVmJVc2wzYWgxOUxIdi80MFNnMzRmNjVD?=
 =?utf-8?B?N1ZXZUgwK04rNitxOUNiS1NqdldaNU5lWUNpUFR4blF3TFRDb1JtUHp1SVQz?=
 =?utf-8?B?Q0xLbnBlYjFlOEdtanR1Yzl2Q2V3WnFLVE9QRnEvQ0ZBcFJRRW5MY1RBOWgr?=
 =?utf-8?B?U2hHdlh4NkhXQ2xnTGhFWEZvV2RYSmtCSEdRYjZEZGg3RVdYQTNJbVpnYTNr?=
 =?utf-8?B?VWR4alczOVJRZ09QZXUzbWI1MXgvanlETnA2ZVZuTlM0ZnFRRUM4eEJadDBm?=
 =?utf-8?B?K3liR0tGeWlGSkt2K1NyV3NmTGs4RGNUTFN0RHdIOUR1OWNoV1ZBaWFYRVky?=
 =?utf-8?B?aDUzR0JkZzBHcyt5TUl2a3IrckFnT2U1QlRtSFRnNzhRa043LzV2UDR3TnJT?=
 =?utf-8?B?T0pEWE11SXBUcS84b1JjTHN0QXZET2hWc0x2NU5sbEZKclBydUFSalF6b3lG?=
 =?utf-8?B?QjJDRXpvVDZVSSt4bDg3S2lSbWlEQW5hYTAxRTN4Ri9JNXU0aTNjbjZIM2h4?=
 =?utf-8?B?dkRMTGgrZk1tNUxOLy9uKzlrQ3YrU3MxRWxNYzk5VmloSThGSmc1RDNoTTRQ?=
 =?utf-8?B?S0o3WXY2SGZ4d01WdHhGWng0ZkJCY3FlT2dkYmFXTlRzamt6R1dPakV6YUkv?=
 =?utf-8?B?YmZmeUppWnVqSHdjeFlkbVlueVlxZEhoajV0c3pqcnNyUFErSkV2NTdRRmdl?=
 =?utf-8?B?UkR4WGtOK25LQVRrdEFZNnBzcGpCV0x1azFXTE9GM2RUQ1I3OExmZ09jOTZQ?=
 =?utf-8?B?OXNmYVducEZJNDRTZzU0UU1tWU04QlRqN0gwWE1FTEpKV0NidFFHb1NRMGdI?=
 =?utf-8?B?R2lTV0w1VEZWMXZnT1lJOXdsZU44MXFqUHZLbEFZbTdmU3VjWTBLR1Rzb3hL?=
 =?utf-8?B?SHFyMlRNcHJkU0FOMEJGWWZjQ1ZNQnkweGNJL1FDVVRZSDZHMVBqdWRDcEQ4?=
 =?utf-8?B?N28ycEZ1a0dmS3RZZjdaa0xCUGgzandKVnl4ZzFyNElFOUY4MWtWWitRQWRB?=
 =?utf-8?B?RTlZK3EyU2Fvb0JRYlpXMlI0aTlRSXVPRDVkOTBKQ1V3Qzg3ZDB1ZW4veXI0?=
 =?utf-8?B?bERORlVTLzdrMUIxUTZWNWtueVpYWlVURjlrUVBTQVdoQ2wycnVSQnF0U2dJ?=
 =?utf-8?B?TVNNUDJXU2pmU1ZFR2VoREVEYWRkdzhreXNmOGY2eTZwaStVNE9xS0ZDeGhU?=
 =?utf-8?B?Yzk3YWlFQjFGWHF4ZGdsOFE5ZHJYQWp6RXExYnQ1ZUw1M0dEeVlpVWJxdGZV?=
 =?utf-8?B?SkEvQ1h2dGlTVWdWNjhuOXZaK3E5NjhTeXFRTWVtQVVhaUl3WDhUTTc1U0lz?=
 =?utf-8?B?YW5hOU41TDVRL0prZi9IdnlPTGQ1bXJMb1hzdE56NWNaWnB4R2cvV1dURHo3?=
 =?utf-8?B?WktaOUsvMld5NW1waGpJcGFBSW8rTzJBQWZqTHdFVUFHZWZzVXMwYzlIbHl3?=
 =?utf-8?B?ZWtEc0VZanM3d0tKbTZGVldnNUxZMkV5RzNrMlREM2RaMThEMDVub2FHNnJ0?=
 =?utf-8?B?dFVZSE1DMnJRMFFxWlJaa2dWWklONGVvcWxCdUh4Yi9YdDNNcXhYMFVNQ1N0?=
 =?utf-8?B?T2p0cjVPSmY5MmFydDllbkUvLzJjb1lwaVJmenYzTFJNbFJmd21keDd4aDlC?=
 =?utf-8?B?SnNwbUxBSGEvQlc3clR6SjNsMFJIY01pTUhZVWJ2VXNPY3A1VVkrOGd5MW9I?=
 =?utf-8?B?TkJGOEdFRlhxSTFDd0dZQWxSaDREU2RrK1pEU0hMdVN1dys1VENDRjRGdWFk?=
 =?utf-8?B?SWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f894d11-da9f-41d4-1eba-08db02bebe19
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 12:37:26.2852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oJUVz5Xccui/wX4GTcidhJeAbpyqHV1YidsSqBliVokzLkOPCQGKnZsEsoqDJirQ1AAUsbqWQK/nRqXJXxG4qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5460
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/28/2023 5:46 AM, Sean Christopherson wrote:
> On Thu, Nov 24, 2022, Yang Weijiang wrote:
>> From: Paolo Bonzini <pbonzini@redhat.com>
>>
>> Refine the code path of the existing clearing of supported_xss in this way:
>> initialize the supported_xss with the filter of KVM_SUPPORTED_XSS mask and
>> update its value in a bit clear manner (rather than bit setting).
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 5 +++--
>>   arch/x86/kvm/x86.c     | 6 +++++-
>>   2 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 9bd52ad3bbf4..2ab4c33b5008 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7738,9 +7738,10 @@ static __init void vmx_set_cpu_caps(void)
>>   		kvm_cpu_cap_set(X86_FEATURE_UMIP);
>>   
>>   	/* CPUID 0xD.1 */
>> -	kvm_caps.supported_xss = 0;
> This needs to stay until VMX actually supports something.

Will modify this patch.


>
>> -	if (!cpu_has_vmx_xsaves())
>> +	if (!cpu_has_vmx_xsaves()) {
>>   		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
>> +		kvm_caps.supported_xss = 0;
> This is already handled in common KVM.
>
>> +	}
>>   
>>   	/* CPUID 0x80000001 and 0x7 (RDPID) */
>>   	if (!cpu_has_vmx_rdtscp()) {
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 74c858eaa1ea..889be0c9176d 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -217,6 +217,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>>   				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>>   				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>>   
>> +#define KVM_SUPPORTED_XSS     0
>> +
>>   u64 __read_mostly host_efer;
>>   EXPORT_SYMBOL_GPL(host_efer);
>>   
>> @@ -11999,8 +12001,10 @@ int kvm_arch_hardware_setup(void *opaque)
>>   
>>   	rdmsrl_safe(MSR_EFER, &host_efer);
>>   
>> -	if (boot_cpu_has(X86_FEATURE_XSAVES))
>> +	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
>>   		rdmsrl(MSR_IA32_XSS, host_xss);
>> +		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
>> +	}
>>   
>>   	kvm_init_pmu_capability();
>>   
>> -- 
>> 2.27.0
>>
