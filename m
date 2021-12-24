Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB9A47ECC9
	for <lists+kvm@lfdr.de>; Fri, 24 Dec 2021 08:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351903AbhLXHij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Dec 2021 02:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351906AbhLXHie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Dec 2021 02:38:34 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BDCC061757
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 23:38:34 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id s1so16042447wra.6
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 23:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zehQu19sG8zPf6sTX7xbu4Pim5UWCx0QpvBAMXBdZsM=;
        b=Kc7Vq0z4QdQj5VZQWUJruEHr1vXWKQiy/GE0lgTeAHMJ4QcMlUr277gJ16+XTFn0sT
         bCYygv81STggBYOWNbKSVNP33Mf5gaXHpN6prAkGu49yN9Lc1a2AzJgDyFm+L/j6TY8J
         1TbfOhCJ5PL1CYsdhIUw1iNEc/OPIHjiNth0Rd3IIw0HtxMXHgeiVcCbcoedWKe3Uggb
         Y2P8QXdgyVAnBvghox7tN127eJJHfkYWyxMcYTGkjEHmnvin+ATSuiQ0GcZRWkcgnbPB
         UTMntwFq2Ch2n6jpZn4siAdn3phBB2Lpu8GsYvDbAQAPw6gIQzgS1cCMh0/dWS8B/KRf
         N2lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zehQu19sG8zPf6sTX7xbu4Pim5UWCx0QpvBAMXBdZsM=;
        b=XGjhjexO4kuU4cOa1bBO6ySNt7JTkcKfn7Mqhw9nc5AANt6MCI/hFcQG4YoNPi10R8
         S+QneODhv/KQFgzXZtAWInAjqiuen6I+UHrrmGlVoGlOYk/oxo1Or3ndee3tsVjlecdW
         x0ckqumTryoJl6hXqkLW0KHdAQvBFBR6Lvjuv0udAHUfx2IN2EoWveFJYKw478oByqR0
         TNghK6O77JELeJ1u0zTlif6Lzu3YgeesZL9d6UVkd6pjeFVuz1E+w1+eQCUOBiYQ54R3
         1TdLM3ALXyYkw3W4QMy9vv3O13xrxylIGETv4idHSY3OfGPZ2IfHpQY8svw+fSz8G1Jt
         ASeQ==
X-Gm-Message-State: AOAM5334GPOehVfyGi4SbiEMhGzr4Doi0ffrOyZsZtYdAePk6f538/H4
        nCOIB4KOBfemF/YKPPB1O3LnlurfhHpr9OC8srvWJw==
X-Google-Smtp-Source: ABdhPJyl+RLF9H+jUZa+5CGrWYy5DZy8pF9QpRofT4U/ZZybydpgrPxqo7pr1Asa3GRAZQ7HMCHf7E3gnAL6mmS40iw=
X-Received: by 2002:a5d:4d91:: with SMTP id b17mr3999415wru.214.1640331512744;
 Thu, 23 Dec 2021 23:38:32 -0800 (PST)
MIME-Version: 1.0
References: <20211224073604.1085464-1-anup.patel@wdc.com>
In-Reply-To: <20211224073604.1085464-1-anup.patel@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 24 Dec 2021 13:08:21 +0530
Message-ID: <CAAhSdy2Gm96UVZhFMmbER+trrMgi-gFCpMvURR9Thb8NiNd88g@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] KVM RISC-V 64-bit selftests support
To:     Anup Patel <anup.patel@wdc.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All,

On Fri, Dec 24, 2021 at 1:06 PM Anup Patel <anup.patel@wdc.com> wrote:
>
> This series adds initial support for testing KVM RISC-V 64-bit using
> kernel selftests framework. The PATCH1 & PATCH2 of this series does
> some ground work in KVM RISC-V to implement RISC-V support in the KVM
> selftests whereas remaining patches does required changes in the KVM
> selftests.
>
> These patches can be found in riscv_kvm_selftests_v3 branch at:
> https://github.com/avpatel/linux.git

This is actually v3 series so please ignore the "PATCH v4" subject prefix.

Regards,
Anup

>
> Changes since v2:
>  - Rebased series on Linux-5.16-rc6
>  - Renamed kvm_riscv_stage2_gpa_size() to kvm_riscv_stage2_gpa_bits()
>    in PATCH2
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
