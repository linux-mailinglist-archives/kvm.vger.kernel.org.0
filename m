Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0FF2A3E05
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 08:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgKCHux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 02:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCHux (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 02:50:53 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5257FC0613D1
        for <kvm@vger.kernel.org>; Mon,  2 Nov 2020 23:50:53 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id v6so20844822lfa.13
        for <kvm@vger.kernel.org>; Mon, 02 Nov 2020 23:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pdch/+8NScTpJ/wP0mR4qWDZ1zEnJckVrsyJZx+35/Q=;
        b=duMnO75wrfHgd1QkuU4aSPOMwgKf5Ke2aZlBdEQ1rzNQNcPE0JDoYnuNVJl2d0fQ31
         y0UBNX2PcOBNI6Eo+lApHr7Vztdwk0G4svmxuYlT84VyeRgCOBeIzyuxlcSsRf1t4EFT
         lg5fWmKWtqwVC/pTc3m9CZaSDX9ACOWvM5rG3BgC283aebab/MRJeWcWoj54csb1C9AO
         uhknpNGk3t4lRma1WORHli4/zP7n4q0b0C6P4hE5AX7jhtHaKiKg2gYTCBNw+IHh2W77
         JubW2AyKzTVNaW/DFY0nU2XsZBiVczbwot+5t3/6GCfD1BxdIVxDYuftr5VSPbtRyJaA
         dtMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pdch/+8NScTpJ/wP0mR4qWDZ1zEnJckVrsyJZx+35/Q=;
        b=Yv5BNTEZaIpOhqisieGSYK/C657JkNFewhaxucuZ+dBIU3DuOyzas/AqqPHRmqBZ5Y
         ZCHR/TgNTzoxYzBD/Kv6pEO9mj1T877vLJF6W5AtUZAmj+90SL5bsJh5bHpaVcPkzZ/2
         VT31atwSue29r0tz1Xm+v127sVaLeZ2zPtC4ulRh0fqjECV8yeBGK6tC/4m8sFVO/QDm
         M6EdWfVm4OiT9IIC+uLSQHMN1Z7mc0Hrsve6OHc9fUb14OchifJxQLopvgDgjZ/i+RKm
         KlmVxa7xM5GOvEBLtE6Jz/KXlaml2Zhh65LLrhaTMpJr4M2p3q4gHCWIcssQxzx1WhPj
         41Qg==
X-Gm-Message-State: AOAM532utNxZKuL7zQYyGUeW18FlBgyMEl52OpI4uBrpr172Z7ciRb3c
        rmeRpC8YD4xDJvAOQOPXDoiwmWop51A7MtZ9HWm6TkQJEHjWeA==
X-Google-Smtp-Source: ABdhPJy7gVBIytHZGjeKFFHVSM4DM35oToxB9tea31NXyHRxZ+nh75es7Ccd5QUe7l8Ud7KXRJe6PvaYr80vE+uoi4A=
X-Received: by 2002:a05:6512:204:: with SMTP id a4mr6662830lfo.310.1604389851308;
 Mon, 02 Nov 2020 23:50:51 -0800 (PST)
MIME-Version: 1.0
References: <20201027231044.655110-1-oupton@google.com>
In-Reply-To: <20201027231044.655110-1-oupton@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 2 Nov 2020 23:50:40 -0800
Message-ID: <CAOQ_Qsha88cZuasbjN3FodmNsWyc+B9mN+YozrD7ONMJCcBjVQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] Some fixes and a test for KVM_CAP_ENFORCE_PV_CPUID
To:     kvm list <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Friendly ping (this series contains bugfixes)

On Tue, Oct 27, 2020 at 4:10 PM Oliver Upton <oupton@google.com> wrote:
>
> Patches 1-2 address some small issues with documentation and the kvm selftests,
> unrelated to the overall intent of this series.
>
> Patch 3 applies the same PV MSR filtering mechanism to guest reads of KVM
> paravirt msrs.
>
> Patch 4 makes enabling KVM_CAP_ENFORCE_PV_FEATURE_CPUID idempotent with regards
> to when userspace sets the guest's CPUID, ensuring that the cached copy of
> KVM_CPUID_FEATURES.EAX is always current.
>
> Patch 5 fixes a regression introduced with KVM_CAP_ENFORCE_PV_CPUID, wherein
> the kvm masterclock isn't updated every time the guest uses a different system
> time msr than before.
>
> Lastly, Patch 6 introduces a test for the overall paravirtual restriction
> mechanism, verifying that guests GP when touching MSRs they shouldn't and
> get -KVM_ENOSYS when using restricted kvm hypercalls. Please note that this test
> is dependent upon patches 1-3 of Aaron's userspace MSR test, which add support
> for guest handling of the IDT in KVM selftests [1].
>
> This series (along with Aaron's aforementioned changes) applies to
> commit 77377064c3a9 ("KVM: ioapic: break infinite recursion on lazy
> EOI").
>
> [1] http://lore.kernel.org/r/20201012194716.3950330-1-aaronlewis@google.com
>
> Oliver Upton (6):
>   selftests: kvm: add tsc_msrs_test binary to gitignore
>   Documentation: kvm: fix ordering of msr filter, pv documentation
>   kvm: x86: reads of restricted pv msrs should also result in #GP
>   kvm: x86: ensure pv_cpuid.features is initialized when enabling cap
>   kvm: x86: request masterclock update any time guest uses different msr
>   selftests: kvm: test enforcement of paravirtual cpuid features
>
>  Documentation/virt/kvm/api.rst                |   4 +-
>  arch/x86/kvm/cpuid.c                          |  23 +-
>  arch/x86/kvm/cpuid.h                          |   1 +
>  arch/x86/kvm/x86.c                            |  38 ++-
>  tools/testing/selftests/kvm/.gitignore        |   2 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../testing/selftests/kvm/include/kvm_util.h  |   2 +
>  .../selftests/kvm/include/x86_64/processor.h  |  12 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  28 +++
>  .../selftests/kvm/lib/x86_64/processor.c      |  29 +++
>  .../selftests/kvm/x86_64/kvm_pv_test.c        | 234 ++++++++++++++++++
>  11 files changed, 364 insertions(+), 10 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
>
> --
> 2.29.0.rc2.309.g374f81d7ae-goog
>
