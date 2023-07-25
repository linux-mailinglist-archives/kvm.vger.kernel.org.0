Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E560761D4C
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 17:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbjGYPYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 11:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbjGYPYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 11:24:46 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189DFE42
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:24:44 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-26825239890so1175256a91.0
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690298683; x=1690903483;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b0EgGlOxHFhuNZckylSvtceV9VyyP66yKvo8vXK/g0E=;
        b=hG2gfIZBfNeeeVvajYhBS4ESuo2co6r81JPN77ML0gi0gG6WHcM88/FWIZQU0QwO9x
         34e93V1nbPfgA5oG9aRDiie+oL3i/qv0Fm5B8qVig1bqW2uKI9ieAzuvq2byXniq9gdD
         5Fc/hMjf8fuaVyQlKdvQqmrzJxLUROukfjg2A0k5EERw4EIdFne0QkXv941PR/SvDFLg
         efVn2AuhuuR8fw+eaMn+lJBhiU93zbR2wnaIadwDxyMw/BlKUB5TQz/eMtgFVkSkEBwg
         j4RLZRG/bHhVxZfIxzfeSZRh87IPNysQI9g5tFVGkN2fREQhqRVivEGQgyD4LobVwean
         YHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690298683; x=1690903483;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b0EgGlOxHFhuNZckylSvtceV9VyyP66yKvo8vXK/g0E=;
        b=Z8iUEIfEcVpuGMGgMajhDnNV8qh+G81D2IHWbT0T5BD9J9tQdEYhdI8U+/19B4dpO0
         pwOghgFbYUTAfKFXFb042vs72Wcr6HALfpSyZ+T6hF2OIH8BZkVYRT0xjzI+lNlKDGkf
         2P8yGdZybSfHLRY4+a4h7R0zvhoafksU45TWr/n2juulaQAbKGkcMDVKAko9SqjeLpth
         ZblRS4YCeFwPY7nSNi10DUI8aD45soCu95DZtNeMCsOQEf1C2+Pbvgt+xek4vHWaArmv
         ES2Em9OB31el0dospNuGM3UygoiOr8Wz5Lc1alnOiPioI44CD4LWLDe1GgUL5n66B/8t
         FiYw==
X-Gm-Message-State: ABy/qLbdph+mowFvK79izaAfJiRoZNOMLwBG8Ghb0z9oPOMv2DbvFqlR
        +PIlHE8zXeR7UGgTWyrp3/I7mw==
X-Google-Smtp-Source: APBJJlGTewQhsMseJ6xKz8TgizoD0mSYJ8TcloYS0d0B922jVC/oY1vM3bbYiNYEJ/JlpLyQNBNGZg==
X-Received: by 2002:a17:90a:d78f:b0:24e:4b1c:74d2 with SMTP id z15-20020a17090ad78f00b0024e4b1c74d2mr12896653pju.32.1690298683452;
        Tue, 25 Jul 2023 08:24:43 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id g11-20020a17090adb0b00b002683fd66663sm980372pjv.22.2023.07.25.08.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 08:24:43 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 0/6] RISC-V AIA irqchip and Svnapot support
Date:   Tue, 25 Jul 2023 20:54:24 +0530
Message-Id: <20230725152430.3351564-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The latest KVM in Linux-6.5 has support for:
1) Svnapot ISA extension support
2) AIA in-kernel irqchip support

This series adds corresponding changes in KVMTOOL to use the above
mentioned features for Guest/VM.

These patches can also be found in the riscv_aia_v1 branch at:
https://github.com/avpatel/kvmtool.git

Anup Patel (6):
  Sync-up header with Linux-6.5-rc3 for KVM RISC-V
  riscv: Add Svnapot extension support
  riscv: Make irqchip support pluggable
  riscv: Add IRQFD support for in-kernel AIA irqchip
  riscv: Use AIA in-kernel irqchip whenever KVM RISC-V supports
  riscv: Fix guest/init linkage for multilib toolchain

 Makefile                            |   3 +
 include/linux/kvm.h                 |   6 +-
 riscv/aia.c                         | 227 ++++++++++++++++++++++++++++
 riscv/fdt.c                         |  15 +-
 riscv/include/asm/kvm.h             |  81 ++++++++++
 riscv/include/kvm/fdt-arch.h        |   8 +-
 riscv/include/kvm/kvm-arch.h        |  38 ++++-
 riscv/include/kvm/kvm-config-arch.h |   3 +
 riscv/irq.c                         | 138 ++++++++++++++++-
 riscv/kvm.c                         |   2 +
 riscv/pci.c                         |  32 ++--
 riscv/plic.c                        |  61 ++++----
 12 files changed, 563 insertions(+), 51 deletions(-)
 create mode 100644 riscv/aia.c

-- 
2.34.1

