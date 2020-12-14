Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5333B2D9F52
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408906AbgLNSit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408895AbgLNSio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 13:38:44 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9D5C0617A6
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:03 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id x22so14681027wmc.5
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DvL7rsuXwOy7A4uG7jIuuMdjlMIgZJtQ8Sw9rQv0vgk=;
        b=kXAzLtsWvoRZNkxK3QfzhePj2xCpEwPeaCxWn+hS8EOAxYHORP2YvWwjfrJVnVvPsE
         8Tlkx8zC5Q9G1DJ2ykbNA2MO3XK+2vihDVbBhyiamt12b0N+9sdBXuXFxr1EzW6HvxZM
         zL9L2cbM+QEvORrXsqF0pL5zzKDY5ACFV+L9dgpApMdTneuUglmnQA5tp0DE9xmhFUwg
         thbUNg+kismdH916KVP0g1X+s80HA/3zqzsINrVStNv/eNpf5KP4iimlNyn0ztxLfinf
         SNuSU7BrO+q17UUQv1Inb6nDwbXmE7dcF81tJeJgDX+unA0FPWD8yW1JtK2NnISt/MKg
         bJeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=DvL7rsuXwOy7A4uG7jIuuMdjlMIgZJtQ8Sw9rQv0vgk=;
        b=hQLUMxjxXl4ZhExcEaw1L314IIdSgEj5OhDzxYsoXvczFBv8E7D5QFJkzXKMe3Ck5C
         9jJGKOsCYEIlkanOddfexfSC/QYIhAm9c9TOr8O9/E8sEyBnvO4w5nLBxI464Ow6Z+a4
         BYygi23M/p6QdUq2Yn0g+i9nDFcUkLb43cwmeMWzpyybdgSwQl8F48JOX2nmPAuoMdMt
         GQm20dHYep2DZFED8TpxQwhw5E7q+R7xR6UDyuClDxCIeAczBxIuG+d9yncxrnHRFTXL
         x6R3OwgluQ8j3Czc9R5CTYkedFlgkfFzKAMFGFHzizZAWPt7TVtRsqvwCX3g2JH4Feug
         RmzQ==
X-Gm-Message-State: AOAM532kjt38AWr3C4ESdJOwlcJTENKNspSuqz0+Rh8ouORqM9d9jS7P
        0ADhS8sYQo+LAAiYNdrKYgeh7h28SLs=
X-Google-Smtp-Source: ABdhPJx3txinzJGaex7i/x3SQ8SYsfnEhn9muwCasq9NZdu9YYmx4x6odxQdU+R6stgDbXJrnCktAg==
X-Received: by 2002:a1c:4d0a:: with SMTP id o10mr30042071wmh.185.1607971082664;
        Mon, 14 Dec 2020 10:38:02 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id n14sm32217432wmi.1.2020.12.14.10.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 10:38:02 -0800 (PST)
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
Subject: [PATCH v2 04/16] target/mips: Remove consecutive CONFIG_USER_ONLY ifdefs
Date:   Mon, 14 Dec 2020 19:37:27 +0100
Message-Id: <20201214183739.500368-5-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214183739.500368-1-f4bug@amsat.org>
References: <20201214183739.500368-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/helper.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/target/mips/helper.c b/target/mips/helper.c
index cdd7704789d..0692e232f0a 100644
--- a/target/mips/helper.c
+++ b/target/mips/helper.c
@@ -552,9 +552,7 @@ hwaddr mips_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
     }
     return phys_addr;
 }
-#endif /* !CONFIG_USER_ONLY */
 
-#if !defined(CONFIG_USER_ONLY)
 #if !defined(TARGET_MIPS64)
 
 /*
-- 
2.26.2

