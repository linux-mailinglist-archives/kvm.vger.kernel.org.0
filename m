Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2523B59002E
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 17:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbiHKPjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 11:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiHKPil (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 11:38:41 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC809A963;
        Thu, 11 Aug 2022 08:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660232054; x=1691768054;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xZdsS+/QDIewwMbHc1pcUJmTJQdF1pLw/TmobooeOJw=;
  b=bp0vqfGGEpzQhcoirITh383KnSWFr6O68w5srBUTQscNqFf2olaqNA3Q
   lB8rkDOQb9REIvCFEg2aMBG6C8jixF5q02sgyCEw7J4tVUNjoS4NhGlmf
   zdcvHMx9mAGKqs8ecGt1CuZuFEGeZ/eEzKolirYBejon25z5Vd+Y1iO5O
   kiL2IduMdiuwzkSh1HKLRHuZWr3dfbRD1f3r//dik2Tea/RACN3vSezuH
   hLCfFdxSO5O7PEsWQFPxYxRAz5GYk1QJ/Yr4HZyqu2Ar6OEAwAmq2olHf
   jexjbhoBRYNIYB7aOwuWDbB7+1mLjnyzGpheLPx31oGng4TQD//BqMXBv
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="355384055"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="355384055"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 08:34:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="605586707"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 11 Aug 2022 08:34:13 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 08:34:13 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 08:34:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 11 Aug 2022 08:34:12 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 11 Aug 2022 08:34:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9L922FvjsDsfyNNhMpWbepkhJoE7p04uByY4NjUcAArldlSZ1OIXH9y1XQcVAviafWcqJiMv1fg7GkezC20I59DUtQyhfXwKwZ7ye4w6ZHzdYkpVGJfHDmTN4Ca6i366tCFGvdKv/WnxgXKmTTF2dnDEDKPfYetqQZl9rCwMEf0m6Lu5C6OWQgKk1TjsLv7r8nCJ0OXmx5YFomVQGiP1x8fK3Xp2ImolqMXQw3Xnrkkc2syV0XoKoHbGRU0DrvkmREJL+3xcQEdgo0hSSFe8EqxPNnrDp4KFE4R/uijUh5QLpCvx8W3LmYf8jq7MORQwRwXzZA9WxVM5DiHEpGZWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rW2CIgK5vpi9ZJLZYBFc7pbw/Ngn9480cRx/gg0kJA=;
 b=ikbci0DbuISNkYgJiVlq489nfMc9z+TKyK9+e/idw+gFOQ2VWlM7tZ+43TV5PMtZ6dqgpJAdPDzRkIg09DyYg74wN6UzVt5CPSim3U5dXGqz1H7sovhosbEb8imH0aFJCiJ+kCIxVqPkLUJUbxUiaNhBmTErFhTRYh7oOausQdaHbpy1SsvnUCZACEp8h4o02BVz0sGtsmA5cMV+rps42hcFw8dgo5GjKHmRc68KY3dLmdyCw2IShlZENOBYzCqeZvLUFWMDCWfIaFTqZFHF2GlklCsOJv78ZPO0A7S1+ugK+OsHWMVAzD1awdGuCEbecK0hAaOeuRyIumgWUrCI2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB5918.namprd11.prod.outlook.com (2603:10b6:a03:42c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 11 Aug
 2022 15:34:10 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ddb:2488:14dd:3751]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ddb:2488:14dd:3751%8]) with mapi id 15.20.5525.011; Thu, 11 Aug 2022
 15:34:10 +0000
Message-ID: <2e191acd-0b71-784a-2c14-6e78351788cc@intel.com>
Date:   Thu, 11 Aug 2022 23:33:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 03/13] KVM: x86: emulator: introduce
 emulator_recalc_and_set_mode
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
 <20220803155011.43721-4-mlevitsk@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20220803155011.43721-4-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:196::17) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85dfdac4-ea9e-42d3-ae59-08da7baeef9b
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5918:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VnbC24xXNh2A4SpDeR1/KgVBqn1VM6TDT4qm0J4IrsOXeKtx+yG+awY1iI+ovkGjNQp6Hbmrd8rVaQqBiEKcGE743G7UnIJmLTxqTpQbGPYO3Mb9CPaHAMdOcdGynZrK0d4p1OhjyPLok6cuOjDsTlZj1E0G5gXe7jUs7UHZ+i2BJVtVNxnXQZr88sl6e6bklmgfoWpn4Qx8mk/8ink/jecHbD9xIt5zCgKY+lnxrPVPtOm2wd1AuuypGb9lRs+/jUIeHnTx+dOKu5Xv+lCM/AdzjThnzJpM3Dj3dQjDSoSDiyRir4Wu3yQWCy1pfGGWkVJ+Fid169r9KBpG4YqHuwrO+nM8OuhR3shH6OW4nAfc1B4i7FgNPi416t5q5Qdo9sKF19wxfTJX+kdHdLktYe8MgkhRLIdmqXgg8Ntk6Hq3k8CGGZIDFV2DU1gHn9lhHq6/Me0uoqmPmPGTlYxhH1wOqJrS/vmVWwYJShsWt7vEBULTY2i5EXwEOlWbA5rNB+oU3gJmA+dQQVQ5EEdqZwVAsqUIAX/jrj+dJC/CcHY1rHTmjH491y8JNswJIv0MsVBUb05/ZA+/IysDOGZ58qdkTovboDA6oXjyO8VvS17SFbMq+kKYXnBEDZlkGbRBwHmzdwBCD/9/Az/0v7BFelwcszY7EizJdWutfE0DyHpGfMfZC9vkAKd9Zn1/v6k3vUaVxhQMeFXYcCRfGYjhF9T07oz27mbqRmdqBWY6XCmOllponwPOhitx1Xv0mIf3pEb79tPHkatb3R4zjaBAQ0hGjQBlfV7UftyuMYfqs+QM2ycSVlfx2WAkBgz9KCP8FkNwTE32TZWV22KQEy7xcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(396003)(39860400002)(376002)(38100700002)(31696002)(316002)(86362001)(66476007)(4326008)(82960400001)(8676002)(66946007)(66556008)(5660300002)(7416002)(8936002)(4744005)(6486002)(478600001)(53546011)(6506007)(26005)(6512007)(2616005)(41300700001)(6666004)(186003)(110136005)(54906003)(31686004)(36756003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHJRUnJmanAwcEkrTDVnT1Y3aG5jeHBwd2V1c3plcmRwM3dXdHIwc1p1cTF6?=
 =?utf-8?B?eDdlQnhUOXQ5VTJLOGtXeUFmQmEyQ2dKSkNKSlEwK2NHZXRDbUI5dGpsWGRs?=
 =?utf-8?B?WkgvaG5KUm9NM25TYVlTNDhlNVloRisyQ0xjYWl6ZDRhUjlCOVg5dFVSSHcx?=
 =?utf-8?B?dlk5WXpjUFA1d2wwN3llZ3hGMzRWdEI4SUM1SzF5MTdPQ3VZaFozZG1OUGRE?=
 =?utf-8?B?OVRMYlM1YlFUeVdwMFJBMG9zWHJZZVZML1I5Z3dpU1BRWVo2aU5mMFRyb3Bm?=
 =?utf-8?B?QThoRVFCajZkcENoaE8ydDJzU1FoWE9ZSTNjdGlKL2VrUXd1UWZBYzdqL0ph?=
 =?utf-8?B?Qm53cmsrZDJMSkF5cXFQOHJPMkQ0UFlGeHVNVFVWUno5cENJSU8vM1Y1TUcr?=
 =?utf-8?B?SUNma01uL1VBbWdtQUlkTGN4MjZvN08yNHhuSE5RVm5VQUNLWWVZTlpnNXhC?=
 =?utf-8?B?cWxERU1GR3AzRS8xQllPL3NPZldTelBQUmRqVU90cXg3QlN3YnJzdHUzWFRH?=
 =?utf-8?B?S05mY3MxWGswUFVhbmxmY1hIT0xDR0t5WnZlRnJ4bGd6dGdUMDBVenpqczdw?=
 =?utf-8?B?dkFialJlQzhkWWYxRlZCckgyVHNXekJ1NGI3TzBqQVBuTE9LQUpEaDUwNEZv?=
 =?utf-8?B?WnRUemlKbFA1cU4xaWYvSHlDQVVoSFdNa25oZGp6S1VTMGVUN0pGaUZRWEpq?=
 =?utf-8?B?REw1WCt2aWR3SldqK3lyVGtNQVN4ZTZ4VkdXbE8vY1UzalNvRVJvUXl4djRM?=
 =?utf-8?B?K09KN01VTm1vV094RjBNNEZzQnZidHVheVRtSFkrbGVRR2Z4V2tXTyswM0RQ?=
 =?utf-8?B?NG1Ud05nU2RaU055R3N6aFBHb2gvcTRQamxTR1d0SDhvcDVsUVNaNlJzQmVz?=
 =?utf-8?B?OEEzYjFkVHJlK1dOVDZwaHZnOWQyVFNSSi9Ka1pJdCtNSGR4RlN0MVZaek1M?=
 =?utf-8?B?MVgzVmlYSVUyQlVRRktuSUpWT29VK3NwcnhLakZkZkQ5OUNkOEMrbmRzU1Vh?=
 =?utf-8?B?cElZd1k0a1ZWZEhxYlcvYm9TMGllMmYyWDlZZWFoMjVKcG8zdDAzYlNDRkFy?=
 =?utf-8?B?U3ljVlcwTWVlUUU3SXNmM2JWcDJVQ3UrOTZ5UkovK25BR0w1Q1RSbkR4d2l5?=
 =?utf-8?B?YVlYU296RUVTRFhra2E3NmhjcCtuUE1lN2VsWXN2SlZmVGw2cDdQUnpyRmJX?=
 =?utf-8?B?SlhGNm11dDFhV1BTMlF2VERyLzBpL0dVTFVUOGd3Ulkzb0U5TFR0b2VOaWJB?=
 =?utf-8?B?eXVycTJBTlFBaHdHenNlUVZjenNXdWhUbVBCSWNIN0FCc0pJbTRMaXYrQlZ0?=
 =?utf-8?B?VjVTTTE5c2gwWGR6bEVkRVl1WVhnMklMRFBxVmd4UWZjQi9DWlNCTEpWb0pC?=
 =?utf-8?B?YmMyS1NSajIwK0Erd25RV0F6UENuUGpDSGt1azdlbFozWU96MStCYjQyaXFs?=
 =?utf-8?B?SFJ5OFdVUXdMUitHdEdGZDhEOVZWd2tieFhLc1lrc1RRR3Bnak1lUmt4Y3Bq?=
 =?utf-8?B?a3cvRTg5dmxJYXVqaWpBOXJxTEdhSUJlRG9oSjZmS2dVVWgycURJT29NU09q?=
 =?utf-8?B?NytJUmdEclMzUi9aVk1aMHNFMU9QNEJtSTJRd2tldmRnamZuaE1yaGFDRHh5?=
 =?utf-8?B?UThzbnlMTmsybC82eGNVdFNWNVgwWG1oTHE3QU90VkMwZXJycnJHK25xak4y?=
 =?utf-8?B?UVdQVHZXYzBwNEwzNUpQT1lDWDFoY2ljNG9Vd0N6ZDA2U3pFT1ZoS0RnM3JQ?=
 =?utf-8?B?M2RMMEhUQnRrUUNqZ0J1M21NVWU2NHB2eE8zckFxRU41Q2dOUXhmckF2Wk1a?=
 =?utf-8?B?WDVzdVpOWUZVanRoZG5NbzNRZHZTeWI1alpWSHEzVFpqbTlWVUJLcVZSNHBu?=
 =?utf-8?B?MDNGK0VtSVhjTHJvdWFTL1dXcE5JU2VVSjlHTWxYTHExM3Rmc0tmMW5hbDUr?=
 =?utf-8?B?dy94cTczN0hqYlBLQVdWTzFZWUNhdW5PUHFXYlk4SmIzdFNWcHNHdWt0VFNi?=
 =?utf-8?B?TGdqQWI0SDk1WWNUa29ZT0w1a2Y1dGwrU1lZZWdSQUhtWjkrc1BLOHdOTFpH?=
 =?utf-8?B?Tkg0YWdwRDk4cGNTakJrMWkxSWpZcDhUdFNQbmVOaVN3c2JuRFBmUHhNcU50?=
 =?utf-8?B?aXZsV09FdSttUkhwRVlKcm9vaWk5OWxOVGMwQzA1b3FSYkdaMkZSTC9FS1V1?=
 =?utf-8?B?b1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 85dfdac4-ea9e-42d3-ae59-08da7baeef9b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 15:34:10.2860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TNydtMn2w+909kxD3/A1hNQdE96nyaqMd6vIdx0Sxm9rvqEqmQtnaNigQMDokzQY2U6Dkumeb26ypWx/5wAU9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5918
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/3/2022 11:50 PM, Maxim Levitsky wrote:
> [...]
> +static inline int emulator_recalc_and_set_mode(struct x86_emulate_ctxt *ctxt)
> +{
> +       u64 efer;
> +       struct desc_struct cs;
> +       u16 selector;
> +       u32 base3;
> +
> +       ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
> +
> +       if (!ctxt->ops->get_cr(ctxt, 0) & X86_CR0_PE) {
Shouldn't this be:  !(ctxt->ops->get_cr(ctxt, 0) & X86_CR0_PE) ?
> +               /* Real mode. cpu must not have long mode active */
> +               if (efer & EFER_LMA)
> +                       return X86EMUL_UNHANDLEABLE;
> +               ctxt->mode = X86EMUL_MODE_REAL;
> +               return X86EMUL_CONTINUE;
> +       }
> +
[...]
> --
> 2.26.3
>
