Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4213D63335A
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 03:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiKVCd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 21:33:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiKVCdY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 21:33:24 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFBEB971E;
        Mon, 21 Nov 2022 18:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669084403; x=1700620403;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=YZOqd+n4nT3F+gZJ44XnS/lioAS48Z2toBDEF56IGhY=;
  b=Hu2pGM5cmwTtTmpUENiabgpMKLyCg4CZO4GtJ+lD91V/0EsPh4i2nHhG
   H4+jNtmWFofei3RhheIxwkdFSRSfE3ijpN/2GDwpB7Uct1wPDEIlcYvdl
   QN4apI2WnZ3kBEj3yngsskCFTvki7DT5spfwH/pgD382i5DGPAnx/rqo1
   9FTox4YuQIRM/xB3FJHHMzXb94l8L5HU8k0RsOsvySTQyACJ+BHOWeaug
   x4R1iojlJUcbzjUeQbF7RInC+qiI4HLhaYmtQ4psDYfEoMD3j1SMKHHBA
   d/gxAHyo80b7nfhNHOm+8S9/81GdKPTX75NE4pn6cykkDVmOLja0sd9Lk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="313740819"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="313740819"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 18:33:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="886351774"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="886351774"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 21 Nov 2022 18:33:22 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 18:33:22 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 18:33:22 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 18:33:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QuHpKop9CG7SzE4hp+O5YCSzp7lwdJrUTxlkrFbLcJY3C7QZQM7yK0CfV//zJmbjLfDjIFvTnkXsPYdFiYsXLkwB4Cang4dgRSYFiaiQIj4zV/M845X4u7EzhOko95pmDZtviLb8MgzPR1LBOxYKOOAec8pJXcxmqidtCUXI20sDVufCDCRKKudnC/psJapiG2cMlBFm3VBqpRsPLN0E5XQ3pWZ3QJcbguK1VKqmhfItPV4cJFMumvKJ9jBi8W0CKAryUf/A69e6/nS4Qia4+tnRf6C4vjDkdhpJyij2ZCJNuU4MD7DTsY2wlACQydyD3QSdF4UXMytib9d7Jvau3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tSiM4KaakHxEoRq5/Im1NYK1vYjYW0Nnp3+nEeuih8M=;
 b=oO+o4mj0WhRrfb4v3jxIQPaM+CSJq4kaC3V3hyyF9cUgJ5ASpIPkkjV3fAvmpSFHioTJ33ZaOHcOwyvAIps05BVM97Fjv4n5+wLMwz8+hF+q4G/EhNzbMtax4soX95FFsbsxpQ42c/TLAAWUOKHIBDd2O+bj4F3voS1+nLTZkuzyh3xyS7wXEzMA5Uo8GX3tbV8otnu3nNJhTpFOKiRQRhcGe5a9UovJykNY7cQbxPg0tXwSFPgsSDArmYvDi/TJ6Gc0XSzSmwuIDofDGI/NypuT3R3Xg+1JkZ3bSmLR5ZuLfgRXorS+bXZ/aJKTVtqnH8clUEs8yE7Ze0LEQuWVng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL3PR11MB6505.namprd11.prod.outlook.com (2603:10b6:208:38c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Tue, 22 Nov
 2022 02:33:19 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af0:fb9e:4ef9:24e5]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af0:fb9e:4ef9:24e5%9]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 02:33:18 +0000
Date:   Tue, 22 Nov 2022 10:10:13 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     <isaku.yamahata@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        <erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v10 035/108] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Message-ID: <Y3wvhWyIKNzczFov@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <f1c9996fa4f4bc71b3feee8407d247aeabb8968e.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f1c9996fa4f4bc71b3feee8407d247aeabb8968e.1667110240.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR02CA0135.apcprd02.prod.outlook.com
 (2603:1096:4:188::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL3PR11MB6505:EE_
X-MS-Office365-Filtering-Correlation-Id: 188bff2d-fadb-45da-dd00-08dacc31ea8c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +GEJvxkVkPZxSJ1aUruyO4wkUq4Ym0QaLs5xjvZPH3lJP1/AmpV3UW7jsDpyqx23i0LMCK4wu/Pcg2I11o/s+3gpOmQhwkNU6pW1hg6XnxWFrpa4sYRy3FZI0O8hHPl+FZPcOvtvV8nahL94+2yuFojYzHBGsNqgJvu48aVueOTlYFFY5TSaqK1zvzocBiOwTJ6Q/LBrknvudei2HXZ1Rs2nvBYMGTdDDr8LjOTTOGNEFPvlc3BwgNUyk2LpwLiI8pPcooJM00GdjgCdkR65ocwNms0NSRz/iSaaKRrsiQArGocVJOXatOgId4FzX6a7aHoKgS8Ox0P+X+KPjY6YQdJevF+TXTOcO7Zh5TXRPkV/vDATzs76ZPsrQe/uXLVPCOFFrt2ilIStnrMIYLRGBw1qkO0tHJsiNUFVnqxQvrIgoffL1TUtnnygKfuI2iteittqxQk01R+62NvlerQpM+2VAYM4jPzC9GFJhGqrtHDb5ktjautfs1QBcaNkeGsnKoYsvXyBJFxhCxqAIkdUcONWjqn1xSsSJUODu25dDpWaeAw+WnCbMBrRRvHfPZEJ7X7alWUFuHKa2atxevmwvZ3uSRE5LlEhQwlkeBF9pZY9YOel20E38uFYYlluuuaefZW+006sZ54W3VL6uyHTYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199015)(107886003)(6666004)(8936002)(34206002)(6512007)(478600001)(41300700001)(6486002)(6506007)(26005)(5660300002)(3450700001)(2906002)(186003)(82960400001)(38100700002)(83380400001)(86362001)(66556008)(66476007)(66946007)(6636002)(316002)(54906003)(4326008)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gknd8tKm/SoKjVSrSCZbJ5fDx0/etI91eRLBMCSTtZ9HVEgCUdWR3hlG3xVe?=
 =?us-ascii?Q?XtQoElpioggG5hTb3KjlOQ1ECQR7p1UrtdMer5jKLy/PJISEI4ZC0TGira6o?=
 =?us-ascii?Q?EqrxEKBLaxo0dmJCLfFQ9BbVP1PVDJeBRcNQnAhJyTNIroXAo/l+FsIn+vLC?=
 =?us-ascii?Q?0Y5o0Mnpg5fXlsTUa7+zhjD3XF9Tmj+IqBBHsRSDrmw7kDNoLRzf/ScAJCrX?=
 =?us-ascii?Q?e1dtfoe1PVzq+gj/sbrxBYZm/KJ8mG2et7llpwRVWiv/5OMDHsme/Mi5+QsI?=
 =?us-ascii?Q?1LOkVtxS56yWHDXv8YPo/dYCA9ujIGzcggTL0levJR3qUr5tmHdUotAEjQEz?=
 =?us-ascii?Q?IJywoFQW+BaniXvtR9lsWwpw5vyYZ/tYEvsvvwjfDc8e6hzHjIfwS3C3jny2?=
 =?us-ascii?Q?U07Qd5qDMXCq1dMhNz7slpd1+5OQoqzQPeo9+hqEDcqQVERZ/7kmxCAhgZVr?=
 =?us-ascii?Q?uQHS7Bc/JUmGYBxhvtr6+bRBNrHT151KA4Avtsrjvvv2gS9PS2XIWo23duki?=
 =?us-ascii?Q?R+JNKlXTqnoVg5QyvoKvjKSi/i6GGzB2ZMhDvT3QaQfXm15gxbrZ2SZ0VLmE?=
 =?us-ascii?Q?sQzl9mr4rZOgAHHRUlPf7/1LUydJhC0q25c4VGmIjmsbEVbhwk72BsiNzktr?=
 =?us-ascii?Q?g09R7yExCVRw2C7+8MXhKmQgnO1TV3uOFtbdupql2lbhDEN2+dxrbVr4eaWB?=
 =?us-ascii?Q?HvfqDpWZnGSmg7MtJztTWgR6kuc7oFR82pjhdOXDEX7YtcX+VliQyiKgSNyv?=
 =?us-ascii?Q?deNCw1xnjsh3fJxem8fL6sdHnsjjsAXjddP28ck4SazuUFtXDOETJFrekJhJ?=
 =?us-ascii?Q?HisbG9sEn2PKUBXRQDjZls9n6UtB4VeHopAqDBgSIdHctrmJVR9P7nZFcJ9r?=
 =?us-ascii?Q?N9jxII+HK1zZ+9Mq35DdXTTu/h4HjLdMFINKhWLIV5SBxWA3pW5vNXnCF7cA?=
 =?us-ascii?Q?uVaH3rRExtvF44LTBUvY/f+PUdfoarp0c7oMk53UKVVV5eg2ZHWB6R3DaBkn?=
 =?us-ascii?Q?guxWVXLKCX0cTw/PZvLqR8AfQeXOSmx5j5d3atzcbFbdAtH7PBG0SbRljf8C?=
 =?us-ascii?Q?PHqisfmp9uYoS1FcXacAYw1lsPesYivZnN0FB1jqKacwfxhZMd67KU1WStsn?=
 =?us-ascii?Q?eWsWTeLPhhd8yPjxgrRAguSO4RsfQzPegOQ00rLD8wtZFvYs4uvl4V8xi0kN?=
 =?us-ascii?Q?M/A4oaWEO8fZb8XtKFcfdivdN6UMBWpgtZiO0Fr+jWKRohYgaFnEEeC12WJ6?=
 =?us-ascii?Q?j5BW7wqFLmvvJYgKM3U/b4wzBWsIQJwtWiMemd0H2CNQM8y4/skAN13+VlDR?=
 =?us-ascii?Q?bHfV3U1yE0ze2PRMCdcziCkLb5YzykMcO3/zf6cw3tPvh1mPTAXgH1WkGxoM?=
 =?us-ascii?Q?Efde6Fi9YNETIziPGVDO4kZtOPNPCufXC/7FCU5h2b21MOYQ70RA7VTHjz5o?=
 =?us-ascii?Q?wCRxfIURdZd4QPjn6dgrpMoJgF38KPbXkoitDlovwnbWLnlF8kqGP36+/Flq?=
 =?us-ascii?Q?KbS/+qPwDu9EHg7bCGXUVeNlEwfQe0o3vUiVjIfEa5rjoTCyD8v2uoQ0GS+R?=
 =?us-ascii?Q?My4RpMDUbuWLQLRBwMQlvF7ppe7FzGKahcKTuAmC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 188bff2d-fadb-45da-dd00-08dacc31ea8c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 02:33:18.8785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yeZeEEoUAzor/uKMGr9P10AEZJBuQOMn7dBmWzqoYvCBMmr4y5kQms+IeVoYEa4Hm599m1PsLO8rW435BZ2Rzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6505
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 29, 2022 at 11:22:36PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX will use a different shadow PTE entry value for MMIO from VMX.  Add
> members to kvm_arch and track value for MMIO per-VM instead of global
> variables.  By using the per-VM EPT entry value for MMIO, the existing VMX
> logic is kept working.  To untangle the logic to initialize
> shadow_mmio_access_mask, introduce a separate setter function.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu.h              |  1 +
>  arch/x86/kvm/mmu/mmu.c          |  7 ++++---
>  arch/x86/kvm/mmu/spte.c         | 11 +++++++++--
>  arch/x86/kvm/mmu/spte.h         |  4 ++--
>  arch/x86/kvm/mmu/tdp_mmu.c      |  6 +++---
>  6 files changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3374ec0d6d90..a1c801ca61d3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1171,6 +1171,8 @@ struct kvm_arch {
>  	 */
>  	spinlock_t mmu_unsync_pages_lock;
>  
> +	u64 shadow_mmio_value;
> +
>  	struct list_head assigned_dev_head;
>  	struct iommu_domain *iommu_domain;
>  	bool iommu_noncoherent;
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index a45f7a96b821..50d240d52697 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -101,6 +101,7 @@ static inline u8 kvm_get_shadow_phys_bits(void)
>  }
>  
>  void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
> +void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value);
>  void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
>  void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e7e11f51f8b4..0d3fa29ccccc 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2421,7 +2421,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
>  				return kvm_mmu_prepare_zap_page(kvm, child,
>  								invalid_list);
>  		}
> -	} else if (is_mmio_spte(pte)) {
> +	} else if (is_mmio_spte(kvm, pte)) {
>  		mmu_spte_clear_no_track(spte);
>  	}
>  	return 0;
> @@ -4081,7 +4081,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>  	if (WARN_ON(reserved))
>  		return -EINVAL;
>  
> -	if (is_mmio_spte(spte)) {
> +	if (is_mmio_spte(vcpu->kvm, spte)) {
>  		gfn_t gfn = get_mmio_spte_gfn(spte);
>  		unsigned int access = get_mmio_spte_access(spte);
>  
> @@ -4578,7 +4578,7 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
>  static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
>  			   unsigned int access)
>  {
> -	if (unlikely(is_mmio_spte(*sptep))) {
> +	if (unlikely(is_mmio_spte(vcpu->kvm, *sptep))) {
>  		if (gfn != get_mmio_spte_gfn(*sptep)) {
>  			mmu_spte_clear_no_track(sptep);
>  			return true;
> @@ -6061,6 +6061,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>  	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
>  	int r;
>  
> +	kvm->arch.shadow_mmio_value = shadow_mmio_value;
>  	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
>  	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
>  	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 5d5c06d4fd89..8f468ee2b985 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -74,10 +74,10 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
>  	u64 spte = generation_mmio_spte_mask(gen);
>  	u64 gpa = gfn << PAGE_SHIFT;
>  
> -	WARN_ON_ONCE(!shadow_mmio_value);
> +	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value);
>  
>  	access &= shadow_mmio_access_mask;
> -	spte |= shadow_mmio_value | access;
> +	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
>  	spte |= gpa | shadow_nonpresent_or_rsvd_mask;
>  	spte |= (gpa & shadow_nonpresent_or_rsvd_mask)
>  		<< SHADOW_NONPRESENT_OR_RSVD_MASK_LEN;
> @@ -352,6 +352,7 @@ u64 mark_spte_for_access_track(u64 spte)
>  void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
>  {
>  	BUG_ON((u64)(unsigned)access_mask != access_mask);
> +
>  	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
>  
>  	/*
> @@ -401,6 +402,12 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
>  
> +void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value)
> +{
> +	kvm->arch.shadow_mmio_value = mmio_value;
> +}
Also make enable_mmio_caching to be a per-VM value?
As if the shadow_mmio_value is 0, mmio_caching needs to be disabled.

> +EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_value);
> +
>  void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask)
>  {
>  	/* shadow_me_value must be a subset of shadow_me_mask */
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 7e0f79e8f45b..82f0d5c08b77 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -241,9 +241,9 @@ static inline int spte_index(u64 *sptep)
>   */
>  extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
>  
> -static inline bool is_mmio_spte(u64 spte)
> +static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
>  {
> -	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
> +	return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
>  	       likely(enable_mmio_caching);
As above, also turn enable_mmio_caching to be per-vm ?

>  }
>  
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 1eee9c159958..e07f14351d14 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -580,8 +580,8 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  		 * impact the guest since both the former and current SPTEs
>  		 * are nonpresent.
>  		 */
> -		if (WARN_ON(!is_mmio_spte(old_spte) &&
> -			    !is_mmio_spte(new_spte) &&
> +		if (WARN_ON(!is_mmio_spte(kvm, old_spte) &&
> +			    !is_mmio_spte(kvm, new_spte) &&
>  			    !is_removed_spte(new_spte)))
>  			pr_err("Unexpected SPTE change! Nonpresent SPTEs\n"
>  			       "should not be replaced with another,\n"
> @@ -1105,7 +1105,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>  	}
>  
>  	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
> -	if (unlikely(is_mmio_spte(new_spte))) {
> +	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
>  		vcpu->stat.pf_mmio_spte_created++;
>  		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
>  				     new_spte);
> -- 
> 2.25.1
> 
