Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71133FF119
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 18:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346248AbhIBQSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 12:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346150AbhIBQSs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 12:18:48 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B982BC061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 09:17:49 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v10so3839948wrd.4
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 09:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wiJyFwIKRQWjRkbu8SvGMr1PDMKMIYamMV7C3BB8oe8=;
        b=qAtoFIb8zeHmLJ+DXBMGpAdnbrphpEAfuI7XHEPw8NBmRW9/+WQnP+AZelTqnIhAyE
         XWWklQ0ZgUaW+TjGyBKgrmT5Awe/DhMqWt5iYbHcpZayB/1OpJXxLIVgIBvvvx9tbfbe
         MhBhX16/hQ/XQpM8/t7IWpZx8Wn0h5lsCbsMip4ljj1E3unFy90cJy4UzhkEFnhbknkU
         T8DR04fw7m7nWgaHWphfTdeObgKvp0ylXJqEGEN6mGrqmeM1GzS3/abyks0gzOofcGN7
         UjU06l66Hvh9mNoLvBN0ewV7GlShfdvdFlG07p47BqES4xriMHGxYVH/Zf/4POrSSA9s
         8XQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=wiJyFwIKRQWjRkbu8SvGMr1PDMKMIYamMV7C3BB8oe8=;
        b=ZTp+4MJDXLBBsfR1fLnFRIJJs3yU1aShB14hf6wkK9nlhWuSl964ESzJt9sZZ7ECoL
         Sj/FO4m1g2ZAGSHpHUrXRTt2p71fgToZiqVOfBU8CIcHq8Oi7flIy4Oztsbfg3/9XtAC
         wuTDb+HA0oHfg0YzMcOjfU6LkXb9+jYHzOArn5P1JWQlasE6saLRpu/jMMp1zxS0QHqs
         aRjNlCSMSBaJ8XBFJEBvU4oOVDp4/UcoTh2Rf8XBAh7R2G25ESxbSX+po+YJ7eggq/IA
         GgKASANJYSFo5FFvN24507UjXFyHE707319k8ZW79tb5w1c1l3FQkBewIKCWvbVp0oTz
         o8Rg==
X-Gm-Message-State: AOAM531AhIviI2INVb9g9yGCd7Krq58SLre+os84978+tJgN9UyfqGDx
        ETYmP3sDFdJYSyytvHzfbzQ=
X-Google-Smtp-Source: ABdhPJzK4QdOoxXsApVtGRumuSNyT10qkKd9QeSHbbUEQ3zItVBoCovI95FuxXm2STsnpfXGUzb9Vg==
X-Received: by 2002:a5d:4ed0:: with SMTP id s16mr4776030wrv.71.1630599468354;
        Thu, 02 Sep 2021 09:17:48 -0700 (PDT)
Received: from x1w.. (163.red-83-52-55.dynamicip.rima-tde.net. [83.52.55.163])
        by smtp.gmail.com with ESMTPSA id s15sm2202811wrb.22.2021.09.02.09.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:17:47 -0700 (PDT)
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
Subject: [PATCH v3 19/30] target/openrisc: Restrict has_work() handler to sysemu and TCG
Date:   Thu,  2 Sep 2021 18:15:32 +0200
Message-Id: <20210902161543.417092-20-f4bug@amsat.org>
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
 target/openrisc/cpu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/openrisc/cpu.c b/target/openrisc/cpu.c
index 27cb04152f9..6544b549f12 100644
--- a/target/openrisc/cpu.c
+++ b/target/openrisc/cpu.c
@@ -30,11 +30,13 @@ static void openrisc_cpu_set_pc(CPUState *cs, vaddr value)
     cpu->env.dflag = 0;
 }
 
+#if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
 static bool openrisc_cpu_has_work(CPUState *cs)
 {
     return cs->interrupt_request & (CPU_INTERRUPT_HARD |
                                     CPU_INTERRUPT_TIMER);
 }
+#endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
 
 static void openrisc_disas_set_info(CPUState *cpu, disassemble_info *info)
 {
@@ -189,6 +191,7 @@ static const struct TCGCPUOps openrisc_tcg_ops = {
     .tlb_fill = openrisc_cpu_tlb_fill,
 
 #ifndef CONFIG_USER_ONLY
+    .has_work = openrisc_cpu_has_work,
     .cpu_exec_interrupt = openrisc_cpu_exec_interrupt,
     .do_interrupt = openrisc_cpu_do_interrupt,
 #endif /* !CONFIG_USER_ONLY */
@@ -205,7 +208,6 @@ static void openrisc_cpu_class_init(ObjectClass *oc, void *data)
     device_class_set_parent_reset(dc, openrisc_cpu_reset, &occ->parent_reset);
 
     cc->class_by_name = openrisc_cpu_class_by_name;
-    cc->has_work = openrisc_cpu_has_work;
     cc->dump_state = openrisc_cpu_dump_state;
     cc->set_pc = openrisc_cpu_set_pc;
     cc->gdb_read_register = openrisc_cpu_gdb_read_register;
-- 
2.31.1

