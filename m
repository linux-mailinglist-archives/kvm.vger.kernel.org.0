Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954B42EE85C
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbhAGWXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbhAGWXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:23:53 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6582C0612F8
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:23:12 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 3so6816973wmg.4
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qWarhXBRCCKl1ib6yNLPWYWSvngUVzs/930y/X1kaDM=;
        b=OuM8zCGuNKENPmA4AeOPBdxZtVqMeY6L/Qv81iOjsTaLsVhNTiF50IuicWsO8xsyU6
         o0YnigsuBrsraQeRizxBsomHfdxZIkbwBoywYTxdXLmqXJ5LlsBkfCJAzthQm4hhH681
         pMnR00hnz1Vk57j5SO61N7SoMInJ12z1LYEw1qAKQLvAOLeh+6B8UifHppiM09sgyr+6
         IouSehCrBqmUXzGLX8iNu1dqgmKYWfxhb6FDOLK63NnBD25BeS8taeITL6RNsNl6kU+J
         nteWfI+rNhmXMDJUF+V7/x92LZyffEXHgdvcmn9w3dvTNFRrcOXzq5uNVBAAGeaoDmon
         6eTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=qWarhXBRCCKl1ib6yNLPWYWSvngUVzs/930y/X1kaDM=;
        b=iWCNhY4MpeWFRR9GCTqr1gyD8IBX7UPYpyjUPkLT1EnIyWUOdLhIaX1+1/4h4y/ZRj
         Af/cn6vXVRC8w4v8BOnxA0lfs/bAUXEgRcWfUikkd2rHV1oaRYVq8V17ho3cIvn3R1gc
         Q6G79dtSDS7hVy/fljktO6FLsyNKxf4IjIlCqglpyqIu2uv9l3cgN1548it8EvPOdUz/
         gka5yWSv6TWtRxlSDZobfTLIhpdGEE/vxKjkIt97lwO3ydTG7mv43Wzmyr37bfS5X9xb
         SCaU9sEj8ZewRa2ciUEqxXtl53NXcRcsjA+9uMixLH+nh0RUu+pyUJAbge+Siytsvdwu
         GgBw==
X-Gm-Message-State: AOAM532UfsuzKi0EI/aPmnDJ1LtNj6lwnEfA/Qinho3hWFmWXoQwf8UN
        KC7ioEyge5V45HUHk0L9noM=
X-Google-Smtp-Source: ABdhPJwXEJY641mvWZFlqGlSPn78NAiXwQ5lcO0KUEHFx1ZWxt8dNXQxbxwgVbBtDlkQiI8jfm1hCA==
X-Received: by 2002:a1c:6283:: with SMTP id w125mr480401wmb.155.1610058191505;
        Thu, 07 Jan 2021 14:23:11 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id q15sm9893608wrw.75.2021.01.07.14.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:23:10 -0800 (PST)
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
        Paul Burton <paulburton@kernel.org>
Subject: [PULL 03/66] target/mips/addr: Add translation helpers for KSEG1
Date:   Thu,  7 Jan 2021 23:21:50 +0100
Message-Id: <20210107222253.20382-4-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

It's useful for bootloader to do I/O operations.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Tested-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Huacai Chen <chenhuacai@kernel.org>
Message-Id: <20201215064507.30148-3-jiaxun.yang@flygoat.com>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/cpu.h  |  2 ++
 target/mips/addr.c | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index 0086f95ea2a..0c2d397e4a9 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -1312,6 +1312,8 @@ uint64_t cpu_mips_kseg0_to_phys(void *opaque, uint64_t addr);
 uint64_t cpu_mips_phys_to_kseg0(void *opaque, uint64_t addr);
 
 uint64_t cpu_mips_kvm_um_phys_to_kseg0(void *opaque, uint64_t addr);
+uint64_t cpu_mips_kseg1_to_phys(void *opaque, uint64_t addr);
+uint64_t cpu_mips_phys_to_kseg1(void *opaque, uint64_t addr);
 bool mips_um_ksegs_enabled(void);
 void mips_um_ksegs_enable(void);
 
diff --git a/target/mips/addr.c b/target/mips/addr.c
index 27a6036c451..86f1c129c9f 100644
--- a/target/mips/addr.c
+++ b/target/mips/addr.c
@@ -40,6 +40,16 @@ uint64_t cpu_mips_kvm_um_phys_to_kseg0(void *opaque, uint64_t addr)
     return addr | 0x40000000ll;
 }
 
+uint64_t cpu_mips_kseg1_to_phys(void *opaque, uint64_t addr)
+{
+    return addr & 0x1fffffffll;
+}
+
+uint64_t cpu_mips_phys_to_kseg1(void *opaque, uint64_t addr)
+{
+    return (addr & 0x1fffffffll) | 0xffffffffa0000000ll;
+}
+
 bool mips_um_ksegs_enabled(void)
 {
     return mips_um_ksegs;
-- 
2.26.2

