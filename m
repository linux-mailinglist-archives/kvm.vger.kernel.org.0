Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1698A3FF11A
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 18:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346286AbhIBQSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 12:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346150AbhIBQSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 12:18:54 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC52C061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 09:17:55 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id u15-20020a05600c19cf00b002f6445b8f55so1771318wmq.0
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 09:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KB6w4zAa3ScKbWvcSeRs6nml5mmvjgABbPo/s2Hl9mE=;
        b=KudZd4akeMvkEQWUbX6szQOXRBHrwcFxsejJsDwXAwrTkhmJGlULM7aiBntpU6DlLD
         x1G792oH76CFsyLlbuYcUF0GY8rXRo+VR9Hu/GBgHJyiVzTP3OvIC53DxbyFxm7deDsy
         jywij08/HNg0mFST30fvOpvMZOkJgu6uZtVjcnTVWcKz4cejoxRKoHPRUUanT/GYimTW
         BuEEvjzL5rlc0uwntqWn8CT2tidHHSSa+1LvLL/36Uq3AShOfMPK6XKiF4/niGHWKMJq
         4jkolFQjzFn6TC5LBuIhdKNpLtstdk7EfVBatQiEEjt66rdtDDU/Oqn47gGLe726oHXk
         a0tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=KB6w4zAa3ScKbWvcSeRs6nml5mmvjgABbPo/s2Hl9mE=;
        b=q30hDdxguXv/CNQ+rgpkh1loHMvULeJ1HbgLn0/IjXjHhLrwR4i23hfbjoSF6PSs4E
         6Qzc8FWGUll/T0iqEblozn+Smc/UAcCg63JndfuULkW2Vy2orn97lkrIQqCzcdeweUKq
         9QsS3fQQLtrSsLigq1T1IzuJ0QGwkV4ReG/qhe3ckaoJMwAPwnyXKmLc/pu8sGOxqdMQ
         KTcr4wRYYFifekJY2hyupU2e3c19pkLvJExWRIRiqfREYadWPDe48NE65GJCmyWsj/ls
         zujg1dHjo29tq1vpAj91WxmoDeGrZ8iq4HByxsX1uNmeKCb9IvLov6BBtnuAIFiHLBWp
         LHsA==
X-Gm-Message-State: AOAM531loVNSm6SuzWqpEHFiWgrzHPLKA9rKrWfVPK/XPLjM9EZkgtK1
        b+GKe9qNRYDfoE3iSYZ9t6M=
X-Google-Smtp-Source: ABdhPJx3cFt1jrbYXnlPCjqrJf+8cwfXAXn4EeP6vsDC0dCbWo+FdkLPkzBtWW3nLTZkBTFw2ib2sw==
X-Received: by 2002:a1c:ed10:: with SMTP id l16mr3994398wmh.8.1630599474350;
        Thu, 02 Sep 2021 09:17:54 -0700 (PDT)
Received: from x1w.. (163.red-83-52-55.dynamicip.rima-tde.net. [83.52.55.163])
        by smtp.gmail.com with ESMTPSA id f7sm2089431wmh.20.2021.09.02.09.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:17:53 -0700 (PDT)
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
Subject: [PATCH v3 20/30] target/ppc: Restrict has_work() handler to sysemu and TCG
Date:   Thu,  2 Sep 2021 18:15:33 +0200
Message-Id: <20210902161543.417092-21-f4bug@amsat.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902161543.417092-1-f4bug@amsat.org>
References: <20210902161543.417092-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restrict has_work() to TCG sysemu.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/ppc/cpu_init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index 6aad01d1d3a..e2e721c2b81 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -8790,6 +8790,7 @@ static void ppc_cpu_set_pc(CPUState *cs, vaddr value)
     cpu->env.nip = value;
 }
 
+#if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
 static bool ppc_cpu_has_work(CPUState *cs)
 {
     PowerPCCPU *cpu = POWERPC_CPU(cs);
@@ -8797,6 +8798,7 @@ static bool ppc_cpu_has_work(CPUState *cs)
 
     return msr_ee && (cs->interrupt_request & CPU_INTERRUPT_HARD);
 }
+#endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
 
 static void ppc_cpu_reset(DeviceState *dev)
 {
@@ -9017,6 +9019,7 @@ static const struct TCGCPUOps ppc_tcg_ops = {
   .tlb_fill = ppc_cpu_tlb_fill,
 
 #ifndef CONFIG_USER_ONLY
+  .has_work = ppc_cpu_has_work,
   .cpu_exec_interrupt = ppc_cpu_exec_interrupt,
   .do_interrupt = ppc_cpu_do_interrupt,
   .cpu_exec_enter = ppc_cpu_exec_enter,
@@ -9042,7 +9045,6 @@ static void ppc_cpu_class_init(ObjectClass *oc, void *data)
     device_class_set_parent_reset(dc, ppc_cpu_reset, &pcc->parent_reset);
 
     cc->class_by_name = ppc_cpu_class_by_name;
-    cc->has_work = ppc_cpu_has_work;
     cc->dump_state = ppc_cpu_dump_state;
     cc->set_pc = ppc_cpu_set_pc;
     cc->gdb_read_register = ppc_cpu_gdb_read_register;
-- 
2.31.1

