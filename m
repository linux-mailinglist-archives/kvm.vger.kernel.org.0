Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DCF3F9491
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 08:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243253AbhH0Gxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 02:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243085AbhH0Gxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 02:53:53 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098DBC061757;
        Thu, 26 Aug 2021 23:53:04 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 7so4881233pfl.10;
        Thu, 26 Aug 2021 23:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:organization:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZbPR4yx/IOajSeOQV0WqfM0PbBdXTweT1rKYfi28feY=;
        b=payY2kqnM27b9m01D/1+bYK3zs1eXQlgI4vTVEDItXKdcEjenbudsQUK12OYHhZIDJ
         JOxvUmjXzUwKZpNU30p0IGGgmqvvdzbBsUOvU6kO6AytKPjJv1t5M9UKqUnNynMo3O1t
         897hTF8t6qJ401enQ56rSSevNHfVbvTWJ2uDO8+oBxCl+aL8EvHPdnXfXPhKa2JAH0Rb
         GaP8DF5aX4LiaeW5F4pLVTPqSSEmBhqL2SFViKXjLv/WCXH2zl9+/EBUAncYatI1OJYW
         ut5gRVObXIQd3ImgY4BCEWE/FMTk8GjNsLYaORrSs8vtqDHmAJVY+p5cShEKs9U0gvIh
         z52A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZbPR4yx/IOajSeOQV0WqfM0PbBdXTweT1rKYfi28feY=;
        b=uc+r/FSfVGzV7gBi6u83RLHumCfWHCY/uDHCBuh5xHsRtJCqktODQmHgysJpvEH+ns
         HptPXjMZXlJuNSNb2EH1TQFzyBPiY4TgU5/NPBEWX7cMx8pq1WhhlSyvuECTU1/NqZ9J
         d0S6IflKF6/kokpydhVYT/9wEgpDZ+dkMxXCX7jlnlmTTbnj4QHlcDvxDGJWg3sC4z8p
         rVpExtyMyqR4S1f7CmlMRTjhoVA+YhT+L3kYTC2NZxUzF2z15pUvaZcinJ53ho9buQBZ
         YPbGZJDbdufI1yVrDuBO8C2szaepgrvvrGIyTfRsFn6DkA7QVxgnE7udYzdiAKTJFrJ0
         Y1vg==
X-Gm-Message-State: AOAM531AVM9uTciJNVkY/B0aCvGpg01lAt3rIJfVKBf2XEhmTLGt8nMp
        L2CEv7yE2KEKGBfNtIpxaPs=
X-Google-Smtp-Source: ABdhPJyIg5x8cr9cVb6zAj5cRL9RFwMN1nC8hYox93WeTM79htakFUO0AJVU1P54gIrOby01KizKhw==
X-Received: by 2002:a63:b1a:: with SMTP id 26mr6567924pgl.12.1630047183274;
        Thu, 26 Aug 2021 23:53:03 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t42sm4859131pfg.30.2021.08.26.23.52.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 23:53:03 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jason Baron <jbaron@akamai.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ard Biesheuvel <ardb@kernel.org>
References: <20210827005718.585190-1-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH 00/15] perf: KVM: Fix, optimize, and clean up callbacks
Message-ID: <fd3dcd6c-b3d5-4453-93fb-b46d0595534e@gmail.com>
Date:   Fri, 27 Aug 2021 14:52:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210827005718.585190-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+ STATIC BRANCH/CALL friends.

On 27/8/2021 8:57 am, Sean Christopherson wrote:
> This started out as a small series[1] to fix a KVM bug related to Intel PT
> interrupt handling and snowballed horribly.
> 
> The main problem being addressed is that the perf_guest_cbs are shared by
> all CPUs, can be nullified by KVM during module unload, and are not
> protected against concurrent access from NMI context.

Shouldn't this be a generic issue of the static_call() usage ?

At the beginning, we set up the static entry assuming perf_guest_cbs != NULL:

	if (perf_guest_cbs && perf_guest_cbs->handle_intel_pt_intr) {
		static_call_update(x86_guest_handle_intel_pt_intr,
				   perf_guest_cbs->handle_intel_pt_intr);
	}

and then we unset the perf_guest_cbs and do the static function call like this:

DECLARE_STATIC_CALL(x86_guest_handle_intel_pt_intr, 
*(perf_guest_cbs->handle_intel_pt_intr));
static int handle_pmi_common(struct pt_regs *regs, u64 status)
{
		...
		if (!static_call(x86_guest_handle_intel_pt_intr)())
			intel_pt_interrupt();
		...
}

Can we make static_call() back to the original "(void *)&__static_call_return0" 
in this case ?

> 
> The bug has escaped notice because all dereferences of perf_guest_cbs
> follow the same "perf_guest_cbs && perf_guest_cbs->is_in_guest()" pattern,
> and AFAICT the compiler never reloads perf_guest_cbs in this sequence.
> The compiler does reload perf_guest_cbs for any future dereferences, but
> the ->is_in_guest() guard all but guarantees the PMI handler will win the
> race, e.g. to nullify perf_guest_cbs, KVM has to completely exit the guest
> and teardown down all VMs before it can be unloaded.
> 
> But with help, e.g. READ_ONCE(perf_guest_cbs), unloading kvm_intel can
> trigger a NULL pointer derference (see below).  Manual intervention aside,
> the bug is a bit of a time bomb, e.g. my patch 3 from the original PT
> handling series would have omitted the ->is_in_guest() guard.
> 
> This series fixes the problem by making the callbacks per-CPU, and
> registering/unregistering the callbacks only with preemption disabled
> (except for the Xen case, which doesn't unregister).
> 
> This approach also allows for several nice cleanups in this series.
> KVM x86 and arm64 can share callbacks, KVM x86 drops its somewhat
> redundant current_vcpu, and the retpoline that is currently hit when KVM
> is loaded (due to always checking ->is_in_guest()) goes away (it's still
> there when running as Xen Dom0).
> 
> Changing to per-CPU callbacks also provides a good excuse to excise
> copy+paste code from architectures that can't possibly have guest
> callbacks.
> 
> This series conflicts horribly with a proposed patch[2] to use static
> calls for perf_guest_cbs.  But that patch is broken as it completely
> fails to handle unregister, and it's not clear to me whether or not
> it can correctly handle unregister without fixing the underlying race
> (I don't know enough about the code patching for static calls).
> 
> This tweak
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 1eb45139fcc6..202e5ad97f82 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -2954,7 +2954,7 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
>   {
>          int misc = 0;
> 
> -       if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> +       if (READ_ONCE(perf_guest_cbs) && READ_ONCE(perf_guest_cbs)->is_in_guest()) {
>                  if (perf_guest_cbs->is_user_mode())
>                          misc |= PERF_RECORD_MISC_GUEST_USER;
>                  else
> 
> while spamming module load/unload leads to:
> 
>    BUG: kernel NULL pointer dereference, address: 0000000000000000
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    PGD 0 P4D 0
>    Oops: 0000 [#1] PREEMPT SMP
>    CPU: 6 PID: 1825 Comm: stress Not tainted 5.14.0-rc2+ #459
>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>    RIP: 0010:perf_misc_flags+0x1c/0x70
>    Call Trace:
>     perf_prepare_sample+0x53/0x6b0
>     perf_event_output_forward+0x67/0x160
>     __perf_event_overflow+0x52/0xf0
>     handle_pmi_common+0x207/0x300
>     intel_pmu_handle_irq+0xcf/0x410
>     perf_event_nmi_handler+0x28/0x50
>     nmi_handle+0xc7/0x260
>     default_do_nmi+0x6b/0x170
>     exc_nmi+0x103/0x130
>     asm_exc_nmi+0x76/0xbf
> 
> [1] https://lkml.kernel.org/r/20210823193709.55886-1-seanjc@google.com
> [2] https://lkml.kernel.org/r/20210806133802.3528-2-lingshan.zhu@intel.com
> 
> Sean Christopherson (15):
>    KVM: x86: Register perf callbacks after calling vendor's
>      hardware_setup()
>    KVM: x86: Register Processor Trace interrupt hook iff PT enabled in
>      guest
>    perf: Stop pretending that perf can handle multiple guest callbacks
>    perf: Force architectures to opt-in to guest callbacks
>    perf: Track guest callbacks on a per-CPU basis
>    KVM: x86: Register perf callbacks only when actively handling
>      interrupt
>    KVM: Use dedicated flag to track if KVM is handling an NMI from guest
>    KVM: x86: Drop current_vcpu in favor of kvm_running_vcpu
>    KVM: arm64: Register/unregister perf callbacks at vcpu load/put
>    KVM: Move x86's perf guest info callbacks to generic KVM
>    KVM: x86: Move Intel Processor Trace interrupt handler to vmx.c
>    KVM: arm64: Convert to the generic perf callbacks
>    KVM: arm64: Drop perf.c and fold its tiny bit of code into pmu.c
>    perf: Disallow bulk unregistering of guest callbacks and do cleanup
>    perf: KVM: Indicate "in guest" via NULL ->is_in_guest callback
> 
>   arch/arm/kernel/perf_callchain.c   | 28 ++------------
>   arch/arm64/Kconfig                 |  1 +
>   arch/arm64/include/asm/kvm_host.h  |  8 +++-
>   arch/arm64/kernel/perf_callchain.c | 18 ++++++---
>   arch/arm64/kvm/Makefile            |  2 +-
>   arch/arm64/kvm/arm.c               | 13 ++++++-
>   arch/arm64/kvm/perf.c              | 62 ------------------------------
>   arch/arm64/kvm/pmu.c               |  8 ++++
>   arch/csky/kernel/perf_callchain.c  | 10 -----
>   arch/nds32/kernel/perf_event_cpu.c | 29 ++------------
>   arch/riscv/kernel/perf_callchain.c | 10 -----
>   arch/x86/Kconfig                   |  1 +
>   arch/x86/events/core.c             | 17 +++++---
>   arch/x86/events/intel/core.c       |  7 ++--
>   arch/x86/include/asm/kvm_host.h    |  4 +-
>   arch/x86/kvm/pmu.c                 |  2 +-
>   arch/x86/kvm/pmu.h                 |  1 +
>   arch/x86/kvm/svm/svm.c             |  2 +-
>   arch/x86/kvm/vmx/vmx.c             | 25 ++++++++++--
>   arch/x86/kvm/x86.c                 | 54 +++-----------------------
>   arch/x86/kvm/x86.h                 | 12 +++---
>   arch/x86/xen/pmu.c                 |  2 +-
>   include/kvm/arm_pmu.h              |  1 +
>   include/linux/kvm_host.h           | 12 ++++++
>   include/linux/perf_event.h         | 33 ++++++++++++----
>   init/Kconfig                       |  3 ++
>   kernel/events/core.c               | 28 ++++++++------
>   virt/kvm/kvm_main.c                | 42 ++++++++++++++++++++
>   28 files changed, 204 insertions(+), 231 deletions(-)
>   delete mode 100644 arch/arm64/kvm/perf.c
> 
