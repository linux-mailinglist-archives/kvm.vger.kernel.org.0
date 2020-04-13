Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA511A63BA
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 09:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgDMHa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 03:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbgDMHaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 03:30:55 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A11EC008651;
        Mon, 13 Apr 2020 00:30:55 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mn19so3496760pjb.0;
        Mon, 13 Apr 2020 00:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lozGXI+RCcD8805GHzdbsHHUQvLgBz8cDlD+L+c1heU=;
        b=Kcx4puo8ho90L2YsbhjK/H50hA2RCXsBXZpnLgbU09+jqnjb9lQ2nhCLP8GhBwv3wR
         jNAUTY9hMqoT01OY7BLsavXjZhZTs9T6sGoxGW9eYd+3ixQ1QQa74P0ahHpcb44jEMD7
         2EklggW0EczbXKxs6hGTbgQldVb0hVGNu6hFrHUqcbFeZnFRC+ntZns9C1d6z/+2OS7o
         ezf0EIsvj4MiI+zzzRz7b5W7UG6qzqOoxtXCMoWbF0MtofE+YTyFKGKxVPC2vrjjKXuS
         H4IVbXRYGQ+phiyisGvWSHm0TGMpyWqmi5uMk2PZKKMlA5Kftg4Jl3/jTzVdtJerVF4/
         RqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=lozGXI+RCcD8805GHzdbsHHUQvLgBz8cDlD+L+c1heU=;
        b=Cov4m1zNSuY31DaGjcqgaJcQSwuC+A1piBkCiUwdLlKWWY0wigzPCW6cMI4aqEdCpn
         BpGL+m3zpMuIVatTViAIWe9pm0nzQxoRI93s0USNPHtlOTFZqHWvmyWaupc+xcNYQOjG
         NRSgVoCVLS3fNbPkEO7t9JNP28ElLx72LddhhDo2uRp9HHvfhv6oXenll3xwjo7yYj//
         T7BC3Kd40ycZ5gJQh9VoNqlzZiNqqD5je0sPUJZc+ABLrnsDiN66Wh3LrBF4xJlMb3J4
         oohiZnECN5k5AawvHFTmL8SzQtN3sKr0TLH+I2SSKxcT7uSeqUgTZBeoXtNQB464gE64
         cMlw==
X-Gm-Message-State: AGi0PuZoIlJfk7DMXlWRnrV2Q5eZEix3m0DTxoCaX317NyAduo78WqbI
        hx9Y+A0VEKm0bLe4xeeBEWY=
X-Google-Smtp-Source: APiQypJvTPl29jy0Un/24PxwFVkWS2cBvgRYlBkmJPaXAfhrOMi4sadbxXTfHq9f1iE3cmoC12OCQg==
X-Received: by 2002:a17:902:9b90:: with SMTP id y16mr15589789plp.227.1586763054390;
        Mon, 13 Apr 2020 00:30:54 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id u8sm7241341pgl.19.2020.04.13.00.30.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2020 00:30:54 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 15/15] KVM: MIPS: Enable KVM support for Loongson-3
Date:   Mon, 13 Apr 2020 15:30:24 +0800
Message-Id: <1586763024-12197-16-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
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
index a1f973c..e9a1389 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1465,6 +1465,7 @@ config CPU_LOONGSON64
 	select MIPS_L1_CACHE_SHIFT_6
 	select GPIOLIB
 	select SWIOTLB
+	select HAVE_KVM
 	help
 		The Loongson GSx64(GS264/GS464/GS464E/GS464V) series of processor
 		cores implements the MIPS64R2 instruction set with many extensions,
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 5bf0821..c46724e 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1958,6 +1958,7 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 		c->writecombine = _CACHE_UNCACHED_ACCELERATED;
 		c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
 			MIPS_ASE_LOONGSON_EXT | MIPS_ASE_LOONGSON_EXT2);
+		c->ases &= ~MIPS_ASE_VZ; /* VZ of Loongson-3A2000/3000 is incomplete */
 		break;
 	case PRID_IMP_LOONGSON_64G:
 		c->cputype = CPU_LOONGSON64;
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 2ea1f13..cddd5b0 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -2666,7 +2666,7 @@ static int kvm_vz_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	 * prevents a SC on the next VCPU from succeeding by matching a LL on
 	 * the previous VCPU.
 	 */
-	if (cpu_guest_has_rw_llb)
+	if (vcpu->kvm->created_vcpus > 1)
 		write_gc0_lladdr(0);
 
 	return 0;
-- 
2.7.0

