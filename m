Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB236FE8D9
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 02:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbjEKAku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 20:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjEKAkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 20:40:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98161981;
        Wed, 10 May 2023 17:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683765645; x=1715301645;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=PMt0CXghQI4X5jtXygo8SyK2Z+UFsu2Qj6RV25eG5O4=;
  b=AtJBRlKfrb3JM+LHFuW6ZFN7pFWpcrcqkzHZo3lPHcxHWW7mNIj6VErY
   mUrPUI5VMaxiPtlwxov9Sld/bfATwe4FFHAWm8QDp8jN8m/BI99KbYRM5
   PWGQGiLY/1ATuT9nHqumt4ufhBL2Zql7lVfwEgxz3ChChYL1xdpCgxOlB
   Zisb06ud/t62BzF5TmvjzQnUyYPibpMfFyxmFJ3XW9Qh5254L2Y6mcIrw
   i5ltsiRY2O6pNDt2Z6ByMU2/E7aNBiHC4VhuqGEVbOR87tfD3OlGdPD12
   khc3s1rdLM1c6Hs2wCouO/p9FNJLwNAnAHjmFP5ZtLOBfXSGddyPRkYnd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="330717649"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="330717649"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 17:40:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="677051840"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="677051840"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 10 May 2023 17:40:45 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 17:40:45 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 17:40:45 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 17:40:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqyyYriqp9zIl7Q0Wbq9VbE+mmu+BRR6E4SQfVO5wTUf7pHkuEwf5xrihkvZ4D5L65JrEWPLS/tT5Qx+SzDyad2Mafyol4vVjpaflsx1NwxYzz5A3xDGvLVpzmKBErMyTbunDrB3ezuCT0V7PLasWabxoqfRxFdTcCP3q+4UGmxzWRC723hb0zr53GA+KWpJSJc8pGULbzgsaEQZZHfbiLAAjkoV9z6cLUZPFKDaS9/11vHWmAL01XeO6tF+OZhXs8uUg3l7Vyjdu5iCCPMbFNf7pUYmJkRfFVmk1rlHINpf+Ae3Z6e9oEsgaaceO3pHfvZ1+gb1LzhIAB1JGuID9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5MxVJS3CEL5vuDnMIQzRfFvqX0TPaZD9v67LlfQ9MCs=;
 b=m/mNoeNnLXAFfFJE9ugrNouH6TfPN+6i7RO+oleR23y4RGkqeTNJujI6RmW94rnYALYoguBptqlRQRwCtbCd4qA9CV9UrIrdZjCk4fIKsqTN98n/ni6yRKo1i3+guOnkwRXiCVjim1har33AEMlgbmLqECTCvWcSP7lRFwty/ffHtPcqgiHEHcggv0BV+xQBVWZamTF5YHOCGjlgPeSPpqd6UnuyZjSiVLPqED6/9GLV3Qdlm7i1HRb8tiMbFlA67yKbhqkj77WvoWGVJi9DeJKdkuMmOwg7MTEqv2EtWznrUsxhnP7SwTyBVe8BhANkhngNMs/V07is792ItibWpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA0PR11MB4573.namprd11.prod.outlook.com (2603:10b6:806:98::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.19; Thu, 11 May 2023 00:40:42 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 00:40:42 +0000
Date:   Thu, 11 May 2023 08:15:39 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
CC:     "Gao, Chao" <chao.gao@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v2 3/6] KVM: x86/mmu: only zap EPT when guest MTRR changes
Message-ID: <ZFwzq/833QX3n9xc@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135143.1721-1-yan.y.zhao@intel.com>
 <ZFsuDWwoKRA0W2/j@chao-email>
 <ZFtPKLvblLcxPvZQ@yzhao56-desk.sh.intel.com>
 <99c982ed53f0dd7e0723f566b5527091b7e4e54c.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <99c982ed53f0dd7e0723f566b5527091b7e4e54c.camel@intel.com>
X-ClientProxiedBy: SG2PR02CA0026.apcprd02.prod.outlook.com
 (2603:1096:3:18::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA0PR11MB4573:EE_
X-MS-Office365-Filtering-Correlation-Id: 05ee3ea2-2b3a-4932-0366-08db51b8599f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1NDi3f9UdAdmHQqXCWKzxPeD7ViDikGYL1xRF/1LxxWYEmKtr1mvTiVG0UQXCoeUTikaXbsp83kMx484AbHTFfhtPTuhHuP+lZwrOez3+RUXMb8YTsb54eGQR5lt/tLDMHLvOlMoyFDKG6R03EvmB2cXsevsQtHuqE9HJ3AvlATdFyFA+jxLGx9xYyUyGg25a7oaZKJd5gxJUoPPyAuG9rBdbo+PeXi7AKKKhLJtgVvomiXBgHYWh1ZlK5raR0SeotDsIwCZARrifhN0FK2OMLqONDkPkX5/2TdhQFBBs//I6xRbgP2HxePnm5HJyoUJdPYgZfsn/GSzTRg61OGsbzVZ9UqExiaeUEpfQW/Y39uSZcUZj+sMZEj5p7STXluCoCvfUl2vvMI7IkYur/ijgGFOMwPgdD0kebNObDTFIcnXaj8HNAgH5oirYfGzNSHSJSmxwpNzo6+LYxQvyNAJwOna8Ik3JbPqC5y99/CQn/8T9PmYlJuazkf/o6qmHIt5J9OML8F+3rumZGyPoV+MyR6hAuN7QI92IZjGRpbAjuGS04qID/H9Rl0Mio43KSQm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(366004)(396003)(346002)(451199021)(82960400001)(38100700002)(86362001)(41300700001)(6486002)(8936002)(6862004)(8676002)(26005)(478600001)(5660300002)(6506007)(83380400001)(3450700001)(2906002)(6666004)(66946007)(66476007)(4326008)(54906003)(316002)(186003)(6636002)(66556008)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jSy9+xka8DZcQ587Vp+5Xlw4u6lcj5nPbrU3Qh8uC9MLOe9QGBsLSWkDFYTZ?=
 =?us-ascii?Q?yQzgKVvwA9xzO5qh10voXWImR1YwzjT0LcVY+JUZ5VzMTdWcjcc4IzkCT/P6?=
 =?us-ascii?Q?Co6WxWEvA841rZ/MG9GdcqA6Rf7Tisv6dfSrGmIiODFB3wiEhDA2R2dkhGgw?=
 =?us-ascii?Q?yQSR23oaabgYOplcQ7nLMw223ySC0rtxz+twPk8ZOKD4oA5yQCy8+tDizpXx?=
 =?us-ascii?Q?pdgCsKPZpbT2zGYUaHbT1S3IV3DJltMSCARcaGy2TvsqbG2Gl9JLn4d27Pd5?=
 =?us-ascii?Q?riKJo8ez6WNgmZiUqCv7qm4QJkT0GAIgIZrHoKsZZRvpzJPLAJvEZVfB8rBS?=
 =?us-ascii?Q?Y+OIJhijpovQBhK4d85D8kqJ3MZNzSTVSmBMGXFHITgxRDILLMRXoeN2KJJE?=
 =?us-ascii?Q?2njkRQEHukbJMeYEFLGJfuYGxc8dXsgee097+HZfGhJX/lCoeNIz6a2q+/9F?=
 =?us-ascii?Q?txNh7T5rzXJNokDwXE8RlsjxkFSBx2otpdxPKOUqAXA2A8rNx9MgJxenTfw7?=
 =?us-ascii?Q?c+GPupiRBL+RWw8MwwJeplgrp5zA/pD9Ad4Ghl1xGPfn2sR3r6xPQC6ADG9L?=
 =?us-ascii?Q?TA+VDbsponfaQmKqepRrNAZMwk0bti3g3vYShoGNsjjkfKhsSswRZLxW89gU?=
 =?us-ascii?Q?lb6/qH1ZnmCKRgNlLke9TzI0xWAlYUxVKa3CHnmFuAXzO03C40QjZb2oH0AI?=
 =?us-ascii?Q?A5tUuAkEKyZHAmHo5KxGak4Mz3BTJo1VAQnrqQCifyOm+JXRZ8js7lfj9V2o?=
 =?us-ascii?Q?R0S1ExSh7J/4Vn/CxzbCTCIv4fE+Wn+Ly+/n7U2nhS/cBBj6yMY/L7hjvXmT?=
 =?us-ascii?Q?DWfVjV+7wcgXmTA5sa56fc7ikiOR3gM9Yv/B0JL2kBD9X1EqH2sbI6MEUVK3?=
 =?us-ascii?Q?6Y6WuvheBig9BPSou7WFegY8KA30yPc/nNS4hd6imiusjgseANxG8rSn4oG/?=
 =?us-ascii?Q?cqJsEy/Zhpt/I4mCvH6vePKqpm0xNWapXLq4J+eg88kNE2uUPrF4fwECEr30?=
 =?us-ascii?Q?xwNdgZO7n9zo99IeS7VYSVnp+Ahta9VPblOSOOPZl51YonHL6/hxbBHull50?=
 =?us-ascii?Q?J1wGKZZOdEaw8SxIctglxFEjOYMF9DWwgtaYcFTBnZzNIdVZKTS8nQ0hMQo+?=
 =?us-ascii?Q?wiSEOSQ7Ti9zP6MQfYbmKBaosceY8+MpFFuz0WhuLp2NCrgQsO9j2eAruncn?=
 =?us-ascii?Q?MXquTn3QaRzQ6hAkyoPB6Fnaif69PCNDYR8S1qjIGj6zC90nPc8UCcfuEMcr?=
 =?us-ascii?Q?84GwUIdcSWZPPVR2Z4fIviyIN9rfeMF7JbSTMG/uaZWW3Z+rIldBQHpTbQ0C?=
 =?us-ascii?Q?Q4PZi4o9Sd7dcqo4kduGB7cI0xvXqqXl+iPWAqJmKmaL5mbwa6kGNp/RcIBA?=
 =?us-ascii?Q?78hRsxmJTyT4rY5FoCuikAO7pWIzmvBT7cowgNyHDXTaRPELAyvEzlELoM8U?=
 =?us-ascii?Q?n5KjkbozjriR+DuYVQVl3d8qa5EQ3y1AzVYwOBXSmpH8yKtdFQYYXzv7AA/d?=
 =?us-ascii?Q?R0hxvtKg0iarifZ5WAtcb6dMs04mmRCKSq5utpyhNfvy0ZzifVpbI4mnWV6T?=
 =?us-ascii?Q?Sldsimzk4rznTx/k+HqVtBuYB9dGhuUggMDjypjd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ee3ea2-2b3a-4932-0366-08db51b8599f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 00:40:42.4436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W7moEVmvhDDFi6JzOxjMjmmgG00TBF3aUYP5Z7/5dGpYN2+MS6rDvlEXrx0l6m9IyVaDU/Lk3gC9600Y+H40aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4573
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 10, 2023 at 06:54:51PM +0800, Huang, Kai wrote:
> On Wed, 2023-05-10 at 16:00 +0800, Yan Zhao wrote:
> > On Wed, May 10, 2023 at 01:39:25PM +0800, Chao Gao wrote:
> > > On Tue, May 09, 2023 at 09:51:43PM +0800, Yan Zhao wrote:
> > > > Call new helper kvm_zap_gfn_for_memtype() to skip zap mmu if EPT is not
> > > > enabled.
> > > > 
> > > > When guest MTRR changes and it's desired to zap TDP entries to remove
> > > > stale mappings, only do it when EPT is enabled, because only memory type
> > > > of EPT leaf is affected by guest MTRR with noncoherent DMA present.
> > > > 
> > > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > > ---
> > > > arch/x86/kvm/mtrr.c | 2 +-
> > > > 1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> > > > index 9fac1ec03463..62ebb9978156 100644
> > > > --- a/arch/x86/kvm/mtrr.c
> > > > +++ b/arch/x86/kvm/mtrr.c
> > > > @@ -330,7 +330,7 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
> > > > 		var_mtrr_range(&mtrr_state->var_ranges[index], &start, &end);
> > > > 	}
> > > > 
> > > > -	kvm_zap_gfn_range(vcpu->kvm, gpa_to_gfn(start), gpa_to_gfn(end));
> > > > +	kvm_zap_gfn_for_memtype(vcpu->kvm, gpa_to_gfn(start), gpa_to_gfn(end));
> > > 
> > > I am wondering if the check of shadow_memtype_mask (now inside the
> > > kvm_zap_gfn_for_memtype()) should be moved to the beginning of update_mtrr().
> > > Because if EPT isn't enabled, computing @start/@end is useless and can be
> > > skipped.
> > 
> > No, shadow_memtype_mask is not accessible in mtrr.c.
> > It's better to confine it in mmu related files, e.g. mmu/mmu.c,
> > mmu/spte.c
> > 
> 
> No, I think it should be shadow_memtype_mask.
> 
> Conceptually, after commit 38bf9d7bf277 ("KVM: x86/mmu: Add shadow mask for
> effective host MTRR memtype"), I believe in update_mtrr() the check:
> 
> 	if (msr == MSR_IA32_CR_PAT || !tdp_enabled ||
>               !kvm_arch_has_noncoherent_dma(vcpu->kvm))
>                 return;
> 
> should be:
> 
> 	if (msr == MSR_IA32_CR_PAT || !shadow_memtype_mask ||
>               !kvm_arch_has_noncoherent_dma(vcpu->kvm))
>                 return;
> 
> Because the intention of 'shadow_memtype_mask' is to use it as a dedicated
> variable to represent hardware has capability to override the host MTRRs (which
> is the case for EPT), instead of relying on TDP being enabled.
> 
> That being said, to me it's more reasonable to have a separate patch to replace
> the '!tdp_enabled' check with '!shadow_memtype_mask' in update_mtrr(), perhaps
> with a Fixes tag for commit 38bf9d7bf277.
> 
> The kvm_zap_gfn_range() should be remain unchanged.
> 
> For the problem that shadow_memtype_mask isn't accessible in mtrr.c I think you
> can include "mmu/spte.h"?
> 

I agree shadow_memtype_mask is the right value to check but it's indeed
internal to kvm mmu.
Including "mmu/spte.h" will further include "mmu/mmu_internal.h"

What about introduce kvm_mmu_memtye_effective() instead as below?

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index a04577afbc71..173960b1827d 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -254,6 +254,8 @@ static inline bool kvm_shadow_root_allocated(struct kvm *kvm)
        return smp_load_acquire(&kvm->arch.shadow_root_allocated);
 }
 
+bool kvm_mmu_memtye_effective(struct kvm *kvm);
+
 #ifdef CONFIG_X86_64
 extern bool tdp_mmu_enabled;
 #else
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2706754794d1..ff7752d158d7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6288,6 +6288,10 @@ void kvm_zap_gfn_for_memtype(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
        kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
 }
 
+bool kvm_mmu_memtye_effective(struct kvm *kvm)
+{
+       return shadow_memtype_mask;
+}
 /*
  * Invalidate (zap) SPTEs that cover GFNs from gfn_start and up to gfn_end
  * (not including it)
diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 5ce5bc0c4971..b6bd147d22a0 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -313,7 +313,7 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
        int cnt;
        unsigned long long all;
 
-       if (msr == MSR_IA32_CR_PAT || !tdp_enabled ||
+       if (msr == MSR_IA32_CR_PAT || !kvm_mmu_memtye_effective(vcpu->kvm) ||
              !kvm_arch_has_noncoherent_dma(vcpu->kvm))
                return;

