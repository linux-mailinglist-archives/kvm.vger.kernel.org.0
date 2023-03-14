Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2004E6B8901
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 04:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjCNDeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 23:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCNDeB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 23:34:01 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F791ACC5;
        Mon, 13 Mar 2023 20:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678764838; x=1710300838;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=EQy0cUMOnCWXzlgFsAU1bcjc8QBOnQa+8Ob0wUlASns=;
  b=nGnmlf8Yvtvulvp8zeg5rZqevqD/+xqjkVxGDOeb8j3JJPpFeZgqxFuK
   GfejTUTb7wSgeoyFkAaHI18Z1bCfQyRsDiGYm5R4zezPWZns7YhQtEuTr
   TTK8umq8KLp8aYqkzdFQqZp43TVq7Htzxb/iB/LW7hU8b7JphYqTaS2X6
   D/ggeJxYtWHRVFir6KxTVPKLio2QgF3z9H5QZeji6182bT/MG04wusfFJ
   R6hhgvXqnqx3Pq0IUJxFBXXaJl0x3UNSWCOLOjG4Cu2wZOVmfuD6T8Yp1
   HgqThLEbsUa0GvhdRqXgEcF9n13jJ1Of1yERw3P1x4sqF0S+JE/Zybqiz
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="334798705"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="334798705"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 20:33:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="747847643"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="747847643"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 13 Mar 2023 20:33:57 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 20:33:57 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 20:33:57 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 20:33:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOF7LR/BhV4156gAW6hGeePTOVfFwpvvYCJg8bKaf/lZY153+W+d4aNfwnY54K1cuF7gRyb6OzMYii3VjiI9Tzswh+q5Vku0iJGKgB2HRsuPX0VS5UOaqs9L6pENgSrG6Ge+xz10TiwZjLQ0OZMvsUaOusmDBIYzzPNxNq+/Ah2pncaY+hciGOu2WmuswQ2EYv85cDRIJikJjfIp93dXTCqMRojoyLZhz1rG4wOjAQUeFv4FvamAWxREKJEbQ/yhQSPY9Pj5BIOI1U1zFktXP8UEURZeCvhDhHBXAjk3T9cScE0InO7zT6kUxFhyFh+xguRuSyCkQ9jJvDCwk23XXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ol9s7kmJkpZ6xPGqVUoOvWFh6RYAr0tfMPvj8+YdBfU=;
 b=Pv8aDFBhh4T64O9/ynHKQ5Ytn6JI9JUoDbX8oIOauUBG2BTZXtXCyxqMfuHAs0nmDLxAX33lAiQLlJoJq3KR8sdPrucmuYTodJMRyUdNyuxEmRBm0obnRzwrQ17LiAKY7AxeWc2970YC6X8XJNvPuHZh19zHKux4NoFXuHcX0EJ/IjXLiTBkrYmc4guR9m2KVdqkI1sydCzp3kD4BQwrLU5Ix6KlzL9QvMXqHoQvglNJkSxtPS9tyY+dY+7PFUlRSGyQ/WjlmfY94rH4wMO+I6oxWzFyxG1h5bonyamqbJW/suzUA37nn03t7mf4ydJtJM+0xB7nPPQhi7uFUPlJPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by SJ2PR11MB8345.namprd11.prod.outlook.com (2603:10b6:a03:53c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 03:33:54 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::101b:3fe1:ba2f:7a99]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::101b:3fe1:ba2f:7a99%3]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 03:33:53 +0000
Date:   Tue, 14 Mar 2023 11:09:20 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 04/27] drm/i915/gvt: Incorporate KVM memslot info into
 check for 2MiB GTT entry
Message-ID: <ZA/lYL7dsv7xBA01@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-5-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-5-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0115.apcprd02.prod.outlook.com
 (2603:1096:4:92::31) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|SJ2PR11MB8345:EE_
X-MS-Office365-Filtering-Correlation-Id: 77198ad1-eccd-4cbb-fff5-08db243cef36
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cBECf4EXDMl/6Ax8SPzyp4tHlsLTUMe8mtGbg9kc//IIh90z1tFr4JD+upit+dAMQojCeLeOPlikg0e7hHdybLYGZJXyGENWWaAed3cPzcbEpic99yTSoMLSFH4MnYBy3ycLjR4haOIMXe9Ntp9pXX4GMYkdbWDXj1XqEoH6d8waBUXy3CA6s8Lho10w93ZQrrFtV0lzDiLOD95M6RJBLrPtyNU2HLcqV4hUFwb7eE40Z2k0mtDM6vSHUOAgMGUYvYhnKIeiFksrMVNl6P4hrWzNcBARMl8Gm+0MrWkNRsWE/jXocIoV7M7FW3s/aDKCyOh2mYo8Kazm0zcnyl54WmVF2XTfGDDcyMN1/LUuwaCfDD6PowTXuejkc0sQMCq+D2RGLE8Euc3GMmvNQWNGMK2GPPryqzvuHTzKwMKQI+pJMGe2tlaUV4eCXlv+QIIPPZjJpEGKbdc5CTy7SWgLyeRBb0zoUV8KAt5bzQI52wNA2S4s9x92v6uPWj+gyaryJXWYLJfNTQj47Kv33wW3TmAXbetorVna3M0a0tHWE9Bq8t8rJyFraFpKdrCnQPbR600k2BC6ge6qGOVkPgXNZmho+CXgyeP2CMEntOmowV1OkRpmJInC2bKUuVaBXn9fJgdKZu/w7uocKatPaNaeuktGbEFbF5mZKEoquuWbfnc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(136003)(366004)(346002)(39860400002)(451199018)(86362001)(82960400001)(38100700002)(41300700001)(4326008)(66556008)(8676002)(66946007)(8936002)(54906003)(478600001)(66476007)(6916009)(316002)(6512007)(5660300002)(2906002)(3450700001)(83380400001)(6486002)(966005)(186003)(6666004)(26005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UgkCO7k9n9EkAZwH81g5rvbIsr+F37ta+TxXPg/TM2ZZPo8JnAbgiaFMyyz3?=
 =?us-ascii?Q?okmOvmLCODXPNUUjCEQUsbY7lFegveQNAzHr4nup4VgNHwouowuTpOvHGTdT?=
 =?us-ascii?Q?kr9MB9uLtINMQXWd6QK6RirH0371bchN/08e/rquDQ5CRKthS9gGC8qeyBxh?=
 =?us-ascii?Q?2Y9KbIIJcb25SFuJsbk2gy4TIsHUJ+zRCSa7GOC9QAVetcD3DtLQnIkDtLiW?=
 =?us-ascii?Q?m5SOmgl9ltCMk80oGBgL2OEikX0e7Ngdlj9w6GMiYEWCkxzuhBiMGvjg2a/g?=
 =?us-ascii?Q?XTGIWZnA2OW/dRMaftaVUo6+duB8Hk7M33q93xU6eQmv35y+fXW5un0OGzz9?=
 =?us-ascii?Q?5fFybs8nRU+8U+DvDhrDY5QBO0fyQIBpFqUwJS4G01bTW3fXkLxawNXX2wN6?=
 =?us-ascii?Q?SLv7VRh/A/zKZvutxGBTm5gcT6zuj2JGETwaT6CwXDrO+8uN1g590TbUv6Wh?=
 =?us-ascii?Q?+lhg2XeBZ9s61VckLSr5f39Oeonw8CKt8l7j5SlluthbSWubm/lJzV+c9qDK?=
 =?us-ascii?Q?v2y7hPhzffntpKPLagwgq/UEZiBwFnr9dRiIqW0q4G3g1FhaF7ti3WMbf1fB?=
 =?us-ascii?Q?2dWEB1xIU2dJCM0MBS7xwahw2S596EPdQQ0Jna2Gnj9zsYdTHCQNHmSzZxQX?=
 =?us-ascii?Q?2k/pykVXTCQVShVAqjbYfVrB6ZW6N82PDp+AGqDI1qT77aMlyODS4V+1din/?=
 =?us-ascii?Q?1ajJXwVyjxWhIMDmXph1/BE3Aukj4iVTYUEFUi4BEYho98hC4Ry07ctMuMoK?=
 =?us-ascii?Q?LLPdjkqvzvnC3vdmpwE533ATENSSPRAbkq6zH4huTtz0nex5Fzx8RlYz3Xn/?=
 =?us-ascii?Q?thyPOLZWQVFbWXTh+hZ1eMu+fTTmhusphw2vQoBFkJrOBu4VlpmR2z851Fl/?=
 =?us-ascii?Q?RPLwfZaQOSUYoUSWOzrSc2loUFBLIHZjebVzm/C8xmOmTfJBkSMtoVIQRBJQ?=
 =?us-ascii?Q?LvxNdTFmDrtmBcOVVTIsewfql7qhWQjB0uYCERoa19SCFKzF+J1fmu9gyUUS?=
 =?us-ascii?Q?nKh4H745tVj2w21RU97rHx7mLbE4h4a5dZiWJszOWcOKT4j6Bw9k5l8JfbVW?=
 =?us-ascii?Q?Y6EBwSlHlG+sb1JFl9HsiAEeSP6mWUjRRDJPzd3oSLYiZ3J8zWkLuZ95TwY3?=
 =?us-ascii?Q?uQbnCZlu+GoYoxYXYDncpiR68StGEW8YTDQuiSIiYpIg7R916GN0qgIAb1Iw?=
 =?us-ascii?Q?zGhkb+tMfZSLuS690RVs6i8hrH2pDD9SrVcDg58MqGApUwRswcnEPoBIn+Gj?=
 =?us-ascii?Q?5VqhzxdA6IA5eZ1Wfqf5wEEa/R0im6sYe7fRTYkK9f7og2yeVHjJ/BTMLzVh?=
 =?us-ascii?Q?BFgWFN8Dr/hCYqqMpIlZvOgr+cwKyFcLyGvg3nq/vsrbW+SROzy7Qv8jCbuT?=
 =?us-ascii?Q?eIqksZqvJOFhaUpBMjiYGyUYeXuFhGFx0L+377yGnkYUBbIUjt0g6bZc9gI1?=
 =?us-ascii?Q?+yPEjMpDt4k9PRk/7Xnq5GNrznKYPjIZ18ctWxwTk6PB1wy7eVlJmu/WLPUa?=
 =?us-ascii?Q?5m13+N5F6mWKY0NarYQ+OIZZAjneMN5bqoQbvfO56gCpIGWVBSJuR3APRLZn?=
 =?us-ascii?Q?Y04p5xrNoTFwKO5M8JN011D+R3Dx/DmDtwCnoxZPICJcU9kHCGtwt0dmoxcx?=
 =?us-ascii?Q?Ow=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77198ad1-eccd-4cbb-fff5-08db243cef36
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 03:33:53.4616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xHDLbJJsMojf8HqUGZAZHlw+/KNe6T1FqowJte/TS11S6UZQfCHPqYRvKdCyGvB0QLubISQkuKFa5E7KJUb42A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8345
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

On Fri, Mar 10, 2023 at 04:22:35PM -0800, Sean Christopherson wrote:
> Honor KVM's max allowed page size when determining whether or not a 2MiB
> GTT shadow page can be created for the guest.  Querying KVM's max allowed
> size is somewhat odd as there's no strict requirement that KVM's memslots
> and VFIO's mappings are configured with the same gfn=>hva mapping, but
> the check will be accurate if userspace wants to have a functional guest,
> and at the very least checking KVM's memslots guarantees that the entire
> 2MiB range has been exposed to the guest.
>
hi Sean,
I remember in our last discussion, the conclusion was that
we can safely just use VFIO ABI (which is intel_gvt_dma_map_guest_page()
introduced in patch 7) to check max mapping size. [1][2]

"Though checking kvm_page_track_max_mapping_level() is also fine, it makes DMA
mapping size unnecessarily smaller."
This is especially true when the guest page is page tracked by kvm internally
for nested VMs, but is not page tracked by kvmgt as ppgtt page table pages.
kvmgt is ok to map those pages as huge when 4k is returned in
kvm_page_track_max_mapping_level() for this reason. 


"I'm totally fine if KVMGT's ABI is that VFIO is the source of truth for mappings
and permissions, and that the only requirement for KVM memslots is that GTT page
tables need to be visible in KVM's memslots.  But if that's the ABI, then
intel_gvt_is_valid_gfn() should be probing VFIO, not KVM (commit cc753fbe1ac4
("drm/i915/gvt: validate gfn before set shadow page entry").

In other words, pick either VFIO or KVM.  Checking that X is valid according to
KVM and then mapping X through VFIO is confusing and makes assumptions about how
userspace configures KVM and VFIO.  It works because QEMU always configures KVM
and VFIO as expected, but IMO it's unnecessarily fragile and again confusing for
unaware readers because the code is technically flawed.
"

[1] https://lore.kernel.org/all/Y7Y+759IN2DH5h3h@yzhao56-desk.sh.intel.com/
[2] https://lore.kernel.org/all/Y7cLkLUMCy+XLRwm@google.com/

> Note, KVM may also restrict the mapping size for reasons that aren't
> relevant to KVMGT, e.g. for KVM's iTLB multi-hit workaround or if the gfn
> is write-tracked (KVM's write-tracking only handles writes from vCPUs).
> However, such scenarios are unlikely to occur with a well-behaved guest,
> and at worst will result in sub-optimal performance.

As being confirmed in [3], there's no risk of iTLB multi-hit even for
not-well-behaved guests if page tables for DMA mappings in IOMMU page tables
are in a separated set of tables from EPT/NPT (which is the by default
condition currently).

[3] https://lore.kernel.org/all/Y7%2FFZpizEyIaL+Su@yzhao56-desk.sh.intel.com/

So, I'm fine with exporting this kvm_page_track_max_mapping_level()
interface, but I don't think KVMGT is a user of it. 
> 
> Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
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
> index 0a2ac438d647..e739dcc3375c 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -301,3 +301,21 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
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
> index f30922c55a0c..d59c7ab9d224 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.c
> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> @@ -1157,14 +1157,22 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
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
>  	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, vgpu->status))
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
> 2.40.0.rc1.284.g88254d51c5-goog
> 
