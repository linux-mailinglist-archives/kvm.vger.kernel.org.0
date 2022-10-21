Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA36B607187
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 09:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiJUH5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 03:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiJUH53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 03:57:29 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F842249D37
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 00:57:28 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id r14so3796209lfm.2
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 00:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KpsylIcJcyYDvq7kbh4L6nLN082ExQpNZ7EI3rLx/bI=;
        b=xNNq7cdCHlc8fDgPKqg6rA8FUz2PQ0AhqXn4dcxRAnd1EaiR9sGPwdLjyfUvAjuSSM
         0LYK1a0ddo8UUn50BXeBlCejjSopQc9BckEValTc6w8YpHt228c8oOeIw3l8YHOItYbw
         dujypay23HQMCz+L9LC1F8SSNN0KNSdIRZVMuDQkfe6Sjl9b015hn2QKGEY551S3OWA+
         EjzfcHn2Jc66I/EZswpnw46Ji4c3su5IdtgrNNvb+VIIN07aTJHb4En04C5EbfvM4wnk
         uSzgEuTzaQTsjyqKrVvOjb1Qe9BzFH3iRmNZPQGkCQQbSVrN7vCcXm1+oQ9OnHPN2v1A
         aagg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KpsylIcJcyYDvq7kbh4L6nLN082ExQpNZ7EI3rLx/bI=;
        b=FGrZUNarPFexMYyUT737avuT0ehpvNh9n70wb8p2/RTpyWJimMWBUoZ/v3Rbmlfy1k
         I8uXosVsWlKBrZVVINmEdp7abq3NOuYCJRBtuN3OS8SlYmFmpInGdd1skYsr2Xpa7/Wh
         ZYuX6A/+4f0x1KXFiIyawNMPqxJU65YicInlxIv6/pxqszJgSA3+32iOYkNszEA2GwWL
         Fywu8d9wEwA6bnNfjxYY0D+G7tGe6veTvzZtOZyYtrw3ipe+ZVJbPx0QyWhpTHSFvgHn
         PbPA3T1pMevvFdVqfjoeLZkoWFpeyMzx7lIeGgycpmWARGxqLxYZzy7IwprTL5dNo/Ar
         QZUg==
X-Gm-Message-State: ACrzQf3BKm/R1omUP1pOHw/o1HxIJvhaAz7oQbUk3YTTOmuYx44a73Y+
        fw07XwEcaoqloJWfjBiO/aMM9FzOkn4BC/pp2ZW7hA==
X-Google-Smtp-Source: AMsMyM7MPtXymXgi91qUU68WgZmUxp+2pwD7cQPNMpeJf1I+PZIaJdim8yTKye5v4pLc/WZK/kyDVihrfiQE1xUdpvY=
X-Received: by 2002:a05:6512:1599:b0:4a2:70a9:fe79 with SMTP id
 bp25-20020a056512159900b004a270a9fe79mr6525962lfb.298.1666339046248; Fri, 21
 Oct 2022 00:57:26 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 21 Oct 2022 13:26:49 +0530
Message-ID: <CAAhSdy30JYf3SjDaAm6LHTU-yD36Nb8=FYaPpECm68O8XFdBDg@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.1, take #1
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

We have two fixes for 6.1:
1) Fix for compile error seen when RISCV_ISA_ZICBOM
    is disabled. This fix touches code outside KVM RISC-V
    but I am including this here since it was affecting KVM
    compilation.
2) Fix for checking pending timer interrupt when RISC-V
    Sstc extension is available.

Please pull.

Regards,
Anup

The following changes since commit 9abf2313adc1ca1b6180c508c25f22f9395cc780:

  Linux 6.1-rc1 (2022-10-16 15:36:24 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.1-1

for you to fetch changes up to cea8896bd936135559253e9b23340cfa1cdf0caf:

  RISC-V: KVM: Fix kvm_riscv_vcpu_timer_pending() for Sstc (2022-10-21
11:52:45 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.1, take #1

- Fix compilation without RISCV_ISA_ZICBOM
- Fix kvm_riscv_vcpu_timer_pending() for Sstc

----------------------------------------------------------------
Andrew Jones (1):
      RISC-V: Fix compilation without RISCV_ISA_ZICBOM

Anup Patel (1):
      RISC-V: KVM: Fix kvm_riscv_vcpu_timer_pending() for Sstc

 arch/riscv/include/asm/cacheflush.h     |  8 -------
 arch/riscv/include/asm/kvm_vcpu_timer.h |  1 +
 arch/riscv/kvm/vcpu.c                   |  3 +++
 arch/riscv/kvm/vcpu_timer.c             | 17 ++++++++++++--
 arch/riscv/mm/cacheflush.c              | 38 ++++++++++++++++++++++++++++++
 arch/riscv/mm/dma-noncoherent.c         | 41 ---------------------------------
 6 files changed, 57 insertions(+), 51 deletions(-)
