Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8F44FA2AE
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 06:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236115AbiDIEdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Apr 2022 00:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbiDIEdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Apr 2022 00:33:41 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14A527084C
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 21:31:33 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id k23so15637666wrd.8
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 21:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=QpzV2uFM/aAveTReD80iQJbGn4VzHmCnclShwZNR5UI=;
        b=b2tM4CVFktZ20J5uk+EB6fEbXSrB7MeT6dPRKSb1VgM1sfEH+AB/q9MLRd9uMoz8H8
         6dRSPFadK7kaIV+5dDTi9Nck3H+O4dtIeWcDhnJ+rfKevput+dso5tPsxFSktW0X+wh3
         Qh6uGlgH5CeVj4kIcW23Ta8EM/VCzvnPLxCiyXkJ28ZmbV7PqZEIJDxi8VogCUdGRIVg
         fTbzaBjgh2+SIr82BPV9hVfAjxcseUm82KwRs6EMQmLsdiKewwx73YLhzqsh4aNlFIBP
         i+0DWibRfEsz+Y+yMvcclQJwlXU41YAcxJbH1sGdiQeZFWF6mAZ/MzIO3jlzmBrY7s/K
         GNhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=QpzV2uFM/aAveTReD80iQJbGn4VzHmCnclShwZNR5UI=;
        b=jCOq/F2Id4ACPVJPMrBn4BgZOtx3jX9KVpcKcyGbYKaL4YwlWXV6Xm9gYUyNYp+GgK
         eU8psgJiHdxWzUBK9WTo4QjgmOMaD/iWxBxjKDe+2PJ47GcIIsy5kGMguFz59DRtWqdq
         VqLsE/HvlD/2tKzNP1vI6HKfEgHIfqRzy7oCN3wiAQG9xBpsL0fvHAfwhKuHNjsNBfyH
         7UUNOPrEKGlPvHupqKXPeHXL7i13foUFJhaXRwSrA9VtbMyT5GlhVwAYun1L0X+11xJ2
         8gwZFsH6eISLKNAq5ZY16G8WtHurLOsl6kFUtNEvW33qhYzXkOeNRzXz0MnMO6dfHD9F
         ll3A==
X-Gm-Message-State: AOAM530m1Dv5BzM/XAPG7wRiacylxaT36BEo1zHCPtgoRoXdgqe39eRK
        RAEYOom6fjMDw+N+Z9Lxkfl2TXO2wYNkHXa3Y2na1A==
X-Google-Smtp-Source: ABdhPJx3oQ9/V2ogNWTQKjsKih6Mh7GzCI3OOxiepTNjP/2ClgjHAiJbqrc6dC6wzcb8k3/1qzA2ypR3LhVmRMURzas=
X-Received: by 2002:a5d:6e84:0:b0:206:147b:1f59 with SMTP id
 k4-20020a5d6e84000000b00206147b1f59mr16768877wrz.86.1649478692200; Fri, 08
 Apr 2022 21:31:32 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 9 Apr 2022 10:00:29 +0530
Message-ID: <CAAhSdy3RJpcYNS9NN=hNw=14O9e6=hqoF10fi1vT=No2cT0jWQ@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 5.18, take #1
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

This is the first set of fixes for 5.18. There are four fixes:
a) One fix related to hgatp in kvm_arch_vcpu_put()
b) Two KVM selftests fixes
c) Missing #include in vcpu_fp.c

Please pull.

Regards,
Anup

The following changes since commit a44e2c207c30a5780c4ad0cc3579b8715cebf52e:

  Merge tag 'kvmarm-fixes-5.18-1' of
git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
(2022-04-08 12:30:04 -0400)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-5.18-1

for you to fetch changes up to 4054eee9290248bf66c5eacb58879c9aaad37f71:

  RISC-V: KVM: include missing hwcap.h into vcpu_fp (2022-04-09 09:16:00 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 5.18, take #1

- Remove hgatp zeroing in kvm_arch_vcpu_put()

- Fix alignment of the guest_hang() in KVM selftest

- Fix PTE A and D bits in KVM selftest

- Missing #include in vcpu_fp.c

----------------------------------------------------------------
Anup Patel (3):
      RISC-V: KVM: Don't clear hgatp CSR in kvm_arch_vcpu_put()
      KVM: selftests: riscv: Set PTE A and D bits in VS-stage page table
      KVM: selftests: riscv: Fix alignment of the guest_hang() function

Heiko Stuebner (1):
      RISC-V: KVM: include missing hwcap.h into vcpu_fp

 arch/riscv/kvm/vcpu.c                                 | 2 --
 arch/riscv/kvm/vcpu_fp.c                              | 1 +
 tools/testing/selftests/kvm/include/riscv/processor.h | 4 +++-
 tools/testing/selftests/kvm/lib/riscv/processor.c     | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)
