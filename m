Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BD72EE86B
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbhAGWYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbhAGWYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:24:38 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359D2C0612F4
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:23:39 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id m5so7106804wrx.9
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3dEWbpDdPMdXRy3J2F2mLkOfTaazaI9EIz5mLCDLiyI=;
        b=p2wlxoD+bjz1+F87HnT7tDhsQOxdcVzIyFkuIE3U4oPHj40yxiscOCY+dXYiL3ICrg
         mqPBZpgZBMQRkCMgK1R+TPfHPoD8T+d48Fv7Pkncg5T27cjabl0+N+O+KXX/irjfqDbi
         2f/9Ez1jUY8CTttxB+bRS10U5cALJfSX/X344oS24ziGYkLG+RRF1evG5B/M+6GbeiYN
         wjY4kIcRsSjbB8UBCMLDCh7M+G7LvWUEp2hxjyQINOsdjaxxq/5Dwi9txEx4vOmbN4EU
         P/LQfWGsfCs/bTvxxM6puvA+GLFIJefEYZW3ifeQ70JxhCw/hUhNPzhdLN1Xc1EEfJKH
         V0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=3dEWbpDdPMdXRy3J2F2mLkOfTaazaI9EIz5mLCDLiyI=;
        b=tqfbWQ4xmBFIedHw2llcrFGmrS0DRxsx+FkJJV/p9bt9Sqj1A1hDehTV553fczbqYG
         ZGnbEJpY+0J00SaF1E9fUOYWSi+w4jghXdu6Q+/AAuwyDqVoBnb7qkftkZLQmjGHrAka
         uvzqHwWfAtixrtoXZYq39r3Zd6uvIBrQAPe02XZOglIbgwFeJfkzS1wdrelLxolYGQ+C
         DWa0XAEFyZgCWSnh71ZvYYMvOpwXFyzRot2YvZ5RtKf2oMcJuXj4K7XdXS9zYcR88XOh
         TgUdz8/YprUggqIKVxWjGreRmbZQz8APDQZGaHyZgRe04KtoSQLJBpJgUR2mcRCp7WtY
         k+Og==
X-Gm-Message-State: AOAM532I/rA1htK1S79ClO+03K6g8p9+b+jzMf/sAnVnsDMSf8lilVMK
        EgfxMFB3wi8aRQeNFOyCW3M=
X-Google-Smtp-Source: ABdhPJxWBSZI/e+jPEoF1RloYNcT970YP2LcN6V5aQKKkXis7I1KbpzS65Ja/lqCJkM2rDokmSLgMg==
X-Received: by 2002:adf:dd90:: with SMTP id x16mr645299wrl.85.1610058218031;
        Thu, 07 Jan 2021 14:23:38 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id o13sm11872381wrh.88.2021.01.07.14.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:23:37 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     libvir-list@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 08/66] hw/mips/boston: Check 64-bit support with cpu_type_is_64bit()
Date:   Thu,  7 Jan 2021 23:21:55 +0100
Message-Id: <20210107222253.20382-9-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Directly check if the CPU supports 64-bit with the recently
added cpu_type_is_64bit() helper (inlined).

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20210104221154.3127610-6-f4bug@amsat.org>
---
 hw/mips/boston.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/hw/mips/boston.c b/hw/mips/boston.c
index c3b94c68e1b..467fbc1c8be 100644
--- a/hw/mips/boston.c
+++ b/hw/mips/boston.c
@@ -444,7 +444,6 @@ static void boston_mach_init(MachineState *machine)
     DriveInfo *hd[6];
     Chardev *chr;
     int fw_size, fit_err;
-    bool is_64b;
 
     if ((machine->ram_size % GiB) ||
         (machine->ram_size > (2 * GiB))) {
@@ -463,8 +462,6 @@ static void boston_mach_init(MachineState *machine)
         exit(1);
     }
 
-    is_64b = cpu_type_supports_isa(machine->cpu_type, ISA_MIPS64);
-
     object_initialize_child(OBJECT(machine), "cps", &s->cps, TYPE_MIPS_CPS);
     object_property_set_str(OBJECT(&s->cps), "cpu-type", machine->cpu_type,
                             &error_fatal);
@@ -545,7 +542,8 @@ static void boston_mach_init(MachineState *machine)
         }
 
         gen_firmware(memory_region_get_ram_ptr(flash) + 0x7c00000,
-                     s->kernel_entry, s->fdt_base, is_64b);
+                     s->kernel_entry, s->fdt_base,
+                     cpu_type_is_64bit(machine->cpu_type));
     } else if (!qtest_enabled()) {
         error_report("Please provide either a -kernel or -bios argument");
         exit(1);
-- 
2.26.2

