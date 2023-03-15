Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706246BBB24
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbjCORn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbjCORnw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:43:52 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECA6158AA
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:45 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso1592181wmb.0
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n2lqvTUuUPDyKzIrsP16s/eYBb9PuaeW9Nb5YqUgavw=;
        b=LIp+fyzYsr1PkYiEm7gbcx1B1sBzNXTJuwtFxRcoiSddXx0bTYiRbX5j+lLUqWIw8W
         H5qZNkdj4kR1dxg1fK+bR8TohBNHv/pzMkREtdrLCcP7nnNvAFB25jIYVWSPQKpxBs+8
         /hJNOp5krYGHqxbJvCnpZTg1b9cU2Ht0PdKKRFGW4YOGUvFgQB+ub8wT/ZrfOdMIDplI
         136lgdbi2SGphMeZM4ZCYjrF8VxJvTdIo3jxhSP1sxi71i4dhKnkQcjVVbovbNVjDtkO
         W9WQwK8+mH1g8kCYmffpLkDG+ltccljeA81ickL8VInlRPDrhxqr8uWMh/66t6V/GQUZ
         MmMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n2lqvTUuUPDyKzIrsP16s/eYBb9PuaeW9Nb5YqUgavw=;
        b=TMUvUmttOWfcLkMoocWq2ntaUSdRMwyGcza32Ngc5wPxLNaEyoG3030fEU4onl0suM
         HA7Sq1deh/WPPXPDN/wsFKV8EM/uvzPAngNV6G/BVONoMbOLh1irZkzaGg1lISJP9y1M
         73O00iLaMSnUZRF89lzN0F01w+N7FY6B+rHyQF+OgkKKOJdg15W4mh3AO96FNAkKsu9x
         L7S9t0vo758ulNHFzGsSlQI30fdeHqAM7nJEorMJYhArSOPo/MRU9eqo8nb9rw6eo6W9
         xbZHRYlFDIP7sirGKm8rkulNEeVLGZ0GQVceaC1Pu9jIAT3fqYyqolxog7DnUdPLLm2J
         aLEg==
X-Gm-Message-State: AO0yUKWoXYF83M1WNYl9EWF3leZyI/p5i2ow1OnM5glgQgBGvWIl35xk
        E9s9dzqZdkw4H4+pkvP+G77pNQ==
X-Google-Smtp-Source: AK7set/V0TtSO4e7MAc+9is5Xqoc2dUXvwUSQZtY/ABalmrlPm39omiQX/433j9W1nISXeTSpB0wDQ==
X-Received: by 2002:a05:600c:3b82:b0:3ed:3457:4e82 with SMTP id n2-20020a05600c3b8200b003ed34574e82mr3037826wms.30.1678902224524;
        Wed, 15 Mar 2023 10:43:44 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id c7-20020a05600c0ac700b003eb5ce1b734sm2562105wmr.7.2023.03.15.10.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:43:43 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 484EF1FFBE;
        Wed, 15 Mar 2023 17:43:43 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Akihiko Odaki <akihiko.odaki@gmail.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        qemu-riscv@nongnu.org, Riku Voipio <riku.voipio@iki.fi>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Thomas Huth <thuth@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hao Wu <wuhaotsh@google.com>, Cleber Rosa <crosa@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, qemu-ppc@nongnu.org,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Darren Kenny <darren.kenny@oracle.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stafford Horne <shorne@gmail.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Thomas Huth <huth@tuxfamily.org>,
        Vijai Kumar K <vijai@behindbytes.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Song Gao <gaosong@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Niek Linnenbank <nieklinnenbank@gmail.com>,
        Greg Kurz <groug@kaod.org>, Laurent Vivier <laurent@vivier.eu>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Alexander Bulekov <alxndr@bu.edu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-block@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>, qemu-s390x@nongnu.org,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Bandan Das <bsd@redhat.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Beraldo Leal <bleal@redhat.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Paul Durrant <paul@xen.org>, Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Hanna Reitz <hreitz@redhat.com>, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 15/32] *: Add missing includes of qemu/plugin.h
Date:   Wed, 15 Mar 2023 17:43:14 +0000
Message-Id: <20230315174331.2959-16-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315174331.2959-1-alex.bennee@linaro.org>
References: <20230315174331.2959-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Richard Henderson <richard.henderson@linaro.org>

This had been pulled in from hw/core/cpu.h,
but that will be removed.

Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20230310195252.210956-6-richard.henderson@linaro.org>
[AJB: also syscall-trace.h]
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/user/syscall-trace.h | 1 +
 accel/tcg/cpu-exec-common.c  | 1 +
 cpu.c                        | 1 +
 linux-user/exit.c            | 1 +
 linux-user/syscall.c         | 1 +
 5 files changed, 5 insertions(+)

diff --git a/include/user/syscall-trace.h b/include/user/syscall-trace.h
index c5a220da34..90bda7631c 100644
--- a/include/user/syscall-trace.h
+++ b/include/user/syscall-trace.h
@@ -11,6 +11,7 @@
 #define SYSCALL_TRACE_H
 
 #include "exec/user/abitypes.h"
+#include "qemu/plugin.h"
 #include "trace/trace-root.h"
 
 /*
diff --git a/accel/tcg/cpu-exec-common.c b/accel/tcg/cpu-exec-common.c
index 176ea57281..e7962c9348 100644
--- a/accel/tcg/cpu-exec-common.c
+++ b/accel/tcg/cpu-exec-common.c
@@ -21,6 +21,7 @@
 #include "sysemu/cpus.h"
 #include "sysemu/tcg.h"
 #include "exec/exec-all.h"
+#include "qemu/plugin.h"
 
 bool tcg_allowed;
 
diff --git a/cpu.c b/cpu.c
index 567b23af46..849bac062c 100644
--- a/cpu.c
+++ b/cpu.c
@@ -42,6 +42,7 @@
 #include "hw/core/accel-cpu.h"
 #include "trace/trace-root.h"
 #include "qemu/accel.h"
+#include "qemu/plugin.h"
 
 uintptr_t qemu_host_page_size;
 intptr_t qemu_host_page_mask;
diff --git a/linux-user/exit.c b/linux-user/exit.c
index fd49d76f45..3017d28a3c 100644
--- a/linux-user/exit.c
+++ b/linux-user/exit.c
@@ -21,6 +21,7 @@
 #include "gdbstub/syscalls.h"
 #include "qemu.h"
 #include "user-internals.h"
+#include "qemu/plugin.h"
 #ifdef CONFIG_GPROF
 #include <sys/gmon.h>
 #endif
diff --git a/linux-user/syscall.c b/linux-user/syscall.c
index 24cea6fb6a..27871641f4 100644
--- a/linux-user/syscall.c
+++ b/linux-user/syscall.c
@@ -22,6 +22,7 @@
 #include "qemu/path.h"
 #include "qemu/memfd.h"
 #include "qemu/queue.h"
+#include "qemu/plugin.h"
 #include "target_mman.h"
 #include <elf.h>
 #include <endian.h>
-- 
2.39.2

