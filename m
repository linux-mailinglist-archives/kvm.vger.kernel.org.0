Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFEF2EE85D
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbhAGWX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbhAGWX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:23:58 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33365C0612F9
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:23:18 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id e25so6851936wme.0
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i4p93KWwozcpUdxQORlradD/IWu48glCvPCZu/J+OhM=;
        b=Czkxpi82pJCD7JSf0mA7kHhcxneqK0d6Fsds+0JbSzuPtZWV1yh1M5oXFGZ+w0JNuW
         cyc5o4bORJxj++VlibljEoacu8ytM3nu/1NQbW3IgS/bOzz1y9DfQt+sKqMpCMHFyH7R
         L9Yw4OgAR6qcwJ82fnwL7IIdbY8GsFKenrAsXAREMdk5h1j94jq1mNQbh/U8E/o5uYKK
         wjx9K4+FV2DA7gTfJD1gevkY8UEbaQdtJ7hR7mAwRcis19ywwvO2BOHPJJdYa/gtmkom
         gCe6QknW3HDOAqJmSv7I6pxVUett3/FbWSncVR8NTYiJW6QHnM0MEPER2H1PsEUn30Vz
         vHsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=i4p93KWwozcpUdxQORlradD/IWu48glCvPCZu/J+OhM=;
        b=HqeCq+d2Ms4DAwQ5ALsSLs6SWXtsDHV+ga7NQuG6zptUUPlNeyRu2BYGd7d2g+U7FQ
         7tzMe1CLblH4RVcSH0+Z8iKPw/Ac303R5BTbLTOYjzS+/58fmXQSqYfcv/7v7mqW+Oab
         Swv7Zb7JvQjMwdZ7JlhrRtQ/zgr7PCywCA2n5l36USGUk7w97p5R4r74ii+BnGPinK6T
         b+TohJ3a4dW4xl+KyfidPpkaJB6cmS2fZ4SvXLZFQaRKv1A09f5nmmMP0bat/GSO0ppD
         SnMlh4CnJIx3ql3KrHY0qbVkz1eTUwL9j5Di3O/QSuyBu48qbpo9bKo088CiNaoEM2Cr
         ChYQ==
X-Gm-Message-State: AOAM533Y5U/5fjQpDkNjKnHcmzCsgTycIUjhsbTvEN9K6C88P78momeG
        UbmgzH6TpBs4D/ckHlZGmVg=
X-Google-Smtp-Source: ABdhPJw42/Tbgd5nDkMN32lGkO4V59KXfV71HMhGiFKrMKuVn2Z9xZTeKIOwm/xUy/9bCNTfy7TeRQ==
X-Received: by 2002:a1c:234d:: with SMTP id j74mr532053wmj.18.1610058196986;
        Thu, 07 Jan 2021 14:23:16 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id y7sm9861567wmb.37.2021.01.07.14.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:23:15 -0800 (PST)
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
Subject: [PULL 04/66] target/mips/mips-defs: Remove USE_HOST_FLOAT_REGS comment
Date:   Thu,  7 Jan 2021 23:21:51 +0100
Message-Id: <20210107222253.20382-5-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove a comment added 12 years ago but never used (commit
b6d96beda3a: "Use temporary registers for the MIPS FPU emulation").

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20210104221154.3127610-2-f4bug@amsat.org>
---
 target/mips/mips-defs.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index ed6a7a9e545..555e165fb01 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -1,12 +1,6 @@
 #ifndef QEMU_MIPS_DEFS_H
 #define QEMU_MIPS_DEFS_H
 
-/*
- * If we want to use host float regs...
- *
- * #define USE_HOST_FLOAT_REGS
- */
-
 /* Real pages are variable size... */
 #define MIPS_TLB_MAX 128
 
-- 
2.26.2

