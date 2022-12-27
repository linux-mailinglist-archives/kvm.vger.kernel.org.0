Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDFF6566AD
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 03:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbiL0CS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 21:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbiL0CSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 21:18:25 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41ACF10EA;
        Mon, 26 Dec 2022 18:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672107504; x=1703643504;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bFoM5XFeFYdbdff3S7JkPaL42FCmlinCXTagcjSQUTc=;
  b=GTGW10KmZ+yem3prWy9KaGE9wfz5VdGhl4xaXpclkqmzsvA0oBL7kvRB
   h33EBmoeMhqZMBMe044+3golLS87ByfIGugFaWtemNsH9wHcRlEM4lCYq
   aPXTJ829nWVFdq0qPAM9wW6ZnE2bX3vjkLYcaIHwLZak92Wt9fJHbE7ye
   wFN2UQlzNahrhcpRcBKEaSpvTs9Ok53jq7gmMSTNA+GrCQKBkj1VL+L7H
   zD7V9MMp1FW+quRAvwEz+QnHUBSsSwqUF5GhwG94Bhro0+VNd0UUTaOC0
   gAz8arO8xQeX5ZRdMBYK+We29ORmgDKLF+ruST4NmS0M8xtlHosXx6dst
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="318303463"
X-IronPort-AV: E=Sophos;i="5.96,277,1665471600"; 
   d="scan'208";a="318303463"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2022 18:18:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="654880795"
X-IronPort-AV: E=Sophos;i="5.96,277,1665471600"; 
   d="scan'208";a="654880795"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 26 Dec 2022 18:18:23 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 26 Dec 2022 18:18:23 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 26 Dec 2022 18:18:23 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 26 Dec 2022 18:18:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dY336a7xjJc5rA90XG6hyuEn5vJNkB08z5JDmQf+GfPEF7xqYC9HM8bxsHXraaxvV3sSWVrALgDWZG1SGFfwgSTb/kuFZPSFZj69XgHD2B7CksGYd6+XOl+WeF5gQi6VKvtNgwQJdm2f5PrBkelJPRQMX3wfMmhpaah5Ui5RswS7AcrBEKbu1axodk/uxvK+7GhBGCRVLVf++befx8e8Zpb4Rd0VSlCK+/eBW2OK2+68mDZvEt35ZX1sr4W6lrOz+3KtMDVwq2ieRo7vqgeiRsnHf2Z1eik5mqCsakNrqdJgICt7RwW/Fsqk0CxVZ6rDowU7pvBIzWGJEQpn+MpILw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K+f+as0TYqvsHRglCup2ZWG1PW8kuRZTy4snI/hF1xY=;
 b=nX3ppcn75bQSDxyz7yLsNtufHopsIV7DoJUnNLaopJQYFOxIbxhRnHEjEpeR4reNdygXXZmVaJv7Zhq/oczmxiURR7t6tpqnqBjj1abdKnaz2Nr7OxfnBKtv0hokckksYxywUKHFRiGctAWkyj+Lf30QqdQ3NJnzRyzwNWw1ppp9XxB5tDOr9gmWI5kEOC+MvrOkk3Cd5kmjb2/KtHLrLZFSmVTyFqpIAO+TsZqBij6wE6VOk2A99JGpSA7SO7qrPrCsLq7AYtPGxwBT+tfwto7Oun46jd74NPZcl1yZYgcZqpIIrR7rfxhgC4677a4FZZYuVu1yP7ogjJKFW7T07g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB6465.namprd11.prod.outlook.com (2603:10b6:208:3a7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 27 Dec
 2022 02:18:21 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe%3]) with mapi id 15.20.5944.016; Tue, 27 Dec 2022
 02:18:21 +0000
Message-ID: <9375f330-cede-1fc6-55a5-6330a59a6a2a@intel.com>
Date:   Tue, 27 Dec 2022 10:18:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 1/3] KVM: x86: Omit PMU MSRs from KVM_GET_MSR_INDEX_LIST
 if !enable_pmu
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
To:     Like Xu <like.xu.linux@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
References: <20221226111710.51831-1-likexu@tencent.com>
 <20221226111710.51831-2-likexu@tencent.com>
 <752cacbf-5268-6ea0-8c5d-36fb297789ee@intel.com>
Content-Language: en-US
In-Reply-To: <752cacbf-5268-6ea0-8c5d-36fb297789ee@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::16) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB6465:EE_
X-MS-Office365-Filtering-Correlation-Id: c6295324-94d9-4fd6-cbb1-08dae7b0a001
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZlUjiitSUeBTm2UL0MtZICQVqWJABjbp2vTVYNdcn8+VHZvTuVQFb5aWA9e2vtDdM4RRSYECZKEZa2h6JnZc+zyUHxsYtSMPLDxLwOfePlEtZ73uTeUSGMt4t/nUeoqQZtCulr/M7QcHLUKEcWv09rOcZRMheD/7Dymq/bYdZCr12RMDCO8PWFYgM0Oe22tZ1y0lIPY1g4k0WLEYbT7xZ9+GcGTiy4ltgjcLS6TNfp4XGbywN6uT27bFTkh7EuGouBVCRVtwegIYrnQbptADNYK0F9pvXTojw1917fJjrwXw+vcKtlj2v2/AeykK0nKzfQ7vI7MRJlcG0//oUVp/tMGcMzx6K8zxE52iZgxbCiFVGQyUeP3kgRQiuYffy8dHJZcrOeyW8t4/vceKC5ACHMLRAs9xGilpxZIoqDAseVZpf+Wy0VT4tpJXU6ODoIvh4J3GmNUoZHM9n6E+cBfUbK7hTQ2+lYcZOJ+WWUhxebouE7bJc3iw1isuiv24oq8TLoOwLvNNU2Q1ZXAyUKmUvy2cikkFHOYF6C+gb1FVBLZFebGxx6As6rdwKybHLLub0LH6w0Uv0rSOkI/a48LHB7hAtwJggJJVwKDMyMKmfbjj9obum2LPgwclAXn3CLlgT7DOAN72yYCVSDinYtWalfzXFBq4MDheYOHStin94PWqgHb78oM95OIZluKlTLqVvwha7ySbGHC/8MUujLsrlr17nQQYIsGlyinTFAprAaQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(396003)(136003)(376002)(366004)(451199015)(186003)(8676002)(66476007)(6916009)(6512007)(4326008)(5660300002)(2906002)(53546011)(8936002)(6506007)(66556008)(36756003)(38100700002)(6666004)(41300700001)(54906003)(66946007)(83380400001)(31696002)(316002)(86362001)(2616005)(26005)(82960400001)(478600001)(6486002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aE03a1lHRnVDUlRjZU9sVlFHN2NVd0N2WGhZa3JUeDJQbSs5dXZYTEtKMjND?=
 =?utf-8?B?L0FPcUdpdXo0UnJqQkQxQWNGOEV1OGJlb2llb2lhVFZOK1lxVjNVeUpVV3Zt?=
 =?utf-8?B?L3MwWDIvWmZiYjkzTDI0QVBSZVVRREt4b1AweEdEY1ZTZWE3WjVHZEZGY3VN?=
 =?utf-8?B?R2JXeEVEbTlORjdDRmFlWmtaNWZIb1lCL1FYN2hKYWxiVUIrK29PeUJKS1lL?=
 =?utf-8?B?WENxQTdkamxYbTgyY0xsak1TUEZSeHJTL21TNHJOZ0VqNUZEOWNUeFR5SzFi?=
 =?utf-8?B?dVc0MUt2ZVZGbEUwTWhqUXRzaEtmZUdCTXZobDZBaERvcGh3Vkw3aStrSU9F?=
 =?utf-8?B?U2xUbFFQVjMvN2w2amVtLytQUkcxUmsyMU5KcEpyajEwSFNFZ2RvMEQ4bWZT?=
 =?utf-8?B?K0JaSzFQVGkreUtFOXNOUGlGNlB0WGs3QUV1Tkt5WGdNUnR1bHhGa25yUHRs?=
 =?utf-8?B?Yk56L0lwSzMzTTJyNTZDQ1QxeUdVc1J2OVpKRGdLQ0htNEc3cVBuSUdmU1Ri?=
 =?utf-8?B?Y1pnV1g3M1dvbnFlS2VXWTJMMThJZlBsOWp4Tjk0Q0JDTjdrZTlpZ0xsV1d5?=
 =?utf-8?B?bEczUDYvczkxbDF5QkkrbWg5QnMzbXhrbjQrUkFHQ096WmdCOXhIblRoSlNH?=
 =?utf-8?B?VG81dEVjLzYySVgyK2JJeWd3aUdRQWlGSFllc2tJUmM3ajl0RGlFVW52bFJH?=
 =?utf-8?B?VmtDbXhQdHJKOG9mT0lsdzhQallmS3FkTjBKQ2dHK3d4NjR1c1REbERTOVlB?=
 =?utf-8?B?TFNlVWRvQlNjL216VGV2aGRJWk5YL3ZSbDZPbzV3SzJJZ1h4ektTQUw3bXVL?=
 =?utf-8?B?MGMzSE5oZHBSN05SQnZKWjZiRGVmWWlRcHI1UzMzeEplR1hubEhwT3I2L1dD?=
 =?utf-8?B?V3Bpby9RTkFVMW51RmIvWHM4MkZleFN3dmk1MzM5eTRFd0s3UnJrKzVXUG9S?=
 =?utf-8?B?Wk1hS09Va2tqOEpQYjZWZ3ZyQ1BoTG5wYjBqRkRZaG5ZM3NneUFLMExoNzJE?=
 =?utf-8?B?bFp4Y3VOWUpFRm54aUFkZTJ6T2xRUVlnbm9oSFREbTJralM3R2srbkJDVzdX?=
 =?utf-8?B?dFBTcWFwWkpVNTNVRitQVkhOUStmZkNoMFZYY3FOeTd5cXY4TmlHVlJqSmtP?=
 =?utf-8?B?djZOVmdzNEFMWU1sVGJKZUlobVJMR2F0UWJjVnU1YkVZUnlmS3VCUTVlVWtS?=
 =?utf-8?B?bDRGV002SnQ4SVZTRytFSzcvRm04My9MVlM1aUd6RGZoemhUZEduN3dLMGpi?=
 =?utf-8?B?b2JHTDY2eHM3WkxVSDN3aDdrRlJFRE9rY09lVE5aVTREVzIrZ0xndW9naEd1?=
 =?utf-8?B?am5NbElQVGdObnVrenVUeXJvMktSUzBzL1QwQ0VRK0t4TTJjeVRFRTh4akZl?=
 =?utf-8?B?YzVPQ0EzZTVtbGxwT3VYTldEOStXVUZ5eUU1YU81VWhwNWRyS1hndEc2M1Nh?=
 =?utf-8?B?TzZRdkZNaWdBWi9xUitxMmp2Q3NIeTBwaExDVWZzVFl5TmdKZ0M4ekIrUytq?=
 =?utf-8?B?TGZBT2NTbXJ0azVKMVFRTkl4VEF1T1JPNCsyaDh5MENpV3RqMFdIcm9ucXRp?=
 =?utf-8?B?Q0NpUVRNTVhDcHp0SXFxMWk1ajNoeWVGRTRtejRTUjlZR3pzYXZzemk3RGtx?=
 =?utf-8?B?bkhjbmVWcVlhemp3b3lEYlgzeG1SYitrOW5nM0ZXQ3FqdXFXUUw2dExPOWtG?=
 =?utf-8?B?VkxQWlNyTENqbGNhRUtGVk4zRGtocXF0c3dPaDMwMzE1RmNBT3JKNVM3ZDFy?=
 =?utf-8?B?eE9XQzV2TDN1cGF2ejJCQVY2c1BCR0w1ZVNyL0ExNXV5ZXNyeUJnMTVZRmNk?=
 =?utf-8?B?cVBaZlU4TzUvL3NxWXlNNjJzY094UmZaRmhMTkFwL24yeVJxcmgyeFVDbHR4?=
 =?utf-8?B?UXY0eWNUU2pQLzdHQkd2VjJlcEVDcTh2aWFQUWpnT2gvZ2ZTcWllT0Fhbm9i?=
 =?utf-8?B?dG9JeHl3dDN3bzJCQUJ5VUtkUTgrS0lQa3NWTEVHbUtnSlZqVWhEUU1XbzVM?=
 =?utf-8?B?S3grYk80eEExSWUrb2NIQXZXTGVzakRmRXIzait0VFNOMStXR0xDMkZ2UnEw?=
 =?utf-8?B?NyszRjlyRjBYY3Yrc21Ua0R2SXVKL3BiMFlaZ3RBQkVzbjVIY3hKNEZGQzBW?=
 =?utf-8?B?R2JsU1dEQ0thSWVaNUxwMEhWRjV5dXlXc1hyZnV1VHB5WHV0ZnJDVll3c2hK?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6295324-94d9-4fd6-cbb1-08dae7b0a001
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2022 02:18:21.3578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pt72h5MeF928CT/7ZOwSMKakvJ36CF6yAABMVXYwSLu30iWXkbV5EBPXJiNo5SHYv0neypYqt09fKydMA8w3+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6465
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/27/2022 8:59 AM, Yang, Weijiang wrote:
> On 12/26/2022 7:17 PM, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> When the PMU is disabled, don't bother sharing the PMU MSRs with
>> userspace through KVM_GET_MSR_INDEX_LIST.  Instead, filter them out
>> so userspace doesn't have to keep track of them.
>>
>> Note that 'enable_pmu' is read-only, so userspace has no control over
>> whether the PMU MSRs are included in the list or not.


[...]


>> +		case MSR_ARCH_PERFMON_FIXED_CTR0 ... MSR_ARCH_PERFMON_FIXED_CTR_MAX:
>> +			if (!enable_pmu || msrs_to_save_all[i] - MSR_ARCH_PERFMON_FIXED_CTR0 >=
>> +			    min(KVM_PMC_MAX_FIXED, kvm_pmu_cap.num_counters_fixed))
>> +				continue;
>> +			break;
>> +		case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
>> +		case MSR_K7_EVNTSEL0 ... MSR_K7_PERFCTR3:
>> +		case MSR_CORE_PERF_FIXED_CTR_CTRL:
>> +		case MSR_CORE_PERF_GLOBAL_STATUS:
>> +		case MSR_CORE_PERF_GLOBAL_CTRL:
>> +		case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>> +		case MSR_IA32_DS_AREA:
>> +		case MSR_IA32_PEBS_ENABLE:
>> +		case MSR_PEBS_DATA_CFG:
>> +			if (!enable_pmu)
>> +				continue;
>> +			break;
>
> I prefer use a helper to wrap the hunk of PMU msr checks and move the
> helper to
>
> the "default" branch of switch, it makes the code looks nicer:
>
> default:
>
> if(!enable_pmu && !kvm_pmu_valid_msrlist(msr))


Typo, should be:

if (!enable_pmu || !kvm_pmu_valid_msrlist(msr))


>
>           continue;
>
>
>>    		case MSR_IA32_XFD:
>>    		case MSR_IA32_XFD_ERR:
>>    			if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
>> @@ -13468,3 +13485,4 @@ static void __exit kvm_x86_exit(void)
>>    	 */
>>    }
>>    module_exit(kvm_x86_exit);
>> +
>
> Extra newline.
>
>
>
