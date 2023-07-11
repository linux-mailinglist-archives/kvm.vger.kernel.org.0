Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBA874E36D
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 03:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbjGKBZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 21:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjGKBZW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 21:25:22 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F57E49;
        Mon, 10 Jul 2023 18:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689038700; x=1720574700;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fBOGNPEtiOBr68fPLTdlldaF2kKm1sGP+rYVw504gDY=;
  b=dUbsX3I+1PVbQAej5+mi7MjuA0m+4OPl8c9fobynEDflnhVOPKdU9Afg
   9pGvFOyjRIDNoxsGicEUrmSfflW2B27Gh0GXFW1P01gcz5+/77XSo3YwK
   2lPK1w/Gu0CKKR+F2SJCmZsSpcp7CjQykk6APmc91HIXVepU5juGCSPv5
   D+oCkHMq6+j8LWX9IKQPlV/09BiZCv9ma7v6bs5fp+P0zaidg7T4djhl9
   /A0u3Xp8UZGmXAZvNFFIQxje7u402ns1HJlJ+HDI+tsJRBrstiAQsAj80
   VubAIDy9Y4k7qnZ2Tc+LIhMeiIEdlmCsQvtmy7/U81YZP0pTVy3ENIEQE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="364536906"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="364536906"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 18:24:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="756173685"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="756173685"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 10 Jul 2023 18:24:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 10 Jul 2023 18:24:26 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 10 Jul 2023 18:24:26 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 10 Jul 2023 18:24:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NW+RFIIpZ8Ph7hj+9cwLIF9WBcwt6hdocQ8zsNT5Fim6uSDfwRlg1XvrvlDeyKqamGH9pyEs2cz3vMPjNF/j0eC8G9VRTIOy/+be0frdIrTmEK2pJ5TQwUhUWHsAtKWoLr7rUWI9wvEjVnsuNVCteEeXVLCkTnhBHsj8nJqI/sukWN8xqjKcSDeYqHW9CXgqdO2vle3mgr7GqLJfPxE9/56CojO0Ju2WwOc2HHlY2u9cYPS3jrQZNCPiCqM0eh7SdV6GRyQ4Gj2zLElaZoOUx5PdWDHxdpHWBSB+GURxiFtn5ulOT1j0/8/5iDSgfigqlOnCkixKJ9GSnhIgigA2jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBOGNPEtiOBr68fPLTdlldaF2kKm1sGP+rYVw504gDY=;
 b=hkhrteKSqjUB8Q4JdeLY62Zcw9zrTmoMBMcXYU8gApOhFWR3f5iJboXGACHv1o6miwafL4cijl6jZmf83dT7fuxu+zAIOeVuGacFeIMKdk2Y/NbHMYchGVCNEegX25thIeUHGIoZJKwSw3izhwODdSRP+w5jLf30dKI5BVJhbqvQnKBjGgAgzkhd+62Us+QWsWuQteKNUb4rRELNIqBHiArvaHCE6APuNB36Mocf0kvNowZGBoWknTCgUUpjxvzcniZy48+sXFw9stEb2TCf3anTrXxnZL3CHnnEa8f64wrAs4v+5B7TISIueOXbplN9URjmEaokYfGi19RMaj3L3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY8PR11MB7339.namprd11.prod.outlook.com (2603:10b6:930:9f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Tue, 11 Jul
 2023 01:24:23 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 01:24:23 +0000
Message-ID: <a7b34b4b-3ce8-7dd7-969e-164abbd7e995@intel.com>
Date:   Tue, 11 Jul 2023 09:24:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Gil Neiger <gil.neiger@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <ZIufL7p/ZvxjXwK5@google.com>
 <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
 <ZIyiWr4sR+MqwmAo@google.com>
 <ffd84a94-abea-a813-a6da-59d45a5ac468@intel.com>
 <ZKyDy3IiB/6VHt02@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZKyDy3IiB/6VHt02@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:4:54::21) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY8PR11MB7339:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ae202f0-cd1d-4169-fb4d-08db81ad8e99
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P2teEDEF6GNy/8k35/MTj6OnhU41Q/cih+mL+HlV3A93pF22ORNi3xBaNjPqtxE4AUG0NLcXGab8diVxY2EsIQgBEZYju40uVYFipAEtYBbyn3S53NiW41q6/d/fMuX0lMSff+/LwK2lCbAZiUDW8XVAtWScPpGVvsVjPPy+st+FvZ7mKzuNthAY5VypkSN7cOBnT3bu29LTrwcG+BqklRmr6jKodUAeR+PjkGwnORHK4l3qeeTlruhQ866PzWe7iouF1ktknkx93qbEFvCN7GXIoHW/S9jjOJMejPycjcrcUzUXAmTlBVw8yZ+wRvGV//ZxdffEM+btu2Trc+fvth4bpt516UKHPqHRRWHBqMXNFB45aBPBSPaQLE/wD6AX3AAV3b8CcRA9sUbEl8/sJKWU3uxYD4I+Ktg3CWaLUVLs3qgK8qsAm0bE7l6agNVxlj3IHXtqQp8uYWFfkcJqnFw7I9KL4jH1mN7gRh3lHIR7HWOoMOaRWkzgcKEvyvGOMpI2bbGbcmrIYWQramCASIaszBK32kJdwrIRrA4EM2PxIvI7nDNGtfIYZbkSMb1m1oZvNtCSbsgpYH+3fS7Bhi6SbvrXY2gEBeCR90n5+vPMXiXKj5I6lGuD81GiBlZZOuTbXDLbouylLnkrJ6Qn9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(39860400002)(366004)(136003)(451199021)(86362001)(31696002)(38100700002)(82960400001)(31686004)(36756003)(6666004)(6486002)(66946007)(2616005)(26005)(6506007)(53546011)(186003)(6512007)(2906002)(66476007)(66556008)(478600001)(8676002)(8936002)(5660300002)(83380400001)(4744005)(316002)(6916009)(4326008)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXlqK3NIc1o0cExaTUNmVWNYVTZSOUQ4SlFySmVFbkR4VVNIZks2czI1U3U2?=
 =?utf-8?B?eDkvZkQyOFlXZmhnWnRqVHB1K1dFVWExNGg2aGo1b29FMnJ4dDlwb001bW1x?=
 =?utf-8?B?TUNob0JaS0lMbXBwNmFuNGduakd0dUNKNWNCbXdTL0I0eTM5V1k5dHRoWUE0?=
 =?utf-8?B?MDdxc1laWWRLZnBYN3g0Z3M1R2wyM3ZmTXZTOUhrVHZQN1p3aUlWNUhaVWZo?=
 =?utf-8?B?UGpiQmxDYU5WNC9zdktMRkR3L3lka2t3SklyN0pSQ2FVVlZBTFBwZHkySm1t?=
 =?utf-8?B?U0hxVWh1Z2dmZ3o2QlNTRS8wMUJKbyt6WG5veW41RHp4ZjJHZVRPTmFDSVBS?=
 =?utf-8?B?K05lNzgrbEZITGNXWGZBb3NHeWxjaXNwVzlyT2wwbTVjY09UMDFZdnFNcTNL?=
 =?utf-8?B?RFdkYk5GZmt3cVZKdzVqV0QyVXMzL2NRTnFTQlZRSGkxdGJ5dW1ZNzR5WlpD?=
 =?utf-8?B?SHlXb0paWVhPeXE2ZkZWZmlmait1Tk9PR1l0Qk43N2JuYm9uMUFLaVg2V0Fq?=
 =?utf-8?B?TmM5YVJNMnp6U2FXTmlOb24zdVFzZ1JDalpIN2VLaDJYdDVFS0lGVWh5bnJx?=
 =?utf-8?B?dmVlWEVySElGYTNkTFl2Z1ZXVW1KWVZ5enRTNFAvdTFWZFBReXhxSkdMY3g0?=
 =?utf-8?B?dW4xZm5GSDd1bXJZeTBlUytKSHZ6bURPbjQ2bTdWek1NMlNjYnVNazY0Um5r?=
 =?utf-8?B?ajJacW5haVlQK2E5aVVEZ1RxK2JmSWhRMTMxVVdxMFQ2aDJpUlJXMFFhOVZm?=
 =?utf-8?B?SUZSbGRiVUZ2R3dyVVFnVHhnTFFaMlBWUkQ0U01QOXhXd1N2RUpUMDh2c1Bj?=
 =?utf-8?B?R0tETkloLzIrR0pldzJmMXlXdXliWmdpSCtGWHUxV1VyLzBxZ21XUy9nQU80?=
 =?utf-8?B?TzBNTytJeTZaR2pteTFMUWNXN2RkS3RIMnNZV01BdVhrV1dCeS9FSHJWa2Ns?=
 =?utf-8?B?UWlLcnJTSDVIcVE3eDlZNDVCRXlSSVdrMEFYSExvV3Y4S0NXVXFnQXhCOGpQ?=
 =?utf-8?B?Q1ZxME0yK09ua0E4VFFrdmZhY29ZVEorZzZwcENheXpGUWVyaWVUWC92YVdn?=
 =?utf-8?B?WnJWTWszdHBEbE1sbDlXcFdUZVY2WTBrWVlzWVRwNy9COFZ5K0VaaEZMNlp1?=
 =?utf-8?B?aHVtSXZHazV4aFNyeFVqUzRIQW8yVXFESTFjTjJMSDFKaEVxQW9pWk0zZ0R5?=
 =?utf-8?B?MHpvNTQ2aytHRFBFOGVSWTZSWmNTb0VWTGlMWFptaG4yTitVZTE1YVVnY21J?=
 =?utf-8?B?REN4cW5QUVhodXM4VnlEcnlYNHF0L3hBZmptY0s2cWpKNXdhRDYxQ1JRNWxq?=
 =?utf-8?B?UW1MSDZwTExDT3h1WGU3bVZSek1MTk1QdlJYL2ZNVWM4MmxHYlR1b2NTQWUr?=
 =?utf-8?B?TDdxVi93ckdTNTF5K3NSYmxLNXJyL3IrMEpXd0NEWUtEaHBKV0FSN1FuZkJE?=
 =?utf-8?B?MS9oN3Q0MkJsY1NZd3dLci9MVklOQlJmcUZjQzlCeDdFLytOZmYwVXhXVkRY?=
 =?utf-8?B?Nno2amorU2tmeWJHaFZ5VVptaElyb1dVMUE3dlpSY2NMYzBSYlp3K0RsNXJZ?=
 =?utf-8?B?bmM3aVM0eFp0WmdKb2JlOUtRRjV4VUo2ZVRVS2lkdk1TYUJoQ2dvUHpsQkhO?=
 =?utf-8?B?M2dhUmdQZGVsWnRaVmhxQ2ZBUlF2YmtoWjFOOVNROUMrSEQ3L2FXM3E5aVEv?=
 =?utf-8?B?Um8yL2JQaTVJcDlGQkNsY2E1WDRwRnF3Vm5OckZOV3psbDA5cG9zcEtPc0hB?=
 =?utf-8?B?VXVLTEtCSm9TN0ZuMDZKOUlBM0F6R0k1ZUVJQmFJSjU4TERiMXRZc2VGU0FH?=
 =?utf-8?B?UTliZjVRYWppK0NTcUFBRnpXYjAvUDNDTkRoeCs0alZMUFdnTmgweXZyeFly?=
 =?utf-8?B?UlBJcWxlTWtReGlWeEg3aW1XVnplNHRnd1JkdzJOUG1mbHgwbVR4U0ladTFk?=
 =?utf-8?B?bHpxb1N0RGxLRVk4Y29NNVhCVkVuOHY1Q1hHVDZyUFlBK1VrUVRuaWY4d0lv?=
 =?utf-8?B?cVpEREg2eU9VYlBEQXI5c2R3TjFtU3VNbnh1OEtmOWZQbHpSaTJNaDVMd2VR?=
 =?utf-8?B?U1RXYUREbXRnblhNWHBwVHQyZm5MVXNFS09OMW8xVmg0c1JLeWkwaSt6cGdu?=
 =?utf-8?B?a0c2cmNZeXhNOHdLWlgvYzJxRXhKS0ZnVVIxVDRyMThJUU9xOURJZmJqRHBD?=
 =?utf-8?B?cWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae202f0-cd1d-4169-fb4d-08db81ad8e99
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 01:24:22.8075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BwI7BF4L7XdXyNJHAwCTrfSLFQ0tza/9Kq4ajbIkjl2tz08z9FH94cQp2sg+//I+iTR/JqbRAzJ3Dp38gyaBwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7339
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


On 7/11/2023 6:18 AM, Sean Christopherson wrote:
> On Mon, Jul 10, 2023, Weijiang Yang wrote:
>> Maybe you need modify above changelog a bit per the update.
> Ya, I'll make sure the changelog gets updated before CET support is merged, though
> feel free to post the next version without waiting for new changelog.

Sure, thanks!

>> Given the updated parts are technical forecast, I don't plan to implement it
>> in this series and still enumerate
>>
>> CET_SSS ==0 for guest. What's your thoughts?
> Yes, definitely punt shadow-stack fixup to future enabling work.
Got it.
