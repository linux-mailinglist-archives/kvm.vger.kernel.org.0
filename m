Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8255C2EE883
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbhAGWZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbhAGWZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:25:47 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A2AC0612F5
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:25:32 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id r7so7118613wrc.5
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TMeZXBPfIw0UjpZf8Gz8v4KrcSgueeNPugH/0sy+Pio=;
        b=Luly0zoR582cNphF4JxYJ/wLU37qzjIgDaR9mJ2Q1F4IVZ5DXDsAl76xGz0RhYjKYC
         v5rFDRvqQn+1E3+dd2HOUHoPMaXSJKrMPL7YXVuvSRxu2PHpZPkV245s9JZKAtvY9JEY
         03Vmf5qKPNt/byK6qL9hehSYI/aN8waCEtIFNo+ko8A3y6ZUO01bg1RggubpRvzNTtKq
         wRWBQMxskzbMErKL4r6/129J9lPtGfDV9ha230uUsnE6LNrBHm7haaxWkGlncI9dQGI8
         qSyE64sSahKBqaeF6KbARomyT4/4at0XEATFE4DGIuL0Id03BbZBl74xzfLWCCb/Q1jg
         k3HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=TMeZXBPfIw0UjpZf8Gz8v4KrcSgueeNPugH/0sy+Pio=;
        b=GZs1cp49O4gjYRNB64wYTFRQz5sPEHJhdHksYnQfLz2BmXG9iZUONdHmUAcSF23Nm1
         aAcpMFwHaibmvI8mFAc9xpn/+RsfoEBSIpFVEu7tq8kOxc1DPPqyItDZwpUx40ueMfA5
         lGeIiXC/LazD3DDLmwuOawZi8dsaLm/JwFPzV4YJWpGbtJctasu9SojlCci7gS83mPGk
         muJzeo2xHGnybrXO+fDieRjCm72K71rdJnFGCFS9gOaW4aNHi10XDWsHwKEdPSu19Kx4
         M/joi1IN8WuAba41F38aWkHKKcIe3KFAJFIZU3FGGk8Is4cwgx6+GbrajA3tqE5+2Hxi
         oUdA==
X-Gm-Message-State: AOAM532/Sj7u+R74gxs/OQC/gH23h4FPfphJQPitTb4xSDnaZz4KdhWN
        dpQjrzY67h5A/cyyIMwOp+o=
X-Google-Smtp-Source: ABdhPJyQheiVWednPyzYmSRVjnmfiD7VWxSYgMeazBYkbky7oQAAQ3mn/UgeIi/xUbmp1CUcnp2SVQ==
X-Received: by 2002:adf:fbd2:: with SMTP id d18mr703316wrs.222.1610058331183;
        Thu, 07 Jan 2021 14:25:31 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id k18sm12295867wrd.45.2021.01.07.14.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:25:30 -0800 (PST)
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
Subject: [PULL 30/66] target/mips: Replace gen_exception_err(err=0) by gen_exception_end()
Date:   Thu,  7 Jan 2021 23:22:17 +0100
Message-Id: <20210107222253.20382-31-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

generate_exception_err(err=0) is simply generate_exception_end().

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201214183739.500368-11-f4bug@amsat.org>
---
 target/mips/translate.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index 5889d24eb65..445858591a4 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -2898,7 +2898,7 @@ static inline void gen_move_high32(TCGv ret, TCGv_i64 arg)
 static inline void check_cp0_enabled(DisasContext *ctx)
 {
     if (unlikely(!(ctx->hflags & MIPS_HFLAG_CP0))) {
-        generate_exception_err(ctx, EXCP_CpU, 0);
+        generate_exception_end(ctx, EXCP_CpU);
     }
 }
 
@@ -3104,10 +3104,10 @@ static inline void check_mt(DisasContext *ctx)
 static inline void check_cp0_mt(DisasContext *ctx)
 {
     if (unlikely(!(ctx->hflags & MIPS_HFLAG_CP0))) {
-        generate_exception_err(ctx, EXCP_CpU, 0);
+        generate_exception_end(ctx, EXCP_CpU);
     } else {
         if (unlikely(!(ctx->CP0_Config3 & (1 << CP0C3_MT)))) {
-            generate_exception_err(ctx, EXCP_RI, 0);
+            generate_exception_end(ctx, EXCP_RI);
         }
     }
 }
-- 
2.26.2

