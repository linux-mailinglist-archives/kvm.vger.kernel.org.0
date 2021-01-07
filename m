Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B4A2EE87B
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbhAGWZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbhAGWZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:25:17 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6D8C0612FA
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:25:01 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id r3so7141151wrt.2
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gI14Ji2kQ24pI0kCRkP9vvsGbZB3n+f8o62PO5KS7K4=;
        b=c7qDgjfesbw0fPKyUWabRn2PZk1yUuEoxi3oAC3tSzPrvSRdHkJFwMBEsrr4rEZiYa
         f3fwfxvE7zy71dHQpv3Zlyvn6d02pbrv2irtq60wtvFQJ2U9dyO81PQkJSEiaOc0bOc3
         8UGOO1iYZDSpTfH9Qx8/EmQ9E5a16WuuWn4t0otSOVxODo2qgRx2cDYq37jdh1bA3EOg
         98Q5na4Gf/Z9i+DkfI6yE8J7dnW7YdP0E0jwcALz2Bwob9I1b4cPvRKDK3KlTCDBt9M6
         0yR24vOnyTVHyLd18TPjlialzASY4nT9G2dDrxJgdByH3ofWnz1MQFBwEn9QrmYbelVi
         IBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=gI14Ji2kQ24pI0kCRkP9vvsGbZB3n+f8o62PO5KS7K4=;
        b=YKnk5ZXeCFd2x1XgCvOul1y7YgYv1Qkran8QLYTVetedtahM5z+t8XZjRManQFBEIo
         55o9mMcIC0wSqz8MJRDJz7v4OE4aKGrgbE6J8FpDFw39uShy8DixxwJGKH0jMkuc5N++
         jousi2/WRX2kFEeS0mcaKRADtNFKoaJxjvr3IgpyhhDlBrU55R88ue5rhb6oI6YPtG3w
         MTDHn4l+UlxbzM+BeVZF1ruGtyG4G8L/xg6erXFuN94QajuT2mLfsoYG1R/EYX3y+ptP
         Zg/GHOqKNTZax0go/+pmfJ1Yq4RAz8S3BZOlQtMNzUWYyytenVSvvr2JntWSu918A3ou
         1KCw==
X-Gm-Message-State: AOAM530jVLmQ5HSbMOBaqVjxaKL9CDOGfnIf9AVeFKwc+vMNlbs+HWoK
        76H3SVrZMOgVOvx4Pvb4A24=
X-Google-Smtp-Source: ABdhPJw15tAhDZ4T7gT3ayIVkuqHqqJlWYyDvjljJaWQJpFYLDbZMgZTYcpXwM5yCxkV09NCfHPK3Q==
X-Received: by 2002:adf:fd0c:: with SMTP id e12mr667290wrr.61.1610058300729;
        Thu, 07 Jan 2021 14:25:00 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id h9sm9773734wme.11.2021.01.07.14.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:25:00 -0800 (PST)
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
Subject: [PULL 24/66] target/mips: Rename helper.c as tlb_helper.c
Date:   Thu,  7 Jan 2021 23:22:11 +0100
Message-Id: <20210107222253.20382-25-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
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
index 68804b84b15..b02c0479e79 100644
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

