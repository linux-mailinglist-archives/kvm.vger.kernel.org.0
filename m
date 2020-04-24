Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554F31B72E8
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 13:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgDXLQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 07:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbgDXLQu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 07:16:50 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9F1C09B045;
        Fri, 24 Apr 2020 04:16:50 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id q18so4473225pgm.11;
        Fri, 24 Apr 2020 04:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5psEigV2OI7c+ml0RkMlQxutkkIeSg3+povGZxP2tSA=;
        b=abJQNc0ScJq0ea5IUwIAimew2xY/o4Q7soZ2bh9ejj1dRWFSYCU//hznuBazTd9nST
         LivQHFdG3tudJY63KqFytq4OpiP2BEAvLBZ97SdIACxX4wEcj1+uuH6Sry19e/m1QWfz
         0nQfwtQ897zVu+4Mb7UIkfhpYTfRJ5ANa6TKHaxXqDHFRqi76l0QQm2eWNJ6DskPhLmV
         AqdR/J7ASRAoQTKD64ruNwedudgcJ2ygLrhVBetFwpO4cv658iwcK+fmgUGa5NkhRpsT
         opNwi5f/OaAnQnDMFABVaRv15L1Co7tV7atPWOve19swRLkn7/MT6UGQXQkgMQRM35Sv
         U4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=5psEigV2OI7c+ml0RkMlQxutkkIeSg3+povGZxP2tSA=;
        b=S9Uto+1FDOa9coShOtckJ9Avy8t5t9wdIpM0JK3uashfokiTRm+R2bXMro5rl7vtbN
         3pxs2gON38VItXr399lU/2NZ5JTIABEUbOwRbBVLPnXlOIGNrJANTT2pDXhxcOQCub7e
         0edmSghqHpbquIySnzUb/HCIgV3E6sZYlsKYhDlyEjV9UhM4YZYiJa30XWqjDtA5nYnW
         OGaO0lZ59K1urHXD2FPMBR+N8rhnOaDkFapgfL+ZZcMJ80eQ3uVSojpQuZIBiMFQZKO0
         zytDO0fBtB9FXRgWDqpfkKTeOA1jLhE9klLsmXzK8u9bhnX3VLmi6umExSkaMOKkVASF
         zIcQ==
X-Gm-Message-State: AGi0Pub1/5vexxb/YIQiLAjt7FScMYYVEIZwD/CuwDdV/Bi26paBhI7/
        KCb7g4r4bcz9nSSporF3kSw=
X-Google-Smtp-Source: APiQypJ824vPIMDb5SNcaKvkUsOfRpfO75aB0TQw3R/SP1jhBWis/UKIfTBcMSSeLCsKqip086Cutg==
X-Received: by 2002:a62:a10c:: with SMTP id b12mr9457374pff.14.1587727010131;
        Fri, 24 Apr 2020 04:16:50 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id y10sm5470110pfb.53.2020.04.24.04.16.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 04:16:49 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V2 14/14] KVM: MIPS: Enable KVM support for Loongson-3
Date:   Fri, 24 Apr 2020 19:15:33 +0800
Message-Id: <1587726933-31757-15-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
References: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
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
index 0ea41be..e52955a 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -2670,7 +2670,7 @@ static int kvm_vz_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	 * prevents a SC on the next VCPU from succeeding by matching a LL on
 	 * the previous VCPU.
 	 */
-	if (cpu_guest_has_rw_llb)
+	if (vcpu->kvm->created_vcpus > 1)
 		write_gc0_lladdr(0);
 
 	return 0;
-- 
2.7.0

