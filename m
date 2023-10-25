Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B457D6495
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 10:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbjJYIKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 04:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbjJYH6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 03:58:52 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F55199;
        Wed, 25 Oct 2023 00:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698220079; x=1729756079;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=etvudi2QnFqDTA790I0Zqp8Si70Hab5eBkf2va63euU=;
  b=g8Jdd9gnmcSBEdvzXLMi4QGm+x8f6iJzh5jrWmS2gWU5puomb/zu+vyN
   GZVVpOBsOJEwvNcAwjRGtSi9FnatB4eF5V29wfE6dTseT2i44G38ouYy/
   bM8AJVkUOOjDmKaryTySNExbuIGfJuNEfWty0p6h+PeQ4xkvvVQaU/HAS
   D1du25rOB2PopuOuGUUbf/NkEm23ovSxYG/f/I2MYV9Etqw5dnASVWo9i
   wuzATVhXKxikQWHcpWoJoah6s+aKwGKAGWrcTirAmsoIKBs29mi++BTD9
   rgjR8/1yfgSqVs+rmOmIrI4XqShUXW8rV8Vl8nx0fzKaW6V55JmsjtHZ9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="418380015"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="418380015"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 00:47:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="17553"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Oct 2023 00:47:20 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 25 Oct 2023 00:47:53 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 25 Oct 2023 00:47:53 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 25 Oct 2023 00:47:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0Bz8IBN2vyg38NAcXBL879YMTATY3USpIToXs58Y1zkrv/x/LaQzapSazyeoUX8xhp6EU3SNbryOdWDcvlgvlvgf2pMZQw0rCXVQYCJPkmcRZfeKqMjLQiSPQxh6wRgbke7Vzpds6tLcEa54RXxY2tCEmkbM+mR9dwuhzEEtCchJrO7Rn8kvJrSnPgoVI44AGq1ZVQwGhwJ8m9Tk6FM4pp80sXQtTPjPJ8vGhhg/PhlIrX8MTv3d73x/znwaOq/jVudtgXpK3aAALCNPuqGVvbulHwM8RdsehB3j32y6qIoPjgV4xAZsAfdCkk80dKRnmXzaupo96UtNnp7qVA1PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sHm8u7v7WYWBUt9r+yyNAy759u607HRrLNBWERXOKAE=;
 b=kK3vLQIZeOmUzSFQ2y42tEtef+UbysjIsw2dyDAseHYhE+GYs7IxHbO8Rs4yIZWwyN34/ydNtpvqhi6s0SiwN+K7cWGmwnT6rtbk5VBi6gkJ5qBRfV6IvHXcXh7cVpi7g6pnFedkKGIevxl+c2jb1K1zcMo3quhpiOQc4AN/t8ZFhcuhD0bOiWbxXyVsamvJzLNISEyj2+ggThqHIwyGsNs9siuiAFjF6Qi91mOPzg1gs8Ac/hdEUBLiK1tbORKED7YHxtJshcF/e0hCIMB2ESN2NcNg2T40+sWElw3gSuYafRWTRnzB7ITcMIbqJieIhRN/wpBoUZu2r9RSkIugWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DS0PR11MB7335.namprd11.prod.outlook.com (2603:10b6:8:11e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Wed, 25 Oct
 2023 07:47:49 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::e14c:4fbc:bb3:2728]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::e14c:4fbc:bb3:2728%4]) with mapi id 15.20.6933.019; Wed, 25 Oct 2023
 07:47:48 +0000
Date:   Wed, 25 Oct 2023 15:47:37 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, <tony.luck@intel.com>,
        <ak@linux.intel.com>, <tim.c.chen@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        <antonio.gomez.iglesias@linux.intel.com>
Subject: Re: [PATCH  v2 6/6] KVM: VMX: Move VERW closer to VMentry for MDS
 mitigation
Message-ID: <ZTjIGVE3o4K7O9kW@chao-email>
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
 <20231024-delay-verw-v2-6-f1881340c807@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231024-delay-verw-v2-6-f1881340c807@linux.intel.com>
X-ClientProxiedBy: SI1PR02CA0025.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::13) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DS0PR11MB7335:EE_
X-MS-Office365-Filtering-Correlation-Id: 584ec627-4143-408f-31f2-08dbd52eae8c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yty6LGPrZ4uHfGHAke/ykBPrlPvj46lZZ3iTuHBEFHf6rdgaXYpWFfV41/B7/voNLfiuO3ZSGx8Vfvh7wSo0oHIgoMjpOeVXd4v9S6I+DCcq3/Qpcf1UidNM5G8Vfcs/HcINdMpFxXWpE5+Gzo4DdWwp+TSed4bXR0oHHmVm3bhsW8k6DrHB1r4wif0aETpmXLimzQF04/UYbfFrnDXPr5ROfSF6OiZUf0E8ZjvvRYKRC53+scnGZ9N/gZSGV7cot99mnX0FHj8yk1J2vlY4spdvjLlT/Os+2PB3eGlra3AJNzrkVb4W2JW8kqd5/gVhOj2mwe5ixlvRE+fIKBJY+gMra3UVmxkyGqDVUFGDm56wXiQA4rmudQeBMGENf14o3AbtFSIHyzen5hNDV/rGSZigxkWDbF5l+TQq5EQs6o9ZoAWq6qaNEhhl9N3qNU2vRZoF2i8AlYs4556NnBqqIPpPKgDbkEG3VU+238PDG7b2wEVGC8LGkA74o5VMX6zW027W3nrARMw6DdpMoEaNbC6wtHE3v1acp3kTvEyDfLdWvSAjm/jkkkRRlt3o3VjC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(376002)(346002)(39860400002)(136003)(366004)(396003)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(2906002)(5660300002)(7416002)(41300700001)(44832011)(8936002)(8676002)(4326008)(38100700002)(83380400001)(54906003)(66556008)(316002)(66476007)(6916009)(66946007)(6506007)(9686003)(6512007)(26005)(86362001)(33716001)(6666004)(82960400001)(6486002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lkXeN7cvffV61e763/aYzcMj5wy0eR3cHsVRmZA8ncytKYanOFdNbpJOLogH?=
 =?us-ascii?Q?9SWlgh5nGr5KC3THTw/QJ3BSOQGTalRJ+JEPasoLj9iKTcy++YBUasWXbG27?=
 =?us-ascii?Q?IRAT5EbUrpwBljp7go8DXhLrVvm1qy1Iy22YMJBaLsvPV1woJfp/jATJNeZr?=
 =?us-ascii?Q?dHLjoT6C5a+GgIl/0SmtQ6LqrTjyXnZLqhoA3zzqAX7bCAAstC/N9p8jWpVq?=
 =?us-ascii?Q?P+QWK/Q9Lk7mOMAi8qpXQ253VhCr/k4aw3dO+RdLT5uOXfytLYsOi+EXxxNX?=
 =?us-ascii?Q?Lw1N90Sf+qEn61BtuXzZLHimfZIajP/yrRtxbPXOb1JImBphaCj8g5ZLetzM?=
 =?us-ascii?Q?2jYUwhAxhifUPCvxZ3vKbBMWg06LBxPwAkt3R+A9WAI2lih+oNQwcxwgOyl4?=
 =?us-ascii?Q?McW8+ja+F0DOQFcsXNa4qZGwO8VPV2W0Cha2STHFiBe58VCnZqk8mIdKk7cM?=
 =?us-ascii?Q?gyzy67YIFARod5o6fQsCMylnBy2M/bc/eKEBeSWjEP5RTZBeTsQJQDorlRgZ?=
 =?us-ascii?Q?qw3O1cFrSbniXyzzM10jOyGt5e6kbsyeSa9ZZZuU6AOxcbOD3KZPICEVr6Io?=
 =?us-ascii?Q?cde4FXjFcOwBz+iaUDVc/tAf8bvaEJc4hV/Bqwanvh0bjwV1jXzSK6bULfiM?=
 =?us-ascii?Q?AJFvKllu7XfCXy/BZv+dvQje01WgItktDHEEROE7XPRl9DXD+8zE6Uq6ZVYX?=
 =?us-ascii?Q?RjODynVJZ/bhhSUTZ5pDjdx+EFJ5yU43xFjRJLJ4M5pnlXS2IcAXvH/GBLKi?=
 =?us-ascii?Q?bAXso0AJL0x7xHtYxszBj5wtsaU9KdOfuW736/0LITqzstjgByt3hHJM553B?=
 =?us-ascii?Q?KnWws40qmtX1d6uxGeqM2XdLXFRdyFGRYZIgqJJaezhFmN11Icvx4KbwmYEP?=
 =?us-ascii?Q?+QISoitp3XE/esuW5AlDVlBzUzl4u+K1WX27hOnks58jNbyKcNyZK1SWX7FB?=
 =?us-ascii?Q?2k3V4QQvkcNUgbf4gPaF14QiaaR6vkaJbcxWsS7HPR2cmF8s+d8UhkzIayff?=
 =?us-ascii?Q?DEDxKa8GPbT3QhXuslXXpE85s6W4wJ3IFaP4g9jGGm9SpjHWZ1qEgr3a4vd1?=
 =?us-ascii?Q?Vro8ykZLv9VtPiZAYRn+CncUu8mESeb8xmETgP2SD1lS7ESawv/9YfQq1Nln?=
 =?us-ascii?Q?KAqgUldwiXWlZ5y+dFy5nF0kv+EUKEDFfdWYMdjtBA3+stabQ+XvyD8Q2ORP?=
 =?us-ascii?Q?HGPZs9EmobpmwAFz2GbvHDuIOfQ+J8qPGrI2Fo+8IC5sFwrFGNk7N/zODH+T?=
 =?us-ascii?Q?87Cx3hp3BPpOq27XweWGOlkmEy4+4rNrYnEcZ8Xn3WIL0AaQjsI9HkTkSsiJ?=
 =?us-ascii?Q?Zvx68nWu+G+A/MEIo37GbFJuvNZndSu8E1mzxpcOPOEkU7jCcJyx0k44ejLn?=
 =?us-ascii?Q?tyajWmOiWZc29qw7r7O7dTEcC/Zgie1yyUgF20Tz6gjWOsg87ZzoTDHJC8P0?=
 =?us-ascii?Q?2qrxFFzt5wU9LzYD6Iv6n+A4v7J0rSE6izxFdX2Qu8ntSmRR1V34QJ7XX8sG?=
 =?us-ascii?Q?nAWvSlYAUkYyyEFHR/Y5vhchN8D40d9VXh6zB+AUFZHxCuIfEydlQjI8+NwF?=
 =?us-ascii?Q?F1lu1c3kABHbc0jPbnbgrHY8QeyCVxWwiQPQwT7F?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 584ec627-4143-408f-31f2-08dbd52eae8c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 07:47:47.8094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ob6c4c5ZNbah/1jNqCg3Mnyon8NMRIAfHAbHtap2nWBIxBq3sL2RXxTKSRjjQipREutE7P0Wt4Je/sbuJQdy5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7335
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 01:08:53AM -0700, Pawan Gupta wrote:
>During VMentry VERW is executed to mitigate MDS. After VERW, any memory
>access like register push onto stack may put host data in MDS affected
>CPU buffers. A guest can then use MDS to sample host data.
>
>Although likelihood of secrets surviving in registers at current VERW
>callsite is less, but it can't be ruled out. Harden the MDS mitigation
>by moving the VERW mitigation late in VMentry path.
>
>Note that VERW for MMIO Stale Data mitigation is unchanged because of
>the complexity of per-guest conditional VERW which is not easy to handle
>that late in asm with no GPRs available. If the CPU is also affected by
>MDS, VERW is unconditionally executed late in asm regardless of guest
>having MMIO access.
>
>Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>---
> arch/x86/kvm/vmx/vmenter.S |  4 ++++
> arch/x86/kvm/vmx/vmx.c     | 10 +++++++---
> 2 files changed, 11 insertions(+), 3 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
>index b3b13ec04bac..c566035938cc 100644
>--- a/arch/x86/kvm/vmx/vmenter.S
>+++ b/arch/x86/kvm/vmx/vmenter.S
>@@ -1,6 +1,7 @@
> /* SPDX-License-Identifier: GPL-2.0 */
> #include <linux/linkage.h>
> #include <asm/asm.h>
>+#include <asm/segment.h>

This header is already included a few lines below:

#include <asm/nospec-branch.h>
#include <asm/percpu.h>
#include <asm/segment.h>	<---

> #include <asm/bitsperlong.h>
> #include <asm/kvm_vcpu_regs.h>
> #include <asm/nospec-branch.h>
