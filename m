Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA49682D84
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 14:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjAaNOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 08:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjAaNOQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 08:14:16 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BF6272C;
        Tue, 31 Jan 2023 05:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675170856; x=1706706856;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qy90fpgkVnIH6UfPBRdnfzhhLkShjMUIJSm7BLvwcEA=;
  b=cU3LpjCdhxZsol6jBBCjm6v5BwUIwxvPZsRkMg4dHcju1gWKjiCE/EB7
   VA70S6NuaAuq5vpmcN2ZWITLgqtlGcblh5rJ0VtZrxuVwTQ35gT85B6Oy
   WKqBVacNmCUUSlmwzheOG3slVG7tRAoe+FrmCn6UWVmDfxk6HrPcsfNlN
   9+v997U6zP5MIH8nZiLBHurOrqEDQp3TVedWQW4z4MSRV4ebJYAUtotTx
   z1RYRwjX6+Zx84/lOM20pu5pmh7xhlwIhmUfUUZlYVmm/eNb4azToaRKt
   QpZz6ILtIwJAG4NtNdOuLxPpXEU6E9T9w96lU8siNPfyQ6D6aCRfPNb81
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="414051261"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="414051261"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 05:14:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="772970922"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="772970922"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 31 Jan 2023 05:14:15 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 31 Jan 2023 05:14:15 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 31 Jan 2023 05:14:15 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 31 Jan 2023 05:14:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dU3mL9qPp2pbnzGYNGLpgWbsP5JxUqkw0s5L10tKBi9//h9zxFXhDSUyChckkRb2lkPQLLPxrTOSm/T89UacVXm3BnwEMxOFJee74Dg8QMaEXCVpD8QCViu29aZlFPVDK5oCnJ0Ge382MxT1b7QJvkNC/7P64iYDDbG+8J506o3FRlGDXI+VEehFLmPANvQfho4p6MjNP1ey+G9589ZwUcP5F644fmZ17lHhk+LvppO55ANM5NzV8oUpSd+XJRJXfcjszKGe6YcRTIXdWy7Zt65aN1hZBTHqf580XnWJ3ReZa3mYNWu+P2g0t7Gv1vQrvcpXBtnhEkMY9AQk1Ux7ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VjUXt/+1NWNGdHzaubFWq65uUdolWNLj25ROSHG/oB0=;
 b=atRvsttTVJl8Ew1cLsONqAH3xkujKgft6xH+ZV9+DW5CF2ZGMadTw+z2ohq+oNznlSF2BPJcaLllnu2kX5a0YiHJHqQ8gmODJOaraMs2fNvKZWjwtgh8cf086biJrO4pzI9zAQ2VSgTspu1fXiSX8f5FvZ8f7AzE6c64sHbVTb2TSnlntCjmgpNZE91IbWy9u49a5g49MQKrSlJZ1ZrD54KWAi6Edj7oq03jpIV5mJxWxBFYuvutoqNUC8ZiHKTOeIXWnRKL5ofnav/IDQJk+ZLiMAwb4REUXYmCyFBvCUu1fCjCjykqth0ennsZs77K65dujORLRGpIlXtBtI7JWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB7706.namprd11.prod.outlook.com (2603:10b6:806:32c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 13:14:12 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf%2]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 13:14:11 +0000
Message-ID: <1ec9fa76-7758-b67f-1695-177a5a573d6d@intel.com>
Date:   Tue, 31 Jan 2023 21:14:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
Subject: Re: [PATCH v2 14/15] KVM: x86: Add Arch LBR data MSR access interface
To:     Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-15-weijiang.yang@intel.com>
 <Y9RMbq1FgygCPRrZ@google.com>
 <f70ea782-c7d4-0997-88e0-c24768fd02a9@intel.com>
 <Y9f+nDdnk8fHXRZe@google.com>
Content-Language: en-US
In-Reply-To: <Y9f+nDdnk8fHXRZe@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0116.apcprd03.prod.outlook.com
 (2603:1096:4:91::20) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB7706:EE_
X-MS-Office365-Filtering-Correlation-Id: b1a000e8-84f0-4486-6b46-08db038d0aff
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O9HWQH2x0DMkkQQvIaXam784Lmg+2xks866RZLmGPzqqXGAim4Xh/GUUzyjxfct9sm9KhMhvtTschuMBQyCpkgDky7HqeiBpBfL/YdCDDMrxnVQOq2dzbItN3su3CZ6iT74EGJly5WyDzvywdylHOg4RAQG6ikkCfbYFzs89kmD/VquaKuDfhe9gbkQqN5aMsqM7BsaqfIy53h2yN1UT8UGvaZRP1bW5BHPomWxVo+0AAVOICbRH0Khkix5fVT2BECiW5GYdpNTQTODamLmsHIfL1fxb1CjGO4NlxaPFfSpJqJJKSOSTMStrxwYf9xoqEQ3MykpqQXW1fH3k0WqrfvDtf1Ll1ZEfKKfWlxwuE6FY29xZfbqsMN9AIwSr1eB1W/5wdXsOpShUxrGEXfvve59HrQoZ4pbaEU6kIv7iOX9X8xp0BZ8dh/2TXb8XsUiY+vOzwFSjOo6EVYjbxhTkn/4cllx75iwV63r/iSB3cnnr/2poIp9zvXYXifcaoCOWcxpeQuWorjp2BfKQ7TDLGtDQbZrTNgiUjDzghpDhUMmXhWDc5oXORdkECXjiBSte68K8dbxuScW8iO7UYzRS6C62h4NYLp1+Ji2AG/TI3EsL+TazoRsx641tofTcWXh2+dThR5LZG9W83R6pWgYPNXU6S8HrLALOuDVKKbHlAhfzSna2lxCRzCyPr9cDxL39GwfVtDu8ziYuMM2R+OUh6ilWiO9aL8fnIgavoKljq3UDesmyNMUhTMJ2xRKA5MFtlpwLD3OTZuLhfiA+GDqSJ9VCGV5UMAYDXqPcTONCGg0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199018)(8676002)(66556008)(6916009)(66476007)(66946007)(2616005)(83380400001)(316002)(6506007)(478600001)(6666004)(6486002)(53546011)(54906003)(6512007)(186003)(26005)(36756003)(38100700002)(86362001)(31686004)(2906002)(31696002)(4326008)(82960400001)(5660300002)(8936002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTJxZFZQYnhib252UUMvckRxbEpyTFNlY0xjcG1TRUhwanpGcVFVMlV2cERz?=
 =?utf-8?B?ZnBWdjlFSkpkZm9oVEQwaUtMeWdOWlJLZjg1RTNpdWFpSkxZb2tXU3RIMEZY?=
 =?utf-8?B?RW1zR0Z6aGlRWXQ4SE1taGx2U2NoZWx3Y05jVE9OK1p2VnQyWE9obThPTHc5?=
 =?utf-8?B?aVZhVFpuMndabG9ZUmIzelRQbEpWQ0xDclZLclMrQ3J0cHlucnN0NnhNWkpv?=
 =?utf-8?B?OURhcjVjSUpXb1FuRm5lUEFVM2RMbUtYZlZpL2w5czRlYUYrVGVsK2NiZ3BD?=
 =?utf-8?B?SWlQN1JPaDYxZ1hrRDIzSklETUNRWVlLaFNCK29nb05RNlpISjFoRlpoMHFt?=
 =?utf-8?B?cFV3RVZrSW02bGpzbndzQVVoMnFvSkR3UG5yN0xYUlIwQTIrWUljdW5WbHpj?=
 =?utf-8?B?ZzVESzZQc0phNndsZkl6SEVsVEZZUGhxazhEWHN6YWJUQkhzd01RQXdJSjVr?=
 =?utf-8?B?SFRyS0pWZFpvM0lzMUQ4WGJWeHhUVmQ3ZDlRT0owaGxtRnI2S0NFeDhJamlm?=
 =?utf-8?B?US9GNTlrd21HR1JnQmFVOFZsRkNRRk9LcElkS2Vuc0M0dDE5cFRPREVaRFhn?=
 =?utf-8?B?eitpb21TMEFtT0xDcEhpS2dQL1M0RXAvT3ZuVk1IOXhHN0RkUVU5eTBWcjJv?=
 =?utf-8?B?aTlQdzJNdmRDNVpMWWdKL01sbFUway8wME5ETkZEOXgwTll1SUQ5dllhZVdv?=
 =?utf-8?B?K2RSTldkdTliS3ZMbDNTTUdxQTFoL3JudXRFbmFNODEzQ29ka2Y4Sk52b1I2?=
 =?utf-8?B?ZVh4T29ObGo4SXl2OTE1cGxFY05vNWtNLzBjYzRoL3ZRWW1jMEMxcXBCbkcx?=
 =?utf-8?B?WnF2blVWV21JVFM5bG1uQ2VTaWNQZWJFRmxLcWJrZjFTemJEVngvcjFCYzUz?=
 =?utf-8?B?Z0VlMVdpVlc2aCtVVU4rdDVZYjBFQ1F5RkxZek5Zd0hHcHNidmxCU0NSS2Nm?=
 =?utf-8?B?Ym1JRWhxVjZzejQxN1RwM05IQ1dDVXZERWdtSTFuR1pCMFVSVUpQWHlPbHg0?=
 =?utf-8?B?ZnB1Nnd3UUFtSG5hOVd0bFhPOTBwemlhRTYrSllUSC9TVDhqMS9xSlpIRjJS?=
 =?utf-8?B?cmZQMUE4RTR4VDc1Uis0SHdlTk95SFM0cHNwUGN0bWtrYk5tRHExYTZzYkpq?=
 =?utf-8?B?eUJtRWJGQjEvanRWVnNPWGg2VzltU3BRVDJOVUIxVjFUZHU1Mm1ZbXdBdzNj?=
 =?utf-8?B?WUpwN1pkYVNxaXdmRVBXWHg5VVNZSnlXTU5BMEw0anRlemlucWk2RkdFVnAy?=
 =?utf-8?B?dU94UlFKaDVFdGhrUDA4cm5iUHZwc1VMY2RYbzQ0U0xNNHl2VnhPWEpxQlpG?=
 =?utf-8?B?d1pHNmVGSjJNcENVY3RSSUVkVkNpZzh5Y3JEY3lRV2Ntd0VGeDJKR3NnNEdk?=
 =?utf-8?B?MW11ZWxnbXJGWHVQdkNlNGFpcTlPT05HclpJbVlYbGRnRlhNNzdpbHB3NFMx?=
 =?utf-8?B?ZnJTMEVLNFE3dkk5S1NLckpIVk9VeDRXWjFGWTZwRUhlWmp5RG0xQzFoRGxF?=
 =?utf-8?B?dmtCd2ltWVYxL3FTeE1BMll5YU9jb2JIMjI0M1JZbWE0dTJzVnBpSmNQQ1Na?=
 =?utf-8?B?VWhiWHkrM3Q5S0NmU2MvYUNvYzB3Q3hqUmpYYkNTTGZVeHdyMWx1ZFdMSDMr?=
 =?utf-8?B?d1FYK2RSZVJ3Z0l2MUhBNkVsdVBwK1VJbStvSE12VlNzOVppcncyUWV3NlJq?=
 =?utf-8?B?bE03RkRhNXBDaWJlVlB0dUdPN1AraTZ3ZFFSRzFRMWV0cVE4anlrNHo3QVM4?=
 =?utf-8?B?VUFneEFpWld1SERka20xNTFBa21yOWExUmdWUmpPSzJzcFMrSVI0YmU2S0tN?=
 =?utf-8?B?SjlNdVVUWGk1TVk4blBGV0VmNUxGcHVaejRFTVFxK3ZDbjFMb1lCK3ozL0FC?=
 =?utf-8?B?S29vQ1BUd3JiR0kwOXc0anJEU3hnMzFBSmxtWkFKTmtSVDNudEVvak16RU9s?=
 =?utf-8?B?U2I1bGRLWVJrK2tDQzRuTitZMTJlajNvY3ZybGRuekdzOC9pemUrWkM4bVpV?=
 =?utf-8?B?MTFFRVF6cCtxWVNjWmpHVDQ3OHZIQ1FQSjFUWXlycWVjWWhVc0JwMS9HOE1D?=
 =?utf-8?B?cnZDbm9sZTMvbHU5R3JObE51MkJmb0NldFVNSnkvYll1STRONmp3WUtsQ3dz?=
 =?utf-8?B?RVV1UVFTRUplYkc2MnN5MFVGejE3eXliayt2eVZ1d2R2Uk14dG9ZWDRLM3pV?=
 =?utf-8?B?TFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a000e8-84f0-4486-6b46-08db038d0aff
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 13:14:11.6121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJsBUSSiSl59Z3b7VubHNYlfxCpHsU38zPWk4VU2X3k7vY00a1QUhyTTQfrC+u+iSfTB2ifJtMiKU3BSoKNN6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7706
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/31/2023 1:30 AM, Sean Christopherson wrote:
> On Mon, Jan 30, 2023, Yang, Weijiang wrote:
>> On 1/28/2023 6:13 AM, Sean Christopherson wrote:
>>> On Thu, Nov 24, 2022, Yang Weijiang wrote:
>>>> Arch LBR MSRs are xsave-supported, but they're operated as "independent"
>>>> xsave feature by PMU code, i.e., during thread/process context switch,
>>>> the MSRs are saved/restored with perf_event_task_sched_{in|out} instead
>>>> of generic kernel fpu switch code, i.e.,save_fpregs_to_fpstate() and
>>>> restore_fpregs_from_fpstate(). When vcpu guest/host fpu state swap happens,
>>>> Arch LBR MSRs are retained so they can be accessed directly.
>>>>
>>>> Signed-off-by: Yang Weijiang<weijiang.yang@intel.com>
>>>> Reviewed-by: Kan Liang<kan.liang@linux.intel.com>
>>>> ---
>>>>    arch/x86/kvm/vmx/pmu_intel.c | 10 ++++++++++
>>>>    1 file changed, 10 insertions(+)
>>>>
>>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>>>> index b57944d5e7d8..241128972776 100644
>>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>>>> @@ -410,6 +410,11 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>>    			msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
>>>>    		}
>>>>    		return 0;
>>>> +	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
>>>> +	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
>>>> +	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
>>>> +		rdmsrl(msr_info->index, msr_info->data);
>>> I don't see how this is correct.  As called out in patch 5:
>>>
>>>    : If for some magical reason it's safe to access arch LBR MSRs without disabling
>>>    : IRQs and confirming perf event ownership, I want to see a very detailed changelog
>>>    : explaining exactly how that magic works.
>> The MSR lists here are just for live migration. When arch-lbr is active,
>> these MSRs are passed through to guest.
> None of that explains how the guest's MSR values are guaranteed to be resident
> in hardware.

I ignored host *event* scheduling case in commit log.

My understanding is, host LBR *event* could break in at any point when 
the vCPU is running,

in this case disabling IRQs before read/write the MSRs is pointless 
because the HW context could have

been swapped. I need to do more investigation for the issue.


