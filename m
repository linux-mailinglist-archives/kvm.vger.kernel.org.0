Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F621AAAD6
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 16:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392460AbgDOOuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 10:50:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51146 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2392410AbgDOOuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 10:50:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586962213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qpQqiPTUBuQrThGzBWHY/3GIKSsGUjMINyQOadxscTg=;
        b=abAd+IGEWOD1oEtHDC5K5A6iQjdAD7oAOOE22rDEC0DG2syXXm6sJ8F/rejUlGcgseWgvG
        U3od8yfpxCzjm4k27Af9tayKy+Fi42E3oQ8jmLQqx7CeJk6A0fdnseU4RxCPhRTkWS7Zbj
        CSvyKh+d1T/u2G5XAwZpe+x6nciIS5k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-F4QgG4fZMzygQsH7waLe6A-1; Wed, 15 Apr 2020 10:50:06 -0400
X-MC-Unique: F4QgG4fZMzygQsH7waLe6A-1
Received: by mail-wr1-f70.google.com with SMTP id o10so30535wrj.7
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 07:50:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qpQqiPTUBuQrThGzBWHY/3GIKSsGUjMINyQOadxscTg=;
        b=QLWwJARpDuHQr8lDtKKzdPpqyMMReMXGgemdU/wBYclt8t5WwREznzFwGumvamdfW+
         e/7nXkR/CBsdWXztWdoCGy2YORLK/9sisMSDLpq/lF0Z+beoQ0RIgPpn8Ab4wbS1BVQC
         bvChlWaTmxMWfOLSfw+XCvSr5+K+foV6XpJmoX3BDo+MxFs6KZBXpR6GtAGAz3Jo2VXh
         u/9X/WJchtLFJeqPj1O7EmX7LtEQQtpVWFFLEKnUxQ3yicgm3qVhkYzhBj5IVggQS0tu
         ZlGaHzadAsGFuTzQw0E+CUVLtaYDicMGfSMSq2Ka5YU78iN9SQjpV2kUNikTq3GOM7Ta
         TUeg==
X-Gm-Message-State: AGi0Puaq6MwJgNSR1aN3/lDIv5Wy8sanIwU7u257UJA4DVEkiXNT2lGP
        NZahy+gMc8LfXBObM8tUSIUvBjiCDJfUdB4AQDl2FgPS7t+nk0azGC1OcGKWeWnw/TZs+iSkGzX
        3rRGehByUlOzm
X-Received: by 2002:adf:8563:: with SMTP id 90mr11550163wrh.202.1586962203915;
        Wed, 15 Apr 2020 07:50:03 -0700 (PDT)
X-Google-Smtp-Source: APiQypIY6SmJfBFhqZ4l23qMixhzMzFZ9BMgkJmcwYVR5NfdB0Y1M9hX5zDpA6En9ld9tv+7uvYjlQ==
X-Received: by 2002:adf:8563:: with SMTP id 90mr11550139wrh.202.1586962203541;
        Wed, 15 Apr 2020 07:50:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id s24sm22189364wmj.28.2020.04.15.07.50.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 07:50:02 -0700 (PDT)
Subject: Re: [PATCH 1/1] KVM: x86: Return updated timer current count register
 from KVM_GET_LAPIC
To:     Jim Mattson <jmattson@google.com>, Wanpeng Li <kernellwp@gmail.com>
Cc:     Peter Shier <pshier@google.com>, kvm <kvm@vger.kernel.org>
References: <20181010225653.238911-1-pshier@google.com>
 <CANRm+Cwq7foDTcD_jbASzV+YCiQwWuNXGjXH8Ew7a+h_ze_VEA@mail.gmail.com>
 <CALMp9eQajZRaZJ=PD-1T4JfiBqje-G1OtXEgcrwLjan3j-BC0w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <39988979-9f65-20ce-6726-2caae82dd903@redhat.com>
Date:   Wed, 15 Apr 2020 16:50:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQajZRaZJ=PD-1T4JfiBqje-G1OtXEgcrwLjan3j-BC0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/20 01:43, Jim Mattson wrote:
> On Tue, Oct 16, 2018 at 12:53 AM Wanpeng Li <kernellwp@gmail.com> wrote:
>>
>> On Thu, 11 Oct 2018 at 06:59, Peter Shier <pshier@google.com> wrote:
>>>
>>> kvm_vcpu_ioctl_get_lapic (implements KVM_GET_LAPIC ioctl) does a bulk copy
>>> of the LAPIC registers but must take into account that the one-shot and
>>> periodic timer current count register is computed upon reads and is not
>>> present in register state. When restoring LAPIC state (e.g. after
>>> migration), restart timers from their their current count values at time of
>>> save.
>>>
>>> Note: When a one-shot timer expires, the code in arch/x86/kvm/lapic.c does
>>> not zero the value of the LAPIC initial count register (emulating HW
>>> behavior). If no other timer is run and pending prior to a subsequent
>>> KVM_GET_LAPIC call, the returned register set will include the expired
>>> one-shot initial count. On a subsequent KVM_SET_LAPIC call the code will
>>> see a non-zero initial count and start a new one-shot timer using the
>>> expired timer's count. This is a prior existing bug and will be addressed
>>> in a separate patch. Thanks to jmattson@google.com for this find.
>>>
>>> Signed-off-by: Peter Shier <pshier@google.com>
>>> Reviewed-by: Jim Mattson <jmattson@google.com>
>>
>> Reviewed-by: Wanpeng Li <wanpengli@tencent.com>
>>
>>> ---
>>>  arch/x86/kvm/lapic.c | 64 +++++++++++++++++++++++++++++++++++---------
>>>  arch/x86/kvm/lapic.h |  7 ++++-
>>>  2 files changed, 58 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>>> index fbb0e6df121b2..8e7f3cf552871 100644
>>> --- a/arch/x86/kvm/lapic.c
>>> +++ b/arch/x86/kvm/lapic.c
>>> @@ -1524,13 +1524,18 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
>>>         local_irq_restore(flags);
>>>  }
>>>
>>> +static inline u64 tmict_to_ns(struct kvm_lapic *apic, u32 tmict)
>>> +{
>>> +       return (u64)tmict * APIC_BUS_CYCLE_NS * (u64)apic->divide_count;
>>> +}
>>> +
>>>  static void update_target_expiration(struct kvm_lapic *apic, uint32_t old_divisor)
>>>  {
>>>         ktime_t now, remaining;
>>>         u64 ns_remaining_old, ns_remaining_new;
>>>
>>> -       apic->lapic_timer.period = (u64)kvm_lapic_get_reg(apic, APIC_TMICT)
>>> -               * APIC_BUS_CYCLE_NS * apic->divide_count;
>>> +       apic->lapic_timer.period =
>>> +                       tmict_to_ns(apic, kvm_lapic_get_reg(apic, APIC_TMICT));
>>>         limit_periodic_timer_frequency(apic);
>>>
>>>         now = ktime_get();
>>> @@ -1548,14 +1553,15 @@ static void update_target_expiration(struct kvm_lapic *apic, uint32_t old_diviso
>>>         apic->lapic_timer.target_expiration = ktime_add_ns(now, ns_remaining_new);
>>>  }
>>>
>>> -static bool set_target_expiration(struct kvm_lapic *apic)
>>> +static bool set_target_expiration(struct kvm_lapic *apic, u32 count_reg)
>>>  {
>>>         ktime_t now;
>>>         u64 tscl = rdtsc();
>>> +       s64 deadline;
>>>
>>>         now = ktime_get();
>>> -       apic->lapic_timer.period = (u64)kvm_lapic_get_reg(apic, APIC_TMICT)
>>> -               * APIC_BUS_CYCLE_NS * apic->divide_count;
>>> +       apic->lapic_timer.period =
>>> +                       tmict_to_ns(apic, kvm_lapic_get_reg(apic, APIC_TMICT));
>>>
>>>         if (!apic->lapic_timer.period) {
>>>                 apic->lapic_timer.tscdeadline = 0;
>>> @@ -1563,6 +1569,28 @@ static bool set_target_expiration(struct kvm_lapic *apic)
>>>         }
>>>
>>>         limit_periodic_timer_frequency(apic);
>>> +       deadline = apic->lapic_timer.period;
>>> +
>>> +       if (apic_lvtt_period(apic) || apic_lvtt_oneshot(apic)) {
>>> +               if (unlikely(count_reg != APIC_TMICT)) {
>>> +                       deadline = tmict_to_ns(apic,
>>> +                                    kvm_lapic_get_reg(apic, count_reg));
>>> +                       if (unlikely(deadline <= 0))
>>> +                               deadline = apic->lapic_timer.period;
>>> +                       else if (unlikely(deadline > apic->lapic_timer.period)) {
>>> +                               pr_info_ratelimited(
>>> +                                   "kvm: vcpu %i: requested lapic timer restore with "
>>> +                                   "starting count register %#x=%u (%lld ns) > initial count (%lld ns). "
>>> +                                   "Using initial count to start timer.\n",
>>> +                                   apic->vcpu->vcpu_id,
>>> +                                   count_reg,
>>> +                                   kvm_lapic_get_reg(apic, count_reg),
>>> +                                   deadline, apic->lapic_timer.period);
>>> +                               kvm_lapic_set_reg(apic, count_reg, 0);
>>> +                               deadline = apic->lapic_timer.period;
>>> +                       }
>>> +               }
>>> +       }
>>>
>>>         apic_debug("%s: bus cycle is %" PRId64 "ns, now 0x%016"
>>>                    PRIx64 ", "
>>> @@ -1571,12 +1599,11 @@ static bool set_target_expiration(struct kvm_lapic *apic)
>>>                    APIC_BUS_CYCLE_NS, ktime_to_ns(now),
>>>                    kvm_lapic_get_reg(apic, APIC_TMICT),
>>>                    apic->lapic_timer.period,
>>> -                  ktime_to_ns(ktime_add_ns(now,
>>> -                               apic->lapic_timer.period)));
>>> +                  ktime_to_ns(ktime_add_ns(now, deadline)));
>>>
>>>         apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl) +
>>> -               nsec_to_cycles(apic->vcpu, apic->lapic_timer.period);
>>> -       apic->lapic_timer.target_expiration = ktime_add_ns(now, apic->lapic_timer.period);
>>> +               nsec_to_cycles(apic->vcpu, deadline);
>>> +       apic->lapic_timer.target_expiration = ktime_add_ns(now, deadline);
>>>
>>>         return true;
>>>  }
>>> @@ -1748,17 +1775,22 @@ void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu)
>>>         restart_apic_timer(apic);
>>>  }
>>>
>>> -static void start_apic_timer(struct kvm_lapic *apic)
>>> +static void __start_apic_timer(struct kvm_lapic *apic, u32 count_reg)
>>>  {
>>>         atomic_set(&apic->lapic_timer.pending, 0);
>>>
>>>         if ((apic_lvtt_period(apic) || apic_lvtt_oneshot(apic))
>>> -           && !set_target_expiration(apic))
>>> +           && !set_target_expiration(apic, count_reg))
>>>                 return;
>>>
>>>         restart_apic_timer(apic);
>>>  }
>>>
>>> +static void start_apic_timer(struct kvm_lapic *apic)
>>> +{
>>> +       __start_apic_timer(apic, APIC_TMICT);
>>> +}
>>> +
>>>  static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
>>>  {
>>>         bool lvt0_in_nmi_mode = apic_lvt_nmi_mode(lvt0_val);
>>> @@ -2370,6 +2402,14 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
>>>  int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>>>  {
>>>         memcpy(s->regs, vcpu->arch.apic->regs, sizeof(*s));
>>> +
>>> +       /*
>>> +        * Get calculated timer current count for remaining timer period (if
>>> +        * any) and store it in the returned register set.
>>> +        */
>>> +       __kvm_lapic_set_reg(s->regs, APIC_TMCCT,
>>> +                      __apic_read(vcpu->arch.apic, APIC_TMCCT));
>>> +
>>>         return kvm_apic_state_fixup(vcpu, s, false);
>>>  }
>>>
>>> @@ -2396,7 +2436,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>>>         apic_update_lvtt(apic);
>>>         apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
>>>         update_divide_count(apic);
>>> -       start_apic_timer(apic);
>>> +       __start_apic_timer(apic, APIC_TMCCT);
>>>         apic->irr_pending = true;
>>>         apic->isr_count = vcpu->arch.apicv_active ?
>>>                                 1 : count_vectors(apic->regs + APIC_ISR);
>>> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
>>> index ed0ed39abd369..fadefa1a9d678 100644
>>> --- a/arch/x86/kvm/lapic.h
>>> +++ b/arch/x86/kvm/lapic.h
>>> @@ -147,9 +147,14 @@ static inline u32 kvm_lapic_get_reg(struct kvm_lapic *apic, int reg_off)
>>>         return *((u32 *) (apic->regs + reg_off));
>>>  }
>>>
>>> +static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
>>> +{
>>> +       *((u32 *) (regs + reg_off)) = val;
>>> +}
>>> +
>>>  static inline void kvm_lapic_set_reg(struct kvm_lapic *apic, int reg_off, u32 val)
>>>  {
>>> -       *((u32 *) (apic->regs + reg_off)) = val;
>>> +       __kvm_lapic_set_reg(apic->regs, reg_off, val);
>>>  }
>>>
>>>  extern struct static_key kvm_no_apic_vcpu;
>>> --
>>> 2.19.0.605.g01d371f741-goog
>>>
> 
> Ping?
> 

It's been only a year and a half, but it still applies with only minimal
conflicts so I queued it.  Thanks!

Paolo

