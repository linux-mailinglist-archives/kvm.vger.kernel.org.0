Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DF9637003
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 02:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiKXBuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 20:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiKXBuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 20:50:52 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2972419C36;
        Wed, 23 Nov 2022 17:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669254652; x=1700790652;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=khs1J83DYYBYzGzxKgiyvBNTfK2tHcVOGrJyym8fB38=;
  b=EFKhHUMNBwAYSZlTohMYB3Dr0EDn6gBll8lbYyglAyas27tcYd3XA/C4
   7cnivyhnMK2NgZPoJOI2BgxXXzdDP3aJ7N6DSAdnso569omGsLdYGrrzb
   tyYoZskBt6aVJRLZE0LRROkFMQLBbnli8WHs+a43xy8KqgvWVUXzPh2lh
   apKystSaYUA5jgeD1dKHsk+YFMIa/1QzQUYZthDT5ZLhDW2E95zdxIC7/
   dFTSiZzZH+7tJwBNAvHm46vOH/hiBy0DbH871ZcqbUJ9mR9GoremJzGDH
   UTF1d7YqmOjdcvNFDCIJm/TtnEwmangNX7xYs5xug7fB63fOThbFuCxSV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="314229307"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="314229307"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 17:50:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="592728592"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="592728592"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 23 Nov 2022 17:50:50 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 23 Nov 2022 17:50:50 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 17:50:50 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 17:50:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fPuNxKHho5OzJWUmKB2O2FivRMy4o2NS66NJoavmShPUttV1r15/E7UQR21GDmOYxun9NNVwCrWYTtQ8fy8DFC2OXXOMAEKraWOKD3Qbml6JAclNdGn3yqq6sQNvS/3MzkFhz8uzHPHOHmtdQaUWkcQGjRO4QVEzka7RXlgFzsi1WzY7rBwk9Lu9YVayCj1qe/UbeDjhzeOO2MZcucYEfduBnQYLy0hR1M326S7mjybpyef6qOYAsQqTZK+i/vVdtX633dTQTn0Q+SuTr1r28vCMY9dL7KW5JwD1FR8wSxmQUW0XSDjUJCb+dNxD9wqmyrX6/AESOLVCPnfyxVICBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0Do35m8Rb9zuwN95Nbl6zYC83jf0hesjs5SOLqiMcc=;
 b=N+9djsgwb4HFHwEBffYFADPfu/Nnz0ij8AzFN0FXtbU2E650ibAKdMuZsi5YYRtlbz60BTdxqOQVFV48lnh6ymriRlOoUEsJcmfcKZH0lfG88vagtnFM4l+jDzc1TDI3hUFJgt82OEDrhg2OHKghgZVvmYDw6xRP/e/mYIo6b6t2hIOuP76zltNzgoVgZP9C8ly2tJxZ4thMaxGiaGYtuDYS0fSS6fnaPExXvuN3Jjhfu8WbVq9dWSOIRpH1LGlLomdBkuu6xARerxIFn+PBiS/tX1XgYz82M8voeu3cS+XTrh5mz3HCkcbjqxe4ji+nsumjOHTsATqKwZnbps4NjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SJ0PR11MB5117.namprd11.prod.outlook.com
 (2603:10b6:a03:2d0::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Thu, 24 Nov
 2022 01:50:42 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.017; Thu, 24 Nov 2022
 01:50:42 +0000
Date:   Wed, 23 Nov 2022 17:50:37 -0800
From:   Dan Williams <dan.j.williams@intel.com>
To:     Kai Huang <kai.huang@intel.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
CC:     <linux-mm@kvack.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <dave.hansen@intel.com>, <dan.j.williams@intel.com>,
        <rafael.j.wysocki@intel.com>, <kirill.shutemov@linux.intel.com>,
        <ying.huang@intel.com>, <reinette.chatre@intel.com>,
        <len.brown@intel.com>, <tony.luck@intel.com>,
        <peterz@infradead.org>, <ak@linux.intel.com>,
        <isaku.yamahata@intel.com>, <chao.gao@intel.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <bagasdotme@gmail.com>, <sagis@google.com>, <imammedo@redhat.com>,
        <kai.huang@intel.com>
Subject: RE: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Message-ID: <637ecded7b0f9_160eb329418@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1668988357.git.kai.huang@intel.com>
 <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
X-ClientProxiedBy: SJ0PR13CA0220.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::15) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SJ0PR11MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 5df3f14d-d8ae-4980-0491-08dacdbe4aa2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2R0EXGJ87DYkmVFX1gcGaq5SW4F1f+q5DpTJJ8UQt5nGJbaJ7VvvdfO4K6eIltTnFmNDjOVt1JXVmKlWMPfFHraObbhTTdua5XB4t8qcToCsaTOq4PTurGLJGlIPBulJW3mnDgBlKcNmG9cY0fY/XFWWyQklNWOCzG4tmYHzSwunhN1yT/E+hdEI0yBIIZKcFQRXx2T5tSimQ0YgJOHiyx7Sf77ZXlWpwotzhH7k/kTb0vQd4x8KXDkipDUlSQfyW3twSctP+8yeTRS+faFu1FF76MPiAxMQmbNif8jiBpUyRpHaqc+8L2UZ1HdTIx2CDfEI07H0u6C/sazNd31N9UUdBeLLzjqpsQnJP6UwH0mhLbfUQO94EgJNIC0TeVEWt9zf2NaRFBuzY9IAHd8W3hL82/crZAyL2KaWnxvRxGfedEEQ6on3pVdQQ41vxKoC6LpUb9DucPn2XAZcVLjJYBo/PR75ePUs9JynlD5ksL5q9ktN5/Vxc7t9JvDc/FgnXgwvX7HLW+RSt+ctWOIpTmKLO6u2VIyg1+EhwC9y3NtB25EKLLT8udc4TuzkUJUDZmzgtLH9H+LDh/6UijvpgDcCVZwq9Sbz7X/88v4tZ8ewCy+km7o/Tkru4DqfM7KIQSfMsDs6PDdxxSbobmP4fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199015)(66476007)(478600001)(38100700002)(82960400001)(86362001)(41300700001)(6486002)(7416002)(8676002)(8936002)(5660300002)(316002)(186003)(4326008)(66946007)(66556008)(6512007)(83380400001)(9686003)(6666004)(6506007)(26005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9hBAVOUxtxmDKCaqvxpqu9Zb6YNLCyeTYaYAJwDWcjd39QlwZX3XpSSdvdD0?=
 =?us-ascii?Q?eEuV3WeSg7CaZtrVuCIiRI89+mKnPKWKNESBq4SkMP7KPsXzHhWjV4mBTsqm?=
 =?us-ascii?Q?mW50RshGnigl7vEwhSd0EFe0isQ1MSCunpV0vdEQQeT1ODnLub0sZ7Fiaiyn?=
 =?us-ascii?Q?ydsmBUhog9H1fsijN6axiMO3ujqi7lPQl92tSo0cB6DlzSNOpgnErDjUmTgx?=
 =?us-ascii?Q?nQu5C8cC+SPGOwc8kByTyKtPkOOp5hAA6kviocw9ydDCXo1OhQXsiDMU5DEL?=
 =?us-ascii?Q?9Ft1B1dsSSTtRBdX9nLCQABKe9HpC1D4GDWHPkuB8re8OUWPZLsuGK5z8vmf?=
 =?us-ascii?Q?hlpy8dROYSXmVJo8z8F506WUjSPT7jtINNf68WsFJ9fyVETEvH57iPi9wqr9?=
 =?us-ascii?Q?TGhKctsTdR9sBAldyvM9FtD0LbwmMxANVGli7zeQrTVtqlttI6QWZrfxTaCK?=
 =?us-ascii?Q?ZdaTs7sVoOS1N+8y1+HTFu4biJBVdTTO3/kZQTVDyCOVwo2ISCzPsU6EtaPA?=
 =?us-ascii?Q?piYLcyWuIYt6ZN8SblJ8gSoGIeClzZAoWJhDNLdnpf5a/ZDBK2wuDjXtqAEw?=
 =?us-ascii?Q?scnk4bCSsNjLC1WWuiJYp+5gtRNDwE+mxHkLQyba31NHO4qv2HmLO9koKOmt?=
 =?us-ascii?Q?P2ykvVTRXCMN/q6h7h91FlEqhWC6Y6beY7uMDReMff5I32A+3cdCTrm8vI6p?=
 =?us-ascii?Q?kkZKm6Ithfi8zDTFqC+ypksvrjaoxhL+yELTkTkxalxQg4KbcRqwgDWK1dIF?=
 =?us-ascii?Q?kH273F5dJQHkVnguXvps7zJrLPBgmCZ+LQjbh9VjOJ3xLRyd92CTUhJFZNVK?=
 =?us-ascii?Q?u8CPBwQN2i2XX1ZCvt0JSpkojbMRWmiABMK137D4EpKep/kMwqeDUfaq4hM1?=
 =?us-ascii?Q?en3o2wXpUZ6JGp78w4gzKO4HM8br87ZzGa/hK0Gm5ILT5cIm5SoxevIYlU/p?=
 =?us-ascii?Q?BDSNnvr1jN1GuSISXTvW7LXQS8dd+t8UXoqKxE3+735pDiG1rE6MBszJdlfJ?=
 =?us-ascii?Q?RqyimeCTTzZOyAkIxxgqKjm6v4R8EsI5zlGHtf7bMSSYaOLkAe2YFSDi5bKr?=
 =?us-ascii?Q?Vnn9Aoe+pncfRvf/RJVg7bfixfleE8x7YrZXataIc2/qtGbpEE/hla2Gm9O8?=
 =?us-ascii?Q?ps5iIjDaySqiJZ3gG0yqfKYmKic6r5btWjetiAjGKSQeEsIPpKCwnhT/X1bW?=
 =?us-ascii?Q?nTHCvien+Cpq2Qeg7dN0mwUyGsQnfKra/Oi9HjhULY6WfQkJ2Rx7cNRvxBJA?=
 =?us-ascii?Q?r09cldB2QErqUf0h71KzJqL/a2v2iQYYU1fmnYIChUm8shqCOzhDn/XSbk3p?=
 =?us-ascii?Q?ltofST93s9L1s34M/bBni1Ho6CoklAQEe0gHO7GnjAFdOwGw7QAyQbtPkAr0?=
 =?us-ascii?Q?JzE0JWq+IktTv/kBiI1L4TMbJ+iro7hb7zsrO9j3BhRpyy4K0sRTB/XZfaGr?=
 =?us-ascii?Q?wSo58/TxxZLtdIby6PaLEFib1mgrJLkm+nMRXo9MUWgvD0U33VwZjwQclUj5?=
 =?us-ascii?Q?1sThb6rd6yBjpfkcEPOPZiDcMTDgqV/X2qjJ3qweYXbngvXPcCo9AKjyBaUa?=
 =?us-ascii?Q?HQUf8viYzaGlLwPU3wbmsN40s8XmLbw+ESYnxA01k/uyzN0I3KdxpHf3hrDH?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df3f14d-d8ae-4980-0491-08dacdbe4aa2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 01:50:42.0332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POMvYKRQKR58aa3FUobqeXbSLS3URxNIrwFMaY7FWLfEJmtZVBKE5OMYO9xWMW1AnkKH5m0IQblF32xFCcuPH/3XwjzCTsNWNDcAd6Yrul0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5117
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kai Huang wrote:
> TDX reports a list of "Convertible Memory Region" (CMR) to indicate all
> memory regions that can possibly be used by the TDX module, but they are
> not automatically usable to the TDX module.  As a step of initializing
> the TDX module, the kernel needs to choose a list of memory regions (out
> from convertible memory regions) that the TDX module can use and pass
> those regions to the TDX module.  Once this is done, those "TDX-usable"
> memory regions are fixed during module's lifetime.  No more TDX-usable
> memory can be added to the TDX module after that.
> 
> The initial support of TDX guests will only allocate TDX guest memory
> from the global page allocator.  To keep things simple, this initial
> implementation simply guarantees all pages in the page allocator are TDX
> memory.  To achieve this, use all system memory in the core-mm at the
> time of initializing the TDX module as TDX memory, and at the meantime,
> refuse to add any non-TDX-memory in the memory hotplug.
> 
> Specifically, walk through all memory regions managed by memblock and
> add them to a global list of "TDX-usable" memory regions, which is a
> fixed list after the module initialization (or empty if initialization
> fails).  To reject non-TDX-memory in memory hotplug, add an additional
> check in arch_add_memory() to check whether the new region is covered by
> any region in the "TDX-usable" memory region list.
> 
> Note this requires all memory regions in memblock are TDX convertible
> memory when initializing the TDX module.  This is true in practice if no
> new memory has been hot-added before initializing the TDX module, since
> in practice all boot-time present DIMM is TDX convertible memory.  If
> any new memory has been hot-added, then initializing the TDX module will
> fail due to that memory region is not covered by CMR.
> 
> This can be enhanced in the future, i.e. by allowing adding non-TDX
> memory to a separate NUMA node.  In this case, the "TDX-capable" nodes
> and the "non-TDX-capable" nodes can co-exist, but the kernel/userspace
> needs to guarantee memory pages for TDX guests are always allocated from
> the "TDX-capable" nodes.
> 
> Note TDX assumes convertible memory is always physically present during
> machine's runtime.  A non-buggy BIOS should never support hot-removal of
> any convertible memory.  This implementation doesn't handle ACPI memory
> removal but depends on the BIOS to behave correctly.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v6 -> v7:
>  - Changed to use all system memory in memblock at the time of
>    initializing the TDX module as TDX memory
>  - Added memory hotplug support
> 
> ---
>  arch/x86/Kconfig            |   1 +
>  arch/x86/include/asm/tdx.h  |   3 +
>  arch/x86/mm/init_64.c       |  10 ++
>  arch/x86/virt/vmx/tdx/tdx.c | 183 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 197 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index dd333b46fafb..b36129183035 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1959,6 +1959,7 @@ config INTEL_TDX_HOST
>  	depends on X86_64
>  	depends on KVM_INTEL
>  	depends on X86_X2APIC
> +	select ARCH_KEEP_MEMBLOCK
>  	help
>  	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
>  	  host and certain physical attacks.  This option enables necessary TDX
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index d688228f3151..71169ecefabf 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -111,9 +111,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
>  #ifdef CONFIG_INTEL_TDX_HOST
>  bool platform_tdx_enabled(void);
>  int tdx_enable(void);
> +bool tdx_cc_memory_compatible(unsigned long start_pfn, unsigned long end_pfn);
>  #else	/* !CONFIG_INTEL_TDX_HOST */
>  static inline bool platform_tdx_enabled(void) { return false; }
>  static inline int tdx_enable(void)  { return -ENODEV; }
> +static inline bool tdx_cc_memory_compatible(unsigned long start_pfn,
> +		unsigned long end_pfn) { return true; }
>  #endif	/* CONFIG_INTEL_TDX_HOST */
>  
>  #endif /* !__ASSEMBLY__ */
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 3f040c6e5d13..900341333d7e 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -55,6 +55,7 @@
>  #include <asm/uv/uv.h>
>  #include <asm/setup.h>
>  #include <asm/ftrace.h>
> +#include <asm/tdx.h>
>  
>  #include "mm_internal.h"
>  
> @@ -968,6 +969,15 @@ int arch_add_memory(int nid, u64 start, u64 size,
>  	unsigned long start_pfn = start >> PAGE_SHIFT;
>  	unsigned long nr_pages = size >> PAGE_SHIFT;
>  
> +	/*
> +	 * For now if TDX is enabled, all pages in the page allocator
> +	 * must be TDX memory, which is a fixed set of memory regions
> +	 * that are passed to the TDX module.  Reject the new region
> +	 * if it is not TDX memory to guarantee above is true.
> +	 */
> +	if (!tdx_cc_memory_compatible(start_pfn, start_pfn + nr_pages))
> +		return -EINVAL;

arch_add_memory() does not add memory to the page allocator.  For
example, memremap_pages() uses arch_add_memory() and explicitly does not
release the memory to the page allocator. This check belongs in
add_memory_resource() to prevent new memory that violates TDX from being
onlined. Hopefully there is also an option to disable TDX from the
kernel boot command line to recover memory-hotplug without needing to
boot into the BIOS to toggle TDX.
