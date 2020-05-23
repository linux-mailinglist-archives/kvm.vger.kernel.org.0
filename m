Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D5C1DF5F2
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 10:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387750AbgEWIEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 04:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387627AbgEWIEF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 04:04:05 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672B0C061A0E;
        Sat, 23 May 2020 01:04:05 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z64so1754901pfb.1;
        Sat, 23 May 2020 01:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GcNjUC8+FQGiWISz7sNyZr0sACzYWzv953HqOAl2GuE=;
        b=ta3KzncfrCmWacqzLka1nrySD+w1uUGD9Ab1dTXzNqcPF4XTCZc+Z6indLRL2hikjM
         /OuK0J5wIELk7MMajGmtQ5LhUbLFY2r042YdwV0oBDLBRzdR47d+XinFkvYnL/6oaq85
         e+e+JXRUSWKWlefqqvRQu7Vu3MVTKv7Xw0Y74q0D8zPUPQNNyh3bi8zMAY+WYx1+oj9Z
         hlIqCXCdZHCi0jl4CQMroOmcp7u9MMrBZOO7ldLY0OCo85Q7HF05Zk1uwOWShQqXh6aE
         T7Lnx5PbIBByOxH8qdbWMiPOtQ0NqoVLmKVxD0ySgcX5DUmYcWykoA+0IFhPOH/dmJ6T
         Vpvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=GcNjUC8+FQGiWISz7sNyZr0sACzYWzv953HqOAl2GuE=;
        b=Wo5aOZA6dKX5gHP+fQqLCMBft9cJ2YSoI/1kcp4JiXrKwnsE2FD0Pwso93EwfChl91
         6dIgUFXxC/mdE9LOr27DuP6TdxiIDUzW5+FZfKI7DZp3KVq2DFmrZlqeJ467iKdG+jN9
         YhnpA8Zpb7pGO4Iw1t3sFO05YeVOosg6ft6taP18x6KrNS6q61Whr01IN7slN5Oqo/+f
         MawGSmWgqy1tZ7ClWVB3GGhXQ8emGFzVXEYV5JkFvFgMGNTf9VckoNbCW5YCDabEsM87
         uDJSN1Nst7BGIKJNR4sVf9A+TTKcGwjLPssxfwGZ9x30TpozuaMCzNqmwUkLjeAzwwrW
         b4Rg==
X-Gm-Message-State: AOAM533oGqfuwc50xHQTkWBcIIRSnvW0QArHX1wpBPp+lVVary/O9xoC
        2d9iCUyczDzfllEjTwAp7pY=
X-Google-Smtp-Source: ABdhPJwpaNDZUWb7NcT8MIMGjwxTlr2WerEjlPMwnqPUSfeVsELpBtGa4CCQc2RWId3ogdQFyx3kGg==
X-Received: by 2002:a63:5646:: with SMTP id g6mr18018835pgm.315.1590221045025;
        Sat, 23 May 2020 01:04:05 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id w7sm678491pfu.117.2020.05.23.01.04.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 May 2020 01:04:04 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V7 14/15] KVM: MIPS: Enable KVM support for Loongson-3
Date:   Sat, 23 May 2020 15:56:41 +0800
Message-Id: <1590220602-3547-15-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
References: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch enable KVM support for Loongson-3 by selecting HAVE_KVM, but
only enable KVM/VZ on Loongson-3A R4+ (because VZ of early processors
are incomplete). Besides, Loongson-3 support SMP guests, so we clear the
linked load bit of LLAddr in kvm_vz_vcpu_load() if the guest has more
than one VCPUs.

Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/Kconfig            | 1 +
 arch/mips/kernel/cpu-probe.c | 1 +
 arch/mips/kvm/vz.c           | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ce1aacc..3a15f2b 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1405,6 +1405,7 @@ config CPU_LOONGSON64
 	select MIPS_L1_CACHE_SHIFT_6
 	select GPIOLIB
 	select SWIOTLB
+	select HAVE_KVM
 	help
 		The Loongson GSx64(GS264/GS464/GS464E/GS464V) series of processor
 		cores implements the MIPS64R2 instruction set with many extensions,
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 319c250..415fbd2 100644
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
index 73701c3..dc753d0 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -2697,7 +2697,7 @@ static int kvm_vz_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	 * prevents a SC on the next VCPU from succeeding by matching a LL on
 	 * the previous VCPU.
 	 */
-	if (cpu_guest_has_rw_llb)
+	if (vcpu->kvm->created_vcpus > 1)
 		write_gc0_lladdr(0);
 
 	return 0;
-- 
2.7.0

