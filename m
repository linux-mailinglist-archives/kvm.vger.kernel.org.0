Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D5A5B659D
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 04:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiIMCbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 22:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiIMCbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 22:31:03 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A64752E66;
        Mon, 12 Sep 2022 19:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663036262; x=1694572262;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YYmKC/o1Uv71aP4sX1aBM22WYhuxdVWtaG9YtAxGr8w=;
  b=krMAkAtCbG0hZVXyCqmntCEAfdqFY3Bh5J6tLGmMN1J8mqM/3g4u2TCs
   vvu3SXQJcltw0FUjraSfFGd14gJgo0oRvFV7wfHdlBCUSBR9FuKnJLnYV
   fKeQGJ8ATfSmj4qxipoyCG7UxrxDua5SoAyoXbumMEk+R652Sb9leklPk
   BM7F/xwTePdRMD3vBd9in8vas52NEPRVNXE7gvTQNs4f49YwZLfoH56sz
   gfGNicXD8wl4QUukaep5q1S07GgZ/jbCFlpk4yoeKYYRE+sfn8oOvzbAT
   iD/Tc8S7wZPtmxG7TEuq9fDpDrQ3jii/Z4ppRDet36UcKoDI/NfYnqCzW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="295605672"
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="295605672"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 19:31:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="742000182"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 12 Sep 2022 19:31:01 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 19:31:00 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 19:31:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 12 Sep 2022 19:31:00 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 12 Sep 2022 19:30:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxHp3IonRYZT+b0Hw0mhaqoGi7nf0S+FOlHWlb6yI38wdtXkgygMiLAuR2PU9v9vT1wOHS29Y8EQhQBssT1spOV7SPgT2GZeg2xUgMiUwWV+tHaaK/8D+S2KM0qXK5bSiPVJkkInSjKnzoxc2cWMsUnyCb6n7xPTUTYNNKHwAkuQfEq8vx9IbBJK5qagQelgXRdb9aiZJ9/lo09lB6HdMSPqvAwpPtSqhj7si97cHNq5MhNNjd6osORawgmL5r+5N4+KdO6nSoOti8rxtGkeyjpJ8D9Sc2oZWpJCs25X7OLBddExS78zmYNzxajRiTVn9slOn+fUB0+HRzuoY70Vew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UXR/A1boV8o0R28VnPfcNm55oWEkr6aN8MYAZeYaQPQ=;
 b=ektCNQQjzZ0UzsxA+hZtzl2gNIp5HsC1TgdNTnnc9gJZE48FzW5dzZv8WHrPaHlx1sPJFb/F0Fs+6rAuVI+VwflXwMtFEAwKF6lxFuMvjqkrKaLVvPkrEPHjEIPDMnwW6fPinvSxmIvcXxdQSIUqMgBIRyN1Qy+vL0W0r9Y/tSCyqcVDx1VpZqgMO5JcJJXf7PH69xedpgp6NUp+tcNYP8ShFX8bN9nKsHJubObBysCvImc+pF8ULLaqWYLuDzkH6EGTKm1xNHAoTJ10oJOHz6Iwz7bdWR/TesA7fHMsHG/ILzoabBlwvp0JmZg6HnoVyKbkYJfDAzCXK/sOnMeQuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB6816.namprd11.prod.outlook.com (2603:10b6:a03:485::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Tue, 13 Sep
 2022 02:30:55 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ddb:2488:14dd:3751]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ddb:2488:14dd:3751%9]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 02:30:55 +0000
Message-ID: <7e64d472-fbce-6640-033a-51b8906b7924@intel.com>
Date:   Tue, 13 Sep 2022 10:30:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC PATCH 9/9] kvm_main.c: handle atomic memslot update
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        <kvm@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        "Maxim Levitsky" <mlevitsk@redhat.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
References: <20220909104506.738478-1-eesposit@redhat.com>
 <20220909104506.738478-10-eesposit@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20220909104506.738478-10-eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0174.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::30) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SJ0PR11MB6816:EE_
X-MS-Office365-Filtering-Correlation-Id: 90ab848b-1aa3-43da-ce5d-08da952ffc7b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EgydGfu7FxOJjfs6uOODZZCeQR50pQNfnnjNzsbU6uYgRvzviK2QgbigOTs681OkS+PT2jTRKCeAizdbGbolhfz+fScczggHRgjjh1QRwbxedEWFBj5OD+wBI6NEuyvXkkWtyhDTzYi6SsYfyQHLhaIbwqBZXObcQ3+DDOX7fsp2nAlN4SX4LeDfSFb3kfyr0YbTPb6TMjbOLFpopiRDYHNtHK8IBIEoh930eCDrGxc7gzVSdVnyVODixEFByodlORnB7EtZi/9rlkhjIXBOdgcIksIvWxut0pj1i8bUcu3L9oHm+kgZ3pPbWdRiIjSGNVr/M1S8cr8NjwcRrk+apZBhKXuk4gMnv8APmh79ZLBrYuCu8uuBXLHLJ8VtB/3Ait/IyLsmzY0BGuqxNxwbqvlHoDo6C3oDoOOPN0iMT69Ca+or7Zxx6E/UPZTQ+IJTp2aKPPj3QUcFYeIwJgIRlSaILqZ3vftOI8sX4TFC1imzXT9ntZl3gQiBYvRP0mIH+eq275xR1n4ejKmIrAdzWRTAq8y2fhWuur0zanHorC1CvtDD7kkIGmDRhtJQBe0NfZXPJWef5bFaJxMeeh7ARuwsmJRx8sV5yvcWFyYJ4Ri+THx4Aq7n+1ghbJqQYeTvSgkr7K2yksxsIOmJFay0gV2kFlk6dy4HxL7RpR5bwwAmqAT6ZsT9z7F1GE/VWEConOl0ppbnIOgYilxX+/m8r/3o4d5bqnxSOsZL5Z3sqaLPOT9XHEY3yeq9+otVdl8YIfhhFisMr88AIz5M2HL30h8WlXaeVY45jGyB/kt3pl4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(376002)(396003)(366004)(451199015)(26005)(53546011)(7416002)(31686004)(66556008)(6506007)(86362001)(2616005)(31696002)(82960400001)(41300700001)(66946007)(2906002)(66476007)(6666004)(83380400001)(478600001)(316002)(4326008)(54906003)(8936002)(38100700002)(6486002)(6512007)(8676002)(15650500001)(186003)(36756003)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTJ4b2IyRmc5WUtqRWNldllNOTQwREZQRU80K1pidEczak1sRXVkcW9vNVdj?=
 =?utf-8?B?MWZUSkx3WTI1TU9kMXh1VHQ2OUUxNlBVQ2hnSzFSaDNLWVhTemxsRVVNL1lG?=
 =?utf-8?B?bkdMMXljMzlXRVpWU2xsTk5Ja2c3R2hDTU5VVWFVeWhUK3FxdTk2anlaTGZj?=
 =?utf-8?B?SVVXV0diNXlIYjhtZ1czSFpLT1lCVkFMU28wQXVUVVpFcE4zVGVENHhyVGdr?=
 =?utf-8?B?eC96Z1E3RUFibXZUdGVwNTdrbW5vNDUrZVpGNUZEZVBYN2g4Y2cySDg0cjFW?=
 =?utf-8?B?MWJCOUhVYURzSXZUREk5OU9RQllKazVPZmFpaXlzeVVoNUgyeHhIc1E2YUZk?=
 =?utf-8?B?ZldDTitweUIreTJ1d214NlhCN0tmNEUxVXE5eUY4SWluRi8zWjJUd1hLWG1B?=
 =?utf-8?B?WnduWDRObmRRbnFMdUpnK3NqUExPdzN2MDRTdmxQSW9FRm94N0UvNWpmREZu?=
 =?utf-8?B?OHhOV3I3MmpTRFVFb2RUeEZrcHNWcUw1cFhmbGVRZTlrZ05QV2FvVXduc2xK?=
 =?utf-8?B?a3E1SUdGU3lzNi9IempKN2RPWHd1YzRyWkNnS2NpNzkxWkhLdUZlWEtacVRl?=
 =?utf-8?B?Rno3Qnl3VG9aTmR4ckcxOWlIMUZUWUNxNmlCM0JoejNSSmRKcVNyL0FpSkdk?=
 =?utf-8?B?b2JuZFB5OFlrOG5BKzRGZTBEdGpKWGZuM0FlU0JYTy94VjhYaitlYis0eTZ0?=
 =?utf-8?B?c3NLTHF4ZngzbGo5dEV3eTdEQnlwUkh2VlVwZlVRRDQ3M1p2TmJFd1dLL1JZ?=
 =?utf-8?B?bmFuNloxSnFQSWllazlhdmZVMkNaOUVqQ3RaMW55ZHdKbjdwSUVORWdsaitq?=
 =?utf-8?B?Vk1hbzBlaS8wc3JQSVUvL3V3Q3JyMTFCKy9SL09MRCt1NUxJdGl5L2daa2x6?=
 =?utf-8?B?RDZabFQxb3AwRHVsR0ZocWRMZm5IaUJDZGdWUHQzb2I4bmRxSGdjaHNuQnor?=
 =?utf-8?B?VTg3WHRZZUV3OUJscjVSVDhLcjVndldSMllIQUlvcFZma2NiNkk1aFhZOVBr?=
 =?utf-8?B?b2dvN1F3Ump4T1F6WG9mZXExd3d5SVdyemE2TjV4SFV1QjlqbURlUDJIOVJE?=
 =?utf-8?B?OUFNUmRURXpuc3h0M1MyOTV5YzZtdWpMRFd2cHpSS1J0UUxGMVM3clJIWGdy?=
 =?utf-8?B?SFFUaFU1ZmdMT1pJVUtpVzIrUkZoOEJqTmRZWEo3YWI0UmJMa0g3RGc4a3RM?=
 =?utf-8?B?b1crMENXclB5dXFBT2h1aVA2VXFzck96Mk13UnZQWWVqQ1VNMUdLVlgyallH?=
 =?utf-8?B?WU5HbHRXSXp4blRMZHVFTGFuOU03azNWNDBOV0QwVHhIa3I3OG9DeUJHVTE1?=
 =?utf-8?B?ZStBTjZNV3YrNzdqRnhTQm15SkZJWURicTUzdzF3VHhXdjFQUGFUNzQvNVRi?=
 =?utf-8?B?TTRaSW9oQXFQVGpGaXhUaEVXN3kvVEZ3TzIwYTJ0WE82TGppVkRobU91UjlN?=
 =?utf-8?B?UFJNNWxPaEJRU3FtbmhuRDE1cXF4UkgzYk55T2xHWVN0eUlqNGRSbHkxVGF3?=
 =?utf-8?B?MnZVOHpxZEdNRzdIWm05d1BBVC9DOVJqWmFqRjJlODdUaW1mbWd6bkc0V2lm?=
 =?utf-8?B?V00zNTBpbC9LT2Q0R2VQV0x0Z0FYT3NoL2Q4SGhDaHd4NUNUekczSEFybExm?=
 =?utf-8?B?aDF2anovZzRERHRiTitvUmEvVDRPcjJRdmozUnJSc2NucXJSMlhhZ21lTjg4?=
 =?utf-8?B?dEdhUEZRaCtYZGtoSkdjSDA5WUFLWC9NRmcram9RTjhCZXB0U2Z0S2JKVmtm?=
 =?utf-8?B?ZzE1WXJVVnlwZzEwV3lURDE0RFZDZFR6S2lIU2RXTjhpMHJ2QkxPUlExMVc4?=
 =?utf-8?B?NnBpSXZud3Nxb3Y3dkxqWmJKSVMzQ25SV2owRFJzOU5rMjZKc2pTazJxcU10?=
 =?utf-8?B?M2M5S1p5Tjl1V0dpSFlLZzVLbDYzMFYwSkxGazg2dFZpQW1oRkUyRldhUG9P?=
 =?utf-8?B?QTJ2aFNUZlh0ZWYzT2NHQmZCM3o4Nk8ydnBoWHJLSlI3YXY5Rk1yelR3NmJl?=
 =?utf-8?B?Z3NjTnV3VzJBbnZOU05Tbk04NXBaYkR1YlRqWDRhZURuWmRXUUpYT05NVkpq?=
 =?utf-8?B?emJZaEkwZWRZR05ZMWN4dkpkZDdEcm5tNHdqRzJBMWFXVVFWV0Y1TElhRjdh?=
 =?utf-8?B?L3J1WkFPWlpENE45d3ByVXFENmUzMTJkR2IvS1h2L29YbGVGYW5kNVhMeHhG?=
 =?utf-8?B?dEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90ab848b-1aa3-43da-ce5d-08da952ffc7b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 02:30:55.9100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gYBk7zxBmc3Z2E8xAn+evJF54B+nk3Y5bKN3WxJWZLiBQuptUDA6LApewYqKvNyQxXLRLS2xQu+W/WYavKOkng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6816
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-9.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/9/2022 6:45 PM, Emanuele Giuseppe Esposito wrote:
> When kvm_vm_ioctl_set_memory_region_list() is invoked, we need
> to make sure that all memslots are updated in the inactive list
> and then swap (preferreably only once) the lists, so that all
> changes are visible immediately.
[...]
> +static int kvm_vm_ioctl_set_memory_region_list(struct kvm *kvm,
> +		       struct kvm_userspace_memory_region_list *list,
> +		       struct kvm_userspace_memory_region_entry __user *mem_arg)
> +{
> +	struct kvm_userspace_memory_region_entry *mem, *m_iter;
> +	struct kvm_userspace_memory_region *mem_region;
> +	struct kvm_internal_memory_region_list *batch, *b_iter;
> +	int i, r = 0;
> +	bool *as_to_swap;
> +
> +	/* TODO: limit the number of mem to a max? */
> +
> +	if (!list->nent)
> +		return r;
> +
> +	mem = vmemdup_user(mem_arg, array_size(sizeof(*mem), list->nent));
> +	if (IS_ERR(mem)) {
> +		r = PTR_ERR(mem);
> +		goto out;
> +	}

IMO, it's more natural to dup the user memory at the first place, i.e., 
kvm_vm_ioctl,

it also makes the outlets shorter.


[...]
