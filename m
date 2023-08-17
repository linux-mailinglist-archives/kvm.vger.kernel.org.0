Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB40077EE38
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 02:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347311AbjHQA1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 20:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347308AbjHQA1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 20:27:22 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A2AE2;
        Wed, 16 Aug 2023 17:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692232037; x=1723768037;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=E2maCfixAqP8dalCzhDbhcz5KRHVGcaVlQ5JikTsdFg=;
  b=JvLzQrDdPR4hf2U6n4B8BkgTl7uM2b83IwwbhRgSaPVdnW/rx71FPOos
   nurxZeA0+/PEwCcGOuxlbsIN14RqRjmhanK3+lFPGwnwf0uhKVScefnUF
   3VDW6C79pWXvTPcjIMCsP4cwkJdhz6nuAjy0qciX7LAdTXJBPnMHqzqYE
   0xocEPSYih/z5SRvlf6puR40BBEH8FVAtzw+VlXhwihuvhkt6/QqzP2wy
   U1VsSD1NVe9HoPwE6mfb/PulRHtg13hojuigXxj9HcWeehCDZmWm5nJa/
   ctxN97xMpDOXuUMV87qDdy5hgkB+ssDYs3TPLhC/Zd/W9xQWgp2TFPBp7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="362828424"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="362828424"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 17:27:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="908198112"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="908198112"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 16 Aug 2023 17:27:08 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 16 Aug 2023 17:27:07 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 16 Aug 2023 17:27:07 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 16 Aug 2023 17:27:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsI3ugklZbVoakGS490abEHlT9yTgF7seBg3tYypMxUcb/bYKMrVWIgxmtNQPsDntsp8fenhHl+6a90t+VWhHBFm4jLPtR7I8Inp7yPI6RDi+98S50XhRlOiz581k1ISrAEQJMsk/FRqrzqbq6k5lXgUPx/X0Xjlno8ORA+mpxUUa2/2iRDJG/87mAYr9ZxvDNiNW31+bDNzdaIFymKhSWRChLrtLOtf/DMwWvDm61OQ7aZwso9Jan8nykwdnKzP4gGytgRVmRhvxdZkTOI2GXRYY/wNkLELfbuJ9qYwik3gMGT/mCmz2OdVSYG4FVKWcibWKQfgruYbA5Y2+rzxuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DQqvczo4MZ/geGqk+nAAQS8WoAFMAvgLcux+PDl3q8k=;
 b=OeywVM/ipevLpAOCYxcB3VYgT9FygMEnGpezWJWiQWuOAgt5PRRibJHW/0olXuW7bz9L47MGB94yRVJmFUR0phLIuyrkbi8VhTsrJvaJgDOqWhvO7uG9jb9DhW3baDbRGuVOhxVmIp5azgaE9BN1C/TYzDgfxKaE3ccFFcAmi5sE48rX68XLw+jQeIxU09f+trzxDdFtv6XZbVmX+yzuPMpE5VPdJpXXH3hqBy/qTN7qLD7mzVO/BfYpQsNfEKIBJ+2v9kmIu8xLMbg5MQLsUKD0Eb6A3k40Xdwrf0hEFtHUS8rYv5jpMat1D+UpJMCD6lzKnxDsYNzZTk2v7sE+sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH0PR11MB8191.namprd11.prod.outlook.com (2603:10b6:610:181::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.29; Thu, 17 Aug
 2023 00:27:05 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6678.029; Thu, 17 Aug 2023
 00:27:04 +0000
Date:   Thu, 17 Aug 2023 08:00:04 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
Message-ID: <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230808085056.14644-1-yan.y.zhao@intel.com>
 <ZN0S28lkbo6+D7aF@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZN0S28lkbo6+D7aF@google.com>
X-ClientProxiedBy: SG2PR02CA0115.apcprd02.prod.outlook.com
 (2603:1096:4:92::31) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH0PR11MB8191:EE_
X-MS-Office365-Filtering-Correlation-Id: b9297c60-92e7-4654-a2c2-08db9eb8aeaa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bIbK771zg27qfQHmaoyby7rNk9Pll7Xyr4NrK73gQAVd0J0knI/7/6i/dWqjfGDFKem5tSlzPDspzH9jSgjIsmSbqDuV28oW3Z4FqmtLcZQ5dnQFNIdeNDX98s9fXvgz3JKM4zBr4EVNoduHKvc69TPFS/OZwcgX8Ai+YWjVSq5NhRiTU3X5GMpyoa+O3WJpU0BMJ6csORRxqTKCcWUU8qoZc6L3FWlqZwQ7NNJ/RvwFDWzTLY1pOWRa3o5bJkrHwEyOI8fcX90TsjJJADeiLjqblmBndvamjaTm/AAzvaQfjgnR9slqDa+giwYngPJODWqK5/IRk2WVg+vnpflS+Ysthrdu2RvusoWiKvCCwLomVojzgSdTYS+oJNsq426XwS3zMVFSMOAzbRo+ztONT0VSM164PvoPxrgymMUD+afHwHUUZUDtHoSr/tgZl00b4cnpPCCVl1E75tuVf67/ArZzplVf+wEd8rKWHRXDc8LlgXGWejyLL+4esUHEayXbDXR91nHYdGHmaii2Fy3my1R4tSFEv6CnR0lA5vN3mCc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(136003)(346002)(39860400002)(396003)(1800799009)(451199024)(186009)(2906002)(3450700001)(83380400001)(26005)(86362001)(478600001)(6506007)(6486002)(6512007)(966005)(5660300002)(41300700001)(316002)(66556008)(66946007)(66476007)(6916009)(8676002)(4326008)(8936002)(82960400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d3UI8V7Sf1Exu7WXWvSlcP3O1DrqN3zZl94YlVoF/HRc1fvnKFr6KGeYPD9c?=
 =?us-ascii?Q?6fCgh81b74HEfXqxA1OUaaYnzLNallsSGYzbQwDtfDAKJU1eERcUW9xQuuyJ?=
 =?us-ascii?Q?3fN6Pvk+ekejl377Bx6sQoxxlvYEhW+LYMOxmcWgyNolMS8lSctdaQwz+K62?=
 =?us-ascii?Q?TZVK2EHdrkMD9xSSW5+f3vE8qDxxTlW3M8UKxVox8RJFFSoORarJ0FvazvfG?=
 =?us-ascii?Q?8rl6F4tqSa5sTwYZKcO3RZtF/ofSAnUu+s44t193eTzSiZ+CGVRjNfaaUa11?=
 =?us-ascii?Q?/Zao0twE+kFVLyl5zgBYSCu3CiT555B4AtYnSB4AtAf7ExpCDiPMcHjpl0ZI?=
 =?us-ascii?Q?azzHtgMpp5xdrAjPt/j4UDD/wxoqY+vl+YS3urK/0j+dj6YNrcont3POf/lJ?=
 =?us-ascii?Q?/HGPmjvhjV3t/dWP/ZGY+U9zw0HzCdAspkLzsEzwcYHQNF9tcNPOM72N7C3W?=
 =?us-ascii?Q?pr/4j410PnPk56XfgA/h+yGGk0l4Rg55RmJf2WrlEiWe2Lb2bXE5XFO5Yu5B?=
 =?us-ascii?Q?a+rqd/AfMURu1pswChmATJiWmjWDx1MXuad1PL62B8pu+o6FeAJ2W8z0x8Kx?=
 =?us-ascii?Q?6O95b98S+O+4FSZTqcegoNL2gKopyD3ASl4tPbLEGbr3Uj/FZVga901l30t5?=
 =?us-ascii?Q?bqrq+4muIIfMBPgSm2YND0JlsXLc1c7it2P/thQ0H2DiCjB+d+oCVez99AIN?=
 =?us-ascii?Q?dt4fx9r0Kjx/EZ+RQED81QO9KaNipKKceRkPHBtDVu+LUQDcOmwl2ZK9WJLQ?=
 =?us-ascii?Q?u57QWwneuoJVzaXxoeTNXenLJwHe6NfVzxhzOGuiAQnjGK9xgViXyx/LNvfS?=
 =?us-ascii?Q?m/cC9K1pmsSwRCpM1yeU/JALfKHAo0w18xWr9bWVaMu8TBJo59uq+ifBhL8N?=
 =?us-ascii?Q?56BUYvglLysLkCVuc/9GL4KkeqjYsc5G0rNReWumFBBX8+0QUkbqrBrcq8Tk?=
 =?us-ascii?Q?UTEphkhfqOtNou5EuhXWiOglQnyGOAMePfuRAFTeJ2SLux8gG+hinJdBKp3b?=
 =?us-ascii?Q?LB5d7xKw2RvsrsNH/CXIykz/Y4wOeI0Hi7KlJIzEwNvSdUInWUgb+Bcm5/ca?=
 =?us-ascii?Q?TyM/KLv708rz37QcOP9yl8rddAeGsSZ+9f5JhafEWC3z0ea6qwAYeJ8P0elw?=
 =?us-ascii?Q?dN1bIS7aVw1S5P+eqgsZhVOwUZUeyj2kZerG/p25JYiscgn9J58jt1TNcMJw?=
 =?us-ascii?Q?oe4whulKxGfzufc2B2GMpFNVsKMYIwDBKJ/7wa9/xki5pAt6VmIf7WIiflQh?=
 =?us-ascii?Q?P4NbLQJPH3kw+72pvM/mnRkSfPxwwRzaNpa4QBY7qrnLYVAjcpSE/G0q0Yvv?=
 =?us-ascii?Q?8yQaEAH/CKvWeK19Ib+/gEDEoxb9kH07yxV1dgjtyXXjEn/SYtyMJIjMF9Rh?=
 =?us-ascii?Q?h/dvMolMy2+0UZz9LZAi1AtpstJmA0mukwy05xTv3HEO4AKAyzPo8zMBOmoL?=
 =?us-ascii?Q?McRQgKl6wrzWxZZDZe4CA8s4GO6oWdPuHxeUPkHq/rxjwMnahQktBDOna/4e?=
 =?us-ascii?Q?A38cRhRYX7IjAuudK15CCNuztXHRCUT2wIOiljMpuKQJwA6uwAlruSO1/mxg?=
 =?us-ascii?Q?2zA54fYFX94RZfWvV+KVMDbcxxFdt6YgSEAVnERI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9297c60-92e7-4654-a2c2-08db9eb8aeaa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2023 00:27:04.6901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Gr1bWgcx5ScUdMfOdmocvVg6DCIzkbbHwTmOAd0jJozlKijhvAZscd4yC5vy3yWK+ZjZnoJ8nK9oOUtgueA6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8191
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 16, 2023 at 11:18:03AM -0700, Sean Christopherson wrote:
> On Tue, Aug 08, 2023, Yan Zhao wrote:
> > This series optmizes KVM mmu notifier.change_pte() handler in x86 TDP MMU
> > (i.e. kvm_tdp_mmu_set_spte_gfn()) by removing old dead code and prefetching
> > notified new PFN into SPTEs directly in the handler.
> > 
> > As in [1], .change_pte() has been dead code on x86 for 10+ years.
> > Patch 1 drops the dead code in x86 TDP MMU to save cpu cycles and prepare
> > for optimization in TDP MMU in patch 2.
> 
> If we're going to officially kill the long-dead attempt at optimizing KSM, I'd
> strongly prefer to rip out .change_pte() entirely, i.e. kill it off in all
> architectures and remove it from mmu_notifiers.  The only reason I haven't proposed
> such patches is because I didn't want to it to backfire and lead to someone trying
> to resurrect the optimizations for KSM.
> 
> > Patch 2 optimizes TDP MMU's .change_pte() handler to prefetch SPTEs in the
> > handler directly with PFN info contained in .change_pte() to avoid that
> > each vCPU write that triggers .change_pte() must undergo twice VMExits and
> > TDP page faults.
> 
> IMO, prefaulting guest memory as writable is better handled by userspace, e.g. by
> using QEMU's prealloc option.  It's more coarse grained, but at a minimum it's
> sufficient for improving guest boot time, e.g. by preallocating memory below 4GiB.
> 
> And we can do even better, e.g. by providing a KVM ioctl() to allow userspace to
> prefault memory not just into the primary MMU, but also into KVM's MMU.  Such an
> ioctl() is basically manadatory for TDX, we just need to morph the support being
> added by TDX into a generic ioctl()[*]
> 
> Prefaulting guest memory as writable into the primary MMU should be able to achieve
> far better performance than hooking .change_pte(), as it will avoid the mmu_notifier
> invalidation, e.g. won't trigger taking mmu_lock for write and the resulting remote
> TLB flush(es).  And a KVM ioctl() to prefault into KVM's MMU should eliminate page
> fault VM-Exits entirely.
> 
> Explicit prefaulting isn't perfect, but IMO the value added by prefetching in
> .change_pte() isn't enough to justify carrying the hook and the code in KVM.
> 
> [*] https://lore.kernel.org/all/ZMFYhkSPE6Zbp8Ea@google.com
Hi Sean,
As I didn't write the full picture of patch 2 in the cover letter well,
may I request you to take a look of patch 2 to see if you like it? (in
case if you just read the cover letter).
What I observed is that each vCPU write to a COW page in primary MMU
will lead to twice TDP page faults.
Then, I just update the secondary MMU during the first TDP page fault
to avoid the second one.
It's not a blind prefetch (I checked the vCPU to ensure it's triggered
by a vCPU operation as much as possible) and it can benefit guests who
doesn't explicitly request a prefault memory as write.


Thanks
Yan
