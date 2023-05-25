Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A47E710A3D
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 12:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236310AbjEYKjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 06:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjEYKjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 06:39:20 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C40E6;
        Thu, 25 May 2023 03:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685011158; x=1716547158;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=PCcKkxgoC/YwAqVHqGYbQdcbloRTTrYNZ6DDgypS158=;
  b=N3krzJopeojtMKw45konZmRxVRt6HrFsi/pJ4l6zAEwtxLU/duqSshAd
   JvfIHTNIbeMj3lIeEiQZN+M2dDycLWkvKxUC+/SJQGvZA4099RfFspaBb
   n3cTAaX35dN5eDLuwQ2Nezbye10Ca2yQXIn5gNrcPl0fpLlNW8+ehnKNj
   IlsLHgOqA/79zDnAcKnUScFLonEq/NfRzdIoLSGcHMrd6624+si+rfb/P
   LrotAYgVVR4BQeaCqANcRO/sACwjg2EFGaWvscHSWhp1Sh/UrWwnO/9MS
   fSRsF2qYMK0hfBI0LzKsy/v6aN5uRO5yte8VdR0r0XgjFZcUQe5kx4hX9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="338426998"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="338426998"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 03:39:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="849154765"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="849154765"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 25 May 2023 03:39:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 03:39:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 25 May 2023 03:39:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 25 May 2023 03:39:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLAf15HvSOoK3LoYDIe3MkxNMRd+jwAC0DNCXtzbcRr4gmIyBr/Du9zBEDENAZF4U6MCIVb+WyTPyL8YEBwJcPtlXDONJW3iYdx0qdYQ/gumLST6TNGLPqGmRSt8ncfzJrfyeJ+AD6pUqA7Wznkoo7y3m326GYYBtE2QO5tpAwYEznRuwSPRj/JmUuCPAJLMVKx0KsPxYWfkQZwPeidhGQWQn++oi31UMlbyIyNT+BXnPcyhJvoQPGjbWdcauE8JRVdQ6xLsW1S9Z/pDbdI2a4JwTY/N7OxTF+DWbDV/IwA/lLvYQksEN5eqneSA9UrMC8m3DFq/rGheQLOrtyxnNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jAR6SNjaqHENYDDnb7HwdkSkLz9R7I4vfYEAwGFPTuo=;
 b=a9LzT3vCQhP/dCiixEv2k56FuqgybPOKAomU4qs2Vpjfh4NJ0Dhfm/PDyREhJKsoVyBBZuAcYSmHjmauWdPeiuPGZ5PhmBFxPIvVsuQ8j4fqsV7bDO913x+amNuJ11S+GqQrXFWdOvN4Ll94DaZ+RcL8m+/wybnySDO0mWbV+7XwRB1Ve5/1wwBoj1NjUv8BQdFSd5dT/EAigLqfic8Pt750fd41ncMqgHzbh2xKLWQmBeFn1bfF29G2CW3hHHwB6Zbs0CNsKq+gsmXSvNRtI84/Fn63zDZhKwl7QL1IACYkgvvSBxNXljknfCgJK240J3eLcXtx5Jjk+/9H155Gvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6331.namprd11.prod.outlook.com (2603:10b6:510:1fd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Thu, 25 May
 2023 10:39:13 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af48:a141:6dd6:25e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af48:a141:6dd6:25e%6]) with mapi id 15.20.6433.017; Thu, 25 May 2023
 10:39:13 +0000
Date:   Thu, 25 May 2023 18:14:04 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: add a new mmu zap helper to
 indicate memtype changes
Message-ID: <ZG807ECX4TeBcE61@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135006.1604-1-yan.y.zhao@intel.com>
 <ZFsr9TynkA/CyPgg@chao-email>
 <ZFtQeLNuXP6tDMne@yzhao56-desk.sh.intel.com>
 <ZG1DhSdhpTkxrfCq@google.com>
 <ZG10zi6YtqGeik7u@yzhao56-desk.sh.intel.com>
 <ZG4kMKXKnQuQOTa7@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZG4kMKXKnQuQOTa7@google.com>
X-ClientProxiedBy: SG2PR01CA0178.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::34) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6331:EE_
X-MS-Office365-Filtering-Correlation-Id: df3853f3-2cf0-4deb-c112-08db5d0c479c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AN+xd6q4tYTsTDwhnhHAE5AS3bNQ3u6/PAPHi+AurH420X30O1TqNFeFL0V4ITDxVtglVThwiI9vm857fUtCfL//oIAH48qcK+ZyVPOmXyJZsDEkOz+5cMYN+svu9uiQAhZmRSMOS0AnkLLUEO2QOv+LaPwekhb9C6HeLojzl0N/FQ08iCCVsecMDmBs9I0cu7xTW9AsL1YH8EADj4iLJixD9pfYJGSdD6cO2mfrTxsgkctPvOkoKfLt62F3GxRlksvSXgKXpslB2Pb3OjcKVCcPBWDe1MDDfjjrvUU7IEXGnlzxvgdU7pGCRK/3AHiyCuTHnG/hAR2zc30k3tAsh/WTyTZYZymjqEK13a9fL/nw+DzSlUFHXt0eaZwNLil/4hT3f1DnSVDum29kllVOy8RMrktrEUDTxPt0Ih5MgtwrDJ9tKdGU2B+UQCkMQAH0FIeo+CEyL90fFjjWvptOd5l/TOujVqef/XHnyPlL0+OLX0pO5uxPvPvJ5x50f2D1LL+VMDJMKsKPdBptpD7XWAKs47RmUHi5lmZHu2M+nOlmM2OVyLz9wzcZW7OhELgsrsr7PoHivinZa1htzZHvnlO3FDkItldMNGnpkjKjIpqQ5sxtWKv6xt1BKFyHs75H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(39860400002)(376002)(396003)(346002)(451199021)(83380400001)(2906002)(3450700001)(186003)(86362001)(82960400001)(38100700002)(6666004)(6486002)(41300700001)(316002)(8936002)(8676002)(5660300002)(478600001)(66946007)(6916009)(66556008)(66476007)(4326008)(6512007)(6506007)(26005)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2md9K0FRwsAzUv09aSU3n3zDrcrfAIBu+br2DpIyQ314gLhcEIHJLlImEDk+?=
 =?us-ascii?Q?7gnd+Fm+ZEM2EuI3Yx7iI7XeEUmVFgQu+b3gQlb7px/pdSXTOMg4NGWouO2g?=
 =?us-ascii?Q?SSp23kLvoM4kcmQOgDK6ok9n9tbN8H/NmzClUebOiIy16kNpVaLWcnCF3o56?=
 =?us-ascii?Q?GZjhyCVMf/X4z3WaCGGql2l4U4ttHIlR0cEQnwJWQFPxrZZqBFjwfs2sAX+2?=
 =?us-ascii?Q?jLAXVXvBSJttGe5e/aqpNrXB5TG2PAgjdSTlL9PKSm0bfqAEZoYsPrJJVpJl?=
 =?us-ascii?Q?M5yMG/vcrOIzPhkyD7GAmeOEXv3/dcj8mMhbNpNCnuQj+sDcJH8OB1amI9ut?=
 =?us-ascii?Q?wdflPdT54KxpuSaaZFsqaJezYSNszv3OmpCeHFNN4581K2r5gMNrzVreZo1P?=
 =?us-ascii?Q?rZT4icOmy8igCvsGm9pBpfiZ8V9jHR+blkTIXlCsmTJQd7wRDHcmRMfQGRg7?=
 =?us-ascii?Q?FtdKD1HkEZnp1Ik60KHrtbECDBkN5oGgDQ1JOYJULVFiJZTSAX6sQagZSch3?=
 =?us-ascii?Q?5A/fXbU0p0jiKthgwrRQbZ+8jiOvzu6unaLFfXr9wQK/2jtBn8i9aAwIOi3N?=
 =?us-ascii?Q?03gR+NvhsiVKS/OefQmAMamsKGmOtoowKlOGd2va7ISnYv+4p0925PAI0RRz?=
 =?us-ascii?Q?jbKFwNX9hKUn4HvCM37yQ6cSa5v1V+blesT0WcJJ1gdRcBss/DERDWwpOr/f?=
 =?us-ascii?Q?b86a8r4l6BPEjpS8iRkB8/iRnAwbViELh3hskYBH2Q0K6fbvrfMwF32+3My0?=
 =?us-ascii?Q?OJ9Z9yGPnDgJr2chN99c2T458uYAL4olusxIlUah29w4wftJF//rXXb+EZ1t?=
 =?us-ascii?Q?haqHyIrwdmPRMw2xi4DI3HBUETaBHh4kGdxHeS2Hz/5mJxtPPl5WJLBAfkE0?=
 =?us-ascii?Q?pH0ELZaP+XMqs0byAYJNw910TSI1RCN5UBaSCrt/QE/UDNCRMQQ5ZkubhUkT?=
 =?us-ascii?Q?LUdPQUF2QVbmR1yb08z8CQehBhrKqLx0Qbk/QJkld4ouhV/3vCyoFk5LlhHO?=
 =?us-ascii?Q?8Ko0m+z8HvLxML/BjsOOYZq1ZUZ2/B5f2KIqz7a6AAXGJMkA9T1q6wm0PWpm?=
 =?us-ascii?Q?uBsHDZZZY00aUe76OYlVhdQ+7ZewCPviwlbUV/0DKBgHDnTE61P73KCDmqwz?=
 =?us-ascii?Q?zXO8GBF5m8aadmNXVb61OGesbmOJIf3IregsliyACI7VDFGQzPcmF2NGIQm4?=
 =?us-ascii?Q?egDqmakNgyo4zmEUD9HsLn0ASa8B0B5G7FJ3mGpKVn2ob7vxWGWE+eQn1Fqf?=
 =?us-ascii?Q?qQnJJM54lfO2XPK8+t16C4aen3NdcAMQCCBgsDwEgoWz0xZcd5V8tV6j91c4?=
 =?us-ascii?Q?jHD0Rgy7JbyJIxCVpL4guF1ZVCpxE70uJ6mu9LQNfYrW2Z0eeHwIxfC78oUJ?=
 =?us-ascii?Q?IHuzjebDIwwVxGARkhbA7bx2CZEzUgGtra0wTY2WFvSraY9PTZeK5q4rGpYP?=
 =?us-ascii?Q?REu3OPEH2NJcsPTw+B1GZiNpkwuLhpYJmtK3mCS0vwQ3FNviKa6+yFAJC79l?=
 =?us-ascii?Q?kwBagfiTo0qOiOTQ+x3eHMF+HzWBNabAndXbDzbjKjKHButXcpnpfMenKx9L?=
 =?us-ascii?Q?8TGP9BJXuaY0hpQqxYAr4co3rgodYSP3umHekkSl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df3853f3-2cf0-4deb-c112-08db5d0c479c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 10:39:13.4138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Qch9RtZFGhlekVxkulsU0rEub3Q1KCPwNYgqWEKdiNd4Tisg+eDhbaKIT2h4HVVF3RKGGKEwTg+S5VTiraMdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6331
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023 at 07:50:24AM -0700, Sean Christopherson wrote:
> On Wed, May 24, 2023, Yan Zhao wrote:
> > On Tue, May 23, 2023 at 03:51:49PM -0700, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> > > index 3eb6e7f47e96..a67c28a56417 100644
> > > --- a/arch/x86/kvm/mtrr.c
> > > +++ b/arch/x86/kvm/mtrr.c
> > > @@ -320,7 +320,7 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
> > >  	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
> > >  	gfn_t start, end;
> > >  
> > > -	if (!tdp_enabled || !kvm_arch_has_noncoherent_dma(vcpu->kvm))
> > > +	if (!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
> > Could we also add another helper kvm_mmu_cap_honors_guest_mtrrs(), which
> > does not check kvm_arch_has_noncoherent_dma()?
> > 
> > +static inline bool kvm_mmu_cap_honors_guest_mtrrs(struct kvm *kvm)
> > +{
> > +       return !!shadow_memtype_mask;
> > +}
> > 
> > This is because in patch 4 I plan to do the EPT zap when
> > noncoherent_dma_count goes from 1 to 0.
> 
> Hrm, the 1->0 transition is annoying.  Rather than trying to capture the "everything
> except non-coherent DMA" aspect, what about this?
> 
> mmu.c:
> 
> bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_noncoherent_dma)
> {
> 	/*
> 	 * If the TDP is enabled, the host MTRRs are ignored by TDP
> 	 * (shadow_memtype_mask is non-zero), and the VM has non-coherent DMA
> 	 * (DMA doesn't snoop CPU caches), KVM's ABI is to honor the memtype
> 	 * from the guest's MTRRs so that guest accesses to memory that is
> 	 * DMA'd aren't cached against the guest's wishes.
> 	 *
> 	 * Note, KVM may still ultimately ignore guest MTRRs for certain PFNs,
> 	 * e.g. KVM will force UC memtype for host MMIO.
> 	 */
> 	return vm_has_noncoherent_dma && tdp_enabled && shadow_memtype_mask;
> }
> 
> mmu.h:
> 
> bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_noncoherent_dma);
> 
> static inline bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm)
> {
> 	
> 	return __kvm_mmu_honors_guest_mtrrs(kvm, kvm_arch_has_noncoherent_dma(kvm));
> }

This should work and it centralizes the comments into one place, though I dislike
having to pass true as vm_has_noncoherent_dma in case of 1->0 transition. :)

> 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 41d7bb51a297..ad0c43d7f532 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -13146,13 +13146,19 @@ EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
> > 
> >  void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
> >  {
> > -       atomic_inc(&kvm->arch.noncoherent_dma_count);
> > +       if (atomic_inc_return(&kvm->arch.noncoherent_dma_count) == 1) {
> > +               if (kvm_mmu_cap_honors_guest_mtrrs(kvm))
> > +                       kvm_zap_gfn_range(kvm, 0, ~0ULL);
> 
> No need for multiple if statements.  Though rather than have identical code in
> both the start/end paths, how about this?  That provides a single location for a
> comment.  Or maybe first/last instead of start/end?
> 
> static void kvm_noncoherent_dma_start_or_end(struct kvm *kvm)
What does start_or_end or first_or_last stand for? 

> {
> 	/* comment goes here. */
> 	if (__kvm_mmu_honors_guest_mtrrs(kvm, true))
> 		kvm_zap_gfn_range(kvm, 0, ~0ULL);
> }
> 
> void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
> {
> 	if (atomic_inc_return(&kvm->arch.noncoherent_dma_count) == 1)
> 		kvm_noncoherent_dma_start_or_end(kvm);
> }
> EXPORT_SYMBOL_GPL(kvm_arch_register_noncoherent_dma);
> 
> void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm)
> {
> 	if (!atomic_dec_return(&kvm->arch.noncoherent_dma_count))
> 		kvm_noncoherent_dma_start_or_end(kvm);
> }
> EXPORT_SYMBOL_GPL(kvm_arch_unregister_noncoherent_dma);
> 
