Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D396BE240
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 08:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjCQHyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 03:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbjCQHyJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 03:54:09 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A93C5AF9;
        Fri, 17 Mar 2023 00:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679039610; x=1710575610;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=KaV4oSUE0DVJjJh4xxYc6aijsqBIcnXMzHrreFnOt8c=;
  b=J5tZafzbNpgIlUXjc/Vg8YYDzT2rjzMLOMJlmdkbF9G2XvFL444r0fxM
   sxnaTb1Im2MyQJfvfkdfCxUefua9QFG0FSJErvy6pDlRMepAYTPNwgNry
   p6RJm6ctENeunKwmhJYgqcO08iOnYPRRYe/iQA1zhhidU6hWnw+ZjFef2
   keQVwgRlbg/FDLbuXz2prNY/2pes+dLIdm/i6RqhPxsTNCpegDJHsRlgW
   ca5nabySlWg6v+8JQFAanWOC/zkG6iM9fjmXYL5UYROGWjOKXHtr3ctrH
   4klNqW+oL/W4rs8BanVxQq4CGwFrgT7DRDOytcR+hB28lFYehaQa7SsoI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="339745311"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="339745311"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 00:52:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="630204121"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="630204121"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 17 Mar 2023 00:52:56 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 00:52:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 00:52:56 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 00:52:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ka8aNnygzwTO8wnimCpBSBPXM0pGgqNbzBkIhAV+mw0h0Eg52lMo3aqc/98aEV+QX2zfLA9dXwF4SsqxsHPtEUahY3ErDM1Ou3DZ45PejTStxvnCIK0/zOy0mFuZ4soYWgffFTOa7NYQ8WDjuDhRZ5KFurtJLMHBTwQDPzT6iSrhxN1Au0MAD29vuwbJ0m8hziPV0so5CVO+TbBxJPvNIp+LtEfcTPzCHWMEU1HdIDKv78VL27n8McQmNJh0C387rBrIqOEUI6uSQAE+U+lrmTNHfe1wK++/P35DWq0GSrQwJpgqU2gHu4aQuRlGdHNUxXmJ6XfyJOHVGzJ+k+cZDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+T3ayPzai7oKuRNXsAYFpz15zEWBJSBynng070/4jY8=;
 b=Om/SW59zuEx+IW6erGKccxQ7T4vYomhLWHy3KNvt118+9VXDH4YThYKRmFPZY6uSslh3WDhkqZQalpPkQl66Cq3UD6x4MSAM2onCEYTgkNOgELvV8Cj/I9CPi2Ix9kTppKw5ZBAI7JPOlpqFZXNPLRM8CkFYYW5xJp3amIYEhPyaZLzFfvmCUfZFib1skoDhP8BRIHvvQbGSsQYJ2TQXNwmwfZ9KA4yOxxM8rwQw53CrsVPrw/XdYqSGW/b+G7z52dEkNnX4bKh8qjnHrOW2JdHk2NZOyzlYl87WsXfWVz+LrmSFL2WhvFnvEPsHr+Q+IuHyF6yABuoXMXbAeOknww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6272.namprd11.prod.outlook.com (2603:10b6:8:94::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.31; Fri, 17 Mar 2023 07:52:48 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 07:52:48 +0000
Date:   Fri, 17 Mar 2023 15:28:09 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 13/27] KVM: drm/i915/gvt: Drop @vcpu from KVM's
 ->track_write() hook
Message-ID: <ZBQWifhj6lZxRlMa@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-14-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-14-seanjc@google.com>
X-ClientProxiedBy: SG2PR01CA0126.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::30) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6272:EE_
X-MS-Office365-Filtering-Correlation-Id: 83efed58-988f-4a60-ae86-08db26bc99b6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UwfmXIRpXhTpUT6G4PYiNTUuqFTF4PbwO91T+/dJoM6d/vU5aZuLNsSEvHjBuOrnUK0V07zFz6ioXs9CmAGqtXALBTqa1KgNQ86rNNYfaEovVI5lo/mgYU+vznWOJCWp5HjMkw/zjxXtNZx6nH5y6SOSR4Zm0ZI7F1LXJiQLNl+zz/ZwgDIVL9BDLR3NR4lC7hXHkuWuor0Tn/ZDfnPRjWD6/1b57LA4vXEOIThayzJytA7+ZCubJisnH/IiZDVmCKsKKjExRDziBYmyDsvZiPohN5cGqk+o299bzOY9iHlV0JQJJvyuGgocF6U0cFGzwpJSEeMG7QFTDUHxFnGlARd8u9t7lusp7vHqxrgLwSMtVAkpuKqZsDBsYG7rbJ/Vero41dZBHNuCD8fAEPaOzfRA1PDbTTRzF1voI5Vndi9Tcai/rXIBhx3UVueKkzmgCIXkvgyjCMEpnnchDBYmUuvSrGmXOCwgeFobv3Lj/wkLQna2SK/Okak7EiUZfbPt4kGutY21T4j9Yn5n73ZIoLx0TVGCVPNG/fEN4AV4dhGOZw44GaF16Gnln9R5gCdKG+LC+HSGY1D9acblBHUH/WHKS5NXrIb9ND0GIIlfZ9+8KrEeX7gIbKawEvUDKt8VX72TAAF8i2F0khqQteUUUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199018)(186003)(6486002)(478600001)(6666004)(54906003)(6512007)(6506007)(26005)(316002)(8676002)(6916009)(66946007)(66476007)(4326008)(41300700001)(66556008)(83380400001)(8936002)(2906002)(3450700001)(5660300002)(38100700002)(82960400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2I+cPsCzIPon0iY84JtdqWFtdVfr5yIuYhlt921+Ma/+5tuzL8W2qynrXwu6?=
 =?us-ascii?Q?WYjfQf7I2U+bh0r1Ro63Nb8ylq5FbeK60iYfckpM6XWPiVMDtmPPkfxdPfA7?=
 =?us-ascii?Q?xAIARLNbml1283UR5P7jnRx1MCnBgoAmUzmDibcrtQcUYmVo0MVU3sgwb3eo?=
 =?us-ascii?Q?tpxhcB+tt6ZHrgE0pTvV+4PYUog73Zy5OU3uF2Ezb+NnWDZyeT6GrA+/v9Cs?=
 =?us-ascii?Q?BwcEVUHMaiEujaX+/YQSonKIA14U3z/6QK1nsVh7p+RUZsFxWELGqwWDkxZN?=
 =?us-ascii?Q?xLWUlEAC9MN3W9vsLkGYNNP+A6yRFJ+jqlgO8L9LwZI0NnscPGu1k/Ta1P6j?=
 =?us-ascii?Q?raBr4y4Wqvx8J7NDg9DIckzxnD/O2nTT4Rj6ghcXjWL20bMu3wAXA42a4jvs?=
 =?us-ascii?Q?JPI2LcAWSSmT+wwUo7dJgXDVW7txthsazHp4F1itgINv7PGWHCyxwiRKUljr?=
 =?us-ascii?Q?grh/Pyyt8yFty3DCpbyOolbSmhO5nAH4mewfGl+O+p/XCoURJWKjqAF9W+ix?=
 =?us-ascii?Q?FKidSLuiqg6uIqJdyMJVqVi2iDCEAWLWWrwpxV30fIbznT5BiHyn78eO1ETJ?=
 =?us-ascii?Q?U853gb1o1Hyj7zON3z2gl3NoJqHUk10K6ZxpG8OCpvMu7w+EGsMSRx8v7msZ?=
 =?us-ascii?Q?9mfzp2rSG+wzxpF/i/0M3HZE0J6VqaMH/zKluSvpwzb9dfjMLLlSOpeIqcbm?=
 =?us-ascii?Q?18TWsQBemhHes9NfgSOTv8SD/SNXFF9GhHpsktWdzjVyT7ZNigCJOv3kKCDN?=
 =?us-ascii?Q?qjFlgND0fPXv1R34OOg6iWqxn/iqW5Hn5ms78AdsjFxOwYBj1d7EwJmYbj/K?=
 =?us-ascii?Q?1qrhqEXgU1M/4wg5aUYl+xitgPi/K82gFHNEby9VN6byy6nCofddsQv3wPOM?=
 =?us-ascii?Q?1hWE81FiBvQ05lQnCesjtwrm3GA93d2F9cmp+0CB2m0t5grG2/FFBFADhKoS?=
 =?us-ascii?Q?nErriCiIurjs0APa4ZJL32knNvov/It++bih4XrGrLsMAiG7Jy8pcL9ZMerg?=
 =?us-ascii?Q?tACJ6Diqlb70iMr+aWIMkOMn1frd7TdngCGco7W5COwtu8da4epw3g1j5DxY?=
 =?us-ascii?Q?VHLWYODCpixmrVq01eagXqCqpncgkeLgnUFc8RaQ4i/GTdX3Y9cPqCvLV3NO?=
 =?us-ascii?Q?z75gvAFaWrwVXiz9vovCKJ1DVRzPwcLFZMOHhrzoyo4WSvLIuD7GzKEdK1c6?=
 =?us-ascii?Q?sY3+iiSmAACANFbr0RLqq/rlkw8OqzIY/Opt11VTMZ87fBQ4DmDWZ900OPl1?=
 =?us-ascii?Q?G6LNmKGKBWGEng/zUzzNA5XZqUHTiVk8xPHXs3a8RAsU8cjUnAxAl24aZn39?=
 =?us-ascii?Q?MNdYSsCSS07dqh22wihI2fVCWnuVaYfft6wqPU3kVnA78ReJ0LG20RdBUrs+?=
 =?us-ascii?Q?tNaVHYm6DoDjJtbcLmkFNQE1/P5jojfVfbrvq1WkgFLPCsnA0WYwr4Kv2kjK?=
 =?us-ascii?Q?8lejhR+luiv7bj8G5O8uLWfTVhntGyN3D2N7WUkqxY4VOJXse62yH0lco+ub?=
 =?us-ascii?Q?lGsCSrc9cPBQ+RwAg0hkpg9K65GFqJohm855E1VZ/1v5esGatPvLddvoio8n?=
 =?us-ascii?Q?Updz0Ln4VPSPd8DDE5dND1BzYNB0KiVCYl7l6TJzlUG7SlQD4jiHcqVJROdL?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 83efed58-988f-4a60-ae86-08db26bc99b6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 07:52:47.9681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QKJe98bwQD2F5w+e27jjEPAJZ6yXrjbE9KRwW6vfmiNPubSZ74OWAA46K3yu6Z4soZD0/+8v6H1Jo9+t764PEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6272
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Fri, Mar 10, 2023 at 04:22:44PM -0800, Sean Christopherson wrote:
> Drop @vcpu from KVM's ->track_write() hook provided for external users of
> the page-track APIs now that KVM itself doesn't use the page-track
> mechanism.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_page_track.h |  5 ++---
>  arch/x86/kvm/mmu/page_track.c         |  2 +-
>  drivers/gpu/drm/i915/gvt/kvmgt.c      | 10 ++++------
>  3 files changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index 3f72c7a172fc..0d65ae203fd6 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h
> @@ -26,14 +26,13 @@ struct kvm_page_track_notifier_node {
>  	 * It is called when guest is writing the write-tracked page
>  	 * and write emulation is finished at that time.
>  	 *
> -	 * @vcpu: the vcpu where the write access happened.
>  	 * @gpa: the physical address written by guest.
>  	 * @new: the data was written to the address.
>  	 * @bytes: the written length.
>  	 * @node: this node
>  	 */
> -	void (*track_write)(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> -			    int bytes, struct kvm_page_track_notifier_node *node);
> +	void (*track_write)(gpa_t gpa, const u8 *new, int bytes,
> +			    struct kvm_page_track_notifier_node *node);
>  	/*
>  	 * It is called when memory slot is being moved or removed
>  	 * users can drop write-protection for the pages in that memory slot
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index f39f190ad4ae..39a0863af8b4 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -272,7 +272,7 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
>  	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
>  				srcu_read_lock_held(&head->track_srcu))
>  		if (n->track_write)
> -			n->track_write(vcpu, gpa, new, bytes, n);
> +			n->track_write(gpa, new, bytes, n);
>  	srcu_read_unlock(&head->track_srcu, idx);
>  
>  	kvm_mmu_track_write(vcpu, gpa, new, bytes);
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 9824d075562e..292750dc819f 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -106,9 +106,8 @@ struct gvt_dma {
>  #define vfio_dev_to_vgpu(vfio_dev) \
>  	container_of((vfio_dev), struct intel_vgpu, vfio_device)
>  
> -static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> -		const u8 *val, int len,
> -		struct kvm_page_track_notifier_node *node);
> +static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
> +				   struct kvm_page_track_notifier_node *node);
>  static void kvmgt_page_track_flush_slot(struct kvm *kvm,
>  		struct kvm_memory_slot *slot,
>  		struct kvm_page_track_notifier_node *node);
> @@ -1617,9 +1616,8 @@ int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
>  	return 0;
>  }
>  
> -static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> -		const u8 *val, int len,
> -		struct kvm_page_track_notifier_node *node)
> +static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
> +				   struct kvm_page_track_notifier_node *node)
>  {
>  	struct intel_vgpu *info =
>  		container_of(node, struct intel_vgpu, track_node);
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
