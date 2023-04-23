Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733CE6EBD53
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 08:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjDWGMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 02:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDWGMd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 02:12:33 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CC01FCC;
        Sat, 22 Apr 2023 23:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682230352; x=1713766352;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mVKT2iwkezU047YXwkHMWBs5f4ESu0SGfkDkVnPRkFQ=;
  b=hOh7HBZmNL4Z8y3hrrJIH2TI6+fa4uAk4Vz1OggQ3o0QlWedvutbZgCC
   YRlJ6S9RQ2YMoTR64S9uFttcQ4clp8E0KjTdPY1NfP53N070FW8NvoNwP
   WHXN7WL+CbpTuuqTrHzIYgPR7v52aM5dIWvle/4uM8A1KW8+lYaAqdQmd
   Tdv4IbJr5uQEsY7DKOBhbZiTOq2fLtUG1aTq6Qdhk73akCqXdGOHrNYsF
   E0Z11J0c9ZdD8jRCEraEBAzZq1fH443XQCCNgkF7mApzKraf1+3Dtq7qW
   nMxPyz0nuXPW/bdlG0sw0db1QhY5udtUdFthASVsCm1ODIdttLEP+Hoco
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="411523721"
X-IronPort-AV: E=Sophos;i="5.99,219,1677571200"; 
   d="scan'208";a="411523721"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2023 23:12:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="686304157"
X-IronPort-AV: E=Sophos;i="5.99,219,1677571200"; 
   d="scan'208";a="686304157"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 22 Apr 2023 23:12:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 22 Apr 2023 23:12:30 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 22 Apr 2023 23:12:30 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 22 Apr 2023 23:12:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fw9j9qAsZdcOK+7ONS7UhyCL7puqWr0KLy8QvqL5L3GjPG4HQqqfTcaFkzGzGpeZCk6powqqwr0kzfdmyOeqeuywDEepT+dhZAa6tYzAkZdEh4QBJn3q73oHAydh7Inj0MQdeBRV8cCE10Yz8GMGnAwcC3Sa6iHepb/sBKiERfUhUULxjBEXUwrF9xf4j4KQt1GxyB4tvWh0lEz9oOeB42/VieWgP/byvLeqbLBwybfroV8vdhYrYDuKSUt8zZScduIdXTuDMNmuM7XOoOytPURvbF9qcPA23pOsH7rwEEX/3CgVcUD3cyymDrnd6u1+ovvbC5XBbnKMHHRQ0KBddA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B/ftO8JuaHLrZYgzQLyK6eotX5tjBAFFwdgD3ZaPqjU=;
 b=eGOox60bR+2CR+/iKafN/g+mM854ApU11qPfK7BcBDqGErDXwgAFg8ODgFYWj4wx07TEH4bGozsUlGihCqYqmYSVNk28lEiQTKodbjqtk3kZuInrru1WMpL0KHUGyE71eWNZT9XilACN+vfl5mfMjRbMlCI0ga7VRLR191lPkbJUarXiFl5L7xC6LSsYTCqE1lBDmRdtkJH1DiK+KzGIhErBsqHtAFKAQ7LLieW8FSsn7b9IRx38sbJScLkz5zyjt4mFdTbR0mxN7zAf7ZYrSggYH8Blh+ogCGQCn3MKy6wW9fSCwCkWbF3jnuyoL5z5/g65K6ZtklUJ5HjFj9LSUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB6351.namprd11.prod.outlook.com (2603:10b6:8:cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.31; Sun, 23 Apr
 2023 06:12:22 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea74:f9ea:fdca:4890]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea74:f9ea:fdca:4890%5]) with mapi id 15.20.6319.031; Sun, 23 Apr 2023
 06:12:22 +0000
Message-ID: <d0c5c217-646c-fb02-51e6-41c8fcdc00b4@intel.com>
Date:   Sun, 23 Apr 2023 14:12:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 00/21] Enable CET Virtualization
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <john.allen@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rick.p.edgecombe@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <20230422130240.GJ1214746@hirez.programming.kicks-ass.net>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20230422130240.GJ1214746@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0156.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::36) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB6351:EE_
X-MS-Office365-Filtering-Correlation-Id: 14c0328d-05dc-4643-c4fd-08db43c1b376
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xvsJSI/Z1ytf1km8LGAMqnor8Mw3dyAkC0GimTs5wSOg9Ily+ryKhySn5oGDeicfTAynOMLQbjlhJPqcWM07E21tvjv8uAieaTJ6UuT8m3NTAJl8NKDSlpo3egChJ7WwQq/zOBA0d7VsFMwGDkHw98qgHB0tAUey6xUuEmQs+yw/+oYRI2ry6BmZ6ttzigTkZEdS4jDXefZqrGEPtFcmzgDZ6eyhnOQLdwEzsrcN3tyv/5SKlDcq+uQdedj6vEeyA33ugHQu9r3oo5oqMVPedTfU6b8it5ZaDlKHQzr5pAKGUWn+/aXFkgcvdczPI4/ytQ60yaCF72OkxnoJ0N21+6TrXH62dp9es/KEzJZ2xKEjj/ST25H9fiePjz/kanajzY9DAzC9t4zCysA+KZKUtZhg/chcqhoHy9y9C5nR1yikjM6x7T14r3bsjjh6jWSRnN+t8KA+6SvgTLuT35WvpNGU+zFQqr4vix7Bx7j/cqLLl10kmB0ut4VlxbF41mFIzV1Jq8Z8icXfBpLUfTARplCHyzvYNUVugWKv+ZswCEF/+v7+bKZ9qwVEpeY4NuAtRyWc+h26ivnonZYZTfdOmcZ4KWm4w+oMo+t3EC+90FryNqK1y/e4HkTxPrb6/g6tR9nYSUuGj5ux2ki/aG4jTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(366004)(376002)(396003)(451199021)(2616005)(83380400001)(82960400001)(5660300002)(2906002)(31686004)(8676002)(186003)(26005)(6506007)(53546011)(6512007)(38100700002)(8936002)(6666004)(41300700001)(107886003)(86362001)(66946007)(6486002)(36756003)(478600001)(6916009)(4326008)(66556008)(66476007)(31696002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0UyQ3ExTklieWZ3djdwdHZzZEJ6SG9tSUdKWFkwNXc5UUFGNTc4UlNHQ3JQ?=
 =?utf-8?B?N3pKTTJoVkNWSG1waGFpN3NxYnljL2VlVVBmbUVSeXk4OERLVmFDaTMwVVJU?=
 =?utf-8?B?am5LS2FDK1pPVy9aL3I2amZKZVFSOWx5ZE9yY1NKTGNVVXdtaEpMTUZSakJJ?=
 =?utf-8?B?QjBqclIzRkdQckllWHZjYjhYNXBjR1U3Nm8ySG1DSStTNUZRaTUxYnZpSk00?=
 =?utf-8?B?dW9SejhhT1NrSm11cU1pa2FjM3ZEWk9qUkI2SFpJVkR2WG4yRjVKVVVQMWtj?=
 =?utf-8?B?R2pRRFBuSWxCTS9RVFJRQVpuSUk0N212ZE82aFRSdDJqZFZZakRkYlpRTVlR?=
 =?utf-8?B?TWpNUTQzUXN3TjVtdzJjWlBmcjVGckx3aHRqamMvelJnaHpmR2Q2b0RUN0lq?=
 =?utf-8?B?NEpjK1k5NHY0WitBZ3hkaEFaWkRheVJ0a2JycHNTZGdOUElSL0lxQS83SjR6?=
 =?utf-8?B?NjFOWHBmS1ByWUhWWThFNFhBR3RFZ0QxalA3VzZWeURjdXc1L2hYZVBDZ3dZ?=
 =?utf-8?B?VXR1OU9WSExRZ0wwSFBZU3QzdlF2NVdWdjcreklXMmxITjhITkJrS29HSm1O?=
 =?utf-8?B?NW00UTljWkdOK3p3UThQaGZLeXJ6b1puNDBqaW5mSzhnbUxsbDJ4YzZvWkdl?=
 =?utf-8?B?YU9OcHZFTXZwN1hvRmFqMldsYjFJNlVwMHlBRXk5UW9CQ2tIcmR2bUx4NDNh?=
 =?utf-8?B?NDVwYy9od0l4WVlUUnUzK1k4ZFQ1eWdaeCtwOEVBOTVFUzY0RHkxdSszMjc0?=
 =?utf-8?B?VSswaEFReWg3YzQ0cWZuU3RZRHUyL1kwRGZFYWNJY2t5K3A2ZE1vcVk0VkdG?=
 =?utf-8?B?SGlnUnBRSlcwVk5DWXpoeUFCRFAzcFFURk41VHFmaHJvd0J0SWFIZkYxdFl4?=
 =?utf-8?B?SXJxUFprT0l5QWVabWswWVNwbzJOY1RjY1MrKzdTMVZzY29Obzd2cU13TTZp?=
 =?utf-8?B?d3VXQnI1WEc2Q01NSmxrZWFFRW1KYkFKeUY1VVgydE9mRUNYbWJ2S0J1cGtz?=
 =?utf-8?B?ZU5sZTJUd3lCR1BNait5NGwvWnRzU1k5QU9lOFEwdGdhNmc4Zk56ck5CU0E4?=
 =?utf-8?B?a3Z4d0thSnduY1dtUlRBYTB3cHphRXp0U1BsQkw5VnRpbzQyMlJZWUxCbndW?=
 =?utf-8?B?cHdYcXQyZVd2citJZXZuUVlDWkIvcUdtTW9jR1MvK3EyKzhUMitUSDZ6WWdP?=
 =?utf-8?B?T0kwQ0YzZ2tPaEhJTFVFU09KRDdCbHQ3Q2FXUFA3TE1PWHBrS0R6RGpqMWpm?=
 =?utf-8?B?QkJLV0c2NmJNQWNIL2M5N0JudnM1WFk1djFpQ2NCVXdMMHZzTHlGdkwyTyt2?=
 =?utf-8?B?aS80SHMzSndXRi9HSmRvcHpsOFVQUG0rd0dPWU9EaTUxYlBRbzhGTXlNYlVF?=
 =?utf-8?B?aW5lVzdLSGVIRXNsTWN3VjlMREVVNXhVR2VyZ2xaQ1JpR2JlT0EwL2o4anlM?=
 =?utf-8?B?VGJGZ1FPdkYxbWVqN1M1SDhLK0pTVWhjVGExUTBTL0VqSDVMUmxFdUt0cUtt?=
 =?utf-8?B?VzNUUGZZZEw3UzI3UHcydEhveXlQc3loOExKZHd0bDdPQktBaXhESEhndzE5?=
 =?utf-8?B?ZVBtcS9jSExsNHFVMGJXdTNXVlROYVlSOXhDcWJBSjIzQkhRSyt2OWgvcFBr?=
 =?utf-8?B?SWVwa1R1eVlpMlJVN29icWphMlZoZmppT21hR2IxVGhIdU9BWDczelluT1FV?=
 =?utf-8?B?N25vYm9CVEROTk9wZG41R2wrcWRTdDMwb2JwajZudWI4MkhsakI3T0UxWnJ1?=
 =?utf-8?B?dTZVU2pvZ1pzeGNUTjhXaGVDVU1XR05iTEFaK1lBbmJ1NWEybWk5ZGpxcUlU?=
 =?utf-8?B?YVo3T2hMZTBWY2Z6dno3QVB0QWNWNlpFZ0FIOEw0amFLQ0xQQzBMYTE1bHRv?=
 =?utf-8?B?cE1tQVBJd0hyY2xrWXR2NVRSdzhnTnZ2dE5FY2oxcGN0QWdOOVlWOHdXWXlm?=
 =?utf-8?B?b3k0NngydnY4RmNGU2tZY3ZETHYxVTRscC95dFBaQW42MFVnaGFHSTR5QVI2?=
 =?utf-8?B?Qi9EZTlzK0FLNFMwV25HZG1pZjlxRC9UcDFOeWZmOU41YmphWlNSeU9iZG5H?=
 =?utf-8?B?d1RHUmI5MW9Jd1Mvb2JvWStqZ3c5eEFramlTVjcxdWE1SGl5T2hwMmlTQ0JU?=
 =?utf-8?B?Y0JvUllmSm1LbDJlYjdaaGI3dms1TDRQQ016cXNDUCtjMDZxcVBjZnlZakcx?=
 =?utf-8?B?UWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 14c0328d-05dc-4643-c4fd-08db43c1b376
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2023 06:12:22.4744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DsPZKR9/XtGkt/Ulh4li04jkEvAePdOCmd0q9MUlpojlzHL+GsNYlrIDT7fGiIpQ0QEIerAWKAw/CsHVoGslZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6351
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/22/2023 9:02 PM, Peter Zijlstra wrote:
> On Fri, Apr 21, 2023 at 09:45:54AM -0400, Yang Weijiang wrote:
>
>> Implementation:
>> --------------------------------------------------------------------------
>> Historically, the early KVM patches can support both user SHSTK and IBT,
>> and most of the early patches are carried forward with changes by this new
>> series. Then with kernel IBT feature merged in 5.18, a new patch was added
>> to support the feature for guest. The last patch is introduced to support
> Yeah, at the time I had to hack up kernel IBT guest support, because the
> platform I had to use (tgl-nuc) didn't have serial and so I had to use
> KVM :/

You did it and beat all the hurdles :-)

>> supervisor SHSTK but the feature is not enabled on Intel platform for now,
>> the main purpose of this patch is to facilitate AMD folks to enable the
>> feature.
>>
>> In summary, this new series enables CET user SHSTK/IBT and kernel IBT, but
>> doesn't fully support CET supervisor SHSTK, the enabling work is left for
>> the future.
>>
>> Supported CET sub-features:
>>
>>                    |
>>      User SHSTK    |    User IBT      (user mode)
>> --------------------------------------------------
>>      s-SHSTK (X)   |    Kernel IBT    (kernel mode)
>>                    |
>>
>> The user SHSTK/IBT relies on host side XSAVES support(XSS[bit 11]) for user
>> mode CET states. The kernel IBT doesn't have dependency on host XSAVES.
>> The supervisor SHSTK relies on host side XSAVES support(XSS[bit 12]) for
>> supervisor mode CET states.
>>
>> This version removed unnecessary checks for host CET enabling status before
>> enabling guest CET support, making guest CET support apart from that of host.
>> By doing so, it's expected to be more friendly to cloud computing scenarios.
> I've on ideas about cloud stuff, but there is fundamentally no relation
> bewteen the host making use of IBT/SHSTK and a guest doing so, so there
> should be no dependency there.

Definitely as long as there's no quirk required for the features! Also 
eliminated the

upgrade efforts for host end users in order to play with CET.

>> To run user shadow stack test and kernel IBT test in VM, you need an CET
>> capable platform, e.g., Sapphire Rapids server, and follow below steps to
>> build host/guest kernel properly:
>>
>> 1. Buld host kernel. Patch this series to kernel tree and build kernel
>> with CET capable gcc version(e.g., >=8.5.0).
> Why does the host kernel require a CET capable toolchain if the host
> kernel does not in fact need to make use of these features in order to
> provide them to the guest?

Oops, this should be a typo, guest instead of host build requires 
qualified gcc version.

Thanks for the comments!

