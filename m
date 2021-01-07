Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADB72EE86F
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbhAGWYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbhAGWYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:24:47 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056AFC0612F9
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:24:00 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id d13so7067485wrc.13
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R9iTS/+Q/OL/iW6QRfMv5vZReuHwVb5bW5AGpFsloxk=;
        b=tUcaEvYkwN32GC9JZSJWC6BFGCBWEbk26/SDV94fflESJutVaCrHRc8zOkayk84Gkc
         NimTDEzVoNIXnJxTUs8OQjSVlWyMA0KJGs1Ngg11NasyZ8u8l7EWDPnoRb2saxPkWaY6
         oTy4DHY6w/IhMcv0UCz6l6GNFiMOdq+cu1cWql//dqzOR/yHVKqKdEJGfFQyAc9JAuYs
         vortXdPZv6+DzeeOEAASZrRyhixj4hFujFtpMDGJ0FBakRkUZTYkKimVcwGyVsZLxrSY
         NIuKLIm5llCHUk3ZDbcpfdEqX559I1zY1nawJe81k0ogfCPEUCeb8BdmgWDH57oVPPTv
         iARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=R9iTS/+Q/OL/iW6QRfMv5vZReuHwVb5bW5AGpFsloxk=;
        b=HJKhPDYgDhzPkae5K2SWMyaDg5jUpe5dgq2EGocqMNlwVIgNDV33G9qWEgIxZWaAZ2
         hjKaMaY1DSSBNw0Bo/GUNEboMlcbxpnuDgTWkWMfC99YQn0TZWq7E+fy5f140YxyDX9O
         GO15tjSccxDoMxiU9D6ryt96IRZo7aSnz3AYmXDMkInjdZrWn6dIerPs1RogsrbIq2Sh
         0Rya5U4N5BA7NT8TzGvLrJda8lVvvCqfLAyk06R6TPOwttnA8tFqhZtzB5+Bf5l2czFx
         ySewU0qJzuVKnQhX+h5ggxv+FZ5wk2mhRRAIy6/DOo5o8DDYWQHQLwSSQ6nC3vZ3Aav0
         uZmg==
X-Gm-Message-State: AOAM530GbfN4iS0utHBiNtf/r8+90/Rl0bIr+SOiq5cpZzXIaFeR98XL
        EnxwK8toY6+HH4+B4H64nd4=
X-Google-Smtp-Source: ABdhPJy0sO863+4qLz2HdBGbQrXuLugI5GKgLWVCcPwhAv9Pa6qnXGqqntjW9U6RUL8K1L83XVKcEw==
X-Received: by 2002:a5d:6a4c:: with SMTP id t12mr657799wrw.249.1610058238789;
        Thu, 07 Jan 2021 14:23:58 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id c16sm10724308wrx.51.2021.01.07.14.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:23:57 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     libvir-list@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 12/66] target/mips/mips-defs: Use ISA_MIPS32R5 definition to check Release 5
Date:   Thu,  7 Jan 2021 23:21:59 +0100
Message-Id: <20210107222253.20382-13-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the single ISA_MIPS32R5 definition to check if the Release 5
ISA is supported, whether the CPU support 32/64-bit.

For now we keep '32' in the definition name, we will rename it
as ISA_MIPS_R5 in few commits.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Message-Id: <20210104221154.3127610-10-f4bug@amsat.org>
---
 target/mips/mips-defs.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index ccdde0b4a43..b71127ddd7c 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -20,7 +20,6 @@
 #define ISA_MIPS32R2      0x0000000000000040ULL
 #define ISA_MIPS32R3      0x0000000000000200ULL
 #define ISA_MIPS32R5      0x0000000000000800ULL
-#define ISA_MIPS64R5      0x0000000000001000ULL
 #define ISA_MIPS32R6      0x0000000000002000ULL
 #define ISA_MIPS64R6      0x0000000000004000ULL
 #define ISA_NANOMIPS32    0x0000000000008000ULL
@@ -84,7 +83,7 @@
 
 /* MIPS Technologies "Release 5" */
 #define CPU_MIPS32R5    (CPU_MIPS32R3 | ISA_MIPS32R5)
-#define CPU_MIPS64R5    (CPU_MIPS64R3 | CPU_MIPS32R5 | ISA_MIPS64R5)
+#define CPU_MIPS64R5    (CPU_MIPS64R3 | CPU_MIPS32R5)
 
 /* MIPS Technologies "Release 6" */
 #define CPU_MIPS32R6    (CPU_MIPS32R5 | ISA_MIPS32R6)
-- 
2.26.2

