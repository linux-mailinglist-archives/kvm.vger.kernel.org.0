Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0617925D2
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236512AbjIEQE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244711AbjIEB1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 21:27:48 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC79CC6
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 18:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693877264; x=1725413264;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Ab7uXWQB7SHBNtzPg6zZK0SrWBM3sdS98DuBtIwAHQk=;
  b=JiDGXXMheHtQ05R/Jox4FG78DR2sjiksN0q2xZ1jQN4WEitd9B75rzl8
   8SRWhnSDL6xW+StZrN69ZzgnRh0DdnAoJK6je8OE4LRIxGq63N9Mu2835
   qYuBE6ebb2OiXznS63/Rr2DkUhXEjinnBiJe5tVnpiWnVMFhGGFRBZLsF
   zFZmQ0zpYNnOKnHNKcEGiVDz5Oc5v8kIzn7yBFLzaBYs1ISsr9qjLhir2
   dQ08qaSE4wxZMWiKV5+elFoioZueP+HmObWoZDyerxiVmgTFJPNo+q8Pk
   uacQN4npYYBo4x7RrmHaqvaL9oVywX99S8eHIPBhde1iXSmAvMwYDX/s9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10823"; a="379397049"
X-IronPort-AV: E=Sophos;i="6.02,227,1688454000"; 
   d="scan'208";a="379397049"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 18:27:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10823"; a="776013741"
X-IronPort-AV: E=Sophos;i="6.02,227,1688454000"; 
   d="scan'208";a="776013741"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2023 18:27:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 18:27:42 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 4 Sep 2023 18:27:42 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 4 Sep 2023 18:27:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8q5ezU9mBbSnxwrVmLL+Oenz6YTQIMYhNNCx7EpjKrGuuyh+8GdplPerXiRq97YWTC5Jznx8zlXawmz+8ldY5LCabqGnuHv6ZBdJFcrXx3jYxswyqF0YLURE4uliSTErg+Hw8hZieiZukEL2QNkzww3AZOkhLBzWo8poUqw1d4DhxjyomZV1kMBeb1NKC/0Bc61dWjio0cfYcvxfnbdfrhPkrGb4Ni9eAXoVcJFdkf3PEgZHcNHK3l2dP2BFYEWRexCcUtzTC4n5mWML8QtylEo/OEGAc5YYW17AKCUMGe+YQ7rV+s7JVfcSu9loRY31Roh086uOWgpY5axeMBNZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9gIaq8rzCKe772DVf5DamCJj4lx3NIwID5UYV5KGbN0=;
 b=gobsXGzeHtuGEkW3IEphz/m1nTfWd5CQ+rbi6dgkoUBgilxJzNK5OKaqxlqs0whFZ0FKNqweRoUMy8vxKQyoAvWF/q1ZD+i4VFJSjZUpjRfUk9TmuTWvdJa9+lEPFyGQfCIQ0hG4TdXdZ1Dhbm2dRkaZEzZ6PGS+plhwdWU74eRQg/rkg6yyPWA4+THsI0A8Kfc4utj853fInkgtzFX4l92abiO4I/h+KmqFKcdNzWkrk40vM8yHXrFvrR0LMq0/zFJrUUgCAP3Xw2w8x5GY8G8RBy20hNs1L9Sp9XDDWHoANxDo3Dm1UmurI5pkpQcms5IUrJ2aTuulQGeAAHFwIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB5923.namprd11.prod.outlook.com (2603:10b6:806:23a::17)
 by BL1PR11MB5432.namprd11.prod.outlook.com (2603:10b6:208:319::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32; Tue, 5 Sep
 2023 01:27:39 +0000
Received: from SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::1770:c2a5:d27f:76ce]) by SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::1770:c2a5:d27f:76ce%3]) with mapi id 15.20.6699.027; Tue, 5 Sep 2023
 01:27:39 +0000
Date:   Tue, 5 Sep 2023 09:47:01 +0000
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Dmytro Maluka <dmy@semihalf.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "android-kvm@google.com" <android-kvm@google.com>,
        Dmitry Torokhov <dtor@chromium.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Keir Fraser <keirf@google.com>
Subject: Re: [RFC PATCH part-5 00/22] VMX emulation
Message-ID: <ZPb5FR+AdInTGQvy@jiechen-ubuntu-dev>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
 <ZA9WM3xA6Qu5Q43K@google.com>
 <ZBCg6Ql1/hdclfDd@jiechen-ubuntu-dev>
 <75a6b0b3-156b-9648-582b-27a9aaf92ef1@semihalf.com>
 <SA1PR11MB59230DB019B11C89C334F8F2BF51A@SA1PR11MB5923.namprd11.prod.outlook.com>
 <309da807-2fdb-69ea-3b1b-ff36fc1d67ec@semihalf.com>
 <ZIjInENnK5/L/Jsd@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZIjInENnK5/L/Jsd@google.com>
X-ClientProxiedBy: SI2PR01CA0021.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::19) To SA1PR11MB5923.namprd11.prod.outlook.com
 (2603:10b6:806:23a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB5923:EE_|BL1PR11MB5432:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cca9166-c253-4440-0d90-08dbadaf4ab9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QENAqoHZ1K45gcFhy2sby+MzzupDKng1ahqiBUjA0ja8AkxvAIy1a4NTVmlWuwpfxahPeDWZY3cNvkSLl8+vJWv8HvIXPMsG7mszkjHkHX4wV0hOnKUtDP76nBeDccz6gF8P9geOS7zIVwbeBOALaMVaoebiduiy4Jnnd5O1sInHsFxEjoVfNc9e3EY77BZ7wgCJGitFfSf116f0bpWfejiWSgsKm13tlHFYbPPVwkjnNSvonEmRtVp8XC1lZQETfX3DH+0X9mkc0Harb3GaDDhjDZlsW8q/k2MXEXV7sm2oB8UYSFFAibz7nkdkghc0mZavOYHsgfrJOov4eGyg/SCVU9fWD0+pfgA+TENRYLb0w1Z0/DMVqCo9DeuvehQQJ/+9ZScMu3LVszl11Kpap/QDV2ke5ugHh+vtcKmvrbwEWznfZX30KLgqLzQUuIxnu1gPG825sKvnpDuab5KMgE0TGym+WpR50fR0Q/Gafso6OQEoyaNbWa1e6PtnJh2+OC4Vzq0StkiDI2o/fkzrbn+lmbQxx0Uz0kuqdo9k0P+4xdMmF2dH/fzW4Rdf02+uuSMRy77sirIvI+OjVH3y981Un4U3lEvn9IOjuBNDWO4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5923.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(396003)(366004)(376002)(346002)(39860400002)(136003)(186009)(1800799009)(451199024)(26005)(6506007)(6486002)(9686003)(6512007)(66899024)(38100700002)(86362001)(82960400001)(33716001)(83380400001)(966005)(41300700001)(8936002)(316002)(4326008)(54906003)(66476007)(6916009)(66556008)(5660300002)(66946007)(8676002)(2906002)(6666004)(478600001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r2YAF7h5GFYgzH5kFXab34XvVdbuOlNGU+F0dlceq/UNNG65qUcXU9GD7p8w?=
 =?us-ascii?Q?F7n/wpX54daEY23g3qM8b+d0cDH1wvAalPhPk3H+hXbIzre3UG8eSpJBhRPQ?=
 =?us-ascii?Q?Sj6g7CdkeGFKarx89ciuuhqWZDRMRLg86Uky7Ydb9VQKNP31yxyE61b/VBx/?=
 =?us-ascii?Q?+2FTlaVGD/IC9s5Y1Mq9CNqitFX5q10+rB5Sze2pU8JufBXtzySgbD+12K5Z?=
 =?us-ascii?Q?bX2YPulTm/INHIRmEt+DaFhK1w1ESaRgCUR58iLl37WLNP8wWSG36Eim6VF+?=
 =?us-ascii?Q?STMgR7q8GHubnhF/2djxaTdz9YhR7on0DyigyKyhfzPO1rYcut9n6bAdx7B/?=
 =?us-ascii?Q?R1d7kuvktsyNfYGs70yTSeqNRet7/X7HrT6b0CDZ5ddQlVyioABKSxQo5+Do?=
 =?us-ascii?Q?PRDyetw8gSjsa+MKgSw9sH0UIevvR1jIA2nnHfl6dbIsBEAt8h965FiL1WyH?=
 =?us-ascii?Q?1sQlQXSulNL3VRacvbes45sc9YeQQzbrxWYY089yfyMzd+5p6GGi+opuHXxR?=
 =?us-ascii?Q?zuAcylLJg/avRdePSyMoDQVcc5uJCKG55ywNW0Ja4rkRwHcltAzCWMhYUKab?=
 =?us-ascii?Q?eFR8F9rUhfZGExs6X5NiowWQ2e9l/LStos+vNBcTf4IDKL7JDLC4V7fdDHhT?=
 =?us-ascii?Q?RZa6FA8Z2oK5JPQkCG3gy+UVmrTVihHz7P3tUeEAiS+cEfO3n9v964a5VY6f?=
 =?us-ascii?Q?dfctItbD86HHPoWJI9XK/auVLV0f+h3jcNfGUBBVxkqtwAbYjwg+xCFV1Dt5?=
 =?us-ascii?Q?5UfNcNb3l5npHdN/OYf+YMuXzcgsZqqgW+T2Z+/KwTluTRDb/jH8rUzUpkff?=
 =?us-ascii?Q?s68FP9tUTImv/TiDjniGcBy/E9oMKrZUEHMdPjX/fKifOLJgnPpvnZT7L16b?=
 =?us-ascii?Q?yDuOzPazjLIDtEXorEmMIfrdXznwvET+YdKPqu41GaNTwsAqUyahWJGFa+oj?=
 =?us-ascii?Q?ALvdbm8M/qja21mkPg7kspQ8JO0KjfBUZ/yBnZi6sTdxKfx7DZy4c6gtDUjU?=
 =?us-ascii?Q?BFnRq4TS1MHp/3uzNnu5lOgwRbGrJyxW1TGE2ZBD2g4mBsfsqLTQGksUYQ2h?=
 =?us-ascii?Q?aO8rkdPDep0JGq4tfDsBuA+LWwS+MWTuWbUTR0cd34n4tYWp/fQKhm6bLfAE?=
 =?us-ascii?Q?JSXe8trV3rOLZHH7jYFOUqawByZEFcYwOn/GdwrLPVttkvotzDxDWzFIDeNo?=
 =?us-ascii?Q?HyJ4SN4WdtzQrrNliiySef2sv5mq1n8IZYjPhHlpISEYTZQt/DXd35AkhzcU?=
 =?us-ascii?Q?GioCixWbdyjfvmeKmvD+QlRqfaQD6vgNRbIIhvCbbzH/UcfjugxEgtLDIREP?=
 =?us-ascii?Q?l7IOlL9c5UaZYtEzXWZFggs24Lf7wGAUWtp4EQWbu6surkLX2o8V10W6ARIO?=
 =?us-ascii?Q?KAhEEBvLJHtx6e4hM2Czr+rJ2KbIxNqaOFZihFbh+ZS4XSWAlOs4coW4Ggi5?=
 =?us-ascii?Q?2OO5iGGpfn2CTvAFV8nc7oOW31LdZ57CclnCR3vPfL83Jz0IwTg9QQd8QE40?=
 =?us-ascii?Q?dc2B65p3npiyDbaaJQyJam8ysdxUA84R901/nx+roiSatbIVKmXPsTiD9lP2?=
 =?us-ascii?Q?xHgDc/pbN/kVghqCUihPNqtbhqzKJfOLWEBq5evJ9QMZS31nQ56XSadzw3MA?=
 =?us-ascii?Q?kw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cca9166-c253-4440-0d90-08dbadaf4ab9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5923.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 01:27:39.0176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d1Lkv6S845Da07/eJPAX2VLyq6RPOl3QCRdq+n/6ncI8KPPwB2DHij2KmLgTPsgPrQuc7cvnX2vc7CLDgvujfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5432
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 13, 2023 at 12:50:52PM -0700, Sean Christopherson wrote:
> Maybe?  A paravirt paging scheme could do whatever it wanted.  The APIs could be
> designed in such a way that L1 never needs to explicitly request a TLB flush,
> e.g. if the contract is that changes must always become immediately visible to L2.
> 
> And TLB flushing is but one small aspect of page table shadowing.  With PV paging,
> L1 wouldn't need to manage hardware-defined page tables, i.e. could use any arbitrary
> data type.  E.g. KVM as L1 could use an XArray to track L2 mappings.  And L0 in
> turn wouldn't need to have vendor specific code, i.e. pKVM on x86 (potentially
> *all* architectures) could have a single nested paging scheme for both Intel and
> AMD, as opposed to needing code to deal with the differences between EPT and NPT.
> 
> A few months back, I mentally worked through the flows[*] (I forget why I was
> thinking about PV paging), and I'm pretty sure that adapting x86's TDP MMU to
> support PV paging would be easy-ish, e.g. kvm_tdp_mmu_map() would become an
> XArray insertion (to track the L2 mapping) + hypercall (to inform L1 of the new
> mapping).
> 
> [*] I even though of a catchy name, KVM Paravirt Only Paging, a.k.a. KPOP ;-)

hi, Sean & all,

I did a POC[1] to support KPOP (KVM Paravirt Only Paging) for KVM on KVM
nested guest. I am not sure if such solution is welcome to KVM community,
I appreciate if you can give me some advice/direction. As I saw the
solution is straightforward and less memory cost (no double page tables),
but a rough benchmark based on stress-ng show less 1% improvement for
both cpu & vm stress test, comparing to legacy shadowing mode nested
guest solution.

Brief idea of this POC
----------------------

The brief idea of the POC is to intercept below x86 KVM MMU interfaces
to do three KPOP hypercalls - KVM_HC_KPOP_MMU_LOAD_UNLOAD,
KVM_HC_KPOP_MMU_MAP & KVM_HC_KPOP_MMU_UNMAP:

- int (*mmu_load)(struct kvm_vcpu *vcpu);
  this ops(from L1) leads to KVM_HC_KPOP_MMU_LOAD_UNLOAD hypercall for MMU
  load to L0 KVM, L0 KVM shall help to create L2 guest MMU page table and
  ensure vcpu will load it as root pgd when corresponding nested vcpu is
  running.

- void (*mmu_unload)(struct kvm_vcpu *vcpu);
  this ops(from L1) leads to KVM_HC_KPOP_MMU_LOAD_UNLOAD hypercall for MMU
  unload to L0 KVM, L0 KVM shall try to put & free corresponding L2 guest
  MMU page table.

- bool (*mmu_set_spte_gfn)(struct kvm *kvm, struct kvm_gfn_range
  *range);
  this ops(from L1) leads to KVM_HC_KPOP_MMU_MAP hypercall for MMU remap
  to L0 KVM, L0 KVM shall try to remap the range's MMU mapping for all
  previous loaded L2 guest MMU page tables who belongs to L2 "kvm" and
  whose as_id (address id) is same as range->slot->as_id.

- bool (*mmu_unmap_gfn_range)(struct kvm *kvm, struct kvm_gfn_range
  *range);
  this ops(from L1) leads to KVM_HC_KPOP_MMU_UNMAP hypercall for MMU unmap
  to L0 KVM, L0 KVM shall try to unmap the range's MMU mapping for all
  previous loaded L2 guest MMU page tables who belongs to L2 "kvm" and
  whose as_id is same as range->slot->as_id.

- void (*mmu_zap_gfn_range)(struct kvm *kvm, gfn_t gfn_start, gfn_t
  gfn_end);
  this ops(from L1) leads to KVM_HC_KPOP_MMU_UNMAP hypercall for MMU unmap
  to L0 KVM, L0 KVM shall try to unmap the {start, end} MMU mapping for
  all previous loaded L2 guest MMU page tables who belongs to L2 "kvm"
  (for all as_id).

- void (*mmu_zap_all)(struct kvm *kvm, bool fast);
  this ops(from L1) leads to KVM_HC_KPOP_MMU_UNMAP hypercall for MMU unmap
  to L0 KVM, L0 KVM shall try to zap all MMU mapping for all previous
  loaded L2 guest MMU page tables who belongs to L2 "kvm" (for all as_id).

- the page fault handling function (direct_page_fault) in L1 KVM is also
  changed in this POC to support KPOP MMU mapping, which leads to
  KVM_HC_KPOP_MMU_MAP hypercall, and L0 KVM leverage kvm_tdp_mmu_map
  to do the MMU page mapping for previous loaded L2 guest MMU page table.

How geust MMU page table be identified?
---------------------------------------

The L2 guest MMU page table is identified by its L1 vcpu_holder & as_id,
L1 KVM is running L2 vcpu after loading L2 vcpu info into corresponding
vcpu_holder - for x86 it's vmcs. When L1 KVM do mmu_load for its L2 guest
MMU page table, it will also define different as_id for such table - for
x86 it's based on whether vcpu is running under smm mode.

And in this POC, L0 KVM maintains L2 guest MMU for L1 KVM in a per-VM
hash table which hashed by the vcpu_holders. Struct kpop_guest_mmu and
several APIs are introduced for managing L2 guest MMU:

struct kpop_guest_mmu {
        struct hlist_node hnode;
        u64 vcpu_holder;
        u64 kvm_id;
        u64 as_id;
        hpa_t root_hpa;
        refcount_t count;
};

- int kpop_alloc_guest_mmu(struct kvm_vcpu *vcpu, u64 vcpu_holder, u64
  kvm_id, u64 as_id)
- void kpop_put_guest_mmu(struct kvm_vcpu *vcpu, u64 vcpu_holder, u64
  kvm_id, u64 as_id)
- struct kpop_guest_mmu *kpop_find_guest_mmu(struct kvm *kvm, u64
  vcpu_holder, u64 as_id)
- int kpop_reload_guest_mmu(struct kvm_vcpu *vcpu, bool check_vcpu)


TODOs & OPENs
-------------

There are still a lot of TODOs:

- L2 translation info (XArray) in L1 KVM
  L1 KVM may need maintain translation info (ngpa-to-gpa) for L2 guests,
  one possible use case is for MMIO fault optimization. A simple way is
  to maintain a translation info XArray in L1 KVM.

- support UMIP emulation
  UMIP emulation want L0 KVM do instruction emulation for L2 guest,
  which want to do nested address translation, usually it should be done
  by guest_kpop_mmu's gva_to_gpa ops (unimplemented kpop_gva_to_gpa in my
  POC),  we either do such translation based on L1 maintained translation
  table (in this case XArray may not be a good choice for L1 translation
  table), or we maintain another new translation table (e.g., another
  XArray) in L0 for L2 guest.

- age/test_age
  age/test_age mmu interfaces should be supported, e.g., for SWAP in L1 VM.

- page track
  page track should be supported, e.g., for GVT graphics page table shadowing usage.

- dirty log
  dirty log should be supported for VM migration.

[1]: https://github.com/intel-staging/pKVM-IA/tree/KPOP_RFC

-- 

Thanks
Jason CJ Chen
