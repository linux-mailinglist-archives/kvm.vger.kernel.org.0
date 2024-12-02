Return-Path: <kvm+bounces-32801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FC4E9DF984
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 04:24:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A9B7161E8D
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 03:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1356B1E2614;
	Mon,  2 Dec 2024 03:24:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2695F1E22ED;
	Mon,  2 Dec 2024 03:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733109845; cv=none; b=LzUHcWJWuduzVz17gcFk36R7Daf3pzYnhs37Ihkmax5hcn08RiR9RSEB6OoOpvpA4Ii8ODM5TZPtexTZjnzYN0xYx39FBSg7yHlrhKwq4Anxygcm66lkVD2/xUBhzD7woCnn7QjArexQqfzrfywhUjry2PMw9IpF0thSG4gB/9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733109845; c=relaxed/simple;
	bh=kB013ck6ZxRml5ouW81cc/qXpUazcGI4mjou5IaCfuQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mZLWFp8PA/Ryn6Bqs89ARsWH5gGqeL/4PuPj9vok5Tva3JvKKAblFEjOYoZAVGZnIwwv6i7bfsLg+NtImohme1+rkLgmKBzUxmaO6W006D0QI+2eS6RDCNcdxcIWSkNVox9UenWWvDpgPjp+XAlQHZuRdWznIClRA9FYzbj5Jc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [180.111.103.148])
	by APP-05 (Coremail) with SMTP id zQCowADn7389KE1n_dUuBw--.9423S2;
	Mon, 02 Dec 2024 11:23:42 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: anup@brainfault.org,
	ajones@ventanamicro.com,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Cc: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Quan Zhou <zhouquan@iscas.ac.cn>
Subject: [PATCH v2 0/4] RISC-V: KVM: Allow Svvptc/Zabha/Ziccrse exts for guests
Date: Mon,  2 Dec 2024 11:21:26 +0800
Message-Id: <cover.1732854096.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADn7389KE1n_dUuBw--.9423S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZrWUGw43JrWkXr1xKFy7trb_yoW3AFXEya
	4xAryfWw18Wa1UCFyxAFn3GFWxJFZYkF17XFnFvr15WFnrZryayw18Wr48Ar4UWa15X3WD
	Ar1rXrZak34avjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbf8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbbo2UUUUUU==
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiDAcTBmdNBhJyIwABsw

From: Quan Zhou <zhouquan@iscas.ac.cn>

Advertise Svvptc/Zabha/Ziccrse extensions to KVM guest
when underlying host supports it.

---
Change since v1:
- Arrange Svvptc in alphabetical order (Andrew)
- Add Reviewed-by tags

---
v1 link:
https://lore.kernel.org/all/cover.1732762121.git.zhouquan@iscas.ac.cn/

Quan Zhou (4):
  RISC-V: KVM: Allow Svvptc extension for Guest/VM
  RISC-V: KVM: Allow Zabha extension for Guest/VM
  RISC-V: KVM: Allow Ziccrse extension for Guest/VM
  KVM: riscv: selftests: Add Svvptc/Zabha/Ziccrse exts to get-reg-list
    test

 arch/riscv/include/uapi/asm/kvm.h                |  3 +++
 arch/riscv/kvm/vcpu_onereg.c                     |  6 ++++++
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 12 ++++++++++++
 3 files changed, 21 insertions(+)

-- 
2.34.1


