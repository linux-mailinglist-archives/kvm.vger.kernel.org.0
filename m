Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267022D9060
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403976AbgLMUVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390355AbgLMUVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:21:16 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24099C0617A7
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:25 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d26so1169762wrb.12
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ElGn7JwtMTMMU13LrhvDMbTZ+gVsyAEKbzwxbxdSXTQ=;
        b=r279oMzyuCA06s9efRNLeeAbvEmXQa8MM5wCrkN4z80SdfG4YW8i5qEoPXL3o3oJzi
         RmVwgMhKBr4cnlxAyCF1GV3mj4WeRSBTBlqhLnx+iO+4rrza/osaiircUIlMbzxNd3iK
         Cbwao2wMXofejyOGUVwrDa3Mf/5sK/dAsxP39CKyeGmdw4+1UtmB9pQuHKPBPFn9bSht
         7zAg5Kaca5zsZLeJuvFC37lgO14GuwKCNbMWbpRowN04gx/ili7iU2l2H8mkWf8bmfS0
         tq3lVJknSoW4EbcjJAJPadvtUseVOKUUdCQvD5ciCtG5101ztnGpoCG/dKyAxgwTlvjB
         lG/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=ElGn7JwtMTMMU13LrhvDMbTZ+gVsyAEKbzwxbxdSXTQ=;
        b=SD+6DPZ+r+qpgdHHlfN5bJU1j9VEDsQaLBq+D4FwhL+RSLSiP3jCvRgZaHD0SkuOlq
         +a++/0FMYIg0rv8C1BDomsUBlm+mELMQnr7lRJaMSMvoUVTPLWg+lELAHnxmRGqkWfOq
         v5vKHZuO2YSaOC++kN5Du9OoXqK2jxizH8KtIu4vQFWx6XoZ5gNb/3H3SmumoW827G/m
         hlr6+BW3JH5wr2SGryRyN6uPeXcM6EfaTDSJPqA0m5ptkv7JmhZ4VExHtg1lByhpbPla
         XFYWUbIVDJr0NcMLV4LCu/+gUkXES5GLeQ8kBkiaNapWgkh1kC+Oy7RjlVvtNrEnbW1Z
         aP5g==
X-Gm-Message-State: AOAM533cj59AMenyNdn14gYGdTGtvXK4dSzuGKkIRnVGWR6Nanfo+tky
        hIfXY56lvugrHoxwazP+6OY=
X-Google-Smtp-Source: ABdhPJyXLdF/7P0sm1YXBUTdja+xRF+QyOyW3QdtUpku/c3SnS6EaVS1ygEllhtb7X2nkTZzGO+ydg==
X-Received: by 2002:a5d:4349:: with SMTP id u9mr24715442wrr.319.1607890823912;
        Sun, 13 Dec 2020 12:20:23 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id q17sm27617700wrr.53.2020.12.13.12.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:20:23 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 07/26] target/mips: Remove unused headers from cp0_helper.c
Date:   Sun, 13 Dec 2020 21:19:27 +0100
Message-Id: <20201213201946.236123-8-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove unused headers and add missing "qemu/log.h" since
qemu_log() is called.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201206233949.3783184-5-f4bug@amsat.org>
---
 target/mips/cp0_helper.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/target/mips/cp0_helper.c b/target/mips/cp0_helper.c
index caaaefcc8ad..cb899fe3d73 100644
--- a/target/mips/cp0_helper.c
+++ b/target/mips/cp0_helper.c
@@ -21,15 +21,13 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/log.h"
 #include "qemu/main-loop.h"
 #include "cpu.h"
 #include "internal.h"
 #include "qemu/host-utils.h"
 #include "exec/helper-proto.h"
 #include "exec/exec-all.h"
-#include "exec/cpu_ldst.h"
-#include "exec/memop.h"
-#include "sysemu/kvm.h"
 
 
 /* SMP helpers.  */
-- 
2.26.2

