Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD4E729446
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 11:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241062AbjFIJI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 05:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240819AbjFIJGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 05:06:34 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D109B30EC;
        Fri,  9 Jun 2023 02:06:18 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8CxPuuJ64JkTvwAAA--.3043S3;
        Fri, 09 Jun 2023 17:06:17 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxluRO64JkSXEKAA--.31854S10;
        Fri, 09 Jun 2023 17:06:16 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn,
        tangyouling@loongson.cn
Subject: [PATCH v13 30/30] LoongArch: KVM: Add maintainers for LoongArch KVM
Date:   Fri,  9 Jun 2023 17:05:18 +0800
Message-Id: <20230609090518.2130926-31-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230609090518.2130926-1-zhaotianrui@loongson.cn>
References: <20230609090518.2130926-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxluRO64JkSXEKAA--.31854S10
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add maintainers for LoongArch KVM.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 27ef11624748..c2fbfd6ad4e5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11357,6 +11357,18 @@ F:	include/kvm/arm_*
 F:	tools/testing/selftests/kvm/*/aarch64/
 F:	tools/testing/selftests/kvm/aarch64/
 
+KERNEL VIRTUAL MACHINE FOR LOONGARCH (KVM/LoongArch)
+M:	Tianrui Zhao <zhaotianrui@loongson.cn>
+M:	Bibo Mao <maobibo@loongson.cn>
+M:	Huacai Chen <chenhuacai@kernel.org>
+L:	kvm@vger.kernel.org
+L:	loongarch@lists.linux.dev
+S:	Maintained
+T:	git https://github.com/loongson/linux-loongarch-kvm
+F:	arch/loongarch/include/asm/kvm*
+F:	arch/loongarch/include/uapi/asm/kvm*
+F:	arch/loongarch/kvm/
+
 KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
 M:	Huacai Chen <chenhuacai@kernel.org>
 M:	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
-- 
2.39.1

