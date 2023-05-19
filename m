Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3827094BD
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 12:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjESK06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 06:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjESK05 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 06:26:57 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8182EE56;
        Fri, 19 May 2023 03:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684492016; x=1716028016;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZuRq0BGghKLQrSck/zilHEO1oAT0K80WxLhMTRfVfeo=;
  b=bXc5c9PXYSNEZkDK/n9MyO0/vCRtY7/rutGmdJl+O69cXPAAv+es9mq/
   8cPuR+vNaHLb+nDoiNc1HEVYJ4ISP94uMkbCGfdZ6UmPRbUIWY+NmtffS
   dGautOGCt9HD73ldUNLREJZPYipYx3PfIm7366kPP1PtyIVDEPchpdAFd
   rszjgKSC2WFjT7P5DmBp7fTSCiSYx2Y0j1aLioEkblMxCh7gwy6rEr5EY
   10+lkRU1nD6WofDmzztzuZbvsDtEM715/4LY8ynkXgMP8daRdtuNUpo1e
   ciQLFUO8UIq9RZbLNGcHy4qZ9Psy5G1LKgtV6s0rJXr+Lt1VZD6ffuxfz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="438689702"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="438689702"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 03:26:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="705566825"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="705566825"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 19 May 2023 03:26:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 19 May 2023 03:26:55 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 19 May 2023 03:26:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 19 May 2023 03:26:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkM37tpocArtgRws+dZAq0G4zho19Fe0F1FYrs4N/gOzEtFcGL6OKspcbwGuEBbovGnOiul8/uQGXuYCCJB0ZfgCj5ObI/wshqGhZobJouwGVBucGwcEU7PkJ8o3tR2SxHj3tTyZhSPaD5zIpQDHoDrltxy/IGqQMYnnL8isHBtk+B5xpDWl0fwvZTPgFmdM6JySoLWvLxmiuNAH3xOUoqoMBIihUAmA+fn5hfHAsNHdJofcJ1iKFMSeIrC2zxzVhsJxUxaK/gjFZrbh92QFFZ7nAh/HolqVxkf1UvXvEfmDAKyK0aE+cXKmfomwq1lCLrtrBeMTwfB1WsUXMilQ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vw6AB8Z4NS3zcdTbcEcLj/KOTebpRJwuG2vNsERQsnU=;
 b=fOMhzjVtVye8u/sXG1fYX335HxNPHglXRxmt9gOFnHJ2hP38+xCNlqLKr1UmBQ1ydJ3/fPAmuZMl/oLEpMusCiPendt+/ovfbx8am9ic8NUPTB4zV4+ekBJrqROsx482FvPEfTvokCtkiJ4a5CevMQc+LnYdlo0O38vmwPJbusH4+T5qCtFoYGAvE6reetFyVF3UeXw2nm99uSMbHCwg6H0TrbqxSKXHQNtWLSGKbVzjjlJVi/vbmu4N5zzzVj7DiFYDeceTybAjqWqNIZkkJ7/OMxEVcw7lgSUwbqFxG3hrwy0DIVyITdrJaNK1Kuj401XYw7mENIz/3Mm/pti/ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MN6PR11MB8244.namprd11.prod.outlook.com (2603:10b6:208:470::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 10:26:53 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%2]) with mapi id 15.20.6411.019; Fri, 19 May 2023
 10:26:53 +0000
Date:   Fri, 19 May 2023 18:26:39 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
CC:     <kvm@vger.kernel.org>, Jiaan Lu <jiaan.lu@intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 08/11] KVM: VMX: Advertise
 MITI_ENUM_RETPOLINE_S_SUPPORT
Message-ID: <ZGdO37dJueeGasId@chao-email>
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-9-chao.gao@intel.com>
 <7b90b6c6-9574-eb23-0884-d4ba5fbfb039@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7b90b6c6-9574-eb23-0884-d4ba5fbfb039@intel.com>
X-ClientProxiedBy: SG2PR01CA0170.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::26) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MN6PR11MB8244:EE_
X-MS-Office365-Filtering-Correlation-Id: 0399630b-b62a-4280-4a81-08db58538ffa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +BZ1NhPDVhVrOOuIXs6QxI2VYNlVmfpyt4jN8/CB+gI31VP4ONzudaa6+P4p7jtT8Y60PQwWR+pAEKrDFBIyIaKW1GjfTddlHb8GgWElFRDK6SL+rEmri75/4yupMSXoV91WcBAqp60IF/L5pKsEET/m9oreBvlbvB/1M+s41I7Vq5wzH3iRng2jmJ57ckbjLA/2Qqyhqy7FTl8MOvMHuS1E7yiGhyn7aIvLqAzQ1q46fFJSI9zEmC6fbIWe6i4R1Vz7z00C0PrttC2+BePASa4C6sOwJbygrgTXKSD72IMLjtHJhb07INJxtd4sABFGukF8O+dwHVjhuZA6L3jpGS63tUD9jxKNpeYbUPDwnVrLn3AZwvk6XL7vc9zXC3831fraWmuSwyqM+FrdgD8T1Z4dKxOA30QzsYq4W0d3CPgzEYE3X4WpZO4tGeqkhu0fl1omWL4JOJwdaWGFY3PDjN7lkfGGM6HTW7K+40/Ltxdhy+cn+/a8Cu1+5yt1bMWgJz4QzhiVn9vGL1FB6cOX6nRQs1JlPIPJD+wPr/KT4jPyRPBo/HEVpuj0y8ulgvm/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(346002)(396003)(136003)(376002)(366004)(451199021)(4326008)(6636002)(66946007)(66556008)(66476007)(478600001)(54906003)(316002)(86362001)(83380400001)(6512007)(9686003)(26005)(186003)(6506007)(5660300002)(6862004)(8676002)(7416002)(44832011)(8936002)(6666004)(2906002)(6486002)(33716001)(41300700001)(82960400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FRXiYTA7P+qa4gQwf6rQ3KiAuYeTCzzaZ/CS9HhDTUv1TREh5sWr0tHn7SuB?=
 =?us-ascii?Q?vrppQMTjJ/DuBxS9hWmXU7wjf2H/48/J12uDC+f2cT7ArAeOi6X+MIBOYDmT?=
 =?us-ascii?Q?KVzbkyTWTxBPP/IrDIsE8Xwl7n+Qfhtu09c7bF65dgO5ZR5VfY3AGV4a961s?=
 =?us-ascii?Q?PHg8/JktmspKwIqX6jZcRXUJg/CrJx7WmdiHwjRIv/cEubqYiDLDRW4T08+C?=
 =?us-ascii?Q?omnB4UNkoKn5VYe395XNdIojHTDMUcJPSMjX6SahyE3qhju8qwaVXsNlqU8z?=
 =?us-ascii?Q?TRDX1pc4Of0kHZQwH0rCM4nzylidYmtFEoE07LsQZPZPX4tLjXcNzY8PDCkk?=
 =?us-ascii?Q?kPHniTuvh1URPCwGHKade93cPimAi00ntiMluF+yadfdmmdlLplnA/vgYXyi?=
 =?us-ascii?Q?KqozaHxUMXsnIG+f5OUBiFRw7gzT7jlqVoBOKK9ZgcNdE4bf7c/zYZN2mnBG?=
 =?us-ascii?Q?0FSCb5y4AN5/Xym0L/3MXqTSOtKu9TzCn9+/IMTh0V9IjBB+XuyDQXyZ9qws?=
 =?us-ascii?Q?zOhHB8/hoXXSxVWjIFCadqWCEXl0rcUyv3nK097t981WqfmJBfk5cOaa/p7/?=
 =?us-ascii?Q?uIiJAYyFeZa/63faOXSQsN3N3JDxauVn4h5XcKwqZhJv/t56DFupXBoyY9Ni?=
 =?us-ascii?Q?FAHe27LbyAhcBgxPtXJ/wIUb2pmmh1DbIGMH+3qCJQvrHT3G9yN57Zwjmg0P?=
 =?us-ascii?Q?L4dGNcTTgKHiuSLoSJ3jrGO9RT/285zBOZ6DPsh8kojzMo7Sh0xq/adSUF3e?=
 =?us-ascii?Q?lOiO6QPHJjkC+FmmN+DdztFvpeHkrP6rx/Eu96p2+LGkcYi3zm7ZWTLuzgde?=
 =?us-ascii?Q?k6CygMvfb3jugrslGIej/48dAyrp/IlBsaIeV98h0sR/nMI53LK+OJFlsY5b?=
 =?us-ascii?Q?f9YEJCf4xSynDJroYIK/5qhTc47e/O+9lIe530MYGZHJFo+ffsByENn7DXiY?=
 =?us-ascii?Q?noQl4NyrcA69kp6k7ZI+G4k6B/ahMR3olG7Qs/7iVHBWV6RUPZGgEB1rwWhk?=
 =?us-ascii?Q?en8SvQmrgvdfvpDrprBm91JD6+hszIDr9AFKf0nAiPLfvSx540qXLZ0b1hne?=
 =?us-ascii?Q?xntWSIY8ihoaZ591tEfwtdHXOBmdoNspsK0haqQ5c169yv+IUVqFAgGgqCK5?=
 =?us-ascii?Q?I/nUUgsH5bMhHZSi5p3NepcjTSpsFBMRzjDZP5e2NBhiLoF2P1g6gLEqZs1L?=
 =?us-ascii?Q?x/4zUPVaOw2X/tgf6Sq2S5hUgUKqNil2zyeJzMhVeF3wdjHmPLtxza6wzUe4?=
 =?us-ascii?Q?PEYgMnYQZ3FolvvwYe1eiHJ9hikVXxmTAVyktpaJW57cBoiSvZR7ibN0AVKR?=
 =?us-ascii?Q?Dggjq1lI81mB5I8iWHtaN0fvPvHlinYJbmctjGs1OcAAmA7XdVd2ciFIVCaA?=
 =?us-ascii?Q?VhgnfpP4XZS5aHWPj9NbMGh3Rq448UbQQapdKMcxYsDaqdMUTpb1pzUsC5qz?=
 =?us-ascii?Q?ZdWa8uG0r+o29lCRDc0/VDVVkzmfpphWd4ROet0/LH8T+jbfY5zm9a5GxWfY?=
 =?us-ascii?Q?lwSR68+31XFQFC7g3C8wiwCa1ptsn7aBlcH8aJuI9U0SGkK8r4ygpPSsA0IC?=
 =?us-ascii?Q?6jecRL6B7YqS1y84U7kSdoo0KrgZDxaPh3IW8F80?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0399630b-b62a-4280-4a81-08db58538ffa
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 10:26:52.7774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qRk5ylaUUYOmbnwQAjp5JkZV95k/Z8yZ6yfZcEHv8T3hECr//5P0WbGPamJMAcrDjmkhk6PM7hpMrYruRTjCeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8244
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 18, 2023 at 06:25:30PM +0800, Xiaoyao Li wrote:
>> @@ -2173,7 +2173,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   	struct vmx_uret_msr *msr;
>>   	int ret = 0;
>>   	u32 msr_index = msr_info->index;
>> -	u64 data = msr_info->data, spec_ctrl_mask;
>> +	u64 data = msr_info->data, arch_msr = 0, spec_ctrl_mask = 0;
>
>Sugget to make arch_msr and spec_ctrl_mask as local variables of each case {}
>block

Sure. Will do

>
>>   	u32 index;
>>   	switch (msr_index) {
>> @@ -2488,6 +2488,24 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   		if (data & ~MITI_CTRL_VALID_BITS)
>>   			return 1;
>> +		if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
>> +			rdmsrl(MSR_IA32_ARCH_CAPABILITIES, arch_msr);
>> +
>> +		if (data & MITI_CTRL_RETPOLINE_S_USED &&
>> +		    kvm_cpu_cap_has(X86_FEATURE_RRSBA_CTRL) &&
>
>why kvm_cpu_cap_has() is used here? it means whether KVM supports expose this
>feature to guest. But what we need here is whether host supports this
>feature. Though they might get the same result, we'd better use
>boot_cpu_has() or even read CPUID directly (since cpuid info can be changed
>by clearcpuid magic) to avoid confusion.

OK. This makes sense. I will use boot_cpu_has(). clearcpuid sometimes is
helpful for debugging. I prefer to honor it.

Thanks.
