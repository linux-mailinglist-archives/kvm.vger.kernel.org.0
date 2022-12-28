Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAB8657310
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 07:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbiL1GI2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 01:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiL1GHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 01:07:36 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B8395A4;
        Tue, 27 Dec 2022 22:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672207558; x=1703743558;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=szArQPUq31fmy14HbRIHShl6wylkp3wFsgE7kg/0jvQ=;
  b=ez+hB4g/9Mc9YaGYHSHZ/9b9feTH5NK0TzAuzvQLB6alBIOmK6sOyunk
   4McXicrxGQ8tzx5KQKpogwEvujh0CyAco6NAulAvOrH5b0Zzsoxyd27T9
   vXuCqOaBEMUGGAxygwgaCl8BcR5nVhM1/00TcKMuf6Rvgg712QzzijUrG
   28IjlMJko3j5w5xTMUNtfW+jCc0Oo2/roxOCQN7NCRG6au74XkL5s9+q0
   Xn53UcpivvFNPohc1WahTSLmE2rl907Z4QLo9HLYA23wmvdk5BlxRGT6T
   Jc6j6gSCeka/Y+yy13DFZv1ZcDh8XoBIb4uOdTHMniSwX+pIHtUzRzVG+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="318490664"
X-IronPort-AV: E=Sophos;i="5.96,280,1665471600"; 
   d="scan'208";a="318490664"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2022 22:05:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="741940339"
X-IronPort-AV: E=Sophos;i="5.96,280,1665471600"; 
   d="scan'208";a="741940339"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Dec 2022 22:05:57 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 27 Dec 2022 22:05:56 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 27 Dec 2022 22:05:56 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 27 Dec 2022 22:05:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNwLyBdYhVNL3BsaIYayr8Hrvh6LbyTQY7fBSboZ5Klst++GmwbLhfWDz1AH7YkMBUV/y0/n8kbFSjxWyLs3zLePP6JcZooLlvaurSlePjlbdYHYqaV48KbtqdDrz2kicAn0QHucTTMx+F9b2MOXojVNuN1WBOkAjiWEs8MY4I4HFYdSyRolOT2KzKpqYVOx8r4GvU2GTUSn4QxFgVaD+qQMGAWqpp5I0IM4dIvNRf0UvwnyY3wLWUV81q3WcEYWLqXNdGXxHoU60RxJULyhhuCCdCLdENGucY7cY0CiShRvhHhPF9wwrWjxqtY8DNNj3jmSh7+aVNchAKyxbba5QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vlQibGe86ySO9H1ggH1/1ZN2UtPW7TQKooVQslra8Kk=;
 b=eVVihydnpoYTlaSs5lym24gms60DgHtHV7Xuv7Lr2L6DbqmOoYYpkQ1lO+Ek/uKhnHvEOZcAm6esQNeXG7bWBBnI1bHbyZbfxDega8klBkMAkB2fcZT/EavjE00tx8Nc4fnE6XQ6Ab1EwkkjQr/EtkwVC+7pA0FnlCdFgjo21Ab5vE5a/+HYEDOAv++Qe9nwK8SHFnqUvxJVabtmg0Cxp/7zD0W/PUxcguV028XZva6SPnIvtqtudk05uk2Jhyz6IB8+Tf25NkLLkniPML5/tzHw2wRUn2i/ouvgrN4ytPVMvT9Ecd0RmDsN8sLvcZ21Ud1fC38/HAoJ2hRG2rEFdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM6PR11MB4690.namprd11.prod.outlook.com (2603:10b6:5:2ae::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.16; Wed, 28 Dec 2022 06:05:53 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734%9]) with mapi id 15.20.5944.016; Wed, 28 Dec 2022
 06:05:53 +0000
Date:   Wed, 28 Dec 2022 13:42:37 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 03/27] drm/i915/gvt: Incorporate KVM memslot info into
 check for 2MiB GTT entry
Message-ID: <Y6vXTcxDNovrmeVB@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-4-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221223005739.1295925-4-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0056.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM6PR11MB4690:EE_
X-MS-Office365-Filtering-Correlation-Id: 864a10fc-fc51-4d7c-6f8c-08dae89993a8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r+WZgBG/slf3Un2i9RjwtssA9vRLOjzXPUWcIamQvpIWM1fbesdCnQib40fWGhV0Wj8ipSMkOoBr0I+Pb7CRl4ez26t43Y3zD1GM9cDkmdACKEZe8xZCLMo4bZyu3SWnUU006XUYXGZdz/xqWWfWYhiKiHUNRdkOG67YQBSyWmvKQ1XleXIZpqLxR9zjceZpYt/hStNIPd8dehEF3Q9afoovWvJOY4+yTrR92roJFBmlk2UgMltm8t3bA9U1MZYfJJSeAOS0USK9R7Om0+aL03xAzdmK4bl9jbj6zv9YlhkA8Sgk9b4NeYX4yI3H5OUSto8p8DaSNRVLEQliHEY0ArH3oJdqnE/AbwoFifMd0Gh885OqffWggt+4LUY9eTl7R9iaFQEQoXBu84GXPPxySZUaT5Wpx/IF5LyoRcL6kn/F7WCWgLphXxtlcQj/JhLnRLtv3SqrBpoJJCJGI3sMVYoH0D6cXkS8AmofUZq/NisuQIF7iV2n7TIten9GtiwlDSKtqWDcWj/VzQ3xBZtg1Txy6Ry+tmHlwVwPTPo94ofU0pniyndUXH8VwdN+dNq28dvvyG6Dz2CYySbKWq+SdGFe5HLGvOnCvT1h2MWs4bBHKmMaPMGuipKmUcBfmrtS6d5dkhaaF510hXZICqZAsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199015)(3450700001)(2906002)(38100700002)(8936002)(41300700001)(5660300002)(86362001)(83380400001)(66476007)(66946007)(316002)(54906003)(6916009)(66556008)(8676002)(6506007)(6486002)(82960400001)(478600001)(6666004)(4326008)(26005)(6512007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zGUzR0n/127hK3CfNyyWtrTXf67bYQYzyXqr/rRC66tnFxnZfVpeykMZX/My?=
 =?us-ascii?Q?lh16dwiQQgDqUT578YDs+f0aO7HvNslOT4EdMMlb00O5h9Up53Kk8sQi04nx?=
 =?us-ascii?Q?WFAJR0vSK2W9Efy5Ui7jZettWOeNltWnYqXigFKaMqFyxQpgIa406YkDGWYG?=
 =?us-ascii?Q?+hoF5PfbzKt5d5izOWms2KKtmYj/eNS0OflcG23LSUOC0Q/aFxDdhCGZ8ItK?=
 =?us-ascii?Q?KWcTWBAmXvvZSih3JFxu48O94Yp3RGGARdf/bscfaSuJwJ9i203zFNWucl2Y?=
 =?us-ascii?Q?L279hQJvJCP6m8U+Gu7SvbUoBuXOpbzV6IrnJ4LhZNOkEJMBAcc+F6nYph8N?=
 =?us-ascii?Q?uf8xw5pSfDAZ28bfVOGsJC6MGmKAnoKVOtZCp4midtU2T4wCqaOgTfhTkE6a?=
 =?us-ascii?Q?Vtv9tNd9D0wrQ/lrppCVGOMr0NNKIYSJaun2jBMgillo07ziab2FzcRlmvE6?=
 =?us-ascii?Q?iujHcu8epYWyTT5HaJJQCHYWMejGo8k/4UEc//OeBg6OboNwAoHrWAI35c19?=
 =?us-ascii?Q?wuBET3EtHRROIzCAcOV3Ll8P0B+4YI1axqtoa1azoc1MVmq9h/Hl+XTNbIxs?=
 =?us-ascii?Q?E9KHyOZOEyTn8ZL+hX9dMYx7RWGzMNZR4JgMNpcr6j2QGyE4C5gjLYy5zAtD?=
 =?us-ascii?Q?nEasS++RSheo/XDAxe9vb0B4YeJDj6RNR/3S8P4gg/l40ZA05l3rdeOEhjLb?=
 =?us-ascii?Q?uPRQMPbDcibw8JxTJyilVg058WSJpyk3msRXkBxahJHOMjyOyRiu/awaC4n5?=
 =?us-ascii?Q?9NJuQ8dNbhDr28B/ouk489F1iNhpVrxAYp5oOw7dlY36eyauaE2nqQWDC4O9?=
 =?us-ascii?Q?0VH+u39ZjZxZjdpWcn6fCxI6L1/0BWcwMljXbL/PfiZ0vmFybZMi9csx629S?=
 =?us-ascii?Q?rz0OztLY7pj2O+TR1I5TCKiaMqicu35FFFSnkfVjxSRXPYcfQdtGVdaRjZmm?=
 =?us-ascii?Q?D3gb4y/MKpVtcdFkTod6j0bLx03xnycJKYuXNb6jh6I3KRNrv7xwZ3b4bcDX?=
 =?us-ascii?Q?H9MI4pKvukrZhzYZYrq+FhSW5mECi7ZvjLvAANOwI1WDga69ov9nwJMCdclX?=
 =?us-ascii?Q?Ikgcqfybk/Cw2gMrIIhjfw+TJzJxWWYzlZSA5Rcp2rpThvuBk44eyEnSdE57?=
 =?us-ascii?Q?rWqcFJ7KM8LGsd0vHRSUGk7QON0qFSglCSqv10uU5Lv8RtGm/uqmL6vFB347?=
 =?us-ascii?Q?Skqi3GtxgRN4LgVmM4KMgqYff3WQ+1qU5ySVPKBFCHoaVWlJYqfsN9TVfRfk?=
 =?us-ascii?Q?ugrP2plWP/5vUDE+BGjlOMr6BQ79DRL8HYptSE51xfQ9nSX+BTdHmAks0Gcw?=
 =?us-ascii?Q?spkt9YgfrU1EXV22ZgmHqkDqF9tqnOLrwCj3C93J/y2UO76wYhNwvTvuwyjI?=
 =?us-ascii?Q?sD23yz4QGd4UtQy06uPUtSY/seMUhCN+HARC+6CoyZdHUCsqq7wn49rYwU9B?=
 =?us-ascii?Q?D8Oq9hLG81NvRGxIA25waKYwf+clhxw2bt8BsnqQO4x/IULVR6gNua8+y+K0?=
 =?us-ascii?Q?+OSbCq6ZIqyCQgz4Nn086FuDPn5cONjIS6/BWDAhollWC6Lel5oRIUle3/Io?=
 =?us-ascii?Q?X0nrnGSk6axif2nE08Lcy7u/haHzoXrBB8RsDrk5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 864a10fc-fc51-4d7c-6f8c-08dae89993a8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2022 06:05:53.5101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wpqUOU1F6T5PrNPZX7/Xew4EPl8rwRE/+whrYrZHHtEPNFo6st0VjRUB21Lof8JWwZmIEU8KnkrvNV+DJdBX/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4690
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 23, 2022 at 12:57:15AM +0000, Sean Christopherson wrote:
> Honor KVM's max allowed page size when determining whether or not a 2MiB
> GTT shadow page can be created for the guest.  Querying KVM's max allowed
> size is somewhat odd as there's no strict requirement that KVM's memslots
> and VFIO's mappings are configured with the same gfn=>hva mapping, but
Without vIOMMU, VFIO's mapping is configured with the same as KVM's
memslots, i.e. with the same gfn==>HVA mapping


> the check will be accurate if userspace wants to have a functional guest,
> and at the very least checking KVM's memslots guarantees that the entire
> 2MiB range has been exposed to the guest.

I think just check the entrie 2MiB GFN range are all within KVM memslot is
enough.
If for some reason, KVM maps a 2MiB range in 4K sizes, KVMGT can still map
it in IOMMU size in 2MiB size as long as the PFNs are continous and the
whole range is all exposed to guest.
Actually normal device passthrough with VFIO-PCI also maps GFNs in a
similar way, i.e. maps a guest visible range in as large size as
possible as long as the PFN is continous. 
> 
> Note, KVM may also restrict the mapping size for reasons that aren't
> relevant to KVMGT, e.g. for KVM's iTLB multi-hit workaround or if the gfn
Will iTLB multi-hit affect DMA?
AFAIK, IOMMU mappings currently never sets exec bit (and I'm told this bit is
under discussion to be removed).


> is write-tracked (KVM's write-tracking only handles writes from vCPUs).
> However, such scenarios are unlikely to occur with a well-behaved guest,
> and at worst will result in sub-optimal performance.
> Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_page_track.h |  2 ++
>  arch/x86/kvm/mmu/page_track.c         | 18 ++++++++++++++++++
>  drivers/gpu/drm/i915/gvt/gtt.c        | 10 +++++++++-
>  3 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index eb186bc57f6a..3f72c7a172fc 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h
> @@ -51,6 +51,8 @@ void kvm_page_track_cleanup(struct kvm *kvm);
>  
>  bool kvm_page_track_write_tracking_enabled(struct kvm *kvm);
>  int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot);
> +enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
> +					       enum pg_level max_level);
>  
>  void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
>  int kvm_page_track_create_memslot(struct kvm *kvm,
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 2e09d1b6249f..69ea16c31859 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -300,3 +300,21 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
>  			n->track_flush_slot(kvm, slot, n);
>  	srcu_read_unlock(&head->track_srcu, idx);
>  }
> +
> +enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
> +					       enum pg_level max_level)
> +{
> +	struct kvm_memory_slot *slot;
> +	int idx;
> +
> +	idx = srcu_read_lock(&kvm->srcu);
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
> +		max_level = PG_LEVEL_4K;
> +	else
> +		max_level = kvm_mmu_max_slot_mapping_level(slot, gfn, max_level);
> +	srcu_read_unlock(&kvm->srcu, idx);
> +
> +	return max_level;
> +}
> +EXPORT_SYMBOL_GPL(kvm_page_track_max_mapping_level);
> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
> index d0fca53a3563..6736d7bd94ea 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.c
> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> @@ -1178,14 +1178,22 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
>  	struct intel_gvt_gtt_entry *entry)
>  {
>  	const struct intel_gvt_gtt_pte_ops *ops = vgpu->gvt->gtt.pte_ops;
> +	unsigned long gfn = ops->get_pfn(entry);
>  	kvm_pfn_t pfn;
> +	int max_level;
>  
>  	if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M))
>  		return 0;
>  
>  	if (!vgpu->attached)
>  		return -EINVAL;
> -	pfn = gfn_to_pfn(vgpu->vfio_device.kvm, ops->get_pfn(entry));
> +
> +	max_level = kvm_page_track_max_mapping_level(vgpu->vfio_device.kvm,
> +						     gfn, PG_LEVEL_2M);
> +	if (max_level < PG_LEVEL_2M)
> +		return 0;
> +
> +	pfn = gfn_to_pfn(vgpu->vfio_device.kvm, gfn);
>  	if (is_error_noslot_pfn(pfn))
>  		return -EINVAL;
>  
> -- 
> 2.39.0.314.g84b9a713c41-goog
> 
