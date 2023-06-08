Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5C87276D6
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 07:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234431AbjFHFoi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 01:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjFHFof (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 01:44:35 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAF52709;
        Wed,  7 Jun 2023 22:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686203072; x=1717739072;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k3tdWbxIT7fN09YHdpLYGZSddTFHFsMMft4hscmu+ug=;
  b=oJq9M9l1As3FaHjRXxLCF2fNmhgKbcbcplpaxvzypolTCfYbrqrZwtx+
   vK0hLETK46Cl8MpPmY0kGUyRlrus9VjMVJUzqmGuixe0czujceNiuX6Mc
   NTUwjB/4ASm9dPuY8gxPq0zn3W993SEp8Xp6+um0Ja6IHcKRaey2sxNnR
   h+UqMhgEIUQLoknzoqe6j2uTiS9QH+hYUO6GwqjsgJTfL2hwW8SPPMVOz
   U2NGVtlq7BIS5aJZRANY232Nld4/+OY/yFmNNL6ctTtAUIScqPhY3r2UJ
   PwfcBXpAR3SrawmVOuPZ5U6EAZfH6uvdILpQsJiD2fKe5/OyWC9N9W0IE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="385552140"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="385552140"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 22:43:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="834026188"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="834026188"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 07 Jun 2023 22:43:10 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 22:43:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 22:43:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 22:43:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzKmwT4FlYM7C1htME6UcjY3Gx8X+VuQSQBR2VCBLfsPqvBHKu8sALgrEogVJ945CNRgMfrLRaE8tezWSvRYZKx1nKRW/50KiqRBRUnaHQfTXxIKSqtuS+nY9/eZeIFSnGFFT9R+TtK2rhNe7E8mLicEoy1PQszNf3Lps06d3g4hIj+5/a5NKHT/GeQNXsvQvXJ6PHEUQNOQE9opKQyeLPS0hdHx+o8DjQMJWUtu9VSvN6DJG7Tf+UWvDzEbVprJP7WOrn/hahTsL6xcz7LauH2qAZQL0Paww1P0a6PfWBjF6euGxd56RuvU+0zqQ/9QRlyh1RduEjkjo99cc2yqHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HsTy/LGzKR25LIYHu3dV7MlMHNKE3gWMDyAI6sBAc/c=;
 b=Gr+fIoHOhenRQ3fUCoIPzgIHMs7eTtJ1SY/6LuYpPGCXh5UBnNavNpwqDZ0zT6QePw+nW/LdkSlgDGhjRjUllZifHe4PvHNZ4FdB7A7tbhGaW8MIhgzv1Jzq379IYRybpyJz5JFcbX+8EIn95bO1cmGbh0b8n7vgcuKVVoKOGNca/u0sx/ABAd+XEdZCS1+T6z5j2Qc5j2nV0GjaGvPggNiR9gC1lzmgGKszLbjj45oE7Hpcy470A2HIt0uuwYDrd16MN+I3WGuSx2riLBZizTmsqHu/ygRNgg+Oc9CQhYBD+UwmsxlGUid2rOX2ZN+YqZuywNn3klHAC8JiOkaEjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BL1PR11MB5285.namprd11.prod.outlook.com (2603:10b6:208:309::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 05:43:06 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%5]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 05:43:07 +0000
Message-ID: <e0f5e95d-d221-8852-72db-cc70cd807754@intel.com>
Date:   Thu, 8 Jun 2023 13:42:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 08/21] KVM:x86: Init kvm_caps.supported_xss with
 supported feature bits
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-9-weijiang.yang@intel.com> <ZH7wc4NX66HNqMl9@chao-email>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZH7wc4NX66HNqMl9@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:196::7) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BL1PR11MB5285:EE_
X-MS-Office365-Filtering-Correlation-Id: b7d741ad-9fce-4f77-2537-08db67e33c1c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m8o2KADHXUWwwwLqu+upkKizELQSecOsW2m3BWwazhKJIWuc/tHSaunS05R9fXeqVnOh2oCam95EqaqUeA1s2wZceVwX0dtUnXHx2F7QOMhtg28YxFuPN4OPulXuPniYIGk8u/3izEvZbeV2Zp5wfnBzqihd0+IF7+Tqj7p5n5GaH0UIe5RtrEPDEirx7e3uNKgp3Q/IAjzE5jM7dRnqWAG+QgP8KSHapr8a0ncHdEbudHFcEVfXjTz3rvSOQ686cDFBG17+7xUnFQHtmRfqF+OOK6FH1op916a572HeT3F+1YFI7gs62bE1l5uE1weSDd92yyrFtV3N/ndqPda1xqTriOd8/UHI1G02X5OrGWfLS2uaVRfU5ogf9lip53Zu6iFKW3xUc8LtC16TPobecp4ljS0gUo7bW5Tlsooc6KST68rI3WIM5Lyfef9lqWPKGPn9Drrb/RTCWJH0VhAQY7ghRFoAdfMIwDvYzpdqxjnwRTjHv4KHEVnZDUzErRowwbHU18Rvv/l3RAtdCI/1bnnDTqby++xx6bYkqs3A+eawUxVt46xT08vjZ+9lqVbgksRs5Jb5Jt4yYNpXDW8wxYT6HdL1NdrgVsJzB94tYvJT1tuxNNFp1/6/y1nsg3ibvLStdp4RhSPB5F0fSBMhyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(376002)(366004)(346002)(451199021)(31696002)(86362001)(2906002)(36756003)(31686004)(6666004)(6486002)(186003)(83380400001)(6506007)(26005)(6512007)(53546011)(82960400001)(478600001)(37006003)(66946007)(316002)(66556008)(66476007)(4326008)(6636002)(38100700002)(2616005)(41300700001)(8676002)(8936002)(5660300002)(6862004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkNRQnFUYWFENUJPMFFTMHBKZUhaU3RscmZjdTF6a25HUE10czhDQVBZdU5H?=
 =?utf-8?B?Wk82Tzl1VXNaNUh3b2NmaTdNSGdBc0kxa3hoUlo0T1RBTk5mcVM4amZ5a1Iv?=
 =?utf-8?B?WWNjVU5yY3d1VUJ3WTRnM0V4ZHh1QSt2WVN2bGVqcHFyMXlvN0pQWGZpcHF3?=
 =?utf-8?B?NEorR0pRdkR2N2MwZFBhWS8zM0ZyVWNIN0FEMnE4RmM3MXFFYzAvbUhqYk52?=
 =?utf-8?B?R3d6RERoL20zV0VFVDUwQXAvVmdjU1BXajdlZHNGV0dKS25OamJWKzl6OVE0?=
 =?utf-8?B?UHp4YXNjOHNSMU1DM2pGMTNmRzlTY3RFNWRlRUJWeFZpYUYyc2pjcW03ZENJ?=
 =?utf-8?B?VHJlUHdZSEErMnV1eEVVNTJUbWlaL0MrbmRLQ05nRkVHaUVnQmhQSXcxdjJE?=
 =?utf-8?B?dm91dzNUdzRGOVNnRGxGOGVXU2dyUE14TnBTODcreWcrUmFROWR5WWpEc3pD?=
 =?utf-8?B?cklpTVJIK05Gd1I4ZlNja3BOUE5xN1huOE1vb2RrNUtRK0M4QkQwb3RhVHg5?=
 =?utf-8?B?YkwxcDEvZlZ5VFJTN2h6Z0tNRjU5c3dPRHVuZWorLzNhbE1GdDBjWUJrZ2RD?=
 =?utf-8?B?YWdaczl3S25LMi9CMFRRVGg0citvRll0Vy9reWtzb2lteFUvcGFXZENPdDhT?=
 =?utf-8?B?L0FON1ZKaGJEaFBtS3ZKTzdaYlB5aC9oTDhFdVZXWEVQR1cxclFPcnUzRGcy?=
 =?utf-8?B?T2poWWp0ZDJsTitEaGs3RTUzbVcwaUcvNk5YUE9aT05ZSCtVdkx5cHFldngy?=
 =?utf-8?B?bE1ZdVAzOHdub29NSUhXYnpjcWZVbVdpbGYwTFJjT1BEU1NsbXYrVldFTDlD?=
 =?utf-8?B?OFpBbXVkWGZ5T3RSMTVFTS9sYndsS0NnemZGS1hJZVZCa21mZHg5clVNVFlk?=
 =?utf-8?B?OEV4ZXh3TGYwVzZTZ0RYaVVGSTFOV3dia3BFbGtCbFdKN25wOTY4WVdzYnFE?=
 =?utf-8?B?VFpJNUdNdEVlWWFkRTJRV0ZpWHdMb2xzdFNIclAwQnJqWHViaUI0cjAvaHBk?=
 =?utf-8?B?VHArWnZLWUZXK1JPU0J2NjdmOTlGODBYT09RN1hXUGYzNE5YdzN4RkNQQ0dN?=
 =?utf-8?B?alVhTDJCaEpJOVM5NmNzNERtRy9nelJ5WFlJcWZ4bWpSNUtPcXFPRGI4RW9F?=
 =?utf-8?B?V2FGcGwxZjJRMTdjNFF3VHA4aXJzSW5BN0M1QVJGWUZYaUt3cUVwT0xtRnVs?=
 =?utf-8?B?VUZyM1hnY3FCYllyd0I1VHNuUm91QkJwQVBWWjNJUzVnazVGRklVQ0duL0xm?=
 =?utf-8?B?QkxXUTIwR2NidXNwMFZlL2RCbDk1eG5XcFdxdVhhWnRSSGRXSlpLcldEVmdo?=
 =?utf-8?B?MVFaakpVV0xPc2Q2Vk80czdGVTI4KzlYV3hmQlo1V282eDZEWVZIVXNHQkFo?=
 =?utf-8?B?aFIxMXN3QTRnMldOVU8xT3VxczhEeWhRdEZUM0xQY2dNaU1KMXBNT1ErdTZ2?=
 =?utf-8?B?ZEJsVzNVdnNuaS9CNXJJUDJqWVVGS3FrTldHRSs5MStsUCtRbGZUU05qZUNG?=
 =?utf-8?B?WUlOcWpIU1UzdHVKWno0NmwrUzZER296aThJdzZpdnBUOG5RNlZOc1Q2aWoz?=
 =?utf-8?B?TDdZejIxRERnM3FGYk14YUdtY00xaHg4bnByVkllUUhGTHcvUkxPU0NXd1JD?=
 =?utf-8?B?QjJlU09TQUtrWlRQNVNKV2I0TTlZN0x6QTNkOERQYmltQUlXVHdXWUlQYmpL?=
 =?utf-8?B?Rlg1S0Y3YmYzRGx5QWpWZmlaVlM5NXpITHozdGk5NWdYdnN2dmdZVFBjVnBx?=
 =?utf-8?B?bEg0RkxnZUtZL0lLZGoxcjFZcmpNYWxYUXhkcEF3WitKVUdJUlBkcHN5QThl?=
 =?utf-8?B?TDVsandGYUJvSDUyV0l1ZXEwS3NXWVdRcXh3SXpHRElxdXJlMC9kYnBEUEl6?=
 =?utf-8?B?QlhuQTNyTkRKS1JXS1ptTGZnUmxOQ2x5MzVISXNXRFJURDk3MWJnbTR1R3l3?=
 =?utf-8?B?aTBNcGlzOGV3bmhOd1FWNkd5SlZQL1dOZDRRUU4rWGc2WXEvWUZoa1YwZXJi?=
 =?utf-8?B?UXU3cG9TMW1Fa2ZVcDRscWkwbFMvYXBzRkJuZXNxVzJGdllxbVBoT01tdWY5?=
 =?utf-8?B?ZHJHenZXQTJucEF4MDBBalhHbTFtUHV6WVZqLzVYZlBCRXk4NGlMcFpEL3NR?=
 =?utf-8?B?azAvQVl6NmFHdXpwZnBlNTdDTDlIWHdKZzM5L1BIWG9KUGNzVm1wam5JTmlL?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b7d741ad-9fce-4f77-2537-08db67e33c1c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 05:43:07.1330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W1uF9A+UfOHEIMn8ntoPlLNFzIBuwUK5QlfKUJNW1iEKxrmJXRxMZC+rZ85kx7DYR6K1inOpH2+EUvmHiTj8/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5285
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/6/2023 4:38 PM, Chao Gao wrote:
> On Thu, May 11, 2023 at 12:08:44AM -0400, Yang Weijiang wrote:
>> Initialize kvm_caps.supported_xss with host XSS msr value AND XSS mask.
>> KVM_SUPPORTED_XSS holds all potential supported feature bits,
>> the result
>> represents all KVM supported feature bits which is used for swapping guest
>> and host FPU contents.
> do you mean kvm_caps.supported_xss by "the result"? I don't see how
> fpu_swap_kvm_fpstate() uses kvm_caps.supported_xss.

The wording is not accurate, what I meant is : the resulting bits are 
supported by

fpu_swap_kvm_fpstate(). I will change the commit logs in next version, thanks!

>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>> arch/x86/kvm/vmx/vmx.c | 1 -
>> arch/x86/kvm/x86.c     | 6 +++++-
>> 2 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 44fb619803b8..c872a5aafa50 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7806,7 +7806,6 @@ static __init void vmx_set_cpu_caps(void)
>> 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
>>
>> 	/* CPUID 0xD.1 */
>> -	kvm_caps.supported_xss = 0;
> AMD has the same statement. Do you need to remove that one?

Since it appears in svm.c, so I assume Allen(AMD) will change it

in his following up patch series.

[...]

