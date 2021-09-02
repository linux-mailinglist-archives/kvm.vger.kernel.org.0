Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E77E3FF10D
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 18:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346266AbhIBQRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 12:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346060AbhIBQRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 12:17:47 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E7BC061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 09:16:48 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id u26-20020a05600c441a00b002f66b2d8603so1868475wmn.4
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 09:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1uiIX4B4XnBDTSuiPfQ6TXqVM80IFaG7yss59sugPek=;
        b=KqzWIKJ7D2fRmpGndmFmFNuwslKTxikjGxDMGA2xsPlBUegPAHynuzDusdrr5XjA+x
         UCJbwBQeZPJQtXG0Xtu7RxwzPdlThK6RVv2DMQ/DDE16jxbu2MLTQ+EKf6s/CZXPXeN6
         nzJIGn8UESvClj1N6xIA9j+rSpvqLJiMXVoYewPiMa355LZW9o2GW/afajWJc0/NEar0
         Q8DpjYGYUJuF0UC+706nFPlDCV62j7IN2KHM9wzg02+ZUE7+nf9cE7ogevav/S8CwMh4
         Jx4C3Bwaygo71B9Uga55OA34fqh3F6hfjdQCFZRtq0AWQ50+fnYTHxBfr074WpLdgF+1
         YThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=1uiIX4B4XnBDTSuiPfQ6TXqVM80IFaG7yss59sugPek=;
        b=se1re+QoA8I3F63VPIZ796+qcHh38SL2nPgQxootbrRJo6b5XPZWUFUa29Fd23UC6q
         j15dyah3Fw0VfYRn+jdubky09gvJQbRjzCwcZUgMOxyTCp7f9iEafBSj9ES8Qxc5lvKP
         Ww8AJDV884cTrxzWOM8eWeBpWq8aZPMEwskjGApExl+KKqc0ZqTr6edRgHEvjQmjAj6L
         4F3xHAI1LlhUUXJ9TXn2aIEj7XjPPq2/vA+odUxhmsGlJiKo60EmGtubwvulcCCEJg8r
         7J9WZdEfKlpjM0SkI4vyM5Ii9TIk1kmPfgccV9npxMgxvlZy4SABAfm2XhavU2sNehol
         c4UA==
X-Gm-Message-State: AOAM530jVRmUxN7487lnCYZGCAgpwTUWFPs4T73HbohdO4WB58ZD3Wjx
        jreM/6gs6j4qWt97qG4ry8k=
X-Google-Smtp-Source: ABdhPJw3pSsMq4kZKK4hbVaJZjnjyoQFK4vJQiZ4XHFwYg2jDsiLD33cM2YA1HEu8cnvL7L44Mu7XQ==
X-Received: by 2002:a1c:44c5:: with SMTP id r188mr4089427wma.9.1630599407288;
        Thu, 02 Sep 2021 09:16:47 -0700 (PDT)
Received: from x1w.. (163.red-83-52-55.dynamicip.rima-tde.net. [83.52.55.163])
        by smtp.gmail.com with ESMTPSA id y24sm2479386wma.9.2021.09.02.09.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:16:46 -0700 (PDT)
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
Subject: [PATCH v3 10/30] target/avr: Restrict has_work() handler to sysemu and TCG
Date:   Thu,  2 Sep 2021 18:15:23 +0200
Message-Id: <20210902161543.417092-11-f4bug@amsat.org>
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
 target/avr/cpu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/avr/cpu.c b/target/avr/cpu.c
index e9fa54c9777..6267cc6d530 100644
--- a/target/avr/cpu.c
+++ b/target/avr/cpu.c
@@ -32,6 +32,7 @@ static void avr_cpu_set_pc(CPUState *cs, vaddr value)
     cpu->env.pc_w = value / 2; /* internally PC points to words */
 }
 
+#if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
 static bool avr_cpu_has_work(CPUState *cs)
 {
     AVRCPU *cpu = AVR_CPU(cs);
@@ -40,6 +41,7 @@ static bool avr_cpu_has_work(CPUState *cs)
     return (cs->interrupt_request & (CPU_INTERRUPT_HARD | CPU_INTERRUPT_RESET))
             && cpu_interrupts_enabled(env);
 }
+#endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
 
 static void avr_cpu_synchronize_from_tb(CPUState *cs,
                                         const TranslationBlock *tb)
@@ -198,6 +200,7 @@ static const struct TCGCPUOps avr_tcg_ops = {
     .tlb_fill = avr_cpu_tlb_fill,
 
 #ifndef CONFIG_USER_ONLY
+    .has_work = avr_cpu_has_work,
     .cpu_exec_interrupt = avr_cpu_exec_interrupt,
     .do_interrupt = avr_cpu_do_interrupt,
 #endif /* !CONFIG_USER_ONLY */
@@ -214,7 +217,6 @@ static void avr_cpu_class_init(ObjectClass *oc, void *data)
 
     cc->class_by_name = avr_cpu_class_by_name;
 
-    cc->has_work = avr_cpu_has_work;
     cc->dump_state = avr_cpu_dump_state;
     cc->set_pc = avr_cpu_set_pc;
     cc->memory_rw_debug = avr_cpu_memory_rw_debug;
-- 
2.31.1

