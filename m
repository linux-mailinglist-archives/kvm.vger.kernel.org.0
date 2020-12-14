Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1F12D9F5A
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408834AbgLNSkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408801AbgLNSjp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 13:39:45 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96980C061285
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:39:04 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id r7so17451385wrc.5
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3jTmKcmmqBWLYbQ1cWD989jXI7AUr/FtqoKPQ00ZpaA=;
        b=DmvDAgVDk3rT6vilBmhNkckxULBIzzOM7iPzs+1pqtzygklCVwU2Nf/bxGPV3xiUth
         716+qran5MG77Z410nif++Lkg66Vu6HV4Xq4NSFh7RIJHdIPP2KN2AqGn8x373KuVU60
         IJu7NyQ7ckS3ymP9XbkN4e8aLmRUY9BJsX8J4PgRvbgvyu2B4olGlZjUeJOzhyndGU6c
         DgUeUkq1XIPAsOSlTvBNoTfr6yOlYBV2dVHq4+3SlwRwM6waQWSKpiX6/gk9EewantFS
         jSuVyYsL0wEy2640e0xlUkGzQ5tVXWR8Gi2/+WLarpBdiW5+zpahNBBf/kp2uPwLmarH
         cdrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=3jTmKcmmqBWLYbQ1cWD989jXI7AUr/FtqoKPQ00ZpaA=;
        b=Nw8IsG7BDMa7bD+tBaBT40ZS1rqioWWTBDW+MamXW01o99b0w2m/2U/6QDQS7HrCjG
         n/C2/QKsm3EaXwu+87MJJkd6udTuAhYxRzGW7jNA/SRrANvEgm/FWHxzqOffUGqCgdQG
         gzj648D+Vgm0Fp2ELk+AZHR1WOAI9VJNVhS65sQ924hOpB4TeLw0M32xGJIMOfcBafam
         jP9C/y84HeYlofkRt3mYmwzrA0N2c3R7iSCgR7R1fCCmcSq4YjOq0li/EaFnEQXCjf3C
         FblXlrow/uzZe8qOT0Kjj50+AvePQLE0eah9tEZm7QHhQBzHS3+ODPku9Hyk1jf0rE3Z
         8Kkg==
X-Gm-Message-State: AOAM530Ht9RnpIpvqjS/oXuCxV5oWp2hgRS3fmsAXApOBa0HubDwRdlw
        OSS5MsWWsgx3RQHSlBjMcoo=
X-Google-Smtp-Source: ABdhPJylZEZ27Ecah1UpEhdOM3kNCewD+xZzhYtp7CCr76vb0A0zPGaLnGaH25igd87RXx73ckqSKw==
X-Received: by 2002:adf:dc8d:: with SMTP id r13mr30567261wrj.325.1607971143337;
        Mon, 14 Dec 2020 10:39:03 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id 94sm33793630wrq.22.2020.12.14.10.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 10:39:02 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v2 16/16] target/mips: Only build TCG code when CONFIG_TCG is set
Date:   Mon, 14 Dec 2020 19:37:39 +0100
Message-Id: <20201214183739.500368-17-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214183739.500368-1-f4bug@amsat.org>
References: <20201214183739.500368-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201206233949.3783184-20-f4bug@amsat.org>
---
 target/mips/meson.build | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/target/mips/meson.build b/target/mips/meson.build
index 5a49951c6d7..596eb1aeeb3 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -1,9 +1,11 @@
 mips_ss = ss.source_set()
 mips_ss.add(files(
   'cpu.c',
+  'gdbstub.c',
+))
+mips_ss.add(when: 'CONFIG_TCG', if_true: files(
   'dsp_helper.c',
   'fpu_helper.c',
-  'gdbstub.c',
   'lmmi_helper.c',
   'msa_helper.c',
   'op_helper.c',
@@ -15,11 +17,13 @@
 mips_softmmu_ss = ss.source_set()
 mips_softmmu_ss.add(files(
   'addr.c',
-  'cp0_helper.c',
   'cp0_timer.c',
   'machine.c',
   'mips-semi.c',
 ))
+mips_softmmu_ss.add(when: 'CONFIG_TCG', if_true: files(
+  'cp0_helper.c',
+))
 
 target_arch += {'mips': mips_ss}
 target_softmmu_arch += {'mips': mips_softmmu_ss}
-- 
2.26.2

