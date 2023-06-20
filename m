Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BB57361CE
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 05:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjFTDAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 23:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjFTDA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 23:00:27 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9BC1710;
        Mon, 19 Jun 2023 19:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687229991; x=1718765991;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=u6GkRXVGNPQlDyWCQAQtXzujdk/LJBVYfLWdgREHIAQ=;
  b=MGRTEzlFs02N3SXFnpXSwfmNfcOfj82VoHytCrJZwYACnIyn0OpwZX+9
   tc5lsVUH+Sv83GCif0qhz1DaZ597gyqW8lmz5GbpdYVMIGm+2rXs1akeC
   KaOSOatopnvUzxdi8I1baLJg931OLpgWucDD/3fEykGXggAMC+m4UMqr+
   5vmWOaCFZvOSnM2RG/8QEPmia8vj2kbCbPzJNwi514K+bcFrTpjwp0Y4h
   j3Wnh7kaMRPB0M6oW+y4N6q9Lzy/3yWHgb0GDRyfVF3IhSEM33npsvKoX
   PS8riRWltnrLTC5EEWz60hwWYIjalsJQ44xs1bvDV9lbjudK5P25gS8dc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="358619154"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="358619154"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 19:59:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="691274564"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="691274564"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 19 Jun 2023 19:59:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 19:59:49 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 19:59:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 19:59:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnUzJLG/0ZYd11SQ0XztZCjSkR1y2nMp5dQ2Qq6rn4YJWQdwtKib2ragGamQeRqt9Ard2vLpy2wD6CsA+K1t7PZ2R6My4aj6621soKP+5Z7ZbbNAdXQKzA3yEsSN1Oj/gN7W7CNd9ANMds1hCUprDCG57dSRd004sz17LJPCZ15b3FZuvTmrDERKK1BrES87rI3njsFhHXbrGSn0I8JOQUOPNsHiR5Cfs+LXnzRths8Wp2TUOIWIGoxjI9RHQIMVqfqlPnTA1H91+v7mLU+nsrIkjHmITPbc8PRxnZjSbYi3lN6hbHwnOHDV3lxir3a7J8bvDOC+3mcmwP54LUx55A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rR51MGx/5VGG+e0MJPoQmbtV2ihIizv18oBdEZ/gv60=;
 b=c1TL9mebhAnxtpQDxkjnlWFrtpKGJjIUjZKUKZH8tbWVvWJ6OXEJZP71wprOT4KsQ2jMbR4D8QqiVn605gz3C5hl6pvpTSD1IGbn/2lfmqZe2kKZUAkwCqzwKmbIIjLycbBi0AibuIVh0Qw6sg7fcROY96EqLQBMYWdrFh9bodvLTzJa2yxzMNZM1UW2d1G72UbKlprbhTf/dCpcI6+do/PRFhS80GSBI4Jk7SERJdyxy/srha4YFi8hVWNjzLoBF8QuFvmQ82CHw2sVxql6UBg7KRZELSvkyi8yoDDm2VLtsyJKqknWgZp5pCuZ9wYpM9iB21m+zP9o6KmrtFLd9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6174.namprd11.prod.outlook.com (2603:10b6:8:9a::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37; Tue, 20 Jun 2023 02:59:47 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6%7]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 02:59:46 +0000
Date:   Tue, 20 Jun 2023 10:34:29 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Chao Gao <chao.gao@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 07/11] KVM: VMX: drop IPAT in memtype when CD=1 for
 KVM_X86_QUIRK_CD_NW_CLEARED
Message-ID: <ZJEQNTvfwOSsSzrf@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023815.7439-1-yan.y.zhao@intel.com>
 <ZJESMaG5Thb5LWtt@chao-email>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJESMaG5Thb5LWtt@chao-email>
X-ClientProxiedBy: SI1PR02CA0011.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6174:EE_
X-MS-Office365-Filtering-Correlation-Id: ab9d8674-effb-4728-0b95-08db713a67be
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Io3t/xKpJv0VpktxWcquYnW7rQn2YxxLHvJGD+XwV0QFbKOUhGEDUoHUJG4kKD6QiTwk0NPcXk761Zvc1qbSx2Q2kJRzX0kEPlnf3loqJrqHjRueSAZ25t4jPfVmBJLLMkPVm0X8njzg0euZAjo3licXtR8MVKHNYLD3l4q9M5PUnrPviBtbIHiQ7ShV8Q/G52dVMktBp3rX5xyF9BiyVslhf3e1eUzjJmblAC6gMyAJgMAxkPOFVtrSMJ1x2dsHf2etIYl7Y6e4oQZPHqaZJJjQe+aYbKzNPBfqTNZ6v9n9PJ2w9g+LueTXDdwCV2ovJhqE5Bh43VMGsTESky4xMp40PKxgTwoWl9i5X9jSJsipd5L59EFBL2mNiLdQpJ+vWOS4bbtSo2MhjaiCAdLc5lIAwP96Y0Va0PXEzBanFPYoo73vFNL1Z/B2m9P/C/QBtSbJdjgJ5w+4mdWqT9Ykg8OYRzBoNYiTNKNCzhYCr2BAfJIpBUU+nim9TB+IdKyN+s85eFYxLmAdE/PZR7CDxjIS3j+WQjww0ZFqhMMDWxIsZWRYOySScsCIqxSr/mYM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(39860400002)(366004)(396003)(451199021)(6486002)(478600001)(6666004)(83380400001)(6512007)(26005)(6506007)(186003)(2906002)(3450700001)(6862004)(5660300002)(38100700002)(4326008)(6636002)(66946007)(82960400001)(316002)(86362001)(8936002)(8676002)(41300700001)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SCdOrcxSjJeXkpiYd9IVPnZFfh2StwnhtLbsgO0zQLdxig9LxU3AvbKgVG9d?=
 =?us-ascii?Q?F+L/eQR+F3FQFvnJILhvidtdCec2zSvYv3BwaGvIzc/bGOgn6a6STfMtSYlt?=
 =?us-ascii?Q?1R1sHdVLemQj4CcibQHxrFTLeaDv4vGds6wGKkSKApFX62Q+sreM4vCTLv2F?=
 =?us-ascii?Q?020+MWTeX1yq+C2HKy2aNFPr58ICYU4bJNvHyckMOEmdckTjtf0oIF+0I2Dj?=
 =?us-ascii?Q?0OaX073w2mFIqT0uUJjuRdT6JmuK+nROPSgA9RiEgsC7X6ovtC+OvtG+/ORt?=
 =?us-ascii?Q?FOLoJu3Sxi7AxFYI7PORRJv2u0MvxvlAHx6svJ7kR2WY5sw2X9EJqYtqkcCQ?=
 =?us-ascii?Q?IZonrvjvSIfeUSU22qtxyL1ovh6Cp3hTfRcqu0i6Z5iNJl/6TVWurOqVjkhh?=
 =?us-ascii?Q?LPbsrNR6ny3z2YICN/IgteJDEvFSrLqupCpXuJfJc4iZQE15LMm4uRJqwzeL?=
 =?us-ascii?Q?kn6Tf9WVp64oUEaLykED4kB58Aq3kviaxoC3DHvTaZ9Wrw6AUcB4GnhdIs5o?=
 =?us-ascii?Q?ga9rjfgZgkUSqkxMSUr+VZfwCmNyWAAqKLjni9ZapcnzKEknmjeHjFuk3nyo?=
 =?us-ascii?Q?iLOSeb8emWfH69dL9OlC7oZzMSdoTXEXurAEiBBs24h7wFqsmtJlkXMWp3ET?=
 =?us-ascii?Q?g0+m5M2L5kROqpxZO95BS+ZtJgo/t6Vw/uRz/aRljHT0YDaxQAvCIw4eypXx?=
 =?us-ascii?Q?UehG1amJ5TqeKD12A8YAnFq/a+UB7vbbymGjkdRUGzVQC1cOuwZk2oLZH027?=
 =?us-ascii?Q?vD6JytaHfQFFp+fpDjHNl2KrR5GkIWlRCOHRHSLGfqY8tzOUkfzojITPFgz5?=
 =?us-ascii?Q?10qIHkKpP25xBAK2se5X1jtJUlCQPM6clT8eV3Kh9Tkjo9+gXECGfWWIKc11?=
 =?us-ascii?Q?vBIhLOgRxhDLpcu0csQumkp3n/qXnfGv05PdcLRQiHrw5bNgVfsgkz4Y1KKF?=
 =?us-ascii?Q?alZFfYzGrlxDtWQi79xhy1vFAlkw8YaxgAkw5G0ek8bx/7C7qyVoMPiUMupC?=
 =?us-ascii?Q?EKZed6HJB81Z683CVq/fALNUP3Y0UOge2iXy44pg8ux+Z6L8kKawzcj2kr7p?=
 =?us-ascii?Q?to3fcfA80qdF0JddggtYdS4uWgcJOt2iV/9RPatX3YMOwDFdxMAsl8jZwWzT?=
 =?us-ascii?Q?2EwFJgCdodosnan/bWoJU87ie/jKcwm1lWiuzvsO+TSfzxWJy3cMgo1MC3K5?=
 =?us-ascii?Q?0qqIK79F9ufLsDnu2CC8SkJenaZjxFAY6bLOuvNNCMPjF0V/JlLKeCgArk/u?=
 =?us-ascii?Q?+4jAZqvgNOofDfBd/+RcEu6lS54rRJIy+LziSYNC/M+IrQNcCJcPg90G3gft?=
 =?us-ascii?Q?MVS+mxHjB1He8m1rAqaNVRDpU5CRXtG3f/0v8NTrcn4h7kZ9qqmq591C+b9E?=
 =?us-ascii?Q?9sdWV6H3WliUFeChf4aRczrbAZDeDKd20GX/O6OEk3qrolg0hNeBerpRM8M1?=
 =?us-ascii?Q?ulvvfk7Hn6N08/d2ccmv8iF7mHQ9E2P2SEo1b83GcSfjNvCJUqoB5L2qBdYd?=
 =?us-ascii?Q?1D7fF7C+XlzQXU1kZ4oQWk2IOfFAbtU8V6IO/513HR+J4YN+YcbLZC1HiXM1?=
 =?us-ascii?Q?oEMfWCKE7VOe/mVEPEe3MVMZHbcHXOTO7BG0p1gG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ab9d8674-effb-4728-0b95-08db713a67be
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 02:59:46.7430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 632adPWw4sdWaJQuhxMQu9j6JV3Wd6qDRhRdRNg6z7sc1f8kQfa6YsUzcinraa9gFalyolA2xEDJKWLgo9T+HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6174
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 20, 2023 at 10:42:57AM +0800, Chao Gao wrote:
> On Fri, Jun 16, 2023 at 10:38:15AM +0800, Yan Zhao wrote:
> >For KVM_X86_QUIRK_CD_NW_CLEARED, remove the ignore PAT bit in EPT memory
> >types when cache is disabled and non-coherent DMA are present.
> >
> >With the quirk KVM_X86_QUIRK_CD_NW_CLEARED, WB + IPAT are returned as the
> >EPT memory type when guest cache is disabled before this patch.
> >Removing the IPAT bit in this patch will allow effective memory type to
> >honor PAT values as well, which will make the effective memory type
> 
> Given guest sets CR0.CD, what's the point of honoring (guest) PAT? e.g.,
> which guests can benefit from this change?
This patch is actually a preparation for later patch 10 to implement
fine-grained zap.
If when CR0.CD=1 the EPT type is WB + IPAT, and
when CR0.CD=0 + mtrr enabled, EPT type is WB or UC or ..., which are
without IPAT, then we have to always zap all EPT entries.

Given removing the IPAT bit when CR0.CD=1 only makes the quirk
KVM_X86_QUIRK_CD_NW_CLEARED more strict (meaning it could be WC/UC... if
the guest PAT overwrites it), it's still acceptable.

On the other hand, from the guest's point of view, it sees the GPA is UC
with CR0.CD=1. So, if we want to align host EPT memtype with guest's
view, we have to drop the quirk KVM_X86_QUIRK_CD_NW_CLEARED, which,
however, will impact the guest bootup performance dramatically and is
not adopted in any VM.

So, we remove the IPAT bit when CR0.CD=1 with the quirk
KVM_X86_QUIRK_CD_NW_CLEARED to make it stricter and to enable later
optimization.

> 
> >stronger than WB as WB is the weakest memtype. However, this change is
> >acceptable as it doesn't make the memory type weaker,
> 
> >consider without
> >this quirk, the original memtype for cache disabled is UC + IPAT.
> 
> This change impacts only the case where the quirk is enabled. Maybe you
> mean:
> 
> _with_ the quirk, the original memtype for cached disabled is _WB_ + IPAT.
> 
Uh, I mean originally without the quirk, UC + IPAT should be returned,
which is the correct value to return.

I can explain the full background more clearly in the next version.

Thanks

> 
> >
> >Suggested-by: Sean Christopherson <seanjc@google.com>
> >Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> >---
> > arch/x86/kvm/vmx/vmx.c | 9 +++------
> > 1 file changed, 3 insertions(+), 6 deletions(-)
> >
> >diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >index 0ecf4be2c6af..c1e93678cea4 100644
> >--- a/arch/x86/kvm/vmx/vmx.c
> >+++ b/arch/x86/kvm/vmx/vmx.c
> >@@ -7548,8 +7548,6 @@ static int vmx_vm_init(struct kvm *kvm)
> > 
> > static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> > {
> >-	u8 cache;
> >-
> > 	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
> > 	 * memory aliases with conflicting memory types and sometimes MCEs.
> > 	 * We have to be careful as to what are honored and when.
> >@@ -7576,11 +7574,10 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> > 
> > 	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
> > 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
> >-			cache = MTRR_TYPE_WRBACK;
> >+			return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
> 
> Shouldn't KVM honor guest MTRRs as well? i.e., as if CR0.CD isn't set.
> 
> > 		else
> >-			cache = MTRR_TYPE_UNCACHABLE;
> >-
> >-		return (cache << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> >+			return (MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT) |
> >+				VMX_EPT_IPAT_BIT;
> > 	}
> > 
> > 	return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
> >-- 
> >2.17.1
> >
