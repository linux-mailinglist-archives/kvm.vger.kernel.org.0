Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409C8775002
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 02:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjHIA4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 20:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjHIA4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 20:56:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C4D19A1;
        Tue,  8 Aug 2023 17:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691542592; x=1723078592;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=axdD7x6KRSyFlpR3WprMIsB6/vxR7T6KsdrQ8f++MO8=;
  b=mZasGm/oAjG4csRekzpbtz4XlBKVDT/t/w0pd/wo2WC/mfgQs5/2VJ0B
   RoT0pavVfTlg9B42PCUMT0A+u1fOlhtVagBJldJzSLJTFDeH9g3J8p4Wd
   rPDdLQ2govl069UiHzCbq3eGnVwkVPDsRtLnMghE2wnxhqROiEl4Q8gIs
   QcT9cny4BQIzKgOqhhzkvf8l/VKAwiaQ1ybSMqQ9y16GrXPf60Rg9SRdt
   5l5Ul74+F5vogIYVjOc3ZoUHzx+jvhPgvhT6EZMAyqJg7aBpRAwry3rai
   b7oWqBQstKyczi/9xq/0LscUyeuJs3xiExhpqCgcU62l5WkzHPMzqftyI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="434873350"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="434873350"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 17:56:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="855316200"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="855316200"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 08 Aug 2023 17:56:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 17:56:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 17:56:31 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 17:56:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nv9vku+vIO+tyAITBiLhAkt5kgEEt9sj9f104dW/T5eYmJRq3cwslKXISWcrEdCDp66BJi6FYLYSnr8wL3c2UhtWXZAeE56pZ1ZQr6rivxHQJrtXj7VZRgSpxk4fqmJ/84GxOJlIAeQII/YElYc3vi1wo6euHN1VM/W+tL2yOyF2qB9+SpGZA9/29w5WrzW0fgwi9Ip5WXNuSZfKZlHYTl/EJIIWr/fICVM9Nqu/gN+PXGKFLRQvMwJh/4kvnX9oAl6H15ccyQKUVoJRULha+OkA8awvmXeAPi85a+JBk5q/5zfXAwMZaTlb8dALO7TKxpwhiEWp599gusEldm7Qrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1GePVeoAHFgXDONK0eo0HVDuRyqL7w0jd0ixOA3tmvM=;
 b=iYC/ePwLfu3Vmq7Dyrm4J72hQS1X8Kf9L8mgDXj4m9/9jBO1KgMTCx747PA8SzHQXtJPMriIDwvo3jCdbDRJr9Q+T4g67OFbev/VkO3/VA8mDx95OSDfBlb0QpMXf2VSkx+jC++cfh2MGlQrLhpbmbIKsPyQ0TxmApR5oR/6VpAm/ZAWW1lVYaWvvhzf4/oAfPCsXwJ/lIvQCKoXt1mq4nN5o9h6hfjksciGfeHfJv0GrjrKY8aRbO0PQ45ZQ2tAmt4Pjn8V2gTA1VCuom56EVZnzPCqnV4gil0/CV3oPNh91S4lCfRjb9et/3xVbV19WcU9yDFsL1WpLV3VFw4KMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH0PR11MB8166.namprd11.prod.outlook.com (2603:10b6:610:182::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.27; Wed, 9 Aug 2023 00:56:28 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.028; Wed, 9 Aug 2023
 00:56:28 +0000
Date:   Wed, 9 Aug 2023 08:29:31 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <mike.kravetz@oracle.com>,
        <apopple@nvidia.com>, <rppt@kernel.org>,
        <akpm@linux-foundation.org>, <kevin.tian@intel.com>
Subject: Re: [RFC PATCH 3/3] KVM: x86/mmu: skip zap maybe-dma-pinned pages
 for NUMA migration
Message-ID: <ZNLd64+92ltbp5SS@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230808071329.19995-1-yan.y.zhao@intel.com>
 <20230808071702.20269-1-yan.y.zhao@intel.com>
 <ZNI14eN4bFV5eO4W@nvidia.com>
 <ZNJQf1/jzEeyKaIi@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZNJQf1/jzEeyKaIi@google.com>
X-ClientProxiedBy: SG2PR01CA0195.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH0PR11MB8166:EE_
X-MS-Office365-Filtering-Correlation-Id: b4db4085-94d9-4c23-eaf0-08db98737671
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RLJyNeA+IQltq1uOiOjL99tWNBs8UxfVgw0hs69MBKMIrny1GBznLt35Ox+FQqA3tHVHZEPdcRU8D6RdDPsMER05Ul6YCRzJyjl7LJTxmcj0/i7in8yt4Ni4TekScjyjv5jV85eUJ+HKFWD5sFmcTSe/Fb/Da5zhjlikzagxvXLg8UFCycoOJoNv/i0gIBa/x/ECnOjYqjQIYp7Z/ik0Pqh/qTKBDtSohB3Q/1f0frt9kF1nBUdINLGAfPwIVg4Ht3ALoGbbMTKKi9YmI15mfGMTlDkyqXLKFJj84ALafKOkI6qH++YlEO8r1MJoYgsi7BDmxkyCREyFxkL15s0a/ASbVAsF5FQ3gD8+/1uSi5h51hdLGsfcTzn7JWT0EWTuGvpZ+EIVBtR4JNt102Oawhn9I5i4/Kp3AZ3mosxEj5aw0qVLHHqiRmuis+DWifyCdAE68LFCTU5W4Xyv7CBWxkNnH5AYi3wmmrN189jWiIiNYMtEuxxKtJW+LCeTvTg8Ok2s/z3V2xvSTJ0QT/CENsq2hn5UHlnS2wY1uaSQNA+aeTRifbdV2/TOo5/SF+QEq+xIiHQBiJrSMzZ6q2SEqUrtZXDUGfE/e/0YZxNBuRI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(366004)(396003)(136003)(1800799006)(451199021)(186006)(478600001)(107886003)(6512007)(6506007)(966005)(26005)(82960400001)(6486002)(6666004)(38100700002)(66556008)(66946007)(66476007)(83380400001)(6916009)(4326008)(7416002)(5660300002)(3450700001)(2906002)(41300700001)(8936002)(316002)(8676002)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H2+opliugcdK5XPmBPQp32GZnE/kN55UaSwzZNX6F/Pd9qJfwLIUfvsuZBXz?=
 =?us-ascii?Q?dRU0Xv9d+7782gQiC6ljQOn0k7XmyWkP74lFM3M/K6gYX9FA7fMPHQebbfBI?=
 =?us-ascii?Q?+nyTH+ofxAfk1abyXLZHKjgpNa3zZg1D0bEE1G+Yfh2KRao28NRVg2WqIDZS?=
 =?us-ascii?Q?V0TzLhzSxBY5qRJ/pbd1Kt3uX/cD6scV5mTSdJSnsKegTtwBqJIt6r6NKV2m?=
 =?us-ascii?Q?2Zah0VzzRIispAjB2839Z4vKmn9LXEWuUmTtbTDIrnyul824oOuiQOe2W37z?=
 =?us-ascii?Q?byj4gBI28wFB8EHonw7O+hBEqy5j7hACRVrHgH2LUytcwZ21whL/91CjX9uX?=
 =?us-ascii?Q?P/eXvn1PAc10wwJvLVPWlJ4Bx3R4CtkvrOubT6nZNjhWWuuMCxMW30FCllpL?=
 =?us-ascii?Q?y77edVMLSX+RrWcDcGuBFZRKJqKh8KYnTI6uTxnzf4lAelkGWV2rgsFA7ozn?=
 =?us-ascii?Q?tAM4lWXIsVokWDqdf/UrQut7rtGnnnPGdg+76gb0jC1dZNNoMqi4C0OzlY32?=
 =?us-ascii?Q?sf/xn0Y/cevm2yeAmTlZEchzKXWeqG8wTamJq0bTenMCqx/VXdHbbfaAcQk9?=
 =?us-ascii?Q?F53hN6oi5q4tWlaNELn5Y8xWssFSJiNxcUo3l4DYxmW3zkQmfNqAdV8M3i/+?=
 =?us-ascii?Q?3Rs2ceJ4D+/PbMj3J5696bD9lZvQMbdvAB4mZwFrRrETReg0SSkmjHQIJqXt?=
 =?us-ascii?Q?vZM7VOhyEh6SG+fG3tXj6xxucmNRFyviBDXlomLjtHmTOxxPMeB06BTP5DLd?=
 =?us-ascii?Q?irkVThteUKo8HioidcbnjtKBA2v/4YydKOa4tVAGiovYKfDw8gSMLsTv97uX?=
 =?us-ascii?Q?54o58N8BEjovnLdkqpk0vn3+D5viOzOZr99Zq0zcFV/QhggOO2jTqlfUfV2P?=
 =?us-ascii?Q?QCcHsQpk0c9s/O8hyBKdEmCneXtX86tv4ZnDUjWsqRvFJWCr9LejsOAzy8O6?=
 =?us-ascii?Q?yF8/U3e0I9rcHgOuHQXk15QvHf5RPVGJNZd8C8r7i+MkqI4H/tx8yEJ6kHWu?=
 =?us-ascii?Q?g+OyovdQqYptcN20fYq0RAz1sd2eEnHPzNgsaTP3p14FPeXZEAmUwQnht6Ay?=
 =?us-ascii?Q?3ko75YHxKajdoi+1zjxM9SBosbOQcAVrDkFujQD2RffElLnIWZifrI3/pcZU?=
 =?us-ascii?Q?D+uDgFVNMXsskoy/aAqt3ZB50pMf4Hr3Er85swug65hLfiA6lQNZvNlWQcUi?=
 =?us-ascii?Q?v3Oa3eCQacPPLgjm66eGmluWxb74XJeDObh8BFJGBOGQiQAavDG2nY0cozWW?=
 =?us-ascii?Q?KVh1F4XPmGKn+9T9bGdHM0A0TcIIOYNav2FmH/lMu4IbiIsh/+jRXC4b6483?=
 =?us-ascii?Q?u2s2VPlVnyPZG396DoujV4nzaLVirECUCDXs5wEZ58QTge7/dBct1Nefwc2W?=
 =?us-ascii?Q?z5JcuKndiF1uKYrov8zGBPujAzZDAcDK2HmEejNP038DJqAVFQWjFKmiviVG?=
 =?us-ascii?Q?B4fEM1uBE4gGylaeD+ukCMjBv3f3TnGoZJBcINLDt+f8SS4qTy2TVZQDEcrK?=
 =?us-ascii?Q?HWR3OEPo90n9kxNS6H77DI5To28KWWs1qrGBErifEjky7sBunY81uRD3704o?=
 =?us-ascii?Q?fvlJtp5futdNERI/9f0IS5dxe0HvY97ZIH+WKqHC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b4db4085-94d9-4c23-eaf0-08db98737671
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 00:56:28.0370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MsgRl6MNuHWajTOp5gy3NUH7gIAulT/YqSvkeasNw7EA2+TTTzS9L48fIHhIPFa0icASQFU/SEZ9DnbRVqzbNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8166
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

On Tue, Aug 08, 2023 at 07:26:07AM -0700, Sean Christopherson wrote:
> On Tue, Aug 08, 2023, Jason Gunthorpe wrote:
> > On Tue, Aug 08, 2023 at 03:17:02PM +0800, Yan Zhao wrote:
> > > @@ -859,6 +860,21 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> > >  		    !is_last_spte(iter.old_spte, iter.level))
> > >  			continue;
> > >  
> > > +		if (skip_pinned) {
> > > +			kvm_pfn_t pfn = spte_to_pfn(iter.old_spte);
> > > +			struct page *page = kvm_pfn_to_refcounted_page(pfn);
> > > +			struct folio *folio;
> > > +
> > > +			if (!page)
> > > +				continue;
> > > +
> > > +			folio = page_folio(page);
> > > +
> > > +			if (folio_test_anon(folio) && PageAnonExclusive(&folio->page) &&
> > > +			    folio_maybe_dma_pinned(folio))
> > > +				continue;
> > > +		}
> > > +
> > 
> > I don't get it..
> > 
> > The last patch made it so that the NUMA balancing code doesn't change
> > page_maybe_dma_pinned() pages to PROT_NONE
> > 
> > So why doesn't KVM just check if the current and new SPTE are the same
> > and refrain from invalidating if nothing changed?
> 
> Because KVM doesn't have visibility into the current and new PTEs when the zapping
> occurs.  The contract for invalidate_range_start() requires that KVM drop all
> references before returning, and so the zapping occurs before change_pte_range()
> or change_huge_pmd() have done antyhing.
> 
> > Duplicating the checks here seems very frail to me.
> 
> Yes, this is approach gets a hard NAK from me.  IIUC, folio_maybe_dma_pinned()
> can yield different results purely based on refcounts, i.e. KVM could skip pages
Do you mean the different results of folio_maybe_dma_pinned() and
page_maybe_dma_pinned()?

I choose to use folio_maybe_dma_pinned() in KVM on purpose because in
this .invalidate_range_start() handler in KVM, we may get tail pages of
a folio, so it's better to call this folio's version of folio_maybe_dma_pinned().

However, in mm core, i.e. in change_huge_pmd() and change_pte_range(),
the "page" it gets is always head page of a folio, so though
page_maybe_dma_pinned() is called in it, it actually equals to
folio_maybe_dma_pinned(page_folio(page)).

So, I think the two sides should yield equal results.

On this other hand, if you are concerning about the ref count of page is
dynamic, and because KVM and mm core do not check ref count of a page
atomically, I think it's still fine.
Because, the notification of .invalidate_range_start() with event type
MMU_NOTIFY_PROTECTION_VMA only means the corresponding PTE is protected
in the primary MMU, it does not mean the page is UNMAPed.

In series [1], we can even see that for processes other than KVM, the
PROT_NONE in primary MMU for NUMA migration purpose is actually ignored
and the underlying PFNs are still accessed.

So, could KVM open a door for maybe-dma-pinned pages, and keeps mapping
those pages until
(1) a invalidate notification other than MMU_NOTIFY_PROTECTION_VMA comes or
(2) a invalidate notification with MMU_NOTIFY_PROTECTION_VMA comes again with
reduced page ref count?

[1]: https://lore.kernel.org/all/20230803143208.383663-1-david@redhat.com/

Thanks
Yan

> that the primary MMU does not, and thus violate the mmu_notifier contract.  And
> in general, I am steadfastedly against adding any kind of heuristic to KVM's
> zapping logic.
> 
> This really needs to be fixed in the primary MMU and not require any direct
> involvement from secondary MMUs, e.g. the mmu_notifier invalidation itself needs
> to be skipped.
> 
