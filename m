Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F28058D27A
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 05:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbiHIDs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 23:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbiHIDsE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 23:48:04 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E271FD7;
        Mon,  8 Aug 2022 20:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660016815; x=1691552815;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=XhgU589VGrs6MDuNdb+WxgCDizeiUb6J6oz60c7Z+fU=;
  b=VY2UR0Y6veen5yq6Rq4OS15NAo550xAsK43D7XiB3rOC365/PDcvnTTX
   iPS+zmu4M+k8hBssap6XFqGgspVqdIpg7Eqm3WYqQkyhS4erourwP+27B
   X5YD0EcDbKmwtUo61MIQxHAGBJE+ZbCB5Ck+k1ZYtTpahML1kc2A8/9Zd
   V+GdfWWZlWhjZrbRypz7NbTZOp4jOB8O1LE9wUf+oG5Rh5bLtiHqVlP0w
   ynGqfUgtuPhT9Ooo4tqq3QHTgXG2BaiRFJgWrOs2bwBGXLhNvHhJM6iUH
   sLslzPGViBCz7VdcQJkOsHWql5zTN5kYGkSlYIsya9Fq4fMzH8BFKYW+j
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10433"; a="277681917"
X-IronPort-AV: E=Sophos;i="5.93,223,1654585200"; 
   d="scan'208";a="277681917"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 20:46:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,223,1654585200"; 
   d="scan'208";a="580633749"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 08 Aug 2022 20:46:54 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 20:46:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 8 Aug 2022 20:46:54 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 8 Aug 2022 20:46:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gkqCxNM7K8zALBCU0Rfgmkoj1Suh9jp91v+2hHQ776WsGU76yQ+qpQlOL3X3oY5av127E+XM/axn9MGqamITxyW0+ubPRv2tM9EUG2DOuvjwJ58FZxBEKqCsQVBoqg4i7BG3S73NzZZjru9rcSrPm/LOKLZe8cARGCu9aI/WD97QlanmDbHEnpMc1PIW1GwNTehMkSoO6Z8me+5JWAT1gr+eJf4ZLD57Lg1NelQ1WxmG0rJEQydsfPbYEQvseJvWtqm0A9zjUxwaBSn/SxY4c2zM3mm7YreTul3a6p9NpraGJhk+9usFeVjo4r/gC8wZQeYzXBHkbUop3GQDF5cNRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1z9Q5cMuP5t2fDZlV1oIn/DvwHrkOZx61m89WUtA614=;
 b=UFEr7WAvuseRhBwyPogOzls8tVDKEeV4Xgjy96tAFSuy6MFazLchYUtL0hAhkfrKqxhcbitoRKLlsoLmO6XCt2emge8iS3k+5YIOKFvshMGyHrv7P9AM8OFZ4tyGJpJLzKbas92r8xuudH8+O0rk5clHuGpKwxCSBhm4rC9iIv7JYWgNLDVPkN9FZNtWdmfs7calhCdVXeK+9DL2rIdzTn0k9uu6oPvw+V3XCP4jZaOWBWk1p/YlwY3m4p7BfCk/dU4KwH0sK38k5mKjSWMCfHkCtZA4xwypDT5cjyT0Y8W3Vh3ln40qqeqOLKkwDBccwf27vNjscQfRtxcw5rmuHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by MN2PR11MB4128.namprd11.prod.outlook.com (2603:10b6:208:139::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Tue, 9 Aug
 2022 03:46:47 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::bc51:e72e:5555:ccdc]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::bc51:e72e:5555:ccdc%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 03:46:47 +0000
Date:   Tue, 9 Aug 2022 11:26:09 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        "Mingwei Zhang" <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 5/8] KVM: x86/mmu: Set disallowed_nx_huge_page in TDP
 MMU before setting SPTE
Message-ID: <YvHT0dA0BGgCQ8L+@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20220805230513.148869-1-seanjc@google.com>
 <20220805230513.148869-6-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220805230513.148869-6-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0103.apcprd02.prod.outlook.com
 (2603:1096:4:92::19) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f28fc66f-654d-4178-07f4-08da79b9c8be
X-MS-TrafficTypeDiagnostic: MN2PR11MB4128:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wWN6babUi2ndm8u+tg7ChBATw+NCbYoXaxHGCM20uHNUIvwADziKW5XTIviQCToScpcXqiTILan+ZMTioHPm+dOqNLJaq885EXuMyOuIm37wvf5lP0iF/vz7fNdHFx9loGo6TYULJCZDJ/hMWr7SKUdzSY8AQCFlq9jLjL68ZLIXmkNLvu/mao+l4Wxb52pBQVd6xvmZQ3FdIuJQb0T0RvcU7sD/Lh7ocXJNir9xri7FaE5jDcrY+q/dXabyNlrswWFbRmwSZzyLEfROklOELJSuewwt1i4PtHOs52pm5578BKyAX2zJlwIlKEAmFvmhnENnH36QjjNzCUXNxxTd/DooODLFla24COPPnFeHI5VZV7b6P9CMJhBj42ZY3cQiLwiA5wCrc3dKAnNq/1GiTmRnjCmvzGzMZETHoZ22vLkGH0MtYgZfhS2l4ufxmej/5kEJeVMdLS+SgjUlYTG6LVpzOkOAxAXZQ1asX8kYmVuDeJC7y+rNiXTX9z1wVTr0Zo5Ykp1VH/wqZswmXVUXCl3MKMUtC+dNOWwnYyQ/teq+OFw1r1CTN2N+XrguCFFzYyGAgLlByUs5CeTuXVNxjJfHB2klPRAeO0cAeVcXOXgbx8TWKe1x76437hKe5EGj/ObEfaRsTAX6qDqpAw0b2+AnLir4g2x98JUJTps4k+6exx7DRtJ6QH7+9G07O5ypMMNNsZE5T5++XkwtSwuHhLuDKRe6TO7pxOMDR/YlDwFgzhfRjDdnEFc6/cKfl8WvlwTyyE4nbXRKyN53+8U475OU84697lm1RHkVqDcPM7Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(376002)(346002)(39860400002)(366004)(186003)(3450700001)(5660300002)(478600001)(6486002)(66556008)(6506007)(6512007)(26005)(66476007)(66946007)(6666004)(41300700001)(86362001)(38100700002)(2906002)(83380400001)(6916009)(4326008)(8676002)(8936002)(316002)(54906003)(82960400001)(14583001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6E7T+vcsyrp1EvyboplgrPR9RxYMIffK22zWzhzhue0Cqgyz7bW/PmWcl5nV?=
 =?us-ascii?Q?yic9F8AP9Uef+146JOnSw81/dXC5n5/jFrxq/q59LjGyekzBIcjaQiTv0KDH?=
 =?us-ascii?Q?QYPihaGjxMdl4ZK6iln71u52gLDmXzIu3ZqEPaE/NL6e7yqH1Ki9G4uQRsd0?=
 =?us-ascii?Q?WUqZcw/b52GOiYeWLfBg09I6EodlxKAIggSr0a4riYmOFjyK3dw5O8G4GaFw?=
 =?us-ascii?Q?RFtREBzmGyCir36zJPlWTkR+A9w/i5m/AMw6lhbovC8uLxj+6zm71n7+Vtv/?=
 =?us-ascii?Q?XOWkiu9DiWcj9sGpHdGZw9iQoqmrS2jwc3TR2h4Wof8MKmEAchSuRJa9/ImV?=
 =?us-ascii?Q?3H4wA3fRYwvjI4Pkmg7sGmhIlk37kYskQm7d/zQXLKpQ0/KUbE3brNn4GyuD?=
 =?us-ascii?Q?3OpqQzzfoRRTp/ROP3ORtcmuMprMrxwskW6apNSgTkgr9qi1kF3SiMDwhbQp?=
 =?us-ascii?Q?YY26YxT1HDgJ7uHQg0zpMR6Q2Z4JtcLhtpa6ludR6gtvml+xIBuYmbhyKUOF?=
 =?us-ascii?Q?VFufABRXvYSvbDM7HR03sBHOHvRSZM/V80iOVRKfN5raLPzjQh/L/eTzySK/?=
 =?us-ascii?Q?JwzirsyyAWMQqWMGbATROC9KPUuYrzKHpUNuffl1176fd2ZTrld5LuOkqx+I?=
 =?us-ascii?Q?5cmUCx6EeanXZNhjE+5esH7sGpUXBvQfU1CKx19AsMLYvRpBoikJ4uTnsaFb?=
 =?us-ascii?Q?ecTjbdq/53Dk5ZHX4Roq/mEDPgiKF2vkAZ4LJ0GyRGl6LX5yd05ibl0Gi2bQ?=
 =?us-ascii?Q?moi+Yojnn7L/+EcJdGPBD4AC5GaHhVBHuUIRMHwF40NqrCzDITjN9SqIuK/h?=
 =?us-ascii?Q?oUsYndRh7Wvb8ytOetwBXZv6NJYc6ptrQ5/4xoz06r9iI+gB5sTWKdsdP7sd?=
 =?us-ascii?Q?F9aWbdURPq2v73zmSm4uOKEsxlRdMtz+hbOfQTQ/Y3TyWNhkBZBsIgK+Vu20?=
 =?us-ascii?Q?EJhrLNFpLVPXRSXWL0ioX3QBWS4Agt3z8cbB+Xqk/Snv2eZpwi2580+HKoqp?=
 =?us-ascii?Q?MMD0auqa6dXJPUWP2utzdtYdpwAVkrNGjeHAz8muwl1za3WqsSXZop7OpiBM?=
 =?us-ascii?Q?xMIS7EbEd7oIV2tNKmEXLS2syYEj2e8+wGtgzO4ruy94xust8OLRFneLavl1?=
 =?us-ascii?Q?c44V45NDGkr510Z3x65EDhTcTIG6iBXljmqh57A+afZHdXiKv7SlY+UbPI7Y?=
 =?us-ascii?Q?6Ec+jHwsVQJ6k69k8pSPa/ZbK+6mEtY/qKCirmmuRXmNbcodXrSrU+9uNIy7?=
 =?us-ascii?Q?afnZ1ut7u2eABJNgNxOFzaRXxW14Uci2WgTSLb5zdEEQPG/+L8kRPSyJ0awv?=
 =?us-ascii?Q?0CQxOIoD+xTrPL5FPTDaFsQg4fyD450Mix4Svi84gVt64lkAzDmiWMhG0pVr?=
 =?us-ascii?Q?McexYU00ncShceBExJqoqh+uN7KJMmLLLtwAMUKwDBiZEu9ljJBwrfLCsFy3?=
 =?us-ascii?Q?AD7j/rSDyFF0HeiY5LjifFNb3ecrR1/s9z7YTLJY5SAqexGRFRY++p3ulkTC?=
 =?us-ascii?Q?LXoNb5uknwpFYCKWg6Z5CCOBkfG9d0qK5Vw4BzvCqr5X0csIJC+IwfnIJde0?=
 =?us-ascii?Q?nJm9D+F/DvCRxpl81O739L+tv7vFbLdhAjSYMAiN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f28fc66f-654d-4178-07f4-08da79b9c8be
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 03:46:47.1716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eRaf6RYnA0freNjWd7TFJDq3QzQaQn0X0LjStHiJBEzSEsHFEMQxgz77kZTkjwwPWpPWZ6/Gkr/a56dLB/qxNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4128
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 05, 2022 at 11:05:10PM +0000, Sean Christopherson wrote:
> Set nx_huge_page_disallowed in TDP MMU shadow pages before making the SP
> visible to other readers, i.e. before setting its SPTE.  This will allow
> KVM to query the flag when determining if a shadow page can be replaced
> by a NX huge page without violating the rules of the mitigation.
> 
> Note, the shadow/legacy MMU holds mmu_lock for write, so it's impossible
> for another CPU to see a shadow page without an up-to-date
> nx_huge_page_disallowed, i.e. only the TDP MMU needs the complicated
> dance.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 28 +++++++++++++-------
>  arch/x86/kvm/mmu/mmu_internal.h |  5 ++--
>  arch/x86/kvm/mmu/tdp_mmu.c      | 46 +++++++++++++++++++++++----------
>  3 files changed, 53 insertions(+), 26 deletions(-)
>
<snip>

> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 0e94182c87be..34994ca3d45b 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -392,8 +392,19 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
>  		lockdep_assert_held_write(&kvm->mmu_lock);
>  
>  	list_del(&sp->link);
> -	if (sp->nx_huge_page_disallowed)
> -		unaccount_nx_huge_page(kvm, sp);
> +
> +	/*
> +	 * Ensure nx_huge_page_disallowed is read after observing the present
> +	 * shadow page.  A different vCPU may have _just_ finished installing
> +	 * the shadow page if mmu_lock is held for read.  Pairs with the
> +	 * smp_wmb() in kvm_tdp_mmu_map().
> +	 */
> +	smp_rmb();
hi Sean,

I understand this smp_rmb() is intended to prevent the reading of
p->nx_huge_page_disallowed from happening before it's set to true in
kvm_tdp_mmu_map(). Is this understanding right?

If it's true, then do we also need the smp_rmb() for read of sp->gfn in
handle_removed_pt()? (or maybe for other fields in sp in other places?)

Thanks
Yan

> +
> +	if (sp->nx_huge_page_disallowed) {
> +		sp->nx_huge_page_disallowed = false;
> +		untrack_possible_nx_huge_page(kvm, sp);
> +	}
>  
>  	if (shared)
>  		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);




