Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E040F6BE2CA
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 09:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbjCQIMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 04:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbjCQILw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 04:11:52 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535842CC4A;
        Fri, 17 Mar 2023 01:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679040676; x=1710576676;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ECb9K3Z3+Ybd3Wi7T/KczYNot+SHTeORri3Xk/nHGMM=;
  b=QhrLgWvDpJfx/3oW1g1XHr4HIF1ZYl8GJhYkKVX7fGOf5BlNbSL2f1JY
   G6/qmRsIxkQOVBCzmFeAPN4YAM0FxR1aq61EleWcvliZiLx7SohrHnaQE
   Vsnvv/scH0siX8M2D1qhOf4vXeZDN2bKSCyKLC9YykMNgAb6/x167IBMG
   OeDj0/Cud01jLvX+V1TElfZ/ewP76CTFjY5mjm7BG/vqWyoD4p6zuC21X
   BNZ0DvL8/nPCCmQc2LZzvOMTByB/nvn6SCeU0jcjsOAqt4IxK2t/tyiwy
   QKSfu4Ttvu6iwaDcyar+GySfitUnxaWPZy7WmVn8yAcWaCM26Vczapq5l
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="317863862"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="317863862"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 01:10:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="744469975"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="744469975"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 17 Mar 2023 01:10:09 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 01:10:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 01:10:08 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 01:10:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsqbs1dNAEFOl55qbNT0t0YpqzqnhV7c2dkBu5GjLwz6D+RNEv3F11WbUtrnhpsu4fitqyIEZU0cTfpJ4rItXB3fQ8J2vZtd7MZUisRovcaDPrikvJLcsiZOtUeM9qQb6ibhurrYI1rh35TjHzBjxd5RTAJ/M513/REgak25kUUikHC2McxOJz9Sy9IyoOToknsNRoSv8FBoPs+vWOXokRpl4qHq3b5OSnIbMGKxUp8bYefREbRHO9p3FEG9jwNFhSX+oJIdtT6tEVIxPfoefgosJP5+6fcA/O1bIryMllhEfYkIkdgGUMN0iNRKx5+kUWEKrNacBXRQ+6k+SEp/MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FDA5YxdEdIFTAvUOePvjk+VNOm5P88schr8h0N9sLOg=;
 b=VIymVhrvSLvLbKj/U6RH+33Z/i/4dodWWNzT0sHDLs6V3Q0Fpjq+LpdhPupa9/2wF2yNscWcST+lTdBe7ORoejd0eeB3EA7VgQ8gtLtuO6dQufG+yH0dIASxfHqHr5QNaQSDWaZkCu7/r/6orofb455kky2VokYatxRuv6tM8IBLyPfSr1eFGyI9MSc6qgXaIqFEQ/yq++LhcgPnIUkQq7Rr+94qpj5+bYnKGN1d6Ek0vPlGXR2N35TdIotPkF4pFKH45Zl6+L/X2qCyvsujvL741C+jRm3SRj1IWl+ZPpNFxZLLwTFn9Q5XJv0ErWNwtfNuUcCUGeLu79jZJRTRog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6663.namprd11.prod.outlook.com (2603:10b6:806:257::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Fri, 17 Mar
 2023 08:10:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 08:10:04 +0000
Date:   Fri, 17 Mar 2023 15:45:26 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 17/27] drm/i915/gvt: switch from ->track_flush_slot()
 to ->track_remove_region()
Message-ID: <ZBQalmUGAHyRQ2sg@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-18-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-18-seanjc@google.com>
X-ClientProxiedBy: SG2PR03CA0094.apcprd03.prod.outlook.com
 (2603:1096:4:7c::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6663:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e386596-4d6d-4b74-d9db-08db26bf0321
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rMmIT3PiE16gsfc/pdh0F0WDOrnJIN1IJxLy2l5fNSXdAqvuJoLGwz+ymEEyFrFD2sondqlBECJ8dgMrXtvKdmEqk8dog2MrVHZKCipHWUGm6FGTrpG7kiitLD/c+v/y2AegBvh9PbxLcOxnx+GFNSRrTyS3C00SaYgBSM6Ivz0Irw0kRyffYGAr7WpyOXrljfjevJtc/yp60M4t6UA57BXez1Ae34QX80p4f7ZoY3IuEyXL/Bumrnx6wiFbqbF/yc9M6W3QuwYylVssJtxqsPLrmTMTR8BWULS3DJ7/sYOUxthrv56AdvZJU8ExFiHr9jXFSkGM/8DGwwKd3SmPzNEKn9yxHk22OA0voKGCDrz5/lwgCP7/cAyc4Gox7Im0e2t2bi2P4uObHqT3+DOPBHKs+CcqI/zmql5exMHpqljtklq8MJ9ZgHxgjNztYjwO1+vCu7kEoBuYnPk+aMAPgfVlUKdStWk8KNI0DU19TdvCw3Hx+rFTsMrtUbsNO+lsjInKhz9+1ufK7txavnmxtBf1Fu8UQp1gqoty67D1VGyksJqT4KPKyqPsc8kv2L2QB5tocXEPQQh+v2eQqj8ASCxabEqBOlZwrKFu9YghA5TX+9U/rybovTz/N/2Ljpyk9ePvfRjcdF59lRZcvcZOdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(39860400002)(136003)(346002)(396003)(451199018)(2906002)(3450700001)(82960400001)(8936002)(83380400001)(5660300002)(41300700001)(86362001)(66556008)(6916009)(66476007)(316002)(4326008)(66946007)(8676002)(186003)(38100700002)(54906003)(478600001)(6486002)(26005)(6512007)(6506007)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mDkNj95p5jcHt4f/1sjxv8smczwCH7zHJnIyiK+9yAq8OlNeK7P4A84a4rki?=
 =?us-ascii?Q?12wDEqy1bzO16pSk9YG4mi2eGaTyBDxdGIKGbTnwjpVvzDUOwDi5Gf9o8CVi?=
 =?us-ascii?Q?s/ej7ELXzq6yxKtik0NJ670v7nKHEcKJVEAz8wdzQ1l3N9rqkF24KfSYY/TM?=
 =?us-ascii?Q?0JQycvJNHky2aRn7piUAZM1ND3ICIG1qJfp98p9bj4RbdqdFMV9+/gW+sOpU?=
 =?us-ascii?Q?nfAaa/tGnr+KfVoKXUVnyVNKaCjBHzRfZs9LXj5LZCeHBfCWZLM9DeEpNBVj?=
 =?us-ascii?Q?yREJLuRtmKgv2DG+7IX39Bi8rseivICpU45A8/K+hX6la7Rx3fEQPJAnlL1/?=
 =?us-ascii?Q?OuTqZCcGg+BxjXmj7f7H3lleRbBqLhHate+XndxASPF2oVcYC7oznw0GbLEz?=
 =?us-ascii?Q?kxOa/9mhxh/cuc8UDoykQ9iRQP1/lk3mm0LNF/QLE48znLnZweqouHJ5QYg6?=
 =?us-ascii?Q?5l4aNd7BV7t61CMjiX+2SMWW7BGQN6qiEDdPxv4OEKg7Fow3EPNsk6waAM2I?=
 =?us-ascii?Q?fCnkODDa0vbWvhUX2l2AiEp4QdBjrTfw2jqOrp6u/E6V4cKsS3ZbP4DRZBvC?=
 =?us-ascii?Q?wGuLTjst5jq7KEvBZQnxyob7m2P2oX2K8DnPHeXj5PnhF9s3vAcPb0K6LbwA?=
 =?us-ascii?Q?vCzgBN4hLev2EclLEv5/su/TeYwSqxs/bDLsZX8wcj14mkdsAbx+o7XZEMYl?=
 =?us-ascii?Q?bUWIP+0u3sb+cvZBB1PX0G2qNYnI3E7F7cKr5cSamR+IrYOVVdIMS46TwZ6q?=
 =?us-ascii?Q?I8M/OVZRC/m24nubVZRdTKLBYjxHAx3KVuGtn1Ruzh4OnfU+KAtJXIGgSAm7?=
 =?us-ascii?Q?h/7lpxUzu66Y9TTHg8esh6DG+0WVz5rZrON//jqELuYel4NR60eU0fKx+sk/?=
 =?us-ascii?Q?6jo8phWchulQYVC6OCpV7w+8S+4FtH6ohtWRL39gnlFaOJuSSU8Gr0jlbtwJ?=
 =?us-ascii?Q?pfUTTnuglrwTPuKQTPyVsm49yjvTHs2ye97/hcYWcALS7G6xn1ISKUusjDn0?=
 =?us-ascii?Q?OjpT/O8eYroCU/G5wA5MgW/57bvFlsQCRfrS3Hx2aj92NdhugR44L82KwRMu?=
 =?us-ascii?Q?i9X7i9aD2nkijd9zTJDcW9xjSCoCL0VgzimO3cHYnTbhmTYIPAPaf6DpFa3R?=
 =?us-ascii?Q?Hr4hnomYzKuzVe4EDn6dJGOgr04lpFHbYup88glXVCe8JiwMnYQA1dtPq4vp?=
 =?us-ascii?Q?DrcQbFa96IkwHyAn0bnP+EVAOhVcB7cCuBXQIfBWK5ncX2sbQnuj15OUalUm?=
 =?us-ascii?Q?sKSnHeIJA8zjnaJ0HIQ3ehZtitBjISm1wH4rcxA2Ms2Eul5kKfbW1N0CX3F2?=
 =?us-ascii?Q?4EKSxBIldU6TtG6HN0CYPrhFyRPsYYtn3gZLOZWExwn5Ogyh0PsEJgqj/qQK?=
 =?us-ascii?Q?FwVBD9pLqkKBmZ+vZHNQIL5ZIWoCeSInv2sNiZnNqmRH+fh1Mm82TSBAQ5Gd?=
 =?us-ascii?Q?5wcQ0FCS7wdhL8L7W6r62qTpOtjeJFZf9MbTtiwDLwNN48Xkl0Z4IOUBTTxf?=
 =?us-ascii?Q?ITGwyz1M9XgkEXpNANg9GfPw8r17atHHwEXq/b7S4//MVx6W5QEtkAIadyFc?=
 =?us-ascii?Q?gVkw7cL3CuFgj84DmTnlKQpK3j2+NBTE2pmCs5Ou09Z77WEhzyDR1sbPPTQo?=
 =?us-ascii?Q?uQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e386596-4d6d-4b74-d9db-08db26bf0321
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 08:10:03.8103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EjMsRovTQWgxkx/iGWSYe1YWr16RCgQlvlfOy0HYfxAEdm/tnHlNNbRUEt6JL2KL+fB17TTDmLu0KJtZgRi7Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6663
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tested-by: Yan Zhao <yan.y.zhao@intel.com>

On Fri, Mar 10, 2023 at 04:22:48PM -0800, Sean Christopherson wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Switch from the poorly named and flawed ->track_flush_slot() to the newly
> introduced ->track_remove_region().  From KVMGT's perspective, the two
> hooks are functionally equivalent, the only difference being that
> ->track_remove_region() is called only when KVM is 100% certain the
> memory region will be removed, i.e. is invoked slightly later in KVM's
> memslot modification flow.
> 
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> [sean: handle name change, massage changelog, rebase]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 577712ea4893..9f188b6c3edf 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -108,9 +108,8 @@ struct gvt_dma {
>  
>  static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
>  				   struct kvm_page_track_notifier_node *node);
> -static void kvmgt_page_track_flush_slot(struct kvm *kvm,
> -		struct kvm_memory_slot *slot,
> -		struct kvm_page_track_notifier_node *node);
> +static void kvmgt_page_track_remove_region(gfn_t gfn, unsigned long nr_pages,
> +					   struct kvm_page_track_notifier_node *node);
>  
>  static ssize_t intel_vgpu_show_description(struct mdev_type *mtype, char *buf)
>  {
> @@ -680,7 +679,7 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
>  		return -EEXIST;
>  
>  	vgpu->track_node.track_write = kvmgt_page_track_write;
> -	vgpu->track_node.track_flush_slot = kvmgt_page_track_flush_slot;
> +	vgpu->track_node.track_remove_region = kvmgt_page_track_remove_region;
>  	kvm_get_kvm(vgpu->vfio_device.kvm);
>  	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
>  					 &vgpu->track_node);
> @@ -1631,22 +1630,20 @@ static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
>  	mutex_unlock(&info->vgpu_lock);
>  }
>  
> -static void kvmgt_page_track_flush_slot(struct kvm *kvm,
> -		struct kvm_memory_slot *slot,
> -		struct kvm_page_track_notifier_node *node)
> +static void kvmgt_page_track_remove_region(gfn_t gfn, unsigned long nr_pages,
> +					   struct kvm_page_track_notifier_node *node)
>  {
>  	unsigned long i;
> -	gfn_t gfn;
>  	struct intel_vgpu *info =
>  		container_of(node, struct intel_vgpu, track_node);
>  
>  	mutex_lock(&info->vgpu_lock);
>  
> -	for (i = 0; i < slot->npages; i++) {
> -		gfn = slot->base_gfn + i;
> -		if (kvmgt_gfn_is_write_protected(info, gfn))
> -			kvmgt_protect_table_del(info, gfn);
> +	for (i = 0; i < nr_pages; i++) {
> +		if (kvmgt_gfn_is_write_protected(info, gfn + i))
> +			kvmgt_protect_table_del(info, gfn + i);
>  	}
> +
>  	mutex_unlock(&info->vgpu_lock);
>  }
>  
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
