Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5664E663C
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 16:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351370AbiCXPpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 11:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351316AbiCXPpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 11:45:18 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2412A72D
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 08:43:45 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id p18-20020adfba92000000b001e8f7697cc7so1804691wrg.20
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 08:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rWoUPKu0AaJWm8l2aQCNG1PmHsFWS0Tjs1BlR+KeXSo=;
        b=F42fUyJCuMK5arWCFGN29kI5mU1nxES6fc2W7TIjsAOLovM99OY8KNdVq/oTHni2mF
         E7ovxFATJU9oVS/0qDYxcaoyl7zlGDJYMMEoFT33/qBygNRaeenX7k4Y3fYFLGzVIgDD
         91aRQP543zaepKPUwi+uYrTl4byb/pE+gn2DW7113WbzDcqabEfx1/J9gqZx5hkT5Z6Y
         Z9/MA0ILTViF7rYYYSpzAasabejhJjvMGMpU4rMoAZRZn0JlC4kpT6hQt/Sd9Hmph8jB
         +pY1zBgLwVoa8Pca1UkqN6Yq/DNN/GCcPAKmkB98G9sVMakZZgm2cWR307aseM60oYIP
         9X6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rWoUPKu0AaJWm8l2aQCNG1PmHsFWS0Tjs1BlR+KeXSo=;
        b=StxQlsSo5d9BOI8xHlbQeCw55tF0EPQk9oBUDIdD1CT78lXrnDcFwM/Aa3EUCiaoKa
         nCatVEMrSXJeF2RYj8g8s/xrUAVZMoMyNQGNwtqMmaIFozno73C2QyV7EQzXnmzZEa7o
         xLqeUTjp7ycgJBEHAsE/eESqbV5ZwYfG4SK6p2VtCiT38S2n9KOeNs6sfhWJ8hZKoqAe
         uspAIwCIRTkhD2fY7JOvscuCPSpONJDOhIIXm9k8zwsOHd0EFh4q+l+LghQ0uz1ZUc1x
         6x1X/q3WmhKLbvV1JydOq01mlBbEF/z1pQwbVI7P1Vs9YFh1D67G1zfSafp7NpqGH0au
         kedQ==
X-Gm-Message-State: AOAM532dQEHPL7ctguAtLMlqDc8f17E58919TmRME8NszN/YP2Hn9HiM
        OC4afRFveixEStcJ9lJ8AtIjga5/uthfBudBmwyZ7h5RMIOvT+oQwlgGAMgHzwcwq/VDpLLpLnD
        ftvFUhoIUCQhkBXNhexahaG/kBuNhuMInGQxMoStDV13f9sMRe92PKJWU3WxkuNS7HVGOKVXd6Q
        ==
X-Google-Smtp-Source: ABdhPJx0dUAc+CPGDR5fCVWncoXBTYBEoFnp3BZG+yihBm+1aLnW1hvzxkvOCAtA/5o6APLgOSlW+cYrdOQktSzt0fg=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a1c:7518:0:b0:381:c77:ceec with SMTP
 id o24-20020a1c7518000000b003810c77ceecmr5353400wmc.57.1648136624209; Thu, 24
 Mar 2022 08:43:44 -0700 (PDT)
Date:   Thu, 24 Mar 2022 15:43:05 +0000
Message-Id: <20220324154304.2572891-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH kvmtool v1] Make --no-pvtime command argument arm specific
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The stolen time option is available only for aarch64 and is enabled by
default. Move the option that disables stolen time functionality in the
arch specific path.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arm/aarch64/include/kvm/kvm-config-arch.h | 5 +++--
 arm/aarch64/pvtime.c                      | 4 ++--
 arm/include/arm-common/kvm-config-arch.h  | 1 +
 builtin-run.c                             | 2 --
 include/kvm/kvm-config.h                  | 1 -
 5 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index 04be43d..a9b0576 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -8,8 +8,9 @@
 			"Create PMUv3 device"),				\
 	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
 			"Specify random seed for Kernel Address Space "	\
-			"Layout Randomization (KASLR)"),
-
+			"Layout Randomization (KASLR)"),		\
+	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"	\
+			" stolen time"),
 #include "arm-common/kvm-config-arch.h"
 
 #endif /* KVM__KVM_CONFIG_ARCH_H */
diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
index 2f5774e..a49cf3e 100644
--- a/arm/aarch64/pvtime.c
+++ b/arm/aarch64/pvtime.c
@@ -48,13 +48,13 @@ int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
 	bool has_stolen_time;
 	u64 pvtime_guest_addr = ARM_PVTIME_BASE + vcpu->cpu_id *
 		ARM_PVTIME_STRUCT_SIZE;
-	struct kvm_config *kvm_cfg = NULL;
+	struct kvm_config_arch *kvm_cfg = NULL;
 	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
 		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
 		.attr	= KVM_ARM_VCPU_PVTIME_IPA
 	};
 
-	kvm_cfg = &vcpu->kvm->cfg;
+	kvm_cfg = &vcpu->kvm->cfg.arch;
 	if (kvm_cfg->no_pvtime)
 		return 0;
 
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 5734c46..9f97778 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -12,6 +12,7 @@ struct kvm_config_arch {
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
+	bool no_pvtime;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
diff --git a/builtin-run.c b/builtin-run.c
index 7c8be9d..9a1a0c1 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -128,8 +128,6 @@ void kvm_run_set_wrapper_sandbox(void)
 			" rootfs"),					\
 	OPT_STRING('\0', "hugetlbfs", &(cfg)->hugetlbfs_path, "path",	\
 			"Hugetlbfs path"),				\
-	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"	\
-			" stolen time"),				\
 									\
 	OPT_GROUP("Kernel options:"),					\
 	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index 48adf27..6a5720c 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -62,7 +62,6 @@ struct kvm_config {
 	bool no_dhcp;
 	bool ioport_debug;
 	bool mmio_debug;
-	bool no_pvtime;
 };
 
 #endif
-- 
2.35.1.894.gb6a874cedc-goog

