Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A596381F9
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 02:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiKYBAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 20:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiKYBAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 20:00:19 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA2C108A;
        Thu, 24 Nov 2022 17:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669338019; x=1700874019;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=LlYYNXo79Gt2AEwvoEpnb7qogSiTp5usc73T6bhvD8A=;
  b=b4YmAnSmiUg8Sr3c/jM2DrT6nyD693tF9wJW2rhSANsdkmzS7RTCR2nI
   AO/tIw4vjV9MsA+60N1CWA+GycGPcGeB1XAAPfSO/Mi8Oh6znlED0k/ct
   e3uMCIcdaVTqnVHFxzhN+xO5BVvB1U1mfz/1UOaJRseEyQS9PlgwrDMTF
   rY+3lWNojKGu10K5UhSHQcOlgYnMODT/hBIJwCIbc8utl6cK2sNRvHU49
   URV+Ds2TeUv+vxW9mb+48ianjGyIUnuJHPTgJjMd7wGjwuD4efmcoiOeZ
   8XNlwGOh7DHnBA3Mhj3r5zB1HGVy1hlryF67Ggm63L9Eo7eAJXNOn39yb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="312020932"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="312020932"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 17:00:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="784780118"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="784780118"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 24 Nov 2022 17:00:18 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 24 Nov 2022 17:00:18 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 17:00:18 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 17:00:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGeV+yhkkCQoLQIjbmgD/X24niQBQmtxbiYOGq+BBqzZUngZ+svhwAsRFMKRuIMjyFpfj2o1gAOepMZFBa6+tKTqpyO9Y+IUrAxCxKNoosf4HU3dXHU6DRACQ3Cf6j2ulNBg438+psKDp1BXffyq9TmE+3oOyinOo+7BrTa0lpQDGWE8PVWk7NQ0K4y1Y6z5T6elYUUxLOWtO7r3onmlCmhom4APjf+yi50oo1x6TFKV8Y0wVYRohnfTxx7gs51tSYu5IF8+mKmKJczMITeMhRtn3wJ/LREkPeZmMLMh8JOrtVkbwgT/5DbctGqJGjtS8ka+f2gS1bX/m5MlPtVcvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m1mmOW1eYyLzzNpOJrQQlnuZEP2noryZOqLwUlZVj7A=;
 b=G49/WWLcEAcUH/JhXzLrKpAQOtc552qdp4X6E8tNI1pD3/hq/0cAzYVpxpteE4sGJ3dezmdxC4hUYaQfUDMaobJQuicfvpZ3khSf2ITpA4p0lKVZ7iXfw2riOxj7y0TR+2Nc0fIo8oJMhVIfETII09hy3BTq9DBQHPh1dmwJHjEr+pNZRsvDjMCaxm4N1R4M+rjgd+NVc5NlRqlUUa1hbtu2DxxSaW8fNMPB0WPgsfHeocGYk/qaxPxLH9kaRsJy03LJybDeNKzGusseEHmApDIwu3x2utPUDvooA1ET1nLpe0hZ1Z2VP9h2MLLJYwlrz56Zg87ouBazMdw7rbqZkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY5PR11MB6114.namprd11.prod.outlook.com (2603:10b6:930:2d::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Fri, 25 Nov 2022 01:00:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af0:fb9e:4ef9:24e5]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af0:fb9e:4ef9:24e5%9]) with mapi id 15.20.5834.015; Fri, 25 Nov 2022
 01:00:06 +0000
Date:   Fri, 25 Nov 2022 08:37:06 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v10 035/108] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Message-ID: <Y4AOMo00B0vlQfIU@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <f1c9996fa4f4bc71b3feee8407d247aeabb8968e.1667110240.git.isaku.yamahata@intel.com>
 <Y3wvhWyIKNzczFov@yzhao56-desk.sh.intel.com>
 <887a77acc9bf96f7c7bea519ab7ebdd27fb67985.camel@intel.com>
 <Y4AIYGGEU3BdrQgV@yzhao56-desk.sh.intel.com>
 <8e14a7732a2d873846d07c4ec467fb7c48b2307f.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8e14a7732a2d873846d07c4ec467fb7c48b2307f.camel@intel.com>
X-ClientProxiedBy: SI2PR06CA0008.apcprd06.prod.outlook.com
 (2603:1096:4:186::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY5PR11MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: 47ea8ecc-a59f-4c7d-c5c1-08dace806437
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bOVY+47qAuR6YXkqq3dTWXAEctr7tanZ/tbS53gOYhfe374tSNWI31k5SExi8UeoSJTEvPNGIxW+n2svaWRASr6VN6m4CbkSWDTbdxBBABefj4xbNebWgFRzngR94yCHYU40ZM1jTywW7tM4R/92hd0/2h8Q34rEMB9PEc9eZPzXK7FboJjZjJ9ZFg0OObc6Y/E9cQcca/5yhZAaySHit+kvtNTtdsz9PjTnL5hC4HrTgAYEVkoeB1zLcXMEU1tSscxFiLgrgoE0zaPZiiIz5h0mBLNYx6qF1C5YUdnckMuJP/4wWdsUWZziYFKqoNFYgpN2yM3toUvtqcxqyL/ZOxprStX6uktNIv5IeQwsa3/M3nnhHb7RDQc6Efez7SSMm5tFe5efg1q8dgNp9Wp80A0r+yOnQXefYXhrcLS060JVxqM9ddZYP+vCwb33n+k00/ZeFxB4eTg846eMcQTXUrMGkYJxzeS70cCu7W8Ay6CFtSKdAAm6nrpKqTDk4vRuWsXEYF4OiuYxYnusa+hroNp3ZJB0FW/prA2MKiIAVtz1Dy1DLufpUgcP9QSf4gMdOwrq7OgwjOhy7BORh58GJlQnRmYHaGr1pHBZ9wsg61pM73kxU90gTUfiWFGm/WSmPYgM8s1UEc76PiyExGttZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(366004)(39860400002)(396003)(376002)(451199015)(478600001)(6486002)(66476007)(66946007)(316002)(26005)(8676002)(6862004)(186003)(8936002)(6506007)(6512007)(3450700001)(66556008)(6636002)(5660300002)(86362001)(82960400001)(4001150100001)(54906003)(41300700001)(4326008)(2906002)(38100700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Dklsmy9yWDgfbhNrwBd4ENDf+5g+5MAuurZRz3jJjRGiLfBh0OjmELmV2k1?=
 =?us-ascii?Q?8DrtHswtvHlQ6K7paEA6dFSCy9X6cRBC9OBmfunooY1pliHwawt7n6sBs6Ea?=
 =?us-ascii?Q?DqO96AQNmdXRSlaH2MUTxHGNGfn/o7q1F0IOn4+U8UxPuZ+DtJwpA+ZJNPsp?=
 =?us-ascii?Q?B0oplcNMx7e0G3yZB/AQrMVLqgmxEfqo0DvGUTbGjlCaMysfvSzrP/QRSBz3?=
 =?us-ascii?Q?G1rbbqPPUk0PR7x7czmvfQflh6gCBpzEBpZoyaMr6wKd5Il+Inh5j/q+bQwv?=
 =?us-ascii?Q?4l72jFjHY6AuBWS6ykttTvgti2MLzJKo/gDl6bJrS6hD1qGzcITaTWh4S8Rx?=
 =?us-ascii?Q?LB3qalRW5lz4g2mGIbN0ivjAZBj+WVHR2855hLvxnYj5xVKmRgika6mEitOv?=
 =?us-ascii?Q?n6ODmaBUV6iDIK5kOzE5ZdJvKJYg5BxddPW2uqP1BUrZkRbypq/miUSQvGei?=
 =?us-ascii?Q?t0LeQcAD+jiqOXFFlRDRf4xnvo8MvDMgJk5+8i2BKg1TQ77vlHBcGYM7nQ7S?=
 =?us-ascii?Q?Rw1DvwwJFGP5iCXVZYrXXeEO3glVhYuuYFTROKnGIeyjZCX5mdo9Asw+2/nP?=
 =?us-ascii?Q?RPb/plYR4ckGTo6Z2RPk/fw81YiL9h7u81BBa4ClznIeI0gqO9+40poxya+g?=
 =?us-ascii?Q?M+MALVwnB8Cx61LWeT/QcF9ILFblGjjggEMfy2x1KPiisurzcIBmWHojFpSA?=
 =?us-ascii?Q?yho9sDNDbnJ5Q7jwuV3uDw1VT1ktKPiXxpzspZsISPmvADovNU/MSqq5B8KY?=
 =?us-ascii?Q?xVBDPmeD47A++PvtbSl8cx8Ea97Kd3f55COcemyFQ9FNB8MaJyExPYcUm2Ad?=
 =?us-ascii?Q?6RYvx2RAZe2cPSw4+14nEE7+kfySH1MMnzBT7n5/3eSowe0L7tDmpBTi/+1E?=
 =?us-ascii?Q?NYXPUgubGjLWxb8o2TFvEVBHA5F9Q65be1tBh7Z+B0ApvhZL2zY7qDTn93td?=
 =?us-ascii?Q?7e/Lko2SysA1rCgLQO+ffAu+TX7L+X2ylHAuNg9wqZaU8p8OrH3OE0ju7uB7?=
 =?us-ascii?Q?I6Jv6NZV6Om/tKB4Fi7cycFnaiVoJCC+sJrFxCCknQact3TJ9lLOryVW3fTU?=
 =?us-ascii?Q?QiwuPK8IqiT1a8/lwEgvoCPR9YZyaCPMAi21MlvIcN/mZY7fGptOM7lSxiiE?=
 =?us-ascii?Q?Xn3ysCJCGwpYPf5/6tznS26yVxU/wQNED9ZpvVNe5a9LtXWUkvsv9yX6UFX3?=
 =?us-ascii?Q?hRxk1m7b/iVte7rguE5orK2H8xVrDkOGbUvAxT5eINeU7szXdjVZz5JGqpF/?=
 =?us-ascii?Q?s+c2PX441GInvGv+rdxq3Kkm8pcVVI1tB6ixo57AXwfWeJI1Aj80wSpi3EyH?=
 =?us-ascii?Q?OTQOX8s4Lce6PqDuuCgkql4pa+mg414VGUabzT43UzeILUGgVNvS8ezKnOQP?=
 =?us-ascii?Q?RP9GopzmNExxosmdpexbOV29gTBFzlstRMvu9BvZHbxq6OuwKbHMj3EK5wjW?=
 =?us-ascii?Q?IYypVzjVxD/tE5dM3JnN8IILrPnSEbLmAA8c07KmlbnaNLvMEyL5mLbF/AO4?=
 =?us-ascii?Q?jxuv6wFqKOeFXakiS67knJx81fj97/JXY6BuLC44Uogv4IFBGA9pFhKc9Gc5?=
 =?us-ascii?Q?cl466GlItfVNbQRqlKJmgWlhrj4Rzu/Bk+uosTsu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 47ea8ecc-a59f-4c7d-c5c1-08dace806437
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 01:00:05.9952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Oym8FWaUpSNIBrr8s/nFOQCTq908/RTm5so7w+xOYem3qdg6p+SeGY/pzM1DYQEnXLY9bPTr2dn93/SXJ8tdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6114
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 25, 2022 at 08:45:01AM +0800, Huang, Kai wrote:
> On Fri, 2022-11-25 at 08:12 +0800, Yan Zhao wrote:
> > On Fri, Nov 25, 2022 at 08:13:48AM +0800, Huang, Kai wrote:
> > > On Tue, 2022-11-22 at 10:10 +0800, Yan Zhao wrote:
> > > > Also make enable_mmio_caching to be a per-VM value?
> > > > As if the shadow_mmio_value is 0, mmio_caching needs to be disabled.
> > > 
> > > If I recall correctly, Sean said we can disable TDX guests if mmio_caching is
> > > disabled (we also will need to change to allow enable_mmio_caching to still be
> > > true when mmio_value is 0).
> > > 
> > > SEV_ES has similar logic:
> > > 
> > > void __init sev_hardware_setup(void)
> > > {
> > > 
> > > 	...
> > > 
> > >         /*
> > >          * SEV-ES requires MMIO caching as KVM doesn't have access to the guest
> > >          * instruction stream, i.e. can't emulate in response to a #NPF and
> > >          * instead relies on #NPF(RSVD) being reflected into the guest as #VC
> > >          * (the guest can then do a #VMGEXIT to request MMIO emulation).
> > >          */
> > >         if (!enable_mmio_caching)
> > >                 goto out;
> > > 
> > 
> > Would enabling mmio caching in per-VM basis be better?
> > 
> 
> We need Paolo/Sean to decide.
> 
> The thing is TDX guests always require mmio_caching being enabled.  For VMX
> guests, normally we will always enable mmio_caching too.  So I think per-VM
> basis mmio_caching is not that useful.
With per-VM basis enabling, I think we can get rid of the kvm_gfn_shared_mask(kvm)
in below code and also in handle_abnormal_pfn()

static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
{
        return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
               likely(enable_mmio_caching || kvm_gfn_shared_mask(kvm));
}

Thanks
Yan
