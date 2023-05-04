Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86FB36F62AB
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 03:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjEDBbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 21:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjEDBbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 21:31:10 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F34610E6;
        Wed,  3 May 2023 18:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683163869; x=1714699869;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FU10a/SrTXQY60ZgqS1jwwcDqTmOklW3tBFYQX40M1w=;
  b=dKocfh8Kj4gAwuMv5MUhODoMzL7VQ1YZAXkbVAaVTSqN2cEpWEiyQMUt
   or9vgip1jtjoCBPXirTCW/FVG48SlUn4AtghCxYGPFyjRaPUJpzpGDneC
   MVX9NZGUDk3yaX+GPDHaXZ6yNKAJvO9q9e9F3rpxGeyqqBYH9AEvcrGwd
   MkZuLGchIujojM5ZAYP7xU75nlk4Ai2nGfroL+n/QPTeU8afqkp+w18On
   xg13ToFA52hubtnIEjDvPcR5DZdeUswmqgem8hgAJ374nhA7bEYXbgOc6
   J+ocC/d5RR45ym3UqRQ9K0yKn4x4L491jueVOxUR78c/w97yi0zdL+Xou
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="411974124"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="411974124"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 18:31:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="727368004"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="727368004"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 03 May 2023 18:31:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 18:31:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 18:31:08 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 18:31:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3RGp+chhHj2to63PNKZNSPLu6h5G9ToM4oQtCCqI8IYK1jBtGkpJ2zXQYHLVZSwA/RboTqJl4vkAfLXFXWfyEE6fSfeN4QatUjLA+LPVANlxj2MBICO0KmoqeaFFvSnSZcAd8Xsi/lqZeWerHt7m3oH2/+esIpkioJSC+SZxGIG9AmAft/fyp1l5vOy9lXgZOlYz/A5t+mTjaKUm3HZPF9PnHc8BnbKzN/PC49Oa1INF4YkKWTpWc3X+0XVmlzAY6gZnNw/D/+snrbr1o2FuLwStLMlQtGUhSMWHeWjwuxOLP8+jOMZZ5e4WAVckQb5Jl7/eQ+MK6Fq/0sCzw38nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IOVzokV4h+7wc+AirUuZXKsQ0EUsFkhDEdE3F51UM2A=;
 b=RxsTERyqdOjR7igWM5MBglK7w/txl9CcDORJOlrbgj2lhu+VqUq8jiQ3yegQf/ie8FKSkcFKAWMTBbaIGnv1DnzYJ/I23xmxnPzz8dcXsVZ0Rq2NP/YVzLctUHXfP9JoWhfUfsjzymE9+y5MBwFc95PAVngzcI+Z5hM+ET759AwlM7MYmAsoHEWq+E15hGIAnxnRgJUgVW54+Jc3IY/V98rsSSFD6NXs09vuazFag+yJnAqF1EAT0YU3nOUb8XXdoa3lrkLkEgQdWdnvycThUL8h/19mD6Hbw7PbLxeam2Igy19IFZnI+f7On88m4sUA6COt76APDTUJ0qZPEiQiYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH3PR11MB7937.namprd11.prod.outlook.com (2603:10b6:610:12c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 01:31:00 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::1ff:c7e7:87de:6d97]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::1ff:c7e7:87de:6d97%5]) with mapi id 15.20.6363.026; Thu, 4 May 2023
 01:31:00 +0000
Message-ID: <76a9a58a-06e6-2151-a3a6-a8b61a68ab15@intel.com>
Date:   Thu, 4 May 2023 09:30:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 14/21] KVM:VMX: Add a synthetic MSR to allow userspace
 VMM to access GUEST_SSP
Content-Language: en-US
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "john.allen@amd.com" <john.allen@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <20230421134615.62539-15-weijiang.yang@intel.com>
 <50366bbd8ff5adf164644dd406ea7337c174ec22.camel@intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <50366bbd8ff5adf164644dd406ea7337c174ec22.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0156.apcprd04.prod.outlook.com (2603:1096:4::18)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH3PR11MB7937:EE_
X-MS-Office365-Filtering-Correlation-Id: 945498b8-e08b-4630-6989-08db4c3f374e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lBzrRcj+eb4F3rRCFGjg96kfnbCw3VmQvC1M60Ctyxww252HgL8F71MTHNb92qQfnJH/grvOCDtz8q4r/g9rX6dMP1LaoR3FoTg2bmI+pVkM2qNib7Xyci3qMfXGv7LT2cyK8HBS30uhjZWdOuMO7Vmc8BjOa3VU7q5PtTSG7eYsf0QsVmP9Q4PYY+TEPsYKPy4vcEoUYmqTV52MGrp0I0LFVk0IMbgROos4C9mZ35C+nqfPe+P1Hf3ABOfYynFzFKa7dXp+QscmxCjB282UIp2Wf05T6Xc62lthwqJeMfkgCojCUJFQV3ISb+zDbv5+P7vo/a2KS4uTsB+ZCJNh4+ZWONViXE6D6ATQ8qcsX0/97jZCY9Ic6fdMOOQ5W5JzXuEcJF9PxFWWA6tnrHBCuoXpMNlPIT3ki8Uht0jel0zjtor34aEH+qQAygkQUgOJLm12bKm/018SRIuLT9oj+U4O6w8TIzxE4WRHIMxwKt2lF2MPZ1OUkAIQ0NaHGxV3V0wtuOGCT8EvzLnIlxdANiM4F4Mkq2QLDUVqL+4J72ew2LfWAHn1CEtGqQFMOwa6m6TK/EqNpEQ0t9n/NbftsJspVrp8YUbOlFwHRskkW4MM54jUKtvtC8KxhdXrYnYoDu5/HYqhJR5Tudyu4ZumsWiu5vbckaIvznYGmXwB3hU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199021)(316002)(41300700001)(53546011)(186003)(2906002)(6512007)(6506007)(26005)(31696002)(6666004)(110136005)(36756003)(2616005)(4326008)(107886003)(6486002)(66476007)(86362001)(66556008)(66946007)(31686004)(4744005)(478600001)(8676002)(8936002)(5660300002)(82960400001)(921005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0N2NFc4MFlxdzdzL2cvM1AyUFFxRVZmNmdtdWNZNmdGRlFrR3llUldyL1Ix?=
 =?utf-8?B?M2d1ZGwvQXdDNUROekpsaFNMNE4xUk1kc25EWG9qNWVZRkp2MGovOE5kVmVN?=
 =?utf-8?B?RHI0amNRU09oTU1BWTBNMFlwOWtITnBXMXRvU2lDbDNFc1Qyb3k4NjFTKzdS?=
 =?utf-8?B?dzAycnhQK215S3hKOHFjS1FGVERFbDZqeGtGbytyMTJDMmFVZXBzbVllUDV3?=
 =?utf-8?B?ZG90K1ZrNzFCTDdrWXRCWTgrRDZ3T0xyWHN1UFlIaklQZjdKb2VXcXVsL2xU?=
 =?utf-8?B?M21NVE1uWTlSL0FJdTh5VEwrZG5lQ0NQbG1xSjEydW9TdHNTWWh3UGliUkVs?=
 =?utf-8?B?Z3p2dFZVZlJycDBWUm55WE1LSmhRUE1HdG1JNmVGcDRnalVXMzhqK1VsYStS?=
 =?utf-8?B?M2ZYTElDYlV0aER6Wk1WbHlhYVdueFY4TDlHcklBUVJDZEVxUE1jVE5LNVRp?=
 =?utf-8?B?WTkwZkJhbUxIYkhjZ3FtVU83a28zOU5VZHk4bytqQmpVSVpzZ0VVV3lwOW9t?=
 =?utf-8?B?ZmV1ek8rSWpxQUs3RkdLWmowYjlBSVRuNVZFRDlrZlE4RTVuWGtIS01uV2k2?=
 =?utf-8?B?UGdtTk5JSzlPbkRHY01ra2c5NjBteFRUQUFjdWZIZ1FqTjNuWkJzRjJDQjZq?=
 =?utf-8?B?SmZKMkx0K0pGbmVyc0ZqSEJVZzE4WWVrYWtja2VDWjRTdmFjSjZ6WEp2bFJ0?=
 =?utf-8?B?WEZQUVhwSnNtTGxMemdGU29uaElIWG95MWlEazVZV1VTTm5IVjEreEhHK3ov?=
 =?utf-8?B?WWE3NUpoelRoUVcydmFmWlJEelFYYWdwN2U3SHNmdTlqMklMUStqK291eTV2?=
 =?utf-8?B?a0lIdGhCZGpTMjE4Yks2bEQ3STVnN2lCWGppM2NwbVJiZ3V6KzA1TG9Nc0Vu?=
 =?utf-8?B?NkxKVWk4am5SMXVnL0hPUU9peHhUZWxqTU1YVjB5V0lTbjFOV3U5NEZwRmU3?=
 =?utf-8?B?R21VWTBycmVhZzNkU3NuRFV3TjMxZHdaZzF3VXlQWStDZTZEWDZrYUl5d0dp?=
 =?utf-8?B?bXZZSVdxNFlva0piMkEzQW5wSDc4eXhQVVhKTGJVMzBHRk5VVTZQczA0ZTQw?=
 =?utf-8?B?UURkZG1USHQwN2Znd2NrR1paeXZhQittLzJ0L1ByYmdvNmZuOUpGYmFsUUZw?=
 =?utf-8?B?amU2VFlWS3BiNjUxcko5dGVGV2xYM09WcmRETkxib1lLNFhIc0ZyQkt1bEgx?=
 =?utf-8?B?WDhwT3lHMTlZYU16KzVqUnJZbk5JTXZBSzRjSFlJMmlUNHVJM2JCSlFKTnht?=
 =?utf-8?B?YlpyTjRNbWFoa0JaTWVzS0s2R0E0VTBaaGlpTUEvUjJ1SDlJdmVPUnNVWFU3?=
 =?utf-8?B?UmVmU0ZnMGp5QU8yazZ1cWFrSEJUSEJwTXRzM3NPMnNkTTExL2xaSlMwclZ1?=
 =?utf-8?B?bU9xRHhSZDFxc2cwd0Z4N1lkVDZML05YTU1VMjhacXN1U2FlRzFHOW51VEtp?=
 =?utf-8?B?eHB5TUxyc3JaWmRXMVlaZWg5K3BKN1ZZQmxvT25VNGdsZ0VPenM5MyszV1Zp?=
 =?utf-8?B?WWMvcndWYUhhQS9Pa0ZQdGxFcDc0VS9CK1QzMmEzT2FRVGZFK0o0LzVvcys5?=
 =?utf-8?B?RVNjdkt4cE9TVThMNE1BQnQ1MlhGMWU1WkFlMmtuZDBqVC9FY0xaZVV1M1g4?=
 =?utf-8?B?WU9nQjVwaXRBSi9hZ3MrdWdjYVEra3lrWVBWdmh0TWFIeGFHTGlwTGF2dHQ4?=
 =?utf-8?B?MjRna0RYWWw0ODlQVXhERTFvbFVnZzlhaUZUYkVhVmVIZkt0Qm1lbXErM0dK?=
 =?utf-8?B?aG5hbW9mOGM1eTNOTzZWZHF3bnhRbUdqdmxuRVhMZUI3Nk54Yk1CL0dBUWs0?=
 =?utf-8?B?UmRGZUpDMGRvTGppVEozUWtlNEZrRnpER0tZMzIvc3dRRXQ3VFk2blU5bjdv?=
 =?utf-8?B?NjhLNmQ0TjlVTTFEZy9mSDZ1dkthREdVa3JUTGYxVnR6RitFUGNWRk5NbHRv?=
 =?utf-8?B?YUwvWUI2MGEyWkt3Y21uellnMHV2dDJLbDd0SzRDdmpaRW5keHBmMm1BU09l?=
 =?utf-8?B?QmxhV3pmcDlEYlkva1pod3ljK1FNemZJbEQzd2tadklNQlFFWnhFVGdSQ3Rn?=
 =?utf-8?B?eEhucjRYNlFzRlJNdzYvcGNOeHBJcXMyNFBUaHdJaDRkL0RYeWVXeWVyMjdQ?=
 =?utf-8?B?a1BWQXZWNFFiemZ0enhKb04zdUZmc2FubWFKNDBKaUlaUEZSZWVPeStqYUVh?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 945498b8-e08b-4630-6989-08db4c3f374e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 01:31:00.1325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1AOKwvZf5UJTY3PVT/4xbdvi6pRFnon0jMTbk3gHHBG8dml5dw/uxNVIBhOcJUqj0aJ1OrkF6GrUrld/jXKiLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7937
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/4/2023 1:08 AM, Edgecombe, Rick P wrote:
> On Fri, 2023-04-21 at 09:46 -0400, Yang Weijiang wrote:
>> Introduce a host-only synthetic MSR, MSR_KVM_GUEST_SSP, so that the
>> VMM
>> can read/write the guest's SSP, e.g. to migrate CET state.  Use a
>> synthetic
>> MSR, e.g. as opposed to a VCPU_REG_, as GUEST_SSP is subject to the
>> same
>> consistency checks as the PL*_SSP MSRs, i.e. can share code.
> It seems this is exposed to the guest? I'm thinking maybe it should not
> be. IA32_PL0_SSP comes with some extra checks, so MSR_KVM_GUEST_SSP
> seems a bit powerful. I think the guest doesn't need it either.

Make sense. The MSR is just for live migration purpose, no need to 
expose it to guest,

will change it, thanks!

