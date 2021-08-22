Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20E83F4159
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 21:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhHVT5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 15:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhHVT5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 15:57:08 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27368C061575
        for <kvm@vger.kernel.org>; Sun, 22 Aug 2021 12:56:27 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id g13so33244972lfj.12
        for <kvm@vger.kernel.org>; Sun, 22 Aug 2021 12:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8EvprDUUqsYUgGbr+CUCRWV+3LEbs3hnD+fZ87zhZtk=;
        b=Yg0NsfcTNyrDqZJOESZ0zS4B8ms6dqrIZBjjTU/jkhkIkNh33wD67YtPQupdsGPWRC
         UtIyQRyUVmLF/ZYwdTmHX+3E4xAPRSJdEAKVb6qPz3JOCjAn98VJ01VnUwL9GUWp+9ND
         fJH8BYww140lSRwIA/ijPyisQhN9ljGkwQpTHvLUAPdQzROE7nr/Asz92pHS1a+j3/FK
         ADGlb4t1KG0ln+eGIvvG+TiZCWSCXaE5x8tGU5ippqNyKMvYC3IHYYLlI3C3xsdcRd2+
         f7qPBX8sc4Dn9QyLu4CGjHJAeZHMVIV9rGq8tr0u0w0lHaKAGDW8tQ9EWFCl/myJYeXp
         j5xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8EvprDUUqsYUgGbr+CUCRWV+3LEbs3hnD+fZ87zhZtk=;
        b=UuiY5AQ0tfdpbpFxHZegroiDhMUsTJG0wl6quvTcgJZ13tUZFauBDzh4H4XXp1Kebn
         tub/1rM7eLvuLbIvS+Uz1tjmfZWDqJmpFfLwGj+5YAtjaXGAuGHL3NreymTt8b/RyJe/
         eNmXBNgXgm2aLCrC5frZZ86PgsZ2mHebskN9nZSZ9YYHTbYUv3bFBF9OIFDxPZP6mdYa
         CtkMAdDFEhlClOV5NzR2ISN+lj95RyI7/Jke0a6ZwALABAjsJV/JClWHKbMjUNBUCtH3
         zOXQ4BGiBmOCGavxE28HGs1lx+hWr3AUH4wsCPU8eoCtLtUyl2/RiefmYeu8nQxWNbb+
         wgsQ==
X-Gm-Message-State: AOAM533gUujOCR2PtyoaxS+tBuK1gTPmVqHAlYeWB5UK1g9osQ+9rWQW
        sEElpb1V+4z73X/R6KMfq6gyISixSq7sbsfPp66Kv94Ucak=
X-Google-Smtp-Source: ABdhPJxK2ZKevjpY+Lj+EO4GHgYci/sC4siRXi3L+At0+wMEzqARiWLLWTshUd5QuzhAUgR2/ZulCBYsQ1zifvUPf1M=
X-Received: by 2002:a19:f718:: with SMTP id z24mr5922854lfe.57.1629662184795;
 Sun, 22 Aug 2021 12:56:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
In-Reply-To: <20210819223640.3564975-1-oupton@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Sun, 22 Aug 2021 12:56:13 -0700
Message-ID: <CAOQ_QsgaACbcW276TAqrmq2E5ne-C2JiEDVGjVXg9-WRds8ZQA@mail.gmail.com>
Subject: Re: [PATCH 0/6] KVM: arm64: Implement PSCI SYSTEM_SUSPEND support
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marc,

On Thu, Aug 19, 2021 at 3:36 PM Oliver Upton <oupton@google.com> wrote:
>
> Certain VMMs/operators may wish to give their guests the ability to
> initiate a system suspend that could result in the VM being saved to
> persistent storage to be resumed at a later time. The PSCI v1.0
> specification describes an SMC, SYSTEM_SUSPEND, that allows a kernel to
> request a system suspend. This call is optional for v1.0, and KVM
> elected to not support the call in its v1.0 implementation.
>
> This series adds support for the SYSTEM_SUSPEND PSCI call to KVM/arm64.
> Since this is a system-scoped event, KVM cannot quiesce the VM on its
> own. We add a new system exit type in this series to clue in userspace
> that a suspend was requested. Per the KVM_EXIT_SYSTEM_EVENT ABI, a VMM
> that doesn't care about this event can simply resume the guest without
> issue (we set up the calling vCPU to come out of reset correctly on next
> KVM_RUN).
>
> Patch 1 is unrelated, and is a fix for "KVM: arm64: Enforce reserved
> bits for PSCI target affinities" on the kvmarm/next branch. Nothing
> particularly hairy, just an unused param.

Title line may not have been clear on this series, Patch 1 is a fix
for the PSCI CPU_ON series that's in kvmarm/next to suppress a
compiler warning.

> Patch 2 simplifies the function to check if KVM allows a particular PSCI
> function. We can generally disallow any PSCI function that sets the
> SMC64 bit in the PSCI function ID.
>
> Patch 3 wraps up the PSCI reset logic used for CPU_ON, which will be
> needed later to queue up a reset on the vCPU that requested the system
> suspend.
>
> Patch 4 brings in the new UAPI and PSCI call, guarded behind a VM
> capability for backwards compatibility.
>
> Patch 5 is indirectly related to this series, and avoids compiler
> reordering on PSCI calls in the selftest introduced by "selftests: KVM:
> Introduce psci_cpu_on_test".

This too is a fix for the PSCI CPU_ON series. Just wanted to raise it
to your attention beyond the new feature I'm working on here.

--
Thanks,
Oliver

> Finally, patch 6 extends the PSCI selftest to verify the
> SYSTEM_SUSPEND PSCI call behaves as intended.
>
> These patches apply cleanly to kvmarm/next at the following commit:
>
> f2267b87ecd5 ("Merge branch kvm-arm64/misc-5.15 into kvmarm-master/next")
>
> The series is intentionally based on kvmarm/next for the sake of fixing
> patches only present there in [1/6] and [5/6]. Tested on QEMU (ick)
> since my Mt. Jade box is out to lunch at the moment and for some unknown
> reason the toolchain on my work computer doesn't play nice with the FVP.
>
> Oliver Upton (6):
>   KVM: arm64: Drop unused vcpu param to kvm_psci_valid_affinity()
>   KVM: arm64: Clean up SMC64 PSCI filtering for AArch32 guests
>   KVM: arm64: Encapsulate reset request logic in a helper function
>   KVM: arm64: Add support for SYSTEM_SUSPEND PSCI call
>   selftests: KVM: Promote PSCI hypercalls to asm volatile
>   selftests: KVM: Test SYSTEM_SUSPEND PSCI call
>
>  arch/arm64/include/asm/kvm_host.h             |   3 +
>  arch/arm64/kvm/arm.c                          |   5 +
>  arch/arm64/kvm/psci.c                         | 134 +++++++++++++-----
>  include/uapi/linux/kvm.h                      |   2 +
>  .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 126 +++++++++++-----
>  5 files changed, 202 insertions(+), 68 deletions(-)
>
> --
> 2.33.0.rc2.250.ged5fa647cd-goog
>
