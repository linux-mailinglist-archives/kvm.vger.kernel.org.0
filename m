Return-Path: <kvm+bounces-1990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E43697EFFD7
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 14:29:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8943281016
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 13:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6790113AEB;
	Sat, 18 Nov 2023 13:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="S11PXVlU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1582182
	for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 05:29:02 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-53fbf2c42bfso2246464a12.3
        for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 05:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1700314142; x=1700918942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=btcVqzYnBalVj+zysZxRTxYBlWfPT4v9zvMbMJwfI4s=;
        b=S11PXVlUVJAPSVEJwlwfGfdWyr7eBlU1gislTEDjugDgpHYss68vLjzdjLwf2M/i6d
         uoZuaIRssKQH3HTet6a2zFURxqSbf7wNbAbiDVMxCrFQ66CIMSYp+R3H+AYHJkCq7eFC
         gXANIXBxxnnccWt//D2Ra8QxFxy0PSJYSg1epErffhkjJacVRTNsnkeeZYw6ahovLm00
         JoDXTmrxMyj4ymqNg1P67nP4Kxt5jvKpf3PQUCDY0kzGYOfeqDJ3oXce4JWGNb1hVpn6
         4z/WgaEcHplWo2anmCGYEqxGxu5K112K1yQ/gNUXUF/ddEUSeabiVhLFcVPO1viyKJfg
         8xtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700314142; x=1700918942;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=btcVqzYnBalVj+zysZxRTxYBlWfPT4v9zvMbMJwfI4s=;
        b=oMKQAJCPNjzEruyMm5t71VmRt41G7M1+ssozQhJSJX2OrFAU/A/9gJzYki1tWcnm02
         OHGe+t/4gyieR3sqVH8+ApqpTtJ0WSrGfFEx0YPUkn6zw/Ddbq1vLZZc6oL00te9rUDc
         SXd0tvIT4Q/wkMtNWpwf9JZO0DFMWTV7sdt328o9+hlmh3wkNUCJ+WXeDZtVb1GHAflg
         eYt1w9/9VP6SVPeQhN2tNwn34p+iJOvTAZoEho0AmRInoQvSu8oizH0i1Pxhpv5/s7em
         AddEgCFgDDEQi/U2uiSE4mbrP7DEDHA0qAHh2elsKxN0QKHZGnnLHnWUVC/a6PtNZjQw
         BHIw==
X-Gm-Message-State: AOJu0Yxk9u6DnpEZSjsBj51kHTBTNoheHBnXyZOeBIK+L8K8FxfrIU/6
	fLS52A+EH//PofZWJshEoeB8Kg==
X-Google-Smtp-Source: AGHT+IF4P7g0Bopwk8EqSc9v+Ont6kCtBx4PqpCHEdIwDNezl/DQ6o71FOvIzMzx0IeDKAYIVQRS/A==
X-Received: by 2002:a05:6a21:33a0:b0:188:973c:ef7a with SMTP id yy32-20020a056a2133a000b00188973cef7amr3012653pzb.34.1700314141862;
        Sat, 18 Nov 2023 05:29:01 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([171.76.80.108])
        by smtp.gmail.com with ESMTPSA id k25-20020a63ba19000000b005b944b20f34sm2627262pgf.85.2023.11.18.05.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Nov 2023 05:29:01 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v3 0/6] RISC-V AIA irqchip and Svnapot support
Date: Sat, 18 Nov 2023 18:58:41 +0530
Message-Id: <20231118132847.758785-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The latest KVM in Linux-6.5 has support for:
1) Svnapot ISA extension support
2) AIA in-kernel irqchip support

This series adds corresponding changes in KVMTOOL to use the above
mentioned features for Guest/VM.

These patches can also be found in the riscv_aia_v3 branch at:
https://github.com/avpatel/kvmtool.git

Changes since v2:
 - Updated PATCH1 to sync header with released Linux-6.6
 - Addressed Drew's comments in PATCH3, PATCH4, and PATCH5

Changes since v1:
 - Rebased on commit 9cb1b46cb765972326a46bdba867d441a842af56
 - Updated PATCH1 to sync header with released Linux-6.5

Anup Patel (6):
  Sync-up header with Linux-6.6 for KVM RISC-V
  riscv: Add Svnapot extension support
  riscv: Make irqchip support pluggable
  riscv: Add IRQFD support for in-kernel AIA irqchip
  riscv: Use AIA in-kernel irqchip whenever KVM RISC-V supports
  riscv: Fix guest/init linkage for multilib toolchain

 Makefile                            |   3 +
 include/linux/kvm.h                 |  19 ++-
 include/linux/virtio_net.h          |  14 ++
 riscv/aia.c                         | 227 ++++++++++++++++++++++++++++
 riscv/fdt.c                         |  15 +-
 riscv/include/asm/kvm.h             |  97 ++++++++++++
 riscv/include/kvm/fdt-arch.h        |   8 +-
 riscv/include/kvm/kvm-arch.h        |  37 ++++-
 riscv/include/kvm/kvm-config-arch.h |   3 +
 riscv/irq.c                         | 145 +++++++++++++++++-
 riscv/kvm.c                         |   2 +
 riscv/pci.c                         |  32 ++--
 riscv/plic.c                        |  61 ++++----
 13 files changed, 609 insertions(+), 54 deletions(-)
 create mode 100644 riscv/aia.c

-- 
2.34.1


