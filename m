Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BA95AB70C
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 19:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbiIBRBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 13:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235781AbiIBRBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 13:01:45 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF71FD8B1E
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 10:01:44 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id j9-20020a17090a3e0900b001fd9568b117so2699480pjc.3
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 10:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=YUxOFpnDcuO1JKcZKoGOLhBh9DhGvttoN1H+IidO6hU=;
        b=ETyEOM40mL6WbpHYxawQkUwUqftcZOHasqHn1N2MV2Rmdifn+azsFcD3L9Rxm6Doob
         KYKtL5G1u+PGSpFcQzCJF45Q5LUQncBQ6sVZTFYRSSSe4ZUFdv+TlhW4j0VscznpqBUo
         F6U7nVgYJQPVJh/ZY6rKhO+k44vgYS5SomlukJn9HGDlFRnXaCUd+tjNHVxXGjPuOuLe
         +AQp7LdDBBYtvZd7rmDBvIXhdSEqXN7RaRVwjdtHGsvA7qcXu1QF3Vrjk5f94CgG6wpY
         mygpMiQRHmDYNrMLkbxZR4V333iaCvozt1+UiBzOmnN/ff3B3zQu8D8NQmHVTeej1hdF
         FE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=YUxOFpnDcuO1JKcZKoGOLhBh9DhGvttoN1H+IidO6hU=;
        b=PWhQqx9p2Ajc+3utujYy2thO7RaRfX7bxeMgqZzYovdxBfiCmLxBUsC1PVl7kepl1B
         Kfar9ya0cArGrCvh/CDYvugwShMqNg+vGqgt0gOHOXqtaqxApdRW94f5+mkArTKRZjA/
         cgUftG++T9+RFdKkf49e/nn1ZwHQrf4+Yg2zxH1unXcwOKSGT6VrKI7cX0l/X7Dw6abA
         17+x3XESdBXxu5WCo+S2GvRROkh+30fkqr1FmiIOl325ZGjhysOTK0Wkr3xSQZ2JXcp3
         Jsz2ucgw8EwEOU3Skmj9ah8EPDyjfGa1q62o/r5pH0vu4EPbX0bP/5NKmYopuP60+q/q
         2J/Q==
X-Gm-Message-State: ACgBeo3KHJ9kYgRGb5dV7Xl6q+kcaF5JZInlvvqfEDRtV8gfFqN+9C8J
        dcurt/EM+OlU/C7zHlQ4LLTCtw==
X-Google-Smtp-Source: AA6agR6AZOMgkiY+i1WsWPOVMnHoXdP3XF2/SxVDcMtustilH221mFiL8FiGhx5WwGV9f1MOs3htnA==
X-Received: by 2002:a17:90b:4a87:b0:1fd:f44a:1d9e with SMTP id lp7-20020a17090b4a8700b001fdf44a1d9emr5731358pjb.241.1662138104265;
        Fri, 02 Sep 2022 10:01:44 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.83.155])
        by smtp.gmail.com with ESMTPSA id w10-20020a65534a000000b0043014f9a4c9sm1638800pgr.93.2022.09.02.10.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 10:01:43 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 0/3] Svinval support for KVM RISC-V
Date:   Fri,  2 Sep 2022 22:31:28 +0530
Message-Id: <20220902170131.32334-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds Svinval extension support for both Host hypervisor
and Guest.

These patches can also be found in riscv_kvm_svinval_v1 branch at:
https://github.com/avpatel/linux.git

The corresponding KVMTOOL patches are available in riscv_svinval_v1
branch at: https://github.com/avpatel/kvmtool.git

Anup Patel (2):
  RISC-V: KVM: Use Svinval for local TLB maintenance when available
  RISC-V: KVM: Allow Guest use Svinval extension

Mayuresh Chitale (1):
  RISC-V: Probe Svinval extension form ISA string

 arch/riscv/include/asm/hwcap.h    |  4 +++
 arch/riscv/include/asm/insn-def.h | 20 +++++++++++
 arch/riscv/include/uapi/asm/kvm.h |  1 +
 arch/riscv/kernel/cpu.c           |  1 +
 arch/riscv/kernel/cpufeature.c    |  1 +
 arch/riscv/kvm/tlb.c              | 60 ++++++++++++++++++++++++-------
 arch/riscv/kvm/vcpu.c             |  2 ++
 7 files changed, 77 insertions(+), 12 deletions(-)

-- 
2.34.1

