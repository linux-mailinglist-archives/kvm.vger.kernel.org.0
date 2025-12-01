Return-Path: <kvm+bounces-64980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AFD9C9587B
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 02:46:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 525823A27B6
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 01:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C7BC83A14;
	Mon,  1 Dec 2025 01:46:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A489E2628D;
	Mon,  1 Dec 2025 01:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764553560; cv=none; b=pmR9ZwccFMjCgPqXjQaNbrEI3LopEcBoK83Frg3PYqGQgGyOAxWsewvY/c/vZMDABeYlGz/pL1K8RpZONBT6Yt9ncJdfWHSXhoejki/fc/ZfM4vLHOQO250M8EaNIjpkhinlXvxu8ClVhmInXsZKCV8GOOrKwo7P/n5YD5HBU3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764553560; c=relaxed/simple;
	bh=aWlLYOiCAjdJdHlzVFRjdGHSyxMf+yZ9gbDA2Hh6HwA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BneKChpkzVB2fg6TRWxIVBDcNff1Z3HCq8gpvMehLfrVL1y2akqtu1ep/1T7ejDPYdZivFZhCAYsqyNEbJElqiBWqL0M1tM69onSGftGoQKKb35iMAeSFxh7u7fWMIZSV/ySK3SA4nNPdV8tiucKOmZo2G9sggTi0BpJ0HZVOfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [121.237.244.238])
	by APP-01 (Coremail) with SMTP id qwCowADnfMxE8yxpRt2vAg--.19616S2;
	Mon, 01 Dec 2025 09:45:41 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: anup@brainfault.org,
	ajones@ventanamicro.com,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com
Cc: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Quan Zhou <zhouquan@iscas.ac.cn>
Subject: [PATCH 0/4] RISC-V: KVM: Add Zicfiss/Zicfilp support
Date: Mon,  1 Dec 2025 09:28:04 +0800
Message-Id: <cover.1764509485.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADnfMxE8yxpRt2vAg--.19616S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtFWDJFyDKr1UJr1rKr13CFg_yoWkAFb_Cr
	WxJ3s7u34xJFZ7KF90vwn3WFWDKrWrtF98tw17Xr17WFnrur13Xw4Iq3Wjqr1jyr15Xa93
	ArZ5XrZ2q34j9jkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb6xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCY02Avz4vE14v_Kw
	CF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_
	Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
	vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUfWrAUUUUU=
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiDAYDBmks7K0Z0AAAsC

From: Quan Zhou <zhouquan@iscas.ac.cn>

This patchset is based on `riscv control-flow integrity for usermode` [1].
Add Zicfiss/Zicfilp [2] and sbi fwft [3] support for riscv kvm.

[1] - https://lore.kernel.org/all/20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com/
[2] - https://github.com/riscv/riscv-cfi
[3] - https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/src/ext-firmware-features.adoc

Quan Zhou (4):
  RISC-V: KVM: Allow zicfiss/zicfilp exts for Guest/VM
  RISC-V: KVM: Add support for software check exception
  RISC-V: KVM: Add suuport for zicfiss/zicfilp/svadu FWFT features
  KVM: riscv: selftests: Add zicfiss/zicfilp/svadu and SBI FWFT to
    get-reg-list test

 arch/riscv/include/asm/csr.h                  |   1 +
 arch/riscv/include/asm/kvm_host.h             |   3 +-
 arch/riscv/include/uapi/asm/kvm.h             |   5 +
 arch/riscv/kvm/vcpu.c                         |   6 +
 arch/riscv/kvm/vcpu_exit.c                    |   3 +
 arch/riscv/kvm/vcpu_onereg.c                  |   2 +
 arch/riscv/kvm/vcpu_sbi_fwft.c                | 129 ++++++++++++++++++
 .../selftests/kvm/riscv/get-reg-list.c        |  26 ++++
 8 files changed, 174 insertions(+), 1 deletion(-)

-- 
2.34.1


