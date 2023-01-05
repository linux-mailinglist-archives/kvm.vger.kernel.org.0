Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10DE65E380
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 04:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjAEDbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 22:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjAEDa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 22:30:57 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E598A2F793;
        Wed,  4 Jan 2023 19:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672889456; x=1704425456;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=O6RBVEOx3cCVA5gD1QUDMjhuadwsp70bALFB0PhR6Ic=;
  b=D6we7Tw5PJW9KfXnV6f0t7KLT2vzjsBjgTZPtOhj5nuHvz8Poy9gqgJM
   IWvTwrWFUxe/UqlOegq/xOXDoR6S1IZQHzQMa0IdXsPexMnG4j95+okNE
   jepASXKbQvI6gq+xE1ScE6s1fNVl+gpMQSQHF1qd/KofPtetfCRQFWxnf
   s8ppiAElzK1eZYEsSTNOv+JJFYmRffJoGUQhKm6MK2TrBvtH7+XLAPDwN
   K6752IfzUQvOERl6HAPKS0R/Sb9WZLpi5RgLSknY0AX+gKqGLj0q9TK9P
   zp1dfqhN76PE+6ajZuBsrgMvF+HU2k0zer4mp6KQH91/l15jTR52dgoOC
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="386543218"
X-IronPort-AV: E=Sophos;i="5.96,301,1665471600"; 
   d="scan'208";a="386543218"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 19:30:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="900791836"
X-IronPort-AV: E=Sophos;i="5.96,301,1665471600"; 
   d="scan'208";a="900791836"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 04 Jan 2023 19:30:54 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 19:30:54 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 4 Jan 2023 19:30:54 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 4 Jan 2023 19:30:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6L/GzIsUOiQ7pVJoMjn4MNjpkk+cFqxL85tKLT9ZIHbIs82AeMVaRdFMI7JMx27ZYrRAdMa77tm+dsZ0e7Izs4ISGXjCyzRrkK1ONGy91O4xo8HQ7+Z6esUqfPwx0vf7kvHfEQj8h3rijhXp3GqXOxYsJ6xMCZGGlclJOmEbK4tFzQTBoycW54d3ZW5JopjJeROFatKNYtWKWK0jvSbUvqZDYnprJZdHdrbswDRoGfLyd7OqsncVDvh1oRf/0vO6iqcy815+sMpaApzSUKweEqOua0OTuyEu3+mM71Y+eVczBGuHpu1aUz/4quIr+h3UWInpjczOMITNqOYVNAaQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=42IdaDcrCM5dEo1wBMzBoqwSZPyPiVC8bjFVot7qBow=;
 b=a5Qr2a68LW6H7Q2J7mWZOB5g5kD21YX/AJeK+AAA0A0puHJIQFeTjPhKd1NIv78224VAV+lD0XBZbiQQIlSDpb2Xja69aF9g9rHjAFRDmEQjUktzVmdOmdY1fOqu6eZ0W553yPh6AqfFoqf71shT1655hketiv+c4cGRs2sadKAKIPJrMYeaL4+bQapRFpjX9BKlnevklxHfSDAyYyFLZu8XS5jWeIjk1SzvZtKdnxkbD4TZSCmT8Qe2jT0OPFPcwvWiM01ipv4jPWFhmZ3tgPrkbwx9AbS3wHTkc+Jvb9eiihD+aHkge8bppUzsaNGF1mQlETZLd57kGXnfK3L2nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6882.namprd11.prod.outlook.com (2603:10b6:510:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 03:30:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734%8]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 03:30:49 +0000
Date:   Thu, 5 Jan 2023 11:07:27 +0800
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
Message-ID: <Y7Y+759IN2DH5h3h@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-4-seanjc@google.com>
 <Y6vXTcxDNovrmeVB@yzhao56-desk.sh.intel.com>
 <Y7SaklDQD0EoIs8l@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y7SaklDQD0EoIs8l@google.com>
X-ClientProxiedBy: SI2PR01CA0031.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6882:EE_
X-MS-Office365-Filtering-Correlation-Id: f6988251-d1dc-4de9-8ba1-08daeecd3d78
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BM5g7odxtrOyMPHxt+GxsFAdzchog+EBdQDWRHjMf3lXZVzPlOk6ZDphwHrkW31QccYix/TJ4pLn5G0hVAaqcIkuCBr16mXvtplPGwDOTLX/Ee0oBA2tizevNAD5oKuI+VD5j3jiUBwGNC1PsZHjDVTyKtCMc7rE0047cbMyZ5cwz2QH6qwY+xL16gzCRTQP65trCcOQnPkzEz53Nx48JpmgJ8O7nNsKQHaHnsnaVa8gQ8zkpdJ+LSS2o76xzSazHtg5E0TjzRewzWp9574RfZI3Opq57nP1nGP+t+bTZcJK3mTsmIjAOYkT9dq7HP8nMSdVtoESOkRkWmjQnoXUztEcunF5qoBBziPFoAU17oGqtq3gqV5Hc1WU3p7FUfRNvh4GJ202wPBd2yLWpO5XhYtS8aaDEBubtXvoOknCWk9pBnE0y9IiWzCxkAtxO2rFy6RVaw3YurHh3D6WacRDk1XQWAob+Qx93d/g4H9ji2UqR+6lladIVBEn6QNqFD7BbIlGyKosHKYQw7UQc11fLtBd9Gz6TDDW+RGVbRkrBlzqa1CmwtavIzj564pnVbQbf+bHAzC1ssQa5pIWRa4rKtKw3WP/yOqFWouv+csqM2a1Q6gDNWTEoo06sWVU4nim4DKeh+uu21hH7fark47yUOtT2OsmpIl0pxkUsmcRcenQZiFepdlgjaO+vsPRelaW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199015)(41300700001)(6916009)(316002)(66946007)(66556008)(8676002)(66476007)(4326008)(86362001)(82960400001)(38100700002)(83380400001)(5660300002)(8936002)(3450700001)(6506007)(54906003)(2906002)(6486002)(6512007)(6666004)(186003)(26005)(478600001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Iuklm6V6eqGy6qhrD6aDGLUPXoMTUzhnsgCj07MuTfinMMPNu+lpqcz/mC/g?=
 =?us-ascii?Q?D1HoTo6AicBaxGpXb7TUn+PzR086iEoWx34bCsb/76ir9gXH/RRfhNmkSlLe?=
 =?us-ascii?Q?Kv1fgMMvu8IMvzjksWQI7yjcizcAKi7Z4c4tzi/nM+UGhjoQur5ULzK6GvKE?=
 =?us-ascii?Q?Vh5KlhOql8RAvgUD4dk+KyqXvRasYVetW7i0iXi7hW1dZuHloDJ4N53oT68f?=
 =?us-ascii?Q?xXR6lbVf38jG7xglWs051pKl8TdZ5gtgI5tJxWA+r6jLnoB7l7UMiOlXbnlF?=
 =?us-ascii?Q?OKQBezkjKeMcjMwGx22cTRKyF+ewAhyGH0NS7Pdj5iJ03kExS/Yq/+nDFVGP?=
 =?us-ascii?Q?u5EFcW3mz90+wQKWawAb/+4gdNr/Cxx9RnAPWSdgUgmtEKrdCjfmsaVCWCkA?=
 =?us-ascii?Q?UPGxc+Iq91qhfD8NBLzkmoABRy4xGhNGCD+x9jTXxXOVZ5VwOkR1HzCH5hUl?=
 =?us-ascii?Q?k0DWg0QxlNa9N0d0V6x5MSiq1BgbhnSw5ebu4L9Fb2VJsg+DsBv7p3GJG0or?=
 =?us-ascii?Q?UJeZ7Q5+GjIYVxFxjW/6mk+M/st4B3YQBfs9ib8XUXLWI0wcKCQDUQrM2Hyp?=
 =?us-ascii?Q?P0aGfGwGRAPnOFdJ2vY1zKmBOWYuK+YdnykTw3OprbChdFA5OZpe314g9VTo?=
 =?us-ascii?Q?lpgO1SfjiCS6V7j2Tcn44gBWoS+A2W8YHnAgz+KmLKV0ZWvmHInTh0qXnwWr?=
 =?us-ascii?Q?PNWVG/8yHaD5ULh8o8s2r0IyuMYDctYL/lA62/+wqpeLHwxMT9t9y50tMUXU?=
 =?us-ascii?Q?dulnG1cMf8FKMmfKyvZ6WLQLUdU5qijgedXaawAfrLnfE3EQt2o8XHXGeg5M?=
 =?us-ascii?Q?Tv2kIfWJO0yyF6jHzg9FukQoTwvtmQnlduXmDKmdegx6cd6BmYa66Ikj8UXW?=
 =?us-ascii?Q?+YGIbIKeXiZhLYHUHd7n4DwCc4nEsvQg4QJEITRpHb77pzloq389y9UcqQwU?=
 =?us-ascii?Q?q+9WeczrxCrpDrPEl+Iyz2+uvqYNZgl+2WteSy/4s9n+5h8FhPayGMhKz/HE?=
 =?us-ascii?Q?uiD50v0GfV4N3sI5MKPHq8lr2WJcVNRJfJ48lq0cS+e3V68I3UMK+aTNeBCu?=
 =?us-ascii?Q?cZI+Y+8xLV1FUnJGYAZtbpoKxHg9fTtvdbMKdrBPb539SY63sZe+BEy4M3pG?=
 =?us-ascii?Q?xWk8lIjxQ+GEvn5A4CSwu88OioUfvfzrnGd1WRfXkpKyDccVlgTPlfl6Qhvj?=
 =?us-ascii?Q?rkum3mARscA8OMsnwmNk8TlfU5NcGjmvEOjwfQMbYBP/j3+/LJLPahhTC2Wo?=
 =?us-ascii?Q?hwB2d7HtcbVamqLaNS7r+wCfTq5/UA/B6IRe+kSc0+ftvzOlOADFnURhuTMw?=
 =?us-ascii?Q?ojyBxOKCyOpXvR8BYM+btf2T27ckMbEA7b8fLCE9MJooNOp4kPCb5x4FHvmZ?=
 =?us-ascii?Q?Sj/cjAZC7u25Uzq5C4THUHK/ICNSbneW5BZVtavVtJXwPwT2rK5IbK89l4Qz?=
 =?us-ascii?Q?zy4QUPuTknvMQuNSf00M3hTlg+Bj3kKCUtmqkkw7eY+LmjDzYc/jSVcWzGbO?=
 =?us-ascii?Q?RpxTHX5p/kVGfoZu+H2gLwnoyMgRGZuv0kzAdnhZki4SCLCJnXusoUG/iqJU?=
 =?us-ascii?Q?SGLhQyEW2zi3Efrl5/u4zLvoYG5qGnrU7GEx50d9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6988251-d1dc-4de9-8ba1-08daeecd3d78
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 03:30:49.5237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ymbZLOLkTuHuIShDDCkUNcfPYOvPc+6GEJdYIUU3cqfG+M5PwCq4fvdkGnrESarlBNMX1BGmYg+oWX9BF7E3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6882
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 03, 2023 at 09:13:54PM +0000, Sean Christopherson wrote:
> On Wed, Dec 28, 2022, Yan Zhao wrote:
> > On Fri, Dec 23, 2022 at 12:57:15AM +0000, Sean Christopherson wrote:
> > > Honor KVM's max allowed page size when determining whether or not a 2MiB
> > > GTT shadow page can be created for the guest.  Querying KVM's max allowed
> > > size is somewhat odd as there's no strict requirement that KVM's memslots
> > > and VFIO's mappings are configured with the same gfn=>hva mapping, but
> > Without vIOMMU, VFIO's mapping is configured with the same as KVM's
> > memslots, i.e. with the same gfn==>HVA mapping
> 
> But that's controlled by userspace, correct?

Yes, controlled by QEMU.
VFIO in kernel has no idea of whether vIOMMU is enabled or not.
KVMGT currently is known not working with vIOMMU with shadow mode on
(in this mode, VFIO maps gIOVA ==> HVA ==> HPA) .

> 
> > > the check will be accurate if userspace wants to have a functional guest,
> > > and at the very least checking KVM's memslots guarantees that the entire
> > > 2MiB range has been exposed to the guest.
> > 
> > I think just check the entrie 2MiB GFN range are all within KVM memslot is
> > enough.
> 
> Strictly speaking, no.  E.g. if a 2MiB region is covered with multiple memslots
> and the memslots have different properties.
> 
> > If for some reason, KVM maps a 2MiB range in 4K sizes, KVMGT can still map
> > it in IOMMU size in 2MiB size as long as the PFNs are continous and the
> > whole range is all exposed to guest.
> 
> I agree that practically speaking this will hold true, but if KVMGT wants to honor
> KVM's memslots then checking that KVM allows a hugepage is correct.  Hrm, but on
> the flip side, KVMGT ignores read-only memslot flags, so KVMGT is already ignoring
> pieces of KVM's memslots.
KVMGT calls dma_map_page() with DMA_BIDIRECTIONAL after checking gvt_pin_guest_page().
Though for a read-only memslot, DMA_TO_DEVICE should be used instead
(see dma_info_to_prot()),
as gvt_pin_guest_page() checks (IOMMU_READ | IOMMU_WRITE) permission for each page,
it actually ensures that the pinned GFN is not in a read-only memslot.
So, it should be fine.

> 
> I have no objection to KVMGT defining its ABI such that KVMGT is allowed to create
> 2MiB so long as (a) the GFN is contiguous according to VFIO, and (b) that the entire
> 2MiB range is exposed to the guest.
> 
sorry. I may not put it clearly enough.
for a normal device pass-through via VFIO-PCI, VFIO maps IOMMU mappings in this way:

(a) fault in PFNs in a GFN range within the same memslot (VFIO saves dma_list, which is
the same as memslot list when vIOMMU is not on or not in shadow mode).
(b) map continuous PFNs into iommu driver (honour ro attribute and can > 2MiB as long as
PFNs are continuous).
(c) IOMMU driver decides to map in 2MiB or in 4KiB according to its setting.

For KVMGT, gvt_dma_map_page() first calls gvt_pin_guest_page() which
(a) calls vfio_pin_pages() to check each GFN is within allowed dma_list with
(IOMMU_READ | IOMMU_WRITE) permission and fault-in page. 
(b) checks PFNs are continuous in 2MiB,

Though checking kvm_page_track_max_mapping_level() is also fine, it makes DMA
mapping size unnecessarily smaller.

> That said, being fully permissive also seems wasteful, e.g. KVM would need to
> explicitly support straddling multiple memslots.
> 
> As a middle ground, what about tweaking kvm_page_track_is_valid_gfn() to take a
> range, and then checking that the range is contained in a single memslot?
> 
> E.g. something like:
> 
> bool kvm_page_track_is_contiguous_gfn_range(struct kvm *kvm, gfn_t gfn,
> 					    unsigned long nr_pages)
> {
> 	struct kvm_memory_slot *memslot;
> 	bool ret;
> 	int idx;
> 
> 	idx = srcu_read_lock(&kvm->srcu);
> 	memslot = gfn_to_memslot(kvm, gfn);
> 	ret = kvm_is_visible_memslot(memslot) &&
> 	      gfn + nr_pages <= memslot->base_gfn + memslot->npages;
> 	srcu_read_unlock(&kvm->srcu, idx);
> 
> 	return ret;
> }

Yes, it's good.
But as explained above, gvt_dma_map_page() checks in an equivalent way.
Maybe checking kvm_page_track_is_contiguous_gfn_range() is also not
required?
> 
> > Actually normal device passthrough with VFIO-PCI also maps GFNs in a
> > similar way, i.e. maps a guest visible range in as large size as
> > possible as long as the PFN is continous. 
> > > 
> > > Note, KVM may also restrict the mapping size for reasons that aren't
> > > relevant to KVMGT, e.g. for KVM's iTLB multi-hit workaround or if the gfn
> > Will iTLB multi-hit affect DMA?
> 
> I highly doubt it, I can't imagine an IOMMU would have a dedicated instruction
> TLB :-)
I can double check it with IOMMU hardware experts.
But if DMA would tamper instruction TLB, it should have been reported
as an issue with normal VFIO pass-through?

> > AFAIK, IOMMU mappings currently never sets exec bit (and I'm told this bit is
> > under discussion to be removed).
