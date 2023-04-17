Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89DF6E4117
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 09:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbjDQHdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 03:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjDQHcm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 03:32:42 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275D94207;
        Mon, 17 Apr 2023 00:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681716711; x=1713252711;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=U6gFJhgTpcdG7KMrhiou+1TRuuuLYT59ECJkAtLeX5k=;
  b=h04Wd4es9gfHwqtFLmkdIkB+oBh2MDzYZG27eY5BT1a05n/6zwqPcy+z
   BfYsYuRLqjlq4fwSb/R+ZYNzclNKcw4b7XQq64FZ33AqzY5MozKI5ULwR
   4XQmI/gtvQztgbj3+jDCrwBUKQzD25IN5XAEs+w+zaxmoxTHtU3j0b175
   rgV/BG2P9xcelAqXRzTu7dE3R/AjEMQs1fdDaCyrcQBtjGCbRsEC4pmPn
   ry50jTfVBNQqC4g91JQincDYQM1fX8nigQNhPl4oYheZYX2gD/ksBjnRP
   5jWWKZu8E0XB2NDZbsnh62dwmBBPDsruZTmXSkgBiIt0sFPizrYesf62D
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="328993092"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="328993092"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 00:31:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="864911944"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="864911944"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 17 Apr 2023 00:31:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 00:31:49 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 17 Apr 2023 00:31:49 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 17 Apr 2023 00:31:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+z4rvt+unkVh+7gwuROgxPL0l76b8rMXlgPaPX7Hn9+keaRKOJmwAWhVizWE/6ncK7gs4JL81Uvo5mShxVMwk3cF/lvWJcsAEaiDPqjwvN1tWJwZYalWaLfBEl5qlhWeD9M5xNVB0kLYbNGeNX4p81k+52D+gfDn7pqIeWTBxO2K95akLlOFJ8KEjb/5O1gIus3U/eibu0yVcH9eB8XJneXyi+5mlwmTJflwgkawjsH5wkoM7UMW2t3ThPop4Zy8BXt9Ixr5zpXO0JFTat4Ml+2voT+3AwRfqYX3UcyhcI0VNS9j7IbPnABlHfPsij0jqzUt6t49Xmu8ODxPVjZcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r0wpsxziAqaoMJ1AmIdqhVzj7pcHsZecqLCHfzYU3Zw=;
 b=h9Di6d8L+7CaqsCRyA26Z4W7NMmUDKxDAKuN0qWbhgD0Q2C/5DaBDI1Em+Kpw9EaZG/YQnIQNb5tRYAmqEniXBc7qNOOyBVlp4hvVBk9lDE45QU/6rEyKi3ClGfQ2QtjW9bxIZOd+lcqTlO3hw4ZlwoV/Tb5TDm55T65EOdi7e6kJwkhE/+OhvYp66Xn6D92eCdi3zkAwcem54ibFTWxN5co7tVEsNbMHh5c5AuELdnvn9s+MTapBLw+7cidFTgf8W4UEOAR34zMbV5FXIhaFtV7u8QdMvlmScZcbFFQYDQSMFUhfp5aV66h1GwRDY5rWEDTDq0j1HNFjXZ9uUuHfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by PH8PR11MB6997.namprd11.prod.outlook.com (2603:10b6:510:223::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Mon, 17 Apr
 2023 07:31:48 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 07:31:48 +0000
Date:   Mon, 17 Apr 2023 15:31:37 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
CC:     <kvm@vger.kernel.org>, Jiaan Lu <jiaan.lu@intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 04/11] KVM: VMX: Add IA32_SPEC_CTRL virtualization
 support
Message-ID: <ZDz12ZlMb+iqJP9p@chao-env>
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-5-chao.gao@intel.com>
 <c89c9d44-f9c4-2e48-ff0f-f0e070de6426@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c89c9d44-f9c4-2e48-ff0f-f0e070de6426@intel.com>
X-ClientProxiedBy: SG2PR02CA0124.apcprd02.prod.outlook.com
 (2603:1096:4:188::9) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|PH8PR11MB6997:EE_
X-MS-Office365-Filtering-Correlation-Id: 48d1f524-7784-47c9-4dde-08db3f15cd52
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pY4YQuTANodt74edbE3PPCoHg93a02cixRRB8EqRMemqfMtC6fDWcOC9ewuGvfqiK/Hv12+efTWMh70qPKY4TQ5tyHt0x+wpsLMmBiIvYrYzZRGOlcUhXBWiwi0bpUUIBF5ZrCTXnGoZSVDDFlf+ldWCGpJ2FQ6g3XjdDVlgqlB5EZB33iESwErSlSP/NWuGeD9Br/k+I2s3faKoHXA0EKhms9w/8SfqxSBDczJ2DtvyNhYxJola4Ec+dfJesbD4N4UzMJcTrD92istc1ZbFLL+neIplLs4hcddJnisODsYXbzn+GZRG8A/OLP7V4ZzIbtd6pWdxB+IlG+M8FQCt4tiYbcISzR3IS51rI7zWRFjnYiZ7bR4cz2klQfIM+nBpguAl3HRXBkPadBJND4wptR0oeCpFahrpIM2JIcS44gQUarJRh0W6sQ4pwyuvQETBfGUwcqJnZkZe3KU5S/FHCUmJSnkPENJRIwynQ4LAYmkU/eivujnILQYXdChAFSrfWh5f9Ueg04gohFB1cGheCAUs/NeK22dGapGRSjcxj8rk/kzoebixxr+dSxnorOoSHK/ZO4zbmrr8PKHIacTTnc5/dL7XV0Xnzipv/uzFSV3dxw09qta1uoKoozDT/OnLLpSle7kBCBkrEi6BsPx9HQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199021)(5660300002)(6486002)(66476007)(66556008)(2906002)(4326008)(66946007)(33716001)(44832011)(7416002)(86362001)(8936002)(38100700002)(41300700001)(478600001)(6666004)(6862004)(82960400001)(8676002)(316002)(54906003)(6636002)(9686003)(6506007)(6512007)(26005)(186003)(83380400001)(21314003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?irh4dUbg4rU10Ma9oYIzIM+euzQUrDMHZj1TdQnFaxQucMmuIC7KH+JTxxOo?=
 =?us-ascii?Q?JV23Ty9Okf7lKKGq33pwApFXcszJbIL0eKfmqyAAKTnApjjAH8jIaA8oAfah?=
 =?us-ascii?Q?BepvV/8viiC3/SbBxVLE83kAxYDJWCxUMaYV07J14rs2GM0db+WjbW0CZ4F/?=
 =?us-ascii?Q?uyFjf81X8OVjpfswponjlPQFU0zx5QbLMgRjxIbPLfBTEvmZKcFWCI92QMn6?=
 =?us-ascii?Q?iiUScqhdGAbM8WNmNUTxh8MABQ3qDG+rJ5h7cOHbjKjkvDHU3XI1gVoONFZw?=
 =?us-ascii?Q?xu1Mz2sbPgWXPIr6LfaI1JFHVrLqDzAoIvXs2IdjgXkm02zss57CU5cBfwAk?=
 =?us-ascii?Q?trt6a/VhVlpaCXtem9Gfs6N2Ie7ggRyv/LOItn+yGFkzUG9U9PQ1AIOzrtiy?=
 =?us-ascii?Q?I5v6wya/pjDxTsC8Wdyh+51Pu8Cg5ScHaeduE2LVRV+AufHkPRWwRPSjC94D?=
 =?us-ascii?Q?KsAzxPhdKzsT4EyUYX7LX9vZj7KWba+z8lDVa/uTR7MDfk8PrGc+7RZCD/Vm?=
 =?us-ascii?Q?9pmFnpQsz28dxeRmcz6DqJEV/2cdj34JLC9QaUBiuRXztowYRs3fDKKMdNKX?=
 =?us-ascii?Q?tckcL6LL4p4Lpsn72MkD1SDJrz2FYVG1MAbRVYpt5FwC7idvJ62Us9rOZp+L?=
 =?us-ascii?Q?VUAWI2LPBuJ05/SugkvC0aHUE/dasS2BatNU9fOswquKSYVKtHGbv0J7Q4sX?=
 =?us-ascii?Q?HFedhhe/Ikj6wyObXGPiz3YDELTrL/v2y+9NxsaXifi1NApGbCuTnS3K919u?=
 =?us-ascii?Q?N4Ch4AsKpNeBfahRfZx65I/mZpKES/FNpih8vJgFopPKonmqr87IxlV1DkWW?=
 =?us-ascii?Q?CwAdm4zUGVYJ0Lk/QfuGbXFCUowfD1bnEl5KzvFTn9GY6sMXKKkSNhPxbnLw?=
 =?us-ascii?Q?S/zRoBr4TyTZjcQDdNF8ixHffryGarLoWhp4fXUNrGXGwpPXF8t6f522ZpXB?=
 =?us-ascii?Q?In+u4q6XBtMd5vrZJnIIOHXC4Gfw/bCqjfwbj9HxMXJA3FQ+wr3FRGBDou8a?=
 =?us-ascii?Q?GfuooNzF0fv02wnljPP9kRF3XiUixxA6RMiRFUV+zOy43jjTavYE71HKwnBr?=
 =?us-ascii?Q?MJf7nwh75+2bh+HSqR0tbDtGn0/9A0cT3k0CevXZBtzwYur60ISuqseGKpAo?=
 =?us-ascii?Q?qQOLHHzqfHleEtpw4D7ov8DyBY7aV7bSMiivcRn9ZPNT5BQmw2jdlFfcvTYy?=
 =?us-ascii?Q?ZhpheKs2Vx4LHNfeQE6iprZGl2zgo56UW11vsgmI4rFkeVkj5+23rcSsGdqo?=
 =?us-ascii?Q?5vqR2oq/6omFMYKNBKi9DdOtPlwBsxWjP0BNCoy4sOY78QoCerCp5QR/PheX?=
 =?us-ascii?Q?D72sIToJsbN4G7cgmHJ9DE5BerUY7TBAtqs26xr0+I5xT3rvEPYhMYV5Haf0?=
 =?us-ascii?Q?Ap/sV/moIgTXP5mq4H7salYD+YbHAX70lyuqNAN5lrmb1AHBO8MGtYxhIEFl?=
 =?us-ascii?Q?yDv+sqlUClJ9ks3yny5db9v95Wu1Tr17Qs8rXBwFCfxUbFREV784FazbaOsz?=
 =?us-ascii?Q?Ddd+Av9fiNuwLtX3xZIJzAsz2hi4DdZzqVp1IpIT5T0kDaiwY5S8U0zxdIK3?=
 =?us-ascii?Q?9K/KHuqp8XMWbuRMOcn+z2IY3lC9YnE6xhwSEiqB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d1f524-7784-47c9-4dde-08db3f15cd52
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 07:31:48.0133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zx/VvQ6kw+zWhUDKqJ/6AjfWY2feCUsTERWVQteIdyvHNjv+CZpXkjhQ+zIjDp54lQnPOD9Y4wkZBGf88C4GIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6997
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 17, 2023 at 02:48:56PM +0800, Chenyi Qiang wrote:
>> Co-developed-by: Chao Gao <chao.gao@intel.com>
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>
>Duplicated SOB. Move the Co-developed-by down like other patches.
>

OK. Will do

>> Tested-by: Jiaan Lu <jiaan.lu@intel.com>
>> ---
>>  arch/x86/include/asm/vmx.h         |  5 ++++
>>  arch/x86/include/asm/vmxfeatures.h |  2 ++
>>  arch/x86/kvm/vmx/capabilities.h    |  5 ++++
>>  arch/x86/kvm/vmx/nested.c          | 13 ++++++++++
>>  arch/x86/kvm/vmx/vmcs.h            |  2 ++
>>  arch/x86/kvm/vmx/vmx.c             | 34 ++++++++++++++++++++-----
>>  arch/x86/kvm/vmx/vmx.h             | 40 +++++++++++++++++++++++++++++-
>>  7 files changed, 94 insertions(+), 7 deletions(-)
>> 
>> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
>> index 498dc600bd5c..b9f88ecf20c3 100644
>> --- a/arch/x86/include/asm/vmx.h
>> +++ b/arch/x86/include/asm/vmx.h
>> @@ -81,6 +81,7 @@
>>   * Definitions of Tertiary Processor-Based VM-Execution Controls.
>>   */
>>  #define TERTIARY_EXEC_IPI_VIRT			VMCS_CONTROL_BIT(IPI_VIRT)
>> +#define TERTIARY_EXEC_SPEC_CTRL_VIRT		VMCS_CONTROL_BIT(SPEC_CTRL_VIRT)
>>  
>>  #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
>>  #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
>> @@ -233,6 +234,10 @@ enum vmcs_field {
>>  	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
>>  	PID_POINTER_TABLE		= 0x00002042,
>>  	PID_POINTER_TABLE_HIGH		= 0x00002043,
>> +	IA32_SPEC_CTRL_MASK             = 0x0000204A,
>> +	IA32_SPEC_CTRL_MASK_HIGH        = 0x0000204B,
>> +	IA32_SPEC_CTRL_SHADOW           = 0x0000204C,
>> +	IA32_SPEC_CTRL_SHADOW_HIGH      = 0x0000204D,
>>  	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
>>  	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
>>  	VMCS_LINK_POINTER               = 0x00002800,
>> diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
>> index c6a7eed03914..c70d0769b7d0 100644
>> --- a/arch/x86/include/asm/vmxfeatures.h
>> +++ b/arch/x86/include/asm/vmxfeatures.h
>> @@ -89,4 +89,6 @@
>>  
>>  /* Tertiary Processor-Based VM-Execution Controls, word 3 */
>>  #define VMX_FEATURE_IPI_VIRT		( 3*32+  4) /* Enable IPI virtualization */
>> +#define VMX_FEATURE_SPEC_CTRL_VIRT	( 3*32+  7) /* Enable IA32_SPEC_CTRL virtualization */
>> +
>>  #endif /* _ASM_X86_VMXFEATURES_H */
>> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>> index 45162c1bcd8f..a7ab70b55acf 100644
>> --- a/arch/x86/kvm/vmx/capabilities.h
>> +++ b/arch/x86/kvm/vmx/capabilities.h
>> @@ -138,6 +138,11 @@ static inline bool cpu_has_tertiary_exec_ctrls(void)
>>  		CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
>>  }
>>  
>> +static __always_inline bool cpu_has_spec_ctrl_virt(void)
>
>Do we need to use __always_inline to force generating inline code? or
>just align with other cpu_has_xxx() functions, use inline annotation.

__always_inline is needed because this function is called from 
vmx_spec_ctrl_restore_host() which is in .noinstr section. With just
__inline, the objtool may complain:

vmlinux.o: warning: objtool: vmx_spec_ctrl_restore_host+0xb3: call to cpu_has_spec_ctrl_virt() leaves .noinstr.text section

>
>> +{
>> +	return vmcs_config.cpu_based_3rd_exec_ctrl & TERTIARY_EXEC_SPEC_CTRL_VIRT;
>> +}
>> +
>>  static inline bool cpu_has_vmx_virtualize_apic_accesses(void)
>>  {
>>  	return vmcs_config.cpu_based_2nd_exec_ctrl &
>
