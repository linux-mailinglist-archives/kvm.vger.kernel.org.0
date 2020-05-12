Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593351CF2A8
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 12:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbgELKgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 06:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726891AbgELKgI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 06:36:08 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431ACC061A0C;
        Tue, 12 May 2020 03:36:08 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id f6so5965071pgm.1;
        Tue, 12 May 2020 03:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HudJgUttq/EyxeqvRwzUzJD5SKyuTwPsUUoI6cg1zZc=;
        b=GU3noXNgJuPa7RFB6wEDQ806tcCxACmSECXjfBbcyfkr83AAYkw77kS58RDvgcbsR+
         TgpxzPwbXOIweZGlGRnJqMk1AYghYfbmKacnqQ7MMnVCCjdcN1CPM5l8VJ4ByjqSfXa6
         Ac/Sswnw7SR2qlNRlHWyU5J+6eLvCZrNvy5IsYOktPCaWHU28O4ILwQ4JbkSs82qWfSl
         Z/zCjU1b5wqfregNJaif/NF6LdV5OnAzq7dvJSYOUiWGkauTKLZmWGczpjyyD9VzNpaR
         7ZIdERIwm/z6TVlB7jslDUZay720qCoctFJ/FmDERdN2qkg3jPByHoTL+iwJe/2Ix8YD
         0veQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=HudJgUttq/EyxeqvRwzUzJD5SKyuTwPsUUoI6cg1zZc=;
        b=ks/JlM6c81sT7UmPnauGDdDTyZcxyzjYmN9o1A86Q90hnnLxtOhIWivw+zUmTA7Ew+
         5h7AWVN3JkYWXQXjRpUsokO7Q+h8Rg81WBT155h2ztTeBbAJT/PvtXHVzOAzYrwmsvTh
         V5Z9JEXGNtPhUj9VzJ0NBQXjq/VmMnfpZtWyn0ggrJAoPVGy2fk4lzg0BP7VXxBTjDEK
         Sb7P6LYw4KDX2dC0IEeX7r7ZbmwL+mb611BoOBVUV2q2YyUM+3K45PyOHhv2SB8s9hnz
         q0xodVHHCv8tqAPsxd4VMYHj68/Eu6zaZTMZdHsE/bDnHROMJo47Swq8G9bG9Rkv2nOK
         /yxw==
X-Gm-Message-State: AGi0PuYMbYrJmq02fjKF+c4Uy4TIfBFAdeyPosJugwX8YpYvuKzGNeuW
        phHfIZHLn/2mIrKqfusnwdE=
X-Google-Smtp-Source: APiQypIanoKOpz29E9xOuus7JwHmdcpYbmKLudL/bTfWSOwoyNdMc7PuE1MYizlzrrz//r3I7UBLhw==
X-Received: by 2002:aa7:9dc7:: with SMTP id g7mr20506447pfq.291.1589279767865;
        Tue, 12 May 2020 03:36:07 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id q11sm11617094pfl.97.2020.05.12.03.36.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 May 2020 03:36:07 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V4 14/14] KVM: MIPS: Enable KVM support for Loongson-3
Date:   Tue, 12 May 2020 18:31:20 +0800
Message-Id: <1589279480-27722-15-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
References: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
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

