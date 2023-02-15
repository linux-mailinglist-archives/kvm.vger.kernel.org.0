Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273D7698240
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjBORf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjBORf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:35:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181B65FF3
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676482510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5tf+V8DJIKLh2c8kinjZQV06pVM49sC8W88QF7Olf/c=;
        b=BF7B6K+hx8dYWK3r7oYHHns1wx8+su1arPEjqH1MOjdJfkrFdXjX7oGpncfv1NI+ScaOv1
        pUqc3PYCEN9HrwEto3AOuOmR0njehJIaIveXboA9JAFG6JmI7kSVWm1No7vRJ55yKx1dhD
        Hcgbg+xiXqCT7lo7UHsgDsAc924MQfM=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-620-gPgAHCgxM1WKVeB-3lnN7Q-1; Wed, 15 Feb 2023 12:35:07 -0500
X-MC-Unique: gPgAHCgxM1WKVeB-3lnN7Q-1
Received: by mail-vk1-f197.google.com with SMTP id i20-20020a056122209400b0040163d749ecso4243477vkd.11
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:35:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5tf+V8DJIKLh2c8kinjZQV06pVM49sC8W88QF7Olf/c=;
        b=0/G1kWQ6zY25Q+RALSal9EYp9P077FM1hmLDQh4mtmynkMjH3v/R1xICZ4a20o9TLe
         /pWZ+3Awsc0YWwAGiG8h2p1Ew8VS2K+TwxOaate5FoYMkCxDZoIzsTv0Tck71mU4xuxV
         Mm1+Wct3cOFueh8vA9kq407/RufRNWmTVGg7RqHkBJMFLqW8vYQuBFDME7Cr4TlC2HwP
         e5vCmvRDm26ZjPiCit87ohjL42VenLQOJqPhCdnIULaG3NEpqMZ0waanREg6QFKvnCBD
         8i1/llfWUHDx6gBY7Y2cuSPc2BTnkS/zrCkOrN4M83JCe/xtWOk+oCdx01WI0IN1G5cb
         tSfw==
X-Gm-Message-State: AO0yUKWFmS8pfmorT7iJDX9g4WSuNrq3tNHOYWJBFr30gJ115VvEgH8U
        X9am1rlbhE+WOy9WAVFo0+DzE4H4NcGfD5bNI1fCz69Czkm0tM9OMQy2Le71xNUReX+GtCsMDKP
        wJAm/Kz9JGyaXONfYvM0n6wsZKG6P
X-Received: by 2002:a05:6102:5c17:b0:412:c97:4ac8 with SMTP id ds23-20020a0561025c1700b004120c974ac8mr501650vsb.53.1676482506628;
        Wed, 15 Feb 2023 09:35:06 -0800 (PST)
X-Google-Smtp-Source: AK7set+AYx/JnyU2pU6bd3Lzl+4J3wYF3yJk48DOVfDOD8nXYixJemGpjfVpYcAQrXAoAoxcjoDZwnuK40Ze7IoLFgs=
X-Received: by 2002:a05:6102:5c17:b0:412:c97:4ac8 with SMTP id
 ds23-20020a0561025c1700b004120c974ac8mr501643vsb.53.1676482506333; Wed, 15
 Feb 2023 09:35:06 -0800 (PST)
MIME-Version: 1.0
References: <CAAhSdy25NgCY23u=icRgcZpEZzNgJkyEN92KEVL8D-SvUwTBXg@mail.gmail.com>
In-Reply-To: <CAAhSdy25NgCY23u=icRgcZpEZzNgJkyEN92KEVL8D-SvUwTBXg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 15 Feb 2023 18:34:55 +0100
Message-ID: <CABgObfbkCP7gciYaBQ38Qqkryx_k=RcV_Egvv_UE28EO1CnOew@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.3
To:     anup@brainfault.org
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 7, 2023 at 6:36 PM Anup Patel <anup@brainfault.org> wrote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.3:
> 1) Fix wrong usage of PGDIR_SIZE to check page sizes
> 2) Fix privilege mode setting in kvm_riscv_vcpu_trap_redirect()
> 3) Redirect illegal instruction traps to guest
> 4) SBI PMU support for guest
>
> Please pull.
>
> I will send another PR for 6.3 containing AIA CSR
> virtualization after Palmer has sent his first PR for 6.3
> so that I can resolve conflicts with arch/riscv changes.
> I hope you are okay with this ??

Yes, it's fine to have it separate.

But please send it now, solving the conflicts is either my task or Linus's.

Paolo


> Regards,
> Anup
>
> The following changes since commit 4ec5183ec48656cec489c49f989c508b68b518e3:
>
>   Linux 6.2-rc7 (2023-02-05 13:13:28 -0800)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.3-1
>
> for you to fetch changes up to c39cea6f38eefe356d64d0bc1e1f2267e282cdd3:
>
>   RISC-V: KVM: Increment firmware pmu events (2023-02-07 20:36:08 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.3
>
> - Fix wrong usage of PGDIR_SIZE to check page sizes
> - Fix privilege mode setting in kvm_riscv_vcpu_trap_redirect()
> - Redirect illegal instruction traps to guest
> - SBI PMU support for guest
>
> ----------------------------------------------------------------
> Alexandre Ghiti (1):
>       KVM: RISC-V: Fix wrong usage of PGDIR_SIZE to check page sizes
>
> Andy Chiu (1):
>       RISC-V: KVM: Redirect illegal instruction traps to guest
>
> Anup Patel (1):
>       RISC-V: KVM: Fix privilege mode setting in kvm_riscv_vcpu_trap_redirect()
>
> Atish Patra (14):
>       perf: RISC-V: Define helper functions expose hpm counter width and count
>       perf: RISC-V: Improve privilege mode filtering for perf
>       RISC-V: Improve SBI PMU extension related definitions
>       RISC-V: KVM: Define a probe function for SBI extension data structures
>       RISC-V: KVM: Return correct code for hsm stop function
>       RISC-V: KVM: Modify SBI extension handler to return SBI error code
>       RISC-V: KVM: Add skeleton support for perf
>       RISC-V: KVM: Add SBI PMU extension support
>       RISC-V: KVM: Make PMU functionality depend on Sscofpmf
>       RISC-V: KVM: Disable all hpmcounter access for VS/VU mode
>       RISC-V: KVM: Implement trap & emulate for hpmcounters
>       RISC-V: KVM: Implement perf support without sampling
>       RISC-V: KVM: Support firmware events
>       RISC-V: KVM: Increment firmware pmu events
>
>  arch/riscv/include/asm/kvm_host.h     |   4 +
>  arch/riscv/include/asm/kvm_vcpu_pmu.h | 107 ++++++
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  13 +-
>  arch/riscv/include/asm/sbi.h          |   7 +-
>  arch/riscv/kvm/Makefile               |   1 +
>  arch/riscv/kvm/main.c                 |   3 +-
>  arch/riscv/kvm/mmu.c                  |   8 +-
>  arch/riscv/kvm/tlb.c                  |   4 +
>  arch/riscv/kvm/vcpu.c                 |   7 +
>  arch/riscv/kvm/vcpu_exit.c            |   9 +
>  arch/riscv/kvm/vcpu_insn.c            |   4 +-
>  arch/riscv/kvm/vcpu_pmu.c             | 633 ++++++++++++++++++++++++++++++++++
>  arch/riscv/kvm/vcpu_sbi.c             |  72 ++--
>  arch/riscv/kvm/vcpu_sbi_base.c        |  27 +-
>  arch/riscv/kvm/vcpu_sbi_hsm.c         |  28 +-
>  arch/riscv/kvm/vcpu_sbi_pmu.c         |  86 +++++
>  arch/riscv/kvm/vcpu_sbi_replace.c     |  50 +--
>  arch/riscv/kvm/vcpu_sbi_v01.c         |  17 +-
>  drivers/perf/riscv_pmu_sbi.c          |  64 +++-
>  include/linux/perf/riscv_pmu.h        |   5 +
>  20 files changed, 1035 insertions(+), 114 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
>  create mode 100644 arch/riscv/kvm/vcpu_pmu.c
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_pmu.c
>

