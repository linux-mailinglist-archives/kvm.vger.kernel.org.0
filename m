Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AA72D0821
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgLFXll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728611AbgLFXlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:41:40 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA56C0613D0
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:41:25 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id y23so470512wmi.1
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n+99MQGfH3ws6+hiYTWg+4rrAybzJdIAfbn40ls3kQA=;
        b=VW7WqeZgfbUIfta173CGJdeR7dfKwzewm7EoRtrSTO3x2mRpzvi/abkbHam9G6TPmD
         fOWKGB5uSYlElBasR+JVTRkpCVm/f4pr/gp5FexX/gdYKuhCyg4/YwWL02Y4NIVN9Qvg
         mvAZRAGn7l76CGVBQIjCOWULmL75Jzm7VMVvtBzBZ1kYOqiiEU0U3jdanI7NTWe4+3mh
         1MoBYxSHGJhuoYW4J8XDLyPxiEUMMce3/BUASEjZNDYU0tBwohxoZFZy1ZGoSzAgS2Kd
         ythIuTFf8f+DcYsKh11ijcuxb1Z71ALIS3u/xf/r8xrHnJYBiSwGVX59EedQkDDqfDh1
         xFOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=n+99MQGfH3ws6+hiYTWg+4rrAybzJdIAfbn40ls3kQA=;
        b=JW8kdDP7RU69zpx7j6DVFp15s33NByX7efLO1osb1e7d1GLXqSPSktdva9OliGgLmF
         zNpKdH5ChFo7Z8RFM9LPVN8kiQvcbVw3cFjefYXLWoFuwwmT+xR0FylHtq83EJ56x7Ox
         P2eIlDISHbciaoh0vpIcKPOPw4UAYhb4tatJRK2t72JUZH4L8sx0DbAGmA0Yt8Rcdqi4
         /W3EOzVjtGdv2vFMyKFQEmajBX4Bo996cqyT60rJ3Lf8KLLQVfTpZxYVuTRd2n2k6ynf
         xlodhs9Fe9ynKAZzFzypelsLHh//F7RiFv4YWnGhibRMdW+CBplM6z+oTyNpkSpOqxuR
         xegw==
X-Gm-Message-State: AOAM533FfdF1eQTpzVUiOQS70Kdg5o9ZtwuNy7186DTpKwl9A5LMBMI4
        3wNW8mEhZjldfqwK7qh8f4k=
X-Google-Smtp-Source: ABdhPJyjns/B798+mFTm2wm7XE4zN7sKqY5G1A3JKvnUaOePKo4NsA6M8H2M1DJdBlQYE86l4bMqfQ==
X-Received: by 2002:a1c:7218:: with SMTP id n24mr15456149wmc.186.1607298084105;
        Sun, 06 Dec 2020 15:41:24 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id c2sm13819964wrf.68.2020.12.06.15.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:41:23 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Fontana <cfontana@suse.de>
Subject: [RFC PATCH 18/19] target/mips: Restrict some TCG specific CPUClass handlers
Date:   Mon,  7 Dec 2020 00:39:48 +0100
Message-Id: <20201206233949.3783184-19-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206233949.3783184-1-f4bug@amsat.org>
References: <20201206233949.3783184-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restrict the following CPUClass handlers to TCG:
- do_interrupt
- do_transaction_failed
- do_unaligned_access

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
Cc: Claudio Fontana <cfontana@suse.de>

 target/mips/cpu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 8a4486e3ea1..03bd35b7903 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -483,7 +483,6 @@ static void mips_cpu_class_init(ObjectClass *c, void *data)
 
     cc->class_by_name = mips_cpu_class_by_name;
     cc->has_work = mips_cpu_has_work;
-    cc->do_interrupt = mips_cpu_do_interrupt;
     cc->cpu_exec_interrupt = mips_cpu_exec_interrupt;
     cc->dump_state = mips_cpu_dump_state;
     cc->set_pc = mips_cpu_set_pc;
@@ -491,8 +490,7 @@ static void mips_cpu_class_init(ObjectClass *c, void *data)
     cc->gdb_read_register = mips_cpu_gdb_read_register;
     cc->gdb_write_register = mips_cpu_gdb_write_register;
 #ifndef CONFIG_USER_ONLY
-    cc->do_transaction_failed = mips_cpu_do_transaction_failed;
-    cc->do_unaligned_access = mips_cpu_do_unaligned_access;
+    cc->do_interrupt = mips_cpu_do_interrupt;
     cc->get_phys_page_debug = mips_cpu_get_phys_page_debug;
     cc->vmsd = &vmstate_mips_cpu;
 #endif
@@ -500,6 +498,10 @@ static void mips_cpu_class_init(ObjectClass *c, void *data)
 #ifdef CONFIG_TCG
     cc->tcg_initialize = mips_tcg_init;
     cc->tlb_fill = mips_cpu_tlb_fill;
+#if !defined(CONFIG_USER_ONLY)
+    cc->do_unaligned_access = mips_cpu_do_unaligned_access;
+    cc->do_transaction_failed = mips_cpu_do_transaction_failed;
+#endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
 #endif
 
     cc->gdb_num_core_regs = 73;
-- 
2.26.2

