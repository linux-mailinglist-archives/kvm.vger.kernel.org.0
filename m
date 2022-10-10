Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8885F96CC
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 04:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiJJC2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Oct 2022 22:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiJJC2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Oct 2022 22:28:37 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DAF2610C;
        Sun,  9 Oct 2022 19:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665368916; x=1696904916;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=1osLfIp7zefTA1L6ChHIz/eGvb3nDkSv5pNRXkOe9GE=;
  b=GGwsX/0xR5PuY6Oco5nK4F1cmL6CCRn3QIsqmMDJ1XVGs6o4ZRivLfUf
   tOCXOYWyrvqHAWUfMfdIkjgSmQggNxrsIVlA2HiLXlycuxOwrKFJQti6T
   XD1f6OUXcQ7kJl5OQPoeLYx47/r7kOwn4axAtrjAMlJPO88MqUwitvJ1z
   1OZ6th2aRglRPSvC2+ljClb9DFgv2FQ/6wl32fCIJZ89frs4cEFEV3aGL
   hvHTypgOP5DY4jFMmsOiygdpAghdhQE1SHQg6RJtufzpdIzEZulIZHBSC
   xaiIWPX0IZGncqhVC1Easw9q8/uLd0mUhH/5AFPw6fEB2CREbdeoI0/rt
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10495"; a="302860553"
X-IronPort-AV: E=Sophos;i="5.95,172,1661842800"; 
   d="scan'208";a="302860553"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2022 19:28:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10495"; a="656772808"
X-IronPort-AV: E=Sophos;i="5.95,172,1661842800"; 
   d="scan'208";a="656772808"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 09 Oct 2022 19:28:36 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 9 Oct 2022 19:28:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 9 Oct 2022 19:28:35 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 9 Oct 2022 19:28:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8/+Y6OrYPL2+GaU3XQUxRPpH3d1FCbTydG9VXd65g3hcfl0w8pCJRSIFxxtn7CisVTC5Ipbah8eAmjKSBig6g5Ko8DU5IKmRf/tPxexpizdi+Hy1BDhQgWrGGNIJY2+ZDR03b+YDvIn5JypxvZcz8jjg7QsqnBeu3DqTti2kY8OoGawfU3wWDb9acQiTWse86lw/wlEZTthq8ZmVXKc9jicqP4oaTuy4EsOOJBKAX5L8uHQnNwU/FIQjouDiZVhIV0xgXUPUrBRALU3LRF0198WoDenssX1QP0yMoCRBCDBT3xw8EGd5pQu8UeC3MDW8UIxqXbxalwIBLRFXSFa+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cJdeqERN1BL/xPom0KQgpKU1hQGlbvLRRF+yQyiCB+g=;
 b=hZjum4Es6+kDb9ghPRn27Tt4wy6IH2AIUw49Ha0ckUHV6wRXKyXY4sW8lb0az2rJoI5DfgO+utTAcS/1xc4G+ZX1mYPx4LyRXRBcNR+1vWVJ677ENuP09EFVd7FDttFwfssh/EYoyCP0kTt8RxoIKyP6vlhNmCSHlU7t/BihDWNcCZ+FkZybAnITFlIHc8SnI88M616Lm7VpH4q63YvgMBTboYW7iuMOsPaT31yCONsG3QUK/8stqd9Fuos1VFDbObIiXLd9kFu5uOcLe9QT/OB/8gK2JQU7zdJtE4rxPsr0+rSz/FvVd+EVFu69pesmalsEy/uTRzozdjpdC4KdVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6427.namprd11.prod.outlook.com (2603:10b6:510:1f5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Mon, 10 Oct
 2022 02:28:33 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e1be:376b:2662:16ad]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e1be:376b:2662:16ad%3]) with mapi id 15.20.5676.032; Mon, 10 Oct 2022
 02:28:32 +0000
Date:   Mon, 10 Oct 2022 10:07:51 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mingwei Zhang <mizhang@google.com>,
        "David Matlack" <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v5 7/7] KVM: x86/mmu: explicitly check nx_hugepage in
 disallowed_hugepage_adjust()
Message-ID: <Y0N+d2seeNJcsFPD@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20220930234854.1739690-1-seanjc@google.com>
 <20220930234854.1739690-8-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220930234854.1739690-8-seanjc@google.com>
X-ClientProxiedBy: SGAP274CA0021.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::33)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6427:EE_
X-MS-Office365-Filtering-Correlation-Id: b8e63b15-10bd-4860-34c3-08daaa672063
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HIng9OMoOBnK9XZi9/EAIecMxjoh2IZJt2A6Cg5AR1USwu1IEdYhzQrLLmwLEsPuzhlHIW+Q27udWtQcFnYsMvBmxgrjNVkt82AiSvSDFeBpNH5DOjxLk/y/6bu8Tf2UpDX497yVT0XeM15SmMo3s3FJZKYsHIODIIyXChZHYiaJZFE1sf0rwXK+PqB+dWc3bkmI4lJdOfDiLexuRf0aiYG8fUSSDW72x/BxsZJIuMKRHo4SoRIq4vseIe6UDdzmQcjPEaUYgdAv/ILBdKun9f+PurT+6Ibjf1N7njWSyjhfUNoSWEnD6cl/HFOKwGm96ljpdbXlibyYe1EbsGM/NGZR7RHdOZfakugZ13lLGCzKa9XyOLJspMkXh8D3i1KzxV6aTZMayXCMJetsiTNVRIu6LnEhjE+ovbiHY4KbwFKyfNJsO24A+UQ8nOFlYtsozKPr/BU/aKayoMeQiZXgz6nqnD4tbUEnM4v3X+h26FNPooqDv7k2KsN4wd+Ae/PBvSDWtfWemXpz7poTsjzm+c6UiTWu+/PMBMUWH6ClfM50HAVDVMjGPIMaaXvh6FKWDNGn5xn3WzswI2hGxr5t0V63yIgkMLmW+nwAuLjOcCgZL5YAgTW8+QCrS6COVqv+aPmplEusvH8oBnPJVLlbt82L+5XPOlt2Pa+OporUVgFORRjBrsLhVcDu9WxLtP/RmBJ6PFy24psnylXrapHO+axGd0fDAll0Wo/39b97/czBAgxhJxjniQO7uRrqvSjP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199015)(66476007)(6512007)(186003)(26005)(83380400001)(6506007)(6666004)(66946007)(38100700002)(54906003)(6916009)(41300700001)(86362001)(82960400001)(2906002)(478600001)(4326008)(8676002)(316002)(6486002)(66556008)(5660300002)(8936002)(3450700001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kBK79ds2g/FV9B36WCKhkc5b7Qps3AAkn2GX9JPo0ic/tsG4qOp4yamaKpky?=
 =?us-ascii?Q?Se+XnanhvQTg0qCez7UX+StZTn2a17g24R+6mZvtFGYkfjsrXTJT6bny+/Q4?=
 =?us-ascii?Q?XzjIh9aORtoVz5WOqqJRtH+pH7Id78ZIuTRbMOlzz4yAkAGrwktVNgcKw44L?=
 =?us-ascii?Q?nlwa5idbqCWllRwKoVF7tWj48dT52NwDD9PCekdf9iEceQwTh3ZVZi2zNNor?=
 =?us-ascii?Q?Qo7w5zP/kx6lPFWbh2ZV1yW1cD6YarGeQfjWaGcQi8ly8rqcFPhRLkM+dQpP?=
 =?us-ascii?Q?A4Q1mfUizgk0MeS50FDU+6ZC5EoBDsDFCjxWxh2+pLn8DDZce1YjOlgu2MLH?=
 =?us-ascii?Q?LqnCOIwB2oOmL7vc/6bvBseAuyafF1xSw+7H2aQgbJpFGMOqa8+tF6vDgsjl?=
 =?us-ascii?Q?0l4EFFfUUrjNLfBrJ0PFM2ugO+ktpqsk59Ko+Pj9awO+pq9F8ImHKAppmpan?=
 =?us-ascii?Q?agcQNjelSy1eO3p7njghgc+7+QP27zf11kK6xv0MWeEHQttCQIAldlR9jtYu?=
 =?us-ascii?Q?fK0P7yZkgI8Tw+/8zGUEiEq84ZbkR94x/NbIPIuYW4sspiOK9BipjTpzbCm0?=
 =?us-ascii?Q?/IKhR909tdkvTzkeXs7kbscwOcarEn4kxxjWSA+9aDkxuTzngwryaWqbXdC1?=
 =?us-ascii?Q?HRTBv5WG10n/q1UIPojqjd0NfA8GiL0PDwqkFQ8E9iqmmFZDZPMHP8YsdTKT?=
 =?us-ascii?Q?rkaQtPCC3ACo8Z8u/hl/d0pVLmui2g74UdSAYQCu6Y8q+zNOL4hao/LnWbCt?=
 =?us-ascii?Q?Tw+fAt6pEJ4nAqwSNqv1ssZQcSFEJ3ikiRdBVMz8EziEHO930oilE9Kckz4e?=
 =?us-ascii?Q?YmuZiwwVqeZk853I+mU9VCZ/XBKVJ+mNCN0jp8N4F1uLP9Fpnwq3OAxm1wDq?=
 =?us-ascii?Q?exzRYC+bnIr2z6fTxHMN8WErl2rgPMA6lIZiI6/a1/fS2S42kT0cyOjlDAQE?=
 =?us-ascii?Q?6r774Mn2ay97INVb/9SIuefI/QbqlHlDnQANeU0lr0CBx8Yaz5wYc9I4vjkv?=
 =?us-ascii?Q?qCRTXf2RhdbgjMxXoaa98j0WJNUvQGHWY3vZb07sARCrQ7RFREoVh14lKEZL?=
 =?us-ascii?Q?+EWnv6HQZJArHVEyJ80wcLXECQPgBlB3sqhkoP7XOsDDZAMyA/TIYMFsCZz1?=
 =?us-ascii?Q?CFy4GLM/gUK+X+dz5UATHHSrnxBnnpISmouMz4G1VvIkrIYl+m7bCpJRpeFi?=
 =?us-ascii?Q?FGEFH8pNtsj8vJGLJTcJfMZeJB8BU2w2oglXhyyyAemQpV6WI3Ydquo9p1vK?=
 =?us-ascii?Q?XY7Z9Hhj2GQquZUS/LKhKCWHUUldccy7eGco1PFNZd1/Ip06C5yQEP6Kp8Iw?=
 =?us-ascii?Q?teLMOm0ERy/lCmfPyUR4IhjA5oMne+5C0Fduc/h5yvxWO7qLyPZkMNwTlpUA?=
 =?us-ascii?Q?F+U0Y9pk2RiZ0SYMDgOFS9jILoTzaLrnUsi2tXSqcLuZ4henqp9sCCcSL2Hb?=
 =?us-ascii?Q?49P976w0ga1L6wSGtJflOXjZdzOLEsJcizBIivUpIXCJv6bE+XTmu5oEYTSo?=
 =?us-ascii?Q?vxJcX5Q/f9AminxKvheW8GBPSlZHXJEU2xAN62fpLpPGA3ttLa0EUs0y1o/p?=
 =?us-ascii?Q?lCOR8bdeoJjjwe6O37gzujp96aOv6msgMFLKtc0+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b8e63b15-10bd-4860-34c3-08daaa672063
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 02:28:32.9334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YKB/CCv2ej8MXyjL8ivgidmhVDb64xF+IW9A22gvUOkipAOpYm794r8nrBdTUXr9/eCS8QOVHT2fXoi1DPWreg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6427
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 30, 2022 at 11:48:54PM +0000, Sean Christopherson wrote:
> From: Mingwei Zhang <mizhang@google.com>
> 
> Explicitly check if a NX huge page is disallowed when determining if a
> page fault needs to be forced to use a smaller sized page.  KVM currently
> assumes that the NX huge page mitigation is the only scenario where KVM
> will force a shadow page instead of a huge page, and so unnecessarily
> keeps an existing shadow page instead of replacing it with a huge page.
> 
> Any scenario that causes KVM to zap leaf SPTEs may result in having a SP
> that can be made huge without violating the NX huge page mitigation.
> E.g. prior to commit 5ba7c4c6d1c7 ("KVM: x86/MMU: Zap non-leaf SPTEs when
> disabling dirty logging"), KVM would keep shadow pages after disabling
> dirty logging due to a live migration being canceled, resulting in
> degraded performance due to running with 4kb pages instead of huge pages.
> 
> Although the dirty logging case is "fixed", that fix is coincidental,
> i.e. is an implementation detail, and there are other scenarios where KVM
> will zap leaf SPTEs.  E.g. zapping leaf SPTEs in response to a host page
> migration (mmu_notifier invalidation) to create a huge page would yield a
> similar result; KVM would see the shadow-present non-leaf SPTE and assume
> a huge page is disallowed.
> 
> Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> [sean: use spte_to_child_sp(), massage changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 54005b7f1499..688beed3a41e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3110,6 +3110,11 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>  	    cur_level == fault->goal_level &&
>  	    is_shadow_present_pte(spte) &&
>  	    !is_large_pte(spte)) {
> +		u64 page_mask;
> +
> +		if (!spte_to_child_sp(spte)->nx_huge_page_disallowed)
> +			return;
Merge this "if" with the upper level "if" ?

Thanks
Yan
> +
>  		/*
>  		 * A small SPTE exists for this pfn, but FNAME(fetch)
>  		 * and __direct_map would like to create a large PTE
> @@ -3117,8 +3122,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>  		 * patching back for them into pfn the next 9 bits of
>  		 * the address.
>  		 */
> -		u64 page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
> -				KVM_PAGES_PER_HPAGE(cur_level - 1);
> +		page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
> +			    KVM_PAGES_PER_HPAGE(cur_level - 1);
>  		fault->pfn |= fault->gfn & page_mask;
>  		fault->goal_level--;
>  	}
> -- 
> 2.38.0.rc1.362.ged0d419d3c-goog
> 
