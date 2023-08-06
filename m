Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FF6771400
	for <lists+kvm@lfdr.de>; Sun,  6 Aug 2023 10:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjHFIo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Aug 2023 04:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjHFIo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Aug 2023 04:44:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C257E5;
        Sun,  6 Aug 2023 01:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691311492; x=1722847492;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H050wStVDy+S6ekB/wQGyDJ6edKUiVheS9j8XkCM44Y=;
  b=oAog3RWxaH/Zuub30EplL5kFvQfx9VAWu8x9n+Qj74YnIWbs/noQxZet
   SBbx5hB7OrlxDxkDxWjzIgrTlYREPTW/MVn4veWAydKL55XKa0NqaJdVI
   FHHO78awQ/JdEuIYyDKVetY728Y7fAjtpFiBPMUfITw7XAQnl2fe4Pf47
   Ee1GF6AtgWl0pnyTvrod5juXf9z+yHEfTyTrhx88BXcbcnlz/GbIEX/CA
   rJSJvjjD9QEwfBptlB7LN0mq2eBOhinNF4TeYZG78fEm9fNX+WzwxooUZ
   yhLnsvgRgEjwd/mZ3FKsj0GUPXirGgWgezg3Sq7aTGu5NGq3SmStvGoE6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10793"; a="456747047"
X-IronPort-AV: E=Sophos;i="6.01,259,1684825200"; 
   d="scan'208";a="456747047"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2023 01:44:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10793"; a="760101753"
X-IronPort-AV: E=Sophos;i="6.01,259,1684825200"; 
   d="scan'208";a="760101753"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 06 Aug 2023 01:44:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 6 Aug 2023 01:44:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 6 Aug 2023 01:44:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 6 Aug 2023 01:44:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNXfuODZQTH07YdCe+zqQeG5DbF/BSr9Q3brKmuwaCzwhig52mbpIjywE1yu6Fl/E0uCPsfYVRT60cj7DoqiVVXcMss/fVW3kFuO3KATegH9ufqJy3U4mpRzxKMNc+aaW9CO0crc7HaBQUQitRSB9BdOBk0Tv8E9Ejk3Mv2rkOw60TdfzAEWdVr6kfwXDmJpwmXy8gS3EwGNIAE0SaHe0rEsQjMbQqE1Oqx4poZEKi6Wu32zxyEMqWipoqlgSQOVg2S6cEOdf366St4WBNTbla4gMjwuftRfmSLzwVifnfEJii872ShchWV40cpYKYxTdndwlP+OZNpQl8WefH7n7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZoFmMAezqZ3/9idVnbpl9CDSlN+eVtfUfTi6TOnBgb4=;
 b=fHefYw9k8pmyi2Vp7aJ7mMV1e8zRPbQ13TUC7e+hxYeVJ2CBg7iXvZiuF91PMln7VnXthgb0bqEZfzNpUNZ740ARPnDC6L3tl9+aoGXOQYUsyksZzK36qv44C08JE6ByVOJ1QA2g21C9KQOFLQXUicFTHm8V5y0Q9qC6N4PmjAoQxU5qmN8U65ewSoml2aCuZJAZDpvwskOSfgT8HieJf80LOL1CyBfB/HCmlvq2jGEANMZBITflBR2NCkeWIJRN7BJtpSnPWkNcjewuHQYMsT5ktD2eKGpvZI4GRoaibDKaTcuNfg0NXziZ1Xd6KmvYkx+OPHfuKXqDCM8FZzZcGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH3PR11MB8093.namprd11.prod.outlook.com (2603:10b6:610:139::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.25; Sun, 6 Aug
 2023 08:44:47 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.025; Sun, 6 Aug 2023
 08:44:46 +0000
Message-ID: <7df23a0d-e2a6-71a7-7641-6363f4905f5c@intel.com>
Date:   Sun, 6 Aug 2023 16:44:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 11/19] KVM:VMX: Emulate read and write to CET MSRs
To:     Sean Christopherson <seanjc@google.com>,
        Chao Gao <chao.gao@intel.com>
CC:     <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-12-weijiang.yang@intel.com>
 <ZMyJIq4CgXxudJED@chao-email> <ZM1tNJ9ZdQb+VZVo@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZM1tNJ9ZdQb+VZVo@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1P15301CA0066.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::14) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH3PR11MB8093:EE_
X-MS-Office365-Filtering-Correlation-Id: af4c8869-f5a7-4567-6ede-08db965962f9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VX1S/BfluUwf/5Z4jXDODAkO+fzC2/gsmMbsUoqezV1FY8wXFEcSIdvgYP7Z2N/iOZzhIzu9s/SKKwyDUU0T8P+/OaeogKIPeh3ZmNi7O/S25U02n2v6kZn0RdYaNBwGKtoW30Uln/jU9DoG2xy4YzxHGEvTB/0eCUJXLMXEE/q+7zmTAOjryJUYBT5g8XTN4J6Q7bEMfl8cYUBXg1b4TThfLR5YSXlljeIvro/oRFtlKWEf4kvEGk3a5rrDd7u90Cs+M/iTtGLsHHPj7zZHtfbfXOdRiCY3pLWbIJ0WHk+sbR7ZR6ZM5tkUNPFb+W/1s4r7+aQEFu0NzjJXs0C+A8/i5IB9/+PWNQuPPWhKwY3XpS1krejfdVZPXKOW+wjhQUu4s4j7ml0IxwTD3rLz1JUm8wERn5zBEeg0v1FpR7tvJrGjrNFEmP2XbQ6PRcvAzRSdiNdfR+WfHi5I4YnC1e4lvwdma5ZkMh+3xgAbiyRpuGDNqVycMFxvoGO0ZdYkR48bL/E8xXn9cCQfVTSSKwbl2PgmREClbUHu3+RZoaQ+yMdxQ7N9o/9VrggAq+UtbXOcILZ6H/sZWkLoVaIdRGAAByxFQ/Dl1pvU+iy7PhUQULaD2tGmd2gX0w+suhsZuCo2/zG8l4Bt5Jz34uHq6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199021)(186006)(1800799003)(86362001)(31696002)(41300700001)(53546011)(478600001)(6506007)(26005)(8936002)(8676002)(38100700002)(6486002)(6666004)(30864003)(2616005)(5660300002)(83380400001)(36756003)(2906002)(110136005)(31686004)(316002)(66556008)(66476007)(66946007)(6636002)(4326008)(6512007)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekpNSFhwb1dEcXBObnlROE9qQ0czb0dYTGpFNkxJUExMWDhEZlVpVjNxRGZz?=
 =?utf-8?B?SW9UVmRwOVRheWwvWHZmSHJZQ1MrUi9qVXlQSkVCRGpiV2RYU2tXOUUvK0cy?=
 =?utf-8?B?ZU1USXRFa3MrZUtxZ1pvbnNhZkFuOWsyS3dUNXBjRGFrVXRVQjlDVDBNL3U0?=
 =?utf-8?B?M0krUE8wMHJneDB3YUp2VzFzQi9Cd2tNRS93QnpLV29EcUZoRlRRRzI0SnBY?=
 =?utf-8?B?SnJwUUFjTUVZUENSY3IzajBTVmZmanhKRkdvRGVrdWplM3NvVCtzVGFSZUFJ?=
 =?utf-8?B?ai9sUlF5ME5CMTk4OHY4d3gwV0IrU0RPSkFqOWgwMUNrYURPSVBzemRCRVZr?=
 =?utf-8?B?WlRCbWFCTEJMOVpZZXNoS0YwSkY1S3RackEzcVpnQ3hWSWtSdXVTQnVLV0Fo?=
 =?utf-8?B?Vmg4ZTh3aUNxUHhSQkVRTVpTQ3pZMC9sSWpVdUNWSmx1My9XS1VPaW8wU0Rt?=
 =?utf-8?B?U2xrdmtFOUVlN1lIaHE3TjZhNUs4VE1ZOEhlSzEwd2VkaXM5dHNZMVQ0Wjg4?=
 =?utf-8?B?amlGWUhQamRjeHRjcWV6QU51Q2ErU3F4dkIySEVycm14YTliZG1WRnRlV1dO?=
 =?utf-8?B?TkNWZjNQd25yc3RVQndyb2RPczkxOWszRVVTcEpXc0VYbmExcmI0WFdqdnRF?=
 =?utf-8?B?S1lGTTdIZEVVdzNHYU5zUkpQSlhWZ1BneWVHdjlHcmRTL1gzM1FGa2hRaXVh?=
 =?utf-8?B?aCtpakZZeXd3WVp5YmVYVG55em9sZHNkQ3JFRmcvTEg0TlI4QmltK2pWY2dQ?=
 =?utf-8?B?bjBwTVZtTzlYM0t4Z3hQRzBHcTVwMEFXdkNWTFYzOFJvYTRjMGhnWU92WE5Z?=
 =?utf-8?B?VnZrRnh5dC90TUJjSmQ0MFBqUFhGK2gyZmdyMFFpMFZuRTgwSzhoMkREWVpP?=
 =?utf-8?B?UEJVbHJsRFpYSm1zaVYrcW9YcUp5Vis1eWVIRDNTcWFYaUp3YzJJbVlXdmtY?=
 =?utf-8?B?V3FMT3llUzBHTnk4WVpzVTdKajN1S1d6RUxYNldQSnlyQndKU0lrb05BQWNE?=
 =?utf-8?B?MHE2b0pmYlNIREhpRndSMjA5dzU4SmZyVlJvT1JEenB1VUpDcENvK3ZIcTZi?=
 =?utf-8?B?dTR4ZHYyRmRmYjBOZUFlelA2Q25NSHNtRTd2cDIwQ1JhR1cvODQ3UDBBZVV5?=
 =?utf-8?B?QmVSazZrdlp4ZjErOGJndFJ0Tkk5RE1iU0hzbWlTVG4xWUY1NEYwbnMwa1VF?=
 =?utf-8?B?K3kyYTFPbWFFU2hGUy9XT1U0K2RyVWJpbWt5NE5zWjRSTTBDZjZ2V2ROWjVK?=
 =?utf-8?B?OXpPQUtBVHMyV2pIK3JvTEg3eEdhR2dCMkttQ3BUZWFORDRPTDd3am9aYkZG?=
 =?utf-8?B?U25raDB5TGF5T2c0T3dGYUd3NGtjS05ubDVRTjgwNnhCNVdubDhUNnRva25Z?=
 =?utf-8?B?V2pkKytMOWNxUFQ0K3NBS0dneDM2TldCWkNIN1plVncrUXJtQU1zYkxoY2Q4?=
 =?utf-8?B?cW5qU01vVjA4Zm1DenJvZWpSRVZFUUYxQUpYZUxLdEhJd1VGV0I1a1cxZS9a?=
 =?utf-8?B?ZU1iblMzc044UUdwZkpFOTN2S1J2b1Vnd0JiUjdlbUdIRm5IQ2thU0RJdDdv?=
 =?utf-8?B?U2hsT0VMYjViaWxnQkN2UE9mQk05TWd4ZUdTT29mSy9ITWlCNkdZTUE0VmFw?=
 =?utf-8?B?eXQ2Rzc3N0JBeFMwVnRDRkhhUXBhSU9NZGFPVHplT0w1d3UwWERtV0JzNmY4?=
 =?utf-8?B?bG5KSzdtRG5XRk5qclV0aCs2OUJGQ2xVQklEekhlSHFRMGpES0s3ai9ZSk02?=
 =?utf-8?B?Tkg3Z1VSakdyODJ5NC9zWks3ZGdINWdoa1AvcHdqNWtjRXNEQkxTWnBxSlZi?=
 =?utf-8?B?VWo3b05qMHBrM0RHSU5IWG5EOXdGYlRMVTk0K2dzSXNTdWpMVnAvL3M5SGQ0?=
 =?utf-8?B?a3BYUzl1OXFUdHZVZVNzSEUzS05XdXVIR2o1bjU4OXRFYjI2UUh0S0k5cmpr?=
 =?utf-8?B?RENrTnB3TkNTU1JubURLeEhmOUpqQ0d5SDNXZU4yQWFWVklPZWpycDlPQUFl?=
 =?utf-8?B?RVRYb29RdDVGS0tWOXBoclNRRzlaRlgyQkxCaDRUaDVGbzJTV2ZpeWczOWw4?=
 =?utf-8?B?anc2ZjJJYTBLK3ZKTVN0a3Bob3RqVDZTUE1GUzhWdHBNQzZpL0dEdDVMamtL?=
 =?utf-8?B?Yml6WU1sWFNGR1ZPU0hIKy9SVzhoandJNVc3MWNrbmJaVG55bC9rbTloTlFx?=
 =?utf-8?B?ZFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: af4c8869-f5a7-4567-6ede-08db965962f9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2023 08:44:46.2898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FcnZL6SXImk4CsVY5ftkB8mv8NA7s2fs0cMYjBBJobTd7RWGc1rXz98H9HtygHdQBSW2DH3w0ihquP3XiIt4ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8093
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/2023 5:27 AM, Sean Christopherson wrote:
> On Fri, Aug 04, 2023, Chao Gao wrote:
>> On Thu, Aug 03, 2023 at 12:27:24AM -0400, Yang Weijiang wrote:
>>> Add emulation interface for CET MSR read and write.
>>> The emulation code is split into common part and vendor specific
>>> part, the former resides in x86.c to benefic different x86 CPU
>>> vendors, the latter for VMX is implemented in this patch.
>>>
>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>> ---
>>> arch/x86/kvm/vmx/vmx.c |  27 +++++++++++
>>> arch/x86/kvm/x86.c     | 104 +++++++++++++++++++++++++++++++++++++----
>>> arch/x86/kvm/x86.h     |  18 +++++++
>>> 3 files changed, 141 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index 6aa76124e81e..ccf750e79608 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -2095,6 +2095,18 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>> 		else
>>> 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>>> 		break;
>>> +	case MSR_IA32_S_CET:
>>> +	case MSR_KVM_GUEST_SSP:
>>> +	case MSR_IA32_INT_SSP_TAB:
>>> +		if (kvm_get_msr_common(vcpu, msr_info))
>>> +			return 1;
>>> +		if (msr_info->index == MSR_KVM_GUEST_SSP)
>>> +			msr_info->data = vmcs_readl(GUEST_SSP);
>>> +		else if (msr_info->index == MSR_IA32_S_CET)
>>> +			msr_info->data = vmcs_readl(GUEST_S_CET);
>>> +		else if (msr_info->index == MSR_IA32_INT_SSP_TAB)
>>> +			msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
>> This if-else-if suggests that they are focibly grouped together to just
>> share the call of kvm_get_msr_common(). For readability, I think it is better
>> to handle them separately.
>>
>> e.g.,
>> 	case MSR_IA32_S_CET:
>> 		if (kvm_get_msr_common(vcpu, msr_info))
>> 			return 1;
>> 		msr_info->data = vmcs_readl(GUEST_S_CET);
>> 		break;
>>
>> 	case MSR_KVM_GUEST_SSP:
>> 		if (kvm_get_msr_common(vcpu, msr_info))
>> 			return 1;
>> 		msr_info->data = vmcs_readl(GUEST_SSP);
>> 		break;
> Actually, we can do even better.  We have an existing framework for these types
> of prechecks, I just completely forgot about it :-(  (my "look at PAT" was a bad
> suggestion).
>
> Handle the checks in __kvm_set_msr() and __kvm_get_msr(), i.e. *before* calling
> into vendor code.  Then vendor code doesn't need to make weird callbacks.
I see, will change it, thank you!
>>> int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>> {
>>> 	u32 msr = msr_info->index;
>>> @@ -3981,6 +4014,45 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>> 		vcpu->arch.guest_fpu.xfd_err = data;
>>> 		break;
>>> #endif
>>> +#define CET_EXCLUSIVE_BITS		(CET_SUPPRESS | CET_WAIT_ENDBR)
>>> +#define CET_CTRL_RESERVED_BITS		GENMASK(9, 6)
> Please use a single namespace for these #defines, e.g. CET_CTRL_* or maybe
> CET_US_* for everything.
OK.
>>> +#define CET_SHSTK_MASK_BITS		GENMASK(1, 0)
>>> +#define CET_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | \
>>> +					 GENMASK_ULL(63, 10))
>>> +#define CET_LEG_BITMAP_BASE(data)	((data) >> 12)
> Bah, stupid SDM.  Please spell out "LEGACY", I though "LEG" was short for "LEGAL"
> since this looks a lot like a page shift, i.e. getting a pfn.
Sure :-)
>>> +static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
>>> +				      struct msr_data *msr)
>>> +{
>>> +	if (is_shadow_stack_msr(msr->index)) {
>>> +		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
>>> +			return false;
>>> +
>>> +		if (msr->index == MSR_KVM_GUEST_SSP)
>>> +			return msr->host_initiated;
>>> +
>>> +		return msr->host_initiated ||
>>> +			guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>>> +	}
>>> +
>>> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
>>> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
>>> +		return false;
>>> +
>>> +	return msr->host_initiated ||
>>> +		guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||
>>> +		guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> Similar to my suggestsion for XSS, I think we drop the waiver for host_initiated
> accesses, i.e. require the feature to be enabled and exposed to the guest, even
> for the host.
I saw Paolo shares different opinion on this, so would hold on for a while...
>>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>>> index c69fc027f5ec..3b79d6db2f83 100644
>>> --- a/arch/x86/kvm/x86.h
>>> +++ b/arch/x86/kvm/x86.h
>>> @@ -552,4 +552,22 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>>> 			 unsigned int port, void *data,  unsigned int count,
>>> 			 int in);
>>>
>>> +/*
>>> + * Guest xstate MSRs have been loaded in __msr_io(), disable preemption before
>>> + * access the MSRs to avoid MSR content corruption.
>>> + */
>> I think it is better to describe what the function does prior to jumping into
>> details like where guest FPU is loaded.
OK, will do it, thanks!
>> /*
>>   * Lock and/or reload guest FPU and access xstate MSRs. For accesses initiated
>>   * by host, guest FPU is loaded in __msr_io(). For accesses initiated by guest,
>>   * guest FPU should have been loaded already.
>>   */
>>> +static inline void kvm_get_xsave_msr(struct msr_data *msr_info)
>>> +{
>>> +	kvm_fpu_get();
>>> +	rdmsrl(msr_info->index, msr_info->data);
>>> +	kvm_fpu_put();
>>> +}
>>> +
>>> +static inline void kvm_set_xsave_msr(struct msr_data *msr_info)
>>> +{
>>> +	kvm_fpu_get();
>>> +	wrmsrl(msr_info->index, msr_info->data);
>>> +	kvm_fpu_put();
>>> +}
>> Can you rename functions to kvm_get/set_xstate_msr() to align with the comment
>> and patch 6? And if there is no user outside x86.c, you can just put these two
>> functions right after the is_xstate_msr() added in patch 6.
OK, maybe I added the helpers in this patch duo to compilation error "function is defined but not used".
> +1.  These should also assert that (a) guest FPU state is loaded and
Do you mean something like this:
WARN_ON_ONCE(!vcpu->arch.guest_fpu->in_use) or  KVM_BUG_ON()
added in the helpers?
> (b) the MSR
> is passed through to the guest.  I might be ok dropping (b) if both VMX and SVM
> passthrough all MSRs if they're exposed to the guest, i.e. not lazily passed
> through.
I'm OK to add the assert if finally all the CET MSRs are passed through directly.
> Sans any changes to kvm_{g,s}et_xsave_msr(), I think this?  (completely untested)
>
>
> ---
>   arch/x86/kvm/vmx/vmx.c |  34 +++-------
>   arch/x86/kvm/x86.c     | 151 +++++++++++++++--------------------------
>   2 files changed, 64 insertions(+), 121 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 491039aeb61b..1211eb469d06 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2100,16 +2100,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>   		break;
>   	case MSR_IA32_S_CET:
> +		msr_info->data = vmcs_readl(GUEST_S_CET);
> +		break;
>   	case MSR_KVM_GUEST_SSP:
> +		msr_info->data = vmcs_readl(GUEST_SSP);
> +		break;
>   	case MSR_IA32_INT_SSP_TAB:
> -		if (kvm_get_msr_common(vcpu, msr_info))
> -			return 1;
> -		if (msr_info->index == MSR_KVM_GUEST_SSP)
> -			msr_info->data = vmcs_readl(GUEST_SSP);
> -		else if (msr_info->index == MSR_IA32_S_CET)
> -			msr_info->data = vmcs_readl(GUEST_S_CET);
> -		else if (msr_info->index == MSR_IA32_INT_SSP_TAB)
> -			msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
> +		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
>   		break;
>   	case MSR_IA32_DEBUGCTLMSR:
>   		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
> @@ -2432,25 +2429,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		else
>   			vmx->pt_desc.guest.addr_a[index / 2] = data;
>   		break;
> -	case MSR_IA32_PL0_SSP ... MSR_IA32_PL2_SSP:
> -		if (kvm_set_msr_common(vcpu, msr_info))
> -			return 1;
> -		if (data) {
> -			vmx_disable_write_intercept_sss_msr(vcpu);
> -			wrmsrl(msr_index, data);
> -		}
> -		break;
>   	case MSR_IA32_S_CET:
> +		vmcs_writel(GUEST_S_CET, data);
> +		break;
>   	case MSR_KVM_GUEST_SSP:
> +		vmcs_writel(GUEST_SSP, data);
> +		break;
>   	case MSR_IA32_INT_SSP_TAB:
> -		if (kvm_set_msr_common(vcpu, msr_info))
> -			return 1;
> -		if (msr_index == MSR_KVM_GUEST_SSP)
> -			vmcs_writel(GUEST_SSP, data);
> -		else if (msr_index == MSR_IA32_S_CET)
> -			vmcs_writel(GUEST_S_CET, data);
> -		else if (msr_index == MSR_IA32_INT_SSP_TAB)
> -			vmcs_writel(GUEST_INTR_SSP_TABLE, data);
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
>   		break;
>   	case MSR_IA32_PERF_CAPABILITIES:
>   		if (data && !vcpu_to_pmu(vcpu)->version)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7385fc25a987..75e6de7c9268 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1838,6 +1838,11 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
>   }
>   EXPORT_SYMBOL_GPL(kvm_msr_allowed);
>   
> +#define CET_US_RESERVED_BITS		GENMASK(9, 6)
> +#define CET_US_SHSTK_MASK_BITS		GENMASK(1, 0)
> +#define CET_US_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | GENMASK_ULL(63, 10))
> +#define CET_US_LEGACY_BITMAP_BASE(data)	((data) >> 12)
> +
>   /*
>    * Write @data into the MSR specified by @index.  Select MSR specific fault
>    * checks are bypassed if @host_initiated is %true.
> @@ -1897,6 +1902,35 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
>   
>   		data = (u32)data;
>   		break;
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:
> +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
> +		    !guest_can_use(vcpu, X86_FEATURE_IBT))
> +		    	return 1;
> +		if (data & CET_US_RESERVED_BITS)
> +			return 1;
> +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
> +		    (data & CET_US_SHSTK_MASK_BITS))
> +			return 1;
> +		if (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
> +		    (data & CET_US_IBT_MASK_BITS))
> +			return 1;
> +		if (!IS_ALIGNED(CET_US_LEGACY_BITMAP_BASE(data), 4))
> +			return 1;
> +
> +		/* IBT can be suppressed iff the TRACKER isn't WAIT_ENDR. */
> +		if ((data & CET_SUPPRESS) && (data & CET_WAIT_ENDBR))
> +			return 1;
> +		break;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
> +	case MSR_KVM_GUEST_SSP:
> +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
> +			return 1;
> +		if (is_noncanonical_address(data, vcpu))
> +			return 1;
> +		if (!IS_ALIGNED(data, 4))
> +			return 1;
> +		break;
>   	}
>   
>   	msr.data = data;
> @@ -1940,6 +1974,17 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
>   		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
>   			return 1;
>   		break;
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:
> +		if (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
> +		    !guest_can_use(vcpu, X86_FEATURE_SHSTK))
> +			return 1;
> +		break;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
> +	case MSR_KVM_GUEST_SSP:
> +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
> +			return 1;
> +		break;
>   	}
>   
>   	msr.index = index;
> @@ -3640,47 +3685,6 @@ static bool kvm_is_msr_to_save(u32 msr_index)
>   	return false;
>   }
>   
> -static inline bool is_shadow_stack_msr(u32 msr)
> -{
> -	return msr == MSR_IA32_PL0_SSP ||
> -		msr == MSR_IA32_PL1_SSP ||
> -		msr == MSR_IA32_PL2_SSP ||
> -		msr == MSR_IA32_PL3_SSP ||
> -		msr == MSR_IA32_INT_SSP_TAB ||
> -		msr == MSR_KVM_GUEST_SSP;
> -}
> -
> -static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
> -				      struct msr_data *msr)
> -{
> -	if (is_shadow_stack_msr(msr->index)) {
> -		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> -			return false;
> -
> -		/*
> -		 * This MSR is synthesized mainly for userspace access during
> -		 * Live Migration, it also can be accessed in SMM mode by VMM.
> -		 * Guest is not allowed to access this MSR.
> -		 */
> -		if (msr->index == MSR_KVM_GUEST_SSP) {
> -			if (IS_ENABLED(CONFIG_X86_64) && is_smm(vcpu))
> -				return true;
> -
> -			return msr->host_initiated;
> -		}
> -
> -		return msr->host_initiated ||
> -			guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> -	}
> -
> -	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> -	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> -		return false;
> -
> -	return msr->host_initiated ||
> -		guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||
> -		guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> -}
>   
>   int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   {
> @@ -4036,46 +4040,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		vcpu->arch.guest_fpu.xfd_err = data;
>   		break;
>   #endif
> -#define CET_EXCLUSIVE_BITS		(CET_SUPPRESS | CET_WAIT_ENDBR)
> -#define CET_CTRL_RESERVED_BITS		GENMASK(9, 6)
> -#define CET_SHSTK_MASK_BITS		GENMASK(1, 0)
> -#define CET_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | \
> -					 GENMASK_ULL(63, 10))
> -#define CET_LEG_BITMAP_BASE(data)	((data) >> 12)
>   	case MSR_IA32_U_CET:
> -	case MSR_IA32_S_CET:
> -		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
> -			return 1;
> -		if (!!(data & CET_CTRL_RESERVED_BITS))
> -			return 1;
> -		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
> -		    (data & CET_SHSTK_MASK_BITS))
> -			return 1;
> -		if (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
> -		    (data & CET_IBT_MASK_BITS))
> -			return 1;
> -		if (!IS_ALIGNED(CET_LEG_BITMAP_BASE(data), 4) ||
> -		    (data & CET_EXCLUSIVE_BITS) == CET_EXCLUSIVE_BITS)
> -			return 1;
> -		if (msr == MSR_IA32_U_CET)
> -			kvm_set_xsave_msr(msr_info);
> -		break;
> -	case MSR_KVM_GUEST_SSP:
> -	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
> -		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
> -			return 1;
> -		if (is_noncanonical_address(data, vcpu))
> -			return 1;
> -		if (!IS_ALIGNED(data, 4))
> -			return 1;
> -		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
> -		    msr == MSR_IA32_PL2_SSP) {
> -			vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP] = data;
> -			if (!vcpu->arch.cet_sss_active && data)
> -				vcpu->arch.cet_sss_active = true;
> -		} else if (msr == MSR_IA32_PL3_SSP) {
> -			kvm_set_xsave_msr(msr_info);
> -		}
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		kvm_set_xsave_msr(msr_info);
>   		break;
>   	default:
>   		if (kvm_pmu_is_valid_msr(vcpu, msr))
> @@ -4436,17 +4403,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		break;
>   #endif
>   	case MSR_IA32_U_CET:
> -	case MSR_IA32_S_CET:
> -	case MSR_KVM_GUEST_SSP:
> -	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
> -		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
> -			return 1;
> -		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
> -		    msr == MSR_IA32_PL2_SSP) {
> -			msr_info->data = vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP];
> -		} else if (msr == MSR_IA32_U_CET || msr == MSR_IA32_PL3_SSP) {
> -			kvm_get_xsave_msr(msr_info);
> -		}
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		kvm_get_xsave_msr(msr_info);
>   		break;
>   	default:
>   		if (kvm_pmu_is_valid_msr(vcpu, msr))
> @@ -7330,9 +7288,13 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>   		break;
>   	case MSR_IA32_U_CET:
>   	case MSR_IA32_S_CET:
> +		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> +		    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> +			return;
> +		break;
>   	case MSR_KVM_GUEST_SSP:
>   	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
> -		if (!kvm_is_cet_supported())
> +		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
>   			return;
>   		break;
>   	default:
> @@ -9664,13 +9626,8 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>   		kvm_caps.supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
>   	}
>   	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
> -		u32 eax, ebx, ecx, edx;
> -
> -		cpuid_count(0xd, 1, &eax, &ebx, &ecx, &edx);
>   		rdmsrl(MSR_IA32_XSS, host_xss);
>   		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
> -		if (ecx & XFEATURE_MASK_CET_KERNEL)
> -			kvm_caps.supported_xss |= XFEATURE_MASK_CET_KERNEL;
>   	}
>   
>   	rdmsrl_safe(MSR_EFER, &host_efer);
>
> base-commit: efb9177acd7a4df5883b844e1ec9c69ef0899c9c
The code looks good to me except the handling of MSR_KVM_GUEST_SSP,
non-host-initiated read/write should be prevented.

