Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E956BE041
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 05:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjCQEox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 00:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCQEov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 00:44:51 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5438A42BF2;
        Thu, 16 Mar 2023 21:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679028290; x=1710564290;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=5mn8lbC7Q+P15hmZ4YHeHqhtKn3gzPQk3Cz+G1Y443Y=;
  b=FCEqsxeLfNrgVQ4KV30z1L/lUGiSDg1JlYBLHdnyWfpkKAdnJcy4rYRL
   6JjM+sBH1G4YC7e1TOMumPgcZWm3c/Ar39fOdaGetsbYigiyhvMU0fSaN
   4VzCVCOG1LpNH9ZwmReE8V/HNqiv7+s4Zn87aRrJPurMSTuShdCRE6br7
   TcuW2U/l839np7Wwysh2YHa5Eq7YmkKgAGsHMLx2ETb/DEiJBaktrTpro
   l2PZHo3kO0JLaJ04ViCocdLiN9yL9mtVt4CaVG5dhrpJAgn2N9VVkCOmE
   gTdy5KRBPSClvacPchS49UVBDl3AXI9rsrgZsiIfz56MphIWQMhpliWTv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="318574511"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="318574511"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 21:44:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="749124596"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="749124596"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 16 Mar 2023 21:44:49 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 21:44:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 21:44:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 21:44:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRta1a13iTFoKbIfQyS2hVKPn3T2L7bLKOtsRmp18ef0FROGVOSNkPXcqjhxlwWxPXZTDXU/AHZT1qt2U9TeFQPecbfIlWPTZsEyiNvjyjpx0mcQ2dBKhfN1gCDjf+AM4UwlBVrG8H0F+wmJ0TUo1XGkwvo3mSOL8669matHMGIr1KUPccya9RQEpjjqcnVj8gwyZSDuHlujkcojB6JpsubfG6DT3raieZw3SQAWRELLgJUpnCy0NaMQIWtnmQcIaq7fyDWxbqExHmJ3DFnZR1yIVK+qIyJgOFFlN3Y77P0MIMTwpzuGLQ+vfMoFr9TxG0/sGGwRYEobDxg2A+CQ3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Svx4MikXRjfT6oh/loZLJeZpRlxpTGZqou3jIiw3JBs=;
 b=YX8KSwwCXEyrOVnNjuBDzdZUUTgkziSWCJLdsLKk4bkeIyhRoD/5LvB25+pTDsFAHwJcLwekBRfHuCQfm39yDboHJIQ3MRGBgRbt4qt3T32M7HyS5oURtmhvm1iCm2dBqjYb6+wgUaFDasMGUwMCrZWzLwKHDkvx4SHs9YRu/6AZd6EksPPOVCjYiPMa++8uwuu2p2RVE2hgI5ZJxNO+WaHhSB9gek55swMot4OZYY1Dq2/mIaO7JUcW9akE5OjDCcHc0vMlHdWo+Hd9cpaM6dSP/hXIvnVezsrNwans43R7U36Kavr5WqL27vBYsbr7Hdj2YJkbWellSwwmsQxIJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BN9PR11MB5387.namprd11.prod.outlook.com (2603:10b6:408:11c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 04:44:46 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 04:44:46 +0000
Date:   Fri, 17 Mar 2023 12:20:09 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 01/27] drm/i915/gvt: Verify pfn is "valid" before
 dereferencing "struct page"
Message-ID: <ZBPqeVIqfKF5ctrO@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-2-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0037.apcprd02.prod.outlook.com
 (2603:1096:3:18::25) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BN9PR11MB5387:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a2be59b-e35a-47ea-bf71-08db26a2555b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /WUFojJSa+7wEOFhZrjPU+8wcYSjgVdvgqR45Yi7eg9Rv9mxwddj5hxff8FgmSOVmsgd496RfXWxhaM5Bp+5D1yBVZ9kg+zVVvWR3exwrVaCzAqm2Q6+bcj0T3CFol/MHlBdudI58KfJ4SwcuADo8bnwXF2jtfYpgMohGORCxN+WOfGRgiWAdZRPcSUHw9eLCEsfS+CWlgOuiQFawpcfjtkTuJ7ngPXprxOB41/2z9tVEr3hmIz1EQFJpf2a93hqNGv4Lf7DX5GPH5nUFh1ZEreAomsntvhq7kff24CSlQQRa6C6QtGWOrCDVoVaMFbVU08vmkk5W6/0opWFtQuo2bWJz9XUfLQVmXtFzXwdR7Fv7YiwBgkLSyGgeGXfRjWLAG9L0G/2MaXpqFVYPK/Zb556NjIobl2XIdx/69Imla4B832BStSdjGzIkHPHjPUYFY6HVhowdRX4zU/1wCBRacQZHvlYRHpyrXoCWEiBKpcuaI9BClOsMxAY+tMdP6a3TheeWkkUWdP/lfS71iGF0INI0p9s/DtL4jCiwQSnH0gzUlyEuPO7f2V2GtAhBNkUMVRojH7K3TvDM2rMNw9zn4/sD9H/lbUTZGLC/yME7bFRSqfbYFkr7N0DklrlRrXTE4DWX6UeLy0tRsfoto22vA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199018)(8936002)(5660300002)(41300700001)(86362001)(38100700002)(82960400001)(3450700001)(2906002)(26005)(6506007)(6512007)(478600001)(6486002)(4326008)(6666004)(6916009)(8676002)(66476007)(66556008)(66946007)(54906003)(186003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lWvOSsvYaC2Ie1v28pcXNp8Ek8uVRQ0a+TYmG+sY8mNTt46JtQwlpS6R1Ly5?=
 =?us-ascii?Q?9NrA6iia3CKeG6Nt2Cc3miFOPGCdEwEMzHM4A55JPeP74usJIV+mUc16Gt7P?=
 =?us-ascii?Q?nhrxoctVRo1flPDmWVpNmcR0OWVriNlCRpod8p7eTlmeyL79twhJ0XcI1GT5?=
 =?us-ascii?Q?/eSp9OGNY8qoZk0A9waJv4g63j5/aWkGRP+oArESKRxOnyx6YlhMiysSXBkD?=
 =?us-ascii?Q?S1fGKbn1X0rewaKpUa+nOO8oufgd4Uen2aow/pg4LHxzSt//1bc96CQGPs87?=
 =?us-ascii?Q?s5OmVSM2MiAGogMzKfSi9rgH9r2R9lFH6ngzOPKQ3E9Wp7L12PCF5BVlvAPi?=
 =?us-ascii?Q?QEn/1QsPlNgpwGCapemNvAb+yIKl7jw7SxCWboVFDn6fpjn8ydxMiMNxeFH4?=
 =?us-ascii?Q?KL7e887kXSRoDF4MEvTGHK5AOqLS4TVC6nOxeh8aOV/9xv4qiZ6I+bRjtFWv?=
 =?us-ascii?Q?cLaXoADY1cr1Ab9E9du8kM+7+kuJ02pEJIoYMU760GrVCvRqZoKLUUBBGjq3?=
 =?us-ascii?Q?P/hX2wqZXWVUmL9f1GwHk5oZNuQZr2dwrsHvddeovoJe+ntgrcG1wRZ7OqHH?=
 =?us-ascii?Q?5TvPok0nL1TDq6deVlhbLTSYSAupo60cpfAszHTk+Yq4lbnGBoYyPYo2cPR4?=
 =?us-ascii?Q?Qskjid/7N8cYxst22kYeWbajuTDr+FSMbhnZ3BaJ4nokKG5anKA9YP9sX7tw?=
 =?us-ascii?Q?Q8aMxr9f0cBkUl3VxCqwwG0T6IDHlg/zxf37cpOAohDViBFkgi/pn2WEA2X6?=
 =?us-ascii?Q?RbCXpOIDDWvJkQNcQmzpzWXEwzXgkBs10YK/aXpp7NsrOl5ORkwtPij7KJX5?=
 =?us-ascii?Q?l9lH8lWEYzhVmsGnyWqNCtEHtyicJa5M5at6ID+As7wZNdAkehhsSh/uRBqI?=
 =?us-ascii?Q?Ohng+KwdpkSDWPTPwI1gBv+csiutn0ywcrjqTV8qbyeZdY1O4SApfuDlX9Cz?=
 =?us-ascii?Q?bJw/sobmzugzAGVUcnd+mI188et7c8/acIwN1DpzIYVRzNb+CjCVeBSGne+O?=
 =?us-ascii?Q?1/XU/BXc0Yjd+xftJwbfK4ASVv6grt2OlcxeAYEMpre+3mnHiF004xd/pU4R?=
 =?us-ascii?Q?7/tXfs1LvOI0j72Tl2r/taA5BgGbu8CRAWolz/WxnlRD456J55iYQ+PM/lQA?=
 =?us-ascii?Q?yqIUj19PUVodpnNIdtXepWYBGGUtNqNROSHtU084X970Q+6sw64mJqoGLQXU?=
 =?us-ascii?Q?tjlAr310eOS/RPrxorHuJZeMDWZ2mxnV2EC6EuBcm204bi6q3HeoeO+tzCaw?=
 =?us-ascii?Q?O+8KI3Rj/b4JJt1cYrOSs0SplzT//GAUnwLTvJDr1mTcQHqxxcGnD8x9fxrZ?=
 =?us-ascii?Q?db937riH0L8JMgyJ168IukEuWH9MgSs3XFWmxWNwkobSJ1ZL650Z6nsr+y7n?=
 =?us-ascii?Q?JA4jvLBsZNQcHpDPmrS+RQhXTzDcMeKSZsPX+o7yy+tEmOBzoRBcWeYPq+Xg?=
 =?us-ascii?Q?t/SS4aVVR2mbiXhiRo04QZKaRCR+FntyGBablXyn3oPx/ppATDjSet7+g+G9?=
 =?us-ascii?Q?6bsaPE3uEgD9PYW4QiwxMbnMXjA/CmMlfYzr7HdgiUFl+Lr2omQa/ZylWMU+?=
 =?us-ascii?Q?OFVX8t2/NBOXllUcfhrnpGRd1HTGpztbXWJv3mrgM2TiMfWv9HJKftgTFBno?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a2be59b-e35a-47ea-bf71-08db26a2555b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 04:44:46.3878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0sCV1HXg0qUWHoIP09DJpHwgIymRgJqLvM/YPkIqq70rLc33aI3LcqUMT/MGEuNAz6SGhqPLfd8IZhJ+uOTOhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5387
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

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Fri, Mar 10, 2023 at 04:22:32PM -0800, Sean Christopherson wrote:
> Check that the pfn found by gfn_to_pfn() is actually backed by "struct
> page" memory prior to retrieving and dereferencing the page.  KVM
> supports backing guest memory with VM_PFNMAP, VM_IO, etc., and so
> there is no guarantee the pfn returned by gfn_to_pfn() has an associated
> "struct page".
> 
> Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/gpu/drm/i915/gvt/gtt.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
> index 4ec85308379a..58b9b316ae46 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.c
> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> @@ -1183,6 +1183,10 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
>  	pfn = gfn_to_pfn(vgpu->vfio_device.kvm, ops->get_pfn(entry));
>  	if (is_error_noslot_pfn(pfn))
>  		return -EINVAL;
> +
> +	if (!pfn_valid(pfn))
> +		return -EINVAL;
> +
>  	return PageTransHuge(pfn_to_page(pfn));
>  }
>  
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
