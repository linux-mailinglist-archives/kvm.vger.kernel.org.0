Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5C65AB45E
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 10:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392717AbfIFIuf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 6 Sep 2019 04:50:35 -0400
Received: from mga07.intel.com ([134.134.136.100]:51284 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392632AbfIFIuf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 04:50:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 01:50:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,472,1559545200"; 
   d="scan'208";a="213081645"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga002.fm.intel.com with ESMTP; 06 Sep 2019 01:50:33 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 6 Sep 2019 01:50:33 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 6 Sep 2019 01:50:33 -0700
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 6 Sep 2019 01:50:33 -0700
Received: from shsmsx102.ccr.corp.intel.com ([169.254.2.113]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.235]) with mapi id 14.03.0439.000;
 Fri, 6 Sep 2019 16:50:31 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "Liang, Kan" <kan.liang@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "Xu, Like" <like.xu@intel.com>,
        "jannh@google.com" <jannh@google.com>,
        "arei.gonglei@huawei.com" <arei.gonglei@huawei.com>,
        "jmattson@google.com" <jmattson@google.com>
Subject: RE: [PATCH v8 00/14] Guest LBR Enabling
Thread-Topic: [PATCH v8 00/14] Guest LBR Enabling
Thread-Index: AQHVTC0a1hHjJr16G0eshMkAiyqYMqcehe4g
Date:   Fri, 6 Sep 2019 08:50:30 +0000
Message-ID: <286AC319A985734F985F78AFA26841F73E21BB5C@shsmsx102.ccr.corp.intel.com>
References: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
In-Reply-To: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMmQ1OGQ2ZTItN2IyNS00YTYyLTg3NDMtODIwZjI5ODcyYzEyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVlExWHdONGZDcWgra0dvenFocUNsUHBlcUwyOTgzZDBKb29pTDVYaUJuRGNZeW5wRWwzT1JGXC9iTHFQaHVWaVIifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A polite ping for comments on this version, thanks!

On Tuesday, August 6, 2019 3:16 PM, Wei Wang wrote:
> Last Branch Recording (LBR) is a performance monitor unit (PMU) feature on
> Intel CPUs that captures branch related info. This patch series enables this
> feature to KVM guests.
> 
> Each guest can be configured to expose this LBR feature to the guest via
> userspace setting the enabling param in KVM_CAP_X86_GUEST_LBR (patch
> 3).
> 
> About the lbr emulation method:
> Since the vcpu get scheduled in, the lbr related msrs are made interceptible.
> This makes guest first access to a lbr related msr always vm-exit to kvm, so
> that kvm can know whether the lbr feature is used during the vcpu time slice.
> The kvm lbr msr handler does the following
> things:
>   - create an lbr perf event (task pinned) for the vcpu thread.
>     The perf event mainly serves 2 purposes:
>       -- follow the host perf scheduling rules to manage the vcpu's usage
>          of lbr (e.g. a cpu pinned lbr event could reclaim lbr and thus
>          stopping the vcpu's use);
>       -- have the host perf do context switching of the lbr state on the
>          vcpu thread switching.
>   - pass the lbr related msrs through to the guest.
>     This enables the following guest accesses to the lbr related msrs
>     without vm-exit, as long as the vcpu's lbr event owns the lbr feature.
>     A cpu pinned lbr event on the host could come and take over the lbr
>     feature via IPI calls. In this case, the pass-through will be
>     cancelled (patch 13), and the guest following accesses to the lbr msrs
>     will vm-exit to kvm and accesses will be forbidden in the handler.
> 
> If the guest doesn't touch any of the lbr related msrs (likely the guest doesn't
> need to run lbr in the near future), the vcpu's lbr perf event will be freed
> (please see patch 12 commit for more details).
> 
> * Tests
> Conclusion: the profiling results on the guest are similar to that on the host.
> 
> Run: ./perf -b ./test_program
> 
> - Test on the host:
> Overhead  Command  Source Shared Object  Source Symbol    Target
> Symbol
>   22.35%  ftest    libc-2.23.so          [.] __random     [.]
> __random
>    8.20%  ftest    ftest                 [.] qux          [.] qux
>    5.88%  ftest    ftest                 [.] random@plt   [.]
> __random
>    5.88%  ftest    libc-2.23.so          [.] __random     [.]
> __random_r
>    5.79%  ftest    ftest                 [.] main         [.]
> random@plt
>    5.60%  ftest    ftest                 [.] main         [.] foo
>    5.24%  ftest    libc-2.23.so          [.] __random     [.] main
>    5.20%  ftest    libc-2.23.so          [.] __random_r   [.]
> __random
>    5.00%  ftest    ftest                 [.] foo          [.] qux
>    4.91%  ftest    ftest                 [.] main         [.] bar
>    4.83%  ftest    ftest                 [.] bar          [.] qux
>    4.57%  ftest    ftest                 [.] main         [.] main
>    4.38%  ftest    ftest                 [.] foo          [.] main
>    4.13%  ftest    ftest                 [.] qux          [.] foo
>    3.89%  ftest    ftest                 [.] qux          [.] bar
>    3.86%  ftest    ftest                 [.] bar          [.] main
> 
> - Test on the guest:
> Overhead  Command  Source Shaged Object  Source Symbol    Target
> Symbol
>   22.36%  ftest    libc-2.23.so          [.] random       [.] random
>    8.55%  ftest    ftest                 [.] qux          [.] qux
>    5.79%  ftest    libc-2.23.so          [.] random       [.]
> random_r
>    5.64%  ftest    ftest                 [.] random@plt   [.]
> random
>    5.58%  ftest    ftest                 [.] main         [.]
> random@plt
>    5.55%  ftest    ftest                 [.] main         [.] foo
>    5.41%  ftest    libc-2.23.so          [.] random       [.] main
>    5.31%  ftest    libc-2.23.so          [.] random_r     [.] random
>    5.11%  ftest    ftest                 [.] foo          [.] qux
>    4.93%  ftest    ftest                 [.] main         [.] main
>    4.59%  ftest    ftest                 [.] qux          [.] bar
>    4.49%  ftest    ftest                 [.] bar          [.] main
>    4.42%  ftest    ftest                 [.] bar          [.] qux
>    4.16%  ftest    ftest                 [.] main         [.] bar
>    3.95%  ftest    ftest                 [.] qux          [.] foo
>    3.79%  ftest    ftest                 [.] foo          [.] main
> (due to the lib version difference, "random" is equavlent to __random above)
> 
> v7->v8 Changelog:
>   - Patch 3:
>     -- document KVM_CAP_X86_GUEST_LBR in api.txt
>     -- make the check of KVM_CAP_X86_GUEST_LBR return the size of
>        struct x86_perf_lbr_stack, to let userspace do a compatibility
>        check.
>   - Patch 7:
>     -- support perf scheduler to not assign a counter for the perf event
>        that has PERF_EV_CAP_NO_COUNTER set (rather than skipping the
> perf
>        scheduler). This allows the scheduler to detect lbr usage conflicts
>        via get_event_constraints, and lower priority events will finally
>        fail to use lbr.
>     -- define X86_PMC_IDX_NA as "-1", which represents a never assigned
>        counter id. There are other places that use "-1", but could be
>        updated to use the new macro in another patch series.
>   - Patch 8:
>     -- move the event->owner assignment into perf_event_alloc to have it
>        set before event_init is called. Please see this patch's commit for
>        reasons.
>   - Patch 9:
>     -- use "exclude_host" and "is_kernel_event" to decide if the lbr event
>        is used for the vcpu lbr emulation, which doesn't need a counter,
>        and removes the usage of the previous new perf_event_create API.
>     -- remove the unused attr fields.
>   - Patch 10:
>     -- set a hardware reserved bit (bit 62 of LBR_SELECT) to reg->config
>        for the vcpu lbr emulation event. This makes the config different
>        from other host lbr event, so that they don't share the lbr.
>        Please see the comments in the patch for the reasons why they
>        shouldn't share.
>   - Patch 12:
>     -- disable interrupt and check if the vcpu lbr event owns the lbr
>        feature before kvm writing to the lbr related msr. This avoids kvm
>        updating the lbr msrs after lbr has been reclaimed by other events
>        via ipi.
>     -- remove arch v4 related support.
>   - Patch 13:
>     -- double check if the vcpu lbr event owns the lbr feature before
>        vm-entry into the guest. The lbr pass-through will be cancelled if
>        lbr feature has been reclaimed by a cpu pinned lbr event.
> 
> Previous:
> https://lkml.kernel.org/r/1562548999-37095-1-git-send-email-wei.w.wang
> @intel.com
> 
> Wei Wang (14):
>   perf/x86: fix the variable type of the lbr msrs
>   perf/x86: add a function to get the addresses of the lbr stack msrs
>   KVM/x86: KVM_CAP_X86_GUEST_LBR
>   KVM/x86: intel_pmu_lbr_enable
>   KVM/x86/vPMU: tweak kvm_pmu_get_msr
>   KVM/x86: expose MSR_IA32_PERF_CAPABILITIES to the guest
>   perf/x86: support to create a perf event without counter allocation
>   perf/core: set the event->owner before event_init
>   KVM/x86/vPMU: APIs to create/free lbr perf event for a vcpu thread
>   perf/x86/lbr: don't share lbr for the vcpu usage case
>   perf/x86: save/restore LBR_SELECT on vcpu switching
>   KVM/x86/lbr: lbr emulation
>   KVM/x86/vPMU: check the lbr feature before entering guest
>   KVM/x86: remove the common handling of the debugctl msr
> 
>  Documentation/virt/kvm/api.txt    |  26 +++
>  arch/x86/events/core.c            |  36 ++-
>  arch/x86/events/intel/core.c      |   3 +
>  arch/x86/events/intel/lbr.c       |  95 +++++++-
>  arch/x86/events/perf_event.h      |   6 +-
>  arch/x86/include/asm/kvm_host.h   |   5 +
>  arch/x86/include/asm/perf_event.h |  17 ++
>  arch/x86/kvm/cpuid.c              |   2 +-
>  arch/x86/kvm/pmu.c                |  24 +-
>  arch/x86/kvm/pmu.h                |  11 +-
>  arch/x86/kvm/pmu_amd.c            |   7 +-
>  arch/x86/kvm/vmx/pmu_intel.c      | 476
> +++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/vmx.c            |   4 +-
>  arch/x86/kvm/vmx/vmx.h            |   2 +
>  arch/x86/kvm/x86.c                |  47 ++--
>  include/linux/perf_event.h        |  18 ++
>  include/uapi/linux/kvm.h          |   1 +
>  kernel/events/core.c              |  19 +-
>  18 files changed, 738 insertions(+), 61 deletions(-)
> 
> --
> 2.7.4

