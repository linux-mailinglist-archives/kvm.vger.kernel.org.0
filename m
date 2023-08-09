Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C08774FE8
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 02:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjHIAi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 20:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjHIAi0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 20:38:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C6310D1;
        Tue,  8 Aug 2023 17:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691541505; x=1723077505;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=v03cXpJ/aQj+VXBIZepl/gqYF3AAj/XA8RBQI/NPmB8=;
  b=BC/7XOB5PLTFCA7X/k7/XeB/dr4pUluVnIhTieXTNSZ7XIEVDl8RotPy
   7yvAFE0I0HJpSg29SB+LttBmaLK+vzdD1VWubmHp7TymqAj9cCWCfbzM5
   jbWAChKin109jKUVzyt8EQ+0yN/eRPEu1/mDI6oWHsIF6qM/yT1Ji+Dxk
   PmKXjfdWN5YHOUo6rir3UOhtcPBDMAwsH61Xhoc0oDk8nwx7mnNi0H8q6
   SBbG73tLaCOPIDmgpB/1afiR72AOuJoLx/lx1wIIxJpWiZ8RxfNVIOU7w
   gOxzBnkJ5aYnCliW8DL7F/AWO0NGQMfvXYTkA72SXdC8to+V/vv8U3rmx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="373768839"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="373768839"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 17:38:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="875001969"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 08 Aug 2023 17:38:26 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 17:38:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 17:38:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 17:38:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=STKZM09+2nIRCc4ZsNmc6ebMhg6KKwyfSwrGQiwWTc+s01SZ2geEw29mBOZS6d5sKhkSIXrdQgN0VKWgcdhJu8Lao+xW9vBk34JEXAbF0srZ9HZhuKWMODt2xDs6036NXE6Ojp6BWvLx8tOm5ZGxGQFARNnpXy4XNwe1ywtQ7ZvGZ3N4N6uSVgtsoDml/qCsrBWwRGXJ3Vy0jXqdEpgOzLDOwucdLves7wKFtblpPilqBytJNnoOHps6aHlqDdvxaNIIOp5RkfMZ1mK+9cHmXe229JtHPuqcZkl1jM+U0VRS49L2fN6PbnLBZZVCBYY/XfGFDtjgTixqmZGr/EDpoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nc8kkZnpZ3v3FcLq2ynxL1J8nmULKgunvlzlLev6XIA=;
 b=Z1A0XrjDdXRFoxe5VUPHnh9oIA464rRAiCJ+Dz3IkevHzUl+phh9TLw3f1oBDV7UUAlPj3PRY7RzgPNm4eAcj7q0MwEfIyH5SL+pMRMlImSEGGEhZxZELiKCWJ0y6i8lgHXleGqLqZYs9AjI4rSFHnmyK9NJkGdfIHo7tIyh774g7k+MYHiBkxlBHwZpjkQLaQy6+lAz46rVoh2e0JYsHDhZFNVU6WceHMNDFyrsAxMuInEMkM3664lSysu5iry5QnpHb09jYcHGHrzp0pHc6S2XqR8z3YEp1iAL+khhFvKyB08w4FfjDsXq+LC2i66ULKhXxZdAo2aiXhHVpkOFww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6379.namprd11.prod.outlook.com (2603:10b6:510:1f9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.26; Wed, 9 Aug
 2023 00:38:15 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.028; Wed, 9 Aug 2023
 00:38:14 +0000
Date:   Wed, 9 Aug 2023 08:11:17 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <mike.kravetz@oracle.com>,
        <apopple@nvidia.com>, <rppt@kernel.org>,
        <akpm@linux-foundation.org>, <kevin.tian@intel.com>
Subject: Re: [RFC PATCH 3/3] KVM: x86/mmu: skip zap maybe-dma-pinned pages
 for NUMA migration
Message-ID: <ZNLZpWbnSmNRc/Lw@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230808071329.19995-1-yan.y.zhao@intel.com>
 <20230808071702.20269-1-yan.y.zhao@intel.com>
 <ZNI14eN4bFV5eO4W@nvidia.com>
 <ZNJQf1/jzEeyKaIi@google.com>
 <ZNJSBS9w+6cS5eRM@nvidia.com>
 <ZNLWG++qK1mZcEOq@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZNLWG++qK1mZcEOq@google.com>
X-ClientProxiedBy: SG2PR02CA0011.apcprd02.prod.outlook.com
 (2603:1096:3:17::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6379:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f188c68-57f1-4f98-b277-08db9870ea69
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LF9FirW66JLXmQRRWpCwTdfVjPlJwAl+AD/w0n0lMQocKcWyAuUsETZUgwbR/kVHK6IwMvyzzRZ+NLvdPAcwOb6ht5Ry56ojsd2JT6ZSeIurz+WnpQWMxVPysrnSKYJiOX01h9mR7U5k3wCjNOC3U2IRrZerTTWBWKHodMJOX4/x9jl7NFEhlMrPYIABx+KM9ZNOEnaJYK+scA7eAJBye8tfgTr4o3EG7Mpc+mE5cPnvyZYKsJoawY36yh870vcWr3tGlmW8fgagwqWQvZBqg5MMrpv9hGqgI9+jOOZuH68jkp2sdGSd75y5VdB3+86P6nssF1OqlrN37NWSlEl/uzKKeXa/lW1UxN+Vav8cMPS4RlX3dPhmz7dJ3zu+/0w2NJ87h4T/jor217vaFvRa2ihZpWHXGTiTWqgevT2p7BnMmN6tBfeLLEuseIgn6wrk5OtMQPUKUOuQ8iPYkho9SxWSjxxXg/pAiPkvFwb8a+gfvHYK0eUhtx6kNx0KdcXXowsjWnwgGuS+dv3xbqnDkNFhuKGmU9B0D9IM+O2VIYJKeuufD/LHhmlqv3elFpoN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(376002)(136003)(39860400002)(396003)(186006)(1800799006)(451199021)(26005)(107886003)(2906002)(3450700001)(5660300002)(83380400001)(7416002)(8936002)(8676002)(41300700001)(82960400001)(6916009)(316002)(86362001)(38100700002)(6486002)(66556008)(478600001)(66476007)(6506007)(66946007)(6512007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IFV/EVB1jKi0zk6nk/1ve1uHoqMW1bI32ETleHDxE8MqPoYm9Sgp3qsuZIPP?=
 =?us-ascii?Q?9p32Uelef2h2D3dailBxeo8YVBHNUmQjCfxvY/udaCLivKtpBGGqvMifFfSz?=
 =?us-ascii?Q?fFpc0QwlviMzS9P5k5vGyR4B1MWc6vl6FOPBho/JChmIcEy3j9r4WQChc7/m?=
 =?us-ascii?Q?b9WUpJXMwbqPqHRTebjla96CZAmDAUmyftKuWqab5J3dYlB3j28O0e7XzQ27?=
 =?us-ascii?Q?PbRKokyinLya6i1jqtI7ukFsA6ntHtZmbI1LZ7FZT38KozcAC1qzV/CfYrVQ?=
 =?us-ascii?Q?6ou7VVgleveLcn3/JyPfdfQ8fdhgsVBPLb45u9aRvvHb/ulyHa8EQ8uSwcwB?=
 =?us-ascii?Q?ezGwfg5a4Vw4JZUKpkZugf6R4LwJTb3rgOfxa+kBL1SRgQ1cHe1zuM7ARrG4?=
 =?us-ascii?Q?50hdaxIXEi/NsrMk6sAGxdEaSjUjYtn6Atbkwfd0n06iDmlQ53fQhWiNbiWg?=
 =?us-ascii?Q?48PfltuFcclC5NvHobVcVk4lODQHFLBlD6msSwtrQZ31J8qmMuc+Ny4rFvo4?=
 =?us-ascii?Q?TNi3BLHjjh4n0DZwv7DKd+ZUIiUNUj0Ollmv6qfuBo5ZjSGuLfWsYuABcNVF?=
 =?us-ascii?Q?eY12Hzj3qweU5ltsnGxCATP6I1xLQxNZYSszRKhHb7HdDKK5ucZ1dhAZd1yS?=
 =?us-ascii?Q?LmsyFlYJjvzVa6MwnlDmpNLl678tYZGaUvH/YcVEl8eeoA8C+W5O1hOvltfL?=
 =?us-ascii?Q?X692VrZzLPePvMRhNW85PMxWy5xmYWGonC1DmYd5R+kccZni79z9hL0POTVi?=
 =?us-ascii?Q?NhDgyBwydcljaLEwDBSnCFaCakeRdO7skJx+OF2alh+Eflk1pL/p+fnfW2p1?=
 =?us-ascii?Q?nNgik7dk8xMY1mODvn67Lg5pluS5BRuN9nmytv1+KqoNE5JVAPyKufalcbga?=
 =?us-ascii?Q?sJpdxvfTzow2hJWgePruNmoYpR4oMrHVKNmtN6Wd8oES5YJuiBqIpd7TcYVQ?=
 =?us-ascii?Q?RKdFZwX3h9Wx2hrZq8Mzbtpav/MVDaE4idq7ssoosv9FsSiXj618bQyQ6n/L?=
 =?us-ascii?Q?ko6bYhj8r+MLc7RoD78VxeR5gsc21nOunPe/MQ7H2FYkVpJOAEtBN/X0qcN7?=
 =?us-ascii?Q?9Lz9Bw+Aw1LDFsBLUGNmmVZatcHsjuYiBzT0vbCKglxKlSJGJST3l/VbHLIc?=
 =?us-ascii?Q?ZjruXDHTD8IgOtFJT9lsGudURAaDkw/akf5B7UzF2fjo64/4ZYkuMxx55VIh?=
 =?us-ascii?Q?Tds7q5+Z3HqBYvHUrxy8kVW8yUnHhAWCismjFUATC/+evgqCEd1XoaCNsW/s?=
 =?us-ascii?Q?KertW9OtKPRJe9KKfmNfjfCZxx+/FQJYnIMUQU9QsvByE8Bm4xyfkpWLEB/I?=
 =?us-ascii?Q?XNTWc9LxaSP/QzIU1gUdtO0P0wU2t40N0lraD/CfP5V8XpvQ73v2x4Pzgypj?=
 =?us-ascii?Q?C1Hlye67kM1BWZjoBdqeBJ8MYwy7zFAsWRhGc2RRCnoNKJi3uHZiyPNzpy8/?=
 =?us-ascii?Q?9PR2/X+OyLvICDMafa4+0QVwqdJhnoHmYS3v/dBXL9M18Uy2iZkKBptOcd+X?=
 =?us-ascii?Q?a4dmQBQ+EwPhGGVpuvFM127/U3Uceo04ObxQ6mRPKAv/6I2ux0tvxvu5IzNU?=
 =?us-ascii?Q?+K1TbsaA5K50Bd0ihRPr3p+MbFRKAXm4nhVzEl6o?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f188c68-57f1-4f98-b277-08db9870ea69
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 00:38:14.1852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3yXlXDvrE9zpgeMA+5ihbuNhH77s03yZrHgzTTCAJXTsjn9FtLdLt8El2LIMbTMrd+0cb+mzH6La5Bb6wFC4KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6379
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 08, 2023 at 04:56:11PM -0700, Sean Christopherson wrote:
> On Tue, Aug 08, 2023, Jason Gunthorpe wrote:
> > On Tue, Aug 08, 2023 at 07:26:07AM -0700, Sean Christopherson wrote:
> > > On Tue, Aug 08, 2023, Jason Gunthorpe wrote:
> > > > On Tue, Aug 08, 2023 at 03:17:02PM +0800, Yan Zhao wrote:
> > > > > @@ -859,6 +860,21 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> > > > >  		    !is_last_spte(iter.old_spte, iter.level))
> > > > >  			continue;
> > > > >  
> > > > > +		if (skip_pinned) {
> > > > > +			kvm_pfn_t pfn = spte_to_pfn(iter.old_spte);
> > > > > +			struct page *page = kvm_pfn_to_refcounted_page(pfn);
> > > > > +			struct folio *folio;
> > > > > +
> > > > > +			if (!page)
> > > > > +				continue;
> > > > > +
> > > > > +			folio = page_folio(page);
> > > > > +
> > > > > +			if (folio_test_anon(folio) && PageAnonExclusive(&folio->page) &&
> > > > > +			    folio_maybe_dma_pinned(folio))
> > > > > +				continue;
> > > > > +		}
> > > > > +
> > > > 
> > > > I don't get it..
> > > > 
> > > > The last patch made it so that the NUMA balancing code doesn't change
> > > > page_maybe_dma_pinned() pages to PROT_NONE
> > > > 
> > > > So why doesn't KVM just check if the current and new SPTE are the same
> > > > and refrain from invalidating if nothing changed?
> > > 
> > > Because KVM doesn't have visibility into the current and new PTEs when the zapping
> > > occurs.  The contract for invalidate_range_start() requires that KVM drop all
> > > references before returning, and so the zapping occurs before change_pte_range()
> > > or change_huge_pmd() have done antyhing.
> > > 
> > > > Duplicating the checks here seems very frail to me.
> > > 
> > > Yes, this is approach gets a hard NAK from me.  IIUC, folio_maybe_dma_pinned()
> > > can yield different results purely based on refcounts, i.e. KVM could skip pages
> > > that the primary MMU does not, and thus violate the mmu_notifier contract.  And
> > > in general, I am steadfastedly against adding any kind of heuristic to KVM's
> > > zapping logic.
> > > 
> > > This really needs to be fixed in the primary MMU and not require any direct
> > > involvement from secondary MMUs, e.g. the mmu_notifier invalidation itself needs
> > > to be skipped.
> > 
> > This likely has the same issue you just described, we don't know if it
> > can be skipped until we iterate over the PTEs and by then it is too
> > late to invoke the notifier. Maybe some kind of abort and restart
> > scheme could work?
> 
> Or maybe treat this as a userspace config problem?  Pinning DMA pages in a VM,
> having a fair amount of remote memory, *and* expecting NUMA balancing to do anything
> useful for that VM seems like a userspace problem.
> 
> Actually, does NUMA balancing even support this particular scenario?  I see this
> in do_numa_page()
> 
> 	/* TODO: handle PTE-mapped THP */
> 	if (PageCompound(page))
> 		goto out_map;
hi Sean,
I think compound page is handled in do_huge_pmd_numa_page(), and I do
observed numa migration of those kind of pages.


> and then for PG_anon_exclusive
> 
> 	 * ... For now, we only expect it to be
> 	 * set on tail pages for PTE-mapped THP.
> 	 */
> 	PG_anon_exclusive = PG_mappedtodisk,
> 
> which IIUC means zapping these pages to do migrate_on-fault will never succeed.
> 
> Can we just tell userspace to mbind() the pinned region to explicitly exclude the
> VMA(s) from NUMA balancing?
For VMs with VFIO mdev mediated devices, the VMAs to be pinned are
dynamic, I think it's hard to mbind() in advance.

Thanks
Yan

