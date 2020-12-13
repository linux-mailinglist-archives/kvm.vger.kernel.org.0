Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152062D9062
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393086AbgLMUVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392882AbgLMUVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:21:21 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B5DC0613D3
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:39 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id x22so11943543wmc.5
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UKVyHTJcfnmphpZOlFQ3sK0TO5i59SQTbNG7ZpwIL2s=;
        b=Q2ksS/NIJwRo6OVacRh1D3+KqjRnj3fQkjk+RFruSjRTqsxfiGyG+2kd+xqRaPSyNn
         Og8GyaYIUtXhBQX+ZW1nfYS1ilo/N/MXh94szzfdIv4dta73ui2OpQFnEmnU3t/r+teV
         Tka2QbqFNDF+03VruDSDXm2EDY0TDxtdzQcGizbC803leH6tL1MOB8fNUmFcmB7n+bV4
         N8yARhMJkKFDmnjPEv7kVWv0GVMvQAhDMqIa45YAM3Bwo7t5En2DVylczCrwAzDEA5Xl
         sIg9lVvazuHl6l7sJEEFsd8GbAJt4sB2QIEPGG9ZKAcN5ikpBAIkwDEfNdY7XCyoOr7v
         +I3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=UKVyHTJcfnmphpZOlFQ3sK0TO5i59SQTbNG7ZpwIL2s=;
        b=okxy7xnTGMlSIH+V/hL2qAL4wOw4+Ig8M8dQY7b+0ndsroXzhBCx98G83xNnzYsiDX
         wr7xsXyWrCMgt+xpmE4RZ5bmpTVXuvSmLjxiy7vfavjzFpyvfhNi6K1QSXcTpEwjgMNO
         hS8TteCAa7+oBBA12hEweWAR9MgHli/aCKHskgojCFEcb5GWlakHHpLHNiPzVv6hu6h8
         /KLi2z6O9k+0RH0aE26BTP5rZa1np8fFNnnKZTUA4Id/tjP4pOylgW8/7uhwyS/1iRwL
         NMkap3O6kVFfXG0JLeYDaboneJLKBJhX/AtNP32bufyv/R624zGK/XNT7pyXYzzpmfvq
         dpxg==
X-Gm-Message-State: AOAM530fxQxFEW7AWSu4p7vLykUCeovtPb88P2abShixhVbxH0+ipkJX
        bXY98TQh6zY1C6XTPTq9Ko8=
X-Google-Smtp-Source: ABdhPJzgoE2qp8c/gtBc5k0f18CqNg5PxnMO3ehBmX6yeySByMtolXCKZoaCC8qZNyu+dyEmkIbmeA==
X-Received: by 2002:a7b:c773:: with SMTP id x19mr23833930wmk.127.1607890838712;
        Sun, 13 Dec 2020 12:20:38 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id r20sm28985853wrg.66.2020.12.13.12.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:20:38 -0800 (PST)
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
Subject: [PULL 10/26] target/mips: Explicit Release 6 MMU types
Date:   Sun, 13 Dec 2020 21:19:30 +0100
Message-Id: <20201213201946.236123-11-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As of Release 6, MMU type 4 is assigned to "Dual Variable-Page-Size
and Fixed-Page-Size TLBs" and type 2 to "Block Address Translation.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201201132817.2863301-4-f4bug@amsat.org>
---
 target/mips/internal.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index 76b7a85cbb3..bcd3d857ab6 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -16,10 +16,11 @@
  * CP0C0_MT field.
  */
 enum mips_mmu_types {
-    MMU_TYPE_NONE,
-    MMU_TYPE_R4000,
-    MMU_TYPE_RESERVED,
-    MMU_TYPE_FMT,
+    MMU_TYPE_NONE       = 0,
+    MMU_TYPE_R4000      = 1,    /* Standard TLB */
+    MMU_TYPE_BAT        = 2,    /* Block Address Translation */
+    MMU_TYPE_FMT        = 3,    /* Fixed Mapping */
+    MMU_TYPE_DVF        = 4,    /* Dual VTLB and FTLB */
     MMU_TYPE_R3000,
     MMU_TYPE_R6000,
     MMU_TYPE_R8000
-- 
2.26.2

