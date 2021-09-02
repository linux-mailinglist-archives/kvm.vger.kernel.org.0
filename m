Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2564A3FF10C
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 18:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346243AbhIBQRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 12:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346261AbhIBQRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 12:17:41 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A566C061760
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 09:16:42 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id u26-20020a05600c441a00b002f66b2d8603so1868215wmn.4
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 09:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=umRcFm5z0yg595NbXyjpfnNGeUl5eK5xZLxoXeUa+qc=;
        b=pz/nBk0UJK243d6EyhFjqhTq8St+3bylyw8UsBpEg2waosqkIlwbtba8uBILAoIr7Q
         lNryWY6OK0Yv0ei6QJ6YXdrGJmNPpUHm0iNE4fP7UqEe/h1YNv75NdMU0PYG192jLiEi
         nT8wtIR6GbLksC5eh0yUWGhRmDBX0INOYd68LwmG3Qv1zsVvvdfXM2Eh93Z4wPStdVNa
         KE8qNYenYdeo9Hw6npfh1Orrhaz/BR1l28Y8J4uAZJNC+LNfQ5fwkt6laufXunuUNo9o
         yefdGCG2pUPAo+hQ2RqYEKAbC+KVHHoFEwqvKykz0cg+3b9kRE25Iwy6z1ljbMNpTwU1
         QDYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=umRcFm5z0yg595NbXyjpfnNGeUl5eK5xZLxoXeUa+qc=;
        b=rltzHtSANd9LQlHEH2azSGY6JZbyPDEEzqVLYxQ7/dGYxWNZn33267BKE0B059Na+Y
         wN8yAbkc34RVuLdGezi8RIzZvswatpP8RnX1RwVFPYqgjqaDesDO8x2Jg3lyUeleNfml
         PQ2ctQ42jDLVwsR7/z+DGmUewHe5g9EsiKuSSHzM+EbXzCKFDyv1xCTQzPzpnJTMGsh8
         Nv/Lp/ND9PpyTwe8hvEmvysPmlPMLpCUGVSvYGFYw/qxviDXOic31+Xs1v0kZ5Sc1dDT
         lObKMbdCjhnCtf3XXMcBXH8YHMNTRu2hsDKUku/FMUPxnlOJZ1wjlYe5TUaRfiWgNGgC
         m1fA==
X-Gm-Message-State: AOAM530AaWBd9PwO4/OS7TX0iTtxiq5ebmsfzh3TH/e1ya1KjRJMp8ST
        PZv+8gbeqft9YVc2lI0eud8=
X-Google-Smtp-Source: ABdhPJxG0Ekgmsw86aV3vYz0yeffJLjcyX9LXqOx701gt1hpjlWPvR2zb0A5F6AGLmteTS9Julrfnw==
X-Received: by 2002:a1c:4cd:: with SMTP id 196mr4020214wme.10.1630599401061;
        Thu, 02 Sep 2021 09:16:41 -0700 (PDT)
Received: from x1w.. (163.red-83-52-55.dynamicip.rima-tde.net. [83.52.55.163])
        by smtp.gmail.com with ESMTPSA id s7sm2278245wra.75.2021.09.02.09.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:16:40 -0700 (PDT)
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
Subject: [PATCH v3 09/30] target/arm: Restrict has_work() handler to sysemu and TCG
Date:   Thu,  2 Sep 2021 18:15:22 +0200
Message-Id: <20210902161543.417092-10-f4bug@amsat.org>
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
 target/arm/cpu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index ba0741b20e4..e11aa625a5f 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -73,8 +73,8 @@ void arm_cpu_synchronize_from_tb(CPUState *cs,
         env->regs[15] = tb->pc;
     }
 }
-#endif /* CONFIG_TCG */
 
+#ifndef CONFIG_USER_ONLY
 static bool arm_cpu_has_work(CPUState *cs)
 {
     ARMCPU *cpu = ARM_CPU(cs);
@@ -85,6 +85,9 @@ static bool arm_cpu_has_work(CPUState *cs)
          | CPU_INTERRUPT_VFIQ | CPU_INTERRUPT_VIRQ
          | CPU_INTERRUPT_EXITTB);
 }
+#endif /* !CONFIG_USER_ONLY */
+
+#endif /* CONFIG_TCG */
 
 void arm_register_pre_el_change_hook(ARMCPU *cpu, ARMELChangeHookFn *hook,
                                  void *opaque)
@@ -2017,6 +2020,7 @@ static const struct TCGCPUOps arm_tcg_ops = {
     .debug_excp_handler = arm_debug_excp_handler,
 
 #if !defined(CONFIG_USER_ONLY)
+    .has_work = arm_cpu_has_work,
     .cpu_exec_interrupt = arm_cpu_exec_interrupt,
     .do_interrupt = arm_cpu_do_interrupt,
     .do_transaction_failed = arm_cpu_do_transaction_failed,
@@ -2041,7 +2045,6 @@ static void arm_cpu_class_init(ObjectClass *oc, void *data)
     device_class_set_parent_reset(dc, arm_cpu_reset, &acc->parent_reset);
 
     cc->class_by_name = arm_cpu_class_by_name;
-    cc->has_work = arm_cpu_has_work;
     cc->dump_state = arm_cpu_dump_state;
     cc->set_pc = arm_cpu_set_pc;
     cc->gdb_read_register = arm_cpu_gdb_read_register;
-- 
2.31.1

