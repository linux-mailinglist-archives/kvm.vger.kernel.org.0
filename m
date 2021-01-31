Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A88309C53
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 14:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbhAaNaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 08:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhAaLvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 06:51:54 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31BEC06178B
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:50:32 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id v15so13528048wrx.4
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NbTS4eSvhYMRXHU2vVjE8jfBdk95n+pM+UWftFmVvfU=;
        b=h1LzEJAXnr2fpxrCr74qTa92E0dAQb5YiEWfKSWN16Ei7mKBJSZQMVHDtkutWVDdYD
         QqYbWZZHSoxyuWQZ0pIEs9v6rLkDln3JPGHTftQ6RA5bwJSd93SlGR2L+ITnjWAutK0g
         tIS1BhDZkCAnE9y0tqhEZkdrRtZlLeW8E5mcViIcVkm0C6Wv07Py5VZXtuO1xTDY3Dc7
         mvaI5qvAC6+T8+Mvqn86Ru7LvFhZ9yPMrtGUe0qq02OGSlaFwVC0zKhpVON0ICphi4MA
         y3ISRBAX0Z+MYNv5DS5/to54WQKzMmf73GoOvsshWv3hWIjt2qa4xFrh33b18Zx6xf8E
         pYWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=NbTS4eSvhYMRXHU2vVjE8jfBdk95n+pM+UWftFmVvfU=;
        b=pGoC/muuMytPDPPGCE5RrDI5VBTUEcfSQTIW3SsCqzG00mJjWt+yey/AcY7owjkZyk
         UPfjNrgkwsTHNWTSc4NRuqZRcH/Rjpgpfm5Ql5RB6pe/lFCqWv44ln7Zm3sQvPgzTo5R
         94L+YvRJxQFOh/jElYDIi3ANdCDkp9UqbCYmMx1aYCJAIKRMBKYJzZ9V1YJOvARDN5aU
         RZo9WYb3erPbO5uI877ois6AOXvRW5ewLIryJJ6en/LGDcrAdvz41tg0IWZh/06SZFts
         7KvUQIxbbS8RT8vEfQKtAQd7mkPtloHnTk59ObYsMw2Bp6D4XVhHT5F6vx66KIxQbDZ4
         m82w==
X-Gm-Message-State: AOAM530SB4zpX0JKL16XGiaNhU97xY2LN1n87GG8UmuwSgQrD/Unzz+A
        U1lwQczrbHPayK2aK1yfKpk=
X-Google-Smtp-Source: ABdhPJzbicD1HJnXpjT27xzPC9x3I2AWZtVjzXvYLMRzjxZrSarnOD5x4M7qz2f/ytk+RI73IOJ3pg==
X-Received: by 2002:a5d:458a:: with SMTP id p10mr13399523wrq.168.1612093831543;
        Sun, 31 Jan 2021 03:50:31 -0800 (PST)
Received: from localhost.localdomain (7.red-83-57-171.dynamicip.rima-tde.net. [83.57.171.7])
        by smtp.gmail.com with ESMTPSA id c62sm5346752wmd.43.2021.01.31.03.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 03:50:30 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>, Claudio Fontana <cfontana@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Markus Armbruster <armbru@redhat.com>
Subject: [PATCH v6 01/11] sysemu/tcg: Introduce tcg_builtin() helper
Date:   Sun, 31 Jan 2021 12:50:12 +0100
Message-Id: <20210131115022.242570-2-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210131115022.242570-1-f4bug@amsat.org>
References: <20210131115022.242570-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modules are registered early with type_register_static().

We would like to call tcg_enabled() when registering QOM types,
but tcg_enabled() returns tcg_allowed which is a runtime property
initialized later (See commit 2f181fbd5a9 which introduced the
MachineInitPhase in "hw/qdev-core.h" representing the different
phases of machine initialization and commit 0427b6257e2 which
document the initialization order).

As we are only interested if the TCG accelerator is builtin,
regardless of being enabled, introduce the tcg_builtin() helper.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
Cc: Markus Armbruster <armbru@redhat.com>
---
 include/sysemu/tcg.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/sysemu/tcg.h b/include/sysemu/tcg.h
index 00349fb18a7..6ac5c2ca89d 100644
--- a/include/sysemu/tcg.h
+++ b/include/sysemu/tcg.h
@@ -13,8 +13,10 @@ void tcg_exec_init(unsigned long tb_size, int splitwx);
 #ifdef CONFIG_TCG
 extern bool tcg_allowed;
 #define tcg_enabled() (tcg_allowed)
+#define tcg_builtin() 1
 #else
 #define tcg_enabled() 0
+#define tcg_builtin() 0
 #endif
 
 #endif
-- 
2.26.2

