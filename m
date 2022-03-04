Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBD34CD215
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 11:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239517AbiCDKLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 05:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbiCDKL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 05:11:28 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD7A1A906E
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 02:10:40 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id k22-20020a9d4b96000000b005ad5211bd5aso7010714otf.8
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 02:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jAp2jVsPECC5CukAgMyeSN7hFFqb5X1LnQN+Kkktlqo=;
        b=pD++kqzRB0zUtstpkWHCebgX+WoT2BUX73QeUXWnW+dBIaVSilGHLtU7egvHwNDxiR
         lrELYYMQ5yg/GEKFkPRTsPiaeCtMcAYGJ3tlckgJIduosevDUuAGHXWBC9echpvgbHBY
         T2LfY77HduS818c2eDrBxONuY5O7s68ojvIJAq6WusZ02lnVDx21ZqQpG5qqXhoyVim/
         +zmGekY/qRTN6PQ+gJXpaPmHRb0UiXIvZD40CNeVh8141Nf7MZmSxTnTQ79Y++nRSIwS
         oUC1q4Fg9dxmC5fJ2j6cvFTT76GU9sg6oCyXJkGn5CTSv26laOw8YpLgRw2C+7TKS5Xx
         xHwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jAp2jVsPECC5CukAgMyeSN7hFFqb5X1LnQN+Kkktlqo=;
        b=pdbWTsfp5+ddyohBO1zsnyk4hhk/fEpQ7B5+4wL6n2S8UJNDMbLcq5d4x4KUezJceM
         anT/y5x9OcLk4hQkImtxe/LBaKvifLcLgkhXZkJ3HgBSZS8l43G3l2Sh0USJvT5azW22
         GPNR1eKmm9AiLOtJ/GDUawletmm4uy4agEkuKDFmk7YVIZZaGzFjpHwhu9KGI3X0+HUH
         nfZAYBbqENrlb/ZoreHpLA6EE/wTI/2uZBpIKP5S/I7k4U2CdkccSw97axDNlxbi09+h
         wMfT/X9XDExfx6u9IbXBrnXjQtDDiJt9MuZLniKZFoQgnSq9WzsLRla7ABJDWgLFQPY7
         nI8Q==
X-Gm-Message-State: AOAM532lbSvSpvqrJ0i/rUBMXS3r5ccfJ1GJQ6gKLcAFdzowQMvSNJGY
        4E2sVqV9k5mjCHZ8oDBrNkNJjA==
X-Google-Smtp-Source: ABdhPJz/1VD1ogYByCne7YXihgD15fCIfLlRPu2jSDBNKjSp3yE50No6u6ZVVb1UfIRiWzYnBTrADw==
X-Received: by 2002:a9d:758a:0:b0:5ad:2fd2:d28f with SMTP id s10-20020a9d758a000000b005ad2fd2d28fmr21595690otk.125.1646388639900;
        Fri, 04 Mar 2022 02:10:39 -0800 (PST)
Received: from rivos-atish.. (adsl-70-228-75-190.dsl.akrnoh.ameritech.net. [70.228.75.190])
        by smtp.gmail.com with ESMTPSA id m26-20020a05680806da00b002d797266870sm2358769oih.9.2022.03.04.02.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 02:10:39 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: [RFC PATCH kvmtool 0/3] Add Sstc extension support
Date:   Fri,  4 Mar 2022 02:10:20 -0800
Message-Id: <20220304101023.764631-1-atishp@rivosinc.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds Sstc extension which was ratified recently.

The first two patches adds the ISA extension framework which allows
to define and update the DT for any multi-letter ISA extensions. 

The last patch just enables Sstc extension specifically if the hardware
supports it.

The series can also be found at
https://github.com/atishp04/kvmtool/tree/sstc_v1

The kvm & Qemu patches can be found at

KVM: https://github.com/atishp04/linux/tree/sstc_v2
OpenSBI: https://github.com/atishp04/opensbi/tree/sstc_v1
Qemu: https://github.com/atishp04/qemu/tree/sstc_v1 

[1] https://drive.google.com/file/d/1m84Re2yK8m_vbW7TspvevCDR82MOBaSX/view

Atish Patra (3):
riscv: Update the uapi header as per Linux kernel
riscv: Append ISA extensions to the device tree
riscv: Add Sstc extension support

riscv/fdt.c                      | 32 ++++++++++++++++++++++++++++++++
riscv/include/asm/kvm.h          | 22 ++++++++++++++++++++++
riscv/include/kvm/kvm-cpu-arch.h |  5 +++++
riscv/kvm-cpu.c                  |  5 -----
4 files changed, 59 insertions(+), 5 deletions(-)

--
2.30.2

