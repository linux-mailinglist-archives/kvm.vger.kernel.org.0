Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9B03A269E
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 21:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbfH2TBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 15:01:47 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38393 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbfH2TBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 15:01:47 -0400
Received: by mail-io1-f68.google.com with SMTP id p12so9094066iog.5
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 12:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C0GoqTcetNrsUYVAfNmMyDqTNMHiKZd1X2n4rg0Xzqw=;
        b=XzU33u+W1B0k9YCWc5RlZojrPzqvliMOZTJajeaB1y7KqVJuusocLKxgHiaNO1/QB4
         hAxEnYxtc81Lz9kkcPpJICN2SpCCFR2TEihyt7eVSLUADJhMQvJAXRBN0XwoRjBsQSsO
         3iu5LbmRvzsM5DjCuQsVlJaiCbcWdAqJYl+idwcfVXMhI7aWqMoy5SQv0BnG/DPimIoD
         QYYUXdzpkn8Vd7p85TZ5ATinFawqlUJN6Gpx29OJ7EzNEJC9yMJZe5oUZGpqxZ2EVPzB
         7PjEYSdvQA3EamflN9hXPebOSjyyMqyo41yciS2NqD/n2G7F72q/roZ5Y+Y57DuMkHTf
         cPTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C0GoqTcetNrsUYVAfNmMyDqTNMHiKZd1X2n4rg0Xzqw=;
        b=hiTLBkFdSxyQNEnLZdL4RVxC4tGckEtaDjvhLSxw9cYlSI0AfmYOjqW6o0mI1BJkHb
         jGnYuoSk728D3nu+ZxSCLD3CSjVYQcXpXiZq0Pz/HYs44ny6lcUWitH2bLj+cvwOQtle
         2XVr3dq3n1XNF0CKn/sXAZJvlQ2ZV3TNqMTSaWNP9aCt03WqH/iIEs4MOi2kCaKA5KNI
         snzj7SDODH3PwVsPGHpdcZBi/LOFQ9EkADKn7wj9dtTbu2PS04cyVY6ghLY46NBkl7Uw
         1hbC17q0vePYIMEtzMRrGxrjBWOIX3Ho2HxAvGzi6RSUGaBAD+00VDv+bvy2MyEzqMv9
         qslQ==
X-Gm-Message-State: APjAAAXy5Z+cLASLiG/bgDU2ELjqlIi8W5/RicoYPZHiPQFkR+b36TEV
        zjogaRlbHk7EiarmTLZ6h2KrFjEEkX4c32GeemPzbw==
X-Google-Smtp-Source: APXvYqx/Nd1FoK/WJw+5huELXgYRT9e9xB16tDB/tJa16xuUVF91FMNgbcDHx+F/2Bi6FnUbidggsHmYSy3SOhPd92I=
X-Received: by 2002:a5d:8e15:: with SMTP id e21mr6809020iod.296.1567105306039;
 Thu, 29 Aug 2019 12:01:46 -0700 (PDT)
MIME-Version: 1.0
References: <1567056849-14608-1-git-send-email-luwei.kang@intel.com> <1567056849-14608-2-git-send-email-luwei.kang@intel.com>
In-Reply-To: <1567056849-14608-2-git-send-email-luwei.kang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 29 Aug 2019 12:01:34 -0700
Message-ID: <CALMp9eS0-OfAR1=mrvABrOg85V+-yM64KuOff3A1_wCKDYZNxw@mail.gmail.com>
Subject: Re: [RFC v1 1/9] KVM: x86: Add base address parameter for
 get_fixed_pmc function
To:     Luwei Kang <luwei.kang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 10:38 PM Luwei Kang <luwei.kang@intel.com> wrote:
>
> PEBS output Inte PT introduces some new MSRs (MSR_RELOAD_FIXED_CTRx)
> for fixed function counters that use for autoload the preset value
> after writing out a PEBS event.
>
> Introduce base MSRs address parameter to make this function can get
> performance monitor counter structure by MSR_RELOAD_FIXED_CTRx registers.
>
> Signed-off-by: Luwei Kang <luwei.kang@intel.com>
> ---
>  arch/x86/kvm/pmu.h           |  5 ++---
>  arch/x86/kvm/vmx/pmu_intel.c | 14 +++++++++-----
>  2 files changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 58265f7..c62a1ff 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -93,10 +93,9 @@ static inline struct kvm_pmc *get_gp_pmc(struct kvm_pmu *pmu, u32 msr,
>  }
>
>  /* returns fixed PMC with the specified MSR */
> -static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
> +static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr,
> +                                                               int base)
>  {
> -       int base = MSR_CORE_PERF_FIXED_CTR0;
> -
>         if (msr >= base && msr < base + pmu->nr_arch_fixed_counters)
>                 return &pmu->fixed_counters[msr - base];

IIUC, these new MSRs aren't new fixed PMCs, but are values to be
reloaded into the existing fixed PMCs when a PEBS event has been
written. This change makes it look like you are introducing an
additional set of fixed PMCs.
