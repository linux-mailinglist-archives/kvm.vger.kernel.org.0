Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46309606FD6
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 08:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiJUGJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 02:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiJUGJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 02:09:09 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E01F23640E;
        Thu, 20 Oct 2022 23:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666332548; x=1697868548;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=UIyUx/AVJrUvWj78ds0Rg0RzXLOztRWDczH4WB+tdsQ=;
  b=M0H1tq4LA5fpzeNiwi/jlzN6U1MMiuSPCzPdDTddsHkbxzNeTbf8oHv8
   JI6w0O+acaLCmCKkDJzKNcvOa1PROKKoTXuBEVPM6OMALIGvjkk1VlQbL
   6LpL9dM3MGA9J+aAtnA+owyWYK0wY5z1DHamsC8hN0U2guRemDSD3zE5L
   b5OCHEbDaOA0TrJGKLs6N070uVG2LbxJ8S8DFgsQsN9PToACBDIRolRr2
   ltfnvpU/6u4Az51OpqY1GKbOlYqP7fajOaBEZj41PZRy0aTaawr0etpWI
   uTnD+PNxdz2x97UE5qUiKUAfBaneqyVbkyqN+uCgT0BxNEpPhhxAF0A9t
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="305657008"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="305657008"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 23:09:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="875487479"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="875487479"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 20 Oct 2022 23:09:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 23:09:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 20 Oct 2022 23:09:07 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 20 Oct 2022 23:09:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EXWSLqejoLr8KbgvkKLNFDuPwUZ+D3afnzULlgYX0Ixjkrj3ir0VudpoiUP4clL1ZK2G7UTEwivD/CspUO35h/7a9Okse9c62VB2VazlBp7xARCAzHgbEWrvs+cVnmkpJDYo0RJf22TAK6PcZu0oOtHFNF8sacr4KBuxzwnEZBt6yeDP1HV6yG5r/vFtnoPYy2gYH77+Ceb3qZRs5jSPAJekoTwWqGxRlTd5wiNaTsev18qFgaFaKLd6x9jI31QjWJvDHtsgzRkfjc/9DJvyocX7F6zyZFPuVpb6vf0GM4adhoquRPLCXsZTdy5F0B3kvOpysvonsf75YMAMlsGFMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B7B0QolnxilvloLZmL8Gwydik2XiEHQeKVnrv3/GwVU=;
 b=DAFQXqG/EddZLdwxB6IldaBC9oltirHCe3ucLbEEsRETihgeJUACBALuAOox3/gctRPxkUng4nLL55ZkuLEg39al9gj5uq2i6378E2HcGqQ8QwMmAyFQpV7T+rmE78t/Z/RbfS2pcJg7u+ozPskNmZuVtrRerQyB6+N0RrVWzL+uwFZhn8aADqt/po1d+CfJKI8mQdI/akq0muR26BrI2KITvyHJTeFekpR7Fwwci7uzxEE6aVGGr5vbQUSaipnJQ7klt8dgLAVbUYyZuyI3UTpNF7cNy/rb4juhhv3hd9N2hsN9o88MWbOz1awcKoPjvsXxFdYM1igcoXWTEYTMjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB5486.namprd11.prod.outlook.com (2603:10b6:5:39e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.30; Fri, 21 Oct 2022 06:09:05 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e1be:376b:2662:16ad]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e1be:376b:2662:16ad%3]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 06:09:05 +0000
Date:   Fri, 21 Oct 2022 13:46:32 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mingwei Zhang <mizhang@google.com>,
        "David Matlack" <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v6 4/8] KVM: x86/mmu: Set disallowed_nx_huge_page in TDP
 MMU before setting SPTE
Message-ID: <Y1IyOJsVGo+pCYTq@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221019165618.927057-1-seanjc@google.com>
 <20221019165618.927057-5-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221019165618.927057-5-seanjc@google.com>
X-ClientProxiedBy: SG2PR04CA0193.apcprd04.prod.outlook.com
 (2603:1096:4:14::31) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB5486:EE_
X-MS-Office365-Filtering-Correlation-Id: 858f9194-a6bc-496e-b9c4-08dab32ac211
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tB64hWyCEBdRBXLCiIeQ/r1Gho1jTqkGY4VB6TaXxoYUw73eczbNpPKK8tUEuOFXtkbXX+Ky00T26O4dRd/2UktLCYvEIkmvZmssuD+gzDvCgHEi1Rx3bCNJKl+/KzB+St7bUMnp98oQNloUE6cfFeiOBGtA/UkxHHbulgAAEtE49+J57rVXw+oysvrGKxaDBfk/41CzPzgWogQbOVuhTWtAQLQRQUzwbwGOZDag2LiOroYqFhFB0+6KAA/M8TvfnLqKifmC0/Lk4YfjrUcGn8e2lvt3hEbv7flKQBXaOXEYnytHHwr3S1nRnxlUSYgmbIOoeZ1O+IX+hxTb6M03EjWZ7MO7CJumhCNKXECT97Avsh4oJkEi8kZGv7Md7sjP4xx93cSJD4FCyKdZ96VC1Lp91FiIM5X4LrytPCHEo4k4++xkgviSourtZA1nKjNk6D5EyONKZ83P4MWWGd2X1pUPgL52WauBrMv34TPZ6h1cNBrC7/YhpBoqxwEnobmM1MbGt80WzZE+mtXzYcmx4YhMeR6MO5vyU7+dginxIqENZFphf0XeMQj98g3suqEHEUzaQiHKOR4Hq0FV3vy+yJUWKQf34c1h7S87yROG3nlKfuA4/mhgg5GXTfbldWJkllzvspvXm46A/7uNy7Ih+XtfgZaJRTOe7uPsvT19cxl8ow8cCFPgzvHxS0p5LiOqyEoY4jF8L8UFJ3LMwuQNJajrw6V4mDgBvsybwaDpkQvL/FnW36X2X/at/QBnOyx68+7K1SxiHQ4K/gjyQzt45A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(39860400002)(396003)(376002)(366004)(451199015)(66476007)(5660300002)(66556008)(54906003)(6916009)(316002)(478600001)(66946007)(8676002)(6486002)(4326008)(6512007)(26005)(41300700001)(8936002)(2906002)(186003)(6506007)(3450700001)(83380400001)(82960400001)(38100700002)(6666004)(86362001)(14583001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yrl51FsaeZDm1DDkFsgIS0sp3VZLKRuH8bp+ZT3SyjZU+GasZHEWEPPSBwv0?=
 =?us-ascii?Q?0xCfKWQK2u62m0cQesuO2nCVTC8pW/bzA2EIayhoX+1A/ldz/57dX0Zasf2/?=
 =?us-ascii?Q?3jHo/aPl3199e1GRGrro6P81NaVhDtaYRpMB0YkDorffwMJDbxh9ZGxZKXDH?=
 =?us-ascii?Q?USFBtw/HVZfG5VE1toUkrJkgD0qT/HQzi9g7wo9WGk9/XvhEZfMMhX3tTBcu?=
 =?us-ascii?Q?IfG0satdwBIeZ/ycsGQguyEKo4XRKwtQxXIE7BlqJIqSIDUOgNrIP7BDb5a+?=
 =?us-ascii?Q?J3uEmoxzs09K2uZIIW350i1Rm4sRRgoFrvNzenFk/ZbtYXd4hKKyItaF3gQ6?=
 =?us-ascii?Q?QnvhZBzvsyP/zQ/YbiUI1jWa29iXNWv2muoZgouyudvuYw1Q47ITNhkNOOBN?=
 =?us-ascii?Q?WAsEXT+ZJRSabGVprMwvL6SegjDkdi4Jl4IfxQCSkGWJh2GUjip5SSkm3fef?=
 =?us-ascii?Q?GJNIsHebInkU4BMWwRSAzelyTDEzcXWHcMPcogh1fzWbr5OH+YclA8TMQyTX?=
 =?us-ascii?Q?L++Z7k/l7THohkw8WJQlRDXRGQbKopbsJWtxW2odMbUEHmknmoJHENmolVGy?=
 =?us-ascii?Q?LdIoUfB4jT5maJJc6Slx1zxvbDstamKnfuHv5efys0FrpWhzaiuTa26vEzhp?=
 =?us-ascii?Q?hOi95xYN5KBiE5d/SRp0WWmWpFjSOUn+byoq41KJnOfivu+qIhyFo4GUMlTC?=
 =?us-ascii?Q?9Z1cMSvGiZEeEjy5hmWtTCKIi4364qodn0ZQf4FYlJqKHkfMWPwhSp2VbyVJ?=
 =?us-ascii?Q?BSOtwrKP8aNTDT91kXTOD3Cf7L4Ga5LV1KXO9bEPvCTotza234t4GpQ8O9wO?=
 =?us-ascii?Q?DDQYpTscb9zcfMq70d/vYIYr+TQJLbLncLEz2uh141wv5XzGORinBooEaf6i?=
 =?us-ascii?Q?n4fn6qMR0s8d0KZnSEqRdh28pwfKrMS8D8nsVp0L2XPQn8QlDgCqdmHoIk4o?=
 =?us-ascii?Q?JlVgVXekl4mxmz895HO/10sxvdPPaiRav4qPfhGCTUycHp9gl7EDXk0dxoKc?=
 =?us-ascii?Q?/aBFB4qgStEnFXz8p/n+FxoWsb+Z8fJpd793PDPTpWe+IwzXtHq84Iu71wJb?=
 =?us-ascii?Q?uN4F+CHoe2JHB3bk3KntAv+4BToVvWJ1VLZDmf9Q0gy1SxK18zFtf0YQ5Qeb?=
 =?us-ascii?Q?O47GzAfM8rqvmVSNP0w/CnwNA5geVAe19sn4jwyPDOmz0wRxQiIT7fh8GEoW?=
 =?us-ascii?Q?CGc2467RzBdKVB0OSoggwm128LOn2t4MsMvf4ROhs6ezd9IK33JBfvJ0282h?=
 =?us-ascii?Q?g9Y3RLV2u0styF8nZTTD7O2AuILRoLEiqYxzpAdrKZkZIo0i5C7E7qK7CEZj?=
 =?us-ascii?Q?8T/NcjCp+jvYWzW7+bTLb9huZm8yBs4h18bbIGODQx5GC9sI08J/F7S02ocz?=
 =?us-ascii?Q?SL9WB/aUL/graOUF0nb1Vm7pmTCvSEEwcygA8rJ2F1Pzr1vzhTOIc8QoUcvU?=
 =?us-ascii?Q?P46mAOZbf3G39v7sRYNoPUKaRoDCp7dey4TX8TloiH+/tLRTL1k7mQOcb2aK?=
 =?us-ascii?Q?rWGDD7TCbOG/ObMmqqNc6Jxgg5c02K+JgmO7A2/jooz2mmq3nXs6stnNwws2?=
 =?us-ascii?Q?XeDTFMouXVvuWnh2gQxwEz+QMLxkhveEETFm47G9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 858f9194-a6bc-496e-b9c4-08dab32ac211
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 06:09:05.3223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZFkw3TDNCYc8E3oAPOYbJZlgjtU41H3WHhi5gN9LfGqhaGRM9srjsyGylY2ibJ8Y69LCCe7v+orMjJyGSxTBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5486
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Wed, Oct 19, 2022 at 04:56:14PM +0000, Sean Christopherson wrote:
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
>  arch/x86/kvm/mmu/mmu.c          | 28 +++++++++++++++++++---------
>  arch/x86/kvm/mmu/mmu_internal.h |  5 ++---
>  arch/x86/kvm/mmu/tdp_mmu.c      | 31 ++++++++++++++++++-------------
>  3 files changed, 39 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 99086a684dd2..57c7c52d137a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -802,11 +802,8 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>  		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
>  }
>  
> -void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> -			  bool nx_huge_page_possible)
> +void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
> -	sp->nx_huge_page_disallowed = true;
> -
>  	/*
>  	 * If it's possible to replace the shadow page with an NX huge page,
>  	 * i.e. if the shadow page is the only thing currently preventing KVM
> @@ -815,8 +812,7 @@ void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>  	 * on the list if KVM is reusing an existing shadow page, i.e. if KVM
>  	 * links a shadow page at multiple points.
>  	 */
> -	if (!nx_huge_page_possible ||
> -	    !list_empty(&sp->possible_nx_huge_page_link))
> +	if (!list_empty(&sp->possible_nx_huge_page_link))
>  		return;
>  
>  	++kvm->stat.nx_lpage_splits;
> @@ -824,6 +820,15 @@ void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>  		      &kvm->arch.possible_nx_huge_pages);
>  }
>  
> +static void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> +				 bool nx_huge_page_possible)
> +{
> +	sp->nx_huge_page_disallowed = true;
> +
> +	if (nx_huge_page_possible)
> +		track_possible_nx_huge_page(kvm, sp);
> +}
> +
>  static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
>  	struct kvm_memslots *slots;
> @@ -841,10 +846,8 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>  	kvm_mmu_gfn_allow_lpage(slot, gfn);
>  }
>  
> -void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
> -	sp->nx_huge_page_disallowed = false;
> -
>  	if (list_empty(&sp->possible_nx_huge_page_link))
>  		return;
>  
> @@ -852,6 +855,13 @@ void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  	list_del_init(&sp->possible_nx_huge_page_link);
>  }
>  
> +static void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	sp->nx_huge_page_disallowed = false;
> +
> +	untrack_possible_nx_huge_page(kvm, sp);
> +}
> +
>  static struct kvm_memory_slot *
>  gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
>  			    bool no_dirty_log)
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 67879459a25c..22152241bd29 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -328,8 +328,7 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>  
>  void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>  
> -void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> -			  bool nx_huge_page_possible);
> -void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> +void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> +void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>  
>  #endif /* __KVM_X86_MMU_INTERNAL_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 73eb28ed1f03..059231c82345 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -403,8 +403,11 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
>  		lockdep_assert_held_write(&kvm->mmu_lock);
>  
>  	list_del(&sp->link);
> -	if (sp->nx_huge_page_disallowed)
> -		unaccount_nx_huge_page(kvm, sp);
> +
> +	if (sp->nx_huge_page_disallowed) {
> +		sp->nx_huge_page_disallowed = false;
> +		untrack_possible_nx_huge_page(kvm, sp);
> +	}
>  
>  	if (shared)
>  		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> @@ -1118,16 +1121,13 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>   * @kvm: kvm instance
>   * @iter: a tdp_iter instance currently on the SPTE that should be set
>   * @sp: The new TDP page table to install.
> - * @account_nx: True if this page table is being installed to split a
> - *              non-executable huge page.
>   * @shared: This operation is running under the MMU lock in read mode.
>   *
>   * Returns: 0 if the new page table was installed. Non-0 if the page table
>   *          could not be installed (e.g. the atomic compare-exchange failed).
>   */
>  static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
> -			   struct kvm_mmu_page *sp, bool account_nx,
> -			   bool shared)
> +			   struct kvm_mmu_page *sp, bool shared)
>  {
>  	u64 spte = make_nonleaf_spte(sp->spt, !kvm_ad_enabled());
>  	int ret = 0;
> @@ -1142,8 +1142,6 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  
>  	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>  	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
> -	if (account_nx)
> -		account_nx_huge_page(kvm, sp, true);
>  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  	tdp_account_mmu_page(kvm, sp);
>  
> @@ -1157,6 +1155,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
> +	struct kvm *kvm = vcpu->kvm;
>  	struct tdp_iter iter;
>  	struct kvm_mmu_page *sp;
>  	int ret;
> @@ -1193,9 +1192,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  		}
>  
>  		if (!is_shadow_present_pte(iter.old_spte)) {
> -			bool account_nx = fault->huge_page_disallowed &&
> -					  fault->req_level >= iter.level;
> -
>  			/*
>  			 * If SPTE has been frozen by another thread, just
>  			 * give up and retry, avoiding unnecessary page table
> @@ -1207,10 +1203,19 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  			sp = tdp_mmu_alloc_sp(vcpu);
>  			tdp_mmu_init_child_sp(sp, &iter);
>  
> -			if (tdp_mmu_link_sp(vcpu->kvm, &iter, sp, account_nx, true)) {
> +			sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
> +
> +			if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
>  				tdp_mmu_free_sp(sp);
>  				break;
>  			}
> +
> +			if (fault->huge_page_disallowed &&
> +			    fault->req_level >= iter.level) {
> +				spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> +				track_possible_nx_huge_page(kvm, sp);
> +				spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +			}
>  		}
>  	}
>  
> @@ -1498,7 +1503,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>  	 * correctness standpoint since the translation will be the same either
>  	 * way.
>  	 */
> -	ret = tdp_mmu_link_sp(kvm, iter, sp, false, shared);
> +	ret = tdp_mmu_link_sp(kvm, iter, sp, shared);
>  	if (ret)
>  		goto out;
>  
> -- 
> 2.38.0.413.g74048e4d9e-goog
> 
