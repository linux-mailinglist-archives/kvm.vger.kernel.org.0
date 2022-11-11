Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACC2625108
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 03:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbiKKCsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 21:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbiKKCrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 21:47:45 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0132B7B20F;
        Thu, 10 Nov 2022 18:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668134495; x=1699670495;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=B0mtmyLE0adFFQbeHdd+IlzOgsWO3mDVTGK4pb75+yw=;
  b=UIJrYG7ZthKyelyluBV1wpCoHvuYoUtC+rz9oUDFJZQyyrhK1q9k85M9
   RPbfXTfKm8guEO1IkSSZr1d7KVSzdkUe/29I7W+GsVKoPJgwIFUmB9tyJ
   SFnK8ZO+ugPwqqrT1tDvE2O3vTu65wra4D2ux8LPHnl8v9swRx8nZE2EC
   Fv/IatC2SugbsetO6u/6sQ3cenyMVGdBiZHINVKT5+liQrLN4XxpS/a9H
   6Tj0tyCZ9fJ77BDA48RygHoDUZOSZO9ozA/2VF+p0b+DpjB2QmyrEoJdj
   WbJb5too6uSQ3kKj+Bb3k6YWA3whqmhJqveZVG52wJJs15AM9C0SMRCCO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="310219619"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="310219619"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 18:41:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="743120727"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="743120727"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 10 Nov 2022 18:41:10 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 18:41:09 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 18:41:09 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 18:41:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmW9UgF5LT5Gft6Oo2iCm6+Bo0WWcfVdvBKJwsGfL0ymtMnWhkgKsf5cR2deMmFPCOoavtXriGy8Q/GWBq91mkrni4skl9UIC9uqUmFIz2ONm0q9dpprOOqyUc1q2FHR8kVW31pJaWmdtRhig2VsYijGxBDWbWi5idJUidjbNTtjSnCJXERiwxWB/n+vhc7GETjyFWGpwBaKnV8EmsARHdtpdCcemEKMukJC1CxeHgb+BYW3/l0107yF15KnIpWcBUs+xiXw2b97X4ZNH+rEF/qrE6SLCp0lzRRZm7RWsCjW6wCiCmup4QIcW/kNEv4HfioGIJxYNlBB5U4QfNSdXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7gb+hXHEZYRA5MpZlryDB4rXwvlXBvAuIgRohAYCOXI=;
 b=PjM4228sTBZ+zeaUSfq52QROjoGRFBURkcWVcOhC0ZiclcmLWjDpitkA4SYrcCKg1ZIem/friqdKjgol7Ci56ov5zlDFofcGDV2Qia/MmHNQwXpbIoZ5iQ3kYi0VsHLivDWroqeYvgw9Qaucat15qmZ4ZiF6tTNqCNzR+r+qexadxyX5XVAyPU1oWliW/111HWfKIWofhuDct12//1GnBJgzHOUgqJP7n02o17Xq2hcCVLlrnxJK2mYfM+GNY2wkrXSfY16lLueGc/4IcJZuUJOpGE1N20K4VTmsiI0AGo9pEBQWIfRCr2QQNUp/fEU8LMKZ2fKxSsRLqWQhEeRoMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6213.namprd11.prod.outlook.com (2603:10b6:8:ae::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.13; Fri, 11 Nov 2022 02:41:02 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f%7]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 02:41:02 +0000
Date:   Fri, 11 Nov 2022 10:18:13 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Don't rely on page-track mechanism to
 flush on memslot change
Message-ID: <Y22w5XEhv4hU2wPc@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221110014821.1548347-1-seanjc@google.com>
 <20221110014821.1548347-2-seanjc@google.com>
 <Y2xheotNkWPVKsIl@yzhao56-desk.sh.intel.com>
 <Y20wDoCz90jhxrU6@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y20wDoCz90jhxrU6@google.com>
X-ClientProxiedBy: SI1PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6213:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d9cc8ad-b9ec-4c3e-7ccc-08dac38e2c3e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FAMOfjJ7MdnWqVpDsjPdwZJEwf8JxIRnLInNX3XkGHNyPkcu248fGRDljtfhiln1723rPfsHhONl71Z2k3QpTVzk89t/AuEIkniuTSMidIXF2XN8WzcuFpjjk2BwAWidvJlS+aB7cSJdIegg8bgMgTleX8ENjOzxMwrC4kUdcglqg1J67idz6JBkzFNzA3qU8UcOfHWFGE8kXMVHwvCsFAY/pBKcnxkf4TVbMUGnAMZjurNK+2ZPKnrrjkKR4Lp6So7+pDDA6AaHhc4QSPMqjgu1NJJzXHnWDZaLzFsqCIgKfuaycRUzU7KFyrJRXxRnjMjiEfUOprZym7/pQVBWUGEC5UllW+TyqgXYQGh1EiL97Hlmw+1uVx8x/rldEpdhUqFMjPulxssvHaSHrxwPGE7saRPciQzGzSIh8d4B5UTLu3eMKtLHecU60Mf0NAcW4RSiaJpFIVwq8IAAWDco/ZYp8kwnC17mgpUuM3MfQZdSklhml8XkbQkNlm6CXXgjA7tWHiuew6INykKCctvhq+2E0nIsPrknsYd2D3KVZhyIXt4EhmYnCOnWRV+g1WNygtKhdA5j4UymtEvWbV8umsQTnehFkPTynUUnOQ7n5VhQjDa37MU19wbfu8F8CjglKcQjJ1WWAXvOB9CHO+/KA8v2/r+n9B8Ysy6S5Zs9k0163WqtCm8N/ID6uiPIdfp7KcTl+IIgjAOyuEnuWjOMlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(396003)(136003)(346002)(451199015)(186003)(66556008)(66946007)(8936002)(5660300002)(41300700001)(3450700001)(38100700002)(82960400001)(66476007)(4326008)(2906002)(8676002)(86362001)(6512007)(26005)(6916009)(316002)(83380400001)(6506007)(478600001)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uVzGqwen5nfOkK7zRq9b+3yBTW1HkKzErrC9rMVbqq6hkU6z6si+ALtqpvyG?=
 =?us-ascii?Q?Z3k1rTrL7aoWbYC/08YjauZn+eK4nSuZwLS2UrXT978JE4u9h6s/n6j+0ezk?=
 =?us-ascii?Q?cfsqGEOP3WtO232mTL4d1THUhJWK8HIw7V4oXNAcUJjORqf/fTAy7Yg60j6r?=
 =?us-ascii?Q?HO9huI+lh0o+1wAloupWo41ln8kVEr+vjzBn5SS898VVxLV6b1YrxcTFWHYE?=
 =?us-ascii?Q?0zkkKqzTGYqatXvfkQfDKKkAbO82cev9bnYsCWhMCc69grwCCo4wYgG2UGwU?=
 =?us-ascii?Q?w5OhsT0p67DOX/qvPq8QR6ls1wYuc8ZKeYk6vCL64jG5S/sYCXTPLLIwlkd0?=
 =?us-ascii?Q?BHn1p/LljuOBw0Zo0eEyqHSRqcnOdz98i3YqNCPf2n9CxR+pdmTviePLwLzN?=
 =?us-ascii?Q?IXV0pOE1EzPnAwyhzJK9IBTZNRfuODTu0pd1WlbXUG9gZSrBA1bGl4NEeKUj?=
 =?us-ascii?Q?vvlSdYs8yFOmWzRIbMK/D1j3cqSJgh4teAIuEhQW4IcDJUhW0CSbqnkfZbK2?=
 =?us-ascii?Q?p7U8TWCI25rq5HKP/2zm0UJEtxASAw3vDa6w5aeH1rp0HSPOmsqcrtS9kDsq?=
 =?us-ascii?Q?oGmc+d2sAe8F3GVHIB+jYNRs7mOYptQKODMDHXq8dKzH8sq7YV2AWsCu2mA9?=
 =?us-ascii?Q?Dp6PEBPnaj3Z/ky7ZdWIGP9RVF0yrmfOhRAEzR2RuiQRb0GuSoLkKzaPEcUZ?=
 =?us-ascii?Q?5k/Qk4TJIQSDHjtp28xGFmLomJLBXpCQcymvjfoEJ/tFpmnNj+/D7BnohSDS?=
 =?us-ascii?Q?rmv7dm4vDbrBgijbo3vUp2s+U78zz9WDvbsjpZf+4wT+9RN+A8f/cpyaiyED?=
 =?us-ascii?Q?WxM465qvKYf2TPIpwJcrRT+OboUuDA8F3sNr3GANpeQ5SvavYebZn17mL2w/?=
 =?us-ascii?Q?zaknVrFlxs9hX+Hq6MfIyOyPT4SUy2CUIREOdxfR44M4nF6j1c5ReNUW8++k?=
 =?us-ascii?Q?vk+XCYvWQ7VSjNxsellLTt/4OuYhErXM4NQQc3PoBXkLE5ZtpB8FFTA3tel4?=
 =?us-ascii?Q?GgPy4kN2bX1huF6bfj+V/BkAs0mofI9CGkIM7NEY2xSr2OlO2elZ5JT7p/Px?=
 =?us-ascii?Q?OGUPIdDzMNFK8Vhj7KGYH6ZcLmlLztkuhf6MelAIN+7RT36DhGZC4W/AFHox?=
 =?us-ascii?Q?QsUzErz7/ecpcCAP3tRNhJrz3ES9f7N+DnBCEj2HYbcL7p55K8Cj1gScthrf?=
 =?us-ascii?Q?6oO+x62stx/cJgnsCCfcy0wNZEyeibI53fhyql9O5MjUFWAcbwqQYaBQoSbn?=
 =?us-ascii?Q?2DWMdhPgAVQ8UQEPvCbUIEvhPsS8TIkLNDMdzjwIZWta03DIOoLUaKeaRbwT?=
 =?us-ascii?Q?xpgRk5tO/SEOHRmk0hnH5Ut9Pz3M6Mnu/W5ZihOZxTH+uyN1r/RXoWavDmNn?=
 =?us-ascii?Q?BlEJBeIJqMPT3Uc9RxLghtQ10cVvYa8VwhJGCx+u6sRsMQlzZU/sjAB3MsMk?=
 =?us-ascii?Q?vqubvKqgkIDlYD4KwCaLtfSy7GhNH2UNs6feAGHCXipdyk+5CDrgKt8J59g7?=
 =?us-ascii?Q?O5S8nIi5TMipc+7eZ0Q3b5tCbxpqRzwOqrEVTXhdkNn1lWsWg+V2irf8JNzX?=
 =?us-ascii?Q?Odh1tJKzISYqoe2pn0FDGfD9vTrTKO8C7/O6u/2+9UTqWM6TRpVIbslA1WOq?=
 =?us-ascii?Q?eA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d9cc8ad-b9ec-4c3e-7ccc-08dac38e2c3e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 02:41:02.2661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G2WlMUdtPYDf6QskrPioAdfDNYcXwXiCDDG6a6ZxsNMmpJMhpZjpS/RLWhmyiucLwOuZh43p1uOy8P0UpMLrKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6213
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 10, 2022 at 05:08:30PM +0000, Sean Christopherson wrote:
> On Thu, Nov 10, 2022, Yan Zhao wrote:
> > On Thu, Nov 10, 2022 at 01:48:20AM +0000, Sean Christopherson wrote:
> > > Call kvm_mmu_zap_all_fast() directly when flushing a memslot instead of
> > > bounding through the page-track mechanism.  KVM (unfortunately) needs to
> > > zap and flush all page tables on memslot DELETE/MOVE irrespective of
> > > whether KVM is shadowing guest page tables.
> > > 
> > > This will allow changing KVM to register a page-track notifier on the
> > > first shadow root allocation, and will also allow deleting the misguided
> > > kvm_page_track_flush_slot() hook itself once KVM-GT also moves to a
> > > different method for reacting to memslot changes.
> > >
> > <...>
> > > @@ -6021,7 +6014,6 @@ int kvm_mmu_init_vm(struct kvm *kvm)
> > >  		return r;
> > >  
> > >  	node->track_write = kvm_mmu_pte_write;
> > > -	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
> > >  	kvm_page_track_register_notifier(kvm, node);
> > >  
> > >  	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index e46e458c5b08..5da86fe3c113 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -12550,6 +12550,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
> > >  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> > >  				   struct kvm_memory_slot *slot)
> > >  {
> > > +	kvm_mmu_zap_all_fast(kvm);
> > > +
> > >  	kvm_page_track_flush_slot(kvm, slot);
> > Could we move this kvm_page_track_flush_slot() to right before
> > kvm_commit_memory_region()?
> 
> More or less.  The page-track stuff is x86-specific, just move it into x86's
> kvm_arch_commit_memory_region().
> 
> > As KVM now does not need track_flush_slot any more and kvmgt is the only user
> > to track_flush_slot, we can rename it to track_slot_changed to notify
> > the new/deleted/moved slot.
> > Do you think it's good?
> 
> Given that KVM/KVM-GT have never propery supported the MOVE case, and (IIUC) that
> there's no danger to the kernel if KVM-GT fails to write-protect a moved memslot,
> I would say just change the hook to ->remove_memslot().  I.e. even if the memslot
> is being moved, simply notify KVM-GT that the old memslot is being removed.
>
I think it should be good.
We can refine the support of MOVE later after it really happens.
Will do it by following your suggestions and based on this series :)

Thanks
Yan

> E.g.
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5a2821ca03b8..437e3832e377 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12566,6 +12566,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>                                 const struct kvm_memory_slot *new,
>                                 enum kvm_mr_change change)
>  {
> +       if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> +               kvm_page_track_remove_memslot(kvm, old);
> +
>         if (!kvm->arch.n_requested_mmu_pages &&
>             (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {
>                 unsigned long nr_mmu_pages;
