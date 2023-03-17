Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D026BE174
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 07:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjCQGog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 02:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCQGoe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 02:44:34 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3C591B59;
        Thu, 16 Mar 2023 23:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679035461; x=1710571461;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=1XYrJ21QaZftsg9AQUbZFeQe3zR8ZQdOvFw+VP4gVZc=;
  b=mpazrycdolynt3H0djOD3Q63ESEtxNX9feDj4k65WXoNotnJU0IU9k7u
   yTZti0qQblh9SmxTD9ckVpEtfjzBpowihvtCIhrYadNLD7g75Yv+t7DiW
   NJDHjtK7tBCaQ6zsFqRChaQRx7VDUFyRfzojqWG9xoDLrECZoO1WqWo5O
   DDoPwe/udGxOQlzCy9wkfnjmmPeWBYkdjtIce1Wzk3XvxjXM5cKjTFHS3
   sMmgJ+pdMa5cgWy07xPrGBmHjc13h/kf3R60GtZ0qZxhD/C3yLkAHS6/k
   oNGZsNdjtHzfPGtVcNFOFxv37109Qjja12pq9ghthqOLlQHnFVHyouwtU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="339735808"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="339735808"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 23:44:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="710401374"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="710401374"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 16 Mar 2023 23:44:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 23:44:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 23:44:17 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 23:44:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W85izYBspRJRlWU0Hd5Oc5Z9gpbECrb8Xv8g+O+fpcNLecqo0btT0RllZ8zkpCERkKbcQtD2AYVtlIQ2vZbwdmzlTvhymU7wTHdxtHd8mSHkRNRHQehTlndwZxo4MeyBNgUBb3Mbq3vYx5tgKco9lyDlaRJPrtGiGj54Z8DhcIUVRR231x5nyPIA6J3TqXN+66Ax3OnhdJwM3rEjQh6GOj5euO5xQlzr8QGBaeAgFow1OPoTJSH7i9BdRF5L/On748i6gtn/ilPDHSTk8yXlPn/3F2dUxyAkvtXgu+BIo1BEkoWZG6C+2Z/rXJPHwFPEgcl5P4Y4hl/QL7mRLKv46Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=41WtfN08KuQ+5nDvKbbsAonQE20eQYG9OO8qjS6EsmU=;
 b=JJ7p7x6m5kiHCY7LM4y147Hm9rGyAvuGuXhzhKDZMK9Y9RILKSIym+/jKtu8wAlPqg9Dla9b2NG496bV4pmeSceT/l4OET3XOspERoN0QS2orC4+Tixe4AWD8Km3qoYMBhD8wTSoDwJKBNkngDLfryy/R1P/1oypGTZ+cK1ICCP7oRYTn6ondevOgVPh3ENS260cvW4+gla7WCrtpIolMWpM8iSBGSp1ko+TYKTAeWi0RyW/HB2jmJR5pYgRgemPSszB/K5E7ANDohdUNjYBrSu6scBZWDFKk7V8gL4ims1rPd/SVizHMFjLER3k8ClC1PlXN4oofLYRloyzX0nbpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6759.namprd11.prod.outlook.com (2603:10b6:806:25e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Fri, 17 Mar
 2023 06:44:14 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 06:44:14 +0000
Date:   Fri, 17 Mar 2023 14:19:36 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 08/27] drm/i915/gvt: Use an "unsigned long" to iterate
 over memslot gfns
Message-ID: <ZBQGeJiNosyes2DM@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-9-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-9-seanjc@google.com>
X-ClientProxiedBy: SG2PR03CA0097.apcprd03.prod.outlook.com
 (2603:1096:4:7c::25) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6759:EE_
X-MS-Office365-Filtering-Correlation-Id: b758b9bd-e9e9-40ad-b6ca-08db26b305a7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5scGmx3V2rTYNMhjRJDdcHhTAOrxOZt14eOc1Fk2hsi5cwLf74MWJSFb7cEmoRNsEQc+r6bj9CV6uy0/Tz0xXRnzSROvVZwD6u8vFOH1aZAmXhxRNE7dDC7xlghU1/CHoiQ4Mk5/F7m/8P7ujHmqZC0F3tRC8TYhEex9ChdPTFpqWA7KDdj0SLCCZem/exA7hymuXPgOKMfU35f9czP1Q2vTzFsv87pfmzBPrSbbiConLrrnb58hDuw7UtxEK/5dZjBouXuaDyI+qM1WGO0VszRKEwmjDtcPWFF9FodhQNRHLQUrJf+GjfVRpb7npLvEIXeZG8GYRFzsdkJpPQQmFDkqmErj+ewhrCf7LgTSmTTE67lUBJISfrLwiRsqJCIA7NgaRcVv7ZMIbzuO08VEvLmXZa04mohwn5BeKHpYuJmiY17HPj0/k8eGyx+eZBCgFbaXIuU6lx7ASpdgVsx9U58xJ+z3E7irDT7bzPxHw44tXaMckG9Up0U/VPLukJOZpZ2vV3D6l+xJmCxgzctVkhFiTumrNA+uYjUp4DzbdLWDsWW6ItiOt/JSjjwMndcCnRkhseFLTg8kCbHyKJ1cOwB6+9X6JsgSUT7EwF90mJ+Ggge3SEFwBNBIChEVpk1M0RX9Fp+jnnO4+C/2Dr9ttw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(346002)(366004)(396003)(136003)(451199018)(316002)(54906003)(5660300002)(2906002)(478600001)(6486002)(8676002)(8936002)(66476007)(66946007)(66556008)(4326008)(41300700001)(6916009)(3450700001)(6512007)(86362001)(82960400001)(6506007)(26005)(83380400001)(186003)(38100700002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d4kDCdlJOEFgaBpoN7hJUKDD9BvqZoDcwneJIjmBv3a7C79IAhzQ4Riv9ULP?=
 =?us-ascii?Q?VXgujwQBkaeCBo7FSb9ELpdAsyOzZPUnTiIPx8vv0JGr6uSwcPChb/rJR5Pl?=
 =?us-ascii?Q?IWTKr2zGsS+HC3NzBzi+ROfKtdDC9eZj4O71D+EedCqaG5cWI3FGMytgysv5?=
 =?us-ascii?Q?bs6JqesfC7YB2nPUv34+aFPoBV775a8V07yY6sUW6oMELrvmiajNAZPsmq00?=
 =?us-ascii?Q?6zKfQZip1WM+G+J8bSvcktq3TdWw1T5iqJAjlSXkmiBESrioR5cHlJkQUVkB?=
 =?us-ascii?Q?N4eAT1I0d9GoDVTRc36TEQlsr4yIBNhFjzlTcdGOMPP0Nw4s8kY+t81JLWhM?=
 =?us-ascii?Q?x/RcDgC+ae+dl+6godbB8/XcjdLk6old1zkbqcKdU78ksBiXfsWA3NYHR9XQ?=
 =?us-ascii?Q?B4yIoAXrQGDjbQk1kj377m95JN9ieL4s2AdF96HyuVsOSbXqXFsRAycVHgWl?=
 =?us-ascii?Q?Wc57M3C4Hy/H1rAkawiQsSa2zWTM6uC14a8WYXaAhjyuZBQSDFvsA/OOGAr3?=
 =?us-ascii?Q?ftLoRTH+GlFZqNeCfIsCDGPccfnADRHCIr8NxzphfSt6dpIGU2argIiIVAgN?=
 =?us-ascii?Q?t7iZzXCq+s4djk9cFigvdl472XTd31Qro9Vt55cJfyBpkBimOdH3JO7bzUjb?=
 =?us-ascii?Q?ihSsHqqnChqgcN2ckBkmZTDaremDshRMEYpIuMoR8zz4W55u/VmTeWS+Iosz?=
 =?us-ascii?Q?T1RDZ9lh0tCOBjYRLhZfZEiA28lOU0qz81stqipX+nA3cksmN3A7tDqZPEjL?=
 =?us-ascii?Q?FC12N0uQQkW2G/UwsM9oLeU21OZk0mxswYWbWU7l4dq67qKb4XKTPbnZB22k?=
 =?us-ascii?Q?qsg00TJo4VwGoG/rLmlIlcUO0ERmCQyzUfnpF0oXgLv+v4PG9HWRMT8AS+hq?=
 =?us-ascii?Q?8fGPYGnxW7NoQiLedpZWscEYIWakfxECLRvqEmDzPED6+0yl3gl8q7yWqpZw?=
 =?us-ascii?Q?c06KdDBvJVtEgpNhyZpP4eC/P+xjPCSKrhnGPWSPEvbXtHPr+rbU4fdQi945?=
 =?us-ascii?Q?2wCRfbH6TXj7/Gn+7Divi3QubrMMcCmr4X+fuuhTbhm98JdMzD32An/xq6IT?=
 =?us-ascii?Q?DdVZ+l7g7V99coKAJ6Ak1q8aiZXQTW8Z2K9HxodOMY5+P5KsBqka8tLMIfms?=
 =?us-ascii?Q?PMrGhw3jsoYqB6SkZ33MixRegwzQleNFARlNQ9r/X1mcr2Pcbd4T9+2Iq3Pq?=
 =?us-ascii?Q?3Lo+42xMTxWfmnPAHzc0mi0rNg0IdeS5NctLMAv6M4evaA974vJS3zrZZA8Z?=
 =?us-ascii?Q?tBVv7LUSuLvA7hvSh7nMHqnsuh0mZ49tYxMFffzRW7PHBEBtz2H0MIx296YS?=
 =?us-ascii?Q?xEefSXpxYaUy50RkGmr1zP/ToCXTjQXkm/h7UraBfMGDq+pxnYBUHhMTmr/X?=
 =?us-ascii?Q?SCY654ZQlpFJ5SmXi4Agt82MUmUkA61qXTwARCasUq5bWpN4tN0chJEMQrUy?=
 =?us-ascii?Q?yDqfFZZ9MIr3/Ai0Gn80KT/wCojZZj5vOokuIyP7fAA/wiKc8bkCRgK/TiG/?=
 =?us-ascii?Q?+TNPmipuncc0t5KXcbApPmSjbN4D3qTHlmD7jm8/6DDBd4/tpLqr2JlGHbtK?=
 =?us-ascii?Q?YeQXn+aO7uZ6bAZZhQmalY0KxRDxHWjStg6vuWMW0VcFPWqyJOCsHol45Ric?=
 =?us-ascii?Q?OA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b758b9bd-e9e9-40ad-b6ca-08db26b305a7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 06:44:14.0510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJdFSRXzJ1yhXt6TLCfixcFeTG5GpoNNR+m2SjELed4bVRRFa1LWDDCm5guSydRJ58+hUHCVuD/RvYRxsIp5Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6759
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

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Fri, Mar 10, 2023 at 04:22:39PM -0800, Sean Christopherson wrote:
> Use an "unsigned long" instead of an "int" when iterating over the gfns
> in a memslot.  The number of pages in the memslot is tracked as an
> "unsigned long", e.g. KVMGT could theoretically break if a KVM memslot
> larger than 16TiB were deleted (2^32 * 4KiB).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 90997cc385b4..68be66395598 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1634,7 +1634,7 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
>  		struct kvm_memory_slot *slot,
>  		struct kvm_page_track_notifier_node *node)
>  {
> -	int i;
> +	unsigned long i;
>  	gfn_t gfn;
>  	struct intel_vgpu *info =
>  		container_of(node, struct intel_vgpu, track_node);
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
