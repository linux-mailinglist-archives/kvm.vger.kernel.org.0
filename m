Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210FC73619C
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 04:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjFTCnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 22:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjFTCnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 22:43:15 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CE510C1;
        Mon, 19 Jun 2023 19:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687228993; x=1718764993;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nnUYMrJWUnVY6vgXDEl6oTzlpnT26K/ZW/xcdKImzyQ=;
  b=DlOGyXlKGTkiZIuDhU+OA4iu/GFek0C5He20fRRV/ttoMHPjRxRPCWD/
   IgRDVh7nQav78kQGlJYCT9pOnjq4PaZ3B1/kHjU2oYNSMvjvUOp2P1OkB
   3fssKE6d4iWBioBPtR2PVMZvEcZKyXVavClStVhzWAX7u7pekYsKId7tT
   74zqrG27c9PMQ/AYf557Mm4zIUt1YRtR9oRjKmi3z8BOpnRBMi3Uywed4
   dkqFTO7XftZh3fmANp/f1Ec6CaJC9VP2X3P0PwDyrBx/TGKZ4lRqhzMSX
   tUE9KVYFqQSv+3atEtV8lF4Ly8UOoAcrWX0GrtCHe2ehQy5/bO9ykbKFJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="344494227"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="344494227"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 19:43:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="960599383"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="960599383"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 19 Jun 2023 19:43:13 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 19:43:12 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 19:43:12 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 19:43:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWb4QHwpySeLyolQiZ/mUY08GjVKfS3Kfh+CfQjrItBgaUoLcnzxoOs+S2yi4AwT6gIRBNKHeWgwqaerYlhEtDDk8hh7k0SoT2xxamy3WX/QRJvOZlG/v5pnEDmRJoqQjhJ9fw0iTqkiwSVo3Rg7brQ6q38y53sqJdg5PmR9GRtSkSCJnLHqmRx178gsffUpjruZUTebNkNikDXMlJhoRnI0mu2TSGP469H493gV4IRLdgaeATi+x+7Sw46cYA9fDuX+act9gQjP6VebXvSkTVXiEuP3AGqIXVfdSIuh3MI1IIWwW+0gUMzkPAWmWPH63O5f8c8ahM4vVQ2BuwwQVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Od5W5jniSgztpYHVhpBGOLzcoqWsLgTZP+W82MJqBhE=;
 b=fO4b7Pd4I0Adtwb3f0ybDfpJndKk85LjgMEp+hGPh8DkSS/nzfht+bExaWcRAbN7pqQJHDJbLojOZPZ62crOgyu8iIm0EMeUu+Xo3Ma5a3RWJiTH3mPxWcDM7NdwYoxGUqFDJYYP5VZh08xMo5sujk7xUVie/ZniUNyX8DLDA7nxXpoL+JERkybqzEBsfL1zvRSltB2oNWyryOblJMC5O4lUWSe5fmPJiTfOZZ5pOtySyro00oH1YBOKk/71Qi/CTtiLdnuVledItNJgvv5V/MpjfGKy9Je5cNAtoJLYordbk1L/ANlnFgsO1QMTSGr0bwJFwwj7cRHDzyQo/xnTrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SA1PR11MB6870.namprd11.prod.outlook.com (2603:10b6:806:2b4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 02:43:08 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5%4]) with mapi id 15.20.6455.028; Tue, 20 Jun 2023
 02:43:08 +0000
Date:   Tue, 20 Jun 2023 10:42:57 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 07/11] KVM: VMX: drop IPAT in memtype when CD=1 for
 KVM_X86_QUIRK_CD_NW_CLEARED
Message-ID: <ZJESMaG5Thb5LWtt@chao-email>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023815.7439-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230616023815.7439-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: SG2PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:3:18::22) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SA1PR11MB6870:EE_
X-MS-Office365-Filtering-Correlation-Id: a8d9974d-d008-42e5-1242-08db71381452
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EMCZddYLRH7BA0Ob3Pxw/isHJQnx6wEmEUapvyFvrDjPe/0ZiI9y+OF6WOi9Trq3T7/WAfuESDoje02/E0wS5t0biQcE3/imQ8OG3X7/pBgxtPNh94GcKjmwLlBcz5ANxebXcc2iHCd7i9FFCLYYKRACevs8dtu4fc4vNJLVoojbuka71l8csWPyq4SEgYDSS0o58i/rzslbSKpBOpTRDf7+ggt9hpUqz0rRxs7Zn3ISYV7WRPl8z5Rqlqgf1/3ejE/oP/Ni9K7MNBtE0C6jATp5G5C2Y9VKEsBQzxPEm5VaRUvomvUDDj9rwAqtZVIB1GWRusPu8f3VirKKvc/B1FCui9ixHqX5aKJ0uDkpABYaGWjL4tLdL176TVvK9CvKTzHW6wJYFg+uYR2aOrSPbFoecbxCkZoDq4WXWOl5mlXYL2UVQE3NZ0sU0U3jcJFWdgNMMai4dslQBMbb3+Ov3RuHdPqAHu33OlkVeMWkHhnYcG5htaaYEah0t9LllRhGf2AQ5aIUpLA0o6CDmA28oV/GtHwliwEB2OIkVeOc3iuuwrVjWfUL2ViGx697EoHU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(66946007)(8676002)(66556008)(8936002)(66476007)(26005)(186003)(6506007)(6512007)(9686003)(82960400001)(83380400001)(41300700001)(38100700002)(5660300002)(6862004)(44832011)(4326008)(6636002)(316002)(6486002)(6666004)(478600001)(2906002)(33716001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rg99VO7qzo8O4ca8C9cZNSguIUkOa4e+hp4Q08oCFckyC03UgVde2CU4l2WD?=
 =?us-ascii?Q?JUiM+ula0TqyZKzK4JmdoLiTV4l3doQ5YLcwJCJV/p22UMnfPeka0AtlZHbu?=
 =?us-ascii?Q?New/i8CFIBq+nR+xO2VwlQlXg2ipohyl1W/S+mtdq2gVFiZlHskRM/ggS39G?=
 =?us-ascii?Q?6aGNpbnLn5HWX5CzFPSMaO3VgUJzumqR4T8/fm1waKWmr07su0YKyzlveWSA?=
 =?us-ascii?Q?NC/owl54aROT/Xih/kNRdE/EBvei4ScpEWjNqFyonUma/zkPh/i/9JijxXHq?=
 =?us-ascii?Q?Da32F2AVEEr68orq7HSbrkK/GrQ+UkFsO3o9krf287P/dDj06WZcyNojdGbz?=
 =?us-ascii?Q?WZf7+nsdIxDmn3PTEPoJWneMyaIltP2wq+c3/IKyASsFdES69l4DtPPQn2lm?=
 =?us-ascii?Q?BhQs042EIYuFrZEcJRjE1r8uoyKGPYjEwZPL/qcful540vF6s8UmRKQSWks0?=
 =?us-ascii?Q?8WF9cuetmB7MqdM+usHxWGQS5wEo2W9TpH1sVp/7CJNedqCYb9iFnr6aYXfJ?=
 =?us-ascii?Q?J+E/YmDZ5mQ83QdJdruIB5BBLgSZ94yGLCjI1Rcn3y+/4sb36f4Mu0fWjJME?=
 =?us-ascii?Q?EBab8kv8+Y7C1sM2lFgaIsZLXurgSnhw5Y87vPaLMSF+LWxqffwrk7yXO3Jw?=
 =?us-ascii?Q?DoTV26Z0DxrMEfmLLYBOrswXJGMUUFUxq7hFkwoT3KBtlEo0R1Wsan/4ioAr?=
 =?us-ascii?Q?5Wq4AZy1u1WlAUify6V+zIBeb6oiFXbYUsI3qzf7HvEbZ9qvSdOciJ3RHUhm?=
 =?us-ascii?Q?aHyLHAxIG8ND3gtvcJlGzTyJG4A4umlhPuiXKyJLfGd+LlMfsOP53CyWMhea?=
 =?us-ascii?Q?RyYywlmY7YHCRQ6Qdf/kJqrkkayE980+8j2KZc+3fu+kr2cF1Hr878uSrLWK?=
 =?us-ascii?Q?B5SdRzxUYO+PreUQuxUDJdYwjVdmhI2Xn+L9bnnyNgSHHtdKT8jEfA6RuN9X?=
 =?us-ascii?Q?cFCVI8gNgOCFUYtAVacdHFeQ0D9puQvNjJjGACF0aLEKmpZ4r5rORvYizuve?=
 =?us-ascii?Q?aQNzWQy+QeynPivZDV2P6et7ya6/ceDImKjzGSy9zW1G88SnNfQtz1/Q6Wmh?=
 =?us-ascii?Q?iPN8Mzr3kPMyC4iXqK7fIBMUBPy0ndyPtonsjHxyAto0jbVjJ47cxPPG3nH4?=
 =?us-ascii?Q?u9iR61tmkA3v67mrjUGz8lISYoGJcdVLRz9jt7K4hjSFWNh6SHgYJ70ye5l3?=
 =?us-ascii?Q?9xfWOl8TM9nBYaw1L1enffr1eZsiRFnGaX3UYnaZuMBTiieUOQ05Iu7tO1M0?=
 =?us-ascii?Q?j27a8XaZBBWUffWIeKaH3u53/y8vfVXMzSwUI9UlYcxGeiUsKMsQN4X4oLGX?=
 =?us-ascii?Q?2ej77Q3NYTPUXXaYj9Bhw7O6E72t52jr5bXy0uyYT3kGkbYcKPXLezvhqdCW?=
 =?us-ascii?Q?PnAVipYQ+P8/cB8u3p2/zcSBb9G2O6mwhw/laav7O+xfoSNvuMr9XljHb7/o?=
 =?us-ascii?Q?1eNTBxK+3Y9V+YOASwc2t/FANWQXkDP5inirNnoGNnimQ7H8abWWWFvcYI0Y?=
 =?us-ascii?Q?ARv1slfSnr5NNu+jIBoR81oxHfp2OHAyBCZM0YY44Ejg2LW5PJyUjx8QFYiO?=
 =?us-ascii?Q?P3O5z6OEcS0xLTpqCSfPh4R35u0INK8/gS3bcPOF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d9974d-d008-42e5-1242-08db71381452
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 02:43:07.8555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p7mdGYDl2bo/ka509HsSK6pM50himyYnGN7mxSVKmwmZipFv5Bp7sh6RN2BIHKBV5paoZk113FD2l6spEI7Jgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6870
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

On Fri, Jun 16, 2023 at 10:38:15AM +0800, Yan Zhao wrote:
>For KVM_X86_QUIRK_CD_NW_CLEARED, remove the ignore PAT bit in EPT memory
>types when cache is disabled and non-coherent DMA are present.
>
>With the quirk KVM_X86_QUIRK_CD_NW_CLEARED, WB + IPAT are returned as the
>EPT memory type when guest cache is disabled before this patch.
>Removing the IPAT bit in this patch will allow effective memory type to
>honor PAT values as well, which will make the effective memory type

Given guest sets CR0.CD, what's the point of honoring (guest) PAT? e.g.,
which guests can benefit from this change?

>stronger than WB as WB is the weakest memtype. However, this change is
>acceptable as it doesn't make the memory type weaker,

>consider without
>this quirk, the original memtype for cache disabled is UC + IPAT.

This change impacts only the case where the quirk is enabled. Maybe you
mean:

_with_ the quirk, the original memtype for cached disabled is _WB_ + IPAT.


>
>Suggested-by: Sean Christopherson <seanjc@google.com>
>Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>---
> arch/x86/kvm/vmx/vmx.c | 9 +++------
> 1 file changed, 3 insertions(+), 6 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 0ecf4be2c6af..c1e93678cea4 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -7548,8 +7548,6 @@ static int vmx_vm_init(struct kvm *kvm)
> 
> static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> {
>-	u8 cache;
>-
> 	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
> 	 * memory aliases with conflicting memory types and sometimes MCEs.
> 	 * We have to be careful as to what are honored and when.
>@@ -7576,11 +7574,10 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> 
> 	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
> 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
>-			cache = MTRR_TYPE_WRBACK;
>+			return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;

Shouldn't KVM honor guest MTRRs as well? i.e., as if CR0.CD isn't set.

> 		else
>-			cache = MTRR_TYPE_UNCACHABLE;
>-
>-		return (cache << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
>+			return (MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT) |
>+				VMX_EPT_IPAT_BIT;
> 	}
> 
> 	return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
>-- 
>2.17.1
>
