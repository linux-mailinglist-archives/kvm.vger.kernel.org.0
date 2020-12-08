Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253022D1F1B
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgLHAil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbgLHAij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:38:39 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0686C0611C5
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 16:37:58 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id ga15so22189460ejb.4
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aukrehohMNBj/77mUsP++hcXafJAket0+6KWGIXO0nA=;
        b=cYJvu8QmCh1iAR1hLkECf/nTF0tRLRFQEqhfJt7gWh0LW/xSxjZT+0CXHzPvis2QXq
         Rse/iqCWAF2iRQQdSbiJNKGOqrquoZddI6tBLgjgaERU04mpjsN/q2JGWXR0TR/VFlrR
         U+W2PF7plWveFFlsBr+4d9ZiL8HfXisOAM/MrtDHETwuqDFWpiC5azSjnFBhbiNVAWZ7
         E/RBx0FjkgQGiVPZyNdW06WDkk3CK9EwQEOj+CZHLS4zKjtwV1UXjO74mwC4uhqKAYoA
         darwQKnaXi5KhFBbp0KnkNSWv/OuWdoCO7gjc5CEgyoGF1EKPlnQ8dSnKZ0FOWrGlf6A
         Limw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=aukrehohMNBj/77mUsP++hcXafJAket0+6KWGIXO0nA=;
        b=NJe9FHeI16JgVGsQ3AiBCtDL77JMrEAoI2g7XtIpxXHlkDe1+N1hCPGpXO3MFEpoku
         UiF/WEuNMC6eTzjVuUXBVa2jUfDGGSn9K7eGL57Nudm3shReYdrNlSuve1nbCD5O6U0G
         +m8nn1SWOcPABFruY6e63do+q0WAifFOWiJ74nckp/jIF9WhtkK+TOiW3uCFH7DAnDBF
         FMvLPzKtqudDY2SricxM82aXfGgiNPWAtHD5CYY1lmeynoCLycYwnEHgu7ZvkV9vArDu
         NHdPwPQ7Wo4hopMAKor19YqAfabODiRvZtgCQzPvY2yFzY34PL30HCGv1IYvV3snkz7U
         QDBA==
X-Gm-Message-State: AOAM533CcGnjPz+nEAw8p/H6ejUI3gMWBd+3yDQsb9Qqd//wnOToJ5bD
        4dIeip8nvUlkoLAl39DNYrk=
X-Google-Smtp-Source: ABdhPJybqp2BNzaBlaHOIYhqOJWkb3UKa2oTa2o8LX+GbDac5ltWhOZMecS3sI/+6stAs6U7VoBYtQ==
X-Received: by 2002:a17:906:38c8:: with SMTP id r8mr21677157ejd.39.1607387877543;
        Mon, 07 Dec 2020 16:37:57 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id 35sm13972994ede.0.2020.12.07.16.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:37:56 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 10/17] target/mips: Rename msa_helper.c as mod-msa_helper.c
Date:   Tue,  8 Dec 2020 01:36:55 +0100
Message-Id: <20201208003702.4088927-11-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208003702.4088927-1-f4bug@amsat.org>
References: <20201208003702.4088927-1-f4bug@amsat.org>
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
 target/mips/meson.build                        | 3 ++-
 2 files changed, 2 insertions(+), 1 deletion(-)
 rename target/mips/{msa_helper.c => mod-msa_helper.c} (100%)

diff --git a/target/mips/msa_helper.c b/target/mips/mod-msa_helper.c
similarity index 100%
rename from target/mips/msa_helper.c
rename to target/mips/mod-msa_helper.c
diff --git a/target/mips/meson.build b/target/mips/meson.build
index 681a5524c0e..35dbbbf6519 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -6,8 +6,9 @@
   'gdbstub.c',
   'helper.c',
   'lmmi_helper.c',
-  'msa_helper.c',
   'op_helper.c',
+  'mod-msa_helper.c',
+
   'translate.c',
 ))
 mips_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
-- 
2.26.2

