Return-Path: <kvm+bounces-54361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F1D6B1FDEE
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 04:39:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45E11177A44
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 02:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBAA4247295;
	Mon, 11 Aug 2025 02:39:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC29EACD;
	Mon, 11 Aug 2025 02:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754879940; cv=none; b=CILFiv6anTUTIEPOVrxHjn2SPqBNib/g3qBgpSc0nSf/CxcGhkq+vn52lSSqqo7JskMDffJGCR7jzue4L9ElgmbL5DClb1r6llMG4bkkz8ZwUtUc6SCed4xq/9sKZ6gI3xlSMl1qYNgE8VEg1CjVkpa781gVPyyXAanJuWed9Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754879940; c=relaxed/simple;
	bh=PJuRgG4SSRo1FworDmipCx11eVm/SkRxlQjHQ+0c1pE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GLbmKxTUxFjI+X65Mqzx3fmRbsNQ44jtuUOW7rpG82rhEFRm+d9jsCJnZxELlrc7Jw3e712UvVN1etkyVkHdVuxdiTx7/Z/950/t2VRpzm/0mkN38wF4eBwHXXUqdfDjq6wqNDfm0QvRqwnepE593joKtAEP+4bHU9es/xMEc4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [121.237.92.164])
	by APP-01 (Coremail) with SMTP id qwCowAC3pamoVZlo_2nRCg--.21035S2;
	Mon, 11 Aug 2025 10:30:01 +0800 (CST)
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
Subject: [PATCH] RISC-V: KVM: Correct kvm_riscv_check_vcpu_requests() comment
Date: Mon, 11 Aug 2025 10:18:29 +0800
Message-Id: <49680363098c45516ec4b305283d662d26fa9386.1754326285.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAC3pamoVZlo_2nRCg--.21035S2
X-Coremail-Antispam: 1UD129KBjvdXoWruw4ktFW3CF1kZry3trW8WFg_yoW3ZFb_Cw
	1xGrsIgrWrZF10vFsrua1FgFs8G34xWayrJ3Z7Zr9rJ3s5urZ3W390gw43Jr47JrWYyFZ7
	Jw4FvrZ3C3s3tjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb68FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFylc2xSY4AK67AK6r4UMx
	AIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_
	Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwI
	xGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWx
	JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcV
	C2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUb-VyDUUUUU==
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBwwLBmiZRyEuxwAAs4

From: Quan Zhou <zhouquan@iscas.ac.cn>

Correct `check_vcpu_requests` to `kvm_riscv_check_vcpu_requests`.

Fixes: f55ffaf89636 ("RISC-V: KVM: Enable ring-based dirty memory tracking")
Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
---
 arch/riscv/kvm/vcpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index f001e56403f9..3ebcfffaa978 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -683,7 +683,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 }
 
 /**
- * check_vcpu_requests - check and handle pending vCPU requests
+ * kvm_riscv_check_vcpu_requests - check and handle pending vCPU requests
  * @vcpu:	the VCPU pointer
  *
  * Return: 1 if we should enter the guest
-- 
2.34.1


