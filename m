Return-Path: <kvm+bounces-49700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D6672ADCD03
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 15:24:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 946E918867A6
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 13:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B29C2DBF73;
	Tue, 17 Jun 2025 13:19:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6555C96;
	Tue, 17 Jun 2025 13:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750166347; cv=none; b=AJrGB7to7xypFeM6wpqi07vHkQ64KRE3/DNoYKslZPIki/nOA911kdLMaldwpuLlTx4+W6aN1uFLu9oNkUsk71op4dlg2XlVRIU6vxcxsRcvxxGtZ6BPfZlEt5Qb/DIJNPF+1b7iYt9T//6pEO7lL1C5vfKoEeSKdCKfJPXqMx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750166347; c=relaxed/simple;
	bh=zlZ7puKr3VZ/dcYv6DCSFGofYQiNgkaHZx1U36Njtn0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mmyDTyz71gEW9JMiNvGq6BwUMg8/vg+UCknGdoUvWUGQGDhia/kGkyb49O9uH6JFQSfg+lgMWbmTM77RqqwTdKgia9QwEBiPaOSuLom7LlGYf+0ZGBbSACqYbSoUkqEM5BW8ayZg0w+ZVp0Hp9aDimnhOFBJvdNsyv8La83/GF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [180.110.114.155])
	by APP-05 (Coremail) with SMTP id zQCowADXYRA+a1FodSQ9Bw--.11058S2;
	Tue, 17 Jun 2025 21:18:54 +0800 (CST)
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
Subject: [PATCH 0/5] RISC-V: KVM: Allow zicop/bfloat16 exts for guest
Date: Tue, 17 Jun 2025 21:10:10 +0800
Message-Id: <cover.1750164414.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADXYRA+a1FodSQ9Bw--.11058S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZFyxJr4fWF13Cw45urykZrb_yoWxZwc_CF
	WrZrZ7Jw12qayjgFW2y3Z5tFy8Ja9akFy7Xa12vr1UuFnrWrWUZw1xta4UGr48uw45Xw12
	yrn5uFWSkr1YqjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbTAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s
	1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0
	cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOdgADUUUU
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBgsQBmhRLE-QtQAAsk

From: Quan Zhou <zhouquan@iscas.ac.cn>

Advertise zicop/bfloat16 extensions to KVM guest when underlying
host supports it, and add them to get-reg-list test.

Quan Zhou (5):
  RISC-V: KVM: Provide UAPI for Zicbop block size
  RISC-V: KVM: Allow Zicbop extension for Guest/VM
  RISC-V: KVM: Allow bfloat16 extension for Guest/VM
  KVM: riscv: selftests: Add Zicbop extension to get-reg-list test
  KVM: riscv: selftests: Add bfloat16 extension to get-reg-list test

 arch/riscv/include/uapi/asm/kvm.h             |  5 ++++
 arch/riscv/kvm/vcpu_onereg.c                  | 19 ++++++++++++++
 .../selftests/kvm/riscv/get-reg-list.c        | 25 +++++++++++++++++++
 3 files changed, 49 insertions(+)

-- 
2.34.1


