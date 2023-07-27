Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E15B7648E6
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 09:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbjG0HjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 03:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbjG0HjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 03:39:08 -0400
Received: from mgamail.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77644EDA;
        Thu, 27 Jul 2023 00:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690442969; x=1721978969;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OG5022uiYZ127s2tdzBaOY/0tsVfnooKLaTylE2FBMU=;
  b=fdewdyCMMBcmF/7gOnINw1MUK82EtYTsYCXbGy7nX1yKqdBQus9vypBA
   Y0ra8PaiLlA+TlRE+YDEaxGR+MvOcvbwOKr0AwkV60I9hE8bFF/Qm7sGu
   hF9rSlDA6BFBeZLlLEDsaXu6OBwfZY5x9jiYddLlVUAFW3YzLKSUewJYW
   fCPKe6f2a00nl1r4B6Dyf6LkXxJSroIp5oL/FCQmvKPIvrq5IqZ574RL6
   43azsM+SDEs/Nj5S6lxUUDCPdNlExFPGTf9cq3bSOblWnlw3Cu4vtCl+l
   2k4ialFaCeHYOimET/wJoGYPFqkTn/DynvjnXayJq93nRLlwScq8TIDqC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="347844002"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="347844002"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2023 00:29:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="756549389"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="756549389"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 27 Jul 2023 00:29:29 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 00:29:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 27 Jul 2023 00:29:28 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 27 Jul 2023 00:29:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPlYO4Vsa44uSi+2T8dCxuT9/1JGI+e+a7AQ8cs4oKNcE8lF/zx2FrooCXz2YbEWYRTnj1oNNeNqArWMOeeUsEwrsCkQD4uE0ZmdeP6bi6+M3lgdvJUB2r3pFQsq8jfybQXs2xlJlS7wVcjF1cH0SM8jfD1apCfFpORtjUrAWA6BUHAUCW6BvL2WT244pjr1B1YFH3E+7w/eoZeAfPFHZ9fyIsepCCjUBv8pqjhgFPOT7Hws57DPzeKasBTslwknTwpcUy+WYENAYEgBw0SYyA6q6aZLXtMi8oZmCDxNYmSchR0qBGSDI5lJyr6I/CBwa0jIf2R7sh1C8omPbN+V6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zONbvskba71xgANSToPxkrOGk4GGDpuerY+B6ls6jsU=;
 b=dHZoASdzOqVpelcrtbaM+vTLaCJVplEZfB/gHU2BoOUNouMWy591+eaMEa5Mldyr4F9MYOtASmFL6swYW3lhIMI7KSyqla/sQGfrnvIOdP70nHJhGWv2mN53gDRbeS8eG43XdjAkoLdy10q113ZE4gUVSPBYaYejqK3JdZkYQf+/7CzsWxBThOfRc5ly1i/3JMElhbDoJm6JM+ZDoLMSUnrUcZnJrnN3cGBowgdC406kca5tPEQgzax5OW8u21OqnZ2ACJj+L1UQNeQFlFtD1W41K721c7JE0mruRPKkikVTmK+HCYA97r4gJ5JMbKp68zWx86rsLz43KNVooa0tbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB4950.namprd11.prod.outlook.com (2603:10b6:510:33::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 07:29:25 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37%6]) with mapi id 15.20.6631.026; Thu, 27 Jul 2023
 07:29:25 +0000
Message-ID: <eb3e6370-132f-d545-7fc8-ff560881b17f@intel.com>
Date:   Thu, 27 Jul 2023 15:29:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 15/20] KVM:VMX: Save host MSR_IA32_S_CET to VMCS field
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Chao Gao <chao.gao@intel.com>
CC:     <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-16-weijiang.yang@intel.com>
 <ZMDdp1A7DOsRNeTd@chao-email> <ZMEoHgAm29baVbdp@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMEoHgAm29baVbdp@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0043.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::12) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB4950:EE_
X-MS-Office365-Filtering-Correlation-Id: 360685d8-1845-4ccc-a589-08db8e73342c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WJGD6spZIbVe7Ap7zLcISbWtMWw6vXpgRIPyaWqFJP6ql2V34c7gCbecoBebit2ZGH7+FyXIDmFW29lbwNjH90SVBYzHzfnSLYjd0cxZEoo4jK+dRHlaY5aV87+BLaRK1ZGCSfBmgcPhNh5UTRMfOqR81QFmu63RcNFBhK6n0hkUw0AJ7lVKhP5XjpaIdJlNWa129d0TBHEBhn7wY4zyeXr4ITkDZMt1sRJ03rerXm6iBkvttAZ+vqL+jWw+gEyBSp0A+3JIxgUfR781whn17BGqlttfvjuMUso+eOdOlzrz50q7AuSD0QV0b5vuZFQ2H+XzzvQ8qT+sjUXEIMcCDpEWQSZ345DVllv5oAzH658nfQOgZGsJRPCkfxav7Ak4iOiuGZhUXLhL7dp2k+h+f5HBJ1RNO4HFCwp/q3vspSsiYNR2gU+OZ6D1u5LKyczRNgcekUhlcteoHO25KS3QVLhUmnRR4Skr6b9X1em2GvwA4UVCIozuWqEEYRkZCP2o6mEnJev0xVv2/MFOGIIY8G+E6FKAc0R1Hjh1L2oGhGZSq1bwk/b0eHRlPH6Fug1W5SLTZ+7GC+uAecRkFsklpSAjnHRPK8btL6A8vltjtMM6FM2TPJ3gkVUD7MwSHEgCVFFrg3sEP8p1hRR99jAUXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199021)(31686004)(110136005)(6512007)(6666004)(6486002)(478600001)(36756003)(31696002)(86362001)(66476007)(2906002)(2616005)(66556008)(6506007)(53546011)(186003)(26005)(66946007)(82960400001)(38100700002)(4326008)(6636002)(316002)(41300700001)(5660300002)(8936002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFE1cUdHMDBPbUpBN1AwejVXd09tNHVJUnJnZlJ1NnBnRytoQmUrSXpSdE1B?=
 =?utf-8?B?NGJPMmdqbE93VmNHZHYwVDZmaVVhdUlSTG1RWHF2elZuV0E0QWFZdy9JNzR4?=
 =?utf-8?B?aUVuSEsrL1c3dTJuenh6U3lGK3NvR1BiclFnc0k3NTNBOGNCZXgxOTNWeUZ2?=
 =?utf-8?B?b3pCZGVlVUR0QTJsTGN3ODNDUlhTdDdsMys2Qzh6Z3NPZE8vaE5McnAwVTN4?=
 =?utf-8?B?K05EVE15YjNQd2svemZPblJBL0lneXl6SGRRSXcyaTcxR2thWDYyZkZzT3hX?=
 =?utf-8?B?d3l0L2ZXU0w4dWFRNnJ4RkxGM1FZZUtRa1dlWkh4ZFB2N3BUVWZ2N0VQVTU1?=
 =?utf-8?B?SXpaY1QyWXBDUVVBckdnbW0vNUxnZ3NuT3Q5bFBSdVkySW90bWttbHFLbmtu?=
 =?utf-8?B?VzVHbUhkVzV6TmFIU25CaXBVSmJUZm9JbTZlM0NzbHEydCtoeU1POGZYWVlB?=
 =?utf-8?B?dERhbUJlWGNxTDlVNTVVTVM0dU5uaS9mNkprM2ZWb0ZBQUJYTXJmRGdSZ1h5?=
 =?utf-8?B?Yk4rTXNtNmIraEMxWlVEd1VTa2NKVjBzaUtuV1FOQkI1NUs3TmRvaVFGdkJ4?=
 =?utf-8?B?amxPK2EyOG5VRkZCNjNTRHBCRFV4SEVlOFRlOWdQVndDYVdpUVppeHBSMFB4?=
 =?utf-8?B?NWdCYWdFTTJ3ZWFjaWgxRWF5a1F6VndGM2hSSmliMWtUOU00WjNNV0lneFc5?=
 =?utf-8?B?WVltSzlWUDRkOE1TMTJRYWd6M2wyM3FxTGhUMVQwWmVyNjVhS0ZmRndzWlVE?=
 =?utf-8?B?K3o5V2JqZ3JoYWZaSHlzd3hzcVd4V0p6Unk5Z04rMlZaSHo1QmJVbHRzdVJ1?=
 =?utf-8?B?VUNjS3prQmlJd3BNNHp3NmdpN2hjYzBVL1hNYnczOXUxUXpSY1VPdDJRZlJY?=
 =?utf-8?B?bWxCbXhBZ3NsV1JaRVdZUEpoMWZ0Mlo5N0ZsSDlWdjQxZitXRGlRcGp1cnNv?=
 =?utf-8?B?VVhmMHZ6SUphMEZiNnVYL1FvQ2tiWWp6QjUwWlZMa1g5KytmNmtPVHR1OWNv?=
 =?utf-8?B?NmF1SkdvUmJzVVJaSzA1TjIwWHNlcEw1N0tNWkgwSS8rQ2c0OEYyNStodXdk?=
 =?utf-8?B?M1RNZkVSelZBV3RGenljZVRhMldzM2NiQmdSd1N1WjFvS1RkVE5QblJ4aTNJ?=
 =?utf-8?B?UEd1YlVXNG1yekphbkVtdy95T1M3MGVHTm9NV0RYaVpMMytWY21RNm95WWRB?=
 =?utf-8?B?Mmp6ZWxxNGZ1OVJZdVJGUkpneDhYMHZVWU1Mb2FuWUpiQlJBTHVuVDNTQlg5?=
 =?utf-8?B?RUMwSDY5ZGpPRzR6eXkvK21KWEVPcVlyajF5d0ZQM3BHV1VTZXpOVDIrT240?=
 =?utf-8?B?djJYTDZwdEs1R2gyZzd2QmU5SVIzako1ZVhFSjUrdUx3VUtEWTVRdC9hc0Ft?=
 =?utf-8?B?T0xRTnBnYldUQ2FWV3FOWEpaSkowY2ZTMTdvRk0rTzNDUldhUjJ3dGdYMVMy?=
 =?utf-8?B?RXF6UEZrNFQxdjRNUGFPZzQzUlp6bmVWSnZJRlJvQWZlbWVqRWpyQnd3MHoy?=
 =?utf-8?B?N1FHT0NTVlhOcTk2cVZnVmtZdWRXS0dkbEhWKzgwdjNsSld5bjFXd25pOUNo?=
 =?utf-8?B?QmhhS2hHRWpMQU9CS1dLSkk5bjZjcXN3c0dYSW5udTdBY0NrSC9YUzdOR29Y?=
 =?utf-8?B?VE9iSXhaa01UVjd2SUdySjdwRVJmMFR0a25senFialhCOUllSVI0SmJMRCtt?=
 =?utf-8?B?RnFiMVQ4bjJyRWpxMEphODBFbHNxcWhwS1BXSHRUUk95aWtOM2N3NE93UVZr?=
 =?utf-8?B?dnlaRWhXcDVqbk90M2xsMDF6TS90bFA5Z2lmWllhSWp2b1hnTUV1dHFVMnpq?=
 =?utf-8?B?Z3BCVUp1U2ozWGp4K3NlZUVZZDE4MlBZVzNpemNIRVhlSkg1eEQvQjd1M3Zr?=
 =?utf-8?B?RllITkE5S2ZBNElBTFB2L3VxTG5vTlN2RTVZUGp1TG0vSEJwTW5XZmFndlBv?=
 =?utf-8?B?V3d5NkhEbDhSQUhsR1NXVS9rUmo2UWVRekFDSlV2ZHRjUVlmNmpUNWpJVlNG?=
 =?utf-8?B?SUI2WWt5MEN1VHJJUU1mdTNuQ2N5UXA2dk1kN1FYNE9CU0UwODFFeWVjRFd1?=
 =?utf-8?B?RFkzTEE5TWNheTJnL3JiRUdGUTFNTFA4dEhieklCRk5YNjBFL1hYNVRjZm1p?=
 =?utf-8?B?ZHZtQ2g2NGQ4NEYrSjJuMjdZZzVnaUcvd3IyR1drR1h6S1M4ZW50blNNNUt1?=
 =?utf-8?B?Tmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 360685d8-1845-4ccc-a589-08db8e73342c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 07:29:25.4376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5eEbI7NOKubkKPepRp4zDTC8K4kqRG6xo7MFWOQ3VNbFUpkT2+TErp+Ly0fPsmIHiqpJs3yFG+JHKea8le0MtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4950
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


On 7/26/2023 10:05 PM, Sean Christopherson wrote:
> On Wed, Jul 26, 2023, Chao Gao wrote:
>> On Thu, Jul 20, 2023 at 11:03:47PM -0400, Yang Weijiang wrote:
>>> Save host MSR_IA32_S_CET to VMCS field as host constant state.
>>> Kernel IBT is supported now and the setting in MSR_IA32_S_CET
>>> is static after post-boot except in BIOS call case, but vCPU
>>> won't execute such BIOS call path currently, so it's safe to
>>> make the MSR as host constant.
>>>
>>> Suggested-by: Sean Christopherson <seanjc@google.com>
>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>> ---
>>> arch/x86/kvm/vmx/capabilities.h | 4 ++++
>>> arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
>>> 2 files changed, 12 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>>> index d0abee35d7ba..b1883f6c08eb 100644
>>> --- a/arch/x86/kvm/vmx/capabilities.h
>>> +++ b/arch/x86/kvm/vmx/capabilities.h
>>> @@ -106,6 +106,10 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
>>> 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
>>> }
>>>
>>> +static inline bool cpu_has_load_cet_ctrl(void)
>>> +{
>>> +	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);
>> VM_ENTRY_LOAD_CET_STATE is to load guest state. Strictly speaking, you
>> should check VM_EXIT_LOAD_HOST_CET_STATE though I believe CPUs will
>> support both or none.
> No need, pairs are now handled by setup_vmcs_config().  See commit f5a81d0eb01e
> ("KVM: VMX: Sanitize VM-Entry/VM-Exit control pairs at kvm_intel load time"), and
> then patch 17 does:
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3eb4fe9c9ab6..3f2f966e327d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2641,6 +2641,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>                  { VM_ENTRY_LOAD_IA32_EFER,              VM_EXIT_LOAD_IA32_EFER },
>                  { VM_ENTRY_LOAD_BNDCFGS,                VM_EXIT_CLEAR_BNDCFGS },
>                  { VM_ENTRY_LOAD_IA32_RTIT_CTL,          VM_EXIT_CLEAR_IA32_RTIT_CTL },
> +               { VM_ENTRY_LOAD_CET_STATE,              VM_EXIT_LOAD_CET_STATE },
>          };
>
>>> +}
>>> static inline bool cpu_has_vmx_mpx(void)
>>> {
>>> 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS;
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index 85cb7e748a89..cba24acf1a7a 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -109,6 +109,8 @@ module_param(enable_apicv, bool, S_IRUGO);
>>> bool __read_mostly enable_ipiv = true;
>>> module_param(enable_ipiv, bool, 0444);
>>>
>>> +static u64 __read_mostly host_s_cet;
>> caching host's value is to save an MSR read on vCPU creation?
> Yep.  And probably more importantly, to document that the host value is static,
> i.e. that KVM doesn't need to refresh S_CET before every VM-Enter/VM-Exit sequence.

OK, will add it to change log, thanks!

