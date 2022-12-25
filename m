Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70BF1655C5C
	for <lists+kvm@lfdr.de>; Sun, 25 Dec 2022 05:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiLYE1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Dec 2022 23:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLYE1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Dec 2022 23:27:36 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A1D65C1;
        Sat, 24 Dec 2022 20:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671942455; x=1703478455;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=p6iA4tUxMLMuAJJomWArTHrZ1JQtJPpVukmADn8MvVE=;
  b=hh1c6bZROQ7fRWHMKCcAnZE1gzaLK37poNfJEH2s5j8HqleTxTdo9l6X
   UZHGQZgBI8MOUcPtS/pQUaPQilSJ3QNKq/nHwYREW5jwaod54tfmAsfq2
   WfEn5zUnbbbkYzRQt/7ZcnOfxFXQfF/h9I1XftfLSKc02xZ2xPgdjiSx7
   l8N48DGeSxjsiMxgOU/o7sr1YX1q6UeKsqAe0BbcuUtCdm870T2OyvJXj
   WXqxXJcLTW8P0NoDURpYw1uNRyP65C1RwCOwCzD3d3kqSFT6ejkaiIDaj
   5npZSTL660TrswFJqYNEcCDa/NK/rQFmtzRAaNObDJDdFWA/dtXmZeYlA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10571"; a="321685281"
X-IronPort-AV: E=Sophos;i="5.96,272,1665471600"; 
   d="scan'208";a="321685281"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2022 20:27:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10571"; a="683052521"
X-IronPort-AV: E=Sophos;i="5.96,272,1665471600"; 
   d="scan'208";a="683052521"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 24 Dec 2022 20:27:34 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 24 Dec 2022 20:27:34 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 24 Dec 2022 20:27:34 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 20:27:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hf7IyjZEulFilDXEGx2B88z1e7RGy1xAsU1g8Mwh2nd8Rol0B7OgYfzWuUOYKWkhqy1AAq5fiFIPPbbzM29cBfxroBuHh/kyt3DwbJaOTFPi2LIMswHwaAv8dCTamGcu/No27k7Cn1Ha/bDsO+Xyfvb3zsRSBfxj/rE0+LPMrKedKB+P6B/teXwIfabZ9I7EI1eA0SzfYqS9thgEwPkzKGHDdk5q7e3ERxOFVtjxQ9QtsOYThKMLBO6o05EXiQUuy1IHmD2KF3s35TUAnYuaHnUuwcgRhGtls1Sk3ddbbRfgbgMzIZ4Gv2e4M14TLdhxYU7TowejFMfUFuij5E/trQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ilX5zysLQmQibi9NUtG7lKToDuyXGfNTeJE71vbr2c=;
 b=bMWGnAZytnwp7vL5evjGlx6HRiXq2ptceq9WLqR5a/CXmOcyC7kp0UHv0A2RS13dzmTJj3v2sOb0RAfSSdLEYVyfY3FeCYk0xgbpJRrfN45XSECi3baP3z2IeywTGbrx+O8CnmNiapCOxWIdpOAxwDM5tE+SdgRVqejLdXohELsIzAGSFLs6fMJj4jxdMs0e+gajAJ+wOF9vtFeNJosqgJd6qg+sHre2plHtEcRkGBtpMmPVC0kwWKopspSQ9FBlfXq/sofpayF6oscwdtYmGuv/1p32KPTXccHZ3OLB9TAjYO/vmpyToEBfXQMEBXr7gRuvjBvIiKoP6ipvhGJMSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB6237.namprd11.prod.outlook.com (2603:10b6:8:a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.15; Sun, 25 Dec
 2022 04:27:32 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe%3]) with mapi id 15.20.5944.014; Sun, 25 Dec 2022
 04:27:32 +0000
Message-ID: <d3623400-194f-694e-5d33-bc6b1573913f@intel.com>
Date:   Sun, 25 Dec 2022 12:27:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 06/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest
 Arch LBR
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
CC:     <kan.liang@linux.intel.com>, <wei.w.wang@intel.com>,
        <seanjc@google.com>, <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-7-weijiang.yang@intel.com>
 <8f0fec41-d302-b261-ce5a-83692f1238b6@gmail.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <8f0fec41-d302-b261-ce5a-83692f1238b6@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0024.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::13) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB6237:EE_
X-MS-Office365-Filtering-Correlation-Id: bb0dd860-a8bd-4b0d-c88e-08dae63056dc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zXTAzQY/EyQlvQY33texofajRkto/+EQbhvNi7nGegrqK+WEqQlZ0F1CBtRivlJEVP1dnhBkRXzwVawnJLwt/2AnFZqgPibU1J3Dw/t8WOuxVOjyHrfmh9wIPQ8Nt1DQuTUypYYpVF7Rj+fokfN0fxDQ/OY4Gs0Nlz/gPnZvgLa0XWhsoXLlPda6tFI1xnVCxmcWrLEAlSmv+PNDhcNcA2db/U6H5R8mQsckOewXZWg/qu0pBO0oo77pc1RNQ3Bcbdaw9lDbLqPoaEX8ktovGN/jQKb4FOrF3k4lntLgZ+WBYOXVGkI8648FexkobE5DzIOAtx/wvNDFHZuFPAuKQK30u1pg+WhvBkatB+K0AsAqy/gh6hdqTIS6LvQKSjrGk2Z4JssTnVk9x1cZVG4hM0+EyBbmtIKiw/49unSQjFflsizFRMuHVK0xnyJEcV7jJJBdJrKC1P29IvrkqfynFfJsjOch9/10LWXGnmd7iJR5DyLSlil2jMgN/Su7A2JaZHeQhavT0NUyfy5+HDfAbLdl7A6KoLtHgRLmjUk14QBifoInTm1f2NNTNtvKI6wYd3x1JZfnH/UYcrobqB62FnsAHorFzUjmnUsNoc5gQBdp5TcCU1ORKHX3iJ4HOUco3aurqExhuPRAjHabvdmrQ2dWEhdXhadQ4JQ6ssMdyXZ6dUBJZVmQXnfJP8Al4ZJWMuZuM9zfVSDGs67P9/tzE0bAroY60ObIcHcuLHzjRqk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199015)(36756003)(2906002)(82960400001)(38100700002)(5660300002)(8936002)(41300700001)(4744005)(31696002)(83380400001)(86362001)(66946007)(66556008)(66476007)(316002)(6916009)(31686004)(6666004)(6506007)(478600001)(6486002)(6512007)(4326008)(8676002)(186003)(26005)(53546011)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTB2QzNCSVFQUW5BQkdUQjNudmloS3JyaUk5VTA1bmJFUk5wZFFhY3dUYUxj?=
 =?utf-8?B?cGs2YkVyWUtJYktDaHFjbkgrdXh1YnYrSW4zd1E0dlN1MUltQmxPeDFZMDRG?=
 =?utf-8?B?MVYxL2hRMXpkbEE4dDBsbHF1dVhlZ0l2S0ViWFNVOGJrOEVIMjJ2MlpVQ2wy?=
 =?utf-8?B?Q3VJS1FSVE1NU212YVh6ZnNnbkloWHhXem5ncVlVZGJUU05xMU45aGNZVGh2?=
 =?utf-8?B?UmNtb0JGTkZZdEx5cEcyYzFYUjhYeG12a1ltRTFtbVp3UUxoS3dyQkp2RFJq?=
 =?utf-8?B?Y242a254c1RRckx2TXdtaksrWXkyTDhlQXNrRlBDc01ILytjbjFFeGRvbHRw?=
 =?utf-8?B?THA1aWJ4S0ZJbEVYM0tsdU9qZytTaytZMkswNjNqTkVnblhBa1JRdndRRmh2?=
 =?utf-8?B?VHFaa3lzMUEvYlQ1ekRZNXNjSWh6d3pIbnBDTzA4TnIwSGtVVDVHWTlGcTdF?=
 =?utf-8?B?bjVPWHIzSGFoNVZSK0IwWkY0QVo5eGVmUlYxeE5EZ3ZnRC9aZjB0SUtpNFZI?=
 =?utf-8?B?MjkzWUltR3ROdWR1ZTFkVVZTczh1SG16ZkU3TlBsbG56VFlDMjdVZlQ3NWFX?=
 =?utf-8?B?MG0vWlg5b2licCtQL1NMcmFPekoyUG1kNG0rU3EwVytuMHlORWMrQWJnaWFs?=
 =?utf-8?B?R25jUEcwdmNqRUE0OFE4NEt6b3ViMzlKdGZOazROcUJhbnA1Rk4wWnZoUzVX?=
 =?utf-8?B?a2RCcGhnVGRRaFo5R3RWYWVUQmY4MkdxWlNDeTJlaTNCMnBuQ3RDaW1kd0ky?=
 =?utf-8?B?VGpISEhNTmJSTzBETm5FSDdjeGJ0bzlpZE82UmdhRGlocGx2UWRKOWdNWFpL?=
 =?utf-8?B?c2ZoMFozOGNWYjRiVWoxYWNFVzl6WXpaOWhidmpCc0hOUmlQdDBRWnZXZml3?=
 =?utf-8?B?aW1LSjQwaUpQcWQxSUFwS3ZjK1VSS1grczQvM1luUUtHTjd1Z05SblBSejRo?=
 =?utf-8?B?c2NIMU1EVWJ3ZUp3MmpVTWx1MU95UzRwTmVtb09xYUt0aGh0R2p5cDVIdDB5?=
 =?utf-8?B?cW1MNnp2NkRFN3dPeDIrbW8yTVV4cXBoYiswcVNlS01ldEhCSkJkTXNIRWIx?=
 =?utf-8?B?eC9BMDB1WmlWREc5ZEpuV25VM2tOL2ZoWkdUOTRyY3ZHME5PbnNrRFEzSGJp?=
 =?utf-8?B?VUczbEk2STRaakRkVlM4Rzh5enB0K2FxcGJKVitJVU41OGRCYkM4RGVNR1A2?=
 =?utf-8?B?TUMxZFcvR095Sk5UYzJCR3BraU00N1pOODNPaVNHbzhwVXB4Q1lFMzBJTjVh?=
 =?utf-8?B?RlI4T0E5Y2ZKMjN3YjQrYkNiYzVYUE5RNCtSTkxoREUvNzRITDZsUVVKeCs4?=
 =?utf-8?B?TjBYY3k0cnhKLzBjZHNrSUQxWUxCL1JIN3YxRXZpaDdJeEw0Nk8zYXhKTm5t?=
 =?utf-8?B?Sit1VTNGOWpRYlFHbUhWZDJJNmR6b3dKTkxsa3Y2bUZkNTM0RHBPeFZaeko3?=
 =?utf-8?B?TkFMVXlxUXQxOHp3Sm9uKzExa2dzdk1sUmFGdjZsbENhdVZKMHNVU3Y0VzFS?=
 =?utf-8?B?czh1WFlSOTVXcHRHWCtId091UXlId20wTUpJV2JReHFqaTlLc2VOeitNYjRR?=
 =?utf-8?B?eUQ1bmJwR3lPRzRqTCtoNDlZTWd1ZEhNWkE2aGhPTC9ZdG1uREhpRVFQYzQr?=
 =?utf-8?B?YWhRdVU1b0JlUmZ1eUlaTEJQZjJtcE9yRU40S0dIOVZON09XVmNyRFRvZkF5?=
 =?utf-8?B?QU90bmVwMWwxdk5CTjF0dFRxR1pUcUI1eXhIUGR0M0JWQW03VkZNZHZOaUwy?=
 =?utf-8?B?WVhPdUdUSHhqWk0zOU1BS3czdXI2cEhCVEI0Sk5QeU8yMnFHd3VWTnJrR1dv?=
 =?utf-8?B?dUdqc1NPUERJWG54RWIrT2Q2MUpGN1NEVVVHL3NlajZNMnJ5c1hmZFI1ZEhQ?=
 =?utf-8?B?MVd0ZGlIck1WWnVxeFhpdnVLV2N6VzU0SWRyd1VpdW5iUVZUYWlETDd0ZnJi?=
 =?utf-8?B?Yml1Rm84WlFlVkxyblBoQld4TnF0VFpIbnFzL25OODVnNkN1Y1RmOGVSWEw2?=
 =?utf-8?B?c2MwQXgxWGxmZVh6b1IzS1Z5VUUzL29STTIyU3FDMmtNa3NkVUt0SnRqS1pr?=
 =?utf-8?B?YXlxZUc2Y3NrbThpNVNac3ExSW1BUVVNMXNKZ2NUYm5GRzBMdVVvYTFETVBK?=
 =?utf-8?B?eHV6L242azBKV3o3Y3BTMG1ydHJrUXl5WVBpWXMydlJYenZlOGF5eTkwbDJr?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb0dd860-a8bd-4b0d-c88e-08dae63056dc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2022 04:27:31.9443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gYSsjFg3X1Wm7rQugLkLWB37OIS7wpaC92zWEdzAO2F0VZ0sVBkMtbEXxLhKQZOn9ZA735OPE6RRwivzRkjA8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6237
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/22/2022 7:09 PM, Like Xu wrote:
> On 25/11/2022 12:05 pm, Yang Weijiang wrote:
>>   static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data 
>> *msr_info)
>>   {
>>       struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> @@ -377,6 +402,14 @@ static int intel_pmu_get_msr(struct kvm_vcpu 
>> *vcpu, struct msr_data *msr_info)
>>       case MSR_ARCH_LBR_DEPTH:
>>           msr_info->data = lbr_desc->records.nr;
>>           return 0;
>> +    case MSR_ARCH_LBR_CTL:
>> +        if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR)) {
>> +            WARN_ON_ONCE(!msr_info->host_initiated);
>
> Why we need this warning even in the format of WARN_ON_ONCE() ?
> And why not for MSR_ARCH_LBR_DEPTH msr ?


IMO, this is just to give some informative message. Not necessary for every

arch-lbr MSRs as MSR_ARCH_LBR_CTL is the master control msr.



>
>> +            msr_info->data = 0;
>> +        } else {
>> +            msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
>> +        }
>> +        return 0;
