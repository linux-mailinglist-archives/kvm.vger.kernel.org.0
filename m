Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6615A989B
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 15:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbiIAN1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 09:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbiIAN0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 09:26:44 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E473A3CBDD;
        Thu,  1 Sep 2022 06:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662038679; x=1693574679;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kTOUZFy0SbtVTbdAIyFyHcq80MBoUUnk1TlUIepPOjw=;
  b=U6tKWQzO/NHOYXVzmXHqiwM6rhwlEWjqhkN7SRFLO0GKdcsBa67mgYdL
   tIwV36WQaA2p6k5PWfLpQFC1OhX6PDF45QMLdsvjkIzmQzpyzDtBbmq6w
   Y/uwDQRJZZcpEJCe+EbDSHt11v3Xc8hMqIQJc8kdFthH0rsOpZo2vbsRm
   TQlyID2HyjoOw+84Ss+Ynx9RIR1QB1Ur6kltvLtO/AUjNqjPVPmTWofxU
   72bhRLlou/t9T3mo/6v6vK0r5fjTcrzighvX0QGrEiX5APIWZbzlbP+G1
   7A2bQp0n7wY1z5o0TRnxG/B3lkKtQn2YzibiUE6igsrkfkXG9lVmUg4gZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="293290706"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="293290706"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 06:24:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="673845905"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 01 Sep 2022 06:24:37 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 06:24:36 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 06:24:33 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 1 Sep 2022 06:24:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 1 Sep 2022 06:24:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffgq0ctXF90n1SijKPEB1N4wd074yZ64xWP0A2ViowviS9BgjPJEmhezr8q+Pm/2fo5xQfk6w0YzYUJQ6qtHE8TER6haKJkIZ3hPdJjlGeT5j3aV+p3xZnnFBzLOxShohRCVP0azaMMXgA719xroQFv3LwyhTOZQ3bY1ynKVcZ60FIbaqr+ehaWHXwwdNMpBt9X4p40mocGK617W+ldW7emlJycDZFQAc2dATnWHKj3lWsRDzfHvbeA99EutOgQevKDY1VkT+FO1bWFCIVk1QmkLbrXcyM6ISI6D67D3zztYEaQo3bHbNnBtVjmXaKmEJwQSyNTccvu1XiN9od2DOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Y9THVeQv5WFz8gC8Uc6eCpeEjfqDUWVeDomA/GL6YE=;
 b=O3PKc+uy+beWVyoQnKwiZZ7agvZiA4VrV/b/lRhnydl8fxWfNJ41C6wbHXod3pF0K95GFN7Mu/SSnP/nd2nyyuXoQH8Q2w5HKYYU6iHymo1sfXzhj7CH/SkJ/UX59IDL0ejI0aLX73o/AcXXFweee7+1iSN/B2lFBvJBs480EEXZAW4k+IVfXY0tdBS95Q/sHzQgCd8Boe1ecUlP1+OfbgsecQUmSbTrRFqBXiEhJ90SfmJnx6YCZ58vWCsU9vFXzrwbO1qb8vapOyXszvqHLpD1qIfWHsHXeTr0PNuibYvWIWkNj+IXeo+zHfDhtejPiXCw+Y3ACSjcm4OzqZeF/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
 by SJ0PR11MB5022.namprd11.prod.outlook.com (2603:10b6:a03:2d7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 13:24:31 +0000
Received: from BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::5482:e4d0:c7d9:e8be]) by BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::5482:e4d0:c7d9:e8be%4]) with mapi id 15.20.5588.012; Thu, 1 Sep 2022
 13:24:31 +0000
Date:   Thu, 1 Sep 2022 21:24:21 +0800
From:   Philip Li <philip.li@intel.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
CC:     kernel test robot <oliver.sang@intel.com>,
        Kai Huang <kai.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <lkp@lists.01.org>, <lkp@intel.com>, <regressions@lists.linux.dev>
Subject: Re: [LKP] Re: [KVM] c3e0c8c2e8:
 leaking-addresses.proc..data..ro_after_init.
Message-ID: <YxCyhTES9Nk+S94y@rli9-MOBL1.ccr.corp.intel.com>
References: <YvpZYGa1Z1M38YcR@xsang-OptiPlex-9020>
 <04ce8956-3285-345a-4ce5-b78500729e42@leemhuis.info>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <04ce8956-3285-345a-4ce5-b78500729e42@leemhuis.info>
X-ClientProxiedBy: SG2PR04CA0152.apcprd04.prod.outlook.com (2603:1096:4::14)
 To BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1c7fddc-c86a-4d73-e620-08da8c1d4d94
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5022:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lh2O2V269xM4UY+9NUJP0UXtsYw7Hwd2qGJG0vcCdKNPDzfXUCmB4mRVphaBS4rY1jmhMMKYWiO7DMEh0wFne/TQpb4QBwwK85s9lvCR8Dgpis3gv18ci+pm2elNg1kJoiQ9+jW+OJq5qox+XLtzRW3/+MvtzSsAHa0eUvmUmKYOtldAE4ifPhgCZEx3/UkmzamI/jlRpsdYXdDnsndqC4UoL2BUFECuD1t5BVbJ05IJTigM0UCrLKj/XSsZBwNUPrcvABxN+EcmGUWvwxB1TrmGLFy9vMtuvSmFH/KlA+MaUTL/gOGoWzgACYvI/EwMT3GvPA56zYy9pfemNMvEmc0jafe9W5F3zAQx/b2b8C2C4h1A5kDIG3K1irqVsK129nfwW6dSB17v8dE8uYyD1ofbqhs7MzkJI23/3DWmnAylCUyVCkEDtlIoJpXKUAVEh09FZKRWgVgeWWK48dMKplYs2cPmR6I9FV1kWIhkxwfQiy/xOrjTeKYfwdT/nTRNQfT3iny1Gg6XlUqpQiuS61LysV6pBONkSvawnIHlbjaznlThMic8383o+B4icxx9cxmSHLy5kRZ+Xpky+Wn3CPVnnoLEL1Nx4CrOUmNfDnMs1jQoBrASZtrNtc3ijvikG2nvzlNY6juYrH2P8BzYjRuwdPFS6Sba1imPoPOcAkAhTwdzI2lN5UiZ/iLM/3drqODbxzgKsFG5rYMCOXbeRg1rGleXxXJAqVSuoDcE2GxckmsZiH8EL8Rq3IPwx3bu0DQYZ4+P20BvE+tB2523fst0UA/Auw3eRK15DyDdP8QsAog0xU+J7uCFbbPI+Xplpw2b6sYXEQUn79FdSjw5Kvh26wHzUWaGWf2J7JFXTYk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2995.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(376002)(366004)(346002)(136003)(8936002)(44832011)(6486002)(38100700002)(478600001)(966005)(54906003)(53546011)(6506007)(316002)(41300700001)(5660300002)(6666004)(6916009)(6512007)(26005)(86362001)(82960400001)(83380400001)(2906002)(66946007)(66476007)(186003)(66556008)(4326008)(8676002)(101420200003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ifhZs4KUwL9WLs67ZmQ6Or8IiKlDnw2Pnl1BjYYGPS1416CW/hGbfBoUMm7B?=
 =?us-ascii?Q?SIhyLzZlgftCw4wF/UAb9BZNAo1EQxXjk96TI79edScA2YTpNeeanbgynNVx?=
 =?us-ascii?Q?ZUCt4t0wKEoYJu/g2F0MnZ9YGgjPG7b14KWE+k5Thm50trigHbQFx/peEk1S?=
 =?us-ascii?Q?A68yvVIUNB8I+BNpIBbyIawKRSvVIzkRHWiMJsKT1GlAVEfCVSRm02PaGNKg?=
 =?us-ascii?Q?3dwkz1ammBIVs6WKJswPVcLxDuLAvK24GuCJdEGYI49ivj+3g9NW/N939p4D?=
 =?us-ascii?Q?buQlmkibdrB8PNQoMh/z9O4DTLiUE/PtxmO88kMy2/ip+1cnHmFE8rCCVF4a?=
 =?us-ascii?Q?7+bq5b+wOfIWTIxP8fTw/1iOAgVBk8zchfrjd8mM9XbWAqIrYBIfYoCBm0Gu?=
 =?us-ascii?Q?+yajM3Jl7Aomn4KOn12yQwyYQ4ErzrOCZNgPs604Pub/2h4AZHZVbiGCO1rs?=
 =?us-ascii?Q?LK94o72Ad0wadiGSGTSX3o2VBfRKPpdjlqZRhNQC5pXVMGN7Z/0WHO8s2E7H?=
 =?us-ascii?Q?nSOsItlCJfn37CP8Rb6n0OM3AEpbUr6PV3rOZMIFFII8gQUajkChIhsMjS4o?=
 =?us-ascii?Q?gt8t2J1gpdqOoKOdfGaasPwQPsqaN3BqlMWLICpsAplsY+Q5FpaKWHDo8Qe/?=
 =?us-ascii?Q?ZKqe7VMEMYZfn15w6rz6l9c/WVCs+yhRL2fZ3Nr/xMrRB/jWpwxIIlkRePfL?=
 =?us-ascii?Q?iNxtoGtiVkkhI6U/Og2qb7is+sUynRv31Vggo47VHtSTQpL9dUzofK/yk/ty?=
 =?us-ascii?Q?Aq2P4uazk5GulEyJdn9Dl77+cq3O6XT+2vWKeJtFrmTHSjfVKq285LT55BeO?=
 =?us-ascii?Q?D+UZDlfZkpB0FPl1zhnRZh/GZkhMScMWIODe0hM7IFxMko+PX6kYqafA7MGd?=
 =?us-ascii?Q?g4xuLcFpGyAaVeM8IanojCO4WeA+KqPuoltpnf5+x3Kr85stBGXVJr23MPRP?=
 =?us-ascii?Q?tpT16fHSfsWPZQLWvJq9X7wae8VkpFSGdifompHePrMX7OFSV5EOdH7yP6mY?=
 =?us-ascii?Q?9ADUKhkV36kVYEJLoX6ggmo/5DTdcNq8/5TqzE/5gj5drRTRgiPSldW01Bpe?=
 =?us-ascii?Q?z+Qp4DwQUIegdhIof/mDYOMMdJ7rtGs49t8rqmU9Wu0Aq05etgR4vNe2Jot1?=
 =?us-ascii?Q?8xoUcJkuqZfl9Ku//FYQopSBqHnsx/1ShA9G79w2oTjjsi3lWS5nRwweLbGg?=
 =?us-ascii?Q?lvu+2oJxEa2igR2AhJx2jFh5rP90MxLk1PfN7FcNiZfxSJDl8G/iNQth2Ank?=
 =?us-ascii?Q?xuOn6xenpIoYtEl+7SPwq8QZC5CHxRarxN0MZ/NqcrHN+gPju48V4UHp1luB?=
 =?us-ascii?Q?u7ZbpmRWCXzNf/HB6Hbawa4t4fNBBxQzLZDmx068nc4+QZhCR0zJW/RbcivR?=
 =?us-ascii?Q?n1kTxEFd+L2nrSNIMIBmlZJW98NZVDuDygvzrsCDiPijCtTLRpjvW6zt8HJq?=
 =?us-ascii?Q?TOmH8GrEqXqNoCHyUpqpZ7RZFsCszKoJVJSClk0DW3QTp9qrRMdaABnllO+d?=
 =?us-ascii?Q?Nr8AowkUDqoOkhfGY3+20c6A/DxZGXx9jJOzOeYHDxOeqzY8xx3Nz7GSVwjs?=
 =?us-ascii?Q?UX1KXehtM5r9H11NvdGya1HuUYwsc3rneN6h3PPTtRJGVEjOlLAOirx3jw8h?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c7fddc-c86a-4d73-e620-08da8c1d4d94
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2995.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 13:24:31.4421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +sa1ltTv/tYUj52reYYOfPZNy/BfLseNpGc9FPSLqHe5N6FtJWLsJuJoGaQogDrmydW9pulvv8hBv32j27evgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5022
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 02:12:39PM +0200, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker.
> 
> On 15.08.22 16:34, kernel test robot wrote:
> > Greeting,
> > 
> > FYI, we noticed the following commit (built with gcc-11):
> > 
> > commit: c3e0c8c2e8b17bae30d5978bc2decdd4098f0f99 ("KVM: x86/mmu: Fully re-evaluate MMIO caching when SPTE masks change")
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > 
> > in testcase: leaking-addresses
> > version: leaking-addresses-x86_64-4f19048-1_20220518
> > with following parameters:
> > 
> > 	ucode: 0x28
> > 
> > 
> > 
> > on test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz with 16G memory
> > 
> > caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> > 
> > If you fix the issue, kindly add following tag
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> >
> > [...]
> >
> > #regzbot introduced: c3e0c8c2e8
> 
> Removing this from the list of tracked regressions:
> 
> #regzbot invalid: report from the kernel test report that was ignored by
> developers, so I assume it's not something bad
> 
> To explain: Yeah, maybe tracking regressions found by CI systems in
> regzbot might be a good idea now or in the long run. If you are from
> Intel and would like to discuss how to do this, please get in touch (I
> tried recently, but got no answer[1]).

Sorry, this was a mistake that we missed [1] to provide our reply. I will
reply to the questions in that one soon.

> 
> But I'm not sure if it's a good idea right now to get regzbot involved
> by default (especially as long as the reports are not telling developers
> to add proper "Link:" tags that would allow regzbot to notice when fixes

Apologize again that we started to track mainline regression we found before
we fully understand [2], which probably not the effective usage. Especially
we missed the initial touch and led to more improper usage.

> for the problem are posted or merged; see [1] and [2]), as it looks like
> developers ignore quite a few (many?) reports like the one partly quoted
> above.
> 
> I guess there are various reasons why developers do so (too many false
> positives? issues unlikely to happen in practice? already fixed?).

agree, not all reports we send out got response even it was reported on
mainline (0day does wide range testing include the repos from developer,
so the reports are against these repos and mainline/next).

Usuaally, we also ping/discuss with developer when an issue enters
mainline if there's no response. This is one reason we tries to connect
with regzbot to track the issue on mainline, but we missed the point that
you mention below (it need look important).

> Normally I'd say "this is a regression and I should try to find out and
> prod developers to get it fixed". And I'll do that if the issue
> obviously looks important to a Linux kernel generalist like me.

got it, thanks for the info, i found earlier you tracked a bug from kernel
test robot, which should be the case that you thought it was important.

> 
> But that doesn't appear to be the case here (please correct me if I
> misjudged!). I hence chose to ignore this report, as there are quite a
> few other reports that are waiting for my attention, too. :-/

Thanks, we will revisit our process and consult you before we do any actual
action, and sorry for causing you extra effort to do cleanup.

> 
> Ciao, Thorsten
> 
> [1]
> https://lore.kernel.org/all/384393c2-6155-9a07-ebd4-c2c410cbe947@leemhuis.info/
> 
> 
> [2] https://docs.kernel.org/process/handling-regressions.html
> _______________________________________________
> LKP mailing list -- lkp@lists.01.org
> To unsubscribe send an email to lkp-leave@lists.01.org
