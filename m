Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4092D905A
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731384AbgLMUUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbgLMUUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:20:35 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C16C0613D3
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:19:55 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id g25so7884792wmh.1
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h+0f4MZSwT7Z4ULpAMMMf+Y2JWijk+gFO9yAfDJUPRo=;
        b=UJMr2i9eDj/K0MVcCJ+eHoqUUGk/nd2qt7yFEqMack+wSX2s7WSSO6FxE+tCIP/Ys7
         N1neLRDTRYdoM1prp+IqS1S/88Ms03F0CT9Z0sQCLxORgWu8ynoO/3J3Ivji5uFMuG84
         25MsLPNiUWV7VedPd4IHFWPH5y0xuG1Ftc6OXkFi25B8PBoLKTF4TCU0pUWg+8Eip5cl
         avfscgy49AaE9FsWpQB6/I/IZ8O9Eal3JQYYMEXTpOlCsmZO7RZ3xKPAbhkFQoTQvmDI
         aFgPPqnGlHqso7eYh2r5Rsc93wLo2YYc3GDhQkfmQdo8dBh2gyGN5p4jRDoqiKNFgvWr
         7WBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=h+0f4MZSwT7Z4ULpAMMMf+Y2JWijk+gFO9yAfDJUPRo=;
        b=O9Ka3B2tNVvHzgjpMCJ/b5eBRUBVh2Y5aqa+iPzzq9kIruz+MdBzbd4G683Pp8enLf
         NsnHjAUGNegjo6yb5HHTcTpbTbV47bz6hoxCE9uhdez/r6zpQRnMU//ccLlVTgmDS5XL
         MU2Hg6bcLYmf9VqqHid0fp6wzSyfIZ+kV0x4W2ZU/wyrlv/4Y9KenACQvMeXNS9v6k1Q
         hHnMcpRkn5jo859IiB52vJ/HB1lMqaKu/s62H5lhDqQW8wsGDf5hyBbR1o9w/TaZdU5y
         lQFAquIlQMWyeadrxI8+/LMEBm7rdGA9CIU5zmYpVEm9SUy7qyWq5HTyhLTjoBvzJDAM
         rs0w==
X-Gm-Message-State: AOAM533RmkZ0+mnXWPHOY8kJwRR+8wyjCVW02MsUtU1NCq6pjKbqw1Fm
        fkeKQ8VMfsbxuQOjuBRemD+NXWmW6vg=
X-Google-Smtp-Source: ABdhPJyQGcPstFoF2k+UOL35hL2hnxGP87DnUYgX7saUmt1VArW5Q/W9u0DyNBvUw9DDWFHQkeJQJQ==
X-Received: by 2002:a7b:cb84:: with SMTP id m4mr24472231wmi.157.1607890793929;
        Sun, 13 Dec 2020 12:19:53 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id b4sm27219980wrr.30.2020.12.13.12.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:19:53 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Huacai Chen <zltjiangshi@gmail.com>
Subject: [PULL 01/26] MAINTAINERS: chenhc@lemote.com -> chenhuacai@kernel.org
Date:   Sun, 13 Dec 2020 21:19:21 +0100
Message-Id: <20201213201946.236123-2-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Huacai Chen <zltjiangshi@gmail.com>

Use @kernel.org address as the main communications end point. Update the
corresponding M-entries and .mailmap (for git shortlog translation).

Signed-off-by: Huacai Chen <chenhuacai@kernel.org>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Tested-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Message-Id: <1607160121-9977-1-git-send-email-chenhuacai@kernel.org>
---
 .mailmap    | 2 ++
 MAINTAINERS | 8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/.mailmap b/.mailmap
index 663819fb017..a1bd659817d 100644
--- a/.mailmap
+++ b/.mailmap
@@ -49,6 +49,8 @@ Anthony Liguori <anthony@codemonkey.ws> Anthony Liguori <aliguori@us.ibm.com>
 Filip Bozuta <filip.bozuta@syrmia.com> <filip.bozuta@rt-rk.com.com>
 Frederic Konrad <konrad@adacore.com> <fred.konrad@greensocs.com>
 Greg Kurz <groug@kaod.org> <gkurz@linux.vnet.ibm.com>
+Huacai Chen <chenhuacai@kernel.org> <chenhc@lemote.com>
+Huacai Chen <chenhuacai@kernel.org> <chenhuacai@loongson.cn>
 James Hogan <jhogan@kernel.org> <james.hogan@imgtec.com>
 Leif Lindholm <leif@nuviainc.com> <leif.lindholm@linaro.org>
 Radoslaw Biernacki <rad@semihalf.com> <radoslaw.biernacki@linaro.org>
diff --git a/MAINTAINERS b/MAINTAINERS
index d48a4e8a8b7..d396c5943b6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -388,7 +388,7 @@ S: Maintained
 F: target/arm/kvm.c
 
 MIPS KVM CPUs
-M: Huacai Chen <chenhc@lemote.com>
+M: Huacai Chen <chenhuacai@kernel.org>
 S: Odd Fixes
 F: target/mips/kvm.c
 
@@ -1149,7 +1149,7 @@ F: hw/mips/mipssim.c
 F: hw/net/mipsnet.c
 
 Fuloong 2E
-M: Huacai Chen <chenhc@lemote.com>
+M: Huacai Chen <chenhuacai@kernel.org>
 M: Philippe Mathieu-Daudé <f4bug@amsat.org>
 R: Jiaxun Yang <jiaxun.yang@flygoat.com>
 S: Odd Fixes
@@ -1159,7 +1159,7 @@ F: hw/pci-host/bonito.c
 F: include/hw/isa/vt82c686.h
 
 Loongson-3 virtual platforms
-M: Huacai Chen <chenhc@lemote.com>
+M: Huacai Chen <chenhuacai@kernel.org>
 R: Jiaxun Yang <jiaxun.yang@flygoat.com>
 S: Maintained
 F: hw/intc/loongson_liointc.c
@@ -2861,7 +2861,7 @@ F: disas/i386.c
 MIPS TCG target
 M: Philippe Mathieu-Daudé <f4bug@amsat.org>
 R: Aurelien Jarno <aurelien@aurel32.net>
-R: Huacai Chen <chenhc@lemote.com>
+R: Huacai Chen <chenhuacai@kernel.org>
 R: Jiaxun Yang <jiaxun.yang@flygoat.com>
 R: Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>
 S: Odd Fixes
-- 
2.26.2

