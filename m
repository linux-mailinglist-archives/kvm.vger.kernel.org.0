Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6135773F301
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 05:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjF0DvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 23:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjF0DvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 23:51:15 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0FD9B;
        Mon, 26 Jun 2023 20:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687837874; x=1719373874;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EXCaCzQO+Ma5uBio7XpFCnsf41pDMzCZ3ifLnaIsJa0=;
  b=GO5nESYAPYD/opqCY1bSfs7+QukKnC6vU7BptQ7b1P/vPpk1Elk22B28
   JvFHp1KPbQpYVwbTAeUCkW50iMzxEeXlc3TFPlWGPBBfbZ0lXQzpItWPO
   vGYRaYpE/WFW9ZHHurQOoMNCQO7YQZ7tLHbXdS0YzSzQo+o7cW1BY/kdW
   xVHqgXDAUZmCsGe5vsa4xeDC8fyHEVWBqRz5KrXaAKMxQ4p5e0iSlk1lu
   emkyRV/6M7W+cOvO9+B0YOuGUW4KNkvYl9vTppwXbl4C9NaO5B/7Ca9H3
   GWB/T1CBtfwGHuzuaSlkwuwgIDv1Xj95VcMjN3Ez7GOrXynm14HnwlWfY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="341805254"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="341805254"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 20:51:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="963007262"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="963007262"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jun 2023 20:51:13 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 20:51:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 20:51:12 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 26 Jun 2023 20:51:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfZXTt7IkqAM1CVUzVvFA6iG0nDd1+IdvGO92OfkteF1zrr0kbVlLapnUSXwkkuB8ZySvtQHC+aGX0fYVj9GPs0dr5vcZXPzgyRWD84WcSQKOo+Yz1mFGIqq5qnjti2kgWrdCng6OtiTwXhgI7zgVBO4VFN+0YjZkGhaVHqSu9DNYPiM00QhOI48t0cmt0ofrY0PeJBtUNfSkWb9VoCe8O62s9edcB0hM6oehmU6tgxManbhI4jWoW13N/UEtOtI+XrDTPAX+YeLli4Yk3/XBLqssJon7fOTBvcZ1qQJhfoRvvsha5B8okfcyo2VUY9e/ayCMuoSP6nZpYTHbHrqzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QXxxx1M3+RYA6DpBfToLLuoPcV0CkdEQKHPCd2gTCDw=;
 b=bvDHE+/cZ4iiuFnozvXyl1VvAviGJ4NWDyAoF4F9kYMKQPNwExStkT4nwZ5uFv/6y9uhdjne+tnc7qGevTqMDNy1K6HpfmZB8XyYCF8J0l83fN36uPHn1wUXbWvymuTn4Dc4AQI9/lYy5rm2lgbgChgIf7spbK6BaIOEiB7g7J6uBFXM5x3tXhAPDMfOYmKogxjnIpFiH3oINY/1uIHYQO308D4P0VjSGBZtRTiui4gAfeIQ0j73QZOJRFash2BNMJOHPaQXEs+Sewnp4mmQdVNu6mL2X/yseECjXza+QrqTvuwhFX0kC+AS+jVbGYXYO9h0ZuJZ2Y8xH2rTbATTNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS7PR11MB7858.namprd11.prod.outlook.com (2603:10b6:8:da::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Tue, 27 Jun
 2023 03:51:03 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6521.023; Tue, 27 Jun 2023
 03:51:02 +0000
Message-ID: <ca4e620b-6d3e-ef30-8d02-c436640bf0ce@intel.com>
Date:   Tue, 27 Jun 2023 11:50:51 +0800
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
 <945384ea-8a15-02cb-66b6-4ba4f22df3db@intel.com>
 <ZJoBFegpUDwCTVLS@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZJoBFegpUDwCTVLS@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0169.apcprd04.prod.outlook.com (2603:1096:4::31)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS7PR11MB7858:EE_
X-MS-Office365-Filtering-Correlation-Id: c813110f-294f-4989-288a-08db76c1ba02
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lqNno9U/M72ZHMVkVOwsbeg24luug2SGGeDMj2omMyYdlWuqX6E1lGbNMiJ019F0+LruAFMaWOzhnZD9ZqM3SArKLjdxFl9er7+6/Y3hmF5x3AbuUGnc/KUKU4IIXNOJ8weo2m9FkRpUl9Gnk6HECNVKDHTGSiDq2jO1L/6DKwdN9nKh3k4w9u66WBclqEfxJzqF6/NG+ISnYn3EjPAgypsnLh4W6sEGQVZpu+0nLv+LiKwJokJP97CdRQUj/VJqNkarmAk+HHX3g0JiaI3gCQZYhTQPAxfhqa7pJk6z65VtrNEtRG/FcdcNAG6rlv4PiCuxvDuvOgSCvc5JKEE0San+KIyJN5Hkq9P9bUac6SNDFiKtDrlkoIl3fBa3qaEcIY8iyXgOK86j3PH7GHkNiC7yJ84Wv4v1aZfCeV7tMz+JyuaZ6Ot4YC0NcW3OPY45wp6U7mqEKUt0zx+dZeImnSKioD7wiWamXeIyJSAZuVdZgGjPNq7w+xnH24NaBK9qqUv4LgKfXgUfOW33I/+CNJD5z100obxKw13NI3rSfcWJJQED1BeU5d0uwm+3bwfzGM11Bmd52nDJSWEglMP+Ro5VGUCaluHPsFu7UJ97xzynDUcy10CO6vE2CwX0AzB1OxFDj5GONZAcLMK4XeGAnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(376002)(39860400002)(396003)(136003)(451199021)(2906002)(186003)(6486002)(2616005)(82960400001)(38100700002)(6666004)(83380400001)(26005)(6506007)(6512007)(53546011)(966005)(41300700001)(86362001)(31696002)(478600001)(316002)(36756003)(66556008)(4326008)(66946007)(66476007)(6916009)(31686004)(5660300002)(8676002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bm11dmhFclV5ZG1XcUt1VFMzaXNnUVNWSjVES3FvNGUxTjNGcnRPbVRiUUxr?=
 =?utf-8?B?TVdHY2ZYb2RoSFRnRTVuV2JYUXY2UVgyS0ZSaUJUT0NUMHRzYWhKRUYwVHU1?=
 =?utf-8?B?UEd2WGNzSjlTSFRuZWY1TXdUNHY3eFVYbk45SHkwL0d3K3MzVFpyQzV6VHd1?=
 =?utf-8?B?L3ZSMUtIenV3U0JVUzVpZGdXK1VRVllkVG5LR3FUTjg3c0NBNTVYVFBBRWVq?=
 =?utf-8?B?QW5oZXNGMVdidGpmMzRrRmN4KzE2eWJhcm1oVy9RK2hwc3NGNHZvTTJkYVlU?=
 =?utf-8?B?cEQ4N0NaNWdIVGZSRnEvNVJOelBpdk5xbDdFV0tjUXMrM2JHVjVjMCtYQkhv?=
 =?utf-8?B?ekNpajBHbzhCNGZpcVBPd0Z1aFdvalBuc2xjUS9nL3FwMWRxM0UvSWJkZEFK?=
 =?utf-8?B?M25EdGNOV2JhZndEOWk5RWJvYUFkL0dyeDRLbHJtNUFteW9EZnNkOUIyQVpR?=
 =?utf-8?B?MHJYdkw5blF3UHk1VmtZeG5WRTVZS2N3V1hPbDJwcTlkS2dSQ09JR2Z5SU4x?=
 =?utf-8?B?K2h0dFp1MWFRQTlHckQ1V3ZuemRtNHIvRnZPcDNBYWVwVmhlejFrbERacDhr?=
 =?utf-8?B?a2N0TUhTSktQRDFiUkEvZVNSeUdHenpWeUxYQjYxY1h0UjVPSzd0UklMZHls?=
 =?utf-8?B?Y2loKzVtcjQ2R0RxOU42dlJxSHhjTjQwVGFCRlliajhCZW9FRHplN3lTQ2px?=
 =?utf-8?B?d3VtSUI4WG5VZVpJRWxnNWRsdU9ZQWpLME1zYkdLSDZ4UzZIRFcxOUU4N2JU?=
 =?utf-8?B?R0FQczgzREdrdXBaTzZZdXlCejFaVUFJMTlTODB3Q3llUFFrZC9UNUJIbThN?=
 =?utf-8?B?MHo5a1NDWTFXMGZvS2FMNW1oS0VyUWJycGVSWUo5VnhHaUtoK2dXODAydkht?=
 =?utf-8?B?SmkycHFDMUV1Yk1JRUlHYmRSS1dMTGsrWnY1WW1kQXZPZ05OQjNsUU1oTTRo?=
 =?utf-8?B?OWhyYksrT1JZK3pUNkNNVDhWUHBzU21QaFZHeGVhTFBMUmNEc2xZNVdiWk5j?=
 =?utf-8?B?RjJkMHhLSG5BWlR1aFg1am5pZDRUL29zTWdkZWFETUJ1OEhiQ1pvbzBGTThH?=
 =?utf-8?B?Zkd1a1dkTmhhODJnc1NHOXR6YXozTWI4b0lrdUNxb0N5VmtIODlDbThWZTVp?=
 =?utf-8?B?M2lLaXdPVzZPc3p6a09yRnpNUWtJUmtiV3lSWXFVN2tFdStTNjBGNXVLNlRn?=
 =?utf-8?B?c09DcW03QUtjYzRRaHBSa2ZNZ1Z4T2o4cCtlUEFuWGk5RlRCMEc4eUwvUFc3?=
 =?utf-8?B?Qnh5VitQS3pUZ1dDWE9zYnE1YjVPU3gvbWtFSTVjNnRLUkIyM29rejhPNmd1?=
 =?utf-8?B?Z2JyUEgxVDc1VzVDNUlITHA2UlNsMnMxVEk3YUt4b2NOQ0dMMzJlTWRDWXJr?=
 =?utf-8?B?QkpBTDQzUUhnNmZ4ZndNRGp5a3Qram1teUUycExodFQvWC9iL2J4V2FvREVl?=
 =?utf-8?B?R2N3cUdha1pRK2ZKUFhSS3BHUkMxM3F1VEVlWEtHdUhpeHpaN0FoZmFmVDd1?=
 =?utf-8?B?OU45Sm1vbmx3bTlxUkZYS1Y5Ny9CbCt5U05jL21ETmtBSXgrZDlLbHdJaFlX?=
 =?utf-8?B?YTVseFVSRVNTQ0Z5R1BtVFg5QTdzM1pFWHQwMTJ0bVVBT2RBM014OG90N1VP?=
 =?utf-8?B?cW1pYWIzamVlTFUrWDYweTZqVFFuUSszUnJZWWNzWGpDS0tOQkhPTk1Udk55?=
 =?utf-8?B?cWVMWXRNVmt5NW8reTUxOGRqZ1IzRnlSNk9uZ0pyWW9aKzNIMktsRkxXV0tO?=
 =?utf-8?B?YU5OOXRjaE85YURGV0tJeDFQTWpISEprNld0NWI5aHQ5ZkR2K1dPWDkzUjBX?=
 =?utf-8?B?anpWRmNPYUFMLzdHUG11S3FIYVFTcTZpU1p0dmVWOUIzV2JuMndZTlJ4elZz?=
 =?utf-8?B?RnBZZjdmUnF4MXd3OWVxcGhOV2VxYytQcUNYeGhIS05ONGFSQnNmYXZmUEdx?=
 =?utf-8?B?WjBmeEVvNWVVRGI5WStyYytoMkFMQk91T3liOTNadEhkNWZuY1Q2SFZ5Qm5u?=
 =?utf-8?B?L0pMNVBkdXA4SzY0RzRNMFJJSER2SE5oSWh3V2xJTWZFOTV5UldzcE1mbm9E?=
 =?utf-8?B?TTlPRVVJNGxOb2FjYkJEOWNkTzlCK2JFMWlIU2xzeU82QlNsWldiNk9Nb0tF?=
 =?utf-8?B?bmxBMGZoSXZnZ2Y2K0gwVUVJRU1YRnpaNUpWa2dNSFB0VktqTVhCVVNxblM4?=
 =?utf-8?B?QWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c813110f-294f-4989-288a-08db76c1ba02
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2023 03:51:02.7548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MV8MRm9QCDGpoV3wybDj32aDDpYFKnHViofLOupyyMD/4mvEFc9CVrhAkEdZHYdj1Uw7LzXdJBy+3AEli4ZHvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7858
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/27/2023 5:20 AM, Sean Christopherson wrote:
> On Mon, Jun 26, 2023, Weijiang Yang wrote:
>> On 6/24/2023 6:30 AM, Sean Christopherson wrote:
>>> On Thu, May 11, 2023, Yang Weijiang wrote:
>>>> Save GUEST_SSP to SMM state save area when guest exits to SMM
>>>> due to SMI and restore it VMCS field when guest exits SMM.
>>> This fails to answer "Why does KVM need to do this?"
>> How about this:
>>
>> Guest SMM mode execution is out of guest kernel, to avoid GUEST_SSP
>> corruption,
>>
>> KVM needs to save current normal mode GUEST_SSP to SMRAM area so that it can
>> restore original GUEST_SSP at the end of SMM.
> The key point I am looking for is a call out that KVM is emulating architectural
> behavior, i.e. that smram->ssp is defined in the SDM and that the documented
> behavior of Intel CPUs is that the CPU's current SSP is saved on SMI and loaded
> on RSM.  And I specifically say "loaded" and not "restored", because the field
> is writable.

OK, will enclose these ideas.

>
>>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>>> ---
>>>>    arch/x86/kvm/smm.c | 20 ++++++++++++++++++++
>>>>    1 file changed, 20 insertions(+)
>>>>
>>>> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
>>>> index b42111a24cc2..c54d3eb2b7e4 100644
>>>> --- a/arch/x86/kvm/smm.c
>>>> +++ b/arch/x86/kvm/smm.c
>>>> @@ -275,6 +275,16 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>>>>    	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
>>>>    	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
>>>> +
>>>> +	if (kvm_cet_user_supported()) {
>>> This is wrong, KVM should not save/restore state that doesn't exist from the guest's
>>> perspective, i.e. this needs to check guest_cpuid_has().
>> Yes, the check missed the case that user space disables SHSTK. Will change
>> it, thanks!
>>
>>> On a related topic, I would love feedback on my series that adds a framework for
>>> features like this, where KVM needs to check guest CPUID as well as host support.
>>>
>>> https://lore.kernel.org/all/20230217231022.816138-1-seanjc@google.com
>> The framework looks good, will it be merged in kvm_x86?
> Yes, I would like to merge it at some point.
>
>>>> @@ -565,6 +575,16 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
>>>>    	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
>>>>    	ctxt->interruptibility = (u8)smstate->int_shadow;
>>>> +	if (kvm_cet_user_supported()) {
>>>> +		struct msr_data msr;
>>>> +
>>>> +		msr.index = MSR_KVM_GUEST_SSP;
>>>> +		msr.host_initiated = true;
>>>> +		msr.data = smstate->ssp;
>>>> +		/* Mimic host_initiated access to bypass ssp access check. */
>>> No, masquerading as a host access is all kinds of wrong.  I have no idea what
>>> check you're trying to bypass, but whatever it is, it's wrong.  Per the SDM, the
>>> SSP field in SMRAM is writable, which means that KVM needs to correctly handle
>>> the scenario where SSP holds garbage, e.g. a non-canonical address.
>> MSR_KVM_GUEST_SSP is only accessible to user space, e.g., during LM, it's not
>> accessible to VM itself. So in kvm_cet_is_msr_accessible(), I added a check to
>> tell whether the access is initiated from user space or not, I tried to bypass
>> that check. Yes, I will add necessary checks here.
>>
>>> Why can't this use kvm_get_msr() and kvm_set_msr()?
>> If my above assumption is correct, these helpers are passed by
>> host_initiated=false and cannot meet the requirments.
> Sorry, I don't follow.  These writes are NOT initiated from the host, i.e.
> kvm_get_msr() and kvm_set_msr() do the right thing, unless I'm missing something.

In this series, in patch 14, I added below check:

+/* The synthetic MSR is for userspace access only. */

+if (msr->index == MSR_KVM_GUEST_SSP)

+return false;

If  kvm_get_msr() or kvm_set_msr() is used(host_initiated=false),

it'll hit this check and fail to write the MSR.

But there's anther check at the beginning of kvm_cet_is_msr_accessible():

+if (msr->host_initiated)

+return true;

I thought to use the host_initiated = true to bypass the former check.

Now the helper is going to be overhauled then this is not an issue.

