Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82686710A32
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 12:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240309AbjEYKfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 06:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjEYKfC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 06:35:02 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3BDE6;
        Thu, 25 May 2023 03:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685010899; x=1716546899;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=YPbcbBC08r+X4Ko3olCp/iNZ5XXQg4YqmSZKtFJ6jPk=;
  b=Ro81C9S8mdy4bOoC8hE9n+UJwY0MXd+kHKUwr78OgYElTIkgKnAI9A4j
   c96jKn06BMvm8ChsBMv8MONtnyv9G+WwxhWWNt4v9D6V4viO2HTnVG7tl
   JKxkuuPunfDU8Iqh+xFFMA/+pU01kqdFQ2ObWcJUbpM+41yv0rZEMENIO
   seb0HH/LYIXxXVNq3SLxTgm9P2o8IVFg2qC4BikeD1svpiGM4cW7Go1hY
   xl2kfu8Ok3JAj0ffHFJg2+ZEsT/odG4Nuqk5BjJlw3cZq37pg+Z0EtN7k
   bF0YuFIhlCcFjU+oBGTO+8H3S3qmKjBiJ497UwydLGaEN8u3hxu+/BgW/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="382099972"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="382099972"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 03:34:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="737683633"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="737683633"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 25 May 2023 03:34:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 03:34:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 25 May 2023 03:34:57 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 25 May 2023 03:34:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0/avFj1qVxIvRD+yWRgcGp0MPcLzXJkIItVE18WnHRjWbHpRDKzEu36OjiP3CofC1z6eRULrkglMcTufe7SxWFFROhMj4nk4zAhFCzOB82G2VELhAbrX4Ji+1AzzjRZKXQbCt92SmTU7gGYaZ7WWf/bOjeNfAnMiLaA9WyV656CplOo9Nk6G0JlKnvGuXwnzHnV1Hkd4UeLdDWCELnYZAuAgCapMdl2AOFY/D5nXGrnabobVSI9Y9M2OVjtiLIQ3q2izjnBz9jzvGeEpVQheiiaPMvFsLTqjrq3/CXZo5ii3JslOgklRepqnLhkS3D2XsyzxSJGv68D/7gp51eIRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S7t/oorUP6JAmMOUg6DW+0FCJSNcZfAdNI7nTAc4C58=;
 b=jgU0ViGBnguaHJUz9es9L0z+57980sCFrsg33UxYP1QnaNGWaeBVNjVBV5qyNZ2JV9ODpdqETloLT6NWolCoZONSCjcbcZZaIKZAYTzatxyhfc9P6H21cTju286xuaog7Uhthtlf5pnByVDVkjKLwqqjqQUgh0DdD2+N6eYABFciHaBaxJS2d8W8cWwBDMBbv0aYXi8pjinhBBDRsM7UWLq/10gmJwPoM5RR/Nfd1lrvphGcG4j1kYcJOpGdOHoIq4PUmK5lhM+A+i4kp0yLh9oO2259opiHMbc5kf0kN0UjvM+fr8VFwMWoQ+TAXKjlpeY51PYKthP1bukwb3AAkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB4911.namprd11.prod.outlook.com (2603:10b6:a03:2ad::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Thu, 25 May
 2023 10:34:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af48:a141:6dd6:25e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af48:a141:6dd6:25e%6]) with mapi id 15.20.6433.017; Thu, 25 May 2023
 10:34:49 +0000
Date:   Thu, 25 May 2023 18:09:39 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Robert Hoo <robert.hoo.linux@gmail.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>
Subject: Re: [PATCH v2 5/6] KVM: x86: Keep a per-VM MTRR state
Message-ID: <ZG8z493pfPIOPAT2@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135300.1855-1-yan.y.zhao@intel.com>
 <3f09e751-33fd-7d60-78cd-6857d113e8bd@gmail.com>
 <ZGxbat2mM6AfOOVv@yzhao56-desk.sh.intel.com>
 <ZG1WsnYST4zLqTnv@google.com>
 <ZG3vB052ubr1vBQA@yzhao56-desk.sh.intel.com>
 <ZG5VlRzJkcwo9Qju@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZG5VlRzJkcwo9Qju@google.com>
X-ClientProxiedBy: SG2P153CA0006.APCP153.PROD.OUTLOOK.COM (2603:1096::16) To
 DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB4911:EE_
X-MS-Office365-Filtering-Correlation-Id: dc1b5d77-2ee7-4e56-8dc2-08db5d0baa5c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BFiNNG+FGd+gv52o8nY3Anc0uq6Zx3fRMhGShMYk/ltrv65muR1hhfK6AuU+Y/NOBioLDgj5yiZ4BsL4Wq32CvPc+T9xkcu2U5tJQT2doujmL3OSo1/5zrpQuRynIpaMqR4MjxJggsJxsr6ujDuv1mp5Ux2sVWv8wBkfom40Pg8jT1YL/6TOseicMsaaqnhWtR/eWBnNj36r2I0UGPxLZ+mMKX0JGqbyP0Gwg68abHmOaM7jftlsQAcBQzeJpVBS7PrTqmE4ZVgcCmbL3+8ppWOyo728k8dbARKkE5ALj3pA3lmgR0VMqj7FsmmaDvbuXLj0+nulO086JRDn1pKFTnEYzPeBnoG2ECSKVJmYeUqseiObzOoDmE6/JYNBPE/85UbwW+ptOW1S2mrwbSRh+Z/lsCEDjy24TWk2uLbR1V1i/fsOaE9CpUBdNOPNUBprSNWI/PmTaEqBuzEhE8We8LzLwKVAFJz8fSZ2tVnwQ2rS3Wa0uEPUrUvJkfOjirFK8GwzdfkdoK8F+RmW1FI2csA76ZbmK+9jAuLdnNzwklr7MZ053EXRFP+OzLIW7YlU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199021)(86362001)(4326008)(316002)(6916009)(66946007)(66556008)(66476007)(478600001)(6486002)(6666004)(8936002)(8676002)(5660300002)(41300700001)(3450700001)(30864003)(2906002)(38100700002)(82960400001)(6512007)(6506007)(26005)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?svTdBVCOJvMFg3HzT8etanxUCvxESNlybka4tIYw34FaW6r8rJ6cf8jgjnbC?=
 =?us-ascii?Q?m5834CBSJL0gl6UOVxN+lM+vgG6qOBHQkzMV261znNyMlvLzLdFoP9sqaHh0?=
 =?us-ascii?Q?hVDdUj5loMkwOz4LQQCDxZxBNqiYQqd8LPhP4nOudzjCOh9MYvrl0Mz1eXVc?=
 =?us-ascii?Q?43nv4pSKFiyC6gug+ACOJ4XVAFWTnc5FGO+0nY3So9c4AWzDU2bYi1c1GuBv?=
 =?us-ascii?Q?xqGdHNKvwyy1eC3Q6MBaMUdV98yK1RUgRpEXEu+n9NYfUJoXX6sIJwCDMeH1?=
 =?us-ascii?Q?LYpG43VrJ1HwvC2so1kX+3+UeoEskesEW2976qzQF0zgesPMZmACa0ezthd2?=
 =?us-ascii?Q?joUMfp1gqv5iZh/ZSwK6sukYBRHFrrby1YxoIzEMbD0m5zvytvqV1GYm8PdF?=
 =?us-ascii?Q?U9vuCkpmkeX4f+Ren2WvDjPiKDZYlKmHrMkdDLSB4FUF2wrkFe7Ii92h3ZSq?=
 =?us-ascii?Q?Bc5LSldPJCW5Rdg7aVumYU50i9pgPEck9+GaIIjjOwvE8EG4QDJwj+njCIJ8?=
 =?us-ascii?Q?zSAxyHIiYsiRcCTefbZG3dOqbixXA3nZulxYMrdm1dgc+1bOD9YpKyojNZsT?=
 =?us-ascii?Q?1utWxM8YX7HR2JTDWgzz2FJp/bWzhbgfBjWmxEmjQ+3ZYMBInO4uACWM+uv8?=
 =?us-ascii?Q?wP/DRpG2GYrSSYG/1pixYOdZ5iauJeZrgaSIlfZtAulNAGmllzhVWTBDxRDU?=
 =?us-ascii?Q?KYSZdCDDXf+bjVo11/ctEcHgOoGyHDhv3qZfx7TEwQfdHxQkkFJSiS7JzIp6?=
 =?us-ascii?Q?zdjH3rUujS+srvurGoU+JOkEs9XSD+eYQQjnTeaKiD9lj9xY9gjQCNOxNi8C?=
 =?us-ascii?Q?obGmNA7YVJb/xC9K6/nO0uYvUpE8PbuTQtuxweF8wOVnlPywovpKemgsRWPh?=
 =?us-ascii?Q?jwPm56ADgAOt3k/uNsVMFzFBhJYoSQjuNhYV33iZ+NW78WV6MwLNWE3fc2Se?=
 =?us-ascii?Q?yn/wkhniRuzgl0oVbk7oYy8FofuWeFzr/z5s1WrS1UK7A1J4DMEWQ80yhSh0?=
 =?us-ascii?Q?oScG+s9qVXpLxxBlqr4CKDLn506BUbAW5TWN7hTfCS8sBoJc3891zKsVjRAJ?=
 =?us-ascii?Q?JNNSzzfoguq3103nL0wMoHP8vGlsYfF0owFnk8zg5mgOxXQxfExFNQJ2Mek/?=
 =?us-ascii?Q?KIXP2lyc03wJfTNUv0qHsZRKhPmBb9WNSsMJv95p4k2L0beTU3tznAJdb1Kd?=
 =?us-ascii?Q?6ec723ff2mXxEiCHak9t7zCAIx4H7ZpEjvwYOmEWhX0BVwRBCZRHQ1UkkouR?=
 =?us-ascii?Q?aFx9BXqjT8odzh7U5bEBSnPVDyquts86Y1D8qDiA3W259NSDgP1U/fmngotB?=
 =?us-ascii?Q?gDDcrNQ6SZZrFg3DDb0CiyLi/lGGaoH2dJwgeIV7R7bb450U2iGm0sXUrJ0g?=
 =?us-ascii?Q?UWd/jw6g/qJmVjLNFtGE9fMp2GcgQ14eBz0j+tjtIgVs4NKcGI4V2QcUXytW?=
 =?us-ascii?Q?XUTGzzikNAPdTPedsoL7bMH+zcjqCWnwITUHFSJeAXA1eJentiwvhgQSvNlm?=
 =?us-ascii?Q?er73Fp7wYnZxq6Zyrafh7A/mooHA6gpL5cGZp68bqPVYMRJ7mSoxxr2IAnW5?=
 =?us-ascii?Q?f2WnTxhwOUyNo7Q1SAYGFjVenRxNiMheenEBAdMI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc1b5d77-2ee7-4e56-8dc2-08db5d0baa5c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 10:34:49.1486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3I/mu/QzvhDTLnoia4NpPhP/+sz0RzEYEMWf6UfcP4bMo5dV5bXu3SjlOOUfvcuNK2RTXbV38Z1Iby+/2LbKyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4911
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

On Wed, May 24, 2023 at 11:21:09AM -0700, Sean Christopherson wrote:

...

> > > Picking a single vCPU will always be subject to edge cases.  E.g. I can see something
> > > like kexec() "offlining" KVM's chosen vCPU and then having problems because KVM
> > > ignores MTRR updates from other vCPUs in the new kernel.
> > >
> > Not familiar with kexec().
> > I wanted to trap APIC_SPIV and finding the lowest online vCPU id by checking
> > apic->sw_enabled status. Then only MTRR state of vCPU whose id equals to
> > the lowest online vCPU id can be written to per-VM MTRR state.
> > Will that work for kexec()?
> 
> kexec() allows "booting" into a new kernel without transitioning through BIOS
> and without doing a full reboot.  The scenario I'm worried about is if the new
> kernel offlines KVM's chosen CPU for whatever reason and also modifies MTRRs.  I
> think it's an extremely unlikely scenario, but my point is that selecting a single
> vCPU to control the MTRRs works if and only if that vCPU stays online for the
> entire lifetime of the VM, which KVM can't guarantee.
> 
> > > One idea would be to let all vCPUs write the per-VM state, and zap if and only if
> > > the MTRRs are actually different.  But as above, I'm on the fence about diverging
> > > from what hardware actually does with respect to MTRRs.
> 
> ...
> 
> > > So, if KVM zaps SPTEs when CR0.CD is cleared (even when the quirk is enabled),
> > > then KVM can skip the MTRR zaps when CR0.CD=1 because KVM is ignoring the MTRRs
> > > and will zap when CR0.CD is cleared.  And to avoid regressing the CR0.CD case,
> > > if KVM honors guest PAT for the bizarro CR0.CD quirk, then KVM only needs to
> > > zap non-WB MTRR ranges when CR0.CD is cleared.  Since WB is weak, looking for
Not only non-WB ranges are required to be zapped.
Think about a scenario:
(1) one fixed MTRR range is UC initially. Its EPT entry memtype is UC, too.
(2) after CR0.CD=1, without zap, its EPT entry memtype is still UC.
(3) then guest performs MTRR disable, no zap too.
(4) guest updates this fixed MTRR range to WB, and performs MTRR enable.
(5) CR0.CD=0. we need to zap this fixed range to update the EPT memtype to WB.

Does it make sense?

> > > non-WB MTRR ranges doesn't need to actually resolve the memtype, i.e. can be simple
> > > and just
> > > process MTRRs one by one.
> > > 
> > > Did that make sense?  Minus the code to identify non-WB MTRR ranges (and much
> > > needed comments), the below is what I'm thinking.  If more intelligent zapping
> > > provides the desired performance improvements, then I think/hope we avoid trying
> > > to play games with MTRRs.
> > > 
> > > ---
> > >  arch/x86/kvm/mtrr.c    | 19 +++++++++++++++++++
> > >  arch/x86/kvm/vmx/vmx.c |  8 ++------
> > >  arch/x86/kvm/x86.c     |  6 ++----
> > >  3 files changed, 23 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> > > index a67c28a56417..e700c230268b 100644
> > > --- a/arch/x86/kvm/mtrr.c
> > > +++ b/arch/x86/kvm/mtrr.c
> > > @@ -323,6 +323,9 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
> > >  	if (!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
> > >  		return;
> > >  
> > > +	if (kvm_is_cr0_bit_set(vcpu, X86_CR0_CD))
> > > +		return;
> > This will always make update_mtrr() return here for Linux and OVMF. 
> 
> Yes, that's the intent.  If the CR0.CD quirk is _disabled_, then all SPTEs are
> UC, i.e. there's no need to zap.  If the quirk is enabled (the common case,
> unfortunately), then KVM isn't honoring MTRRs, i.e. non-coherent DMA won't function
> properly, and so zapping SPTEs is pointless.  And in both cases, KVM will zap
> relevant SPTEs when CR0.CD is cleared.
My worry is that if the quirk is enabled,
(1) when CR0.CD=1, the EPT memtype is WB.
(2) when MTRR is further disabled,
    a. with EPT zap, the new EPT memtype is UC, effective memtype is UC
    b. without EPT zap, some EPT memtype is still WB, effective memtype is guest PAT type
However, in guest driver's point of view, the memtype is UC, because its MTRR is disabled.

So, if we don't zap EPT when guest disables MTRR, and if there's
non-coherent DMA on-going which requires guest driver to flush caches to
ensure cache coherency (though I don't think this scenario will happen in reality), guest
driver may not do the right thing as it thinks the memory is UC which
has no need to flush cache while the effective memtype is WB.

Previously, (i.e. in current upstream implementation),  
(1) when CR0.CD=1, the EPT memtype is WB + ignore guest PAT.
(2) when MTRR is further disabled,
    EPT is zapped, new EPT memtype is UC, effective memtype is UC.
The guest device driver can flush cache well for non-coherent DMA.

So, though the quirk will make current upstream code malfunction when
CR0.CD is set alone, it still functions well if MTRR is also disabled.

But I doubt if we need to care about this extreme condition of
non-coherent DMA that happens when CR0.CD=1 and MTRR is disabled.


> 
> And this is actually already the behavior for all MTRRs execpt for MSR_MTRRdefType
> due to the !mtrr_is_enabled() clause below.
> 
> > >  	if (!mtrr_is_enabled(mtrr_state) && msr != MSR_MTRRdefType)
> > >  		return;
> > >  
> > > @@ -375,6 +378,22 @@ static void set_var_mtrr_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
> > >  	}
> > >  }
> > >  
> > > +void kvm_mtrr_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
> > > +{
> > > +	if (cr0 & X86_CR0_CD)
> > > +		return;
> > > +
> > > +	if (!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
> > > +		return;
> > > +
> > > +	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED)) {
> > > +		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
> > > +		return;
> > > +	}
> > > +
> > > +	<zap non-WB memory>;
> > This zap looks will happen on each vCPU.
> 
> Yes, on CR0.CD 1=>0 transition.
> 
> > Then only half of zaps are saved compared to the original count of zaps in
> > update_mtrr().
> 
> I don't think the current code is functionally correct though, even if we define
> "correct" to only apply when CR0.CD=0 (because the CR0.CD=1 case when the quirk
> can't possibly be correct).  Keeping stale WB+IGMT entries that were installed
> while CR0.CD=1 is broken.  As mentioned in my previous mail, I suspect it works
> only because KVM doesn't install SPTEs for DMA'd ranges.  FWIW, the WB memtype
> is unlikely to be a problem, but setting IGMT definitely is.  Though of course
> we can and should fix the IGMT thing separately.
Current code may also not function well for non-coherent DMA when guest vCPU has
no X86_FEATURE_MTRR, as it returns WB (without IPAT) as EPT memtype.
Then the effective memtype is guest PAT, but from guest's point of view, it's all
UC. (see pat_x_mtrr_type() in Linux's code).
But I guess we don't need to mind this case?


> 
> > And pieces of no-WB memory might produce more kvm_zap_gfn_range()?
> 
> Yes, but they'll be much, much more precise.  And the bajillion fixed MTRRs can
Could we instead keep a per-VM copy of MTRR?
Then, if a vCPU modifies an MTRR entry and we find it's different from that
in the per-VM copy, we mark that entry dirty. When CD0=0, we just zap
those dirty ranges. (or just zap all if there are dirty entries)
In theory, only one vCPU will trigger this zap in each round of MTRR update.

> be batched into a single zap by sacrificing a tiny amount of precision, i.e. zap
> from the lowest non-WB fixed MTRR to the highest.  Crucially, assuming BIOS and
> the kernel aren't doing something bizarre, that should preserve the SPTEs for the
> code the guest is executing from (0 - VGA hole should be WB).
> 
> And if we want to squeeze more performance out of this path, there are other
> optimizations we can make.  E.g. I'm guessing one of the problems, perhaps even
> _the_ problem, is that there's contention on mmu_lock in kvm_zap_gfn_range() when
> bringing up APs, which is likely why you observe slow downs even when there are
> no SPTEs to zap.  A thought for handling that would be to do something akin to
> kvm_recalculate_apic_map().  E.g. instead of having every vCPU zap, track (a)
> if a zap is in-progress and (b) the ranges being zapped.  There will still be
> lock contention to add ranges, but it should be fairly short in duration compared
> to zapping all possible SPTEs (current behavior).
Yes, I guess this one is more performant, too :)

> 
> Something like
> 
> 	struct tbd *range = NULL;
> 	bool do_zap = false;
> 
> 	<gather non-wb ranges>
> 
> 	for_each_non_wb_range(...) {
> 		if (!range)
> 			range = kmalloc(...);
> 
> 		spin_lock(&kvm->arch.mtrr_zap_lock);
> 		if (<range not in list>) {
> 			list_add_tail(&range->list, &kvm->arch.mtrr_zap_list);
> 			range = NULL;
> 
> 			if (!kvm->arch.mtrr_zapping) {
> 				do_zap = true;
> 				kvm->arch.mtrr_zapping = true;
> 			}
> 		}
> 		spin_unlock(&kvm->arch.mtrr_zap_lock);
> 	}
> 
> 	kfree(zap_entry);
> 
> 	if (do_zap) {
> 		spin_lock(&kvm->arch.mtrr_zap_lock);
> 
> 		while (!list_empty(&kvm->arch.mtrr_zap_list)) {
> 			struct tbd *range;
> 
> 			range = list_first_entry(&kvm->arch.mtrr_zap_list);
> 			list_del(range->list);
> 
> 			spin_unlock(&kvm->arch.mtrr_zap_lock);
> 
> 			kvm_zap_gfn_range(..., range->start, range->end);
> 			kfree(range);
> 		
> 			spin_lock(&kvm->arch.mtrr_zap_lock);
> 		}
> 
> 		/* Clear under lock to ensure new entries are processed. */
> 		kvm->arch.mtrr_zapping = false;
> 
> 		spin_unlock(&kvm->arch.mtrr_zap_lock);
> 	}
> 
> 	/* Wait for the zap to complete. */
> 	while (READ_ONCE(kvm->arch.mtrr_zapping))
> 		cpu_relax();
> 
> and I'm sure someone that's better at lockless programming could optimize that
> even further if necessary, e.g. by checking for "range in list" outside of the
> spinlock.
> 
> E.g. in my OVMF based VM, the precise zap would target only two ranges, the VGA
> hole and the 32-bit PCI:
> 
>   kvm: vCPU0 default type = 6
>   kvm: vCPU0 fixed MTRR range 0 - 15 == 6
>   kvm: vCPU0 fixed MTRR range 16 - 87 == 0
>   kvm: vCPU0 variable MTRR range 80000000 - 100000000  = 0
> 
> That bumps up to three ranges for the kernel, which adds what I suspect is the
> 64-bit PCI hole:
> 
>   kvm: vCPU0 default type = 6                                                   
>   kvm: vCPU0 fixed MTRR range 0 - 15 == 6                                       
>   kvm: vCPU0 fixed MTRR range 16 - 87 == 0
>   kvm: vCPU0 variable MTRR range 800000000 - 1000000000  = 0
>   kvm: vCPU0 variable MTRR range 80000000 - 100000000  = 0
> 
> The above is distilled information from this hack-a-print:
> 
> diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> index 9fac1ec03463..6259c7a4bcd3 100644
> --- a/arch/x86/kvm/mtrr.c
> +++ b/arch/x86/kvm/mtrr.c
> @@ -304,12 +304,42 @@ static void var_mtrr_range(struct kvm_mtrr_range *range, u64 *start, u64 *end)
>         *end = (*start | ~mask) + 1;
>  }
>  
> +
> +static bool var_mtrr_range_is_valid(struct kvm_mtrr_range *range)
> +{
> +       return (range->mask & (1 << 11)) != 0;
> +}
> +
>  static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
>  {
>         struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
>         gfn_t start, end;
>         int index;
>  
> +       if (mtrr_is_enabled(mtrr_state) && msr == MSR_MTRRdefType) {
> +               struct kvm_mtrr_range *range;
> +               int i;
> +
> +               pr_warn("vCPU%u default type = %u\n", vcpu->vcpu_idx, (u8)(mtrr_state->deftype & 0xff));
> +
> +               if (!fixed_mtrr_is_enabled(mtrr_state)) {
> +                       pr_warn("vCPU%u fixed MTRRs disabled\n", vcpu->vcpu_idx);
> +               } else {
> +                       for (i = 0; i < ARRAY_SIZE(mtrr_state->fixed_ranges); i++)
> +                               pr_warn("vCPU%u fixed MTRR range %u == %u\n",
> +                                       vcpu->vcpu_idx, i, mtrr_state->fixed_ranges[i]);
> +               }
> +
> +               list_for_each_entry(range, &mtrr_state->head, node) {
> +                       if (!var_mtrr_range_is_valid(range))
> +                               continue;
> +
> +                       var_mtrr_range(range, &start, &end);
> +                       pr_warn("vCPU%d variable MTRR range %llx - %llx  = %u\n",
> +                               vcpu->vcpu_idx, start, end, (u8)(range->base & 0xff));
> +               }
> +       }
> +
>         if (msr == MSR_IA32_CR_PAT || !tdp_enabled ||
>               !kvm_arch_has_noncoherent_dma(vcpu->kvm))
>                 return;
> @@ -333,11 +363,6 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
>         kvm_zap_gfn_range(vcpu->kvm, gpa_to_gfn(start), gpa_to_gfn(end));
>  }
>  
> -static bool var_mtrr_range_is_valid(struct kvm_mtrr_range *range)
> -{
> -       return (range->mask & (1 << 11)) != 0;
> -}
> -
>  static void set_var_mtrr_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  {
>         struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
> 
