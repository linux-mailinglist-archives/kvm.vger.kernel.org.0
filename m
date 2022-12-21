Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBD9652A82
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 01:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbiLUAfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 19:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiLUAfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 19:35:43 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047841DF0C
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 16:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671582939; x=1703118939;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BYqE8wPtoQnQqWDQtl9P5DaTqI8rpplAPcWQbRtF4g0=;
  b=oAY75yGWTYDfjtS/zyKwe1Y3kKOWIJolOGib366voHGTRcuEJJ7nBA+G
   lPmZ9vQq07Jc50qpdOenQ5DboM4j1yPgo3F0i1+98b2t9acFHM46htTBI
   AV9Z48d60ZEYmmomEsy0x9tb66qCS0sHyhzWqfCX5ImSwmtenieA5F0J7
   tQz44gV+9L9ZCC9o4ZaaHCjedBKW1Lp3mqkTigSx+6eV+L3JdOFiBKYW6
   05vCzdmODYM6XRJ3f4ML2hu9jM+iK2XND7AHGArVty+860hRNNnPmb33P
   am6Pr3A0YVp8gNKKdy70tO536TFs7GaMzy9QSRGPmWxKMMKBWsHIg6bav
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="307433355"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="307433355"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 16:35:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="896676022"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="896676022"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 20 Dec 2022 16:35:24 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 16:35:24 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 16:35:24 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 16:35:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSb5wCCRKM5qG3I0uYv4L42bpT9e8yYYR+GH3DX5sHyDdY8wDmHXAPic6EQbX9Mtanc4JJr0rOYwHD5Jh0Uxnzft/xjWn1AHVilO0bfRA8LQZm3S9RyIcqBPqzz3Hf0ccVwBqu20Tvp58E/FHXITPRFLZrL/OO7cZsb56oUASzAlisRjK9+gAG2PDs21F9yYTDKJcHxwyxS86qozpitwqYIc2ZJxzhqo17aP7WtkQHedb2FI+jxYXI0fHTE6CvQ6f1aZ+6e6n4JfT4F284PPTdH+f4CD93pF7Hk63f+iBj1lPMybd8tqxbtHgJ+vNQjSmIs6s8ZLvs1GTZmDUZjF0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eNYxyLByjJPG51YZdI1UDAh3QQHEgbggvhCYS/93mbs=;
 b=YKo/xMj1ZLJ+64msFL8kT1iZQMg5N16gHiz1ra90bMRPgc+Lyv9K5hEd0E4QaAPa+/rk8QXKNRkIlLnKbFHraXK6/cStGt9SD3x0gWYVYnEjoNXKQ6sP9Vt42D95H4XnigNwRv6SeILeozIhxbXUgl2D4NfpgF07M+FsZfIpLE5jcCrz9AyfWDUS66H2BaW/0+Sp5WUZyhepDEgJpf5eGSZ9I8Z78pwRNWvYK3ffQR9vxw7cklApLOVG47xI1AfGbNcJQZHhDp1DIkBq4VdU3tkL4l7arM35AcW6gnOOTnqZO+KV2Q2i2u+9SMtZRYX3AAMGioGxmmdjg3MisgIkVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BL1PR11MB5352.namprd11.prod.outlook.com (2603:10b6:208:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Wed, 21 Dec
 2022 00:35:16 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe%3]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 00:35:16 +0000
Message-ID: <4bff3b59-c18b-85d1-2164-cf31076780b6@intel.com>
Date:   Wed, 21 Dec 2022 08:35:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
Content-Language: en-US
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     "Liu, Jingqi" <jingqi.liu@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-7-robert.hu@linux.intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20221209044557.1496580-7-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::19) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BL1PR11MB5352:EE_
X-MS-Office365-Filtering-Correlation-Id: d5f5275b-4c35-482c-335c-08dae2eb3af7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E5FxfAW5PTfYHh5uD3BHZNqZHC0NJ25/nckzUMz4fizlecT37T/g8KuLPUdnL+KzUzs9g8nr1Cvka62jCuS5akZakGsHy+7vIviEBrjALc3jY+6DjWmn5oGVQmpZFuzt9C2RszgQWKVjfZwtg34/jMZI3Kg/I4XLqaQ1ZeNJwNOdfNXrG4YbA+2LpX2+sEZkj17z4q7X5zShhdZOjK63sfRGLW1hKrcTJEi3fdgNVb5Y4mJKa5NLJtfUQe86ZWKlLOCTbhl5fuZZLltnFJ0nokfcDh9XHqGM/y1X1hY9wUbL85fwN5YHFZO5NBZ9UbaUeyOTV0ylTL1Zosu945J8uyC/Glm5WVjY4dgyjjZ60a+4hxQrbbolV3pjUOz8RC4ZqWVTepei71GDBN+LxEAznKXvDSZuocczpJDeGkKqo/mjHkagYp/rV2MNB67Uu5gYOeV/JICynquI5WX7rQxbKsj2VvdEhmjlJrCOqxGjTV9HwdlL5/g/zXfAEpGlhr2oPGmVzU/m5C9cGHZL0XOJRmenneN0e6bsADFbh/ZtG6UH6YoUP6f/B2vb6/5qvJpRplJZZPyqM0EgcykN5sV+1PvQKjh9t6T3S4k4FE2HkfmSEcpGU8EnyKT7KvYY9d5yCmR6yRV1MW8EkVzB3bQyNndWltZXJT1EblxDb62+h+apFxy6BZLIivy/EWI0saaZGRBKNsgTmvq8ZE9CD89jQ7H8y+5/5u09N11Wra/pUF4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199015)(2906002)(31686004)(5660300002)(8936002)(66476007)(66556008)(31696002)(8676002)(41300700001)(36756003)(66946007)(54906003)(316002)(6486002)(6916009)(4326008)(82960400001)(6512007)(6666004)(26005)(6506007)(53546011)(86362001)(186003)(2616005)(478600001)(83380400001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUpEUWVCV0Z5cE84M2V1R0lDN2h3aTQxclpidGJGWStKeFFHN0pFWDA1ZGxC?=
 =?utf-8?B?cVI0WGRDRHFoWTB4KzhaQm51ZVh1aXd6bzJQOGc2Y1N6S1R5YzFMMUR4amJa?=
 =?utf-8?B?ZWdPUm9GVWxBL3l4UnhxUWdjQWJtT0doMWVMK1VaYTc0S2RxbnNPUHVLQXBI?=
 =?utf-8?B?dnZ3K3dpdjJmMGlQZjJzMnI0SE44b3lwMWpHWXBJUEFDUHNSYVNQYUxzUEx1?=
 =?utf-8?B?bUNPQ1BBZFpwOWpySmpObE9xOHJRS3gweFBMdnZJWXU4T3k1dExXUEVzSlV2?=
 =?utf-8?B?ek5uOGZzK21TNm1Ocm5IYUJOS1I5YllDdy82QXNTc0RRTWc0VTl0YU9ERXFI?=
 =?utf-8?B?MHErc0JQOVVyTmdIdkNXOVlxWWtaOFlCOGtBeHovNzdzdFFtMENKa1JlQkF1?=
 =?utf-8?B?OHhSeVA3YmFPWDdxQm5mMDgrcHp5SGtMMm5QTm5UN2dnd2U4Qlp3NUNSVllu?=
 =?utf-8?B?UkVRSngxUENsTU9xZjltQmtaRmdsK2Vtb0NxdGgyWGNDQWNlT1hUblhFSVlt?=
 =?utf-8?B?bWxLTVRBTTRFeDB3OFFEYXA1VDVnWU8wWFNzVHZmekxPckV0MGlnMTJpZ2U5?=
 =?utf-8?B?Y0JoamFzdERFaTkwQnRBWFp2N0pPZWErQ29kMnU4Nk5ENzNUM1BkK1FGQnZE?=
 =?utf-8?B?Q3FiQ2NwWEppbDdVdXUwOVcrQW1JaEtZSmdpU0I4bWFkaXYwSE9HblAzZUND?=
 =?utf-8?B?UlFqTVUram9sYWR0ZC91QjZ6Nno4RytSRi9MTWREQW80QWpqVFNRQlFHclNs?=
 =?utf-8?B?TVpTYkVwTHlwZEdRZTRKRkVkaG8vVTI2YjVnbndxL1ZxQ3VEcUhkYTd1bDBL?=
 =?utf-8?B?R0dNemlEanBHWERhQjFKWnZTK3ZzOGdEbGp3K2dNMUk4SDhSYUxNVFA5RlNQ?=
 =?utf-8?B?ZWZwRjVNdVd1eUFwY0dhT3FCZ0cvLy9qSGExWW40N3c5YTR3dDJpelYzTmd5?=
 =?utf-8?B?eExibUdVNlYvcDdodjZORlJVdDJOV2liU3F3T3hQeWhPUnd6NzA0cVlLSDZi?=
 =?utf-8?B?RVcrclBuL2Q5WGQrT0grTVhDTno3cUdhYTRsSlZvNytrQlB3VXlKQkdJRG5t?=
 =?utf-8?B?azN1OWN1a0l5Y2Q0OEVweCtPS1UxM3BwZy9Qc1BkTS9CdG8rbWJGanlud3hS?=
 =?utf-8?B?a1R6YUlJMFJjdG9KTGlsSE5LN2kyK0VXOUlSdHE5djZ2VjlLdUg4NTM2c2xp?=
 =?utf-8?B?ZFg3em1QbzRoUXlPOHh4RndzcHR4c1V1R052NXJodFRaMXRFZkVrSXUxZVhP?=
 =?utf-8?B?TDhwTHBUS3lML0M1ZEdtR2FjSlQ4M0hBbURjNGJjc0MzdkcxazIzL3dlNElH?=
 =?utf-8?B?ZkxKdVgwWno3L042K1AxZXB4RnAzV3I1K1RIMDAzK2tuSTZKWnV3cnQ0ME5u?=
 =?utf-8?B?MGRtQXVkTHk2R3E2SElTYzJaU0dqaWRUYkdZVEN2RGZuUlZSMm5uM2pCbkZX?=
 =?utf-8?B?MG84cmExV3YrUndaYVU4c2xKay8wbVFIOWY5Qm5NSnB4WDFCbkR5Q1J5TDhR?=
 =?utf-8?B?b2dTSW50UEdhUkNWTWY4S3ZENnRiTHd1ZU5tK2krazdlZTBORkpWQkRTb1o4?=
 =?utf-8?B?ZEljd3grZmlPNDMwRXRYanF1WkJFVENUQWp4YmJtYmhNRWplM2lGbmFqdlIx?=
 =?utf-8?B?bE1aaEZ2VUVsM3piZnJzZXBic0NYSVNTN3VBWG50ckl3TWhsOSsvMjZNVmR5?=
 =?utf-8?B?ZCtrZzdjc1UyYms4WEtOenJ4c0VCSnVRSjdCa0UzbHRvTDluN0JYaXg3bmRT?=
 =?utf-8?B?eWYvcGcxM2xxM1R6OGRIRTNmRXp3dzNLb3o4SWRzTHJiWTVheEp5MTJUR29w?=
 =?utf-8?B?enljaVVoaXFqaDgvSzB2V241UkNBZUtUeEZUMklWemNpMFlBMmt3NEdQd1dz?=
 =?utf-8?B?c3dKQ3hJODM1K3dFdWt3K1liMDdSQ1B1eFJZa241UVM5WEgybitnc0JZckFn?=
 =?utf-8?B?dFJXeWtiWEpDUThyNE9FMHFlZCtQbHdwbi9hSi9OeXdJM2VOMGdCTFdBd0lQ?=
 =?utf-8?B?NUg5enFBcTI4ajViWjVpbG8rOVRKNnNERGdGVm44b0wyRlRLNlFlMitReXBi?=
 =?utf-8?B?Z3pBeHpaUU5ERnVZT2p0S0Y1b3FPZjZiSkdIZTJyU0tzRzVPeHJZY2NPWnEz?=
 =?utf-8?B?b2dzUnZNMi9xUWNIWm5CclBpZ2k4TG13QVdNWnBadC9yR25jZ3dSUDU2Zm00?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f5275b-4c35-482c-335c-08dae2eb3af7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2022 00:35:16.3629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxlJUScWi/5qLMivk9s2t1nP+5labPdCanVC9xccKDitYUEP9T1lYrBU65QN4wSPRdcmfoYM/WLkDTvTqbMT5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5352
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/9/2022 12:45 PM, Robert Hoo wrote:
> Define kvm_untagged_addr() per LAM feature spec: Address high bits are sign
> extended, from highest effective address bit.
> Note that LAM_U48 and LA57 has some effective bits overlap. This patch
> gives a WARN() on that case.
>
> Now the only applicable possible case that addresses passed down from VM
> with LAM bits is those for MPX MSRs.
>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c |  3 +++
>   arch/x86/kvm/x86.c     |  5 +++++
>   arch/x86/kvm/x86.h     | 37 +++++++++++++++++++++++++++++++++++++
>   3 files changed, 45 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9985dbb63e7b..16ddd3fcd3cb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2134,6 +2134,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		    (!msr_info->host_initiated &&
>   		     !guest_cpuid_has(vcpu, X86_FEATURE_MPX)))
>   			return 1;
> +
> +		data = kvm_untagged_addr(data, vcpu);
> +
>   		if (is_noncanonical_address(data & PAGE_MASK, vcpu) ||
>   		    (data & MSR_IA32_BNDCFGS_RSVD))
>   			return 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eb1f2c20e19e..0a446b45e3d6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1812,6 +1812,11 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
>   	case MSR_KERNEL_GS_BASE:
>   	case MSR_CSTAR:
>   	case MSR_LSTAR:
> +		/*
> +		 * LAM applies only addresses used for data accesses.
> +		 * Tagged address should never reach here.
> +		 * Strict canonical check still applies here.
> +		 */
>   		if (is_noncanonical_address(data, vcpu))
>   			return 1;
>   		break;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 6c1fbe27616f..f5a2a15783c6 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -195,11 +195,48 @@ static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
>   	return kvm_read_cr4_bits(vcpu, X86_CR4_LA57) ? 57 : 48;
>   }
>   
> +static inline u64 get_canonical(u64 la, u8 vaddr_bits)
> +{
> +	return ((int64_t)la << (64 - vaddr_bits)) >> (64 - vaddr_bits);
> +}
> +


There's already a helper for the calculation: __canonical_address(), and 
it's used in KVM

before set MSR_IA32_SYSENTER_ESP/MSR_IA32_SYSENTER_EIP.


>   static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
>   {
>   	return !__is_canonical_address(la, vcpu_virt_addr_bits(vcpu));
>   }
>   
> +#ifdef CONFIG_X86_64
> +/* untag addr for guest, according to vCPU CR3 and CR4 settings */
> +static inline u64 kvm_untagged_addr(u64 addr, struct kvm_vcpu *vcpu)
> +{
> +	if (addr >> 63 == 0) {
> +		/* User pointers */
> +		if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U57)
> +			addr = get_canonical(addr, 57);
> +		else if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U48) {
> +			/*
> +			 * If guest enabled 5-level paging and LAM_U48,
> +			 * bit 47 should be 0, bit 48:56 contains meta data
> +			 * although bit 47:56 are valid 5-level address
> +			 * bits.
> +			 * If LAM_U48 and 4-level paging, bit47 is 0.
> +			 */
> +			WARN_ON(addr & _BITUL(47));
> +			addr = get_canonical(addr, 48);
> +		}
> +	} else if (kvm_read_cr4(vcpu) & X86_CR4_LAM_SUP) { /* Supervisor pointers */
> +		if (kvm_read_cr4(vcpu) & X86_CR4_LA57)
> +			addr = get_canonical(addr, 57);
> +		else
> +			addr = get_canonical(addr, 48);
> +	}
> +
> +	return addr;
> +}
> +#else
> +#define kvm_untagged_addr(addr, vcpu)	(addr)
> +#endif
> +
>   static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
>   					gva_t gva, gfn_t gfn, unsigned access)
>   {
