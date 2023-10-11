Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8ACE7C47AA
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 04:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344777AbjJKCPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 22:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344770AbjJKCPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 22:15:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FA7B4;
        Tue, 10 Oct 2023 19:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696990538; x=1728526538;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=X7qL6Ak8blVkedDoqpXiHgElMvEj0cMEE/5gwQBSC9M=;
  b=bin8bE/pfCta5VlMQ2RULs+0i9RGDqEJ+xEOgq0fBBCK2j/HJXIfnxmi
   GV+HNxTNJ58vKkebT3ZVuaegeE4Pd+CAC9KJZNJa/diE+b0KxsTo/oSaO
   qKhQwkok6fHSrWZi+jAaE4FejKg7SZy4AB18+BRKRPqeuMauYM3Q2NLMA
   MpDg8Z29LCpoxCQeA1G4cmJQmtJEav6NsJVUHNz0FfRN+GtXC8gyHvPnP
   3pGQUUQqKxPHoZwj0yjYJ0iciX9lKXR0dGH/w7UmgBK/VP6BwEVvULjnx
   EE70bS44hm6DKem0M7V4hXKQMyIpICx6E4EL0Y83gI8Z9mmwq08XmmD/3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10859"; a="415607842"
X-IronPort-AV: E=Sophos;i="6.03,214,1694761200"; 
   d="scan'208";a="415607842"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 19:15:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10859"; a="819497558"
X-IronPort-AV: E=Sophos;i="6.03,214,1694761200"; 
   d="scan'208";a="819497558"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Oct 2023 19:15:38 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 10 Oct 2023 19:15:38 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 10 Oct 2023 19:15:38 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 10 Oct 2023 19:15:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EP0prQ3RHxby6uYw46N56oxEgQxO4P51AyZh+16VYf4+ovl0/e0d3z4tEL9rNMXFKf0xNu0q1RkDGEx/Yrb6R/azhdc/uLvGO6s/ikqfmDhqcLM3+aYGmWC4ruDMAiDnYcMSzrMnsEMucOPa/NkumyNurdMbtsvP36AXhJFgHU1T8NRaVD0/SuVW6zdNxxFEZTOhFY8bxGueM/VJbsN5QitVjhBAIXbzWWI98SjeoZR7sl9icKCyGqVCnyFZyxrzl+x+vErKkJLyhYGVfJXR9Pok2fgit/EhhkZ6DDQoE0/G+i1H6dbdEPLTDSopMbNA+0GOQZuvIXz/MHCUKEXq5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=opb43sazUZidPn8jrIojSEGc7qyYD6p81OH93hF/8x8=;
 b=GJJ6Ys7H1eJP8b9LFe2AqxyiEJny/NS2/jMfqg2j8iuuUQwdF1EKLTPwNxiAaHJVdTR0uD7D5JjWtZ6LXa3rihOIiHbpvWZX/Bm/jUpdbLIQPGEi7Wkw6OhdWFYU9JUrn59bfbugjLKqr3jz3VvrGh+Hl6E4Ab6vX1KMtiJPyyB0Ilku1a4sMxcw7E42WbqJzKqMNQk5nmP/Hjk7ELV8CbM86YvBx6GnvD4H0I1RisO6DxBOTwlzyZKX/7cxWq66ggqvGYWlaR4Wmn9MmELg0A91v5OxUrVm7GftMOgn7d7SSVZSFKB8rGJlA07PbD4Eyx5UnZMPhmIVaWxO+5KCfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB8719.namprd11.prod.outlook.com (2603:10b6:8:1a8::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.41; Wed, 11 Oct 2023 02:15:36 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602%6]) with mapi id 15.20.6863.032; Wed, 11 Oct 2023
 02:15:35 +0000
Date:   Wed, 11 Oct 2023 09:47:28 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Like Xu <like.xu.linux@gmail.com>, <pbonzini@redhat.com>,
        <chao.gao@intel.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>, <yuan.yao@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 01/12] KVM: x86/mmu: helpers to return if KVM honors
 guest MTRRs
Message-ID: <ZSX+sODaE+zQr/AW@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
 <20230714065006.20201-1-yan.y.zhao@intel.com>
 <553e3a0f-156b-e5d2-037b-2d9acaf52329@gmail.com>
 <ZSRZ_y64UPXBG6lA@google.com>
 <ZSRwNO4xWU6Dx1ne@google.com>
 <ZSTJEJepdnmC5PA5@yzhao56-desk.sh.intel.com>
 <ZSXnaIi454ATEdH0@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZSXnaIi454ATEdH0@google.com>
X-ClientProxiedBy: SG2PR02CA0116.apcprd02.prod.outlook.com
 (2603:1096:4:92::32) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB8719:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e1d516e-5a19-47e4-bd5a-08dbc9fff409
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wqooJOdq7DHVd6EvVpm4J25uD2B5X+fA00gZUV4jYNB1VQhU1h+By2yj1WOAGQjS+ZDVzJ4tNM6+NwssTncXILzirhbge5oX6Eo0iQABeGHOQEyhCEotalNqFUSUzpeFLRgPJ6EA8e5RM/ObmFfhasi+PKfGNhRElRp6c2UTpYseDInb+9XC9urySfm0efx6D9CObWJJKO6p1JnYklaOmksjVhB2IIBpK7FJWi8CRqk0h82nW3O2uwYwCLaEIfOcNYEJAwUcJnJljEwTyXLlHHEq9o9jdt1fnAsa/Ikh2J+nKjoCH9odYfmLVcfm+1Tk9ot0Skeo8k/ctXRWYk28YwbcyRsMgC/FgFwqme9R3WmYG09B7sDLnu5hRiz993vBz0nKK3rFg8FAlqLaMy7z7Kq4OvkY8Q2pvrF9XKsfhn/5PzSFRWhV3nHG+jTgESDWfspZ6uGCu/2t7rhYBGXL+9QDhh7VEQ6riMTf+cLZU6KtCK41mGY/VV4bX0VX6Firzot9IjdTflV42zEqOJjIhHGI4NY7kSmX/umY8Ms5DlMEshTRn2be/EdeTIQNIm8hsTvneSe5eKG3+4S2uebjzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(396003)(136003)(39860400002)(376002)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(26005)(54906003)(5660300002)(966005)(478600001)(6486002)(6512007)(6666004)(6506007)(86362001)(41300700001)(66476007)(38100700002)(66556008)(66946007)(316002)(6916009)(4326008)(8676002)(8936002)(2906002)(82960400001)(3450700001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CjNSwprbpPjA10eJIk80r+iz22DzpGePoDoGMa/F46Q5CFxXIDnZ1/kY7gci?=
 =?us-ascii?Q?KXVcPKaywdayNts4IoQJzIJnrh78qcrPx4mVwR3bk/nClZg+zdH02Zjkh0BM?=
 =?us-ascii?Q?m1UfZwdy+yo0Ws7++LZ2Z01hiHd8phVoYlTpXiBeFimI4/7M7mPDlsjZ3p+h?=
 =?us-ascii?Q?v6HmsiNQC7SAdenrzwFSnfVFw/4noHIi0ek0mSP45RXdZoaMUH77IPBoa4hl?=
 =?us-ascii?Q?E6eQuZa7M/hG/U33ST/OI7z7k4l4YYEPgA/oS5D1A/dCe61FgF6MHmUld+Hy?=
 =?us-ascii?Q?C6QVQeU/nP/+zHSeXlDGU2p/LEivOBI1SG8euxTpd8D6PcGZVxSLrrJYtwTl?=
 =?us-ascii?Q?NN82VsZnKDP2F5r/jyu3GMO4pmycXXcHDbrW8jr0NG8YvlS7yWhOS37HsFiM?=
 =?us-ascii?Q?mq+Q7VN2nsFQuweLULozVNYvT20GPfiL+E9e8aT5h2+OpxtmVjOVe3hvFgPh?=
 =?us-ascii?Q?hzeD2DH90HOK2D/zVpPndSmznxygf01RvUKI3HQgHdlrxSu8YUI+b43h/ueD?=
 =?us-ascii?Q?EZMx2/6Wv82FWm7yQZtaQQXmmR/rXGmE0RZ3UhsjEQXvqB1CbmUiNxa6kD+P?=
 =?us-ascii?Q?ruROdgeZJRJijwj8b82h7rZ1SNBfxZPVkkrmD5h28jgUGx9UmA/D66w0HZHl?=
 =?us-ascii?Q?jRaZ1BytlG7qgVRRBOGe8kKnmW3mpFSQz4Y/lL7pGi/HjIQ3TB24onjc8HF1?=
 =?us-ascii?Q?cSEIZ9MpWmGdpulW/rJdr7G4n884crS1LjpTcwQVLuXdayf+X2P9xRor3q+0?=
 =?us-ascii?Q?IPmakQEFMZtE3Rmi5A0xfDOTY37ELn/rU/8mnNBBWAklQaEfAO+Cy3t12P2U?=
 =?us-ascii?Q?9eKEffgzmrrCfjqveUYjVk440t/u5pgwJ7+BFks5coNrOtm7gh35SKh+nHuW?=
 =?us-ascii?Q?fx0QsfkxV/69GuHeYMi8c5gj1ORDgwyae0+rXjhsLUZQvrcQ4iCVGF80gcRM?=
 =?us-ascii?Q?zsv/Y/TvMkxIBobQhXNlqqUyKNp2/y8IjSoEboqciooiC4MnYlwLluJp5GcT?=
 =?us-ascii?Q?d2bnL3QQHvdTOAxxDKkz8PIBbThPjCmGt869us8zPonvBokryqPmuaioXS4H?=
 =?us-ascii?Q?tqvClQ75mAFIDFNZcfpIR/sq366q36cZd6yy/YhJbN4HGsGXyJdWtkRhEwVj?=
 =?us-ascii?Q?gOmTVL9aPFP+xNAOGaKcbzYai1kvaKC/LYi6CPrfDauBZYIPM+cE9VqH8IhF?=
 =?us-ascii?Q?0MuSF8mcwawAu6i8SxoJuQhRZGdnl/1a0znDIbSC3dX064mamn6c7pobnwE6?=
 =?us-ascii?Q?NXByqYitzXoqSTb+qFjrvCWM5Tme9v4umQgJcHG7uX1vIJEW1XRuBKplB+QN?=
 =?us-ascii?Q?Uuo9Evl7sDkTnbuhBmijeiZnIET1Elva+TV5o02rgoqNzUEQD7Eq9M3SYoOK?=
 =?us-ascii?Q?oyEMa0zuhNseLd1/XWMKjwuq9aDf6LxMSmATTm5g+e7lba0Yv4Eer5ebUv7O?=
 =?us-ascii?Q?gWVGYv07kbYHni6bFqHcW9Pui7qkVAnDySHN9s53oP17SGDphjgRE0hrEU/t?=
 =?us-ascii?Q?GzNhd1LWJnM5w0KWlcuBpUd0FsUeP6z//UP59MzJyVkm/MdJiCpLr9sj/9t9?=
 =?us-ascii?Q?CaiaJPfzV2O0Eil1UycqxPeBjQYDku37ipDg3+F+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e1d516e-5a19-47e4-bd5a-08dbc9fff409
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 02:15:35.2454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aWwLMeAtIAhiKL3WlnbYYXw8x7uLbW81W6USLP7UDSaIEUD5PwwRAaHnhjc3pTc979e4dsuHXW1XtgnAH2IoAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8719
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 05:08:08PM -0700, Sean Christopherson wrote:
> On Tue, Oct 10, 2023, Yan Zhao wrote:
> > BTW, as param "kvm" is now removed from the helper, better to remove the word
> > "second" in comment in patch 4, i.e.
> > 
> > -        * So, specify the second parameter as true here to indicate
> > -        * non-coherent DMAs are/were involved and TDP zap might be
> > -        * necessary.
> > +        * So, specify the parameter as true here to indicate non-coherent
> > +        * DMAs are/were involved and TDP zap might be necessary.
> > 
> > Sorry and thanks a lot for helps on this series!
> 
> Heh, don't be sorry, it's not your fault I can't get this quite right.  Fixed
> up yet again, hopefully for the last time.  This is what I ended up with for the
> comment:
> 
> 	/*
> 	 * Non-coherent DMA assignment and de-assignment will affect
> 	 * whether KVM honors guest MTRRs and cause changes in memtypes
> 	 * in TDP.
> 	 * So, pass %true unconditionally to indicate non-coherent DMA was,
> 	 * or will be involved, and that zapping SPTEs might be necessary.
> 	 */
> 
> and the hashes:
> 
> [1/5] KVM: x86/mmu: Add helpers to return if KVM honors guest MTRRs
>       https://github.com/kvm-x86/linux/commit/1affe455d66d
> [2/5] KVM: x86/mmu: Zap SPTEs when CR0.CD is toggled iff guest MTRRs are honored
>       https://github.com/kvm-x86/linux/commit/7a18c7c2b69a
> [3/5] KVM: x86/mmu: Zap SPTEs on MTRR update iff guest MTRRs are honored
>       https://github.com/kvm-x86/linux/commit/9a3768191d95
> [4/5] KVM: x86/mmu: Zap KVM TDP when noncoherent DMA assignment starts/stops
>       https://github.com/kvm-x86/linux/commit/362ff6dca541
> [5/5] KVM: VMX: drop IPAT in memtype when CD=1 for KVM_X86_QUIRK_CD_NW_CLEARED
>       https://github.com/kvm-x86/linux/commit/c9f65a3f2d92

Looks good to me, thanks!
