Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAEC36BE2FB
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 09:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjCQIVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 04:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjCQIUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 04:20:48 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D074BC082B;
        Fri, 17 Mar 2023 01:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679041223; x=1710577223;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=A4L/cDIHWKRCR1ooNPxZ3VKnJICgVNSw1HZHwmIPPMI=;
  b=ZVZ4/zsH/MEVjH1MiJSLBHbFHfZgw/ojngy7qelUHF3DnT4wCtR94Wnu
   d/swkfovBvquN+utZFl3xme82etihfDjH6wmwaqfueGewM7AzUuzis3Er
   bjjboNYaY6Np05bUw82awitYEJ62OUgkv1FjZ//IYCKJMvB2TZ84IIdeO
   bI0SWPvD8Z9rzBRZTBaMfxZ4IDihuvWDUVGhBvE4qVh+A+LilxYwEw033
   p7/lPLn3cKzFfjbAnBG/qO4yA43PfdfrHaG02lWWfaGjyf0e7kU6UjucW
   bMSvU2/733a/u1UVbPjO1SRDxyGiH3EGdkGsxHe6Xtld0ifTaUt0y+wT5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="424481149"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="424481149"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 01:20:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="854363530"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="854363530"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 17 Mar 2023 01:20:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 01:20:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 01:20:16 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 01:20:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhvDb/aQQmd4vwor9G1T8BqkQ4UB5QLrn4OegG7ypOhl1Nk4SoNUtV9P95IQIIM1IVd8vCVnFU3Yl16Of+xKPcATuPWzDsQtWMeoXSF9FX4ut/jqkCOWaJpfwQedzMJHQeoBFF9wtP/RpkEOKGJgykl9iA3BWNI2xaersvv3w9E1xHIsvPyAUofNaAOaXzPms4hcbIl+eQCQjR3J3eUI3GMIC8KriqT+wQLS45h02nI+13AZP32m3TB6LXiwlx7yXbKr34F08BFqT1RhCgn34zxIViu26UKoO+0XK+gTJSzaDX2obQOBhc76udnyBxknfsXH4Ert8xrszN+x1qFCfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=shIM8kX4WrwdamTAZLwSfphU+4oAGAdHVg5hCiXcIHc=;
 b=Lfmx83AHOkFETQzWptSbfU9BuEEwpnRRaDk06fwZA5gSeGmw49t5egzTIdX42FKWJ3ff/V+dkjUaLbjI3yiR8UOQONviLfDyc/KQGjVQTSOWa6qv5GJN+7WaNcMK0uwjcI660nOyn8D1QG4Lm8qGVCKXOvFd4rLPDgossFayayJIuCfNkvlmM6WmejTYFn1gCUZtk+Gqvm/cfAWTdg5Ikyov2rJIouwHneRUH9+kaJyz5WF6XyrqMi84FAjoaONA+Qogb/P5xk9NHR8AtA+heJTMd1Wqv6Bp1UvsHCGGnmxB46/erFkFxiswUmjO0U2R3cUJ26WharvD5eV9S6KDXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7338.namprd11.prod.outlook.com (2603:10b6:930:9e::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Fri, 17 Mar 2023 08:20:13 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 08:20:13 +0000
Date:   Fri, 17 Mar 2023 15:55:34 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 23/27] KVM: x86/mmu: Assert that correct locks are
 held for page write-tracking
Message-ID: <ZBQc9owYBNdKmMuG@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-24-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-24-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0105.apcprd02.prod.outlook.com
 (2603:1096:4:92::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7338:EE_
X-MS-Office365-Filtering-Correlation-Id: 186ba4d1-825f-4866-b079-08db26c06e1b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PFh598NXUY2kgRJZyGCO5MYNaSQQH9yZMILLDZWvVR1m+MuMC8A0ucvJzY+sRnvmuj086R/MmhSQjMClQG3Ei5vFzlGrkJVlkdo3BP4xZU7IKDgsttQTHG3ZH9AiOgWLGbXXdhbMFgpTEOOV7fMzKBOVt7TER8rgbGjwCkxoDhWar16czXC5IpoO0hoImDGfv8a2z/nG6llJKRhtks9yfC6i3nJ4Y+VxExK4SZUt2dE51uW29XTgLar8voajbBJ69sFcaQztbG8IwGDJmTJ4jGTF50VE1uksu3kJjOPowYGbxrWDyqnDfjmml67QxJS7P5x6NwEkQs3tG5VUZ7zYQFDuT0e3PsNumvCe/s319ZHVauNcG70uBsTMkMkKKfPJMyBfWvq/v0gi3Wr94TeJyVpLCX73Keo7IukevojAVjheZx1DznDFeyKvd8apojrmhobUTzF+jMHbVTetL7j4khdnQIPk33jeOt053YykyfzwYMqQQOfYl0EXA5UHTC1AZXqZQEeCfdQ7EARKBRc0LzC082nHb1vE9T2CV589yj6LgP8UaLKMivTf1s48C5CCGzpJEzMRHjvs3WKYqYPc/osSX2Hz937WLHavoBDbwS/Ex4OisnLZzpEw8qynltA/Ntcrdhxn/VyX2S+I5vj6pA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199018)(3450700001)(82960400001)(2906002)(8936002)(83380400001)(5660300002)(41300700001)(86362001)(66556008)(6916009)(66476007)(316002)(4326008)(66946007)(8676002)(54906003)(6512007)(186003)(478600001)(38100700002)(6486002)(6666004)(6506007)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RFy6vZe4P++qaPNRlDwhZKo6p41EsgknC1kqU5G8iq47QH/NgwPHg2dmCWDY?=
 =?us-ascii?Q?DRv2SyLzAPUD4kqnR/Sa4OAf7myToINKUCgk7aNOXDp6UJBIFj41zslEvznn?=
 =?us-ascii?Q?Ahfen1l2qVWPiOHcmxxVcV9RTpiUNz0CyXi4StPyeFu8PYAmY6ALbCJKhiIC?=
 =?us-ascii?Q?JYozuOue4puOGz+8O8OclBn46ju7/3QiR0Umad947+NlkN4QILgxyWy2+LsK?=
 =?us-ascii?Q?NU7glghSjrN8uJJhQUf8Q5zeZKz0NI/hw9rU9hoQsNep3Hg+5MG6E4T0uQMx?=
 =?us-ascii?Q?H6CEk8Qxc9yvcBqS0OukQ/kZtj8IGo3dcBZ5Pb2isdSBzn0LvBcamwseX6Zr?=
 =?us-ascii?Q?5nri7qHqQYUjbQVN1f2D4eRXeKOuUQ8YVaBp7OubSzU1OLPSYDGXSBFUSnlF?=
 =?us-ascii?Q?ozazM7/NG5WlSOUw5dJJcLGVL1wKAHKv3mcLYJyUn3VltenxMldYBNGqxJdd?=
 =?us-ascii?Q?PuvB1gj1Qucy9sbmb45sP8m4I3DCyCEeHX/PvgMnelHjx7S5xzBZakTe/846?=
 =?us-ascii?Q?xktODunCf79c1bIHzYp5Ose+VeMgk/b1Mp2ma3Kz0b7QMyUzfZg3ILLBxEQi?=
 =?us-ascii?Q?451P6o+Q6KCxbzerhHQj8u9rfjFoBrustDqXycGTcwQ3d3bUoO2kwQ67TDw5?=
 =?us-ascii?Q?8Bj//z/k7ybtG5M9GAGWKTXlSiMer76fB0jQYn1Sm99pOuTX53Y4iwa+7tQA?=
 =?us-ascii?Q?DOpfkUpeLzIhj6ZKIRwKTMJDNbct3N85PGfeVGmQ1Z35YIHB4dZZnbvrmvb7?=
 =?us-ascii?Q?6ErQtr2aTROWsSS8rIO5dcN5Zx4vnaO/1/bJmgjps5yRb7zzjq7m25DiLLMn?=
 =?us-ascii?Q?7p81TJ1EPFnc03DPp8KdA8HUjAE+MA56+jAqvevTDpXKEshGnXyP4UJB0YrW?=
 =?us-ascii?Q?VQ0oXFlIoxCmZn1ie5jWdjkrb53ew+gKvfcourAuaa+yrTyJFO0I1FiiZkhb?=
 =?us-ascii?Q?jKA8cetAwNT4FJM0VnosfQ3f/sN06J1Xe0sWUBJE/SGer5iyeX39O+VZgjAa?=
 =?us-ascii?Q?ERDKyvIepWP+X56GXeP3f/cVsSHZ8u9Lrfh8yEa6HLE3F8oc/rOm0CGK/Q2X?=
 =?us-ascii?Q?IGqQAaWUPuA9AohTtn6dio5qKS344MMumXjKMsIEDPg4OT1OQeqENpXsKE+p?=
 =?us-ascii?Q?oVU9LGAMt1A6OfU1JsAA4GHu1kmDa/qxzYSQunvQH8F/5z9IGStUXTFrH2+J?=
 =?us-ascii?Q?cQYucgY0nQeel+BTCO4dcp9f/2aGrdZcYxkEUsxY3Mx2v2rbK0pPFZV+VMv3?=
 =?us-ascii?Q?KgtTUNBJ2lfpDtlVRGRr6YO4A8G66tsDoxR60CvVSs3GBdFbXrPaIxaf8tsy?=
 =?us-ascii?Q?I1bkxWbhZQgHCv0JcTTWGeO/MjwhA4JHlheocCwbbSxYfrYffkaaHSwu5/kt?=
 =?us-ascii?Q?n2Bc/PyoZaP2uzbUYUVc3MK8Xli1oudpmcevQgeX4CWcg0yfAFGMLAhzl0xW?=
 =?us-ascii?Q?1Za+47XRCEu5mdulIepChOnz0XuagUA8x1/W++TSAMCnDzMgv/80DiZ58vdf?=
 =?us-ascii?Q?8QrhX3eCiDyzZTpGrk8074reVDDuCjWd2eixGqNXDG1aK4ZXhpSrt6z01AaJ?=
 =?us-ascii?Q?0GPQ1zzdF9TgANwTDzAusFijg94gFh9nxm01T+tDPOeDup67GkQtr2sGsHHg?=
 =?us-ascii?Q?/g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 186ba4d1-825f-4866-b079-08db26c06e1b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 08:20:12.7816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UE1lihJ5FvytnVn0JMCMX9dcSL1/pPA4tQo9Iq1c4al22/BOEVbMp6XkwlbZnWnmYaRtmn7+ONy+y9SppbQqUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7338
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

On Fri, Mar 10, 2023 at 04:22:54PM -0800, Sean Christopherson wrote:
> When adding/removing gfns to/from write-tracking, assert that mmu_lock
> is held for write, and that either slots_lock or kvm->srcu is held.
> mmu_lock must be held for write to protect gfn_write_track's refcount,
> and SRCU or slots_lock must be held to protect the memslot itself.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/page_track.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 1993db4578e5..ffcd7ac66f9e 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -12,6 +12,7 @@
>   */
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> +#include <linux/lockdep.h>
>  #include <linux/kvm_host.h>
>  #include <linux/rculist.h>
>  
> @@ -77,9 +78,6 @@ static void update_gfn_write_track(struct kvm_memory_slot *slot, gfn_t gfn,
>   * add guest page to the tracking pool so that corresponding access on that
>   * page will be intercepted.
>   *
> - * It should be called under the protection both of mmu-lock and kvm->srcu
> - * or kvm->slots_lock.
> - *
>   * @kvm: the guest instance we are interested in.
>   * @slot: the @gfn belongs to.
>   * @gfn: the guest page.
> @@ -87,6 +85,11 @@ static void update_gfn_write_track(struct kvm_memory_slot *slot, gfn_t gfn,
>  void kvm_write_track_add_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  			     gfn_t gfn)
>  {
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +
> +	lockdep_assert_once(lockdep_is_held(&kvm->slots_lock) ||
> +			    srcu_read_lock_held(&kvm->srcu));
> +
>  	if (WARN_ON(!kvm_page_track_write_tracking_enabled(kvm)))
>  		return;
>  
> @@ -107,9 +110,6 @@ EXPORT_SYMBOL_GPL(kvm_write_track_add_gfn);
>   * remove the guest page from the tracking pool which stops the interception
>   * of corresponding access on that page.
>   *
> - * It should be called under the protection both of mmu-lock and kvm->srcu
> - * or kvm->slots_lock.
> - *
>   * @kvm: the guest instance we are interested in.
>   * @slot: the @gfn belongs to.
>   * @gfn: the guest page.
> @@ -117,6 +117,11 @@ EXPORT_SYMBOL_GPL(kvm_write_track_add_gfn);
>  void kvm_write_track_remove_gfn(struct kvm *kvm,
>  				struct kvm_memory_slot *slot, gfn_t gfn)
>  {
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +
> +	lockdep_assert_once(lockdep_is_held(&kvm->slots_lock) ||
> +			    srcu_read_lock_held(&kvm->srcu));
> +
>  	if (WARN_ON(!kvm_page_track_write_tracking_enabled(kvm)))
>  		return;
>  
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
