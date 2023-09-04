Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB193791444
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345315AbjIDJFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjIDJFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:05:32 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75705138;
        Mon,  4 Sep 2023 02:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693818329; x=1725354329;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=7AgDW9SBVcSWx1ZNYJThzWO98dtz/uX7yz0N2iw5P9Y=;
  b=CBrglLLm7UucbNyItfO2V9TsV1IAoZJi1car7bQW5Aq/XfP7P2UY4zju
   ogPVP0DeGLebS3KyqUVzF50ZYdZkbcLe4qHFB9/YcdyW5bGnsSWfBYUIu
   f1dD7zbalHOHDiPQNaMSgVRV/AdBD3rhBWly2a+1vGIVlXYQUTsU8c7SG
   fbCry1qGGAsat+WX1OyDnAOYRoTVdjX/hlMSq0c49T2/ENlsfg869Q2wy
   cxTyGnJ+0kQvKfKUTxDoXQ0ZU9DVQA6yMrjAoRiV1voNsnJ0F7OZJZE+z
   VRMVeOHtfL019MFAstFG4sddBSey3sRnjD6rJxzp3e1NTZ+JSEpw8ACfE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="440521110"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="440521110"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 02:05:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="690520287"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="690520287"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2023 02:05:28 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 02:05:28 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 4 Sep 2023 02:05:28 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 4 Sep 2023 02:05:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YdVb7wOwBdkEtZz1O0e3pFU/fJuqvrKblwBqQ17xEDIlH+BwnBtuW0NE8N+QPtE/OEnco2lrrbvmjWLNsPv8WIiJOoOVMPffAkgXpbxqNLJaeY22e/VjGzDEpxhQFPAVDm89x+TWclb+tUI3i9ZmdChwP//P/QN4xepQ/ePKGiQsY2ksvJexgZBi9F6GsVYtG0N6iPpPFqMcI4fm1ksQGbofBbVWbXA+/24+SU7eGyXAimVfBEHeAptlXdyCN2WDP5SUY7AAvJOBA8ZB9zqroXWqGs+MWh9Rs9kgM5XEPP7VeeiBWalGHVn31K/tCEjF7KOvrEl07LBIKJHjiMD/9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gyZpQs1rz0PM98q6vXojJTSKNBXfaREmwMORfvLuHe0=;
 b=XQOJspPxAg+bMVpvDIFnrZFiWgaNc0t/VzBiEZpo86cweNHWlSC2C+0kavmFU+3d8oBgIjeNVCIRyevIwRS+uIlycK0bHALM6okWYtQaslygkPrNeV19IW1CXUJlnwcNDmqRxXY5tDKdgIdwx88RiBmda0G8pNgmBrB2YCWSEH1fPtYDjwnOlQjkv5wo1e9Xk4rp3reEQv4fFwpepgzFaQHVFSwA02gatA2mwnbXiUpnOOTJmmzFQweXghgKRoPeV9YApRM9QVNZmdoPlRGYE3BYN9AtVdOqxKiYWEJEpJyWpxaeyDzYW7ep+JcHzWlDJy9GBlqPs49tJmf2Kqy96Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8341.namprd11.prod.outlook.com (2603:10b6:610:178::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32; Mon, 4 Sep
 2023 09:05:25 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602%6]) with mapi id 15.20.6745.030; Mon, 4 Sep 2023
 09:05:25 +0000
Date:   Mon, 4 Sep 2023 16:37:48 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <chao.gao@intel.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>, <yuan.yao@linux.intel.com>
Subject: Re: [PATCH v4 10/12] KVM: x86/mmu: fine-grained gfn zap when guest
 MTRRs are honored
Message-ID: <ZPWXXLVlCpccVLvY@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
 <20230714065530.20748-1-yan.y.zhao@intel.com>
 <ZOk1n3ssdU7bXalP@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZOk1n3ssdU7bXalP@google.com>
X-ClientProxiedBy: KL1PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:820:c::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8341:EE_
X-MS-Office365-Filtering-Correlation-Id: b98157a1-dd9d-4aa3-32b3-08dbad261369
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qbCQqx4giBfnxH9zRqKQpIS+L3t+Qvy+pbwVunqWTm+7+DtF6WmvnBk3rrAwwe4YojYN4yXGStZDl5sSCY97WgT/adBFjniJfVxigKMEocAes0YTd+FK3H2XPpzza4IF5gRUBnaUKNB4xa4mcPqqwuJ5XbbsRVb3H3TKaxQKbpulMqiFFm6ipz1yH/8g5dyITJEVro1u/JAMdacELfdCMXpZ359KJfk/LIl/UWHWy5HRgpjEa5MtAMlyfB0RzPQQHyeIpqGQFdeA8cqDpIN90osvmkYqXJOKLqwxY0it/qWjadOsE/GegAHmgGpPjquxz9rzSiCnck6gu5tI7IJXDUj2qRS0qb0oFsqmS2XDneImMwG28PBt/BRQ3TlG8sPM9AubrMk5pTUIQTrh2qBuR7ePR/vMyClsrvz0y8xMFvv/RYbhcuZ1zt0EdXOc0PKQrzr5fg/ntnGjU3ltBoCrUSrwcy4NG+Pzu1vIr+saPcjuci38gQ3HGsEJKvpWTCyyltdzYdbonkfSFLBSWL2hRv25zx1UFUGMpvS4/NZF/BZbNtQU0abFfDx/ey31Mp0u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(136003)(376002)(366004)(186009)(1800799009)(451199024)(41300700001)(478600001)(38100700002)(6666004)(82960400001)(86362001)(83380400001)(26005)(6512007)(6486002)(6506007)(3450700001)(66946007)(2906002)(316002)(6916009)(66476007)(66556008)(8936002)(5660300002)(8676002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nqzd+1c2FlKEX5QXyfE+N5RTt94y0Oeq88y0G7LjrQAFcoJ3oD5Oyniu0enm?=
 =?us-ascii?Q?KifqCtKFlLUi0Jl7WgtsWrdRhDiV0gjf0UVBGNX7xOMM1B/X4DlBAX0KpYio?=
 =?us-ascii?Q?E0/seKn2L4e0Mqw+BWG98jOLRSQg9NCX6CEIvdEw5qzu9GcQ4wd4rL3jxDr/?=
 =?us-ascii?Q?Jg2w60FkhBxYpWb2p2aU0MyjvJmva6lquhDewffN1YhHT++Mc7DOHrxAKnE4?=
 =?us-ascii?Q?/06D4SVLBh6/iirRaTWGHV4beZUXlBluo5cO1l6PSbtlOpsqYEHdRRgYmuLC?=
 =?us-ascii?Q?Q9h+e+n5cRNwHQYIuybc8Z3RUEPGzqGlHxgG+9Xf4dBz9aknuB2ceJ4LR0HT?=
 =?us-ascii?Q?+1eNf0Hn39E5brRX90HBLkG8l6sXrEtAixGGZlo6wiFm+HNG20HVDYwjisoy?=
 =?us-ascii?Q?I6Rgp8lx7Wo0oMaklV5RTlOEfsqd+coT8z5soPjnafGPpqP66ySY4VMfuTCd?=
 =?us-ascii?Q?3guWj2RfWpQnp4AAQKgdHc0ppKOlUPjP2qRieRVvm+Pi52R9B2UldB97KwSH?=
 =?us-ascii?Q?ZJIz0aDc+5Lb04Tl9XEf8tQxKqCUSyvzP8pG9VpqbHqI0keeZxVaoYLmZv8y?=
 =?us-ascii?Q?3SS5n7pgezPZ0EMO8FiwM42pLHHyKWmvy1QIRwitxjl8zUHdtqdWjbp3dV+D?=
 =?us-ascii?Q?JDCvggCGesZodOdLgw5Scu1ixjLxiePFayiEeeGUP2E3f6okBey+pdxrD7ZC?=
 =?us-ascii?Q?B1XS4IT9fMz4XHRTzsqTWPRYHEmg5oks2Snl1r4fg1IaXKD1KyvEBj3D+jh0?=
 =?us-ascii?Q?rUrbqswpl1wtGZyB72sbQLjgjFgawNS86UldvvCiIdC7eXxfQdFvHTjsaLex?=
 =?us-ascii?Q?k+b10c0gYHqMExu505ZfppM1lA0oJtbJC+COQM/6NXZmM2+m/7R3Hkr3ogEY?=
 =?us-ascii?Q?zh043VhyizPCQOh/FeP6hYBMIjcR80kURoR+FovZ+QSEcarcCoVN1tW5NTWe?=
 =?us-ascii?Q?eAN6i8OaRJeJyZwDeQAp5PI8/9LbyKCSjIZxfF2r2PS9zrRrNMEP7RdGf3lm?=
 =?us-ascii?Q?P8C9YmdVAU3wB4yga8ORFIl5pBbA5UvMSAMVDX/cjLSVjFVVhp80z74KtSDS?=
 =?us-ascii?Q?tk0+bpQGDtWzrrXWt4FG9I7pZ2iXEXk09El9hD4D/9Kxx5KFIc6mpp2WAK3L?=
 =?us-ascii?Q?3QqGKKlwsUxV5eOxALonebndesll1DCrBC+3Cxe1cBiGVR0sFbzVhSZ0I/0x?=
 =?us-ascii?Q?lydoeLq9RAEHVSirVGC0UaZh7cz+QEgO9fsRX9dvBUxsA4ZvdpqX0FzWOzru?=
 =?us-ascii?Q?qolMqxBazzrA3w9rtez1y3pk3Ku7pjIkhsdqZmFMhAzWtKN3Ny/GHAB5FQ8o?=
 =?us-ascii?Q?5eX81tbfD6a2zMbbU+VU/9wBYnpgr0G+5yqZ66fLClb/dwHQkMIFUpQFEjGv?=
 =?us-ascii?Q?H6o6B5wNp1li2s2Wf+VtVz2mit2BjVnFC8oi0/HP73vOqPAKXXHXQGupJH65?=
 =?us-ascii?Q?41CaD6GitHZ/jH7u3WUOi7VS4KJ4+fYqeytFehdBH0XLh4gs1iwWqlVfX7jI?=
 =?us-ascii?Q?IipXqqCugQyjT6L9xTDbHYUMHREJ3nhTRg4GDBvwWbiMOH7z6GEvqMJVZ5VA?=
 =?us-ascii?Q?saJJTCS2a2LDqDJSn+Qp/9GstUjfZL39S5R6uUiV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b98157a1-dd9d-4aa3-32b3-08dbad261369
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:05:25.0841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xGFFAiDTOHYd1oIOPBfgSWC/wZs+atWLvj0JDntiVO3gGHWh4a6viMbqZrpNyJX65zH5IJxjYT8kabfsMSD/zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8341
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023 at 04:13:35PM -0700, Sean Christopherson wrote:
> On Fri, Jul 14, 2023, Yan Zhao wrote:
> >  void kvm_honors_guest_mtrrs_zap_on_cd_toggle(struct kvm_vcpu *vcpu)
> >  {
> > -	return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
> > +	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
> > +	bool mtrr_enabled = mtrr_is_enabled(mtrr_state);
> > +	u8 default_mtrr_type;
> > +	bool cd_ipat;
> > +	u8 cd_type;
> > +
> > +	kvm_honors_guest_mtrrs_get_cd_memtype(vcpu, &cd_type, &cd_ipat);
> > +
> > +	default_mtrr_type = mtrr_enabled ? mtrr_default_type(mtrr_state) :
> > +			    mtrr_disabled_type(vcpu);
> > +
> > +	if (cd_type != default_mtrr_type || cd_ipat)
> > +		return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
> 
> Why does this use use the MTRR version but the failure path does not?  Ah, because
> trying to allocate in the failure path will likely fail to allocate memory.  With
> a statically sized array, we can just special case the 0 => -1 case.  Actually,
> we can do that regardless, it just doesn't need a dedicated flag if we use an
> array.
> 
> Using the MTRR version on failure (array is full) means that other vCPUs can see
> that everything is being zapped and go straight to waitin.
Yes, will convert to the way of using statially sized array in next version.

> 
> > +
> > +	/*
> > +	 * If mtrr is not enabled, it will go to zap all above if the default
> 
> Pronouns again.  Maybe this?
> 
> 	/*
> 	 * The default MTRR type has already been checked above, if MTRRs are
> 	 * disabled there are no other MTRR types to consider.
> 	 */
Yes, better :)

> > +	 * type does not equal to cd_type;
> > +	 * Or it has no need to zap if the default type equals to cd_type.
> > +	 */
> > +	if (mtrr_enabled) {
> 
> To save some indentation:
> 
> 	if (!mtrr_enabled)
> 		return;
> 
Got it! 

> > +		if (prepare_zaplist_fixed_mtrr_of_non_type(vcpu, default_mtrr_type))
> > +			goto fail;
> > +
> > +		if (prepare_zaplist_var_mtrr_of_non_type(vcpu, default_mtrr_type))
> > +			goto fail;
> > +
> > +		kvm_zap_or_wait_mtrr_zap_list(vcpu->kvm);
> > +	}
> > +	return;
> > +fail:
> > +	kvm_clear_mtrr_zap_list(vcpu->kvm);
> > +	/* resort to zapping all on failure*/
> > +	kvm_zap_gfn_range(vcpu->kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
> > +	return;
> >  }
> > -- 
> > 2.17.1
> > 
