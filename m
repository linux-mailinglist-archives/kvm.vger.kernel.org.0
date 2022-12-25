Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4927D655C62
	for <lists+kvm@lfdr.de>; Sun, 25 Dec 2022 05:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbiLYEbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Dec 2022 23:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiLYEbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Dec 2022 23:31:44 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300E01A5;
        Sat, 24 Dec 2022 20:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671942703; x=1703478703;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t5VNgYEc+A7VqA13nLAhSNVvSv2F8hCGoD1yqcrUCm8=;
  b=Zb0G4ODb/08orZhaRF1AqIIG58p5+315Gy5AjF51KH6pI5MGIl1wQsa1
   z+polYRalrUYl9D3GmO5bvvzyXszdBc4xuFpeBG2/l1I8d3t/eA8gkba7
   ZJNTJw5V13+q11uhMJJNfJEm95ANEI+elHUKlC/3E1HaKxdf7yc4oG1lx
   G5hYFCGGN7/ERHnnRPlurSZuswhNcytqlSaLS5oeijNYZqlLIjlQIXWOe
   arZDNugsJ+Iud8ISh8Am6r70th3M2Ji7F0+1s26z+4In/JF0dqZzTVWdq
   Ul4JM5XcNaR2Lk0AiruJBXVnpf/vYEfQxQ+I2JBNU31jsncVBGKs4VCKM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10571"; a="320534475"
X-IronPort-AV: E=Sophos;i="5.96,272,1665471600"; 
   d="scan'208";a="320534475"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2022 20:31:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10571"; a="776641939"
X-IronPort-AV: E=Sophos;i="5.96,272,1665471600"; 
   d="scan'208";a="776641939"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 24 Dec 2022 20:31:42 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 24 Dec 2022 20:31:42 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 24 Dec 2022 20:31:42 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 20:31:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NoI2uJe6N2NrN9y38DY500Q8PeU9o6+UdH7IG9LpeIr/nVxq5gzixfCjOkxJ7j+7WcH0D6+TRTQXd92XgTpbTF04tfs6hX++2gwvOMwlxSd+/rCzVCBq1eIMTp5N0ZF60Tyqjh9n6AdBo7/2C6lirictU08zpw2KMxOo6IAHbowof/p/BJnB65HowSVKRyGbYqQDXZOCHdDiSnvHsMz/Kwx7Ge0IWSr189kz9aXVk/wTGZMQBPPlBbKbYm3DIZxpU26ToLQ03D39ikj0vaN7OpYU8sQqRyuCVO9IA0XTMjJw91OfuMSHFKR76Ir2wcDmbwUb/c9BDHngB+kXHAEaDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1xEbBB92pbcy4fKUcNbHjp4M83XABHpvwIdQlCr26z8=;
 b=PMfwPL9K9ICJaEVrS6wB6elJAxCghCcjhXGTnRAgonfEswNEzfrNvNnpZ/TNYEsYm3saGq1J1BwxZZiYOLJ8e6n2wxwkUufINH7QICBUki51v54U5pmxNTp1UTBMPD4mN1fyB/SFS1XPviEFS0S4Kw7fwmOXRwIfLsEDKvwumiv4s57hif7dXxKGadksxtvrvlf7khMM+KxfWtI/Wz86t/+MKI4LWW3oHPbHBRLW1nI2Du8jCzBzqdakTkC+stLJfbrufA0caZrsdefi3vcv+oB9SoqXlf6okX3XmX0ooJztQ+tIjHoTo3VFTXRKs4Npy1nmN0FtF+2B+1THYE0SnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB7889.namprd11.prod.outlook.com (2603:10b6:208:3fe::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 25 Dec
 2022 04:31:32 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe%3]) with mapi id 15.20.5944.014; Sun, 25 Dec 2022
 04:31:31 +0000
Message-ID: <5dccc4fb-1b90-326d-fb33-4e68c839a675@intel.com>
Date:   Sun, 25 Dec 2022 12:31:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 15/15] KVM: x86/cpuid: Advertise Arch LBR feature in
 CPUID
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
CC:     <kan.liang@linux.intel.com>, <wei.w.wang@intel.com>,
        <seanjc@google.com>, <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-16-weijiang.yang@intel.com>
 <41f13d29-b375-da1a-543e-7cfcc052a5ed@gmail.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <41f13d29-b375-da1a-543e-7cfcc052a5ed@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG3P274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::14)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB7889:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cdabd6e-2e37-488c-37fd-08dae630e56b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vmbn/N0SFKurAnaOvHkI57yGufGNanob69wKe5BneGT+mApbvxf38bl11y9rmKS4WQXvRqahMsXc65IJl5B/7sFG8be7G+tpaXz36iBsLjnlOu3rHos803Y1cqd7fO7a+G8kujPs9CLceK6+iGUdRXrZUZMhAmco9c0CCN2vCVE37nwSI4cpKyiqPhEzjjAafodm6ipUuLiSOXErIThbD1jTrmQ4Y3cJwjLhias++28M2Uz1ydRA7rJPDHLFvAQNCf7uhCaIhehwnI7xFkDIHqUaiBOU+aE1dgXMjBIggmOyHnklSyQX8tGWA5CpYxQX1Uaf6W9Y+t1p28lyav5eWQmac26ygJFAA2YecSj8nm5yL9DddKdj2/FWBYd/JIS5XBBUZjxySx8fZe0I7VYwTKOn6reYmD2SoOPleuoa5XHO2Rllj6kCyYeng/UlG7xOjlJFFhj48moqz0fNJkcLGqCq4N9AJTjMb8OpWoXFzH6VNCm63q+wyOx1fWiIJP+JdbGL5iiitvOrTE9197KBsYLd6virXewOP/UuXk3qTVWzEbOPTxVOugl438t09bWRsgUFC01SoV2zmfOnoKJTsb7bR9caY0LflNkBXctDbJZvGiJft5vgJAOgT/1MuBDLN/XnjNmwjFI8HPJ5YYlpxFvFZPISJmuYWtXh05AzfwykWpJaF9IyZg4r8IySg4xA9mOUSt1XwAsi7Q7cMMGMNZIii7GCX4gFi7fi0v9KzMY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199015)(6666004)(31686004)(478600001)(66476007)(66556008)(6512007)(186003)(26005)(31696002)(86362001)(6916009)(66946007)(2616005)(316002)(6506007)(53546011)(6486002)(8676002)(8936002)(4326008)(36756003)(5660300002)(82960400001)(2906002)(41300700001)(38100700002)(4744005)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dCtLQ2VzdU1SU0ZBd2o1SzRQQXVueGRwUjVKYWZhVWRxQTh2c3F4bG9QWmdO?=
 =?utf-8?B?UTFYSURSOWFCeU9CM1lRc1VwSVk0MXJZbFhwNUIydGtGajNXbjNVOHJrcVdT?=
 =?utf-8?B?VWJaeHUrSmR4MlV4U0YvNGZ3UitsSDhNYWljTWV4RjZGb1FuY3JlR3lsRlB2?=
 =?utf-8?B?TE44L1NkeXRITS9vMG1WZnY1eDFzbWtPbm5NSXBHdDFDdmNFQVhpWTdUd1ZU?=
 =?utf-8?B?T0pXcmFCQ0k5QVJKOVdiRTZ0UU51ZkM4ay9KTnJqWFRBVm9rVVRiSnhMS0xr?=
 =?utf-8?B?YU45dWNPcU9vdjJ2V2tpWVpuemZWUFQ1QWxGN2xzUTMrdFc3TUREM0l0RmZt?=
 =?utf-8?B?M2JQWTlVdTJJcFU0SnEzVFhxWDlVVE8xS21JSmVLVVVDYkFNQy9FbkduOVpI?=
 =?utf-8?B?bW5DdUkvNGQ4ZlJmUGxuRFBCaExxYUhKSmh2QmlNSC85V1NOQ0RZOVBoVTRi?=
 =?utf-8?B?TlFmZng4RTYwQWhYUFQ3T1hpUmlsT09maXFXNi9DS3lvMWN3NFl6K09qdHQ5?=
 =?utf-8?B?RkJmWjZpc2QvUkJzcHRFYnVoNkNPZVVoVDc5M3psOVdCLzlzVFRtOTd6eGFY?=
 =?utf-8?B?cURVZEpyaTBMdWw1N3JqZHhUTVZCVDJVbUdzYmNtdWxPNWNMUWVFVW5vaENl?=
 =?utf-8?B?U2lYWnIxS3NhZjl3WUpNSWtlYjYreHlzbGZJcmU5NWpPMUdOUWo2Y0hxNTV6?=
 =?utf-8?B?M2xubmU2Zm9WTVhpNE8zemtBOFVYSGR4bFYrVk9YNkpBYXEvZWhOVXBGY2Ew?=
 =?utf-8?B?cDkvUjRzeXFaRHRlK0RKTlJkTjhmd29NQTBlN3Q0T3NSVWlqcWZST29WR3h5?=
 =?utf-8?B?cU9hUXpuNEh3QzdIUWZLcE45eEdGVE11T1BtRlRGT3hVN2liN3NVWjlWVUNh?=
 =?utf-8?B?bUdTTnlIM2hUZnRRaGM1QlVVSjlrNWhIY3FWVlJ5ajFpV0RNNlRZZlR2T0hQ?=
 =?utf-8?B?RElxS1JYS1A4dmpmZThJOFhDOVl2bXRHQUtFcEw5RFNvOWZ3Y0NWRFRtckdH?=
 =?utf-8?B?TmU5Z1ZjSnhkUEJhMlp3b3NGYzZ1cFV1eE8xZlNBeTVWWmljUXdoL2xqQ205?=
 =?utf-8?B?ZXVEWkVKaHdmM0E4WkVSTytyQWcwRFFZZGRpVEdOUmVyWU9HTXR4UUtYc3lw?=
 =?utf-8?B?YnUvYXR4a2hOUHFTMkhhRmEzYVg1L0dMaVBFWkhTZEVEV1E1aTM0dGNuTnlL?=
 =?utf-8?B?djh2REljeXRnNENJYmNNc3FsaGpIT0ZUL2pObnJUYmg0REtsMWxVMWt0SGZz?=
 =?utf-8?B?QkNtYVhJZS9uV3hnVWUvV25DYXgxMnMreUVlVEVqWlkyRW1GZ0w4ODNvMlBF?=
 =?utf-8?B?OVdEckZjeFNVZm10ZlV5WXRWZTJHa3Q3NkpiSlhOQmRaQUdyUXltdm4yYmFo?=
 =?utf-8?B?cXAvcnlMRytDSjdzSUIrWUlGWVhpVVF3NUlwYWFkdkhCR2ZhSG1BeEpoQlY2?=
 =?utf-8?B?Y2tqajBLYlJpSkRHaFBLUVlBT3h4RFVoRUFLNytibnZDcVhiSnVlRkRBcHRW?=
 =?utf-8?B?eGlaeUI5Y1B3TjBKd0ZKQnpERTEycFBEZXJpeDVVTytnbkFuVnlFVmlwZGx2?=
 =?utf-8?B?QTBWQnhDWG41RFpWS1VqVndlSCtDbVhkbzgwWUx5cTdObzdGSlJyZ2dhbHgz?=
 =?utf-8?B?VFc5cnBEVVZoVlAxT2lzZXh4c3A4QlNnRzRaQjlhZVU4UFplYklGRHJITG1a?=
 =?utf-8?B?RDB5NVZveS94bEdmanZ1eXdueVJ1NTlMcXhiQWxhZVQzME1CUC83bmZTR25m?=
 =?utf-8?B?WFQwTmxFMXpWa3c4VmluK1JTZ1M1aEFvWHIwTnRuK01Sajcyd0tCMTR0QlZZ?=
 =?utf-8?B?ZERqYmt3SHJhMHR3aUlUT3h5MGFNTkIvbTZFNC9IUGNidmRsZCtEanptWi9F?=
 =?utf-8?B?ejFRcjd5N3YyUTFHZDNpNWNNZjVVby9Rd3kvUmlodG5PckJldVp3U0ZoQU5z?=
 =?utf-8?B?dFVIWWNDNkczNnNRQUZvckQ2ekN5cXQwcXI3Nng1eU5waEpuL25QNUhFRXY5?=
 =?utf-8?B?TUJBSUxxQWNCWEZJdjFzdHFOQkFQSXphZXdER1gyTlZWdjA0SjAyU3FXa2Uy?=
 =?utf-8?B?SFdBYVFxTmF0T3ZuQUVNeEljRE5JOFpHc3A4cWQvaE1LdVB4UGgrQmpGOVNI?=
 =?utf-8?B?VG9TUEJUclA4TVMzU1NBaDBKUWhCaVUxaEd4OFdKcC94MGc2R0hjOG1RS0NG?=
 =?utf-8?B?elE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cdabd6e-2e37-488c-37fd-08dae630e56b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2022 04:31:31.1142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NcPIcq5vNRvJc+aa8nK2wbLsSK3cyVkFlMMWWD7Pg8AihukwLXaBM2yDjUArToyq+DNoE5ocKP/CYD0fs9AxIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7889
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


On 12/22/2022 7:03 PM, Like Xu wrote:
> On 25/11/2022 12:06 pm, Yang Weijiang wrote:
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 85e3df6217af..60b3c591d462 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -134,6 +134,19 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
>>           if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
>>               return -EINVAL;
>>       }
>> +    if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR)) {
>> +        best = cpuid_entry2_find(entries, nent, 0x1c, 0);
>> +        if (best) {
>> +            unsigned int eax, ebx, ecx, edx;
>> +
>> +            /* Reject user-space CPUID if depth is different from 
>> host's.*/
>
> Try to verify this in the KVM selftest, as this behavior is different 
> from the host.


Will do it.



>
>> +            cpuid_count(0x1c, 0, &eax, &ebx, &ecx, &edx); > +
>> +            if ((eax & 0xff) &&
>> +                (best->eax & 0xff) != BIT(fls(eax & 0xff) - 1))
>> +                return -EINVAL;
>> +        }
>> +    }
