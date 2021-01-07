Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0E32EE887
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbhAGW0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbhAGW0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:26:10 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581A5C0612AB
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:25:53 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id c124so6332554wma.5
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3jTmKcmmqBWLYbQ1cWD989jXI7AUr/FtqoKPQ00ZpaA=;
        b=JmCr9XMH0Xb/5ySjXnTL2zj8cPAsTgQNJ2XdfmLENexBJjnJtbsVgKl+4pTFOSwxGM
         bvYcgCEbrEO3qU8Xam8cLfy8CwX8GDys5m8nIKN2uDp6FwZYFZ9HHZTVjoQDU0XHmjU+
         D/NIctv2mOmnFWzaCcvTmdXkQ92s3QDfSOpnT3XTfytSuH3pJSu3q5IqezBWliQFVgT5
         apFP/C7KxsmT8lUS/XP44hhdFX8aSDXCfbfR7vVF5PD0wxu0ALVjRzADkJtUU70UcNCl
         ppnSQ25S/68/gkMsSpJyFxK1TGItTa5782GF5BA+nj6p00BSoQ6ZbfVWzf64cPrhF/lE
         K6cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=3jTmKcmmqBWLYbQ1cWD989jXI7AUr/FtqoKPQ00ZpaA=;
        b=ZQSfFb2VhDLp99JbeRv8A6n+gRvcmYzr+yxvCqTw/pwcZ/yk9oBTjEvp6rBhHDva8g
         gC+w+ihtQC5wCgWdrzKtQr5Fm9wJp61GUZQZ6ldN7wKfEFUpoDKRaEDAxAv26iiMtOAb
         THxrTCQcXdf+yEcjYY6kulk8Z9mr/59huQdzgVLn4zCGvfICyV4B3UYHYOB1+01B2+hI
         oJWe9T6kC8Oml0oKJTvRSUF95SHAzFrBUXDRidP6CTixTyijObPlzZl7eX1mIblYCmZo
         BJRgGEatfqcdBEnrszU4EfvETfU5IX/0+NvAxb7emLy+V6kRPPuCrSouJ6ec0in7vkBO
         8+Tw==
X-Gm-Message-State: AOAM532gy3Zo5P73+cfqs9jVD6PYDLC3jdg7hWnNVskKsZumC+otG/Kz
        BOrELDT0tME3FzOYgw3+I0s=
X-Google-Smtp-Source: ABdhPJySWP2OfH3zDeQHbohqijhGKNj//KPNIRETWR+IRsQBzw41eeOhKpXMHUzNlu9Sj6QDr2gJGw==
X-Received: by 2002:a7b:c145:: with SMTP id z5mr516372wmi.164.1610058352120;
        Thu, 07 Jan 2021 14:25:52 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id x66sm9249543wmg.26.2021.01.07.14.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:25:51 -0800 (PST)
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
Subject: [PULL 34/66] target/mips: Only build TCG code when CONFIG_TCG is set
Date:   Thu,  7 Jan 2021 23:22:21 +0100
Message-Id: <20210107222253.20382-35-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
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

