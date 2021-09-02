Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F563FF11E
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 18:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346296AbhIBQTD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 12:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346305AbhIBQTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 12:19:00 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D31C061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 09:18:02 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b6so3836619wrh.10
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 09:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MUUy/NWyVU2hg662wvWPJPkcXsVUh4rWx1BGsDTs1tA=;
        b=kEnHldIRSmSDQxyQdugw1Vx8L7xguo0M9caEjgWu9MaZq6gyOqkCAuD92VRjnuFYVu
         AFC1pCBYhs9ACTTeUQoUMMput3Qpo+G6rdKTIhD095mZXQogsq0uWanMgwmK05q4B113
         wHEl+rU0Lu5ECIbKPzs4FN4XtzXbG2tlJtl+zohx+CtLscNoURzNPXzDuLlX3udxNyRV
         ISqkEHEFnJiqPltUmbvOkyQ8UgtyH8boBBAz3eZMg7gCSDPvog7KSraXXpPQ+P/Y1jP/
         dnFgk5Q12dkH0yO8X+tMaBzTnLA6tV2u5dL5oZQj7YYuUZIHbs6Fs72PHNz4exx0IHfr
         tXUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=MUUy/NWyVU2hg662wvWPJPkcXsVUh4rWx1BGsDTs1tA=;
        b=cVMVsjxPt7cAOmKdyj0dbDajupTyz8twyNaf+6PKjvvyXU/o0MvmJD/VB8Kp1XTQRE
         el64I30TVY9xsxb2+8kdDLFJjptwrc3kGxQbvSqH6S8F/pvK4wzqJ0r8seBBDmu7hGw1
         nSJjTrR72gwdsHKclCGLMhbBwiVQ2TFw7C4T8nOeNqilAICMWJQxqdb+d6fS3lGBSZVC
         vT/8VC3vblOjEbndE06WyO3StHygkJwH6cI4uBVIg8yN0c/nDJQ3ThkWDvIU0Fq7JHTy
         05zJYK0hvE4tzOWVq4yprh+fJVe3isACUGFehY3jIY+D0crXmR+0Yli5cL3zUBlVVhFL
         QIRQ==
X-Gm-Message-State: AOAM532Mlqy7wErGTjjGlA6kPrX4vDgF3Kt1WoUWTFWPzo++wGGhzSU6
        FfVTI8SC2HUlL1qe8f9LoaA=
X-Google-Smtp-Source: ABdhPJwaDZNhw8vo3XF1wL5OY+S/6RqfQvS7pZENs96vrPKDQEeSMVgbBjU4oik0CYAZjXMqLcm/Gg==
X-Received: by 2002:a5d:6cca:: with SMTP id c10mr4738535wrc.224.1630599480361;
        Thu, 02 Sep 2021 09:18:00 -0700 (PDT)
Received: from x1w.. (163.red-83-52-55.dynamicip.rima-tde.net. [83.52.55.163])
        by smtp.gmail.com with ESMTPSA id c3sm2411819wrd.34.2021.09.02.09.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:17:59 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Bin Meng <bin.meng@windriver.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Greg Kurz <groug@kaod.org>, haxm-team@intel.com,
        Kamil Rytarowski <kamil@netbsd.org>, qemu-ppc@nongnu.org,
        Anthony Perard <anthony.perard@citrix.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Michael Rolnik <mrolnik@gmail.com>, qemu-riscv@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Chris Wulff <crwulff@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Taylor Simpson <tsimpson@quicinc.com>, qemu-s390x@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Paul Durrant <paul@xen.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alistair Francis <alistair.francis@wdc.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Wenchao Wang <wenchao.wang@intel.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        xen-devel@lists.xenproject.org, Marek Vasut <marex@denx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Stafford Horne <shorne@gmail.com>,
        Reinoud Zandijk <reinoud@netbsd.org>, kvm@vger.kernel.org
Subject: [PATCH v3 21/30] target/ppc: Introduce PowerPCCPUClass::has_work()
Date:   Thu,  2 Sep 2021 18:15:34 +0200
Message-Id: <20210902161543.417092-22-f4bug@amsat.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902161543.417092-1-f4bug@amsat.org>
References: <20210902161543.417092-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Each POWER cpu has its own has_work() implementation. Instead of
overloading CPUClass on each PowerPCCPUClass init, register the
generic ppc_cpu_has_work() handler, and have it call the POWER
specific has_work().

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/ppc/cpu-qom.h  |  3 +++
 target/ppc/cpu_init.c | 26 ++++++++++++++++++--------
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/target/ppc/cpu-qom.h b/target/ppc/cpu-qom.h
index 5800fa324e8..ff2bafcde6f 100644
--- a/target/ppc/cpu-qom.h
+++ b/target/ppc/cpu-qom.h
@@ -189,6 +189,9 @@ struct PowerPCCPUClass {
     int bfd_mach;
     uint32_t l1_dcache_size, l1_icache_size;
 #ifndef CONFIG_USER_ONLY
+#ifdef CONFIG_TCG
+    bool (*has_work)(CPUState *cpu);
+#endif /* CONFIG_TCG */
     unsigned int gdb_num_sprs;
     const char *gdb_spr_xml;
 #endif
diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index e2e721c2b81..bbad16cc1ec 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -7583,6 +7583,7 @@ static bool ppc_pvr_match_power7(PowerPCCPUClass *pcc, uint32_t pvr)
     return false;
 }
 
+#if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
 static bool cpu_has_work_POWER7(CPUState *cs)
 {
     PowerPCCPU *cpu = POWERPC_CPU(cs);
@@ -7616,12 +7617,12 @@ static bool cpu_has_work_POWER7(CPUState *cs)
         return msr_ee && (cs->interrupt_request & CPU_INTERRUPT_HARD);
     }
 }
+#endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
 
 POWERPC_FAMILY(POWER7)(ObjectClass *oc, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(oc);
     PowerPCCPUClass *pcc = POWERPC_CPU_CLASS(oc);
-    CPUClass *cc = CPU_CLASS(oc);
 
     dc->fw_name = "PowerPC,POWER7";
     dc->desc = "POWER7";
@@ -7630,7 +7631,6 @@ POWERPC_FAMILY(POWER7)(ObjectClass *oc, void *data)
     pcc->pcr_supported = PCR_COMPAT_2_06 | PCR_COMPAT_2_05;
     pcc->init_proc = init_proc_POWER7;
     pcc->check_pow = check_pow_nocheck;
-    cc->has_work = cpu_has_work_POWER7;
     pcc->insns_flags = PPC_INSNS_BASE | PPC_ISEL | PPC_STRING | PPC_MFTB |
                        PPC_FLOAT | PPC_FLOAT_FSEL | PPC_FLOAT_FRES |
                        PPC_FLOAT_FSQRT | PPC_FLOAT_FRSQRTE |
@@ -7673,6 +7673,7 @@ POWERPC_FAMILY(POWER7)(ObjectClass *oc, void *data)
     pcc->lpcr_pm = LPCR_P7_PECE0 | LPCR_P7_PECE1 | LPCR_P7_PECE2;
     pcc->mmu_model = POWERPC_MMU_2_06;
 #if defined(CONFIG_SOFTMMU)
+    pcc->has_work = cpu_has_work_POWER7;
     pcc->hash64_opts = &ppc_hash64_opts_POWER7;
     pcc->lrg_decr_bits = 32;
 #endif
@@ -7743,6 +7744,7 @@ static bool ppc_pvr_match_power8(PowerPCCPUClass *pcc, uint32_t pvr)
     return false;
 }
 
+#if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
 static bool cpu_has_work_POWER8(CPUState *cs)
 {
     PowerPCCPU *cpu = POWERPC_CPU(cs);
@@ -7784,12 +7786,12 @@ static bool cpu_has_work_POWER8(CPUState *cs)
         return msr_ee && (cs->interrupt_request & CPU_INTERRUPT_HARD);
     }
 }
+#endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
 
 POWERPC_FAMILY(POWER8)(ObjectClass *oc, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(oc);
     PowerPCCPUClass *pcc = POWERPC_CPU_CLASS(oc);
-    CPUClass *cc = CPU_CLASS(oc);
 
     dc->fw_name = "PowerPC,POWER8";
     dc->desc = "POWER8";
@@ -7798,7 +7800,6 @@ POWERPC_FAMILY(POWER8)(ObjectClass *oc, void *data)
     pcc->pcr_supported = PCR_COMPAT_2_07 | PCR_COMPAT_2_06 | PCR_COMPAT_2_05;
     pcc->init_proc = init_proc_POWER8;
     pcc->check_pow = check_pow_nocheck;
-    cc->has_work = cpu_has_work_POWER8;
     pcc->insns_flags = PPC_INSNS_BASE | PPC_ISEL | PPC_STRING | PPC_MFTB |
                        PPC_FLOAT | PPC_FLOAT_FSEL | PPC_FLOAT_FRES |
                        PPC_FLOAT_FSQRT | PPC_FLOAT_FRSQRTE |
@@ -7848,6 +7849,7 @@ POWERPC_FAMILY(POWER8)(ObjectClass *oc, void *data)
                    LPCR_P8_PECE3 | LPCR_P8_PECE4;
     pcc->mmu_model = POWERPC_MMU_2_07;
 #if defined(CONFIG_SOFTMMU)
+    pcc->has_work = cpu_has_work_POWER8;
     pcc->hash64_opts = &ppc_hash64_opts_POWER7;
     pcc->lrg_decr_bits = 32;
     pcc->n_host_threads = 8;
@@ -7941,6 +7943,7 @@ static bool ppc_pvr_match_power9(PowerPCCPUClass *pcc, uint32_t pvr)
     return false;
 }
 
+#if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
 static bool cpu_has_work_POWER9(CPUState *cs)
 {
     PowerPCCPU *cpu = POWERPC_CPU(cs);
@@ -7998,12 +8001,12 @@ static bool cpu_has_work_POWER9(CPUState *cs)
         return msr_ee && (cs->interrupt_request & CPU_INTERRUPT_HARD);
     }
 }
+#endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
 
 POWERPC_FAMILY(POWER9)(ObjectClass *oc, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(oc);
     PowerPCCPUClass *pcc = POWERPC_CPU_CLASS(oc);
-    CPUClass *cc = CPU_CLASS(oc);
 
     dc->fw_name = "PowerPC,POWER9";
     dc->desc = "POWER9";
@@ -8013,7 +8016,6 @@ POWERPC_FAMILY(POWER9)(ObjectClass *oc, void *data)
                          PCR_COMPAT_2_05;
     pcc->init_proc = init_proc_POWER9;
     pcc->check_pow = check_pow_nocheck;
-    cc->has_work = cpu_has_work_POWER9;
     pcc->insns_flags = PPC_INSNS_BASE | PPC_ISEL | PPC_STRING | PPC_MFTB |
                        PPC_FLOAT | PPC_FLOAT_FSEL | PPC_FLOAT_FRES |
                        PPC_FLOAT_FSQRT | PPC_FLOAT_FRSQRTE |
@@ -8062,6 +8064,7 @@ POWERPC_FAMILY(POWER9)(ObjectClass *oc, void *data)
     pcc->lpcr_pm = LPCR_PDEE | LPCR_HDEE | LPCR_EEE | LPCR_DEE | LPCR_OEE;
     pcc->mmu_model = POWERPC_MMU_3_00;
 #if defined(CONFIG_SOFTMMU)
+    pcc->has_work = cpu_has_work_POWER9;
     /* segment page size remain the same */
     pcc->hash64_opts = &ppc_hash64_opts_POWER7;
     pcc->radix_page_info = &POWER9_radix_page_info;
@@ -8150,6 +8153,7 @@ static bool ppc_pvr_match_power10(PowerPCCPUClass *pcc, uint32_t pvr)
     return false;
 }
 
+#if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
 static bool cpu_has_work_POWER10(CPUState *cs)
 {
     PowerPCCPU *cpu = POWERPC_CPU(cs);
@@ -8207,12 +8211,12 @@ static bool cpu_has_work_POWER10(CPUState *cs)
         return msr_ee && (cs->interrupt_request & CPU_INTERRUPT_HARD);
     }
 }
+#endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
 
 POWERPC_FAMILY(POWER10)(ObjectClass *oc, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(oc);
     PowerPCCPUClass *pcc = POWERPC_CPU_CLASS(oc);
-    CPUClass *cc = CPU_CLASS(oc);
 
     dc->fw_name = "PowerPC,POWER10";
     dc->desc = "POWER10";
@@ -8223,7 +8227,6 @@ POWERPC_FAMILY(POWER10)(ObjectClass *oc, void *data)
                          PCR_COMPAT_2_06 | PCR_COMPAT_2_05;
     pcc->init_proc = init_proc_POWER10;
     pcc->check_pow = check_pow_nocheck;
-    cc->has_work = cpu_has_work_POWER10;
     pcc->insns_flags = PPC_INSNS_BASE | PPC_ISEL | PPC_STRING | PPC_MFTB |
                        PPC_FLOAT | PPC_FLOAT_FSEL | PPC_FLOAT_FRES |
                        PPC_FLOAT_FSQRT | PPC_FLOAT_FRSQRTE |
@@ -8275,6 +8278,7 @@ POWERPC_FAMILY(POWER10)(ObjectClass *oc, void *data)
     pcc->lpcr_pm = LPCR_PDEE | LPCR_HDEE | LPCR_EEE | LPCR_DEE | LPCR_OEE;
     pcc->mmu_model = POWERPC_MMU_3_00;
 #if defined(CONFIG_SOFTMMU)
+    pcc->has_work = cpu_has_work_POWER10;
     /* segment page size remain the same */
     pcc->hash64_opts = &ppc_hash64_opts_POWER7;
     pcc->radix_page_info = &POWER10_radix_page_info;
@@ -8796,6 +8800,12 @@ static bool ppc_cpu_has_work(CPUState *cs)
     PowerPCCPU *cpu = POWERPC_CPU(cs);
     CPUPPCState *env = &cpu->env;
 
+    if (cs->halted) {
+        PowerPCCPUClass *pcc = POWERPC_CPU_GET_CLASS(cpu);
+
+        return pcc->has_work(cs);
+    }
+
     return msr_ee && (cs->interrupt_request & CPU_INTERRUPT_HARD);
 }
 #endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
-- 
2.31.1

