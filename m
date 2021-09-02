Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85433FF120
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 18:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346291AbhIBQTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 12:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346315AbhIBQTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 12:19:12 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5545FC061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 09:18:14 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q11so3832592wrr.9
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 09:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NcTQcOUeeehYkPycaMHvSzYk1/JpDe+W3tlOioHt6ec=;
        b=Qo3n3nT5T2uCxZDbpwI/2fMsolvJt4Y1gOrYSxa05AyniYxnVrYAyAl58E/mePDB+Q
         mp74y9slo+JHNdNbb124nVsmTrRmSYtRFeXvQ45hmAzQLS7SZdoREJlqjngb5ERIDHOz
         8fG18ynHtTwJKTgzScUP5EYAEGDfAkaAdwzs1bs8Mwbkci0fjxZIrzyNblhH2fEmvKn0
         14gWvYc8/SbUfS0Y8MjZjc8PX2H+MElpBG7G8YmI1yDXyIqgKhSWIpr7bVwK4JmVtxvW
         D4kk4tzADto1QBEDwX3w/FLijcMe32GJWkC5PPc+o9liJR70fQ003gNi58OOJ6evLU1W
         Khjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=NcTQcOUeeehYkPycaMHvSzYk1/JpDe+W3tlOioHt6ec=;
        b=AUDV3MMh21yGxuqh5C9y7ILEx7lAVBQJm8aiPNA9pvGb6mM5QtrAMudpZRey7Ma7KW
         hViWwPh218BWnO3roGHqqcwMwYudpCavZeZzwJK9BVRUeRieHj4O6Ajbp2d/nn/SIWKO
         9O/KYrHl+MGwLZqFXkG4gI98Xe0MwLK3I1R9JyH5dNC24AgPuQH6joYurLyVS/WwIGze
         nRmtiMrOsLt+9mEMcTbuOWMRqMBpYkYH9lSCbQ3zi8Q+ztRKIy+qTKHgSwEe3WMsrX9i
         zGi/J2RGZf9hpuihTa4v3uXguB+A7Q+znes0EVVsJnP9INSV+MOquRgMRECVSxFZHQyt
         DqWg==
X-Gm-Message-State: AOAM531WIrK6sR5cj6dc0ylczERBNA8Wy+emGXM7jcq7IefnOUtEZi9y
        /r+oeVoNoDs/xoOKmv1VlmE=
X-Google-Smtp-Source: ABdhPJzq4gEgBOzEB6hIFdgS7MM2mMxbBTgou1tfWKrQyw8z4fa5k0Y3IhkCYtobsiFPzwgsy9U7mQ==
X-Received: by 2002:adf:c390:: with SMTP id p16mr4949292wrf.105.1630599492959;
        Thu, 02 Sep 2021 09:18:12 -0700 (PDT)
Received: from x1w.. (163.red-83-52-55.dynamicip.rima-tde.net. [83.52.55.163])
        by smtp.gmail.com with ESMTPSA id g1sm2930192wrb.27.2021.09.02.09.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:18:12 -0700 (PDT)
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
Subject: [PATCH v3 23/30] target/riscv: Restrict has_work() handler to sysemu and TCG
Date:   Thu,  2 Sep 2021 18:15:36 +0200
Message-Id: <20210902161543.417092-24-f4bug@amsat.org>
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
 target/riscv/cpu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 13575c14085..abb555a8bdb 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -335,9 +335,9 @@ static void riscv_cpu_synchronize_from_tb(CPUState *cs,
     env->pc = tb->pc;
 }
 
+#if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
 static bool riscv_cpu_has_work(CPUState *cs)
 {
-#ifndef CONFIG_USER_ONLY
     RISCVCPU *cpu = RISCV_CPU(cs);
     CPURISCVState *env = &cpu->env;
     /*
@@ -345,10 +345,8 @@ static bool riscv_cpu_has_work(CPUState *cs)
      * mode and delegation registers, but respect individual enables
      */
     return (env->mip & env->mie) != 0;
-#else
-    return true;
-#endif
 }
+#endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
 
 void restore_state_to_opc(CPURISCVState *env, TranslationBlock *tb,
                           target_ulong *data)
@@ -647,6 +645,7 @@ static const struct TCGCPUOps riscv_tcg_ops = {
     .tlb_fill = riscv_cpu_tlb_fill,
 
 #ifndef CONFIG_USER_ONLY
+    .has_work = riscv_cpu_has_work,
     .cpu_exec_interrupt = riscv_cpu_exec_interrupt,
     .do_interrupt = riscv_cpu_do_interrupt,
     .do_transaction_failed = riscv_cpu_do_transaction_failed,
@@ -666,7 +665,6 @@ static void riscv_cpu_class_init(ObjectClass *c, void *data)
     device_class_set_parent_reset(dc, riscv_cpu_reset, &mcc->parent_reset);
 
     cc->class_by_name = riscv_cpu_class_by_name;
-    cc->has_work = riscv_cpu_has_work;
     cc->dump_state = riscv_cpu_dump_state;
     cc->set_pc = riscv_cpu_set_pc;
     cc->gdb_read_register = riscv_cpu_gdb_read_register;
-- 
2.31.1

