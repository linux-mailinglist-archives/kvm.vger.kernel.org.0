Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5447407B9
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 03:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjF1Bmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 21:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjF1Bmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 21:42:39 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B4E26A3;
        Tue, 27 Jun 2023 18:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687916558; x=1719452558;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ORDjZvUTS+C9iOTC13BtVYxQ+7DEox9OsjMiQmHsCjc=;
  b=b6hZeBte+y7a2tOCG4NPuYwZPmLZ6k6Pl8fVr9yupQes5pwNiegIxUmk
   cpUd5A248QnJ+LfDLZMc7meHk/tajOvUloxC1KoO2EgH6DYWXu06DbfVS
   nIeENz3o05S7SH0Y3GPYXDHwpGQJRrPHULhqO6UdDuhCOpfkoNEEa0r3T
   Ph2b4NCJw2Bbh56zKiaFYbaOxg7oTlTrssuHlsZnjb15ysqcpnuz1wZMr
   igNQYBfRMDqiFoIJKGv7ToEY2G7xDwcoN4Pj7YEAjTSSEGvB6EFU8y7DF
   iyG6R7TTUMvgYfNbBqoTz6Spq8I3uHLO5gNKcCxmIZDC7Uh78poMmqyEi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="351507641"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="351507641"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 18:42:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="963411030"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="963411030"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 27 Jun 2023 18:42:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 18:42:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 18:42:32 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 27 Jun 2023 18:42:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2dQ9P4/DdNLDi88PXUgRjlcbYpEmu66mjAGo026qKEU+4grYNz4trZoWF4OYCZ4w0pFiNLqZewKoDlyFdkMuSHiDPLYrwcMRrTjnH5rb1mgaBkf9PqiXrUNSmX/0gIyvQvI5mQrcVgSzSTRmWJMi89JovB5J3lHF88xRabyDFib4t1S8NAuuYl75EPbTAK6iQNIVkfk//eDknLULx1yd4iSmDLyWXi0uLR3Aerikb1YExvlfsk2vuYhTDyR1dyC94kJatbExfxthVsAAnD8SO277abA2tmWSIoJOP0NEJP0ynU5xkAJe8QrJfXRD+0PyQgYINOj1Sr+8HVEL1NQug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=piwnIPqs55/SEcwv4HPblSvnXcZZoQ/79QXbFPSzlyE=;
 b=ePr0KVIco1awqCohiExAtflcY1tmBPH6bX/rEi65G4AC/pwuHKMa5pdk8O4DmsWu8LrKkYYhOg+ts1Hk7VHbruWOvspq18lI+9LE7uZ1T+JkGSA6+Lo12qTGmJq1/DOQmCCPWKhpg77HTZiJqn4jXbwYTQNbv7cIy8taogxxpv5i1WuPHUZnCXRtZbKsmLY+UfL0X4ljMT3PEh0CgKeTD78LYfNZe+2UYI3AE+WVHFIfIh/ygXLzk7vHLCEBQ/lVEvTXnh5yDYyg1diVg5Yho0lixHFlE1MP7YiJBTH0XOqCOAwQwHbN0W6V6TZ0ltv7sPjyYWbm2/EZZGi/zn1exg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB7270.namprd11.prod.outlook.com (2603:10b6:208:42a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Wed, 28 Jun
 2023 01:42:23 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6544.012; Wed, 28 Jun 2023
 01:42:23 +0000
Message-ID: <814ba427-02b3-10e5-31f2-c9ce09137964@intel.com>
Date:   Wed, 28 Jun 2023 09:42:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 13/21] KVM:VMX: Emulate reads and writes to CET MSRs
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-14-weijiang.yang@intel.com>
 <ZJYwg3Lnq3nJZgQf@google.com>
 <9b12207f-7aec-7d46-9b7a-99355bc9d38d@intel.com>
 <ZJn/4qC35eFjfqJv@google.com>
 <44d59b64-716f-fa58-67ee-d66beb9132d2@intel.com>
 <ZJr4WeeLuXYUvzYA@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZJr4WeeLuXYUvzYA@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:195::9) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB7270:EE_
X-MS-Office365-Filtering-Correlation-Id: 5553423b-38db-4730-24c8-08db7778eb2a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mjAKtq1EPVvTeOl+ktkkgF7JAUxpRPUVvCeAIiOo7VdWCN+rdr7N0XgmoAR3MDSQ2NoGDme1Sqkn9qybUg1Iu4KJhbmLa0KiqTEFs4eSodYzUpM2+XUq0ysobd69KeIUsZbGy12sc+mqu4776ZhFQCVOyW37spBd8/cNPeNwHVtOoCcgOsvwmpAo16VnOAL9u3H7xWQy+5AC1eYKx+IgFLd/Yry95epxj527UFgow8FyXt8OpQwT2wN2woAKCoWjeBynrzgyUsiy23HF6M2JLNeKpJ316CoFABbMcQodCdSXhrHcxHhOmvPzGUO4/kTjS6ioSJCUFCufU7aAWTjGlFpTgkYz7ftHUDhrXYz0G7s/epMkTJHfRVINmI8KHYTvqFGEAtV9PoknbjmCQOVyoTFhl9NhpNrBhS96BN5fgW6w8+eCQLTSJCLgT2qwks4rNwK/9wcw8fcHNRflUuPIRXi4NWPBjWYaVMxFX3qt+w0PnijQd7R9YoXx1DwK49ZO93yCdroICYmYeU+QCPOEhiMpkVP7o1QsFCb7Wdz5fJDR6u9LyQKsIyazNueRMYsca93mcIuX2SBi0ewiLUX7GoCGNQZuXKAb9fuEzLEGoP/BWKY4x0kuDghc9ngREr4Klpzd7ovQq2xj9iFEv6M3hQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199021)(31686004)(6666004)(478600001)(6486002)(83380400001)(2616005)(82960400001)(31696002)(86362001)(66476007)(6506007)(53546011)(26005)(186003)(6512007)(2906002)(66946007)(66556008)(4326008)(36756003)(6916009)(8936002)(38100700002)(41300700001)(316002)(8676002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enFSbVM2UjhYY09LZWtBR3FIMStoRW93Y1pLeXZ3Z1prMkVwWWc5WWZ3SkVq?=
 =?utf-8?B?SkNKcXhEd3VaZHRuY0NYMkxicUphcXNpWi9ZQXZnVXRQZ2lwQ0NzbkhMdTVL?=
 =?utf-8?B?T2E2a3NldkUxdzNFUGlDemFGd0lrUHpEdmw3aVRjdnNoU2h2aGc1WkJLcW9w?=
 =?utf-8?B?bmNXOW1iaHFmRWtCU1lLWlV4dzkrZkpNUlhWRXZTSjA3WFJaUHBtZ0l5dENh?=
 =?utf-8?B?STVRUyt4cW9oeDlwcWpGaXAvQlFRUkNodGpVVUwzaU5oaVU0MUJUQndJN0Nt?=
 =?utf-8?B?emlmY0NYVkhNQUJhK05WTGlnVm1qL1hBYkNJQ096blRlTkRtT2JueTQvTElo?=
 =?utf-8?B?VUs5THdkN3ZPL2dOMW10cVc4dngyK09CNjRSZldoWFJCa1FweDJLTFJZV0tr?=
 =?utf-8?B?eU1ia2JaRGk4WDVIK1NZLzVQamVLRm9US0k1L1ZUTVd2VUhBVHkxeEEvNUR1?=
 =?utf-8?B?SFRGV1VQK2oyakNOQVBtZ0NWdlI5Q1psenlKTmxybVM5TU1nZ2xUb1FQN3NU?=
 =?utf-8?B?OXkrQ1d0SElHbExvajdiU1dwZ1pVMitzMHpJVUNrcUtwMHg1eCtndEJWamth?=
 =?utf-8?B?ak50LzlaOVJwYWR5cjZxS3Y4dHJ1K0hyWGJnMzk3b2xiZmpONkJMTHdoQnZB?=
 =?utf-8?B?WlRuN0FCSmp1Mlg2emVjaUtZZDNHVXUza2k3SVo0Wk96OUp2OVpJeDhidHMz?=
 =?utf-8?B?ZW5OcFh5RytpUUZYV0dsdU5nVUFLYkVTcExOVXhKRlRzRFIyaFpwbDVjc0JY?=
 =?utf-8?B?Y2xncnlrTkMycnBYMGhPOEhQZFV3VXByNzBsc3U0Rm5zQWhEMnFCUkV0KzNF?=
 =?utf-8?B?am5vL2tqT0QxUDM1MzUzNmNndTBDNVd1Z2thWVkyZFIxNVpPNHBnNVNjSllw?=
 =?utf-8?B?ZUIremcvU1F0emlEMDU4WUtub001aFJZTHQwVzJNRWdkUWdubHd6Znp5VlQx?=
 =?utf-8?B?aVliZUJibnBUK2RVbzNJdUxIeXU4TG9SeGErVFlyV0tPci9idDEzOEJ0bEFn?=
 =?utf-8?B?THJRbDFLUjVnSDdFOXI5ajV5MGtLWXJOOUMvK1A0MkVranl3emUwbnZYWURD?=
 =?utf-8?B?UTdWYWRidXEwMm1acERKL2Y1TEYwT2lJbyt0WVI5SUpzbzBZMGRFRUlFTjRy?=
 =?utf-8?B?WTdvQnZXeU5pSVUraTdTT2c1NU4vaTlqVHV3cnFvalBMSEVOKzhqZnJ6cnRk?=
 =?utf-8?B?ZEFUeFQrT29waEdUL1doYTFwczNNMXBJVlE0ZmJsa3JaWGY4K3ZXQVVrdi8y?=
 =?utf-8?B?dHNHM21sYngrTXdZdzBxZmkrSlZMd05YS0hyenh1bkFzSWpIaWx4ajJ1b3NX?=
 =?utf-8?B?aWI2bVpEc21wenFEdmNYQUpEUlIrcU8wOUxrQTN3ZFIycDlqSWwvbGppenFS?=
 =?utf-8?B?SVorVktKQnIxdnZzVTFhUUNtOUVpVnZEdEpnQk1ibHhuRGNNU3Yvb3RoZVVs?=
 =?utf-8?B?TERRaldRK2J0aVBaNGlzeG16eU5qamptRWprYWRacFpNcEMzL0JSZFhWSjZi?=
 =?utf-8?B?RWFaTHo3U1pQdEdlaWJZZlZVRXNFdEtEeXZzVW1kT1EyME1ONzhBaUM2blBX?=
 =?utf-8?B?R1JpN09JOHVuampaSFJ3YVpWblRxdnpyamZETnlPbmx6b3hHbjdXQ3REMDk2?=
 =?utf-8?B?UW5hRVNac1U3M1U1Q09pN09VdzFoR25wNkQ4bXdHQTEvaDFmMFN4dS9MRUR5?=
 =?utf-8?B?OTh1ZjM5QUpYVVJnQndWbkZpMUxKZHBFRk0ySWJ5ZlNLSW0wd3dxMVNndERy?=
 =?utf-8?B?a2R6ejZoWWloOTcwNExSTVFickIyQ2x6T3JubXpjK2M3Ui9wRXBzL0J5ZTFR?=
 =?utf-8?B?SWN5b1VPb1BFdFpVSzNzNjVUNkhTQ2twWVdyM3BwUmdLR2RhZ29KMWRPNkRi?=
 =?utf-8?B?Z0RZMnlmVGxjVEcyK3VPVjB3aStubit2L2JsY0tFNnE2aEsxZUdTSi9ZWGhr?=
 =?utf-8?B?dHh2MG52QVBiTmN0WjMzcEhiNThUNSs1SExBeWVMVTVSUVFwTjdIZjFmNXNR?=
 =?utf-8?B?cy9TMUt1dEVSMW8xam14NWxva05IL3l2MHZIKy9acDhhbGppc3krN1FTY29G?=
 =?utf-8?B?WndCdjhCbkNDWmg0b0NxUjhlMXU5VS83SFFNaHBYRHl5R3M0WWNPRTkrMGVt?=
 =?utf-8?B?MW5hNzkvOXo1TGdjT2VyUXM5QlpzTEpRaVNpVVlOMWhYeU1UbXZmMGpVSHpM?=
 =?utf-8?B?ekE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5553423b-38db-4730-24c8-08db7778eb2a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2023 01:42:23.4451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tkjosaB3YYhfYzhygqxzCDIpDf1V+oTqjYh6Dl3X7bp9WeiFxwrs/G3+AjmbXvq+CScUIdjAb5E1AzLxpLZ4Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7270
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/27/2023 10:55 PM, Sean Christopherson wrote:
> On Tue, Jun 27, 2023, Weijiang Yang wrote:
>> On 6/27/2023 5:15 AM, Sean Christopherson wrote:
>>> And the above is also wrong for host_initiated writes to SHSTK MSRs.  E.g. if KVM
>>> is running on a CPU that has IBT but not SHSTK, then userspace can write to MSRs
>>> that do not exist.
>>>
>>> Maybe this confusion is just a symptom of the series not providing proper
>>> Supervisor Shadow Stack support, but that's still a poor excuse for posting
>>> broken code.
>>>
>>> I suspect you tried to get too fancy.  I don't see any reason to ever care about
>>> kvm_caps.supported_xss beyond emulating writes to XSS itself.  Just require that
>>> both CET_USER and CET_KERNEL are supported in XSS to allow IBT or SHSTK, i.e. let
>>> X86_FEATURE_IBT and X86_FEATURE_SHSTK speak for themselves.  That way, this can
>>> simply be:
>> You're right, kvm_cet_user_supported() is overused.
>>
>> Let me recap to see if I understand correctly:
>>
>> 1. Check both CET_USER and CET_KERNEL are supported in XSS before advertise
>> SHSTK is supported
>>
>> in KVM and expose it to guest, the reason is once SHSTK is exposed to guest,
>> KVM should support both modes to honor arch integrity.
>>
>> 2. Check CET_USER is supported before advertise IBT is supported in KVMï¿½ and
>> expose IBT, the reason is, user IBT(MSR_U_CET) depends on CET_USER bit while
>> kernel IBT(MSR_S_CET) doesn't.
> IBT can also used by the kernel...
>
> Just require that both CET_USER and CET_KERNEL are supported to advertise IBT
> or SHSTK.  I don't see why this is needs to be any more complex than that.

The arch control for user/kernel mode CET is the big source of 
complexity of the helpers.

Currently, CET_USER bit manages IA32_U_CET and IA32_PL3_SSP.

And CET_KERNEL bit manages PL{0,1,2}_SSP,

but architectural control/enable of IBT(user or kernel) is through 
IA32_{U,S}_CET, the former is

XSAVE-managed, but the latter is not.

  Checking both before enable the features  would make things much 
easier, but looks like

CET_KERNEL check for kernel IBT is excessive, just want to get your 
opinion on this. Thanks!

>
>>> bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>> {
>>> 	if (is_shadow_stack_msr(...))
>>> 		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
>>> 			return false;
>>>
>>> 		return msr->host_initiated ||
>>> 		       guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>>> 	}
>>>
>>> 	if (!kvm_cpu_cap_has(X86_FEATURE_IBT) &&
>>> 	    !kvm_cpu_cap_has(X86_FEATURE_SHSTK))
>>> 		return false;
>> Move above checks to the beginning?
> Why?  The is_shadow_stack_msr() would still have to recheck X86_FEATURE_SHSTK,
> so hoisting the checks to the top would be doing unnecessary work.

Yeah, just considered from readability perspective for the change, but 
it does introduce

unnecessary check. Will follow it.

>
>>> 	return msr->host_initiated ||
>>> 	       guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||
>>> 	       guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>>> }
