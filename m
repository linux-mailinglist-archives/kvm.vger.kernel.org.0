Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F5773F8B1
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 11:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjF0J1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 05:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjF0J05 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 05:26:57 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BC02109
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 02:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687858014; x=1719394014;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0AR2PmQw68vTNHPnCWtopbF+saq8Y/b19y3YAH3AGaA=;
  b=RJXOl8XJWK08mUjP7bMqIpZR56Cn9evUe/2Iu3TYDy4wosk6HlrzRGNR
   xlDZWrOlTFNP5d8t0KTpQCrRoUZW0t2K3fpSvkUphbqb39il5/vWqiwPo
   I90wbWF54sRhT2GTt+IW0YEGWmbdmQgHxB+pvmxzGPx3pyLt2RMMgnizs
   FnWed5hyIClQPPB/LAqX/jUuV3FYH84nEZM7AdUmyusKM3UMM7pTQHQbn
   kzJQ9+G5Dn23UB7dSiinBiIg8HmCRVs+OkCyVGsFAvAGmSpHmf2RUxteq
   IBxtimL/1mJM8h4J9tn1n4RAuyz6dXlWIzZpOW54LaTYyugCGZUfVGVxf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="341112671"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="341112671"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 02:26:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="746133753"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="746133753"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 27 Jun 2023 02:26:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 02:26:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 02:26:53 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 27 Jun 2023 02:26:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjnzk2I1xGHybBB8Tb41cGINjDQ91r/C8tiBwqxKuh56d4axgw21IKDihn8/bCNGlXFBodKzNzEz4eSOFKBxgSoK6h4IlE7qESSu0pGSVDJxYfIoW5fwwT0jEbFI6NeJhWr5+HWcHY9jpZWC9hTl+yiTlZFdop1jQ7bh8dLsXsL0Dfs0NEaTXY83AIUZjWv7hY2xbaFeGr1C7hVSXIRYZSIBhbPoNIJBULkKFrc5RDSk8xF8IEGnp+sCNbg6pe0kjVOhpmSSqWk1VOGZYB9NMcum4w/J9ffAi4+TWcmWuPVLCRnCYrMLARLJrr3kQhonx3lHqYLudX2N8cMiGe9/iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODHqgUOVW5tDmpyhYjnKLbENDpzCJyiohv8+6tN9fyE=;
 b=daKRdUlqHE4PUJ0cpHzSihEgHFuNnv+/TB9XrscSa6kNxD7rCsqKYL0iwgLkeVjYLnerJph1tO9mxemXj9lk8Cbq8jKFUyFr3eNVjtPILVs2McEBIPow1fAEdePRw0mlXaaXX7dgErdFWJUhyTmaoWEL87ElvorDWnwVuylgCDcYXD05heyZSevHnka9/RQDw/jskVGw9NRRHj6SDafxWxpaufvOvqBSWrV4WfbxDeThSJFHbcgqGa+Yyqy3J1HToON0nBa86YQN9QqJTFSGBpuWXRvKTyqZD1IW61y9t8eyUbiYr1l1WzhXEQ142RvxmYBZWSsWJAIzNrGybNMiqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB8228.namprd11.prod.outlook.com (2603:10b6:8:180::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Tue, 27 Jun
 2023 09:26:48 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6521.023; Tue, 27 Jun 2023
 09:26:48 +0000
Message-ID: <c19d87ed-387c-93a4-7b15-ba94e6763402@intel.com>
Date:   Tue, 27 Jun 2023 17:26:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 1/3] i386/cpuid: Decrease cpuid_i when skipping CPUID
 leaf 1F
To:     Xiaoyao Li <xiaoyao.li@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230613131929.720453-1-xiaoyao.li@intel.com>
 <20230613131929.720453-2-xiaoyao.li@intel.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20230613131929.720453-2-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR06CA0004.apcprd06.prod.outlook.com
 (2603:1096:4:186::20) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB8228:EE_
X-MS-Office365-Filtering-Correlation-Id: ed32a058-1f07-44c4-fdbb-08db76f0a19a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bcTeqDN0/5xLZcrXjIBudpmv67Hm/Ve3g0KqyVkojgLz4oNZoSqB0LQpPIOlPQNf42ZAh4ZHsjQYiHnoweWrr/MIWBR4nRjqwtJSBh/ylK7JDvxI70ZKJRRm0pnAb+3ZMggqOXLvvBa5JHHanQ7n7TJuwd7NTtPR2jhlx+NQzSvfspan7+nbvBFizqR8bMPrn9126ByRfIT+se6gW7HcFLIPVgThwCeS9cRciV8DXGSwTSQsIMM3wVAmkzfp4xLptVL01JldQ4tyYt8s6qBLEGJhs4qmvp79JsZ7zEK88f/xaqh+k87N9i4HnULm6qtopGRetiFQ6hAgsBo9y/jcyAszTCTyqRV8YPLwZwg4lE15y9G8C7pF8S5qvUk3WcgY6vCsbh9FRWbj0iGHFMMe1nAZ7KtgrY7hqwpfeKgmXmZAjSZGkD419jvWloQUjgSERwGcBHCHAOJIb/f3ScWO3YuP01H1iOea2nisUgbe50nV9SaYNhYkYaidpcaLXJFPlRV3yCjkWHxyzM6ousUlEN1TVtUDF2x3/W2QzHKcz7Qz/B8b/z4HMGBys7ZtaTJ16iIsCALAlZ5hMAlmK1n3zUwGjsF71dzoJykP2OYItxmAf26JvGL6oZY7TjwBLqjUZRwto0P4pANFJw+WEU6FRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199021)(2906002)(4744005)(186003)(6486002)(82960400001)(38100700002)(2616005)(6666004)(6506007)(6512007)(53546011)(26005)(37006003)(31696002)(41300700001)(54906003)(86362001)(316002)(478600001)(36756003)(66556008)(4326008)(66946007)(66476007)(6636002)(31686004)(5660300002)(8676002)(8936002)(6862004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmpkUEg5UmVhakM3VmQ4OWRiUWxQNnRXT1c1S1lZdkFkc2puQXVzNnlOMlVj?=
 =?utf-8?B?Mjg3TUtrMDdrdmJHVEtacUFhYjhKc09lRUVHeXFnblRTdzlIbEd2aWtQM2RU?=
 =?utf-8?B?WmlMN3JZL2ltaDJyZExPcTRmRXdqV3orWC9NYitiZUd2Z1VHOUhNYXFVTVFX?=
 =?utf-8?B?NkxoYVFkeUtEbFpxUkd5dGg2NDZYd3BENVQwMXBTNFNsejRNSjN6SzIvTTVv?=
 =?utf-8?B?T3dTTEplbVRzdmx3WUFQWEdjSGlSVUtDTGxEb1dsZGN0N0dpa3dkeXdFc2NM?=
 =?utf-8?B?dThaZm9QTFhWcENBVExLRTFPV2RUK2VKb3VWdmF0TWdtclh2OXNlVTRZRWYv?=
 =?utf-8?B?clhXVmpyL2xUTThvZ044aGNaM2FYWVdJdVNFZGwyRUR0S1ZPSTR3aHk1TFYw?=
 =?utf-8?B?NitKL2g4RXlGblovcmF5dFh3cldFYzc5ZTVmY3Erbmgvdk5ZMm1NenJPUzQv?=
 =?utf-8?B?VkxBN2pDbkE3eWgrQTc1TUtSN0puRmNpcEtPSHJEVW1FMEE2VEVPZXJGNlFO?=
 =?utf-8?B?dGRhWENRTDRXNkdPZGEvQ1BhNGF6dHNld0dCbG9rYjVFa1k0ZUF1WUU4cXFW?=
 =?utf-8?B?TGQxVVN3aGNHMWRBRVFkbysweDhSaDR4ekJnQUtkZEl4S3F1S2UwY2N3enU3?=
 =?utf-8?B?TnVsWUxIckJvN1dCU1pkazFwQzhRQUNjM0VaLzY4SHpMemhLZEROZHZEMzFR?=
 =?utf-8?B?WUVXV0pHcnFlc0hvZFZtVGx0S2grNFNOTXBIR09rYW0xZmp6TzlxZ3dndXQz?=
 =?utf-8?B?aGFPdDNXNjVBNklVNGZVa0hhUUdVc3BNaVViRGtIZ1I0eVdSck9zTVVFUGQz?=
 =?utf-8?B?aTIvcm84OWIrdDcwY1pSWFNvcllFY1NpMWtKeU40N0t2QWs4VVYzNDlNb2o3?=
 =?utf-8?B?REZocm9WMUlFckZZQm1EZnJKT0E1QXRtMHdrcTV3clMyamVEMjcyQ0U3eDBt?=
 =?utf-8?B?YWxjV1JCaGZ6b29hOEI4RUlXZVZ0N3k2OG55N1pKY0lQZ2NFcXVDMTFSY3Qw?=
 =?utf-8?B?aUJjR0x1emZ2WmZTRUIxN3lMVG1SdXJNUEZFOHVsSmpmYm4xQUlIamtKaUdH?=
 =?utf-8?B?K0tMWnN2bXpwc0MyVEV3bzlQVFpXZ2pQUnV2b3ZYajRQNW9TYWVmNGpMY3RH?=
 =?utf-8?B?N1FCa05MSlhSbllIaTlQSzBXSVFsb0FGU04xeDhkTjBmT2huQVVFTmJpNWtL?=
 =?utf-8?B?Q0VUUXlkQWJhVDJwZ1BHQ0FlckxhTEdNN1RYdW11VlZTQms2US9vYTZlODRk?=
 =?utf-8?B?eVdqcWlHNkF3V0U4Um9ndkp1R09qaWZHRktwUWQxNk5lQ1BURU5QZEZZdzdU?=
 =?utf-8?B?UUUwMUtubWwvMG02L2RVVTlSTlJ4dmw0UTZqQWdyak1sc2taa1I0RFE2eU9B?=
 =?utf-8?B?aTNiV0tJLzZsTEpSekZJMjdkT2pUR3dZdDZhcmIxMFpVYWpSVGJHaWV5ZXlp?=
 =?utf-8?B?bGJDZXRZK2loSHJBSlo3bXVUb2hIYlZNWm9EUytkejhLWGFKMjUvdzZiN1o4?=
 =?utf-8?B?eXk4Y1d6aGkycWdNaUdpSUxoUmNEeHVnaGNWMGhrODMvbDVhb0JVbmxIUi9S?=
 =?utf-8?B?MVFpOGZTV052R3l3K0RDS3AvYTZZZERVb2RDL3pnMEt5NjZ5ZkNadGtsT1hk?=
 =?utf-8?B?dGQxWm9kMFVLQ2FjTGttU3d0dzU2WW04UWdrQnpNMHZQQzVueW8xV2psWnJn?=
 =?utf-8?B?RVE0UStreC8xbmhvK0hCTmRrVlloRkRSM1dTdks4YW5rWUgyNGljSmVCWXE4?=
 =?utf-8?B?VWVhZ25wbkY0NmVIOHREby85QjRjYkFvYlU2alVTSjFWaDk2K2d0b1ZLa2tZ?=
 =?utf-8?B?S3dkYmNTYStrZFJDaVpOV2p3RmhIdXA2Z2FFV0lGL0FqMEdKdEJCK2dPWjdX?=
 =?utf-8?B?c2phVWZuU0paSjdMSkVUdWJtdDZsNUtWaGhPNCtmYUsyMmxIaWYrTk83cXNm?=
 =?utf-8?B?WGdCZER3KzR5Q0pNTlNEZ1FLd0E4Q1pDUkV5ejNSRllpbTJWTXJFYjFlRkZ1?=
 =?utf-8?B?dWhSUnd1SFdkcjRJQmV6WGM2TFdtS2EzeHZDOG9uRk1ZQW44QjBvZW5SVzdj?=
 =?utf-8?B?b2MyOW9MdUxKakh5NlRHSXNUN2tyazlYbWk2V2tCdmdheW5vV2MvYlVGbGlG?=
 =?utf-8?B?MnNaV0JMNHFrSmFNbnFaWmR5TUxQRm5FNS9LWlRMMEZCdDVOaVE5RGZVUmNn?=
 =?utf-8?B?TGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ed32a058-1f07-44c4-fdbb-08db76f0a19a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2023 09:26:48.2795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Q38DxlfRLZ/bWeuxo0LYI70a8vHUjtX8/rN4AXuKh4FYqVYOSFVCKGvjklb1mr3EXjJeVi8EDnGGXX/3mS0ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8228
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/13/2023 9:19 PM, Xiaoyao Li wrote:
> Decrease array index cpuid_i when CPUID leaf 1F is skipped, otherwise it
> will get an all zero'ed CPUID entry with leaf 0 and subleaf 0. It
> conflicts with correct leaf 0.

Maybe change the commit log like this:

Exiting code misses a decrement of cpuid_i when skip left 0x1F, so 
there's a blank CPUID

entry(with all fields stuffed 0s) left in the CPUID array.  Fix the 
issue to avoid the blank slot.

Reviewed-by:Yang Weijiang <weijiang.yang@intel.com>

>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   target/i386/kvm/kvm.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index de531842f6b1..afa97799d89a 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -1956,6 +1956,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>           }
>           case 0x1f:
>               if (env->nr_dies < 2) {
> +                cpuid_i--;
>                   break;
>               }
>               /* fallthrough */
