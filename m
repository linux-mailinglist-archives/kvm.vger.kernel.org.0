Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E792DB6CC
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 00:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbgLOXAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 18:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730279AbgLOW7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 17:59:55 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C58C0617A6
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:59:15 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id x16so30052546ejj.7
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LK9i50FxwiL3rNg7XdhCP+0wnCiZXodjB1KHibKvjIg=;
        b=C7+31wk0dn7nvtLlLbxQ4tdyPvFocz+jtQVbV6fd/Exq7EiiI1Vs35cDoR/f5NBMCj
         RJMJx/qMLe+sSU9/eg6XYz8vQaRJH1URYGtksIlkLf0lNyEYKvAV8w6MF0UhRvYhAzjf
         q+xXwE9N0zJW7KvCaM4qaJYOEBq6l1DX0UWNa4LNAg4ZKBHKuIm6NNAvD14mZLB5zdbg
         SoQLlCidIImoZC6Aokyp4xjMQ8kA/hykrPAmqCjOFlYQsTtznNZa8fQvau+NpOOlOeDJ
         DRRPas9CQnCp/CuW33x/Co5DZUGOXpMZyjJ5WBbPq9V63bMms/ivXFJMki9d8pX0Naab
         ha/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=LK9i50FxwiL3rNg7XdhCP+0wnCiZXodjB1KHibKvjIg=;
        b=oVBdoRUeFMtubDK754LTXudPgmNqKdsIJzN2hZ/p5jY7SLHJ4x1iT+ViGyAMRl0WhV
         ZmX9V+vmJ7b2rHfMxvLQnEURhuInmtSdGC0KTJDPA1PV020JtmzBTFTx3JaVHQiriBqX
         egq8C9DWecySnOPI4VFV2cFiiLetxg/jPZ2PrgdrFPtd/IEwH/oJnlefWHT2HcW/okBb
         CB7J0GqGgsmqfJ68kwaYcXJJ0GTvN0wcDNbNCvIASa9q34kz4z1m4o6lVZsiV9Z4Sl+8
         MTGTokbqM2xUnBJ6a4A+NMfjHNbGVLBp3/KJvBeM34z7BuqxHV8aY3aYY/ct6B83JhX2
         qP4w==
X-Gm-Message-State: AOAM532ySqQ8sRtTTXkQhUuv5tyt4xpke202HRyxF4x5wPlB22MHBNfx
        jQKTA/sAiWBdGUQPs51QQskQcTFCnfD4Sg==
X-Google-Smtp-Source: ABdhPJwQL9CCQxq3bPS0duIjRuCmTSMfE/3q2UjXzR60heKG3S98TXLkf8U9pAaYKT0+ILnrFYl6pw==
X-Received: by 2002:a17:906:9250:: with SMTP id c16mr29307186ejx.355.1608073153983;
        Tue, 15 Dec 2020 14:59:13 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id cc8sm20203236edb.17.2020.12.15.14.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:59:13 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH v2 13/24] target/mips: Rename msa_helper.c as mod-msa_helper.c
Date:   Tue, 15 Dec 2020 23:57:46 +0100
Message-Id: <20201215225757.764263-14-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MSA means 'MIPS SIMD Architecture' and is defined as a Module by
MIPS.
To keep the directory sorted, we use the 'mod' prefix for MIPS
modules. Rename msa_helper.c as mod-msa_helper.c.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201123204448.3260804-4-f4bug@amsat.org>
---
 target/mips/{msa_helper.c => mod-msa_helper.c} | 0
 target/mips/meson.build                        | 2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename target/mips/{msa_helper.c => mod-msa_helper.c} (100%)

diff --git a/target/mips/msa_helper.c b/target/mips/mod-msa_helper.c
similarity index 100%
rename from target/mips/msa_helper.c
rename to target/mips/mod-msa_helper.c
diff --git a/target/mips/meson.build b/target/mips/meson.build
index 596eb1aeeb3..05ed33b75ce 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -7,8 +7,8 @@
   'dsp_helper.c',
   'fpu_helper.c',
   'lmmi_helper.c',
-  'msa_helper.c',
   'op_helper.c',
+  'mod-msa_helper.c',
   'tlb_helper.c',
   'translate.c',
 ))
-- 
2.26.2

