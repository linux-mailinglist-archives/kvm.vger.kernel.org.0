Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66921D0B2B
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 10:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732408AbgEMIsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 04:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732350AbgEMIsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 04:48:15 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C021FC061A0C;
        Wed, 13 May 2020 01:48:15 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id hi11so10800680pjb.3;
        Wed, 13 May 2020 01:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/I3+wT/s7Kk65oADQ2CLgGaaNPMvOxuQE89yjvQ1E24=;
        b=e6begRx7hxCpjbbCxvXuDYLe18sGoSuDKskcEfO+8REEXPq8nfxdnsZqE09epQhMMV
         MGS/cSoxE710/TRn24pYJV3UvQlY/A7QlbLIhyYIw7rkL24oXlP2M99o21OrFQ+rHW/r
         f8VWtX/sizmkQfQlOsS6O0NnsWFSZux3qfIeeyd2EYPz8aMEs55Ik1kJr2f0DWbYNrc0
         V21iPzDSJ9nTGSK8sBmfTqT00kk4XJBkq2V7zpY9y5hkaMLeuDiveTOc+CiWt8fpWbyz
         biu/quipfaOU2R74i1Q25Vox+M+AxC9R+NzAhjGR/PRiV2oHNDVlTBaGLjKRTpJsml8Y
         BFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=/I3+wT/s7Kk65oADQ2CLgGaaNPMvOxuQE89yjvQ1E24=;
        b=PpE9b7ub+zT+eatEStN6cxX1pwjf1XZtT6WmZVkBTd6FpAVaJ5fbZ4LXwy8eJjunFN
         CVEYsOTSu0rshU0e49fSF4RFtU9QF7uyJ7jTb3A0OSqmj7ph9vD3jjvu+kdg166AWqGj
         ETX3jIaJQtBn2hTwAN4uA2xo87Yu0ujseKZ2c9ULCalv1b8JIiQHAesxBfx02SkS2N1d
         pnTnfXXes+BWWtZppDx9uL9aoUomzWbg6nox5Gju7fEO7xOPGuuwXMcvjdqdFGmSPAgY
         d9+XygcDhs+bQcjmMkg/phl62N2a5Ne57ZsymvR/HBL3D484djf4I7sFSQ050uMXcYCd
         jtxQ==
X-Gm-Message-State: AGi0PubXBrw4eKff4q964AOVxrD3Lya4T3X2qTDjDiwFbiXlO1v8UaW+
        ZTTd/6xdJR1s+AQVZL2jqIk=
X-Google-Smtp-Source: APiQypK7yYy2QtKsLBgf84FtyNQlGT2cBNv2K9rStk4TP6KK0p+HMYMLwyqhBwZzUa+ASXYE38dlQQ==
X-Received: by 2002:a17:90a:3687:: with SMTP id t7mr32488135pjb.233.1589359695422;
        Wed, 13 May 2020 01:48:15 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id o21sm14645570pjr.37.2020.05.13.01.48.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 01:48:14 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V5 14/15] KVM: MIPS: Enable KVM support for Loongson-3
Date:   Wed, 13 May 2020 16:42:45 +0800
Message-Id: <1589359366-1669-15-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
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

