Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E3E76DFEB
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 07:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbjHCF4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 01:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbjHCF4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 01:56:35 -0400
Received: from mgamail.intel.com (unknown [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D6430DD
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 22:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691042189; x=1722578189;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CiujWSWA8Xcf+SzRlpqwO9zt0M2TzlSrGUtyUNdRQ7Y=;
  b=d/2wxAgC6RUJmMtCMNdjgP1A/h4nnUbg7ThSuWewP4enDB34lu2XW9lO
   H/kJBne6aIB3CATWnDhsjaaGiv5iZ4YljpO9FawYb4gQ40MUxbJlMOhJ6
   qurKzIaiAdQIBgkCTAj2YgL/65IF+SPT5tKEvsKARRiItVCWaD6bj13Lm
   L4f3LPnwJScmB6BuTX3FOCC+bpHvxSlJKhyvFvm8JE9hbhNsWv1+PrnqY
   T7OCDUEu+yq2U0yauuITweuG7Ph2en7Y8Lw2nNlOzEkeUpml7TPnDo10H
   fx6Tyl8N+KHZLWVTFlTTcwyW+LDmaA7TvsdBqFj4IFkRHPRRSsm7hWIz1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="456151652"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="456151652"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 22:56:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="723109008"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="723109008"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 02 Aug 2023 22:56:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 2 Aug 2023 22:56:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 2 Aug 2023 22:56:28 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 2 Aug 2023 22:56:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOcU09ZvWwItO+6zgzqy/Q4ycqT3Vo7r1qo2hS+E/nMb/UM2AQnMN4ab4du/bc/QP5GjYX2WvayZOx5/tAr+dw4AuG99HS2o/kL/DAPMKfDAtY4FYMGLybFDSihNL1uevdYthMuRt/PznNsaM3iGEVXhrN6C5eYRtubvOA6qfghF+XM5v8SsKAqWbzJ3nUnoyBovPmER09iEYKE5t3dsVzwmYjQibMYWiNvZApq4DM3h6Kt7Z5TJhX/+Jea/1cLpMF34rKd1Ssnkb2ITfWNiGzcVdezbteFVansz0OSszn8ouvSwr/NrB0zCPAtXWMjaUW38jJmRf2SB8xr88jK9iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tjWE+0Xp3iWFquLhuvIsOWbAggV7w4DtANxDePicdoI=;
 b=hgq2LAkK0awRmjVmJkH/7/q2JWSL15LQ5A1ldJ0sROVL4PXFMljOKUwfdaz+rX6nOEAvSJjFgtDumno/FPXwNrHIfFdPS3vyvgdwcaAYdbGnyoxqMSGbGadlndRxWG8nzrMKPbhfwNRxPQJ1W4bhjqCPZVqUW8qAvdERr4HW0tP+KwRfd4W547I4lc1Pdd+uN6iF5lF+8f9BQFZVcTyvL3mWwkhmHhogpx78jIyA9K1ZzSoxdMiDzLCTE7XQD2c20GptOhqB1w8uESEGp8sjUaU3k1a4VK96RtVgMyCAmW4SQXSOOyqFprdlp8j3vDmydmaTuym6jNtNd0bCDN+Rjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY5PR11MB6186.namprd11.prod.outlook.com (2603:10b6:930:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.20; Thu, 3 Aug
 2023 05:56:24 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37%6]) with mapi id 15.20.6631.045; Thu, 3 Aug 2023
 05:56:24 +0000
Message-ID: <a5bc09c4-cc24-1e70-b70f-dbbce4251717@intel.com>
Date:   Thu, 3 Aug 2023 13:56:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [kvm-unit-tests PATCH] x86:VMX: Fixup for VMX test failures
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>
References: <20230720115810.104890-1-weijiang.yang@intel.com>
 <ZMqxxH5mggWYDhEx@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMqxxH5mggWYDhEx@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KU1PR03CA0022.apcprd03.prod.outlook.com
 (2603:1096:802:18::34) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY5PR11MB6186:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e10c070-7332-4815-3be4-08db93e65eb6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sEzS2AzTokc5akKrwGYpXmSG0zaIKx6Lnpc8CkrpI/t9ELHPxRUZChiKnrIeLpDUC2bifaK3XTTYiiI8UOIp505kc8COqZh5hp3TFhGIeFHd1FczSO9kATM9SPJvApfZ1znO7NMdTE1qzP3oKrH3s5xr2cr9ze4wSTtfn7fk9s/gdkt0z6EwoJ7QdTl9QbOpx64BwC7CBZ3vfJ4f9+Ykz2QpgOQe3eunw+cxUpG+JGKW3WeV7NipdGigU3OApsQ01Idq1Rk8nvObGas7I6xx0pjoA25vVVLDML4ezzc3p8W4+pp4awRpy/5LAdWa6/hMvNxkpZKFsA5wL4+7itC5C8U22ojaRETP7PLOZf7O+v6VrCk31Zrtf0fcOG8OFJhnV7YT439rjELk4q0fWbOLKoaVEGLGK+wJVsMANsdUgohoeGM29JUzS5dM2ef4O5RO8O/z1yqhnT3MFKKjM9WLQD4T1rgUbT1UGO53SxjjQzSeSFnqWT8Cgba1qWFTmPGbzKVsJmHIs3CqvTWFKbLBKz+2mHqRAlIBmVmKyBLbURlPOuKCl1Kus4BxLrh9XKwVEonCOIVNPck0lUTN3nrtaTSoqMf+lhvnBw8EWuys2DzN8fE6kiN8Sh8lK++KlOCdw9NoAKzUVyRUUaYlHHIlfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199021)(2616005)(53546011)(6506007)(26005)(186003)(83380400001)(316002)(2906002)(66946007)(4326008)(6916009)(66476007)(66556008)(5660300002)(41300700001)(8676002)(8936002)(6666004)(6486002)(6512007)(478600001)(38100700002)(82960400001)(31696002)(86362001)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0xVSW41d21aWGxoRkw2dHF3NUFYZzd0dXpGaXV4akxTN2NmOW1mZDRaRnYz?=
 =?utf-8?B?UkdOZ1ViRC9lVUdUY0ZONFV5dXowQnNqWTZUVFFKOUk4SjFxZG5ENTVUYlVn?=
 =?utf-8?B?WG9ydkRFRlk4T2JGQks1bE1ZdzZjN3E4cTlnbTRXWEcxb1pOMjVFdGJRRnVR?=
 =?utf-8?B?VngrKzhoYnphTzZaejZtcnlqbGVhbThOekdjRlM4VHU4UjYrSmxQbXhiN3Bs?=
 =?utf-8?B?L1ZMVXYvZnp0V1hvRU9PRTduckdESUxnSWZnL3YvdXFjdUJ4Mm5FODIwVHEz?=
 =?utf-8?B?QXVUeGdKbi9NMUFFZmNyYmxhenB3YmRMWjJiWGNnNW1SR00ydlN6SkdlV3Vj?=
 =?utf-8?B?MzArTm5ydkoxUHVmZ3I3UUM0M05PdmV1SkRuQ0dkYjJ0UCsvcGF3a0dFYUxO?=
 =?utf-8?B?VlNBUlk4cjQySVd5ZXZkTVoyeWl5RHoxU3BtdElCYTBoaVRwR0VIZXVtblVz?=
 =?utf-8?B?UHVQYnByOE5FM0VMMldadjlURWZJNk1PWDA2LzdHd001a3NHWU1sR0huU3FO?=
 =?utf-8?B?RVRMK0dxTmo1T0xRbXRYWEg0TE4wd3JKVVFWUk1sVlZMVmdqRkZMWDBRN042?=
 =?utf-8?B?anpBajVUWlV2VVpzemQxTDF4Y3dBbFBkUCtpRHhja21ZNEIrdXJreFdxQ0pi?=
 =?utf-8?B?dGFEN1ZGYUpRTkFBb1FqS3o4TFUxVWlkUHdJMnZiNHFQYU5QUlZOdGV2REdw?=
 =?utf-8?B?QmpWcGsrc1JlVTFMQkI3cFQxS3BCMUpUa0h6aTlnZ0hicTltRXozbGNSMzJy?=
 =?utf-8?B?ejFRZTMxWlJGYzFPZk42eTh1dkxiMHVZL0tZYmZkUkpkajBYd1RicldDemVw?=
 =?utf-8?B?Q2p2ZFVEVVl2SFZGRXJBem50MHd6a3JsKy9DK0dFQnFuNVZ6QmNqaVg0OVc4?=
 =?utf-8?B?RnByMU5UYXNpeXpuZENnc1ZFSHZZU2R1NjdiLzhFemlTVkxkSVFuTmc4VEI5?=
 =?utf-8?B?WFpUV2UreGNURU5WajA3VGVBZkJZQmI1UXcydTVacW5wUmp1NEVZSXpqNS8x?=
 =?utf-8?B?RmRBWTFSOHJQajBtVXBjNnJMWUpwR1dLQ1h6K0M5S1pRTy92ZXRJN2daMERP?=
 =?utf-8?B?SEJ0b3EvSWdQaHRvQlVyekdvQzJUaktSenppWE1SNWNxSEpaK0lyWmYvWFdy?=
 =?utf-8?B?T252V0xRZ0lmaEgwVldxVVlHUXhuVllpOGNPT3E0eEVVcWkzeXZCMkZPaktz?=
 =?utf-8?B?M3pKOUlUd1UxVWxyTk85VkNINUphUWUxWTF3MDkwdjdvcXU0R1JIZ05qbVN3?=
 =?utf-8?B?cGRqaDBoaVpnNzFiaDduWnpMVkNpMTNOM0RMdWZoK0NBRWE0Q0ttcCttOXRl?=
 =?utf-8?B?NEN0Q1RQQlFlcmdCS20rYjJKRFdFQStlZFNVUVo4TVZRRm50WXFCekE1aWFL?=
 =?utf-8?B?RVVOdmI3a1YvSmpyYUFvblVtZm9xS2lDb014eDN2eks3Zi8vVWEvbC9VT25q?=
 =?utf-8?B?enZMMGttOFNYQ01LRis1TXJVMVJtOWdYaGgxVEhVUS81Mzdtb3FHWDZaQ2pq?=
 =?utf-8?B?V0F4YUxkenNtYzdUVjhMQlVtMWw3dks1OTNCWXhFb3NxSkRWbVYrcXJXbjNq?=
 =?utf-8?B?bmdRTlpvWlFIWU1TejY3dXNEMm0wMnpIZFdmcVhlVjJjRFhSVG05WWV1NDFM?=
 =?utf-8?B?QkZzNFo5dlkxWnNqTVlZRDZQamJKNEF1UTRQK0xHSFBTcTVxTW0vK3drNlF5?=
 =?utf-8?B?WWp0cVErRnI5Vy9wOHZUQXp4VUxUdjhtNjlrWEVXWVJDWk1RRkZyLzlXMjVr?=
 =?utf-8?B?Ym5rODJRZEJIeFlRTlN0RDlDeWc4ZlZYLy96d29VQ2hYekxxVzdUZmRmRWlm?=
 =?utf-8?B?UEpwcm41OGsxc1o1VGphdTBHSnprV1pJdDBOaFJOa0Nwa2VZTmliZUJtcFkw?=
 =?utf-8?B?SlBCRnl4bEsySkpFTVI3dlN3UWdpelBrcWJtRURhdVNtQnhmdzVaZ0ErUHpG?=
 =?utf-8?B?U21hc0JoVGJvSlFvRnlYcU9mYWhTYXZmZDJ1TWdIUGhiYjJHcWxzVnpyaTJB?=
 =?utf-8?B?RXBIVE5vdk90a2dhb09JbmRkeVBDMFM4S1Q4bkpIOHdqQ052Zkh6ZkxLSERW?=
 =?utf-8?B?STE1Wk5YTmFlUlE4YlZ4NnhtZ3gybmNEVWFlUm50ZFlSQkZRek9MUkJKcFp2?=
 =?utf-8?B?aU4xYXJUQjU3VUI4VXYrU0x2VDdOZ0VyeHBoL01hUkIvUy9iYUxucFFSRDEx?=
 =?utf-8?B?MGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e10c070-7332-4815-3be4-08db93e65eb6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2023 05:56:24.7605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: koF9Ir6i7ttmSvQYw1zAy11bkIMA6rBkKyXxGVVWyE87c6pt35B+gb53gr7GxHEdAee/bEoNKW5euuk7Gs4ZBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6186
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



On 8/3/2023 3:43 AM, Sean Christopherson wrote:
> This is not "fixup", this is support for CET and for new CPU functionality.
>
> On Thu, Jul 20, 2023, Yang Weijiang wrote:
>> CET KVM enabling patch series introduces extra constraints
>> on CR0.WP and CR4.CET bits, i.e., setting CR4.CET=1 faults if
>> CR0.WP==0. Simply skip CR4.CET bit test to avoid setting it in
>> flexible_cr4 and finally triggering a #GP when write the CR4
>> with CET bit set while CR0.WP is cleared.
>>
>> The enable series also introduces IA32_VMX_BASIC[56 bit] check before
>> inject exception to VM, per SDM(Vol 3D, A-1):
>> "If bit 56 is read as 1, software can use VM entry to deliver a hardware
>> exception with or without an error code, regardless of vector."
> This clearly should be at least two separate patches, maybe event three.
>
>    1. Exclude CR4.CET from the test_vmxon_bad_cr()
>    2. Add the bit in the "basic" MSR that says the error code consistency check
>       is skipped for protected mode and tweak test_invalid_event_injection()
>
> 2 could arguably be split, but IMO that's overkill.
I'll do so in next version, thanks!
>> With the change, some test cases expected VM entry failure  will
>> end up with successful results which causes reporting failures. Now
>> checks the VM launch status conditionally against the bit support
>> to get consistent results with the change enforced by KVM.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   x86/vmx.c       |  2 +-
>>   x86/vmx.h       |  3 ++-
>>   x86/vmx_tests.c | 21 +++++++++++++++++----
>>   3 files changed, 20 insertions(+), 6 deletions(-)
>>
>> diff --git a/x86/vmx.c b/x86/vmx.c
>> index 12e42b0..1c27850 100644
>> --- a/x86/vmx.c
>> +++ b/x86/vmx.c
>> @@ -1430,7 +1430,7 @@ static int test_vmxon_bad_cr(int cr_number, unsigned long orig_cr,
>>   		 */
>>   		if ((cr_number == 0 && (bit == X86_CR0_PE || bit == X86_CR0_PG)) ||
>>   		    (cr_number == 4 && (bit == X86_CR4_PAE || bit == X86_CR4_SMAP ||
>> -					bit == X86_CR4_SMEP)))
>> +					bit == X86_CR4_SMEP || bit == X86_CR4_CET)))
>>   			continue;
>>   
>>   		if (!(bit & required1) && !(bit & disallowed1)) {
>> diff --git a/x86/vmx.h b/x86/vmx.h
>> index 604c78f..e53f600 100644
>> --- a/x86/vmx.h
>> +++ b/x86/vmx.h
>> @@ -167,7 +167,8 @@ union vmx_basic {
>>   			type:4,
>>   			insouts:1,
>>   			ctrl:1,
>> -			reserved2:8;
>> +			errcode:1,
> Way too terse.  Please something similar to whatever #define we use on the KVM
> side.  Ignore the existing names, this is one of those "the existing code is
> awful" scenarios.
>
> Also, I wouldn't be opposed to a patch to rename the union to "vmx_basic_msr",
> and the global variable to basic_msr.  At first glance, I thought "basic.errcode"
> was somehow looking at whether or not the basic VM-Exit reason had an error code.
OK, will add these changes in next version.
>> +			reserved2:7;
>>   	};
>>   };
>>   
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index 7952ccb..b6d4982 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -4173,7 +4173,10 @@ static void test_invalid_event_injection(void)
>>   			    ent_intr_info);
>>   	vmcs_write(GUEST_CR0, guest_cr0_save & ~X86_CR0_PE & ~X86_CR0_PG);
>>   	vmcs_write(ENT_INTR_INFO, ent_intr_info);
>> -	test_vmx_invalid_controls();
>> +	if (basic.errcode)
>> +		test_vmx_valid_controls();
>> +	else
>> +		test_vmx_invalid_controls();
> This is wrong, no?  The consistency check is only skipped for PM, the above CR0.PE
> modification means the target is RM.
I think this case is executed with !CPU_URG, so RM is "converted" to PM because we
have below in KVM:
                 bool urg = nested_cpu_has2(vmcs12,
SECONDARY_EXEC_UNRESTRICTED_GUEST);
                 bool prot_mode = !urg || vmcs12->guest_cr0 & X86_CR0_PE;
...
                 if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION ||
                     !nested_cpu_has_no_hw_errcode(vcpu)) {
                         /* VM-entry interruption-info field: deliver error code */
                         should_have_error_code =
                                 intr_type == INTR_TYPE_HARD_EXCEPTION &&
                                 prot_mode &&
x86_exception_has_error_code(vector);
                         if (CC(has_error_code != should_have_error_code))
                                 return -EINVAL;
                 }

so on platform with basic.errcode == 1, this case passes.
>>   	report_prefix_pop();
>>   
>>   	ent_intr_info = ent_intr_info_base | INTR_INFO_DELIVER_CODE_MASK |

