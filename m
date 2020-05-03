Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903061C2B20
	for <lists+kvm@lfdr.de>; Sun,  3 May 2020 12:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgECKIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 06:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727892AbgECKIb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 3 May 2020 06:08:31 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962CCC061A0C;
        Sun,  3 May 2020 03:08:31 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 145so4033466pfw.13;
        Sun, 03 May 2020 03:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Apq9sucfBmwOGXvj0V67gdzCLVL91nlJK5leKBoTGWw=;
        b=Xks75GZfQ0X6QBtjXLWiC70RvNKvpA7JjnKscIdVbrnnx6Yjrs4aV+D1ELgi9JfsIh
         M4nLVDw9slUZGMEL8mA9ym2MLviKXQVGK5xbme2G1ke+DVNspIX5ZCAX8bCb/dnPJpRO
         4ZLmcRjgJITfgV4d0XXPSFtLDrztQ8f8R/i9Rmgk8eVhcv9kMbc0FSG440Zqlw2WD2rn
         HKYqgfKLsLTotPkPbJJDsCRUOE6kqpUflXNH3SSWtJXoGw0A0j461pWMgBRIu+UKNm1P
         In0k8V8jvXwvnKMjo78NyStMzPZ6N+ERx/qKnGJx7xtpZn1jmS35pGAvvhiFoZWzpJXI
         oe2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=Apq9sucfBmwOGXvj0V67gdzCLVL91nlJK5leKBoTGWw=;
        b=T0z22k6qcFrN+1vbgqlVY5kQlod8AMPpt7zsWrNqcQdC7v3OMowvKGMHzyBKkbwcSb
         RwV3eaeOUC4stsesE1B+wOIhewurKXHSU/1pSH6oilYqFrOvd/xnd+hrvBQ0VX47qCnn
         +zOSxvMIbS4Hm+HWFEky1WPx2Tn3nqrAxwCmLM07q8AKzLwnOXSQLG/QRzJ56f83BOai
         Qqkkbzzg6/LyofNImlUj/B1z8UIB/4xCMOBLRgas807lo9RJbiu8WUGVPM4iqz/v/St4
         fDNh3yVZYV9zX+yKlaSqHkL84qFZA5nnhp/xTK4K93ANE1YlN7qAF71QCi0RC5dCR1re
         mhXw==
X-Gm-Message-State: AGi0PuZ7mSi/l83XvHccQkOfa/5n15z1f3lX2XcsnIgkHjOi5BhphsoU
        VXeqHPN2GFOmLjoZtEQD7hQ=
X-Google-Smtp-Source: APiQypI2CbwfAI9/oWf5WDwYq3eUe5P+QBD7gAlrAddN5Qjv2hJyYr/2z5tfeFRn4cKRK5JWcYOEbg==
X-Received: by 2002:a65:6417:: with SMTP id a23mr13042369pgv.204.1588500511198;
        Sun, 03 May 2020 03:08:31 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id r26sm6329902pfq.75.2020.05.03.03.08.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 May 2020 03:08:30 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V3 03/14] KVM: MIPS: Increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16
Date:   Sun,  3 May 2020 18:05:56 +0800
Message-Id: <1588500367-1056-4-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3 based machines can have as many as 16 CPUs, and so does
memory slots, so increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/kvm_host.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index caa2b936..a7758c0 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -78,8 +78,8 @@
 #define KVM_REG_MIPS_CP0_KSCRATCH6	MIPS_CP0_64(31, 7)
 
 
-#define KVM_MAX_VCPUS		8
-#define KVM_USER_MEM_SLOTS	8
+#define KVM_MAX_VCPUS		16
+#define KVM_USER_MEM_SLOTS	16
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS	0
 
-- 
2.7.0

