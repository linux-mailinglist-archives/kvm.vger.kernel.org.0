Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D6A708E6C
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 05:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjESDnz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 23:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjESDny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 23:43:54 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DFA131;
        Thu, 18 May 2023 20:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684467832; x=1716003832;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=YF+QpS8hwGdgmTyeQ6ZX/cQJ6rwB40JHrm81mFWNung=;
  b=ONcQ17jgZqfg+zStqSvv1+hKBoUQi/sR4k6sniTN8grkqTZtZy+Q4tY6
   kRsCndSuupZQ5nTQcaf60aLXGe41MhZKdlgRAlrC5V73mrO5wSIW7/Nbt
   e7CPeSXAf/6/U/fZpTF+pRzSCnsJeQsZkfW7S9KZOKSea5zaenwUTUXCC
   gs6uLS5V0ltfF0eoyiqsp824FnPFPl0HoXaIZFYki9Swy8b84dN5SQWN/
   OC4B8/4Cmi6fOJt41eX4A3G8fD0JV0ZOISb5Y7hnktLjkKRNvkrcuKeci
   J0hV0ovUXT/dUfLDdai8NkFNs0BKfYGPJAkt33KlZpv6sNWcjtAbaKx8d
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="354625302"
X-IronPort-AV: E=Sophos;i="6.00,175,1681196400"; 
   d="scan'208";a="354625302"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 20:43:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="705435824"
X-IronPort-AV: E=Sophos;i="6.00,175,1681196400"; 
   d="scan'208";a="705435824"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 18 May 2023 20:43:50 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 20:43:50 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 20:43:50 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 20:43:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlZ5VI5SCWvC1AxCpm92o4Bmh3RWCd1e7oeFVceXa0iPPUYWF9RsyBhWW38tjlQ4yt/L3vvQkuH0OWk2kZCV0tsMmWG1a8sqiRAoIDY2U1WHNim3wk9LCMzmrccKCDQru45nE5SRTm+nN6vQlRjMLg1QMhQ6ZZzsKcoe3iZTwlUxjQ8ToxOatsyg2aAILPBqfbybK8YjpA7wxTu+C4L+xsr7YWOBxltJy9QVTAKVi07fQvKVMPb/GzhTDuvyWLpS50HHufDGSbilO/mjNCSiXeMSFSvhPU1oC/5SXcQcPcQbYPvoBihRorq24NbRT6S0Vm0vEPRxxWCRFkUykEwHGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSjv4/cQlXyzJZCnNPRGnsU6wSI/V5GGQoVXQoYfOwk=;
 b=jDsTTcMGVBTkOBVGS3+QEaiNyCOFzVw+QQBE76B/E1x7cInBGtIcLBwEeDIqAzYhXMK00Lm7wcoTUhiH2IFoxXUpDmrxtwUU0p1VXqC78Z+y5nv2Iv4nnygKCy99b9rEG9mNDA6h56xiCjiYGgpwmc9juk6qL7eY/wqAuz8TQ5MiVZaSfaTTbmFnvHot6z3rcxCt7vTT/1t7V19PNWmb8dYRF+p8Cg2j3iF8kEumvrSyIQS7wLdhnmeCPrx92tUC9VM+5JnAj/l4w2bTXQ/OHFl/h12prok7KEUEUbYskM124kue+V7hhtalbcKGl87SnmLb88UJVhUD+hebmo4UUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7449.namprd11.prod.outlook.com (2603:10b6:510:27a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Fri, 19 May
 2023 03:43:42 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 03:43:42 +0000
Date:   Fri, 19 May 2023 11:18:33 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 03/28] drm/i915/gvt: Verify hugepages are contiguous
 in physical address space
Message-ID: <ZGbqiTWN+7LualJ/@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230513003600.818142-1-seanjc@google.com>
 <20230513003600.818142-4-seanjc@google.com>
 <ZGNO5gYKOhhnslsp@yzhao56-desk.sh.intel.com>
 <ZGTpsvZed+r3Low1@google.com>
 <ZGXqo+tG35S2c+QQ@yzhao56-desk.sh.intel.com>
 <ZGZovmcrdh8NcWqb@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZGZovmcrdh8NcWqb@google.com>
X-ClientProxiedBy: SG2PR02CA0125.apcprd02.prod.outlook.com
 (2603:1096:4:188::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7449:EE_
X-MS-Office365-Filtering-Correlation-Id: aa38cc1f-c6ee-4e92-c28c-08db581b3d6b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A2PihqJsu9yOzIknLNJc6smlOdXTUHFZy0kXvy9tJ+hdruSO4Dyc/PXaUdbFMmkkNehCCO4o6FGFOqc7FXNk5B3FfxC71Tzo/NdydjQJ6QB10UFvSkh15S/dNdz96b+HD/iO4df8Ua4XDP1dmyH2Hmd29OryLXyxRkgGrrwyeVSy8GQRXJBdif8jfbGNM4B9SR+//FoRJfp73JDgUULByjXYILCD9q7gwuA20yQJyspbt89vQw9m0j+F91AMK2XBTjKLObE1MzbJ6TEi5ozoc+dj1xs+0y/3RdjRAGeqMT9yOqz37rDqTyvRvLyTJ4dzGIcc7fnidsln+Gv4I9Udw9EU7zOqShRB5mKgJdLyrqHSotGGematc7WMZHdANZMd6kFZGXFp/j7LZz1OuCFZqUfeUScXvwuiBdVwEKRR0JK7IZrmYFaJg/1bpvgXNh9O9PSXTb8b1kzGx+MgLCoXYN6U4KfmN9l0QS3Dh8ahKI5GGkWsVPOnq8HFPosfNfdPOI0ENxB46TxMqINEwSLUq6G/oAAMU2KB8dIGpkCsIksHR3sWvhsePpxVyLCmK6zs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(346002)(366004)(136003)(451199021)(6512007)(83380400001)(54906003)(86362001)(186003)(478600001)(6486002)(6506007)(6666004)(26005)(41300700001)(316002)(38100700002)(6916009)(66476007)(66556008)(4326008)(66946007)(82960400001)(2906002)(5660300002)(8676002)(8936002)(3450700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4P/GJyVGMaP0NuxtCt0Vp2SQah2Juw6bdqpvZr9WHlPdGFhxUVtcp95xUXXY?=
 =?us-ascii?Q?sxEbd64f4ekuyFnQj4p9KSJtfGD3+akhyqYlS+MJSJRZOqq+B7MOulbAx/Lb?=
 =?us-ascii?Q?idBJu2xZahY7Gi+lRawSgviPWCEULJ7mAkSUnWWdpjnttpgacnvdRXDdxFoE?=
 =?us-ascii?Q?R4qIEwMn5/toXPZBKgxqdDWLc2lpL/Sbyz/Xgaccjxmdcu8Mu4X1ADbnWAtU?=
 =?us-ascii?Q?7IRYXDDs2yyDahBe7u03KE52v/sXpTub/vZDalHNGSQUwhQ9WKIykSQOuZB8?=
 =?us-ascii?Q?Wqr1bOyCtJYePgGIHovX6CjH70dJJtTXxn25TkxYI5mTwqsSn+3ipyChO5aB?=
 =?us-ascii?Q?5Y/IFFVtEpNIcr1E2gTBiMGqv4K8CTopVNbi/SwXWsoyQ5W60S+BswbMMOVD?=
 =?us-ascii?Q?sEeWzhk+quOYd8iAHFDqadoItyK4SQQAZCre73hjLKOaXnZVbbFgeLqeIURH?=
 =?us-ascii?Q?rXbKuS6TeMHM93GZbeM+XwwkWXv2N9y+puJJVZbh8B+smWjaHHXvWjjlahId?=
 =?us-ascii?Q?xauslUgyj/nHTD1Crtq092ZNJWDheVlSUV+2uuyFUthtDWhI6rRgw/48lfJD?=
 =?us-ascii?Q?wVjKSZtSxH1F8H7xCMifiVfI8JNVH+S//eGc+ubZ8FOTnsfo6NgckYLGzcPL?=
 =?us-ascii?Q?RJ8My+W3HnJq20nlqfR1dy38NKiIBXgCTBAufc3HJgnvKORLRKqQ/DXZxoIW?=
 =?us-ascii?Q?XFhEn0sKyiqWiw63WIm8Fr92PeExaY/p69icaf8Q4N2S48m5KD/2BUA3Uwik?=
 =?us-ascii?Q?e8EeI46fOV3z1CRDvqmCYW4Ha3yzRIvG1Dar9Rz79SRgqo/U/JODLh7jZxdN?=
 =?us-ascii?Q?r7Z+WXhtMdTNbs/VKz5kYzK9b+9+BePg9+8ovCDlItJvZ70sKWfqENeRvlnC?=
 =?us-ascii?Q?KhGwZcvt0p7E2ZX0Z43LvCTU6caOlV2OrAUXvc5Vr7bYL5/AwiSX+MA2Gx2y?=
 =?us-ascii?Q?0DqRpzLifjQFim/FMVTrRsMzfCilnAhBzE2hkzEKRnFM0N7HnrYBT8CVD/pg?=
 =?us-ascii?Q?qKNgpGZwkGwj7kriEUmv/4fHoUYpImC9yZuXMvDJt4Ua0WY1R+/VP9dYMr2q?=
 =?us-ascii?Q?XSQLYn2EgXemOS1R7W0wPjDYIBd7M+TAkgCygxRNrLUEx/8+PDIDbVO0l8lL?=
 =?us-ascii?Q?qGBDCZPi3sUqK5yRmzfWESMPxyxn1rZDDx7RHjyAjzpZbZK3hL2/MBzLBoR7?=
 =?us-ascii?Q?2IG6H5gx6Ybl7RcgINuBFfTH0ul+4R7XGk91s/T6AbsL4ghbWZL841Ze5MRt?=
 =?us-ascii?Q?KxYmUsC8XBzSq3mVHlcOQ3qU/yYPMKuz7LMJd9DUNfNBfbVWg8I2+nD4U2z1?=
 =?us-ascii?Q?jfIs3QvvrB1Cjpoax9GDfaLl3nNempoo+sHYA5sT+LU16Q9DhhVocPS959pp?=
 =?us-ascii?Q?3KJqmcRAhOsIZQ//22P/BMTMSLocdHS+o12Q+M95vVv+YFbRKjx9ZJhiFvs1?=
 =?us-ascii?Q?Ev+khtydtEYafbdMgjfxx2QbjYi0GrAp9Z4tIrZNaT8wUfaNo+CoVwY6xeQ0?=
 =?us-ascii?Q?ttwXvDKkGA5LgksRkZRbN5L/8Pl+81G2ACTJHW7q4py1vH7p44z9NZMbaIsW?=
 =?us-ascii?Q?kgzWG9wNjK4byLjUzcME8DPdFpWPTVd8mqJtH82E?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa38cc1f-c6ee-4e92-c28c-08db581b3d6b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 03:43:42.2997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 39OLLcr5gEViJkcO4Qxbgow/XzcDQEbQ/MPCY2X2HX5pe945Q52caqNOCIs+8w2+23Hjg6wuv4mGC2mxCRPJuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7449
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 18, 2023 at 11:04:46AM -0700, Sean Christopherson wrote:
> On Thu, May 18, 2023, Yan Zhao wrote:
> > On Wed, May 17, 2023 at 07:50:26AM -0700, Sean Christopherson wrote:
> > > On Tue, May 16, 2023, Yan Zhao wrote:
> > > > hi Sean
> > > > 
> > > > Do you think it's necessary to double check that struct page pointers
> > > > are also contiguous?
> > > 
> > > No, the virtual address space should be irrelevant.  The only way it would be
> > > problematic is if something in dma_map_page() expected to be able to access the
> > > entire chunk of memory by getting the virtual address of only the first page,
> > > but I can't imagine that code is reading or writing memory, let alone doing so
> > > across a huge range of memory.
> > Yes, I do find arm_iommu version of dma_map_page() access the memory by getting
> > virtual address of pages passed in, but it's implemented as page by page, not only
> > from the first page.
> > 
> > dma_map_page
> >   dma_map_page_attrs
> >     ops->map_page
> >       arm_iommu_map_page
> 
> Heh, thankfully this is ARM specific, which presumably doesn't collide with KVMGT.

Actually, this is fine with KVMGT (owning to page by page access), isn't it?
:)

> 
> >          __dma_page_cpu_to_dev
> >            dma_cache_maint_page
> > 
> > Just a little worried about the condition of PFNs are contiguous
> > while they belong to different backends, e.g. one from system memory and
> > one from MMIO.
> > But I don't know how to avoid this without complicated checks.
> > And this condition might not happen in practice.
> 
> IMO, assuming that contiguous pfns are vritually contiguous is wrong, i.e. would
> be a bug in the other code.  The above dma_cache_maint_page() get's this right,
> and even has a well written comment to boot.
Right.
