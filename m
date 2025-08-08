Return-Path: <kvm+bounces-54318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB274B1E673
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 12:30:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60AA7724F97
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 10:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC942749DE;
	Fri,  8 Aug 2025 10:30:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1719C24886C;
	Fri,  8 Aug 2025 10:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754649044; cv=none; b=ZkJ+yj7NYczDky5gwm4vNIaCXJE98ht3FUsMsV98uacZ1vA8XZJVPSyXwi56QGXcyt1wVF9pcsavQSCdYk0wdorL+Yb6+lWabyaZ9fy5N4fSR0BvOxdKKIxjlsdbkGm6BxYd63zGlwkzM5vftxUGD2Aj7KZHIxEsymZnNIq7jZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754649044; c=relaxed/simple;
	bh=bTbYuDZqHh0yFyDEIajCDjXEYUaSkuOLx6rQWQOnvtQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Zejr1kD3HfVEltSUlKFOXgTw+29lThEP4KRzN3tlgMWHiqVsjrXmjI2UbMPp+W8GV6MRpTo1fqMMXSQ109sNVAqf3g0i4sYWcfvNl6JnajKjJKjDx8mis0PXerRYGh1P7AcshgcBnTHWCwVBadAlVtGopIq3MOh8IqT/28G0qtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [121.237.92.164])
	by APP-03 (Coremail) with SMTP id rQCowAA3zH2U0ZVoWhVQCg--.7250S2;
	Fri, 08 Aug 2025 18:29:41 +0800 (CST)
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
Subject: [PATCH v2 0/6] RISC-V: KVM: Allow zicbop/bfloat16 exts for guests
Date: Fri,  8 Aug 2025 18:18:10 +0800
Message-Id: <cover.1754646071.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAA3zH2U0ZVoWhVQCg--.7250S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XF1kZrWrtFW3Kw1xAr4rGrg_yoWDKFX_CF
	WrXrZ7J343Xayj9ayfAFs5JFykt390kr1xJF4jvr17WFnrurWUZw1xG3yYkr17uw45XFnI
	vrn5uFZ29w1a9jkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbhAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCY02Avz4vE14v_Gw1l42
	xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWU
	GwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI4
	8JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4U
	MIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I
	8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOrcfUUUUU
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBgwIBmiVokWI1gABsB

From: Quan Zhou <zhouquan@iscas.ac.cn>

Advertise zicbop/bfloat16 extensions to KVM guest when underlying
host supports it, and add them to get-reg-list test.

---
Change since v1:
- update zicbom/zicboz/zicbop block size registers to depend on the host isa.
- update the reg list filtering in copy_config_reg_indices() to use the host isa.
- add reg list filtering for zicbop.
v1: https://lore.kernel.org/all/cover.1750164414.git.zhouquan@iscas.ac.cn/

Quan Zhou (6):
  RISC-V: KVM: Change zicbom/zicboz block size to depend on the host isa
  RISC-V: KVM: Provide UAPI for Zicbop block size
  RISC-V: KVM: Allow Zicbop extension for Guest/VM
  RISC-V: KVM: Allow bfloat16 extension for Guest/VM
  KVM: riscv: selftests: Add Zicbop extension to get-reg-list test
  KVM: riscv: selftests: Add bfloat16 extension to get-reg-list test

 arch/riscv/include/uapi/asm/kvm.h             |  5 +++
 arch/riscv/kvm/vcpu_onereg.c                  | 34 +++++++++++++++----
 .../selftests/kvm/riscv/get-reg-list.c        | 25 ++++++++++++++
 3 files changed, 58 insertions(+), 6 deletions(-)

-- 
2.34.1


