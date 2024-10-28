Return-Path: <kvm+bounces-29795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CB6B39B22DB
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 03:38:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 830641F21C75
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 02:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D749E14A088;
	Mon, 28 Oct 2024 02:38:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93925185B75
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 02:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730083105; cv=none; b=e8UnFM4wEuH3Ze7+rP+nTeKoqms3xbjt/eagfoIqPizqF8Yi7tJxW2DrFX67EVVFxSMYWkVtz+2wskuFXnPW3OUy7DNGBtw6J0igXFx85Bsp/0J3YwVNdSJwbc8/Ln4hs9TVYXLSH974JXIeOoc0W+2U0qVbA9PqFB/wuQ9UqF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730083105; c=relaxed/simple;
	bh=uLlNPg27UnC0rVmcY7JgnOfqJjVzyFMiuxgDLZ6GhGM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cG2CFjAlfqa8whvQU4m4fapb+bTACvUoXZm+d2flPtGQhEF2Fyz/uyibDv62+h65pLYvHTKicJNCoc/ByF9Mb5XCPBL5bGrmOb0wcqFta8R80mqfyB0fkkHUn8PRX+oMMsbAVBW/mxgRF2HPtioUnC5TDPWZW5oAOJSvuomYSek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxQK8T+R5n8MsXAA--.25813S3;
	Mon, 28 Oct 2024 10:38:11 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAx18AR+R5nE_sgAA--.13349S2;
	Mon, 28 Oct 2024 10:38:10 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: "Michael S . Tsirkin" <mst@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org,
	Song Gao <gaosong@loongson.cn>,
	kvm@vger.kernel.org
Subject: [PATCH v3 0/3] linux-headers: Update to Linux v6.12-rc5
Date: Mon, 28 Oct 2024 10:38:06 +0800
Message-Id: <20241028023809.1554405-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAx18AR+R5nE_sgAA--.13349S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add unistd_64.h on arm64,loongarch and riscv platform, and update
linux headers to Linux v6.12-rc5.

Pass to compile on aarch64, arm, loongarch64, x86_64, i386, riscv64,
riscv32 softmmu and linux-user.

---
v2 ... v3:
  1. Add unistd_64.h on arm64 and riscv platform also
  2. Update header files to Linux v6.12-rc5

v1 ... v2:
  1. update header files in directory linux-headers to v6.12-rc3
---

Bibo Mao (3):
  linux-headers: Add unistd_64.h
  linux-headers: loongarch: Add kvm_para.h
  linux-headers: Update to Linux v6.12-rc5

 include/standard-headers/drm/drm_fourcc.h     |  43 +++
 include/standard-headers/linux/const.h        |  17 +
 include/standard-headers/linux/ethtool.h      | 226 ++++++++++++
 include/standard-headers/linux/fuse.h         |  22 +-
 .../linux/input-event-codes.h                 |   2 +
 include/standard-headers/linux/pci_regs.h     |  41 ++-
 .../standard-headers/linux/virtio_balloon.h   |  16 +-
 include/standard-headers/linux/virtio_gpu.h   |   1 +
 linux-headers/asm-arm64/mman.h                |   9 +
 linux-headers/asm-arm64/unistd.h              |  25 +-
 linux-headers/asm-arm64/unistd_64.h           | 324 +++++++++++++++++
 linux-headers/asm-generic/unistd.h            |   6 +-
 linux-headers/asm-loongarch/kvm.h             |  24 ++
 linux-headers/asm-loongarch/kvm_para.h        |  21 ++
 linux-headers/asm-loongarch/unistd.h          |   4 +-
 linux-headers/asm-loongarch/unistd_64.h       | 320 +++++++++++++++++
 linux-headers/asm-riscv/kvm.h                 |   7 +
 linux-headers/asm-riscv/unistd.h              |  41 +--
 linux-headers/asm-riscv/unistd_32.h           | 315 +++++++++++++++++
 linux-headers/asm-riscv/unistd_64.h           | 325 ++++++++++++++++++
 linux-headers/asm-x86/kvm.h                   |   2 +
 linux-headers/asm-x86/unistd_64.h             |   1 +
 linux-headers/asm-x86/unistd_x32.h            |   1 +
 linux-headers/linux/bits.h                    |   3 +
 linux-headers/linux/const.h                   |  17 +
 linux-headers/linux/iommufd.h                 | 143 +++++++-
 linux-headers/linux/kvm.h                     |  23 +-
 linux-headers/linux/mman.h                    |   1 +
 linux-headers/linux/psp-sev.h                 |  28 ++
 scripts/update-linux-headers.sh               |   7 +
 30 files changed, 1922 insertions(+), 93 deletions(-)
 create mode 100644 linux-headers/asm-arm64/unistd_64.h
 create mode 100644 linux-headers/asm-loongarch/kvm_para.h
 create mode 100644 linux-headers/asm-loongarch/unistd_64.h
 create mode 100644 linux-headers/asm-riscv/unistd_32.h
 create mode 100644 linux-headers/asm-riscv/unistd_64.h


base-commit: cea8ac78545a83e1f01c94d89d6f5a3f6b5c05d2
-- 
2.39.3


