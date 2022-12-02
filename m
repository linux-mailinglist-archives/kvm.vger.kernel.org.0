Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05AB7640C7B
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbiLBRqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbiLBRph (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:37 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D5DE11A2
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:45:28 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id j6-20020a05690212c600b006fc7f6e6955so5003009ybu.12
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dXMwf5objvW3u6ccglKiojiodstPXhl+xSwcan5VDRU=;
        b=ZPgK5NQWkr0CXkRYqMCgUI/C4GoMsg8aMCqYvByQ/aXs15J98f8nqD3uBJQ0qnvuDa
         uwkTf0mC9yssNCXWIzIIKVslBkw65hrViaXtVkmOx/y7kUTr0jlZEEMXzQn6vvqTwwad
         UeJif98U8hmBbQNYYNuj+4AYmBL9PKPCJtpHLsKFUNB/vHLWy5nnVsXcMOGkG8DaoHa6
         ATctdP5PSik0cOhwczfgaojaACqO1H5u10nZZvVOxw1OJNGY4UgJEGqGavxB9Astj6WK
         OrJ8lQWQKJxv3jytV+xd9Cv4KsojHjg77uWoF/xUbtcHAaRfjmIwgZo7TcZeaZY0P8LR
         grGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dXMwf5objvW3u6ccglKiojiodstPXhl+xSwcan5VDRU=;
        b=BSXGm+lo7m9QVp3c5jFT5uLdN4kebX65L02sp8lc51fOPsQfi61V4LQF6rrLmW4ZgR
         m2Xu3pbpRhuHF5pRzmT4qhGz9v1Dz4vXHbOUeDjGjcVArrhtpnaINRSPEmdlmO29yCBe
         KczZyx3hvLb4EobdS++C2RQ08RwQgcCjbWJthJsmlmBxksyGr/bRNPc9LMBlB/DoLJmr
         rPOb7/TtK+DOQqkfng2Bh0l8IOCN5nsT9j/FctBoEcFIt2m5wCVQAGGrIjOKZZNDp1r8
         TNLuGvPCsZPaGjQZdBwADBeHnTAzXY4+4URiAj5Hv3MxwkQ6c2YsqXwb2TrVl3mXBRsG
         vNsA==
X-Gm-Message-State: ANoB5pnYo/Xy8RrdL0mgfULRl0ymx9X1l6QEl6xmQfoHUHSuDsJVkCIK
        vkgO5BeW7fbZKw5BCLWZ3GXUJVFPK2kQNvUp6Ci19RiKIdqqoA3nknsns4neDW626yuc6l9iX8x
        Im54rQ+Zk/AaZcJR3w5MDuvAd0uL8MqsqkmP6v5SE1BIutkkbf795FXk=
X-Google-Smtp-Source: AA0mqf6rHNMirunmaZE2JJDlCsgHJepjQN08CpR4XnoKViXcj/YzhRg8yOKieWyVhuqDC4mgnCL0clQMHw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a0d:ea91:0:b0:3d4:8f32:89d6 with SMTP id
 t139-20020a0dea91000000b003d48f3289d6mr13794377ywe.35.1670003120853; Fri, 02
 Dec 2022 09:45:20 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:14 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-30-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 29/32] pkvm: Add option to spawn a protected vm
 in pkvm
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, alex.bennee@linaro.org, will@kernel.org,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Will Deacon <will@kernel.org>

For Testing

Even when pkvm is enabled, guests are not protected by default.
This allows the creation of protected guests with kvmtool.

This is based on the current pKVM proposal [1, 2], and is likely
to be different in the final version.

[1] https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/
[2] https://lore.kernel.org/all/20221110190259.26861-1-will@kernel.org/

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arm/aarch64/kvm.c                 |  3 +++
 arm/fdt.c                         | 18 ++++++++++++++++++
 arm/include/arm-common/fdt-arch.h |  2 +-
 arm/pci.c                         |  3 +++
 builtin-run.c                     |  2 ++
 include/kvm/kvm-config.h          |  1 +
 virtio/pci-modern.c               |  3 +++
 7 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 54200c9..f65c9c1 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -131,6 +131,9 @@ int kvm__get_vm_type(struct kvm *kvm)
 	if (ipa_bits > max_ipa_bits)
 		die("Memory too large for this system (needs %d bits, %d available)", ipa_bits, max_ipa_bits);
 
+	if (kvm->cfg.pkvm)
+		return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits) | (1U << 8);
+
 	return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
 }
 
diff --git a/arm/fdt.c b/arm/fdt.c
index 286ccad..0049bef 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -116,6 +116,7 @@ static int setup_fdt(struct kvm *kvm)
 					void (*)(void *, u8, enum irq_type));
 	void (*generate_cpu_peripheral_fdt_nodes)(void *, struct kvm *)
 					= kvm->cpus[0]->generate_fdt_nodes;
+	u64 resv_mem_prop;
 
 	/* Create new tree without a reserve map */
 	_FDT(fdt_create(fdt, FDT_MAX_SIZE));
@@ -163,6 +164,23 @@ static int setup_fdt(struct kvm *kvm)
 	_FDT(fdt_property(fdt, "reg", mem_reg_prop, sizeof(mem_reg_prop)));
 	_FDT(fdt_end_node(fdt));
 
+	if (kvm->cfg.pkvm) {
+		/* Reserved memory (restricted DMA) */
+		_FDT(fdt_begin_node(fdt, "reserved-memory"));
+		_FDT(fdt_property_cell(fdt, "#address-cells", 0x2));
+		_FDT(fdt_property_cell(fdt, "#size-cells", 0x2));
+		_FDT(fdt_property(fdt, "ranges", NULL, 0));
+
+		_FDT(fdt_begin_node(fdt, "restricted_dma_reserved"));
+		_FDT(fdt_property_string(fdt, "compatible", "restricted-dma-pool"));
+		resv_mem_prop = cpu_to_fdt64(SZ_8M);
+		_FDT(fdt_property(fdt, "size", &resv_mem_prop, sizeof(resv_mem_prop)));
+		_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_DMA));
+		_FDT(fdt_end_node(fdt));
+
+		_FDT(fdt_end_node(fdt));
+	}
+
 	/* CPU and peripherals (interrupt controller, timers, etc) */
 	generate_cpu_nodes(fdt, kvm);
 	if (generate_cpu_peripheral_fdt_nodes)
diff --git a/arm/include/arm-common/fdt-arch.h b/arm/include/arm-common/fdt-arch.h
index 60c2d40..81df744 100644
--- a/arm/include/arm-common/fdt-arch.h
+++ b/arm/include/arm-common/fdt-arch.h
@@ -1,6 +1,6 @@
 #ifndef ARM__FDT_H
 #define ARM__FDT_H
 
-enum phandles {PHANDLE_RESERVED = 0, PHANDLE_GIC, PHANDLE_MSI, PHANDLES_MAX};
+enum phandles {PHANDLE_RESERVED = 0, PHANDLE_GIC, PHANDLE_MSI, PHANDLE_DMA, PHANDLES_MAX};
 
 #endif /* ARM__FDT_H */
diff --git a/arm/pci.c b/arm/pci.c
index 5bd82d4..d183177 100644
--- a/arm/pci.c
+++ b/arm/pci.c
@@ -74,6 +74,9 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 	if (irqchip == IRQCHIP_GICV2M || irqchip == IRQCHIP_GICV3_ITS)
 		_FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_MSI));
 
+	if (kvm->cfg.pkvm)
+		_FDT(fdt_property_cell(fdt, "memory-region", PHANDLE_DMA));
+
 	/* Generate the interrupt map ... */
 	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
 	while (dev_hdr && nentries < ARRAY_SIZE(irq_map)) {
diff --git a/builtin-run.c b/builtin-run.c
index 4642bc4..9ec5701 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -204,6 +204,8 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
 		    "Use legacy virtio transport"),			\
 	OPT_BOOLEAN('\0', "restricted_mem", &(cfg)->restricted_mem,	\
 		    "Use restricted memory for guests"),		\
+	OPT_BOOLEAN('\0', "pkvm", &(cfg)->pkvm,				\
+		    "Spawn a protected VM (pkvm)"),			\
 									\
 	OPT_GROUP("Kernel options:"),					\
 	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index ea5f3ea..a18b8a3 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -66,6 +66,7 @@ struct kvm_config {
 	bool mmio_debug;
 	bool virtio_legacy;
 	bool restricted_mem;
+	bool pkvm;
 };
 
 #endif
diff --git a/virtio/pci-modern.c b/virtio/pci-modern.c
index c5b4bc5..84af042 100644
--- a/virtio/pci-modern.c
+++ b/virtio/pci-modern.c
@@ -150,6 +150,9 @@ static bool virtio_pci__common_read(struct virtio_device *vdev,
 	struct virtio_pci *vpci = vdev->virtio;
 	u64 features = 1ULL << VIRTIO_F_VERSION_1;
 
+	if (vpci->kvm->cfg.pkvm)
+		features |= 1ULL << VIRTIO_F_ACCESS_PLATFORM;
+
 	switch (offset - VPCI_CFG_COMMON_START) {
 	case VIRTIO_PCI_COMMON_DFSELECT:
 		val = vpci->device_features_sel;
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

