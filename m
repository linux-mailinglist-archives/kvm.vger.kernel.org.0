Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4E976FBC7
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 10:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbjHDIR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 04:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjHDIRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 04:17:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239B012B;
        Fri,  4 Aug 2023 01:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691137043; x=1722673043;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=T+Vd86hf9Coo2aFjOQ2H46YVxLejYtre51zJnWtn6Rs=;
  b=Q5KW6L/O+oDCpEZHQC6RH4BaxDru3eNMBf3J1iurTS6vBnowTG4imv0E
   4M6ZGb9R42FtJkBb/NgljH9EZqF3cU+EFzfPaIT37nb1Mi22dkdATQGlV
   s+m8Z6IP/VNS97MPSborYg/V3n12j3kUi5gizS9DjKW98WK72VF60VQ8c
   0T711ngSpegHWRh3dpYvxiDG3FhdDfoyLJOws2V9KlKR/X3O8sCxrXlRW
   3A/1LeKw/6Tg2BRZRxcPfj5mwZfYvZLl2sxOKmiH7mOGOuoVDgOkyxVDX
   HGDuJKB0TJO4O6IjLtt2ln/TiZ4sJGdiIlZYNLDDsWwZf+ryNdB3cfSek
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="433949529"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="433949529"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2023 01:16:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="729960136"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="729960136"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 04 Aug 2023 01:16:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 01:16:45 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 4 Aug 2023 01:16:44 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 4 Aug 2023 01:16:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pyl2jaXTKBWtphI8HoAXI6FMEdDcdz18Rz07nnk/hHwxTh+5n33UlPZZULcwvqrm1iMc/u9bpqE0cGOYViYk2owqAXne8XGVIAdHKn2XkDMT5hGjCrxcB/AD9dj9g6OoK/EUXkGr6WpXHzHdgBlxin3/h7t4WyieiLkSE1cCRojzHL5KRNURC4aamTYqb7ItdUFEqUT+ZYdOuJ9V/CyWSU5zBJOAfXxRSf5jRhvRMMchqEkN+kXvL5CHjIpUzzGsrkLnX/M0/vz8EKXCdzYxvC70CfvAIsWPqntbgGvKQJBILnBBOWIbg1oqOYY1W8Q9ceCY2QcVmhwpBY5lNtchaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9SwBvvQMKlf3rakUM80tNruiM6wIeDAev4qyuSkA2v0=;
 b=IzabgFZAx6DruUOlXB9AxYcSRw18wntuJ1ZDsY2GEWYEaZNIpHUkdtoyj4OoyQ2XHcUkqUJz1EW7bclpckirvp9OHKFGizuRglTcunCfZh+g0yj2m2G0Q1kGmIYVGSRdxU06zW3GNdNLp6iq6jFiArksSzCK0m9tes3hJ4immkeVdsz2GByxwEqmpi/wJ+oNgNsyBK1VVr1CiepK9yMaxV1C3S9CTStX6XAAJteuCiKe42Y3WSVhCbmKGnAbf1dV+MyE5ouPjlPEgiN4WCJHavkUoBx86/K9V9KenaNaCcnAIqd+eTArktn3kJIVjy6hpepb4t5Fukpr9afb0qFIoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by IA1PR11MB7174.namprd11.prod.outlook.com (2603:10b6:208:41a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Fri, 4 Aug
 2023 08:16:35 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b%3]) with mapi id 15.20.6631.046; Fri, 4 Aug 2023
 08:16:35 +0000
Date:   Fri, 4 Aug 2023 16:16:25 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v5 13/19] KVM:VMX: Set up interception for CET MSRs
Message-ID: <ZMyz2S8A4HqhPIfy@chao-email>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-14-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230803042732.88515-14-weijiang.yang@intel.com>
X-ClientProxiedBy: SG2PR02CA0085.apcprd02.prod.outlook.com
 (2603:1096:4:90::25) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|IA1PR11MB7174:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e57ac5f-d17d-4709-6e2e-08db94c31e63
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a96wgDdQXryNmqWBVu/mcJLTEZLZ7b2OntjNqTW76RcioDzgpPco7/l5j3dtLOQ+7KDos6noRvLxIZ72rV0wCWc0eBTqmsg8CaPNTC16BS8lEy7v//85TixSFuU1Zf0auORIjVfrc6BMXfFky/iHp5qk2nmaa+KSdcGSTXi4Ein+PDt8D3La5FMfLF+OQ076h80w+/wcMayb1SZLwASX5VSlR0qI5ciZQ1qEzf0456a+JnoaYJP+8JpAuV88qNZ+3VPmLdgPaZV213FDfHAPUuOZnjlymI0IU0vB5Sxme9gvOqZxwkwah/lJFayXxrTwnUbHRi2eySJwgIf2acX4Hca3xC9iYDm5xlNuj8M4XpPZ8f1rhRRsYE4iDCiqMO3/YHy+PiMMBX3uy61nA+/XbGWTK7Kp6BlyNAN/zPdIoCfl8jF9/oA2/25TyzngBkzZTyKNcQmQ5PFEesR+ZRUpXRA/SeeRugjAoWFvFaXdo7c89nJ+5mVXBgfRFHpHJnggopkmbKkG0AEu2fgGzK/3vmN64+CPUq1XRAcjkyIglX8XH5BKjzbDzrxQgN2H1jyO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199021)(1800799003)(186006)(2906002)(41300700001)(316002)(44832011)(5660300002)(6862004)(8676002)(8936002)(33716001)(86362001)(9686003)(6512007)(6506007)(26005)(82960400001)(478600001)(6486002)(6666004)(83380400001)(4326008)(6636002)(66946007)(66556008)(66476007)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ApFPTehu1J5WYnpbQUWpZTlBKfCuWx7QDR1U+6Ez9fGD7oPYegxV3mkH+2SB?=
 =?us-ascii?Q?txXfLDekeMrC06dsU/ZaHL6yjcrAl/dy3zVrxHQGZ+iTqXhgbW0gTdKkRso1?=
 =?us-ascii?Q?dRsznKfCdNcDjSJKn7Tdl+88K9qzKfDEXUu5Bl2rb5KabSSHV8mSnMhPn7OJ?=
 =?us-ascii?Q?S3AZBGAc5J3DKoRg4akujdTxubIjgwgqrtuKVyVJYZ8bZCmJzAQdtotCGL1x?=
 =?us-ascii?Q?M5KTTAVRNDujG/bVFR4MiDeC4h8P+RyOmcP+W6+X8pL4+FW+WEP+q4en5u+5?=
 =?us-ascii?Q?p0ddGQ9aFbaGokgpct7oBmr08KBFnUl1qRXmtNwjrLaWarDAHYlZx3JN3l2e?=
 =?us-ascii?Q?d6WvTyAeljL+v/X1EofCsLTrGP03IOA2YNZacy97fBeXJYJQbNtdhatA7RC8?=
 =?us-ascii?Q?Iz7CAc6GnMF9fP+GQ+eag+JDRWm0mqabk5JfVrfrTwNuVEt82p/1++I0amzM?=
 =?us-ascii?Q?D4IC4rMsYZS55CEW7+4sptPeXwHyCnJ4f5TscKpzgVXaQHzbb2rx6nZrNnrp?=
 =?us-ascii?Q?ZVuq4/hiN5ibd60VA5wGwr3IcnrRBt/q5Qw/h+4N5JBGaGbR7niQUCvg6qH9?=
 =?us-ascii?Q?WIXVwoD3uVMUleCHpLaW3muaMCqhUBOU1uvk/EcgnMtycbvtoMydGh6v+klU?=
 =?us-ascii?Q?zWnNKXVI8lwEkG0cM7pUG5S1oEeHnb/6p21GU02h28qx9uOhBKgS0nq1LZ8j?=
 =?us-ascii?Q?kBxOuF5tgo4HhftCtdzUnWRyuqxEqGVDlUJ0jpoh1iliF3sO7mC4cMe7/T2O?=
 =?us-ascii?Q?K7G93WgPcLhuAWsU6WLCPAgBKWeudXvvbWcu6fkB5ZU6z3N2ce7ORujIbnPm?=
 =?us-ascii?Q?+uCHOll6CGinMMpJTHwA9bVvIA7iPqduQoLMhKPol+Q4if9zqJbKSWOcTBqV?=
 =?us-ascii?Q?BmUOuK8sjsG1CABwxTrjV4fNoJ7X7l9v+rp+w+Fu9nUyadEfJ8lLcZtiDA+C?=
 =?us-ascii?Q?Rrdqdrj2hejKzrqMjhAK6+EPX4zXKFfNOZM51NuVhrjaS7IIurDOtXCS9Y0J?=
 =?us-ascii?Q?HSyGEGfsI7Wkyg/lqaI9OlgdL7AuCRXR7ZylUgep/7yM5VWM6PkfXT061JtV?=
 =?us-ascii?Q?a1I6NL2r8wpz+xqnJRf+lZo4N4iyS97vc+16HN9yI+iqOkltQxZkenoE9EsV?=
 =?us-ascii?Q?SZocHR5+OaFEXkJRf8FxbpCkwbl4DqsnhMT7M9nbpmbCJ/Er7UZCdgK4vID7?=
 =?us-ascii?Q?oLI2mjdizKMPetLtEXsbF3IiUJAc2Lcv379vildwJ6dcL5qiN2VpGuwr/w9z?=
 =?us-ascii?Q?xCMh1xBbBQnNZGQF1f5+UDaL9vJP117wcGQzgN/dBvSuSbXw0HMxiDx801D4?=
 =?us-ascii?Q?Azq0AYgB6/Bj0T/SeHa/UAo0Aq42Xy5YgJGegrUz6dOiuKk9IcaTZcQz4qMd?=
 =?us-ascii?Q?M8DHhzL0oW9rSj8ZiMow7T6LJSWetPJNuPLdG1EDMc4lZ9Hq7C927toOfich?=
 =?us-ascii?Q?7NhobzmP5sBtyr6N+x7pHtLJ9VFkl0hFDDpwdDIOedg3XEnkC7FiUK7pe9vz?=
 =?us-ascii?Q?l+uunYc9t8xgzUmrpgcuDYUG/q6xzR2Oy7x6QNJ8MXBxH7mQfmbgvek+hFZo?=
 =?us-ascii?Q?ItJ4uqRDuyuR1gR7Gy+rgvkQC3nIZyNjgBdvJjvr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e57ac5f-d17d-4709-6e2e-08db94c31e63
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 08:16:35.3458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LUyaYcNYYO5JrinIQ+GxjSv1xLftutB3iJjjgGDf3j6XBJkDInFGKheDeitZ4XBhdz27uhUk4xo7UO/jpmMuCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7174
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 12:27:26AM -0400, Yang Weijiang wrote:
>Pass through CET MSRs when the associated feature is enabled.
>Shadow Stack feature requires all the CET MSRs to make it
>architectural support in guest. IBT feature only depends on
>MSR_IA32_U_CET and MSR_IA32_S_CET to enable both user and
>supervisor IBT. Note, This MSR design introduced an architectual
>limitation of SHSTK and IBT control for guest, i.e., when SHSTK
>is exposed, IBT is also available to guest from architectual level
>since IBT relies on subset of SHSTK relevant MSRs.
>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

one nit below

>---
> arch/x86/kvm/vmx/vmx.c | 41 +++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 41 insertions(+)
>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index ccf750e79608..6779b8a63789 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -709,6 +709,10 @@ static bool is_valid_passthrough_msr(u32 msr)
> 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
> 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
> 		return true;
>+	case MSR_IA32_U_CET:
>+	case MSR_IA32_S_CET:
>+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>+		return true;
> 	}
> 
> 	r = possible_passthrough_msr_slot(msr) != -ENOENT;
>@@ -7747,6 +7751,41 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
> 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
> }
> 
>+static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
>+{
>+	bool incpt;
>+
>+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
>+		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);

...

>+
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
>+					  MSR_TYPE_RW, incpt);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
>+					  MSR_TYPE_RW, incpt);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
>+					  MSR_TYPE_RW, incpt);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
>+					  MSR_TYPE_RW, incpt);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
>+					  MSR_TYPE_RW, incpt);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
>+					  MSR_TYPE_RW, incpt);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
>+					  MSR_TYPE_RW, incpt);
>+		if (!incpt)
>+			return;
>+	}
>+
>+	if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
>+		incpt = !guest_can_use(vcpu, X86_FEATURE_IBT);

can you use guest_can_use() or guest_cpuid_has() consistently?

>+
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
>+					  MSR_TYPE_RW, incpt);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
>+					  MSR_TYPE_RW, incpt);
>+	}
>+}
>+
> static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> {
> 	struct vcpu_vmx *vmx = to_vmx(vcpu);
>@@ -7814,6 +7853,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> 
> 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
> 	vmx_update_exception_bitmap(vcpu);
>+
>+	vmx_update_intercept_for_cet_msr(vcpu);
> }
> 
> static u64 vmx_get_perf_capabilities(void)
>-- 
>2.27.0
>
