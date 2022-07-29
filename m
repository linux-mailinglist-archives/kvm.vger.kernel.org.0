Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08CF58494E
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 03:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbiG2BW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 21:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiG2BWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 21:22:54 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7AD17A99;
        Thu, 28 Jul 2022 18:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659057773; x=1690593773;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Xyb12e2ceTTrVFL2DSyXoREVy7jl9ntXHyTdW8Aax2g=;
  b=N7nItGS0axWYAGHhqBMXcbwVHvx+4ZPiILo1vuK/QqRlszQEREJYkbt+
   6zKbcFa2T+IworKE39V3oxXizKwwTJMX+kzA0ArtSFv8KW3NjR6DAUjLR
   IRHcNcQv35TxUUNt6Ogf1Nj640Nw0dI6lyk64oqIcWdWoxEmXjsaHVGlE
   RSiDvp/D/ibRAL6W4DjtLZJbgOrHJAQ1cmEA9N2uxMjqX+EULcZP9n4pZ
   TEl2Q1HEd9vtirEq5DE+nVSkMmD6YAiU37A9UiKNG3iXsEVnGyYleLRb7
   liWqw9OXKmjneu2O03mh5cERG1HaEwSPWyLhyFCNiyAqiI/nOGf7tykpq
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="286213300"
X-IronPort-AV: E=Sophos;i="5.93,199,1654585200"; 
   d="scan'208";a="286213300"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 18:22:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,199,1654585200"; 
   d="scan'208";a="928555307"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jul 2022 18:22:53 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 28 Jul 2022 18:22:53 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 28 Jul 2022 18:22:53 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 28 Jul 2022 18:22:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLE5dCaeWeFGVUGngXUdXBFQvOz1NPzzZiGwWo+xIj8XylrcAwTYgeo6Sd7wcAiEr4wnoZ5iyed4r0IZW3XqEZFzaEcmS0q5fYif+wlMvY73+1cJaiJjYrcR3inX2Sta5BAFXp/Ot0jxMnLXytI/zWXlKs2ehKFXCEdlAPe2BMgXSUIFipyJjC/qbw5QnrsmheUuftfixbYn92U0g2UwMixs0WxSVvrmP9NYCs6/3mR/FLJJGwVbd0D1uxAIjYQ578yK+UM9a/+6bsSqE4l5CZ9YM3r4KmIxvnfHZt5yDI1AYR0seNlVUHfpiuHSAbCTA3iQAa1FPr5LqyFBg7z9Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H1oVDr9RuDDxCIVNl1o4E5c5uVp9+cr4jI21/ZoOw/w=;
 b=SL6H3O6Mbwj+gRGZ0zqqeTjjYyLXd3POyWvDLFoPR3VV5K/Myds35ogqO79yxJGTGy75sfDNasAhqmqepdBMUV+Ow50r7qXCPhYTGPrumhQYsDr2EtHrVrTMXKt7ptVkv6aVuT0jGWzKBJ2RnGavPo5PV89ivWIpf1jz55TGn4iV391QvIa3Brm7HedjmOu4rYwCxnMHNxP/FKj9t/mP+Hv42qL7XdP13lGKE6UY2zwh6xqXzhKrweJ3GCFxrcnCSbSR+epWw2FeDcWCd36Jj8F8C5MfNuVoRLSRw8gH/XvnClLxtINJN9738kWhk+2p7ozTJDSCJyQhLEGMxeeuog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL0PR11MB3521.namprd11.prod.outlook.com (2603:10b6:208:7b::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.20; Fri, 29 Jul 2022 01:22:51 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::74e8:3af5:24cb:4545]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::74e8:3af5:24cb:4545%7]) with mapi id 15.20.5482.006; Fri, 29 Jul 2022
 01:22:51 +0000
Date:   Fri, 29 Jul 2022 09:02:51 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Yosry Ahmed <yosryahmed@google.com>,
        "Mingwei Zhang" <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: Track the number of TDP MMU pages,
 but not the actual pages
Message-ID: <YuMxuxgFpQdpmBBN@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20220723012325.1715714-1-seanjc@google.com>
 <20220723012325.1715714-5-seanjc@google.com>
 <YuCl48wyA1XkqMan@yzhao56-desk.sh.intel.com>
 <YuGMQ/JJjuWxaUSu@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YuGMQ/JJjuWxaUSu@google.com>
X-ClientProxiedBy: SG2PR06CA0184.apcprd06.prod.outlook.com (2603:1096:4:1::16)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e867979-9387-4b08-24e8-08da7100da80
X-MS-TrafficTypeDiagnostic: BL0PR11MB3521:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IDuL6ieJEVfv4feQ4tefBL5LYRbNNpM74vDvxwAOh8lguZxbb5H0BCh9soVer+L49Bzsv1wG4zktD9Gp5oPxATkr3b++q8TkwFRZIdMFoi71BIetBBH7BcQixAF+Lzwzs+V9fBwFsbVuUgJlHdcMjSf+hc/jqCT4UkBGahvVZxhX/DzBE+b0c8RMjy1x0OX2hXBSxMGbwMHrdaOobnpklVUc/L4g/8KCJoKebyT7ABPKggUsq0+XIWXXxHMeFzV4ekVGCG5a6z+5Dd8URF/Zed2eD4Y++C45kCdLU6gCrbjDKxu+EvIFwT/r761MJUT+J5a6tt4DDrS43X48xBX+FmVvdB8CdMPQXKsM2VM8HSmsoftyxL6Hw+Uo1BZCMzH5anOFfxWMCpIIgIywuS9uHvvqIO49YAcW7x+Xozmya6p/rkWWaDhQfjYGJGcZLe+I5maWNqnOTIFpG9e4vt1n/130i4a/7zG3UE9RTPayfI3Jkn0T6e0ymdDx5lkWOYdIOoPzYHjJtyqcqINaI3NMPVdmOh/topBGb9ZkVCsrbEDWb4KuymYGU4xd8sttb04sepZv+MXBz6NvH5R3cu0AQtBw2spo+iIDv95kibOd2MepqzsesilHnLZeOLnRFJqWKCoK5kghII0a1fGIq/ndLVuV0WMZaoH6YK3yof2mRvgxO5cnmx2OoCfHFCE4ewmyHCcaUW5bdXYjng7XFGhpHa3gni1uf4LI7Uq2H+xQNKE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(346002)(396003)(39860400002)(376002)(5660300002)(6512007)(82960400001)(38100700002)(41300700001)(186003)(83380400001)(86362001)(66946007)(54906003)(4326008)(66476007)(6916009)(8936002)(6486002)(6506007)(3450700001)(2906002)(8676002)(66556008)(26005)(478600001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x5x8s4qBWEH+zcQO+K1Vjwz/hW9ettyKUxBg7qP1Jhi+OjEyGjpkTLZZFa3F?=
 =?us-ascii?Q?u/tUECVWXb2IXd4dT+4qY1pRN18/ejkVrOEjkeIj8ktRwPTohvGpzHvWU/x4?=
 =?us-ascii?Q?0DF12sgWBo0q6i5DwopJaeANQuiuHzWSToJveeroabTwY2Q+4TzMCIVXXSqx?=
 =?us-ascii?Q?C1TDOEWIbNbZLJGY7Cepi/rr8wblNG5fL9ym8ly9luhaQhZhEgkd359NeHQ7?=
 =?us-ascii?Q?dhw61vBTnOhQ4CtLlOwkOURCdG6ORnpV/4zNre2ySCcGqm5kQHCkaNRVfaqQ?=
 =?us-ascii?Q?ZJBSdrV6HJFL7G3IuTuei1AgeAnk8429+oK0/+gaGe+Tx89rZ8jCE8+ml6Ht?=
 =?us-ascii?Q?MWef3azb5iR6epn3lsmHtolC9qYO3fXY40xeFNtGRAo9aLxAWr4MaVQ197lm?=
 =?us-ascii?Q?/DLhyTHN2qoikHMQbmqKCMtsSrORjC5N+Oz8tShyfLUbMc0WVqE+hIpOeFCk?=
 =?us-ascii?Q?rxaxkQP3sIvv2Biy3Nh4NgF46BHQsjV8TpEdn/HKqUP/pXDPMbnJBiCbBWKZ?=
 =?us-ascii?Q?tr8EuFbRQe+I1Wp7xxoZcI6NxlQR0JIEWRGmUps8XP4lRZpT70/ictmcXWq8?=
 =?us-ascii?Q?ZuazsrgrHGLTHHbJkVlyQPcsOaqdvfiGWTZ5+ySuC8YFo2vkNsfH3T9nfs/q?=
 =?us-ascii?Q?rKJTvkoDbSO0HjqtzMTZR7iFpFzOWDTlifI1OcyaeTSev3xQADN1jpuP7xJ8?=
 =?us-ascii?Q?PHNzmj/3TvFd3eJzxQvaiU/KfCgpwr8uBwpPyXOD+nGL/qbrIXR8ogEgKVJQ?=
 =?us-ascii?Q?l0KeewaU5vQCMKAUpkek0yhejCWwa58sJl079FHzysMraluprz2nsQsVe92V?=
 =?us-ascii?Q?GcFqJQI5nn+XaqG0fmoC93pUgzbKMOkOIWZvKWYqGw0uC1IVWBy+GpJ4vYNg?=
 =?us-ascii?Q?kQ0KNFDCITcWXGx1WbQqfm87uBrmD9z7iXfTkOeQzCtGr+apOliEez9ul5Ge?=
 =?us-ascii?Q?jfg+PaK4j2IvoXFTX1TdkvCn7aW2PfL5Fg+8VuM9YzZpenSarqpsa1DSlWsr?=
 =?us-ascii?Q?b1KH02UehTi4XP6yq0TUc3rNtoMgYEDoeYnVimpaqJpKqVZuZCiKKkraI36e?=
 =?us-ascii?Q?kYIJtuIsVZAMfMV1uC7MzL/oE5AmtxvS6063riZ7qKrhqmmtC9UNraWNtyWK?=
 =?us-ascii?Q?S2Pmeb9kz/JK4NqJcauUDJPegbzhiAW/1W2ix5FB/1CyUcOh4yjwZxlMPsEZ?=
 =?us-ascii?Q?ubN5nmKlbvyaiV4ibMRy10nVaQuxZFWhsJXAZ/8pXEvS6YeMj25gtLMvfN28?=
 =?us-ascii?Q?WikQuKzoXKCl+b7YdmH+MH899axsXl2C+0SzkPun6Z/x3WL9D7DI+3X8Hnbf?=
 =?us-ascii?Q?nY3p8SHoS5a8AbNqVdDrDU551Q4OkBzzLIeljCycWlZwk5hx4qTIzXX238Gq?=
 =?us-ascii?Q?LpxyS2motjYXL4shz/tl2upPJpLe3xTXOmAklgLrE3aQSRrNrdY0lfDUwEPo?=
 =?us-ascii?Q?MF3FaGkeUw8Pk8uF/bidTCODj47S4pHN9sVJnYNShRjNJNqwASBNgOJqs980?=
 =?us-ascii?Q?Sj8QQmiaOYzfw9G1AaCFU/lt/qBmQQygbLqFIE2+uSpUwcapWqbZg8sq39lL?=
 =?us-ascii?Q?P/GvBrvRAjGPwWC+j7IgQNmXZFxsMGLeRn77VB4D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e867979-9387-4b08-24e8-08da7100da80
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 01:22:50.8928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IYn+NAr0F8E3dZfbpOnxkFrN/4mcFGE0Doz//htt9/ETdc4/0+Tpjs9NNulIK+Bzd1Gsnb/vcPqoTOTd6jAGhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3521
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 27, 2022 at 07:04:35PM +0000, Sean Christopherson wrote:
> On Wed, Jul 27, 2022, Yan Zhao wrote:
> > On Sat, Jul 23, 2022 at 01:23:23AM +0000, Sean Christopherson wrote:
> > 
> > <snip>
> > 
> > > @@ -386,16 +385,18 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
> > >  static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
> > >  			      bool shared)
> > >  {
> > > +	atomic64_dec(&kvm->arch.tdp_mmu_pages);
> > > +
> > > +	if (!sp->nx_huge_page_disallowed)
> > > +		return;
> > > +
> > Does this read of sp->nx_huge_page_disallowed also need to be protected by
> > tdp_mmu_pages_lock in shared path?
> 
> 
> No, because only one CPU can call tdp_mmu_unlink_sp() for a shadow page.  E.g. in
> a shared walk, the SPTE is zapped atomically and only the CPU that "wins" gets to
> unlink the s[.  The extra lock is needed to prevent list corruption, but the
> sp itself is thread safe.
> 
> FWIW, even if that guarantee didn't hold, checking the flag outside of tdp_mmu_pages_lock
> is safe because false positives are ok.  untrack_possible_nx_huge_page() checks that
> the shadow page is actually on the list, i.e. it's a nop if a different task unlinks
> the page first.
> 
> False negatives need to be avoided, but nx_huge_page_disallowed is cleared only
> when untrack_possible_nx_huge_page() is guaranteed to be called, i.e. true false
> negatives can't occur.
> 
> Hmm, but I think there's a missing smp_rmb(), which is needed to ensure
> nx_huge_page_disallowed is read after observing the shadow-present SPTE (that's
> being unlinked).  I'll add that in the next version.

It makes sense. Thanks for such detailed explanation!

Thanks
Yan
