Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC667BF000
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 02:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379299AbjJJAy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 20:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379226AbjJJAy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 20:54:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4B2A6;
        Mon,  9 Oct 2023 17:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696899296; x=1728435296;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DKUmJLePmhIptUbU7d0n4EEn+GPeGP4k3nP3MvlaAio=;
  b=YzKXpBvo4aDuED1YTObLS2F8C3KbbG818X4cpAJKuEz2ZNEfmgh/Bjg2
   s3WTg19WodFNys+2bu+MLU4RUfkRNtK90Cz23hQsnmmQVsy/YW9IW7AoA
   wvEoWs+nUIwgg08o33L3pllLOP/ah0iMRyW21Np2ylS2cZJrjOfF7j7xn
   lOJ3xknwc7srwB6Iozz0KbBbTluAj7wADZqBU7AglGuHWU4GO2GBPJVtS
   PWZQuin5VkKnRtqoNVOEDfvbbPWaxvOBK/r5x2gAZjFjPeFL8zloVUwNH
   IyNlueBVl26a6MG/csWbdR/icl0O+TuqQYK0DOKcfyjaF5gfrLiCQj8Ik
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="415276191"
X-IronPort-AV: E=Sophos;i="6.03,211,1694761200"; 
   d="scan'208";a="415276191"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2023 17:54:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="877022413"
X-IronPort-AV: E=Sophos;i="6.03,211,1694761200"; 
   d="scan'208";a="877022413"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Oct 2023 17:54:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 9 Oct 2023 17:54:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 9 Oct 2023 17:54:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 9 Oct 2023 17:54:54 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 9 Oct 2023 17:54:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WVyEb8ZtmcgTmLvy+hlrciDyXZ9hRqua9fqU5mSt5ZrHjhE6DUxVNFJ2eyQrrMjqtM4xbM3iD3aFt6k4jwYEjbB/CLZExgYNVvvFC5L99LYJuS0g+Dn4uL4r4y7ZLYuwDp54bbWn0aVzOeMHGQeBgBZDirxsMHNpK5nIxPRaZI/3gnMsAg3J+uoS1bbFyJw54MPjCCBcIrZ+X8iSJM/7WdwZ0LHjI9Tih9HHTuHBEMqWvcFbfmZAcsGTjDj0/sWxEsQLm2c+CWUHwKDM4WVf8BVhPCRNUNXiFbE7IonKu2WDEgnILbUzL1WcE5D1eXiEbQWerCUP8DK79ZTlbF8Wlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Yhf3QWziIBRq764+0u8dCTddatCPTC7HLxZ6PPjw/A=;
 b=RJazTkvE2k+ZlERlBqWARroK96B2IZS9VZwWl7hDaynkQyZQH5C8kDh79oaeBfguPCVxx7hpOwOrzM9fRrKKLrp8paUFCudzxVORn8vKXNDf6ZTAbV+8vm9bh+of2gSebxjMUFF+0Rr7Mz/sBgJ/pm9xs5Q5/DbGiZxP+CnDbkBk8nnlZ1BIFh5sVQLJNs8dYCEZRJxhZWVlga7+dUW3O667sKbk+dkUmVnS+nd/+cEb8tXd1fBSg4jhl40hHTPPc8Ov3iYu7N6G8yqwagzJXxy6h4Y/GqdRwpXUtp9lMMVH5elgJ7QjyYxSSnnfbwO7R0fET4XtjJup3OTPYd+svg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH0PR11MB8142.namprd11.prod.outlook.com (2603:10b6:610:18c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Tue, 10 Oct
 2023 00:54:50 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90%7]) with mapi id 15.20.6838.040; Tue, 10 Oct 2023
 00:54:49 +0000
Message-ID: <f93ff80d-13e3-aa8d-3c03-89b36029fa51@intel.com>
Date:   Tue, 10 Oct 2023 08:54:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 16/25] KVM: x86: Report KVM supported CET MSRs as
 to-be-saved
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dave.hansen@intel.com>,
        <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-17-weijiang.yang@intel.com>
 <ZSJJ5jlNtgrVP+Qw@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZSJJ5jlNtgrVP+Qw@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0018.apcprd06.prod.outlook.com
 (2603:1096:4:186::8) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH0PR11MB8142:EE_
X-MS-Office365-Filtering-Correlation-Id: 30caf28a-180d-42e2-b183-08dbc92b8101
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: chX97wfQkhKj/y5HN7475c/D87K4E83vzGHkt++y8qdGDDz95ylzfGRmkm7/zft8BnBX8ZH2dupbirXUCZlLr/9diOkSUntvExTF1+CPSZgyX9wyCCSALZTaWLw31J23T4bT5Q2bH8PHHd61AY8imh5XVZWRpdHm5MiOn1S3fkcYJfxYPAY90E3jL+LFm9NXVNT6XT3wpo2V3jSdxmRV+U3R4Me726nAxiu9qZ0xqy2W/7kWCiuU9I95p7PObGd0dCZYEkbSs92oVWdBD/zQIKNwzdujrjtLHKigaegBkmT8SX+9HG/NBaQ8SFqnkxU6U5Qo3lkfn1EGtp8cxMqKPU/hMN8TbEmtY9DQyaPaE3QM0Pln1D9klc0wzbQX2NQZA0f83rU1Hn/zgmFNRmtIt5mOJ4YFsd/woYlYu4szpp19WHjm5K1dbUJ7JkdQncmasWfBQbAxKn5v+1VFmM65ubLXbiO0mOWpWFiflm3WD586p45i30vRhmFYefjbQdm6u9ebQn64+ZLrx7Ql/r/JtSBXWUGJbpozvDzHWvJwFUcz9A/8E6N1EyZlENhSmmUigrftJE9KED3Pb1Mj+FY8E7FoC8q8ZWtdH8eh9bjlF0Bt3XRTxOs70x8upIcEsS/yHi0CL+lce5/qhwKNZrg8Tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(366004)(39860400002)(396003)(136003)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(6486002)(8676002)(6862004)(4326008)(8936002)(6506007)(316002)(53546011)(6512007)(38100700002)(31686004)(6666004)(26005)(478600001)(66476007)(66556008)(66946007)(6636002)(2616005)(37006003)(41300700001)(5660300002)(2906002)(31696002)(82960400001)(86362001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWt6VGxUWE9XbjQ4dGtjV3dRMnZqeXZsU0ovZ1RKZTk0OUdDUThoeXdoczl3?=
 =?utf-8?B?aUtmVllxQzZGUVdGdzRxUXpqZjZtTFg1bGF3NFhnY2ZsalBmVTY2SkU4WG9P?=
 =?utf-8?B?eDZ2ZWZiRGhSKzFFUjVLWk84WVFDb2dQaU5vQ0VYRXBkRXRMQUl1RnBjODRs?=
 =?utf-8?B?T2ZPM3hRNGFzUTJiem1HdXhjeTQ0NDRTejNMYkg5VDZGc3VUcUpqV05sWTAz?=
 =?utf-8?B?SDlmT3VPUHc3eGVHaWs3dEtJTjEyODFiT09hMEhpbHNPRjlRU0JDUCtsT2Rm?=
 =?utf-8?B?ajJlYUlraHl2MXpGNk40TDJKc1JlcC9hMzRHbFp6eGtjL1J0L0NFQkkybHVU?=
 =?utf-8?B?RHd3ZWR2RlVzRHBnYlZJdCs5TXUrSTVVWWNneFYzd3pRZEFYRlJNREsyWlhr?=
 =?utf-8?B?VVRJNnZ6dysxTTl4VmIvYWpScVdkKzFNZWgxK2xTM3FNR1VVQi9QNll4SUFQ?=
 =?utf-8?B?L2hIaVQxSjRkeHViVi9xVWRpbDBNblRjeFZKYisrV1FqNHJwUTltN1NvcDY4?=
 =?utf-8?B?VFlHbE5HMy83emF3UGNoRXlGTTJBUEU4WE15cnE0K3ZLMTY3UWlnZ0owM1NN?=
 =?utf-8?B?SldtZG5oMHJ1RW9Yb2VvdFlQV2R5SjFxRUwzU0lIRzVlSTk0MGVmU2xtZkJz?=
 =?utf-8?B?eW42T3lpUU9JTGpNd3dnMzVZakdpcHg4ekQvQXFzN05QVE9zT1ZPUWl2Mi9F?=
 =?utf-8?B?TUVtRXpaRjNEczVFemtsYXpkeklKYUk0R1dVeCtHZUQyZkhBUWRuQ2dpMGtZ?=
 =?utf-8?B?U0NWTkZlZmh3Zi9uWXExTkk2RUlOSlZqL2dIWTdNcFZZK0hrNWhLS1U1NEdS?=
 =?utf-8?B?SHloYm13K0szNFVFWEk2V0VOVzBRT0g3cmUwckt6NFROazZHNTBjNkpnV29n?=
 =?utf-8?B?NXdqTVZGQi9CUkVML1RoOXFaOHZzU2lITE9IRXB0b29jUUVKb1RQNEVtUDdx?=
 =?utf-8?B?a2UwTldGVUJIQVZpWkY4M1V4aHJjSGV5U2dybXVsak93akxZenZuRDJENDRw?=
 =?utf-8?B?Z0JWMjZmY1FUVUZzeWN1cW8wb0dPZDg2UGpueUg3QVlYZWVnOTRvMDFNNTlO?=
 =?utf-8?B?ZjdMUWhTK0NWOTNZa3B3Z2N4Ulc3VTB6QzZyRjc0VWtScHk1TWthRVBaVjhH?=
 =?utf-8?B?dFo3cE9lZGlOTkRsRE5QZGZ4MWppWmxWNjVhUlZTSzhBck5IcU1RRG5XejJm?=
 =?utf-8?B?WkczTi93ZjlYeS8xM3lJNEc5NGllM2RnSEhrb2hBMWZ4OXVrUlBFcDVsaUU5?=
 =?utf-8?B?QmZrRHNLemcyc2lvMlZUaFNVajVqL3NIVUtpL1dtVHFRay9yK3kxeEFSczM5?=
 =?utf-8?B?TzZXS3pmbExXTStSbFNyWlQ1MkF0eDJLSU5NZGNhMGVnN2pqbTEvQ29rMHFC?=
 =?utf-8?B?UmVTNXJPNEFxTytBOS9KS3pYby8zcFNTWWZYcG85TnJITkpIUy9EUUNEWWJz?=
 =?utf-8?B?NFJRMDlzQ0lNd3hCMFV4bXFTcUdSMXJRcWZ0aTNZQnQxbHcweGtCeGVvaHMv?=
 =?utf-8?B?VGNJc3dlNkpHd1VHd1Ivb1c5Q2xXQzg1WHBRelluVmcyQmh5YTZnWXN6SGVF?=
 =?utf-8?B?WE1HWUdLRlRaY2JscFhkamllMWd5UWRnU3MwT3JHVkg3L21PbW80NS9WQjE5?=
 =?utf-8?B?SE1GN1pxRnY4V25RMkNlb0RUUjc1aUttdWFwdVFReU1KTzdlMG1HSjFRbzBS?=
 =?utf-8?B?RUt6dVJXR3lBVWhvUXk5QkZSZms4V29rN0g3SEp3SjJZa0xRMnNuUG1WQUYx?=
 =?utf-8?B?dkpRRXVZWkoyVGJWWjAyNWpVTVZwVSsrNVpJMEZSNkxzRXlyb0RDeldNUjN5?=
 =?utf-8?B?OWRHM3ptNUJib1JEcDNOOXcvVjh2djRFYkFqa0NVT2xxTUJFWDNzc002U1dN?=
 =?utf-8?B?VFh2R3RpRGNGaXErZmpaNytielhuZEVJZjFUUnBHc2dmWmI5QklGZnh2dGVj?=
 =?utf-8?B?QkNiRmxCaGtyTFpnV1AwVFFQY1AxeGx1YSsvWElvTWVNK25kbmJDbmFOdE5T?=
 =?utf-8?B?N2EvRW4yOFowdk4rQlJNMm5VZnhHdzdkMW9iaHF4SytYR05JNVM3NGk3R1VH?=
 =?utf-8?B?YlRwQ0h3TVEwWEZxN2MzN0t0SlMyV3hjZ2pwbHVpWENpaTEzYzdrb3Nxakc3?=
 =?utf-8?B?QmU1SDdGWnBUMjFmeFpZQ2g3Z1lraGpVTWFKdjREVlMwTExIQkpmUlNWNURH?=
 =?utf-8?B?MUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30caf28a-180d-42e2-b183-08dbc92b8101
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 00:54:49.6050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZNPIYKgaaXp+GLY2TftfsmIxyfGswtjSmah+obrcVMsdPrlz9bOKh3QPAw9jDDD1umlMyDxvOLUKOxE8F131w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8142
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/8/2023 2:19 PM, Chao Gao wrote:
> On Thu, Sep 14, 2023 at 02:33:16AM -0400, Yang Weijiang wrote:
>> Add CET MSRs to the list of MSRs reported to userspace if the feature,
>> i.e. IBT or SHSTK, associated with the MSRs is supported by KVM.
>>
>> SSP can only be read via RDSSP. Writing even requires destructive and
>> potentially faulting operations such as SAVEPREVSSP/RSTORSSP or
>> SETSSBSY/CLRSSBSY. Let the host use a pseudo-MSR that is just a wrapper
>> for the GUEST_SSP field of the VMCS.
>>
>> Suggested-by: Chao Gao <chao.gao@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>> arch/x86/include/uapi/asm/kvm_para.h |  1 +
>> arch/x86/kvm/vmx/vmx.c               |  2 ++
>> arch/x86/kvm/x86.c                   | 18 ++++++++++++++++++
>> 3 files changed, 21 insertions(+)
>>
>> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
>> index 6e64b27b2c1e..9864bbcf2470 100644
>> --- a/arch/x86/include/uapi/asm/kvm_para.h
>> +++ b/arch/x86/include/uapi/asm/kvm_para.h
>> @@ -58,6 +58,7 @@
>> #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>> #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
>> #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
>> +#define MSR_KVM_SSP	0x4b564d09
>>
>> struct kvm_steal_time {
>> 	__u64 steal;
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 72e3943f3693..9409753f45b0 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7009,6 +7009,8 @@ static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
>> 	case MSR_AMD64_TSC_RATIO:
>> 		/* This is AMD only.  */
>> 		return false;
>> +	case MSR_KVM_SSP:
>> +		return kvm_cpu_cap_has(X86_FEATURE_SHSTK);
> For other MSRs in emulated_msrs_all[], KVM doesn't check the associated
> CPUID feature bits. Why bother doing this for MSR_KVM_SSP?

As you can see MSR_KVM_SSP is not purely emulated MSR, it's linked to VMCS field(GUEST_SSP),
IMO, the check is necessary, in other words, no need to expose it when SHSTK is not supported
by KVM.

