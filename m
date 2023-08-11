Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC214778764
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 08:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbjHKGZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 02:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjHKGZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 02:25:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDD62D48;
        Thu, 10 Aug 2023 23:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691735126; x=1723271126;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=CB0gchsMXIHddvY9zybaIK/X9HKvE93kcRWx1VdA7Z8=;
  b=W50ZVLjn7NIAAmnRrB3VeYR8yYCfsLlaLiq71FFJv1zXIDshpUZuCmnk
   3UNwNi4FKHbtoyrMfeOS+I6bhtpnMbX3CcZtCNY4NMStSE/Tfvz92jq8h
   wVrJwrJ7WMRrVGkL2qW3psabzla5dRyQpHusznCt6iNCcenGOHJ1tJRQA
   ndYOUhXqksFeBjj040ahjoPN2mJe8rjVhrP2Pbzn7ABh9hXPqVc9Dl/Wc
   t9JPc0tcTLZG3bR2j+6N45JkZAyMBqvXi/rb3FFStVCRrzaM2AR5m7Psq
   Ddv0+ZT3pDhUsfp38Q9OH5w6/AJs8vwAGd3xDq6Jq9qTOd1E7YLWI5Po1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="375318562"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="375318562"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 23:25:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="876044009"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 10 Aug 2023 23:24:58 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 23:24:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 23:24:54 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 10 Aug 2023 23:24:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 10 Aug 2023 23:24:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNuvHUydXohRKEJceMI+eLT/MfwrfdswNTgHq+pbdQwjlS7USFa+AaPMKJd9gSztzXhI65XF9yZ9KQvE+8bl0qSWzF30YTbgd7kUC1i3zija4XZQkgCFo3Q+0qZaqhwLlEeSMMWKll3AYhS0I5Az2QS8wTcvrdYRKq45mCMtjrj1pKKVZ1ROqeSxf7I+kuJRjR1V1WwyyFvgLqpaoaOByTKFMm5aTWhePjhrAT1D9pEWzbM97Tgt9VE56orK8WeWjJAMDuVWit78pjQyTJwDd8Pi7eDSszLVC2SiIxaE+F93+ZKK64klR6HTYDOHINOXkahtAXyRLEva6EOfgw3Bfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+7B+fzMKQnPnxa7e7lKVnHEvaYI4aP/IJFTg1AgzVVE=;
 b=Yxxwgl8pZ4JwhzTUpdRAcZ/aFguiTMiPhi60gGt8fcaNYO/y24+WprxgXia0ptYiI88CIl269wgRFwQA1UZGtwN9RhWUSyGrdb0eqf5LzbS5v/ieWg/JQ5eHqhBEApaOkm8/7K7BjQTCPIUmGP1DMepZrFWOoDLtgZ+108CQEJ4XEF7jqUTC7Y/zr/72/85LBN7FpV30wN5C4tN7T5Z664fOWbybUWN6p9t5Ng5mEeLWC5CBUrm1WUGH63N9bF8xwT/AXe+XTuBKktTLy+BPGbIXw15oVRnxU/ZUip5YHTEcnEZY3+9hvN1oMydFw7PdNX7jxW5uAj96phNCJJuqCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB7373.namprd11.prod.outlook.com (2603:10b6:8:103::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.30; Fri, 11 Aug 2023 06:24:51 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.029; Fri, 11 Aug 2023
 06:24:51 +0000
Date:   Fri, 11 Aug 2023 13:57:54 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Like Xu <like.xu.linux@gmail.com>, <kvm@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        "Zhenyu Wang" <zhenyuw@linux.intel.com>,
        Ben Gardon <bgardon@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        "Zhi Wang" <zhi.a.wang@intel.com>
Subject: Re: [PATCH 19/27] KVM: x86/mmu: Use page-track notifiers iff there
 are external users
Message-ID: <ZNXN4p7RqEICdB6f@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-20-seanjc@google.com>
 <5581418b-2e1c-6011-f0a4-580df7e00b44@gmail.com>
 <ZNEni2XZuwiPgqaC@google.com>
 <ZNLlseYag5DniUg3@yzhao56-desk.sh.intel.com>
 <ZNOjyf2OHQZYfMEJ@google.com>
 <ZNQfX4JHTJu1Qtl0@yzhao56-desk.sh.intel.com>
 <ZNRTO0hY8GJBrnOg@yzhao56-desk.sh.intel.com>
 <ZNUFGljM5oet11xN@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZNUFGljM5oet11xN@google.com>
X-ClientProxiedBy: SG2PR02CA0126.apcprd02.prod.outlook.com
 (2603:1096:4:188::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a718bc5-410f-408e-b897-08db9a33ab9f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M8BUieYYJsNzi9wvCBjKWP3FT2Yk8y6alo/0owAsFfAFgfz7to24XP93MKZGBkwtpYiVSe3IsgmDiT0EYsQ1IzjEIbq3Qh5axxgqWnfSUdVdDp/irFQ9oermg7l5O8fNfDbmn8ViKk7UU+l2wB8z44WPqp40FnHn9+5edQC2+yGqV/VfxgB5QcijiNo9oYxwYk7n+I7SiK9y8Csl0/DWMfqV6CkpJ3B6ZHvxgK/u1GDpkawQINvfbtkX/tju2gIVNk4FWsQOlOiwBCaGMGHjD2/L7c8thKT8M55hoVr0LUpAKI0gHNliIFQfoQEyBgnbR++FdJeL3BgZOgxuJZ0hI3c4bjScvQzILhE3IKAM349tr+U6s+e6ZI+V6VjpvXujN9S+N5FEEk2FcVSpZbgarQ4kzYtjhmo0YIvlyrDRWKG48nVX6Bpzcltr1UVonFN1kMWcKy1qKJKDBBmF2epNjT99AJMUmLwy2Aqv7IeIHq+7j2QFOlxLBsvsRHQrDRvbbrcRo8T97okEt0rz3yY/cK16rD9WzrCr8E03LtxcIl3yXg3bpGNSy9FiCJmxF7407i9phnGcBXaSH2R4fxwBvcclNk3zxr9zItHD+OYQHvXmPtO1UNMtJImOT5RuV7Wn3xGBLPE6ze3OIqT4f2u/wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(366004)(396003)(39860400002)(1800799006)(186006)(451199021)(66946007)(6916009)(6506007)(26005)(66476007)(478600001)(54906003)(66556008)(83380400001)(41300700001)(316002)(3450700001)(6486002)(6512007)(4326008)(2906002)(86362001)(8936002)(82960400001)(8676002)(38100700002)(5660300002)(26730200005)(19860200003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MSCOk8KBG6ruBnpWeVlVmyGBVknJywMNb0vNTrABRO/yDBX661njgH8dd4Hw?=
 =?us-ascii?Q?bVEJ3c1evoVKMi4RveDYQJ7DzOAp2OvWwGCJrjcP7d/fnQ7gC+VfmSg5yrA0?=
 =?us-ascii?Q?DNvwnA/98pbPzO0KZwYK6h3m6a72DF/KC9dxwFtQHuAXw9GwoXSnquzgmtOi?=
 =?us-ascii?Q?6tcLit1OOv+dZKQ6Wb++qbDTP1mva9ga5/A43WogcCXG4PGEWRBfC2vbwNLb?=
 =?us-ascii?Q?+swGtDUV86x2lgbi2nIol4+3jWoMAoyhyrHxx2xRb1l1ibpTq2Qa8qz043cR?=
 =?us-ascii?Q?MERutcKwZ/rO1I0swo4sH1cAxcigaXNal6hwbZiEdIxoqo5yKPs7LlCajlhm?=
 =?us-ascii?Q?V1nWZvHKIaMEWJBZqE1HzsX0+Ajic15b3R9nPrbCw5eDa+q9DBUA1KwKR7gb?=
 =?us-ascii?Q?oZJUiRZP1a0+zsGfJ7CeuGn/Ue+f4NABtzKEqC8QTv4CKPj2kfocRc65YNll?=
 =?us-ascii?Q?57Ce5qb6xa2kG2o8GgJ8Llc8WH4XNTVMPw8F2YplDeQq8rKQZKgGJWQsaALH?=
 =?us-ascii?Q?CicCGU5o1R49XhHQ4pohpAuAqZZVZrg77oXyzcdWBp4eM+K8le4QUA1HCY1z?=
 =?us-ascii?Q?FkzfI5jkvXhjqw0tBp6lq9KGlqqp4Vhco55GLMpnR7N0D1WUXlvGGwIzaxRJ?=
 =?us-ascii?Q?1QZAa1LLzmSdb96WQ04nMVAVhipuxxWdhoWSiDxINnzPLAh4QPFSy2hrU86Y?=
 =?us-ascii?Q?uxDGLoRdSTc6l0Fi4dHw8UmybqLDKqeTt5wbNctbknbOau0i4YxTRRis/5H0?=
 =?us-ascii?Q?LQajAHalD5P38GbXyAwOlHf1ovdtUwqvXFjBT8i0gYCmXsGQ/K84H+T2RLsk?=
 =?us-ascii?Q?fcWz9v0iDtlB7aq2nIEtuwpJBez8fNZ0L7Jh+7RnfI/V3YsBvQsAlBrMwCRr?=
 =?us-ascii?Q?/upC1I81eN6/5wROZQMPtkjDhsr7eUnA2OYkQAzhq0lyNW2LMy0POZWogcnt?=
 =?us-ascii?Q?Lx5ZBJbOOmA0+cEBa+E2wOhXNLF85kO3Geu5nYQC971DlRmZHLNLxgxrk63H?=
 =?us-ascii?Q?EFEVi8WygHxVcbquSRIV/aI320vt+QSk5E97J6DB8FsXjVIgeW5yl6j73dEj?=
 =?us-ascii?Q?EqjZQf64Zt4bW73ulFSchuHNjzp5/D1P3xU0ElKv/05hePmE9ZdImZU5lOOF?=
 =?us-ascii?Q?tTkxTjYSlxfvWl6ogswzFLAooXuYo8Rj1R1DPAyJVic3hGdXcVpV7k6TbqDJ?=
 =?us-ascii?Q?2bjAD07MEYVkFHHVbc9GRKZT+1sToxeP8i4Ck9D1MAEcAkqvG9rL33GB9SQn?=
 =?us-ascii?Q?oxUzPvZARL+pXw8mmpSZgX6GQ5eGLjzCECjd6IQtDV2mz8pH97NlVwMDiXUa?=
 =?us-ascii?Q?tlrxQi0EeoIDEvpXDlwMRlCwVbfHslSPfNh0jaXnTC1lTirNfONw+HnQuttg?=
 =?us-ascii?Q?ptQbv7Mqpt10uNArobhImFES5vz1H+udAq7rGgZU1j3J6iyV1iIPzW/3qVUD?=
 =?us-ascii?Q?29nklu5egVNQKMG7Gi9WNZMO3PtgCdfQG3oMzjrpJIJk6bjQ6cYdBMV8mPO+?=
 =?us-ascii?Q?hNKoXFzBfv6ZWy2t5m8y6j5NiyjtWuQz6lBggSVVpEyZiJoigmgFhXsNthQ4?=
 =?us-ascii?Q?NcV1iwcl2jZV3zDqNaXDVpt3/p21xsVnzjzQLcxD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a718bc5-410f-408e-b897-08db9a33ab9f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2023 06:24:51.8177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xG5ZFwS7Vs+h40qUQmN5qlY93iYcRqiF7amolykr0nYiUMWD9SJXxNo9RZ3OsW06U0Eohaozw3xA3YYxxADuOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7373
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023 at 08:41:14AM -0700, Sean Christopherson wrote:
> On Thu, Aug 10, 2023, Yan Zhao wrote:
> > On Thu, Aug 10, 2023 at 07:21:03AM +0800, Yan Zhao wrote:
> > > > Reading the value after acquiring mmu_lock ensures that both vCPUs will see whatever
> > > > value "loses" the race, i.e. whatever written value is processed second ('Y' in the
> > > > above sequence).
> > > I suspect that vCPU0 may still generate a wrong SPTE if vCPU1 wrote 4
> > > bytes while vCPU0 wrote 8 bytes, though the chances are very low.
> > > 
> > This could happen in below sequence:
> > vCPU0 updates a PTE to AABBCCDD;
> > vCPU1 updates a PTE to EEFFGGHH in two writes.
> > (each character stands for a byte)
> > 
> > vCPU0                  vCPU1   
> > write AABBCCDD
> >                        write GGHH
> >                        detect 4 bytes write and hold on sync
> > sync SPTE w/ AABBGGHH
> >                        write EEFF
> >                        sync SPTE w/ EEFFGGHH
> > 
> > 
> > Do you think it worth below serialization work?
> 
> No, because I don't see any KVM bugs with the above sequence.  If the guest doesn't
> ensure *all* writes from vCPU0 and vCPU1 are fully serialized, then it is completely
> legal for hardware (KVM in this case) to consume AABBGGHH as a PTE.  The only thing
> the guest shouldn't see is EEFFCCDD, but I don't see how that can happen.
Ok, though still feel it's a little odd when a 1st cmpxch instruction on a GPA is still
under emulation, a 2nd or 3rd... cmpxch instruction to the same GPA may have returned
and they all succeeded :)
