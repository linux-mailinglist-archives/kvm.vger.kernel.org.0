Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7297622474
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 08:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiKIHKx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 02:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKIHKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 02:10:49 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9384E1CFE8;
        Tue,  8 Nov 2022 23:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667977848; x=1699513848;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=s05+xiKb14BKHoH857mS69cp1kiV+oJtbASmSUYCndA=;
  b=C0zfPPK2rpf/YIseyL5U9KElF4c8sBXl6jWUXcHBFKnwJU794Vg5eobV
   vyQh0XbHl2IN7/cLYpvj9YegsOMbpvefsqMc40zrtvBgRKZAhvw4h3w4h
   WddzTBy+f5aQLcWBTndSUpwnih/83n3n6kX2nkO/qk/JJj/5MnDR0Q5Q3
   VeumQlXJs00hl59AAtIJ8a2rFNIZtI00l2ae19aLULbUxLE+FP/nsjM76
   3bHIaYg0KqlEjCQrAhahshnn4EMnHuPjfmtzrLqO+DzXkv57aLMVFA4bc
   FLBr2VHdr4Rn169JpYpzMg3iaLo3kdeohkO8XZgYJCrQ2VPRoICpFZnDj
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="298429634"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="298429634"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 23:10:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="636634113"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="636634113"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 08 Nov 2022 23:10:46 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 23:10:45 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 23:10:45 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 23:10:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGbDvZPql3gQVEArVhd7b+WVaiiC7Bu8V/Z/neN0BAZxFt8SUwDS76AbAaw2i/b7KtBl4sZwcMcK57p4PTwbqXU30lagVnvvTwJj+fvTaJQ13ERYBRO0zkm3vkj/vAL+14k48V98wHppQMuAfciTP6UTshDWwOGrf/lHhjbkfgQK3Jc76oy+rUMTMI2+8QiZptFiMp9TjTiI/73+M5vkhymhMwcbUETcEmzkB/O3v7PgyYfxYppswHZwpxvjTF1tktYPwn/qHZZ0hAK7Gnl0kJeBunSgkjUHo/l24zDNQxUWPD7jEDJ3w8JNFfi+3CNwo21nItzjlGe95oxX1e+IJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFt4BlCa9P7+Yv08kAuPacNFgGDbhZLcUkDid3Yd/dg=;
 b=LfoSfuq2u6lqNhWWv+7Xi9e8FWkBX0a7GNBow8twcpTAn2YTOiv1MWnzQjIml+4utHT63wKlEyaaEP5fwi0YH6CC+1/eLpjEj5qjnWFSjn4CKXwE22lDqzaCv0IhsXffylck9w1mNdgMgeNlg0vtDX4Ys8uj4kcXju2CtSj4KO1qF3hy72YN1lRXZtr4uWmxhivaXWWh1AfNaER3fPJkUGV4ZqztPw58/dA5+kpPsIO0W6n+yQ4g0tVXxF1ySHwHCoXwv2BU0T10RiJWKm5TCj1l3oiZvxVLlX9jDuG/gE96jv3FwTctk4Ik3Cl0UkEV4JKcQqrr1KfdiYuiuqEX2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB4773.namprd11.prod.outlook.com (2603:10b6:510:33::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Wed, 9 Nov 2022 07:10:42 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 07:10:42 +0000
Date:   Wed, 9 Nov 2022 14:47:52 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: move memslot invalidation later than possible
 failures
Message-ID: <Y2tNGHF5Lbjk4DQV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221108084416.11447-1-yan.y.zhao@intel.com>
 <Y2qSwlN26qWi3ZqH@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y2qSwlN26qWi3ZqH@google.com>
X-ClientProxiedBy: SI2PR02CA0004.apcprd02.prod.outlook.com
 (2603:1096:4:194::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB4773:EE_
X-MS-Office365-Filtering-Correlation-Id: 30f1f2cd-414b-4c8c-8a8b-08dac2218356
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 94DUNctNuU6d0gPCOJ7KrTeodfD52+eyuz/nbwfW1nfzRBrSqCVwQyjM9xOldR2rJLOSo5GkT3XwC/CLIJkDhIWfDzjnk4UQlxbfjV/OPwtxmIhXq/8X5WZedNMaU1oMG76wuwqX3Q3li2Rd0k1jPSd4FCD7xDcB4yJ6PjvslLaiJkxEch4hsddimJzPuGhtaHYLDJ5um1+tM2IGDPdZMVU3f2Y6sayUbe6N1IMTozFgk5h+rDHRLU9Jkj05S5hVaea1LgG+bSRBMjhSuEZpp/jhUAoqRszDkl9ChtDvPZkr0vw3JFV68/Y3NIy2+Z/y6jeoQAXVOL/t92IgpfPXH1zRDokzqZVdPuKpepbxc/Q9FpzdjvZMgJTVR2+AZJtLZxDvL9xopYKt7OizYH42n8M8ihRZ8Z4pshRumluANcWGm/vx9s9XOBNhZ/r4lqZM7Xpn0A1ExF641b7j+ENNBvErGU1qfuxq0GYB9+UIDN7vMBKigXd8xGyUoGxnGBBbi5aG2IHuul2HZda5lAoNvh484HIp9G6KDqlwWKo9Es6VrPPFSYUSoqI9rjQrg4NEtW+z2aaME7DOP8UAzBdgWM57p92HvIU3QDtSJqCt6QciMwcvhfOXmxNCwSUf8CJD82qB/VUN5W9jXLOtjH65jQaLI/j/M6hWWuYO/8CvgWZvoath6qoKLcbZRQwnwypX5eMMdJOU++aYHZEZqkluuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(39860400002)(366004)(136003)(451199015)(316002)(6916009)(478600001)(38100700002)(6486002)(5660300002)(86362001)(2906002)(82960400001)(41300700001)(66556008)(66476007)(8676002)(4326008)(3450700001)(26005)(6512007)(83380400001)(6506007)(8936002)(186003)(6666004)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QfgAZyQT4MECPqXXVDZnwbDX1LuBsP42ioNh9HKjLV5L/3/blTwG/sW/bAfa?=
 =?us-ascii?Q?9SKXChKu1wdUMQeP0C/6EifuMgJ4aDHP8tiU9MParGNiUxg6v7FamwvTvByc?=
 =?us-ascii?Q?O4+YVTznkU2iMQtYPOUh6qJv/Ac+yYQEXC/bHUaBxfqGo74gqH06o7JtF67i?=
 =?us-ascii?Q?RF1MsmWJUFQiI1Gks2qA519hIRANCZuVz40R5ZB0azHWnP9Tz02zX9OTHt2Z?=
 =?us-ascii?Q?GsEiFk4d6UCr5ncju8qjHrBhdv0VqxO0VzKAqh+JjRfxZ7OSDEsrIiJm5Ivz?=
 =?us-ascii?Q?4NZqUWq11KzizzfhsVLC5KJIMffNYBGyMLkh0F+EYhJWQUbYMpfwAnna1iuP?=
 =?us-ascii?Q?Af3OUm5/XEfBeh6+TNOcJuvAvKvDzinhPrIlcGdRpstd31zBBZcG1rDlxBDI?=
 =?us-ascii?Q?23/xSKs8vmmdtSA5m55iUnEe/zyzdN/JColg7dBrDZneZEevIngcCAnm01bG?=
 =?us-ascii?Q?1c6kKPTNOdTAbtuq1X8G70cBIdZ98rK8vcwPoFXaUMXcni9lAuKTDpPxcgdj?=
 =?us-ascii?Q?QjeyM7S2NYVzj2QBGBHZ+8mrKdNpjJsBWeS6tJkLNR7BDSkXcOBan5s2cetK?=
 =?us-ascii?Q?s2FlFVO5IQvjNsKldB/6fcoFKKbgpVtTrbbAX4vjCohO1deVDRKLZt38c215?=
 =?us-ascii?Q?1IqJSFI48aDOnYwei2/xUlFvbkzZNakzka4Zzim+Ors2CjA5lSqPIjtRQfVu?=
 =?us-ascii?Q?1XuWYzs3egggFYDIQt62tOF+FyNTwUsOTXF5jom0ywz92wj4jS5MWW5LP1hQ?=
 =?us-ascii?Q?wI/JaFCi9mXCpy1ui7EgrV0refR9xS9v05p8lD6dhbCW9e8KAvGTaL9zFwlw?=
 =?us-ascii?Q?iop2scVlZ1AEG7KqWuOFdq2WzWyRZodhCd67W/7D9vvI2diqRkLifGOow7DM?=
 =?us-ascii?Q?k8YQK/xUdPGrH1Zd7dR/SmnD+B6LrKvwqCPN+SuNA1EgpPVQgCGDaeKXRpXJ?=
 =?us-ascii?Q?FWXDwVv/y4SLZgK369y8K+zDtLGevpAZveXyTfdM03fF8rAsgV0pT31G9Fts?=
 =?us-ascii?Q?drsWbiGlZ6VglK0K1JhY/lBxITxrTXkqI42i3Vom3+WDq58qkySsCM1mZ2bc?=
 =?us-ascii?Q?JRQINjWal4J0udXgcMQlupOCwgstaEMYxTHsKDJvjYr/j+lYglZDhqkJs0ni?=
 =?us-ascii?Q?OVmEnWjOw11iBEqo8Y3pz9V+6wr45nSoHLdlLSfRZpnmXZd8l2mkcozyG3Rv?=
 =?us-ascii?Q?kxoYjeObP2vxJJSC3y1k7/HE67Iu+2LIrXEp7UY6so07OwOonVR0s0TgXnP/?=
 =?us-ascii?Q?as+OOJo1B8xkVuSOtNrHoCmppKeERgmJzH5/w3YWSHCWTnf653RmH+cgdy16?=
 =?us-ascii?Q?VT7XLqf0n8D/rNCGd2E7GTfBqBaACWKejf4uasMvhLHb57dGkEAKHSzbLTCa?=
 =?us-ascii?Q?38jNmxpWEPT/sym9FL+mxUYoHc5u/1le/pWiembKZ0D019V08xWRDDVZt9RW?=
 =?us-ascii?Q?zBYkiYsxkKAwAI/6ZtTpvpLaJHLnilrch5AuM52+tN6rQAH7MPoQANt2lJ8/?=
 =?us-ascii?Q?rWm358VR9OHiWDJ6+AGjlnRrUkAEGgisq+l3VKVKdgK9EXasOxkGlpddGU8/?=
 =?us-ascii?Q?/0pP5mxP/zZ1YhmR43STOMfHXwc+9nQG3hv5NlMJUJ5Zo4DCghpEqcU+b2jB?=
 =?us-ascii?Q?mg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30f1f2cd-414b-4c8c-8a8b-08dac2218356
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 07:10:42.1416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G8dGIjB5F9Q+93x8IQIgQGLObV5it0ZJ3z5/KVBHbdUI0L0O4somQyHot5x2idK5BW3Bi79jlcbKL8nu2yZfgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4773
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022 at 05:32:50PM +0000, Sean Christopherson wrote:
> On Tue, Nov 08, 2022, Yan Zhao wrote:
> > For memslot delete and move, kvm_invalidate_memslot() is required before
> > the real changes committed.
> > Besides swapping to an inactive slot, kvm_invalidate_memslot() will call
> > kvm_arch_flush_shadow_memslot() and further kvm_page_track_flush_slot() in
> > arch x86.
> > And according to the definition in kvm_page_track_notifier_node, users can
> > drop write-protection for the pages in the memory slot on receiving
> > .track_flush_slot.
> 
> Ugh, that's a terrible API.  The entire page track API is a mess, e.g. KVMGT is
> forced to grab its own references to KVM and also needs to manually acquire/release
> mmu_lock in some flows but not others.
> 
> Anyways, this is a flaw in the page track API that should be fixed.  Flushing a
> slot should not be overloaded to imply "this slot is gone", it should be a flush
> command, no more, no less.
hmm, but KVM also registers to the page track
"node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;"
And in kvm_mmu_invalidate_zap_pages_in_memslot, memslot (actaully all the shadow
page tables) is zapped. And during the zap, unaccount_shadowed() will drop the
write protection. But KVM is ok because the dropped write-protection can be
rebuilt during rebuilding the shadow page table.
So, for .track_flush_slot, it's expected that "users can drop write-protection
for the pages in the memory slot", right?


> AFAICT, KVMGT never flushes anything, so fixing the bug should be a simple matter
> of adding another hook that's invoked when the memory region change is committed.
>
Do you mean adding a new hook in page track, e.g. .track_slot_change?
Then right before committing slot changes, call this interface to notify slot
DELETE/MOVE?

Not only KVMGT, KVM can also be affected by this failure to MOVE if it wants to
support below usecase:
1. KVM pre-populated a memslot
2. memslot MOVE happened
3. KVM pre-populates the new memslot (MOVE succeeds) or the old one (MOVE fails).
So also add a new interface for the MOVE failure?

> That would allow KVMGT to fix another bug.  If a memory region is moved and the
> new region partially overlaps the old region, KVMGT technically probably wants to
> retain its write-protection scheme.  Though that's probably not worth supporting,
> might be better to say "don't move memory regions if KVMGT is enabled", because
> AFAIK there is no VMM that actually moves memory regions (KVM's MOVE support was
> broken for years and no one noticed).
>
So, could we disable MOVE in KVM at all?

> Actually, given that MOVE + KVMGT probably doesn't work regardless of where the
> region is moved to, maybe we can get away with rejecting MOVE if an external
> page tracker cares about the slot in question.
> 
> > However, if kvm_prepare_memory_region() fails, the later
> > kvm_activate_memslot() will only swap back the original slot, leaving
> > previous write protection not recovered.
> > 
> > This may not be a problem for kvm itself as a page tracker user, but may
> > cause problem to other page tracker users, e.g. kvmgt, whose
> > write-protected pages are removed from the write-protected list and not
> > added back.
> > 
> > So call kvm_prepare_memory_region first for meta data preparation before
> > the slot invalidation so as to avoid failure and recovery.
> 
> IIUC, this is purely a theoretical bug and practically speaking can't be a problem
> in practice, at least not without completely breaking KVMGT.
> 
> On DELETE, kvm_prepare_memory_region() will never fail on x86 (s390's ultravisor
> protected VM case is the only scenario where DELETE can fail on any architecture).
> The common code in kvm_prepare_memory_region() does nothing for DELETE, ditto for
> kvm_arch_prepare_memory_region().
But as long as with current code sequence, we can't relying on that
kvm_prepare_memory_region() will never fail for DELETE.
Or, we need to call kvm_prepare_memory_region() only for !DELETE to avoid future
possible broken.

> 
> And for MOVE, it can only fail in two scenarios: (1) the end gfn is beyond the
> max gfn, i.e. userspace gave bad input or (2) the new memslot is unaligned but
> the old memslot was not, and so KVM needs to allocate new metadata due to the new
> memslot needed larger arrays.
kvm_prepare_memory_region() can also fail for MOVE during live migration when
memslot->dirty_bitmap allocation is failed in kvm_alloc_dirty_bitmap().
and in x86, kvm_arch_prepare_memory_region() can also fail for MOVE if
kvm_alloc_memslot_metadata() fails due to -ENOMEM. 
BTW, I don't find the "(2) the new memslot is unaligned but the old memslot was not,
and so KVM needs to allocate new metadata due to the new memslot needed
larger arrays". 
> 
> As above MOVE is not handled correctly by KVMGT, so I highly doubt there is a VMM
> that supports KVMGT and moves relevant memory regions, let alove does something
> that can result in MOVE failing _and_ moves the memslot that KVMGT is shadowing.
> 
> Heh, and MOVE + KVM_MEM_LOG_DIRTY_PAGES is also arguably broken, as KVM reuses
> the existing dirty bitmap but doesn't shift the dirty bits.  This is likely
Do you mean, for the new slot in MOVE, the new dirty bitmap should be
cleared? Otherwise, why shift is required, given mem->userspace_addr and npages
are not changed and dirty_bitmap is indexed using rel_gfn 
(rel_gfn = gfn - memslot->base_gfn) and both QEMU/KVM aligns the bitmap
size to BITS_PER_LONG.

> another combination that KVM can simply reject.
> 
> Assuming this is indeed purely theoretical, that should be called out in the
> changelog.  Or as above, simply disallow MOVE in this case, which probably has
> my vote.
>
Yes, currently it's a purely theoretical bug, as I'm not seeing MOVE is triggered
in upstream QEMU.

<...>

> I'm not 100% sure that simply moving kvm_invalidate_memslot() is functionally
> correct.  It might be, but there are so many subtleties in this code that I don't
> want to change this ordering unless absolutely necessary, or at least not without
> an in-depth analysis and a pile of tests.  E.g. it's possible one or more
> architectures relies on unmapping, flushing, and invalidating the old region
> prior to preparing the new region, e.g. to reuse arch memslot data.
yes. what about just moving kvm_arch_flush_shadow_memslot() and
kvm_arch_guest_memory_reclaimed() to later than kvm_arch_prepare_memory_region()?


diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 25d7872b29c1..f9d93be2ead2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1716,6 +1716,19 @@ static void kvm_copy_memslot(struct kvm_memory_slot *dest,
 }

 static void kvm_invalidate_memslot(struct kvm *kvm,
+                                  struct kvm_memory_slot *old)
+{
+       /*
+        * From this point no new shadow pages pointing to a deleted, or moved,
+        * memslot will be created.  Validation of sp->gfn happens in:
+        *      - gfn_to_hva (kvm_read_guest, gfn_to_pfn)
+        *      - kvm_is_visible_gfn (mmu_check_root)
+        */
+       kvm_arch_flush_shadow_memslot(kvm, old);
+       kvm_arch_guest_memory_reclaimed(kvm);
+}
+
+static void kvm_deactive_memslot(struct kvm *kvm,
                                   struct kvm_memory_slot *old,
                                   struct kvm_memory_slot *invalid_slot)
 {
@@ -1735,15 +1748,6 @@ static void kvm_invalidate_memslot(struct kvm *kvm,
         */
        kvm_swap_active_memslots(kvm, old->as_id);

-       /*
-        * From this point no new shadow pages pointing to a deleted, or moved,
-        * memslot will be created.  Validation of sp->gfn happens in:
-        *      - gfn_to_hva (kvm_read_guest, gfn_to_pfn)
-        *      - kvm_is_visible_gfn (mmu_check_root)
-        */
-       kvm_arch_flush_shadow_memslot(kvm, old);
-       kvm_arch_guest_memory_reclaimed(kvm);
-
        /* Was released by kvm_swap_active_memslots, reacquire. */
        mutex_lock(&kvm->slots_arch_lock);

@@ -1846,7 +1850,7 @@ static int kvm_set_memslot(struct kvm *kvm,
                        mutex_unlock(&kvm->slots_arch_lock);
                        return -ENOMEM;
                }
-               kvm_invalidate_memslot(kvm, old, invalid_slot);
+               kvm_deactive_memslot(kvm, old, invalid_slot);
        }

        r = kvm_prepare_memory_region(kvm, old, new, change);
@@ -1866,6 +1870,9 @@ static int kvm_set_memslot(struct kvm *kvm,
                return r;
        }

+       if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
+               kvm_invalidate_memslot(kvm, old);
+
        /*
         * For DELETE and MOVE, the working slot is now active as the INVALID
         * version of the old slot.  MOVE is particularly special as it reuses


Thanks
Yan
