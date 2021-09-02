Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791C73FF116
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 18:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346280AbhIBQSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 12:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346291AbhIBQSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 12:18:36 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A566C061764
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 09:17:37 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id u26-20020a05600c441a00b002f66b2d8603so1870552wmn.4
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 09:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oNTRH1yoq5af/chfn9I/5bXkTQKwubTn8iozem9IGSY=;
        b=PGBnfVPTt2uYSxX6RQU1qsSKDWiS62QWAFvPTZETHVyL2OfFEKZZM3g5e9WJ1/HCKp
         vwU/HD/XAeJVS5v2+My/H3taQ/5KpM2mCEqjy9lZxh2Z/pp5+KxKPIJb09S1d7E1zVbI
         3ZIcYz0tlufyP3eqE0RuxgxTothAxpq4vYSqZmx2K/VGuOwYk4ulhhYY34CvxwPWhOkc
         X6DZRjwitqLAQZOFu87Nxe9lRc1tqhLGZ8hROluYOSSfODd35hNP9l0+ra9n37CT0CeZ
         tWoQvZtrbSLJKAVJXRMVVda3fXJ9XRtlNf90jVOb68ZvlGwL1VX/T67Jlue0hgDZL0Fm
         SNZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=oNTRH1yoq5af/chfn9I/5bXkTQKwubTn8iozem9IGSY=;
        b=eWZD28EjkQU2xOgaW3fD9jPOn1ypCnP3cNSSxu9K4pyFiey2jlDHivFuAS6Q1PkwKN
         Pnf3M6nFElulCL24Ts7/AxlpPP1Xop4XKSYasVnjFOFOc35K0gWE/Iu6gYRM6opeq8E+
         D5hjS7sLz2nZc1UPhXdg9G9g45S5xbJt+hA/VlJVoIs0ioK/hbvkjHUTrUtWxHjHYvTR
         njqZo6HflnD+PrNXddy/CgYaaE6znqe4Dq54XSz9Sv3d5XLHpeQ2YfflVJxqxqfbon3l
         tI8ZYO085pm4AQ0IqMAMOQtZ3e36mtjMB1e2GEc+Txq8AYAkyZ7GXbGwjIcyGHWKd4nL
         TkeQ==
X-Gm-Message-State: AOAM533eMjnsPVTY2nH9PN6aVu9uZwju+TCKq73T9/cW92pGLCE1PzBK
        y2/QlAewRJnFTYId9wD1ILY=
X-Google-Smtp-Source: ABdhPJxVc9r0FTKCTOqW8xIIldm9t05NRFuFTf+Kzcn3sLsTdbmtacHYR3pfbO5B7AXHWSOEzXQpFQ==
X-Received: by 2002:a05:600c:19ca:: with SMTP id u10mr3821810wmq.178.1630599453691;
        Thu, 02 Sep 2021 09:17:33 -0700 (PDT)
Received: from x1w.. (163.red-83-52-55.dynamicip.rima-tde.net. [83.52.55.163])
        by smtp.gmail.com with ESMTPSA id z17sm2350022wrh.66.2021.09.02.09.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:17:33 -0700 (PDT)
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
Subject: [PATCH v3 17/30] target/mips: Restrict has_work() handler to sysemu and TCG
Date:   Thu,  2 Sep 2021 18:15:30 +0200
Message-Id: <20210902161543.417092-18-f4bug@amsat.org>
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
 target/mips/cpu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 00e0c55d0e4..3639c03f8ea 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -128,6 +128,7 @@ static void mips_cpu_set_pc(CPUState *cs, vaddr value)
     mips_env_set_pc(&cpu->env, value);
 }
 
+#if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
 static bool mips_cpu_has_work(CPUState *cs)
 {
     MIPSCPU *cpu = MIPS_CPU(cs);
@@ -172,6 +173,7 @@ static bool mips_cpu_has_work(CPUState *cs)
     }
     return has_work;
 }
+#endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
 
 #include "cpu-defs.c.inc"
 
@@ -542,6 +544,7 @@ static const struct TCGCPUOps mips_tcg_ops = {
     .tlb_fill = mips_cpu_tlb_fill,
 
 #if !defined(CONFIG_USER_ONLY)
+    .has_work = mips_cpu_has_work,
     .cpu_exec_interrupt = mips_cpu_exec_interrupt,
     .do_interrupt = mips_cpu_do_interrupt,
     .do_transaction_failed = mips_cpu_do_transaction_failed,
@@ -563,7 +566,6 @@ static void mips_cpu_class_init(ObjectClass *c, void *data)
     device_class_set_props(dc, mips_cpu_properties);
 
     cc->class_by_name = mips_cpu_class_by_name;
-    cc->has_work = mips_cpu_has_work;
     cc->dump_state = mips_cpu_dump_state;
     cc->set_pc = mips_cpu_set_pc;
     cc->gdb_read_register = mips_cpu_gdb_read_register;
-- 
2.31.1

