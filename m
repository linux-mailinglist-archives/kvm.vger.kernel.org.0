Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA5D647E29
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 07:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiLIG6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 01:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiLIG6G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 01:58:06 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9187B2EE3
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 22:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670568942; x=1702104942;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nVdIr+84cNwDDi70t3vMyR28LtGwmtyQW2kFKqr4etU=;
  b=bqUI4xPC20duPo2ySmGT6pSMJ6hH1aLBOQeWLA1TXYJzip9q0AIdVNdf
   z8y7FGCKgE4KZZIJz0x68s9tRKTDKmjQSYhJlOmElH/k3fso4MQpl8gPQ
   SDzIyKHdqlmWqvf2U12YplBBzU68JT3+dTFl1r+r2DaKz+iIvzCab84G5
   2ljmgV1MOyt2unVCE+fn+oklmQcwBHl25xQyaLtzeQrxqzlIcesP8xdzb
   3nICNgSCyuGBBNb3tj43w3gSfrDMyd44Ds5xyIhyflo+OSjkICFotuQnZ
   mzpry4meCaQoI/o7W1nhJn5LYjGnV/mzSBCD0STOp0bVQ5sMV29kp1h6D
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="315032485"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="315032485"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:55:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="892557013"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="892557013"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 08 Dec 2022 22:55:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 22:55:41 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 22:55:41 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 22:55:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KvWAjDFirv8XOGpedP11R6yCowfG1BqA8PTJS2YB5kmhm47hoLKD7pcWukBejuw5uPQK6S/L1Q4lm3PyXlnXnJXnP0qZzqL4r/ge0sdeh/X1qkZQePuaDL3rHNeiRXHgjTm/XyB8GmMkKNJIgM7X+QIT641LMolTR2HuWjKwgC8pqPC2pwv8IQj0/dvmNb3k3SGulzJcZRauKw+DheFKbiKWk8CKq1oFObOQ29RR0mxqYJFOo87W4syLjhSq74wAnq23NDtdAXhlz8QOyxpLSUTtpahfMmFg09F5QJv3AlF5G/AycOQ73zMC/IlR6EIPx8Q+bxmxf53P96nS+3WMyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1E4iTUStrDgjPVtgdzzVlbjgY0EwNPKwougFRMClgVA=;
 b=WwVniBvqsK2sInamiIGqtuJPrt3Q90BL4veGYcykxL+Vaqx9l4A/45HIZWD4apGb5/8ciFzXS6rNAl7u18FJ5wJ1RIxVIAXw+8xGAD8EisuqAMRN7Apm+SWh8ZvJFoRq1ObccIt8kbHKqJFRLxZErOPvJutFqwfXzH7udBB2T/oNm94m7lT02ZesiK4b/xfCZ+KIbq9tPbTZjDRBuDrhwkQWdPsisfRarl9Zksqh5xXfnl0+3RnzQhlzTwRyzHR7yCIt8mMVuDca4s2cpDtZiA6q+yuPf8Rz4OwiUtC4huIiv8+FkxJSDDGl5S9/i8n3ccQ7Pcz6aiXJEI/jbajLyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15)
 by CY8PR11MB7393.namprd11.prod.outlook.com (2603:10b6:930:84::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 06:55:34 +0000
Received: from SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::d95b:a6f1:ed4d:5327]) by SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::d95b:a6f1:ed4d:5327%9]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:55:34 +0000
Message-ID: <79e68a2b-ba65-98bb-a175-68605303d2e5@intel.com>
Date:   Fri, 9 Dec 2022 14:55:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH v3 6/8] target/i386/intel-pt: Enable host pass through of
 Intel PT
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <20221208062513.2589476-1-xiaoyao.li@intel.com>
 <20221208062513.2589476-7-xiaoyao.li@intel.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <20221208062513.2589476-7-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0236.apcprd06.prod.outlook.com
 (2603:1096:4:ac::20) To SA2PR11MB5052.namprd11.prod.outlook.com
 (2603:10b6:806:fa::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB5052:EE_|CY8PR11MB7393:EE_
X-MS-Office365-Filtering-Correlation-Id: 595fd350-7469-43cb-19fd-08dad9b25ea8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: krlc1caeP9xmoHxE+gVdi3mM67D8HxeOZEJ1FkR6Qia7Twra4LrYnP09NJJ2OXH8mCzX1Z4EREORRoydyXGMPomJYjBAvHiH38aftpeytbBR2vZDd6/sxVei9IQQKM8gnfU5x2FnR69thzpfinZbq/QEIOYBWnjKpSY31JNkrIv/YHFFa1Gcaqhdmvze6h1EfcwCgthRvyrbig1bM8h6SFo2bbZaJaUkp8f62hwO7Oztqq9WyMD8u9mAi+//PisusdI4nH//d5Yot6MOln7PG4z6q51juORmOThzjO3lGrI8Nc6hmPkFX8cKOTiDEQ7pKThtDHcEvqZI8BcD/W2J9NbfStkCBo59RQKaI6c7v/iirEyvo24/qB08mA3+NDho+Oilk1KtWKU7JCCDmjBhxvGP/YJqIKhARuYk+HsPp5FesNnJV5PseLqB17Jt7Bf8T3RnrpzSbS0LoXTc0KV6xybi/6P18bbTuxQxXUzXREG1tJtaH7RCF25gssiEp99gHpo/C7wq5TD1k+oWXRlI9XiEDAYOJCN4Ats76UNgY1EDzZdmqtzzf85B1JinJlpQ/F0YGxuztNgiYb8dzM1ftDR88PQOQEsca09yNNcD7tg+TZceRQjhwC8yauaY+D6bXp8uWAeAYhKWxL8nZOWNnBXJBdPjdxQPvGgbcwzffLSpruViO+qtMVfpkmH7xwOf++FytLao1+2iI/cetZ8C6CBt3f12K7FmptKThl6OhZI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(366004)(346002)(376002)(451199015)(53546011)(2906002)(478600001)(6486002)(6506007)(36756003)(44832011)(6666004)(26005)(82960400001)(38100700002)(186003)(2616005)(83380400001)(8936002)(66476007)(86362001)(66946007)(8676002)(316002)(110136005)(66556008)(4326008)(6512007)(31686004)(31696002)(41300700001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkFUeUJyWEZYNWcxQWQ3aFdLU1UrK0hIMGlKRWZuNmpYZnZROFJEMXVCamdo?=
 =?utf-8?B?THRZcWI4L2ExK0tDRm9pL1hqdHNYaUlOdTFIUWpyMFVDcFQ5aFNTeDh4SHlp?=
 =?utf-8?B?Y0liOERTODJXRFJEeXljdmJTRlRFWHJuSk5lOUMrczBZRXdtdXRSTWpsSldo?=
 =?utf-8?B?ZWRlNDhiRjRMd3dKbFNFRnUrdFh2S0JwSWIwQ2c4cjUwenh1VFllUGw1NWxZ?=
 =?utf-8?B?ekxDR2duNUFqcmtIVEtURzJBRUN2bFdVa1ZSNDdJR2NhVmI5dWNpd1k2YmF4?=
 =?utf-8?B?Mmg5SjdvZWtnNlBFV3ZyRms5SnVzQzRWWjNuMnpMUmo2Y2xwK3pNOUJocHJX?=
 =?utf-8?B?ZUYrK2VQQjRjUVg4TTBlZEExdDhUU2RYVWhsd3pYVjd0bklTV3NJTXJKTEtx?=
 =?utf-8?B?WTk4VFpzWWx5MG5FZy9sR3RPdFhkYkM5UTBMK2JzMnFsK1FkQzZUeFRTZk1K?=
 =?utf-8?B?UXNEU0I2czVSdzVBdHVlcDdTN1gzT2t0UHBpeGhmTkQ2dmJoLzBPRldxTDBa?=
 =?utf-8?B?cXNsdWV0dGR6alpXR3ltRmlNOXo5YVA1TlkrcUsxa1NKR0c5ZW41Tm5VaWZo?=
 =?utf-8?B?Q0ozZHcxQTk5ckNVdG9KT2hiOWxtWkViSWJhV1ljNUtJWXFwT1BCdWgwYzVu?=
 =?utf-8?B?L2dVU3h3ZXQ3UWdJUXZpRWRGQ2JzQXU2WGNmd1lrdjJhTndETjZqcDRId3do?=
 =?utf-8?B?TEloS0ZrMXFxRm83Z0I2dTd1Z3hWQ0hxMi8rUWFzNXFuNTRzdHduSDVwbGgr?=
 =?utf-8?B?MW4vdDVEc3VxcHFGdHV2QU0rMGNDOE4vVU9ydytpdWxWN0VPUExRdVFldG5P?=
 =?utf-8?B?cFo5SEVYOHdNMFM0TjJlOTN0M3p4RmJjQkNmL3FBekU2Si9uekVua1hPbDlD?=
 =?utf-8?B?TTJzY2R4dWVTeWNvOXZBTjRmdmxIc091N0JMRkFwaW1sb3N1bm5KeHh0M1RL?=
 =?utf-8?B?a2ZNK0Y2QkpteUdkYm42VmNSeFlWNHFMdldUQVBiR2J5aE9oZkFvUmpRWHhK?=
 =?utf-8?B?ZkVyeHNhSUVWWFQ3Zm95S0xhanV1QUtjRTJMV3BxUzh1dmtlcm9sQVZ6TGls?=
 =?utf-8?B?aUM5cDhQY1oyeWFJK0lvbFNwZnVrYlNHYWk3dWZ5aE9nd1IrcVovQ3AyRHg0?=
 =?utf-8?B?R0ZaOHVnY0lZUENvWW5EendEY2tDRVFTSG13VlA4ekZ4OWVKY2EvWTFFQ0FV?=
 =?utf-8?B?bmlQMGw1UCswdnhmZDhhQm5SL3pleStRQkRwZ0gySEVidFhlbkc4dm16dWhY?=
 =?utf-8?B?NXdVZUdpQjFMQVhXbVozTjhINkUwMHBrZElzejhObUZsakJGSURPSFNKNjhZ?=
 =?utf-8?B?Zk5heS9CVnBEZldpNFJTazRaV3htclBYM01TZUl6dUNwaHNZd29yRW5HYUtN?=
 =?utf-8?B?T1ljbFJ2S0FKZWZKZ3Z6NFAxSXJHMU9vRUpEKzhhNStSUEg5RXgxSEo0VEY3?=
 =?utf-8?B?Qmw3akp0eHBSR282WlRTNUhWZ3B5eXFqd3hBSVJUM1NSRFQxUjhkV1N5bGlH?=
 =?utf-8?B?dVhtaUZiRGJ5OXRkcVErL1drdXkxVFNJcHhCdXVmazE1ejVlUXBWWFlQS0F5?=
 =?utf-8?B?d0lXc3oveGNLRTVsbGlpTVVMM1g2aVIrTTI3eERLSnZrOFhiWkZIR1J6dlB6?=
 =?utf-8?B?ejNkdzZhYytlbUxnL3VFcCtjM2kySXVZZGVTV2xVZW5hOVhnTEsyRTVrenB3?=
 =?utf-8?B?bE9yQzhuOUJ1UXRBMTJNZmhiSEx2d0NiaWRwRy9DQU10VWRYM3hoenpSOUlk?=
 =?utf-8?B?UEpXWlFJM3V6eUxjaTc4bHZEUTE1SDg3MlR6UWY3SDJMbkZuWUhPOXdPcE42?=
 =?utf-8?B?NVNVZFdYSDV5Ymw4MWR6ejZCeGYvVVE0NWtjLytjTEJMKytlaHg2T0pwMzIz?=
 =?utf-8?B?WjZpUmpxVE1BSjdtZXZ6NzNPUXRDNTFQR3dUeXU2UjIzYWdBMkU2ckRZK3k3?=
 =?utf-8?B?RFBHRzZncVNhekNWOWJveXF0eWFGay94RjcyRTdWSEVWYlF2a3lDWDlzaFVL?=
 =?utf-8?B?VGx3eUJKQzgxLzZwY2U1SEFvT2U4UU1Ja0JRMCs1VFFqSU5teVJqQkxZbVdM?=
 =?utf-8?B?dUROeFRBc2QrdTc0UG5oRWw2SkNiYXBNN0FlV05NTTlaU3ExOWthMTdIN3Ro?=
 =?utf-8?B?Z1pPbHdzckJ5bG5QSU56MEphd0x0UXc1bWF6TUlaUm5pRGNGS0JWQjNYQU04?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 595fd350-7469-43cb-19fd-08dad9b25ea8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5052.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:55:34.6201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y7wOFUzWkToHlBbaBWxjwN58UeK6FPzFnsjyJmYyMza2jHWDop+o8zgWnsyZHT5866L8LW949r7UE9kspotApw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7393
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/8/2022 2:25 PM, Xiaoyao Li wrote:
> commit e37a5c7fa459 ("i386: Add Intel Processor Trace feature support")
> added the support of Intel PT by making CPUID[14] of PT as fixed feature
> set (from ICX) for any CPU model on any host. This truly breaks the PT
> exposure on Intel SPR platform because SPR has less supported bitmap of
> CPUID(0x14,1):EBX[15:0] than ICX.
> 
> To fix the problem, enable pass through of host's PT capabilities for
> the cases "-cpu host/max" that it won't use default fixed PT feature set
> of ICX but expand automatically based on get_supported_cpuid reported by
> host. Meanwhile, it needs to ensure named CPU model still has the fixed
> PT feature set to not break the live migration case of
> "-cpu named_cpu_model,+intel-pt"
> 
> Introduces env->use_default_intel_pt flag.
>  - True means it's old CPU model that uses fixed PT feature set of ICX.
>  - False means the named CPU model has its own PT feature set.
> 
> Besides, to keep the same behavior for old CPU models that validate PT
> feature set against default fixed PT feature set of ICX in addition to
> validate from host's capabilities (via get_supported_cpuid) in
> x86_cpu_filter_features().
> 
> In the future, new named CPU model, e.g., Sapphire Rapids, can define
> its own PT feature set by setting @has_specific_intel_pt_feature_set to


It seems @has_specific_intel_pt_feature_set is not introduced in this
series. Then don't need to mention the specific flag name here.

> true and defines it's own FEAT_14_0_EBX, FEAT_14_0_ECX, FEAT_14_1_EAX
> and FEAT_14_1_EBX.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
