Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAFA7A964E
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjIURDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjIURCj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:02:39 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB587E72
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:01:51 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2c137f74b23so3585491fa.3
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1695315634; x=1695920434; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bnRaCddT87p/KTPHMcCblcFY4CEmmrLQIw4UVRv9/9k=;
        b=O/tJooNJYYy1bM7iKArceBNuGD9M7iqedXo70cO2zzef5NoQunUUqIlPVj5MaRpcKV
         PShI0GiPCj08vTaOwbKEAHDdLjVhT1+XyP9YenYvaxyXIWkj5sOikzZw8IvAKRrXvRGn
         5pGbVOk7Xh50ZR4V2SxffnOL1FAaNxERub/Mbo6FpEYbFwj7Pa99ce1ioANqUOTF4JOL
         qu2OBBjD8lPstUYGk+4+O7NB9ZqCluhd9Q35iQsR2S5meDYZyUl89CgBjShmW2OzLyHa
         IvzElydYYasEncL/fm/zt9LBYdo/OdhMB9c+aTl9g3mhNBC3qRzQ4DVYdIlke+dEeSsS
         x+NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695315634; x=1695920434;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bnRaCddT87p/KTPHMcCblcFY4CEmmrLQIw4UVRv9/9k=;
        b=tdaxYlGNnVMmtoNn6EpkQZznvXS6a7IvmjQbDCqkXPvxRMYsjOPmOiuQPnt787DLUW
         ylEfiVAXkulYlpJpBzfvzctfCTqg7CMYJYXkj2St9C0EyM//0kCViow6qeh1kU6kQ4xK
         zCrxAWTT3ylgl4opFDSFxEno57BkZxojZgIggUyr89me0VGdOWHBpBCwKq4sSlkOCDFb
         jJ/KRHWpKqs0jshvXSkH3JB3w0Axjni20ttCdMiXV3Z62qY5k4Pe+mBREcTaewazt2nc
         U2QgeYOUl/AqWWrB00lct7Ep6r49lflFPHtarVjSHYlydosdm6QO5xS7dhESlRCN3smQ
         WWBA==
X-Gm-Message-State: AOJu0YyasGqq5ELu5UBL3uD789dANwuWgWXDpWP8jPQzNPVuMVDh5ETG
        u0RB5J5g1vPWJRxYrinXO0uT+s2yxDaFi4CdRQpDREFQxIud5drArZs=
X-Google-Smtp-Source: AGHT+IHOwtovTmgwsWby+OJoyDY5AP80lEelm3HPPd28DmjZCPyC/5yiOXdj9uKZ7G/HXWgyBFm1cKA1bFemo5pLBa0=
X-Received: by 2002:a2e:7a18:0:b0:2b9:20fe:4bc4 with SMTP id
 v24-20020a2e7a18000000b002b920fe4bc4mr4081500ljc.40.1695289438673; Thu, 21
 Sep 2023 02:43:58 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 21 Sep 2023 15:13:47 +0530
Message-ID: <CAAhSdy3dL1JBSsu3yrQtJKavAkqMva=YotoV_y_+-kt0S0oVNA@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.6, take #1
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        Atish Patra <atishp@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        KVM General <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

We have four ONE_REG related fixes for 6.6. Out of these,
two are for kernel KVM module and other two are for get-reg-list
selftest.

Please pull.

Regards,
Anup

The following changes since commit ce9ecca0238b140b88f43859b211c9fdfd8e5b70:

  Linux 6.6-rc2 (2023-09-17 14:40:24 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.6-1

for you to fetch changes up to 071ef070ca77e6dfe33fd78afa293e83422f0411:

  KVM: riscv: selftests: Selectively filter-out AIA registers
(2023-09-21 15:04:05 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.6, take #1

- Fix KVM_GET_REG_LIST API for ISA_EXT registers
- Fix reading ISA_EXT register of a missing extension
- Fix ISA_EXT register handling in get-reg-list test
- Fix filtering of AIA registers in get-reg-list test

----------------------------------------------------------------
Anup Patel (4):
      RISC-V: KVM: Fix KVM_GET_REG_LIST API for ISA_EXT registers
      RISC-V: KVM: Fix riscv_vcpu_get_isa_ext_single() for missing extensions
      KVM: riscv: selftests: Fix ISA_EXT register handling in get-reg-list
      KVM: riscv: selftests: Selectively filter-out AIA registers

 arch/riscv/kvm/vcpu_onereg.c                     |  7 ++-
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 58 +++++++++++++++++-------
 2 files changed, 47 insertions(+), 18 deletions(-)
