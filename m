Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12096BE04C
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 05:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjCQEvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 00:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCQEvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 00:51:11 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB6C60415;
        Thu, 16 Mar 2023 21:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679028670; x=1710564670;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=9EEQgdX2oaLbhKAYABENQ5C+/+9aU0ZoIZgnyh1xnOc=;
  b=kmofd85FuThufAXLzOK45v2nz57z3JHE2JHdPoRdrPgWhNp0ADxhPCyG
   nHempE25od28sitURpDHJpPs9gMGyEXpqTYRbst1fIcvvHFdtWs0gRFnC
   AL7U2xL0jtIj1Gzk2R/ui68mtU9059HmVlqP886Z+4GtjkCdHG8qsILYG
   wRtQGYjtj/782gje0l0o/P97XfU/gGJyjpLDA6m2xlbgQ4WjD3Zq0HBco
   v8x+vRMOL+8xaDUaFFvZuYMgjuDOpkrt3+DQg6jzP3i08tArK0CKWvK5i
   gQXorE4OaR6mTSLdWqNJzpHAs4IETcciDGqPHyVRHhKIRSmB2YkH1W31l
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="318575403"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="318575403"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 21:51:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="712613050"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="712613050"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 16 Mar 2023 21:51:09 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 21:51:08 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 21:51:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 21:51:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzdt+POe35Pghul9VAIck71sx5sibYRcaiy+ZTYD2i8KNbw0mYIuEu/Su691y52gYqvvSg0vWEW3yywJNGbROrk24y29F7i6Q0Y8yVyvllGQfhcYS5DM0viNFqfjhF3irOYE74b0VylbiRIvI1htSyGUtHQaoA8SH9pOXiR0agOnlrpwk8zJW+k77pA4/E2GwxR2huun+IdLWxLyLm0h8L8R8MbCOwAxdnbOB4wwyuefrbEeXrF3MUaP/Ca5PIeObzuZSYmHNWMSOfbA8PasRyEqJT0k49tU0RVMvuGT6QVIiGA0UG7YK5oUUfeJxXocsFLPtBK/dVH97OXUXoEfPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cSAb8agYrX6RPZXpR7CScrXTUobM18Hhp1uulere2qY=;
 b=hYiNiGKAjkNOUWZ+SsLw1w0y6f47pcmYSDehBo/VMwpgjKJBrpnPBCg6hjy3MTmaT0/Pw+5TdKohpqlIrQ5nPvKesetg7kBpVTPeSl2YxwTdDBO3LqYgABIqbm3Gkwc6j5k/GC8VjahHr/TN2OgS1HAzNCipjAT7dKeLDRpER9gviA0nPTtMcoajiuUKeuKtyJEQQ5BuZfY2kJTBBzmy0Mwljq4zswLUgyDycwW5quNvFiGvvdqWCjDiEJZpbY3ZQkTNqWAaYa2CIkQJGNmko918B9sxJtsNtRNIALXA/9TDbQ0hkuaMZXunL4o+zINDRkqUCB/BMansJjJh/v2dgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB8019.namprd11.prod.outlook.com (2603:10b6:8:12e::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.35; Fri, 17 Mar 2023 04:51:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 04:51:04 +0000
Date:   Fri, 17 Mar 2023 12:26:26 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 03/27] drm/i915/gvt: remove interface
 intel_gvt_is_valid_gfn
Message-ID: <ZBPr8jx6HfAPxdsO@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-4-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-4-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:3:17::34) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB8019:EE_
X-MS-Office365-Filtering-Correlation-Id: f7e5197d-7f0b-4953-f3e7-08db26a336be
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AioC2CUBD5d0D3dqGiSvBzsG8zO9krbHdTCZF8IbgkmgHt17D2fG8W2LERSzDu/Cy/+GhCM5m2KShyDE7nqK+8/oV2Adkwd2C797krRn7kkhNKuNBQoMJDWyXCewZTqpT3yRDnoCwMgHrZ4RtGUrtU4eH0LWDnkKPRWMU8eHIgyELvrTRC3mhyUaUgKs2fvp45bctpd1fKOU0mZEsOmwu97cytpE2mY9Pw2npQw9vDFgEIL9VTrj8Z98rzbF09Brf7JMGYkPTeL/KcTRqazunQWghoa/S8FsS8XCK7muWaQM8usebwc5QReTsQXGH2iAP1KTORwbFEDsLBYVbG04Dt2fuRh0KZh7wYEppy5lrWr4ydq7CxprWtECmpN4DY/Foyd40d+DjwPpKdg9YPis9xEH+Ae39948mDhu5sLFfR9sKGo2qQUyHGPUmv1rhsL05BGSgq2FNIo9LTThL/6pG0pqHsKF0RTGTuxGQonK7kzzuK0LSGikPFdFNfHaTDZnG0Nl0vnGUU+UZHuKtszqAJELyp/376k3i8JuMqvJd3dspecv5blYoAyUf/zrfxqIewCRoPnbvJyVjJ65DuZoM6pb9rk2zl01TNbvjAqD4OIpgc/GnRcxvlSnSlIRi3ARHTWb/gYMJ4YWVkDPhQVEtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199018)(6512007)(6506007)(6666004)(186003)(26005)(38100700002)(86362001)(2906002)(3450700001)(82960400001)(8936002)(41300700001)(5660300002)(8676002)(6916009)(66476007)(66946007)(4326008)(66556008)(6486002)(316002)(54906003)(83380400001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WU/0erwvd8yrbxj22H64qsDXEu4TMmog43wuAY861s/+2iQ5BzWiKL2IUWeL?=
 =?us-ascii?Q?U9QR7RoBNxfKcJOIQhZTFg/SGQSNMBbbgi/VmM9wUYrZ9sWSyTdIXhfm5Z7Y?=
 =?us-ascii?Q?gzOnAgnJQ5Cs07H5gxLC9pD5tPl8DZk5C00jiCCsa5sgFEDMwAMGm1xzR/W2?=
 =?us-ascii?Q?QE6lRpzSwdrr+hnaxjxTHJPuN12/DnaLUlDf/Ap67/UTPJn3t+iaNE+NPLNL?=
 =?us-ascii?Q?X/rkF5ekjpJ+8S15h6Sz9edvc+38ZR+LQHVx0cQHRwk9On3rJi+r9DJd5G6r?=
 =?us-ascii?Q?yWvKWf1707i1FXJ4LX4SU+p72wVcGVU+xE2DcNB2f8gF1ahwzaky+gY9ev/e?=
 =?us-ascii?Q?P8jj6ERAqCuKXl5cWvoA3YdBUKg6MZilwRTxwsZngwcdbeipr1DqU5P/vdlv?=
 =?us-ascii?Q?OPnpU8r2XlPYy4guzBJXkAw71XakCrZ9lKchN+P70mdgYhrmhk7Cj2yBIZJj?=
 =?us-ascii?Q?3tdU7ZDnxpuOg7fKRKm2YFoeFQ50aQVioNHkb3ChyhY2PF67/mGqEq57b/DT?=
 =?us-ascii?Q?zyiJN3lwMCeaZyBC5Ie5adBHO/GOyFh4g3oVytqq96ZfoYgIiPjv0DemKsx8?=
 =?us-ascii?Q?taOYZDMukA+nXH4Lv9Jp2aZZSloxDIpJyw6cG4a+aw6UN30N+hg0aH4w8Ddl?=
 =?us-ascii?Q?CbwImcTswVil9O+Dc+2hsajotIYHLcahlYaeWgL4mgwtK+WoDXE7OSfDFgWi?=
 =?us-ascii?Q?QQ/q7P6Pkp5nGD9Pu48tuwi5C/j7rObUtLRKbrcwP49B8iEzBE8OElh27tuL?=
 =?us-ascii?Q?X2khuB5z3UVxNLOi6plj6Di4CH8xouBO4j+UAjPhDCi21cjB6VP6LyL5VWoV?=
 =?us-ascii?Q?NdHgOHi6pgs6xXhK6LDGcH/hat4BeXppYMJDk5Q1ERB2Q55bZwzRZRtyJSuM?=
 =?us-ascii?Q?7+X6YnG2bVrsfvTOWcnKXGjYs15wEOXO/fQUK+GSEyp3NamKfAIGmUEBlx4y?=
 =?us-ascii?Q?QedgaTU4yL4NX1O4yrsvW24aIMdimI7bHY/0EFxFyjcu3I5NRUrQcTuas/nd?=
 =?us-ascii?Q?xt7v43l/RG/0+YSZAgXjJkisbAuQysWyGqb7HeSVLiUQKPCCTxbaAKRySYW3?=
 =?us-ascii?Q?eYn5W1OwL5CZjctMsHBEz7+QpYrHBOOh8IOhYa11jfN0WfcHu5KNGLQ8F+2U?=
 =?us-ascii?Q?wx1hZfPWXM3m6y4IQKsqfUWkl6+minNLE8ZCxkV6MGE1ehDTfg+NSHXInbpO?=
 =?us-ascii?Q?goy1lpfBZuVdWaRdXp8Of8/nD1LalQ6w/V+3rQ6e6MxiPS3K5JRLTBclsM80?=
 =?us-ascii?Q?tZgRO9XLJJhBOHuye1+UMpXUadU0hUw5jZUcasl5ClcUnfJDPP0pF6XSoR4G?=
 =?us-ascii?Q?8pOpuReIUT6dsw0crHQXPDX3ba0u8VSHPzyv5aAJOwC666H8nx8ERcQYm2Om?=
 =?us-ascii?Q?wV6L0kCRPdnui+vKr2w00HXY0GvDEV7kKb7HT7ru2qomdYdoLAxjvr5HyLW+?=
 =?us-ascii?Q?I63+u5bOu0uKoulmpwT4OI4PiENLivZsZX/S6/Yqj+L2vPA0TuXtUXw33JDK?=
 =?us-ascii?Q?oIS6l2/XDX3+yEimmIsu/QCTpqE3bM0h5czu146AWC8uCqSChBYJK2EeCZ3H?=
 =?us-ascii?Q?3IrsVfz7d9U+C5cVUJpRA/dmVzzBG+xb87Omi3oRxOyeksP4gdBRQNZ1/VpI?=
 =?us-ascii?Q?0Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7e5197d-7f0b-4953-f3e7-08db26a336be
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 04:51:04.6815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szZdF/YNgJULLdeX/eut2ULWa9dD/dSaLFgOZHBF3G4Gd007PtOOZiokLnus4o5CLOcMJn8879hlRTXZgA7hIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8019
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

Tested-by: Yan Zhao <yan.y.zhao@intel.com>

On Fri, Mar 10, 2023 at 04:22:34PM -0800, Sean Christopherson wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Currently intel_gvt_is_valid_gfn() is called in two places:
> (1) shadowing guest GGTT entry
> (2) shadowing guest PPGTT leaf entry,
> which was introduced in commit cc753fbe1ac4
> ("drm/i915/gvt: validate gfn before set shadow page entry").
> 
> However, now it's not necessary to call this interface any more, because
> a. GGTT partial write issue has been fixed by
>    commit bc0686ff5fad
>    ("drm/i915/gvt: support inconsecutive partial gtt entry write")
>    commit 510fe10b6180
>    ("drm/i915/gvt: fix a bug of partially write ggtt enties")
> b. PPGTT resides in normal guest RAM and we only treat 8-byte writes
>    as valid page table writes. Any invalid GPA found is regarded as
>    an error, either due to guest misbehavior/attack or bug in host
>    shadow code.
>    So,rather than do GFN pre-checking and replace invalid GFNs with
>    scratch GFN and continue silently, just remove the pre-checking and
>    abort PPGTT shadowing on error detected.
> c. GFN validity check is still performed in
>    intel_gvt_dma_map_guest_page() --> gvt_pin_guest_page().
>    It's more desirable to call VFIO interface to do both validity check
>    and mapping.
>    Calling intel_gvt_is_valid_gfn() to do GFN validity check from KVM side
>    while later mapping the GFN through VFIO interface is unnecessarily
>    fragile and confusing for unaware readers.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> [sean: remove now-unused local variables]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/gpu/drm/i915/gvt/gtt.c | 36 +---------------------------------
>  1 file changed, 1 insertion(+), 35 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
> index 58b9b316ae46..f30922c55a0c 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.c
> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> @@ -49,22 +49,6 @@
>  static bool enable_out_of_sync = false;
>  static int preallocated_oos_pages = 8192;
>  
> -static bool intel_gvt_is_valid_gfn(struct intel_vgpu *vgpu, unsigned long gfn)
> -{
> -	struct kvm *kvm = vgpu->vfio_device.kvm;
> -	int idx;
> -	bool ret;
> -
> -	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, vgpu->status))
> -		return false;
> -
> -	idx = srcu_read_lock(&kvm->srcu);
> -	ret = kvm_is_visible_gfn(kvm, gfn);
> -	srcu_read_unlock(&kvm->srcu, idx);
> -
> -	return ret;
> -}
> -
>  /*
>   * validate a gm address and related range size,
>   * translate it to host gm address
> @@ -1333,11 +1317,9 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
>  static int ppgtt_populate_spt(struct intel_vgpu_ppgtt_spt *spt)
>  {
>  	struct intel_vgpu *vgpu = spt->vgpu;
> -	struct intel_gvt *gvt = vgpu->gvt;
> -	const struct intel_gvt_gtt_pte_ops *ops = gvt->gtt.pte_ops;
>  	struct intel_vgpu_ppgtt_spt *s;
>  	struct intel_gvt_gtt_entry se, ge;
> -	unsigned long gfn, i;
> +	unsigned long i;
>  	int ret;
>  
>  	trace_spt_change(spt->vgpu->id, "born", spt,
> @@ -1354,13 +1336,6 @@ static int ppgtt_populate_spt(struct intel_vgpu_ppgtt_spt *spt)
>  			ppgtt_generate_shadow_entry(&se, s, &ge);
>  			ppgtt_set_shadow_entry(spt, &se, i);
>  		} else {
> -			gfn = ops->get_pfn(&ge);
> -			if (!intel_gvt_is_valid_gfn(vgpu, gfn)) {
> -				ops->set_pfn(&se, gvt->gtt.scratch_mfn);
> -				ppgtt_set_shadow_entry(spt, &se, i);
> -				continue;
> -			}
> -
>  			ret = ppgtt_populate_shadow_entry(vgpu, spt, i, &ge);
>  			if (ret)
>  				goto fail;
> @@ -2335,14 +2310,6 @@ static int emulate_ggtt_mmio_write(struct intel_vgpu *vgpu, unsigned int off,
>  		m.val64 = e.val64;
>  		m.type = e.type;
>  
> -		/* one PTE update may be issued in multiple writes and the
> -		 * first write may not construct a valid gfn
> -		 */
> -		if (!intel_gvt_is_valid_gfn(vgpu, gfn)) {
> -			ops->set_pfn(&m, gvt->gtt.scratch_mfn);
> -			goto out;
> -		}
> -
>  		ret = intel_gvt_dma_map_guest_page(vgpu, gfn, PAGE_SIZE,
>  						   &dma_addr);
>  		if (ret) {
> @@ -2359,7 +2326,6 @@ static int emulate_ggtt_mmio_write(struct intel_vgpu *vgpu, unsigned int off,
>  		ops->clear_present(&m);
>  	}
>  
> -out:
>  	ggtt_set_guest_entry(ggtt_mm, &e, g_gtt_index);
>  
>  	ggtt_get_host_entry(ggtt_mm, &e, g_gtt_index);
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
