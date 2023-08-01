Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BE976A6C4
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 04:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjHACLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 22:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjHACLd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 22:11:33 -0400
Received: from mgamail.intel.com (unknown [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4494FB8;
        Mon, 31 Jul 2023 19:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690855892; x=1722391892;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=a/Llph8Rur2jb0HkCtcvZF09kv4xphc4vbuX9o4avMY=;
  b=V1ob2GF46pULVpH65kEW3L65pLngg/2utjjq1kxQHZLT2HNjUi5sqR7f
   leXWqH31eR/qYNCEjV8r9ooJDWzhfrgFMvPSXi1WCPEjt0n9MqN5U+P6s
   W6DDFbIn9W3EeVMvE5zVCJpy6gGPMmcyMWa6Ev8wc9jcP7KuP6/LENbt/
   t6QsNgwgUGy71ngVeSgkP34pVkomOr38P/oz/OZkxyPlCQ3YCbakkmwpE
   XvFI0Qi//cbYwqYA6HfGXfVQFhv5M9I4hRo4LJ2QhcdB53T3iNi/X6lQo
   CH3breCnxwUD7C5eV93HBgVfi0OzoY+c71eYsukQZUl7xpJqFlcugZGW1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="435498471"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="435498471"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 19:11:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="798470811"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="798470811"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 31 Jul 2023 19:11:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 19:10:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 31 Jul 2023 19:10:56 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 31 Jul 2023 19:10:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmKdzcK0WCowRv+aN7KaydNgU5LzIvDsv/NT8rEl2uLwwdDtx+5gm/rL182mQNX6NrVewik4L/O+t0qYoyESC2DiVEhyiWP688ZLmmRU6LOcEOwvGJ9D3vmo757FOp7fNuO/C3xZaVUikbZLBcOdnHqz0oClxZoey4Ry3KVuT8rO6UfDE+LdIAzUgSITTC/exd2cL2IV7mk2vfoF/q+IQGS7zz17N1WBzsNJ2L7KaDHkp/JcL+auhAog7Kepo4xZbFMisTpw5Y2atqw7y4A5pqDHhKGVAc0DpttvZeQgl4uZ4al5mpOp6E4JhzJhsWaQp/V1HjjKt8+qG2XgSt0XkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O/FRcvbkOzYE/K0RDN0crn420rWJhM3OtcTAOoJzC4Q=;
 b=RFo6i7Zx+rPiCFHV1yr7L+74ZGAWV28peIVQnI7ByjjJnOL0v21kDKxj8uBUVrMdGApK0DMYodHcqqglIjBWrukCHwaCJ031ig6H/IwebRFB1YbKELLDvHaJ88Gyyo3vl3tH/MVFqFAcVNDH23keJBDMCA7ugwyypjZYHPbaCG9lZ94GjELXOYKLba05nZ9CKvPZVOfL/sObuvldhThZfMZA5wnnU+syMcWdftaIsi0wnA5BTbwMIlP+l/hPUCqc5kG77xvEm3EJXRpHOnoIl+7ZHjGjqV4UCaCS0GbUGLFT0xuiplvIJXEkLwXj88dQzzd2OY81x64Iq3MYoSZ2RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4536.namprd11.prod.outlook.com (2603:10b6:208:26a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.43; Tue, 1 Aug
 2023 02:10:54 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 02:10:54 +0000
Date:   Tue, 1 Aug 2023 09:44:02 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v4 06/29] drm/i915/gvt: Explicitly check that vGPU is
 attached before shadowing
Message-ID: <ZMhjYo8bOsmsWcCL@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230729013535.1070024-1-seanjc@google.com>
 <20230729013535.1070024-7-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230729013535.1070024-7-seanjc@google.com>
X-ClientProxiedBy: SI2PR02CA0011.apcprd02.prod.outlook.com
 (2603:1096:4:194::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: d08d1dd0-0722-4b85-002c-08db9234895f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1VXMtAsZNygroiEUOUlV4dNG0c3tg/njUNh68n6tDyUpmWFL06xk+BrjWUqW8mFkx7x3jndd1EaTtAwIX+nfNQNNYa7Yl41II01aRloXF2JSt3VflFypoG4VB3DGtSJ9PqtzKQAnllHhBfKJFtWx6rVZwtIwITLaLk1pBp82fYwdQoh8sKuxK/oGEVYx69qYemZbd/MzD17zfcV7EZXyKYKiaUhBiXt9hfSOd4ZwTyHgU8fwq/J/GTSxqegtV7SK2NptHid5D1L613ZByIZmxEr/4TM87cpVV4gIXFnOLX287EReOjU/3ZGFWvzSjDrAL8ebSB1FI8hIyyXDXNJFUyUuiTSRE1BWcVQlpWUuXo1v1w1TBHOdqurHiAQv7yxIRBAQFpip0CTlyIyK2JTyUcz4sJMGx+Y6EdRdKjdTyNtWG9g6ZcQLlrcGy6Htwk6BRcazCaE8nbjjKqOsE6rn2AQ3CyRepyCLNH9vLQs8f4hmwhedNfRkyFybnD6EE6IvNOb0bqNFtTk0z/lI0WUuFsiCEhpgbpb7gVfRLfC+BqD/DX7UdrZaC2pCBkmjLGhO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199021)(6512007)(6486002)(6506007)(26005)(83380400001)(186003)(66946007)(66556008)(54906003)(82960400001)(41300700001)(38100700002)(86362001)(66476007)(316002)(5660300002)(6916009)(4326008)(8676002)(8936002)(2906002)(3450700001)(6666004)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vMm2Upu5QccygyO0aD3xIncuBBktiUYXArisAmEaPZ65mykrMszXwD9N1Ks2?=
 =?us-ascii?Q?T89vVjadSstdojRoldQhlfvjNyVXe8vx2ZMTUzOXEuBDXlCuiN/QSqZFjlWp?=
 =?us-ascii?Q?PvMQNsDtb397EL7cqCYSfI0pz4rZUObk15E9eF4HEjiEpM5B+QsIc2cBV2E4?=
 =?us-ascii?Q?1AUOJd9hGksMSp2Ge2/fErsmHoTSZS+0D7FwjEnZB19kBZ9OhlemCaJkScsI?=
 =?us-ascii?Q?tfSEFhE6sVw8L3Y0UDGBCNkogCnwLAscowYwbt7y7Gwtk6Md28t0kaEms8HG?=
 =?us-ascii?Q?xvAJRq+gDQeecgTI1DzmgoeUWQqYrCW52xpcp/C3Ma38CEIslTQLlEvTXOiB?=
 =?us-ascii?Q?/LwJicFsFMdwQA7rZ790EpmnEGJrdtlp9hY7NRqgFaM4W5R2sd4zYSjXWb9t?=
 =?us-ascii?Q?IdeK2XoyQfLf9z6FsDPAnQAYCibRzYF4zClCOWOn8wiyOjNDkOLpyWwak7jl?=
 =?us-ascii?Q?HUiO1IZiQJZGF8AC+sV78UbkcdpRaPkRdXh7a9X+2F70HBPpchezAG5+NN1M?=
 =?us-ascii?Q?fIRnUI6yXUrK0aBdCQpn6D3fMzGkBCXwkD8ZbwuoZwzLVI4oK0tEys3Qj34U?=
 =?us-ascii?Q?wfJkXn8au1CzM5Nb8dvwon8g90OaMELbGt/LUQfqcnxxzT5IcDWWM8n6z7ht?=
 =?us-ascii?Q?DDsQVZ7WvWMQtuLuLT17OY+Kr88xPpeIKWWp/D6rFJzSfWC8fDQc5MXeoeCM?=
 =?us-ascii?Q?ClgANFTpOVyr5jlT30QUbdUMrvOXyYk1sKQcnsRJw9mcvjdtJv0CaQNVW1wv?=
 =?us-ascii?Q?ACGuAc04zYeQLaVXftl06YxnS7uMrtkjCMvDvI6PA6Qf3BYCgb5h1ZRuUtKq?=
 =?us-ascii?Q?2Lu1yw6NDz/ZrUYKitcSyRCCvsMxNgLMTeD6VIXr4v4RKqZQvziQ6aOQ/AP8?=
 =?us-ascii?Q?XqgZnCJbv4K6ZMrZtgOvRSak7FmVdTYGKqdJDCmHQh7Ln7EMLNV18YlJEVbU?=
 =?us-ascii?Q?mFDz/mK25xskmHJtgKoVXQG6yexxu1Wx/LfvwA0A0IpivsJhaI3W2iO3dTpE?=
 =?us-ascii?Q?mFyuBjxicaJGcazKFjxBYoMlFIRS+y2EEvbQBPf27CQPh6Ef1Jti9gj/MTf2?=
 =?us-ascii?Q?43Z9uosopCC7KpgtcDee5qJ27UDEEBlyYTS8ulKdIcprb9pEyL8hmn3Xp4cS?=
 =?us-ascii?Q?SiH0+JMqc6PmUqxkFi/8V9ghol62pyL5JppeV8+qf00GkEcYbmPsAWsVeYiS?=
 =?us-ascii?Q?leLHMyYPwT2MPFPZQr50wNBnp91hzfFJO9OuoJgeylabQ/qHyP/VB79B4cXx?=
 =?us-ascii?Q?PuxIo974MqZBCob/girjWPAZvf6V6tlOyokqV3GYmH8P0JlzVNbc6+0GDSlB?=
 =?us-ascii?Q?QNiOqoaOLTAkEkf7p36pcRYMYKcALiCYNKlDoQLxj7KnJw2ADxPeqFPiK+nn?=
 =?us-ascii?Q?muKIkg2+WDx3QwXRjC+72OOL+GAzDnVB9ePEr0le9HRGwD6xLQmkwgN+kWoJ?=
 =?us-ascii?Q?IiHpmgpMstBHHhUirbFLChHfDl71cCHaZLBrSwPwkeuL/RNb0NCxRK9KlzdJ?=
 =?us-ascii?Q?gCzn76mcLGnbSLsZoDifVk596/Zwvf0w8iTVXxhyzQlqcfDUpFA4O/YtZAPG?=
 =?us-ascii?Q?4owdvsj9LSL6CB7ONRulaEza3YAeWrmJruJaMMP7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d08d1dd0-0722-4b85-002c-08db9234895f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 02:10:54.5658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Fu8TNIe7NuuAfGxnk46cHmUcF8pU06O+OE++qQQThWgn47pvRujIu3usI/dpqkV+fCkAfy1lLklsdrAbT/ckw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4536
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 28, 2023 at 06:35:12PM -0700, Sean Christopherson wrote:
> Move the check that a vGPU is attacked from is_2MB_gtt_possible() all the
typo: "attacked" --> "attached"

> way up to shadow_ppgtt_mm() to avoid unnecessary work, and to make it more
This commit message does not match to what the patch does.
The check in the patch is in ppgtt_populate_shadow_entry().

What you want is like below?

@@ -1796,6 +1797,9 @@ static int shadow_ppgtt_mm(struct intel_vgpu_mm *mm)
        if (mm->ppgtt_mm.shadowed)
                return 0;

+       if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, vgpu->status))
+                return -EINVAL;
+
        mm->ppgtt_mm.shadowed = true;

        for (index = 0; index < ARRAY_SIZE(mm->ppgtt_mm.guest_pdps); index++) {

> obvious that a future cleanup of is_2MB_gtt_possible() isn't introducing a
> bug.
> 
> is_2MB_gtt_possible() has only one caller, ppgtt_populate_shadow_entry(),
> and all paths in ppgtt_populate_shadow_entry() eventually check for
> attachment by way of intel_gvt_dma_map_guest_page().
> 
> And of the paths that lead to ppgtt_populate_shadow_entry(),
> shadow_ppgtt_mm() is the only one that doesn't already check for
> INTEL_VGPU_STATUS_ACTIVE or INTEL_VGPU_STATUS_ATTACHED.

...

> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
> index 5426a27c1b71..2aed31b497c9 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.c
> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> @@ -1163,8 +1163,6 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
>  	if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M))
>  		return 0;
>  
> -	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, vgpu->status))
> -		return -EINVAL;
>  	pfn = gfn_to_pfn(vgpu->vfio_device.kvm, ops->get_pfn(entry));
>  	if (is_error_noslot_pfn(pfn))
>  		return -EINVAL;
> @@ -1277,6 +1275,9 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
>  	if (!pte_ops->test_present(ge))
>  		return 0;
>  
> +	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, vgpu->status))
> +		return -EINVAL;
> +
>  	gfn = pte_ops->get_pfn(ge);
>  
>  	switch (ge->type) {
> -- 
> 2.41.0.487.g6d72f3e995-goog
> 
