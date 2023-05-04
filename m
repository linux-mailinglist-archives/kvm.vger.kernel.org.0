Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11AF36F628E
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 03:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjEDBL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 21:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEDBLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 21:11:25 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C009F1BD4;
        Wed,  3 May 2023 18:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683162684; x=1714698684;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=zSxaL1Sq4EVfdKWAEtc93HZ/55hT0WSvxrJgAsmmYP8=;
  b=bfDE8zH80B9i+GYHGZlBNGsImgnOBnc1HTgdrD5TBRUWewqUlEBV7Q5t
   iKSK+IQmwUH+MINlxbXBT7rG+UHoxO499Fc5V5nIxQKyfJS/C4du3gXBn
   bN9yi7b4fwf3xMFU8+eGETdryraeOs0QeFAGSCYD+E9A0Ul+WvWe1jnVh
   oKMzNaJo/xTnzsVIEX/VxSiiY17/q47j7+ph7GrTBeCZw2edrAo5gXk/k
   tPPIn0d6UcIqpRcOp4nYKfa21Y8wXojKJF0pXC1QuVMYGE/vW6GNXRTL9
   3uyMh/bXEbl/ddUK4e8mnPlw6qpBBbrZ1MhoevDTvnUzWbzra6OkSfyOF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="333171318"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="333171318"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 18:11:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="696813104"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="696813104"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 03 May 2023 18:11:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 18:11:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 18:11:23 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 18:11:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iIINGmp/fXbybD9u0smVDfQuNz2BAwjus58ym98/9xiswJpL1u5lG3+t1IMkmHUFUco7i46a0wmdfg0PSioMBWnkNnmItZXRqdELLhJP7H+1qz/ncbBoQViOfHcVqythvW1Cdwsk6sjM7CtIBGiBswMGnrTiUQApYq5+c8XdTeXKb/u3ltR46YJTIqajukW2DoIKnglqe3U7Jkep6OLfgJAXII+dyRKzFgU1zAp+bqiIFtXLri1t4clhmqsI3DGM+JjQSM8Dc9nB76FLwttJbbmv3rWbgoOOzv1Amzsx9D74ZtAjuhyMypsxF3zSb6CRmqoikF3ExJwuWlcAiThhYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mBgO269rSVW67PRnY0l0JWTFXKIWkgW6tvMijMjyqPg=;
 b=GknVMFR9gnDzJWVmXYZUBoRxQVRdKBYClWz52VhyJNJGQ/s9yjOiREozA7eW5M9YgARJioroUCYdC53gtnPAjBt7IXIeXvuSwtSJhyGg2mXJHuzAJskfxD4BNK0/Zed4Q+PI0ktEVFkWtEwCLktnGcqawrCjM9FLZ7TPdqYHdQ/5jXoemZfwum7sD3WxRyHzCGgvMBiMKP1S+XDFwF2AChfWies+M7Vaww8dXngNWeHKXGkMNI+jWm+FOuw6Kc0U6pnjhrUnjQZzHmTDJtZsoVaQcMA4ECiKQmqlbGOE4RyeWy9wq/lzwJwY1sG9imjZDjABoC+d7OCEt/KTaIkfag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BL3PR11MB6531.namprd11.prod.outlook.com (2603:10b6:208:38e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Thu, 4 May
 2023 01:11:20 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::1ff:c7e7:87de:6d97]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::1ff:c7e7:87de:6d97%5]) with mapi id 15.20.6363.026; Thu, 4 May 2023
 01:11:20 +0000
Message-ID: <0dc77b4b-1f8d-f21c-303b-3ea6d5b978db@intel.com>
Date:   Thu, 4 May 2023 09:11:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 21/21] KVM:x86: Support CET supervisor shadow stack MSR
 access
Content-Language: en-US
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "john.allen@amd.com" <john.allen@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <20230421134615.62539-22-weijiang.yang@intel.com>
 <918166a78f5306210b1877107609cbd340f79a67.camel@intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <918166a78f5306210b1877107609cbd340f79a67.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0214.apcprd06.prod.outlook.com
 (2603:1096:4:68::22) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BL3PR11MB6531:EE_
X-MS-Office365-Filtering-Correlation-Id: b0710b4d-addf-4f5d-df25-08db4c3c7809
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: owhad5ZXcM3vJhaoy4tgZQwbGbtfqXhaA/363AKEnLN2N2qRDWbvHxq3N3DEdiZBLkevMc+wofNI+lA4Q62StRTK+UOQIlC0r3dA70kNMEWf/Xfjd5CbrkuwxWZicFhdbO0ytu0yN4sMDG6AVKMPv42FOtrWSRHVtV9Bu+AJXGp/BGWhk9iw4guFMCHKNesc08mum+fjOAABK3gn89Kiq6nXjVQiWQ9M5slGPYa9EQZhofktY7Xp+mcxZK+xFaWbJQuOeMif6YZR5ULGdeHvVHEtnAyiqYiI3V0LpJMReSF0Cz+DJoNnhZJMq+GAvwUh5REMk5XgJkjWt+H2b6IKSg8cK8Dh2tYUYtrzlD989TbKFVUvUTDaBikq857IFBmuKI40pnwqzkxnzAgNH5IxIBmG/WSKdjCZ8g25Hv1gVtfMXZ4ftrCNSaPfawOKC8wCpIxKWqLKURc3pL/V30dkGdAe9Oq0Z2u74y6e2feTsp0BO9SqeQFNcp7NlTccSs/58R1BcAdGxupOBPj+pmmFdMspPld3Ec/zBtl9kfcGCso/W62pAIYxYDmn/P4jeZVwBwwviaHBld6CjqQ4Sp39FHQPH2a7ft/0ytjewQEokgqwSRfq6fc1tWEx+cqcn74uJLdBr+2XConGstykTvC3+DDcYnnNupC6jZa+usRmznv1zlocR194kEJJzxONJNnFhmi7kfOfB3Rez2Ulkuka7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199021)(6666004)(316002)(6506007)(53546011)(6512007)(26005)(186003)(31686004)(2616005)(83380400001)(4744005)(2906002)(6486002)(5660300002)(478600001)(8936002)(921005)(86362001)(8676002)(82960400001)(38100700002)(31696002)(36756003)(66946007)(66476007)(110136005)(66556008)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZENwZ1dCNHo1TlVMd3JTMHBiTXJEbkNRMmxyUVpqSEIzRzBXOHdxcDI5SWJM?=
 =?utf-8?B?VWRReGhhZWNubnJDYVkvbjNCL0I1VTgzL0t0ZlY0a252YzFJMW1aZWZjZ01J?=
 =?utf-8?B?OUtKa0d5dVU0aS85aElzclEyK09kMXA1c2dSa2N6VEdMek9uWGNiN0FaRlJR?=
 =?utf-8?B?M3gyYlN4dkJ1NVBHN1lWWTFGVzcxbWl3RWxDOWl6VUQxMHhyZFZGNUNIckFn?=
 =?utf-8?B?M3lGUlMvWHhCaVYyYlRXVVJtdndkNWszTDNwNkF3Q09vcEhyd051a3ZvL0Y2?=
 =?utf-8?B?RE9LUjU0N0Jnb0xvSVQ3YVJXT0JtdS8zODlEN0lJVUgwR1hkOVpSQW5MU0Ri?=
 =?utf-8?B?OXVGMFhzMWkzRHdvS2xncFRJSnEwb0laU3pCZ1ZlMEZkVVdCdXc3ekVIQ21T?=
 =?utf-8?B?K0pZdHhsbW5nWVRSeXVNdVVubWhKQm9RclY2SURkb0tpSUI1VHZ6KzNqQTl5?=
 =?utf-8?B?UUh0TVM3YUl6TjZ6b0hGbFY1M2xzbVgvQjF6MWZVSURxUllxV1JlcDBJZnVJ?=
 =?utf-8?B?UmZIRW5UcWpKeUM0ZkRFMm5zSFZ4SWNpMUIydzRpekcxbE1zZ3R6dGR5VThZ?=
 =?utf-8?B?RnVBTkcvN3JGMWhpNk5nK09VZUNEclpCVDEwb1ZNYm5ISzBjYVRVaTdkM0tP?=
 =?utf-8?B?NmdyU3NGaVcrY0tiY2dJNU5ZR3VzN3NuZlRocHJJZHNaRVF6YnBEdGMzQjlR?=
 =?utf-8?B?KytDUyswaXM0WVRDaFRUZFNERWN5aStPYXJ3UEJ0S3ZsVW9nK241blVrcys5?=
 =?utf-8?B?QlNjb0dFU2trYUxYM3NqaFIvVnEzVEt4WXBqcnhSU2dpems5Q3l6blZ1em5V?=
 =?utf-8?B?TFFRM3RRd1ZkTFFSVS9Jcm9oeWJaYndWWWhhVU8zUTV1RUdWdXVaZmMwcENy?=
 =?utf-8?B?c2FteHhJdURyTnZ1cDNzeXJXL0pFUHpoaXdHZ2ZSQWZEckZZWDBWRzk2dWJk?=
 =?utf-8?B?aWljVEIySGdiZDUrR0NwcG5ab1JrSXVJWERsT2xwRkpOTU9CNm9rcGdhZS9Q?=
 =?utf-8?B?dllqOXNWTW5TL1NYbE5CZlNnYWVDM1pwdndXWkpGaXdlTktUdXRmcDJhcnN0?=
 =?utf-8?B?MFR4VEt2V0swcXhJZjBwZFozSVNnbGRGWnFwK2VKTHJJTnZGbXh0N2JEejhX?=
 =?utf-8?B?TzU3ZnR2Z09vMkU4c0E1Y3VPUnF6dkNoQWFzQklwVEtON2FKckpzaFVkd21x?=
 =?utf-8?B?ZTkwOWpQZjF0VzQ5V1lhclVzNkRvUVhoOUJMTmJjVkluSXhoYk1YQktpWWxw?=
 =?utf-8?B?QW1wNWNZeFppTlV0TnNJM0ZiN3JFTWUrMkY1aERWRWlkNkQ1dHhibURPcGxV?=
 =?utf-8?B?WThxUk96eGZiSzJZdUFqakk0eFYvRnRNS2RQK0pSbUtrUElzQmVGY1hlYkFY?=
 =?utf-8?B?dDlwRTZObjlIQmg3aVliSHJXZldzTjJEVTI1cUlNU1ZJTHRpZHh5R0todkcw?=
 =?utf-8?B?MDlLNFR5WVRYV0IraUJsbmp5T3lhQ2V2T1RacFJMNCtON3J1WDcxdFhYSEpW?=
 =?utf-8?B?UW94UVVmSEo0NkdJOGZtcVgvVnM1d0JOdElMdzlxMkpRSUxxNWR3SUVheVgx?=
 =?utf-8?B?SGVIRkludjRBK2hTc0U1ZXZnSnM3aVJUNXlOTVFCbDZvdVRBVUIyMkFHQTQx?=
 =?utf-8?B?eXZoZXRSS1pYWDVhbWxkQXY4c3BkK2E4S3hzRndCaXdHLzNCaFRCMWRXaHZO?=
 =?utf-8?B?dnZyNzV5RE9sYVFJaFNob3dkTGZ5UFNaSjhjNnlpOUR6NWhWejZOWXNOQkEv?=
 =?utf-8?B?MTlxcURkVGp0T1BZempzMmIwMmFsQ3RYN1pxdEFlTzdNcWhnSjdpSFBYZFpS?=
 =?utf-8?B?dWFlT2l5L1IrZUFMTzQ1S0twNUx3dTN4Rm9lQnRwV1FaK0puM3NFTU12Umov?=
 =?utf-8?B?a0U1QVI2M1lHMjBDT0FuS3RVZDFRbWhvRjk1RlpDVFlDTGdLSHlhNmFVdGVx?=
 =?utf-8?B?ckVkUE9zTis0aE5yMFRQV1phUGJoS2xpZHMwMzdmYmdSMEIvQjFFT2NyMFlM?=
 =?utf-8?B?Z2xwWG5uRXozcWs2UHJKRzJtR1Y5NW8zQzVaR2Ewa05wS2VSMDhmMkovb3BQ?=
 =?utf-8?B?alRNNGYzVW5MSkFtY3JFamxrdUU5VDFtYSt6UHo3MWpTRkpETUNYTmtMOXpm?=
 =?utf-8?B?SUxJN2pRMklFUU1DK29DZW9YWjc4eUQ1clRHWHhQN3p1dXhpcTZHK3hyVmFx?=
 =?utf-8?B?ekE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0710b4d-addf-4f5d-df25-08db4c3c7809
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 01:11:20.2666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B5G3qWXvqXIHVI8v3KapjdjmBS6FfwqnLGUYCLHEv89/IaH97n97Hp0ehxQTOf5dvr+BULhqaZ1b2+y6EFl/9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6531
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/4/2023 1:06 AM, Edgecombe, Rick P wrote:
> On Fri, 2023-04-21 at 09:46 -0400, Yang Weijiang wrote:
>> @@ -2471,6 +2495,12 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu,
>> struct msr_data *msr_info)
>>                  else
>>                          kvm_set_xsave_msr(msr_info);
>>                  break;
>> +       case MSR_IA32_PL0_SSP ... MSR_IA32_PL2_SSP:
>> +       case MSR_IA32_INT_SSP_TAB:
>> +               if (!cet_is_msr_accessible(vcpu, msr_info))
>> +                       return 1;
>> +               kvm_set_xsave_msr(msr_info);
>> +               break;
> These are supposed to be canonical too, right?

Yes, I'll add check in next version, thanks!

