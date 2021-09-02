Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4953FF11F
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 18:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346284AbhIBQTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 12:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346300AbhIBQTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 12:19:10 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D75C0613CF
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 09:18:09 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id g135so1663695wme.5
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 09:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UWFl0S8+QJmSRfKpaWNU58d5jvI099dEW79c4Eds8Co=;
        b=qyX0fbK8beMEiA2sBSgl3PW3ky5dGcSVCBtTwKFMLbBLTDoVjxKFiSsk0jDC/pFJh8
         EQJ9wt19ZKu7z9D2NO2X1GBhffNKLdpe3QtarXXg5bKru7SgrpNFq7ykSau/rj7BWEMU
         1lB3fKoh6dEiYxH/wEudtnGa9nyEo7DeltzASvLMnmAUaT41c/G+J+JRbl3ezoYTAza1
         Y+ETvUqkI+1eP+JhGzMn2Azr7F5hdjAx5ZUxT+4ueBQ0CSz4Bd282avi1jucNAchPVMA
         9SsBqrFRz0Y5wm79SMIMZa6Daop/L/LafP8vvrGNOlI29+ElFdjMqyjQo9hpcEC0Ade/
         GupA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=UWFl0S8+QJmSRfKpaWNU58d5jvI099dEW79c4Eds8Co=;
        b=p1MEyBNDEESXQnGdFNrPg9ImJDq2i+YKC+AU45iECagGPqrw9Gy//40EPJOTVoEz5w
         7bus6eDSRJpUDhUAkgcZlaRCaJ7HTEegfSze8n/FFQ98sPkbRm75IIHb58+q2KbstYkT
         nh04QeBIbRv5Vr8xr8yhGLavPAe7DyCO7Msik7cBsoDdpvBRz3BELRzq7NPVLSZQMiND
         uflC7u7ooHO+GqhiAoMwj8OAnBWDEqor3E0S16nW4UUb2evlZBbtq+/33yOM7B+qNe2v
         wAeVkUnEoChxsbxkc6ZDZzrb+1CWmlm8y99u1/mplhHcicTzUanmaxQY+WdDfAH5dU8g
         hJaA==
X-Gm-Message-State: AOAM533oHf7Hl+KmshaTcJpxfyvxlLzdiwWHFRdkoR07aQf546eEFosS
        q81sMNwwYj5Go5VDWW/34/E=
X-Google-Smtp-Source: ABdhPJxiiVaTYWvAG9DN++m79S0TQSTDr2C/1kQW8ctmk5/+oYLKUYcjyiQjFsrDz4LSrxOSg3eaUA==
X-Received: by 2002:a1c:202:: with SMTP id 2mr3928971wmc.122.1630599486805;
        Thu, 02 Sep 2021 09:18:06 -0700 (PDT)
Received: from x1w.. (163.red-83-52-55.dynamicip.rima-tde.net. [83.52.55.163])
        by smtp.gmail.com with ESMTPSA id k14sm2234887wri.46.2021.09.02.09.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:18:06 -0700 (PDT)
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
Subject: [PATCH v3 22/30] target/ppc: Simplify has_work() handlers
Date:   Thu,  2 Sep 2021 18:15:35 +0200
Message-Id: <20210902161543.417092-23-f4bug@amsat.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902161543.417092-1-f4bug@amsat.org>
References: <20210902161543.417092-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The common ppc_cpu_has_work() handler already checks for cs->halted,
so we can simplify all callees.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/ppc/cpu_init.c | 294 ++++++++++++++++++++----------------------
 1 file changed, 138 insertions(+), 156 deletions(-)

diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index bbad16cc1ec..c8ec47d58fa 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -7589,33 +7589,29 @@ static bool cpu_has_work_POWER7(CPUState *cs)
     PowerPCCPU *cpu = POWERPC_CPU(cs);
     CPUPPCState *env = &cpu->env;
 
-    if (cs->halted) {
-        if (!(cs->interrupt_request & CPU_INTERRUPT_HARD)) {
-            return false;
-        }
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_EXT)) &&
-            (env->spr[SPR_LPCR] & LPCR_P7_PECE0)) {
-            return true;
-        }
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_DECR)) &&
-            (env->spr[SPR_LPCR] & LPCR_P7_PECE1)) {
-            return true;
-        }
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_MCK)) &&
-            (env->spr[SPR_LPCR] & LPCR_P7_PECE2)) {
-            return true;
-        }
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_HMI)) &&
-            (env->spr[SPR_LPCR] & LPCR_P7_PECE2)) {
-            return true;
-        }
-        if (env->pending_interrupts & (1u << PPC_INTERRUPT_RESET)) {
-            return true;
-        }
+    if (!(cs->interrupt_request & CPU_INTERRUPT_HARD)) {
         return false;
-    } else {
-        return msr_ee && (cs->interrupt_request & CPU_INTERRUPT_HARD);
     }
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_EXT)) &&
+        (env->spr[SPR_LPCR] & LPCR_P7_PECE0)) {
+        return true;
+    }
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_DECR)) &&
+        (env->spr[SPR_LPCR] & LPCR_P7_PECE1)) {
+        return true;
+    }
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_MCK)) &&
+        (env->spr[SPR_LPCR] & LPCR_P7_PECE2)) {
+        return true;
+    }
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_HMI)) &&
+        (env->spr[SPR_LPCR] & LPCR_P7_PECE2)) {
+        return true;
+    }
+    if (env->pending_interrupts & (1u << PPC_INTERRUPT_RESET)) {
+        return true;
+    }
+    return false;
 }
 #endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
 
@@ -7750,41 +7746,37 @@ static bool cpu_has_work_POWER8(CPUState *cs)
     PowerPCCPU *cpu = POWERPC_CPU(cs);
     CPUPPCState *env = &cpu->env;
 
-    if (cs->halted) {
-        if (!(cs->interrupt_request & CPU_INTERRUPT_HARD)) {
-            return false;
-        }
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_EXT)) &&
-            (env->spr[SPR_LPCR] & LPCR_P8_PECE2)) {
-            return true;
-        }
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_DECR)) &&
-            (env->spr[SPR_LPCR] & LPCR_P8_PECE3)) {
-            return true;
-        }
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_MCK)) &&
-            (env->spr[SPR_LPCR] & LPCR_P8_PECE4)) {
-            return true;
-        }
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_HMI)) &&
-            (env->spr[SPR_LPCR] & LPCR_P8_PECE4)) {
-            return true;
-        }
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_DOORBELL)) &&
-            (env->spr[SPR_LPCR] & LPCR_P8_PECE0)) {
-            return true;
-        }
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_HDOORBELL)) &&
-            (env->spr[SPR_LPCR] & LPCR_P8_PECE1)) {
-            return true;
-        }
-        if (env->pending_interrupts & (1u << PPC_INTERRUPT_RESET)) {
-            return true;
-        }
+    if (!(cs->interrupt_request & CPU_INTERRUPT_HARD)) {
         return false;
-    } else {
-        return msr_ee && (cs->interrupt_request & CPU_INTERRUPT_HARD);
     }
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_EXT)) &&
+        (env->spr[SPR_LPCR] & LPCR_P8_PECE2)) {
+        return true;
+    }
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_DECR)) &&
+        (env->spr[SPR_LPCR] & LPCR_P8_PECE3)) {
+        return true;
+    }
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_MCK)) &&
+        (env->spr[SPR_LPCR] & LPCR_P8_PECE4)) {
+        return true;
+    }
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_HMI)) &&
+        (env->spr[SPR_LPCR] & LPCR_P8_PECE4)) {
+        return true;
+    }
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_DOORBELL)) &&
+        (env->spr[SPR_LPCR] & LPCR_P8_PECE0)) {
+        return true;
+    }
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_HDOORBELL)) &&
+        (env->spr[SPR_LPCR] & LPCR_P8_PECE1)) {
+        return true;
+    }
+    if (env->pending_interrupts & (1u << PPC_INTERRUPT_RESET)) {
+        return true;
+    }
+    return false;
 }
 #endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
 
@@ -7948,58 +7940,53 @@ static bool cpu_has_work_POWER9(CPUState *cs)
 {
     PowerPCCPU *cpu = POWERPC_CPU(cs);
     CPUPPCState *env = &cpu->env;
+    uint64_t psscr = env->spr[SPR_PSSCR];
 
-    if (cs->halted) {
-        uint64_t psscr = env->spr[SPR_PSSCR];
-
-        if (!(cs->interrupt_request & CPU_INTERRUPT_HARD)) {
-            return false;
-        }
-
-        /* If EC is clear, just return true on any pending interrupt */
-        if (!(psscr & PSSCR_EC)) {
-            return true;
-        }
-        /* External Exception */
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_EXT)) &&
-            (env->spr[SPR_LPCR] & LPCR_EEE)) {
-            bool heic = !!(env->spr[SPR_LPCR] & LPCR_HEIC);
-            if (heic == 0 || !msr_hv || msr_pr) {
-                return true;
-            }
-        }
-        /* Decrementer Exception */
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_DECR)) &&
-            (env->spr[SPR_LPCR] & LPCR_DEE)) {
-            return true;
-        }
-        /* Machine Check or Hypervisor Maintenance Exception */
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_MCK |
-            1u << PPC_INTERRUPT_HMI)) && (env->spr[SPR_LPCR] & LPCR_OEE)) {
-            return true;
-        }
-        /* Privileged Doorbell Exception */
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_DOORBELL)) &&
-            (env->spr[SPR_LPCR] & LPCR_PDEE)) {
-            return true;
-        }
-        /* Hypervisor Doorbell Exception */
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_HDOORBELL)) &&
-            (env->spr[SPR_LPCR] & LPCR_HDEE)) {
-            return true;
-        }
-        /* Hypervisor virtualization exception */
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_HVIRT)) &&
-            (env->spr[SPR_LPCR] & LPCR_HVEE)) {
-            return true;
-        }
-        if (env->pending_interrupts & (1u << PPC_INTERRUPT_RESET)) {
-            return true;
-        }
+    if (!(cs->interrupt_request & CPU_INTERRUPT_HARD)) {
         return false;
-    } else {
-        return msr_ee && (cs->interrupt_request & CPU_INTERRUPT_HARD);
     }
+
+    /* If EC is clear, just return true on any pending interrupt */
+    if (!(psscr & PSSCR_EC)) {
+        return true;
+    }
+    /* External Exception */
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_EXT)) &&
+        (env->spr[SPR_LPCR] & LPCR_EEE)) {
+        bool heic = !!(env->spr[SPR_LPCR] & LPCR_HEIC);
+        if (heic == 0 || !msr_hv || msr_pr) {
+            return true;
+        }
+    }
+    /* Decrementer Exception */
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_DECR)) &&
+        (env->spr[SPR_LPCR] & LPCR_DEE)) {
+        return true;
+    }
+    /* Machine Check or Hypervisor Maintenance Exception */
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_MCK |
+        1u << PPC_INTERRUPT_HMI)) && (env->spr[SPR_LPCR] & LPCR_OEE)) {
+        return true;
+    }
+    /* Privileged Doorbell Exception */
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_DOORBELL)) &&
+        (env->spr[SPR_LPCR] & LPCR_PDEE)) {
+        return true;
+    }
+    /* Hypervisor Doorbell Exception */
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_HDOORBELL)) &&
+        (env->spr[SPR_LPCR] & LPCR_HDEE)) {
+        return true;
+    }
+    /* Hypervisor virtualization exception */
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_HVIRT)) &&
+        (env->spr[SPR_LPCR] & LPCR_HVEE)) {
+        return true;
+    }
+    if (env->pending_interrupts & (1u << PPC_INTERRUPT_RESET)) {
+        return true;
+    }
+    return false;
 }
 #endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
 
@@ -8158,58 +8145,53 @@ static bool cpu_has_work_POWER10(CPUState *cs)
 {
     PowerPCCPU *cpu = POWERPC_CPU(cs);
     CPUPPCState *env = &cpu->env;
+    uint64_t psscr = env->spr[SPR_PSSCR];
 
-    if (cs->halted) {
-        uint64_t psscr = env->spr[SPR_PSSCR];
-
-        if (!(cs->interrupt_request & CPU_INTERRUPT_HARD)) {
-            return false;
-        }
-
-        /* If EC is clear, just return true on any pending interrupt */
-        if (!(psscr & PSSCR_EC)) {
-            return true;
-        }
-        /* External Exception */
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_EXT)) &&
-            (env->spr[SPR_LPCR] & LPCR_EEE)) {
-            bool heic = !!(env->spr[SPR_LPCR] & LPCR_HEIC);
-            if (heic == 0 || !msr_hv || msr_pr) {
-                return true;
-            }
-        }
-        /* Decrementer Exception */
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_DECR)) &&
-            (env->spr[SPR_LPCR] & LPCR_DEE)) {
-            return true;
-        }
-        /* Machine Check or Hypervisor Maintenance Exception */
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_MCK |
-            1u << PPC_INTERRUPT_HMI)) && (env->spr[SPR_LPCR] & LPCR_OEE)) {
-            return true;
-        }
-        /* Privileged Doorbell Exception */
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_DOORBELL)) &&
-            (env->spr[SPR_LPCR] & LPCR_PDEE)) {
-            return true;
-        }
-        /* Hypervisor Doorbell Exception */
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_HDOORBELL)) &&
-            (env->spr[SPR_LPCR] & LPCR_HDEE)) {
-            return true;
-        }
-        /* Hypervisor virtualization exception */
-        if ((env->pending_interrupts & (1u << PPC_INTERRUPT_HVIRT)) &&
-            (env->spr[SPR_LPCR] & LPCR_HVEE)) {
-            return true;
-        }
-        if (env->pending_interrupts & (1u << PPC_INTERRUPT_RESET)) {
-            return true;
-        }
+    if (!(cs->interrupt_request & CPU_INTERRUPT_HARD)) {
         return false;
-    } else {
-        return msr_ee && (cs->interrupt_request & CPU_INTERRUPT_HARD);
     }
+
+    /* If EC is clear, just return true on any pending interrupt */
+    if (!(psscr & PSSCR_EC)) {
+        return true;
+    }
+    /* External Exception */
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_EXT)) &&
+        (env->spr[SPR_LPCR] & LPCR_EEE)) {
+        bool heic = !!(env->spr[SPR_LPCR] & LPCR_HEIC);
+        if (heic == 0 || !msr_hv || msr_pr) {
+            return true;
+        }
+    }
+    /* Decrementer Exception */
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_DECR)) &&
+        (env->spr[SPR_LPCR] & LPCR_DEE)) {
+        return true;
+    }
+    /* Machine Check or Hypervisor Maintenance Exception */
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_MCK |
+        1u << PPC_INTERRUPT_HMI)) && (env->spr[SPR_LPCR] & LPCR_OEE)) {
+        return true;
+    }
+    /* Privileged Doorbell Exception */
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_DOORBELL)) &&
+        (env->spr[SPR_LPCR] & LPCR_PDEE)) {
+        return true;
+    }
+    /* Hypervisor Doorbell Exception */
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_HDOORBELL)) &&
+        (env->spr[SPR_LPCR] & LPCR_HDEE)) {
+        return true;
+    }
+    /* Hypervisor virtualization exception */
+    if ((env->pending_interrupts & (1u << PPC_INTERRUPT_HVIRT)) &&
+        (env->spr[SPR_LPCR] & LPCR_HVEE)) {
+        return true;
+    }
+    if (env->pending_interrupts & (1u << PPC_INTERRUPT_RESET)) {
+        return true;
+    }
+    return false;
 }
 #endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
 
-- 
2.31.1

