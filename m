Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95B6773C23
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 18:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjHHQAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 12:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbjHHP7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 11:59:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2926B6193;
        Tue,  8 Aug 2023 08:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691509465; x=1723045465;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lrqv/GIWOhqlKti0m89si+0W9scikKwya4doCUCJVuY=;
  b=U1QeypCU6NUZLvcIRsQaQDtpp1SsvQtTbZIIPBkyEZV2rTrBeSvApUkI
   iW8yMELmM2OSbeDLkdnVteZUd5lwnaiNyLRsiyUglzF4wg4ivXtMgtW78
   LcALFWjz9agF7jp4e6xp6iqN7nkb+2b54ZJTEKmRR0OSquprqJf7qQ4oV
   lbT9E1f24fRVNfMIPZly+3/MO8cEmpK54zbvspvzCvdD5NGDuxghXscfo
   avS40bHMxaNUR6JOc6ou1xhdZiwCjBT1s+gdhOGb5Dwmoedk5dKeMH6Cp
   cEqSA9jgpkmsLKzIvYkECROtBx4n/WeEAhbdabmVJkDkkOBS2Moj45XO2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="457237908"
X-IronPort-AV: E=Sophos;i="6.01,156,1684825200"; 
   d="scan'208";a="457237908"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 08:08:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="724954310"
X-IronPort-AV: E=Sophos;i="6.01,156,1684825200"; 
   d="scan'208";a="724954310"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 08 Aug 2023 08:08:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 08:08:13 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 08:08:13 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 08:08:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cin3Csb1VLeoalANNwi35ka147VuHL4Y7Mb+hxvIoY67EO+Lc5XnOV1skBptRUyfp6+QW+diBaaJov8PMrzqhr2Wk49ZJgSEhBwekZXqOKC0VkFdC7+2YQbW3TEYxukGg+kCv5KsbkPgS0r/WPgm+cxXbRBUNJr44EePsyVycc5MJ5jgIsA9QoZWE+Sh8hezi7UQQCxViMvdo2miyrrtqRPG49UStISf9OpLUpnOJ5S8ANauP2GGYYb6j6CxwujSNkXNe29OkmM06TOzVMxih4CtVrPb32rjUBGT+NOuLU6tvmdx398vo9M4Epc20jOwzGLQkcY+pS1GGkQWqa7pDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ovr26nTSUrKGGSWlTKBNXw5KTPSF7aR29JCDL0fCRQ=;
 b=m/OnDjxtu2VEXPfE5heXjZIcqtVLX36p6IFextg2HmCo72AzWLtLoK8SITiYxoum7NQe/SYDI+Dvn97CF9aqNrENLdqGHrH/VMZxVVQpVTiUUwHzHMtaAU6jZGiTF/Z8R7Qygo9mebBxYU/vl4l2zKwICNNjez/VJnP1+EO0kyktYH8rce18T3gvtMEKpdskX/SIPgG8r4QUDpF38hZBJiuHZ3pjZaCbIX8aLPvRbjO81ufyrsNZX5n0BYeGU8jpOQVktUTPl1RSZMCMg31hRdKxVn8/rnb+B0ySPpLQIVxmJbPZ6Rhc9lmW39DwARaUjHAYd70v1ZCumw8eKrZXKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA1PR11MB8374.namprd11.prod.outlook.com (2603:10b6:806:385::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Tue, 8 Aug
 2023 15:08:11 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.026; Tue, 8 Aug 2023
 15:08:11 +0000
Message-ID: <9fa7222b-311d-a00b-29e5-15e1a7d241ea@intel.com>
Date:   Tue, 8 Aug 2023 23:08:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 05/19] KVM:x86: Initialize kvm_caps.supported_xss
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <chao.gao@intel.com>, <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-6-weijiang.yang@intel.com>
 <ZM1HODB6No0XArEq@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZM1HODB6No0XArEq@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0159.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::15) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA1PR11MB8374:EE_
X-MS-Office365-Filtering-Correlation-Id: ca9d4545-18ac-4d23-270b-08db982147fd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Di581F98zi2V1Uel+/Aovu/ArB0DNQZNkLbFZSo3cR9T1Iin+AaO4MyHIEFN6XSEraB9FtgiVZ0jenj6qcZ5nV1/g5o7GvG/WwjUTfzOj71BUb/04U2caeS2PpQym1ir2o4uN/8TymWtPPuwS6W4k2+XBDka3kba+qx0wAJxxVdMUqL0+JDurqzIobZemUOMdCHazQWWmOHCSQ2OB8avzLMe5EXuoUsgpYcpL825qYj0OCzu0BjSyBlMnuC1Gm1S4T3/AzkGkCvnjo4gk7WjseB8bo4woQs+5cZGAWLn4TYyuVPSzf3YA7j4pZbmu+aedLvTqfpcuSan7vfVF9kZ7gfoOLlkKKDLsoM0fILhE10yU9oIjv+oEzjLvko9ZG3E2sghtowNy1E7NwQ8C5vAXyOCoKMMn1iIIdCS1qLjUZTIHHYU6ejHCWeMVRnEAylRHfxte1FG6u7JnJQWIuYMmZOYHZ8Px+MyVovhVC0KdiMEkH44bAuv/WwmFTtiG78FVnkuw0OhGXFnqS4cOYWRGNQ666guhWI/TbC4MDwXfLZ5yeFrqnuBcJEL3Sc1d60xth+rEhNimc6Ob3SjyWXpawaechLgpUmzHQLcuGd9TsLpdKwd3/sF4tPxAxiPEQFCHqgS+uddMyY/RTx8X4PmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(366004)(39860400002)(396003)(451199021)(1800799003)(186006)(2616005)(6512007)(6506007)(6666004)(6486002)(478600001)(86362001)(26005)(36756003)(82960400001)(53546011)(31696002)(5660300002)(6916009)(316002)(66556008)(66946007)(41300700001)(4326008)(8936002)(66476007)(8676002)(38100700002)(2906002)(31686004)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHRvOC9mZGxaYXdjcmxZVjRSY3pVU3pPZnFCSi96ZnhuWWtTTys4SGVmZ2tI?=
 =?utf-8?B?aGZybStQdGwwc1g3ZDRDL3JQcWdrWXk1NExTWUpQVlpua1pHZ0YyUmxzS3Zi?=
 =?utf-8?B?eXBneGZzNHA3NGtRUGEyZitOQ0tocG5udGhrUWhVMC9QTE5Cbk5MbklFcHVa?=
 =?utf-8?B?ZmZ1cjJhTlU3SVlGVTIrWTNLcGh4aGt0WjBwQ3QzMW5oT0J6Q2x0SStmMnlj?=
 =?utf-8?B?cnAydlBlSkhSTytyV1lOYVo5eVNCQ2xTVFp4RGYyRUxzbVo4STZudy9qSUtX?=
 =?utf-8?B?ay9zUnVhT21SZDNHVjlQazBWdmhIcVdmK3hVR0dySlk1Ti9EVjF1WnZYTVph?=
 =?utf-8?B?YzlwaUY1TWppNUgwUUxPV216NDdKN0J5MVoycmhaRWtPdWVXanJkQVlUdno5?=
 =?utf-8?B?UFhxek9RRllaM1R3bS9WcXRKWC9TZkJSWGpoRHNJZWdRdXh1RW0wK3dTbWdZ?=
 =?utf-8?B?VXpNelVXMDhQdkRHU1M4YnBBb0MxTTg0eTdKUFdidkdMZW5leC9GcnVPZ3pK?=
 =?utf-8?B?S3M5VnpsdzRSSjZocGRmcHZpK29YWHkwL0xyaFN3aXlQSWczVVZKdUE0THBE?=
 =?utf-8?B?aVVvQkpPNHVwY0drQU9XbG1FRnV6VHVnT0tqeEh3R3dsbFFjSmw5Z0d6Rlhu?=
 =?utf-8?B?ekYyZWRENzdYeWUvbFh5YjFlbFpzUnVJZGlrMUNzVmdnTVVRb3FGbVZlSDFS?=
 =?utf-8?B?RFhhNmtKb1Z1VEt6dzZ5NUtTRDBmRGdNbi83bElMaWt3NmZlTktWNGVWM2xF?=
 =?utf-8?B?VnZ1czRDRUZxZVhXZEQ3VDBaZnJoLy9sTUdjTktuOUhEWUVHeENLMnNvRTZR?=
 =?utf-8?B?andhaE15Q25CU1ZQNjk0QkRvWkhpdTRvdC8zMHI5Q2IxOG1XNWlvWGd1K3hX?=
 =?utf-8?B?N3UybE1nWDBXQVNMQ3ArMXFublAzV2ttSzhTZ1MxeU9hT1dqQWZaUTU0d01t?=
 =?utf-8?B?SFhPWTUyTXVDN3JxZ08yMUUvemRMaU4rN25naWc4dXlMa1dINVNLYVJoMFJ1?=
 =?utf-8?B?NERuOWorMzFHL2dNRWZZZm9ITkEyakJZTDJXOEF3UWRDVEdOMlJZZllHV3dl?=
 =?utf-8?B?NU1FZWFsZ0hyaTBDR3hncHpZaGo2RGk3R2tTbWhYWW1TcHQvUnNHNmwvNnRi?=
 =?utf-8?B?aG1mOFNERW9HK0lRQU9WYXRiUkhnNlV2SU5GbG9SN3psOVo0Qmp6M01DMVFR?=
 =?utf-8?B?QTBlY3BUcDJDU1kzdnE5aWhEVms0LzJhS0JmbWpmZDgvdDFBUS83Q1VZUlJC?=
 =?utf-8?B?b3ljajJMSFZpTzNsaGovSk5JWTd2TUFkbW5NOVhpZG1XMFFtdWxLYzkzNEMv?=
 =?utf-8?B?YUsrQUJUaFAzUkNvRURIYzk3bDJ1RlhQT2pZNVViRjkwM0dSeVgwejQ0NUx6?=
 =?utf-8?B?WXBtYWcrYk9DcURITHpqVXVmTUs4K0ZoaGNvclBCa0JqUlQ1cnQySExoQVZv?=
 =?utf-8?B?SFlDaXc2ZHZaMHptYzNEZUJ2bTRMQytyQ1QvdU04S0Z1UFhiamZzSzk1d2da?=
 =?utf-8?B?aDBWQU5PNmtKaGxEakJxbDBkT28yOXZnTWZmNC9KcEROVDl5Nng0S1E4N3hB?=
 =?utf-8?B?cm9xWWVvTTl2L1l0R09PQ2cycEdBTDNXTkhsNFEvNGlUMW5OeFUvWFRvK3RE?=
 =?utf-8?B?bG1VYk1WT3p4d0ZLS0FoVDFTdUJkWkwxUGJxNW9nZkNYcWFtU2tWa3lqa1M5?=
 =?utf-8?B?SmJtSGdYVmZMdjlsOEtJWUQ3TkEvZVdGdC9XUEsrWHR0amFXVFNIeXR3SlVX?=
 =?utf-8?B?YTVpQTVzQ0d3Z2NsT2ZheldLQVhNcmlBcHc4Q01vTFM2ZmlsYVkzNHFzTThk?=
 =?utf-8?B?VGU5WE1HN05ZS1BWQ2NtQnpBaFlQWFcrbURScEtsa0FLRzduR3QxNHNNL0h4?=
 =?utf-8?B?ZFp4and3eTFnbzVaTW1SN2JNTXR2OGpiK0YyVjFKR3k3YzcycEZib0twMEJ5?=
 =?utf-8?B?bE5WVXpMUmk1TmRZQlh4eVFFT2tnT2JwZk5TYjhTb1E3MnI5eXE0R21JNUxE?=
 =?utf-8?B?SGdNRXpxTDZ1ZzcrNlo0OFJtOHFVSXo1SEFnMUtIa0VVQTZZSUFDb2dpTVoz?=
 =?utf-8?B?WHBJREkvWms4NEF4aGRDb3MwUUV1L2gzenl0OXdhVE1Rb0UyRWk4K1lQczRi?=
 =?utf-8?B?YWJRRE1XZXkzR3Q2SzZheXM5eHR0S2FjNklnY1EzNkhpVzFLblU2dFpLVDgr?=
 =?utf-8?B?YWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca9d4545-18ac-4d23-270b-08db982147fd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2023 15:08:11.3792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Zsg1+h7+UUN2bUsdIo2y/6nr6fTZOE5ZwI+i31HfKB7ADwobfXeZJgN+2Xx+kRrdMAKyPmN2r5MIbD7N6RgiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8374
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

On 8/5/2023 2:45 AM, Sean Christopherson wrote:
> On Thu, Aug 03, 2023, Yang Weijiang wrote:
>> Set kvm_caps.supported_xss to host_xss && KVM XSS mask.
>> host_xss contains the host supported xstate feature bits for thread
>> context switch, KVM_SUPPORTED_XSS includes all KVM enabled XSS feature
>> bits, the operation result represents all KVM supported feature bits.
>> Since the result is subset of host_xss, the related XSAVE-managed MSRs
>> are automatically swapped for guest and host when vCPU exits to
>> userspace.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 1 -
>>   arch/x86/kvm/x86.c     | 6 +++++-
>>   2 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 0ecf4be2c6af..c8d9870cfecb 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7849,7 +7849,6 @@ static __init void vmx_set_cpu_caps(void)
>>   		kvm_cpu_cap_set(X86_FEATURE_UMIP);
>>   
>>   	/* CPUID 0xD.1 */
>> -	kvm_caps.supported_xss = 0;
> Dropping this code in *this* patch is wrong, this belong in whatever patch(es) adds
> IBT and SHSTK support in VMX.
>
> And that does matter because it means this common patch can be carried wih SVM
> support without breaking VMX.
OK, I'll dropping this line for VMX/SVM in CET feature bits enabling patch.
>>   	if (!cpu_has_vmx_xsaves())
>>   		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
>>   
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 5d6d6fa33e5b..e9f3627d5fdd 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -225,6 +225,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>>   				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>>   				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>>   
>> +#define KVM_SUPPORTED_XSS     0
>> +
>>   u64 __read_mostly host_efer;
>>   EXPORT_SYMBOL_GPL(host_efer);
>>   
>> @@ -9498,8 +9500,10 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>>   
>>   	rdmsrl_safe(MSR_EFER, &host_efer);
>>   
>> -	if (boot_cpu_has(X86_FEATURE_XSAVES))
>> +	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
>>   		rdmsrl(MSR_IA32_XSS, host_xss);
>> +		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
>> +	}
> Can you opportunistically (in this patch) hoist this above EFER so that XCR0 and
> XSS are colocated?  I.e. end up with this:
>
> 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
> 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
> 		kvm_caps.supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
> 	}
> 	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
> 		rdmsrl(MSR_IA32_XSS, host_xss);
> 		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
> 	}
>
> 	rdmsrl_safe(MSR_EFER, &host_efer);
Will change it, thanks!

