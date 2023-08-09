Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE2E775296
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 08:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjHIGL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 02:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjHIGL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 02:11:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4A712D;
        Tue,  8 Aug 2023 23:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691561487; x=1723097487;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Eilgb0YMvY/jVICjq6ogc3yR9EsGLKfBXoOrCEA9OVM=;
  b=ROn7Ibi9hzFHkaNDjtOOpKqAQSGxnox+lCMs9vJqVT9K6aDGpAIwxirN
   TPnd917oeF5TQjbCesBE0Wg3LsbNa+tb7LgVASEMFTjvGQjjsG2eVZdvR
   4issrCn2/FQMVWO+eMK7xe/+eYLHDsXS5evHBe+qTlQY5wDZpAcYSKF6j
   acdm/yRUjBf/AbHZuoz2Tosv2cngnGj7aqB4iIaaMiNVFmi5Sdd1RBsJw
   q1lZzbduPtkIOOigdghvmVMQhaiNfNCq9TzQ0f+TqP6FBLYQ0+ZKYTb7x
   9ZugxAjdJOiA3JTVQPMMaWqA4xViHFi5I9TK22w6IfDdMparb3Qs6eMCf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="355999257"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="355999257"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 23:11:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="734863805"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="734863805"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 08 Aug 2023 23:11:21 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 23:11:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 23:11:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 23:11:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFq9DGdZR19ERDMY2ZjUuUl2Wb2a1epkrGrSkny6L7qCwTbkfXSQEZU+2pMQ0S9ZMKAeY3bKXEon11oJhoQiJm1EQ+XIoBsmtrGLjKzsLgQ9o3Q8OF1X6/eBsTA3cX/zEK+mKg4JmT3lSYb24lfPgYj3d/qnvfkce1k/OSUzlF2NDV2mP1wUQdFQ80L4rHzvpkQHJW8UbkG6/qRjHrhQIk/j5bRf1CaehHNts1f9Jk623+NaU4+YY7axj+gzz/jSIF1OE5vIuQrG5NCMJT8ahbHk3JAceO+ph9kAKZaibFHXaf54cp4dfYyhenwphplvYxLvKpHd51G4AEnhGaRlNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/tUvg0CaiSSaCDhs6xNfi/dvKpwkOUhuWYmeH1EQYM8=;
 b=Gp/DyoQqvuLh9wC5hdit29UGGyWbFTIF6y2r+Qvr/i4p9PFDnGg/n66m3+yU36n0leFbgXSuQ84pnumkCGeO3pXxEc0QwQEVj4aGe6fgcc0sV3fHbbiUq36SEtdVYuGVACg43DT0kckjChw09omqnG5MxCg4yICk0NL4SZnMrtRRrK/T2TzU3EcYOxHpoTVmSU5iv8VWz8VLKJoQh3iUbEh/lx7r12GyExoN7K500t4LA7N7doDhNk1kFQx5arDN9uCnGHmKE3RstliJBGZNA/rjg47LiOPOyGoEXCOw2EljvYdrxWZOJM4aBdxHyUcXcur0W/EbIH3vW/vTsZNsjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB4972.namprd11.prod.outlook.com (2603:10b6:806:fb::21)
 by MW4PR11MB6957.namprd11.prod.outlook.com (2603:10b6:303:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Wed, 9 Aug
 2023 06:11:15 +0000
Received: from SA2PR11MB4972.namprd11.prod.outlook.com
 ([fe80::2685:1ce9:ec17:894f]) by SA2PR11MB4972.namprd11.prod.outlook.com
 ([fe80::2685:1ce9:ec17:894f%6]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 06:11:14 +0000
Message-ID: <21a1a47d-4713-3c69-b645-c6c74de6cba2@intel.com>
Date:   Wed, 9 Aug 2023 14:11:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 13/19] KVM:VMX: Set up interception for CET MSRs
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-14-weijiang.yang@intel.com>
 <ZMyz2S8A4HqhPIfy@chao-email>
 <f894d23a-5c6a-d189-57ee-8f2bae0baf6b@intel.com>
 <ZNBF4t+x5Gf14PV7@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZNBF4t+x5Gf14PV7@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0004.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::12) To SA2PR11MB4972.namprd11.prod.outlook.com
 (2603:10b6:806:fb::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB4972:EE_|MW4PR11MB6957:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f1de976-3f6c-4f03-53d7-08db989f6fe8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BJVJp/ReclQcHpYM9ofQgGtiBPpdNPSMQUwmCzNDzwcUw2qB/wD63ylv/vucyaVX+gQwHuy0TxVKIPuExtgXl4p1WgNHZTDO+CaNjipfAA2mbIisDeZ9uvtrcjI4aEuZxMRLUGn1TwiP4s2hVtyfBfRZApRh5RtP1WLE2z4tvUPFdi4hX9x1xKqAUwaAxpeJ0TF2LFpaujPKC+DCnPHuoMv3pkcESxIuSm8atW9b//YMHvINvZi/5NImuJ1/VkCku/xBCI8QlfnK8xdW9c+t35NjflL98iVsPi+RTrqDJfCBfj+7zR+wBArY93weNDb9f9cgn7O5i7MNSYjfHhI/Z4hsqteaYiXMDx7pUyAEbprE07psLxMYMTt+ZCU/P+UNyqJvsdC1Qj4mYlDmIia9I0Wp24NqDQMTBSAz1RUfhPkfvJA9GiSrp9MMiKcb/0M/Z75VXashDR9gGW0sXDoW8RsWXrqUR/x/sVMiRgYxvbn0HGDLs0m6oaTPf2m1Rop0+P126pFVBKSfxn8iQIyRxXpobskioSwJMFRxJ5hcaH3APmHbSj0xCyA6vqXD0MSSNh3bVvvSy4E0CkdZTmArJiA0LlvyyYumjvWF3a1cDQYKYHMSgPo45OkQ2dV6vR/n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4972.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(346002)(136003)(376002)(451199021)(1800799006)(186006)(8676002)(8936002)(6862004)(5660300002)(6636002)(4326008)(316002)(41300700001)(86362001)(31696002)(4744005)(2906002)(6666004)(6512007)(6486002)(2616005)(53546011)(26005)(6506007)(36756003)(66476007)(66556008)(66946007)(82960400001)(478600001)(31686004)(38100700002)(37006003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFo0VDd3SU9WWW8yejNYZ1A1R01zNElMRWRDTmIzU1h1b3B6NEVTWWNyaHI2?=
 =?utf-8?B?dS8wc0xTK1RoQndGekxrY3BrQ0NIa3krenFlTEVZLzNRWmxaRll3Nk51R1dE?=
 =?utf-8?B?Sk1NT0dQVGt2K1R2cUIxNW1GYlZIODBtVHNJSXplWlZpWTZjZE9BYnFycTVX?=
 =?utf-8?B?aHhObkNVbHFqYnlUMVlpbGZIazVlVmo2UVNSRUVmL2xjVkJPcGduQVZqL2tl?=
 =?utf-8?B?MitPNHo4OVZtVUhLVVQ3TkhqWFhTWUx1Y09WajdjaFVhOWV5dDhJQU5xa015?=
 =?utf-8?B?SlR6eGVpdWFUS2tVREM1aWNkY0NwTzE3RGZVZTRUS2JreXhUdGgrcHhPV05I?=
 =?utf-8?B?VHdKZitCY1NHUFJVK3VLQmlqZk4veGdkWmQ5YjB4ckF2RFZmcjdLODdTczl0?=
 =?utf-8?B?TFdJaXFZSzQ2TkpUaXNlNGlxQnhpWnFJUEEvU3BCeHlpZURCaVdSbUk2aGdI?=
 =?utf-8?B?TDJaSnVmNm9FRUxRblYwdjlKNGU2L2lDd2pvUnhWN3lCdVlXR1lvQndjcTQz?=
 =?utf-8?B?RFgrTGhNTENNZmZWaUF1RjNtblRncmJuL2dWWUdtU2p3aVZrRDhTSnlMTjM2?=
 =?utf-8?B?UUN3TUlDNEp4cFdBVkVOUU91aDJycEFoVUhLVytLcG1pTzJHZnBMWlNxWC9Y?=
 =?utf-8?B?ZEY5ZGlEbHNuUmlFMkcwU1lYZ3FTRUFjb2hVbTZKcDFLcW83SnRGSHpabkVL?=
 =?utf-8?B?eXVGeWxOL2M1dzlHNDFwbng5L0hBTGorcE92cDZiK2hldkR4NzdOMzBCa1NW?=
 =?utf-8?B?dE5PbGJ3RjE3RVIzSWt6NThoWFlsNFEwc0xLU1U3L1NVT1JDMHI4QmZwbGhr?=
 =?utf-8?B?RVdVcjIxdzlDT01UdkpETjJGY1h6STBJbHhIQ3dRck5DM0VMUWlGb0RPTFdh?=
 =?utf-8?B?SzI4dUtpc25sMGgxT0RHUDRGd3NJZG9MMG9GQUtxUXRDMU11QVdTYkl4MERa?=
 =?utf-8?B?QXhBRzdtd1dnc0ZLeGFLMmVQaE85K0dURmJNUVBPeHBpZ0hDQis5emRJZVBF?=
 =?utf-8?B?SXhxN0R6MlRZcjJpNGVzNUtVSkZJQ1kzck9TOXpYaFBPS01jZGV4anhsV0hJ?=
 =?utf-8?B?NmJXSTJ3Mm95UmtlbWNxckFHOFNBMTZpRU9KNmZwMHpLS05nUmFiMUxpT1ZY?=
 =?utf-8?B?NmR0Z3B4T2hXSGtCRGd0UndFclcwdFB3dCtrdG5zeW5OUjNJcXVKN3JrZVVP?=
 =?utf-8?B?ZjAwS0hxdTFTbXRCMFI5R2ZQYmNrdU56T2dVVlowdE9FSGNWYmZudjRiVXVY?=
 =?utf-8?B?eENVd0xVRGF2ODM4RnRxRW9pODBQTjJiTWJDMzNBdnJlc3VNcnkzMzVXQjFL?=
 =?utf-8?B?S2c4ZjIyQmVjS3hjL2x1Y3J4SHYweGNaSERYejFXQUpUREdEQUFQNkV6bjNm?=
 =?utf-8?B?aGJMTmJqMUZCemFCREtBWG5XUDZqT0hLaXphdTBraUtBYmtZamErNVBoenBN?=
 =?utf-8?B?L1pOdzl0MHVzOVVQc0ZXNDJ4RVNTZTJwYjd2Z3VrTnMxVGM3d2RpT2hzR2RT?=
 =?utf-8?B?NEhGVXlFZnlkdlRNRm9HYVVEbjYydEVFcFNJRmR3bm41WmkvQVUxbUVSRjdW?=
 =?utf-8?B?d3BQais0VEpxaFR2RnljRDlrQ0pNUEVyUWd3N1VJYmQ1VUo5cEpITC90dG1S?=
 =?utf-8?B?RVQyMW13WGs0TnRMb3JrY3RGdHFCdUJFSUh6c3Rsc0oyRGtOK0FWaWFndW5k?=
 =?utf-8?B?djRFRE8wN21SdTBRZ0pvTzkvSW9TRzJuUTJlNlM1UWVVektKbURXVUJQaHVv?=
 =?utf-8?B?eDBkKzY1K3lRVVlFdUdsSDQ4L3lybFJpRTk2aG8rVGs1L0sydlhMV3ZlZk9x?=
 =?utf-8?B?bG1icFBZUXczSkdZcDVJSWRyRUNHZ3JQUUxKTkFpN3h0QjcrL1MrcXl2eVZ2?=
 =?utf-8?B?R1Z0OEtFeGY5eldCZFkrYTdFRWVLSHpFaC9aUXBlckRZb0ZINGZyVnVJWmZO?=
 =?utf-8?B?SnMvWm1oYkR1a1p1dmV5TVhHbFpFV2VoWUVvMlA0MURwZkh0enY3SFRKS2hV?=
 =?utf-8?B?NG1aYVJ3dE1ybEtYbHJSS0tFQzAzYlp5alA3WFlGeERRMnJPMjR4bU9DVWFU?=
 =?utf-8?B?cG1SL0R0SjlNaXcyeGZDWGdteGtVV2tIQjN2OTZ0UFhUZDVLV2w1RkJHeUxa?=
 =?utf-8?B?NmlCSTNLUVM4OVJBRlhUcmRYbkhPWDVKekhBT1ppSTRVNHJKSVNxMHBGRHFl?=
 =?utf-8?B?eGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f1de976-3f6c-4f03-53d7-08db989f6fe8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4972.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 06:11:14.9126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Irzs4zxlGrjIcHBo71XsfN2ztFDvBQG7VGQvpuTrh+If1rOZJOAjYn6mWcpS34GwL1xpGNackgubg4Z7qU9mcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6957
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/7/2023 9:16 AM, Chao Gao wrote:
>>>> +	if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
>>>> +		incpt = !guest_can_use(vcpu, X86_FEATURE_IBT);
>>> can you use guest_can_use() or guest_cpuid_has() consistently?
>> Hmm, the inspiration actually came from Sean:
>> Re: [RFC PATCH v2 3/6] KVM: x86: SVM: Pass through shadow stack MSRs - Sean Christopherson (kernel.org) <https://lore.kernel.org/all/ZMk14YiPw9l7ZTXP@google.com/>
>> it would make the code more reasonable on non-CET platforms.
> then, can you switch to use guest_cpuid_has() for IBT here as you do a few
> lines above for the SHSTK? that's why I said "consistently".
Oh, I should use guest_cpuid_has() instead of guest_can_use() here, thanks!

