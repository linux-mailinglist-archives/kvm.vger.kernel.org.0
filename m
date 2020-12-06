Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335E42D0812
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgLFXkz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgLFXky (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:40:54 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48CAC0613D3
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:40:08 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id h21so12089069wmb.2
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XM32sGEjA2NXWYAKzKhgTdbipbFOwi76R5qWtxt4kUc=;
        b=Ncs0+H+gQE1fr7o37GxbbjzKAZ+KHNVELm8jGKBgLMS+T/eVT5HpkqSY3FCkmUAwnt
         VZXhyiZBQqwAByA1gEh9z5JxlveDyWZhhx1CYEAbGocruA52FLckPeYZe5+lidCB9L/d
         ztwDbNjqxhB0/xUuyb5MDVTp5Opjg6Gq6aJL1sG21723zjoXQQdpu0yu2x153r2Fc9NM
         U4j37LoiN9DzIwlIbY5QrdEO6U6pqLpnVaKZhcZwm9NwIBMsNR8rbPdLZ6ETAtC6pDh/
         8QfoR59ntau1MwlvfkhXk42Z/vZRCzRQXPSol/45BGTF9jneakXaZEcL/s8pc4gyWzK9
         CvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=XM32sGEjA2NXWYAKzKhgTdbipbFOwi76R5qWtxt4kUc=;
        b=r5u8ZKA8+eTLlgKuw8c8sBY36Kv+PS0KbIxDjuTESx697oCvyLLq6q4qdibW+aOyka
         hXji4uH4Kn7h22NvZ+gqRNZ3WZzlH8bVf0uR9qoohxBIXPaJ/ZQZ59DESm2LlM0kz2QV
         RiAkZGPujV5OdYWH1Q7VEDnsuqYbxKHu9zATdKsdmW30HJBgzVja2X/PY7M2OeoBVkjj
         BTHPgwusIgP13RK8k2lCS99luirBBTsZmwNGDUo9X9BkJX50Jc1Mm9w9IcNpabY61Tjg
         MBG3D1P3iIfvwXZOpua3LnaKHESqw65kaDZDg+9hZaDDjkS5Uj0C0nWb1OuxtqNZ/Zj0
         X/jA==
X-Gm-Message-State: AOAM532+EL79FVH+fDtq6KdW/EoyTjhHMgW63wVgSkmw46979zkNxjcs
        qHUNqqEr9fonNHMv78SRw9s=
X-Google-Smtp-Source: ABdhPJxlh5IC/oOpnriO1JnFl0cFXBOn29HlgUnDWDg1BSvBhFrPq93YsA0bYQ3pF4kE7N3nTcYigg==
X-Received: by 2002:a7b:cd91:: with SMTP id y17mr15169430wmj.171.1607298007613;
        Sun, 06 Dec 2020 15:40:07 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id 64sm11892213wmd.12.2020.12.06.15.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:40:07 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 03/19] target/mips: Remove unused headers from fpu_helper.c
Date:   Mon,  7 Dec 2020 00:39:33 +0100
Message-Id: <20201206233949.3783184-4-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206233949.3783184-1-f4bug@amsat.org>
References: <20201206233949.3783184-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/fpu_helper.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/target/mips/fpu_helper.c b/target/mips/fpu_helper.c
index 020b768e87b..956e3417d0f 100644
--- a/target/mips/fpu_helper.c
+++ b/target/mips/fpu_helper.c
@@ -21,15 +21,11 @@
  */
 
 #include "qemu/osdep.h"
-#include "qemu/main-loop.h"
 #include "cpu.h"
 #include "internal.h"
-#include "qemu/host-utils.h"
 #include "exec/helper-proto.h"
 #include "exec/exec-all.h"
 #include "exec/cpu_ldst.h"
-#include "exec/memop.h"
-#include "sysemu/kvm.h"
 #include "fpu/softfloat.h"
 
 
-- 
2.26.2

