Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7711B76F861
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 05:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbjHDD2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 23:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbjHDD1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 23:27:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6024237;
        Thu,  3 Aug 2023 20:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691119622; x=1722655622;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TztJPWzryJ9TZNW9Xhw2hqKN7vpBUvexcm+H5Gppuec=;
  b=dfIpgeVA4Uvq0xSN0/JIEZKL40EgR/Dr97W9b/l85pIt/D1rhpztnSM0
   fmcibEhVdvfHPH4nZoipEQ2S1XmLE1waXP8cRcu97MoG4Qt77l5RglemE
   TalelZuSikTezpTEUHoUApigcXdSbnONGO1A8ajI84KsQ7HB23UTGUZnS
   c/h/iZ6G+MElAzptLizFVhhsYuNx2W98cChDX0/+2ntALUXzWESQwrKcQ
   nAonuccPS+vpshGK1Beu0TI958Bsg8971gqAX8E21oEEnf4nWFD3vxmCl
   uGUEnSmpSvigGwoenC+nnZOYTwPYcDgNdPpXpmhb7CJARfPFmrb/5aOJO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="360108930"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="360108930"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 20:26:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="1060553563"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="1060553563"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 03 Aug 2023 20:26:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 20:26:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 20:26:57 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 20:26:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqYhQ56Jag8P69EYxTWJ7HhyXiVwEMHator7KfJLcaeBWtX3b8JUyPI/rhwL7eT5hSTmFFDlmofaQirBSLNi9mAqEUJG761oJm9OBDQU7PW6rRfgbEFfwrewB++RnAU5tSo3YJr7/3LRn0Uz3nzhlhWopt3bkfTqGO4Sq/T1UN2g09jpR1wG3UcYdBJuk/CSHWPuJaL2rsg4HXnFsrSTqpOSHhauUyBKeQsqOPnlBHK2hnhJ3DFapROOyiXsTOTNtyyuNu/1i6PoLpniuhMERvw8uNdc0ad2t3lBH9hlMDcugfByX6e0nBd1g8YN3wwVSkduAJ4ALks6sgAeb0LqPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eDVjr9mdDhuRAOwn/8JWvZTbxQkeEJLL8RBQDH6pBwU=;
 b=kVjhNgn+h7P9ekgOyLfuBsN6ode0FTnNw4Lpb63VI6mnymdeoYIA1q37F4X5xPSYVHqqrabJ5tafkdDTOxaqSaQxuc+QIPKT5ytaIi5jqjbYi/YL9KUdBZ5Rm8UkUFXkaLQz81KuQkRB+WsFdI8v7VxbIPfJZ09PwahMUwCNHjX7NpCkX4hNKc3t8vsUA6W+R3blSH4kXWm7NrfBOQ9dMJVRIlbDwQ+D+LBK1B8DCDNlCzSw7pQ0ujaLIAJ/pr/HBvBBjJ8po0Hr90YDkFKY3CDT0jWgxSoWgiE+WF8y036a4LL4BjEiGl9oFik50jeC8+i21HmzpdOv9ePk4aLupg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH0PR11MB5706.namprd11.prod.outlook.com (2603:10b6:610:ed::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.20; Fri, 4 Aug
 2023 03:26:53 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.021; Fri, 4 Aug 2023
 03:26:53 +0000
Message-ID: <bfc0b3cb-c17a-0ad6-6378-0c4e38f23024@intel.com>
Date:   Fri, 4 Aug 2023 11:26:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 09/19] KVM:x86: Make guest supervisor states as
 non-XSAVE managed
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-10-weijiang.yang@intel.com>
 <ZMuMN/8Qa1sjJR/n@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMuMN/8Qa1sjJR/n@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0086.apcprd02.prod.outlook.com
 (2603:1096:4:90::26) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH0PR11MB5706:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a367427-1598-409a-5f44-08db949aa609
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KI5YIMTvmbFyzNODJZOvW8cxadN5WQmHmrkYmoC9Iotnt+1XrfGO4qiort61c3acuiy0iNaYOgsiTQlAAPAYSm+JXMzaoNdnCwwqMV1UWIkzyUM8ECn/oTkRJA5RYUbPsi5pB9pyGkWfgM6JlaAbEWST4MKdSHtnAg22jhMuLboU9b8vGZxN3ALFv43u9MhwKCYUy4jqTTLvJeFssEdshjhlidlO+bNuAmIhfKlBrtmMjOG4OcuKMd4vLI3QePfjrERk+0paXTWbMlp3G4ujzuTm04Pez7Ac+ED+D9qERbl7RYvkl4T6gxExWZdf5X+mH9Em3qD+AF/AWjy5sdR8YktlaYOW2as/68CZEvuNgjJbLSR/zUSa+ne9TqgtFA2fmpJckMRReRoeA4zzXnhRAOomgSGJzBL6B5MvcPiZmLLxaR/WYuEfjCdBdqzoP8P32vrzKmgXlQHM9yPZeBRehk4PaFHGw/HfQohhXyPOB2YtxvO8841N1dkI6m5XQWuqh82DJvN3FiQek+hyZ7wyLeX3/g+3cf43Ebu/ehk8EpL63j5cTY0PEZo9VRhuXHviZ6gZ+SQVhfRgaoPnefMD/gTt1NR0mjd2QC1IfVYJARay4vERLe2m4Gr5HMs8ka10
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(366004)(376002)(39860400002)(346002)(1800799003)(186006)(451199021)(2906002)(83380400001)(2616005)(86362001)(31696002)(36756003)(82960400001)(38100700002)(41300700001)(6666004)(31686004)(6486002)(37006003)(6512007)(84970400001)(316002)(66476007)(6636002)(4326008)(66946007)(66556008)(26005)(6506007)(53546011)(5660300002)(478600001)(6862004)(8936002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlNWWk9rMXZEVHE3R1J5YnFsdnRLUnRzakR5MWFndU1ZUnJJYXhxaGIza0Uw?=
 =?utf-8?B?dFNnTU9yWjFlb0FJUmR2MjlERjE1d2xkL2ZWM2I3V254WEV6bzlFK3FYOFJY?=
 =?utf-8?B?N2tUbW9yNHc4MmViTDRnQ20ybjUwOVhpZTFiWms5S0RDejBTaGNIM1BySWg0?=
 =?utf-8?B?VTBtUEhOdE5PQmYwY1dyaWZIVVI5VmVMOHdsTHBmazBibzNVWkFjZS9hMTZm?=
 =?utf-8?B?UmZ3Vk9USC9MZEFwSk8zVHRDek14d2srWkRtWnB2M3pnN21aMFlpZi9kaTh1?=
 =?utf-8?B?NEtHU3AvVkJEQWhlWVY5cHpxcy9pTHhUWTVNNHZJZGo3RU9UMmxUVk9zRU52?=
 =?utf-8?B?eCtMbUZmUndDTTErVnJUdGF6eXg1QnNOWWJIa2RURmpJQUtkaHh4Rk1ETStG?=
 =?utf-8?B?cUJkSmFSMjI3czhHdUNHek1Zd1BTOXF6Vkdhc2ZlclVJTGZid0M1elVvMUpq?=
 =?utf-8?B?UzhBSnJtVGhrd0V0cEhXa2w3TktBdU9GdGhYV0JHV1NHdjFnYXd6anNGTjlK?=
 =?utf-8?B?aXdGSHJ1em1UWE9HY21hTjBsZWdjdngvNm1YVU43OHA5eUdFVEd6WXdiSWJv?=
 =?utf-8?B?K2U2aFJiZFdpR2huWm92bWpNaDRTalRFdlFhTUpzVFMyTDVidWhZeWJOa0pH?=
 =?utf-8?B?aURwOUR0YVAxZzloR1U4UEZnT3lkT2lWYkcycWxaQVdoTzNOL0l2ZmgweFI0?=
 =?utf-8?B?dTl2bWV0Y0t5UlQ1THJXTFd5WHZkbTIwb0FyZVRyV3JheTJxTnNTakZCcm9w?=
 =?utf-8?B?NVpCbzRPZXh3VTFXL0ZuMW5RcGt5bi9tZDZpNGtGMjlWOFBHTWRPaGtXYS9Q?=
 =?utf-8?B?RDd5STQzdGt6eDVxTkFVOExMRzNrTVB3TzBmTVJBVmtLZ01FbHlvOUx2cnFY?=
 =?utf-8?B?TkFMak1hUTlyWGxWZHY4eHJQMWFtWHc2bkRWZDFxVnUxRDhxZzE3UmFOWFYx?=
 =?utf-8?B?VmVxdG1Gb1BFQ2w5c2pRNzlCU2RJVmt5eXlyMVpzUGNSNFVLa3kyZ2lra2ov?=
 =?utf-8?B?TXdTQ2VhaVBwc1dlNjkwVGI0MlJ6WHRmSXppc3EzOVovM09SVDh3Z3FCdkZo?=
 =?utf-8?B?UlpFQkNTWFQvbllwZy9Wc2dGTzZKUWVic2xHOTdNY3VSRTZrM3dLZ3hHd1Y0?=
 =?utf-8?B?ZjVqV01nNXhnUFQzSzFWSkJ6dTZ0RlFqdnNmU2tzYXR2L3RZQTgzaUFaZm1m?=
 =?utf-8?B?UmJ0b0FtNkRnMG5xeXNvb3pwT2F5WlJrQVhMaCt1SGZkZkNlM3FycHZKSjI0?=
 =?utf-8?B?WUhqSmdvN3dRRjFoTUxna3JuNHN1a0lrMVBpcnhFSHJQckZHL25jRVBmYXNJ?=
 =?utf-8?B?ZjZTdDVtMFFHTUVBdDVTek5uOHdJTW16STBIaEdkQ1YrcFYxSUNYUlJGQ1Iy?=
 =?utf-8?B?UXFlMkVaK1lmZXdSKzFXKzJuTENrSXhFN0JnYkhsditQaGdHQWRtSnV0bUJw?=
 =?utf-8?B?enUrQldyTVJ1SmNJaUtiaXMvSTZrYnlReGQvWVlWaXpTWXIvN0UzOHBCVGg5?=
 =?utf-8?B?SW9qTzNnMGY1MXJYcXRONUVzdHp4eTVLUk9qdGVTM2xwZmJwT2xCT1lORFhE?=
 =?utf-8?B?WTRjUWRpdTlqUnQwQVY2YWlDbXZ6SjNoWDJ6cjZpUlZFei9vSFBUNzcvayt3?=
 =?utf-8?B?L0lub09uSjlSWDY5WG54TzBPci8vUTBiVGpMOENienh3eEN2ZDVmbzlmaTZT?=
 =?utf-8?B?OHNNWkdjcW1vWWpreFVsNU5pUVY1MlRsMnRLU09QYk1uUm1LNlZLOXBtZVRj?=
 =?utf-8?B?a1dhU2RPMGlOZGVTd25RR0Q1L0tWSVRCSUxidncrU2RxREVHN2pyWm5lRm1M?=
 =?utf-8?B?TXo2SE4xZGRabktLN0xRZXJUMG1oWjluNHBQT3VlVXUybzJhL3BmN0R5UzRQ?=
 =?utf-8?B?ZUxOVE5wRUllS1JyMERHTWMrTzJMR0w3b1NZUzFNampmaFJ4NHZrS1Q2UnF0?=
 =?utf-8?B?WmtlTnRaSDBHZlg2SkF6M1VHb1MvdjJwU01LUEd0OUtjV0lGcUg1M2t4VXFh?=
 =?utf-8?B?U0dxMGUyaTl5NWk2QWZiejlzemx2MkNKWE11QzBvanVyT0VaM05EdEFaSkRB?=
 =?utf-8?B?cXF6LzRKbG9rSmtmRnpNM0tZcUk2NjBxcVF6V3JhWkY1UHNxaUd3dUtaQTM2?=
 =?utf-8?B?YWZPZjBENWtxd2x2ZW9HWGpuU01VVXN2WmxxbVZQRS9OT2lVWVBEUHNsUjlO?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a367427-1598-409a-5f44-08db949aa609
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 03:26:53.7317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ehmjD4DYKbW20IDpb6N7OnTZQJ8q7ukkeVdEZ7+93dJru3eoXDn6S9lRYZeptAlE8cEsw2lTI6Rke8gxTTRwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5706
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/2023 7:15 PM, Chao Gao wrote:
> On Thu, Aug 03, 2023 at 12:27:22AM -0400, Yang Weijiang wrote:
>> +void save_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
>> +{
>> +	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
>> +		rdmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
>> +		rdmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
>> +		rdmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
>> +		/*
>> +		 * Omit reset to host PL{1,2}_SSP because Linux will never use
>> +		 * these MSRs.
>> +		 */
>> +		wrmsrl(MSR_IA32_PL0_SSP, 0);
> This wrmsrl() can be dropped because host doesn't support SSS yet.
Frankly speaking, I want to remove this line of code. But that would mess up the MSR
on host side, i.e., from host perspective, the MSRs could be filled with garbage data,
and looks awful. Anyway, I can remove it.
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(save_cet_supervisor_ssp);
>> +
>> +void reload_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
>> +{
>> +	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
> ditto
Below is to reload guest supervisor SSPs instead of resetting host ones.
>> +		wrmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
>> +		wrmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
>> +		wrmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(reload_cet_supervisor_ssp);
>> +
>> int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>> {
>> 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
>> @@ -12133,6 +12158,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>
>> 	vcpu->arch.cr3 = 0;
>> 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
>> +	memset(vcpu->arch.cet_s_ssp, 0, sizeof(vcpu->arch.cet_s_ssp));
>>
>> 	/*
>> 	 * CR0.CD/NW are set on RESET, preserved on INIT.  Note, some versions
>> @@ -12313,6 +12339,7 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
>> 		pmu->need_cleanup = true;
>> 		kvm_make_request(KVM_REQ_PMU, vcpu);
>> 	}
>> +
> remove the stray newline.
OK.
>> 	static_call(kvm_x86_sched_in)(vcpu, cpu);
>> }
>>
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index 6e6292915f8c..c69fc027f5ec 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -501,6 +501,9 @@ static inline void kvm_machine_check(void)
>>
>> void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
>> void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
>> +void save_cet_supervisor_ssp(struct kvm_vcpu *vcpu);
>> +void reload_cet_supervisor_ssp(struct kvm_vcpu *vcpu);
> nit: please add kvm_ prefix to the function names because they are exposed to
> other modules. "cet" in the names is a little redundant. I slightly prefer
> kvm_save/load_guest_supervisor_ssp()
Sure, actually I wanted to add the prefix, but at a second thought, the functions with
kvm_ are mostly generic functions in KVM, but here are the CET specific functions.
>
> Overall, this patch looks good to me. Hence,
>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
Thanks a lot for the review!
>> +
>> int kvm_spec_ctrl_test_value(u64 value);
>> bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
>> int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
>> -- 
>> 2.27.0
>>

