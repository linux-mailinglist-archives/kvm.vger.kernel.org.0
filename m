Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE382EE867
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbhAGWY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbhAGWY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:24:28 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2B2C0612FA
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:23:23 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id a12so7096612wrv.8
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nLKJKOTk7XMRzOC+u/WBz+w7tk2M4QOBGegMa8D7C0U=;
        b=ZVWElPmEws5/yKsdpE5XMJl4WjoNRbQ+/ZyhFkxmf4fjlz5POTK1+3LMkl8c/ecyE7
         MdhGb4s2qqI//M0fkoxntqZHIe0iRW1sKTXzFrTqp7WJjBsc43MYhJBrRTW/M61Sn3K+
         3xW1kXYxVZIWDREcLvushMul2P96NUVfd+3CIQfapp87NwraTPPJPHqHr6raDpYDeqd9
         A4y6tHZ0b5gUtPi/46ek+3p15k+4IUfFgkLba+05R3duqnVlOYrCHDCOdD6xzZ9R9f2c
         9+vS1x7fGjNejncwLS1j8h4yGvhC073mEcprLuJpkT+Pjv7WhUqzrnukurFmEHxdtvwT
         lSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=nLKJKOTk7XMRzOC+u/WBz+w7tk2M4QOBGegMa8D7C0U=;
        b=I4c7vW+CH4gEEqI7/moFlgcb/cIEJ/cqgF8DDFoxSwPCqTU+TJ1UQAnqHmduWwfDJe
         Ts2sHel4/hLJldL6BbAD+i2JZh1eblcpyO0WKIrmvU9q0xqJHiAU9jtFsb2yy/YXtQHt
         vp5xcZ2W08xuOLpnnvSeL9fkQr4TADDGCo8sSyBa9TNTIPxf75NAtqgo401NHnzoQ1Qb
         3DXbIFGuMNqi7otZtzOUC3DXaxY5ocb1iM+nMzVnwiaksafUomc0Z4CZAc4zoiZvhRtz
         nsdurfEOdflgz4YinVkq22pa0cAm230zCaJgFEHxnGmGFNlRSAU41UGib0np/xEJmh1R
         QDQg==
X-Gm-Message-State: AOAM532gvlwkrlObuGAG+K332/gpMDIOcjdYa8OmiJdnH/a1E+Y8AU2x
        EJAQR3dObmvQj9MQzQkDME8=
X-Google-Smtp-Source: ABdhPJyqhYYYdd8jES83UCqVJhtWLKUdEOFwqPCAdCeOqoWuJUN6I5HlIbNUDX4nbg0EhKBTsUX+nQ==
X-Received: by 2002:a05:6000:cc:: with SMTP id q12mr662468wrx.335.1610058202257;
        Thu, 07 Jan 2021 14:23:22 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id e15sm10530098wrx.86.2021.01.07.14.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:23:21 -0800 (PST)
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
Subject: [PULL 05/66] target/mips/mips-defs: Reorder CPU_MIPS5 definition
Date:   Thu,  7 Jan 2021 23:21:52 +0100
Message-Id: <20210107222253.20382-6-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move CPU_MIPS5 after CPU_MIPS4 :)

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Message-Id: <20210104221154.3127610-3-f4bug@amsat.org>
---
 target/mips/mips-defs.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index 555e165fb01..48544ba73b4 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -65,13 +65,12 @@
 #define CPU_MIPS2       (CPU_MIPS1 | ISA_MIPS2)
 #define CPU_MIPS3       (CPU_MIPS2 | ISA_MIPS3)
 #define CPU_MIPS4       (CPU_MIPS3 | ISA_MIPS4)
+#define CPU_MIPS5       (CPU_MIPS4 | ISA_MIPS5)
 #define CPU_VR54XX      (CPU_MIPS4 | INSN_VR54XX)
 #define CPU_R5900       (CPU_MIPS3 | INSN_R5900)
 #define CPU_LOONGSON2E  (CPU_MIPS3 | INSN_LOONGSON2E)
 #define CPU_LOONGSON2F  (CPU_MIPS3 | INSN_LOONGSON2F | ASE_LMMI)
 
-#define CPU_MIPS5       (CPU_MIPS4 | ISA_MIPS5)
-
 /* MIPS Technologies "Release 1" */
 #define CPU_MIPS32      (CPU_MIPS2 | ISA_MIPS32)
 #define CPU_MIPS64      (CPU_MIPS5 | CPU_MIPS32 | ISA_MIPS64)
-- 
2.26.2

