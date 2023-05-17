Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC10C705C58
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 03:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjEQBWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 21:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbjEQBWm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 21:22:42 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C3359C4;
        Tue, 16 May 2023 18:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684286559; x=1715822559;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=TWMcZMLHdLjlTJs1uxBlTxkJ22hCNaYJDgS4NPJUW8Q=;
  b=HU4+VaLEr7AIvMpeg+hs6cke14i56n5DFN+GvLBy/e2iWAqXrRy7YMkd
   SBSit7X6OYIafOYR12ZLpYChAzmGRGcrIajhuk/RZRaQUVUNPv4vUP6P4
   LzNnmVPDiNGJwx+A7K9PNHhYT4un68lUgrYBGNzLTAQ9mJOpKvzgGUT6I
   8yzmXQ6JvD8M4vV/OxeiJ8pq/mDxQkoW5glBTEmhMdLBgqXmnRl6kchDb
   clpcl7So2CyFut0kmBYqErtvz2qLk6/c/Qi5h9u6KtKPsLxo4xUcJHopn
   0i/SN/ibxWpPv1gaGpEgXOxsVUbQ4xEUIGPaWGyz8fRu2RlX4Cn2KHboU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="415040681"
X-IronPort-AV: E=Sophos;i="5.99,280,1677571200"; 
   d="scan'208";a="415040681"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 18:22:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="652047788"
X-IronPort-AV: E=Sophos;i="5.99,280,1677571200"; 
   d="scan'208";a="652047788"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 16 May 2023 18:22:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 18:22:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 18:22:38 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 18:22:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzsf9/uHD4BMGcCJFQVcYtv4o3HSZPmdCuN84GhGQE202CC2CkXfPQfsS/vFuWDq8VnveAxNh/Lv+2SMm+ABniDlk9m93YJH6AUb2noud02YF/mDWMI0oVU9IOCrkX1COnLRZGQyIzmBgXg6LFHQb4CWpVmMLYsDeKVnYv5IJDUAJSpEZIlCfHJQcypT7JIjT69brFtIDl5FRtGP8OOSneNGnJJy1y7oTWjCRY1xlVzRUHhdbPoD3JWYz5jLtDthQRxUmEotp9OUiPnHx1Z1POgknsYOXGwfgeTZ8XepA6fvqgH+IWDLDi9EoAUfJS1UPEEtfgygoourFnY5EjRHWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8k0p8ng9Y0hE8OE294Z5UkFW1P11//+W16FhA+x7fw8=;
 b=VR44PIZclHttTiIRIiwcuFvXrQB8GNd+j2qJXObvcgAFW3DPgAHv4SG39EuyaRSQVXx+NrBlCOqlB+FmQPPxExoSrEeL6466vamCDl/29wQxeb2Dzqs2bN/eYbK1peVz7fP28UXSLkjTNjIxbviqLSQUcoHLHWQBmPmA7TFHPZUHqcnk9uwyN1e2o5SF2WXXiHs7pVxFFopbXBQO1B/mM3lKZXgouXU+srjpZssHz1ilKFb67CH6dNed+QJE+rq0Freb//9BK7HdgUNJ5FYP3/pULdNDHZgLt+zgVzBcPS+9uTOzGzM8viBYoTi+q3gcyZXNpS3qBdkSqHiaB/peMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 LV3PR11MB8508.namprd11.prod.outlook.com (2603:10b6:408:1b4::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.33; Wed, 17 May 2023 01:22:35 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 01:22:35 +0000
Date:   Wed, 17 May 2023 08:57:28 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        <intel-gvt-dev@lists.freedesktop.org>
Subject: Re: [PATCH v3 07/28] drm/i915/gvt: Don't rely on KVM's gfn_to_pfn()
 to query possible 2M GTT
Message-ID: <ZGQmeH4ADjQh4m9H@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230513003600.818142-1-seanjc@google.com>
 <20230513003600.818142-8-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230513003600.818142-8-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:3:17::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|LV3PR11MB8508:EE_
X-MS-Office365-Filtering-Correlation-Id: 7648c5f5-49cb-410f-ec7b-08db567531ee
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: grhgvJbrdzsBCHsDmXPb1Sifoj6Cz7qZ6ZRXUxNA0Bg4tCgGTHgNML+6upbhtp3d08OZ7+/FsBm/hrVyzWHZQaeAeU8zPj4hkvufZf+FLJpL5B+FK/Z8gMeAVGOpDgtQ/KU/hQqhOgyuWT77klURp8Rc7RHoEbge7t6o4A8znEjMFaD4uUe1zrtyJeKD7paDrzYijT4pHwbECvN4wqfeMvj4LDUxenm0ZVKMBnX+Q4K2lAQwoDmfGEqAr3gmj7/EJxxlfzK6UJe92HE3LbiZtWn4Mt28d8TKFmJyI+lxsusWMM4WecywCPPCqCotWT6T3jsv1XdAGiv8GE8SF7m1WR+LKoC6D+ot3MREWU/Y0swOqFXKun/rJeOr/mOESUKFy/j3qpmH7pSbU/pba8FMsos4tGUycdX8IyGuuZNkQpaWn8m+Nwsl5zNZOuahoU9BGkrLPHJ/9c6/taVKOSx6MsyndEGqJjpQ/uNR3jovdWkLl1WzqSJq9MkxMPcQYJWsCCyMgoX5PZDxxPnOLQ9IpnbXZzpOrIWoyT/lLTJpXtvZEryATUIuCDeORjAV5z73
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(5660300002)(86362001)(8936002)(8676002)(83380400001)(82960400001)(6506007)(6512007)(26005)(38100700002)(186003)(6486002)(478600001)(6666004)(316002)(41300700001)(66946007)(54906003)(66476007)(66556008)(6916009)(4326008)(3450700001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QIcmuFVgbMRCvy1Y4CDJ0sjHuuercUg31p0L9Qe1KHEyJ657VYIUClPTexnh?=
 =?us-ascii?Q?05YBnj1dRuEBPsG302YJx4RW/iM7QXffCqo8S3GYt7SIDVlaW0b6Fl3GSKGd?=
 =?us-ascii?Q?YIZs+hEhm+nQO+Yxl7/ILG0uKq7IlNGTm7GHRFFMPLtGdhzm4kfU4hzCzGVp?=
 =?us-ascii?Q?ai9bURok4aNDh5geqHcrhHbzLTZiylP2C+g05CTwOSQ6OUmWwsl4R8Fnvr7o?=
 =?us-ascii?Q?ZnUUuFP7mGwaQFNeiwkwIxE9KfpTL2eMs4uvrxT7Swn4xF00kEl8TibsMYB9?=
 =?us-ascii?Q?6/m/F7KsXpuKCrXebu1bis/GQUDHHo+cBxY7xI1yoq8YpG3KKzDMr/PtSCOw?=
 =?us-ascii?Q?wFK6cb5SP+AlDMUby15hXRtNXr4DjzsJkMcIMZtX7XsnuLnRTS5m3Mj8FQ2j?=
 =?us-ascii?Q?4mSKdTZziWy++cu0VfklKGFQdV++PncjGJ7IOuN9LD63VUskVaQAa1tJu00A?=
 =?us-ascii?Q?QhN1PFtKehDIlXNUQW5AvHin2T/OOeHAKBaQp7Wpz8gjUG/9qsu/VXO4G3/W?=
 =?us-ascii?Q?AE75K5jXUQiJ3CU4YMc/4bOMANrfI8XQfzjZQGZTzMlQoIh2APnptGeCOhsN?=
 =?us-ascii?Q?9zc3AWY5HtFQJoMZXtpkStbDck/jaLL7bkXKXn2KKCQZQEJwjUIF8EygAUs5?=
 =?us-ascii?Q?jxMnzlhInJp4vpy3ODR/VY5HkVCKk2oiro6gzMwJND40v4i8uOVeqNEF9L28?=
 =?us-ascii?Q?iDT4IE8580ibBVPb54wZEy3YEffkq8BBG+4ni+k8ro+023O7KjJlDAub6enT?=
 =?us-ascii?Q?Zpk0iZFus6/Nsb4r7lgkjXdrLd2eAcu/sceGdB27qr1dvKDhrk7eBNMuioA5?=
 =?us-ascii?Q?Xf6Y6gvccFj+TQz/7HKICMRi7PuG/v2G0N91S4WXEsQeYoqHWxskRRTINGmr?=
 =?us-ascii?Q?Wi7ruuhbrOOLhWIojlGfzRJOgp12NSCnogh+6N/qnauCNHMx8zAbfRH0h4GQ?=
 =?us-ascii?Q?BM3WRE2rVR9nzHrcVitp4sBdiJCLeYFJBdVkw3TdE2sMXprU8/jkJWwt0D/F?=
 =?us-ascii?Q?VAIbVXGZ2b3TUBWMkhzf8wEAYdN2/4xRXKszTPLQoz0BxFrSkY6xlAonRN55?=
 =?us-ascii?Q?AX6N7wrMkbtR52KBuwxuenvZ7AqaQABpndEsk8TN+X6qHbnkKpnhbijQi2WA?=
 =?us-ascii?Q?888IUCtaX+XSRoTMxYkertF8GUZpLfdBmDI5mJZ2k5RtmptvwHX5MWNOO8V3?=
 =?us-ascii?Q?2CQQqQqlkB7YKI7XYcJyxdxqxp16jmQlY/INBN9swKt9aXpr7tO/ku5fcrY3?=
 =?us-ascii?Q?Q/lIBasFlcA1l+J1Bzz6Q5MYA+AFvLnxlO0cc85T7HBxbmf0kGU0NwifeJJ4?=
 =?us-ascii?Q?eqCHy3Ukz77NBGoSBrTOIDZyq2PW+x18Byoit2IXPBdrb/TVjGIY5Gn7E0DV?=
 =?us-ascii?Q?wVDaeZ6EgpYF0cxEfOr0lbbm9UtUz4orBCMbfRXGRWR1KC0kXFk+ND3QOrW5?=
 =?us-ascii?Q?sl6G6gt1PYAs3wwqxPJRsqvk5NH3TIWlLIv+l+R8ZNZjtQJok6QvFjsvyjQR?=
 =?us-ascii?Q?dxV6Q/QZShf64j5OchAVr4n4ukNg6N8m4VqwjTef9bu6YhLuMU5BhjxzCuxa?=
 =?us-ascii?Q?sz0OtgtzVSzVRdZB/hQV8i3PkdnML7UZGzHOIQAK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7648c5f5-49cb-410f-ec7b-08db567531ee
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 01:22:35.5400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +INPcWP5sMMs93FooXlquJY8QnWJ3fswut+PckS7vwo35snPjx3tqx1XBc7L+ccC7D5r7h50kOtOE/w9BWDMgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8508
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

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>

On Fri, May 12, 2023 at 05:35:39PM -0700, Sean Christopherson wrote:
> Now that gvt_pin_guest_page() explicitly verifies the pinned PFN is a
> transparent hugepage page, don't use KVM's gfn_to_pfn() to pre-check if a
> 2MiB GTT entry is possible and instead just try to map the GFN with a 2MiB
> entry.  Using KVM to query pfn that is ultimately managed through VFIO is
> odd, and KVM's gfn_to_pfn() is not intended for non-KVM consumption; it's
> exported only because of KVM vendor modules (x86 and PPC).
> 
> Open code the check on 2MiB support instead of keeping
> is_2MB_gtt_possible() around for a single line of code.
> 
> Move the call to intel_gvt_dma_map_guest_page() for a 4KiB entry into its
> case statement, i.e. fork the common path into the 4KiB and 2MiB "direct"
> shadow paths.  Keeping the call in the "common" path is arguably more in
> the spirit of "one change per patch", but retaining the local "page_size"
> variable is silly, i.e. the call site will be changed either way, and
> jumping around the no-longer-common code is more subtle and rather odd,
> i.e. would just need to be immediately cleaned up.
> 
> Drop the error message from gvt_pin_guest_page() when KVMGT attempts to
> shadow a 2MiB guest page that isn't backed by a compatible hugepage in the
> host.  Dropping the pre-check on a THP makes it much more likely that the
> "error" will be encountered in normal operation.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/gpu/drm/i915/gvt/gtt.c   | 49 ++++++--------------------------
>  drivers/gpu/drm/i915/gvt/kvmgt.c |  1 -
>  2 files changed, 8 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
> index 61e38acee2d5..f505be9e647a 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.c
> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> @@ -1145,36 +1145,6 @@ static inline void ppgtt_generate_shadow_entry(struct intel_gvt_gtt_entry *se,
>  	ops->set_pfn(se, s->shadow_page.mfn);
>  }
>  
> -/*
> - * Check if can do 2M page
> - * @vgpu: target vgpu
> - * @entry: target pfn's gtt entry
> - *
> - * Return 1 if 2MB huge gtt shadowing is possible, 0 if miscondition,
> - * negative if found err.
> - */
> -static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
> -	struct intel_gvt_gtt_entry *entry)
> -{
> -	const struct intel_gvt_gtt_pte_ops *ops = vgpu->gvt->gtt.pte_ops;
> -	kvm_pfn_t pfn;
> -	int ret;
> -
> -	if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M))
> -		return 0;
> -
> -	pfn = gfn_to_pfn(vgpu->vfio_device.kvm, ops->get_pfn(entry));
> -	if (is_error_noslot_pfn(pfn))
> -		return -EINVAL;
> -
> -	if (!pfn_valid(pfn))
> -		return -EINVAL;
> -
> -	ret = PageTransHuge(pfn_to_page(pfn));
> -	kvm_release_pfn_clean(pfn);
> -	return ret;
> -}
> -
>  static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
>  	struct intel_vgpu_ppgtt_spt *spt, unsigned long index,
>  	struct intel_gvt_gtt_entry *se)
> @@ -1268,7 +1238,7 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
>  {
>  	const struct intel_gvt_gtt_pte_ops *pte_ops = vgpu->gvt->gtt.pte_ops;
>  	struct intel_gvt_gtt_entry se = *ge;
> -	unsigned long gfn, page_size = PAGE_SIZE;
> +	unsigned long gfn;
>  	dma_addr_t dma_addr;
>  	int ret;
>  
> @@ -1283,6 +1253,9 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
>  	switch (ge->type) {
>  	case GTT_TYPE_PPGTT_PTE_4K_ENTRY:
>  		gvt_vdbg_mm("shadow 4K gtt entry\n");
> +		ret = intel_gvt_dma_map_guest_page(vgpu, gfn, PAGE_SIZE, &dma_addr);
> +		if (ret)
> +			return -ENXIO;
>  		break;
>  	case GTT_TYPE_PPGTT_PTE_64K_ENTRY:
>  		gvt_vdbg_mm("shadow 64K gtt entry\n");
> @@ -1294,12 +1267,10 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
>  		return split_64KB_gtt_entry(vgpu, spt, index, &se);
>  	case GTT_TYPE_PPGTT_PTE_2M_ENTRY:
>  		gvt_vdbg_mm("shadow 2M gtt entry\n");
> -		ret = is_2MB_gtt_possible(vgpu, ge);
> -		if (ret == 0)
> +		if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M) ||
> +		    intel_gvt_dma_map_guest_page(vgpu, gfn,
> +						 I915_GTT_PAGE_SIZE_2M, &dma_addr))
>  			return split_2MB_gtt_entry(vgpu, spt, index, &se);
> -		else if (ret < 0)
> -			return ret;
> -		page_size = I915_GTT_PAGE_SIZE_2M;
>  		break;
>  	case GTT_TYPE_PPGTT_PTE_1G_ENTRY:
>  		gvt_vgpu_err("GVT doesn't support 1GB entry\n");
> @@ -1309,11 +1280,7 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
>  		return -EINVAL;
>  	}
>  
> -	/* direct shadow */
> -	ret = intel_gvt_dma_map_guest_page(vgpu, gfn, page_size, &dma_addr);
> -	if (ret)
> -		return -ENXIO;
> -
> +	/* Successfully shadowed a 4K or 2M page (without splitting). */
>  	pte_ops->set_pfn(&se, dma_addr >> PAGE_SHIFT);
>  	ppgtt_set_shadow_entry(spt, &se, index);
>  	return 0;
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 429f0f993a13..92ceefe1e6fb 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -162,7 +162,6 @@ static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
>  		if (npage == 0)
>  			base_page = cur_page;
>  		else if (page_to_pfn(base_page) + npage != page_to_pfn(cur_page)) {
> -			gvt_vgpu_err("The pages are not continuous\n");
>  			ret = -EINVAL;
>  			npage++;
>  			goto err;
> -- 
> 2.40.1.606.ga4b1b128d6-goog
> 
