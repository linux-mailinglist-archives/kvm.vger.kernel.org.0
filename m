Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188944879D8
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 16:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348130AbiAGPnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 10:43:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348126AbiAGPnl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 10:43:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641570220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xLApLSkD2tnkzqx7aoXrE25bXex4a2vpZpy1QnhSBFE=;
        b=EF+kXB0Onsorqh/VKS1RLZExJYW7xWv0DU6dnze2o/HJJp7s2QC01axazuPqeFtljecTkN
        iq20g3xmbHb2KgV4Fue86r/9H3ekcNNfcO/6TWtmWQT6ayO8bpDfc0PHiK7uOi4P7nRq6Q
        NGRCNeTJXMfVqlRY2qo4FKGoyETBZiY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-xwsyNjgcPB6jSSjIjDo51A-1; Fri, 07 Jan 2022 10:43:39 -0500
X-MC-Unique: xwsyNjgcPB6jSSjIjDo51A-1
Received: by mail-ed1-f71.google.com with SMTP id dz8-20020a0564021d4800b003f897935eb3so4992038edb.12
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 07:43:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xLApLSkD2tnkzqx7aoXrE25bXex4a2vpZpy1QnhSBFE=;
        b=q6gFqMwUqokCF1vaeVJ27m3lmv1BJ8zp00l7yPmkiAXDQUD37tHqIVy+G5p62n963y
         toYtZfAkYRibskFTlOfqDmMXu0MxRmCLP6+mtYY0ipYoB93yxemwhnIFI1j9w3RGJUx9
         E7vm09XS74sluEHWLhHUg3bjwy1Pbf/3Ru7gVnkzHrt5uy5uH5wjA6YPVlxzsj36lBR8
         Ysp7CeTPVZC5hXBFXUrPqsj6NG1u2CLTJGDYhh5KXG2k1cVQZMn0Sz8TnSnZM0E9/8gW
         DehP0Drn3RkNuFkREEJaBT6XSfOJlmjRvoDn4+nB9oke/YU7hJDrlgcErG33XsMJSyda
         cWcw==
X-Gm-Message-State: AOAM530peuiqVfwMf5gXp4Idb3dqaaRzTAy4QUmJ+BkHL9/IMusbD9Oo
        IRWwEH/vKW7DV8RKWROuYZvrS4ist9goFr3IbLU2qOc7sFe5GRMWUCr0VfTPSPCE19PwuAiVs9p
        Sx8SD+lTi4KhW
X-Received: by 2002:a17:907:961c:: with SMTP id gb28mr49410034ejc.385.1641570217885;
        Fri, 07 Jan 2022 07:43:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwuHgNBYCw3FFcW3eQJ8shP/R+L2QCQpOod+A/9z88SLM/oJpVx1fVYsU+6h62mFlJQkskP8A==
X-Received: by 2002:a17:907:961c:: with SMTP id gb28mr49410027ejc.385.1641570217668;
        Fri, 07 Jan 2022 07:43:37 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id b10sm2219207edu.42.2022.01.07.07.43.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 07:43:37 -0800 (PST)
Message-ID: <806cc760-8e49-62a4-7bab-7149e9c95d33@redhat.com>
Date:   Fri, 7 Jan 2022 16:43:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [GIT PULL] KVM/riscv changes for 5.17, take #1
Content-Language: en-US
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy2iRgCBt=6t2p5AE_Rq18s2QcRoM62ZAGiAcn5A6TfB4w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhSdy2iRgCBt=6t2p5AE_Rq18s2QcRoM62ZAGiAcn5A6TfB4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/22 14:21, Anup Patel wrote:
> Hi Palao,
> 
> This is the first set of changes for 5.17. We have two new
> features for KVM RISC-V:
> 1) SBI v0.2 support and
> 2) Initial kvm selftest support.
> 
> Please pull.

Pulled, thanks!

Paolo

> Regards,
> Anup
> 
> The following changes since commit 5e4e84f1124aa02643833b7ea40abd5a8e964388:
> 
>    Merge tag 'kvm-s390-next-5.17-1' of
> git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
> (2021-12-21 12:59:53 -0500)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-riscv/linux.git tags/kvm-riscv-5.17-1
> 
> for you to fetch changes up to 497685f2c743f552ec5626d60fc12e7c00faaf06:
> 
>    MAINTAINERS: Update Anup's email address (2022-01-06 15:18:22 +0530)
> 
> ----------------------------------------------------------------
> KVM/riscv changes for 5.17, take #1
> 
> - Use common KVM implementation of MMU memory caches
> - SBI v0.2 support for Guest
> - Initial KVM selftests support
> - Fix to avoid spurious virtual interrupts after clearing hideleg CSR
> - Update email address for Anup and Atish
> 
> ----------------------------------------------------------------
> Anup Patel (5):
>        RISC-V: KVM: Forward SBI experimental and vendor extensions
>        RISC-V: KVM: Add VM capability to allow userspace get GPA bits
>        KVM: selftests: Add EXTRA_CFLAGS in top-level Makefile
>        KVM: selftests: Add initial support for RISC-V 64-bit
>        MAINTAINERS: Update Anup's email address
> 
> Atish Patra (6):
>        RISC-V: KVM: Mark the existing SBI implementation as v0.1
>        RISC-V: KVM: Reorganize SBI code by moving SBI v0.1 to its own file
>        RISC-V: KVM: Add SBI v0.2 base extension
>        RISC-V: KVM: Add v0.1 replacement SBI extensions defined in v0.2
>        RISC-V: KVM: Add SBI HSM extension in KVM
>        MAINTAINERS: Update Atish's email address
> 
> Jisheng Zhang (1):
>        RISC-V: KVM: make kvm_riscv_vcpu_fp_clean() static
> 
> Sean Christopherson (1):
>        KVM: RISC-V: Use common KVM implementation of MMU memory caches
> 
> Vincent Chen (1):
>        KVM: RISC-V: Avoid spurious virtual interrupts after clearing hideleg CSR
> 
>   .mailmap                                           |   2 +
>   MAINTAINERS                                        |   4 +-
>   arch/riscv/include/asm/kvm_host.h                  |  11 +-
>   arch/riscv/include/asm/kvm_types.h                 |   2 +-
>   arch/riscv/include/asm/kvm_vcpu_sbi.h              |  33 ++
>   arch/riscv/include/asm/sbi.h                       |   9 +
>   arch/riscv/kvm/Makefile                            |   4 +
>   arch/riscv/kvm/main.c                              |   8 +
>   arch/riscv/kvm/mmu.c                               |  71 +---
>   arch/riscv/kvm/vcpu.c                              |  28 +-
>   arch/riscv/kvm/vcpu_fp.c                           |   2 +-
>   arch/riscv/kvm/vcpu_sbi.c                          | 213 ++++++------
>   arch/riscv/kvm/vcpu_sbi_base.c                     |  99 ++++++
>   arch/riscv/kvm/vcpu_sbi_hsm.c                      | 105 ++++++
>   arch/riscv/kvm/vcpu_sbi_replace.c                  | 135 ++++++++
>   arch/riscv/kvm/vcpu_sbi_v01.c                      | 126 +++++++
>   arch/riscv/kvm/vm.c                                |   3 +
>   include/uapi/linux/kvm.h                           |   1 +
>   tools/testing/selftests/kvm/Makefile               |  14 +-
>   tools/testing/selftests/kvm/include/kvm_util.h     |  10 +
>   .../selftests/kvm/include/riscv/processor.h        | 135 ++++++++
>   tools/testing/selftests/kvm/lib/guest_modes.c      |  10 +
>   tools/testing/selftests/kvm/lib/riscv/processor.c  | 362 +++++++++++++++++++++
>   tools/testing/selftests/kvm/lib/riscv/ucall.c      |  87 +++++
>   24 files changed, 1291 insertions(+), 183 deletions(-)
>   create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi.h
>   create mode 100644 arch/riscv/kvm/vcpu_sbi_base.c
>   create mode 100644 arch/riscv/kvm/vcpu_sbi_hsm.c
>   create mode 100644 arch/riscv/kvm/vcpu_sbi_replace.c
>   create mode 100644 arch/riscv/kvm/vcpu_sbi_v01.c
>   create mode 100644 tools/testing/selftests/kvm/include/riscv/processor.h
>   create mode 100644 tools/testing/selftests/kvm/lib/riscv/processor.c
>   create mode 100644 tools/testing/selftests/kvm/lib/riscv/ucall.c
> 

