Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5946477C638
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 05:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbjHODFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 23:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234468AbjHODFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 23:05:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF968198C;
        Mon, 14 Aug 2023 20:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692068702; x=1723604702;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=CatjdhPO62KGw21SKFy9IZNzpT0T66HuunueqtsUPfc=;
  b=Kq+8WZVk83xVKFTN7ZyN3I/58H3o52DBn2mEXqxSVHyTU4IN+zl265Uw
   U7Lh+LHB0p7cQEE9zN3w5y0K5BFVyAXtZ7xJeN8obijlIcxrY/76hSJyy
   dLOBZ2cN4fGuKK9fMnjUq36G48LhcozuLECySecFEwGUuHxZnzd1Tqsjn
   7zaLGIpASOzW5BWy/8VJ8nlBXAz3TkS0Atx1sElRkG4lr509OOsZn7KZh
   orcKxnKDekdyX4X6IiLd506t1TZ1azlNZhxFvBV9K8XVepgRo7UwEwjkT
   5402MdF5v+KQwEAITZ9NPzbcYGavT7Xe2Pf2sD5SfQruf746RS/e9CMAZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="436087515"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="436087515"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 20:05:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="727229938"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="727229938"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 14 Aug 2023 20:05:01 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 14 Aug 2023 20:05:01 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 14 Aug 2023 20:05:01 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 14 Aug 2023 20:05:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqJ0pmWckWOJq9BCMDLYcDxBxnOMKM8/YEqU0StJ2k0oCQvb/qF0/2f0Y9hl+ybUFHtnYgZwrfUsZEM7VK9dF7BRKHkY+q/UTjJs2faMOwqdFiUHzpj6D2mLR/xX/i7iTqS0yg09xnoaC2ith7Z8/NmqQbBxsdOJGAF01R9eZUHV9qcqiD69XIPpL9cufSkwmwBOBDHAEw24O9pT1NH+BJmeno5Afg7QfdpIr/QMVubqSVdKcMpGmFPnz3MRog/Bw6uyzBG/o4C0JSRxneg/KU8P3N4iR1VDywygOTc7RkReLgHP5dHMCrqQFcHFA87MgzjlFEZ2VwGSYV/30+uZCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gswkJBh1GnOmqpg1ICOhVTXS9BuPQVhgL0BAwZDslAc=;
 b=bZtwW++50O7ox1+2vI2B92w7oF44CfBEb/4tcEBKPr0Ydl+pB7yWzm6OGVx98aub6QCbR/6wyGtjtmizgSM8cNnWS288P9mxlv3P4nauY1P+Y1p0m/VCXhOsMYX6WWa0V2NqMU1Ab9cELozvNVauOlPlgiWkE6qK9SAPt6KluUwtee6s68GqDTKMl0W/GyACoaUV3GVwK0iNYQHe3d4V+kYOs59wI6a2SwBLVtSu2C/VqpAqLFsguIJ8yfL8ydU+eb79qRijE8NAeLtkbklZO3YarqpWZkvs4v04zU57VBkWRGCIsYzEZDMfR8NCiDou8qlOWa6Qmu0N7BLZWrvewQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Tue, 15 Aug
 2023 03:04:57 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.029; Tue, 15 Aug 2023
 03:04:57 +0000
Date:   Tue, 15 Aug 2023 10:37:55 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
CC:     John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>,
        <mike.kravetz@oracle.com>, <apopple@nvidia.com>, <jgg@nvidia.com>,
        <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <kevin.tian@intel.com>, Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in
 a VM
Message-ID: <ZNrlAyzo93oGngM2@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <41a893e1-f2e7-23f4-cad2-d5c353a336a3@redhat.com>
 <ZNSyzgyTxubo0g/D@yzhao56-desk.sh.intel.com>
 <6b48a161-257b-a02b-c483-87c04b655635@redhat.com>
 <1ad2c33d-95e1-49ec-acd2-ac02b506974e@nvidia.com>
 <846e9117-1f79-a5e0-1b14-3dba91ab8033@redhat.com>
 <d0ad2642-6d72-489e-91af-a7cb15e75a8a@nvidia.com>
 <ZNnvPuRUVsUl5umM@yzhao56-desk.sh.intel.com>
 <20230815023618.uvefne3af7fn5msn@yy-desk-7060>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230815023618.uvefne3af7fn5msn@yy-desk-7060>
X-ClientProxiedBy: SI1PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB5008:EE_
X-MS-Office365-Filtering-Correlation-Id: 06fcffae-575b-479a-aadd-08db9d3c6826
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HHxGoJFp8TnUMMujkON2k4fHWvO0kAgUi4oQMfBlbsJAPXFxzSNNM3FikUHXOTFV78Y2FLZMl6chYfEWo6Os96sj/pDow0AFdTvyftbr2xGTEvc+IC0WeoqPx5UM5LfGDbk503AbQYqrmad+VEiStvcb2B72g/VucsOyMbq72PgCNoWU3EdaCdxKRRUbMVszKsbIVEowtsk/DTUqZF3Un9FZgZ3AssKdd083jyhQHh9JDQbfknVMoKJjGjVo5oEYqQxMquzpfdUk7TH8eboV/P66RxgL0Yc4/Pq0ohHzuvRR9P7VxXG4F4KbbcNIy5Z/L9qxScpBGYULMV4C8qlCgo9sTANpWe723wTjIj0xqV7mO9QqIrNOjqmwduFC0KNIUeerJtaPySR3c65V/PlKHRQOrtB7mPwb/ez5AxHTC47RIA0whOjEDSojvmlFwy5UwHgyOrqDiJCwrxLLjeluMMid/WpJaB6WDMxfadY0nutLqJ4o2CHZoFHxigBZwzn3c4zch2yxFkqeqmNTgJtL4v3FRlf/q7HdWiUMcM3NBicdPhYkFwFPOpfjxNR8ASN7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(346002)(396003)(376002)(451199021)(186006)(1800799006)(26005)(6512007)(53546011)(83380400001)(6506007)(3450700001)(41300700001)(54906003)(66476007)(66556008)(66946007)(6916009)(2906002)(316002)(5660300002)(8936002)(8676002)(7416002)(4326008)(478600001)(6486002)(82960400001)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ACza1hrsGvcPp3n4IRAXCk97bKjdUYr45yf20twOxQmmuCycTmw8qXPXqT?=
 =?iso-8859-1?Q?pxJu2L23xn1Sc9jzmiDAzSEcln3nTq1Ge2K9iAQHOVWQQpoaNFn+K1O5Nb?=
 =?iso-8859-1?Q?0PbY8H+V56WSWM9+lNJx+KUqyDkUM1Xp7V7/vPECQJuadAQXjV3XgHiFIL?=
 =?iso-8859-1?Q?FfPEXd3shCBqPNwHNya02943pYbwn6o6clJu1Xa9J3W/bo08Ny/LTWboMs?=
 =?iso-8859-1?Q?4xsGkOKeGNzDVG6q+jXz1gyd0u/kcvAfkQoWSOM/Xm1oo/ChSjYxiJyHuz?=
 =?iso-8859-1?Q?7znsJni0Lc8YBMbqFcgi0DGUug0HZDxNTWruHg+lCJCRvEOqfjeSbGrBT9?=
 =?iso-8859-1?Q?Cpxz4Sqj6nNkyoXYSFd3uVXfNwP0MB8cjl4sfjgo4MydwiO1EAxyO0W+oa?=
 =?iso-8859-1?Q?4IxQ2pYZd9C6g9IYustBIcpLEOoQd2h/uslfvdowG0ot+BXuO/tbSWtwcE?=
 =?iso-8859-1?Q?SZjb+muMfJhoChyRtoZNwnHwjtd2uRdb3Bb+UEOT2ZIRTVQtx08mF01Di+?=
 =?iso-8859-1?Q?3x1NT4U4sd3+2SEu+KGdt9/WxDGg3k5avc9yyQwIDYE1ZQaILVTlyTubD5?=
 =?iso-8859-1?Q?gcQrD7i7TycKA//qXMiviah5diYEb6ET/47vD3K79siyNU6a6is7KHgdzd?=
 =?iso-8859-1?Q?i0cpdOPbGQ6gjZDakjfEYwj0zbNPxCX10rSOGYJGta+9OfB/yas+bd5ZqA?=
 =?iso-8859-1?Q?S1xBNtaywEHXQTd/qiHUm0EyKEKtzEbvL3x6Ijhaiqn0HsEIPD4+jhLoik?=
 =?iso-8859-1?Q?FYqARH7T2S7hVFCWZMII9PrSXN9nrFTYnrzSvdFxAmAKuNjM3raMmKE7LT?=
 =?iso-8859-1?Q?hkzqWs/RRwR6JeTIDYrd5OgIBgsF2ifa5qcigl4itj2VxpCNekB0wk5TGJ?=
 =?iso-8859-1?Q?aW9JBUBij3sHBpY3HooPh7XHHKV+z0caqdNY2mEIlSQQLDMJfu7kE/gHa2?=
 =?iso-8859-1?Q?wU1gIg5OHV/az+/ap/8jUVSacQVH3r+Tj4cKSgaps2FRYr2HXvFgejGjqk?=
 =?iso-8859-1?Q?cdfG3NEOvacaifAQ++E4LnGhZpBEk6Ty7DvUL2FyJV9mcdnQWCpeEJ/Bft?=
 =?iso-8859-1?Q?BTJ6tGKFjseHXZ3Kxrz5zOtSWfBByjKSq8pJUzW4nqNPPlpdwj5Wx7aQR7?=
 =?iso-8859-1?Q?aqZi5auNTqwS7DGyBQvxJy5LPu4Doau5y1wcWzPrWdanl7bIElDXyp+1sT?=
 =?iso-8859-1?Q?sFmOb40rjS5hUTO1wVXbRTsDsqYRWNxg8AWkgPrg4pPLxMf8ZEKNXVROtm?=
 =?iso-8859-1?Q?4XH1SuzXYeWK0guzcPQUwffSgIf6zev6nr0sBOdB3NmANUXlCXKhyx1mC1?=
 =?iso-8859-1?Q?rvtMUKAW/pWTiWbVoCtcQvfXuuF+4WZPR1TXqAP9xtOemzDwWoOa3AyUdf?=
 =?iso-8859-1?Q?XH2BiRg4dmSRfE4Zb4nJjLTOQgSrJ3C3w7O/I50ngTFrfu7tQyUcVZq2Lv?=
 =?iso-8859-1?Q?xuRVoyBo0+mdyoHt8UQ81zcgqjLZMC9ggW+c2GGJmqGUAxMtcBmb+u778Z?=
 =?iso-8859-1?Q?eRMfMXeFJIr6Sd2bYw6WRz5UNEnhvf0/DzgNDa6fkUCvj/qRev93wBq5/6?=
 =?iso-8859-1?Q?IrjMEoYv/XSQorjM0ED7K0maeetoqt12YIM7gmKzfM9S20CowFsQs+c7tY?=
 =?iso-8859-1?Q?XfQSVHbO6HPODHr/FarVn9+SZM60CT9kq0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06fcffae-575b-479a-aadd-08db9d3c6826
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2023 03:04:57.5259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: taaGruJ6yz0Dkr8a4C2Bz6R4Zwn2vQV9g65zy8rA4mMTw9iaa/eDizNeAZXDxBTXIH26H6dTCdzHIhU8svS7Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5008
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023 at 10:36:18AM +0800, Yuan Yao wrote:
> On Mon, Aug 14, 2023 at 05:09:18PM +0800, Yan Zhao wrote:
> > On Fri, Aug 11, 2023 at 12:35:27PM -0700, John Hubbard wrote:
> > > On 8/11/23 11:39, David Hildenbrand wrote:
> > > ...
> > > > > > Should we want to disable NUMA hinting for such VMAs instead (for example, by QEMU/hypervisor) that knows that any NUMA hinting activity on these ranges would be a complete waste of time? I recall that John H. once mentioned that there are
> > > > > similar issues with GPU memory:  NUMA hinting is actually counter-productive and they end up disabling it.
> > > > > >
> > > > >
> > > > > Yes, NUMA balancing is incredibly harmful to performance, for GPU and
> > > > > accelerators that map memory...and VMs as well, it seems. Basically,
> > > > > anything that has its own processors and page tables needs to be left
> > > > > strictly alone by NUMA balancing. Because the kernel is (still, even
> > > > > today) unaware of what those processors are doing, and so it has no way
> > > > > to do productive NUMA balancing.
> > > >
> > > > Is there any existing way we could handle that better on a per-VMA level, or on the process level? Any magic toggles?
> > > >
> > > > MMF_HAS_PINNED might be too restrictive. MMF_HAS_PINNED_LONGTERM might be better, but with things like iouring still too restrictive eventually.
> > > >
> > > > I recall that setting a mempolicy could prevent auto-numa from getting active, but that might be undesired.
> > > >
> > > > CCing Mel.
> > > >
> > >
> > > Let's discern between page pinning situations, and HMM-style situations.
> > > Page pinning of CPU memory is unnecessary when setting up for using that
> > > memory by modern GPUs or accelerators, because the latter can handle
> > > replayable page faults. So for such cases, the pages are in use by a GPU
> > > or accelerator, but unpinned.
> > >
> > > The performance problem occurs because for those pages, the NUMA
> > > balancing causes unmapping, which generates callbacks to the device
> > > driver, which dutifully unmaps the pages from the GPU or accelerator,
> > > even if the GPU might be busy using those pages. The device promptly
> > > causes a device page fault, and the driver then re-establishes the
> > > device page table mapping, which is good until the next round of
> > > unmapping from the NUMA balancer.
> > >
> > > hmm_range_fault()-based memory management in particular might benefit
> > > from having NUMA balancing disabled entirely for the memremap_pages()
> > > region, come to think of it. That seems relatively easy and clean at
> > > first glance anyway.
> > >
> > > For other regions (allocated by the device driver), a per-VMA flag
> > > seems about right: VM_NO_NUMA_BALANCING ?
> > >
> > Thanks a lot for those good suggestions!
> > For VMs, when could a per-VMA flag be set?
> > Might be hard in mmap() in QEMU because a VMA may not be used for DMA until
> > after it's mapped into VFIO.
> > Then, should VFIO set this flag on after it maps a range?
> > Could this flag be unset after device hot-unplug?
> 
> Emm... syscall madvise() in my mind, it does things like change flags
> on VMA, e.g madvise(MADV_DONTFORK) adds VM_DONTCOPY to the VMA.
Yes, madvise() might work.
And setting this flag might be an easy decision, while unsetting it might be hard
unless some counters introduced.

