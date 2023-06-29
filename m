Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB2D741D99
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 03:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjF2BU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 21:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjF2BU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 21:20:28 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237A82694;
        Wed, 28 Jun 2023 18:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688001627; x=1719537627;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=PAaGKa4EflJysY1Od++ChnqnZZJDLcEB3D9z9FBCFT4=;
  b=jLJ9BVwRpsejiFaVnqKWNub1CPUwutdFKZuMRstydkpm8B46pr0GKibn
   ZMFeOVCUOqfVHPVfBmY59dxZNmb+OALYt7bzxfiNolA+XhXp5QXbOlvZf
   H3vKbj5vuXqTZ9rhWf/gW+lVRQPt/ua11D6N/oxqyYhtN9eb/Cfv8qraN
   Ihj8D61MLtuMZW1z6VtTuHE8MVxE3Dag+5Q66159BWNpmkzsKK9saoRcz
   5IZuRhddleHiY194A017Pjqf+h6mFwNqtDl/Wxgb68aD2DhEszPMtv/ah
   aToe0cHj/t6cGhgcyo9psV0xyRcObPVOLMBopv7XpK7InDCLZSIivMn0Y
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="359488447"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="359488447"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 18:20:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="694459488"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="694459488"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 28 Jun 2023 18:20:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 18:20:25 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 18:20:25 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 18:20:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BhowZ1YKkBo8Quurj1+1vE3SyZ5qpU3FQIjuFAoUXchuWX19EzD3RrylIJETjvBN0b56R/Qbg735mbwv49a8XR13f20cCTQbCfSbcJ0j8IM/ST4QMtL4W1Nl3wK8rGTXIjKeuO8/yXuXc5wSA7aVycVJ8rjW/ofe5yAhsDi0durB/1qPHb+8ULajYIfdHBn0gKj0QCcbg0H6lP6ClI1sm0XV6Hzueg6haEKuEJuJV/pxQzdOWcilq9isrY2OLPFs3R9k2jNlx050TxLkSclDgME+AjvJl7yV/66zzh+rA57SdgLaS7CVD/cO+X7GGvXRIiG9NvRHhfWPg/PVVZva1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fnvmhUFUvx0Ud2QstUZeWyAdRl6Y7mtWF3s5LPW/2No=;
 b=Qv5vDtVKfvCHoROzTb5rDsVvwAEH/5V3psmo0pkg9LwL/PsiKehmX+m6YhpxpLpYwKZwDfBSyP/ILFRN+PyCiLaEmHACBdDeTn8l+eQYyMgPr5dJo8eCvna5h1oSrygu0YZfXx6o4uBXgh6NhOhkp3Qbk39vp6YP6WVKxXOpFtYQo2a15SUYyFWgExIRDo8yu+B+nH2cST44VxTkYByZFDkkAmvpUZWlV0r73lpKnQUvI88qYr42alfWIdEkeKQ2OIhsAnZeHDxg0aZxiTBt9qXLakZifeh17EyYgJ2Z5mOha7/M04/9ChLzdsjp7qIG42+fqnkPGENphoUs/HEZuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW5PR11MB5786.namprd11.prod.outlook.com (2603:10b6:303:191::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Thu, 29 Jun
 2023 01:20:22 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6%7]) with mapi id 15.20.6521.024; Thu, 29 Jun 2023
 01:20:22 +0000
Date:   Thu, 29 Jun 2023 08:55:00 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <chao.gao@intel.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 08/11] KVM: x86: move vmx code to get EPT memtype when
 CR0.CD=1 to x86 common code
Message-ID: <ZJzWZEsRWOUrF7TG@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023858.7503-1-yan.y.zhao@intel.com>
 <ZJy6xcIsOknHPQ9w@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJy6xcIsOknHPQ9w@google.com>
X-ClientProxiedBy: SG2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:3:17::34) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW5PR11MB5786:EE_
X-MS-Office365-Filtering-Correlation-Id: e0fa2841-e1c9-462d-a401-08db783f020f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: avxG9uZhqD1Lg+kb8981TQncaKc2zsM21r7CQvASDebqVgIa/fbAuIWN41o903UyfO5QwYW5F8UkLGaOYBtSnB+NUA/eH2Y7C2Ic2TXrWT7Ttep7OwWOqz+F50WL8WVo3QnwrhvRUVe2KgX6tdbes7OnUzgWvX+DW3HEWk4ctX6VeCcR3Ye7Xsdgv5TdjpOQVuKKibihxY8QFGp9wGOR+ZUynYjC1cbAC9ZveulS6HICn6OIqSmJQ3Pts7z5hgk+Mzy5+wBJOvxQiUt7of+6gQ+wsK2jdT4vkYGrXFfkDEYX3mecdtZ9rM/Ho7epsYadl7DtWIaHu9/3TZ3kpFetFHi36dnYks/jdyFtE9U8H4HcxJ8b/rNKp+7ZRkJZxwKrtKNWj1mS/YgWAiYwULr9M8IFZ7EMl8NNICQ1biN5FBJo4qq+6KeA5DtZvY413Rk/yJSORpcs74PZNmYQF6tpeJPUrO+2KazDwzz8xXGdw3ImRK96O0467ev4Pk2lzYSLyRC1IQ6ScDCoGFrSzVB21ML5lFfZJz1bRK3JVU+t6rLg8TYEuyZFska+B6An9IrE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(396003)(136003)(346002)(451199021)(6486002)(2906002)(83380400001)(38100700002)(82960400001)(26005)(6506007)(6512007)(6666004)(186003)(41300700001)(86362001)(4326008)(478600001)(5660300002)(66946007)(316002)(66556008)(6916009)(66476007)(8676002)(8936002)(3450700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UT7Sxgil7OEpQRkmAzYL6kFQoMQkz4yZnohOmXU8AkasdbQqea0vUiEQHMyj?=
 =?us-ascii?Q?J1Y5fqa2TssHsdRZ10VlH4SLjkx1/6iVG+XCIgFvbKt4a7LA87aPzoASHye6?=
 =?us-ascii?Q?va0d5Xj3W3v/FBNG3CkQXZUebwt2r4CblHPYClIMMKaAG7PxwEVLLKhOCyfQ?=
 =?us-ascii?Q?joLIdQxwj98sYhS9ynk0DQbM5ozVfYJy7QMiths8cWE46Bvh8HIMzkpBSN70?=
 =?us-ascii?Q?OY9iPxnrD7buYbHFjroP1yi2RsnhRL14nMv8dupiS7PCkab0tP0j77Evjhkl?=
 =?us-ascii?Q?2b7AHOow6Ulj01TRq41Ga7DZFGrLKRC+JpXtk2AfgGIpKnozGK6n7SVC4Ncr?=
 =?us-ascii?Q?XwP4D3lwC9kaZEC7JjQm4Vqn9E5zaM6cv6wRkGWsCF3Nsk7Rh/hxr1RGhRVc?=
 =?us-ascii?Q?5LeYP0rIQ2yNUZPeBhJKAL47pqZMAKnXd7Wk85wLOpc2mkeiDnq7+SfUDFwb?=
 =?us-ascii?Q?fSoXQHK3RcU3FWIK6+1PMQ4TFs0Cr/z9c/3iDvzI8aDUDgwE/cfK9/7evPJQ?=
 =?us-ascii?Q?EEr+PEXVWiHwXuIMHM67tnZnumUHiXV4WuVj/a7UV8Okux1w8slW5+b60Fi3?=
 =?us-ascii?Q?t50Bk25neA/mzGfqaSR8ViC5qJ2xSkbD61+X7yXvfpzdoomRvNaa4rPSQ4ta?=
 =?us-ascii?Q?s0hEDGyTy9On3dzYd/mVHgq6GAYrl0qTgYtVzwuFIogPy0HxBFIZVKyXetnF?=
 =?us-ascii?Q?M1fIfzmbc5zzFEh+kYGYp/RZuXyzv/0SMvIjMuLOWaDN4Nfswy6qtkGMJ63L?=
 =?us-ascii?Q?FNiZTL9QAhq/7jIpwZNxopgb+LxYPFI7JMveqOEI/3UuOGpGDmSMtCcmWnZu?=
 =?us-ascii?Q?vObrt2njorhYoobOz5m9xx5zwumEzBBtb913gzdmFMkpVJ6hDwu/y16vKkYe?=
 =?us-ascii?Q?L02hyZ5gaIdNlJ691IihzDAbkgi4G1S0jw5l6gI5zy87rlBC2teMKs7TiBKh?=
 =?us-ascii?Q?9GUvgmZgyEXMMWMKmVNxwuAe6fwmnKpJ69yTN4+HpZyROVgmkSuV4sfK8zsL?=
 =?us-ascii?Q?/RpVrD8m2rqm9p8nwaOJbyC7AQUtLg1MNgJgpNX3piBCf+3uwqElksdkqb01?=
 =?us-ascii?Q?66067t8PiRRnkGFrLezgT6i53rNJmUm7dTGe0QvuKZ0c/hWyER4wWOvWodkg?=
 =?us-ascii?Q?U+h7LRYvG3MpbJGA+ltHCTKJ1ZNw/X5Vpnk3Pb4YplZ5er89tuwdY/ezk1MF?=
 =?us-ascii?Q?mbdjwNBSg7ZYuVt67Ud4oLRhojMPFDv5HivMcAszWG/FdYq4YzTkmhxEAiIA?=
 =?us-ascii?Q?0WSwSkUT59tdMKog3Z+rNrW5o2vo8sREcPiuQwoQq0tX8eo8Sjmiiu0aKXS3?=
 =?us-ascii?Q?Wj/2GFfcrN/k2F6cHV+A7dV2jdV/R8uA0IeoigMQLEP7v0ULhhmGMuPWi27Y?=
 =?us-ascii?Q?ZKXvFaRd4U5TxAnl+BdJJ82edzo5ZHSWD+lREChvpa67aLV5Qqe/KQDBrRRf?=
 =?us-ascii?Q?6vMAlClrKHGbWOg/UaOTUS1+6QF4YSlvpFrhHa1i1iTgVf4mvqKPnKl/UZtB?=
 =?us-ascii?Q?dXCn5cHPuuPFV+YYZKVRzihlCskHNasfXeSYXyKRxYP9j+IzRJRHixBUdC/Y?=
 =?us-ascii?Q?xt7jLxzq7w5sRzDBS5kXrsSZoc0XAnEMJVsGetbR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e0fa2841-e1c9-462d-a401-08db783f020f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2023 01:20:21.8940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Ao3dO3OGdMzqurg1FLJWgGh4Z9w/vgVk0Nxu2v8tVlSmTb7rCS1M+DHanb2IJLeFlRn79PbNgNwtytFareiaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5786
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

On Wed, Jun 28, 2023 at 03:57:09PM -0700, Sean Christopherson wrote:
> On Fri, Jun 16, 2023, Yan Zhao wrote:
> > Move code in vmx.c to get cache disabled memtype when non-coherent DMA
> > present to x86 common code.
> > 
> > This is the preparation patch for later implementation of fine-grained gfn
> > zap for CR0.CD toggles when guest MTRRs are honored.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/kvm/mtrr.c    | 19 +++++++++++++++++++
> >  arch/x86/kvm/vmx/vmx.c | 10 +++++-----
> >  arch/x86/kvm/x86.h     |  1 +
> >  3 files changed, 25 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> > index 3ce58734ad22..b35dd0bc9cad 100644
> > --- a/arch/x86/kvm/mtrr.c
> > +++ b/arch/x86/kvm/mtrr.c
> > @@ -721,3 +721,22 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
> >  
> >  	return type == mtrr_default_type(mtrr_state);
> >  }
> > +
> > +void kvm_mtrr_get_cd_memory_type(struct kvm_vcpu *vcpu, u8 *type, bool *ipat)
> 
> Hmm, I'm not convinced that this logic is subtle enough to warrant a common
I added this patch because the memtype to use under CR0.CD=1 is determined by
vmx specific code (i.e. vmx.c), while mtrr.c is a common code for x86.

I don't know if it's good to assume what vmx.c will return as in below open code. 
(e.g. if someone added IPAT bit for CR0.CD=1 under the quirk, and forgot
to update the code here, we actually need to zap everything rather than
zap only non-WB ranges).

That's why I want to introduce a helper and let vmx.c call into it.
(sorry, I didn't write a good commit message to explain the real intent).

> helper with out params (I *really* don't like out params :-) ).
I don't like the out params either. :)
I just don't know a better way to return the ipat in the helper.

> 
> UC, or more specifically CR0.CD=1 on VMX without the quirk, is a super special case,
> because to faithfully emulatee "No Fill" mode, KVM needs to ignore guest PAT (stupid WC).
> 
> I don't love having the same logic/assumptions in multiple places, but the CR0.CD=1
> behavior is so rigidly tied to what KVM must do to that I think trying to provide a
> common helper makes the code more complex than it needs to be.
> 
> If we open code the logic in the MTRR helper, than I think it can be distilled
> down to:
> 
> 	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
> 	bool mtrr_enabled = mtrr_is_enabled(mtrr_state);
> 	u8 default_type;
> 
> 	/*
> 	 * Faithfully emulating CR0.CD=1 on VMX requires ignoring guest PAT, as
> 	 * WC in the PAT overrides UC in the MTRRs.  Zap all SPTEs so that KVM
> 	 * will once again start honoring guest PAT.
> 	 */
> 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
> 		return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
> 
> 	default_type = mtrr_enabled ? mtrr_default_type(mtrr_state) :
> 				      mtrr_disabled_type(vcpu);
> 
> 	if (default_type != MTRR_TYPE_WRBACK)
> 		return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
> 
> 	if (mtrr_enabled) {
> 		if (gather_non_wb_fixed_mtrrs(vcpu, MTRR_TYPE_WRBACK))
> 			goto fail;
> 
> 		if (gather_non_wb_var_mtrrs(vcpu, MTRR_TYPE_WRBACK))
> 			goto fail;
> 
> 		kvm_zap_or_wait_mtrrs(vcpu->kvm);
> 	}
> 
> and this patch goes away.
> 
> > +{
> > +	/*
> > +	 * this routine is supposed to be called when guest mtrrs are honored
> > +	 */
> > +	if (unlikely(!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))) {
> 
> I don't think this is worth checking, e.g. this would be WARN-worthy if it weren't
> for an otherwise benign race with device (un)assignment.
Yes, WANR_ON is a better way.

> 
> > +		*type = MTRR_TYPE_WRBACK;
> > +		*ipat = true;
> 
> > +	} else if (unlikely(!kvm_check_has_quirk(vcpu->kvm,
> 
> Eh, drop the "unlikely()" annotations.  AIUI, they almost never provide actual
> performance benefits, and I dislike unnecessarily speculating on what userspace
> is doing when it comes to code (though I 100% agree that this definitely unlikely)
It makes sence!

Thanks!
