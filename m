Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1805B70F02D
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 10:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239494AbjEXIHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 04:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjEXIHa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 04:07:30 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB5191;
        Wed, 24 May 2023 01:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684915649; x=1716451649;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8Wc9E0bjIF6baZVZrk8Q8jI3g8zAHGBfHjy4zMelHi8=;
  b=Pgp/quYdyQbh2AYNbrKNcDwQD2UI9Np+5KeeU/GaCUyJ5kv0GYkrlSTn
   MsrNXWg0Hpybgmg/wiPTHLqGQDjz+xtV17RlIIv9YOTxf5I7nsUTaUhjZ
   LTnPzmgzHAgEU6k338sC9AHDBzlSfTlU4p4rWJJySnck8RjPZUXvBzhuT
   ByABqmj0OL3ZvcmeTxz+3qwD3C7NIgLsPnHoB01EhibDVSlndvxjunLOo
   B7Hby98bqm2Zl5wucNFtRmSxe5HhXzaRNqZXF9gm6L52Qo9++9xz3gcTr
   /qLTrO7KuOm7ZsJ0Qw7ASwBrNATEiSCllU7Hx/pJoRxc257giJpCBs2mq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="352336265"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="352336265"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 01:07:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="774162453"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="774162453"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 24 May 2023 01:07:29 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 01:07:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 01:07:29 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 01:07:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQ+hx8IxFbe0iMSjowLVc3nOa2YgwsVRP3Om1+BWZdKT17XneWgD7ZZk5APbMsDJ8erTLVqDaYWY7kUjw5DrIAhpUqOzy9jKyoOYvPiCm/3+fvhmk0/uJg3nKAe9dnlUpLI1RNE2M5MgtoaNLc8P3Nc4E5oS0fDfav4vgZaV+zK4yCob01vUeOgVCG2zG8vV+HhBrLD/9ure6sLIMlDL6iNQB9xsGwhDvp0EbgN07Yqvn7Iwq4nwQT44Bmb18RgTIi5aeiYpl1qjuhQqqpSyebbulmklku1e974YRkoAKMmdl96AccXGDIIk2XPFnkIODmSV4D+yFxCnSnCyUJ8WBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ISApY9L70mw0i9XrqBZT5my9O4dduVKDQuK6s/vEYY=;
 b=BwIgfnAXNoEnzQFqruzN1LIL2KVcY4YOPerr0IKO+a86eIIInLf3/Ryo+bhFyqaEM8PSrrjuKYypTn1A9nqmsvPQYO7lbVvCJl/PebHguD7taitzx+7dMLLABDg3Gp5C0pTC+TOGlYqcNueogF9sG7yATRlFDFTA/Ud9G+FDd5ntzYTTemrRj/+0a6vlnlkG+dTc6CcbkEKiKfplKVOcaUiexUX2VBl3MAYODWYaRVXldvgYJ7QbvaswtREJBneq9ZBQykb2gYJvrNiDXCN9B04yKa66sIasuUz1nY+9AM6rlJc/8Z8sMjumjIdWPDFj+0lj2c5NXEEsy5g3DmIVzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS7PR11MB7930.namprd11.prod.outlook.com (2603:10b6:8:da::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Wed, 24 May 2023 08:07:26 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4f96:4b14:c54e:6261]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4f96:4b14:c54e:6261%2]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 08:07:26 +0000
Message-ID: <e86e000a-ccf6-8a66-a7e3-01d1c6f12857@intel.com>
Date:   Wed, 24 May 2023 16:07:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 18/21] KVM:x86: Enable CET virtualization for VMX and
 advertise to userspace
To:     Chenyi Qiang <chenyi.qiang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <peterz@infradead.org>, <rppt@kernel.org>,
        <binbin.wu@linux.intel.com>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-19-weijiang.yang@intel.com>
 <2af0d399-727e-ae24-ef7c-7064240c735a@intel.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <2af0d399-727e-ae24-ef7c-7064240c735a@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::28)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS7PR11MB7930:EE_
X-MS-Office365-Filtering-Correlation-Id: dcae1373-743c-4368-b3c7-08db5c2de936
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0E6P2dE20k8xKodVDIphg5WO8Fiz5PwbK6Ib2N3XcbjwosvSM3uRvv5FKz9iTlqg2St1MfOiQ5N6VLCY2kHrmeJcwzVC7oPJRZtWv7QRl3n4OzvlBE0QA6UBDT8A5J0c579qtXZ47OD3qvsHfzKKYU3BAVXWke3WLogo0UnFXxfUw6lWioG+jWFeDIK1DL5e1OzHPrpYCmZbsCU08M56tKzcK11SVoiZ1NtnulxdNSqd9X/QgPgumzKiECRaE1SwjZmH8/5WxoIdb/eWlT0IwdH1U8sCYc5YSjYHIJIB6rnFW68C9AwTP57ASMzd89F8+McGrpYuHL3cBhkfHgJ95deW2ntrcOETZH6k03N+z0ZE7bDGRz9L2H0a3c13EcjviY4Z+D4QlWo4eRgyV7P48I3yB9A8gAluGcXqINLiPddvbjTjymt1snwFrNfmbsDVa1JaxJlySCmE8+ekR9O4T7N18ppM7VEw4nU9N2bNKKUFPqjYcQ32I++WyEJV/GQ9IBX3NfiB8uijtL4kZH+VtaUw/jF7KGTAe7mWEnNThP2Kh5r87ge2EhHNB3jxoN2KO3KUf3AzK7L6Xq3ZYSoRtgmuGh7mK/9Is4GY9ou+1LWiISegYdQ3BQFrL+uir4QfoUsCfPqh5MVcBleX1ovb+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199021)(6506007)(82960400001)(26005)(6512007)(186003)(53546011)(38100700002)(2616005)(36756003)(83380400001)(2906002)(316002)(66946007)(6666004)(66556008)(6636002)(66476007)(4326008)(41300700001)(6486002)(37006003)(31696002)(31686004)(478600001)(86362001)(6862004)(8936002)(8676002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1I5eUk3V1dza1I4Z2pTTXNHcjBPMlR3NGJHK2ROZ2tRTWR2bGdDRkFLNnJT?=
 =?utf-8?B?Q01CWHIvTU1vMGFpRi9MRnQ5SU1VRDRwTUk3OFpHTHVNWTAwUXFrZ0ovQllS?=
 =?utf-8?B?MnBwQXRvbkJZVEg1emliT0xqQjhWL0k3V0dWenJ5cE83Ti9jV2hHS1d3aTZW?=
 =?utf-8?B?dU1FK3JKMllBTzlkZWFQeUJmcndOaDBPUzY4dGx1TWMwT0dqQjJMaXFJclMy?=
 =?utf-8?B?QmFzeW42U2Y2RlhwN3ptcHh0R3ptNXUzNk0vcnM5cFhIOHFFTytVUUlHVzg2?=
 =?utf-8?B?UUdNdTlMR2VVbkt0czZSVW9kU3kwWHJ2ak5MMlBPaVV5aDM5SVdOd3E5d0Rn?=
 =?utf-8?B?L3JOTGFDZElDT0VyRnE2N1ArcnFRQW1JaTVBcTBiWTRONnJZYWZJenl5aTVo?=
 =?utf-8?B?NFBidzNYRHRMenRXSUNuOVR2eHBWNGJ4Qk1vQ25hY09ZY2hZdVgxbGVld2Vn?=
 =?utf-8?B?NXRwaHlINXlDTmZZTm9tT0RoeUZQY0o1QWRNNG5HbjYwY1gxejB0TFRmR0Fx?=
 =?utf-8?B?Nk5RODlsNUZnNEJlejhrWEhlOG1IcFo4OUlUNnRuZmRuVnAzNW9zR0x5YThk?=
 =?utf-8?B?SldqeWtyQ2loeFFNeGpIaXJ5L21mMmtwdFBJUFhUdGl6Y3cxTEdCSTJiM3JC?=
 =?utf-8?B?b0FPdFVtOTJxeENuSStLL3Y0QnVIRTVqb3A4NlYxT0JKZCsxSUlRa213andx?=
 =?utf-8?B?OFFZb2l2VGI0VDFZakdiaTczM2Q1cHRrNnlTZVFxbWg3RkRIa3dKK3hITkQ1?=
 =?utf-8?B?SVVVcTI4eWxWN3hxL2RBa2dSazJ1K0tWRDR4SVU3R24reHBwSWhQYmVldVdz?=
 =?utf-8?B?VjZuaFRTbUdFVlVPSG9ydUtiUS8rWElabkFsUlVnT3hZNWpDRjZvb3I3Zlgr?=
 =?utf-8?B?enUvTkNPQXdQV1Q2OHc2UmtodjJINGpmM0RrUXhpdm1qb0pBc3NuSFpuQ09T?=
 =?utf-8?B?TXBUUStNYlFYVHhwenN5QXhmbkVCOFBXK3pSc3dUK3A1aHd6eW12alVseHdR?=
 =?utf-8?B?dzVCV0N2YlY4Z2s4U1VrbHI3dTZZWmZ2YTQxcG83Z3A4MDFkVGtYRGs5bCtV?=
 =?utf-8?B?N1p3VTZFeFR0SW5vOXNJNGxUdmFLR1J6OTlRSnlwUWRlNjBzbG4yNU5rS1Iv?=
 =?utf-8?B?cnVlMDVrZTIxM3BWTmoyYzBqdXdVeDlBeks1V2w1OXh1dXBmRFpQa1ZoUWZ6?=
 =?utf-8?B?ckVFQkp2Mm93WjEvbkhYQXQ3RzZiQUcyRjZqblgyL3VqaUZ2UXhJTitJN3Q0?=
 =?utf-8?B?Q1hPaEhzSjdVOUJpNFpLRy8rakNSZm1mWmhXWjhEMHh3S0djME90cXlnSXFS?=
 =?utf-8?B?QnZvZTdFaHF1bER6ZGtvcWV6YzBlaGVHeFVEWXhJOWRsUGlwTGFOcS9HaHF1?=
 =?utf-8?B?OEszMjIwaHMwaWlVY3BUb3RjZlJaTkw2Z25QNW9wZXRqUGxsRjh2QU5oVm8w?=
 =?utf-8?B?VTNaRFl0aXhMQnQvdkVwQXlqNDJqUDFFWkJLSmJ0VUd6bVFha0x1YW1GZnRJ?=
 =?utf-8?B?UFNZVEdhWlVpa3Z4VzJrejMxajErODRnU1BibU5KWGRnUFZYUCtMNjhiRDYr?=
 =?utf-8?B?elY0SG9ocFVJTi9PQzRxUGdFS3FURThoMWErVnFSbUl2WjBmd1d0RDhHUzdQ?=
 =?utf-8?B?amVvU2Z2a01QQkNuc0h2TXVxY3AzUWNlWlI0RjlQRWsyclBXNlVnbGNHYzRy?=
 =?utf-8?B?bVpPSm5Wdld4ZitKanJaMnBkNHE4MXlLL1VCRUc3R0hNblJsTXFMTFRyWHhT?=
 =?utf-8?B?YjRwUVo3cG1ZOWhiV0p3NFZHb1pUc3BWd2ZyYUdYS0dITXlwalk0TmtadXRl?=
 =?utf-8?B?L2Q2YWFIYVQyYTJyTUovckVpUnU3YjM5WkJtM2drSjN3RlBtR21UN1JWdHg4?=
 =?utf-8?B?R25rTmxYbTRyR1dIUU44cS9iZ3VnZXM1c3NaSHdxekNnc0g1VXQxcW5zL20z?=
 =?utf-8?B?ajVtRmJQMzlPbzA4SVZQVlIwMk5UcnFmR1E5Ynh1ZnJOVW9OeUo1VUR6N1Vt?=
 =?utf-8?B?N04xQy9MTEc0c1J2SDVzTWhjWmNXTFhiTHVkKysyekx2ekhVbFEyUXEwOGpN?=
 =?utf-8?B?STJZVEl3bW5IOEk0eWtxWUZTenZ1dUlvMTNvckF2NlBVQnB5bHdGMHVZMmdS?=
 =?utf-8?B?eWU0YWRqcGVENEFuVUdIZ0p1OUtOTnYvdEFob280aWJXSm1kYldhSmlySmIr?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dcae1373-743c-4368-b3c7-08db5c2de936
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 08:07:26.3943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G2wqkX9yJhduVJ6ZZbdM4v+0oKTPBU3ANhdW+ybs0LAlxeuVu6PtsXFfQ0LkY/pgnlkzZ1VqlgENVQpVoQhPcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7930
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


On 5/24/2023 2:35 PM, Chenyi Qiang wrote:
>
> On 5/11/2023 12:08 PM, Yang Weijiang wrote:

[...]

>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 50026557fb2a..858cb68e781a 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -226,7 +226,7 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>>   				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>>   				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>>   
>> -#define KVM_SUPPORTED_XSS     0
>> +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER)
>>   
>>   u64 __read_mostly host_efer;
>>   EXPORT_SYMBOL_GPL(host_efer);
>> @@ -9525,6 +9525,25 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>>   
>>   	kvm_ops_update(ops);
>>   
>> +	/*
>> +	 * Check CET user bit is still set in kvm_caps.supported_xss,
>> +	 * if not, clear the cap bits as the user parts depends on
>> +	 * XSAVES support.
>> +	 */
>> +	if (!kvm_cet_user_supported()) {
>> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
>> +	}
>> +
>> +	/*
>> +	 * If SHSTK and IBT are available in KVM, clear CET user bit in
> Should it be "If SHSTK and IBT are *not* available ..."?

Good catch, thanks! I'll change it in next version!

>
>> +	 * kvm_caps.supported_xss so that kvm_cet_user_supported() returns
>> +	 * false when called.
>> +	 */
>> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
>> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
>> +		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_USER;
>> +
>>   	for_each_online_cpu(cpu) {
>>   		smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &r, 1);
>>   		if (r < 0)
