Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADA97637F8
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 15:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjGZNqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 09:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbjGZNqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 09:46:50 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB5210F1;
        Wed, 26 Jul 2023 06:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690379209; x=1721915209;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ONBpHWf7/JMzguM5d6QyxJ72eYeR7xuWdSB9qW2Ysfw=;
  b=bBjUYRWTq3jMcC1Qag2EQz0gqzlDAeCtsl+ssRbYFQshZkGsgArxQ+L5
   f1TKLlkjDW0HfCNQSsU8GojoIRBphlYEnqjfLKcYsRaYeZxYg1iBUfXjs
   8gzDDI+lFJMdBQlkRDPBzU7p9zw1w9+w77L2U0a7UX/Pxc/a5GzZ6xVcA
   oVxDAoWoxTGhgoSS+CuiWtWDlD4yVQHg4emvh+tSTdWdtLMEc2jlj14xG
   39AKILFnuj1w1s9ZifKt/JfysDJjUJ3Osj4Thu+6HjMUYN4YayFWlw2bN
   HJkb4QUs6vmfWbsECGFr75ycHpNp3bTUoWS1ay8LoIBuQ1EiJrvlTdqLg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="352921216"
X-IronPort-AV: E=Sophos;i="6.01,232,1684825200"; 
   d="scan'208";a="352921216"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 06:46:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="796584264"
X-IronPort-AV: E=Sophos;i="6.01,232,1684825200"; 
   d="scan'208";a="796584264"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jul 2023 06:46:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 06:46:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 26 Jul 2023 06:46:47 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 26 Jul 2023 06:46:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BD0OX5EC4vvksfRCyDO8xVcUPajQk3EESPOc0s3W/fmyK7XZi1tb5cpBuONjfM+QfQj169xBNb69IPLRL+XO4WUwkUuG9PFnz1wyCvDDD2EHc1fpyFZMoggtg5OJbCxedcte87dkXTisM5ejGZYstyp+XNbPpRiob2gCj+aiKalKDqpFwLL5ASIMtWprx5uzCKb3JkEAOpXKVpczZs24fHDetiPSPFmh0p77lYR4CX0x9I7+dpNc0F+rVgbEMZEpYmIzg9LQp9hOg4Y7gkJTf1YWZmRoV2kmaTip6qFD0IH2xLU8iZszUZD49YWB0mxFb+eM7C/YoXUBRSz33NoGZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iHv6TOs9LVuICghAQs/dBmFKfRG4tA0FWPL4yuIRwpY=;
 b=KmqJ8166ONHlLB9/Zl7XTBlToPpoa+HpqC7t6CzcK0kSCTlPQrRFCtxaFFFrcj0abgcD01Ey68Z/oQgAivN4koagMMRBT6FpVgWYgTuvGmUMG/jBrOeunW9xdll1t5DGKfZPGykthaJ5WGDxBFodCJgfIZ1pG7EZm8nwwpeFWscMjLRz9+P5TRqts6aZq0CN82coeJXppHwjmrYbe9xTruX1f7xdOLPYvSH3Z96HAlFso5+9L7CNkHyRDyjwtn3Ra44pgYTXLkFxQGE28e8GU3tYNgHrr94sQ3HfkOtAwNjy2Blumk87HPJ3SOuwFo9ZXff4b6yixJaZQd7EnfemlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DM4PR11MB5390.namprd11.prod.outlook.com (2603:10b6:5:395::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Wed, 26 Jul
 2023 13:46:44 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6609.032; Wed, 26 Jul 2023
 13:46:44 +0000
Date:   Wed, 26 Jul 2023 21:46:33 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v4 09/20] KVM:x86: Add common code of CET MSR access
Message-ID: <ZMEjudsdr8WEiw3b@chao-email>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-10-weijiang.yang@intel.com>
 <ZMDMQHwlj9m7C39s@chao-email>
 <67250373-c5f4-d1d7-9334-4c9e6a43ab63@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <67250373-c5f4-d1d7-9334-4c9e6a43ab63@intel.com>
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DM4PR11MB5390:EE_
X-MS-Office365-Filtering-Correlation-Id: 848d8365-abd6-4878-8c6e-08db8ddebf68
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eyOLEuwuugZPn28B16IP7w+b1RL2mk6RCVwGQRDBCYbXh5frs2kfXCL6BmhnfPP2oAgz8ww0FrxuYfXeDYWsKHFbmNObmjaOCOlwJ+ekhfJEzJE6j7ufOgxSzC1gViVYrHChTto+N69pdP6FrmpiVMiXc2yKdHFoatRVB19qlw+SH+qUkUvoiegUZyWg9hkQpxycO54hqe/SzdT9Ecfx4Dpw/IYNNAUnoSO86rogKbhxlKem0DXWx6RQqYckGaFr4T8L2018pOkN5zoNo3a7Dzz7P/vu1o6Vz5HOGGGMRGv3GPY2z3obQbbFpyzR5zhQ9m/q2NxlqrNF8RYInKXM9CEQ2fytk01rcR3XeYJqPpuuV7JptAZfQhiNGPM4ea43yvxsOwaEXA93n01+7pmzmRoLmfNkWIlSUVydXBqnlM+/lYVsSR2AR93KvUE4kUjUjk0y9KG8Xtzrevrrxm0VgKlnADwKTliWcgjQAxpDATcvSTTFJPObuAf/1swUfItpy1dPBL8IhNkVWlSrgxTCryzV0obAGAuB9ShpLKFHVMGrqvFIK4YQDjzW5CfVq40M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199021)(9686003)(6486002)(6512007)(478600001)(6666004)(83380400001)(86362001)(6862004)(33716001)(66556008)(2906002)(66946007)(26005)(66476007)(6506007)(186003)(82960400001)(38100700002)(6636002)(4326008)(316002)(5660300002)(44832011)(41300700001)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?l/FjcgBetxW5/j2jpRD/uqvW5kuBDEhj4s92rtIv624AWxloKRPrcyV3BC?=
 =?iso-8859-1?Q?mQFhZCVRM54h+j0h5nYD9Iyw47zR/rlT8xyMXTyYLMJeiGuKYc3Ckw1uBb?=
 =?iso-8859-1?Q?vTmd/Dv5PSuOiS4GFj7/IabUp0iaSRLFx+hFx7udJ4HfNn43Iv8kHF8qpf?=
 =?iso-8859-1?Q?PSH0shzQ/XdEKLTskyi/hetmtxo3cl7XDdbk1ZMUFM1hD1ReOkNtfAYTxM?=
 =?iso-8859-1?Q?qAMJxw86+YNfDxFAHtocT1+7Z2Qer6f+8+W1k7HTeTyjkQ4JvJJXV6769n?=
 =?iso-8859-1?Q?gQXu6060ETuKZfRjS8F7ASRmLTneyWWCSLar0vObFCfI87LV6GiA/FRG5N?=
 =?iso-8859-1?Q?kElo7DcyU61B15xIkC4DXTuBRb8VEp8E0nIUjpVyVyJkipUopEF/nlCGga?=
 =?iso-8859-1?Q?4dQYf2QlonK6DDu7vt4N5FqadqLkzrtTMIleuxKxss7Alr4AkkTRcFj9lf?=
 =?iso-8859-1?Q?3dtIWuD2krjaxjgELesBlnqZVS4RvT6GfJwvJO19AUDsih/UvuL7+I7gEI?=
 =?iso-8859-1?Q?CO7OqhukmSyvUBJXNQzjD2lDAvBz0OGlLR6hbo7SNQPLzYPEzyFtx9zhb9?=
 =?iso-8859-1?Q?6ctNBI88TpXihnZBiphYWOte3VnxY/IqJVRql5gbyRLdyQAlBTWY90q2tv?=
 =?iso-8859-1?Q?8mc/d4GLAMsUuHS01AY+Y18MKcmjv+zY7q+CLeNxnAMpkCKRoqhETVURTB?=
 =?iso-8859-1?Q?WFdq/dIEDlTYlPQ9vzyNgZGdmRU+tljGeVgMMQR2jJF6mAaa6AWGAQ7KCt?=
 =?iso-8859-1?Q?clO00k5SBmjRkcfekdoSMR0ZJozMYI7022+smsUewP3hOMMyO3z8SnsLDK?=
 =?iso-8859-1?Q?nBQA5qhFP67eANjt3dd7EwjwbuVAYuVk46rwQTuBcwBmJgqcf/Czs7PpiH?=
 =?iso-8859-1?Q?PkiMiQugaTEVqjwuW6C0Pu9ny0894MZX5BI2p9lwSq434gMMaOhKxkyuAL?=
 =?iso-8859-1?Q?dbRMTSBKTSBsaxVIRM87PC+nkUhmQRBG3cYOxax+d8LO/qCVAxlBQkWrh7?=
 =?iso-8859-1?Q?s7jlVLLmSLkCyXNJxvzG8ODgpwsfmJJarJXpzwz87aWxYeSee3mrqL1erw?=
 =?iso-8859-1?Q?UuC+xk5sI0Yiyw690s0c7hX21mkHMadcEhGLRx0GejTssV3Utddszsb41V?=
 =?iso-8859-1?Q?0OclbJF1VVTGPzzmPZEZJ5DfuzWROObsrQUjj7+8PDPO1pxkkT2+qJ7I8d?=
 =?iso-8859-1?Q?RuKT2owiPSmmCk2y1xUUnwn40akgmvUG+s2WA6BVUA903xAwvcTGoGdoVh?=
 =?iso-8859-1?Q?kaShB+SsoEwaALnUOWWvm+T92zd+kDbGxXKj7ckaxstSImh+WEeBrW7zYX?=
 =?iso-8859-1?Q?5ugbDMIhUe4wVzSniJDf4YTni47fHaRZ/FEvL65HnB/OjroBNHTOOxBkr4?=
 =?iso-8859-1?Q?nPF4r1fqJ/4arwlk10yeifpIOIvgQp/BVmV8uteIvxajoM22BFXYiqR0Yi?=
 =?iso-8859-1?Q?SWNrjLU674znN7eGAhDfPxB73IlKrFFGvyMJNKApVYrT9Sr6sb4gULQDjY?=
 =?iso-8859-1?Q?o9YLfPuk6T/3LsUaBxiGKBhTfn9V4uPXLtNhvJogNuh62MX4UhsMwTNwCm?=
 =?iso-8859-1?Q?V6YWkK9qE/bJQQZ5k8lVfD4MfB3FDGvEbzsjS6HwCkL7E1uAAm/dcXerCj?=
 =?iso-8859-1?Q?vsIK/TQ/sIfLZqeQVQhhr4hmD/CKi3GXyS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 848d8365-abd6-4878-8c6e-08db8ddebf68
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 13:46:44.0211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s7xNlShTLRF2zE8atc1Wn8UaTMUBUggM1yyg/F5z64MoL/KeiYcyvrTl1uYGyPWb1WnObEmZO2EZqDokdUY+2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5390
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 26, 2023 at 04:26:06PM +0800, Yang, Weijiang wrote:
>> > +	/*
>> > +	 * This function cannot work without later CET MSR read/write
>> > +	 * emulation patch.
>> Probably you should consider merging the "later" patch into this one.
>> Then you can get rid of this comment and make this patch easier for
>> review ...
>
>Which later patch you mean? If you mean [13/20] KVM:VMX: Emulate read and
>write to CET MSRs,
>
>then I intentionally separate these two, this one is for CET MSR common
>checks and operations,
>
>the latter is specific to VMX, and add the above comments in case someone is

The problem of this organization is the handling of S_CET, SSP, INT_SSP_TABLE
MSR is incomplete in this patch. I think a better organization is to either
merge this patch and patch 13, or move all changes related to S_CET, SSP,
INT_SSP_TABLE into patch 13? e.g.,

	case MSR_IA32_U_CET:
-	case MSR_IA32_S_CET:
		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
			return 1;
		if ((!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
		     (data & CET_SHSTK_MASK_BITS)) ||
		    (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
		     (data & CET_IBT_MASK_BITS)))
			return 1;
-		if (msr == MSR_IA32_U_CET)
-			kvm_set_xsave_msr(msr_info);
		kvm_set_xsave_msr(msr_info);
		break;
-	case MSR_KVM_GUEST_SSP:
-	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
			return 1;
		if (is_noncanonical_address(data, vcpu))
			return 1;
		if (!IS_ALIGNED(data, 4))
			return 1;
		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
		    msr == MSR_IA32_PL2_SSP) {
			vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP] = data;
		} else if (msr == MSR_IA32_PL3_SSP) {
			kvm_set_xsave_msr(msr_info);
		}
		break;



BTW, shouldn't bit2:0 of MSR_KVM_GUEST_SSP be 0? i.e., for MSR_KVM_GUEST_SSP,
the alignment check should be IS_ALIGNED(data, 8).

>bisecting
>
>the patches and happens to split at this patch, then it would faulted and
>take some actions.

I am not sure what kind of issue you are worrying about. In my understanding,
KVM hasn't advertised the support of IBT and SHSTK, so,
kvm_cpu_cap_has(X86_FEATURE_SHSTK/IBT) will always return false. and then
kvm_cet_is_msr_accessible() is guaranteed to return false.

If there is any issue in your mind, you can fix it or reorganize your patches to
avoid the issue. To me, adding a comment and a warning is not a good solution.

>
>> > int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> > {
>> > 	u32 msr = msr_info->index;
>> > @@ -3982,6 +4023,35 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> > 		vcpu->arch.guest_fpu.xfd_err = data;
>> > 		break;
>> > #endif
>> > +#define CET_IBT_MASK_BITS	GENMASK_ULL(63, 2)
>> bit9:6 are reserved even if IBT is supported.
>
>Yes, as IBT is only available on Intel platforms, I move the handling of bit
>9:6 to VMX  related patch.

IIUC, bits 9:6 are not reserved for IBT. I don't get how IBT availability
affects the handling of bits 9:6.

>
>Here's the common check in case IBT is not available.
>
>> 
>> > @@ -12131,6 +12217,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>> > 
>> > 	vcpu->arch.cr3 = 0;
>> > 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
>> > +	memset(vcpu->arch.cet_s_ssp, 0, sizeof(vcpu->arch.cet_s_ssp));
>> ... this begs the question: where other MSRs are reset. I suppose
>> U_CET/PL3_SSP are handled when resetting guest FPU. But how about S_CET
>> and INT_SSP_TAB? there is no answer in this patch.
>
>I think the related guest VMCS fields(S_CET/INT_SSP_TAB/SSP) should be reset
>to 0 in vmx_vcpu_reset(),
>
>do you think so?

Yes, looks good.
