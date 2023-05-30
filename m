Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD019715443
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 05:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjE3Dvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 23:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjE3Dvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 23:51:39 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A68DD9;
        Mon, 29 May 2023 20:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685418698; x=1716954698;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cE5ZoeQ9vhlZRuUJ46vJkUg7ErLNaq5grsN4X1Wcn6I=;
  b=TeB5q6J0eicM88KIfyIGMYsqsQYKcI7CA4F6X1RA9/lgKwm2TVTQvyAq
   fE460FtxjCRDW/Fqfy3C7TsWZzdVS/uJQ0ajTAezqCZodaxWDwgqtPp/j
   0dqIyjI/+GDdhsULHhAQwIDf1rndy/7TuykjHVc4DVK7HrRouiiGlQQ10
   D5A3Zl/0Sm1VubDeiSbktA52pZQ0MEcLts9pBvfEf+vj1t1WLJMU9u0UH
   2aHcuB8bHkNm5wwcGL75rUkaxnZ5MtOGc8T7B8tbGw5q4OuaKaoe94nnv
   Wl3VHo6RoFkRljMU747sf7kDKrVfk1aSTu6Fq8ZaHhqIRRiPN3GpgPViM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="354824187"
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="scan'208";a="354824187"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 20:51:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="850591668"
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="scan'208";a="850591668"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 29 May 2023 20:51:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 29 May 2023 20:51:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 29 May 2023 20:51:36 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 29 May 2023 20:51:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDVw1wMpuFNL3Sm25Ev1jUEdHmuAJUYiqrYhFfxvohxS5gIny34bBDY4yDkNMsdX4hwCAvW1AVPCH3R8BJ06X2mm/twNFTxLpO9P+kbnlGjRXXauDmq/tXlkYlWK8u7EjfneOKOvhQRLTqTxuL0GMuQmJL3zN9odtV8YoOYem1Mk9cD85HTarkxRUXWanTnG5dXu/74r2WDtZ2Tytt/DVn4kMpNE2pXf4kalzYCH0ZAX4epdmuD2RLYCbcAiRKda1fJ7YojL4pmet9OS1nOgbOCgfF842fdInvZUDPLPd1SjPtGixAOGUsZUF5+u9Bit51QBohIbU4udjQNfMoX8nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mvEjSCEEv1WQQKNvVKRyFS1qeqegQ3ibVtRw1rRCkkU=;
 b=EYx08ExuVprlwK4yLYgw5aVn6ZoYUfqV8JwVgG3mcSooC5NhT+yZb2wwky6AzDzr4onQ3KLuqOGmO1eUhmt1oProbsWKup0ZlzFJbtIlMFbzXesYD7TpoQmXp94GqCAAJC9/csts2xxT3Oth+p1wWzU7EuqSt+WkV2PtUKo5n1Up1kvVJnNHRmWXTU0Dy7vGn75f/woOdXC6+vSK73rUFCr7qENIp+uHAzW3qJMP1BU919JY+UxjuRekSYrqUOfJIc9mNNQlTDiAM4K8OgxczL/Nr+Yxx8VRxOT53dHbduncYFMjMn19lW7Zy3W2YKGqn+OLuZXn0v9mudN1E9ZG7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB6677.namprd11.prod.outlook.com (2603:10b6:806:26b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Tue, 30 May
 2023 03:51:34 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4f96:4b14:c54e:6261]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4f96:4b14:c54e:6261%2]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 03:51:34 +0000
Message-ID: <23169e5f-9793-9486-fd5f-287e3317b837@intel.com>
Date:   Tue, 30 May 2023 11:51:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 07/21] KVM:x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-8-weijiang.yang@intel.com> <ZG77wu4PyBn1z587@chao-email>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZG77wu4PyBn1z587@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0193.apcprd06.prod.outlook.com (2603:1096:4:1::25)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB6677:EE_
X-MS-Office365-Filtering-Correlation-Id: e08b29f9-629d-4982-419e-08db60c128fd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D47M8ZUPHSLciuqzmiU8eNcCcBgbtCtDN2M65TuojJPz2Iw7485eQdpgLzTcdzAmjY1zhBb42XF3oVe56fu22GdYxCfJNL30brQRCwTpUgyy8AKdTkpC6at5sKiAuKfKGmiPwr+lD72jktuU6S1h8rIMhfMICho6N6Sbam088Xjflcp6QpI0ZtXTD4Y7bs0Glc1h3Wej7VqZmYsy8T6HSAtYCONUDHOjHcN68025XM1IW5J7EkOGJbY1+MI7j96P/I+fG6b9fgNpSn4AjHhYMNK7JKitmfKF/uCfZjjTxJ4tTlK+/OW8YGkkvO0GHW5wGhfcqRgU0QaZhygUccq8xcQrjfzzJt9YXFnFpNdUU4L4xtv+XdoX7ExEeLyz+yWkvpQTde8QQbNaBL6iRbxnrRcYGNSizzQbVzDZ33I9qWRRrO7hcn4hjVnL2a4FX/gmjYnSlad5WkzdJUELHSlzG+n9I6cJ9qFSaVMoLW5ijm9zSpOQPD4Wg++zEjDBZT9cubzbsLYaLvHfCg/ZF4ylSXmne6FkTul4/0lvz8ZILE5W9QK7Scx+1+QgGrmj33zAvmW2iQfZ8CFMJyy/QLLE9OxlmdxiTJzrJrY5ysfp5PSvEnhZiPAA50daiacP5hygismYufLb+gPdOgKryWYF+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(346002)(376002)(136003)(451199021)(6512007)(6506007)(37006003)(31686004)(186003)(2906002)(2616005)(53546011)(478600001)(26005)(83380400001)(86362001)(8676002)(41300700001)(82960400001)(38100700002)(6486002)(6862004)(8936002)(66946007)(316002)(5660300002)(6666004)(66476007)(66556008)(36756003)(31696002)(6636002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZldmazNjNldNVjVLaWgvZ2ZGbVh2Tmp4a3dMT29Ya1I1ZkZ2bEViT2dwVk5a?=
 =?utf-8?B?MFkxUWt5VG00MXF6WTJyRkVoRGd5ck5VeEx3c0ZNQkI0MzhjOWRjUm5KcHVM?=
 =?utf-8?B?OU9FYkM1M0kyVEtYNGphTFZkbjFNblZpbUF3OE85WWtFTzJlU2d0TmVGTTRh?=
 =?utf-8?B?ay9YMEdva3M5YWI2QnEwYjFQRmhjNmo5a29Uc3gxaG1qdTJzY2Zhb0RXTXVu?=
 =?utf-8?B?b1RlSjM3U0VPWlUwd0hHNWxqZitQbVJOeTRTbFBiWVJYL21oSGRDY1F0ZEtB?=
 =?utf-8?B?b1U4bi91TVR5VXJ5amFubkJaMlBmZTBsWFJHTVJWdndwT004NE9sSWIwL0FH?=
 =?utf-8?B?bjJPWFNXSVpYdy9kNXhQSkRYaW1JRW1WcHB6dHFoSGVTL0prY1VMd2FPSm92?=
 =?utf-8?B?TzByOHRmTk1UTy9uSmFwTkFTOUdibGd4REdhck1mT09lYzAzSEVxbEQvVjY1?=
 =?utf-8?B?UDNDdzBpL05leEFVOGw5QmgxWXpvRlU4ak90L0RpR29xQURkZnVzSzhCVnVh?=
 =?utf-8?B?dy9tMXcreExkYkpMWFZJbzZ3S2JQeThuc0dPNEluWHVuMU9tKzcwQ2J0WEll?=
 =?utf-8?B?SXBSZC9HZ2lteDB3U0I4L0grTUJwNmpyajcrdlROR3pLYXhpSXBxTXA3c3Jy?=
 =?utf-8?B?UENzRDk4bE5Kc0JVM2ZEakJHUjZ2N2YzaWtvWDhzUERRTmJVM3VYcExnc2E2?=
 =?utf-8?B?aFhuRGtYK3c2djd0ZGZieVdxdnNBekpMWDlUSGhQS2VuZ01XejQxb0xXdlJV?=
 =?utf-8?B?eVA2V282YWN3blM5TmM3YUwvc2hzU2N4ak9tckNjcXMveWhWTVd4VnB0aVVL?=
 =?utf-8?B?OU53M1lmS0lFelhHa3lSRmN1eDFadHg1S3B3NnNiV1o4eWJLTUMrZHI1R2tS?=
 =?utf-8?B?N01QZDFVMzZNMGRqSGZwVE5aZXdlUjBoMTl0c1NBT1IrbWMwMVVtQUxyN3h4?=
 =?utf-8?B?cFQ2YnNIMTZ5aUMxczdBQWg3UXh6Q3BlcWNUV0dEdDVseEVsNnIrd0IvQWlX?=
 =?utf-8?B?eHJZQUhsZkgwYVJlMkdCTzdXWkc2blB1MFlEaXlIbitza0NncFhQMVZ3R1Fm?=
 =?utf-8?B?N2MyNmQ5ajJ3cldQSkNyOStKbW81TXFuemFCWTNxYjZKdlhONXZHb2ZjSkFE?=
 =?utf-8?B?cEFwVUpVUmlTOWRLcVlpaC85dDFjcFVsOTdrLytpL1JzWUFQZ2o5ZGgyS3pv?=
 =?utf-8?B?Y1lJeE9xL21pNXdzc1c3aGlpMGpBckUrMmtGSjhlZUo5ZGpnOGE0MjMxZTRa?=
 =?utf-8?B?UWE4OUZZRDFUNkxBYUwvSmo2K2JJR2RYeEVzdDlLVE03Z3RXQzk1MGNJRHp0?=
 =?utf-8?B?b2JzN1YreU9kenhnYkhrR0pZK0JpT3RZSkU5NjU4ZzRHRTlaRkNIZnJpSlZv?=
 =?utf-8?B?NTUvTXltQlBSdVB0Uit3UUZMVkdvS2kvN2NPVXlzMG11NEE2LyswTEVvWWc5?=
 =?utf-8?B?M2tNaTNERDU4QlNuOEIyaTZSbUlWMzZZbEpRSlk1TUtyQ2VlOHorbmV2dldv?=
 =?utf-8?B?VElsT1Q0bFphRk1xd2NRQUtZRk5hV3JhcVNERVFpYlNFOHBTSEt6VFp2dGRL?=
 =?utf-8?B?UkttOE1qZ0k5WTdMczFqU2N6MVd1Q213djNjOHBwRytCMGh3TDdHQlhldHVS?=
 =?utf-8?B?YnlRcTNHYWQ2WVJyUFFYUXlQell5am9tVTRTMno3U0NqKzl3OHdNN3JqVnFR?=
 =?utf-8?B?M2NVbnRITmtFRXo4T29OS0c1WFNmelN2WjNrWkJsSTFlMmk3eU96VEdyckVW?=
 =?utf-8?B?aEtXayt4ckhnSVRpM2VQcDZvZGI3Q0dFZmhhNXp5S2p6YUd3aW1LcHo5MlpW?=
 =?utf-8?B?Rjd3d29VTVpQVG5POFJBN0hsU0sxeHZSVm40MklXOEY3Y01yTlhoMGNMZkNu?=
 =?utf-8?B?RUtNYWtMbkNWcDZRN3ZPTlZMSjRmQTRQdGIyamtrV1ZINHF3K2pWQjcxNDNt?=
 =?utf-8?B?c1h4aVhOSlBBMnFtZmNjRkMzSWRCZldJeGwrS0pyTEYvamtkSy9pd0RaWVpl?=
 =?utf-8?B?bE5kM1FEZlNUbUgybzRwclUzSDhoanluVWZYUmFmVytQb0I2bHZSZ2VtTzFP?=
 =?utf-8?B?ejM2Q2hxOWk4TmVXN2ZiejBIK1Racks3NEt5YytFYlVaY3VFUXBqUEhiNFNB?=
 =?utf-8?B?VC9OZk1WR25qWk16cVBURnlMNzNwZTl0UUlJZDJvZXZWeCsyaHo2eUNoS3dy?=
 =?utf-8?B?U1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e08b29f9-629d-4982-419e-08db60c128fd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 03:51:33.8805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vS6ZH6JQTxaRgQrnN+/pMIg240VKfGv1cFunGWb43aZIYmYJ+zdpAIyZK8wGceQP6QVVeWYxSFXW/NwU1kRH8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6677
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/25/2023 2:10 PM, Chao Gao wrote:
> On Thu, May 11, 2023 at 12:08:43AM -0400, Yang Weijiang wrote:
>> Update CPUID(EAX=0DH,ECX=1) when the guest's XSS is modified.
>> CPUID(EAX=0DH,ECX=1).EBX reports current required storage size for all
>> features enabled via XCR0 | XSS so that guest can allocate correct xsave
>> buffer.
>>
>> Note, KVM does not yet support any XSS based features, i.e. supported_xss
>> is guaranteed to be zero at this time.
>>
>> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>> arch/x86/kvm/cpuid.c | 7 +++++--
>> arch/x86/kvm/x86.c   | 6 ++++--
>> 2 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 123bf8b97a4b..cbb1b8a65502 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -277,8 +277,11 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>>
>> 	best = cpuid_entry2_find(entries, nent, 0xD, 1);
>> 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>> -		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>> -		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>> +		cpuid_entry_has(best, X86_FEATURE_XSAVEC))) {
> Align indentation.

OK. Thanks!

>
>   	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC))) {
>
>> +		u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
>> +
>> +		best->ebx = xstate_required_size(xstate, true);
>> +	}
>>
>> 	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
>> 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 33a780fe820b..ab3360a10933 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3776,8 +3776,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> 		 */
>> 		if (data & ~kvm_caps.supported_xss)
> Shouldn't we check against the supported value of _this_ guest? similar to
> guest_supported_xcr0.

I don't think it requires an extra variable to serve per guest purpose.

For guest XSS settings, now we don't add extra constraints like XCR0, 
thus all KVM supported

bits can be accessed by guest.  There's already another variable 
vcpu->arch.ia32_xss

to play similar role. In future, if there's requirement to serve per VM 
control purpose,

then will align it to XCR0 settings.


>
>> 			return 1;
>> -		vcpu->arch.ia32_xss = data;
>> -		kvm_update_cpuid_runtime(vcpu);
>> +		if (vcpu->arch.ia32_xss != data) {
>> +			vcpu->arch.ia32_xss = data;
>> +			kvm_update_cpuid_runtime(vcpu);
>> +		}
>> 		break;
>> 	case MSR_SMI_COUNT:
>> 		if (!msr_info->host_initiated)
>> -- 
>> 2.27.0
>>
