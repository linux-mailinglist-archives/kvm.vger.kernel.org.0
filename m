Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A381C2B44
	for <lists+kvm@lfdr.de>; Sun,  3 May 2020 12:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgECKQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 06:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728018AbgECKQZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 3 May 2020 06:16:25 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5161CC061A0C;
        Sun,  3 May 2020 03:16:24 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t16so5593626plo.7;
        Sun, 03 May 2020 03:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HudJgUttq/EyxeqvRwzUzJD5SKyuTwPsUUoI6cg1zZc=;
        b=vbio7Q7J3YCQHxexqOleieZ/AttVYNhKO0Vw5zNli40i66QgMMlSkEKFg4S6cH0TZX
         9b9A9cmYi4imlMPkE690r1SZKbtblh4Z+19P0S6zEn2Lsa6WzN9XinwS/in528B6lz4V
         wCD5Um/dhvKlxxhx4klB8UcT1aft/KL6rLJp0ZHN9xrR6uVdvUG0lOsFitrdw2zl3Hr+
         kXYNerQzki3xNkK8ArHfGhRTOOtdR29zRP8bzTkqilt6TNndhkFyGfebmAsnBxgH83Um
         2VPEOe66kAWJ2jsuuSNTpxegPrZAkQGCKy3VW90mn8Z7ByhPQ7rL6mMCK9RON1F73EdU
         bqSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=HudJgUttq/EyxeqvRwzUzJD5SKyuTwPsUUoI6cg1zZc=;
        b=Iz7AziR02HO1ncOzWOifSp9yf7bg3MKAqLNLOjTPUFOV03z8XNA39e3f+yX6BjPYyw
         ZB9F1Bd3Wmlp+CTr2YtzUpoI/6Vh/xn6QSAi21M6O9VZOg9T3L5wN6AwmYIJIyf8wIlu
         mirpsuwUN2SiCJU1h+V8x6TTPgD/kd3hsnNOg+TMcTIcVnz7EknbdMKbvBoq0INbS+TG
         Qr4VJrVd7Y9+9eFLWbPIQfEId0fj0Rdkhw14tvhrc3HTK6yCvPlNHt71zNmuw0HAOVhg
         dymGJYM3pmcuNW3Sxf9dPAzhVq63Td7MhCjcs6jWzwPvdym8KnUU1kCBsYtnSnFHKnpe
         AjZA==
X-Gm-Message-State: AGi0PuZziX1FD1QaQY6x/kkLyh/1IJ8sG8lmqzfw+VZWag9TSMtQO0r+
        mLzgxxvuYGh0poEuG38IYN0=
X-Google-Smtp-Source: APiQypIwJj+rd0+MQLSUwqg1TywA+fgdVJ2UWDufcbcYGOv2W2qRazHjEwE2Vigfg/sa1Ck2Jb8X4w==
X-Received: by 2002:a17:90a:e2d0:: with SMTP id fr16mr10748013pjb.146.1588500983883;
        Sun, 03 May 2020 03:16:23 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id r26sm6329902pfq.75.2020.05.03.03.16.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 May 2020 03:16:23 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V3 14/14] KVM: MIPS: Enable KVM support for Loongson-3
Date:   Sun,  3 May 2020 18:06:07 +0800
Message-Id: <1588500367-1056-15-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch enable KVM support for Loongson-3 by selecting HAVE_KVM, but
only enable KVM/VZ on Loongson-3A R4+ (because VZ of early processors
are incomplete). Besides, Loongson-3 support SMP guests, so we clear the
linked load bit of LLAddr in kvm_vz_vcpu_load() if the guest has more
than one VCPUs.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/Kconfig            | 1 +
 arch/mips/kernel/cpu-probe.c | 1 +
 arch/mips/kvm/vz.c           | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 9f15539..9c4bdac 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1470,6 +1470,7 @@ config CPU_LOONGSON64
 	select MIPS_L1_CACHE_SHIFT_6
 	select GPIOLIB
 	select SWIOTLB
+	select HAVE_KVM
 	help
 		The Loongson GSx64(GS264/GS464/GS464E/GS464V) series of processor
 		cores implements the MIPS64R2 instruction set with many extensions,
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index be1b556..4432442 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -2008,6 +2008,7 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 		c->writecombine = _CACHE_UNCACHED_ACCELERATED;
 		c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
 			MIPS_ASE_LOONGSON_EXT | MIPS_ASE_LOONGSON_EXT2);
+		c->ases &= ~MIPS_ASE_VZ; /* VZ of Loongson-3A2000/3000 is incomplete */
 		break;
 	case PRID_IMP_LOONGSON_64G:
 		c->cputype = CPU_LOONGSON64;
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index fc0f8d5..5f877a9 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -2695,7 +2695,7 @@ static int kvm_vz_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	 * prevents a SC on the next VCPU from succeeding by matching a LL on
 	 * the previous VCPU.
 	 */
-	if (cpu_guest_has_rw_llb)
+	if (vcpu->kvm->created_vcpus > 1)
 		write_gc0_lladdr(0);
 
 	return 0;
-- 
2.7.0

