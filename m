Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8796D1791
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 08:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjCaGjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 02:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbjCaGjn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 02:39:43 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6531116F;
        Thu, 30 Mar 2023 23:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680244781; x=1711780781;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TuqpTg5Fx+IMF22EEQJX/VwS6GUUs3NCcE/1c3UDHm8=;
  b=P1gx82qcwIY8N0JFTGA3Hn8N352rZYo5HS1FeY3J1SoLAO8dpb7V0SOn
   EnLDeJo4bcTfNr1i9AJS8mkhN1gt4vUjNmOOtMHCZldPb7Btg+Lnb9tPR
   tl9DmTwoQJfXhkwdwOjJlZ8S9w+2YXTiUCm2qiHCho/jraVvADhoen/jN
   /Nsqn8+nB1DrGhFfp/SSCVBDKTOSMF9LPgle6UxfvYBLCA+q5f9skijjZ
   h9WWwqfe8RhMmXVrY7vlJ7o1Nb+kN/Ual8E6OdvUEptMtzfj3TzuRanjj
   rIJ1mGwcI6aGdCwxCiVZKYcvsxGPOEYN/hZZRxU7kt2wl8zz3AHyM56yZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="321026856"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="321026856"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 23:39:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="749508815"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="749508815"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 30 Mar 2023 23:39:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 23:39:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 23:39:40 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 23:39:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8Y2EpUSlVxhZsBgQrz95I79vq9NtYq+JKQv2UNOzIFgzlLwYXgRQTToMnWohF0kf4VTvqLPw6VF5omf7yuuR/ezoZK2e1LkF5uJux0kGHWL4pr86K20PZL/nxnZdqKHukJODJS2jrdlHueX4pVrHwmZRepVaFz+0o4BVWX5yUI/qcUiRjIdsjEsOqLCPZzCRSBodGtg9fBghGpVucPmz05StfVPBG8/IFMbGleOAUdO9iYgPnub9oqvDFs0fbX5nWa3HPUW9klzWgsJUNUIJ5CU73K/7gUvwQGposzJNTQpB9nVZ+IyOw+2bLUoaQsqXuDpom6FC3DCm9icFo5fRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1SquwDCWD7ZW1KTtgConb/cRQSSy4wh3trCaVUtEaGE=;
 b=Wbj9qxyb9oCo2b8fl9F9UrZwHaVNv1EDVVVDlaHPcbD8W/lQuKbD/t6qZuvO9vmkM7OLxMVlJxL43aXX9l0IECdB+SuUU0f/gc+Yp6vpK6FM9awvN+IKfpIacMZ3qfHpVJVO0iWIuBnH09Hr7EGU03hIEJVzX/zfPTasnqfE1Ymqbri9vPffzd0qx9g/YTQz22BajrSVZLTWyecHKihmy2F3ij0jAztkRe6OxgnWwTODkayjeFm9yQasYVU4Gx5swuDOm5tYk7Swyl04gDysLUrJaFc8d6IWBYHd18azTAA1kcjFSdBIReZBBj15BM+KuvXTIHdaJZ+QTixrW8TOTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB5456.namprd11.prod.outlook.com (2603:10b6:5:39c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Fri, 31 Mar
 2023 06:39:36 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::47e1:d7b9:aab:dada]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::47e1:d7b9:aab:dada%6]) with mapi id 15.20.6222.034; Fri, 31 Mar 2023
 06:39:36 +0000
Message-ID: <8e8e2885-22c4-46f4-ba25-943fedd11319@intel.com>
Date:   Fri, 31 Mar 2023 14:39:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [RFC PATCH 0/7] SVM guest shadow stack support
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        John Allen <john.allen@amd.com>
CC:     "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20221012203910.204793-1-john.allen@amd.com>
 <Y9B97dZnFnjEHhVf@google.com>
 <d4e15021af4e72d6daba4021feaebf289b676830.camel@intel.com>
 <ZCMpJLAx8//1zLLV@johallen-workstation.lan>
 <b75c6f20-a99c-a6d4-c1c1-7ae9f016d2af@intel.com>
 <9cf73a9d-d9eb-c6a6-a083-88539a3e78a2@intel.com>
 <ZCXnYj3GsoB1Kipo@johallen-workstation.lan> <ZCXotrLbDl6JJaVj@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZCXotrLbDl6JJaVj@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0063.apcprd02.prod.outlook.com
 (2603:1096:4:54::27) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB5456:EE_
X-MS-Office365-Filtering-Correlation-Id: 13642f1d-76a2-48f8-267a-08db31b2b1bc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tzE+a/cTQGWKHQ99KEjU9ElCTeeQOrlAgivTH5QvP8YK8FUwL713554W1+o5kpj75ueqh/lwYXmzrFnKF9S9GqE3ESlfhHe4zTS7/87LYs28nPOJm77cfGj3gzTBj2O6kuwOL9IvZvU6BYYzZcXzTdXJsYi6s2PDEXK9D+xMWucYFbF4MRfSCYAMZooWJvYIIyEReoDnPJe9FkT42nCntS5pW5rW6fph86B/+sRKBggmFVe53APgC6uuEBj7VHP3PLgvfkVNhRbtv83Hn3Qy/aIiqxnd7JbZC3iG+9L4+M469MDE8rKB8OOdFK+7Be9syieKnmoiSL0N1PKiEM7TXeuG9wkkPuUQplwCz4uLcxSrtdqfTX4oTJNF1tPReQtCbvSZ1JVrzsH13rNiQv0Q2pQVCALeya+zCOLL+vvLEqws12sJF+7UgUmK9V+v/M+ICsbmm7bJ4j/so1UarmeDy2gkQLYcgQvz6GyxehX3KPuF7srAZI4f8E2dwZwqox1x/RYVXS1j9fgqTsWdzA0uZPQg/vvxkxQtWOFFnmNvlft4aBNn5SFQL3oKfdf884G2PV5aUctWjiX84gtBTbiQfyI1QTi2yYnWqZgFCeboxxgbrmFHrgeN6e+0UG0TUh2gla/nn8W2Q0gfLRE7SzM1pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(366004)(39860400002)(396003)(451199021)(8676002)(4326008)(66476007)(66946007)(66556008)(38100700002)(83380400001)(5660300002)(66899021)(8936002)(2616005)(41300700001)(6486002)(36756003)(6666004)(110136005)(316002)(478600001)(54906003)(26005)(6506007)(6512007)(53546011)(107886003)(2906002)(86362001)(186003)(31686004)(82960400001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWYyeVJEYXBsZzVyWjloTm14enhKNkVIMG1vTUozYUlzeFc2UVhPRHgzbUM5?=
 =?utf-8?B?UHo3THNneXN1N3JLbUt5LzJNUkpQTjllWU9scitIK1VuM1lKNWxGWnZkNitM?=
 =?utf-8?B?RWwvQlBOaXRtM1BFeHN2dUNnQjN6bndDNXRXTkxpbWlJR1ZHMk9kYVNlOFNJ?=
 =?utf-8?B?azNlUWpsMFlWU2V3TWVqWjNXZnJTMXZtMlh1eExwNGFzWkJXVW04RFZMaUJx?=
 =?utf-8?B?Skx0enMyMDZNV3BJVnJQL3VsaXA2bHhUcUp0RGZzYU95ejYxUDYxdU5YMGwz?=
 =?utf-8?B?bGZTd2d5UHdhRTU5M2FSbURCL2hXUU1rTDEvZUthMExRdzVmT0prcjhLZW9p?=
 =?utf-8?B?LzY4bGJ1K1IxVCs5WWZDT0VCS0pGcFpOUzAvaHB4R25hendUaHhmd1p3bUxw?=
 =?utf-8?B?Y0Y2VkFjMFFqL01ac0FRQmQ0U3lVS0xYb1Uwa3BIVXkxek1VcmNUTHYzbkpK?=
 =?utf-8?B?SFlETnI1VjhvNCswYithWGlaeXpTYTZ4WnhEQnRRSEhCWWx3TjlYa3U2YnZt?=
 =?utf-8?B?b0JQcm4rUXlqOFFLbDBMaDlYbTg5ay9ZUTR2MnJIMG5INjRXVm5ab2YwcjMy?=
 =?utf-8?B?bmhGcjExblRpK2o0OFpkRkd0bmgwd3FoSWRjU0lON2loOXMxNmFpQm93SklL?=
 =?utf-8?B?bDZrN3F5cWgwcU14UThxUFZrdFVwYW1GdGVZSEFPMTNISHplU2haYjljNVBp?=
 =?utf-8?B?MnoxVjJKaG1rSG5JU3RWL3RmMnlYMXExaWJENWFaNmYxK2s4VGtlRUFwQ1dw?=
 =?utf-8?B?V3N0cGwyaTJnVW4wRTQxdjB0aE9EbVdXRnlsaVBaS20yZm54N2x0QXBYdGE5?=
 =?utf-8?B?TXpPQ1VzMHg0a1lONDlMbnVFUTN5RUxXelQxc0NHOUdYdlcvQUVvYUxHVEVH?=
 =?utf-8?B?cTA4ZmEwTm1MdWxUWDF3blR0NnFVOWxJN2k4YUw4TFcrQ2prM1pOaFZ6eU9F?=
 =?utf-8?B?eU1mQXo5dWZyR1FmK0VhZXFsNGJvazZaNG4ycGljcXk4QUgvMEl2Q29yOWha?=
 =?utf-8?B?ODRVMnpVdWs1RWtRWS9ZUzZwNk0yMlkzN0t0ZE9mQ3orVFZVTlIvbWRzTzBR?=
 =?utf-8?B?UUZpajZHTEpIU3JBTEdaK2doNzFaV3drNnZ5N2NvWkcxTFFqelZ0TWZnRk0x?=
 =?utf-8?B?WFlwQW16NnhkTCt6dnlncDBlam1vNnkyQUVWT1BvM2xyMWMvb0Fzb3hxbVpL?=
 =?utf-8?B?bDVHSHREWWRRdCs0SllyUjNHUXFIN2ZGVFNabjVobTMzQ2hOTENhTnQydUJ0?=
 =?utf-8?B?d3d4KzdENGExclhhbEhRVnExM0VmblE4U0hjRW5GUHlIcEtsemVMY0R4QmdW?=
 =?utf-8?B?UzUxbDRUbEpDTEJLaHdMZjhmTVBwZTY4N00yQ3YzTW5mQUdTaFI2Sm5XY2ps?=
 =?utf-8?B?YWUzUXNHbSs2b0RpRVdLcHRWdUtoWEUrdHpEbVJvN3NRdjlZTS9RZldNdW1r?=
 =?utf-8?B?czM3QzhzOEt3UWNFSVQ1OTB1MzZoWjEyWlBwUkVZd2xjV2dwRHhMMzluRmpm?=
 =?utf-8?B?SVNvWmIxUmFBSlh1dDgvMFd3bFJWWjBwVjNPcmg5VVlFNVUrWGpWejNjU3FZ?=
 =?utf-8?B?TTdFRTVQdzdYaXppWVdjaWZhQlBMWVhJcytsMTltOCtjaDVuNTdIa1UwYzgx?=
 =?utf-8?B?SXcwZDhQWm5CVytPb2Y4R3UrNG42VHNsUzVTVmtPRTRNRUNESTVnb283WkFH?=
 =?utf-8?B?RzZMM0hvcDV3cXUzVVRSV1VwR0ZwTjhMdTFrV1MvZEJpcEVqZm5mTnBTQzdq?=
 =?utf-8?B?STdEWWp4ZVRFZ3BMNkhvYzZVNEJqazdwWWQvcnB2T1ZjYjZxNTVkMVRVN3Ry?=
 =?utf-8?B?amZZRG1UbXBFcSsxblJ0bmpUMWUxTnVLbGhPWjBnb0s3VmIvRjJmNFlSRlo3?=
 =?utf-8?B?NWYxdzlmdUNOamlhNXNtRS9jeXE5aFR3S0xNYVBHZkNBSHFIUWRIMlBWZ3Z2?=
 =?utf-8?B?TVUrK2p5TVQ1cm9UalRhOVBnVHlsbXA0aG1uZzloMnJmK1oxNFFNOEZqL3Fj?=
 =?utf-8?B?YjdvRGtoT3RzWDhjUzhXVFNnN2plaHBKVG5Db213ZkxEaWRPVXFVMi9hQTk3?=
 =?utf-8?B?eTFScXU3QWFQTmxwbytaaks2WHBxMk80KzY3TjhjUU9GVkI0eHJIbEVLYURF?=
 =?utf-8?B?anVlVW94TGJDUEhueWN1cENPaVp3N2h2ZWMwd3c1N0ZqbnlKbXdsZjhlU3Js?=
 =?utf-8?B?aEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 13642f1d-76a2-48f8-267a-08db31b2b1bc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 06:39:36.5459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3XtV34P+PKjZtM09ovzW1eF6aviWYtkPzkf711/DntjV+08dF84/akvgvSa0BWeh/Q7+OizyOYz6AcRYb/UYUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5456
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/31/2023 4:05 AM, Sean Christopherson wrote:
> On Thu, Mar 30, 2023, John Allen wrote:
>> On Thu, Mar 30, 2023 at 01:37:38PM +0800, Yang, Weijiang wrote:
>>> On 3/29/2023 8:16 AM, Yang, Weijiang wrote:
>>>>> Now that the baremetal series has been accepted, how do we want to
>>>>> proceed? I think I'd like to send a refreshed version based on the
>>>>> version that was accpeted, but I'd want to wait to base it on a new
>>>>> version of Weijiang's kvm/vmx series (if one is planned).
>>> Patch 1/7 did what I wanted to implement to support AMD SHSTK, my next
>>> version will continue refactoring them in vmx scope, thenï¿½ your series may
>>> pick up the helper and modify accordingly.
>>>
>>> Please note, in my series, I removed check for MSR_IA32_PL{0,1,2}_SSP since
>>> they're not supported right now, but your series supports for the MSRs, so
>>> you have to change the helper a bit to adapt to your patches.
>> The reason we decided to include the PL{0,1,2}_SSP MSRs is that even
>> though linux doesn't support supervisor shadow stack, a non-linux guest
>> OS might support it and could make use of the MSRs. It could be
>> something the vmx patches might want to account for as well
> And emulating/virtualizing those MSRs is mandatory unless KVM can hide those MSRs
> without violating the architecture (been a while since I looked at CET).  If the
> architecture does allow enumerating support for userspace but not supervisor, then
> ideally the two would be enabled separately in KVM, e.g. so that that if one is
> completely busted, we might be able to precisely revert only the broken code.

OK, I'll add a separate patch to expose these supervisor MSRs but they 
are not accessible on Intel

platform right now, i.e., resulting into #GP.

Meanwhile CPUID(7,1).EDX.bit 18 is always cleared to tell guest 
supervisor SHSTK is not supported.

Allen can modify per AMD needs.

