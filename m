Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E8E2D0816
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgLFXlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbgLFXlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:41:15 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BFEC061A51
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:40:24 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id r3so11037968wrt.2
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LGB1WfqGgk+E2BwfN1znIYNM8Z3EDS1Ck0ntTTU7ae8=;
        b=BjYNpSuhMXRN3yzz7v8F0ddsWC0Dvd7e9EXTpN8f3LCl6fgx4hk8n+tmByOePqfT6S
         XfaNjCg5xXOg8+uwLVvYX+zXVIX/t2N0WAXA8sP1Jbc8xhghOg7Vm0mGuK93ye8H/hkC
         b+u3WSZBJZcjSc9M01II3aRCYoJSnNHw7s+2vUdsr+rTiy/LGwy7YujgIws3OhDDRweH
         HOh9PKLKPbtO4TVkaL8vOxQPgPygx0uhcpkLLJOFU5tD8vtHJpQk9jN1wFX2Fhgg1hYV
         WRm2JD7yO+uNSaaxeQhf+L/EqUlVwVaos4WJAC1uUydp9X6iP+m0P0BPosgXhb5mAcI+
         WJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=LGB1WfqGgk+E2BwfN1znIYNM8Z3EDS1Ck0ntTTU7ae8=;
        b=gt8cI/p53dJsOkJtYWxoEbkXV10H4QsSEETK3iMB359dYlHHY07OOhVQ9wBw5S8vtu
         3wEQrUPXOkYV/rZR/7i5YPBBjApCztiZLl4sNCMCWJHCOWUlfjqDIKrVBHNKrkULZEGO
         OS8FoLdVn6ZnRgYvD6k4rfTdV6UhdsZeFqotAsqnDo08JEiT6jjD2K4IVUSc5i+y9o24
         iDEysIZ3pD3OToy+pKyP5mwejDebJg/X3TVvCsaqCHj7eP1f1jDcFxjAbXw0r8Lar9d3
         PAfIo4asn6PJB8yputtnI/g9gGp1+FwnhtXs301/j4LeaMQ3MDYN53p5HVNpyvHV1BVX
         8UVA==
X-Gm-Message-State: AOAM531rjjrJF6VDSxaGJ4hBIednJs+3PWZOOyg9OkWjh46UttQEJYOt
        t5B+8uoZ/SZepkCd96ohQd4=
X-Google-Smtp-Source: ABdhPJysqiCEfdLErNwAUUYoVp5/a3euOcrunaaXOC5+fFMPXtLaIPATX703omSt4u8PEH29fpe5vQ==
X-Received: by 2002:a5d:6191:: with SMTP id j17mr16516791wru.299.1607298022902;
        Sun, 06 Dec 2020 15:40:22 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id 125sm12128389wmc.27.2020.12.06.15.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:40:22 -0800 (PST)
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
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 06/19] target/mips: Remove unused headers from kvm.c
Date:   Mon,  7 Dec 2020 00:39:36 +0100
Message-Id: <20201206233949.3783184-7-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206233949.3783184-1-f4bug@amsat.org>
References: <20201206233949.3783184-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/kvm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index 72637a1e021..b3f193f7764 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -19,11 +19,9 @@
 #include "internal.h"
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
-#include "qemu/timer.h"
 #include "sysemu/kvm.h"
 #include "sysemu/kvm_int.h"
 #include "sysemu/runstate.h"
-#include "sysemu/cpus.h"
 #include "kvm_mips.h"
 #include "exec/memattrs.h"
 #include "hw/boards.h"
-- 
2.26.2

