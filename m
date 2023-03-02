Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D59C6A8925
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjCBTJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjCBTJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:09:11 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F50311F6
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:08:52 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so2505260wmb.5
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=62eIWH+UgNDIO9tL0abCF5DS6hbxUYuKBS98TK1uNAY=;
        b=Y2EwnqrCp+qDTcFz1EW3YC21JHlRf1J8aYrGwA16D/IrPQ+aPQqDJHH+7FThelkDFB
         8P/fukV7yJd4T0msEj12mSBV5ljzbAuK6Sg3R+g9QsoN5jpHqQxlkHkrKYLjXCAIuFRL
         5S5C5B39krQZ0rFy9pIr/itagrEREMhfC3EVUx+d4tsUUzcbvDECSEuEHxCVWJS8GDxC
         gXYle4/apt0EhZXe174MMqRCyJIGjlK8TLBqhbQwZEZaz/OdMjUChqu5R1h8exkjYA67
         CeV9ATLtLKGKbS65+050zb/YnCyfCHofOiHTJPzr5sRxrbwBNYOAwmSee/eKW7BsEBor
         vDBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=62eIWH+UgNDIO9tL0abCF5DS6hbxUYuKBS98TK1uNAY=;
        b=2j1kLFGxfLy7S6lV6PuHq7mieJ9sGf03yrxadbzt6EPYB97JhzpC+gnGqQjpWwwBAA
         BWmbmQQzryUajUfWr9zygSdpML1OQmIZCdwwDTB1Egf6Hg1IzTjyczZwxLUccNeMxt4t
         tyxpSIuG/266cLGkF/0xeaZdWWtmqJsQOeHb8Tw/THb64kA+8e+Mcgdd6F1ITPeNy+Wo
         vYZNTFVJ+vd+web5ZYUJVxOLhmC8VonaJ4eeHlldrEQQykDqfBRiGGYLAfhZYgKnhj5J
         xpJHjcbuW4j7vk0UBcQtX/UYT4YopOIg7oXjaO4QsdadaSw1ZUKc5r118lej9jTY07y7
         g2YA==
X-Gm-Message-State: AO0yUKWtIXTQLPC09S1vobUuKhb6cy7aLPH2ZMs7lsZG2OXCI9VHc5Sv
        vn1tOib12zLJE99f68+1TG2bHA==
X-Google-Smtp-Source: AK7set+DZpUV+fLm5EmXNvZFeuE5OsROlq+aBaJRW0JmuEXUuessAEZ306eoy59qqadcmgINWU/Wgg==
X-Received: by 2002:a05:600c:170a:b0:3eb:37ce:4c3d with SMTP id c10-20020a05600c170a00b003eb37ce4c3dmr4634014wmn.38.1677784130856;
        Thu, 02 Mar 2023 11:08:50 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a10-20020a5d508a000000b002c54241b4fesm125929wrt.80.2023.03.02.11.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:08:48 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 07E891FFBC;
        Thu,  2 Mar 2023 19:08:47 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Weiwei Li <liweiwei@iscas.ac.cn>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Laurent Vivier <laurent@vivier.eu>,
        nicolas.eder@lauterbach.com, Ilya Leoshkevich <iii@linux.ibm.com>,
        kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        qemu-s390x@nongnu.org, Stafford Horne <shorne@gmail.com>,
        Bin Meng <bin.meng@windriver.com>, Marek Vasut <marex@denx.de>,
        Greg Kurz <groug@kaod.org>, Song Gao <gaosong@loongson.cn>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Chris Wulff <crwulff@gmail.com>, qemu-riscv@nongnu.org,
        Michael Rolnik <mrolnik@gmail.com>, qemu-arm@nongnu.org,
        Cleber Rosa <crosa@redhat.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        mads@ynddal.dk, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yanan Wang <wangyanan55@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Taylor Simpson <tsimpson@quicinc.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v4 04/26] gdbstub: clean-up indent on gdb_exit
Date:   Thu,  2 Mar 2023 19:08:24 +0000
Message-Id: <20230302190846.2593720-5-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230302190846.2593720-1-alex.bennee@linaro.org>
References: <20230302190846.2593720-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Otherwise checkpatch will throw a hissy fit on the later patches that
split this function up.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 gdbstub/gdbstub.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index fb9c49e0fd..63b56f0027 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -3021,27 +3021,27 @@ static void gdb_read_byte(uint8_t ch)
 /* Tell the remote gdb that the process has exited.  */
 void gdb_exit(int code)
 {
-  char buf[4];
+    char buf[4];
 
-  if (!gdbserver_state.init) {
-      return;
-  }
+    if (!gdbserver_state.init) {
+        return;
+    }
 #ifdef CONFIG_USER_ONLY
-  if (gdbserver_state.socket_path) {
-      unlink(gdbserver_state.socket_path);
-  }
-  if (gdbserver_state.fd < 0) {
-      return;
-  }
+    if (gdbserver_state.socket_path) {
+        unlink(gdbserver_state.socket_path);
+    }
+    if (gdbserver_state.fd < 0) {
+        return;
+    }
 #endif
 
-  trace_gdbstub_op_exiting((uint8_t)code);
+    trace_gdbstub_op_exiting((uint8_t)code);
 
-  snprintf(buf, sizeof(buf), "W%02x", (uint8_t)code);
-  put_packet(buf);
+    snprintf(buf, sizeof(buf), "W%02x", (uint8_t)code);
+    put_packet(buf);
 
 #ifndef CONFIG_USER_ONLY
-  qemu_chr_fe_deinit(&gdbserver_state.chr, true);
+    qemu_chr_fe_deinit(&gdbserver_state.chr, true);
 #endif
 }
 
-- 
2.39.2

