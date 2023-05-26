Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26CC712212
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 10:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242661AbjEZIUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 04:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242465AbjEZIUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 04:20:34 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA8F1BB;
        Fri, 26 May 2023 01:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685089228; x=1716625228;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=8ZQ3ivZkINntCrIdDLE18/BeOztbn/+hegVadJ005nE=;
  b=nOq6+UAJGzMwKXYUCUrAPzIWgfTePHrGeFFTtNP8QDdo7xDkyqv+EHAM
   N0kDv1hjA+3lolYk23ZLaUqb2+EzY/GPzdlMDquwv0XZvcjrBimFCa/tV
   75FdQzuzAYLTS5jr9RX7quqoP0fXMOKsCCfkV+OE9Xhr8kOEyDBUbfjLa
   9uTDTKyHEqGcyi1WmDQgWzg+K6z/4DKivKw2yxOyjg3lirm2F36+zyw9X
   /J+CkrmY9GQJNMWdO8c3+Nn3nE8eld6qSonEJEiEEkBJvu2CgiUX06Vaj
   88BxIGTd0qN1yjjP8vBydD/mkzSnW7JOWXHNm83TE5ZXePLYziwbLwNPa
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="440504404"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="440504404"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 01:19:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="705117124"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="705117124"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 26 May 2023 01:19:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 26 May 2023 01:19:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 26 May 2023 01:19:24 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 26 May 2023 01:19:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqWEnPEM03HCFtSHVMCyaGRaDVEoURSNtPF4KVbqSG8dO20Ht8rRArcXtKoV2LER50VLBCQ1nEKU94exscm/tJBazGao58w3YP+uXI+1tl8BJpGRgDhuA2+tMQoPsMJ1gVoLuy/aSI/b08geRF7CYmJjmJu3D6xokoth52he4E4RJ5pgcGoLaMDv9tmw8Bm+eyC96u4a9NVBuCg4tQGsiRTZaQDO892dXf/RFgczP6RQeQ4bicddI4Ac+IbIwJEJlRFGBfRdYX+W+7B5A6UAs86ZU6yGSmKkWr2iVbu/gUbUw+PhP0iuUwBekZMrTvNrj0NdF5FHtE5a2rwaEB+yPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3KrulqFx5lBHNGwxPI+T9ST0/QItADJQNmjVS8PNzqE=;
 b=Eq+fkiM/IqT3YPYy4HT2ZqhngCmBndEgz/61GIMx6tP0VPSP8RG12f6Ii7loPKBaRYq32LuJw8FaUJfkfN1TDDc7h0kJcf5iZL8T3Nw6eUx8aPzGWglFzE/JpZqRR6USlrRnZd/eSKyIiZxkWhMaaaHPDVd+gZmu95CqDXmc13VZ5iWj3ZsncY+h6Em7/H0ZzLkSOMsISq0nQF/gyXVwZtE+sj96bzdXsUKhB/2fa3+vg7o/nNpaFds0RU9G4x0ahqc9u351dSAhzG8DSA3awoonvz2XqiOLOjCxawOMGcW6mBT45KF/wNVOedLBEdNtmNkffHV3CTw0l5MODU/GDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB7470.namprd11.prod.outlook.com (2603:10b6:510:288::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.15; Fri, 26 May 2023 08:19:21 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af48:a141:6dd6:25e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af48:a141:6dd6:25e%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:19:21 +0000
Date:   Fri, 26 May 2023 15:54:11 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Robert Hoo <robert.hoo.linux@gmail.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>
Subject: Re: [PATCH v2 5/6] KVM: x86: Keep a per-VM MTRR state
Message-ID: <ZHBloxxmY/EUyswL@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135300.1855-1-yan.y.zhao@intel.com>
 <3f09e751-33fd-7d60-78cd-6857d113e8bd@gmail.com>
 <ZGxbat2mM6AfOOVv@yzhao56-desk.sh.intel.com>
 <ZG1WsnYST4zLqTnv@google.com>
 <ZG3vB052ubr1vBQA@yzhao56-desk.sh.intel.com>
 <ZG5VlRzJkcwo9Qju@google.com>
 <ZG8z493pfPIOPAT2@yzhao56-desk.sh.intel.com>
 <ZG92dWFxu+ue31Sl@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZG92dWFxu+ue31Sl@google.com>
X-ClientProxiedBy: SG2PR03CA0129.apcprd03.prod.outlook.com
 (2603:1096:4:91::33) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB7470:EE_
X-MS-Office365-Filtering-Correlation-Id: 603aefe8-3b8b-4cd2-8be5-08db5dc1e7cf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4zfWljH4tvTgd2bWAGWMaHMJ6+vpfWd/OdTZnrGkHOQldQOmL1b14/gRE8vwbrd/c/L7QrNCc2bF8DhJ2qHzHEIDNrKkb+Mkr8VOQmmJ2j+UEWAUGUZ1qpLtztKmlEOXJU7d3Qmlfy/7vmtl3gwx5A5+9tdS71yuyhpfRwx7BZR0CONVL4Yd5Oc/pEO1ueafkh+HEhvsmqktvfshNOAb3Kxo6tS1N5sRBJrEh4kk0LmpC/rBwpOsrkw/0zZqYe208Qiq0OS5U3vpNB4GXs02WGOs1Q+ku9WkB84Wc9//IA7Iy2X51YF5lm0toHxkZpVriHFDpw6C2xJKxQyf2FtUc1mG8W4VcUWBPO0UaCgEWilxog6GDZU+2gZkjA62XWVcprDmgc40JkJuQsntP01MOzzy9DZ9zv6K3KoNUnMm5f9MThbs70HzKcrfBPvOEPzY2gy/708YvmEokozSGhwJZOP5ea3UnX4BHvROh0MFnoS7/RSZBZwdorp0mC42QdpwykZo0Yw5nKgnwjAqNBmfCX9WCNXW+8zpbJjWmoCdGQkuIKOFnFzGKuffKa731Bqj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(376002)(346002)(136003)(451199021)(6666004)(38100700002)(82960400001)(83380400001)(4326008)(66476007)(66556008)(316002)(6916009)(66946007)(2906002)(3450700001)(186003)(6486002)(41300700001)(6512007)(66899021)(6506007)(26005)(8676002)(8936002)(478600001)(86362001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mz/KIc/tKyMQKDwjzvn/iCU/cuvpabsjfHSGWWQz3num864xOIYqPvLvDWO6?=
 =?us-ascii?Q?IkNT+LQSWIzW2pxU06w8YvonrXyyijQjRiagsVnTiyASCcVcic0/snXCHDw9?=
 =?us-ascii?Q?rT8abmU2qE6+HNRh3JJYaxqhZhPNkdxJaqW04nJ6GGAUBZrv1raSL1QqhyVx?=
 =?us-ascii?Q?7JHkd+ETtU3aIKvKp0cnTyi7G0uT03wlDkA8yRX04LqGGZlOjdv6876QGvaJ?=
 =?us-ascii?Q?eCKHwt2YcMBCC26hPKqvcvZAABcQ/Fwu1hkIP8IDwXoVL78mFUU08F19dG3D?=
 =?us-ascii?Q?gNDGC2N6qMi7H1L69GZkxmV0i3bBiCDyLebztQAZaIEzmiqKbwEGBaHnYUxl?=
 =?us-ascii?Q?OSuzW7A2b1Z0/QkgFS/Bm3LBeCSCq73HCh1Iwo1omZ8K4eP2Uln8Ju1lSXFF?=
 =?us-ascii?Q?HQ5ueumqytBdL1VIKbtC93wwONerudpB86Q329wQzlyGtVDG9+C8gVdzlIhK?=
 =?us-ascii?Q?etjcc/4j6u41CP1KxvsGBpeS11qyhpSrEsaVvH6hUjo+55407JWBQYLfQjLh?=
 =?us-ascii?Q?WLZHZ1ztkYDUDp8u+QWvUT5mDFkLIQDmBvlE8NqNugPiRNWkLHFRdiz2HG5s?=
 =?us-ascii?Q?PRgOmD1sx3mKQ7A+mSoB2uZyLHN20qLajl0InF8I3dW0ynINOEXajhmHdnpc?=
 =?us-ascii?Q?7OkidbjeCOSkqbgB3B/3ufntnEo/iO976MoJRCAilqhggaI4mXMa5kJS4Lw4?=
 =?us-ascii?Q?zmqw8fevVqnPrkzDDjBfGNjxIHZjM9+hXIvvvzeeQfnFMtLtfO5gSUoDqABA?=
 =?us-ascii?Q?fwnKO8IXootIt8UiiXOsytLpuxdPbbXofzQYM12QnNShlnbMneHp1fH1usAc?=
 =?us-ascii?Q?ligUxTWn+WSXNZSxea/kMkk+WNqDP7mlQxxuTVjmSWFZFai3B9qcpwuT/E4t?=
 =?us-ascii?Q?aFaUh0vXQP58lkCIX6dvYELacuTAfFLeaTtc5sDLfiCr0Suw5Y7ZervqxE+R?=
 =?us-ascii?Q?3jm5GLOSCQjNteWAbqagcnK3IoIF54/WOF248WHyTd0Dg916rS+cw8CN9Hyc?=
 =?us-ascii?Q?DWJnAwvhIH52RdeRA1WpL0nG9I7n34yEsUJcfyNB+zUQ0P7oRNjx48CYP6Mu?=
 =?us-ascii?Q?ujlYr5oyCAR7XL6p9J/3Ht4TOI9AG2aSE6EuOSp54HFuEnqolXsAIbdYICbA?=
 =?us-ascii?Q?hN3ql9dvEYuVvbFIAB6ZwfJd+VFySo5LiMTzr16k00NUxmzyqng+l+ZbYQ9o?=
 =?us-ascii?Q?/DXHgdvcXybAS8DCdJZBVJYls3FNh1h5yVCWI/06jR0PsPutZ9QRH95BlkOb?=
 =?us-ascii?Q?OMMSAwgcbIbgwj3bK7jRJfIkC4o5CcYNMTHaZZmUlcPww1eh89ypfLslH+dN?=
 =?us-ascii?Q?Bp/qKYJr+V87oIPc3kfyfUMnFwjlX2cS2+sRGK1slIljZyo9NFsAZrQoE7iB?=
 =?us-ascii?Q?y3Sl8lzV6cuefFSGhvCLApiU/1JZPSqS873jgHkRWlzOEVMrynuBYZxG+mFm?=
 =?us-ascii?Q?3VABmm5OHDiCSDacXjK7vzfrm2fq3cUkvYzY++6wxqBsmGcIuRtoC3OaJytM?=
 =?us-ascii?Q?hf4YEiym3zGbp2Ng0UIzT1H3Z1fnYSuLltojP1QY8Ql3F9hW2dYxuwjtkysp?=
 =?us-ascii?Q?wV5xm3CmCrBMHSAMUvFHOZt094lvh1diYXRRDi4m?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 603aefe8-3b8b-4cd2-8be5-08db5dc1e7cf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:19:20.9100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bZWKsIv4VqgBnEX4GaxvRjOaEgIzxehzaruKYDn84b2MSw4i/9+GoTY2SE2i8kckNw8/lXmZIKjBR89JM/chUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7470
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

On Thu, May 25, 2023 at 07:53:41AM -0700, Sean Christopherson wrote:
> > > > > So, if KVM zaps SPTEs when CR0.CD is cleared (even when the quirk is enabled),
> > > > > then KVM can skip the MTRR zaps when CR0.CD=1 because KVM is ignoring the MTRRs
> > > > > and will zap when CR0.CD is cleared.  And to avoid regressing the CR0.CD case,
> > > > > if KVM honors guest PAT for the bizarro CR0.CD quirk, then KVM only needs to
> > > > > zap non-WB MTRR ranges when CR0.CD is cleared.  Since WB is weak, looking for
> > Not only non-WB ranges are required to be zapped.
> > Think about a scenario:
> > (1) one fixed MTRR range is UC initially. Its EPT entry memtype is UC, too.
> > (2) after CR0.CD=1, without zap, its EPT entry memtype is still UC.
> > (3) then guest performs MTRR disable, no zap too.
> > (4) guest updates this fixed MTRR range to WB, and performs MTRR enable.
> > (5) CR0.CD=0. we need to zap this fixed range to update the EPT memtype to WB.
> 
> KVM installs WB memtype when the quirk is enabled, thus no need to zap.  KVM
> currently zaps everything when the quirk is disabled, and I'm not proposing that
> be changed.
I didn't explain it clearly.

(1) one fixed MTRR range is UC initially. Its EPT entry memtype is UC, too. ==> EPT entry has been created here
(2) after CR0.CD=1, because of the quirk, no zap, the created EPT entry memtype is still UC.
(3) then guest performs MTRR disable, no zap too, according to our change.
(4) guest updates this fixed MTRR range to WB, and performs MTRR enable.
(5) CR0.CD=0. we need to zap this fixed range to update the EPT memtype to WB.==>we also need to zap WB range.


> It doesn't actually require non-coherent DMA within the CR0.CD=1 window though.
If we don't need to mind non-coherent DMA within the window CR0.CD=1 to CR0.CD=0,
do you think it's a good idea to do in this way...

(1) when CR0.CD=1, return guest mtrr type. 

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7532,12 +7532,13 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
                return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;

        if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
-               if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
-                       cache = MTRR_TYPE_WRBACK;
-               else
+               if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED)) {
+                       cache = kvm_mtrr_get_guest_memory_type(vcpu, gfn);
+                       return cache << VMX_EPT_MT_EPTE_SHIFT;
+               } else {
                        cache = MTRR_TYPE_UNCACHABLE;
-
-               return (cache << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
+                       return (cache << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
+               }
        }


(2) return MTRR_TYPE_WRBACK if guest mtrr has not been enabled for once
u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
@@ -628,13 +635,23 @@ u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
        struct mtrr_iter iter;
        u64 start, end;
        int type = -1;
        const int wt_wb_mask = (1 << MTRR_TYPE_WRBACK)
                               | (1 << MTRR_TYPE_WRTHROUGH);
 
+       if (!mtrr_state->enabled_once)
+               return MTRR_TYPE_WRBACK;
+


(3) when CR0.CD = 1 and the quirk is on, return MTRR type as if MTRR is enabled
+       ignore_disable = kvm_read_cr0_bits(vcpu, X86_CR0_CD) &&
+                        kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED);

-static void mtrr_lookup_start(struct mtrr_iter *iter)
+static void mtrr_lookup_start(struct mtrr_iter *iter, bool ignore_disable)
 {
-       if (!mtrr_is_enabled(iter->mtrr_state)) {
+       if (!ignore_disable && !mtrr_is_enabled(iter->mtrr_state)) {
                iter->mtrr_disabled = true;
                return;
        }

(4) Then we only need to do EPT zap when MTRR is enabled for the first time
and when MTRR fixed/var entries are changed at enabling MTRR or at CR0.CD=0
(I prefer at enabling MTRR, as seabios may do the MTRR disable/update/enable when
CR0.CD=0)


Besides, accoding to the commit message introducing KVM_QUIRK_CD_NW_CLEARED,
we can return MTRR_TYPE_WRBACK for CR0.CD=1 only when MTRR is not enbled for
once. (And I tried, it works!)

commit fb279950ba02e3210a16b11ecfa8871f3ee0ca49
Author: Xiao Guangrong <guangrong.xiao@intel.com>
Date:   Thu Jul 16 03:25:56 2015 +0800

    KVM: vmx: obey KVM_QUIRK_CD_NW_CLEARED

    OVMF depends on WB to boot fast, because it only clears caches after
    it has set up MTRRs---which is too late.

    Let's do writeback if CR0.CD is set to make it happy, similar to what
    SVM is already doing.
 
> Yes, we can ignore !X86_FEATURE_MTRR guests.  If someone wants to run such a
> setup with non-coherent DMA, they're welcome to send patches and write a lengthy
> explanation of why they want to run such insanity :-)
great :)

> 
> > > > And pieces of no-WB memory might produce more kvm_zap_gfn_range()?
> > > 
> > > Yes, but they'll be much, much more precise.  And the bajillion fixed MTRRs can
> > Could we instead keep a per-VM copy of MTRR?
> > Then, if a vCPU modifies an MTRR entry and we find it's different from that
> > in the per-VM copy, we mark that entry dirty. When CD0=0, we just zap
> > those dirty ranges. (or just zap all if there are dirty entries)
> > In theory, only one vCPU will trigger this zap in each round of MTRR update.
> 
> I don't think tracking "dirty" MTRRs releative to a per-VM copy will work because
> of the weird behavior of the quirk.  E.g. if the below happens, vCPU1's WB SPTE
> won't be zapped because MTRRx wasn't "dirty".
>
By returning MTRR type (as if MTRR is enabled) for CR0.CD=1, we can avoid to zap
entries in this window. Agree?

>      vCPU0         vCPU1
>      ----------    ----------
> 1.   MTRRx = UC 
> 2.   CR0.CD = 1    CR0.CD=1
> 3.                 SPTE = WB
> 4.                 MTRRx = UC
> 5.                 CR0.CD=0
> 
> Another problem is that while only one vCPU will trigger the zap, KVM needs to
> stall all vCPUs that dirtied MTRRs *relative to the original per-VM state*.  E.g.
> if the per-VM state for MTRRx is WB and both vCPU1 and vCPU2 dirty an MTRR and
> both clear CR0.CD, then KVM needs to stall vCPU1 and vCPU2 regardless of which
> vCPU actually does the zapping.
> 
> And when handling the transition from dirty=>clean, KVM would need to prevent
> writes to MTRRs while grabbing the snapshot of dirty MTRRs, i.e. to-be-zapped
> ranges, in order to provide stable view of the clean per-VM copy.
> 
> In other words, the net effect will essentially be what I sketched out with the
> precise zapping, but with the added downside of serializing writes to MTRRs while
> transitioning the per-VM state from dirty=>clean.
Yes, the net effect will essentially be what you sketched out in last mail.

I can try to figure out which way is more efficient before sending out next version
if you agree with the above direction, i.e.
(1) Do not consider non-coherent DMA when CR0.CD=1
(2) return MTRR_TYPE_WRBACK for CR0.CD=1 only when MTRR is not enabled for once.
(3) return MTRR type as if MTRR is enabled for CR0.CD=1
