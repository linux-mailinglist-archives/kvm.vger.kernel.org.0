Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A48D75332A
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235405AbjGNH1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235238AbjGNH1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:27:09 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150F1C0;
        Fri, 14 Jul 2023 00:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689319627; x=1720855627;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=RGYEifSwaeUDByXP5rA5fVwOiR3+Q3R4yprTDj/FcBY=;
  b=BhFEW0x/qOeYXk0NVeUc7gA55zPOdo0P+Y54rRrsHClvmzXhmjngOVck
   dOxz4qTeMIKl4ZzZPkvPwMT5cgecJQjUJcGimxdcHG59314L33a5I1sHO
   PGHmaB5QZiCneD6odpSVeGFCYyLbzYHreXpqpWAyygcIsRyaGsXz1eOzW
   tvL0ix87xdRLjLwPElutacopyiAM5J+GNUuQkqlIJ8rrUZeBwU+b/ujLs
   GagyW0gbEx3kHq5KdBWV+43M0cMWR52eQKc8eI1QiNKR5w4rhn8BjZfdT
   CtlIZOk4o7w+YLmZa0asD5d9z4hTvMQwxd4KcAdeUz6pJAo5js6VtyHxf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="396223645"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="396223645"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:27:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="1052959703"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="1052959703"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 14 Jul 2023 00:27:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 14 Jul 2023 00:27:07 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 14 Jul 2023 00:27:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 14 Jul 2023 00:27:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MfTPheC+FGTLxKwD1Miwv6YPaaCQmBVRdLuKlIthOrMuWSKisShziCiW/JtqxiCzbtjBqIgs3mzv9spN82vwP7JeXQ9A8MX/8sMBc4qNmTa63/IiXVPyq9KsqDF6/1c1iQ5KeFFtFu0wrGKkBLO5ojwOuhmhQZs0fi8EZZD9VbNzdUH+B+IEklTa37hAsZwQ2Q5/ETnmPfHtSdwGXJjFw5PkgoHKy1QxsFJhquDslc5CEhrbOQ5M7gdBvHG88B3V/RROigeWuH3vCq4V2TTvN9d5H5VQuM/bnBNiOPttFrcyHMFSOa1LLHMgaUN2fpyx83fF4E6Tb7dT5ixPSxeJLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XdsUkmXrdnwcsLwK3qNdZvo4UJVJ8Z7JPe2lgKNe8hA=;
 b=TNzJw7RzWarajQ7bfi9aDWJmJqnFvDV6Rq/TQIPHLtjWZNh9PMAhvPuXu60nLYpibIx+s/o9n24iJhk6L0bhnOX47w60WYqhCeZ5OaLlXMP9fjm3nc+DbCikZClYmdVtnWKiDvkyDIGgrZ0tYaH1LUcH0OzQdoFZSDoolsG4YMVsSuHFfs/KLRPfSHN6e1ckONhhPzSTkEYTdT08JKuW3Y1jmKtZJkcRH+UzAGCGKlkfUNlHGATbwplSzJgOQDFjMazc9nwuoqnrCpTfSSMqDg9Mn6AVdHM7nFsmdg9paSIuT9MM1fAIdRhU40SMnmph4LP/8d+Ug/iFSCE8WAP94g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA2PR11MB4956.namprd11.prod.outlook.com (2603:10b6:806:112::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.27; Fri, 14 Jul
 2023 07:27:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::c7b3:8ced:860d:6fe6]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::c7b3:8ced:860d:6fe6%4]) with mapi id 15.20.6588.027; Fri, 14 Jul 2023
 07:27:04 +0000
Date:   Fri, 14 Jul 2023 15:00:23 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <chao.gao@intel.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 08/11] KVM: x86: move vmx code to get EPT memtype when
 CR0.CD=1 to x86 common code
Message-ID: <ZLDyh4eKFh4u1DU/@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023858.7503-1-yan.y.zhao@intel.com>
 <ZJy6xcIsOknHPQ9w@google.com>
 <ZJzWZEsRWOUrF7TG@yzhao56-desk.sh.intel.com>
 <ZJ3sxm6CngYC7pno@google.com>
 <ZJ6I9vEfbaSPR7Rk@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJ6I9vEfbaSPR7Rk@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SG2PR04CA0215.apcprd04.prod.outlook.com
 (2603:1096:4:187::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA2PR11MB4956:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ff90102-1c9a-4526-fff1-08db843bb881
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pryG74X/ANL0rr4IYHQDBvhLiwfeHZOW3P9ss5JENjaXrE5mxFI/tr+iCLtDmThrEMW6OwwNR/B0eZhsbeJa14LjnsRlonIjNddw3J9yitPxLFH74v8x1Cdq2ZHXsxiO//RLYhrSrm2pI4FiMItja/tOYiosyOhNuPZjvCzfNV5XDOGIFxhOY80T8LjT4dtWsfNiyTw155dgOiBr9cRrE787IM2QkPyLNzNAAD9cy6g//C3QVL+Hjhx4aIxSbGVYuzYrAPG2OSOxxc1UzhKexgDmIoFXSMKsy9RU9O9ABG1aMv57LQRSOy2DVqlk0rh2Axjlgkn96QJ9CYgfAhUnuouNR/wfu+a6fpzPxaoiukHDALZXYSZBvISjzpuo8EutOrtUuNr1h+NmyZiHeewk9omknGU9RiqfqJxmlrNttFwsIO/FeLJr6FG81ZEI+NczmevrdM3KhuGZv1zk2nWKezqpDUAoKEZeSlrv2hQIgub1+cRSrV2tudpQemcNHeliz3lM0D/DrNxIHwewLAmZ2OqBaZdwZZtknu88ibiA5lI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(366004)(346002)(136003)(451199021)(6486002)(6512007)(966005)(6666004)(186003)(83380400001)(6506007)(86362001)(38100700002)(82960400001)(26005)(66476007)(66946007)(66556008)(41300700001)(2906002)(316002)(3450700001)(5660300002)(8676002)(8936002)(110136005)(478600001)(66899021);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p14QCr0clkNr+6id0Z+e9M22Bh4HcXxgYD8nuTwEgGA8gPqrlD+vw/U0nFd7?=
 =?us-ascii?Q?466x6LaH2x3jAM8okHqlDaOxoEk/+Hy4NwulyrvQLmnuydMjCwXiqJftEqGT?=
 =?us-ascii?Q?+fCjIhQKvd77RIZFuevJXVWh7rl+eYJBu1rVeFtaRrCby0suVzAsfHVLDKQI?=
 =?us-ascii?Q?Lstb2ftkrm/j53juADf/c+N1cF2yrV9jEHQ/8ttHrOFaFYS/2LtG1mj0uhpX?=
 =?us-ascii?Q?uKhmXkTQ6FvYtakr7OO2nPXKscTbUQrFKgNOWkk77sa/9lwTiS7+7UcwTE7U?=
 =?us-ascii?Q?8tczIfoY/Iarx733CjzloksqDEI+BiaPe6YKoaDYXj/RzE9xnRUfwfavgwy4?=
 =?us-ascii?Q?e4y4D4DoMAJh/DQIlO5hyGZ/y1oRQmcPSCyjOyeB7Y7d5+T2My3JwBayBRTT?=
 =?us-ascii?Q?sKzn+vYJhUx6Bzr7ha8fxcEYUVnGNKeNMvOWyvCzHzXStL8xrEXu+6M/l6uL?=
 =?us-ascii?Q?ll8xGqmjCSYykrXnG0N2CUmVRBBLNByoo2iN9NDtixaqOgNtghevlOxRSL9f?=
 =?us-ascii?Q?sw16bXfvFoMO4+KYu7ywVwy6QzSXIC5WGViT+Mnk753Wv259f7NUaxyNmV1r?=
 =?us-ascii?Q?suwzjRHG+WvULtaNsXurzsfq0jjUcuiRGiAGJ1JATTgzye+hJqqG5Kcm4c+J?=
 =?us-ascii?Q?ReL/CbMI2PkGzRNXhzIx4UHOwdHgyah0EMMkyT+vrlZLozhDt3D3Y9dqKVaz?=
 =?us-ascii?Q?NkY1GnyuIADzngxxHzMN6EIMqlAHLOHYJWKie6ALn51e5m6kF1YSftOnltno?=
 =?us-ascii?Q?p/CT7CqyKxjSGFW2k64znssqbqr5864v6c/J1xCNNQnXuuwl0785W4TsMTH7?=
 =?us-ascii?Q?81Mf7mtdXR1LTTD7o5Rwepy/zf65GciHUwWwfJ3jlzB1uJBjWBJbBvTtlrbD?=
 =?us-ascii?Q?FGq1v9jZegWJjWLddX2MgIdVA0Ak8uj8QAQbh8qCxP1o66OVR6R64bDISQ4L?=
 =?us-ascii?Q?WmPewLUPtk2PniFyWwD8WOhUWHP7bz2zrUZmKxmibuL/S5sPINfgTqwIbI2d?=
 =?us-ascii?Q?OvK1YxJbpWiksiv8Lt+q2z7nn9+eArE7P0rTLZoZPBsiuRuSVeVHZ3oTFZGw?=
 =?us-ascii?Q?3tq5B2qJZpnzuvRzmDjI7lL/sI+4I+DjNnUeGq/8J0Ua5TIHLk8y8uTn0Ki4?=
 =?us-ascii?Q?Tni/ILvQEIPuTC5pWSzMW1M6KO1yhs4DXbw3Cx/vBhKJdxyp9h+SIRUXj8Fu?=
 =?us-ascii?Q?Hrk1aTwoBlzN+U+djxT632ExLqzCE982t9POwyugl3sm6M7fRoH1ogsz482V?=
 =?us-ascii?Q?irMb4iHLmh9UUyMPEAHBX+jDVrEt2JpaRTEfv1vCBwsrwmZ8zPBS9mGvxJSp?=
 =?us-ascii?Q?FWzHiuAa3a8UW0v8bJ/uqJHfTrLvkxCod4osnyvec7UAnXfiZQfe6K4DSPOn?=
 =?us-ascii?Q?OjKnJpNcW80onHeAsQy3jOruqvmP90iruARPvHe+HP406D62GOfGpQIG1gha?=
 =?us-ascii?Q?b5/2ECxnrokkgoGk1dcVgrMUX1xp4NvawOsRBrxnpxKMQF8ZKglisWHIF8fi?=
 =?us-ascii?Q?d9MtGSYQiD0rnXUz2nbSWZmY6J4GLYCZC6XXswt2mp6iqqpSBJR6fkcnt2xS?=
 =?us-ascii?Q?zlWS30W0Wl3u+zKmkfly85O+MljndUhJiEAauE3g?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ff90102-1c9a-4526-fff1-08db843bb881
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 07:27:03.9248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gpZfnKRkuiHnxxvI4/HFsyeZYa6a+6fm7XLJAIPhbG/8fEDsIPN4fnGhQlAlpmzeiXO33JefPI2EZmEwGNWN4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4956
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 03:49:10PM +0800, Yan Zhao wrote:
> On Thu, Jun 29, 2023 at 01:42:46PM -0700, Sean Christopherson wrote:
> > On Thu, Jun 29, 2023, Yan Zhao wrote:
> > > On Wed, Jun 28, 2023 at 03:57:09PM -0700, Sean Christopherson wrote:
> > > > On Fri, Jun 16, 2023, Yan Zhao wrote:
> ...
> > > > > +void kvm_mtrr_get_cd_memory_type(struct kvm_vcpu *vcpu, u8 *type, bool *ipat)
> > > > 
> > > > Hmm, I'm not convinced that this logic is subtle enough to warrant a common
> > > I added this patch because the memtype to use under CR0.CD=1 is determined by
> > > vmx specific code (i.e. vmx.c), while mtrr.c is a common code for x86.
> > > 
> > > I don't know if it's good to assume what vmx.c will return as in below open code. 
> > > (e.g. if someone added IPAT bit for CR0.CD=1 under the quirk, and forgot
> > > to update the code here, we actually need to zap everything rather than
> > > zap only non-WB ranges).
> > > 
> > > That's why I want to introduce a helper and let vmx.c call into it.
> > > (sorry, I didn't write a good commit message to explain the real intent).
> > 
> > No need to apologize, I fully understood the intent.  I'm just not convinced that
> > the risk of us screwing up this particular case is worth the extra layers of crud
> > that are necessary to let VMX and MTRRs share the core logic.
> > 
> > Absent emulating CR0.CD=1 with UC, setting IPAT is complete nonsense when KVM is
> > honoring the guest memtype.
> Yes, I'm just paranoid :)
> 
> > 
> > I 100% agree that splitting the logic is less than ideal, but providing a common
> > helper feels forced and IMO yields significantly less readable code.  And exporting
What about renaming it to kvm_honors_guest_mtrrs_get_cd_memtype()?
Then it's only needed to be called when guest mtrrs are honored and provides a
kind of enforcement. So that if there're other x86 participants (besides VMX/SVM)
who want to honor guest mtrr, the same memtype is used with CR0.CD=1.
(I know there might never be such kind of participants, or you may want to
update the code until they appear)

I tried in this way in v4 here
https://lore.kernel.org/all/20230714065356.20620-1-yan.y.zhao@intel.com/.
Feel free to ask me to drop it if you still don't like it :)

> > kvm_mtrr_get_cd_memory_type() only adds to the confusion because calling it on
> > SVM, which can't fully ignore gPAT, is also nonsensical.
> Ok. I get your concern now. You are right.
> Looks the easiest way now is to add some comments in VMM to caution that
> changes in memtype when noncoherent DMA present and CR0.CD=1 may lead to
> update of code for GFN zap.
> Or, do you think it's worth adding a new callback in kvm_x86_ops, e.g.
> static_call_cond(kvm_x86_get_cd_mt_honor_guest_mtrr)()?
