Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE9E77523B
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 07:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjHIFdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 01:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjHIFdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 01:33:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992BF19BC;
        Tue,  8 Aug 2023 22:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691559189; x=1723095189;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=UJ0p28nqMAOolCQDdLWYesEbjA9lrqA1JVGudKGMeew=;
  b=m2zGOCKEyHPyCspt9FM5+dz3GhY7XYJjjjV7QbnMb0DJGx6X/p6vyc0k
   BSDGOn2ppPfv3ULx2w5bMu+ZhDcyENYCL8373LRKI4Ju4f7XZc0HNZ0vN
   7+Nb8FpNAWhtcAdgyHnulGwb/OLmy5HhM3yMiV3TFZGzBXdSNHoEG5rmt
   ZNNkRhoQWKB68/onQd6FVHe3IesDH4tC++Vn9Ufe+d/kn4AYmuOxGr6Ga
   +kg8nLxDH86iAW5Y/W2WBG6A201kQZnpXILCyBbOXoCju97F7If+eqFse
   dTirMSOHG8Zvvbak3zTynt7uCXOHAVNd+MtYpT7ufKyon11QKUpEemc9O
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="361150471"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="361150471"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 22:33:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="821691187"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="821691187"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Aug 2023 22:33:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 22:33:08 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 22:33:08 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 22:33:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eubz3SRpBEuIVesDukhIqVT3u2a/ZrHBfmmnC27HUXyHdzrdrZou1fy2vNhaBNk2bR1Zl+d2krJViaF1n8fKXt/dFAXt/xRLTnrv57XSPrBICYk/ybFJvXd2CPADgu4C8m/roFd5i+89ezmlEbq8VPAx+DyW7nSGzAMFNmGCDtc8Fduc128WmhEcMDqTvan4zmhSw6/vN6eBG6Oq468gT4v0mkVz7QX/yPJWjGBZTr3ShnFjU7RE8MNn3OU2Ahrxqs7M/3SYZx+DRa4gET0YX8aanu+mTD92PJ1rQ6r2CrsG3XarKlSzajMFZpEFwG1/574at4rM96IHbw9qExo9XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LpZ2KEqVp079wcib4h7jcb5MMybShrK+f14y5M3E/8s=;
 b=DMZ5dc/2sR5juuY9/wOWyTEXxY3VBnYILmJ3eYrN2QPKOZxpPVajxgJhF4lnfMiGE1YJBLIURK6QK65NzLgd//tyJA2d4sdhQWmAbE1dEY4nZGAC3osAH8kbEAdi8hVR1VppuzcJHzmPcaIcSozENJXXoTFjzsmxm9hefHlc8nB/oqcJoA48+1nQvvSKYmIwOLWzFNrEMXHMv8DIPQ3fuaTZn+safED/leYd6PlaEbp9HFwaRbQ1iKIYs//Vr1rGkAt9Lb6HHbp1XWgGluFH1jtlBLvy5fEN1RGW46MmYbyM8bw0uPWMgFDnzAbcn6CZldrC6Qwf74XcXUZGBG4vgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY5PR11MB6535.namprd11.prod.outlook.com (2603:10b6:930:41::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.27; Wed, 9 Aug 2023 05:33:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.028; Wed, 9 Aug 2023
 05:33:06 +0000
Date:   Wed, 9 Aug 2023 13:06:10 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <mike.kravetz@oracle.com>,
        <apopple@nvidia.com>, <rppt@kernel.org>,
        <akpm@linux-foundation.org>, <kevin.tian@intel.com>
Subject: Re: [RFC PATCH 3/3] KVM: x86/mmu: skip zap maybe-dma-pinned pages
 for NUMA migration
Message-ID: <ZNMewp61DMAhuDi0@yzhao56-desk.sh.intel.com>
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
X-ClientProxiedBy: OS7PR01CA0251.jpnprd01.prod.outlook.com
 (2603:1096:604:24b::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY5PR11MB6535:EE_
X-MS-Office365-Filtering-Correlation-Id: 24c88a57-5f70-496a-e70c-08db989a1ba5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6jfwHLjLnPnhj2isURkpeeAyAfnth6bP/yzOZOWnqRyhi5JNyqsFW9KrjrViVk1MLNV3N7X5oY2K1IH9kNuGkaq+MfabYP9rB3kUYgufWQTF58UbidDZq8/hXnLEysgOl4cq3IAOHNmDPQluukR1bfxPK8ik+1HxcXIopGt78CByl0SfYiLHM2dZJBpMVdyzyuNP21KYNXoX+geuRIzOQdHlGPa2mxeGc1ThnvjCFrBbxhUvdvMyTfxzO8B5zjHrPN0y3SwABBtbbTHac0kYwl90TgNd5rdDDSu6Vh6bOPQ9+Hew/S3TNCHpM4Zp8dozEqKDwYXpUD6ayQvck5Tu/qWhq7sZHBMdjp2Qc0X0mUEhw14X3ArnnVAP89qigS4ZSxELmEi55fRd3cSXRzR3Muz5jNAMwGA0H7r4Z+2WokcaBQVacVgtDf1RfDtvar5/PznGorBtifVPypuJlQuERsZu1oEHJ8Osw4N99d41oSMGS6CqZQ9JNwdnzxooWtQVqDZr6swn/QCi2zaDbEXfvkwTH1M0p1FDFX2mS7oJ/wkEBW7DRUKd6mVGO1NtCdEo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(396003)(346002)(366004)(186006)(1800799006)(451199021)(6486002)(26005)(107886003)(6506007)(6512007)(6666004)(478600001)(38100700002)(82960400001)(66946007)(66476007)(66556008)(4326008)(41300700001)(316002)(8676002)(5660300002)(8936002)(7416002)(3450700001)(2906002)(6916009)(83380400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0gx/CyBbWOVHODu+HjyOTTozKvleMSxYS0QXKGEMsHi+DfZI55vwefnOl3P1?=
 =?us-ascii?Q?te7DZUBl7pbUVogAFxxisYqQZREa7M53ISn35+3agd2VjFq7U7rJOqJ+/UC/?=
 =?us-ascii?Q?yOl2U2ebg30ftLCyIEJbhvLH7iKncDur3JjZlxtBjAZGCc1E+QZflWb7NqHG?=
 =?us-ascii?Q?44z3R5t69cUKLxIcx1dqJLUladPMm/0kx+2YLBgxQjl1JY84ejiUYZPUH97o?=
 =?us-ascii?Q?s5CtUKy1H3xn+CuLpgvtOMRC+qSs0bF7jsh1oujuzo1h+iuCxhlj8iTTvbgE?=
 =?us-ascii?Q?bY+kjgwpvDE3ice+uiF2sLqSHFzDigvW9+ZB8osx5vAQ+dhPUZeeb3y0mxz8?=
 =?us-ascii?Q?/EcYj8JZyJ4Nhg6SXkGadbYiu3OnmOrBZ+BOHngrwweEOAteoSx6FC/P0GGQ?=
 =?us-ascii?Q?erMGd8L0RwZtiDUtn03hJCKA++cAhx1oIPeCpRJBW20KbSgzEwGHFA3DYQhM?=
 =?us-ascii?Q?ONgbkl9C8Ak7vDJsgVkUy6i13ynzOQaY9E354mRstSzXFLeA4ufftvApfcKR?=
 =?us-ascii?Q?mZx6xTZx90o8azNn+9nUUkd6SY/xAOHonwLalSkLgcRvBXZvkM7cfMA+nBEO?=
 =?us-ascii?Q?WI7qzuXXYGRY9AGlUl+4Do1BS4pR9V3L7zgN0//SWVl9rN4ZQrbCOtl45eHb?=
 =?us-ascii?Q?lMDsihcA3jW8xY+N9U6yBmBmxMYO/RoZ1/S6G9BqxahzRRN/5QDvIw4wVT8M?=
 =?us-ascii?Q?8FRcasRlj1oZIM74p0xC1e7xSioQCKgoIFtuICtkkCbJ3oeNk1ipYLGydILn?=
 =?us-ascii?Q?fD29AFOevrRt2A2ibMdBIoHixC4nwzr8Zf0WLEqwC9egZ8CQKqJubwMcQmK4?=
 =?us-ascii?Q?ibVms4FCdAHTI3EIbqQeIytv4K6solg0Eh+71/Xiy14uApdpmePoQFVHEOzn?=
 =?us-ascii?Q?y8MZZvu4yNCeGpZi6cavcFHQTohNhesexVdt5nQNGXufbLzeUpZIoRe83bRL?=
 =?us-ascii?Q?vJmcD7WZUeaOOBeRYx1mR+5DcW86teRiLrl7iLJVqus2c1+8uPEkQQn+ge/f?=
 =?us-ascii?Q?+LyCCduGKGew0dc1fKZvZl6q3XhFmmCBCdgBShfyg7mbx4wBJke01VhZ/Xjs?=
 =?us-ascii?Q?IjZ1h4rIaGit5VMacYt/PHien/ajkIDmAo8ULKQ2LE7QKSwjPfLGIpvrD4n4?=
 =?us-ascii?Q?c3RCpt3cN5uy58haKdZHdGb237bp3wMVaODEJhzqAuelTW98dcaUa3Nxk3jK?=
 =?us-ascii?Q?WKkZfFdt7qQ0Jd+9z/Ow4SO+oVuy5QZxRrBG+d6q9OR5Kc7n0r1nVn96O4qV?=
 =?us-ascii?Q?NXlX52jZJdj1MHWezNZrinJiuWpNs6OJePGS3DumeDaxTocjVcGdZbkQSXvV?=
 =?us-ascii?Q?HBypEuL6guGN7EHg5SlYss3bjyunPFzJOSIH5EqRRvwWtmctE03LmWM0SyWB?=
 =?us-ascii?Q?N4cxo1OxsU+5XjJ98y+kBFdTQPEsuMys8/ImBSnpRiH0V+r5KIX94FkNYle2?=
 =?us-ascii?Q?NnXp0I0DgWeEme9ZSLoBtMjSUTlx3rAxoIkxzB791/bzn2uC/f3bWEWfrUa4?=
 =?us-ascii?Q?dEePLQdq9/09UjQPaqe9D47D5f6p/DIrL2+hil+u1QTx/8LZQhGIm7FepDuR?=
 =?us-ascii?Q?WeBO5LQpCH4j54xw1PBr/rK4ugBCUJyc1p4+Bcaq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c88a57-5f70-496a-e70c-08db989a1ba5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 05:33:06.1630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QRaUcjtl1CaQTUGnB8QLD9yGXLroiWdKCdJ1T9AKy8fHcRJrF+eSRzrQy5ZfdR8ic5WtBSFrQ+YAfFbU/RsKkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6535
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
 
> and then for PG_anon_exclusive
> 
> 	 * ... For now, we only expect it to be
> 	 * set on tail pages for PTE-mapped THP.
> 	 */
> 	PG_anon_exclusive = PG_mappedtodisk,
> 

	/*
         * Depending on the way an anonymous folio can be mapped into a page
         * table (e.g., single PMD/PUD/CONT of the head page vs. PTE-mapped
         * THP), PG_anon_exclusive may be set only for the head page or for
         * tail pages of an anonymous folio. For now, we only expect it to be
         * set on tail pages for PTE-mapped THP.
         */
        PG_anon_exclusive = PG_mappedtodisk,

Now sure why the comment says PG_anon_exclusive is set only on tail
pages for PTE-mapped THP,

what I observed is that only head page of a compound page is set to
anon_exclusive.

And the code path is here:
__handle_mm_fault
  |->create_huge_pmd
     |->do_huge_pmd_anonymous_page //if (vma_is_anonymous(vmf->vma)
     	|->folio = vma_alloc_folio(gfp, HPAGE_PMD_ORDER, vma, haddr, true);
        |->__do_huge_pmd_anonymous_page(vmf, &folio->page, gfp);
           |->folio_add_new_anon_rmap
              |->__page_set_anon_rmap(folio, &folio->page, vma, address, 1);
	         |->SetPageAnonExclusive(page)

And this code path has been present since
6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
