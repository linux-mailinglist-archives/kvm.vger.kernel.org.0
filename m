Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBBF2AE113
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 21:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729862AbgKJUwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 15:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgKJUwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 15:52:18 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FB6C0613D1
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 12:52:16 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id c129so12987634yba.8
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 12:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ac0VM0dcPTqx37kRHqfKzIT7iqCUTygIk3BYJ8irkmI=;
        b=JTyj4rtordrueuHgkRvdME7gUYeUTCkqogHaxc6bBhVlibTpEnwnZBjuQcZtyD79Z5
         CLc7fA0/gYX9LlScauGCt1LDeUYhs0MkaXLD1XZLy/rwpjLvBn4FPZIt5l5gaGanH7pM
         SD6RWa43QvncETp12N7ewpeQlLU+t0cx9nGG7V/kSTJkGt7jFuO55Y1W1c1yOrFhw/ZF
         KeQiLShdIZgjNxLbheUKxXTNRP8X8rEfYenc9tfXgXP1Sr80PcMArkm8WySoPg2hol2p
         mjp0Y2ctrE/2HVl4rh0pQd6avSY3nYFrJAcijlztRRZ5qmt4xrIHK9BbQw4sRRXLqzte
         Tlrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ac0VM0dcPTqx37kRHqfKzIT7iqCUTygIk3BYJ8irkmI=;
        b=nvkJxovWPmk7xzQlrqxKqPRCAOgMR6wiARwUxQbcH9KEBMYZ41dRmZARarPmjk9Oei
         QAgsw1DXFjhJEUrK0yGuKysgY4WG9h/KH9ryv+og8e4vH8Iexs7JYLyflH4A7unVdd/N
         K+PbHlpif5Z78kPYgKR89prMYU1+PWDnYJJNpvHyLhkLHXHBl2YOuGJiNfsyIlWnSvJJ
         a3FDqsMHRA2LqGg83ASKKkqtcAmJW1wtO7/ofHCdw2jgnIXR+M8ROZmIshOyEB1x7SQs
         buDu80S/UgYCqiJFLf3ZOIS1yH8xbMXqeVl2Re3SDwezcnbGkn6zirZgDatq2troNUhV
         LndQ==
X-Gm-Message-State: AOAM531Eih+KD93VNuoAlZ7VBTOPnOrWasZ1o0l31wCJOQVFpF0DJTub
        4xIDZ1PdSAlwpaDjmaod+DgDSZQ0AWzLv+gq+dJlZQ==
X-Google-Smtp-Source: ABdhPJxQ51yNlwcvddLkpDpNIjNRYR4y4akzEfTZ9y3nYZfaGF2M633znvjCHMsrA7XkkkHdcxn9e9OzazWC8K43VIE=
X-Received: by 2002:a25:a567:: with SMTP id h94mr27245703ybi.211.1605041535584;
 Tue, 10 Nov 2020 12:52:15 -0800 (PST)
MIME-Version: 1.0
References: <20201109021254.79755-1-like.xu@linux.intel.com>
 <20201110151257.GP2611@hirez.programming.kicks-ass.net> <20201110153721.GQ2651@hirez.programming.kicks-ass.net>
In-Reply-To: <20201110153721.GQ2651@hirez.programming.kicks-ass.net>
From:   Stephane Eranian <eranian@google.com>
Date:   Tue, 10 Nov 2020 12:52:04 -0800
Message-ID: <CABPqkBS+-g0qbsruAMfOJf-Zfac8nz9v2LCWfrrvVd+ptoLxZg@mail.gmail.com>
Subject: Re: [PATCH] perf/intel: Remove Perfmon-v4 counter_freezing support
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 10, 2020 at 7:37 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Nov 10, 2020 at 04:12:57PM +0100, Peter Zijlstra wrote:
> > On Mon, Nov 09, 2020 at 10:12:37AM +0800, Like Xu wrote:
> > > The Precise Event Based Sampling(PEBS) supported on Intel Ice Lake server
> > > platforms can provide an architectural state of the instruction executed
> > > after the instruction that caused the event. This patch set enables the
> > > the PEBS via DS feature for KVM (also non) Linux guest on the Ice Lake.
> > > The Linux guest can use PEBS feature like native:
> > >
> > >   # perf record -e instructions:ppp ./br_instr a
> > >   # perf record -c 100000 -e instructions:pp ./br_instr a
> > >
> > > If the counter_freezing is not enabled on the host, the guest PEBS will
> > > be disabled on purpose when host is using PEBS facility. By default,
> > > KVM disables the co-existence of guest PEBS and host PEBS.
> >
> > Uuhh, what?!? counter_freezing should never be enabled, its broken. Let
> > me go delete all that code.
>
> ---
> Subject: perf/intel: Remove Perfmon-v4 counter_freezing support
>
> Perfmon-v4 counter freezing is fundamentally broken; remove this default
> disabled code to make sure nobody uses it.
>
> The feature is called Freeze-on-PMI in the SDM, and if it would do that,
> there wouldn't actually be a problem, *however* it does something subtly
> different. It globally disables the whole PMU when it raises the PMI,
> not when the PMI hits.
>
> This means there's a window between the PMI getting raised and the PMI
> actually getting served where we loose events and this violates the
> perf counter independence. That is, a counting event should not result
> in a different event count when there is a sampling event co-scheduled.
>

What is implemented is Freeze-on-Overflow, yet it is described as Freeze-on-PMI.
That, in itself, is a problem. I agree with you on that point.

However, there are use cases for both modes.

I can sample on event A and count on B, C and when A overflows, I want
to snapshot B, C.
For that I want B, C at the moment of the overflow, not at the moment
the PMI is delivered. Thus, youd
would want the Freeze-on-overflow behavior. You can collect in this
mode with the perf tool,
IIRC: perf record -e '{cycles,instructions,branches:S}' ....

The other usage model is that of the replay-debugger (rr) which you are alluding
to, which needs precise count of an event including during the skid
window. For that, you need
Freeze-on-PMI (delivered). Note that this tool likely only cares about
user level occurrences of events.

As for counter independence, I am not sure it holds in all cases. If
the events are setup for user+kernel
then, as soon as you co-schedule a sampling event, you will likely get
more counts on the counting
event due to the additional kernel entries/exits caused by
interrupt-based profiling. Even if you were to
restrict to user level only, I would expect to see a few more counts.


> This is known to break existing software.
>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  arch/x86/events/intel/core.c | 152 -------------------------------------------
>  arch/x86/events/perf_event.h |   3 +-
>  2 files changed, 1 insertion(+), 154 deletions(-)
>
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index c79748f6921d..9909dfa6fb12 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -2121,18 +2121,6 @@ static void intel_tfa_pmu_enable_all(int added)
>         intel_pmu_enable_all(added);
>  }
>
> -static void enable_counter_freeze(void)
> -{
> -       update_debugctlmsr(get_debugctlmsr() |
> -                       DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI);
> -}
> -
> -static void disable_counter_freeze(void)
> -{
> -       update_debugctlmsr(get_debugctlmsr() &
> -                       ~DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI);
> -}
> -
>  static inline u64 intel_pmu_get_status(void)
>  {
>         u64 status;
> @@ -2696,95 +2684,6 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
>         return handled;
>  }
>
> -static bool disable_counter_freezing = true;
> -static int __init intel_perf_counter_freezing_setup(char *s)
> -{
> -       bool res;
> -
> -       if (kstrtobool(s, &res))
> -               return -EINVAL;
> -
> -       disable_counter_freezing = !res;
> -       return 1;
> -}
> -__setup("perf_v4_pmi=", intel_perf_counter_freezing_setup);
> -
> -/*
> - * Simplified handler for Arch Perfmon v4:
> - * - We rely on counter freezing/unfreezing to enable/disable the PMU.
> - * This is done automatically on PMU ack.
> - * - Ack the PMU only after the APIC.
> - */
> -
> -static int intel_pmu_handle_irq_v4(struct pt_regs *regs)
> -{
> -       struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
> -       int handled = 0;
> -       bool bts = false;
> -       u64 status;
> -       int pmu_enabled = cpuc->enabled;
> -       int loops = 0;
> -
> -       /* PMU has been disabled because of counter freezing */
> -       cpuc->enabled = 0;
> -       if (test_bit(INTEL_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
> -               bts = true;
> -               intel_bts_disable_local();
> -               handled = intel_pmu_drain_bts_buffer();
> -               handled += intel_bts_interrupt();
> -       }
> -       status = intel_pmu_get_status();
> -       if (!status)
> -               goto done;
> -again:
> -       intel_pmu_lbr_read();
> -       if (++loops > 100) {
> -               static bool warned;
> -
> -               if (!warned) {
> -                       WARN(1, "perfevents: irq loop stuck!\n");
> -                       perf_event_print_debug();
> -                       warned = true;
> -               }
> -               intel_pmu_reset();
> -               goto done;
> -       }
> -
> -
> -       handled += handle_pmi_common(regs, status);
> -done:
> -       /* Ack the PMI in the APIC */
> -       apic_write(APIC_LVTPC, APIC_DM_NMI);
> -
> -       /*
> -        * The counters start counting immediately while ack the status.
> -        * Make it as close as possible to IRET. This avoids bogus
> -        * freezing on Skylake CPUs.
> -        */
> -       if (status) {
> -               intel_pmu_ack_status(status);
> -       } else {
> -               /*
> -                * CPU may issues two PMIs very close to each other.
> -                * When the PMI handler services the first one, the
> -                * GLOBAL_STATUS is already updated to reflect both.
> -                * When it IRETs, the second PMI is immediately
> -                * handled and it sees clear status. At the meantime,
> -                * there may be a third PMI, because the freezing bit
> -                * isn't set since the ack in first PMI handlers.
> -                * Double check if there is more work to be done.
> -                */
> -               status = intel_pmu_get_status();
> -               if (status)
> -                       goto again;
> -       }
> -
> -       if (bts)
> -               intel_bts_enable_local();
> -       cpuc->enabled = pmu_enabled;
> -       return handled;
> -}
> -
>  /*
>   * This handler is triggered by the local APIC, so the APIC IRQ handling
>   * rules apply:
> @@ -4081,9 +3980,6 @@ static void intel_pmu_cpu_starting(int cpu)
>         if (x86_pmu.version > 1)
>                 flip_smm_bit(&x86_pmu.attr_freeze_on_smi);
>
> -       if (x86_pmu.counter_freezing)
> -               enable_counter_freeze();
> -
>         /* Disable perf metrics if any added CPU doesn't support it. */
>         if (x86_pmu.intel_cap.perf_metrics) {
>                 union perf_capabilities perf_cap;
> @@ -4154,9 +4050,6 @@ static void free_excl_cntrs(struct cpu_hw_events *cpuc)
>  static void intel_pmu_cpu_dying(int cpu)
>  {
>         fini_debug_store_on_cpu(cpu);
> -
> -       if (x86_pmu.counter_freezing)
> -               disable_counter_freeze();
>  }
>
>  void intel_cpuc_finish(struct cpu_hw_events *cpuc)
> @@ -4548,39 +4441,6 @@ static __init void intel_nehalem_quirk(void)
>         }
>  }
>
> -static const struct x86_cpu_desc counter_freezing_ucodes[] = {
> -       INTEL_CPU_DESC(INTEL_FAM6_ATOM_GOLDMONT,         2, 0x0000000e),
> -       INTEL_CPU_DESC(INTEL_FAM6_ATOM_GOLDMONT,         9, 0x0000002e),
> -       INTEL_CPU_DESC(INTEL_FAM6_ATOM_GOLDMONT,        10, 0x00000008),
> -       INTEL_CPU_DESC(INTEL_FAM6_ATOM_GOLDMONT_D,       1, 0x00000028),
> -       INTEL_CPU_DESC(INTEL_FAM6_ATOM_GOLDMONT_PLUS,    1, 0x00000028),
> -       INTEL_CPU_DESC(INTEL_FAM6_ATOM_GOLDMONT_PLUS,    8, 0x00000006),
> -       {}
> -};
> -
> -static bool intel_counter_freezing_broken(void)
> -{
> -       return !x86_cpu_has_min_microcode_rev(counter_freezing_ucodes);
> -}
> -
> -static __init void intel_counter_freezing_quirk(void)
> -{
> -       /* Check if it's already disabled */
> -       if (disable_counter_freezing)
> -               return;
> -
> -       /*
> -        * If the system starts with the wrong ucode, leave the
> -        * counter-freezing feature permanently disabled.
> -        */
> -       if (intel_counter_freezing_broken()) {
> -               pr_info("PMU counter freezing disabled due to CPU errata,"
> -                       "please upgrade microcode\n");
> -               x86_pmu.counter_freezing = false;
> -               x86_pmu.handle_irq = intel_pmu_handle_irq;
> -       }
> -}
> -
>  /*
>   * enable software workaround for errata:
>   * SNB: BJ122
> @@ -4966,9 +4826,6 @@ __init int intel_pmu_init(void)
>                         max((int)edx.split.num_counters_fixed, assume);
>         }
>
> -       if (version >= 4)
> -               x86_pmu.counter_freezing = !disable_counter_freezing;
> -
>         if (boot_cpu_has(X86_FEATURE_PDCM)) {
>                 u64 capabilities;
>
> @@ -5090,7 +4947,6 @@ __init int intel_pmu_init(void)
>
>         case INTEL_FAM6_ATOM_GOLDMONT:
>         case INTEL_FAM6_ATOM_GOLDMONT_D:
> -               x86_add_quirk(intel_counter_freezing_quirk);
>                 memcpy(hw_cache_event_ids, glm_hw_cache_event_ids,
>                        sizeof(hw_cache_event_ids));
>                 memcpy(hw_cache_extra_regs, glm_hw_cache_extra_regs,
> @@ -5117,7 +4973,6 @@ __init int intel_pmu_init(void)
>                 break;
>
>         case INTEL_FAM6_ATOM_GOLDMONT_PLUS:
> -               x86_add_quirk(intel_counter_freezing_quirk);
>                 memcpy(hw_cache_event_ids, glp_hw_cache_event_ids,
>                        sizeof(hw_cache_event_ids));
>                 memcpy(hw_cache_extra_regs, glp_hw_cache_extra_regs,
> @@ -5577,13 +5432,6 @@ __init int intel_pmu_init(void)
>                 pr_cont("full-width counters, ");
>         }
>
> -       /*
> -        * For arch perfmon 4 use counter freezing to avoid
> -        * several MSR accesses in the PMI.
> -        */
> -       if (x86_pmu.counter_freezing)
> -               x86_pmu.handle_irq = intel_pmu_handle_irq_v4;
> -
>         if (x86_pmu.intel_cap.perf_metrics)
>                 x86_pmu.intel_ctrl |= 1ULL << GLOBAL_CTRL_EN_PERF_METRICS;
>
> diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
> index 10032f023fcc..4084fa31cc21 100644
> --- a/arch/x86/events/perf_event.h
> +++ b/arch/x86/events/perf_event.h
> @@ -681,8 +681,7 @@ struct x86_pmu {
>
>         /* PMI handler bits */
>         unsigned int    late_ack                :1,
> -                       enabled_ack             :1,
> -                       counter_freezing        :1;
> +                       enabled_ack             :1;
>         /*
>          * sysfs attrs
>          */
