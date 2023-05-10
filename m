Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0799B6FD97E
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 10:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236477AbjEJIdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 04:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236707AbjEJIcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 04:32:46 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8A77ABF;
        Wed, 10 May 2023 01:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683707531; x=1715243531;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=eLXpH1i4++EOPbF6fw/mszRAU0iyGL0LeP+uLLqhOxM=;
  b=ZL1vzgtLzABhpZSpXmYkWb8hpltRSvsc/6ZFgZppQWPAMiIFdU317eGo
   02oqE3Leacseu+YDW57ep6WEGbyhnj6OAOMlM5ngblil+qyckYsqjlG52
   TvylpKVotlKJCC1eCQoeyg68dB8vu2QiLvNJzDAt9b2FoSFzVJMXSHBiE
   0x53K+t6E66t5uZC/VQ/Lb5grnNyVZU3P6Xsd5rvjczPfdgEDq5AJklyD
   bNv0H4eT81xWm438U3NBf7bR23sGIYejf3U/8SxkaoPFyGJBMl3CB1fJF
   4rFwDBf9CNmgWY6ajZjWoeGqnrfH4pww2YGuNPYJdf8oNB3n0vGmWAku0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="334624351"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="334624351"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 01:31:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="764206139"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="764206139"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 10 May 2023 01:31:21 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 01:31:21 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 01:31:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 01:31:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSEbbFkBGCraYSaSnJeuVPh+3mr5tWU4Tk8bsSPjtMImNtcTM8H48+f8bgzRc3IIPuQXGQXdKl6C6VOfleKH/D3WpSzRlYHyJRfZw6obWxnqxlYXOmYVWWczSL26G5YuRcmYACBzWk621tifqlU+phtEzvCF7PZmpBDlORfu/K0TYieHH3romJbqtpnwvWPFOfNaxq3oTJe14CHHzsL1m/bMi5dGBZH0Z7XW5Mol57sQwgoXRhnR16ULK/ttU0x/V6J5jLymhErJ1sE18oMilbmHXeJAbpGWFvlMiv88h38JxWVbxEWOv50eaj7uYwChl3sMefWEHKs9mie9q1uVBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XyHN1w3i+YCwJV+Yg2y2P29pvcJylrmvS5VdcYaL2Ek=;
 b=K3zamikqfxQ5mBsIPH7yC9PTbjtOsEsDcbWQR4ZrST8aXZ8JwK/hjpYT9lSN0bEfZsXwq7eMucR3O8M5usT+CUOVSpfBaayodF8hCaPFN++5THCJGaTvh3MIK5CYiT++RIfp4pQX6oXu96HWxUW+wvZVlV9kuoush5yVHD9wHeuP5kXnUru190WkdCed6EmisqvDRy/MVKuAgZgcHsR6ShWQcsPihJDc3yrwHE4AumWCyZhQhxBmEBs7dk/fnOk/Gavu/hqO/LXjPTmXEkVGm7Jw7HJCgztRHpY5Jbm+se7g97ikKXSscwGv9MZMP64IbsedB/k1LkqxmEsaMWdG2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB5091.namprd11.prod.outlook.com (2603:10b6:303:6c::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.18; Wed, 10 May 2023 08:31:19 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6363.032; Wed, 10 May 2023
 08:31:19 +0000
Date:   Wed, 10 May 2023 16:06:16 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Chao Gao <chao.gao@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: add a new mmu zap helper to
 indicate memtype changes
Message-ID: <ZFtQeLNuXP6tDMne@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135006.1604-1-yan.y.zhao@intel.com>
 <ZFsr9TynkA/CyPgg@chao-email>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZFsr9TynkA/CyPgg@chao-email>
X-ClientProxiedBy: SG2PR04CA0184.apcprd04.prod.outlook.com
 (2603:1096:4:14::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB5091:EE_
X-MS-Office365-Filtering-Correlation-Id: bcb34b4f-7121-4c88-df63-08db5130edaa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9yRREnszeceM4z97fI+IRukFYpPfVdeLfk2dKVBOywsUKh+xrQ60PUCZxJYGqVuhWQ3iR3+LEoAyGKqiEYxR3hOm88WDE+MqiqdID3b2wcsJdIJQyhC5IyqA76D5AG1iqFWlluBI3ZtconBcnoMjMG+0muIT+aS6RmuSCw0MoekV19iqGiw1V+5DSKK4kAgBLu3BxBXeS/CdWUHsjDvxoEzxm2Zy263514KE411wVHWHFX9av26UV+XodZ/IlmYgzNVea5CB3uezdTeSSQSJT1a7bb8Ae3zEzz9XgzeDLVp9Gij7xFoymlEQ34QfhqRJMJTF7w6djFCgH+DRyojQxdQij8AbinvO+OKRyM1zc4CmjeEdOeh+t9mjzwcB90xrOgyypqutNbgf6ej6IuszvcOHZyFVCkN6Aob3wxaUmPXPgcrnpfGxKGQwAdBrVB3kiDfyNRbVGQSycLOt1EmesY+LyYBnJfbsZRTJ33Q5aQVrlYn7V6gM1K9L45JQQ9nCh1I7LtJM9DoC4ELw0RRqwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199021)(186003)(6512007)(6506007)(26005)(84970400001)(3450700001)(2906002)(6486002)(5660300002)(66946007)(66556008)(4326008)(66476007)(6862004)(8676002)(478600001)(8936002)(82960400001)(6666004)(41300700001)(38100700002)(6636002)(86362001)(83380400001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1DdEl9Qw/XyJEwvUXtSXSq7kXqGPIuvzVWyBu6fx47GWg1CPQn4MVtIeKdwy?=
 =?us-ascii?Q?H8tujLu8vQgJj8aF/4HkwDhHn4BNm1H7swj8JXl09lBFkTSNz0o+3ymCRbWG?=
 =?us-ascii?Q?wrT3BPpB8yqZo3wNyfF7Ewq5/0XqgpSDKUZeUNs1wrFw6B4vcXytrpApIu4I?=
 =?us-ascii?Q?IbHBNkaSQfozhPmrzyXs8zUxjbYw51H9YuOpZSQVxU68RcUJFRtZ/4x1xjMJ?=
 =?us-ascii?Q?V5ZgnxbhxRsnwVqP99dIwloLWsjpyCB4uFTlx/3oA6KttMP21YWTcf8VIjF4?=
 =?us-ascii?Q?xKwNKbvNQHtEtFX6bZg2H4hj7AV51ujEfOdEnvZ43r+HysD+2jKHQr2W88Cm?=
 =?us-ascii?Q?NFvjRuw4WUKtvw6Ym2A0sd3XFQMe+TE7D+Qn0WM+65xIJO8+vb/37thGz85P?=
 =?us-ascii?Q?O+WwN8ykELXZ3hITY4p4BkCMIYIxljAOIwJyDW0YGFrnfD5XNLQF+R4R+SZ9?=
 =?us-ascii?Q?m7lrvsaUDxq7sKHK3fnJuDIY3JPLl6jTMJRFa2aMVG3WyfqSs8MsUqBIG1ut?=
 =?us-ascii?Q?fJCsrO3DGR5Ul2dIb0iWubEYqWQRcluK2FlkpR7bm8pIEh9kMYetaJ/4v5Xg?=
 =?us-ascii?Q?lcTvEy9tftJIDyxOoonEMjLjIouJTj4sxvYbTcQA9+4dR6QL7c7tF6oeTghf?=
 =?us-ascii?Q?1OllyQj/5ZBf//7tuhr59oUauLQikdP5s60InGMyjoaM6L57fjAhi1rOtppt?=
 =?us-ascii?Q?bliwT8ExmbgivARclg1UsmzyFoSPyrULSG5lVGPFTlj/AbTWLdMulN3AIxNI?=
 =?us-ascii?Q?wAcRmOnKKAd2FDUHj4LnI7sLSgbggJ3SCX+cutzAzvzuQBh2QGVc3z+9/jBQ?=
 =?us-ascii?Q?/w3QtVUtdI1DQdAlKYsrQeRTLE1uhGv9vJQ5H7EPmqhGT0PeKCic4vCv9onK?=
 =?us-ascii?Q?bFLjMNSTVbVoEnLUmH+5RDThdwsqrxLHFY9fq+gE10ZqA1yW7C/lXb4po3Hn?=
 =?us-ascii?Q?PlIzR/mK+Eud+VZ2via+wlS06XOrSoz1kCVASUmJk4+zSlaOWTTBaWxVE+oi?=
 =?us-ascii?Q?t3PD2sQyWRsq+IYJpa3SxwwKvaDxZBJezqH0HiCsnKhh3aeuNOYzsxmzzMru?=
 =?us-ascii?Q?doA6eks09AohUR5goPYSjAOtQBMzSLXjyeAWARvA7m71hD8MfjyyWD+XnW4i?=
 =?us-ascii?Q?Y3MyW/1xF3/hQLBCB402wHQ1fTgE11DZw3M7xJ60g36P6O04tHCKySmb0F6u?=
 =?us-ascii?Q?4zGGRxW1if3WsHwPgZhl2OCZkB/0/G+/8c4phjmS2JVuzLBCmqanKAHPEh5R?=
 =?us-ascii?Q?Knj1h5QCkAybhcTyfcT6Legyhx9BNOvKrcr31OPnKnYvAYku0UVPi3SGb36p?=
 =?us-ascii?Q?WTq4zI1WEM7toqU7zAAsZJMOu5CuRdiMv2nj/dg2ev2KZv4ZtgWhVUT2TF4B?=
 =?us-ascii?Q?1acS0sY+T0RLAXP4m0b3Zm3KSxs83AntndW+Lr53H34pyDmK+0rQcnRBhw0G?=
 =?us-ascii?Q?haKsAn1OYI1dDAchs2LttEcY4PaSI9EE4ta98ToYqZhAKP0XTSWGKF6DJkz1?=
 =?us-ascii?Q?j3UP673+hbwseCfSV0MBzBw3jhjD+hTbfAdbLLQin7NRQO9FdmGq3Q3S3GPV?=
 =?us-ascii?Q?YQgre/ik9ORSEha95fsFX2rzzNpbCBW69FIValGT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb34b4f-7121-4c88-df63-08db5130edaa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 08:31:19.2803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMOApVDFdKCCQ0xfYxr/fVlPVSmKCb7Kh6zUsCOInvxZO1Az3wVpt8qqJ/oWB9iShR8otHUEXBxS2hz+D57fmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5091
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

On Wed, May 10, 2023 at 01:30:29PM +0800, Chao Gao wrote:
> On Tue, May 09, 2023 at 09:50:06PM +0800, Yan Zhao wrote:
> >Add a helper to indicate that the kvm_zap_gfn_range() request is to update
> >memory type.
> >
> >Then the zap can be avoided in cases:
> >1. TDP is not enabled.
> >2. EPT is not enabled.
> >
> >This is because only memory type of EPT leaf entries are subjected to
> >change when noncoherent DMA/guest CR0.CD/guest MTRR settings change.
> >
> >Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> >---
> > arch/x86/kvm/mmu.h     |  1 +
> > arch/x86/kvm/mmu/mmu.c | 16 ++++++++++++++++
> > 2 files changed, 17 insertions(+)
> >
> >diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> >index 92d5a1924fc1..a04577afbc71 100644
> >--- a/arch/x86/kvm/mmu.h
> >+++ b/arch/x86/kvm/mmu.h
> >@@ -236,6 +236,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> > }
> > 
> > void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
> >+void kvm_zap_gfn_for_memtype(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
> > 
> > int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
> > 
> >diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >index c8961f45e3b1..2706754794d1 100644
> >--- a/arch/x86/kvm/mmu/mmu.c
> >+++ b/arch/x86/kvm/mmu/mmu.c
> >@@ -6272,6 +6272,22 @@ static bool kvm_rmap_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_e
> > 	return flush;
> > }
> > 
> >+/*
> >+ * Invalidate (zap) TDP SPTEs that cover GFNs from gfn_start and up to gfn_end
> >+ * (not including it) for reason of memory type being updated.
> >+ */
> >+void kvm_zap_gfn_for_memtype(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
> >+{
> >+	/* Currently only memory type of EPT leaf entries are affected by
> >+	 * guest CR0.CD and guest MTRR.
> >+	 * So skip invalidation (zap) in other cases
> >+	 */
> >+	if (!shadow_memtype_mask)
> 
> Do you need to check kvm_arch_has_noncoherent_dma()? if yes, maybe just extract
> the first if() statement and its associated comment from kvm_tdp_page_fault()?
>
This kvm_zap_gfn_for_memtype() helper will be called in
kvm_arch_unregister_noncoherent_dma() as well when noncoherent_dma_count
goes from 1 to 0.
So, checking kvm_arch_has_noncoherent_dma() is not desired.

> >+		return;
> >+
> >+	kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
> 
> This should be:
> 
> 	kvm_zap_gfn_range(kvm, start, end);
>
Oops. sorry about this mistake. Will fix it in next version.

> >+}
> >+
> > /*
> >  * Invalidate (zap) SPTEs that cover GFNs from gfn_start and up to gfn_end
> >  * (not including it)
> >-- 
> >2.17.1
> >
