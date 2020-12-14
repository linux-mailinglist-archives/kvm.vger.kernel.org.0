Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08812D9F62
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408832AbgLNSlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408896AbgLNSjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 13:39:05 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17771C0617A7
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:14 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id e25so16193946wme.0
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8LC7/cpbLmFmCpCdsWMBAZLA2elqMbfY/U5LRkkEQ4w=;
        b=URmAnvrSw3+rmfGrZ+no4b5Lcrec0Kqp0lNe2JuQLRP1bILan3ppJpC/IQgdIxKs7Q
         +bmK30fxdvE58S0Y+OwPM2NwWrZ4n0TOwtfDJXZxIQOngo9u2a4EoKzUM775qmkjXWwE
         h63BP5nBBLU3zGcT/LFFQmV4Jk8O9Zvz2MJmEmycHnP/xdX3xAQyXXJPO+FemWhalK50
         XcchaHG1hnu4sMNw8XAdQDRxgRhbiO+qjRzicNrFi2Uzl9R+qYHGKVXwduOcD+JYHLtL
         aBLjhH8t3ODfbEBG47jOTvxH1aURoBSwVWpDrtpB0tX58NLt+V7o4NJKj9YeEwRbgm7W
         coHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=8LC7/cpbLmFmCpCdsWMBAZLA2elqMbfY/U5LRkkEQ4w=;
        b=ehgnmf/8zcguaecGGBrhthOVBlOjup4iP+LNdKxhcXmNpcQp4Z1fncvAYSEyW3yzSB
         8DQYL5vlDxcEEdpcPGiYVTvbD5GvWuHR4xRf4PqWcDF5c1vNJ2aspsGJtOvHOzHyOwFq
         xbQhLZhl2168Yu7Rtrk0dAsoxET9sK/m7VUrkWfhH7Q7Chk9esGTeRZaHpTwJLLz9q6d
         OEk6ZyUf9mEDNQ6SAUkeygshx3U4p64DU1wjIPpzRuuhp2NvGsnyS7/QwD21sGx74Qh/
         6TchnbZ3BOnTZVmbhQ5EeZWzCWxdB29O2860K7B2ZRETcOBYo8qi9RiQLiGTuK0s4OAD
         qvnQ==
X-Gm-Message-State: AOAM532eIrdBNUYBgMzs7W8pCO0SIh/114QJ/gmo5f+wgV3AobHXWqt4
        TVSchffiS2pweyGlNnX0wXMSqHBQuVE=
X-Google-Smtp-Source: ABdhPJypoAc+0LLSY2eLKsIDkQhh04/COoZyQzQJoudCNtNC1CMePgXrJmRksR8sstCKXszd7R/AUA==
X-Received: by 2002:a1c:7d88:: with SMTP id y130mr28665528wmc.158.1607971092851;
        Mon, 14 Dec 2020 10:38:12 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id v20sm31460263wml.34.2020.12.14.10.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 10:38:12 -0800 (PST)
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
Subject: [PATCH v2 06/16] target/mips: Rename helper.c as tlb_helper.c
Date:   Mon, 14 Dec 2020 19:37:29 +0100
Message-Id: <20201214183739.500368-7-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214183739.500368-1-f4bug@amsat.org>
References: <20201214183739.500368-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This file contains functions related to TLB management,
rename it as 'tlb_helper.c'.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201206233949.3783184-13-f4bug@amsat.org>
---
 target/mips/{helper.c => tlb_helper.c} | 2 +-
 target/mips/meson.build                | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
 rename target/mips/{helper.c => tlb_helper.c} (99%)

diff --git a/target/mips/helper.c b/target/mips/tlb_helper.c
similarity index 99%
rename from target/mips/helper.c
rename to target/mips/tlb_helper.c
index 59787b870b8..2e52539a511 100644
--- a/target/mips/helper.c
+++ b/target/mips/tlb_helper.c
@@ -1,5 +1,5 @@
 /*
- *  MIPS emulation helpers for qemu.
+ * MIPS TLB (Translation lookaside buffer) helpers.
  *
  *  Copyright (c) 2004-2005 Jocelyn Mayer
  *
diff --git a/target/mips/meson.build b/target/mips/meson.build
index 4179395a8ea..5a49951c6d7 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -4,10 +4,10 @@
   'dsp_helper.c',
   'fpu_helper.c',
   'gdbstub.c',
-  'helper.c',
   'lmmi_helper.c',
   'msa_helper.c',
   'op_helper.c',
+  'tlb_helper.c',
   'translate.c',
 ))
 mips_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
-- 
2.26.2

