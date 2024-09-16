Return-Path: <kvm+bounces-26967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B020979E80
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:29:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E0D61C22D42
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 09:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87AC614659B;
	Mon, 16 Sep 2024 09:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="HJt+5vCG"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E3C14A4E9
	for <kvm@vger.kernel.org>; Mon, 16 Sep 2024 09:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726478975; cv=none; b=imZVdDG1wl3ww8ti5o8ilBw/S1WTU+lZmO+/37aBHg/6AfqvWnwNAofBebdDrDTvj+tXDia8pH3H1Rhr2IT0SHUa6DPuTDL4/CMjStassTLgZSzigNIydZf6RKp8mtloSIYV/C0YylsUQl6l6rZ12N+d9TSVhThD8rLB4OIqr18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726478975; c=relaxed/simple;
	bh=LurvBMAZgV5vSM0HyPmLqsMnwdCNy2bUJ7ttWHTaj4E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u7OfO/0IYnVEoddCigv6Ge/Zoz+fR2iiCfUEbEULpcA7HtE0knldaGvURxhZKZf+CBIf77JGDacBF9bkgs1adkDiwcw/VMnlbTLfNE2YoIjUwV8cv0DbkqW5l1OoZi/kZRpypj7ygQf4H7UfUFhosvnAZRXf9kNDCI3H03uJ90o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=HJt+5vCG; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1726478949;
	bh=/J9ycsKmev+JnOkYZ8ZrOJcZ2sdXEpc0VMnSBiYWn1k=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=HJt+5vCGYboMfqLXq0kOzJkQ0ZblHKn2fM/FqN+6Riqm1nYMT3v/vN3c4aKk4uN9u
	 7Z7uY9maZPH7bzSVeZDVI/VFZV1yq/dGg4IzVG7PDE+CyxkM7fkE7ek/1iDE3y+1uF
	 zFti9t+/w7iGp1wEYkDNVD2fujsZ7AhzD49UNNYc=
X-QQ-mid: bizesmtpip3t1726478942tk58g1r
X-QQ-Originating-IP: +2qEEGnAhCVxuAAwv4tZUJOrInBum+BnrvEqM8e9iaw=
Received: from avenger-OMEN-by-HP-Gaming-Lapto ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 16 Sep 2024 17:29:00 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13749986778819452041
From: WangYuli <wangyuli@uniontech.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	maobibo@loongson.cn,
	guanwentao@uniontech.com,
	zhangdandan@uniontech.com,
	wangyuli@uniontech.com,
	chenhuacai@loongson.cn
Cc: zhaotianrui@loongson.cn,
	kernel@xen0n.name,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 6.10] LoongArch: KVM: Remove undefined a6 argument comment for kvm_hypercall()
Date: Mon, 16 Sep 2024 17:28:57 +0800
Message-ID: <5B13B2AF7C2779A7+20240916092857.433334-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1

From: Dandan Zhang <zhangdandan@uniontech.com>

[ Upstream commit 494b0792d962e8efac72b3a5b6d9bcd4e6fa8cf0 ]

The kvm_hypercall() set for LoongArch is limited to a1-a5. So the
mention of a6 in the comment is undefined that needs to be rectified.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Dandan Zhang <zhangdandan@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
--
Changlog:
 *v1 -> v2: Correct the commit-msg format.
---
 arch/loongarch/include/asm/kvm_para.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
index 4ba2312e5f8c..6d5e9b6c5714 100644
--- a/arch/loongarch/include/asm/kvm_para.h
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -28,9 +28,9 @@
  * Hypercall interface for KVM hypervisor
  *
  * a0: function identifier
- * a1-a6: args
+ * a1-a5: args
  * Return value will be placed in a0.
- * Up to 6 arguments are passed in a1, a2, a3, a4, a5, a6.
+ * Up to 5 arguments are passed in a1, a2, a3, a4, a5.
  */
 static __always_inline long kvm_hypercall0(u64 fid)
 {
-- 
2.43.0


