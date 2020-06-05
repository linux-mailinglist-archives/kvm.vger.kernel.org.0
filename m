Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A8E1EFEA2
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 19:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgFERQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 13:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgFERQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 13:16:21 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4B8C08C5C2
        for <kvm@vger.kernel.org>; Fri,  5 Jun 2020 10:16:21 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id c8so11202029iob.6
        for <kvm@vger.kernel.org>; Fri, 05 Jun 2020 10:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M2DoiL3N8PLmn9uLhfvBWbNohAxFlys4Mkq27kcN6Kc=;
        b=Okspnzrd1e2cu+pXAl0800c5udnBzbjtNe3gaWz6jgdC3P6ABXTtAXRJ+z8JGtxjsp
         iIGXRhiCX8dD3vHfUM75NzOZ6+MputDzUwvEJJjE48pKNB9ZQsHDEvjtJkay2dKP7+Us
         hvYoHtlgjrPzvwL9iHfyVlIVNa6KSHYmcbc+zgQ0MUuW7pn40iwJJlbfRFJDwJSQCYb3
         d3EqhkEk4k0J45+06NODSdXREPElGKLVjlo57ocvnzl5cYe1aCI5q2b12t2MGO8vidnv
         qaf06RTq5zu66oYB10nc4LkspNGeS+FJxuW5ek0tD+LdZOx1UTbtpKi8EHj2l1OGErAQ
         LDeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M2DoiL3N8PLmn9uLhfvBWbNohAxFlys4Mkq27kcN6Kc=;
        b=hr317zihj4PHeLM3nkGKEsv8s9Vid73kdqahx5s718Okn+HXsidOowWk4kdw3lwQcq
         0wT3AAg1f3LOtX2+GEvi+AQx/AhxMW0SSksY+jLVscNkvHb/e5LpO5vBbvJWmZK3Q3Pe
         T255n+m/XmJnb8DJf4nDt5TTSW77ymibAd6wl6yMJJY4ERHVo8Ac288MybqFYTeuKgCO
         rmMoozAioTVBF+7kKAYltDHyGFXvrq07TFDBPEoSPhDB2y0AMRnmx+QEHSIsw+ekwj9X
         oU7LDb3oLzVQLA0nGPY4duz0vTKnNeCwX5hW2OUquF90UP2mueZXx+Ra7bIQYlqwA+yG
         MJWw==
X-Gm-Message-State: AOAM530S0V8vJJvqYVV6JSwYNtwcpWDuYESPWF6NZ9J/bzSsd8b//BPg
        B37mTlZo94vv981GvNGi5DybaO/1IjoLAAcJ6fZiRA==
X-Google-Smtp-Source: ABdhPJyPyx3ITaNlsvuOJzHLVoc4dXrECgaXnMvH9jvGqeXJ4EVIMEfv5i3GsEJQFNA4qqowvDyQVt0C/qGdoJ2IAP8=
X-Received: by 2002:a05:6602:1647:: with SMTP id y7mr9288644iow.75.1591377379827;
 Fri, 05 Jun 2020 10:16:19 -0700 (PDT)
MIME-Version: 1.0
References: <1591321466-2046-1-git-send-email-lirongqing@baidu.com>
 <b70d03dd-947f-dee5-5499-3b381372497d@intel.com> <72a75924-c3cb-6b23-62bd-67b739dec166@redhat.com>
In-Reply-To: <72a75924-c3cb-6b23-62bd-67b739dec166@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 5 Jun 2020 10:16:08 -0700
Message-ID: <CALMp9eSrDehftA5o6tU2sE_098F2ucztYtzhvgguYDnWqwHJaw@mail.gmail.com>
Subject: Re: [PATCH][v6] KVM: X86: support APERF/MPERF registers
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Li RongQing <lirongqing@baidu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        wei.huang2@amd.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 4, 2020 at 11:35 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 05/06/20 07:00, Xiaoyao Li wrote:
> > you could do
> >
> >     bool guest_cpuid_aperfmperf = false;
> >     if (best)
> >         guest_cpuid_aperfmperf = !!(best->ecx & BIT(0));
> >
> >     if (guest_cpuid_aperfmerf != guest_has_aperfmperf(vcpu->kvm))
> >         return -EINVAL;
> >
> >
> > In fact, I think we can do nothing here. Leave it as what usersapce
> > wants just like how KVM treats other CPUID bits.
>
> The reason to do it like Rongqing did is that it's suggested to take the
> output of KVM_GET_SUPPORTED_CPUID and pass it down to KVM_SET_CPUID2.
> Unfortunately we have KVM_GET_SUPPORTED_CPUID as a /dev/kvm (not VM)
> ioctl, otherwise you could have used guest_has_aperfmperf to affect the
> output of KVM_GET_SUPPORTED_CPUID.
>
> I think it's okay however to keep it simple as you suggest.  In this
> case however __do_cpuid_func must not return the X86_FEATURE_APERFMPERF bit.
>
> The guest can instead check for the availability of KVM_CAP_APERFMPERF,
> which is already done in Rongqing's patch.
>
> >> @@ -4930,6 +4939,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >>           kvm->arch.exception_payload_enabled = cap->args[0];
> >>           r = 0;
> >>           break;
> >> +    case KVM_CAP_APERFMPERF:
> >> +        kvm->arch.aperfmperf_mode =
> >> +            boot_cpu_has(X86_FEATURE_APERFMPERF) ? cap->args[0] : 0;
> >
> > Shouldn't check whether cap->args[0] is a valid value?
>
> Yes, only valid values should be allowed.
>
> Also, it should fail with -EINVAL if the host does not have
> X86_FEATURE_APERFMPERF.

Should enabling/disabling this capability be disallowed once vCPUs
have been created?
