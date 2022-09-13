Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F1E5B65DC
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 04:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiIMC5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 22:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIMC5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 22:57:42 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11194F658;
        Mon, 12 Sep 2022 19:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663037861; x=1694573861;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wBP2v4zuxOp2NJesL1LEfHEjOEdS6mjK6+UppkxDQKU=;
  b=EZz6a0uP4/myEAZzwEk+6bHVR73tKrTqJVhkDCFeIWMLI807RAoAQ8e4
   EXB5VwZEsDlQyK/NC14PyWJjS6sN383wOOA3k7KAi0NKOqtYgHdJcRjeu
   M0yNeD+RPcb/VV56KEaI91gCdYETFvUqfcuMc4LVKBEuctDE5KZudi0TN
   iPR4iX6f4An2S7OTIwMAamfP3R0i+4g1ehFvBhnrMTnnvjpuyBcg8MqJp
   agIyGwDAp68T4yErlKVw3CZBhCQleHmy4CEd+Rf0buhrK2zXQWYtz91mY
   lDKp/CIwW+0974JLTv2KJGX2ccdlJ3XQQT6KDcNuRT1rH4SlfUycUxUtG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="295608655"
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="295608655"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 19:57:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="593750764"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 12 Sep 2022 19:57:40 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 19:57:39 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 19:57:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 12 Sep 2022 19:57:39 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 12 Sep 2022 19:57:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZRijBENKDUdwH6MQ9kmMz5wtE+1sdY6azkQX8+Uwk0aKPPSBO95b6laD9LpafWbfezRqj1zuIyvkN2BL7P95st+oIETxl4vEVlPj4Yr41453tl35O+bUDbtrXQie6gcvfWGdK7dMLS17NzjSXFK9nHLfH3xYxcsGrP1TxwEb9ng2MEzDv6YED9jk6PdP7GHXVHQghTBeyHv8Lk74TTUmR8NQzD/PGlGAMfR21WkM2xmxgH5S4WzllSZyleEx54lUpj+70lnAyyC7JJTSjaYCZa+pgPnJ5/wZuYghmIMMxeQbxyZynQVoI9uQAPQHCXyD0ZAArAPRBy7mX6uPrV8CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RK+IE4VIaEQZ2RYO3nfysp8YsnQocSPco12qfB8e6Kw=;
 b=VgUrKNqPB/De6P+OlJdypn3ye09UrtCbLwrmxHcl0Dv6oU/FRXb9fbMdmX7x5+UffsYbsEge8rb1GFrwte8+fQB0va35zXAUxRNMPANe6VW/wIuJEYOnueStriPfLKn3wA48VGlBkiqtnbMTdfl/iweYRNn7HGkh40P1mKreVGeFuHgZgWGVPQUoQDzo+VnQ8bSHt1z1bF148r+i4E2cYJjgeC5wIofWF6brMEqF61h2I6oqtmlRrAY94IfVjM/Ya0j2kYKCZ34E8LMjAUSw0/sUIT2//5wK5sy7Op3uUBS09SNu1WMExtyda+2RasRcjWspBjPna1IzAYd6gvd05w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by MN0PR11MB5986.namprd11.prod.outlook.com (2603:10b6:208:371::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 13 Sep
 2022 02:57:33 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ddb:2488:14dd:3751]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ddb:2488:14dd:3751%9]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 02:57:33 +0000
Message-ID: <9fcd1d25-ec4d-eebe-623f-cfeb48b6656f@intel.com>
Date:   Tue, 13 Sep 2022 10:56:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC PATCH 5/9] kvm_main.c: split __kvm_set_memory_region logic
 in kvm_check_mem and kvm_prepare_batch
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
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
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20220909104506.738478-1-eesposit@redhat.com>
 <20220909104506.738478-6-eesposit@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20220909104506.738478-6-eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0174.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::30) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|MN0PR11MB5986:EE_
X-MS-Office365-Filtering-Correlation-Id: 4423e2e8-f06d-4dc4-614b-08da9533b4a0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d7EXYOW3riubqYN4SDEdfWSuyCLL0m//Ql4pa/mFJ7dsON5gY+J8eBDKdzrGAkUxShaoPrmjv3N4tffywc4urET8gdfrG1FTrotOt2mqatTjNyuGw5S1c6G7cgyOA6gEUwLhT9tpG+qRZXG6ieBj50jI999qPxyNUqmZ5qYoVWZqR+d+FnKgLRpowCVb0AAdzXjcIDefnZUQNOQ/F6+nmvhqplvh9myWDX8vKWIGFIrtuusGwnvP4VKNKfIL1NgF0oYS+j4I8st4bkH9EPi4yBK0Df2xjJPDTC0HYWd1kPpOqXbsGnV0W83a/TAJ83ZCRX6jowwnughAsfJV7dzp89iJbjEIdShAjVdqN9wZIUHz7MV1uQwAUf7jDjaHMIpNDkHQ0UY7By+RrSZYAwhznXpnn06XB3WyJO0MCcw8FWHURbJBDXj9DUtU/cg7F8hcyt+2sazbwFaLFFaLqw6Pr/GleoyV5E29eHCsWN6TdVKAEw1rh30Jg1GuK2lRmXanvFB8qR+EWdEBmDga2XpxS29VBqKQnhF2R0+oo6lC/7SMErhDFrLi2Nty8p+FwJJbG29CRVK3wyLgOa5qi1EZ50hqd+RWzfTdzWvNquxYX7cvrTd1Sb1px3x8UfTHSDBex2VikDvlqbnzEM+dGUOHFteGt5BixvGbBx8GVn+rNL7WUe6BlLdYVHVprx9+PbBZKXlpt1f725RkbYpzFIKai4OTFNnxebB4GGxVj2e7aZZ/Sq0QjPd7+yAotzbrzoVWQt5kQN5NeLHPpWyFF0kcVeH/VYOZwoy0+CHBykUP21k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(39860400002)(396003)(346002)(451199015)(66946007)(6666004)(38100700002)(82960400001)(4744005)(6916009)(2906002)(8936002)(4326008)(7416002)(6512007)(83380400001)(41300700001)(186003)(31696002)(53546011)(478600001)(5660300002)(66556008)(8676002)(66476007)(6506007)(26005)(6486002)(2616005)(31686004)(36756003)(54906003)(316002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGVuVnFhUmlRbVUra0VOdFZTS2FwbmhrbUROYlNsbExza2ZhenRjdFgrT1NO?=
 =?utf-8?B?QXkyUVBYeXRUMW1vbkRSSkR4bUJsWWhrMWhuQ1d1S3NKeTRhYzh5R012UExl?=
 =?utf-8?B?Y1hLZy8rWXJGaTdFYU5FMkpJY0wwNmlRYW9LVFg2TCtMU25Kd1RLREl6Mlda?=
 =?utf-8?B?a3gvWGhhSk41NW1uelo4enRZdlVxNmR3TFNrdUJqZkt4aFRmTGRWaTFJZXNJ?=
 =?utf-8?B?S20yMGxiVGJWRWJucWtQLzg1RS9oQk1jVmhONU9GS1pvZGRzdEVIN1Z0Qnhw?=
 =?utf-8?B?MjgvTEloRWphQkdEcUF0ZWczNWU3bXdjQlRMKzJtRXl2N2N2R2FsbEoraThL?=
 =?utf-8?B?WjVCaWxLa0cyYkRhNlZ5ZGxOYWV2MEhnMDVXdEFXTUJIaDI2Qkt1RHdvNEJQ?=
 =?utf-8?B?aS9tWUhpUlQ2aUtUbGRQUUhGVjNLQldVSzFNOWgveWIyWXY3MjdXeVB2Q3pw?=
 =?utf-8?B?Z2JBdkVNYncvTzRTV01Nc1BEaG1CSUo0T0ZCUUxEZjluZXYvM0lhZXl2cFlT?=
 =?utf-8?B?M3IxMkZQNnNBakxNbkNmcWZTYVVlb1VQNkhrOFovalF1MWdtNU1GQnh2ejNB?=
 =?utf-8?B?OWh5SXNjS1YySlI1N2lRcWRpQ0k3M2FvZnhrVVFhQUZ3MmZsNzlTWmJGL2ZY?=
 =?utf-8?B?ZlFTd1JGVk1vQ3N2alF0cVhPVTlJM281NlQ1TmxRTTUwRXB3Y1NVeDV5WHla?=
 =?utf-8?B?ZEFMRGYzMVF6ZlZTL2xWYis4N3lpbW53SSs1WTMxelM5Z3p3NG5MdTlub25m?=
 =?utf-8?B?ckFUNjFkODRHbGhtaCtSN2xwK2NQQ3NKS1NZN0JQVjFLeGVlckZwM2RSbTNL?=
 =?utf-8?B?MThUdHF2RzJ5RTIreFpnOStKZ2N1NXZObU8wNTVLZ25wbFplaGZ6MlZ4UE9X?=
 =?utf-8?B?Vi9GVktTdVRRZG1QWVk5ZkZBUlJrcEdJSW5GS2hBZURGUTJGRjJmMGhqUSsw?=
 =?utf-8?B?RkdFYWFZMTFPRjNKSkRZOHp6OFFjMTVoejJsK2RDZ2Z5S3dETGdSak1mTVpX?=
 =?utf-8?B?WFZqd1haSCsybG4wWURGRmVTUElWVHZVcW5PaW5vemxGUFFCYmVhdEtEckti?=
 =?utf-8?B?ejFsSDd6S2VZTjhhVEd2SGt1OFJXbHpMVGNmaHYzOVg4eHpaZE9ZT0NmMDcz?=
 =?utf-8?B?Z3k3MlZHbC9LZ1FTdmMrQzJMMVY3VHVNR1lnS3h3TDAyUHZKU2tnbjlhc2hP?=
 =?utf-8?B?ZG9wWHFDbGNLQlVRcTJKekV0clRaeVU2cmV3bE9laEQ5T0ZCQ25SUU04eDhn?=
 =?utf-8?B?YUhkZmlqWi9NRVVFVm1YcWQvbk9VT3MxdmM1cThpeHBRc0tUN2xNem5FRE9S?=
 =?utf-8?B?K0ZmZC9UU0FoMEVSczBybE4xNUNHYjM3OWZxdmo5UWpiUjBPTjRXYmRXaFV4?=
 =?utf-8?B?Q3lwei9KT2Yrbm9NcUhDVmZqaUs2VFlyZkM1VjFBNjN2SnpveldjUFBpSll4?=
 =?utf-8?B?cTFzTmZzTXFON3pnT3FQdk13YkRnOE4zOTNJQzNLTEdJM21rdHVSMDVxUmFw?=
 =?utf-8?B?V3V2cjdXS0xKNDdhaVl2WFgzL0QxZDhrYThkZ1ArUkxaNVhnTlhpdlp0Y1I2?=
 =?utf-8?B?aXZkcmJla2F6UDU5QlBYZUJwcXZGbkYwbVRiNDVYUXQyN2pyK0ZHYm1CTjJD?=
 =?utf-8?B?VEZObU1wSExjdE9GSTZ6SCtDQlp1QTI3eVF5M1Z5bWtBQmN6U2RuTUNTbUQ0?=
 =?utf-8?B?WHh1aEhIVkdTZmdzNVZNQktZalJHQVAva0Q5cjdPTTRqRk93S21FcGJ1dVdS?=
 =?utf-8?B?d0lKTWI0NHRjNERuMld5RVdmeHRpWXo3cFVLTFJEdzdPQXk4V3EycHpkRnpy?=
 =?utf-8?B?WVJGTHA5My9JWXZVR0hRamhSUE9HbnI5UWs1citYODhGdkxkQU84VEdkam5P?=
 =?utf-8?B?bzRVUktQTjd2dm1LQTBqcjNYK3pZMi82ZkhLa042dXFRdjZnUUg4S3pqM1hl?=
 =?utf-8?B?VWtjbG5ja3A4cVJETzZmd0R4ekZEWUNDVDlZTmVPSVBIeGd3SkV4dE1qNlN1?=
 =?utf-8?B?TDNKaHd4S1ZmZHlIS1Q1czRhQjVDK0ZCV2tzZ1JpM3JjM0N1bjVmZXZBeVhC?=
 =?utf-8?B?aXhKR3hTRkQ0b0pJWWhoRzZBYkk3NURRbW84THdCNmRKNSt0c0dldVBub050?=
 =?utf-8?B?NEZHMFdzTHBnNldneWt4M0s5YURSSkdkYkNlY2pRdEFuVjZ4cDJyL3hZcGVn?=
 =?utf-8?B?a2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4423e2e8-f06d-4dc4-614b-08da9533b4a0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 02:57:33.3719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t1t8+u3mxn9HmtFS8fhWmkkqqjjOHeC8IXkI/MwDPdyvvKbPrcIeWJ5MepWo27WXLWmz9DksKjMd0ipk3v9HiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5986
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
> Just a function split. No functional change intended,
> except for the fact that kvm_prepare_batch() does not
> immediately call kvm_set_memslot() if batch->change is
> KVM_MR_DELETE, but delegates the caller (__kvm_set_memory_region).
>
>
> +static int kvm_check_memory_region(struct kvm *kvm,
> +				const struct kvm_userspace_memory_region *mem,
> +				struct kvm_internal_memory_region_list *batch)
> +{
> +	int r;
> +
> +	r = check_memory_region_flags(mem);
> +	if (r)
> +		return r;
>   
> -	r = kvm_set_memslot(kvm, batch);
> +	r = kvm_check_mem(mem);
>   	if (r)
> -		kfree(new);
> +		return r;
> +
> +	r = kvm_prepare_batch(kvm, mem, batch);
> +	if (r && batch->new)
> +		kfree(batch->new);
 From the patch, r !=0 and batch->new !=NULL are exclusive, so free() 
here is not reachable.
> +
>   	return r;
>   }
[...]
>   
