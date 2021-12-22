Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08B747CE79
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 09:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243458AbhLVIvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 03:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243448AbhLVIvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 03:51:13 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65C0C061401
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 00:51:12 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id v138so4536449ybb.8
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 00:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m4bMyDhMjrW7YP3vP6EP7M7Hq9hif6A8RG1x3CwDWSE=;
        b=fOPoQSfg9A1N9bBJuTfwQYXKk80Zk1ZWyIC4Djoo7itH4idBIrSa68ZFFbjZBI8KXj
         obOL3n3EoCAvAfhwLF7wegn2J6fL3D5MaoQ+j7OkMDRoXYBflLXTn96N1l97z+rpu1fJ
         nbVKBgDZeRegAG2HqwRHfylaBAmiIwpWWr8Mg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m4bMyDhMjrW7YP3vP6EP7M7Hq9hif6A8RG1x3CwDWSE=;
        b=oiwjwjv7As0dNKiWHjQRty+Lpn8jiG5FYwBqLE9vW0/yGuMARAWoU7H9LmwXHwn5GL
         t7SdqWEBpOoqUlP5EvXifJmrS94QniGGUWvzJgZgFYA1a10Y5sTrnfFDS3krNsbH+naY
         aWeeH2B41xSatCXezG0S5X9KCpu6b/YQI/bL/zO78WlC9vbGCoPeZD6Ulyh5ZY4tgOl0
         yX9cLUIqxW0RDAqcT0xuAUSM4S1QHofwdcXQ3EtQQOIBkqsTIF2G1R47X4PM1/yEseGl
         mQmtjmXjXIRKWHkWIkyGbN529CYDUB9q9uuBh2pS8BXCtIWDL3m5RbwHGMxu735kY5O3
         ossQ==
X-Gm-Message-State: AOAM530L/CapQaOtAfSGnt2FRIE3IgStMZaOAyQMnJrce8b/1aMrQily
        7dfyimP2exvFc1RAicp8Ck4sFR2lQziQrxZx6vFL
X-Google-Smtp-Source: ABdhPJzdC7YX0iNUuQiVueEYuv3Xd0/ROt59yvLbD0RAiuHFxH0gOhyt+/pTp0f+VcjsQnQX34B36SNPf+yH6w2i6g8=
X-Received: by 2002:a05:6902:568:: with SMTP id a8mr3252723ybt.472.1640163071850;
 Wed, 22 Dec 2021 00:51:11 -0800 (PST)
MIME-Version: 1.0
References: <20211129075451.418122-1-anup.patel@wdc.com>
In-Reply-To: <20211129075451.418122-1-anup.patel@wdc.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Wed, 22 Dec 2021 00:51:01 -0800
Message-ID: <CAOnJCULms0Xn3d4d9Rb90L0ACn7iJj9e4OQmxL_ACbirMX4K1w@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] KVM RISC-V 64-bit selftests support
To:     Anup Patel <anup.patel@wdc.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 12:10 AM Anup Patel <anup.patel@wdc.com> wrote:
>
> This series adds initial support for testing KVM RISC-V 64-bit using
> kernel selftests framework. The PATCH1 & PATCH2 of this series does
> some ground work in KVM RISC-V to implement RISC-V support in the KVM
> selftests whereas remaining patches does required changes in the KVM
> selftests.
>
> These patches can be found in riscv_kvm_selftests_v2 branch at:
> https://github.com/avpatel/linux.git
>
> Changes since v1:
>  - Renamed kvm_sbi_ext_expevend_handler() to kvm_sbi_ext_forward_handler()
>    in PATCH1
>  - Renamed KVM_CAP_RISCV_VM_GPA_SIZE to KVM_CAP_VM_GPA_BITS in PATCH2
>    and PATCH4
>
> Anup Patel (4):
>   RISC-V: KVM: Forward SBI experimental and vendor extensions
>   RISC-V: KVM: Add VM capability to allow userspace get GPA bits
>   KVM: selftests: Add EXTRA_CFLAGS in top-level Makefile
>   KVM: selftests: Add initial support for RISC-V 64-bit
>
>  arch/riscv/include/asm/kvm_host.h             |   1 +
>  arch/riscv/kvm/mmu.c                          |   5 +
>  arch/riscv/kvm/vcpu_sbi.c                     |   4 +
>  arch/riscv/kvm/vcpu_sbi_base.c                |  27 ++
>  arch/riscv/kvm/vm.c                           |   3 +
>  include/uapi/linux/kvm.h                      |   1 +
>  tools/testing/selftests/kvm/Makefile          |  14 +-
>  .../testing/selftests/kvm/include/kvm_util.h  |  10 +
>  .../selftests/kvm/include/riscv/processor.h   | 135 +++++++
>  tools/testing/selftests/kvm/lib/guest_modes.c |  10 +
>  .../selftests/kvm/lib/riscv/processor.c       | 362 ++++++++++++++++++
>  tools/testing/selftests/kvm/lib/riscv/ucall.c |  87 +++++
>  12 files changed, 658 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/include/riscv/processor.h
>  create mode 100644 tools/testing/selftests/kvm/lib/riscv/processor.c
>  create mode 100644 tools/testing/selftests/kvm/lib/riscv/ucall.c
>
> --
> 2.25.1
>

For the entire series,
Tested-by: Atish Patra <atishp@rivosinc.com>

-- 
Regards,
Atish
