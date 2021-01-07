Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4802EE880
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbhAGWZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728417AbhAGWZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:25:32 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56874C0612F6
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:25:17 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id r7so7118204wrc.5
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QyeTQF7UvXhfCkJ2JeL3ZW1k3uAkuDX0bwVNyPuFC3M=;
        b=HbwznF7eh8ZevHZw/xcKKNxfDRZuQ/AC5SmusboRY44m9RvgB/mGd0Vg2YhaHbXNW8
         knB0qnN82vHsL3MC6h/9mljFPeh0RR75AFbxrGYzCwwUjRHWeqiyzeGK9WqIEcsJpPoP
         ZVVapJ98yo9rIRenMQtnCiLDi773PAmjXNljlBzIowsL2qrddShtaX11c+92BpDaFp3I
         +uHbVhQuLWIqxTF+93X3aH5Y3k0SjGlAgGOW9c7FPuiO1p79Lak7D+hzJBroiQT/6mQM
         ExoZRhQXZ26yeS/79H7BZs6wtBK6xNw9+RYOcFXn/3fEIkGJBIhAR/6CyQMchv2xRrNf
         iGUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=QyeTQF7UvXhfCkJ2JeL3ZW1k3uAkuDX0bwVNyPuFC3M=;
        b=ji3MIQkuXFFtVPmzO6u6KSbFWGU2cUybKRXvhg6TQ1Yg7/A+g8ckNTDr6PongAPZU0
         XE+MJGiL7mFxugUxAiKuBQPrYlXF9FHz42GShCPDxVa7ZwkIuQd80aTwsT5wpLn0hdtH
         5LUMAS+ii14qAH1VbFKWQX/nc47jn9oKA3K7eBwamQ/6+BrE1giOXxxTK+yQ+N32D5P1
         3v0cloSFyy3l7vyVKl+4WO4hwoVMZVO+YTU30P9EiasbCf4LJpHCm0ur+oUYuJcbyjtY
         wa5PlEFUSRH8rKtNv+vyByG8foOpewKdMEc9n9gu4TPFr8X6SLGHiMxX8C1PaQpH+Le5
         3Z2w==
X-Gm-Message-State: AOAM530e2pT5KiJuJZUL6ocoU73koJGpc/K8pxaLT+JaseSsJIFuA7KC
        TN2Jx2EgXvjkvwOlayrQ8LQ=
X-Google-Smtp-Source: ABdhPJyH6h8WC+O5aY6j+igrFTma98XjZTCEhgTN14u1Bv21LP2Kk6nJIKKMpVHv549JiPNNjfbaMQ==
X-Received: by 2002:a05:6000:90:: with SMTP id m16mr668214wrx.165.1610058316126;
        Thu, 07 Jan 2021 14:25:16 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id s3sm8998055wmc.44.2021.01.07.14.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:25:15 -0800 (PST)
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
Subject: [PULL 27/66] target/mips: Rename translate_init.c as cpu-defs.c
Date:   Thu,  7 Jan 2021 23:22:14 +0100
Message-Id: <20210107222253.20382-28-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This file is not TCG specific, contains CPU definitions
and is consumed by cpu.c. Rename it as such.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201214183739.500368-10-f4bug@amsat.org>
---
 target/mips/cpu.c                                    | 2 +-
 target/mips/{translate_init.c.inc => cpu-defs.c.inc} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename target/mips/{translate_init.c.inc => cpu-defs.c.inc} (100%)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 26b4c3e9cd5..55c6a054bba 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -311,7 +311,7 @@ static bool mips_cpu_has_work(CPUState *cs)
     return has_work;
 }
 
-#include "translate_init.c.inc"
+#include "cpu-defs.c.inc"
 
 static void mips_cpu_reset(DeviceState *dev)
 {
diff --git a/target/mips/translate_init.c.inc b/target/mips/cpu-defs.c.inc
similarity index 100%
rename from target/mips/translate_init.c.inc
rename to target/mips/cpu-defs.c.inc
-- 
2.26.2

