Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B155AAF55
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 14:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236962AbiIBMgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 08:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236959AbiIBMfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 08:35:36 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41C8E0FF9;
        Fri,  2 Sep 2022 05:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662121731; x=1693657731;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qT4KlYsAq8MJRKNqsN8cReTQdvwAA76NXJM/7mzZ7c4=;
  b=Tc2yydCdKdMQqN4e71VPT5BRifIW8SgFLYVTDqf4EW9joEJNXsYqD8IQ
   HxpgdZvuzldgL7ujnJrQL5SJI11UdNcQPLFKLq2+K94lflv6NG7mBOyZ4
   /kaQ4vnF2x8qfKOiuoq+2LjltwPI3/nXv199Xj9d6gFQOfRfOa/cEAtCL
   8xXFC7lhbGYtbZkXLoQ9PTq5oogr7rxNzMxPJ7K6XpAWWXrbs4nlq7NgY
   52EztOwIxeaqYHENoUPP05y4m7wqCnvPzYni0xPwMkEtaruiE4nVitLlv
   XxZF2YQ/NPIuHBFX6XTMYWnNxrQcy632K5d+XMbAdTapPfhXKEfQn7DBZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="278985069"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="278985069"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 05:26:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="563948438"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 02 Sep 2022 05:26:23 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Sep 2022 05:26:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Sep 2022 05:26:22 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 2 Sep 2022 05:26:22 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 2 Sep 2022 05:26:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5xFV8L7m1yDJBHwIgl2e3Yb7wrDz55id0cKOsovwbN9y0qvupDeWGuslV6e9bpfc8aWMQtmdCXf3A/AaDRhhC6tjCOD3sldrznfzXhrtwJ1edXOFlwXIy1euoere79FTSec4RWObRELjD5owu7BBMk13qZKd3E4e1j9/jFQKmTB9eXJOCvi6xuihIg94Y31m5QoGOMW8uwd30OdY+4EE+EnsbJe0/1eF+qWhGDRa4x1q2h9Apu4hUOnNMo/AR0S4kLANTuu1KibJC/WGXUbim4DDJ1whDTZlrahR1RTwqFMnGgrwf2TC1iIDYSnMeFCOrfI2Z00xl24LvwjJO3Kog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AF4Qc5oFsJHCwSYBPvAcsuqDeC/BhQmPs0HU3qbdleM=;
 b=N+843pGAyvB5A/pgTlzEaCDnqkG3BGUl9RhysC57c0yMqVFE9ARgTtAfh5+9drc03+jdGM6n5WDidIF3U25Yz2mtHkkq+m2mycUR9YFLPuVqQIy2OYuVTxoYErHjFukuYa6engXOsOUT1UyS4hk+r5SDl5w69Ci/AQEfQLL+fRKlBOUiIOD8p5BWgNWDEzNYJFUjCtZKhslS7FFiW6e9WVoDNlISZtpjTp+Wz/KWRtsrefA5gr3l82UR29WInfpAjucNn8k5UPi30FMSE8gjjv9fm2qG7wI9nO5AVWX7E4Y/DoVspwLl4DCeLeeMIh3GSPXIwo3lDm33jHswFYBk9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
 by BYAPR11MB2821.namprd11.prod.outlook.com (2603:10b6:a02:c9::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 12:26:20 +0000
Received: from BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::5482:e4d0:c7d9:e8be]) by BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::5482:e4d0:c7d9:e8be%4]) with mapi id 15.20.5588.014; Fri, 2 Sep 2022
 12:26:20 +0000
Date:   Fri, 2 Sep 2022 20:26:07 +0800
From:   Philip Li <philip.li@intel.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
CC:     kernel test robot <oliver.sang@intel.com>,
        Kai Huang <kai.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <lkp@lists.01.org>, <lkp@intel.com>, <regressions@lists.linux.dev>
Subject: Re: [LKP] Re: [KVM] c3e0c8c2e8:
 leaking-addresses.proc..data..ro_after_init.
Message-ID: <YxH2X8gMWyJeKPRa@rli9-MOBL1.ccr.corp.intel.com>
References: <YvpZYGa1Z1M38YcR@xsang-OptiPlex-9020>
 <04ce8956-3285-345a-4ce5-b78500729e42@leemhuis.info>
 <YxCyhTES9Nk+S94y@rli9-MOBL1.ccr.corp.intel.com>
 <57c596f7-014f-1833-3173-af3bad2ca45d@leemhuis.info>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <57c596f7-014f-1833-3173-af3bad2ca45d@leemhuis.info>
X-ClientProxiedBy: SG2PR04CA0163.apcprd04.prod.outlook.com (2603:1096:4::25)
 To BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a58acb4-2350-4e39-1c04-08da8cde5710
X-MS-TrafficTypeDiagnostic: BYAPR11MB2821:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JwzwId5yDV2zZhbcu+60SZRelHcDwCu2BMETSrmVJCiDjZacX3xhLlbXWEuAk+ob0IHLmuHEZHV2Mw2vHIvbKtREinfbv2qipt/KbOacFEge+tW9bjI5P6CBFYp3wuvOU+aiSrXy2mFHCOXj/scOoAoKdliMh+MLC5FyDGthXFF+DzDJsq2GBOcxVwSsoRTjOs7YOgxwZUxDJblzuPxZoTzHR9C1OyFsI/KAkkyI0FF3aTv2RFXaOl+Tul6nEb9ekCoijD7CPGlABPIm/Db3IXCaRp5D/cpOXjkF3klYrpbPZIO9JYb5iynsA+GHVYF2XofdHdPYsNjSXgqGHIM2y0s8379sSor87ToE3rCpdglmsr1d4Diiza5QJSlsS74bW/jQ1MqRYTrau2Lr96rt6fmzIt2MsMgL8UWNJm+QIh0PUmyihnQUB59HHnMOiIjU5J5iuEANCUP+LXaDeFfNbOX2vgQRtyLB2R3kNY/2xsGTq3LcSTE5GnLUarWGmHzEKAptPanZ0SnTNvPUt7epgRQLD0/yfhVtSAm1c6aaOPElulijvJRWZmmOKiuGr01tfIHyWR0smFojrqw7ovwOtyqviamgzWoDueb7rpWKfx1vFLYj2Bq2xC/tnvxH1KBDNjxJusuD01oR51QNIvDfEeDk8qoOOQyNXrVdnujzPbMdJM/SHIF3WJarcTj1l/3WmbJsnHJKtcQs5/Z6rfO4V95FUltjVDKyeZfnSVRJsNCmDYWcbuho+Ly/dsIdJnhgegMI93H9yFFlaoKbMwVZ1X6wB2nTjJgtF9pp/skrchs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2995.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(39860400002)(396003)(346002)(136003)(82960400001)(6916009)(86362001)(38100700002)(54906003)(316002)(2906002)(5660300002)(44832011)(8676002)(66556008)(66946007)(66476007)(8936002)(186003)(4326008)(41300700001)(83380400001)(966005)(6486002)(6666004)(6506007)(53546011)(6512007)(26005)(478600001)(101420200003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u4UUO9AbvR5TNpg00KfItzufcx7VQubY3VkGHdOJX1fUFDn7PNdJ3czvnC03?=
 =?us-ascii?Q?PmXOGwzIlxbocT55b/vxa8uuf4xqfUp4LN58IS6ettvs4VWA6oaP1DymjJRt?=
 =?us-ascii?Q?p/iV4EIIJO9XQ1lCis+RfU625x7JJiImEwTiS23s/P2e3QPAX2AWNA9M39Oi?=
 =?us-ascii?Q?MW57T1v7a8aI8CHNDCsvgGgW9BCJoT0lvLt2vx2Xzpo0zMHlEO7RomkwU1rI?=
 =?us-ascii?Q?NQN+AoSjln07BPQ+R5L/F6jjMl8FFwXNBBMVsMD360gpStnpv8RWfNHnz6tu?=
 =?us-ascii?Q?xX85aXUO76OnxbHfVCUZSFr5eWJwVGI7eExFSt+juoOUSNrpYwhnuGjMTLqQ?=
 =?us-ascii?Q?P5gh37qKsiGE/wFQaRZc3DKGhy63BdOXzAiFN51uco6qQLqm/4lwOFvLG91M?=
 =?us-ascii?Q?F84dUKiyT5a8EbxA5ArxKcmJlKzdnND72fCm9efWpN1cY503ApcXV7dKGENQ?=
 =?us-ascii?Q?Yjl2DG2KAt6wg8+xb3oYxbUkf6IxQSWSUFTn/Nto38Z5trkAy3TzXHOIbmHy?=
 =?us-ascii?Q?sVGcsIPPneIsbdgXbpHavMKtm3RtlpwQZPFCRIqXR7rFx8NCJ+l0VPggCkvF?=
 =?us-ascii?Q?CRItMmllRbL0VcI3DoWiagzY3Dz52GrjQPs84Q1eto0LyQArPe+V05dESfGa?=
 =?us-ascii?Q?PYnnCTbAQa08gYbyttw99HVowzF25Vqwq2Ci/kEbCqipbTSD95Gux7dOX1B3?=
 =?us-ascii?Q?TQbhE0boSL8TX+q9MGygK+geKvTSDn96eYEqPgGa3XiPVGZE0FxQLO9nvLXG?=
 =?us-ascii?Q?ifoSuMXuBQfRnx8+6seMnMoDSlZunJeXj6OqDtdYeA7gFEgEEdGMz15uQ/sc?=
 =?us-ascii?Q?K/t1uUDeMQYTuIjyhm4IbQg3+5v87NU2eI6c1U17f4jikzDaoax3I+/bCeKe?=
 =?us-ascii?Q?20eKvyRdUYRmB/qsz5bsEOYjF0PkXKbV/DlfHP3U4pBsoDiqNTTfxbcMkhX1?=
 =?us-ascii?Q?Zbzz6y4eH6xIJcr4OGGv4KojOb0LyigDmRMlV+FpZTBFt0LDEtVaA4qQryYF?=
 =?us-ascii?Q?ezoKl93G+VKPU++AClDDvyi8KYDIlz1K3hEFKG9tFPAf14KnVCv9CQQGYg7/?=
 =?us-ascii?Q?Mfcysnhxtij+dR6HOcyHUon5XFJQ8Se2QDLdI1/YgkEsHzr7mzQ/4QqFDC1f?=
 =?us-ascii?Q?JIeBHEIwiHdTAFjhUL5DvriMh67DaijjyaA96UGOfpdLwLQKjiaRGVUE8Vyv?=
 =?us-ascii?Q?eVqVWRMQ/qE7t4OHTa/X24Newzd8SSHx5BJUYtvE2c3p2y7C14gelasmaa+Z?=
 =?us-ascii?Q?j1UXnDCvXDhKEv5jluCYFbUWAp+2swnNdtSQTuHvOfQA1CI74ue7U2qreXPM?=
 =?us-ascii?Q?ZsreyuxxAglTxVDBKItXXf10ldgEjmdCPIzOuUSwES+M6ONbTSYEkOUheryV?=
 =?us-ascii?Q?95nIFPxOu0hurhnH4+ZEQwSMtbtb7hid4o5JuBOgo4kLCDefZfpSThJc6dg+?=
 =?us-ascii?Q?2vVWBJ5seU9ogdLXHKFjyxLUH9QpLFR6uWM/oOByO8a24dh+MU+QeuD0FcaG?=
 =?us-ascii?Q?/jF1w9B7CzqRcOOIiNd8AiuA3xRePxY8I+FDiGZ6DyQndojwM+b6/Xx3V35z?=
 =?us-ascii?Q?x7ruaUKLmWiXemakRWfmEiKnfsVgbtaK7zoGdeRTOBDTAVlT+xaf4ruAH25h?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a58acb4-2350-4e39-1c04-08da8cde5710
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2995.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 12:26:20.0929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8LdwhCBpMmBxsC00kppXCx28f5YEZXO9pXfhZIgwOJwrT69Voj3jl9Fzm855Cly6B8cmTWDTPrGI+pzs8Ai0jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2821
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 02, 2022 at 12:54:05PM +0200, Thorsten Leemhuis wrote:
> On 01.09.22 15:24, Philip Li wrote:
> > On Thu, Sep 01, 2022 at 02:12:39PM +0200, Thorsten Leemhuis wrote:
> >> Hi, this is your Linux kernel regression tracker.
> >>
> >> On 15.08.22 16:34, kernel test robot wrote:
> >>> Greeting,
> >>>
> >>> FYI, we noticed the following commit (built with gcc-11):
> >>>
> >>> commit: c3e0c8c2e8b17bae30d5978bc2decdd4098f0f99 ("KVM: x86/mmu: Fully re-evaluate MMIO caching when SPTE masks change")
> >>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> >>>
> >>> in testcase: leaking-addresses
> >>> version: leaking-addresses-x86_64-4f19048-1_20220518
> >>> with following parameters:
> >>>
> >>> 	ucode: 0x28
> >>>
> >>> on test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz with 16G memory
> >>>
> >>> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> >>>
> >>> If you fix the issue, kindly add following tag
> >>> Reported-by: kernel test robot <oliver.sang@intel.com>
> >>>
> >>> [...]
> >>>
> >>> #regzbot introduced: c3e0c8c2e8
> >>
> >> Removing this from the list of tracked regressions:
> >>
> >> #regzbot invalid: report from the kernel test report that was ignored by
> >> developers, so I assume it's not something bad
> >>
> >> To explain: Yeah, maybe tracking regressions found by CI systems in
> >> regzbot might be a good idea now or in the long run. If you are from
> >> Intel and would like to discuss how to do this, please get in touch (I
> >> tried recently, but got no answer[1]).
> > 
> > Sorry, this was a mistake that we missed [1] to provide our reply. I will
> > reply to the questions in that one soon.
> 
> Thx!
> 
> >> But I'm not sure if it's a good idea right now to get regzbot involved
> >> by default (especially as long as the reports are not telling developers
> >> to add proper "Link:" tags that would allow regzbot to notice when fixes
> >
> > Apologize again that we started to track mainline regression we found before
> > we fully understand [2], which probably not the effective usage. Especially
> > we missed the initial touch and led to more improper usage.
> 
> No worries, as maybe it's a good thing to have the 0day reports in
> there, even if some of its reports don't get any traction. But having
> them in the list of tracked regressions gives them some more visibility
> for a while -- and at least one more set of eyes (mine) that take a look
> at it. And it's not that much work for me or anybody else to close the
> issue in regzbot (say after a week or two) if no developer acts on it
> because it's irrelevant from their point of view. But would still be
> better if they'd state that publicly themselves; in that case they even
> could tell regzbot to ignore the issue; your report's could tell people
> how to do that (e.g. "#regzbot invalid some_reason").

Thanks for the encouragement :-) The flow/process is very helpful. We will follow
up a few things before we resuming the tracking

1) Add Link tag

2) Do internal judgement of mainline regression we found for whether it is
important, so we do some filtering at initial period to avoid bringing noise to the list.

3) Add the hint as you suggested here, so it can be easily invalidate by developer.

Also some thinking below.

> 
> >> for the problem are posted or merged; see [1] and [2]), as it looks like
> >> developers ignore quite a few (many?) reports like the one partly quoted
> >> above.
> >>
> >> I guess there are various reasons why developers do so (too many false
> >> positives? issues unlikely to happen in practice? already fixed?).
> > 
> > agree, not all reports we send out got response even it was reported on
> > mainline (0day does wide range testing include the repos from developer,
> > so the reports are against these repos and mainline/next).
> > 
> > Usuaally, we also ping/discuss with developer when an issue enters
> > mainline if there's no response. This is one reason we tries to connect
> > with regzbot to track the issue on mainline, but we missed the point that
> > you mention below (it need look important).
> 
> I just want to prevent the list of tracked regressions becoming too long
> (and thus obscure) due to many issues that are not worth tracking, as I
> fear people will then start to ignore regzbot and its reports. :-/

got it, we will be very careful to selectly tracking. Maybe we don't need
track the issue if it is responsed by developer quickly and can be solved
directly.

But only track the one that is valuable, while it need more discussion, extra
testing, investigation and so one, that such problem can't be straight forward
to solve in short time. For such case, the tracking helps us to get back to this
even when there's a pause, like developer is blocked by testing or need switch
to other effort. This is just my thinking.

> 
> >> Normally I'd say "this is a regression and I should try to find out and
> >> prod developers to get it fixed". And I'll do that if the issue
> >> obviously looks important to a Linux kernel generalist like me.
> > 
> > got it, thanks for the info, i found earlier you tracked a bug from kernel
> > test robot, which should be the case that you thought it was important.
> 
> Yeah, some of the reports are valuable, that's why I guess it makes
> sense to track at least some of them. The question is, how to filter the
> bad ones out or how to pick just the valuable ones...

Currently what in my mind is we will consider performance regression like
around or larger than 10% for certain test case, or some general tests such
as kselftests, or serious boot issue.

Or if you considers certain reports are valuable and track them, we will also
learn from this to get better understanding of what worth tracking now.

> 
> Are you or someone from the 0day team an LPC? Then we could discuss this
> in person there.

We will join 2 MC (Rust, Testing) but all virtually, thus not able to discuss in
person :-( But we are glad to join any further discussion or follow the suggested
rule if you have some discussion with other CI and reporters.

> 
> >> But that doesn't appear to be the case here (please correct me if I
> >> misjudged!). I hence chose to ignore this report, as there are quite a
> >> few other reports that are waiting for my attention, too. :-/
> > 
> > Thanks, we will revisit our process and consult you before we do any actual
> > action, and sorry for causing you extra effort to do cleanup.
> 
> No need to be sorry, everything is fine, up to some point I liked what
> you did. :-D
> 
> Ciao, Thorsten
