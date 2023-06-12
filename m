Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71A972B7B2
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 07:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbjFLFk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 01:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236102AbjFLFj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 01:39:58 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D504910C7
        for <kvm@vger.kernel.org>; Sun, 11 Jun 2023 22:39:50 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1a49716e9c5so1842501fac.1
        for <kvm@vger.kernel.org>; Sun, 11 Jun 2023 22:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1686548383; x=1689140383;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sWYCGAosK0SUS0+dkv9itjjrp/dSQPeY98ZsDkT2lhs=;
        b=RGIjU88MGvlPicR5dhW//WR7XWLFopn2hQUTjPMK2Lo7t0uqFoMXVJaTy/7khu+J5X
         EueKw+1U72mIxX52AhIrOEiVi70grwPry1iRrUsgrCSidPaTqbCtHj1Ne0gxuAtYnTrZ
         0eh1efmuB7TDJLFlP1a5ByM3wDNYk/VV3/RjBJZcVQsaHbrP3M+YGeemDTFbSx8uAtis
         ifnRUc1qLFCFWSmPP2t07rPV38bE4zqF9by9X4nJSSyqW5I1+Ek6T7tYFBpHXXCV0PiG
         zY1gDb6eNPMxoTyV/Enj0Xds+QOwJm5Puym2867C8LzuJStEKkfkONpj6Mo7k7pIvCY+
         FnIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686548383; x=1689140383;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sWYCGAosK0SUS0+dkv9itjjrp/dSQPeY98ZsDkT2lhs=;
        b=Zb5SOdK23uzR6Y736PJnVNET43dvMbzmHzgw5Zqst3hE9JCMeF+DSIAeAps00UAmsk
         j8Qp5gMybaSAbmUVALhOPSx/AH/XfG/qTbortwMsD9VkanZ6NFVTxlqOUdHX1+xlkdbb
         qX6Uucx3UvFqbrfboeENTtZw73ScBj2hzfipVi/T7ShS+cYSh6vl0/bKQiwXfO2Sxfp2
         ay8cfGHA3i/5+S8UgW/6o/Vt8HVrxUEoudE+YzUM1DSKQGfi2QPjvxhj8SmnZ8Gn9L0+
         Y2LV36rSFuUC/ibbITlKW73VDnxeztP5pePxnwxNdIzH/PXrzJk4TvoOUMKmdBMLSiYN
         snIQ==
X-Gm-Message-State: AC+VfDyqlMYWj6maiYyGFBZHP0Hw3yLpKX/5KVJoG4r+66Y/lGdVasWR
        ORY4FXJU/sjp9HeJMgOVaBLTAA==
X-Google-Smtp-Source: ACHHUZ52I4IvfvRlN6/6kmIgeszsaLBTwQtl0lyDvHGyiOATjHj1bO776c0nh8dssARkY++M/1PwzQ==
X-Received: by 2002:a05:6870:772d:b0:184:39e3:9c85 with SMTP id dw45-20020a056870772d00b0018439e39c85mr5356831oab.29.1686548382777;
        Sun, 11 Jun 2023 22:39:42 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id lv19-20020a056871439300b001a30d846520sm5534869oab.7.2023.06.11.22.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 22:39:42 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 00/10] RISC-V KVM in-kernel AIA irqchip
Date:   Mon, 12 Jun 2023 11:09:22 +0530
Message-Id: <20230612053932.58604-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
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

This series adds in-kernel AIA irqchip to KVM RISC-V which trap-n-emulate
IMSIC and APLIC MSI-mode for Guest. The APLIC MSI-mode trap-n-emulate is
optional so KVM user space can emulate APLIC entirely in user space.

The use of IMSIC HW guest files to accelerate IMSIC virtualization will be
done as separate series since this depends on AIA irqchip drivers to be
upstreamed. This series has no dependency on the AIA irqchip drivers.

There is also a KVM AIA irq-bypass (or device MSI virtualization) series
under development which depends on this series and upcoming IOMMU driver
series.

These patches (or this series) can also be found in the
riscv_kvm_aia_irqchip_v2 branch at: https://github.com/avpatel/linux.git

Changes since v1:
 - Rebased on Linux-6.4-rc6
 - Addressed Atish's comment in PATCH6
 - Added comments in arch/riscv/include/uapi/asm/kvm.h about APLIC and
   IMSIC device attribute type

Anup Patel (10):
  RISC-V: KVM: Implement guest external interrupt line management
  RISC-V: KVM: Add IMSIC related defines
  RISC-V: KVM: Add APLIC related defines
  RISC-V: KVM: Set kvm_riscv_aia_nr_hgei to zero
  RISC-V: KVM: Skeletal in-kernel AIA irqchip support
  RISC-V: KVM: Implement device interface for AIA irqchip
  RISC-V: KVM: Add in-kernel emulation of AIA APLIC
  RISC-V: KVM: Expose APLIC registers as attributes of AIA irqchip
  RISC-V: KVM: Add in-kernel virtualization of AIA IMSIC
  RISC-V: KVM: Expose IMSIC registers as attributes of AIA irqchip

 arch/riscv/include/asm/kvm_aia.h       |  107 ++-
 arch/riscv/include/asm/kvm_aia_aplic.h |   58 ++
 arch/riscv/include/asm/kvm_aia_imsic.h |   38 +
 arch/riscv/include/asm/kvm_host.h      |    4 +
 arch/riscv/include/uapi/asm/kvm.h      |   72 ++
 arch/riscv/kvm/Kconfig                 |    4 +
 arch/riscv/kvm/Makefile                |    3 +
 arch/riscv/kvm/aia.c                   |  274 +++++-
 arch/riscv/kvm/aia_aplic.c             |  617 ++++++++++++++
 arch/riscv/kvm/aia_device.c            |  672 +++++++++++++++
 arch/riscv/kvm/aia_imsic.c             | 1083 ++++++++++++++++++++++++
 arch/riscv/kvm/main.c                  |    3 +-
 arch/riscv/kvm/vcpu.c                  |    2 +
 arch/riscv/kvm/vm.c                    |  115 +++
 include/uapi/linux/kvm.h               |    2 +
 15 files changed, 3021 insertions(+), 33 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_aia_aplic.h
 create mode 100644 arch/riscv/include/asm/kvm_aia_imsic.h
 create mode 100644 arch/riscv/kvm/aia_aplic.c
 create mode 100644 arch/riscv/kvm/aia_device.c
 create mode 100644 arch/riscv/kvm/aia_imsic.c

-- 
2.34.1

