Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE0A4FDE45
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 13:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbiDLL0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 07:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352763AbiDLLZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 07:25:41 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4553026AC4
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 03:08:27 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id 12so4557805pll.12
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 03:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y8/JYtLwGTr+r9WhKddIHXBLC5TCTeFp3FTZ8BAk6HA=;
        b=BWQF6hyEhV41fw/Vfjf8js/WHVuO3KDWVkQ8iaSse8fQWRUMxww5Qo6CNykQ17EiqJ
         R9plY4ivF9hhzBQTg1z4+y6mKIq64h787PG2tMSkM21BHRwuDGku3NMVlkP3l2pUgZOr
         0uS52KvkqEcGka6JR8QD5Suprc65T9w/aFdLzxiyKHmZYNHvqkwYPzD3ZC1QXAMSuioi
         oxCseOUn1dQARtF/OdcH0P1WWbsgSOSymXv1WylLOHKcVTOM1K+1+5zNFRKwXh3K8CHw
         P2lU4Oksd7J26mj5hEnZmKUemEGP293GCRcM9Ix94AXPVy8w6j8ZGMy7mTjFDfuo4kOt
         j01w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y8/JYtLwGTr+r9WhKddIHXBLC5TCTeFp3FTZ8BAk6HA=;
        b=ocIsrua0nE1jKgRsQbX05cR7Q3vssMHL3LmZAJieCE70KZYR1Q2/BsWYp3rrOCd+DD
         yKcO45Kh5GTUBHMsHCyxj5kmqchF9sGfc+AYC9l6Ly3MyWztPa3yjgLNISPwGPOuKRae
         GcPkYWYLPSeIfsHvASJx8v1AbVqADIB0IKUoeWkgeeOfxqhCy2w9Eba0bQCYLhj6wkC0
         NCEbrRe5B2fcpYujd3DKgOPIHGZxNltmEscWXBbRKwwfGdPfGIpfRJlfXejZfppVu5jh
         JPNUD/QAox27mP5MC9CRVfE4Vahw5Z1/YfQLFWpqX6CFepAfi4XMI2+T1GLDoih27bAu
         3A0w==
X-Gm-Message-State: AOAM533381KNPw7uBzNBAqFgZBVU/spDAE+3j4YEwmfka0d7F1Q28un7
        E8fb5PTfJJR8znR2JDe6TnENxw==
X-Google-Smtp-Source: ABdhPJz9BsX5BLP589MLDfJnGsKt1qLr3mtq0HfL/T8EgEobf38Mq+9s+26t59TCgZOSJxq3Z6xS9g==
X-Received: by 2002:a17:902:8684:b0:154:af35:82ce with SMTP id g4-20020a170902868400b00154af3582cemr37178055plo.137.1649758106758;
        Tue, 12 Apr 2022 03:08:26 -0700 (PDT)
Received: from localhost.localdomain ([122.182.197.47])
        by smtp.gmail.com with ESMTPSA id j9-20020a056a00130900b004f73df40914sm37515088pfu.82.2022.04.12.03.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:08:25 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 0/6] KVM RISC-V Sv57x4 support and HFENCE improvements
Date:   Tue, 12 Apr 2022 15:37:07 +0530
Message-Id: <20220412100713.1415094-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds Sv57x4 support for KVM RISC-V G-stage and various
HFENCE related improvements.

These patches can also be found in riscv_kvm_sv57_plus_v1 branch at:
https://github.com/avpatel/linux.git

Anup Patel (6):
  RISC-V: KVM: Use G-stage name for hypervisor page table
  RISC-V: KVM: Add Sv57x4 mode support for G-stage
  RISC-V: KVM: Treat SBI HFENCE calls as NOPs
  RISC-V: KVM: Introduce range based local HFENCE functions
  RISC-V: KVM: Reduce KVM_MAX_VCPUS value
  RISC-V: KVM: Add remote HFENCE functions based on VCPU requests

 arch/riscv/include/asm/csr.h      |   1 +
 arch/riscv/include/asm/kvm_host.h | 119 ++++++--
 arch/riscv/kvm/main.c             |  11 +-
 arch/riscv/kvm/mmu.c              | 264 ++++++++---------
 arch/riscv/kvm/tlb.S              |  74 -----
 arch/riscv/kvm/tlb.c              | 456 ++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu.c             |  34 ++-
 arch/riscv/kvm/vcpu_exit.c        |   6 +-
 arch/riscv/kvm/vcpu_sbi_replace.c |  40 ++-
 arch/riscv/kvm/vcpu_sbi_v01.c     |  35 ++-
 arch/riscv/kvm/vm.c               |   8 +-
 arch/riscv/kvm/vmid.c             |  30 +-
 12 files changed, 791 insertions(+), 287 deletions(-)
 delete mode 100644 arch/riscv/kvm/tlb.S
 create mode 100644 arch/riscv/kvm/tlb.c

-- 
2.25.1

