Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2993C76308F
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 10:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbjGZIz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 04:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjGZIzW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 04:55:22 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCED25262;
        Wed, 26 Jul 2023 01:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690361321; x=1721897321;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XWJh/E3JThAUrm7kaVdrcX+VQZuj7VY3/3G2F/GB/7I=;
  b=MccQ9MUvU0eBnRZE3ioCjP924seqCnSkZ5+2/GewMhE6+D2/Eqh2O1hT
   qLd8qqk1zE4BPeonc39vYdRcmFlyNNqJA9p8KIN8k9ozYivxxf2/4d0+u
   OoZBFYXnTnIjN5K+Sy67IfDycsp/35W1tj61glpXr6FTCxPfKoEwjV+wE
   OT8PQLSKURZtG0ngHWS8ggvOT8vd+UPOPViMfLNn8lZLOLrOZ/jJK0qPg
   QNeMllzJGuPXZx2Qn3Vk6PnsuOP7h82p8jHWu0Msk+4Za+UhkAyf3oU03
   9OqplIBGwxs8oKPP6BHxhty408RQyUx/zucd5ORyzJV0+2IcUI19U1qkN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="431759663"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="431759663"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 01:47:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="756139809"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="756139809"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 26 Jul 2023 01:47:56 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 01:47:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 26 Jul 2023 01:47:55 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 26 Jul 2023 01:47:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5n+WBRTy68NnUws+jgWR8i9IVIe9PC4/yxyxkq2IAUIZFWAziSllDsfB0+QLAmfoZYxraBfqDt62AfYLxCneZXot+ZxL4s8Gm0a8Z3fnCo5ZQvf275DI/9kAs2nxW+xUAS8rurRlWS58Ba9yF7kuT+Ah1Qkbobhds9lQZBnmvrfydSTrZ5cMD0bVWxghjouVJ87ulsn29AZo5BDrSq/NWnktGFIN9vNdcDLs8f9dOdQAd+wc1Gza02IQHWb0WqwUnxfCRhRbv4a7ig3AHEUX3mK7khVb3ms5EXbcvKOWXrfLH9MzPklCz5XQ7QUxN6MAB5MlTWXkw6UVDJ+i4a9Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4XrQKKD5wk4GTKfGxSzqad2VjEOPTiRu9BmSloI/vZY=;
 b=DRpAM+v+CPL2HMPRXGdd68t6rmZbhRGJObviXuFKnNl+1VXV3QHSzPes91Sd9j90cy/rasIVpS7hcpmW1uiI5z2L/1++I/YXlibtBeqg4QL6r4YlGWp86fV4kFr+j1VXPQ2rBmk8De/xYMRmOGQK4i5JD5e5Tbhv1Txg/0j+quTrh7aDgpy4QRE2ITxx5FrjqOed7PNlF/OjocMWgldl1FjlINGxtc7W+9uPT+32l+s+QPh3PVee1WMPdxJfqVu9WIHZ/Zg8FxQDQ+nuQOxiTsiEWMmj98kfDryk0gPwllq8QbxNYBlmcl2DnepeKHDm969LRbVBNZS/6//Hmb1Otw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MW4PR11MB5774.namprd11.prod.outlook.com (2603:10b6:303:182::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Wed, 26 Jul
 2023 08:47:46 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6609.032; Wed, 26 Jul 2023
 08:47:46 +0000
Date:   Wed, 26 Jul 2023 16:47:35 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v4 15/20] KVM:VMX: Save host MSR_IA32_S_CET to VMCS field
Message-ID: <ZMDdp1A7DOsRNeTd@chao-email>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-16-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230721030352.72414-16-weijiang.yang@intel.com>
X-ClientProxiedBy: KL1PR01CA0071.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::35) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MW4PR11MB5774:EE_
X-MS-Office365-Filtering-Correlation-Id: d61083c9-8881-4988-a5ab-08db8db4fbf0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9G9I4VEZh4m2wPD0FtOqHX1xRGYoxLD7dUMvza+IzmfkG88JORyk9BOgo8Sn3EvWTLf68QI3Pvw4T6gsz5zcZysIgBzWadoNY75KM5HePwaaRVDVEA37sDFk/AI8l1DVj5fyOScCVCBgPqBSnRt47BH2aw1QTCTFv0Zx2QsIShzDqQtAPZCCYOHceozgspFQBaP8oqkINy+EDV7hCscVnNJaHz9k48/FAsB11VqXgxO3+qkvl/XtqlodpZUAIYcKL6YxOS2jYaYpZtM1MJjiRLou3s3x0VgUxk9PyXslqaea834MYZy8kajrhGmA6ahnv81tzCbvy4ZJUaagY1jvNlllNEjGZcLbdmtbbUrXXhyhRINbAGKZ+X11MFKjv0SALortFcm2kiV8M9BEnuA53Q+iGgNTfBffllaKmjD6PcxKOKQ9kvsw6BWAhOue6dTbAQb7/eBOTZjYdY6N6MZ0uuZIebYFXPoqChTQXGI/zNU6x7nRZqhkiGv/u7Q4wipMDaXKS67Y5UFzuZ9vu9l/5Uz3G0c1q2S6sy4GwlRwMWAghsjRsIci9UE+993O3XPc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199021)(478600001)(5660300002)(44832011)(8676002)(8936002)(6862004)(41300700001)(2906002)(6506007)(82960400001)(66556008)(66946007)(66476007)(38100700002)(86362001)(33716001)(6636002)(4326008)(316002)(6666004)(6512007)(6486002)(26005)(186003)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3SV97OTDaIL8RR2+8LQpRsDJTuV6U20hEkzkD8m0D5RqcdOmesdkvUWC16H3?=
 =?us-ascii?Q?QEFX0Q/n/CFEQ+USS5sZNjP+5dOyJ+Yc9XBciPG2OlFlIkxZI/SSMOlXKM4O?=
 =?us-ascii?Q?ehNtj6JPjmV+YnwhSRTqcJUtYOP+PCwTDx13eZ0Wl+vbSpn6H1rqcn8owBLl?=
 =?us-ascii?Q?CogZOmmFsMVmW5OUw21q3rJpABnMlvH4Bk0tfxVJk6i+K7OLUpcbf4B2JhY3?=
 =?us-ascii?Q?vA9QDeE69U/v+cuPKCpSGIuQT+uLwSFmAYbn8O6/L5vJq4bBwXrc2i8MAtQV?=
 =?us-ascii?Q?ePLXWOnzs5cvJMUwDUyOxmQ4O0cZebY/aXbtve8LRap7A7/7I1DdREvmne2m?=
 =?us-ascii?Q?XHbCDPl4msTYsPV8Uz0VoaTS31vrzAsgEbk7QdtjuVGASPXBbngYJADr1e3e?=
 =?us-ascii?Q?U+whlDWaGhbCx8URZZzYhMSDn9pPq+OUuRKePx2+0hrbDuouSWlX1sLHt04A?=
 =?us-ascii?Q?Xt5QUlBoYzTUpImL9vluERdLh480sBVaQba811F2CrHT7Bl30o8lia6+9frt?=
 =?us-ascii?Q?MaiF4OtQPOXAhnBNL+iWoKbVsFgBJ3ajDZg6k2mNFiBEzYFDb155hlCzyBjZ?=
 =?us-ascii?Q?e/wIHl0QKUs0UtjMDyk2gwHtp7Hs71K+lHelbuqQPo4yJpXSO+0UjOnz5k2F?=
 =?us-ascii?Q?G8HjJKYp8/QdwyUACNyTns9YmYMBwcY/qoXY8C0nIaXG/WfANnxgtcupDE/4?=
 =?us-ascii?Q?64/Gg7eeF06q+2eEDNTNMluUGH9+d90/O8rAcR3ulCpy3YmVy8nC7xAxne24?=
 =?us-ascii?Q?ob/7Bx0BWdvz+QdpEJzOzzFVCMZCsCBCrEYthDuIuWLDDSyJmNkRvyb/hvH1?=
 =?us-ascii?Q?WoL6wIYlW6aw4FkU4dFA9pOFIYem9QBXJ3I2Lj8dB6Ey++QYfH/Gh+mLFjbo?=
 =?us-ascii?Q?12U0bs2/qHr2vm0X61OvsPDyESSU8wJ3tiW855KYgg7KQFLxjMjebZmnzorL?=
 =?us-ascii?Q?19znqCK52LoJXsmp0U4rxQeGRCURov5W5VyovQ3BZWPctpQOQ9QbE4186+2g?=
 =?us-ascii?Q?U8E5QLc72ohMNhGmACwlbjGXMcZi8DHBm1Nkq9qSO7uJLGt1UDSXZGJTRK0O?=
 =?us-ascii?Q?tcznvvPzC+QH51iegZNHva8SZS3SJGThEouT0DFNwSWMwznvRaRF9x0YMsS2?=
 =?us-ascii?Q?mE+3PoQz/BfagHElscO6dyzpfb6NXbKHN/hq6EN0CVOBP5eev+QkILHM+3dT?=
 =?us-ascii?Q?Ij8mqyuEL1tQxQgW6W8R1WBZf0eFUKNm5jTDrODSKxIWzhwuGfd9t9cRog4m?=
 =?us-ascii?Q?v5dH371l18fYV6a2yJ+PYI4wNQO9AorCk1/CfGI6mqSUbFyYWbuP7tl6ErTP?=
 =?us-ascii?Q?LvHm/kbtjPbAPpR692fCtWVCvtoBrTEJjYcERWRyHy2hhAGteTyBb/FdE8ML?=
 =?us-ascii?Q?5adV0lcsHfxxok963IcGwOeNCZgbcyz/m/wLQguxncygI7EjFmt8foXpIu3T?=
 =?us-ascii?Q?JgVZHRUFUzavLoKN+eJHx3UQW8pxD8GF6NbNB7oUnE5RQezjwLQNOdBwOsbj?=
 =?us-ascii?Q?SMVUhyV5A8gvTkfw9JvA13oxc8C+H5L2Jv02ev+t9aq5nWcV6pghEZlZBw/L?=
 =?us-ascii?Q?rhBDyAHkDjlxGkEsu2lfvDIMmwGQxWdSWDi6trkP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d61083c9-8881-4988-a5ab-08db8db4fbf0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 08:47:46.4692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VQD8cOFYRdkUHaTV+QipV/NOUceuDrYne3myIMxyVNr17QoDQK6W4tSJOXKDbgVXilx5dwjl1ayGHCQWt/PEeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5774
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

On Thu, Jul 20, 2023 at 11:03:47PM -0400, Yang Weijiang wrote:
>Save host MSR_IA32_S_CET to VMCS field as host constant state.
>Kernel IBT is supported now and the setting in MSR_IA32_S_CET
>is static after post-boot except in BIOS call case, but vCPU
>won't execute such BIOS call path currently, so it's safe to
>make the MSR as host constant.
>
>Suggested-by: Sean Christopherson <seanjc@google.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>---
> arch/x86/kvm/vmx/capabilities.h | 4 ++++
> arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
> 2 files changed, 12 insertions(+)
>
>diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>index d0abee35d7ba..b1883f6c08eb 100644
>--- a/arch/x86/kvm/vmx/capabilities.h
>+++ b/arch/x86/kvm/vmx/capabilities.h
>@@ -106,6 +106,10 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
> 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> }
> 
>+static inline bool cpu_has_load_cet_ctrl(void)
>+{
>+	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);

VM_ENTRY_LOAD_CET_STATE is to load guest state. Strictly speaking, you
should check VM_EXIT_LOAD_HOST_CET_STATE though I believe CPUs will
support both or none.

>+}
> static inline bool cpu_has_vmx_mpx(void)
> {
> 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS;
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 85cb7e748a89..cba24acf1a7a 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -109,6 +109,8 @@ module_param(enable_apicv, bool, S_IRUGO);
> bool __read_mostly enable_ipiv = true;
> module_param(enable_ipiv, bool, 0444);
> 
>+static u64 __read_mostly host_s_cet;

caching host's value is to save an MSR read on vCPU creation?

Otherwise I don't see why a local variable cannot work.

>+
> /*
>  * If nested=1, nested virtualization is supported, i.e., guests may use
>  * VMX and be a hypervisor for its own guests. If nested=0, guests may not
>@@ -4355,6 +4357,9 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
> 
> 	if (cpu_has_load_ia32_efer())
> 		vmcs_write64(HOST_IA32_EFER, host_efer);
>+
>+	if (cpu_has_load_cet_ctrl())
>+		vmcs_writel(HOST_S_CET, host_s_cet);
> }
> 
> void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
>@@ -8633,6 +8638,9 @@ static __init int hardware_setup(void)
> 			return r;
> 	}
> 
>+	if (cpu_has_load_cet_ctrl())
>+		rdmsrl_safe(MSR_IA32_S_CET, &host_s_cet);
>+
> 	vmx_set_cpu_caps();
> 
> 	r = alloc_kvm_area();
>-- 
>2.27.0
>
