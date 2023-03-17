Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429986BE16B
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 07:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjCQGnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 02:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCQGni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 02:43:38 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FCC59D1;
        Thu, 16 Mar 2023 23:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679035417; x=1710571417;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=C/NNDW0IQDD8w2QKl/JtgtXqDub/DseZzA7r/3MDwtA=;
  b=OIdNQZN5AYwyEUn1ohwNTYyMA5CKeW+HR+HEdazL9xWXftJcADDhqhwl
   wNjOvy8ArVTjBI6893Gygf3KrtszjBOzu9/4hsf5WQM4aACyQietGq8g+
   ga4XiAwCO61TrMPM9CV7Wfa8UkfHrXYZmFHf9+opEg+NDoE6M2iIU54j5
   kgW1JaQZ5f/ON70Sw9gqYDNiQEbKj300bXPcog+IVTO/uPC5XDg9qbt7H
   y2IGgRZex25nM2uQl6tGySy0Q64U5w392MRdZ8YdifWz29OmdTZ+6dt9z
   zOQykw9G7w6DXGDMJ/nNQaW1No4f8FiCgD5bvwQUBf3jVNN4GXuPd24w/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="339735723"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="339735723"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 23:43:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="710401317"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="710401317"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 16 Mar 2023 23:43:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 23:43:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 23:43:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 23:43:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/2N9JRBB0uSjvX+l6PaeVca6Dbq2Xpn0uJ5N2d6SMhITML9OWIWZmRZNY7ZS+WECMbtO0aFcwEUkkT9SO97IPrdiAXe7lyMRILPGq/XcgazrkQ0EPWk52eCH4XF3keK05p9LHywyeoVGTq2QXvslR6GoF2rAtJ0ihI83Q2vElrJwt+tKoNQ6v2JkPIf9ZHg7dBPTd/gHtJC7OOIAgiYRRUvKcz83JyxwvEGcXuAqVQGfQSUuj8X5hhudkMA0wiEsiiab93/3UaWpiHsxc1vnMbkhAUb4kQPf2BuD1dTcgm6WdvMGLeMSZVA7pnRGy33eTKLPEl8mS3qCKAZ4tkHog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XjrS28v6EygwiYsZGg7qLetg09oY9WcfacBPxV2sHqM=;
 b=KE4TA1YjcP7FFDTCfh5rB3RXS4ae5/unXiwofXM+44oITEPWEdIlfmO0SiofjkU7u16SkXVpbURgtZXcMyjP9b2tBqYT+pb0yU9mOl2GoHCL21ZM0Qtoiz8F/9wJeVr13PstYtAcQNAZ+ixlnmF3469amFd5al2L17XHIvTPeopJuVc3eG9eYZ4S6zZQBHbVPy0Ga11I28zj6VgHyyuogLskggdomWdSXxjpIzVMhev5HebyMnDUxKUD0jZ4TNk2rmp/CXT16B6iudwee107c4RDLoC8MvP4EZi9bqCOCNUbqz3L2los9EwHrJJWwBQpiYu5uQYOWoGKTyDCj5jGHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6759.namprd11.prod.outlook.com (2603:10b6:806:25e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Fri, 17 Mar
 2023 06:43:32 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 06:43:32 +0000
Date:   Fri, 17 Mar 2023 14:18:54 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 06/27] drm/i915/gvt: Put the page reference obtained
 by KVM's gfn_to_pfn()
Message-ID: <ZBQGTjKqXJT4U7fj@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-7-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-7-seanjc@google.com>
X-ClientProxiedBy: SGAP274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::21)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6759:EE_
X-MS-Office365-Filtering-Correlation-Id: 96d66175-10e0-4c36-c156-08db26b2eccb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 64SWfN++zUMbiWPbx9G3lvXDqn2vpavNWGuBMJRYfx3khKpVmOaexYFbpmmXZMXaciGT7H+8s2C+jEQRPlZdGzDO5Jl7/nDZ94z0HWWg94l8SxVQq0q4hWp8B5TfeBBIBjfJ9RsEYcai7qgRaA1pEeyd4RxCunP1xP/5ZASqiJINUJuKUVO/wGvHFHehJmoMzj4QJZuDLh9e61u7lYyNNt7s3L4K1Xq60xae80wH+QeaOihrdxPVfuXQobwgTreSWgEUUJk5ru7D/hcruFXDOe/JtjWC+ge0YV2//gWL7+SVqp4SIcXpcKvTYEDCNX3j5FDo2q7kRS2pNV4G1sTHWJZPxgo7aLninY+WN3iX+ZLamxYm3GsoZFQ3WGVr6lPawyjc3SH7D9c79FHsgGFblazITrbtDtOw5l18VIevEz6gLmzgRO9+x1e+shiRb2B3wKeHJYp6sCj/UBqJQ0GR0dnzFxnIIbXpFz2DboAjR7t/Get30lkmXxMTe5/IUkzbk4B+Tgszx95p0XOzad8D8ZfpXBmdFADFaR9WuPUwnZALC/RydrjNdQ312JltcDgdqCHQre/Ks0UjDOoswz/j3z/hM7ibr53jQ5LLp5Z+pOgPfG5Sp0Pf+uesxlenk3cJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(346002)(366004)(396003)(136003)(451199018)(316002)(54906003)(5660300002)(2906002)(478600001)(6486002)(8676002)(8936002)(66476007)(66946007)(66556008)(4326008)(41300700001)(6916009)(3450700001)(6512007)(86362001)(82960400001)(6506007)(26005)(83380400001)(186003)(38100700002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VQi7NJPh4W5aPNIk7sznauwvp/zeyv1Q+G09d6gvjFKk3yqnfceEYNwrjdL5?=
 =?us-ascii?Q?iNnxChj1Mm9fhkSLmslk/njTaVwzbVPS8KLYZ53weYoHi6v1kbNkP3n/eFya?=
 =?us-ascii?Q?Vme2ntRpYhmVNMA0cYvqfvF83peckPaNPBD46wc2oG1pnuIHYkcL+Qy1y//r?=
 =?us-ascii?Q?a1SBgmroJ3rwgviPLlgdKvujvexbA9PglPDREdRleQvjEU7vgvyUS7G3ZPRg?=
 =?us-ascii?Q?EWWapms+Az1HUUmsAXc2nOUjI/1tPqmS4Jo5fMChkX11ttIkKuYcOhH7kp//?=
 =?us-ascii?Q?ZN/lPUeW9ZWxJRIg2R6zaw8FUEFCgRUArWGt3xJc3lM3uvOF5Ri4gTGomv+3?=
 =?us-ascii?Q?qCAPPzMwNd+ETNYkfmyzldCKgrksK7mAAEJaQ69uO+Rwx/y6DNNPSw47bZNt?=
 =?us-ascii?Q?8iex2PUlL3dKh3P8P4mbZEcgq+NdFfdrLuOGkUSDjKK/pZJnB0ARlsQUiLcu?=
 =?us-ascii?Q?KSGv6E7/srkKBjRrY+BiFV6NnbEW3T/inFocybnfyoXUx2QkdzK8vPldMs2c?=
 =?us-ascii?Q?u3e1DcVy2UmWbZ7znOEuLT6z4p6LOrah9rdnA+ptmNrI5+LyK4Qyk9ucXTUQ?=
 =?us-ascii?Q?STAdkBFqSJ1ZvHO7csUmAAztlCJKve6dMnggje4wsEfosyy2VC06NNNFEP16?=
 =?us-ascii?Q?C2Jo9zy5P6+78+1Ab1k+sebEJduuDYQ1UxEHpyX3yvDBnwCbS30Cm3xtE2TZ?=
 =?us-ascii?Q?WCwOrZ0jW/lTwvrXWyr2xuhNthIL2dxe51mImj/a23kfKUzTy//mc4Zwoa9q?=
 =?us-ascii?Q?6kDXFrMlNQpg7JJ9iiN55Q3kF8yg5UWu1xXxcXe9j0J6S0VmHEZiXICNayVf?=
 =?us-ascii?Q?03YWM6ytweYj/B1jkigz6sxU+XflkUTkIszenecfLuwvh+ieIrkRKK2+++aQ?=
 =?us-ascii?Q?C+6pmJWTijtSa2TctktUsFdyAc0oX4C0nHjl46PH3ihfc0DRZwe5c0XA1mBV?=
 =?us-ascii?Q?9FVGEKQ+pBrJZgAtFJDZ8hqhhoz1wqHJINakfy0d3OzgBP/mSqMFRTSE29Ou?=
 =?us-ascii?Q?OfXUdZKn1ti8RLpZ/ysHVI9eCRdgEz9MDYpma6o9x+vD1wZFybpQ5TPttlld?=
 =?us-ascii?Q?tTZhnKJHPjdRkBIbGCNjilBwNmJRKCRT4cudpNpRc81tAIRU2jZCOXkoMMSB?=
 =?us-ascii?Q?F3jCg4rxUhezOoLP++7aFFIVfAnm+gMiuIN9kOdHixpZ1VLRxTPP8RayM5z8?=
 =?us-ascii?Q?VmUT4lW1fN3a4q/5l912atuLGMW2sBuVxoF9uuh8UvBMjn1R7IMALE91y5T8?=
 =?us-ascii?Q?eRc0cukxVoGDadK8+u/SqnJHzK+93OhtRVTQKhAvvOAOWccQhFMtwd4mAEXe?=
 =?us-ascii?Q?h0FlwTsxjt/PnBpZTOAO5nBYrIOAwrNORGj1Wdd9SojZVz+LrRG+CZO2c8/N?=
 =?us-ascii?Q?kL/WuFPtaOWSUtQ068/riNHeqZSXJmmQgB1vnsMwkuPDc8yCDziRhp4toPCu?=
 =?us-ascii?Q?+5A5O0vBMtTxvc141F5ZQbThhI1IL5DUR828wm0Q6oXVPdhq1CdYGThXD/Px?=
 =?us-ascii?Q?5/8R5hxZZGSWnY6LMhSvQCKEpvXYykvQql97PWnPFfL/DoAwoG/g/Tj/ht8w?=
 =?us-ascii?Q?Df2I9ya+ooISNpvqb/TDv/duKbp+4apj6OcpACfRUVGV5UCijO1S0s0eV5Z/?=
 =?us-ascii?Q?XA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d66175-10e0-4c36-c156-08db26b2eccb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 06:43:32.3898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sG/PAvOyMJnDLSBNIeuE7ub1CvAKvZvTs8jFLZDG8CsTsuQI4Er9flRMABVf/ThqLaJTHJl4S9mJgvujOG9Zbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6759
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

On Fri, Mar 10, 2023 at 04:22:37PM -0800, Sean Christopherson wrote:
> Put the struct page reference acquired by gfn_to_pfn(), KVM's API is that
> the caller is ultimately responsible for dropping any reference.
> 
> Note, kvm_release_pfn_clean() ensures the pfn is actually a refcounted
> struct page before trying to put any references.
> 
> Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/gpu/drm/i915/gvt/gtt.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
> index d59c7ab9d224..15848b041a0d 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.c
> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> @@ -1160,6 +1160,7 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
>  	unsigned long gfn = ops->get_pfn(entry);
>  	kvm_pfn_t pfn;
>  	int max_level;
> +	int ret;
>  
>  	if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M))
>  		return 0;
> @@ -1179,7 +1180,9 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
>  	if (!pfn_valid(pfn))
>  		return -EINVAL;
>  
> -	return PageTransHuge(pfn_to_page(pfn));
> +	ret = PageTransHuge(pfn_to_page(pfn));
> +	kvm_release_pfn_clean(pfn);
> +	return ret;
>  }
>  
>  static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
