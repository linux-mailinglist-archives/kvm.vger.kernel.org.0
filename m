Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02A870F549
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 13:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbjEXLaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 07:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbjEXL34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 07:29:56 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742C3184;
        Wed, 24 May 2023 04:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684927795; x=1716463795;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=h3P42I9Tuovk9u4OXGJJMm0/tV46mroIT63GWYcR/Ng=;
  b=BJuTHB6VKstVLRsnEa7FK+QiFlJOWO7KgjlBZM8wS9Vhmfi1OaMwOgve
   /A4OZ90z91dQWVuiUnI9lCmj/w47eqm3JnV9qmwjHYRLRuHtAbCbE2B2K
   YB3zfF1LJBp8oC+Ajs4I1lqAE9v/LfkFkG8lqRK65zMHJWw8PJbhHvcpj
   GMxOCs7+lrLOuT3HQc5pFxU3GksmZb9/heIoVt5vJNFNz9dPo3EBx9dmE
   YVHgjZR+c7dF1lIJVw12nOE84m5FXuYdmb6Sg52A6Cjv7OEzQmqybTiiX
   uXFMIIPlqd5hvgfqcH1kZkLHySedX8XtzF7qGBEzrFCyhENjUNscQlM5D
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="338114816"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="338114816"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 04:29:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="950972289"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="950972289"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 24 May 2023 04:29:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 04:29:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 04:29:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 04:29:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOL2lr5jskUDGSD3vvIIhsaAKbI80YQmsZNcRjPTXFcwbOgBnlMiFYZDlV7SU3ZXBPkxVWUSDhpUoEuAdkFSVwKyS251guwuB1D2GDUZYjQtEEoTG/czP9vQ/n19LELOZQTMYoX8bInrJDTyAT+cBnMNrdj72c75JdkpupDEUmNf+osxip+zrl+LLwkM+3qAyNK+BwUz6NR0LWpmdRzMMQlMoIQQJBS2J8Clev37lTjndBGhQggFxZz4UvUO5kdv65syPKvXazZdOQaRMVjvjYznpI4PrHfktWFtCZdxjXxslnGu9jK5XpixBbt3Co8GgrjPGMlG+HiD/HL/d4dFQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LLeVlezI75exjV1AA5vORgHXTr0zAvjaI4gArUlYNLE=;
 b=ZpCo7VwDNNNZ/geRbkBaWVvRrZN247s16o0IajmuZocyJHXjP5SxP1aUd/7c8HnVNl15u9fLQLSJ9u5u7wRKD79p8ohy3b0gEieVlkYrqhB1BpR5L58tMlJmv7xzlPM0fT46XhoOvQkbojw3rrNfcRTO8ikFv9+jb6WDCd0qWjnEv/2kX8q6/mbSxISy/ZXYvFcfqOqJqyp8iMQSro4jshnwZexmiGyGCZu+q+Tl/yNk1VLTJmSjRMj71MMYqcuN3JTx9ViSPEpJXZGUqhc4TJQYMobFzCwO0Muu7j/03nBAsjXTIC8nx3jN1/oUwSYOpOTGCADRFKSwVVET8uX6WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7299.namprd11.prod.outlook.com (2603:10b6:610:14b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Wed, 24 May
 2023 11:29:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 11:29:49 +0000
Date:   Wed, 24 May 2023 19:04:42 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
Subject: Re: [PATCH v2 0/6] KVM: x86/mmu: refine memtype related mmu zap
Message-ID: <ZG3vSnLyzolwblD9@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <ZG1XOHBKZbxNEjQK@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZG1XOHBKZbxNEjQK@google.com>
X-ClientProxiedBy: SG2PR06CA0218.apcprd06.prod.outlook.com
 (2603:1096:4:68::26) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7299:EE_
X-MS-Office365-Filtering-Correlation-Id: d073affe-1b3b-43b8-a500-08db5c4a2f28
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O8uYouZG34YVBTsMTqL4zksFCJF0tQfEBYEYBTuaH4H50imgHuyaY1lWPRMDkw1dOH/uSdUXw+s65WcAD7GSYMWiGfJYnTr97V4quKwDiH9YcIaLZsrjZGzDGn3XNkzRl4V0WvNhAA+13FAL4c/TBhwGa1Pa8olqdqAPBAPQdztUS3hcSCF8++oaGjxIhTZPn6oEbzgQ5PVqF0bkAju6T2NzB+ShGRG1Uh/630k85sk4PwEhAeYDf3xaEDoherpZp74CKz5NNcgBGUYjslB94fhJZCBtYy6BDVT2vUzxX7fBDsANAMhs4h6wdf//jCdLmJ51NdIigv769JfFTAJ4svD7OFprmsfF9Pu4NCre+x3sHnBqqr3btN5//Urul7lyqMY8X/fYX601a7syHkGyANw3ap/fgQcvSPqzGYGhZLkr3IlyXQ2hK7RUPbZltd+coKX8yhkWtnksZiRRsGBgrXUE76VyZOsrndB60pgbZ7AjJTpKYLmDNY+1VoVnAVaubahSLzg742rNsV5fDA/BUv7cUD1cRLVr2Tt5TZ/saAo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(376002)(366004)(136003)(346002)(451199021)(5660300002)(8676002)(8936002)(186003)(3450700001)(86362001)(82960400001)(2906002)(83380400001)(38100700002)(6512007)(6506007)(26005)(316002)(66946007)(66556008)(66476007)(6916009)(4326008)(6666004)(478600001)(6486002)(41300700001)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jAbKm4nIgWhjqsAf/+9v3ID3zuavOVPaAQ1PvyCqA+MTUU2BrJAHblBEhu9t?=
 =?us-ascii?Q?bQGPrA6t9uujkOBQwQtUi7JprkEEg7EvPgvR57ZmUloJVX7yYTuvh/xGyye9?=
 =?us-ascii?Q?9u38aIq/kuBPGE1Dp/70N8PS5+OJuIuS6i4Z4RRg6tFDaw4NPhiDCGb5LHp6?=
 =?us-ascii?Q?5RHyU1H092pJoST3aoEtAKAQNvr64BkBSTVCSfTwH9E6SyLqEJsMmI+gzbtG?=
 =?us-ascii?Q?trDmN4UCPukIr87lISdGVteQL+IDpeHVck+nc8F9znKe4ZcKhWyyuESbTejy?=
 =?us-ascii?Q?Jw0F7GhNEmD1gmp5vZvs/XvXy38zLP6cbt2+FFwavI/n3LTQs1MaDVfanuKA?=
 =?us-ascii?Q?s5ekgT2wB8d5YrKb85xWIU/wLupoIWVkDFl3ldmeWQl3qYBqBAJftFkecb0I?=
 =?us-ascii?Q?lSQpFUS8VRl0dyBNEpWLv4x9OA0kM9w2DMWFHTKCLKZ8AjsFBcP3rn2tetjl?=
 =?us-ascii?Q?qeIRLKMjVFSTwzytq2XJN1Idr3XGMosrDqy2eu9ef3szDSAXl8DufhXSPYMo?=
 =?us-ascii?Q?+0sJePj7DMMF1s7cokeWbIyIwWCvqKKckBI2CE8Qzak+MvrCrVH9VVNL7A/Y?=
 =?us-ascii?Q?ciuO43VDIKyzr3esYOmjcDUd0HBCyA2hN6UfbXa0KdGwAROSkkhKGPA3+Kyp?=
 =?us-ascii?Q?UEMPJA9BlsvxakaEPcqtvdKV+fMTx4nvYauch6Kk6xCsKJ3WPMlSyfqcTwsH?=
 =?us-ascii?Q?MrsRpgIyv8QXLC6ZA5Kest+32LAtGIXPMbxtHwzFgNLYXLwCiWtnBlagyy3W?=
 =?us-ascii?Q?RTIzGaHAS4BPACum9lAaCHIM2LPS6OyGuKjesHC229Brir+qa/atpF1CLUEu?=
 =?us-ascii?Q?Szwb8YDpdkk7DmgJOvgXyMMe4uuvwjflVOO/ReD6cZ5aiasOcsbdLTCLPZf1?=
 =?us-ascii?Q?Y+lgGJye6zNMk72U63j7b2H1eyxPkTRo5FjbxM4zSprZHag42RtwKC1ffoT1?=
 =?us-ascii?Q?d/6z4w7Sh9BqyCPUCOk0XpXFUVj8GCRdSKQgzXu4lNh7TtCg/S9lMYTc+PPB?=
 =?us-ascii?Q?0KaWqjK42bGYRso2sVxtl6KLmXQatxhIesA9Huh7VmV0dLI2HBlW8idnk6lv?=
 =?us-ascii?Q?9f5H9kRIl4211yJ3GLJtP8JSoaV2GEum3Weq6ZTD5ptq8jp9jAJjaP8eDxZO?=
 =?us-ascii?Q?+WZqiwqLUX3fJtNsbtyHGgv8EkJ/+UPLQVTavK3gBmObnm1l2jRecmmgrVur?=
 =?us-ascii?Q?TTHAO5X12+CcFykKBt7rZDnpeiXXGPbrf8wwR4pfQ5YfFV3yGzLs1JAIv7pu?=
 =?us-ascii?Q?ZltD7VA3UhaE46AW44drr4hXXOt6ibYXwDbZGugsqN3PJA9tb0CYj+85nGLj?=
 =?us-ascii?Q?lsGZif9ybbkJ1847iEAqqE96K8Ft+8S0F15Vc+qdbJzOBYiwXiziNd+9cnw+?=
 =?us-ascii?Q?Dp2GTLQef4oDi7u3zmzdSg+fHs79rmJHP/BiPF/beqlZscBn7iWC6lbvBZCF?=
 =?us-ascii?Q?H+3lHcTf0b0I7E5bNpvfzZIY62sVQ9Qju8BlBClPupxZpsXlZzB92J53GpOY?=
 =?us-ascii?Q?nOaQzNQ1uUPonYwSmlLbp8lDhCmBEudZzbRrsSkox3rVQWeomQjhpb4GzG0U?=
 =?us-ascii?Q?78iE9hn+YVtiyFlNBLMTZ/o22+8Ak2VIGnMUOBby?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d073affe-1b3b-43b8-a500-08db5c4a2f28
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 11:29:49.5870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: au7tl0L8s0EAQXcz/jjxCc+XE2rx6Nw3JPNn6jrGCBN6hBPz+K/ks4O/ULJP6yUp3ltp2mDJxtqq8uQ8ShEbKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7299
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,
        SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 23, 2023 at 05:15:52PM -0700, Sean Christopherson wrote:
> On Tue, May 09, 2023, Yan Zhao wrote:
> > This series refines mmu zap caused by EPT memory type update.
> > Yan Zhao (6):
> >   KVM: x86/mmu: add a new mmu zap helper to indicate memtype changes
> >   KVM: x86/mmu: only zap EPT when guest CR0_CD changes
> >   KVM: x86/mmu: only zap EPT when guest MTRR changes
> >   KVM: x86/mmu: Zap all EPT leaf entries according noncoherent DMA count
> >   KVM: x86: Keep a per-VM MTRR state
> >   KVM: x86/mmu: use per-VM based MTRR for EPT
> > 
> >  arch/x86/include/asm/kvm_host.h |   3 +
> >  arch/x86/kvm/mmu.h              |   1 +
> >  arch/x86/kvm/mmu/mmu.c          |  18 ++++-
> >  arch/x86/kvm/mtrr.c             | 112 +++++++++++++++++++++++++-------
> >  arch/x86/kvm/vmx/vmx.c          |   2 +-
> >  arch/x86/kvm/x86.c              |  10 ++-
> >  arch/x86/kvm/x86.h              |   6 +-
> >  7 files changed, 122 insertions(+), 30 deletions(-)
> > 
> > 
> > base-commit: 5c291b93e5d665380dbecc6944973583f9565ee5
> > -- 
> 
> To save us both a bit of pain, can you base the next version on top of my PAT
> cleanup[*]?  I am planning on applying that series "soon".  Thanks!
> 
> [*] https://lore.kernel.org/all/20230511233351.635053-1-seanjc@google.com 
Sure, will do it!
