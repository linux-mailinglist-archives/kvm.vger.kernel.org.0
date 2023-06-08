Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6C3727701
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 08:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbjFHGC2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 02:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234378AbjFHGCY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 02:02:24 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55D7172E;
        Wed,  7 Jun 2023 23:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686204142; x=1717740142;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SdEcjMo03cQiIraeXXynqwVZZ6/RA7S/Ys8jJ7HRu5k=;
  b=UoX1o+0tYW4CCI7O+5m2dUbNCwBorbS2RCvS8BvvEjXGXcbnHkDvFFnK
   VYW6QDHSMbIx5diJOHW/kqf3eujWXJ1fK8fOGv3rmkrSZ2zOh2PUhI4qr
   i0futd0lBgYSIyZD05b5eTzQ/UXx8BXx4ZKDQ5vEeLmWjIQ4k6Hx6pfOr
   4ZD+Xqf/uKjS8gB260ax18naR6gjcfN17vzbFKUbYXyX7VzHUDF1NVZ55
   3nwPzDeXzaUvnGIzBwo9DTm0ZfWoePOso4Cwug2qs4o3yBQOf94G+SVsv
   VuXTDd4DBjxxxbq0d+wnxDq8SiNmwZp6+8MA2TE3AXFiRtjIz4NhjRfUQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="357223770"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="357223770"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 23:02:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="884058896"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="884058896"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 07 Jun 2023 23:02:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 23:02:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 23:02:01 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 23:02:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHTumTDJsLCljdhiI72op9m3LLDWgfbzIP9WoR9WAB5dR2n+0y9A8RVbK0e+rhzqn9Q59/LR1+/d/37OElJQB++6b+G713AMf2X+rNYhnDlDEOlavEMPZOOzmzIeiSEDutFKL2zb6e7jrHZd5UsPMU46kj7jgxp8XH0o7c3DJOwkU6vCPPcM1USBfd3Do+hKJEkn8+GREfuYxq8a7uhcfibXhcaL8lfcLFdViVvoMca8G5AC8eThdz8ttRft2+yaINjImXfgiM67iSyPkG13TrC0+KxXqHeO944sb3XX4MkGUxAqECfcJT6L7Q1h7NsM/rEhnDaflnFcxQ25lqdAXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j7W2nOmIB1ysBgsr+hJ1vKjO/2lYSpXo3813is07mYU=;
 b=Sgig8BJnkfeZhXL63NhOyfUTBmF4qrJRLowbfOH9XSibdozPPSAIg0FNwZ+nQx3/XYAEbMsIBq+avypEE4ir6Rumb07M9M/Y3EygB0MWSX09O4krZEHCbkjezieIlv1jGHWEr5CN9UQOikLxZSG0WJIPjtERKReUILLS+wuwGnV8vJRNUAlRmAxaPpEu/RDxKj2bfjke9XT1ufsgmeQAXOtULrE2kklSFtwM+Wg1HHGjybsugTHuYWdVOQ3c3B4+JutjtCNyfjsm5Sv9FbD4F3Utwdjf8ljVoI4Gk2ywUyJfNJvie59A1pTPLgiUIFHqIm5fpYmvDaEEDuRsGdbCtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB6074.namprd11.prod.outlook.com (2603:10b6:208:3d6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Thu, 8 Jun
 2023 06:01:56 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%5]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 06:01:55 +0000
Message-ID: <21568052-eb0f-a8d6-5225-3b422e9470e9@intel.com>
Date:   Thu, 8 Jun 2023 14:01:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception
 classification
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-11-weijiang.yang@intel.com>
 <ZH73kDx6VCaBFiyh@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZH73kDx6VCaBFiyh@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::10) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB6074:EE_
X-MS-Office365-Filtering-Correlation-Id: 69dfb2a1-2b63-4017-52fc-08db67e5dcdb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n2txH4ZolrWwZMi8/jCFjz3b8LNKyavvV19lQmpGYVUh2XWf79tLl3zwtClszjcjs4YdPQBxqd06waafZllC9KkfSOiNBsvN23j4NfJUUZvTPGBQqhbShD2OpGd4maq893Dd7tYvpoEpufgnF1Y3pzVu0SgDG298m3FFo17xzI0s1OXpdINtjGlKWs17MjRsDbqyuORxlufTTUJPxqc5Z81pat+uP0DTXMuKsuHpmYuK6fimEYrYs5a37cNwv+PHvpvuF4us6N7GVV1hexWhN79XpkNtUekaAa4Q6nYnDb9WtpWAWiJMeatcLsMDbwZgMVOfrKJFPozcI4cK/Lpuzg4l46xTwP2CXpu3e1es0dDBu7GCnrT6y6+Q03ZqnXtoOznHuJOI3OLpO7SuOIO9Tok3sOlivhq3CwBcYX7sGG5e/BHGRh47YkBqL73v8NhclCn47oJSKsNsJXJe5yv+v58wlqvVCek47lWFtefXwqiO3JnE9bNEAKEYDdLHg64PZijHYbLlRt72MKJoEUPWlE8lxaixQbTojd5Je0/RO7miDfpCLg4H4Ge9+ALZgA/yjRSqx4iFMWoEY1yzB8P1AQ2SNCEIzUzxkXsh7IDwIwu5MTZ1BJCAyRKycgtgqzmx5F2+2E1VepNQuKX7uTl0Fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(366004)(376002)(39860400002)(451199021)(8936002)(6862004)(186003)(2906002)(83380400001)(37006003)(478600001)(4326008)(2616005)(6636002)(66476007)(6666004)(66946007)(66556008)(8676002)(5660300002)(53546011)(41300700001)(6506007)(6512007)(26005)(6486002)(31696002)(82960400001)(36756003)(86362001)(316002)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?elRUMW4xKythdThUVVFMTUlIdmJlbTNHcTUzY29rRmY5VHRpMEdJQmk3L1A1?=
 =?utf-8?B?Y2ZHcmVZY0hTdUZmNzJXcXBTdm4zOEsxandqUldCSFNlR2VyQVRnR2NYcE5V?=
 =?utf-8?B?aWxrS1IrQkxpVGYvekI5WFFaRVluTGt4a1dBMHFTZDBsR1VLRWZ0WGRPcHNZ?=
 =?utf-8?B?NlNwN0dhSXpMTnZGYWFaTDJoZWdnK0NRNEdmdWhOMDNXbkVER292a2I1VWJa?=
 =?utf-8?B?R250a1Zhc2VZbHB6eDB0c3oyanNUUzg1WFkxT3NBQ3lhdnl1R01VL2NLUDMz?=
 =?utf-8?B?OTRxV0ZaUXdLazh6cUR6Qy8vZ1BBRE5HY2k4NjRxZ09iLzFEdENNSXlRWVpt?=
 =?utf-8?B?MzlhMjJFYUdWV0UvNlRvZ3UvM0NBVE1lcytnblhSMzhRcStOc0JsQnptbkl5?=
 =?utf-8?B?Rzl6MzVld0JkeFlLWENFdHBpTUpHYUVNREJMSkk1R0xsb3lXUmZiekxoTzlp?=
 =?utf-8?B?TGJQL09tMWdLZnBBcnNqRkoxS2xYNWNNV3IzYnBsbnhkZ2U0UEVtdU1Bb1JL?=
 =?utf-8?B?Um92dDd0dmhBR2xpc1M4OEtYelhWb1JXZzcyMGhqcVQrb0Y1d2l2ZDdYbExl?=
 =?utf-8?B?WnIzK1crbjNBczVvYWRtamFzWkxoQkNJcUYraTVuYjlHTi9Wb0RWWVFtTEtT?=
 =?utf-8?B?VHErYk1KekxQZjB0TGFyK1FVZk0zazh0N3EwUmZVOWUyVWNRL2ovc1hheUZl?=
 =?utf-8?B?ZFk0dTlrOGRCWjlnNUozODlyUjA4ajFKbE5ueEhRd0YwT05kTWZGUXZNUEo0?=
 =?utf-8?B?ejBUcUlWMnFPVG1hVi8xY3o4TE1pTm4rbFdwUmtncDg0aktvby9sK0FvbEt6?=
 =?utf-8?B?eFh6RXFnSXd2WVlBUmY5b0w5S3hZSHJwME5sOGxrTHB6WlpjMnJ2cDZCbm9E?=
 =?utf-8?B?YmtDdUFYZ0dWZjl3L3d1aWRTK0tZMW5CRVZ1Nll5dHpOZnhUc2NLekFoc0NM?=
 =?utf-8?B?YVlHVyswVzJ4YmNHWkdUSSt6cHRsSmY2Z0M2NFFoVFZmNlViTkdrRHRnWWNK?=
 =?utf-8?B?UTJsV1RsM3BNNmhGR3pGd0NJekg0T01hNFhpVXVlZHFRT3pKaWNWakIxelpD?=
 =?utf-8?B?Uk14Zm1GVmd1UHQ1aGxHUC9uKzFCcDNDVThYUkZvUmVqUkpwbWNaSlVwcXBv?=
 =?utf-8?B?R25RelRmdFYvY2hTMDdDR1dRTGtid1lZb3BNRUsvVHVveDdrNnJVTlJNZk9s?=
 =?utf-8?B?UnVrS2hnTEZkWTJhcWZ0TkdBTWVzMkd0MjZwY3haQ0FFMk9VdExxTHNIdmdD?=
 =?utf-8?B?cnZ5c0ZKcHFTeUl1L0FzeTZ2U1NJWEo4WTJjYmNBUzZyMExHYmN6QzFQdzBT?=
 =?utf-8?B?R0VUZVUvZ1doTjlldWpTcVZRazVZQnBHdGtHOGtBTjN3T3cxTWZvNVkyNXVa?=
 =?utf-8?B?bGIrQjZ6S3BEYUp3eDJCYVZiNWxrNXBWUUVLS1g0TGdTV0h4MGVCRklOZHJS?=
 =?utf-8?B?Wkc5eCsyTGhBK1dDdVk3UXMzMCsvQmlFRGM5eXBlTGdRVUkrQUtsWHpWUGxD?=
 =?utf-8?B?R0JuTzFlSndDa3Bvc3pCODJVc0pPOVBtOHg1ZDlCSEZlK2I3V0xGWEZQZWYx?=
 =?utf-8?B?eHdVQjlaaGlKTUNjelpudmdaeHJ6RUNvU3dVcFY1QUxHTjFmUXY5T1NZSElK?=
 =?utf-8?B?RXdHV0NuVHBocnpseVdsR3BYS1ZuM29vSFBFNHdEREtzUVMyZGg2cUthZnJZ?=
 =?utf-8?B?dTBFWkhKcVlWMUNySm1oTnlmc2FKRzJ0N004L25mRzRqK2tFU1JBSXhvL29U?=
 =?utf-8?B?NXdoVjY4Y0VNRmxLRzhwemMwUWpsNUVaZThRd1BWUnNsdE16WStWb25MTEhK?=
 =?utf-8?B?bFRpV3FVVmw5VCtFQ0NiRkk3MEFLVG1CYUJlRWhheHdldHhhTkZVQUZSY1hr?=
 =?utf-8?B?YlRtNjR5dm00MVRVYWlncjI3VFhyK2w4dTZ0enYzNzBPMi9vUUx2TFJ3Zy85?=
 =?utf-8?B?NEZudktKZXdtUlBpckVobFNpcVdleHV0V2pUSDlld3BMZStoaUtaUWNCa29q?=
 =?utf-8?B?bzFRaXAzWHhSSmxKT2dJRndiTEtIUHl6MWx6Vlh5UVF6aUJXaHRXU3o5Z2Uv?=
 =?utf-8?B?ZG1IcWdPYkJVT3k0R0QxZWVRdENtTkhlMWlPV1hIUE5jdG14Rnp3U0F0ZEFo?=
 =?utf-8?B?WnJ1SW5hU3F3aXZVWFBPV1dvRUt0S3NybmZBempwVlh2cGFXWlJJZmRGL2xG?=
 =?utf-8?B?UEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 69dfb2a1-2b63-4017-52fc-08db67e5dcdb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 06:01:55.6681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vg9Fz0BHSPmKPSPumQGPXlpGltzHwE8EhQQTm8DCk3fKe8PDiQvQo26PRHotWmt3biV10m8a5q6LvqLVnp+pOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6074
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


On 6/6/2023 5:08 PM, Chao Gao wrote:
> On Thu, May 11, 2023 at 12:08:46AM -0400, Yang Weijiang wrote:
>> Add handling for Control Protection (#CP) exceptions(vector 21).
>> The new vector is introduced for Intel's Control-Flow Enforcement
>> Technology (CET) relevant violation cases.
>>
>> Although #CP belongs contributory exception class, but the actual
>> effect is conditional on CET being exposed to guest. If CET is not
>> available to guest, #CP falls back to non-contributory and doesn't
>> have an error code.
> This sounds weird. is this the hardware behavior? If yes, could you
> point us to where this behavior is documented?

It's not SDM documented behavior.

The original description is provided by Sean here:

Re: [PATCH v15 04/14] KVM: x86: Add #CP support in guest exception 
dispatch - Sean Christopherson (kernel.org) 
<https://lore.kernel.org/all/YBsZwvwhshw+s7yQ@google.com/>

I also verified the issue on my side.  If the KVM CET patches are there 
in L1 but CET is not enabled, and running some unit test can

trigger unit test failure although the #CP induced one has been fixed in 
KVM unit tests.

