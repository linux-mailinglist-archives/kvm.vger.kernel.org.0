Return-Path: <kvm+bounces-51140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F246AEECC6
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 05:10:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8F1C1BC36A3
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 03:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED20821FF35;
	Tue,  1 Jul 2025 03:08:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFED11E1E1F;
	Tue,  1 Jul 2025 03:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751339336; cv=none; b=BJulMrBxavuO+TgI4TrydeB7cKHEJTXzf2stTpYp/GTxKnqeroftRPNCRiJgahwQ70j+c+bGkVwRkoywQSLPP92OR9A7Um2WVdHUucQV2tHujQIwmEAiZxQyXMVOkjPK65bji13lnNytRIe1OmjGX0EFn35uLVgw2PwkzTHKyIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751339336; c=relaxed/simple;
	bh=ryb6hx0FWcCXe6vAqcJ437xJ27ug4a9xTIatX/wE6HU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GDTK80N8mFE5jmbP0Xmzdeahe6XtNmUO6e1QTx9ZwYmwEaQHzTb6BZB+5sVW7Qapy1ZJOgGby99F1dCrUX8/SsW+VU/yJqPj9xn7qMkTFQhkM0r2dGgP9bfzU70gkGlDnBL+5+OCRCRYvrI2gj9xgS2fB3iA7wy7WwMvVCY63J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxaeFEUWNorU4gAQ--.27348S3;
	Tue, 01 Jul 2025 11:08:52 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxpeQ7UWNolGYEAA--.27732S6;
	Tue, 01 Jul 2025 11:08:52 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 04/13] LoongArch: KVM: Remove never called default case statement
Date: Tue,  1 Jul 2025 11:08:33 +0800
Message-Id: <20250701030842.1136519-5-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250701030842.1136519-1-maobibo@loongson.cn>
References: <20250701030842.1136519-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxpeQ7UWNolGYEAA--.27732S6
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

IOCSR instruction supports 1/2/4/8 bytes access, len must be 1/2/4/8
bytes from iocsr exit emulation function kvm_emu_iocsr(), remove the
default case in switch case statements.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 92bae1dea8eb..137cd3adca80 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -328,12 +328,9 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
 	case 4:
 		ret = loongarch_eiointc_readl(vcpu, eiointc, addr, val);
 		break;
-	case 8:
+	default:
 		ret = loongarch_eiointc_readq(vcpu, eiointc, addr, val);
 		break;
-	default:
-		WARN_ONCE(1, "%s: Abnormal address access: addr 0x%llx, size %d\n",
-						__func__, addr, len);
 	}
 	spin_unlock_irqrestore(&eiointc->lock, flags);
 
@@ -704,12 +701,9 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
 	case 4:
 		ret = loongarch_eiointc_writel(vcpu, eiointc, addr, val);
 		break;
-	case 8:
+	default:
 		ret = loongarch_eiointc_writeq(vcpu, eiointc, addr, val);
 		break;
-	default:
-		WARN_ONCE(1, "%s: Abnormal address access: addr 0x%llx, size %d\n",
-						__func__, addr, len);
 	}
 	spin_unlock_irqrestore(&eiointc->lock, flags);
 
-- 
2.39.3


