Return-Path: <kvm+bounces-1663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFF357EB285
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:39:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E33D01C20AE6
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF7341741;
	Tue, 14 Nov 2023 14:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c1Yh6aSh"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158894123C
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:39:31 +0000 (UTC)
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907201B5
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:39:29 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-507a98517f3so7531577e87.0
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972768; x=1700577568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BqgJC9hPHkcXARLwNhCfo2KLP+5VvJiIzbHQjbp4PnI=;
        b=c1Yh6aShjZoPuVGLu7HGWvocpI8dpq3/aYgkpPmU+Gk+Wr3fdra3WTuXAJH9VlQ4RB
         LCeLf3HyT1Wiyyod6TRxvYWhtLWAMeJVWqu8pszmqhlrzoa9xNjOe0IL7gpUY0kWjUXa
         PhtcIfk3Mj+R8fXmTqmgXYyPo+CWm3pxfjJc1DuVG4AWzsqqKYfRgFUKkl49rE2ZHJqN
         fOhcf06MKYadaqyobc8hILriqOQ7BRZisQSWeoMhxjOAp7HpvUBKkzTPAJR7DAEJU13J
         o9C6a0AN7gvsjoxxtpBuMsS9HELMWBA0A9Oaf3QZWRm/sgdbDJ9QonnqOC5toh1tqBh3
         HakQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972768; x=1700577568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BqgJC9hPHkcXARLwNhCfo2KLP+5VvJiIzbHQjbp4PnI=;
        b=uQN8fgmhRgSX20Z+IY/Zj2i8W8EgjazrelQEBMA4ivlUpiyc191YVxYjLbcDZEiFnQ
         qnlnfEwwvoVuAjnI3+K3lablx+3YOxT2FRYwDuMSQC6fcAZ61mN9D2ljOFfZf4RJVMvl
         KQXYgr04K54x42dWTSy4mUV4ZQwtiwr2SIQx9PmM+xPqK3kHrHcI3Yzc39TQHC/sNuMI
         oHF3Aw43cGJu5eGj0bg1lDcoBnL7amqyZMYqhksD8Z7cMEuPe5tpMSgNkxIZi/qS+0jn
         3HkjheciEfUMk5tG3JOFtOOVmEzbjWQV4uR6fSZIgD55s/eD1dx8xCSTWECZlh07XpQq
         COug==
X-Gm-Message-State: AOJu0YyxFLIqNneVQNWaaoNwK02jT6TxpFOtwF/S1/PTo2+EOT1iLf/g
	O0xxb0/x2iFvnJb0PWzoznwTlg==
X-Google-Smtp-Source: AGHT+IG5cdmuSMLF1QQ3nk9d4MKQ+Rf9u6gyzBn2OUTA0N6PdU8Lc7kj9gwB2wtfxvTcro7nwctRJA==
X-Received: by 2002:a05:6512:3d90:b0:507:9a49:2d3d with SMTP id k16-20020a0565123d9000b005079a492d3dmr7641727lfv.31.1699972767814;
        Tue, 14 Nov 2023 06:39:27 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id c19-20020a50f613000000b00542d3e470f9sm5256915edn.10.2023.11.14.06.39.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:39:27 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: David Woodhouse <dwmw@amazon.co.uk>,
	qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	xen-devel@lists.xenproject.org,
	qemu-block@nongnu.org,
	Anthony Perard <anthony.perard@citrix.com>,
	kvm@vger.kernel.org,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: [PATCH-for-9.0 v2 10/19] hw/xen: Rename 'ram_memory' global variable as 'xen_memory'
Date: Tue, 14 Nov 2023 15:38:06 +0100
Message-ID: <20231114143816.71079-11-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231114143816.71079-1-philmd@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

To avoid a potential global variable shadow in
hw/i386/pc_piix.c::pc_init1(), rename Xen's
"ram_memory" as "xen_memory".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/xen/xen-hvm-common.h |  2 +-
 hw/arm/xen_arm.c                |  6 +++---
 hw/i386/xen/xen-hvm.c           | 10 +++++-----
 hw/xen/xen-hvm-common.c         |  6 +++---
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/hw/xen/xen-hvm-common.h b/include/hw/xen/xen-hvm-common.h
index 4e9904f1a6..d3fa5ed29b 100644
--- a/include/hw/xen/xen-hvm-common.h
+++ b/include/hw/xen/xen-hvm-common.h
@@ -16,7 +16,7 @@
 #include "qemu/error-report.h"
 #include <xen/hvm/ioreq.h>
 
-extern MemoryRegion ram_memory;
+extern MemoryRegion xen_memory;
 extern MemoryListener xen_io_listener;
 extern DeviceListener xen_device_listener;
 
diff --git a/hw/arm/xen_arm.c b/hw/arm/xen_arm.c
index a5631529d0..8a185da193 100644
--- a/hw/arm/xen_arm.c
+++ b/hw/arm/xen_arm.c
@@ -111,17 +111,17 @@ static void xen_init_ram(MachineState *machine)
         block_len = GUEST_RAM1_BASE + ram_size[1];
     }
 
-    memory_region_init_ram(&ram_memory, NULL, "xen.ram", block_len,
+    memory_region_init_ram(&xen_memory, NULL, "xen.ram", block_len,
                            &error_fatal);
 
-    memory_region_init_alias(&ram_lo, NULL, "xen.ram.lo", &ram_memory,
+    memory_region_init_alias(&ram_lo, NULL, "xen.ram.lo", &xen_memory,
                              GUEST_RAM0_BASE, ram_size[0]);
     memory_region_add_subregion(sysmem, GUEST_RAM0_BASE, &ram_lo);
     DPRINTF("Initialized region xen.ram.lo: base 0x%llx size 0x%lx\n",
             GUEST_RAM0_BASE, ram_size[0]);
 
     if (ram_size[1] > 0) {
-        memory_region_init_alias(&ram_hi, NULL, "xen.ram.hi", &ram_memory,
+        memory_region_init_alias(&ram_hi, NULL, "xen.ram.hi", &xen_memory,
                                  GUEST_RAM1_BASE, ram_size[1]);
         memory_region_add_subregion(sysmem, GUEST_RAM1_BASE, &ram_hi);
         DPRINTF("Initialized region xen.ram.hi: base 0x%llx size 0x%lx\n",
diff --git a/hw/i386/xen/xen-hvm.c b/hw/i386/xen/xen-hvm.c
index f42621e674..1ae943370b 100644
--- a/hw/i386/xen/xen-hvm.c
+++ b/hw/i386/xen/xen-hvm.c
@@ -149,12 +149,12 @@ static void xen_ram_init(PCMachineState *pcms,
          */
         block_len = (4 * GiB) + x86ms->above_4g_mem_size;
     }
-    memory_region_init_ram(&ram_memory, NULL, "xen.ram", block_len,
+    memory_region_init_ram(&xen_memory, NULL, "xen.ram", block_len,
                            &error_fatal);
-    *ram_memory_p = &ram_memory;
+    *ram_memory_p = &xen_memory;
 
     memory_region_init_alias(&ram_640k, NULL, "xen.ram.640k",
-                             &ram_memory, 0, 0xa0000);
+                             &xen_memory, 0, 0xa0000);
     memory_region_add_subregion(sysmem, 0, &ram_640k);
     /* Skip of the VGA IO memory space, it will be registered later by the VGA
      * emulated device.
@@ -163,12 +163,12 @@ static void xen_ram_init(PCMachineState *pcms,
      * the Options ROM, so it is registered here as RAM.
      */
     memory_region_init_alias(&ram_lo, NULL, "xen.ram.lo",
-                             &ram_memory, 0xc0000,
+                             &xen_memory, 0xc0000,
                              x86ms->below_4g_mem_size - 0xc0000);
     memory_region_add_subregion(sysmem, 0xc0000, &ram_lo);
     if (x86ms->above_4g_mem_size > 0) {
         memory_region_init_alias(&ram_hi, NULL, "xen.ram.hi",
-                                 &ram_memory, 0x100000000ULL,
+                                 &xen_memory, 0x100000000ULL,
                                  x86ms->above_4g_mem_size);
         memory_region_add_subregion(sysmem, 0x100000000ULL, &ram_hi);
     }
diff --git a/hw/xen/xen-hvm-common.c b/hw/xen/xen-hvm-common.c
index 565dc39c8f..cf4053c9f2 100644
--- a/hw/xen/xen-hvm-common.c
+++ b/hw/xen/xen-hvm-common.c
@@ -9,7 +9,7 @@
 #include "hw/boards.h"
 #include "hw/xen/arch_hvm.h"
 
-MemoryRegion ram_memory;
+MemoryRegion xen_memory;
 
 void xen_ram_alloc(ram_addr_t ram_addr, ram_addr_t size, MemoryRegion *mr,
                    Error **errp)
@@ -26,7 +26,7 @@ void xen_ram_alloc(ram_addr_t ram_addr, ram_addr_t size, MemoryRegion *mr,
         return;
     }
 
-    if (mr == &ram_memory) {
+    if (mr == &xen_memory) {
         return;
     }
 
@@ -53,7 +53,7 @@ static void xen_set_memory(struct MemoryListener *listener,
 {
     XenIOState *state = container_of(listener, XenIOState, memory_listener);
 
-    if (section->mr == &ram_memory) {
+    if (section->mr == &xen_memory) {
         return;
     } else {
         if (add) {
-- 
2.41.0


