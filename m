Return-Path: <kvm+bounces-29797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 040FC9B22E0
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 03:39:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91486B21884
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 02:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 576FD189B98;
	Mon, 28 Oct 2024 02:38:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 086A0174EF0
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 02:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730083106; cv=none; b=Lk8iZHUkP1zuydWxmRmm6omZDvlOAsjy1rHPZoU+Zh3uzvFXDWmZQPgrnzc0zkv0xbofU8M8bHVEOjjoskgnxy8guvHCwvHg6mr9P4t4GCkZemUQPh1P2yMo9xVWRPyt8RP3WF+xA0+AFnueDrWVspiRW1bdr5zdKCl7eLksqNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730083106; c=relaxed/simple;
	bh=wggmsFLrnRZQiQpPoLk5cuxCq5eDjrqeCarcnBiCTuo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DAxtncpCBwLqzxFZzVDYdl9DI++E2XI6HIPVCQIbciaTlkta5GxuO0suujMQTceg6Gs6xr3KQXPPAqbluz4pfZpqg3HkoI5Z+ptwNSA6ifw8lclQ8x4E9dpP320iZkKo+3t2CSMoGCaC6LUcygVAqXuOzAp30WEi0KL8w8gDiCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxyuAV+R5nAMwXAA--.49150S3;
	Mon, 28 Oct 2024 10:38:13 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAx18AR+R5nE_sgAA--.13349S4;
	Mon, 28 Oct 2024 10:38:12 +0800 (CST)
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
Subject: [PATCH v3 2/3] linux-headers: loongarch: Add kvm_para.h
Date: Mon, 28 Oct 2024 10:38:08 +0800
Message-Id: <20241028023809.1554405-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20241028023809.1554405-1-maobibo@loongson.cn>
References: <20241028023809.1554405-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAx18AR+R5nE_sgAA--.13349S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

KVM LBT supports on LoongArch depends on the linux-header file
kvm_para.h, add header file kvm_para.h here.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 scripts/update-linux-headers.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/update-linux-headers.sh b/scripts/update-linux-headers.sh
index 203f48d089..99a8d9fa4c 100755
--- a/scripts/update-linux-headers.sh
+++ b/scripts/update-linux-headers.sh
@@ -190,6 +190,7 @@ EOF
         cp "$hdrdir/include/asm/unistd_64.h" "$output/linux-headers/asm-riscv/"
     fi
     if [ $arch = loongarch ]; then
+        cp "$hdrdir/include/asm/kvm_para.h" "$output/linux-headers/asm-loongarch/"
         cp "$hdrdir/include/asm/unistd_64.h" "$output/linux-headers/asm-loongarch/"
     fi
 done
-- 
2.39.3


