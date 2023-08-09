Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F10775156
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 05:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjHIDZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 23:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjHIDZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 23:25:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF38BB;
        Tue,  8 Aug 2023 20:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691551528; x=1723087528;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ZZNuRulOgPL4sn6qfKbq7GQEtvqc/iXC/Ygq03ZGC0g=;
  b=L/P8X6PUJOMSWiZKPAb6QUjieA5v/+deZuT/4uAGROcPsk0KlJlGzCS8
   qGMsqAjp2CwHq/f722L7bSwVNggc/YQvhHVm9Y9Niknz7JMvzZsCB5c7F
   HSO4Z1XR3n7cA4K0RDTbCoGTfOVG3WwXeFmStXFIYaLbgqF2zcRnsYYSg
   yAtZu2ebtWtSyKelUbn1ijoSMJOPcmeEIGyegmQ7vD1YiKoWNrAm7aIc9
   uLQhicuC7zYt56Cckqi0khhDxVXGExvcXRrjQgPdjKUodiHZ5zjaEIenr
   dfKpS2Oy0pLnP9ZFxQVa3fNhQ/H3T/S7YdhxJKE+tXiBODxawQzuXV9+X
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="401975297"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="401975297"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 20:25:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="766643012"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="766643012"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 08 Aug 2023 20:25:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 20:25:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 20:25:26 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 20:25:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITGOfHr+9pBOkd9PhUrk6C3thx7N4vcFA+0DAl0ZHHxiO55Jw8CaubA9J9k2WysKPO7LwzO/9PfbRyln5/mum7yLClqnJYQfCd0lvXL7CrT8Ij7YGXEYAg7OAQNHTPCWHsAsM4xQqZEtabv2r9u8KnPX5Z23xqeHmFQJQp/tTCwJSprBtP+YPra/wClEG0FprTcHVX+jEL5PRZd2XsfwBia/OpaRJLXC8tTDM0kxMz5Knx5DZi8UUZy2juVPIU62EciOcFJ3j2D41XTOmxRtSjPLcF51dsNL9/cRikDX9G1/Qh56UC0AsucNlvo/pF/j1c4ROfUAjPkxB5fa6eZQiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I0A8flsy57uStzc9JUL/wDHLKdvVHpJfdJdQq47SrLM=;
 b=chhmLwMR/zCCnOpeHOlSke6iJmkSh8MZwOj/vTRXL1Ylh8PoG4d0eRgyc2+0jCu1KsT054p+g347UdmIXpkg7LmfH4ntIg9vMv7B3dllpJbZalKgtjDcrYu+PoukRcA1q0OqI7nmt3lcbiADX01SL0JpmLqpaPOgzRyfv7KYDw1WaBcD0+C9Y3SBGWIzG1hbhqy7xgDhwBa71JRTqbeSElpGBPRi/AhYe+bKaM4x1IT3pQEfyj3+NiNUzl4GUnUqiWjhuKAOLKdw5SHIIIocH7dPOMoo3JepXBXdtsN5PYqssmwm1XpBNHFe0HGfO5sMFhwVrVYY2H8NOFpJshDDfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB8421.namprd11.prod.outlook.com (2603:10b6:a03:549::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.25; Wed, 9 Aug 2023 03:25:25 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.028; Wed, 9 Aug 2023
 03:25:25 +0000
Date:   Wed, 9 Aug 2023 10:58:28 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Sean Christopherson <seanjc@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <mike.kravetz@oracle.com>,
        <apopple@nvidia.com>, <rppt@kernel.org>,
        <akpm@linux-foundation.org>, <kevin.tian@intel.com>
Subject: Re: [RFC PATCH 3/3] KVM: x86/mmu: skip zap maybe-dma-pinned pages
 for NUMA migration
Message-ID: <ZNMA1BMUOfUgYn/O@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230808071329.19995-1-yan.y.zhao@intel.com>
 <20230808071702.20269-1-yan.y.zhao@intel.com>
 <ZNI14eN4bFV5eO4W@nvidia.com>
 <ZNJQf1/jzEeyKaIi@google.com>
 <ZNJSBS9w+6cS5eRM@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZNJSBS9w+6cS5eRM@nvidia.com>
X-ClientProxiedBy: SG2P153CA0045.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::14)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB8421:EE_
X-MS-Office365-Filtering-Correlation-Id: 305e6004-3ea3-49d0-c2f8-08db9888454b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rpos7kCngd1FbdTPagJYfTCyWLnMOiXbvjfttxWqD2Qe0wMlTUVjIWcSe9nhGQ1N9oAyTVoCqpjx0gpcGMxiBFC2JPr1pIytkA7p05Xv+K7nlfYLmIewxrXn79ghdgAVlIwDI8ys78Qx26LHHMeXwGch9SLvaZdU/3vXgoXOEaoQwQMPLfxO1cuAKv6eMI0JSRle8BUHoUu6qeKDbVQXhjn3S4LFgNAYSUKec1l5RR6NGfT7H6uFTPk8QbnbEKcXQHjsKQ4fQQSX/6r0EfeHIHtxqHala/gSg/7GjZoNN4VnJhCMYnI4OlQXAceLKVCFWA5SozQAUQniY40ahSPClx3czUcfpCWCWMMEdyiG9QxpBXV32vsEagZ4tPWqieL9MNdoE6OWEGI90gOTt/arXUxLuQEfHuweflQKUNh9gaSQWESqLm8kJZZQw/9Oxuxo0GTGaBmscrISqbiDqswpZGt7OUcFofdZn8A5Ylt3gbDuXL5xq46q4LZQA3xBY0MviS5FAMNrLQ+IxVZL50CQHDjE0NxNl3/VcumKqY0YNvT+jQtHYr6Ej6bVK6pk+BZq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199021)(1800799006)(186006)(86362001)(6486002)(26005)(82960400001)(6512007)(478600001)(107886003)(6506007)(54906003)(41300700001)(6916009)(3450700001)(5660300002)(316002)(4326008)(8676002)(66556008)(38100700002)(66476007)(66946007)(2906002)(8936002)(7416002)(4744005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DkDhLK+TpT5xwAXpcrvter1TAbBlULvs98rSY1ZRPJQlxC0pKkoYsmlPfC7U?=
 =?us-ascii?Q?xMujRQFrculbNJeoEM23EJRpP0CTWmWlb/YnpC/zcFggd7PUuUlNLy9YKOZJ?=
 =?us-ascii?Q?r2otGJIcsf5+j8ynK7sno5wByU22eddknC+LMQfIqfqM2AWox+0VkqmJTzJj?=
 =?us-ascii?Q?vrxNJwIL6jZc0sCEmVcbPBxcBu0I3IaSlsoOSj048CyNYnLc7WLm1e4D/7iR?=
 =?us-ascii?Q?V7xEcCv/mGb9MiFmNk01Pipo+qdYL8XDNJ8D2ZuDqUpr9SKwr5C81+4kNYI9?=
 =?us-ascii?Q?6UAd0acXoDYoOYEcEbBxS1vvZmakzRumvLwmiEHkMpFcbmKjTVEnU+sXtgty?=
 =?us-ascii?Q?xGtWgb+aU++blHjD4BHe+/+qfChWCPd7xfi6a0OXepnG67qfUtZkCpQFSRkc?=
 =?us-ascii?Q?OE1QBp5vPzkEYWzXUuh13EItgDtgfd/NJGOkbWW/L7mm114tMPQWvweP6zO8?=
 =?us-ascii?Q?m6QJ5NLGyCsrBZB2WFgqxqs+5Ham3xmKwX6t0JvdhQYUVzsQA7m9+y3p8++E?=
 =?us-ascii?Q?UOMw8ijytyXG3ssqo0i9nFLNQINeK1d+BlKTVhKru10mdWRHifk7oT3TMpiJ?=
 =?us-ascii?Q?SUYmaUpUoFXVDHVh7iDoAsp1Z6PkhpQKOOvXxjOMzNKBWFwxPuEi84ZeDrWi?=
 =?us-ascii?Q?yinzubV3bhJ6+1PC0Br8x6L12QhjJMcmJafP57KHBT/stK7pGWkhIM0j7ILq?=
 =?us-ascii?Q?CJVfUOT13ps/Qg4FuM2O9sCx5nKmeV+1qypLZlxOiQjhdhiLjxdSoL/LFYZJ?=
 =?us-ascii?Q?E1rnz5LzS5vt8jpPIH7aOvBxrzeW9+lWVsd2PI3yC8dKdmONcrSLX/pVgyrN?=
 =?us-ascii?Q?ZT0ZDqMecx5faSC6Yo/us7FYc4yfD/coTXpVwmxJGmAQHQIgzBE6FHibpCoJ?=
 =?us-ascii?Q?EQ8N/be6N2T8iUYSuFVgJ99vbfAV+4FP1Kll86k3XkKbYBG+7J7Qfh+0AbAA?=
 =?us-ascii?Q?ACDZNMAvqpWmsU31JVJovbD2iqIs6/nClO8NvHk3UOGbDnOjASiuUJc2xrqa?=
 =?us-ascii?Q?NdkNRLdz5ibbBnYTw42CsGbHCbRRVA1rWcOhLReSqiS22H/wGyb/8UesmTS7?=
 =?us-ascii?Q?vVZzKPpno5sanG0QelxArhUTjj5BzemKHwa/PTqznDcS3vePNCb/3bNl9Zwn?=
 =?us-ascii?Q?yYUUb5C1xD3iZUxDRXn1RO406Gan/hFgnFGRNnzwi/DvtcFl0KZeHgbAZpJf?=
 =?us-ascii?Q?OSURFMmcAqPai0ajLVci7wP0Fr4MS4Ecxs9+LCmjH5rlJKUAduefPz72snul?=
 =?us-ascii?Q?yZHHdS+rgu8SPHk2TG/W03JtmEV+V+4PoLxqn50c/VzhhE9YRRDtccvHeSyE?=
 =?us-ascii?Q?xYgrFiwQIt3daNZlczeggapJfV5bTD7mtd3nH1Sw+gudcxrUySD6o7f8NjbS?=
 =?us-ascii?Q?eaAT6YiY47YyIgYqiGb1PdOm7bLZTrIhmSxJU7YYC5+pGaXOSz7vkTqT6sEd?=
 =?us-ascii?Q?uiHTaVyCoCALzCkzp0sQIoZYUNQITTEWGDoThdHwNwv3Svtbsk3ZR5jQUIv3?=
 =?us-ascii?Q?ep1ZK+vLdPdcKFyGu15AFyTbBFh46dbP5FzHN0B0rbBWuiTljV0sla0D6pYk?=
 =?us-ascii?Q?D1IAofxOXM0H1wgPeDOfKpCMtJ7139Eqhyp59RSg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 305e6004-3ea3-49d0-c2f8-08db9888454b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 03:25:25.0064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1NHba8+boVlA7FRtSwq9Lih4TB+hQ+JQNa/6HHOXb0uI4m9qmXENi5pJbC72JZtdV1IxZ+ixyM9RIqn2LSLYQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8421
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 08, 2023 at 11:32:37AM -0300, Jason Gunthorpe wrote:
.... 
> > This really needs to be fixed in the primary MMU and not require any direct
> > involvement from secondary MMUs, e.g. the mmu_notifier invalidation itself needs
> > to be skipped.
> 
> This likely has the same issue you just described, we don't know if it
> can be skipped until we iterate over the PTEs and by then it is too
> late to invoke the notifier. Maybe some kind of abort and restart
The problem is that KVM currently performs the zap in handler of .invalidate_range_start(),
so before abort in mm, KVM has done the zap in secondary MMU.

Or, could we move the zap in KVM side to handler of .invalidate_range_end() only for
MMU_NOTIFY_PROTECTION_VMA and MMU_NOTIFIER_RANGE_NUMA?

Then, in mm side, we could do the abort and update the range to contain only successful
subrange .invalidate_range_end().

Is that acceptable?

> scheme could work?
> 
