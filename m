Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1CE76FB72
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 09:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbjHDHx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 03:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjHDHxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 03:53:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2A512B;
        Fri,  4 Aug 2023 00:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691135634; x=1722671634;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Hai1ULcCtO281cynLHgfcaYfXo+/JAZNyBrZlUMuTWk=;
  b=NPEO8sQCwdxaXnyqmRDs4hYdJt03A7z9r1mzQfsYbpDoK+lev9sE+4HW
   NCTcHDUQYbPJt10mQzsAg7DTNLMQiIXojnF0ZwmlNbkTHLhzHK/zFK56s
   QWc6w8O6XDGQT/GrEECPKf3kuRpDVXuc8Z021TLFxlgQVTmi+T/a/8+KD
   U7i8CYx658oQm9QA3h0O85n9sQfpoZDotVyWnxC4BhfqCiZa/XjlF0BOz
   SacYSr67MFOI3muZyvxRmnvzOtRMsIMNVqweXLgKOpoNR8foG0XvLoP2L
   qWJByD43LUA3vIJ4NlPQYl7pbuzSg7Fd03dQp3rMxb2SUdPD1YDH+ofuD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="372842912"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="372842912"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2023 00:53:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="679822209"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="679822209"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 04 Aug 2023 00:53:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 00:53:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 4 Aug 2023 00:53:44 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 4 Aug 2023 00:53:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPA5Ca9ALYMtAzudaB1PUWRNxIB1MXjejLcyi22z5HRS8iZXyrwsfZ6EvuAkQ9xv3oUxpdag1vQdVnZyWzXOMC94/BRlQxnlz1dyRcAiBkCr5th+ILat/nRxgn6i7n+Ejb1vnrUkPFSrzOCRUu1S7/BPk6DHsJPguXriSIreVjczW30lyVqcwt5MaEjxeYPtNtPLc714KU2PQYYNlj+wg2TwS90KEkjcW7P97AUn6qaDSH6uIlnqdKn+Jmni6BeESHVPDzmit9jzJbCGx4aVIyFsAuiN0PrBYjFpdD2Tz585sPn7h3pXt2F4g2rqkoxmyA2eOwNhxgPdxLf04k5Sbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Imk5GSEKPI+eC8ALQY+vhLqEHpjzXB60mvVcd7K+M0U=;
 b=FcfczAuuX4Hyfr8u6lKA0jnPEXTrOB/0q0rZvSfkH4mS09feyNvcZK8etaCSpGBaJJlhJvhbz98Wte/gVsV8snytjOPvq8zL6/JO2GNG+R+OxL1JLlDvSbZxosIOXCm1TVpKDmLIzCSC47Nmq9fHNClgMXeJ8Vtdw/ryQ902/hMkXxRj6gPtqu1NkyaMjS/BWa5HkY6+DuUk1MCIQ4IqJOwJFTekYEcnbn4EYw1FkPBgsTmOouPGeRtafGhg2lWDsvOcdAUuoPsI/dwpGqflq8H4/uJ9uujm+gLAXnqclfmXYsqtwqyJWcP4ID2uNAm+icpcK9OTeF3wCNxAKfqD7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CH3PR11MB8210.namprd11.prod.outlook.com (2603:10b6:610:163::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.21; Fri, 4 Aug
 2023 07:53:39 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b%3]) with mapi id 15.20.6631.046; Fri, 4 Aug 2023
 07:53:39 +0000
Date:   Fri, 4 Aug 2023 15:53:28 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v5 12/19] KVM:x86: Save and reload SSP to/from SMRAM
Message-ID: <ZMyueOBXMwPkVk6J@chao-email>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-13-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230803042732.88515-13-weijiang.yang@intel.com>
X-ClientProxiedBy: SG2P153CA0020.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::7)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CH3PR11MB8210:EE_
X-MS-Office365-Filtering-Correlation-Id: 2768c833-280e-41d5-6405-08db94bfea22
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bZBawM6t4vEQBWEIyZwToPdKptGvc5Ut6PS1+XhPTgfTwQmMwLysukX/TY6US7J/L4hG3dJxjQjuI4g45uv3PhIx2Xv087n7rUTcGwORGSc/dArtMH066c1nRC+0wzJH5tjgMH0kfQQNo0C3Y4izsQtaR0Egq3yw/TjhmznUGPxdPAU8iBlmlavHnFr/eMfPMgFukq2FggUYZqh/l3Z/H9DsqjSVDE4/VptcoU+AvC4ImSGeg7sGrzsjiBXJy5jAa2WGiSV+wz6FwXpB0cUYwm6R0Jk32LvgENEkbYSv1AUvmQFlPh1NCtjKbMxdDE2ozmbyZ4p7ILDSL0bZR1M6PJ/+Tb1C4IN/GdkqsEII7ZAaIwSxmpA7lhu7yz+qUJ2mAfgY3Kfl8Pt2MkvK30m9PORATESVGLgDcZP+CYe3pBk+UuofkMLSsm8TENnzmFr64KSBiGGVUy7z1n3YR+J/NFfyyKyG7U+QrdPwmffFFZUxEOXfoYByIW0C/VOO5SH+ygou9PBdnVT/6n+6NBuNH6RtS2KzLbyWqh9vYHn1eYM1Riw/WfO3T45da8I31CjP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(39860400002)(396003)(376002)(366004)(346002)(451199021)(186006)(1800799003)(6666004)(6486002)(9686003)(6512007)(86362001)(6506007)(26005)(83380400001)(38100700002)(82960400001)(33716001)(5660300002)(41300700001)(8676002)(8936002)(6862004)(4326008)(6636002)(2906002)(66556008)(66476007)(66946007)(316002)(478600001)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lgUvc4L6NbSowZ9DhK3tm2OadSEUiXTlntvgaNXhOVBhbZBX0can8e8lRth1?=
 =?us-ascii?Q?XVARFFdB9nZC9qjrqO7ci06moKWGGDpmAGCvKsvMm97+eZvA7EttuvVy2vi+?=
 =?us-ascii?Q?83TSnZ7AuBCaqN6hwBJzCqn6qYKLHQi35sH1M2elhrJtmntNBBzhNdcbG2An?=
 =?us-ascii?Q?z7+c/B8n0lEIufXt1Yv1nG6sKzEnxnN86wqh2P/ec6aM5IyrVPMOwPc0TYpI?=
 =?us-ascii?Q?NfQTG9WvtRnCYchzmm8Sgx3vRyUB84V/O6IpLNxAENrMBPUxb1GI4OBVTvZd?=
 =?us-ascii?Q?WBbTbmbInEb9yLtl/4rOc9fqZPpeqeSQ8Xh+KpNK9q12V5HAVugq9W2LbuB2?=
 =?us-ascii?Q?Bt6EHmTR/lIROfZ1/kLs3rOAotjOiC0ozi//2Jn5lOOkB0EYn8tC5DRxpVuK?=
 =?us-ascii?Q?YilbXsjd7cCEuJd0qvDU8TV+1jU1OLDHAh4gJ90JdMyJictLqZa+mdR8lkTD?=
 =?us-ascii?Q?VfSqgxOiZbVtyh45u5KiiNwhnwYeJ86faf+LZgJj30bk9hnjDkE01NS1fyuw?=
 =?us-ascii?Q?gFpsd5fhXaakBqvO2xLaZDEyKw5BJI5Alexiba+3Mcq+JKyDVrit2L5nCXP8?=
 =?us-ascii?Q?vX4ICWBcHEkYjjeaVkWR93I3StEtReCgwrRIDb0Ig08O+8h3ToUNoZ2rgBiH?=
 =?us-ascii?Q?D39QHsXTVqI4GHkqrrrBelUpCjTGTTNIqAUQLaMfrXHoGgPj781db5HfB3zD?=
 =?us-ascii?Q?mvoEWxzoXwJKZ6rX+RjWjZC0PEUK28cWY+Rp6E5N6IwLXdA9QO/dCfgQzg4z?=
 =?us-ascii?Q?rNmg1UkCPgYDzRyg5Rw5NWRLut8Fr1B29OQbJSHxP97CasGF+RWGFbNQRCWL?=
 =?us-ascii?Q?Z9fp7ImomCaDL7PCVL8qf4k8xcVj53HgLmogdUWlTYlQoiyXw0izOxlypoN4?=
 =?us-ascii?Q?w/DqbPE50e2QPWYc60AbY4+3UVrAtFR0OdoMd0ONjSoMNUC3pKylxQZrGmb7?=
 =?us-ascii?Q?cR+6Rr+4zIpzi2jP/5TsXkK3te5c3c47M/XA+pJgHBgIJbJNyfpckbbazJAX?=
 =?us-ascii?Q?n/zSV7003x8h3mJGIHQmwcwN7QTdoW7q/G5ZNUULszof0+HyieD1SqjpUY2o?=
 =?us-ascii?Q?nZhrTFyO3qA3GTLM/Ahsxtbv6yo+MNah2wEWjyoTfW1XB50wBKPZdyKaUbUd?=
 =?us-ascii?Q?5qUO92i+R+ozUg8/cQgV34slXfQt3/M7Iw7JSiGq223sCZkQgxEuDJ/UTAh2?=
 =?us-ascii?Q?IWWUm77bN7uw0JMI/LR3na2dBmcTPw5tsBQdcpJI8p0EkZ8FJGTyVxg25mHP?=
 =?us-ascii?Q?lV5jUrS+z+6TstuQJxQRYyI+mBZw6qN3rA9E2D0eDUXr8WjFuwvXhxOF5EL0?=
 =?us-ascii?Q?Sy7j7rurTC9v2Qpxidu6IDQyHc8QBGZBpY2Piy6xg8VYtX8adDIPzIpY/G2w?=
 =?us-ascii?Q?VjnKXTMDaSetIbwGj3v956aT7dSX9HBXXyD6ip4JX9IatmZDa5bDTmQ11kjs?=
 =?us-ascii?Q?yg5L7beRMEZGm4sb2IHmqcQxx9roEUBmsja8o59GlWTj0w8QZ6JYCWd4cDQ0?=
 =?us-ascii?Q?V9zJYikTkm076aF6MHJ/IJi1e1qSaJctw265L9s9D+OSoLWUW+OiiDXwfZqa?=
 =?us-ascii?Q?/TrRZ+SMVcTLGEFQO95j0eOA6M3AWcBolRxVeges?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2768c833-280e-41d5-6405-08db94bfea22
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 07:53:39.2670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yvvXA2AVIVBC95tRcP3Y7FPMl+iDesocsmIpYG9yVQIUeyRV0jPvoL+nXMBAn8NqIpPhgFAs+rL5dhcEPA/HbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8210
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 12:27:25AM -0400, Yang Weijiang wrote:
>Save CET SSP to SMRAM on SMI and reload it on RSM.
>KVM emulates architectural behavior when guest enters/leaves SMM
>mode, i.e., save registers to SMRAM at the entry of SMM and reload
>them at the exit of SMM. Per SDM, SSP is defined as one of
>the fields in SMRAM for 64-bit mode, so handle the state accordingly.
>
>Check is_smm() to determine whether kvm_cet_is_msr_accessible()
>is called in SMM mode so that kvm_{set,get}_msr() works in SMM mode.
>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>---
> arch/x86/kvm/smm.c | 11 +++++++++++
> arch/x86/kvm/smm.h |  2 +-
> arch/x86/kvm/x86.c | 11 ++++++++++-
> 3 files changed, 22 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
>index b42111a24cc2..e0b62d211306 100644
>--- a/arch/x86/kvm/smm.c
>+++ b/arch/x86/kvm/smm.c
>@@ -309,6 +309,12 @@ void enter_smm(struct kvm_vcpu *vcpu)
> 
> 	kvm_smm_changed(vcpu, true);
> 
>+#ifdef CONFIG_X86_64
>+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
>+	    kvm_get_msr(vcpu, MSR_KVM_GUEST_SSP, &smram.smram64.ssp))
>+		goto error;
>+#endif

SSP save/load should go to enter_smm_save_state_64() and rsm_load_state_64(),
where other fields of SMRAM are handled.

>+
> 	if (kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, &smram, sizeof(smram)))
> 		goto error;
> 
>@@ -586,6 +592,11 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
> 	if ((vcpu->arch.hflags & HF_SMM_INSIDE_NMI_MASK) == 0)
> 		static_call(kvm_x86_set_nmi_mask)(vcpu, false);
> 
>+#ifdef CONFIG_X86_64
>+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
>+	    kvm_set_msr(vcpu, MSR_KVM_GUEST_SSP, smram.smram64.ssp))
>+		return X86EMUL_UNHANDLEABLE;
>+#endif
> 	kvm_smm_changed(vcpu, false);
> 
> 	/*
>diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
>index a1cf2ac5bd78..1e2a3e18207f 100644
>--- a/arch/x86/kvm/smm.h
>+++ b/arch/x86/kvm/smm.h
>@@ -116,8 +116,8 @@ struct kvm_smram_state_64 {
> 	u32 smbase;
> 	u32 reserved4[5];
> 
>-	/* ssp and svm_* fields below are not implemented by KVM */
> 	u64 ssp;
>+	/* svm_* fields below are not implemented by KVM */
> 	u64 svm_guest_pat;
> 	u64 svm_host_efer;
> 	u64 svm_host_cr4;
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 98f3ff6078e6..56aa5a3d3913 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -3644,8 +3644,17 @@ static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
> 		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> 			return false;
> 
>-		if (msr->index == MSR_KVM_GUEST_SSP)
>+		/*
>+		 * This MSR is synthesized mainly for userspace access during
>+		 * Live Migration, it also can be accessed in SMM mode by VMM.
>+		 * Guest is not allowed to access this MSR.
>+		 */
>+		if (msr->index == MSR_KVM_GUEST_SSP) {
>+			if (IS_ENABLED(CONFIG_X86_64) && is_smm(vcpu))
>+				return true;

On second thoughts, this is incorrect. We don't want guest in SMM
mode to read/write SSP via the synthesized MSR. Right?

You can
1. move set/get guest SSP into two helper functions, e.g., kvm_set/get_ssp()
2. call kvm_set/get_ssp() for host-initiated MSR accesses and SMM transitions.
3. refuse guest accesses to the synthesized MSR.

>+
> 			return msr->host_initiated;
>+		}
> 
> 		return msr->host_initiated ||
> 			guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>-- 
>2.27.0
>
