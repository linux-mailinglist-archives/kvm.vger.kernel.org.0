Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFE47933B7
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 04:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241370AbjIFCVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 22:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241237AbjIFCVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 22:21:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD80CE6;
        Tue,  5 Sep 2023 19:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693966868; x=1725502868;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=MwdnsUu9vqZKmIlDsoG1VXBpS9IjMDC0ZCuulcqybNE=;
  b=ekDkZ4u/ftUSy4jyscmVqSiCueyVodnhXtjKRhdbEls7q4lMk7Tn/OIW
   ms2VCtumIcxUf+fuFTVr6SLfFuoyjJxStADFg3BYPb4O8EHCvNeig7pQs
   opCfTZlBz89wZzT464Ei4FEAuyiiQz75ofmUJozFTrp+ywCzVsHZfdHcv
   yDxT19+nBHkrlvh51A5GfUs96RFdx2nFFIRqVZnEgRS5MU/lSaQeXfx7f
   uPPyJYN3L3RhnD8AojbBE2UZKyXiXugVUuhOfHmJe3WXzDbLTWGZtm/Gh
   WsIdRhivGhyWQgDl3ei3U3am3pupsySqVGzjR4+EcIfNGzol7tO8RFqPz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="374342236"
X-IronPort-AV: E=Sophos;i="6.02,230,1688454000"; 
   d="scan'208";a="374342236"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 19:19:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="1072202566"
X-IronPort-AV: E=Sophos;i="6.02,230,1688454000"; 
   d="scan'208";a="1072202566"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2023 19:19:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 5 Sep 2023 19:19:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 5 Sep 2023 19:19:22 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 5 Sep 2023 19:19:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHSe1tbOZYukvIrzQq/hnZOxrLwrUVYkt0Yzy/0SSPWzC0yxHtd9xykkffJ7NlOptaIxzvSzfiBzl9N0NayKSv4jFhY7iu7s9QI5EnBhguSbZR71boie4/8OSuPtgcjhCVFXllgmN8D0sAnMaPDz/4NsmatW/B85s8M1kr24M3YQQrTP7t6MAdNPxEmnwJOUAdgX4oBBBecBqBZuQyYjTPM1Ti+w3bqPuqmXlW0i8tR2hd3DiRTt96vB/dIKQy5bswSrbX9qFCiYDUrSuIsqUG1SW21xgG4e2EO+aKLnhooSphdOZpuc2tIchRXvD1krf+zgjR/icrUTMoqs2LpBRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pgNOelLG0PT8Y/olriSMtjOvfhGixJ6/pPuhV5kw1Ks=;
 b=fBTBS3TUcV5EH8h21eDBWW+RcwgRBa3JKylOHbJeD33grncQsqA22OQawn/u91Ntjm52ryQGLbhlrcNXWx4R1bpwWRSzqkvFyIIH66Z6eT8fd9b0DFoU9iDabZ1l0HhTGMWCPV55cVbT0OaaFF/Cc+PW5QTtwFLiKbLL9P+fHI25HhWb53g3LTxxGASNYSYY6Ene8TM+0RZzvLtfsIacTVPwKWBqvDuJSK5S70kXKVhb4JIp230mvto/xXoAks73jl5aAfZPOszvza+w6ddYOyArO9nODp0K0s8zDB8uC0FeIqoiQWuyTMgsXJYJl6NveUOR61O/b0AJYQYt0p6Bug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB6372.namprd11.prod.outlook.com (2603:10b6:208:3ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Wed, 6 Sep
 2023 02:19:20 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602%6]) with mapi id 15.20.6745.030; Wed, 6 Sep 2023
 02:19:20 +0000
Date:   Wed, 6 Sep 2023 09:51:43 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
Message-ID: <ZPfbL6lS3YI6VW39@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230808085056.14644-1-yan.y.zhao@intel.com>
 <ZN0S28lkbo6+D7aF@google.com>
 <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com>
 <ZN5elYQ5szQndN8n@google.com>
 <ZN9FQf343+kt1YsX@yzhao56-desk.sh.intel.com>
 <ZPWBM5DDC6MKINUe@yzhao56-desk.sh.intel.com>
 <ZPeND9WFHR2Xx8BM@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZPeND9WFHR2Xx8BM@google.com>
X-ClientProxiedBy: SG2PR01CA0149.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::29) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB6372:EE_
X-MS-Office365-Filtering-Correlation-Id: 9db23c22-d372-442b-464f-08dbae7fad82
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GadhfrlXOCW/6/dXDo0pcOWZqxiBSDLp6blvfwHn+ijXqujxC+7eJStYSIHqh61plptazD2YDIZ0kA7QfmujTgNW0XqZanoR+JUs+l7GqjddYxksxldiT2iVbxlt/hSBstM/3c0r7gVCClYWecpZvhnAACDJ5uoytaKvgeN8rh6VQqj3Et4rGWnRl3Y+66BDaFc7OVBZ4VuRgAQwhOGfBb+70mSbGDQXYBsxgClHH5mpT+PefWC4yInSN1LlWAkMrta0F87IsCyTXRH82J7g87IFu3EUVqKE1KW9VbOQkLVp1Lv1IKwyOS9holbuVMj+ZdMmAY2tJHws1zs5xTXIsqXgjx2JSOt9iBC7/R8KmiOPCP8jq12l9owvtT08lG0HgucyBnVeX1sDisxLMI2q6oVppwNYi3bK9+Dn7cO2jqhFcsp018eyFO5OVezELhkQ9YF4S6d9TjefzLpdQ/ggxxfCEAnLiCIvVRURotPNb0ykmaFCle2mADzLozpjvAcbGJEtHKs9wT6fM3dNLJB+uEsEncOt2Cb0CyQ83Do1u4OWa7R/1ZwxqMptSV6t6aF7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199024)(1800799009)(186009)(6506007)(41300700001)(4326008)(8676002)(8936002)(3450700001)(66556008)(66946007)(66476007)(6916009)(5660300002)(316002)(26005)(6512007)(86362001)(38100700002)(83380400001)(82960400001)(6486002)(478600001)(6666004)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yTNwqW2aqcCOMzicof+XzONkZiZfaDWbv14dS/d9q9RmIGQeeTHkaKghh6jq?=
 =?us-ascii?Q?2ucJwt5ekmZcoChrn1LQu4QrWvT2RtGlt63QBQoqvoBSkCz6Sp+AwWgY1IAd?=
 =?us-ascii?Q?ueh27aE7b2qtkkraqs9fvika0knWPK7rMuPiW29dxwsPd79NKhcC7JZbTqzT?=
 =?us-ascii?Q?mVI0Oi3/tLcwsQOiCXjT5WeeqWOIGbraRIRIu5iFBYBX2bQIYVFAXyglmpPb?=
 =?us-ascii?Q?40i2iFbO9s6lWlwsepI3baStzmHb1XwIuBkh9M78K9bVCxF6B6dFPmjFbxQ/?=
 =?us-ascii?Q?8nSSSVRYhVkWJZsjBdiDZOGRUQgPd7mahuE0r8eT/8au8JgOe5td8tBxCG1m?=
 =?us-ascii?Q?KvTPeMv6BpLYLQLUvkyptJ8fqM9AOAheAK8Ki8mRCUgdBeda3JQLKywfFoeN?=
 =?us-ascii?Q?AEjvBHqT4+EQe7NrozfP24MNe9hhwbYs8yPORULhr60N34InPR//fTRs5/Vn?=
 =?us-ascii?Q?2qXCpiDwxCmlWaiVD+QzTOgWX06GddsKOYMm1N4YqGbYtxQB4DwhbHBI0WMA?=
 =?us-ascii?Q?PFGsX6LLiRopJ5M44VzgJbqrJRyqsARpLDKn5jNd4pF6+SjzKx2q19nDYKM/?=
 =?us-ascii?Q?iUfNce+Ujqlfyr0w/wB3zNWiPenfuH0DPX/4u+eMgsBP3yx4aMPhr4lz5X+X?=
 =?us-ascii?Q?18NctPiwg8UFBveH359s4Nkt8KJiy0dUeIMq6FL/gJ0Z9WKl+YvR4xAWOPuk?=
 =?us-ascii?Q?S7WyTHM/QoXQmZnDOYVOZZo/Qz8L1WAbfRjQe6P0JW3fwKzlIDlv4xoD+2bH?=
 =?us-ascii?Q?JN0GWIOHsPVJEfnPHTTvBjt4Mp120u5YJr+pJKE77eWe90bC8bMUvUEAHgsJ?=
 =?us-ascii?Q?3SJDikZz4EkMRRwvw/LibMQlxHeCCvDmLMci7Zpd8IProWyqGntS4WIvyktX?=
 =?us-ascii?Q?BJUIZCjIomkaiZ+D2pLOfaOJKTPgRZXearsAYH5dc16GWxtjDvOXcHQ5sF/5?=
 =?us-ascii?Q?eKVUVKN4HipINehdKue/hOKLicakxMcmB+kewSpAIB0kxDLMgU8Ya7VmK06A?=
 =?us-ascii?Q?EKA00k1X0PlKosRRrlp18/7YIYrctX013foX6W47DemIwCdD520i8YhHOn+r?=
 =?us-ascii?Q?vu4TqH+xE6cv8RuIgRdTZRO8SR16xY0g0wvejz6NZG0537KdQdzQQ82FNydw?=
 =?us-ascii?Q?o5kDmsgeZbTv2kgcPPkVUHR/oqOvXPBUKrwn5YsGkTPPPu0HfqunKilyM39E?=
 =?us-ascii?Q?lF1H7y8DnhdYBXBNRYnGbXh/pHtoHgXysvRto6iHn/wG/b7pMzc6v+i7hWFO?=
 =?us-ascii?Q?AjD59fLpkS+Sr7wHXFs6wBqRVs4Wj46VQqz9m39/R7L9B4aSw72StsN8/B78?=
 =?us-ascii?Q?Eso9V9wqN4C4m7G5NTVzCZIvuneZmIY8fi4w1z+wzASPGHaE6wuBQN/wT84v?=
 =?us-ascii?Q?Q7F/SnfHRsQYIdWx5fTnkkzA3xdlcnXMAzxdP2hu21fi+AjeaA/IGMKndK/b?=
 =?us-ascii?Q?1gXblsCem6hMX+lQ9IWuJsc2WhouNoiE8uDv54WxRFK2n7IKESm2mvU1FwrA?=
 =?us-ascii?Q?578Cmo2e70/C2yKk9UKOQJG7tp4fjxrvL/K17t4A9mvyPd6pIqjLIXT/FfH+?=
 =?us-ascii?Q?Km9drhubFoKymoLdXun8VaeDegw0aazC/+CXl4pY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db23c22-d372-442b-464f-08dbae7fad82
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2023 02:19:20.0784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xnsJf1MZBqq+/x3Uz95Dh0YVK7GNc0E6syLEChgGT9qJrWlNEr976DEMGbnyAVW4P0lW+tY50vRU2CFn4LMjKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6372
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 05, 2023 at 01:18:23PM -0700, Sean Christopherson wrote:
> On Mon, Sep 04, 2023, Yan Zhao wrote:
> > ...
> > > > Actually, I don't even completely understand how you're seeing CoW behavior in
> > > > the first place.  No sane guest should blindly read (or execute) uninitialized
> > > > memory.  IIUC, you're not running a Windows guest, and even if you are, AFAIK
> > > > QEMU doesn't support Hyper-V's enlightment that lets the guest assume memory has
> > > > been zeroed by the hypervisor.  If KSM is to blame, then my answer it to turn off
> > > > KSM, because turning on KSM is antithetical to guest performance (not to mention
> > > > that KSM is wildly insecure for the guest, especially given the number of speculative
> > > > execution attacks these days).
> > > I'm running a linux guest.
> > > KSM is not turned on both in guest and host.
> > > Both guest and host have turned on transparent huge page.
> > > 
> > > The guest first reads a GFN in a writable memslot (which is for "pc.ram"),
> > > which will cause
> > >     (1) KVM first sends a GUP without FOLL_WRITE, leaving a huge_zero_pfn or a zero-pfn
> > >         mapped.
> > >     (2) KVM calls get_user_page_fast_only() with FOLL_WRITE as the memslot is writable,
> > >         which will fail
> > > 
> > > The guest then writes the GFN.
> > > This step will trigger (huge pmd split for huge page case) and .change_pte().
> > > 
> > > My guest is surely a sane guest. But currently I can't find out why
> > > certain pages are read before write.
> > > Will return back to you the reason after figuring it out after my long vacation.
> > Finally I figured out the reason.
> > 
> > Except 4 pages were read before written from vBIOS (I just want to skip finding
> > out why vBIOS does this), the remaining thousands of pages were read before
> > written from the guest Linux kernel.
> > 
> > If the guest kernel were configured with "CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y" or
> > "CONFIG_INIT_ON_FREE_DEFAULT_ON=y", or booted with param "init_on_alloc=1" or
> > "init_on_free=1", this read before written problem goes away.
> > 
> > However, turning on those configs has side effects as said in kernel config
> > message:
> > "all page allocator and slab allocator memory will be zeroed when allocated,
> > eliminating many kinds of "uninitialized heap memory" flaws, especially
> > heap content exposures. The performance impact varies by workload, but most
> > cases see <1% impact. Some synthetic workloads have measured as high as 7%."
> > 
> > If without the above two configs, or if with init_on_alloc=0 && init_on_free=0,
> > the root cause for all the reads of uninitialized heap memory are related to
> 
> Yeah, forcing the guest to pre-initialize all memory is a hack-a-fix and not a
> real solution.
> 
> > page cache pages of the guest virtual devices (specifically the virtual IDE
> > device in my case).
> 
> Why are you using IDE?  IDE is comically slow compared to VirtIO, and VirtIO has
> been broadly supported for something like 15 years, even on Windows.

I don't know why I'm using IDE.
Maybe just because it's of my default settings for years :)

And I sent this series was just because I think each guest write in this case has
to cause two EPT violations is wasted.

BTW, not only for IDE devices, I think any devices with DMA mask less than max GPA
width will cause the same problem. And also true when "swiotlb=force" is enabled.

> 
> > The reason for this unconditional read of page into bounce buffer
> > (caused by "swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE)")
> > is explained in the code:
> > 
> > /*
> >  * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
> >  * to the tlb buffer, if we knew for sure the device will
> >  * overwrite the entire current content. But we don't. Thus
> >  * unconditional bounce may prevent leaking swiotlb content (i.e.
> >  * kernel memory) to user-space.
> >  */
> > 
> > If we neglect this risk and do changes like
> > -       swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
> > +       if (dir != DMA_FROM_DEVICE)
> > +               swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
> > 
> > the issue of pages read before written from guest kernel just went away.
> > 
> > I don't think it's a swiotlb bug, because to prevent leaking swiotlb
> > content, if target page content is not copied firstly to the swiotlb's
> > bounce buffer, then the bounce buffer needs to be initialized to 0.
> > However, swiotlb_tbl_map_single() does not know whether the target page
> > is initialized or not. Then, it would cause page content to be trimmed
> > if device does not overwrite the entire memory.
> > 
> > > 
> > > > 
> > > > If there's something else going on, i.e. if your VM really is somehow generating
> > > > reads before writes, and if we really want to optimize use cases that can't use
> > > > hugepages for whatever reason, I would much prefer to do something like add a
> > > > memslot flag to state that the memslot should *always* be mapped writable.  Because
> > > Will check if this flag is necessary after figuring out the reason.
> > As explained above, I think it's a valid and non-rare practice in guest kernel to
> > cause read of uninitialized heap memory.
> 
> Heh, for some definitions of valid.  
> 
> > And the host admin may not know exactly when it's appropriate to apply the
> > memslot flag.
> 
> Yeah, a memslot flag is too fine-grained.
> 
> > Do you think it's good to make the "always write_fault = true" solution enabled
> > by default?
> 
> Sadly, probably not, because that would regress setups that do want to utilize
> CoW, e.g. I'm pretty sure requesting everything to be writable would be a big
> negative for KSM.
> 
> I do think we should add a KVM knob though.  Regardless of the validity or frequency
> of the guest behavior, and even though userspace can also workaround this by
> preallocating guest memory, I am struggling to think of any reason outside of KSM
> where CoW semantics are desirable.
> 
> Ooh, actually, maybe we could do
> 
> 	static bool <name_tbd> = !IS_ENABLED(CONFIG_KSM);
> 
> and then cross our fingers that that doesn't regress some other funky setups.
Oh, this "always write_fault" solution may be not friendly to UFFD write protected pages too.
