Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2010469218F
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 16:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbjBJPGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 10:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbjBJPGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 10:06:04 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E130211F5
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 07:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676041537; x=1707577537;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KY4cKjzAx3QiCQKeDOzOlnqHJc6PDcM/IQcSZjG5Bac=;
  b=kVgJMmHwKdK9E3XcI8GV+R6TewnLjQgsQVnaJMy/fzT2r5bD4IsJ/Mtr
   TSw1O7/Yb9cBJjdsWTssu4990I0Wfh8K+r+/PpHvKcPpkQWAyOXO2x3R/
   SW7ZuGL/0ONgIWXVuXtEAbXnYS7twCzODjIs96RXPD0Vn3e67HBn42ELe
   /3O5GUu3WZAqn/es+ZYcK1rU3AAEvAe0DdO8M5bqyLcCiaWZTpMaBHgkM
   R8MM2iq75C8FgyJrM3BfYJZnsHzjhzfwwLTDUoxTnc8vnopAaJEz/gqBh
   lt/Kpe90eEU0MeKEjge9xhiNJuyMgggNgHlOD9U1f9k4dD7SWfReFNWhl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="330443919"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="330443919"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 07:04:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="736769985"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="736769985"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 10 Feb 2023 07:04:44 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 07:04:44 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 07:04:44 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 07:04:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ur2Owx4G1aHg7W5zHHwUkLKB10IPFUzbjygQuRrOzgUCodgs7xmrzRo0Wc0wNhI5vYorCmbxSng75UBNHDtfhUSHy1SINlEiev/rDBGOnAr0n2Sn8ybqOZHoqIY5ATYOJczqRaCZ7Wp361fYvvojpHlzjWdz56B16DsBQtfqB5TmsTJ8gMxBLIoSsOmMLZ/rYTFoDpiwnHqDiF7YgxaFDhbWgg5ySmHCLqIQfQHHN1nMRC/Bme2BCTCu0yZ8Ma27i8Rf+DtPRhCdwtrG7SCecoPAQz14hrtcZH8NkBcW3beg47w+Qn7W47ozi6aKsXlTpY2nG49TgLq66wHLrmrg3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IaZg+u5F1gRD4c/Rh2yPpVOPHqYqxXPXiE4FQDEQ6I0=;
 b=EG+fTE2bPwuF9pjQtPMR1Q8BGW1svyAAx9Xl2nKNGAwxihYsC4G8OwlDv7lmKuLiyMBAAQ9yJgq1uSgH93rPOLkmt0kofLvZiCILGlsYBdlELNcI1/+cjIQqG/Cjh+i5A2WKHOZRlo2gCz9Nxuh1t/QCQG2E4A5IxKOsmx+CVFjPWtmMgqcn8PTvcgYJpcJkS3uNb1q/9h+qg4+nEUOvV9Qjy9caWUj22vReG0Fm9L8KGRIaMycJEHgdbx7bAnXGLCIA+DwbLj2KgNLwFtkzqmwIOKt2LoYhE6tXQ9Th8jfB1eyM0NZWTf6beHMC0QhZBF51Tavnh4QF6g5usVw5yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Fri, 10 Feb
 2023 15:04:38 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%8]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 15:04:38 +0000
Date:   Fri, 10 Feb 2023 23:04:54 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <yu.c.zhang@linux.intel.com>, <yuan.yao@linux.intel.com>,
        <jingqi.liu@intel.com>, <weijiang.yang@intel.com>,
        <isaku.yamahata@intel.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/9] KVM: x86: Untag LAM bits when applicable
Message-ID: <Y+ZdFtr1fJkdCtRL@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-6-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230209024022.3371768-6-robert.hu@linux.intel.com>
X-ClientProxiedBy: SG2PR06CA0187.apcprd06.prod.outlook.com (2603:1096:4:1::19)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MW5PR11MB5812:EE_
X-MS-Office365-Filtering-Correlation-Id: b4f48ba3-3c7c-41a1-59e9-08db0b7820aa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ybWcJljE2Iy0kbdkjludDJEVR3R1AVabGUTG1UeM4BaqUyzQd0xs26+ouaGWGLP0DiVQgQC5agI9tDMiOY52Pn1Dpq1bb09KFlffRqmAb4FW4x1V/vsC80o01+o23/h5F54/kYcRJH+iT7jK02YTyssah0ZUgtcpcC01j2DUi5CqgQf8qvst3jCkX/XIhqO9duPPcN8SI1FkG5InmGvvCzOE0kZ3/5qNykla1VpfZ57mVBPqLh4vZzonatuqHgdeSDu/Nk/WkgrLKXh3/bums+aCf6QD3BhjFvzeaYSFAqYvMnxgQX0gw9zSfvN5QEREa04tBINLswS9aHeF0aA6OXmVORUv/wJ/G45+J8j4NzkWYe+IpU9vBStjp4Mkm8f2BGJ1HzA6ls7aYInGlteqJbDf9K9dTo7UkkO30IFSYuZUof6TYr1LL2GZXR3FpmXDyMaV7wWScmjZFnR6Jy14iB61Qpoy+ttbw3GrnOyRu+U0l++A5YmQoqlViykyJUxAMOz9qVxVGWz2zHqkbC5u5S8MKMaERkxcV1irPMhdtGIIkz2QTbM4eBQPr7Vj32QxF5AIFdiV++fh9abKWfyWdRp3cT+ITP65YPQ53SBJ9U/T9EUb7D4cC8Hv+NT8sS7lb8x8CKLfnIisWJ3v7aNkRVT9AJFvTNDdlObBmFAMmIj8HLFe09Bzpvtd7/7qxLJr0ZrbyRCXwlN41C9QgVDMmJG0a06OIDy2ud9PxxE3H/s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(366004)(136003)(346002)(396003)(39860400002)(451199018)(38100700002)(82960400001)(33716001)(186003)(6512007)(44832011)(26005)(6486002)(966005)(5660300002)(316002)(9686003)(41300700001)(8676002)(6916009)(66476007)(4326008)(66556008)(66946007)(83380400001)(8936002)(2906002)(86362001)(478600001)(6666004)(6506007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wTAM6WZoig46xiS2ZM9WQ+OWeyJV4B39u3Kb2oto8XoyXYeDbk1Loox6D7Hz?=
 =?us-ascii?Q?SyJpcdB0+V7b7Q1DbOJn0q5qmHVs1NTzZ2izRIMwom4jLf7ovWJRCkNcYI+B?=
 =?us-ascii?Q?4ybsbhU3ME4gOTXJaJ0B9RcTDy7PRQFJPdvCgZ3AMP1flL1B9cLZD8pzlq0y?=
 =?us-ascii?Q?OOnPlMXO9eXhHxfJkbhegX9JFCdJTAmScAiQF2cpDSyobMPZupejgPC8OjGO?=
 =?us-ascii?Q?5CXlsGcXmQuqR0OsjmpBDvkQa2ICHH1rrY2Akjxo+kzFjq0646NnT+2Oc85J?=
 =?us-ascii?Q?U1h3e/HCWJ/fMQKgrd2EJS24t8ezQdK6deHD25uD+K+Y4lVzWkxJdb2v9IsA?=
 =?us-ascii?Q?AlpTfqUAwmXadR5KehBQfLYrDSta6HUP5PmN4FgqinKveUHHzWqnYVpc0O5q?=
 =?us-ascii?Q?FWOuFlkQ2wiI63p71c80nGJSUxp9f/tJhwbqx7t5wpFavXgZsWOLMw/VFe76?=
 =?us-ascii?Q?+aDsywI7ERcdPj5p1CgAPkQICPZyJysjLZjHYx7Dj/tvJLVtgVp6n+d33CnY?=
 =?us-ascii?Q?LKkvm+C3sIzw7DmE53fL3vuk1/KyYxX8VMW8nepptJUJp8SwDjQvAI2KS401?=
 =?us-ascii?Q?urcUfJoFefCUgMCGHUEk7gR0KmQICjN9M9Is/ejRPMA6AwBpmi80R03kyrzZ?=
 =?us-ascii?Q?hFuO9GGfeWyCL4WYx+B2HSbUGM1LjLQEUlwKeO6rT4D/acZo+p9zY0fVmsEU?=
 =?us-ascii?Q?NBeOitL8bS+4tKQFOkTaMZKKFWBF8wfl9mzx44OVOjG42frLEZqCt3QpKSGM?=
 =?us-ascii?Q?E7AJJ5q/ibV2Yqr7w0+YOJRG2ddOed/lZkmRJEylqvUkL64+EfK5mhIkCJAE?=
 =?us-ascii?Q?ODzhWWE+GlYg9gAs8bU1BeVqI0oxiSJs5ymkSaqdKgOz6vP+cvEDndSForIP?=
 =?us-ascii?Q?NpBeEkP5TPP6QVnwS+4wzlPe78Y+zQeQxp+8/rx95+uVOLV7PyG1qUaZKyt3?=
 =?us-ascii?Q?UANSHtY+WPfQ0oNcZgMQsHlvS2DtLZNP9Qk09FKztwNoobSJfhNTlBudRpkf?=
 =?us-ascii?Q?+Wv9/URslj6VkD6EVzYleamsmon29nBvTMP+dQtl9GrFGsuoQro3ur8CjZtu?=
 =?us-ascii?Q?2tMA4YazWWz/CliIgWcsbxRfe2T72bFCmHKqcUA1IqgV/bCn8GSRYaEVhV77?=
 =?us-ascii?Q?mPoHPMkcyRLk+x3bYl9Ntj97AADvNaqyN/qAbphEy4RQwwG7Ylz6y8bnXFMP?=
 =?us-ascii?Q?Pd9GMFvJ4RClmTUG99WAHENsz6Vd7+Ile4EpxJZiOwodzAMJE/X+4H+XSz6Z?=
 =?us-ascii?Q?vb0ydRbB34Y/SkWw2xaRNBCynYynV1af1dgGy3gJ4te0U2WJGf0ainbwMDnH?=
 =?us-ascii?Q?X2g/z+TOUv5Sw5nUNXLTfgwsoS/WpSDiYPWf47uwLdvUgod0efZ72LLOJLEX?=
 =?us-ascii?Q?j/pDspzyHtR2cf1kSS1Aw9Ar8L/gd8pyS2dEv9ouRTB1Xkrc/CvZ5YRF780X?=
 =?us-ascii?Q?8EUqmyNMk8refKYhitGOr8x1kh15zmm2svYF56G46C9qRZdI7Y0Fpg+3h2vo?=
 =?us-ascii?Q?Npkz39pRwnqBkmE+p4aNtAlTnu6dwz+/qdlcr+mH0KBVg/aNEBFpykTqaK4w?=
 =?us-ascii?Q?b1DnmSIgucMs7chtVHKdbckE3577HCy1sN2mUv/N?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b4f48ba3-3c7c-41a1-59e9-08db0b7820aa
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 15:04:37.7229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yWjzR7eoyrqNIYBjDFMntX2/nue1NPMiE10HW2sXoecEHOBTb0KYgsTz8O9f7XDWnuD+3vo+sbv79cPulkUNYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5812
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 09, 2023 at 10:40:18AM +0800, Robert Hoo wrote:
>Define kvm_untagged_addr() per LAM feature spec: Address high bits are sign
>extended, from highest effective address bit.

>Note that LAM_U48 and LA57 has some effective bits overlap. This patch
>gives a WARN() on that case.

Why emit a WARN()? the behavior is undefined or something KVM cannot
emulated?

>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
>---
> arch/x86/kvm/vmx/vmx.c |  3 +++
> arch/x86/kvm/x86.c     |  4 ++++
> arch/x86/kvm/x86.h     | 32 ++++++++++++++++++++++++++++++++
> 3 files changed, 39 insertions(+)
>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 66edd091f145..e4f14d1bdd2f 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -2163,6 +2163,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 		    (!msr_info->host_initiated &&
> 		     !guest_cpuid_has(vcpu, X86_FEATURE_MPX)))
> 			return 1;
>+
>+		data = kvm_untagged_addr(data, vcpu);

This is a MSR write, so LAM masking isn't performed on this write
according to LAM spec. Am I misunderstanding something?

>+
> 		if (is_noncanonical_address(data & PAGE_MASK, vcpu) ||
> 		    (data & MSR_IA32_BNDCFGS_RSVD))
> 			return 1;
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 312aea1854ae..1bdc8c0c80c0 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -1809,6 +1809,10 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
> 	case MSR_KERNEL_GS_BASE:
> 	case MSR_CSTAR:
> 	case MSR_LSTAR:
>+		/*
>+		 * The strict canonical checking still applies to MSR
>+		 * writing even LAM is enabled.
>+		 */
> 		if (is_noncanonical_address(data, vcpu))

LAM spec says:

	Processors that support LAM continue to require the addresses written to
	control registers or MSRs be 57-bit canonical if the processor supports
	5-level paging or 48-bit canonical if it supports only 4-level paging

My understanding is 57-bit canonical checking is performed if the processor
__supports__ 5-level paging. Then the is_noncanonical_address() here is
arguably wrong. Could you double-confirm and fix it?

> 			return 1;
> 		break;
>diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>index 8ec5cc983062..7228895d4a6f 100644
>--- a/arch/x86/kvm/x86.h
>+++ b/arch/x86/kvm/x86.h
>@@ -201,6 +201,38 @@ static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
> 	return !__is_canonical_address(la, vcpu_virt_addr_bits(vcpu));
> }
> 
>+#ifdef CONFIG_X86_64

I don't get the purpose of the #ifdef. Shouldn't you check if the vcpu
is in 64-bit long mode?

>+/* untag addr for guest, according to vCPU CR3 and CR4 settings */
>+static inline u64 kvm_untagged_addr(u64 addr, struct kvm_vcpu *vcpu)
>+{
>+	if (addr >> 63 == 0) {
>+		/* User pointers */
>+		if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U57)
>+			addr = __canonical_address(addr, 57);

braces are missing.

https://www.kernel.org/doc/html/latest/process/coding-style.html#placing-braces-and-spaces

>+		else if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U48) {
>+			/*
>+			 * If guest enabled 5-level paging and LAM_U48,
>+			 * bit 47 should be 0, bit 48:56 contains meta data
>+			 * although bit 47:56 are valid 5-level address
>+			 * bits.
>+			 * If LAM_U48 and 4-level paging, bit47 is 0.
>+			 */
>+			WARN_ON(addr & _BITUL(47));
>+			addr = __canonical_address(addr, 48);
>+		}
>+	} else if (kvm_read_cr4(vcpu) & X86_CR4_LAM_SUP) { /* Supervisor pointers */
>+		if (kvm_read_cr4(vcpu) & X86_CR4_LA57)

use kvm_read_cr4_bits here to save potential VMCS_READs.

>+			addr = __canonical_address(addr, 57);
>+		else
>+			addr = __canonical_address(addr, 48);
>+	}
>+
>+	return addr;
>+}
>+#else
>+#define kvm_untagged_addr(addr, vcpu)	(addr)
>+#endif
>+
> static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
> 					gva_t gva, gfn_t gfn, unsigned access)
> {
>-- 
>2.31.1
>
