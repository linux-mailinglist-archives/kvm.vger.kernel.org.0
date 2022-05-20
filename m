Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C3F52E401
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 06:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345400AbiETEtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 00:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345397AbiETEto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 00:49:44 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CBD13C341
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 21:49:42 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id s28so9733541wrb.7
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 21:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qp/BBMxdc754d+bzk849z71FeQFIlWgSw30xEOvYyvU=;
        b=TYvWNgC4BfbVbjK1SlClNDynJbkU3Eq8sMH449G4Ua6TOsN+O+jT4pHj5nD9uYmkFx
         57ZeJDPNlZSG3ZAwnJOYHmGY8OKOMDlIkXPfWu8GEFQCo2VqPkjcg/M/x4RUgFNMX5lK
         5zFuAT5EEaVDkZrXUzDF+WzUv7cT4TE3j6tGtie/tfKN4t+kbwcGhhbZ3xzTG1WNO9YV
         dNlyrL4jMNdQXD3PQdqA7EF5esuccsuwtxTvVgOCKCk4vQy0TSiEVv9SjyaRRR+Q8rVa
         a8l/aKewy7JqLeAQ9KVPAvLqZlz7vE/ZIYeQogxPy2WEAKTp4rc0db0kGi51rJKrQj7b
         XbuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qp/BBMxdc754d+bzk849z71FeQFIlWgSw30xEOvYyvU=;
        b=5Dkff1q58YUZVKdoqZAX94ka8HPyYopToR1UjYYt9kxqTg2KJJ5QSS31R6qryl4/5K
         CVocjxIWNUN1MQiKQlwpaQ4pq3OHYe/xt6IeSv898d2UrJP28I5ooTCw7boSAX0CrJWZ
         +Ac3Pj8jkgjGv+Mn7CpHhnmrZZt8aPOi9kNZco+Q98II6JnB+SqrxQrGae/UPnHEXll9
         sSw4ulfelpFT2QOcgKjEueeSu1a2n5eNon7jaXI+dPX5yeIf5AS3Jnb0a9T9MCbW0485
         WHMkFHOOLxfZfdAoBhTeU2LsoQOuQ8AVjqTYl35Hw7U3wT+tJBcXYQLBr45knwqqTIru
         7ukw==
X-Gm-Message-State: AOAM532Jlzw1sQXZgW6P7r1VVLYOQaKJN8uUZ1XNU/KYfuHu5K2V16vG
        xRXcSZskHCp2PGEsIK81QsiCWS1tUDrcDpLMfcTaZg==
X-Google-Smtp-Source: ABdhPJzeAQDXB7LmBuO8hhje7e3q5B2NpjBDa2j8fa5MDZk1nAgROuJdGY8JwMp7w7Wy603wc6IO/j1S5rad8YwrCHQ=
X-Received: by 2002:a5d:6c6b:0:b0:1ea:77ea:dde8 with SMTP id
 r11-20020a5d6c6b000000b001ea77eadde8mr6663471wrz.690.1653022180980; Thu, 19
 May 2022 21:49:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhSdy0V3RziZOXe2UMfpAxmTYn1XpJJTQe5q2FdrmU_3zH+sQ@mail.gmail.com>
In-Reply-To: <CAAhSdy0V3RziZOXe2UMfpAxmTYn1XpJJTQe5q2FdrmU_3zH+sQ@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 20 May 2022 10:19:28 +0530
Message-ID: <CAAhSdy2y9MCMxDpYzbRA-ak035qFJ5nm7ZBfqGes2mBMzLmx_g@mail.gmail.com>
Subject: Re: KVM/riscv changes for 5.19
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022 at 10:15 AM Anup Patel <anup@brainfault.org> wrote:
>
> Hi Paolo,
>
> We have following KVM RISC-V changes for 5.19:
> 1) Added Sv57x4 support for G-stage page table
> 2) Added range based local HFENCE functions
> 3) Added remote HFENCE functions based on VCPU requests
> 4) Added ISA extension registers in ONE_REG interface
> 5) Updated KVM RISC-V maintainers entry to cover selftests support
>
> I don't expect any other KVM RISC-V changes for 5.19.
>
> Please pull.

Forgot to add "[GIT PULL]" subject prefix. Please ignore this email.

I have sent it again with the correct subject.

Regards,
Anup

>
> Regards,
> Anup
>
> The following changes since commit 42226c989789d8da4af1de0c31070c96726d990c:
>
>   Linux 5.18-rc7 (2022-05-15 18:08:58 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-5.19-1
>
> for you to fetch changes up to fed9b26b2501ea0ce41ae3a788bcc498440589c6:
>
>   MAINTAINERS: Update KVM RISC-V entry to cover selftests support
> (2022-05-20 09:09:23 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 5.19
>
> - Added Sv57x4 support for G-stage page table
> - Added range based local HFENCE functions
> - Added remote HFENCE functions based on VCPU requests
> - Added ISA extension registers in ONE_REG interface
> - Updated KVM RISC-V maintainers entry to cover selftests support
>
> ----------------------------------------------------------------
> Anup Patel (9):
>       KVM: selftests: riscv: Improve unexpected guest trap handling
>       RISC-V: KVM: Use G-stage name for hypervisor page table
>       RISC-V: KVM: Add Sv57x4 mode support for G-stage
>       RISC-V: KVM: Treat SBI HFENCE calls as NOPs
>       RISC-V: KVM: Introduce range based local HFENCE functions
>       RISC-V: KVM: Reduce KVM_MAX_VCPUS value
>       RISC-V: KVM: Add remote HFENCE functions based on VCPU requests
>       RISC-V: KVM: Cleanup stale TLB entries when host CPU changes
>       MAINTAINERS: Update KVM RISC-V entry to cover selftests support
>
> Atish Patra (1):
>       RISC-V: KVM: Introduce ISA extension register
>
> Jiapeng Chong (1):
>       KVM: selftests: riscv: Remove unneeded semicolon
>
>  MAINTAINERS                                        |   2 +
>  arch/riscv/include/asm/csr.h                       |   1 +
>  arch/riscv/include/asm/kvm_host.h                  | 124 +++++-
>  arch/riscv/include/uapi/asm/kvm.h                  |  20 +
>  arch/riscv/kvm/main.c                              |  11 +-
>  arch/riscv/kvm/mmu.c                               | 264 ++++++------
>  arch/riscv/kvm/tlb.S                               |  74 ----
>  arch/riscv/kvm/tlb.c                               | 461 +++++++++++++++++++++
>  arch/riscv/kvm/vcpu.c                              | 144 ++++++-
>  arch/riscv/kvm/vcpu_exit.c                         |   6 +-
>  arch/riscv/kvm/vcpu_sbi_replace.c                  |  40 +-
>  arch/riscv/kvm/vcpu_sbi_v01.c                      |  35 +-
>  arch/riscv/kvm/vm.c                                |   8 +-
>  arch/riscv/kvm/vmid.c                              |  30 +-
>  .../selftests/kvm/include/riscv/processor.h        |   8 +-
>  tools/testing/selftests/kvm/lib/riscv/processor.c  |  11 +-
>  tools/testing/selftests/kvm/lib/riscv/ucall.c      |  31 +-
>  17 files changed, 965 insertions(+), 305 deletions(-)
>  delete mode 100644 arch/riscv/kvm/tlb.S
>  create mode 100644 arch/riscv/kvm/tlb.c
