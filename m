Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756112D0817
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgLFXlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgLFXlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:41:15 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D981AC061A4F
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:40:18 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id a3so12052927wmb.5
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wgUivnHTiFsBsZUJynu5sdeZ+qIl0Vpz/g/o+OzVfXc=;
        b=E/w6I/YA1QBm/TJRhjJKH6UCcB0vEAmhPTcnvK9MTghg2gfjSoujrDqduMv9seuqeQ
         vwzngALnI38rHHDk/z6aPvSXmgAIICymbKJoWZ4aaTDbSICad7V+kstgPc8wIs8BZH8M
         evZ6S0kfYSiEMF1QCXoRCBZNScSp2fkR4k3GEBL1vJjmMuZ6JSZQKl0RT5Ztm2yM73fv
         VcoczWisynMrLtCBosob12MrLxCZwNz35lJU1p91FHy0ePl8G68zg9Pce1+qt15sH+tF
         UHK7tDRu+L6oCSIRI0kI6hy5jyg0Ux5mG5dJMTBGwDn9k6BqNACTUgdCwCxY6ViIhoeK
         zjAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=wgUivnHTiFsBsZUJynu5sdeZ+qIl0Vpz/g/o+OzVfXc=;
        b=Gh79VIu8vslOfYmSz65M/+Y11pQoXyNH2jdRk4lP4mfX40gylp597KkKypH1kEYGre
         plabYNcZD7LLtxTCrz4TMNg40glW+10/kPUak+JMZZNvnLxtD1r8db1mOLEw9iYVEhTR
         USICpPzQt3c+jlFiPgfYWRKwfK7fB4LU/IbhbfBNR1vuF1Eq0LceZorfF01iEyqkzGGL
         7YiHyriBiBKn5AdD51O27U0+/A2pYW0vo/UOS02klmemo1MYPXXgz3PNehpoUCysDGXC
         2rBfYJoZ1zGA27A1OmRXKYS5eB0+GqKqDYFvdQaLX7t2WQhfJpUTjji4ocLtfAHTTugf
         XNkw==
X-Gm-Message-State: AOAM5323nDhjvtn4a8dq2c6vzcjwwl6eXmuDU69rvRahj3Rux9PZ4v+a
        VlYgcb5z/4K9kBtbBcVMzRU=
X-Google-Smtp-Source: ABdhPJyn3aNUhSifbgw9ga7ggzYpifzBJNJITGXqPHS89nq/anekJvKjvBXt16wY19n9bHCAzW5XYQ==
X-Received: by 2002:a1c:e309:: with SMTP id a9mr15672224wmh.172.1607298017714;
        Sun, 06 Dec 2020 15:40:17 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id o203sm12394160wmb.0.2020.12.06.15.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:40:17 -0800 (PST)
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
Subject: [PATCH 05/19] target/mips: Remove unused headers from op_helper.c
Date:   Mon,  7 Dec 2020 00:39:35 +0100
Message-Id: <20201206233949.3783184-6-f4bug@amsat.org>
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
 target/mips/op_helper.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/target/mips/op_helper.c b/target/mips/op_helper.c
index 5184a1838be..5aa97902e98 100644
--- a/target/mips/op_helper.c
+++ b/target/mips/op_helper.c
@@ -19,15 +19,11 @@
  */
 
 #include "qemu/osdep.h"
-#include "qemu/main-loop.h"
 #include "cpu.h"
 #include "internal.h"
-#include "qemu/host-utils.h"
 #include "exec/helper-proto.h"
 #include "exec/exec-all.h"
-#include "exec/cpu_ldst.h"
 #include "exec/memop.h"
-#include "sysemu/kvm.h"
 
 
 /*****************************************************************************/
-- 
2.26.2

