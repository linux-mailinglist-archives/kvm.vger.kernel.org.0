Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E93572D95
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 07:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbiGMFsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 01:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiGMFs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 01:48:29 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B2C6051F
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 22:48:28 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id bk26so13923179wrb.11
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 22:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=a7Jq6CNl2s/wsfuy5DRMvbAZURyt/0nHWoFVyeWRnG8=;
        b=ij9ylmOiMr6PNwHJF7dTc2/1Ag8iFSebIsCAGIwpIZvb8rUZium6cfRyZmuyO7YPSA
         zCfn8ChLLcGJDNXYjzr6v58aWDrRg7+rz7z7YXKMNLyklIrD1wmFoliRXt2BMc3PI+yq
         Cz5+NA6Agb1n0LRZ/fYEcFynKyAmay+FkWtBQ61YhDtG+FrOf8rmUe4QZ7HbxEgL2ZjY
         A+TAo6vaeGxK4RML1Nw3EM8o1XXVLtFImc7nzPK5i4qfXQ3n8J0mifNEodyAurloab9S
         XYRMYyFd/uJDJUAtcayGr/n9GaEmPtBnuQplgrqESw8ePCo34wRiwQ79DXC8/c1nn2Vb
         uDQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=a7Jq6CNl2s/wsfuy5DRMvbAZURyt/0nHWoFVyeWRnG8=;
        b=G/eYdMOiXUrajWYp/kPxzw4+UMNhXEqpI738zSGuDeeXP+6gPkgzG0gTnuR6dRgXzO
         ZEcHTL/PdmXuQzQSgI3j/lSENfkrXIqI1kOTLmLmFeTBFZSZGLnlRXWHmq9XfKsVLf3T
         rhd9kMzmabbCwigpfgPJUFRINTAlByec04WLL8tIEwj5fg4Mz+bxjtK4821K4lr2CeWK
         oWpAbW55Nt9vpPqx8ZpTpwmJa7iYR6fcd83rw8epWV06CRgpUXuuHq2nngyHoYBsTlWk
         U9PuZ1Bnt/hmk8Tm+GlB92PsOasvdYNAQTFng68x3jtqBFH2sQBelsHcT7N9uolxHfwi
         QWkA==
X-Gm-Message-State: AJIora+Gdde1Ia1P8BP0usCl9qdmO6CQQiKuMMU4jkk/F46mD4mCku4N
        PAM/b7WdvBwMQ0+Afj6GxP1rzRIhepejp2hPSRZXzg==
X-Google-Smtp-Source: AGRyM1sqkc4Ob6zlaKqcQ56jcIYT4y+cTXdT478VuRnF0kpbKo2bWa1a73J8Q25v81LPyt/PWSacxa+pf5n4C1oXGR0=
X-Received: by 2002:a5d:64ac:0:b0:21d:7832:ecf9 with SMTP id
 m12-20020a5d64ac000000b0021d7832ecf9mr1416098wrp.86.1657691306384; Tue, 12
 Jul 2022 22:48:26 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 13 Jul 2022 11:17:17 +0530
Message-ID: <CAAhSdy1CAtr=mAVFtduTcED_Sjp2=4duQwgL5syxZ-sYM6SoWQ@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 5.19, take #2
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

Hi Paolo,

We have two more fixes for 5.19 which were discovered recently:
1) Fix missing PAGE_PFN_MASK
2) Fix SRCU deadlock caused by kvm_riscv_check_vcpu_requests()

Please pull.

Regards,
Anup

The following changes since commit 32346491ddf24599decca06190ebca03ff9de7f8:

  Linux 5.19-rc6 (2022-07-10 14:40:51 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-5.19-2

for you to fetch changes up to be82abe6a76ba8e76f25312566182b0f13c4fbf9:

  RISC-V: KVM: Fix SRCU deadlock caused by
kvm_riscv_check_vcpu_requests() (2022-07-11 09:36:32 +0530)

----------------------------------------------------------------
 KVM/riscv fixes for 5.19, take #2

- Fix missing PAGE_PFN_MASK

- Fix SRCU deadlock caused by kvm_riscv_check_vcpu_requests()

----------------------------------------------------------------
Alexandre Ghiti (1):
      riscv: Fix missing PAGE_PFN_MASK

Anup Patel (1):
      RISC-V: KVM: Fix SRCU deadlock caused by kvm_riscv_check_vcpu_requests()

 arch/riscv/include/asm/pgtable-64.h | 12 ++++++------
 arch/riscv/include/asm/pgtable.h    |  6 +++---
 arch/riscv/kvm/mmu.c                |  2 +-
 arch/riscv/kvm/vcpu.c               |  2 ++
 4 files changed, 12 insertions(+), 10 deletions(-)
