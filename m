Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D3977447F
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 20:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235708AbjHHSVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 14:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235124AbjHHSVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 14:21:20 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABD77EC0;
        Tue,  8 Aug 2023 10:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691515905; x=1723051905;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cZfIxP7Lt8aIJjSSmyf/+r54nHKLxM7rCCvsDfYER9E=;
  b=EZuK49CPbGywFr5bn0DaNJQH4GtG/lgrycEhEIidW4092YykJSJ7CmSG
   srNy9g8wMS2yH2zPTRkXZifH8Auksngj8IqlLhlfYGZ+amSzvDlrs4FgJ
   esjEnCDEjhnYFBqa2fQuasXh5NKXlKfZZBYGI9x/ZrK3H0p4nj6Lrv7Wo
   cRXBn6gcIG1qQNFzglNtMYxRQXTapAFWHYbEra4zBtGFGunNhYPi59+U9
   rNIy46dgvDU70Ko6fQTUd40kNRxFjl7hxdKRuo9iNSRLKXXiB0bmsN74Q
   ZK5ZBDiL3QZ23MRjUCQRboCD8fXr+mF2Doy3Kkgh6DTRaja26nGI9XB8i
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="434705492"
X-IronPort-AV: E=Sophos;i="6.01,156,1684825200"; 
   d="scan'208";a="434705492"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 08:26:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="724958865"
X-IronPort-AV: E=Sophos;i="6.01,156,1684825200"; 
   d="scan'208";a="724958865"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 08 Aug 2023 08:26:49 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 08:26:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 08:26:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 08:26:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k98h6QN1zfFEyAdElzER6O2rHM9uazOPf8c/hq1tlFxZzKQFPGntqHe20tpzcABwb4itUgoLkD7zG+n7YkP7GZqkKReNG2tVA+quZMtBnOVAKyiJ4bAZggadSzAYWujcrrWi7mCcecw3O3RzZk7AyAh7PRbl4o4heIAiVhgkO0GnOXIi8qi5HWdcqs+CJoKGNsbA3UgWonsX0F9nFK9iXLrMUW1OmIZy6lhMxRcDk1oZoTt9hMqQBI/86QmjH83EZokzhlKlaIOhuQ62fNezqJHDXCvpL2TjSln/sBXnUvjKkDWSKJ6feEff4QmX7m1Bh+uA3tY2njMfDpqagpcDAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MlucIOcRMhSDzOs+tbF5/nOqBPAlGCT48hx8lJG0tFg=;
 b=eLc5iXmKzmxud5hAMYj9sIC5MVD9RiBhgynC2gXLpYIlqCN5CNgAzDBxsP40ylifvWQtxVTsQR2GN/9kjL6CBfXXONUvNiDnQdD3LGcFHGDAdLr9/jVO44myHnijJQ9ToinidR/S2pWYNFHXwOlU+PJkK0xSz1egyMWZs+cLO5BPHOAKODGjWrW0av9jkdA9dIVfgiySbK4RRM+AnTuW1fQKwnNcshp15C/bBzxnaa/dhzxSD3iTxWk6Oymlsss0NcxKdRXux/L1V9M2FavyWHMQfaPO+A++ejwbnfyqSuHWV+ILZBSCmnrextuikoYbYR7zjl//bk8PY1g45YXpSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB4974.namprd11.prod.outlook.com (2603:10b6:a03:2d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Tue, 8 Aug
 2023 15:26:42 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.026; Tue, 8 Aug 2023
 15:26:41 +0000
Message-ID: <834e5b99-e3d9-2608-ed8a-af7de00cfdd4@intel.com>
Date:   Tue, 8 Aug 2023 23:26:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 08/19] KVM:x86: Report KVM supported CET MSRs as
 to-be-saved
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <chao.gao@intel.com>, <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-9-weijiang.yang@intel.com>
 <ZM1JmxzyMgTLeEIy@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZM1JmxzyMgTLeEIy@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1P15301CA0049.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::6) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SJ0PR11MB4974:EE_
X-MS-Office365-Filtering-Correlation-Id: 71b3b36e-492f-4d22-3a93-08db9823ddb8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8R15UlxcZmM0VOPZ8fz75MjUnvx2mDswL3AiISU6eqNm3uRAWA4+Hzz0Ixduyh0usIgL5cd3xd0XHCdauYRlsasVVl1XXC+x4/tTctWcupK1GDwdrxbQ277Upq6JvnNnRCrHYFCAvsdvJxDEATLJe0VLnCSbPe3uhwli+S393CcXf0FWi5r0XtueIExFqC/toActiGDFRU+hxj8Bi6Wrds9WOcmWvWKwe8GqabnQeaabkiqwQlnLoKjJeRVLAUJMu7PkVvEpvbE48w+s8q0eo7Mge+1mjxyep0613h5JjXKz30/FTaSdJdGmT+NB06KwE5QOPAO2CXWHzQ4TPSWKr7Xgq4gNPiTBCSsUjsWdK1JGG2KTn4vCn140jmVasJoOwzhEr/HgCMx2I5TAu0MsHrNni9BemDEXLuvAHPXIFQxSPlAj20yuinR9KR2ikjXu2K9bcrkLw7/qfaLfSZmRNWi2FCQzeVDJwpB53IYJMBSIT5ennlDSUKostASyGw9aaFSNv/SeN2D5hSLnirRQKs5HBt0HSD5YEx+ddxBZPYY23cyHV2bC0WYdbBsneY4hFrhQ3pCNlFT5sIUCYGzMbg3oLjVDT198A2SnFpEtwrkN9Ao3LdOmI7iueZqaDZZJWqaSg+MNUsXqjOFVEf+Yew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(136003)(366004)(39860400002)(451199021)(1800799003)(186006)(8936002)(8676002)(5660300002)(6916009)(4326008)(41300700001)(316002)(31696002)(86362001)(2906002)(6512007)(6666004)(2616005)(53546011)(26005)(6506007)(6486002)(36756003)(66946007)(66556008)(66476007)(478600001)(82960400001)(31686004)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFJPSXZiZlUyKzlrNkhRNlh1Sys4d2gxb05XRGt6RXBvZ1NQMU5Zb3Bjb2pH?=
 =?utf-8?B?ZHFscUJMeFMxQzdqcVMzcXAxTnkrNXIxVThWMTNrRkF3eW9BTS9KL0Q4dVU5?=
 =?utf-8?B?bEhpVEdWYU1uV1RnZjV1OUs5cGcxbGZzL1lWWG1aREJENFkreTNSUjVscFZu?=
 =?utf-8?B?SzQ1dmpVM0RaZllOYW9lN0hHVTZOVm54VnNDazk3QjI2aG5Ud1VtWWlFeDBj?=
 =?utf-8?B?SFNqd0cySThxUkVwd0VxL3dwbkowaVRNMUFqL2RyVmZFMFVFZDVrSGxzTC9v?=
 =?utf-8?B?ek9QQzRvcXlaY2tzU0N5VjFhV2d3VFp0enZFMjNyOUlzWldBWDBKQmtaSEVj?=
 =?utf-8?B?NUplTkxkeU5OQnU4Mk5WekxRUlZtdzIvYTQ2YUJSZWJEMVBrWCthZXpBdHNQ?=
 =?utf-8?B?d3JlZ3dSdGFpWnoxZm9uc3lpbVdQYkxLaTRIM0tDeFNDc1ZOQ2JVckFvSkNY?=
 =?utf-8?B?YmRrL2w5WHhUSHRDTWkyMWpveTlvT29KVEhEbUxTRzBYcDRRTytPeE14dWVL?=
 =?utf-8?B?ZytPSmZ0eUpkbzJhckJUTEFQalpIaHhIQlJqbi81UVE5Wm8yQ1h3OTlGRE5H?=
 =?utf-8?B?M3hoM3hoSzdDWGttbTN1OHVBanJoc3pFNzVnUFVZSGdHQTZCVyt5eTNEWmRk?=
 =?utf-8?B?ZHp4eEMwTzNQOVBsaFRXYlVvYnBPdHRKZ01xN0ZBTk52SVpvTUgyblNJY21V?=
 =?utf-8?B?emNFblpTZk14Qk1zUnFxQ3BaOU4yVlhlWktsVDVCaUR0M3BQa3V2VGpzbStu?=
 =?utf-8?B?OWFKeTNBajVoc2J6ODBrK1ArSFZjRVFhUEFFUGJpYUJlVkNkNGk5amJtdlRN?=
 =?utf-8?B?cHF5UDNwQWJycFQyZ211V2tjNmVaNEFlMGFWWkFXWUhoVUZtaEswK3lmVG1P?=
 =?utf-8?B?RURKb1RzOGEvMWVJYzdxUVY0OVpjalpMRXVsckpWQ1NKSlBTeTMwaS9laFdn?=
 =?utf-8?B?WTFKUjFOUElYVjNCdTRqUG8zdWlrTWZ4dWJPUTRsN24wazRMblR6SWhBcEpV?=
 =?utf-8?B?ell4eGYvQVJtZ3pWRWljZDFDWWZRRjZNVmVhVElCYmNPZFBscnNSS0NYd04r?=
 =?utf-8?B?TVdTTjBaSEFaSEFHMmFQalFWcWkvVXJXaFM0OExHVmZzMitsMjlOUTdnN0Fu?=
 =?utf-8?B?UGJOZHZHWG5RMlphNmd5TFpMY2VJdVR5eXZXd1VjZDFYa3FnMDVRWlpCMXVW?=
 =?utf-8?B?SHRLN3UyWGJ1UnFHa2lWNnpEcGJOeUJpVHVaWGNxaVFrNDBmNkxZbEllVEdr?=
 =?utf-8?B?QzNXbXpYQloxSUFLM0FtcWF1MGtBM3d6VG0wZkRoWExrYitUZFhSY2ZEU1g3?=
 =?utf-8?B?TldlTSs4dllaVWNNVkkzS2F2UG15eFVNejUyaUJRYU90ckVzOWpMSTBtNWNk?=
 =?utf-8?B?YkpuVzNtRmtHSVd0WEI0V21EWWE3dGdHZjdtd1ZVR3M4SXprcUU2bStJakg1?=
 =?utf-8?B?NDIrMmppM0RHWU1GaFprZ0x0Vmt6UnpKUm0wbmxFN0dkNmFhRXBoVG0zTFVZ?=
 =?utf-8?B?K3lzaXpMbndKUUpGeEx3SkN1aEw5S3FmR2lNNENLN0VkT2R2R0lVb3BRL00w?=
 =?utf-8?B?cTFzRG4wYnNRb0FmamNsREo4MXFHSXlyeW5hSURtbGF6d0c1NmREVWdlcUVU?=
 =?utf-8?B?aUw4WTd1Nm9Wa09Yc2JXallsN3VtS25WVXZkWEt4aXRzcU8zc0ZKZVRady82?=
 =?utf-8?B?YnpJTCsvenErMVpHRW1MNUtBdlJobkkrVEdqbk1mcFB6SkRkZzIwVEp2dVFT?=
 =?utf-8?B?L2JqaG1rM0lOZmJYZU1yMGxsT3g2NzJKNVM1Tzg3QkhxajN6SHFoN3FlNW1S?=
 =?utf-8?B?dGk5Rml3OHRCZGdoTkR6bFVHS0l4bFNDaFE0TFE1b0o1Y2oxWU9OS3N6S1J2?=
 =?utf-8?B?Vk84UHNCUlhERjdUdk4xZnUrbDR6Q2VCK05tNFV4RjFYTTdlbDBvekJYQ1Mz?=
 =?utf-8?B?WlBqNWd6R0FTckJKNlBOK3R5YitHVzhoOStKZTZhTVc5UlhXNjFaWUsxMmpp?=
 =?utf-8?B?Z1gyc0h6RHlDL3NpOXBSVG1YSTJobHVMZEdvaFUwRnAyZWN1eURhdzdzNktK?=
 =?utf-8?B?R0lTNEIzMUhtT1dYK3dyc0hxa1F1ZERLVkVWY3hpYzkzOGhaQVF4eEdlc3U1?=
 =?utf-8?B?L2thMmlMajZpUUVXd0lTYWw5QkU1WTlUL1dQZXQrN0tOSzkvTDlHdk9UMHJG?=
 =?utf-8?B?d2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 71b3b36e-492f-4d22-3a93-08db9823ddb8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2023 15:26:41.7255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gvWn1A4HcnqUKNoehUlz2BCHW9zsRPahQ2qTJRq53si4wKpzUkgU0kjvBkOPMao4/Dw3fN3htLkwQGhiQXYgWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4974
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/2023 2:55 AM, Sean Christopherson wrote:
> On Thu, Aug 03, 2023, Yang Weijiang wrote:
>> Add all CET MSRs including the synthesized GUEST_SSP to report list.
>> PL{0,1,2}_SSP are independent to host XSAVE management with later
>> patches. MSR_IA32_U_CET and MSR_IA32_PL3_SSP are XSAVE-managed on
>> host side. MSR_IA32_S_CET/MSR_IA32_INT_SSP_TAB/MSR_KVM_GUEST_SSP
>> are not XSAVE-managed.
>>
>> [...]
>>   	}
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index 82e3dafc5453..6e6292915f8c 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -362,6 +362,16 @@ static inline bool kvm_mpx_supported(void)
>>   		== (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
>>   }
>>   
>> +#define CET_XSTATE_MASK (XFEATURE_MASK_CET_USER)
> This is funky.  As of this patch, KVM reports MSR_IA32_S_CET, a supervisor MSR,
> but does not require XFEATURE_MASK_CET_KERNEL.  That eventually comes along with
> "KVM:x86: Enable guest CET supervisor xstate bit support", but as of this patch
> KVM is busted.
>
> The whole cpuid_count() code in that patch shouldn't exist, so the easiest thing
> is to just fold the KVM_SUPPORTED_XSS and CET_XSTATE_MASK changes from that patch
> into this one.
I screwed it up when tried to make it clearer :-/
Will do it, thanks!
