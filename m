Return-Path: <kvm+bounces-27354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14A3F98441E
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 13:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9ADBEB24050
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 11:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F022B1A4F03;
	Tue, 24 Sep 2024 11:03:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E1B1F5FF
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 11:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727175832; cv=none; b=E9zOuTwfZ5wFp9c+CIdE9lhm3gIGLGVm4lzz7eqttSRkrAXr4OAJInZZ7+lAgFE5gLCw3AQgVs7xgN8JBHxHas+z77hww2nlZhm0baf454DGaFZ7SwqdfhFkZPGbfzecKHwG7pyFMPrUCuWGWxgMAs9USHBi2DFlKKMUJpUvKsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727175832; c=relaxed/simple;
	bh=d2+efHd7qGXNWBltfTBzjceQrBrgaLxzru+7RpmaLpg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Z4V6LjipKQJGrBflyuXXZWFfEZ8i4c4nvVASKPU3d+AjCDsuKJROroMCoMMHqDA3Yei0ooMuZ2BGUk221EjnrdKamqaTPaoROswRo1U76VQifkPNSR+yPGvZmJRHnzFbrNpzswAyS8uOT85Ah6uVXiy7I6blPBVudLeb4KpYMSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [180.111.100.113])
	by APP-03 (Coremail) with SMTP id rQCowADHza1_nPJmtmSlAA--.1647S2;
	Tue, 24 Sep 2024 19:03:28 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	pbonzini@redhat.com,
	anup@brainfault.org,
	ajones@ventanamicro.com,
	zhouquan@iscas.ac.cn
Subject: [kvmtool PATCH 0/2] Add riscv isa exts based on linux-6.11
Date: Tue, 24 Sep 2024 19:03:27 +0800
Message-Id: <cover.1727174321.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADHza1_nPJmtmSlAA--.1647S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYD7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2js
	IEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE
	5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26F4j6r4UJwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7
	M4kE6xkIj40Ew7xC0wCF04k20xvY0x0EwIxGrwCF54CYxVCY1x0262kKe7AKxVWUtVW8Zw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUC-erUUUUU=
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBwoKBmbyg6BWKgAAsK

From: Quan Zhou <zhouquan@iscas.ac.cn>

Add support for a few Zc* extensions, Zimop, Zcmop and Zawrs.

Quan Zhou (2):
  Sync-up headers with Linux-6.11 kernel
  riscv: Add Zc*/Zimop/Zcmop/Zawrs exts support

 include/linux/kvm.h                 | 27 +++++++++++++++-
 powerpc/include/asm/kvm.h           |  3 ++
 riscv/fdt.c                         |  7 +++++
 riscv/include/asm/kvm.h             |  7 +++++
 riscv/include/kvm/kvm-config-arch.h | 21 +++++++++++++
 x86/include/asm/kvm.h               | 49 +++++++++++++++++++++++++++++
 6 files changed, 113 insertions(+), 1 deletion(-)


base-commit: b48735e5d562eaffb96cf98a91da212176f1534c
-- 
2.34.1


