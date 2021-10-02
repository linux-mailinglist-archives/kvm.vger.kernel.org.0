Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C9A41FBF4
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbhJBM4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:56:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233310AbhJBM4m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:56:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HQMlJLpBHn2fUxB+2/XhMlNl1C9ZrEw/LRArmGOAdEM=;
        b=JqroPGK+b3ioFC5fJzYNbHwIwD0gjhLgTD8WchAMjScyouB1rBAxelXXe2icXsJ09DtPgZ
        BdQdo32fUJs1LNKmklypCQULdR7sN3arFJrpM/BI7ahqwG8fZcuIrxhXLNykGBTiLEI91U
        MHS85HtztsRAE6FEw2sw6iRupV5acg8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-DkjUsU-9NFew_HIjEaWp5A-1; Sat, 02 Oct 2021 08:54:55 -0400
X-MC-Unique: DkjUsU-9NFew_HIjEaWp5A-1
Received: by mail-wm1-f71.google.com with SMTP id 129-20020a1c1987000000b0030cd1616fbfso7350476wmz.3
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:54:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HQMlJLpBHn2fUxB+2/XhMlNl1C9ZrEw/LRArmGOAdEM=;
        b=GY6Ue79q2wuh5+V6dMOtnvpqOlsqYZ5w8SzJDGn/jLSB8Vkav2cWiLKsgp0AoUgk9a
         vIYhBGEnybGpx0zyilzXi4VtLfejuiwDHTh9IyM+H5F5zHLxV5dntnv1tkcseJmaKSHg
         kY0OJ1ZwHFczLnV1eJmROyvEKOE/L5/Bk/YKx9Dt+vQga6MR0jie+8SxSaM0OvS0+u06
         y8shq41MU08ICeiRZuycRVhBv6ld7zHJN86YKH8wo+U6PUMj0bIORLK1NCeYh2kG6vU2
         zJKSZGTMNx+tAioFOrKlbjWNCrEIrRRANmdh+59Z3bX1efm362F2yuHqAxHSs+ZiDyq/
         TKiQ==
X-Gm-Message-State: AOAM531FeeNpsVSleTtpoOVfJyhncpaJLTzR0xeq5qaTZWGiuWjc2+x6
        HIaRfXeAGVZXSSWH9M8gX98kD/qBsENRmJkRmC5s5MtdAbadDQAYZiPJEpUKWvUTCab2RIbT2r+
        fI2P8gZitG5Bp
X-Received: by 2002:a05:600c:a05:: with SMTP id z5mr9289027wmp.73.1633179294187;
        Sat, 02 Oct 2021 05:54:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZjFxaIEu9svYHDueJWKUmqvnq/eSj6AVK+xBQ/cs0mjHbQ9g0Mh2BXrylFwcs1VzcJPeV+Q==
X-Received: by 2002:a05:600c:a05:: with SMTP id z5mr9289016wmp.73.1633179294045;
        Sat, 02 Oct 2021 05:54:54 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id m4sm10915060wml.28.2021.10.02.05.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:54:53 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Sergio Lopez <slp@redhat.com>, kvm@vger.kernel.org,
        James Bottomley <jejb@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Daniel P . Berrange" <berrange@redhat.com>
Subject: [PATCH v3 21/22] x86/sev: generate SEV kernel loader hashes in x86_load_linux
Date:   Sat,  2 Oct 2021 14:53:16 +0200
Message-Id: <20211002125317.3418648-22-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dov Murik <dovmurik@linux.ibm.com>

If SEV is enabled and a kernel is passed via -kernel, pass the hashes of
kernel/initrd/cmdline in an encrypted guest page to OVMF for SEV
measured boot.

Co-developed-by: James Bottomley <jejb@linux.ibm.com>
Signed-off-by: James Bottomley <jejb@linux.ibm.com>
Signed-off-by: Dov Murik <dovmurik@linux.ibm.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Message-Id: <20210930054915.13252-3-dovmurik@linux.ibm.com>
[PMD: Rebased on top of 0021c4765a6]
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/x86.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 41ef9a84a9f..0c7c054e3a0 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -47,6 +47,7 @@
 #include "hw/i386/fw_cfg.h"
 #include "hw/intc/i8259.h"
 #include "hw/rtc/mc146818rtc.h"
+#include "target/i386/sev_i386.h"
 
 #include "hw/acpi/cpu_hotplug.h"
 #include "hw/irq.h"
@@ -780,6 +781,7 @@ void x86_load_linux(X86MachineState *x86ms,
     const char *initrd_filename = machine->initrd_filename;
     const char *dtb_filename = machine->dtb;
     const char *kernel_cmdline = machine->kernel_cmdline;
+    SevKernelLoaderContext sev_load_ctx = {};
 
     /* Align to 16 bytes as a paranoia measure */
     cmdline_size = (strlen(kernel_cmdline) + 16) & ~15;
@@ -926,6 +928,8 @@ void x86_load_linux(X86MachineState *x86ms,
     fw_cfg_add_i32(fw_cfg, FW_CFG_CMDLINE_ADDR, cmdline_addr);
     fw_cfg_add_i32(fw_cfg, FW_CFG_CMDLINE_SIZE, strlen(kernel_cmdline) + 1);
     fw_cfg_add_string(fw_cfg, FW_CFG_CMDLINE_DATA, kernel_cmdline);
+    sev_load_ctx.cmdline_data = (char *)kernel_cmdline;
+    sev_load_ctx.cmdline_size = strlen(kernel_cmdline) + 1;
 
     if (protocol >= 0x202) {
         stl_p(header + 0x228, cmdline_addr);
@@ -1007,6 +1011,8 @@ void x86_load_linux(X86MachineState *x86ms,
         fw_cfg_add_i32(fw_cfg, FW_CFG_INITRD_ADDR, initrd_addr);
         fw_cfg_add_i32(fw_cfg, FW_CFG_INITRD_SIZE, initrd_size);
         fw_cfg_add_bytes(fw_cfg, FW_CFG_INITRD_DATA, initrd_data, initrd_size);
+        sev_load_ctx.initrd_data = initrd_data;
+        sev_load_ctx.initrd_size = initrd_size;
 
         stl_p(header + 0x218, initrd_addr);
         stl_p(header + 0x21c, initrd_size);
@@ -1065,15 +1071,32 @@ void x86_load_linux(X86MachineState *x86ms,
         load_image_size(dtb_filename, setup_data->data, dtb_size);
     }
 
-    memcpy(setup, header, MIN(sizeof(header), setup_size));
+    /*
+     * If we're starting an encrypted VM, it will be OVMF based, which uses the
+     * efi stub for booting and doesn't require any values to be placed in the
+     * kernel header.  We therefore don't update the header so the hash of the
+     * kernel on the other side of the fw_cfg interface matches the hash of the
+     * file the user passed in.
+     */
+    if (!sev_enabled()) {
+        memcpy(setup, header, MIN(sizeof(header), setup_size));
+    }
 
     fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_ADDR, prot_addr);
     fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_SIZE, kernel_size);
     fw_cfg_add_bytes(fw_cfg, FW_CFG_KERNEL_DATA, kernel, kernel_size);
+    sev_load_ctx.kernel_data = (char *)kernel;
+    sev_load_ctx.kernel_size = kernel_size;
 
     fw_cfg_add_i32(fw_cfg, FW_CFG_SETUP_ADDR, real_addr);
     fw_cfg_add_i32(fw_cfg, FW_CFG_SETUP_SIZE, setup_size);
     fw_cfg_add_bytes(fw_cfg, FW_CFG_SETUP_DATA, setup, setup_size);
+    sev_load_ctx.setup_data = (char *)setup;
+    sev_load_ctx.setup_size = setup_size;
+
+    if (sev_enabled()) {
+        sev_add_kernel_loader_hashes(&sev_load_ctx, &error_fatal);
+    }
 
     option_rom[nb_option_roms].bootindex = 0;
     option_rom[nb_option_roms].name = "linuxboot.bin";
-- 
2.31.1

