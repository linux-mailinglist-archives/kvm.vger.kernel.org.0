Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF88C780A66
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 12:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359299AbjHRKpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 06:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346027AbjHRKoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 06:44:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BC1272D;
        Fri, 18 Aug 2023 03:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692355485; x=1723891485;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=5tFN1n2QUHXPTqxvY15yQ1jpfuIqcpNpcDm4yw0lBh0=;
  b=SndOumIZ6MQgJiKFalEUKt0zHJGsEFWPn21n95Tzdm7d29CvNAabGT0S
   si3O7Ie2ZauFklNtdO96a+3tZIEa5P2QpMD9tphNq7CpmBEBSkxxNWKI1
   sJOVr/nMGIpuU1H4Y/YJwaf3wnzbDrWSvCZw1YwI61q/VjUgxUnXMTyw/
   fnkNRTc+UDogT5DLK8OpiE6kJ+7tqTVVRXochv1diXOpSjrPOQ3GNcxyR
   kwCUPtTOAl9UQDthWQAFmWTLcDoI1kFvEXJdADYZ9ieygps4xYaz/1EM3
   6ARt/d+Q5bsa5TYoGA8tgcFJADZT/ung2rNTwg81F2f/SyghT8n19M7a3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="439452316"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="439452316"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 03:44:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="878639889"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 18 Aug 2023 03:44:48 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 18 Aug 2023 03:44:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 18 Aug 2023 03:44:43 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 18 Aug 2023 03:44:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5Cho8MXEuUaFwhwS2yPCBuaUgVidjBqUt9IkJ93rQnj4mQCJYikra/8sAB4ZIDa85fitV/FQax/uagmdhiRvI8VbYxGBUAs4ei+qY7J6DHLzVA0yvncaOFeAHqvaliRsafSHsoc4bHO3UR0PWGto2EYGbyw6X8a3H5/ODpZER7otx5M8jxwdftbkL7pQ7FShZ20oq9VXgqdJ2wm/iDeiJiyOrj5HjnBs04kLOo7oyT4p1vAZlYf8dwVeZ1d+4ZobUehGVn8A2afhy/ek39/PZSb2VPYXMhn6zEepG7WMaL+rPpkSlF9qFQwkKGYDlZGXZ/+44sqLm72eXDEp9rAAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e7l7XPvffIWKYkanmwKvMVLGM8T/jF/krrRoz8TCAtE=;
 b=kwHJ0IdXE0Vhx1pYC3YdPVYD7LWI4fXUTheeM4qWkiE0B0URm8TMJiY3mJ2AVB11pCSV5rVlZryjErGm6TKoPjUTrpsUh7sfB3S4fUV5aDs/Q82cPCvxvsbFSMcXTiw/uU6kGl5HOItH5pz8RB12Ll7rNp5Mio/iNG2c3Hyo24iuwRMWTwvi6GGF5Hzngp2iSN5DuVhdp5kWXgxXe5Src3fKD5Nzz2PMaCKEtGweyyL/XqcXJTUbRF4RyKxRRkANNNZmGVfbYLgYi9qZBFbNgm2QF8UW6jPaA6M08sNfZTCFdo28uV9vOCszQhOHB3bIzpwG7WOEfRXNn9ljwVju7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6247.namprd11.prod.outlook.com (2603:10b6:8:98::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6678.20; Fri, 18 Aug 2023 10:44:41 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6678.029; Fri, 18 Aug 2023
 10:44:41 +0000
Date:   Fri, 18 Aug 2023 18:17:37 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
Message-ID: <ZN9FQf343+kt1YsX@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230808085056.14644-1-yan.y.zhao@intel.com>
 <ZN0S28lkbo6+D7aF@google.com>
 <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com>
 <ZN5elYQ5szQndN8n@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZN5elYQ5szQndN8n@google.com>
X-ClientProxiedBy: KL1PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6247:EE_
X-MS-Office365-Filtering-Correlation-Id: cf4dc29a-1d70-4017-b6a6-08db9fd8208b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WnBCHF/6G2Bg3Ch+9EPLGulPsmxa8KFkH22GCuJK+6o7ZnkoXP+FIJ/RwBouAgdFzV2BIMrqH2LKC6cgQRffIx4q6Iuav2X6tM0zjJN4/UsyVSa8Vny4ex9jlr945bw0PWMp0Wd7rCID6AhtXC+n5RmAsdORmeOjW3eSkITu1XSh7IXJUmGYmcTWIrsWjyKkcGmYHbCMtjmtfgAmAUhVaV2bL3+Gw/zl1Vj7ZjUUmIJqbwM4AcS44jZsWBxRSg6MUGVLDsQmX3vw0Exkqhdlnfjfyqx0BasfP05zGXwQqVA9v4B3WU0Z0xYcdbbXyzu9sEU27DeF7q5E7WfYfS++bmsuMl2xOPJOr9QbIwXIhNxEcgLczbDzAMatKcfcUti9bc6HWoWTsAuKNekalKv3eQ3Nzd7pLbopUvi5qr72ZvmlWTp8Vvfec2Fw8xnCxJaXy51UZW1zUkDf82CIZm7G+M/65xS6d6GPwra4/9h0YLBSdo8ZbkA0jAUqtqa0wZ6IrLt9ZCMOjAJZLqUGB8j3sXFf8STecWwiE85GRBr/och45v8E+GPBqRZtiv8IBcok2IM4f4dP3kfgVDRa1GGDSt/1ul8z8v3fBZlCbvwSbXw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(346002)(39860400002)(396003)(186009)(451199024)(1800799009)(2906002)(3450700001)(83380400001)(26005)(86362001)(478600001)(6506007)(6666004)(6486002)(6512007)(5660300002)(41300700001)(66476007)(66946007)(66556008)(316002)(6916009)(4326008)(8936002)(8676002)(82960400001)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XGWAbN/9f/53JU7z+FYRNUt90XbJAACLX7cp5gIBIIbVcyrV7Pck9eGv6TqH?=
 =?us-ascii?Q?x/9WfXC3mj6K7X7oAMX2ifL0G/Xmr5aAopwwnZ4h950C64L7mjiOt2UOROYD?=
 =?us-ascii?Q?9UQI1CbG48x+t8gWU0jL2OwQ62rGoe2BPFtKhbRZszcOIYWgbGLx7gHcVwsg?=
 =?us-ascii?Q?6tTaLm2BRKs9wogdXu9sq/j8Ejci4wzAm5GiBiwt+l+kr4Ul92Z3M/jCQ17i?=
 =?us-ascii?Q?onvxOlmQf1oO4Nt8dGhsVPGBRuR3U2oYsSYZT0unpGz7Jm/2KoltBCnZA725?=
 =?us-ascii?Q?crPA5Te2Si/l6NcbgqkM7xXOv+KI+rrjq0tc2CjkNY/A1GnBODW8/SAFjFrV?=
 =?us-ascii?Q?Q1DgUj+MYckhxweuzhQigJ/FbAwVsE2BtKtNtWadpcdp4s72vIP5CCOChpAH?=
 =?us-ascii?Q?OL+yeUjzAO6h9ZGyPiGlNAiKXy7rmrvTcNMrXCYCdi2ysITSvCjFPk2gYzK1?=
 =?us-ascii?Q?yIQpn4wVImwrFRjKgFDNkzEI7Sam/brQ+IwbhQD2AwXKiYOc5cPaPmr4ytAD?=
 =?us-ascii?Q?LszoGfzKe3xI3n9nL++Xrm8MCJajtyXj0RUEmjHOy0qwiTy//x91NAgQ4cIk?=
 =?us-ascii?Q?2hpJRC/trYMB2pLvX7NodIxxlw0d+MtGg1q80hh5cYAHERry5I93YiIQZqyz?=
 =?us-ascii?Q?if0nJvGRldgSjEaEt81yOuLZesmbPOtqxKpQndtHiMTwb4UBsNbqU9g+0tFR?=
 =?us-ascii?Q?9my2leTJc/cXDaZeNX8uWXowt7AIFxsIKOf2Irir8sZhjKQBFWtTQ77gn67J?=
 =?us-ascii?Q?kI5amzkiAsvsf19W91PWCuZsbpF6eJaea2EXcfUFnqM7LpXGJIE1cDeO+gou?=
 =?us-ascii?Q?1ehtlSJIuUR5PXEDybLW8dWjGF7g9IcLheBNzqLq/jS33ja6YKekT3Zbv+g6?=
 =?us-ascii?Q?PeXVkB40qYifpBFZfNCwwJ2sT2CaxlFSJO8TQ7D1fbnAojjBT7GKjXSEgete?=
 =?us-ascii?Q?DH2eAmS6WrF5YXevdrWy2mzSKnsRtkMWCEuxUiiF1AtNQFtcbRnvNU/csiPY?=
 =?us-ascii?Q?AlmfxTHrlaAi6s0Z6cYTrRBObsMjE7UP7NmJNCqXsTC8BDW7bAjSMgLQD1Zr?=
 =?us-ascii?Q?bJRN11V2Ls77DHdLomRoXFx4QfMyuFcqPghhqBEG5gtJyw5HpirGiw8Yce6Y?=
 =?us-ascii?Q?HTsKkZFFjvWVfeKi+Ahm1aQFOkkTE7qQWQ+yH2E7htpOOJ2UYSiPkoRjrCn5?=
 =?us-ascii?Q?6/cJbCjtvmFTFKotC8MecRQqhcCTfREs4/foUSlqnto/5UEFBMc4+YZQCYyr?=
 =?us-ascii?Q?WlaMyDdLAP59wD0+/hED0YutPq1e+QtwJQ0LUWimDFG5B0iusOpwndhN+0Xe?=
 =?us-ascii?Q?A94EnUFsiFQrgswolFg7N1hMT1nCzIFCu0mDUnlEroxXt9gj1stNRPz+MzaK?=
 =?us-ascii?Q?U4QbvjTNtBiO3KqT4pkTOEkMrQCoFy+fqRbdVoc7YB8mHcHFQ4LjrPGqkLzs?=
 =?us-ascii?Q?1TofxSFZDub+OlHKQiwUhQJm1etzPfulGCOiKEBoT2kCnHS/OXShJz6U5Pue?=
 =?us-ascii?Q?lSJUtEw49XAXdpW1oVdXX5BXde2Am5OlWUwlGzhd06OsQbqr7I+MGv/cd7V5?=
 =?us-ascii?Q?0pC4miwU+fhIHa8cJJvG2ozJibsTV28WhnNToVBQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf4dc29a-1d70-4017-b6a6-08db9fd8208b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2023 10:44:41.2686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vJRnlf9RnG3pCAwJcqeNiY/aaP3L1mDTpa/n0Ajf8UPV6CnS4ZZ6Q95qntyIbqnbldaFrIV1x/ixAAirNo6h8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6247
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

On Thu, Aug 17, 2023 at 10:53:25AM -0700, Sean Christopherson wrote:
...

> > What I observed is that each vCPU write to a COW page in primary MMU
> > will lead to twice TDP page faults.
> > Then, I just update the secondary MMU during the first TDP page fault
> > to avoid the second one.
> > It's not a blind prefetch (I checked the vCPU to ensure it's triggered
> > by a vCPU operation as much as possible)
> 
> Yes, that's part of the complexity I don't like.
> 
> > and it can benefit guests who doesn't explicitly request a prefault memory as
> > write.
> 
> Yes, I'm arguing that the benefit isn't significant, and that the use cases it
> might benefit aren't things people care about optimizing.
> 
> I'm very skeptical that shaving those 8000 VM-Exits will translate to a meaningful
> reduction in guest boot time, let alone scale beyond very specific scenarios and
> configurations, which again, are likely suboptimal in nature.  Actually, they most
> definitely are suboptimal, because the fact that this provides any benefit
> whatsoever means that either your VM isn't being backed with hugepages, or it's
> being backed with THP and transparent_hugepage/use_zero_page is enabled (and thus
> is generating CoW behavior).
Yes, it's being backed with THP and transparent_hugepage/use_zero_page is enabled.

> 
> Enabling THP or using HugeTLB (which again can be done on a subset of guest memory)
> will have a far, far bigger impact on guest performance.  Ditto for disabling
> using the huge zero_page when backing VMs with THP (any page touched by the guest
> is all but guaranteed to be written sooner than later, so using the zero_page
> doesn't make a whole lot of sense).
> 
> E.g. a single CoW operation will take mmu_lock for write three times:
> invalidate_range_start(), change_pte(), and invalidate_range_end(), not to mention
> the THP zero_page CoW will first fault-in a read-only mapping, then split that
> mapping, and then do CoW on the 4KiB PTEs, which is *really* suboptimal.
> 
> Actually, I don't even completely understand how you're seeing CoW behavior in
> the first place.  No sane guest should blindly read (or execute) uninitialized
> memory.  IIUC, you're not running a Windows guest, and even if you are, AFAIK
> QEMU doesn't support Hyper-V's enlightment that lets the guest assume memory has
> been zeroed by the hypervisor.  If KSM is to blame, then my answer it to turn off
> KSM, because turning on KSM is antithetical to guest performance (not to mention
> that KSM is wildly insecure for the guest, especially given the number of speculative
> execution attacks these days).
I'm running a linux guest.
KSM is not turned on both in guest and host.
Both guest and host have turned on transparent huge page.

The guest first reads a GFN in a writable memslot (which is for "pc.ram"),
which will cause
    (1) KVM first sends a GUP without FOLL_WRITE, leaving a huge_zero_pfn or a zero-pfn
        mapped.
    (2) KVM calls get_user_page_fast_only() with FOLL_WRITE as the memslot is writable,
        which will fail

The guest then writes the GFN.
This step will trigger (huge pmd split for huge page case) and .change_pte().

My guest is surely a sane guest. But currently I can't find out why
certain pages are read before write.
Will return back to you the reason after figuring it out after my long vacation.

> 
> If there's something else going on, i.e. if your VM really is somehow generating
> reads before writes, and if we really want to optimize use cases that can't use
> hugepages for whatever reason, I would much prefer to do something like add a
> memslot flag to state that the memslot should *always* be mapped writable.  Because
Will check if this flag is necessary after figuring out the reason.

> outside of setups that use KSM, the only reason I can think of to not map memory
> writable straightaway is if userspace somehow knows the guest isn't going to write
> that memory.
> 
> If it weren't for KSM, and if it wouldn't potentially be a breaking change, I
> would even go so far as to say that KVM should always map writable memslots as
> writable in the guest.
> 
> E.g. minus the uAPI, this is a lot simpler to implement and maintain.
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index dfbaafbe3a00..6c4640483881 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2727,10 +2727,14 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
>                 return KVM_PFN_NOSLOT;
>         }
>  
> -       /* Do not map writable pfn in the readonly memslot. */
> -       if (writable && memslot_is_readonly(slot)) {
> -               *writable = false;
> -               writable = NULL;
> +       if (writable) {
> +               if (memslot_is_readonly(slot)) {
> +                       *writable = false;
> +                       writable = NULL;
> +               } else if (memslot_is_always_writable(slot)) {
> +                       *writable = true;
> +                       write_fault = true;
> +               }
>         }
>  
>         return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
> 
>

> And FWIW, removing .change_pte() entirely, even without any other optimizations,
> will also benefit those guests, as it will remove a source of mmu_lock contention
> along with all of the overhead of invoking callbacks, walking memslots, etc.  And
> removing .change_pte() will benefit *all* guests by eliminating unrelated callbacks,
> i.e. callbacks when memory for the VMM takes a CoW fault.
>
If with above "always write_fault = true" solution, I think it's better.

> So yeah, unless I'm misunderstanding the bigger picture, the more I look at this,
> the more I'm against it.
