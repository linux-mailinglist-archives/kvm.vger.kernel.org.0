Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E757F6F822C
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 13:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjEELli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 07:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbjEELlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 07:41:37 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CBD2694
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 04:41:35 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6439e6f5a33so420635b3a.2
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 04:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683286895; x=1685878895;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j5FP/VynZYENiqYOz5cVGOY/UQ6avKzCTEfNQHyuq/8=;
        b=TcIvKIEkzy96iz0p0zgwR8GsIOSs2f48EdS+kpqvYgMShkBrg5WCHJAOjxJRrVmtzL
         alxf6TX1HUv4RyTbxBwKnk7qUjeDlXky4Xrs6cMHd/ozMUCEJU1a/afaWH2Gi3GjkqmP
         eUaDD+ecsEqXbSt0sf49Pp3hohfgRIoVFy/VB9Tx6MP6NbcejXOMrKlPw0EU9rbJ1uW0
         OfZbPKdfJZV2iWlGBG7RGADcpvMZ+ebvQfZS19IKhyE2dZGtcCdhs/EpMnAfGEcWPBmb
         FOX2E3Tp3pkQ4a+v1AnKqOTwBf9aAl0crH0oitwRldnDHynj26H8+qiRdY55Gb/t9Gff
         oGuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683286895; x=1685878895;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j5FP/VynZYENiqYOz5cVGOY/UQ6avKzCTEfNQHyuq/8=;
        b=gRJwK49snbZWzxl2HLDd+UDroXh05D14jONemURaFkm8pJ6XorGQd1b8AHPEFbOyms
         wjI6F+tEQpM7YBe/81NT0YK6fweODJXRSNlnYD/VyLoX87x4W33ftNDzc9Tt3UhegYz3
         U1sg9J6jF5DcpkmRsi8UK3Hl4hVGVkhXS3pQ2WNDi+HxxiJ6dx6AReyZ+4bQ/zrvNd7F
         iJfBA49vAcaY8YY4liqqwaV8pg+NaCxzsc4czUojF3CQbdqm2YYe1dMdEBxKEY/1eSwO
         hwHiSNxeuOkwmMeR/lpoNjvJfUjB1w+DirpOcpkCUZX0wbgbPX1DHbiSJupRwHYLam8g
         VU5A==
X-Gm-Message-State: AC+VfDxvkIEwl0q1ncLtjZ+iZGifvsWC4PAJUi74tDgpHssT4CXlTjDV
        1jdJCWX9gZMsNiyxs+sVED9gwQ==
X-Google-Smtp-Source: ACHHUZ4cutCnReZAa7qO7rVhzR+9UZd57WVBpVLspbZEc9G7H4z3jqZnyY6zL5VvAyz9nNz67cV1rA==
X-Received: by 2002:a05:6a00:1353:b0:63b:1e3b:aa02 with SMTP id k19-20020a056a00135300b0063b1e3baa02mr2011232pfu.16.1683286895202;
        Fri, 05 May 2023 04:41:35 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id y17-20020aa78051000000b0062d859a33d1sm1448171pfm.84.2023.05.05.04.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 04:41:34 -0700 (PDT)
From:   Yong-Xuan Wang <yongxuan.wang@sifive.com>
To:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org
Cc:     rkanwal@rivosinc.com, anup@brainfault.org,
        dbarboza@ventanamicro.com, atishp@atishpatra.org,
        vincent.chen@sifive.com, greentime.hu@sifive.com,
        frank.chang@sifive.com, jim.shu@sifive.com,
        Yong-Xuan Wang <yongxuan.wang@sifive.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: [PTACH v2 1/6] update-linux-headers: sync-up header with Linux for KVM AIA support
Date:   Fri,  5 May 2023 11:39:36 +0000
Message-Id: <20230505113946.23433-2-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230505113946.23433-1-yongxuan.wang@sifive.com>
References: <20230505113946.23433-1-yongxuan.wang@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the linux headers to get the latest KVM RISC-V headers with AIA support
by the scripts/update-linux-headers.sh.
The linux headers is comes from the riscv_aia_v1 branch available at
https://github.com/avpatel/linux.git. It hasn't merged into the mainline kernel.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Jim Shu <jim.shu@sifive.com>
---
 linux-headers/asm-riscv/kvm.h | 105 +++++++++++++++++++++++++++++++++-
 linux-headers/linux/kvm.h     |   2 +
 2 files changed, 106 insertions(+), 1 deletion(-)

diff --git a/linux-headers/asm-riscv/kvm.h b/linux-headers/asm-riscv/kvm.h
index 92af6f3f05..deba7ff304 100644
--- a/linux-headers/asm-riscv/kvm.h
+++ b/linux-headers/asm-riscv/kvm.h
@@ -12,8 +12,10 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
+#include <asm/bitsperlong.h>
 #include <asm/ptrace.h>
 
+#define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_READONLY_MEM
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
@@ -64,7 +66,7 @@ struct kvm_riscv_core {
 #define KVM_RISCV_MODE_S	1
 #define KVM_RISCV_MODE_U	0
 
-/* CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+/* General CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
 struct kvm_riscv_csr {
 	unsigned long sstatus;
 	unsigned long sie;
@@ -78,6 +80,17 @@ struct kvm_riscv_csr {
 	unsigned long scounteren;
 };
 
+/* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_aia_csr {
+	unsigned long siselect;
+	unsigned long siprio1;
+	unsigned long siprio2;
+	unsigned long sieh;
+	unsigned long siph;
+	unsigned long siprio1h;
+	unsigned long siprio2h;
+};
+
 /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
 struct kvm_riscv_timer {
 	__u64 frequency;
@@ -105,9 +118,28 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_SVINVAL,
 	KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
 	KVM_RISCV_ISA_EXT_ZICBOM,
+	KVM_RISCV_ISA_EXT_ZBB,
+	KVM_RISCV_ISA_EXT_SSAIA,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
+/*
+ * SBI extension IDs specific to KVM. This is not the same as the SBI
+ * extension IDs defined by the RISC-V SBI specification.
+ */
+enum KVM_RISCV_SBI_EXT_ID {
+	KVM_RISCV_SBI_EXT_V01 = 0,
+	KVM_RISCV_SBI_EXT_TIME,
+	KVM_RISCV_SBI_EXT_IPI,
+	KVM_RISCV_SBI_EXT_RFENCE,
+	KVM_RISCV_SBI_EXT_SRST,
+	KVM_RISCV_SBI_EXT_HSM,
+	KVM_RISCV_SBI_EXT_PMU,
+	KVM_RISCV_SBI_EXT_EXPERIMENTAL,
+	KVM_RISCV_SBI_EXT_VENDOR,
+	KVM_RISCV_SBI_EXT_MAX,
+};
+
 /* Possible states for kvm_riscv_timer */
 #define KVM_RISCV_TIMER_STATE_OFF	0
 #define KVM_RISCV_TIMER_STATE_ON	1
@@ -118,6 +150,8 @@ enum KVM_RISCV_ISA_EXT_ID {
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_RISCV_TYPE_MASK		0x00000000FF000000
 #define KVM_REG_RISCV_TYPE_SHIFT	24
+#define KVM_REG_RISCV_SUBTYPE_MASK	0x0000000000FF0000
+#define KVM_REG_RISCV_SUBTYPE_SHIFT	16
 
 /* Config registers are mapped as type 1 */
 #define KVM_REG_RISCV_CONFIG		(0x01 << KVM_REG_RISCV_TYPE_SHIFT)
@@ -131,8 +165,12 @@ enum KVM_RISCV_ISA_EXT_ID {
 
 /* Control and status registers are mapped as type 3 */
 #define KVM_REG_RISCV_CSR		(0x03 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CSR_GENERAL	(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_CSR_AIA		(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
 #define KVM_REG_RISCV_CSR_REG(name)	\
 		(offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
+#define KVM_REG_RISCV_CSR_AIA_REG(name)	\
+	(offsetof(struct kvm_riscv_aia_csr, name) / sizeof(unsigned long))
 
 /* Timer registers are mapped as type 4 */
 #define KVM_REG_RISCV_TIMER		(0x04 << KVM_REG_RISCV_TYPE_SHIFT)
@@ -152,6 +190,71 @@ enum KVM_RISCV_ISA_EXT_ID {
 /* ISA Extension registers are mapped as type 7 */
 #define KVM_REG_RISCV_ISA_EXT		(0x07 << KVM_REG_RISCV_TYPE_SHIFT)
 
+/* SBI extension registers are mapped as type 8 */
+#define KVM_REG_RISCV_SBI_EXT		(0x08 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_SINGLE	(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_MULTI_EN	(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_MULTI_DIS	(0x2 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_MULTI_REG(__ext_id)	\
+		((__ext_id) / __BITS_PER_LONG)
+#define KVM_REG_RISCV_SBI_MULTI_MASK(__ext_id)	\
+		(1UL << ((__ext_id) % __BITS_PER_LONG))
+#define KVM_REG_RISCV_SBI_MULTI_REG_LAST	\
+		KVM_REG_RISCV_SBI_MULTI_REG(KVM_RISCV_SBI_EXT_MAX - 1)
+
+/* Device Control API: RISC-V AIA */
+#define KVM_DEV_RISCV_APLIC_ALIGN		0x1000
+#define KVM_DEV_RISCV_APLIC_SIZE		0x4000
+#define KVM_DEV_RISCV_APLIC_MAX_HARTS		0x4000
+#define KVM_DEV_RISCV_IMSIC_ALIGN		0x1000
+#define KVM_DEV_RISCV_IMSIC_SIZE		0x1000
+
+#define KVM_DEV_RISCV_AIA_GRP_CONFIG		0
+#define KVM_DEV_RISCV_AIA_CONFIG_MODE		0
+#define KVM_DEV_RISCV_AIA_CONFIG_IDS		1
+#define KVM_DEV_RISCV_AIA_CONFIG_SRCS		2
+#define KVM_DEV_RISCV_AIA_CONFIG_GROUP_BITS	3
+#define KVM_DEV_RISCV_AIA_CONFIG_GROUP_SHIFT	4
+#define KVM_DEV_RISCV_AIA_CONFIG_HART_BITS	5
+#define KVM_DEV_RISCV_AIA_CONFIG_GUEST_BITS	6
+#define KVM_DEV_RISCV_AIA_MODE_EMUL		0
+#define KVM_DEV_RISCV_AIA_MODE_HWACCEL		1
+#define KVM_DEV_RISCV_AIA_MODE_AUTO		2
+#define KVM_DEV_RISCV_AIA_IDS_MIN		63
+#define KVM_DEV_RISCV_AIA_IDS_MAX		2048
+#define KVM_DEV_RISCV_AIA_SRCS_MAX		1024
+#define KVM_DEV_RISCV_AIA_GROUP_BITS_MAX	8
+#define KVM_DEV_RISCV_AIA_GROUP_SHIFT_MIN	24
+#define KVM_DEV_RISCV_AIA_GROUP_SHIFT_MAX	56
+#define KVM_DEV_RISCV_AIA_HART_BITS_MAX	16
+#define KVM_DEV_RISCV_AIA_GUEST_BITS_MAX	8
+
+#define KVM_DEV_RISCV_AIA_GRP_ADDR		1
+#define KVM_DEV_RISCV_AIA_ADDR_APLIC		0
+#define KVM_DEV_RISCV_AIA_ADDR_IMSIC(__vcpu)	(1 + (__vcpu))
+#define KVM_DEV_RISCV_AIA_ADDR_MAX		\
+		(1 + KVM_DEV_RISCV_APLIC_MAX_HARTS)
+
+#define KVM_DEV_RISCV_AIA_GRP_CTRL		2
+#define KVM_DEV_RISCV_AIA_CTRL_INIT		0
+
+#define KVM_DEV_RISCV_AIA_GRP_APLIC		3
+
+#define KVM_DEV_RISCV_AIA_GRP_IMSIC		4
+#define KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS	12
+#define KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK	\
+		((1U << KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS) - 1)
+#define KVM_DEV_RISCV_AIA_IMSIC_MKATTR(__vcpu, __isel)	\
+		(((__vcpu) << KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS) | \
+		 ((__isel) & KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK))
+#define KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(__attr)	\
+		((__attr) & KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK)
+#define KVM_DEV_RISCV_AIA_IMSIC_GET_VCPU(__attr)	\
+		((__attr) >> KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS)
+
+/* One single KVM irqchip, ie. the AIA */
+#define KVM_NR_IRQCHIPS			1
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 599de3c6e3..a9a4f5791d 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1434,6 +1434,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
 	KVM_DEV_TYPE_ARM_PV_TIME,
 #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
+	KVM_DEV_TYPE_RISCV_AIA,
+#define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
 	KVM_DEV_TYPE_MAX,
 };
 
-- 
2.17.1

