Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18586BE0E0
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 06:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjCQF6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 01:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjCQF6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 01:58:20 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1736F5983B;
        Thu, 16 Mar 2023 22:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679032699; x=1710568699;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=2P3uKrTWTWswJJCWGnoxm8a2zudtiWfBNb/KGMvbxk0=;
  b=bFIdLovmBrMmFrRvRPoVzEbkELTfXKSu8TnTl8mwIasuJLGQ9aCqE79m
   mAgLnya9iDVfs4zCh2xtRnafo1FH6IJT/DQ3ve3l2eltOwId9+S7l5+EB
   14q8LUSMT6lZKg7MxnYtoKFjmQhpdbCTcNv8aiXC5MwEuI6gaTfc89Uca
   152fcAYKCnkPdaMUJdlj2HvcB6S9uvtCVnUDCSTNsHCa9j70fiQ91IaJD
   PVgWexc3QadGwdbhUpShaz9rUc2k7ywNzqs91XlV1yK+y9gJg3HCseDeC
   pk9aMju+CuC6EWZfTxJPIaeQkN9z3r4hu1u4vZM4exRO/iHa/klKW3IPm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="335680150"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="335680150"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 22:58:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="712630077"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="712630077"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 16 Mar 2023 22:58:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 22:58:04 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 22:58:04 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 22:58:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0XfwkQIKPaMWuLOBVc53aZ9gS5w1wCe5Cm7oF9OOAchcF/twoEEXpeyV6vgt+ce+7ukjLcRRZR/UG79dVO+8DdA8BoTUhHkCdnxhWEf72HSsd8J723t9VZvhgrWrokgd2pRf4+yWvsMn0hrVxhBjpTH2IBNjslkXLkGfgBOGtcqCPcBwO0tpWZE17Wi8/ypQ6ZObHelXDn6nBCS4SJ+vY3WCTv3r20mAsinSGJwUUOQE5A1OECnNjRj4AZ/dUhi35k/zKkKvh0C5e4sB2DH5RYt6dFvd0KyQnkQmjqpjCoImYBUE8QthBydXXC1k1r8d9PmQZXqteDLCx3d2gd/hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zPbVr1Rf37OsrEhPbPQdgAwS2namMdUJkFUIx2fao/s=;
 b=EBT5DIw7ia1XpU8Hy/8U0lGtZhuqFxtqyb3S2wJ4oTyChjg8Izwq7hhEnxizTgksUZO8uJ/RjRKz955pcxp2qYpp6XgXB3PNvoQUNruaYj3Rhm+wEMJIl6vDLE6+6RZrGgRNzsezmXypTpI6ouZY4cFqLjqdoxc2YxUvwr2ea3CrCuBSvnH6wEA5+h6sb5+VlkGh8Ml4bdBAymrfCSZaYTob/sVLwF2hw5u1qN8qykdvOfRTFDdW5ct/Apv4OTIyCq4TMMoPiKH7Lkoqsy1H0zP6l3mL5UA27STutoNwHEYVBjxibawwHgW875vQHhFLUC9HMYV/fndzrGc0qlltSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7499.namprd11.prod.outlook.com (2603:10b6:510:278::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 05:58:01 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 05:58:01 +0000
Date:   Fri, 17 Mar 2023 13:33:21 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 05/27] drm/i915/gvt: Verify VFIO-pinned page is THP
 when shadowing 2M gtt entry
Message-ID: <ZBP7oZ1lkJhlSNpY@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-6-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-6-seanjc@google.com>
X-ClientProxiedBy: SG2PR01CA0128.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::32) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7499:EE_
X-MS-Office365-Filtering-Correlation-Id: c910c856-a15e-42c7-7b17-08db26ac90c1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a6k3SiagTTx1uMatjTr5wr+X/Kobv5I3QyhR8cEz/QelE/d7yemj25H0D6etyMGakpjb4a3w7Z54xbnPaC306UmR9grAdW+AsqJV5GmoVGrOW2yAI7Zc6y6VZ3BwfDLzKjfa3y2Hgbl4QwcHvfv3XOvE4yJxxWyuyVCJPaa8N6lnmre9ZoPuNRAt2nOQ0IfsIWUtefpVhO1JwXF74AzmPWEA4QbntuZviyJTejQJS2dOa7jBbjKrCutzjLhDvRl9bfr66C2qLnTgbbNhojy9ucek7MMlTPoznzMprqInCtLigIUHHHmuPWmSxCWW75wgtXjjUA8J2xG+DuHHAxGGK0n2FZr+bGw+xT/lF8lqy7pRmmPPpxwydtDlW/0r1uK4Xug/0TDIAzH8TtCvDXsX9nTTWSvXTC8Hg4jpQapPYD9HT3mGQeLmNYDRyCBuNT89PbMq+bzuwQdHtD/afZ65q17hYVIYd/bZ+cg7d8Qsb7w8jUTifhC82wxbU7/8ctrkoJwGG1c2hsAXJu457pSxIEdzjndlhOQw5r5PuYBaly8eHS6AEUZdsr5FBjXmIDweMmNpz6r7n4aUSgz+zZS+ig7CUCAJRmluX8+Zi4XrsI3Zb8sM+oYjNEKAR02ZVtviKpyFv4fIM+ryfeDFCfNS2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(39860400002)(346002)(376002)(396003)(451199018)(6486002)(6666004)(478600001)(15650500001)(41300700001)(3450700001)(2906002)(5660300002)(8936002)(4326008)(316002)(54906003)(66946007)(66556008)(66476007)(8676002)(6916009)(82960400001)(86362001)(38100700002)(6512007)(6506007)(26005)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?srCy7V9vLr126DuEA8ShqTcIVsXWBGX21oWAOa6KWOJAko3Lvganwl3qPf8k?=
 =?us-ascii?Q?mS49+yCj7YvBliUmrX7NEGzJ3q/BaTHjAhqY4DVg81x9zqV25f0gwCZRNWf5?=
 =?us-ascii?Q?P03BVlvVN62Zh8pcvmsS9HN+Iq3fSYCV+gpadStE4OVwITSG2K/hFsG4GVEQ?=
 =?us-ascii?Q?5lYIovMerjEVb2C4/mi+ReIBhcFXHXEc3DbzlcXmhC6xnA1md3zdiX0gQCok?=
 =?us-ascii?Q?dZT/Tsmm8OAPXQpQ5/OsopnjmV6xf7DMUzuSe4f06VXr2jCQw9Umcwp558k7?=
 =?us-ascii?Q?X6e+BBBLLoq+xbpUdYwo4i3SI6A030pO/jkLZE2pPlGeESbSUBuD3ByKu72i?=
 =?us-ascii?Q?NWM5Z4jTFHZPs1E7bHAhbCsh/rC4LIYtXXoz0LTktt1iqYfvlliXLXaRk4c1?=
 =?us-ascii?Q?wG4rnFm1EM8WxhlRhoHCdsI+mhxMIbFeQKKwPJ/9cT0RJ5Ye8LqvvOa36SHp?=
 =?us-ascii?Q?IY8YvCe8JnNi5/eaTsFDA3HOafF8tgfsR4gis8gWab/glT0C6nzyaQTDC7PI?=
 =?us-ascii?Q?UiWrZHxXGy8aqIwslI6OxD5CroyyVJRWs57mmzLvURaG4+XEGdJU8cGARCkV?=
 =?us-ascii?Q?ymUf5DXDkyhmhbScx30qepn7kQqN4m/ldhKDH4vw/STTxFCCfyWBPsUq7c44?=
 =?us-ascii?Q?sCgOZQ40Z+VCqtngpiDDZFdljnqvNcYHpYxD/50ZYOtkzRHMwpNdRCB/6tK0?=
 =?us-ascii?Q?Q2U9vPMdqcGp6gKtsoJI7DiP1WxEhejz0bR2mtiyJzc9q5xq3VSSJHJ/DIMy?=
 =?us-ascii?Q?N3XHc1r2xZ+bx36fzzJUQYQ0964rU0lkKOoyZuBeK4M2iUBmJ52fTz2TJtwg?=
 =?us-ascii?Q?QrGKcHu3EUvDZyrad/l/AO5omMXVlnLyvlWxpUdSVjaxONBRDZujNE4AztKN?=
 =?us-ascii?Q?hRFg0reT/wMPntkmvtKk3KuDj0NzWahT/fOQA6blxRbCF6Y6rU6YynjsViYN?=
 =?us-ascii?Q?E6mD61y2rgMtHFa5iYjPWTGxzCT+V4g48Eyl3dKobBvGSFEWLjctnz6vm5LY?=
 =?us-ascii?Q?QUMCrkI5hwa1BCuRAhVsGkElIdZBQwtl4+jfO4v0iCLbvNV7b3/UqhIxtcRq?=
 =?us-ascii?Q?WV224tPwl1CuqSPWQzQH63WcMiaHpK5CekFJezeitP5aWGA0YCyvQKonaiWb?=
 =?us-ascii?Q?PypBmD0RKD9R6dJV21yMu5OPoTcwqnkf8fTijfNBx0yTXe9ZhnELDMQRWmUN?=
 =?us-ascii?Q?AXvvhW3pAG8qICUHoiDeWOkbDYQIAi05yZ51NMJQkpUHZZmIEVvVIRdDWp50?=
 =?us-ascii?Q?ZT6YXHn1AMrxxI9IIkxM5ZXY6O3BO7ulPFNO0AWHc8tunvK2eFixw6Br3vSV?=
 =?us-ascii?Q?sbBG52jX9hT4LqKfi72oMKN9NiS9h+066Zu/kgfLcdZhInIo8eApgdDhuA9x?=
 =?us-ascii?Q?VGn5HR9hbHGKNM3JCkTBJMVRLu40NOW3+++Nt3neguYmOQw6NHPvVOiFc+U3?=
 =?us-ascii?Q?x7wDr9/OnXKPjFd/5sO0l0VMqeAqmu1PajyzCRMx52vIwbYXUoqjS8Xe5R5S?=
 =?us-ascii?Q?SLf96bX/wZqio7koOYHpDtf0y4IUvCXyfiM99npC1UjFlF9h8yNtYiMktb8D?=
 =?us-ascii?Q?tF7RDSksALQGg0E9Zq27RP2nBq1t0oZ4TdBVJfxcH0AvxL1/8egZ9wdnLeJ8?=
 =?us-ascii?Q?0A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c910c856-a15e-42c7-7b17-08db26ac90c1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 05:58:01.0542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oDOfq7hbY4c3M0Z+3f7HE1dYD2W2zxThWOIek3+vhfeczvWwVUdgF2MGYmDe4mbWyrdF/UfoamAM8dcGIC4KWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7499
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

On Fri, Mar 10, 2023 at 04:22:36PM -0800, Sean Christopherson wrote:
> When shadowing a GTT entry with a 2M page, explicitly verify that the
> first page pinned by VFIO is a transparent hugepage instead of assuming
> that page observed by is_2MB_gtt_possible() is the same page pinned by
> vfio_pin_pages().  E.g. if userspace is doing something funky with the
> guest's memslots, or if the page is demoted between is_2MB_gtt_possible()
> and vfio_pin_pages().
> 
> This is more of a performance optimization than a bug fix as the check
> for contiguous struct pages should guard against incorrect mapping (even
> though assuming struct pages are virtually contiguous is wrong).
> 
> The real motivation for explicitly checking for a transparent hugepage
> after pinning is that it will reduce the risk of introducing a bug in a
> future fix for a page refcount leak (KVMGT doesn't put the reference
> acquired by gfn_to_pfn()), and eventually will allow KVMGT to stop using
> KVM's gfn_to_pfn() altogether.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 8ae7039b3683..90997cc385b4 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -159,11 +159,25 @@ static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
>  			goto err;
>  		}
>  
> -		if (npage == 0)
> -			base_page = cur_page;
> +		if (npage == 0) {
> +			/*
> +			 * Bail immediately to avoid unnecessary pinning when
> +			 * trying to shadow a 2M page and the host page isn't
> +			 * a transparent hugepage.
> +			 *
> +			 * TODO: support other type hugepages, e.g. HugeTLB.
> +			 */
> +			if (size == I915_GTT_PAGE_SIZE_2M &&
> +			    !PageTransHuge(cur_page))
Maybe the checking of PageTransHuge(cur_page) and bailing out is not necessary.
If a page is not transparent huge, but there are 512 contigous 4K
pages, I think it's still good to map them in IOMMU in 2M.
See vfio_pin_map_dma() who does similar things.

> +				ret = -EIO;
> +			else
> +				base_page = cur_page;
> +		}
>  		else if (base_page + npage != cur_page) {
>  			gvt_vgpu_err("The pages are not continuous\n");
>  			ret = -EINVAL;
> +		}
> +		if (ret < 0) {
>  			npage++;
>  			goto err;
>  		}
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
