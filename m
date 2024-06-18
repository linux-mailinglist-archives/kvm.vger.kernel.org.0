Return-Path: <kvm+bounces-19833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 710B690C0F0
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 03:05:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24A661F22EE6
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 01:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D46D1D26A;
	Tue, 18 Jun 2024 01:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="V6AXHNcr"
X-Original-To: kvm@vger.kernel.org
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF7915E89;
	Tue, 18 Jun 2024 01:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718672746; cv=none; b=lMJHn/yu7NXRojy7JXdQg8VpM9rTnQ2V/EeFuBWVUAJlCqIWrklynX4dzg7Zup508ieHFXftKdTig/dqVQY3rEnn63yMr1OHFib7JGmFKacNnVQ0IN1mV3lvH1e/Unr5G6gKKQ9IOtDkkNF1UbNtp4xqc6g/FI1DchSklRrAYzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718672746; c=relaxed/simple;
	bh=mDrq0T+HQM3bOhkSSpMTNr1o8Cbl6azQmUqFgfTlp/0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OMXtTej4Ew9HF7gGBUR8erPRft66eAl5xTn6geQu+ccwgXCdP0/ysAapjDX9A3Nxug2BzVCrsw398ZAukiKojwiPNnRbVbKKOvXCVGZt1el7bYy9hfYPEW88/oDTFtQBKujM9PgrIxxnFY9dl1itWBdpsdXsQON/Fl8bZNcyiDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=V6AXHNcr; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1718672735; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=PbMmDwZAuZi/KwewmWBdmgTN9+o61oCioR4xBXdC2R4=;
	b=V6AXHNcrDTiLsCwvjfeLgKLhklflYZJ12bniy2c4Bx0LJQbjjM3iiSIIvCpmmIVuao82spaTkYty1CP/DcrUCRY3Oe+7vE6ZkhoCtCjKJBBolVDzhtF+uKsNdRSS5lCpbuZ9xAcxkngLp2mtJs8gEwrdSIoAg36q/LJpN1jIDJY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045075189;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0W8hk9QZ_1718672414;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0W8hk9QZ_1718672414)
          by smtp.aliyun-inc.com;
          Tue, 18 Jun 2024 09:00:15 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: zhaotianrui@loongson.cn,
	maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yang Li <yang.lee@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] LoongArch: KVM: Remove unneeded semicolon
Date: Tue, 18 Jun 2024 09:00:13 +0800
Message-Id: <20240618010013.66332-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

./arch/loongarch/kvm/exit.c:764:2-3: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9343
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 arch/loongarch/kvm/exit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index c86e099af5ca..a68573e091c0 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -761,7 +761,7 @@ static void kvm_handle_service(struct kvm_vcpu *vcpu)
 	default:
 		ret = KVM_HCALL_INVALID_CODE;
 		break;
-	};
+	}
 
 	kvm_write_reg(vcpu, LOONGARCH_GPR_A0, ret);
 }
-- 
2.20.1.7.g153144c


