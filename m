Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F85736242
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 05:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjFTDo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 23:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjFTDov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 23:44:51 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD3310C2;
        Mon, 19 Jun 2023 20:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687232689; x=1718768689;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=XV6abOOE/jHDhnlh/QrKhH+cSuQyAgCNDBT1ZK6ZTRQ=;
  b=cd9yb+6GA0YKAe8OHWvDGyf18Fbj5zWX7OnhrCc3vgWDJO6s9p8XeFth
   dmK40fIQoJvMtZE7XUWLDoCG6srnzmdneShcopWJ6RdB5bfbJYqImirzs
   auN+U/PzuVHkfmqn2AEjXcNktmj1Eceb2Io+lpp12A/ZUUSCe/WD/zEFM
   qRnxSvrljCulBxlUoya/VqX39aZJlMMjuKc6N0xR8bo/Mly5uxGHcSLGY
   X7zmOFPV/Yu5WkzW7NiH5T/wd+TVCPoZ5El4qlGc4CpZbnpLrP+B0Pvzf
   eedBs+QNBuGuNY/4b4HSGggkY4LCsJyI5hqVjmEH2AA5JB3mzl7rdEKIr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="446133626"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="446133626"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 20:44:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="691281869"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="691281869"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 19 Jun 2023 20:44:47 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 20:44:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 20:44:47 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 20:44:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcEgQU23/R1OFfy7QjsD/NIKjoj7BgtXfKWf5Fg1q99PwUSbteMgBpxb1IeYGbDnYuul4TH0qe+/4WBCg+EsZlxhqYuIQchLHm4gwBCENxYXiAAKFsBUnQRMc4mx1coaE96NLFnbtXI5j3OQUR/jklDQQFLXbF1oXz9kicxBECTbvmT2PaFDMgDyaxEsWd4dgn6xdQO6hhwyPYSxHj9s5y/xJPYbMrqOLWnMTANKR17EEcXHzrJweGL4f1zOE1RxVHJ0y0GIid8oLY1ZNemaUqM8wbHbegKwIdp88MVv2V1uNaS7G7q54pVYWBwEd8cfJT3HsAKmL7ta74q6q23O7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xWh8teQ0cXxQwB19bppVVlJa7kIfMwwGjNjaHg2kNQM=;
 b=Fd0f8ajMxBsUkBAlwJ4eabwm/Pm3wuAPAzfprDC0sRVsXLID59kyJEnPTiUM/Fk+zrDAhxFOgU4Ky/VZ11NZCo4uKkdaKPzYPCYrLmrX7pc/NrjnEJILRu04sTihHL34tKJE0Zvp6C8JlSgqpLvkHv/uDjTwy11NejfLCydLEl30b60bOSDbYbfRp22qwfuWHNVT6j+S8raXM79g26aIuW1pdefQ33rowC3JDwVMyJ7r5OphgDYKYrG7Zh1Wx99DoMRVpWsJTBT3DOoY6GxZQ3zxHzdg1Aa3am/k3u2V6yUueiLypa44aMYt23C1qcHRIhSDO/y5xFpwfdAzqsPhEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7409.namprd11.prod.outlook.com (2603:10b6:8:153::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.29; Tue, 20 Jun 2023 03:44:44 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6%7]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 03:44:44 +0000
Date:   Tue, 20 Jun 2023 11:19:27 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Chao Gao <chao.gao@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 07/11] KVM: VMX: drop IPAT in memtype when CD=1 for
 KVM_X86_QUIRK_CD_NW_CLEARED
Message-ID: <ZJEav5QpdQwDG7go@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023815.7439-1-yan.y.zhao@intel.com>
 <ZJESMaG5Thb5LWtt@chao-email>
 <ZJEQNTvfwOSsSzrf@yzhao56-desk.sh.intel.com>
 <ZJEeUywBg5q/bSYi@chao-email>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJEeUywBg5q/bSYi@chao-email>
X-ClientProxiedBy: SI2P153CA0031.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::7)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7409:EE_
X-MS-Office365-Filtering-Correlation-Id: 619324f6-cc3c-483a-5a41-08db7140afcf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WhGgkk9ODc1C3Uw1UMQlz0VaPDptXsHuPl+bHvye1912vbRYi/DmGVWpkGmNw22tTlvCU9mLV9FwOGJCwXnzt6EBiRJju+Hz7bSvVcJ++sh59kypnii2yRnLbDePGt8/o+uhrY3oV0mJOpzy//bmYpsGpWU4Qwg2gocW8L4JGKUOQnLGDL9HxzPxn4rXLIBehk3au9Q2+HmX6cSH4zjpgF6XknpUxrDnQV13j11a5T2wFCwWBMo0ZXv7B0/+xlVXEaETsGzIN74obeTk8FvyY36fRVISUzAPpE1IA7w2UKUXgWNLq5zbwq8LCS1hOmjB9873sAYn09sv5HcSkvYFLpOtKcufaMZ4q60IFxIBC51nRxoqj2rq4yaqF71pRCIMR9mxQQSD64jhc4WumHMlBr1eImhCPmCk4ml3KmR7Gf1uUnCkVhpVFiDXl0u9ffantqUA8Vv9uAi4gxOo0a4rHyf4Y2af7Qj/oiOj/0/zGsG8PCFWYKlUzrmOUb0IvPXO3TZWz0LsueLwW3ouRxF9IXuq+vOEmNNLCgHQ4H+r/QfyDQN1jq5BP48jF5c67yxG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199021)(6666004)(66476007)(66556008)(66946007)(316002)(478600001)(4326008)(6636002)(86362001)(6512007)(83380400001)(26005)(186003)(6506007)(3450700001)(82960400001)(8676002)(8936002)(6862004)(5660300002)(38100700002)(41300700001)(2906002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dew2NYVcDEkLnv4gafkG5Z5AZQCIWky7hYfmlK10HhA30gB6j7+KYoabfxeu?=
 =?us-ascii?Q?a5Wwgd2yj4mBb4qwGgO6PxghuOnsc1vEmPJRBENVyCFWlKDVgetox/uB9+UI?=
 =?us-ascii?Q?BCWK71knZIMk/9rvx4Ge2zivxiKvPOiFbZrAoMYEEkQKeLzMaz+T2ojzr67J?=
 =?us-ascii?Q?Z+uSKVlgo7CGP8e/ooJV2jUJiLI2/cZBNYBhcy6bLRN6WyDcY+0hyRulIFOk?=
 =?us-ascii?Q?dzaBOFBR8/CsOEcrYX8jX6gkCdr57DckWS4Ylm3jXG7m31a+UsNM6fD3P/OV?=
 =?us-ascii?Q?3/43ks5gXomp9kcddkvqmZOafJyhfRtNoxZmJeSYazq/LrO+V6XVOLERCpoZ?=
 =?us-ascii?Q?9/qZ3BO7rlW0gpWAb5liHacUtO6W5Ee24DAJC9VlCqHy90oKyISo1lThox6b?=
 =?us-ascii?Q?abscx3CSl+fGymOevmmZTeLHLmMWaRRgJfBPnDMcsgeVXHhej0/RYkc9rOrQ?=
 =?us-ascii?Q?QyUGeFeZdluYo/MTX7k9iXb0iSw8V8/MY98WPClxeTVGRqB965Q9Hd248ZAJ?=
 =?us-ascii?Q?+NT6kXMi64PdNf0MiBevfBS0lYLkzLQyYNf3ly7zTziECSwnnRjSH5UgEo+V?=
 =?us-ascii?Q?pGM3H5tbCmVJXqtns7J7xypqEhSLYdBIDcGjAivORpP95pE5FNOybOGUWvkE?=
 =?us-ascii?Q?VRP9Ii34BplLmwo24XpL2CEbCgS4JyfVfG3UHD/RhypmHvLo88Rt+WAY367P?=
 =?us-ascii?Q?C+EG2gpUtInirRvx0JSH04MnnEMjT3O3+drbMIAjbATTceptnDcT2DWvfJDa?=
 =?us-ascii?Q?6fT0JsYyne4M7SUD9QNVhHf/2xH1mais5eDdZcaebE4A5JjJIFiY4MVy1dUv?=
 =?us-ascii?Q?yLS+8grWsZexgLegLEbddb9EDz2A9+FrqCMpxu6itCpv3e6BaiK8z/RINjPJ?=
 =?us-ascii?Q?IoiFyxyb/dxM7+oFWnQ8fR8KvT4JSaFkFQ/aINKkke5HCqJsGDWteaQzdfiu?=
 =?us-ascii?Q?NEPlutKXLfhyMeerqbKcdMcPzuM4GuLmd8cIhzAgH3K068wrtQtKKm64pbpR?=
 =?us-ascii?Q?MLZcYU8aW7UqSKBS8ZN+9kC6poTPQtTuvkXFojcpIiCVL+Kcf9RolWyh/3Je?=
 =?us-ascii?Q?BfIPJOFX6snKmPDIzuswxAEfOfy/XWx5raT1IbVT97Xw5LIGxcq6g02fLgzk?=
 =?us-ascii?Q?eRjoSRODhkPxMefwkrwNY2VqU59bjzRicxZl6vocnAmEw9R5FbQYDSQIXV/a?=
 =?us-ascii?Q?gzZL2dt4vvlRZpVvzZxRq2iW3Ahrz5v1spHS5ha4168kGNz1J9GFXDTKo5Sf?=
 =?us-ascii?Q?pItPhzrK5qqMrcxkRCi0S9jisN/4+TMtYmTnfxW64tgYI9WF5/Tv9G+SXDOG?=
 =?us-ascii?Q?/x5H+798LFao2+x80Qlef2alQR8pB7ko/PhMhth2id8XUYPviCb0/U4HqvYJ?=
 =?us-ascii?Q?QHl6hdbrskUWN/CToSVQ6JD5n/n2o6hppfd8Avh+QhYlBGxwZPoC7Nt/ps9/?=
 =?us-ascii?Q?1slBJs7NI5sY+uN/TIOrnK88s5zLqi2WqnD2iRTw4oLpmC+jvq/RahazA1Kq?=
 =?us-ascii?Q?kCh7ZqGFMU9zBYdeHp5V+AK05zaHuSt6P2+pl/LQvmfoQD3K59xYbUkYbueo?=
 =?us-ascii?Q?Zu5dA4OmUK4bpeYYEvIsxgvkfENbzePQt0R4hvEO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 619324f6-cc3c-483a-5a41-08db7140afcf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 03:44:44.5584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DJ08UBkWUZOddMw5+NXYNg1O869R+2L9TEct4RixiQaYEeJTWPQjisSR0Hds7dQtAwcgYlp6BvXs9hZfl7s6fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7409
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 20, 2023 at 11:34:43AM +0800, Chao Gao wrote:
> On Tue, Jun 20, 2023 at 10:34:29AM +0800, Yan Zhao wrote:
> >On Tue, Jun 20, 2023 at 10:42:57AM +0800, Chao Gao wrote:
> >> On Fri, Jun 16, 2023 at 10:38:15AM +0800, Yan Zhao wrote:
> >> >For KVM_X86_QUIRK_CD_NW_CLEARED, remove the ignore PAT bit in EPT memory
> >> >types when cache is disabled and non-coherent DMA are present.
> >> >
> >> >With the quirk KVM_X86_QUIRK_CD_NW_CLEARED, WB + IPAT are returned as the
> >> >EPT memory type when guest cache is disabled before this patch.
> >> >Removing the IPAT bit in this patch will allow effective memory type to
> >> >honor PAT values as well, which will make the effective memory type
> >> 
> >> Given guest sets CR0.CD, what's the point of honoring (guest) PAT? e.g.,
> >> which guests can benefit from this change?
> >This patch is actually a preparation for later patch 10 to implement
> >fine-grained zap.
> >If when CR0.CD=1 the EPT type is WB + IPAT, and
> >when CR0.CD=0 + mtrr enabled, EPT type is WB or UC or ..., which are
> >without IPAT, then we have to always zap all EPT entries.
> 
> OK. The goal is to reduce the cost of toggling CR0.CD. The key is if KVM sets
> the IPAT, then when CR0.CD is cleared by guest, KVM has to zap _all_ EPT entries
> at least to clear IPAT.
> 
> Can kvm honor guest MTRRs as well when CR0.CD=1 && with the quirk? then later
> clearing CR0.CD needn't zap _any_ EPT entry. But the optimization is exactly the
> one removed in patch 6. Maybe I miss something important.
I replied it in another mail.
