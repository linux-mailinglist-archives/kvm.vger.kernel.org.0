Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3990730941A
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 11:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbhA3KMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 05:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbhA3Byj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 20:54:39 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92B2C06178B
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 17:53:17 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id s7so7635864wru.5
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 17:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sHwmePAwBZnB/6MQG332p6aeurp1aOW9YUVHNzJgQQk=;
        b=HJZc1PSaje6m+L7668kBqPcK1wBm9CBsKO2kC1XrobpTcPPnHU6ITs11hbUl/YKjbc
         DzmcMbtXJnzP6jZlLgdJWwpTlE27nSIkIGsIVBfAmCGKQgMB/xWkVmaOqqSFYsifLlUd
         43jJZWsgGnfdPJBE8xZg+aMXkJ51DSQ7epXkB4qfmO1Rp1YXYWGGo76hopz0wEqPZD4D
         B0dQ+lKuMROs0W/ZONElGdzV5hnhFvdWMUgJODm2C2Sdaq2e81ytYWHR/5xXLEXTV9v9
         iQCHMX91/noURZa+VVbdTq8Y8AIgbZ7bd2E4fXynsrlRzci32qoKpvpXMMtBXeUyxVrN
         GbZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=sHwmePAwBZnB/6MQG332p6aeurp1aOW9YUVHNzJgQQk=;
        b=iC3CMOqY0eGql5D1RXuft1QxDHymMDX1QhMBRvT8pYLi+RZSWv9xpFMq2U9YGPoqo2
         epLUafOXvrS59/OxxKSQwzLgJy11mMCF6KMEKJvOeTtmdgpG7nIsR6cwkxveAMeEG9Dl
         sKbWuG2M7Lf5m5TYsh+oh5j3QeBJkKxohObMYMUjYOtIyKprVeomPc0QB04xvLaxcMNZ
         b2ordUThmdYSu6oaRPSc6kN16tajrIxJZsWOgWwyaoZ2tL8fKqNgE50Ie2xa+nUYvkM3
         3zscPycPbs4sAIItzAl0sygkefL+bqq4YR4wAS4UZR5O3q3uvDxUtdd8y9R7CJlsbfj+
         TN/w==
X-Gm-Message-State: AOAM530IIg4bAm8dqITs+XrDyEAvzSOEGz7ZLWkpBUxVDC8YCGAd2Vwr
        VN5TgLpabxlSr1B5XuBsL/0=
X-Google-Smtp-Source: ABdhPJytRdW5ApRmNTPnsqDHD7BiuYa2AbAtlk3vbvJPE6VBSMcsUQvRsWX8iwp2BHbkvB+QsXhcxg==
X-Received: by 2002:adf:d4ce:: with SMTP id w14mr7095039wrk.89.1611971596601;
        Fri, 29 Jan 2021 17:53:16 -0800 (PST)
Received: from localhost.localdomain (13.red-83-57-169.dynamicip.rima-tde.net. [83.57.169.13])
        by smtp.gmail.com with ESMTPSA id p18sm10429022wrx.84.2021.01.29.17.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 17:53:16 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Claudio Fontana <cfontana@suse.de>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org
Subject: [PATCH v5 09/11] target/arm: Reorder meson.build rules
Date:   Sat, 30 Jan 2021 02:52:25 +0100
Message-Id: <20210130015227.4071332-10-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210130015227.4071332-1-f4bug@amsat.org>
References: <20210130015227.4071332-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Philippe Mathieu-Daudé <philmd@redhat.com>

Reorder the rules to make this file easier to modify.
No logical change introduced in this commit.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/arm/meson.build | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 6c6081966cd..aac9a383a61 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -14,31 +14,36 @@
 
 arm_ss = ss.source_set()
 arm_ss.add(gen)
+arm_ss.add(zlib)
 arm_ss.add(files(
   'cpu.c',
-  'crypto_helper.c',
-  'debug_helper.c',
   'gdbstub.c',
   'helper.c',
+  'vfp_helper.c',
+))
+
+arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
+  'cpu64.c',
+  'gdbstub64.c',
+))
+
+arm_ss.add(files(
+  'crypto_helper.c',
+  'debug_helper.c',
   'iwmmxt_helper.c',
   'neon_helper.c',
   'op_helper.c',
   'tlb_helper.c',
   'translate.c',
   'vec_helper.c',
-  'vfp_helper.c',
   'cpu_tcg.c',
 ))
-arm_ss.add(zlib)
-
 arm_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('m_helper.c'), if_false: files('m_helper-stub.c'))
 arm_ss.add(when: 'CONFIG_TCG', if_false: files('m_helper-stub.c'))
 
 arm_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c', 'kvm64.c'), if_false: files('kvm-stub.c'))
 
 arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
-  'cpu64.c',
-  'gdbstub64.c',
   'helper-a64.c',
   'mte_helper.c',
   'pauth_helper.c',
-- 
2.26.2

