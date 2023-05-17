Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55319705E64
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 05:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbjEQDwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 23:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbjEQDwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 23:52:33 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEB22735;
        Tue, 16 May 2023 20:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684295550; x=1715831550;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=1W1lAXN/1QRR6wNjnAx+6PB1ERCh6gDSV2MCbWr4ddg=;
  b=eX6GNDOm9jTdkTdW2nMEzVM3WG1i2bCEXes+b8ZHfwks7VRKgzoeD6Ia
   w/oyBex7/5ybgRfKudQ7TCdl7lkp+MCnSDXjnETzOI45ne6HzahVN16XI
   P3MWQFhZFFOOT6YSbF8hVxeoK+boz/WbYR82WAa7t2sgO+iy3KjEBLElu
   1kxBAoUPtnpKrc+OWcDhfIbPvqxvGI8WSKOFcUSmAKCIK2A64undfVg/H
   IU5XR864QRFRVyNNsuzfIfDPgjF25sGcYudY6YRxKYIyf0qmUzCfUbnwa
   1wlupfEi5FvU3MwBZTKJdcLGugh28J6UhLkw8UrimJdUh8Rtl7EoJwfra
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="379843830"
X-IronPort-AV: E=Sophos;i="5.99,280,1677571200"; 
   d="scan'208";a="379843830"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 20:52:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="948104528"
X-IronPort-AV: E=Sophos;i="5.99,280,1677571200"; 
   d="scan'208";a="948104528"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 16 May 2023 20:52:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 20:52:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 20:52:20 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 20:52:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDMNX+NnQbA4HNuE39cHo/wco+f96he9yi3IfEFkL6/J30mhBKpEssW+qcxe0JJwhGuXIBdBioe6kpa4mHvKG+9aXyLQp9qMi80AqlPTNkmRUNAkocX65+4nIksKEzCJAsOBykP1L2KJnDVwYGHCv+/ibDdsahdZor8U92pti8vsmrRFLWASJAAALT9ygZ0PZa8klm7SyVzv9jQ1ALNgaINzv+urX4cMz8zqDRZqpcaAhU87Z3XYc/1hB7d3z3wsdvcn+KW2uiMAqwRWyNTNzIoMyQYsQGAfjNHbySFff4RZU+1Tmb8bVe10QkNKBf32KYOexXZCw0TPdvzo0meYWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q0KdS1Y2gS4mbyV2wO8z2tHU/m9reck1F+IbacVZHWQ=;
 b=gzFC7N+Wq9T3PT/IX3LPVn/5ruEXskFNF2NzjLy36SnuFyINuS9Ra0S9cAm5iGgg6n5JA6uxO+BWMa6DbfyAwt/1CMZ5M3XnHeRAfCCwEV8NV06QUjllsC2LjKISU2vxuCJdcWo6Tsc3x3A3d5cte/ppPagU1mt/zhzNCmR+uUVCBsxv5vbESD5dbbhy7iDBhIYnclll4SrEHBErV6uUM9GBgXjmb7bHfh7WeUXsQh3R/TKenQTEtNjbxv+Odep58GhrFQ+ROjneah3B5np+cFc52Didjwe9xFlVDvNBLN/K4CzodrA4F4liAAaIguHuuTIfnXP6BpF8BBaajZn6hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7515.namprd11.prod.outlook.com (2603:10b6:510:278::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.17; Wed, 17 May 2023 03:52:17 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 03:52:17 +0000
Date:   Wed, 17 May 2023 11:27:09 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 21/28] KVM: x86/mmu: Use page-track notifiers iff
 there are external users
Message-ID: <ZGRJjaW1fREfBD2M@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230513003600.818142-1-seanjc@google.com>
 <20230513003600.818142-22-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230513003600.818142-22-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0105.apcprd02.prod.outlook.com
 (2603:1096:4:92::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7515:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b1c4803-a8eb-4d5b-d1f3-08db568a1b5e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tgdj9L1KvjVqqTYDKdYfNVZ16u1RjyGnx91PYx/TTPsvKPkvATQlcbeyqe3NUMVIUiZ0OTFUvFm2Mi7Wqe0VNTtDXM60F/5epV750jRUtZn1vQTPVPdfpBrv+gz2HIOSh+I85HXcRxUH1lGjJfo1Mk0HDsoSh5j9f/dbqU4PPm7GWRGQAsjeN9So2EBFXd3Mt2Mo7wuCh8Q9w4cvIxuVZ91YD6Z4PN0B17qjYkBLezKTvuUMKiJFhaKQ/xtBZrlnp6SOOmhe67ZNevQu60cQoNYBBWTgxPVt9quoXxqMlHISwFHV95tv6y17sT06D10GYGo8QmhWO41lhcXvuu62s2Zd2azg7wQkeNdUz+UGPCf7gvikq1uSNE0aJFNqy+pW36qQEAX+xr4vOOvpMNpNVJxC73r/NIMV6WT/PnHefqiJS1iH8AAjGWV9KsZakhmayHijNovz1T8xO9Rc64ko91PteaU+eV4uiQt8zbClTtZT9uKUqyOEOJU1eQGOOmphWKhIoGicm4K8ZPJggaYCuD3O9LjkqjCsiQajeZkg9zgx2sjc1CvJ6QcZrsklilKL+Fk6PxAjcoDlr/hSF1rgv2KGMLhzshyRDrRYQHxQSqHmRH2wL7xCnH56VgmQS3SVGwJOoXp1JTtxTtdy1WumDnes/JRrqtfvYPFfE6KZvrnZ8TqP/xuoISNFEWrZ7e1t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(346002)(396003)(366004)(376002)(451199021)(2906002)(3450700001)(5660300002)(8676002)(8936002)(66946007)(66476007)(4326008)(6916009)(316002)(54906003)(66556008)(478600001)(6486002)(41300700001)(6666004)(86362001)(82960400001)(83380400001)(186003)(26005)(6506007)(6512007)(38100700002)(26730200005)(19860200003)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m4NgJq9w8F+Fhg/UjTQy33BFbVuniIVRMSwa/SRPPT06u91FRJxYUU9v0s8K?=
 =?us-ascii?Q?DE/ZTNlsSLYsUX0W5McS8AwIYOQufHUEFRXJfJsQkklvIz+USgMmYXLk1ELA?=
 =?us-ascii?Q?NyR3o5RRP0o1QvezAQMkoFI+CLKoee5+upQIsLh46FTQAL9ozBbjfIMhJH9p?=
 =?us-ascii?Q?8Kr3hBjFYi3jwCXBXBED24IKfzOY3xuv3A5YoiesnFjHZ+FjtNf8uVv22f6o?=
 =?us-ascii?Q?Mh4dYkITN+W8mY2idopb51NeW4qnM7d7bRaoBY9EdP9BMnLp7BvOolDqDKwq?=
 =?us-ascii?Q?Ktggh8ugdavRMg1JNrG5uZVZDZLQ2SBmZCPq18zYwQyIqe2zPiV06ZtLIojV?=
 =?us-ascii?Q?3veDkxlrul3iGs8CZm0slsenpzjC78sbWZJI8UXybU/+cUZZkKWpjOZiurX5?=
 =?us-ascii?Q?Dy0f3d++WFpO6xdhKDdv1zToBr/EH4+5ND/Dq7kOAmi57S/5vynx4XWh3xmg?=
 =?us-ascii?Q?CAN0anlh7vKRTqMXhgWanMDCzBGgu0KASKZ4h7y3ZN/JHAWussWqV2701ObQ?=
 =?us-ascii?Q?qdKy0hjY/mrB4DIqO7SWsl+KsoO+q6jBiBQr/OmqUq0q7X5gD/7Zy4hGPtLR?=
 =?us-ascii?Q?LRfND2H8URheyl9JeFNqO12HL1FgirqPVK08kXPY2NcL3OW/aMekfdyaU02s?=
 =?us-ascii?Q?tzBwj1Bz9P9Gbh4k/mV2I3qb14nzn5geNIPsGjn8JcWBzB6hAiqgRpYMZoD/?=
 =?us-ascii?Q?9XYLdLF27Lecdj4RybGiaxtFTKDGPgF6zgigYhyZtI64l6HYuNvYpcKFC2xu?=
 =?us-ascii?Q?oGxyvFsEo82bNqFBAUDr5kj7tEmiQYZyO5Sa3BICum1ipW7STa5s4pCFa3oF?=
 =?us-ascii?Q?g0W71mNsv7IKJiavN0CfTIk2Y6bwSCs4AL7Fx5xr6W2ASWV4j/pG70ynMP7H?=
 =?us-ascii?Q?0IYaEoEwSSUOTW1QfctQeLwzg1OqAr+zAlqmggX7BJJhWNnFxTSZBomZJxZK?=
 =?us-ascii?Q?kfza5mgqGjvLJuMjn4tigk1NXRdAzIKG0tNfQMpd+9nEOkavfdOHaj5pbkIG?=
 =?us-ascii?Q?XyQtt0NqL8fHjfJvIGtj8TydqVhxRZsy5ddiZTT417Wky1VReyuxjomTfqGm?=
 =?us-ascii?Q?cHQ/2FFzTZ62Ou4aS1WjzUZ2f5U8/F2Q+MUWNLFUjs4ixzy9T9ViXGVlxv5t?=
 =?us-ascii?Q?D96KtImnLnYA5zY3yycuwGU3GuEjHbkxFnIag5XGCMWNf6ArC9irupkfYYse?=
 =?us-ascii?Q?nMoban5/j+X85jKq+AQSPGFKaSzj7hsIOTdSGnsBDBPNHCxaieGZ8AhTkev3?=
 =?us-ascii?Q?r3Gaa0X7rnABcNVahSIMI3038xZW2ns/JctP4j5r0X3gy1OlkRMf/aciyhFp?=
 =?us-ascii?Q?8JROgToiN1QUT12C5FzyrALcXVhjPh+tFQ2SPsbsjPfwaSXA/exshk66rhsH?=
 =?us-ascii?Q?fs86vPZhfMV0jUGV5XMRMxrgnx13ZeEAgneL9g7acPpSqgnJ8dSydCYRl+Bo?=
 =?us-ascii?Q?Wk6b1+XdHoIPMFeGut6nRvfw1SUVgh9i7cl/Do3QuPcwswCxNU3+pN5thl3M?=
 =?us-ascii?Q?tCoSqT3Z7Ncx+7g5aHHaC3WOnG+0bqCA0UiImJvsolS4iFjbJMSVoc7lb4Qm?=
 =?us-ascii?Q?ACRBOnygyehmd8l3fqhLLuQkxjE03Td10WbMqNNk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b1c4803-a8eb-4d5b-d1f3-08db568a1b5e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 03:52:16.9761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 190RtqJx3R4q96/cR6kIsbDWrxCSATcgkraulN06VKunQ4qD6rdhshwitWZhocaJGNykoT6iJ8P4NjIXRC93eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7515
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Fri, May 12, 2023 at 05:35:53PM -0700, Sean Christopherson wrote:
> Disable the page-track notifier code at compile time if there are no
> external users, i.e. if CONFIG_KVM_EXTERNAL_WRITE_TRACKING=n.  KVM itself
> now hooks emulated writes directly instead of relying on the page-track
> mechanism.
> 
> Provide a stub for "struct kvm_page_track_notifier_node" so that including
> headers directly from the command line, e.g. for testing include guards,
> doesn't fail due to a struct having an incomplete type.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h       |  2 ++
>  arch/x86/include/asm/kvm_page_track.h | 22 +++++++++++++-------
>  arch/x86/kvm/mmu/page_track.c         | 10 ++++-----
>  arch/x86/kvm/mmu/page_track.h         | 29 +++++++++++++++++++++++----
>  4 files changed, 47 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 113598d3e886..5ce06a75d3de 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1247,7 +1247,9 @@ struct kvm_arch {
>  	 * create an NX huge page (without hanging the guest).
>  	 */
>  	struct list_head possible_nx_huge_pages;
> +#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
>  	struct kvm_page_track_notifier_head track_notifier_head;
> +#endif
>  	/*
>  	 * Protects marking pages unsync during page faults, as TDP MMU page
>  	 * faults only take mmu_lock for read.  For simplicity, the unsync
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index 76c0070dfe2a..61adb07b5927 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h
> @@ -9,6 +9,14 @@ enum kvm_page_track_mode {
>  	KVM_PAGE_TRACK_MAX,
>  };
>  
> +void kvm_slot_page_track_add_page(struct kvm *kvm,
> +				  struct kvm_memory_slot *slot, gfn_t gfn,
> +				  enum kvm_page_track_mode mode);
> +void kvm_slot_page_track_remove_page(struct kvm *kvm,
> +				     struct kvm_memory_slot *slot, gfn_t gfn,
> +				     enum kvm_page_track_mode mode);
> +
> +#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
>  /*
>   * The notifier represented by @kvm_page_track_notifier_node is linked into
>   * the head which will be notified when guest is triggering the track event.
> @@ -48,18 +56,18 @@ struct kvm_page_track_notifier_node {
>  				    struct kvm_page_track_notifier_node *node);
>  };
>  
> -void kvm_slot_page_track_add_page(struct kvm *kvm,
> -				  struct kvm_memory_slot *slot, gfn_t gfn,
> -				  enum kvm_page_track_mode mode);
> -void kvm_slot_page_track_remove_page(struct kvm *kvm,
> -				     struct kvm_memory_slot *slot, gfn_t gfn,
> -				     enum kvm_page_track_mode mode);
> -
>  void
>  kvm_page_track_register_notifier(struct kvm *kvm,
>  				 struct kvm_page_track_notifier_node *n);
>  void
>  kvm_page_track_unregister_notifier(struct kvm *kvm,
>  				   struct kvm_page_track_notifier_node *n);
> +#else
> +/*
> + * Allow defining a node in a structure even if page tracking is disabled, e.g.
> + * to play nice with testing headers via direct inclusion from the command line.
> + */
> +struct kvm_page_track_notifier_node {};
> +#endif /* CONFIG_KVM_EXTERNAL_WRITE_TRACKING */
>  
>  #endif
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index e15329d48f95..b20aad7ac3fe 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -194,6 +194,7 @@ bool kvm_slot_page_track_is_active(struct kvm *kvm,
>  	return !!READ_ONCE(slot->arch.gfn_track[mode][index]);
>  }
>  
> +#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
>  void kvm_page_track_cleanup(struct kvm *kvm)
>  {
>  	struct kvm_page_track_notifier_head *head;
> @@ -255,14 +256,13 @@ EXPORT_SYMBOL_GPL(kvm_page_track_unregister_notifier);
>   * The node should figure out if the written page is the one that node is
>   * interested in by itself.
>   */
> -void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> -			  int bytes)
> +void __kvm_page_track_write(struct kvm *kvm, gpa_t gpa, const u8 *new, int bytes)
>  {
>  	struct kvm_page_track_notifier_head *head;
>  	struct kvm_page_track_notifier_node *n;
>  	int idx;
>  
> -	head = &vcpu->kvm->arch.track_notifier_head;
> +	head = &kvm->arch.track_notifier_head;
>  
>  	if (hlist_empty(&head->track_notifier_list))
>  		return;
> @@ -273,8 +273,6 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
>  		if (n->track_write)
>  			n->track_write(gpa, new, bytes, n);
>  	srcu_read_unlock(&head->track_srcu, idx);
> -
> -	kvm_mmu_track_write(vcpu, gpa, new, bytes);
>  }
>  
>  /*
> @@ -299,3 +297,5 @@ void kvm_page_track_delete_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
>  			n->track_remove_region(slot->base_gfn, slot->npages, n);
>  	srcu_read_unlock(&head->track_srcu, idx);
>  }
> +
> +#endif
> diff --git a/arch/x86/kvm/mmu/page_track.h b/arch/x86/kvm/mmu/page_track.h
> index 89712f123ad3..931b26b8fc8f 100644
> --- a/arch/x86/kvm/mmu/page_track.h
> +++ b/arch/x86/kvm/mmu/page_track.h
> @@ -6,8 +6,6 @@
>  
>  #include <asm/kvm_page_track.h>
>  
> -int kvm_page_track_init(struct kvm *kvm);
> -void kvm_page_track_cleanup(struct kvm *kvm);
>  
>  bool kvm_page_track_write_tracking_enabled(struct kvm *kvm);
>  int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot);
> @@ -21,13 +19,36 @@ bool kvm_slot_page_track_is_active(struct kvm *kvm,
>  				   const struct kvm_memory_slot *slot,
>  				   gfn_t gfn, enum kvm_page_track_mode mode);
>  
> -void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> -			  int bytes);
> +#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
> +int kvm_page_track_init(struct kvm *kvm);
> +void kvm_page_track_cleanup(struct kvm *kvm);
> +
> +void __kvm_page_track_write(struct kvm *kvm, gpa_t gpa, const u8 *new, int bytes);
>  void kvm_page_track_delete_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
>  
>  static inline bool kvm_page_track_has_external_user(struct kvm *kvm)
>  {
>  	return hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
>  }
> +#else
> +static inline int kvm_page_track_init(struct kvm *kvm) { return 0; }
> +static inline void kvm_page_track_cleanup(struct kvm *kvm) { }
> +
> +static inline void __kvm_page_track_write(struct kvm *kvm, gpa_t gpa,
> +					  const u8 *new, int bytes) { }
> +static inline void kvm_page_track_delete_slot(struct kvm *kvm,
> +					      struct kvm_memory_slot *slot) { }
> +
> +static inline bool kvm_page_track_has_external_user(struct kvm *kvm) { return false; }
> +
> +#endif /* CONFIG_KVM_EXTERNAL_WRITE_TRACKING */
> +
> +static inline void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> +					const u8 *new, int bytes)
> +{
> +	__kvm_page_track_write(vcpu->kvm, gpa, new, bytes);
> +
> +	kvm_mmu_track_write(vcpu, gpa, new, bytes);
> +}
>  
>  #endif /* __KVM_X86_PAGE_TRACK_H */
> -- 
> 2.40.1.606.ga4b1b128d6-goog
> 
