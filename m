Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADCE70EB96
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 04:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239217AbjEXCze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 22:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239209AbjEXCzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 22:55:33 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB28189;
        Tue, 23 May 2023 19:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684896931; x=1716432931;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BrBMIo/EAHjUA6ATyfn+YFIgfxydyZlygsF+gJlGphM=;
  b=VFFKIZv331HUnZjCMYcircVMvx0hGjZh/L+6PvtMDt+K59hzyZe64Qvt
   aRMp04wVxt6VPhBa/bwwT+ZfAWXCtE+TRAOwTQfY6b313xSnI97dnJ/BZ
   mYzbmoEhCAIb0oLDnJ9q4JTThI3D8zE60Vn60tdQAXmln8KoDW82G79DE
   TRj+OtXnbZlvbYrzO1+J/3+tIBv7JXuMGvRV3CDaNnGG6qr0GD7tsv0ck
   KxQWM60aKg9tquXm58jv2OBXDDXtzf04hqgKQ+pQnYUie47WXg9HTsOXj
   Ho9ceTH3UIPUTDp0C1/MN/qvXZFUgTB7ufKz4CjsB8wR6a1Y0MZ3a7LVV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="356658144"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="356658144"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 19:55:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="848557565"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="848557565"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 23 May 2023 19:55:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 19:55:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 23 May 2023 19:55:30 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 23 May 2023 19:55:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HyXm0l1oz6/Lt0O2YrCrxlo/whbUPymR5h+x3rOTIF9rVRNRZdqcANMaD5lqey5B1UlFS/N6ntyj2DaxyyoYEq1GxC3KcIHY0H9+Kr+saAMtoiFRT7B+xFZAQuk/VE8mrhI21OOWpAGxusEbp4x3KOI6kx7tfaLUCnODqJK0IWxIdZA45sQ448ulxBMBpeULoqbO11AFOXWhxY/imOFVVLS+Pdhw1DfuWULrDECMulcHMd4AxYo5fzeU0wnQowAClldM6zljvtynncD+MBbCyF6GTI4UGBxs5yUoetmVskPz4jaclG0m5SRs2e5VdtW7SJ3sXQHP0v2yZKKebje6Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WrlLXYkgVNiyY0Rw3WQewrC35GJN49dlp7N6xurZIsg=;
 b=LUgPUO+ffSfzCrpXLXnBx+BeKzY7M2EFtaazJOAa+c/inXAiqMcTtpYjQ6i9/TID7SnuNChUi1JLO+MGPNJv7+ox9dwsJGPq5kIt7I3fxL7eZn2xbxMBosozmgKEZCVi06UzWC98e7/s0qZOOG+pEeVUh8maOFe5a5DoC+w4F7qeaeD10AR2WPZRjnHPhZ3rc7bxrpDYZU7T4dHQyXJAQzN9ECOmKvCtfJLmftuwahahhzTIvXzsW7Ob5JVYv4SDwVTYHeAT4jcpDYqgzKZBI1AIMXErMsz9U/S3NNO/X/vT3qshENF5qcNrlRWnpx2M9yBk3P84mw42nSZYweNBlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB6493.namprd11.prod.outlook.com (2603:10b6:8:c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 02:55:27 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4f96:4b14:c54e:6261]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4f96:4b14:c54e:6261%2]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 02:55:27 +0000
Message-ID: <791e1cc9-38e1-eb02-673c-13c1194c7960@intel.com>
Date:   Wed, 24 May 2023 10:55:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 14/21] KVM:VMX: Add a synthetic MSR to allow userspace
 to access GUEST_SSP
Content-Language: en-US
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-15-weijiang.yang@intel.com>
 <98bbc70e-7566-36fa-98e2-5bf5a97d682c@linux.intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <98bbc70e-7566-36fa-98e2-5bf5a97d682c@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGBP274CA0004.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::16)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB6493:EE_
X-MS-Office365-Filtering-Correlation-Id: 629ecfb3-3454-4989-4d35-08db5c025397
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gVQ1ypitNTC/7x/G2iDfib8km1XSoAovX/nhw5kJOpU763XO4i/Hog76W9nAIEsNCO1iw5Nn2eNcYuZ/Zq5h+ShwLS0G+Osv604Zxp0AaHMkmfQbqLm/dXa4fgUrBUBc6VD3pS7DMVkr96hy7OBDY3Sp3Y0HKsNLcNY+Ib+n6bBewQ+2BTGKj44JPL+qVhlLDoeBQjq5r7At4SGDtThUAdLQAXijHERIoY0c+AGrpoWIjh6MWrXAMjYYDdOxUmefNKa0oQw0pNzJR3pPl3W4k8I6/woUhJFRVIOlMgTzSiej2PQvvYbJwrES1i9tZjjAdxQmWs2E/YfRm9cO1zZQLM8EYSxnDatMsalgTN6fiweiGLZm4Hmfiqt4i44eVMg7aur1fwMgOmfxuEoNN1Dnp+t90yLnUCCNitv7mhNo/51yzu3a/gnCgZiBC1vQWogj715eZ+as6/lzLlNWr861ARUgHmTtMyGSb6eWe7cBkS89bOejuZhtA2zg/BcH+kWPcEtznm+36gERCfrul5wXgt178JDl8/sESTPGNcTOjJ/7Yn8duaJkZarI8ITRNzohSC3uYunYb63cJJPndJGRbnfF4OTA4URkT51oLtnR5dQNWzecoEOfF7yX/fMawMCU2dZ+BXuRHnSD2lpEJHsHuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(39860400002)(376002)(366004)(136003)(451199021)(6486002)(41300700001)(31686004)(478600001)(31696002)(316002)(66556008)(66476007)(6916009)(4326008)(6666004)(66946007)(5660300002)(86362001)(8936002)(8676002)(38100700002)(6512007)(82960400001)(6506007)(26005)(186003)(53546011)(83380400001)(2906002)(2616005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlNvVTFJNUt4b1FuTlRFOStEam1QQmM2UTZxS2ZhaFhnSHdPS1lwb0c0SGQ5?=
 =?utf-8?B?WjNKTXpqcFFLTDNJUWhUbjJjWVN6aUJJWGl1OFlMcmlQbzFZKytyZ0NSdW11?=
 =?utf-8?B?ajNGT3cvUFZFUUdiQXprVFg5K2oyNVVmM0V5b2h3RHFpU2lQdEF6NGhyU2lt?=
 =?utf-8?B?L1liZXMzM2pzR2VpY0hnZC9EalpxSGpJbzJvU1k2b3NyQ3o3RjdXampxdkVT?=
 =?utf-8?B?RzF1ZUt6MHpJaWo3UHF3QzcxR0w3RjNEWkJUSHlYSWN4enhhTkdZT2hOUTdK?=
 =?utf-8?B?eUErc1VpdjFLQWJTNjA0QTJadnRZdU1iSmZoejZ0OTM4OURnM25NNy9ueDQ4?=
 =?utf-8?B?QlRsT1hXdlFYWkFjQy80dGZUT1cxUkJERktrMDhteTNxSy9lMFM0N1liam1h?=
 =?utf-8?B?RGNFQmRMSlFPUlBqbjhuMmNWV0FuMzZWdFlRZFFka0ZMMFc4ZVY5RXpoOUx5?=
 =?utf-8?B?Unp2OEFKWG1SdXI2SndFWWxMTHJrSFZaTW0xWDBIN3I4Z3R1bUVIdHZ6NHcr?=
 =?utf-8?B?L0R3V0xocDhmRm5SOHIvdDc0b1pRU1Q4bSttcFdFYXIzVi8wMndDQWFIZ1Va?=
 =?utf-8?B?WERkUnJ6WWROa2dUM3BRTmwvd3o4QXdJMFM4WXhvRDNCcGJEWUNWY04wUGZ4?=
 =?utf-8?B?MVlvZllwNyszRmdxelBDSTV5amJGMXY3eEgwMUNoZEJqeFkxZWlnbDJUUGQz?=
 =?utf-8?B?MjY3a3NtYS9xa29PYVV2bnRhdWx3V2xKMHZNOVlHTzB1b1NCK0dDQ1VNbVNm?=
 =?utf-8?B?ZHFpZS9pajM3UDZDeHExVEVLTnFVeE4yV0Y4dThnTStjUWgxUVlvOGpObG9k?=
 =?utf-8?B?V2lDVWxMbDY5cmlwTDdrd3hYeHBWVHVJQTh3SlNwRnZSRy9IQ3Z6aEtQd1l3?=
 =?utf-8?B?NUx1OGV0c1lBTWZKSXc3US91R1lVbDlaS0RWc1JCNXAxcWZWSStrUlViN1JN?=
 =?utf-8?B?UzFUUk8zayttSmxsWXFyRlA5Uk9OcU9VTHZ3SzRpUTgwK1RPWUdqSnRkdzNN?=
 =?utf-8?B?WjJ2VzN2TitnWEp4NGZaTFFMSE4xbWwrRXg2RjJLamh6V0U5aWViL0FUTW5W?=
 =?utf-8?B?RGJNNDk3UTNPNWtEWDVpakNJNDE1cWdqenU5bHhUanh4UDNUNFY3clF4T0Qy?=
 =?utf-8?B?RWFIbEN0bXBaRWxXTGdSdTZmRXY5eEVhMzFBVmV6YVFVVjlkVG16SlN4Q3Zm?=
 =?utf-8?B?aCtwY2FFYlNjSHU1c0dNV1lPaUh2MmZKcDhhZE9pYUc1UVdDMUFmT1oySUJs?=
 =?utf-8?B?YVBUWEtoT1l4UUYrTnA0dmhQeVpQb0ZmZlY0NzMvaWdZRHIzb1VLMnprQm1x?=
 =?utf-8?B?d0haTUdsV1d3bkxjdUhXbTdmbFU1dDNnTjdJWm5UNWYxSTJYUEVLeXNsNHpN?=
 =?utf-8?B?RzNZb2doUEMxZ1BQL0tYYWFtTWZNdDlmYU1EQ0Z2bGlWWGJWcHY2S0t0K2xn?=
 =?utf-8?B?SUxnWXZtSVgwTVJXZjNPNmRoQ1RwL1YyRlNTb3ZmZkZBNWptcjc0T29lM2pW?=
 =?utf-8?B?YmVZM2hoNkxiL2M1dDdrWS9aNGpzcStQSkZIYkZyMmFjb0cwUDdJQ3BudHpE?=
 =?utf-8?B?U01FdnRWL3Q0TnlHRnVaWExEREpEU3d6NGVtemlOR2Y3TEYyUmNwclFkSWwv?=
 =?utf-8?B?eTBYZ08ya2pFOVpZbGtxVWFBaDRuZG5sV2QwcnByQWFmVXVSNnNuREExNTlF?=
 =?utf-8?B?RGZUbVBvN1pERmZwMVNWaEZVcm1vQzN6WEc4d1BMOHV3Z05jdm9CRzVMZFhl?=
 =?utf-8?B?OXRBTzF5R0RiU2FFYTc3N1RPMCsvU2M5RFhOK0lvQmhrZDdtNDd0VUU5NWxZ?=
 =?utf-8?B?MGIxRU9ZY3RsMjluWWJYQjFQUi95aEhzN0ZlRlFoQm9mcjIwMHFJVG51dVpB?=
 =?utf-8?B?bzZHZWlyWmVNVUdjZlkvR3AzVTdRNDZIN1VtOEpyejNZTDhRNGI2L256bFFE?=
 =?utf-8?B?T0VaWHEwTmYrdkdUekZ2eXNDaFRXWUIzcmtMY2RUazYydWFQSDJFY2wyc0ww?=
 =?utf-8?B?WTZubndiaWJ5TjZ3MUVVL29CNVlUZUNMOW45LzY0cU1USjZqaG4xTmlWV3NL?=
 =?utf-8?B?OEY2Q2ttcVYyKy95cVY3NnoyWWxHNFBLd2JFbU02bDFjKzU2bDVDRUtsUWhq?=
 =?utf-8?B?TFBZaWMxMnBKRzcxS3ovb0xEdkxXQzJBTDRnNDBRNWxCTmlKbFRvMzJUaFQ2?=
 =?utf-8?B?dHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 629ecfb3-3454-4989-4d35-08db5c025397
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 02:55:26.9667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Evoy1D9FTHJO2IQJBsytwEoyWhhM29mbl28qtSevm810KDXO8c2Xl8tQEZB4FVztHvA6CpdHdPPcSkB8YjuhvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6493
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/23/2023 4:57 PM, Binbin Wu wrote:
>
>
> On 5/11/2023 12:08 PM, Yang Weijiang wrote:
>> Introduce a host-only synthetic MSR, MSR_KVM_GUEST_SSP, so that the VMM
>> can read/write the guest's SSP, e.g. to migrate CET state.  Use a 
>> synthetic
>> MSR, e.g. as opposed to a VCPU_REG_, as GUEST_SSP is subject to the same
>> consistency checks as the PL*_SSP MSRs, i.e. can share code.
>>
>> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/include/uapi/asm/kvm_para.h |  1 +
>>   arch/x86/kvm/vmx/vmx.c               | 15 ++++++++++++---
>>   arch/x86/kvm/x86.c                   |  4 ++++
>>   3 files changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/include/uapi/asm/kvm_para.h 
>> b/arch/x86/include/uapi/asm/kvm_para.h
>> index 6e64b27b2c1e..7af465e4e0bd 100644
>> --- a/arch/x86/include/uapi/asm/kvm_para.h
>> +++ b/arch/x86/include/uapi/asm/kvm_para.h
>> @@ -58,6 +58,7 @@
>>   #define MSR_KVM_ASYNC_PF_INT    0x4b564d06
>>   #define MSR_KVM_ASYNC_PF_ACK    0x4b564d07
>>   #define MSR_KVM_MIGRATION_CONTROL    0x4b564d08
>> +#define MSR_KVM_GUEST_SSP    0x4b564d09
>>     struct kvm_steal_time {
>>       __u64 steal;
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 0ccaa467d7d3..72149156bbd3 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2095,9 +2095,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, 
>> struct msr_data *msr_info)
>>           break;
>>       case MSR_IA32_U_CET:
>>       case MSR_IA32_PL3_SSP:
>> +    case MSR_KVM_GUEST_SSP:
>>           if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
>>               return 1;
>> -        kvm_get_xsave_msr(msr_info);
>> +        if (msr_info->index == MSR_KVM_GUEST_SSP)
>> +            msr_info->data = vmcs_readl(GUEST_SSP);
> According to the change of the kvm_cet_is_msr_accessible() below,
> kvm_cet_is_msr_accessible() will return false for MSR_KVM_GUEST_SSP, 
> then this code is unreachable?

No, when the access is initiated from host side, 
kvm_cet_is_msr_accessible() return true for MSR_KVM_GUEST_SSP.

So the code is reachable:

if (msr->host_initiated)

     return true;


[...]
