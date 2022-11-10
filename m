Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26841623A05
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 03:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiKJCuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 21:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbiKJCt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 21:49:59 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD14BE3D;
        Wed,  9 Nov 2022 18:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668048598; x=1699584598;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=JZ0akdd2tPkNQ66rSQdyxwjfv2TzlO9XzDfMGZFFGu0=;
  b=PBZhyVp0ZdkKardV+tKDk8JBma41K4BTu3ZidgNU3mxjhFBUNs3xYdTE
   VI9QvHlx5HnQ1SgKB5pQ2DhAeunOGtCrsD1BfkvvsoXsZ6NCMupHax2xN
   i4bBNGItllpU1y0ppMnLEgW0e8Y6J199klK+gEocrJYSGUxBgELeOBKmv
   X+Crhf8jS2NdzkW7/cXcbi5MztWnafnqsUMMqyXkud912wC0Z80aStQ8n
   wvxdUBtX/eA9bD7eEnp1hDPZNvZYLB1SPEf25ibC3k8ymRAyTXwbSVpWq
   +yEKiwqd7bSH6/wwwtdywpwCwoSwN9VULfelwYyqLKj4WcYBHd8pAZIj0
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="373304975"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="373304975"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 18:49:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="631489102"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="631489102"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 09 Nov 2022 18:49:57 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 18:49:56 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 18:49:56 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 18:49:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+bTMZbQy9eoMtQIXfHC+SeATmiOGuFOnyuBNKCvyiNqGPRDNEKCcp0TvfYSrnqu+b0wjy88AOk/ZH5seZMGf6Cqk5wJQoSdEIb9W45kovKXOk+BEU74E7SizhmDxtO0nFDz68FspzFd46kOPKTOv4wHjsQoDjvWIXHCpCMMfWDy32Q0wcwm5MRMg9UJ9I5LL21JRlT28wGLDJO9FLghPY5dSxnwZ0mtUoDkOxTG/DwH4Tavpi2FWGNHNssX2TqD1DEI8gBQb4H+NoircmJs96IqWQjwOiWdHTXx8Z3K//PJyCGaplM8yWSKmtyF6U2PmLLsjzVaQinJ1btLWI85Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K71reUg+k89ir0u4ANHv1IkLF+T4pfKq2t4Kr/NtHsc=;
 b=ZvQNsFtKAuxmdMF7ziFNenWM4r4RZF0h8y9WmoZKZG7wdtSTxDll8ihkGA/PufXTZw1zQiyu2yleqFoNud7dLioZp+yx9IZ4lTDYq6NjdSaYKvLtGYRVU+2Wgfw+Jb++al26EHbDHuJUwaAXS8N33d9xZrjBz3i780qWZZhrP1vrpMMqeeBdyD2kRgXNqRs2zh8cF7UTZhSvwh8V6uqjERv0B/kKMUorg8CW2eCYKSCPJGXAfbA1LwaOJn4bpNe+Kv7QYHk1Y1KaxXs/9O/d1KT/wxxCOjET0kHCYc2sgWr12Ci4z5/bsDpjW4nXtmeoHpnxh/xvOSIplciLlEYtDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA0PR11MB4687.namprd11.prod.outlook.com (2603:10b6:806:96::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.12; Thu, 10 Nov 2022 02:49:53 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f%7]) with mapi id 15.20.5813.012; Thu, 10 Nov 2022
 02:49:53 +0000
Date:   Thu, 10 Nov 2022 10:27:06 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Don't rely on page-track mechanism to
 flush on memslot change
Message-ID: <Y2xheotNkWPVKsIl@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221110014821.1548347-1-seanjc@google.com>
 <20221110014821.1548347-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221110014821.1548347-2-seanjc@google.com>
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA0PR11MB4687:EE_
X-MS-Office365-Filtering-Correlation-Id: 05681a1d-76d1-4872-94a3-08dac2c63e55
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O4g3DOZXnM0i9upK/mYs80NUABZa2RzhUIXz1x+LWS7R0MfDl+GpXC+Snk4beQqRAAe/vlCP1Cll4npR+QMfYMIFNBZq3+cKBEcxpDzrI6yCyGJifInZa/7Cxd1Uy70cg9vlxT6+BmdrgYXlJ7Cp1xX3E9Y1P/4IIpBs95DSMk5mz+9cNm05FXjt5Grydui4wJqzFrG1MhfMa3Vv2u4IeMSCyYySnUuSoTuE5dlQCjk69a/teS6hvWD46KHTKJHFIhje7NWk3F8Q5lOjTckPhqDSdnWlJtnm5NUIi3iumJ+TrCPYV65wYdkR+csPjTOPmlPUILuCSxpSbMhbpdFU2ZdF7mi/CBPZZXHfWp0P17dR4yGmgMZH7LM8fUeuZO4nujwkOy6MOgAKuSrF8/FzUcaoQYHiant8zYsZmE6YVE6KtS1TOJVuSQqMSRS9KPF6q5XE8J5ovMsCCw0uoqQWxAKgBTaLG+BdkXKq2uiYcWuzoNckdLU7iUzSrk5dhI+q0HNh3xHKsaOTgDc4nTY2XWj5XoUe7+mRoQCPG5zN7G3KNYNr0GxoYvEnXBBK5J8pnXYNAJbXj7wo6FgtN7+67JNaznNlMJhJxxMKrQpqPGIaCXZHngs9KQrzmzh/6ob0IpIWKGeEOEF4XRlyCXOK7DDpBAXf/Bnq9WpFk40nwv4P2o+jJYj5C7XLRODhAyD8zz4KF6/d+aTg8jj031VngA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199015)(8936002)(5660300002)(86362001)(66556008)(8676002)(26005)(4326008)(6512007)(66476007)(66946007)(6916009)(83380400001)(41300700001)(316002)(6486002)(478600001)(82960400001)(38100700002)(3450700001)(2906002)(6506007)(6666004)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D5+AxnA+TmQw0Rztbxhz9x1ite39/AGeSB04hHY1K5IqDVc8H0PTPKfxTNy+?=
 =?us-ascii?Q?CgZfAnFLLeLaEYSt2RhqyT6aMZLBsb/5tZ4gG0QtzIOqvG5aF8A0gb2HVYf/?=
 =?us-ascii?Q?BVdgKGLTqOR+xvIon1oMbOEI8lPPFlIE6y0FbXlSac35ZZair1n2hOmEqAlk?=
 =?us-ascii?Q?vyMN46afen74JmkDJU5drJLaQ5kZ7dj6VVXovniTKOxMUbK1ZUOsJ/jOGnc7?=
 =?us-ascii?Q?xGi4f/6S8aE8WcZWp1nTIWp7D1a2pwJRnvqhkN0obe+GNkxgUPwZibgREGEY?=
 =?us-ascii?Q?GOw2yjaGrLT5YJ4LWBvNDrVH97rkvq0lj17opxevrS6XssC/8SdbmN2U8pZ2?=
 =?us-ascii?Q?IGduZ73id+/oDGe6Fzp55HODIKE9bNBcLkftfJQkg4Wr/sIcLE6DPbEPLNg1?=
 =?us-ascii?Q?I0KDcCbX3/xGOlMkda15Bci4ZvJxgKJsM82uuo3iM6xzN22z49f3qN0/dLeC?=
 =?us-ascii?Q?iRjBIrVc+we9nOznPpMirq5WvoQ4hJQPojmdxMrkUDQsPUctM9wsdcu8ZNEv?=
 =?us-ascii?Q?h07SLXhVdLBAdrACDAz7KgPSW9njmOutWptPpgyDGl0sW3oagamfofKPj0m9?=
 =?us-ascii?Q?5kQ+86MpUschjPwkCLXD5b6MT340cVUQL96rC3RXoZajIjhYr+DparnpvLgE?=
 =?us-ascii?Q?C/bE9lImqAw+4P98wTnMGDZKxFDstLWkLmJhHTV9F7NcbMyUdqW0A/xUm4hG?=
 =?us-ascii?Q?6GOfurFgJnRzZqH433uzjO13lb53/98f3AGjjcx1fYWT020kMqKdQg1GqCBQ?=
 =?us-ascii?Q?32vik3HaCZ/9i54hNWF6fO5v3ev5KLIwD6j5ul6RcPXvHqqemlaehw3JufjE?=
 =?us-ascii?Q?qCVyjDKg3CspRXL7duBCAtgUIlq1QPAzjJ5drSr2tFaaDwbtm+wVUYz89qO8?=
 =?us-ascii?Q?LLApN/3cxkZBZfmeBrVqi2kjb2zO0UpPc7OtZWAyUH5RJHmhuuhQXLBSWHHn?=
 =?us-ascii?Q?Pfd2WjSY5VrjPIjTyHYHLnXtW064CRmqkQGy4V0mgryglqt4rnTIDQ/6iJu0?=
 =?us-ascii?Q?GJKBakLDlxIh/gKWepBwLAepnHtH26n8zuiqlsabABGBiOlxEBBvHPB+jCp4?=
 =?us-ascii?Q?4WVZtGj0x/f4RUYCuL32+FAk8r4bUPAeqO5M98uXjIQn9A7uwY9wql8ARgWz?=
 =?us-ascii?Q?Kt+tou1HcFiFi2EJ2HiEdfFMgLG5yvtLsPj8f2c/XVFcJNulxckI1VKeCw0A?=
 =?us-ascii?Q?OWKjMjZe05S8QKHOWTIkRG0Nrhsziu4dGbeSqvAahSB+mNO71/MmQJ9/Vg+g?=
 =?us-ascii?Q?Q+AbVliF6qlaTEIGxGWVBXawHr/voLyLiXdEpwUItUptl2f3I1bcZKCBNoNz?=
 =?us-ascii?Q?oCoduzYrHj3hAHrTtdfMkkTBKp65/ey9cD7p/HJvxYA/J2Y5M1t/aObCpKtZ?=
 =?us-ascii?Q?V1zF1iKru7pi0BgL8SUNGk654AekflWVrzkdVEwephhMMOeyykfEV4KTYd3l?=
 =?us-ascii?Q?S5qbTbckgjUogDdrY5+8QgrSzRtuVkNyA86Eiq3z37+Udr12tmEfIjJr4cmT?=
 =?us-ascii?Q?fpoFsEaK4MBQc079hNdnkA6KpAOh3lInu6Hn8Wvj/cZ9uvlh10AvaMF/7zou?=
 =?us-ascii?Q?XTG/tseUrYeJ7EpoPoENDQ2SMv3Rm4YveHfBVrufXhBThpQfEkkF0OiUsiR8?=
 =?us-ascii?Q?Kg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 05681a1d-76d1-4872-94a3-08dac2c63e55
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 02:49:53.5361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WwFhLFWywFv3Tv8Td9xFyys+mnpAOjFLm8J7mEQ5CE9MS5Pl4JyXQ7+pjOpbarOhYRVtDN/lIb5JdgrL37ZXbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4687
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 10, 2022 at 01:48:20AM +0000, Sean Christopherson wrote:
> Call kvm_mmu_zap_all_fast() directly when flushing a memslot instead of
> bounding through the page-track mechanism.  KVM (unfortunately) needs to
> zap and flush all page tables on memslot DELETE/MOVE irrespective of
> whether KVM is shadowing guest page tables.
> 
> This will allow changing KVM to register a page-track notifier on the
> first shadow root allocation, and will also allow deleting the misguided
> kvm_page_track_flush_slot() hook itself once KVM-GT also moves to a
> different method for reacting to memslot changes.
>
<...>
> @@ -6021,7 +6014,6 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>  		return r;
>  
>  	node->track_write = kvm_mmu_pte_write;
> -	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
>  	kvm_page_track_register_notifier(kvm, node);
>  
>  	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e46e458c5b08..5da86fe3c113 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12550,6 +12550,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  				   struct kvm_memory_slot *slot)
>  {
> +	kvm_mmu_zap_all_fast(kvm);
> +
>  	kvm_page_track_flush_slot(kvm, slot);
Could we move this kvm_page_track_flush_slot() to right before
kvm_commit_memory_region()?
As KVM now does not need track_flush_slot any more and kvmgt is the only user
to track_flush_slot, we can rename it to track_slot_changed to notify
the new/deleted/moved slot.
Do you think it's good?

Thanks
Yan


>  }
>  
> -- 
> 2.38.1.431.g37b22c650d-goog
> 
