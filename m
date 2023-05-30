Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74598715359
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 04:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjE3CAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 22:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbjE3CAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 22:00:13 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA4A133;
        Mon, 29 May 2023 18:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685411973; x=1716947973;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=/OvvSvp2Dj7iNv+Cm4BDYzwFDCHF8Sj/OCY5TSJaUkQ=;
  b=DYX9X7ICY1qvEsugHT5lVlgz3AyWOrqiXpvmzqm2RRhjSbUrg51OvsBH
   SwS+l4p6kLSmWk05D1Bwa9kNoy0meBI1GDcDgT52rY9b7u7cFvUzVQdci
   8CnkadG5RacPGTYDJXVpLUPhoeirOTmk3w7O5oF68XlhMRyczFWF5AUsC
   WMvdqS7iU/XTzi261EFfeU6uq9X5qSv+xnpVd9S11w0snSZihQYKnssUm
   uSJpvQpANYfnRxTmeevhyPWmEXEQw2tsPXIbLiH801C7PSkUqIR8Mjmdd
   Vsvwq8mlmkvjDLtmHAjaAHeygJyJmjWiUN1rzyH4cR7epQulAwr3FZi+I
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="353639098"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="353639098"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 18:57:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="1036385876"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="1036385876"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 29 May 2023 18:57:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 29 May 2023 18:57:35 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 29 May 2023 18:57:35 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 29 May 2023 18:57:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U4/gLLPA1I/iKFGXFxP+WOEG91apAdRhvJ2C4sqqA94slVNS+wEvJcv+6vU6XrcxkcA7lUXvNM7LARF7Y4qWJ5yp8J07pFqBAJ+wBGp94H4aHgSQneJk61v8lm27Lb7maWCLOz8xlLZsjsTBjUWbioNqdNdsJoWHAtjNsNgYVaGfNEqfoSPxw2nNjy3muwv10TRcL3uZxRv6eOdpkpNxN3GZxjNyTyp3ljRd1WDkKvqcy7QHtvG06iDigejKoWmr1sWUeagZxoG+KK+0OZ0uq6wZQH/y77eUXJRX+a3R3/hjYIkAkp7//Oi57xvqTBNoMk2NpJo29+D422Sja1Z0Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vl5aPgjww28OPX1QysOk9thba9sl/qCHOl66MNFJwlU=;
 b=cXMH4b2LLTs9RmihgdXw4XwYuPtIAxYrwX/nZzJ880lbgJkQJFDE+DOgtV7YDShaPkOswSj7BQizG+SSWYgJjz1rLAtKRto2Umy67Ny2491fUXjacw9yPFHNDsAJGHICP5aaZx5GIIqVHTvbMbA2eI4ufQXUYfX6hzu2vrgLmNHl6L1OD6BvurJqWzwhSYod7n0pJ8HcrOvMCI9sCrlYU2jEZfgqRdxGnEQ2y8+1Yr45GdLGmDWrBeaYBpjlI5/PMm3C1GRICZ3+cfun9/7t88Rv6mz/MG0pI46cCGLsbqrDeQ3ov5yN2Sqn++wiuY2mlyTwd2kou4SZzV6ToBpoMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH0PR11MB5563.namprd11.prod.outlook.com (2603:10b6:610:d6::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.23; Tue, 30 May 2023 01:57:31 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af48:a141:6dd6:25e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af48:a141:6dd6:25e%7]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 01:57:31 +0000
Date:   Tue, 30 May 2023 09:32:21 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: add a new mmu zap helper to
 indicate memtype changes
Message-ID: <ZHVSJRd1pxTccmb3@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135006.1604-1-yan.y.zhao@intel.com>
 <ZFsr9TynkA/CyPgg@chao-email>
 <ZFtQeLNuXP6tDMne@yzhao56-desk.sh.intel.com>
 <ZG1DhSdhpTkxrfCq@google.com>
 <ZG10zi6YtqGeik7u@yzhao56-desk.sh.intel.com>
 <ZG4kMKXKnQuQOTa7@google.com>
 <ZG807ECX4TeBcE61@yzhao56-desk.sh.intel.com>
 <ZG+Epwp75nJ7tpXM@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZG+Epwp75nJ7tpXM@google.com>
X-ClientProxiedBy: SG2PR01CA0130.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::34) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH0PR11MB5563:EE_
X-MS-Office365-Filtering-Correlation-Id: 347669e4-a9bd-4fdd-10e5-08db60b13ab6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ey3NF1/DS6b+DE6kWmeKg3wFsu7vnhFH7aFdmjSRkxyGVi7URg44HnHuOtoc7OHVMOKKAaNbLxiZPLD+PmzpPw0RzxMnQpDvL/4Lfi75cvwtVMsK1WjrgdwXJvVhDyeU8De0Jtf/qCeiPFukcpYQhmawqVEyJ8QJphcBzSe4cERj9gmyDNYaZnyj/kVNBOU7mGih55KXF+8Dktpo0iWvcsmbAv43vdFUrQmCqXQkXfadekhYSZjzdxgAKTQPtMjR1Y9UFzKUmHnBYI9pvPhYTS1jh+eGIEbjhbkir02rQnDbE48e07haCj3G1XwxdtW3roojZEOiWkLgCS/Ow9V8y4VDwlWFk8YgWbZMrwTx5KjdBWZRQ/Iyxw6qN3fuBtz/5a2RYFGXhEUfo0Vfysg26Dgv/oNR4csmNXldgIy0YsovKeeazHUfeVk94O25yHomvXXvqXnLnigCx9eJhxLfLIoXn6OL66thOmYU7LhoUT1f5Q/cRdqW0BDuQ+DBjjeVdNT9nEOIfRQP11rKBYDsatgZlpeEVCyflbAD8eXQen7yFDW4qbEzXr+4EodiWgWK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199021)(478600001)(8676002)(8936002)(5660300002)(3450700001)(2906002)(86362001)(4326008)(6916009)(66556008)(82960400001)(66476007)(66946007)(316002)(38100700002)(41300700001)(186003)(6506007)(6512007)(26005)(6486002)(6666004)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9jHWXdoIG/Kjpzqne9rXds7O0Rl3P+uflIBwnFzQfSKBPHqK2Ud7QtkYLt9l?=
 =?us-ascii?Q?N1OUQti8aajkskzkyKGDWUM39x9ukziapmyxD0ZCE7ZvWEAmZUta5WhiUK77?=
 =?us-ascii?Q?tdiuAsOcxkInIR7lwe+F5V1BFHTIF6nkNkwCK7FqPJUyvNVYpPC4HrB8aTBr?=
 =?us-ascii?Q?7lTN76aHEC1iuT60F8u3jF/fiX3zGfXPM+CkrABf/ZjTAdqOe/H/TkfMj+Zk?=
 =?us-ascii?Q?iqct7z8MkZJcA35SaPDciCa6YFbu2sUxE0etV/75jj8ZWetMOBsrT3ynu5tk?=
 =?us-ascii?Q?Y+4aGIDghdf9zsIpw5anQkh9BAQFkw99OsuQyIASoxPbEkXuDhSOVEydEUx6?=
 =?us-ascii?Q?IW+TAOcFjrYDa1dQoiUcm10+IxuK77eaD0XzC4VCUOe1hE4alIV5Np0GWtVO?=
 =?us-ascii?Q?ZhnVGRd8sl8t3fVyakfBkslEN8pq+j9RxHRWu0mCQ+13xqSb2W0/VpXdYEh/?=
 =?us-ascii?Q?QHwoAJLDL3JZgt+fI7CY0phbzIoVWBtDlXNxKjj4gCjCC/TMViBCAKh1G2bo?=
 =?us-ascii?Q?G6wLWwuQkzn7yH2mVtEvnOgCuwZKXxr0jrfJKt/5eQmeMzyaRUeGGUBPe9MV?=
 =?us-ascii?Q?o6ef07ldP9aR19/4OSCn2pPLdfbLPG26k/Vhp3pv7JrzRoWKosZXAW09Euvu?=
 =?us-ascii?Q?68pfu7u5zimpYQD0lCv0baYM4cDTPenfOjk3lNKGRSQt+xvFpUEgjcmYu4vE?=
 =?us-ascii?Q?fHep3jVEv/Sl+UMawSS9l6Y8mV2WVxI1ZV59jvNgjr8pWpMpxoRPkK5Fj5RK?=
 =?us-ascii?Q?MuyoFq/2/9dvPd22/OFH7BfsrczcQHCPTfoIsqNaOZMaU1kW9TyuZghPHyfC?=
 =?us-ascii?Q?c8kH+Nv0be/seQ4PFWeoj42svU2K4BH5gfttxrdIk4XgprT1b6iN71L1Snei?=
 =?us-ascii?Q?ambIyDo08ZpMryFi7HnYT0BZKIwdATfPPUDXL27ERUN46mOYtoJBBvgZpJjN?=
 =?us-ascii?Q?VVCjICxzsf0HugDtmZOJFaE16g6SL/FcAE5RG5ngJfoEcr9u9J50UhSSuYdK?=
 =?us-ascii?Q?e4M+2cvG4mu+stm1RiFuF4jam7NEsVRgupytRk4mqGaIpO4vB9Q2p/LBn/Ey?=
 =?us-ascii?Q?Boih0nLp2AEK85WVOjeoyNMjjsL3ZMfTS4bTfhVdgjuWAR9M2+nXcKLNzhSN?=
 =?us-ascii?Q?dqhr2eHw76D/ReXT8XvhQliE6UNsWtsNSwhuuo+y81Up+CN/j3fJ5uvLOdrw?=
 =?us-ascii?Q?xeFZe5KcMneyi+Cauc6PwGOxfNVTgC4LYE2t9hoLiod1fM2WBqjKjJzvRzIh?=
 =?us-ascii?Q?DMeWAzEPfwl+Vt08uo/XuXRcpl4DRES1MM0k2FCZXmuPGknlxj2AWQEGre6Z?=
 =?us-ascii?Q?LEpFM8LtIPV3N1qzNvDOY/HcoxJy8KoYeXzcpE9ezDcgF2XZzdvwk4GUoi96?=
 =?us-ascii?Q?GXRxdSKQmIIJgs5MVkBz2hpR0eL2a6emUuhbnpPhr4SnSRf7ik5P5As9KWCN?=
 =?us-ascii?Q?4ttphkshJjVxh01v/xFy+7EQEzj7ih5QSpSPdMWRin0NL9OHfR1SY/NhqA7u?=
 =?us-ascii?Q?SJBdhdDSVB7CMwodxF74GW+jJn42XRGfo0vB5AD/7TqXCiZ0Iv9fhGcNitrP?=
 =?us-ascii?Q?HHN7i0rOPGaERNql+o/dn+JQxsPASA3lKlKOHgMG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 347669e4-a9bd-4fdd-10e5-08db60b13ab6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 01:57:31.7039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kAMJ1f72kJRjERSvdsvbVSgJA01MEgdPBlaC84sCZdLxNNDijRyUYy76DNRYCL+poIiu1Lx4SLN/BGffikydbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5563
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 25, 2023 at 08:54:15AM -0700, Sean Christopherson wrote:
> On Thu, May 25, 2023, Yan Zhao wrote:
> > On Wed, May 24, 2023 at 07:50:24AM -0700, Sean Christopherson wrote:
> > > bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_noncoherent_dma);
> > > 
> > > static inline bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm)
> > > {
> > > 	
> > > 	return __kvm_mmu_honors_guest_mtrrs(kvm, kvm_arch_has_noncoherent_dma(kvm));
> > > }
> > 
> > This should work and it centralizes the comments into one place, though I dislike
> > having to pass true as vm_has_noncoherent_dma in case of 1->0 transition. :)
> 
> Yeah, I don't love it either, but the whole 1=>0 transition is awkward.  FWIW,
> KVM doesn't strictly need to zap in that case since the guest isn't relying on
> WB for functionality, i.e. we could just skip it.
I think zap when 1=>0 transition is still useful.
E.g. if this non-coherent DMA is unassigned
(1) when CR0.CD=1 (KVM_X86_QUIRK_CD_NW_CLEARED is not enabled), or
(2) when CR0.CD=0 and MTRRs are disabled,
it's better to zap the UC ranges for better performance.

