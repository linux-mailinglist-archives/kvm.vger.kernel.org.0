Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D6E640C70
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiLBRpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234265AbiLBRp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:27 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8EBEFD20
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:45:10 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id ay40-20020a05600c1e2800b003cf8aa16377so2817073wmb.7
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JuW98NK3szawI9EWp4s7ai+ga43lAX+Pov5xEYz6c0U=;
        b=XNIkLOcJfFB16149vMnzWKOCFBWvKDgknVxHjgKpbHllb1p94gyN2NwKGeCOfyBpMC
         bcIboAVxJQHjL9bz29cTC5lLHkf3zp9QnSvY5T/9g9uZUak4hV/JJco2No/ZD1RzrfXY
         Nh1a+/ecv15WLLMP+vYcUO9ryI0feSvCZ2GjjL7fdNAu+5WmrTnnq8rikHlXW+HtyxBu
         Snx7cLsbvrkLtDuKqIZzVZaCs3JokSaCScvziwqOtxChRjSiPw9M2jtyk66osBXyhoV7
         RnkNBwJY+2ZuLz5nndkxkZeH+pXgJDYKRE2tpl5Y85vCJEU0hkY+ji9VhlRvggf2dN1S
         VeWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JuW98NK3szawI9EWp4s7ai+ga43lAX+Pov5xEYz6c0U=;
        b=TAA7rT8X/bU7yF/XaNfp8uDNLe4F7cYy2jiqixmlNjx50IPDjdaOIzNP9MHWsLfMI/
         SF6byJdAEMwV1Gpykr9Y2YPkCVcOoGMxeFqmwXHA7QmhqE6X3mlSwSNuDsTj7MqiHb1K
         epqyZ8kYmr/E+7hbS9jTA46jU783i3wYsyAfKo6A2NucGZwlk48uW1LsEY9B/T2Rtgj8
         hEq86Fs9xxW6lTx9DUz6TjP33p2enUNsZNoUu+0UzHYnapVcL89M8/VyYNu7nwVfzTLQ
         p3/IHuW8jRICHRbTxsJKiUBS5q4OKgK4ll+3AO+aDdGnH+Wl42M/AiZAusD49vrErowA
         Kumw==
X-Gm-Message-State: ANoB5pnnD8FNW/qq+cv1XKRwws/txImhozp7STSeGmn42u2MOqEzv3pI
        MvHVuZKKPXqvIAn0dvTqfmeM3GEvRjdNO3GvHbnVUMMcEWSyVnJaOeIJ8pFVOb2QRvV4rIUwKW4
        Rl8DqoW+IfzZlRzaIFLyueDsbWOxEiOkrlPZglOP6Yh+Wswa5qTxLo40=
X-Google-Smtp-Source: AA0mqf7Im89Ehl+ovCJZqxkqbqa06pTnHR9DJ2DgfayflqV0O+zF/70eu4SECFxNVoJZZP3YYFrb9xtgVw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:f7c5:0:b0:242:9e8:84b8 with SMTP id
 a5-20020adff7c5000000b0024209e884b8mr20798438wrq.25.1670003097943; Fri, 02
 Dec 2022 09:44:57 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:03 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-19-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 18/32] Pass the memory file descriptor and
 offset when registering ram
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

Since the memory file descriptor is the canonical reference to guest
memory, pass that and the offset when registering guest memory.
Future fd-based kvm proposals might even not require a userspace
address [*].

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>

[*] https://lore.kernel.org/all/20221202061347.1070246-1-chao.p.peng@linux.intel.com/
---
 arm/aarch64/pvtime.c |  2 +-
 arm/kvm.c            |  3 ++-
 hw/cfi_flash.c       |  4 +++-
 hw/vesa.c            |  2 +-
 include/kvm/kvm.h    | 17 +++++++++--------
 kvm.c                |  3 ++-
 mips/kvm.c           |  6 +++---
 powerpc/kvm.c        |  2 +-
 riscv/kvm.c          |  2 +-
 vfio/core.c          |  3 ++-
 x86/kvm.c            |  6 +++---
 11 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
index a7ba03e..9b06ee4 100644
--- a/arm/aarch64/pvtime.c
+++ b/arm/aarch64/pvtime.c
@@ -28,7 +28,7 @@ static int pvtime__alloc_region(struct kvm *kvm)
 	}
 
 	ret = kvm__register_ram(kvm, ARM_PVTIME_BASE,
-				ARM_PVTIME_SIZE, mem);
+				ARM_PVTIME_SIZE, mem, mem_fd, 0);
 	if (ret) {
 		munmap(mem, ARM_PVTIME_SIZE);
 		close(mem_fd);
diff --git a/arm/kvm.c b/arm/kvm.c
index 5cceef8..8772a55 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -50,7 +50,8 @@ void kvm__init_ram(struct kvm *kvm)
 	phys_start	= kvm->cfg.ram_addr;
 	phys_size	= kvm->ram_size;
 
-	err = kvm__register_ram(kvm, phys_start, phys_size, kvm->ram_start);
+	err = kvm__register_ram(kvm, phys_start, phys_size, kvm->ram_start,
+		kvm->ram_fd, 0);
 	if (err)
 		die("Failed to register %lld bytes of memory at physical "
 		    "address 0x%llx [err %d]", phys_size, phys_start, err);
diff --git a/hw/cfi_flash.c b/hw/cfi_flash.c
index 7faecdf..92a6567 100644
--- a/hw/cfi_flash.c
+++ b/hw/cfi_flash.c
@@ -131,6 +131,7 @@ struct cfi_flash_device {
 	u32			size;
 
 	void			*flash_memory;
+	int			flash_fd;
 	u8			program_buffer[PROGRAM_BUFF_SIZE];
 	unsigned long		*lock_bm;
 	u64			block_address;
@@ -451,7 +452,7 @@ static int map_flash_memory(struct kvm *kvm, struct cfi_flash_device *sfdev)
 	int ret;
 
 	ret = kvm__register_mem(kvm, sfdev->base_addr, sfdev->size,
-				sfdev->flash_memory,
+				sfdev->flash_memory, sfdev->flash_fd, 0,
 				KVM_MEM_TYPE_RAM | KVM_MEM_TYPE_READONLY);
 	if (!ret)
 		sfdev->is_mapped = true;
@@ -583,6 +584,7 @@ static struct cfi_flash_device *create_flash_device_file(struct kvm *kvm,
 		ret = -errno;
 		goto out_free;
 	}
+	sfdev->flash_fd = fd;
 	sfdev->base_addr = KVM_FLASH_MMIO_BASE;
 	sfdev->state = READY;
 	sfdev->read_mode = READ_ARRAY;
diff --git a/hw/vesa.c b/hw/vesa.c
index 522ffa3..277d638 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -102,7 +102,7 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 		goto close_memfd;
 	}
 
-	r = kvm__register_dev_mem(kvm, VESA_MEM_ADDR, VESA_MEM_SIZE, mem);
+	r = kvm__register_dev_mem(kvm, VESA_MEM_ADDR, VESA_MEM_SIZE, mem, mem_fd, 0);
 	if (r < 0)
 		goto unmap_dev;
 
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index f0be524..33cae9d 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -135,24 +135,25 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
 bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u8 is_write);
 int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr);
 int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr,
-		      enum kvm_mem_type type);
+		      int memfd, u64 offset, enum kvm_mem_type type);
 static inline int kvm__register_ram(struct kvm *kvm, u64 guest_phys, u64 size,
-				    void *userspace_addr)
+				    void *userspace_addr, int memfd, u64 offset)
 {
-	return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
-				 KVM_MEM_TYPE_RAM);
+	return kvm__register_mem(kvm, guest_phys, size, userspace_addr, memfd,
+				 offset, KVM_MEM_TYPE_RAM);
 }
 
 static inline int kvm__register_dev_mem(struct kvm *kvm, u64 guest_phys,
-					u64 size, void *userspace_addr)
+					u64 size, void *userspace_addr,
+					int memfd, u64 offset)
 {
-	return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
-				 KVM_MEM_TYPE_DEVICE);
+	return kvm__register_mem(kvm, guest_phys, size, userspace_addr, memfd,
+				 offset, KVM_MEM_TYPE_DEVICE);
 }
 
 static inline int kvm__reserve_mem(struct kvm *kvm, u64 guest_phys, u64 size)
 {
-	return kvm__register_mem(kvm, guest_phys, size, NULL,
+	return kvm__register_mem(kvm, guest_phys, size, NULL, -1, 0,
 				 KVM_MEM_TYPE_RESERVED);
 }
 
diff --git a/kvm.c b/kvm.c
index c71646f..fc0bfc4 100644
--- a/kvm.c
+++ b/kvm.c
@@ -256,7 +256,8 @@ out:
 }
 
 int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
-		      void *userspace_addr, enum kvm_mem_type type)
+		      void *userspace_addr, int memfd, u64 offset,
+		      enum kvm_mem_type type)
 {
 	struct kvm_mem_bank *merged = NULL;
 	struct kvm_mem_bank *bank;
diff --git a/mips/kvm.c b/mips/kvm.c
index 0a0d025..ebb2b19 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -38,21 +38,21 @@ void kvm__init_ram(struct kvm *kvm)
 		phys_size  = kvm->ram_size;
 		host_mem   = kvm->ram_start;
 
-		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem, kvm->ram_fd, 0);
 	} else {
 		/* one region for memory that fits below MMIO range */
 		phys_start = 0;
 		phys_size  = KVM_MMIO_START;
 		host_mem   = kvm->ram_start;
 
-		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem, kvm->ram_fd, 0);
 
 		/* one region for rest of memory */
 		phys_start = KVM_MMIO_START + KVM_MMIO_SIZE;
 		phys_size  = kvm->ram_size - KVM_MMIO_START;
 		host_mem   = kvm->ram_start + KVM_MMIO_START;
 
-		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem, kvm->ram_fd, 0);
 	}
 }
 
diff --git a/powerpc/kvm.c b/powerpc/kvm.c
index 8d467e9..c36c497 100644
--- a/powerpc/kvm.c
+++ b/powerpc/kvm.c
@@ -88,7 +88,7 @@ void kvm__init_ram(struct kvm *kvm)
 		    "overlaps MMIO!\n",
 		    phys_size);
 
-	kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+	kvm__register_ram(kvm, phys_start, phys_size, host_mem, kvm->ram_fd, 0);
 }
 
 void kvm__arch_set_cmdline(char *cmdline, bool video)
diff --git a/riscv/kvm.c b/riscv/kvm.c
index 4a2a3df..bb79c5d 100644
--- a/riscv/kvm.c
+++ b/riscv/kvm.c
@@ -38,7 +38,7 @@ void kvm__init_ram(struct kvm *kvm)
 	phys_size	= kvm->ram_size;
 	host_mem	= kvm->ram_start;
 
-	err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+	err = kvm__register_ram(kvm, phys_start, phys_size, host_mem, kvm->ram_fd, 0);
 	if (err)
 		die("Failed to register %lld bytes of memory at physical "
 		    "address 0x%llx [err %d]", phys_size, phys_start, err);
diff --git a/vfio/core.c b/vfio/core.c
index 3ff2c0b..ea189a0 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -255,7 +255,8 @@ int vfio_map_region(struct kvm *kvm, struct vfio_device *vdev,
 	region->host_addr = base;
 
 	ret = kvm__register_dev_mem(kvm, region->guest_phys_addr, map_size,
-				    region->host_addr);
+				    region->host_addr, vdev->fd,
+				    region->info.offset);
 	if (ret) {
 		vfio_dev_err(vdev, "failed to register region with KVM");
 		return ret;
diff --git a/x86/kvm.c b/x86/kvm.c
index 8d29904..cee82d3 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -107,7 +107,7 @@ void kvm__init_ram(struct kvm *kvm)
 		phys_size  = kvm->ram_size;
 		host_mem   = kvm->ram_start;
 
-		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem, kvm->ram_fd, 0);
 	} else {
 		/* First RAM range from zero to the PCI gap: */
 
@@ -115,7 +115,7 @@ void kvm__init_ram(struct kvm *kvm)
 		phys_size  = KVM_32BIT_GAP_START;
 		host_mem   = kvm->ram_start;
 
-		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem, kvm->ram_fd, 0);
 
 		/* Second RAM range from 4GB to the end of RAM: */
 
@@ -123,7 +123,7 @@ void kvm__init_ram(struct kvm *kvm)
 		phys_size  = kvm->ram_size - phys_start;
 		host_mem   = kvm->ram_start + phys_start;
 
-		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem, kvm->ram_fd, 0);
 	}
 }
 
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

