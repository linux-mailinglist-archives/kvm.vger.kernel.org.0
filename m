Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAC77779FF
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 15:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbjHJN7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 09:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbjHJN7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 09:59:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDA4212B;
        Thu, 10 Aug 2023 06:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691675940; x=1723211940;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9U4YQni0v4fT8Pb7Hed89/n5BqbGgEtEnK5vKh+HO8o=;
  b=jGuaGFa++OXhSYePELKTXt19YZTjSH4ab2lf1Js7bmrT2KLXDbNf1ZzM
   P1LkrXiufpimrZNgGUla4oPOOc5rRzwEiQQRgfArZYGeyXJCF/SDGj/zk
   1m6BaspR1BW8zO4r63h7xiUjZobFY5+/oyvL0uAlVQMImxb12RjJIg1aW
   5GeKewoHZFX59PWLngM5hNnR3iw4EM0akee1joRAp/iKt4c+mVhaerKtz
   QVr/mt7KmdgQhyyfouiRQ/B2BuC83GzwUBAsYqfslrGkVI2LBzkXn6X7z
   YZRvutRcEZAJuQNzVXkRH2WTyRZAhBzQgNfOusdOLe5unAmJBpU93+zch
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="370314280"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="370314280"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 06:59:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="906077131"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="906077131"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 10 Aug 2023 06:58:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 06:58:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 10 Aug 2023 06:58:59 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 10 Aug 2023 06:58:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6rj9xnYFmTMf9v8Cv7uM/7mgqfgeozJF/B77cL4DC7OrMF7c5b3zfLJWf4iMTq7DDK7vco1iXiQ2OuO4logv3Fh3sM/pDqbrw8JKcAd7igl+apybRJUF/VU2JYvVe77Cu1bDKUuJQMPtaVpMANbaDLhySonpqhx/UogWKktrlVWVnU+NLXYTMgTFtm/Y2dvmuP4zej0a9dL/7WQZ01ORM7K+QGKREip4H9MGwYkaM80k1UCbc3C0Z+//ftTBl57IwmjhTWN3tcJSMckvRJ4pv2rW/1MOsLzxIJ2ixjVfNH8Pj4+OH4e3Cqn/lF8U7zd/5JImzvewXrLSxlnLAoEmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FyHsmSrNoxItNB2thEDOgcfJlDO7/pk5eCOM3QRoTrk=;
 b=X0mLWFdFyx09EJZJThZOMPJN3e28Z5ffBE9JrcOx7WWQ1RNseixJ8UYCRIYYEpG9hkAMPHg3xqtvDKoOXk89YXLavOiXzvjsPjihviVhXKoXltFTaoFkMezK+2GxCqfzmr7T4Xvlw6jwAucGJfKjnccFHBMLM0eqRKTDOh3nTP/bxzubq/x13XafD+JknSlQ2T5YadKL8+X4Fm+4n/7ZAu4fELDYFB3U9CpYY1bS/asqHBjdywA+tmF4XPlygr/5Vamvlr0DFKcJWsvHz4LmsmlfhfEHGtL6sFaU9qVfewACJzwbS/vFqbxa0P021TiNQ+7dWnbD3MT12LWaTGzLPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SA1PR11MB6822.namprd11.prod.outlook.com (2603:10b6:806:29f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 13:58:56 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b%3]) with mapi id 15.20.6652.026; Thu, 10 Aug 2023
 13:58:56 +0000
Date:   Thu, 10 Aug 2023 21:58:43 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <mike.kravetz@oracle.com>, <apopple@nvidia.com>, <jgg@nvidia.com>,
        <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <kevin.tian@intel.com>, <david@redhat.com>
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in
 a VM
Message-ID: <ZNTtExiPZx4b180d@chao-email>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230810085636.25914-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: SI1PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::18) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SA1PR11MB6822:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d0b7d74-922d-48cc-e011-08db99a9f049
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OhrKjaRu4iJoL3U3Z+5qr1HZW4hn1dmz9yxA3bqrGcGvznDJ3BfN0xU4lSh76faRZef1P9p27Y4X0yEJMaRwHmW0CumDZelpCAEvdqCIdH+yWbabMcxs+gW7qVV6yodkklZp3s8Ggw3150TNyqkzUTQQoiPeE1SR5/1CBBLK0OTJ+fsDS11I6AuEa9tAbNiofQzbXBQPIjU3qU2qD2ZkzDkVm7cYfTnsG+naMuj8pR1qKQBjdliL5XynuyoZNAmC+q/vctBXurl6dvTvJySJgZfIwNQRolZH3piB/uUOBsmZZJ6YSPfXmC0d96KZhGsrg1nra2ilB/h+d6zs65FfBVYm+9fgZ5jdsyVQa8lkTh6Qd+R2zNmOqQMFTOw+zO2nNFmVOBa7agvBHZsDl/jyyNgbFuPpzTYVwl1JDn4glSphmDva5i9suQgChs4FYdzflo+kjiMeXIe4U8INMPASKKO8s9kXUYPtIMWoPFdEckN03OhJCjqqDzbOXR0IqRletWvE3kM8riKxTfYu6qtqDm0yNgLEQrYuwRYVsRi2ru4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(366004)(39860400002)(136003)(346002)(396003)(186006)(451199021)(1800799006)(86362001)(5660300002)(38100700002)(6636002)(4326008)(66476007)(66556008)(66946007)(7416002)(44832011)(6862004)(8676002)(83380400001)(41300700001)(8936002)(478600001)(316002)(2906002)(82960400001)(6666004)(6486002)(6512007)(9686003)(33716001)(26005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pCJf86msKYrlTsEzeSXh8QXQ1Dv8ZNbjj2lAyyx58d4ILZ9Z915VaJ5rvkyn?=
 =?us-ascii?Q?IuEObGF7OTwT4F8PA89Q8Alu3QZpjsjYKcGfkUcGo/6AM5oDb80bTjB5XYDZ?=
 =?us-ascii?Q?pYwn7nGqlNT9SYx2spC2qYcCZDh/3HC0OYpl9fiA740ZS0Zcqn5n5NVwUT19?=
 =?us-ascii?Q?/GjemKXwjfTYkzK/j8jP7iSIaow6V0kXHdJbC6Mi9fhyvIS3mz4xMeTH8zI7?=
 =?us-ascii?Q?Z5R2Z2cple78O9dgYgF46JrniYdNT4RK1NPDesHt4rdAsNx294bYKCjk+69b?=
 =?us-ascii?Q?+E9lrAts2PeDOrS4dyD/XjA5XYhBSqM2mYagTrA41k3y++WA+blwvubrCXoH?=
 =?us-ascii?Q?s7eiN59atlQZ7XH4Yer+lkWBz+3+A8FNqmqNaE90wdCxfzOWh8di/iPY2lA3?=
 =?us-ascii?Q?Vpw2ieVIjsiY9mqkegaC4O4Y5PXHg6caK/rFjr6LmssWfabDkqXmm28nwAHm?=
 =?us-ascii?Q?/uwe55L+nPvPi7l0SKEmdfXxFgbHf6EcQ3TO3cfjzvWNFiN2XC8y042ntRUr?=
 =?us-ascii?Q?1zdOPHI2pkNde2Ym8/TWf3pRUpfRR1A6o6ABSWARkMG/PtBP1izkXZaxlg42?=
 =?us-ascii?Q?BCtHpzKdo6aEBtutf54eQ8qck/jqIb+/qUgFsZO4q5v6Nbta0dW7jfxioBwm?=
 =?us-ascii?Q?fXEfq2mhSj22IgTcj7JrItmd5/gM8Rn6Mcdnkm7Y3TLFXDr6C8KCf8dTNl5q?=
 =?us-ascii?Q?36OTqojrgGUJfPauPwo1MP+i/dpMsi20V57CvibfWj3KIUEza7BWTK9dueEf?=
 =?us-ascii?Q?EXf74i41SjWLW5yha4EAMcZxzhPYNwGN7e1KyRd3bZ/y1XTFRbRYbOCqtFM5?=
 =?us-ascii?Q?waBHE+r0JgD09Gy0dV79N+pqli7Mko8FaSx0WuWoIS9/xpCaaNaaBQ6nGLyl?=
 =?us-ascii?Q?fX5hZCfA0doTFdoMNgMS8O/hvk5BeG3FiSVG8l1lti3wxBbL0emTXHxwdmZo?=
 =?us-ascii?Q?VCQoW0kmQQn30AoOckpZ1dRCGVWGt82Af09hGgOZIQBrIn8LOWpTRZ/ZBMLa?=
 =?us-ascii?Q?NYFdMYbbK6CYaAca8AzEt/hNYXg9NwDI2xg0MEDhSJ3gQ2E94YSfAkzM/GEf?=
 =?us-ascii?Q?8f5xgnhK6b8bseN7uRVEXugEUsB08RETx7KfXp4Co05EWAYf3XlmFwEtB/4o?=
 =?us-ascii?Q?P0z+bYxc6buWAaXw3M6iieaC4MxqUav1CJyJKMVysH0IsSA8+MzTILATN3z2?=
 =?us-ascii?Q?Nsfj9gCz+Isbg/BdGzc5+4I10vHIMBfMvyba6fr+RYCa2e/PACLQNauFN9mx?=
 =?us-ascii?Q?Nq54GvDftp6N/ZsGAlL9AguMF3TS4jsPf0Y6DlCT9SV0bjAOaHKgg2HPJAI1?=
 =?us-ascii?Q?4eGXZvU5yUqFs//XQOl588AEJq8If09/HpRRq6aqjL6Bg8HLXYZPDLL6H6zr?=
 =?us-ascii?Q?7pbjkiUDadxnM5xDT32wbyWKkUl0I9p+2JdcqWJsRRHOiS+nIUC7K4whtCGw?=
 =?us-ascii?Q?qSysY0dyr1FRnZm84w/9rViCvyrdFN3AoTlrCQOjMxGWLnnZu5Lezv6ZPf7B?=
 =?us-ascii?Q?cCQM0NpUv64MNxo1pAuD0j5VCygJXxvOBkcBua3puTxNpr0CtVGA0dZssb+b?=
 =?us-ascii?Q?jL6RtiV1KzWqu7Exb05FH2z7qlIUmT844b1uswD3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d0b7d74-922d-48cc-e011-08db99a9f049
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2023 13:58:56.4430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A2Jzobd7vFJQ9mZmsuCDou4trXiCBJ2lV5OIOLGz77R9DILXVDRE9PjMLnQ74iqCxkZZpWOgpCyxkvh+hppSHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6822
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023 at 04:56:36PM +0800, Yan Zhao wrote:
>This is an RFC series trying to fix the issue of unnecessary NUMA
>protection and TLB-shootdowns found in VMs with assigned devices or VFIO
>mediated devices during NUMA balance.
>
>For VMs with assigned devices or VFIO mediated devices, all or part of
>guest memory are pinned for long-term.
>
>Auto NUMA balancing will periodically selects VMAs of a process and change
>protections to PROT_NONE even though some or all pages in the selected
>ranges are long-term pinned for DMAs, which is true for VMs with assigned
>devices or VFIO mediated devices.
>
>Though this will not cause real problem because NUMA migration will
>ultimately reject migration of those kind of pages and restore those
>PROT_NONE PTEs, it causes KVM's secondary MMU to be zapped periodically
>with equal SPTEs finally faulted back, wasting CPU cycles and generating
>unnecessary TLB-shootdowns.

In my understanding, NUMA balancing also moves tasks closer to the memory
they are accessing. Can this still work with this series applied?

>
>This series first introduces a new flag MMU_NOTIFIER_RANGE_NUMA in patch 1
>to work with mmu notifier event type MMU_NOTIFY_PROTECTION_VMA, so that
>the subscriber (e.g.KVM) of the mmu notifier can know that an invalidation
>event is sent for NUMA migration purpose in specific.
>
>Patch 2 skips setting PROT_NONE to long-term pinned pages in the primary
>MMU to avoid NUMA protection introduced page faults and restoration of old
>huge PMDs/PTEs in primary MMU.
>
>Patch 3 introduces a new mmu notifier callback .numa_protect(), which
>will be called in patch 4 when a page is ensured to be PROT_NONE protected.
>
>Then in patch 5, KVM can recognize a .invalidate_range_start() notification
>is for NUMA balancing specific and do not do the page unmap in secondary
>MMU until .numa_protect() comes.
>
>
>Changelog:
>RFC v1 --> v2:
>1. added patch 3-4 to introduce a new callback .numa_protect()
>2. Rather than have KVM duplicate logic to check if a page is pinned for
>long-term, let KVM depend on the new callback .numa_protect() to do the
>page unmap in secondary MMU for NUMA migration purpose.
>
>RFC v1:
>https://lore.kernel.org/all/20230808071329.19995-1-yan.y.zhao@intel.com/ 
>
>Yan Zhao (5):
>  mm/mmu_notifier: introduce a new mmu notifier flag
>    MMU_NOTIFIER_RANGE_NUMA
>  mm: don't set PROT_NONE to maybe-dma-pinned pages for NUMA-migrate
>    purpose
>  mm/mmu_notifier: introduce a new callback .numa_protect
>  mm/autonuma: call .numa_protect() when page is protected for NUMA
>    migrate
>  KVM: Unmap pages only when it's indeed protected for NUMA migration
>
> include/linux/mmu_notifier.h | 16 ++++++++++++++++
> mm/huge_memory.c             |  6 ++++++
> mm/mmu_notifier.c            | 18 ++++++++++++++++++
> mm/mprotect.c                | 10 +++++++++-
> virt/kvm/kvm_main.c          | 25 ++++++++++++++++++++++---
> 5 files changed, 71 insertions(+), 4 deletions(-)
>
>-- 
>2.17.1
>
