Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154E95320A8
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 04:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiEXCG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 22:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbiEXCGu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 22:06:50 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77686B011;
        Mon, 23 May 2022 19:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653358009; x=1684894009;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NpxZ0ktIhwUIXyX8NWUubuQ2OFq4bvaB1nitaIDRJCo=;
  b=JEejhq1Mw3OyRU9drwxc2KNgqH6/Zyg4gvFH9S0G6PdYPR6M40iU0kaJ
   b/WoMuN3AMn4tGC6B66745cTHI74hfaixn+KZVCDuMy/pFcD1UtPEPhwb
   KAyPKJrM9u6N6ByCDO2Pbvtd4iiBpuiOUaeu+8wYeE6OZflcrsWvVZfuj
   vmav7+SiLXk2ys6mTZnP6N945xIHcZzKuRHOwWjraHp1GVOmzDo6RALz9
   rouaFdFk+r3W2XNeD/ZrfzAggD6wkPExaaJ6LkiKFCOMnFJilz9rSNg1N
   Bo1IPfK83jdqg2iIGynKVLgdlbfj5NjGB8XrUZfOUQQF1jEVTwwhM0vvA
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="253281448"
X-IronPort-AV: E=Sophos;i="5.91,247,1647327600"; 
   d="scan'208";a="253281448"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 19:06:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,247,1647327600"; 
   d="scan'208";a="572401541"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 23 May 2022 19:06:49 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 23 May 2022 19:06:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 23 May 2022 19:06:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 23 May 2022 19:06:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oW4T9PgxicVppbisPdPoJWh+l/p9RSxUJ3AQFHJFilQZlF6OfMeQmCKXiJhv6PoGN/nMQXbb4j3laWLLp9VqDwWCGU+gOq52SW7CzT1/ekkUhBdtjd4cEoO99pA9O9Q1OgDWMOY8tfN1lffPiEi7gsVi747zur3wgVAVo+wzbex3XjKA4zWDu5ZXRQGanJzvPjV6UwaSihKaF99URDSKDdNjs4Ct/vPxotm7YQYsKRrHfpRZfQu28ye3/A03Dx5rKHJY3/rHVOKroA0ZheUPG+K/Z7hGKxnkUaxqZsV1z6boHW8zW/8oleEzq7SoOT3mmSZMVXJjTfIJ2h5s6xryAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RFduhSnaej0Yxd9XfjTozk1yQLjIG85+yWhS1JaHeys=;
 b=d6had5KR8HtPnig3QRD9hRR/Uf6F1TgW/vYWJwvwQ6re0/tIAWeBOwT6/eLdk2fj57glZsPX1MrYHRZZzmQ5kvM8KKJKfN1yEs5+uYGtPzbeKRzPhyIzpmO+4555uO2p20iVK2/lAwoUcCwwJf6KaWRlGSCxm/Ax11sFcXz/JszyqFFFD4bl/xTWzRRz/Qf/wqF3DUtn1jcZGI5MStFvl18LN3cqhHxXviqq1MRsoiLTL3WEsNv43IuYMcf5k3AZP+BnSJyGCbCyudC0pjGqv6J4WqViZyWtWDCNHOXj8CnTUZ6It107aitxbTlJdL5G8MHrqMDoxkLYaZK7a8AE/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB4138.namprd11.prod.outlook.com (2603:10b6:5:19a::31)
 by CY4PR1101MB2088.namprd11.prod.outlook.com (2603:10b6:910:17::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.18; Tue, 24 May
 2022 02:06:46 +0000
Received: from DM6PR11MB4138.namprd11.prod.outlook.com
 ([fe80::e9d2:8b69:bb48:b305]) by DM6PR11MB4138.namprd11.prod.outlook.com
 ([fe80::e9d2:8b69:bb48:b305%7]) with mapi id 15.20.5273.022; Tue, 24 May 2022
 02:06:46 +0000
Message-ID: <d8385487-4da9-42d1-36eb-942a849bd55a@intel.com>
Date:   Tue, 24 May 2022 10:06:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3] KVM: x86: Fix the intel_pt PMI handling wrongly
 considered from guest
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <wei.w.wang@intel.com>,
        <kan.liang@intel.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220523140821.1345605-1-yanfei.xu@intel.com>
 <You5oYO5flRRFv4n@google.com>
From:   Yanfei Xu <yanfei.xu@intel.com>
In-Reply-To: <You5oYO5flRRFv4n@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2P15301CA0020.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::30) To DM6PR11MB4138.namprd11.prod.outlook.com
 (2603:10b6:5:19a::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 120ba91f-3a4e-4f63-a72e-08da3d2a0e57
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2088:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CY4PR1101MB2088E98F24365EFC8B274781F0D79@CY4PR1101MB2088.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BI4br/UkyUjWZggDYGbHCVmet7vgUF4uqRM7fUu/IcKlhZRNId+8Qz2Li8hUPkbbiApoWM6RLwemQikFogMULccwrzCQhaPrVkW8Xp+rdhlnKlG62hbsq367ByZE3bTg6bO0I4qb7IoumMFbsGIbwpFoNX3xZMEG64OAFdcin1/Jv8dkz4/zu8eheZFK7McicT8DQqntPbXlvd9pVqHD5epyWIt+yQxyjmyFKc8cVlADQG+icIgDCvYAggv544g5pzIZdJ7CrcpMGMr/HHThAroWR/drTwuWTxlVo5xrCTW4snK0Qar97quuYZ39sinLVoCTK3XyW0rEkmKbV9rxoLWeDHTI3vSJ9+vav0QzLxbz2yeXIjbncutuF3fSYJUfkP4WpN6UCLBeNNhCgWoW5fnQ335nr3P0LaBc66Ex/hzUMLUHlemy0qapp1OH5R7Aq+a+hkzLQC31xfqY2mkpcBqOClkTGmG/9+3cfr9pn0IiANHq6M9d8jFp453OIpkcmqYaosbpQjHRvPCw+Db3/mZ32V6hbEKKLYnsybKjnUBG+O2o4lk/k4tpb82Nr+ogSfjdj2AYP8FF+UJiL9eVn39drbeBpQv3t37CHSjvym1UxZRf7uBOD383rsFgBdE9xR/wdGm51H8Q34M1gYh3QQqAaNhY9RIWZ+xr8LkMw39FWAx6tDxIN1kUsHQdvgkZgpVqt0BdW0lDUflGcR8cJwMA4kJj5cd5Of4wzt5kfsI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4138.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66556008)(8676002)(66476007)(31686004)(66946007)(83380400001)(186003)(5660300002)(36756003)(8936002)(38100700002)(6486002)(86362001)(31696002)(53546011)(6512007)(7416002)(2906002)(2616005)(316002)(508600001)(6916009)(44832011)(6506007)(82960400001)(26005)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEZYVllDYWg5UEhmOGxaZ1kwcDJPa2FHd1hYeEJGQWpFREE1RW9zUzhST0pv?=
 =?utf-8?B?cTN3bDFMYXFnMTJOUHRwK01NVkhNMk5hUFBEQWFJVE1jWk05bEM3SnRBNXhy?=
 =?utf-8?B?R0Nlejl0UjZxc2swL1lKUjFKNTRTZVd2d0ppUFJ6NmticEJwOTFDa2c0d3hQ?=
 =?utf-8?B?aERpWml0WWNsN1FNbncyOE9SME8rZjFQRndxMy9Xbnl4TnFzVnFsL3A0dmtL?=
 =?utf-8?B?UVRWTlBVaHZROWFjLysweFhTOFNhaEtOaE13b3ZFU0pLTlRpM0djQi92MEF4?=
 =?utf-8?B?aUFNWmNYYzdCK0FGaTRpbWFNN2FTVWFpZnZaakVvdjVZUWZUa1N1Slc1Ujc3?=
 =?utf-8?B?ek1pRXphWjN2WXVDQWk0WDVpRkV0RkNhWk5wQVBjWEVJR2xvYjlzZEV4L2Q3?=
 =?utf-8?B?UGZSMVJuYjhiVC94UG5hTWdLekN5N2xjQmUrQU1VV1Ywamo3bklRblU5R0U0?=
 =?utf-8?B?RDVobGV0ZUprNUw3aEdzMnFSc0REY3c3ZWRTanZYU3ZCNU81eVY1Q0RxZVpE?=
 =?utf-8?B?cnFpK3cyc3hHcEc4YWVoMzZTSjFWZkUvM0ZtK1JsZUEwL1QrejZCRGQwZGh0?=
 =?utf-8?B?MGNrY1htSXlWTStWTlNmMzdvWHFiTlQrSDgwVWRjWnRMYXBzM1gvbC9NNkNj?=
 =?utf-8?B?cGR4S1Bacjl3SUlwSnNjS0ZwWkY0WVBQUkN5Qmx3bDNHWkZNL1JkTThyNzIw?=
 =?utf-8?B?VUNaZ0ZyVnF6SHFoY0Y0RCs5a040QmF1UjVsblBhOURUeEx2WkVpQ0V2K2gw?=
 =?utf-8?B?U296SktqalU0azEvWTl3eFh0RWlBS1RPS0NUanQ2M3UzaTNPeXRFWGNEYlVl?=
 =?utf-8?B?OXdqYkpVdFhkcElINUlPWkFUbCtKVHpyNFJxbUlHelJsczhYL3ZVay9Rd3Y2?=
 =?utf-8?B?REwwTnlYc0xPUHNIUjdIS0crS2dVbUxWS1hOd0cyem5jVlUwWkZsdks1TDFn?=
 =?utf-8?B?OFdId2tMdk9VRnByUmVnREE1R2ppVlFPM3J2STJCOTd5UUpOMEFhejJ2NE5B?=
 =?utf-8?B?SUlkTXhEUzRoeVNrelVWRmE0Q0t0T1VYZGRrcEN3dVI0MHJsdkFBMkhFdFBZ?=
 =?utf-8?B?SnoyV0QzdTlsNjhjNlZ2WkIzc1ozZXFzUnFJVHEycjNsemoyK25zaitVclZj?=
 =?utf-8?B?Q2FSbmY0c3QwcGZ6a2xMbm5LWkN0UlNqRmtFTGlqM0htUk5YcTl5clZBWkpU?=
 =?utf-8?B?YUVhSDZqbS9kU1Q3QlEzRllpOXZkWE5HaUc2cXhqL1V3NmZ4Zmd2SWhGMGpB?=
 =?utf-8?B?RU1QeUpXRURwbVhvdUV0RFlucE54Nno0UzBCbElNSURqMWVMYm1GajZvRkJw?=
 =?utf-8?B?aW4wMXFGM1UvajVqM0E1V2x4VEpYODFjUFNldDRCMHd1SE5DQURlVDc5YVpL?=
 =?utf-8?B?aUZSRmVySHVZN0VZUGVoS3c1aU9pSlhXR0lSWVBBS3QrbGx5K1RqUHFtS00v?=
 =?utf-8?B?Z3NQMW45SG93K2VFQkRWUmhVeUo4NVFrNlpvK0ZrNkRiWHNWdXdUN1A3OGl0?=
 =?utf-8?B?cjZ5V1RjbTg4T3cxS3dvcGg1NHZKMTNJa1p0Z3NRZTdiY2MybzNZekdLSTFo?=
 =?utf-8?B?cW1EMC9HVElzMmFkMWt5R0N1UXBOVEhGRVloWUNvSW5WOTg0RXZLSS9GeGVk?=
 =?utf-8?B?b3NwcG5qWEFXTUx6SDNPdEw3U0Y5dUFnbDJsYkZ5TVNJTW01T00zUDVXdUVj?=
 =?utf-8?B?V3phUDdEYlJtcktVcjBSRTNqczNNY3J2c0NPcVRDOWxjNUFteVhIK3REMlBw?=
 =?utf-8?B?YW9nRVJLeWdXL1IyNGhoanZ4by9JREs4MU9QQUZ0WlpOZ2FLaVY3aXZuMFpp?=
 =?utf-8?B?SC9ITnEyK0lCejBMbTlQQUtBNlVkbXAxNThvUStGQ2pWWmU3SHVDWVZwbi9v?=
 =?utf-8?B?Y3dIblRhRXlZd1VjL2dsS0FwemNEdDJON0hHVllnUkJSUnlIQmpGWUFGZDdv?=
 =?utf-8?B?MVBBQlB1L09iRnRSSzZXaHo4WENhZUZFVVd5STRkd2lNbG15eXZ2ZFdkck53?=
 =?utf-8?B?T29NMzhRRGduUW9DS2RNVThpK0h0RXdOcjJjVkY5Nnp6Q0JiYlJjakpnbzVS?=
 =?utf-8?B?bU5LdTF2QkZzUGVvWFF1ZVdiVUFPZkpxaEprNCtVUGpvWkgxbzR5MmRxQ3pI?=
 =?utf-8?B?SXFlNmI3MTlzM0dEenRURXJMaGxKU21FSndFUTNJRG9acW1FSUxZRmQvc0Fj?=
 =?utf-8?B?ZWs5NThDYUlpa1krMlZQWkI2dHZhQnZic3hDRFBOWVNDQ2tXeTRiTDUwNzJW?=
 =?utf-8?B?WXdIWksvZUNBMWVoY0xyNGNkaUwva1RYWlFORzNScEtwL3N0RjNWRUcxYTZ5?=
 =?utf-8?B?VXFkdERRVzFCMEFYeVR6Qlc4LytpUTdZeEs0ajdBL3RzY1dGMmh6UT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 120ba91f-3a4e-4f63-a72e-08da3d2a0e57
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4138.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 02:06:46.8173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ld1veyd66mc1VuY0/IPp716CZ4m/TyCrV/0/BDlwiwGQGcheNhlIeoaBglqPxVNfW7lgA6dSffzaqnL/3qsBIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2088
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/5/24 00:43, Sean Christopherson wrote:
> On Mon, May 23, 2022, Yanfei Xu wrote:
>> When kernel handles the vm-exit caused by external interrupts and NMI,
>> it always set a type of kvm_intr_type to handling_intr_from_guest to
>> tell if it's dealing an IRQ or NMI. For the PMI scenario, it could be
>> IRQ or NMI.
>> However the intel_pt PMI certainly is a NMI PMI, hence using
> It'd be helpful for future readers to explain why it's guaranteed to an NMI.  E.g.
>
> However, intel_pt PMIs are only generated for HARDWARE perf events, and
> HARDWARE events are always configured to generate NMIs.  Use
> kvm_handling_nmi_from_guest() to precisely identify if the intel_pt PMI
> came from the guest to avoid false positives if an intel_pt PMI/NMI
> arrives while the host is handling an unrelated IRQ VM-Exit.

It's much better!

>> kvm_handling_nmi_from_guest() to distinguish if the intel_pt PMI comes
>> from guest is more appropriate. This modification can avoid the host
>> wrongly considered the intel_pt PMI comes from a guest once the host
>> intel_pt PMI breaks the handling of vm-exit of external interrupts.
>>
>> Fixes: db215756ae59 ("KVM: x86: More precisely identify NMI from guest when handling PMI")
>> Signed-off-by: Yanfei Xu <yanfei.xu@intel.com>
>> ---
>> v1->v2:
>> 1.Fix vmx_handle_intel_pt_intr() directly instead of changing the generic function.
>> 2.Tune the commit message.
>>
>> v2->v3:
>> Add the NULL pointer check of variable "vcpu".
>>
>>   arch/x86/kvm/vmx/vmx.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 610355b9ccce..982df9c000d3 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7856,7 +7856,7 @@ static unsigned int vmx_handle_intel_pt_intr(void)
>>   	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>>   
>>   	/* '0' on failure so that the !PT case can use a RET0 static call. */
>> -	if (!kvm_arch_pmi_in_guest(vcpu))
>> +	if (!vcpu || !kvm_handling_nmi_from_guest(vcpu))
> Alternatively,
>
> 	if (!kvm_arch_pmi_in_guest(vcpu) || !kvm_handling_nmi_from_guest(vcpu))
>
> The generated code is the same since the compiler is smart enough to elide the
> handling_intr_from_guest check from kvm_arch_pmi_in_guest.
>
> I'm not actually sure that's better than the !vcpu check though, e.g. it hides the
> not-NULL aspect of the check.
>
> Either way, with a tweaked changelog,
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Thanks Sean.

Regards,
Yanfei

