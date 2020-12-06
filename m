Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998DC2D0820
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgLFXlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbgLFXlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:41:35 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC71C061A54
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:40:54 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id e25so12106513wme.0
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dkeHRiNqYRfILITll5iC1CRHmgrIelrL5ahd1h8p/CA=;
        b=AJCAf6tBfcDaLHenkAJcWO8awSPcD6OV0VbmqjcQG8YLcoPHOBX9/zrsfUtNVfpmcP
         nIiZKqXotBUNxCRuPgt5jlY9J+OmF0W/JRNLxzmga4dPH9o6OjFFAvwGFFet9aapdvQj
         4OhagE7WsNKL70LrawKpoX3U5So49v1TraNAHhsokMcGAZgM1ZCnqC4yyvRqs39x/TbY
         N5UMqqtUfCM3amuvAeTqwaJ44Yc09OO6rP8Wd5M1gDiZNFIutZ8C6OLPOykS5/ywo3T2
         xNxVSkbiwCbPmm1cwlK6ZEIrga3rfqeagoYvTmpGjkqsuoRdZxKM29h+CQlW5mkWJQ4y
         EGww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=dkeHRiNqYRfILITll5iC1CRHmgrIelrL5ahd1h8p/CA=;
        b=DFyMOdOKOsTMj5p98P4ARj+BQBK5rijck4aYJH/Md/DtgIS3P8y8wX7QsBI5xmvnGK
         MgJiXP93qWb28RKlwFDdprgLjY/COvMSqLsJVJWDBB68VQjsuiuQuZt5DcQZVZ9iSpwu
         38iumXKfAMVvc3pM9TelykswSjSD4ilx2jwCXFStOIoHVBFmXGblIywsgsYbGc30Q/fX
         d29onjfadijNMA84vNcSYTFxuB12w45KGyeChPdHU1qmEyepaliaD29Hizlz7glZC/3J
         mxhIif0KDfYFknLd4Jp/bNfnnVYm/u2xPPVlZ+Kq7b7H10PCPWXsuCImRxUc8zTjszGY
         wDoQ==
X-Gm-Message-State: AOAM533pJTqWPbkgyEqzhWhr1POzCBaHYh+rZhg7jMlf9SPK8ZbP+RcP
        g7xtiStFKXJ6CiiFUJdg+UTEYU30C6Y=
X-Google-Smtp-Source: ABdhPJz3cUW+H59OJ3Lwu1sxBPsBIrKMW2o+PML6fhNgBmnIF9weKVx8bfaabn+wJQrAekiecwHQeg==
X-Received: by 2002:a05:600c:208:: with SMTP id 8mr15652630wmi.146.1607298052994;
        Sun, 06 Dec 2020 15:40:52 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id a9sm12901278wrp.21.2020.12.06.15.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:40:52 -0800 (PST)
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
Subject: [PATCH 12/19] target/mips: Rename helper.c as tlb_helper.c
Date:   Mon,  7 Dec 2020 00:39:42 +0100
Message-Id: <20201206233949.3783184-13-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206233949.3783184-1-f4bug@amsat.org>
References: <20201206233949.3783184-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This file contains functions related to TLB management,
rename it as 'tlb_helper.c'.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
Maybe I missed some functions not TLB specific...
---
 target/mips/{helper.c => tlb_helper.c} | 2 +-
 target/mips/meson.build                | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
 rename target/mips/{helper.c => tlb_helper.c} (99%)

diff --git a/target/mips/helper.c b/target/mips/tlb_helper.c
similarity index 99%
rename from target/mips/helper.c
rename to target/mips/tlb_helper.c
index 5db7e80e22b..7022be13ae4 100644
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
index 4858bf86ad6..c685f03fb28 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -6,10 +6,10 @@
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

