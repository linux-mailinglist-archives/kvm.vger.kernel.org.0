Return-Path: <kvm+bounces-29796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1302B9B22DC
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 03:38:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 456FD1C2129B
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 02:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF665188CC6;
	Mon, 28 Oct 2024 02:38:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 956AD170A0C
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 02:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730083105; cv=none; b=XuBWTbE1px0Is8QqmBzZli4F32sx7rkaszLXL8XNJ0xj8xSP/Vo8z//+SHj2u4zW7QOMrVcYdYhEG5uecytsmCLMhMTsihim0sifdzxtbB19gB3dGphVbDARy8P/7suHwMrPtBziawQpIiKaaUD9JDPcYu76doCy0Vp57lGByiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730083105; c=relaxed/simple;
	bh=nWtMc8QD2vLxgzp3gi+Oi/2E3MsqE5am6HpLnEZcpQs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oXmakFtVxa8uRN5j2OvOfcssD89e0BF72ZI14ly9EsxLn6j8aM9STGLbzLTRk7xmQ8uQMOJaQ2R7njNyTcckBCg9gqviYTRYfV94IgI7hn+zUans/RXdlpoYO+BZn2WRlH02FgsW3ZBuivbEQaHnflwPUykoy65HjzEo5slvHnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxGeEU+R5n_MsXAA--.49298S3;
	Mon, 28 Oct 2024 10:38:12 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAx18AR+R5nE_sgAA--.13349S3;
	Mon, 28 Oct 2024 10:38:11 +0800 (CST)
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
Subject: [PATCH v3 1/3] linux-headers: Add unistd_64.h
Date: Mon, 28 Oct 2024 10:38:07 +0800
Message-Id: <20241028023809.1554405-2-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowMAx18AR+R5nE_sgAA--.13349S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

since 6.11, unistd.h includes header file unistd_64.h directly on
some platforms, here add unistd_64.h on these platforms. Affected
platforms are ARM64, LoongArch64 and Riscv. Otherwise there will
be compiling error such as:

linux-headers/asm/unistd.h:3:10: fatal error: asm/unistd_64.h: No such file or directory
 #include <asm/unistd_64.h>

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 scripts/update-linux-headers.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/update-linux-headers.sh b/scripts/update-linux-headers.sh
index c34ac6454e..203f48d089 100755
--- a/scripts/update-linux-headers.sh
+++ b/scripts/update-linux-headers.sh
@@ -163,6 +163,7 @@ EOF
     fi
     if [ $arch = arm64 ]; then
         cp "$hdrdir/include/asm/sve_context.h" "$output/linux-headers/asm-arm64/"
+        cp "$hdrdir/include/asm/unistd_64.h" "$output/linux-headers/asm-arm64/"
     fi
     if [ $arch = x86 ]; then
         cp "$hdrdir/include/asm/unistd_32.h" "$output/linux-headers/asm-x86/"
@@ -185,6 +186,11 @@ EOF
     fi
     if [ $arch = riscv ]; then
         cp "$hdrdir/include/asm/ptrace.h" "$output/linux-headers/asm-riscv/"
+        cp "$hdrdir/include/asm/unistd_32.h" "$output/linux-headers/asm-riscv/"
+        cp "$hdrdir/include/asm/unistd_64.h" "$output/linux-headers/asm-riscv/"
+    fi
+    if [ $arch = loongarch ]; then
+        cp "$hdrdir/include/asm/unistd_64.h" "$output/linux-headers/asm-loongarch/"
     fi
 done
 arch=
-- 
2.39.3


