Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43748468909
	for <lists+kvm@lfdr.de>; Sun,  5 Dec 2021 05:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhLEEPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Dec 2021 23:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhLEEPP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Dec 2021 23:15:15 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3067C061751
        for <kvm@vger.kernel.org>; Sat,  4 Dec 2021 20:11:48 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id w15-20020a4a9d0f000000b002c5cfa80e84so3326109ooj.5
        for <kvm@vger.kernel.org>; Sat, 04 Dec 2021 20:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=H3UttX7wAmIxqwLf4hGdEXVZGemv+gyE0LjHWsvvA/U=;
        b=lFSEUZPL28migNPz3ESVhAgnv6+QvyQxPlwoompSiiJjyaxnjPoVk5DCfBuJ5EXogP
         dLUROF69tERFYRhJyUJOkMV+r7eaQ59PqviXkQ9OHOgmGjzMvSQ4rIVKFWdQAoR20Fju
         t/Oi+S49DBVEIcj0NQBTruVasp2UbtY9vphBTCOQzAo5zg+PTry1vOzuAJ3Ok/eqE4h2
         tz9Zx3Hgm4EaNJCZz/YP6bCVQEO0fYPK92byZckqwY7QwPp38jMDIHpKYFc5V2YXrPCv
         s382T3QR0Ejx+lB4TOikD3+u6n93iwGLsXZjzk2pgQeoKTZknNW6DwIdSgEih3n0GuGp
         pmJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H3UttX7wAmIxqwLf4hGdEXVZGemv+gyE0LjHWsvvA/U=;
        b=D5tKr/B6xW1sTK9gEKEANWRP+M83WtY2TEdAvty/njXuNx56F5lCex+1wt5+OcxBSc
         j/lTAYfFitX+prmVtRdyWrBNt1hdjca+CbdxoJOylBEOvO3zsINKE7eBl3S6NzeUucxI
         dHIR5oCPuFOnAG448pUHs97MpAyva2rwkw2bd+FgViMZW7loi1syErLMgZzXwRN8zYBF
         +9oAuK3DYfWy3yq6m5xQhEnJzgZrqVnRjqAtnBTU/IDG6cYEuMg81hlBBLBSGOJAn5Cc
         hGIIcxiQUtK6uDIVHRDPFlLuz9C/iNTYFM5juywpbfdt7M4iTIvSrGKzT0r64N26G6rB
         lYuw==
X-Gm-Message-State: AOAM530V9bfi+sviOPU3H0LbM5KellZ7lM0TuE5SdBDlBNmyu1o1xrg/
        t91RpdArxRgbnCMJJbR37ZW2g4McVTsRqEgRjuEx122hhaY=
X-Google-Smtp-Source: ABdhPJzYSZ7Kv0pPygFh1NUobFVfks3uQ8v8Sj9qVyFm7aMcjeBoTBHffDNXaycMWQuaFsyhdPJR5cLKOynB5ZABVwg=
X-Received: by 2002:a4a:3042:: with SMTP id z2mr18368879ooz.47.1638677507931;
 Sat, 04 Dec 2021 20:11:47 -0800 (PST)
MIME-Version: 1.0
References: <CAMjwK+d_H2qYjMjdQo=0ouz87u1XS1Cv+daLRj9_jLe6_FOkQw@mail.gmail.com>
In-Reply-To: <CAMjwK+d_H2qYjMjdQo=0ouz87u1XS1Cv+daLRj9_jLe6_FOkQw@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 4 Dec 2021 20:11:37 -0800
Message-ID: <CALMp9eQEhtKoMrBo0pW_H6XNNxvzmJv6SZ_s_2JDJnhv5Wsj5Q@mail.gmail.com>
Subject: Re: Trap and Emulate RDTSC Instructions
To:     =?UTF-8?Q?Musa_=C3=9Cnal?= <umusasadik@gmail.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 4, 2021 at 6:09 AM Musa =C3=9Cnal <umusasadik@gmail.com> wrote:
>
> Hello all,
> For an academic project we need to trap and emulate each RDTSC
> instruction executed in a virtual machine. (Our main aim is to
> calculate how many rdtsc instructions are executed in a virtual
> machine.) Currently we can intercept each of them. But we have a
> problem to give the correct tsc values (values are not stable). So we
> don't want to mess up the rdtsc reads. We just need to count rdtscs.
> Our current approach looks like this.
>
> static int handle_rdtsc(struct kvm_vcpu *vcpu)
> {
> counter +=3D 1;

Where is this counter? Shouldn't it be per-VCPU (or per-VM and
incremented atomically)?

> vcpu->arch.regs[VCPU_REGS_RAX] =3D (rdtsc() - VM_EXIT_COS) & -1u;
> vcpu->arch.regs[VCPU_REGS_RDX] =3D ((rdtsc() -  VM_EXIT_COST) >> 32) & -1=
u;

It looks like you want guest time to stop while the logical processor
is in kvm handling a RDTSC exit. Stopping guest time is not as easy as
just stopping the TSC. The guest has multiple clocks, and if you want
to stop guest time, you need to stop them all. Otherwise, some agent
in the guest is likely to conclude that your TSC is broken. Moreover,
even just stopping the TSC isn't this easy. If, for example, the guest
has set the IA32_TSC_DEADLINE MSR to trigger an interrupt at some
point in the future, then kvm has no doubt armed an hrtimer in the
host kernel to go off at the specified time. If you stop the guest
TSC, you need to change that hrtimer, or it will fire too early.
Furthermore, if your guest has network access, good luck! At the very
least, ntp or other network time services are going to be very
unhappy.

All of these issues aside, you don't even have the right adjustment
here to make this RDTSC-handling time disappear. Even if VM-entry and
VM-exit costs were deterministic and fixed--which they aren't--you
need to accumulate adjustments over multiple RDTSC VM-exits. Something
like:

adjustment =3D counter * VM_EXIT_COST + (counter - 1) * VM_ENTRY_COST;

> return skip_emulated_instruction(vcpu);
>
> }
>
> VM_EXIT_COST calculated by how many clock cycles are executed during
> host to guest transition (for RDTSC exits only). Can KVM handle these

I assume you mean guest to host transition for VM_EXIT_COST. Host to
guest transition would be VM_ENTRY_COST.

> operations built-in or do you have any idea how we can achieve this?

I'd suggest running the guest under qemu with tcg emulation rather
than kvm acceleration, and just adding your counter to qemu's
helper_rdtsc().
