Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776E8655C5A
	for <lists+kvm@lfdr.de>; Sun, 25 Dec 2022 05:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiLYERU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Dec 2022 23:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLYERQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Dec 2022 23:17:16 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74283299;
        Sat, 24 Dec 2022 20:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671941834; x=1703477834;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fjamXpw71hw1qCmj0R1WNtv6q07g+Iys7E9G0EHK54U=;
  b=CIVWMEFqi7f9GLinDI9t+nIkEu1MpJSMJMl9KoRCb3DDjp5zo+fj3H3v
   q1Hkeg0NkwhDU27fHLr8/BCbavx4DOSB+n0ruQ241k/epIBiviqfKCT7i
   MAmzXvx4qZ3KF1C0/OSBfleLXpBiYrOIsw+JeTPksv+qr4Zq5I0OEitQP
   eLVhJr5WuDhGxpvbk3r/KL3p4MXV6dwdiCiEFI5Jvrcv1fp4/406Yf7xn
   cyLnGKsjYihQa4FeVoS/PZbvxy5PHBSZM+Hz/Diwxizw55+DV6nu3t2vk
   aNZpfXm0pzGginKIdOK9jN/jQmb3XQ/sQkVU2HIIOEsiWDvcBIFr2yOBB
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10571"; a="406710875"
X-IronPort-AV: E=Sophos;i="5.96,272,1665471600"; 
   d="scan'208";a="406710875"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2022 20:17:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10571"; a="826590352"
X-IronPort-AV: E=Sophos;i="5.96,272,1665471600"; 
   d="scan'208";a="826590352"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 24 Dec 2022 20:17:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 24 Dec 2022 20:17:11 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 24 Dec 2022 20:17:11 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 20:17:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UhiM5DgF+hmgBVLP0DU+J8uAMODiwGorcsu0xCLeOyafLRQyt0blpihF7FKugF4iwjm33Ed06h4ahdjJJwnUrXQVG+zCumx4FVRlP2pgFj8rbX7WtThNKEUcpBC7o5lA8ChLFBqvV3apigq0bX/VGNIF5D4A/QrVboqe2piycDnGM8u5WvBh2gdr1RcMmdR8SOL/d54tDdOxuIRNas6FvyghDggKG36rMjdBPs33dJg79CyIqTrm8bQm2ERU6Kfdizo2+Cwj0i3udgUcYV/FsEoN0hqSzi/NKs+Lz2BtvJVNz9UrG+EXKp4//nHgypNhGR/cz1BjXy0LqbzpV7znoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hgRjcw/Bp3+1SRDN5i786HN2a/F4YatdB9zpSyuQv/U=;
 b=fsq9vw9THjF7XJFB5bfNvfhjgsNkx6JRVS3Dxw4rcTHgNs6Hta5L54UpYuP6Wt/APywWodhfBbY/xSMDxM6KsbIMspkrh+6dU9499woofarkJwrysNkpC/ZfVdITOOCUQcs4r5tbaD/0jhSAD8Enf4b8ZMWm0/xwzGGTkyvh2T9glx9Q+/GKNZCrwZi9st9v8oHY+SU8fr1a/84WLnsYXzbNXMosIWHiLvH7e8X1UsJNoYDz9ffiAE/1E+TAZmmGRlOLuJbp/kkjGIRt78RUQ+y/DdP7Sk0QUYxavbRAqY8NPmCo8W1LYxOnb8p4xqbCrBlGmuPwrg4TIAUi/kNM4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB5580.namprd11.prod.outlook.com (2603:10b6:510:e5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Sun, 25 Dec
 2022 04:17:08 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe%3]) with mapi id 15.20.5944.014; Sun, 25 Dec 2022
 04:17:06 +0000
Message-ID: <ecac6ae8-ae09-1e8e-4b0e-16f6bc4f2ee3@intel.com>
Date:   Sun, 25 Dec 2022 12:16:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 06/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest
 Arch LBR
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
CC:     <kan.liang@linux.intel.com>, <wei.w.wang@intel.com>,
        <seanjc@google.com>, <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-7-weijiang.yang@intel.com>
 <065de8d2-895e-9ee9-e3e5-16e79969508f@gmail.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <065de8d2-895e-9ee9-e3e5-16e79969508f@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGAP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::25)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB5580:EE_
X-MS-Office365-Filtering-Correlation-Id: f24193a9-42ff-45b4-1188-08dae62ee22b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AKBx6/dJoEVwAcnWcUcoegYEN3vPGCdY3TDYVi6cZkfxifO1PRs8Z0kXv1jFNmCsjuoXw/W/XNwOC0iZ0gMGGGNH6kEDjAxng3J8n3nUXUACnoxPrAXQdB5mf4zGpT4r0dVW/uksQr/7zDqk2DuRjP3Xaa/hzaIk3QJScFeqSyb+Lg1HESZjBLAflEiKbqmzHYkYLuqn/45KnrH4yRkZQ/QHGSm3KOznyHICyTEORm5snkNA5R6VheQ7dEf7QTPxnFELy9Vfg7ftqtmdRTPRXbQLYdQayOLMVyY8whjr5Z0u5rof95z7GFU+DmuingrtCIyj63KM+tsv1re6agE9oKvxY6YW6Y6jo26KKT3t0NZY6T7neD1mnG4mArIi7JBvOvbrwU7juiDvyccnxS2Wm5QctQZ3qKhaIpgeffr8uoVLa36a9sG9XqpxqV0NrJbow9hFj8yAjKW1wF0wgKHH4hlt7v7YjkuubvV+VqZISERysJhGHzDCc7yLl948I/58itcfo8bKeRB2xmvs/ozCqVrTzKY3GMfgOx1p0ikSATR9zPR5WLbJmxovBV6CXxtkk4PMFL9gOzv85E2xTnTZNNIlzlAkS/Uihj/Lcmg3LAGWpcP2KLbqlJQFGiwhX2tl9VdCg/J4m1jsbdh3Qjg3ZDkkyPNjkO70KDbMYns0j8Lula6v14acM04AZohmRpThqTnbFw7tFfXdvPXtnQV58Q4RDrqy+f1fSmLp8fnu0Is=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199015)(66476007)(5660300002)(66946007)(66556008)(8676002)(4326008)(8936002)(41300700001)(31686004)(316002)(36756003)(6666004)(478600001)(6486002)(2906002)(6916009)(53546011)(186003)(6512007)(6506007)(26005)(2616005)(31696002)(86362001)(82960400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVQ5TW9NRXdTaG8vcGlZWWkxeC9CdGZPSjU3cXdDN3RIT0NDL1lOWjZHdUsy?=
 =?utf-8?B?cmgwb2J4RUFRU2lNQWVoQWlKV2V5Y0dKMGZmSkpFeTFFMjJKSlNsZFpyU0VE?=
 =?utf-8?B?L0lJQzJlc2lPMmxZeXRGQWJyeWs4SFFLeTBUdURCcE96MGhDczJNV0pGZS8x?=
 =?utf-8?B?bWNxT1FwSmFIL2JKakpmV04yWjdtQmNCMEIwbVhsODgrNi8wTkMzZFVKUkJn?=
 =?utf-8?B?amxtQWg4cmVqV0Z4dDBpTFVodTNlL1pCUURmM3hnV3U4VkQ3OTd3UVlQMnBt?=
 =?utf-8?B?ZyswQ29tT3d6YW9MOHJ2bTZZLzJONm80VDNLcVdIZWJNN0JUOUZGVVp6d3pI?=
 =?utf-8?B?SXIxWHMxOEdha1o3Qkt4OXY5Q2g4dnRacGFtUGlXTW8zdWQ0NmpLNjhqcXJF?=
 =?utf-8?B?cHNkbVhyZlRmRFA3ZWlnOThNUUtVY20xN2gveG93OHRUMzNoYXdQKzN5UC9G?=
 =?utf-8?B?TnAxeEtSd1hKMGxLRXR1T3JxY1hlUllFcjlWNmNidlNIZkg2VzUwQ01HK0Fh?=
 =?utf-8?B?Vkl0bS9KVC84UGpSQWhKWHZaSGd2cVFJMVo3N2lzZ2F3WjFPSE1PS0h5cHdi?=
 =?utf-8?B?cTAyaXl4b05DTk5qNENDNTRwUWQ2ZzVnS093S0RFSFZIMFBsUktGOFNQdW83?=
 =?utf-8?B?VjBGQlB0N0pBUFltSUE1WUlVc0J1RUtrWHdRRHQrL0RyTjJoQXhWd2xnejdr?=
 =?utf-8?B?eUNvR2VWWkU3S2JPZHJ1T2ExaXhFVytQWXBJenhoNDh2OTJsT3NBRkpNK3Mw?=
 =?utf-8?B?U1orK2txU0hBeldielhlK1ExckI2RlFGU1p1SmhJK0lwbUVGR2QrbmZSUVlC?=
 =?utf-8?B?ZmlOOHlvU2xqT253MVJlMEJoU1BkUitwWFp2Qkt4SFFSRG9OSlphVWlWN29O?=
 =?utf-8?B?ZTdobHREVjRoUFdWOUVoZzJKTFJmdkNsUFh6a3l1ZUd1RnBHV1RicExwdUli?=
 =?utf-8?B?dW51dU5oSUp4am5CRDlLWWd4dC9Ua0tHOW5tV3dtL09oTzZZR205cUJlcS81?=
 =?utf-8?B?K04rRWgxTEpOT2hxMHNKYVpuVm10VExnckNvS0ErcTRqVmlGYWh1SEFuajMx?=
 =?utf-8?B?S2dkblpzWWlGYXEzNU1Tb01uYkZjVjBZSDRIYnhLekVvSVBrTlByRFpId29j?=
 =?utf-8?B?NDRnWXdoM04yQjMySDUvbWVhcmxlRnozNi9GVWtrMnBOZFV5cmM3U1dVVzhD?=
 =?utf-8?B?em12K1UwbVhBZUlEeGhmVzBqRTRGMU9Rck9kS1Z5QkdTZ2xKbE8zMEthSlZu?=
 =?utf-8?B?ZWdWU1V1cmlnVWppOEpjUGlUQU9xb0M5ZG5QbndTVW4xUXl3c0pGdGVaRlVB?=
 =?utf-8?B?bkFjdnJBNGVoK1VsQlNKQzR6N2hhVTVoOEFubE81RHJYVkdsRFpuenl6Tmo3?=
 =?utf-8?B?YTlrZE52Ykxack5HK21NYVBjK2NQYkl0VTN5dDRwbWtZL2dxTjk3QVZTd0Rn?=
 =?utf-8?B?aUd3TFpvRThUMC9rZ0oxWTVkUVNBdmFRQXBHbVZ5WkxyRGNaZU1MMmNvUDJ2?=
 =?utf-8?B?eGlYV09tVGp4cjJHdUVkMkMvN01ZSjlmWi9GdmdnSVRvdFpEYS9paE5LSUlS?=
 =?utf-8?B?QkpqQ2l5M0ZBdmZJdlY5KzRDWWgvcVVmczJaeGNPTklhbGsvQU9LMmRIRVMw?=
 =?utf-8?B?bG1vY0U4SE9PM1RZMDhMdXA5N2tNUGNGSVQwb3pMRERnUEFCcFlFS01IWWpO?=
 =?utf-8?B?UExRMTQ1VUU2RmRMTDRtajl0NjRlNCtJYmJJVFJSY2w0eEtaYnpGQVp3Z0tr?=
 =?utf-8?B?dFVHckgvNWt4SENUbkc3YTI0ck5LL04rN2ZWNjgxc1BKWCsyYzlWUVl1a3lw?=
 =?utf-8?B?Z0JTMVZ0bEpuWmRGMnE2azJqenMzUE83SWRmVUNzNVdlcGVsM24weVN3Ukpw?=
 =?utf-8?B?VE4weFd4RWFBTzd6Q1ZDMTFjdkhad0F6QkRJdmwrd0E5TnFiWVhsdTMydEhk?=
 =?utf-8?B?MDNnMjBpeU5BdEFsYVZMYS9qdSt1RGNVOEJ4ajRnYnZkVTk2eDdlTWlVNTFa?=
 =?utf-8?B?MVJqb0IxTEJ0ZXFLVk1sNlFrUHY3bm9lYStQUE4yYXdCelFSWTNqWVNsUWlQ?=
 =?utf-8?B?NzlwNGVwV0YxV3RSem1iYUpKQllvNkRTaDlXblAySXJTdVQ4TEd4M28xZGd2?=
 =?utf-8?B?SVQvd2cxdjlCZTRrTjhMaHk4emJMSm9ySGF6dmhnUWdjdDNVT083aUxuSVFy?=
 =?utf-8?B?MGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f24193a9-42ff-45b4-1188-08dae62ee22b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2022 04:17:06.6516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YDZaLMQd8q51juK7EF+ywCq9qDlGEk+p4X3lA6iOJJlOcFlBiOsLQyIqrOkUmQVFGTXXjVnNUVQjzC/NQpJSjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5580
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/22/2022 7:19 PM, Like Xu wrote:
> On 25/11/2022 12:05 pm, Yang Weijiang wrote:
>> @@ -727,12 +772,16 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
>>    */
>>   static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu 
>> *vcpu)
>>   {
>> -    u64 data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>> +    u32 lbr_ctl_field = GUEST_IA32_DEBUGCTL;
>>   -    if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
>> -        data &= ~DEBUGCTLMSR_LBR;
>> -        vmcs_write64(GUEST_IA32_DEBUGCTL, data);
>> -    }
>> +    if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & 
>> DEBUGCTLMSR_FREEZE_LBRS_ON_PMI))
>> +        return;
>> +
>> +    if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
>> +        guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
>> +        lbr_ctl_field = GUEST_IA32_LBR_CTL;
>> +
>> +    vmcs_write64(lbr_ctl_field, vmcs_read64(lbr_ctl_field) & ~0x1ULL);
>>   }
>>     static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
>
> The legacy lbr test case in KUT does not cover this scenario, but
> arch lbr contributor should take the opportunity to fill this gap. 
> Thanks.


OK,  will try to add this missing part check.

