Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81552D9F64
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408700AbgLNSlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408912AbgLNSjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 13:39:10 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1813BC0613D6
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:29 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 190so4450470wmz.0
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=klGFn3hgbo3GHDfsgMyJiiPYSrCAsjHYiV/EbjhfoW8=;
        b=CfuHL44otRpfSJlVrA7fEOVv4k4CUkmVu9LTTPz4deOlBK0C1oHElDzWpSNIEhhUyK
         wzOP+WTWzwTB673iXjSOqxnHXT5Za5YADguwGPDlnRZuNDxhPz6YzoDGFFSFj0Owt37P
         2qvgbzypxffE7Gj6OKAb3NPTTfJf/zU+ndpApB+teYdeN/erVCGlN2FwyPB7mIxodBTq
         2qsUk9KbW3SHhfyB87dKQwU8YTsYnhC7DL6xMTpQ4Dv1i34VYT/5MUBa2j1ntNmxJSCW
         diR5/uSlHzp7lrKTC4xMbZj7tlhrFaBv22Vt8Ju1RiPxLVHWFElxIddUZI7flxOWocEt
         HSTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=klGFn3hgbo3GHDfsgMyJiiPYSrCAsjHYiV/EbjhfoW8=;
        b=Wn3RKTypfHcCCNFzRg0wmqks2tK0p8w5yWFcrH6bwd4ZygO5yDBgw/105dK88+wwyx
         nf33p42Hcd4YZAdmNpEiqWvf/zc62zDlqk2iNFZ6k8B3yBg8e7UD1tnRA+/CBlYSqO44
         IYt8G+MTLLBG+E3jATj2cAAHnFcg6fTlkbaSMCuyWUML0PZ5xaZAixj3tFmkaOsr1nKl
         xrQwA66rspEz13tKoXc0wDtEYoi4SOjoaz3VFsHUO26X7Qtth3aY+chMlDmEsY+e5URC
         XTQmO6EH/GasCwRRSLeFWCc4WsmLXncj/avMmcjn0ITDA7BPY6+nrLoOHEQEKdzZKFcF
         G1rA==
X-Gm-Message-State: AOAM530qSY3m41Tw9wcxPkHHt/Xk2feuMi8CFObsoFAl7wdEi8DgIC70
        BJbztTa34sCTqgvI5bhjbTA=
X-Google-Smtp-Source: ABdhPJwTylQrlnQiAcKtSTABN0Cyubl7ydCIKMOBhBiDuRoYFl1iO9R9G02tB86I99Zq8ufgPtmWqg==
X-Received: by 2002:a7b:c208:: with SMTP id x8mr29319888wmi.179.1607971107920;
        Mon, 14 Dec 2020 10:38:27 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id i7sm20396778wrv.12.2020.12.14.10.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 10:38:27 -0800 (PST)
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
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v2 09/16] target/mips: Rename translate_init.c as cpu-defs.c
Date:   Mon, 14 Dec 2020 19:37:32 +0100
Message-Id: <20201214183739.500368-10-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214183739.500368-1-f4bug@amsat.org>
References: <20201214183739.500368-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This file is not TCG specific, contains CPU definitions
and is consumed by cpu.c. Rename it as such.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/cpu.c                                    | 2 +-
 target/mips/{translate_init.c.inc => cpu-defs.c.inc} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename target/mips/{translate_init.c.inc => cpu-defs.c.inc} (100%)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index a54be034a2b..4191c0741f4 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -311,7 +311,7 @@ static bool mips_cpu_has_work(CPUState *cs)
     return has_work;
 }
 
-#include "translate_init.c.inc"
+#include "cpu-defs.c.inc"
 
 static void mips_cpu_reset(DeviceState *dev)
 {
diff --git a/target/mips/translate_init.c.inc b/target/mips/cpu-defs.c.inc
similarity index 100%
rename from target/mips/translate_init.c.inc
rename to target/mips/cpu-defs.c.inc
-- 
2.26.2

