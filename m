Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420D9342F21
	for <lists+kvm@lfdr.de>; Sat, 20 Mar 2021 20:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhCTTG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Mar 2021 15:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhCTTGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Mar 2021 15:06:47 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A47C061574;
        Sat, 20 Mar 2021 12:06:47 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id q26so1262698qkm.6;
        Sat, 20 Mar 2021 12:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Od/6JZXn0GmhjHJDtQp66sidKREmIC6tXOpY6ygJe74=;
        b=AjDzhPEtepioEj3ezrB3ze3Ur7kPfJyHbVQpihrSrUiHXzxVAws5EAVNuHsGAIwtlB
         w/fuJV/zIyifPNdd78gp1A11yANgMdvUJOpcmkdDZPhEaO39fJ5EcGFVVb6j/nrCrVEY
         HKsyhmnunn3om4AhCJ4grPsPO0Yx5nSIZQ4LjGCryK3d5F2McxA789oGDpRkR6gnl2bS
         iqEj7gLUIG/kCc9agRRd72WXQ6lEWCvFP7w4CeguBWpaHVZ1l7NYeXelZl2+YsMDq+rP
         LbqHJwEy47VMoVIWJN+QqZvLw6KCrX5h9ny1WXC3KXqxK32rqebUGyXtulIyePJE7gcC
         13GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Od/6JZXn0GmhjHJDtQp66sidKREmIC6tXOpY6ygJe74=;
        b=S7tznipHxlLhmNZFsAT4/z51A7NbpX+8BLavuBIUvINa56Ni9Gh3LYAz9YWzWdOu0s
         AnSbrxkbdeksZX8024Qf2W1fGsi4gGngzssXSAsSGWryqsChfeixUkFlvXr5C34PAxKF
         9k6B4PW6Hhj6KDr1LBwl6tukywg00yMDtrJGX2ZOkxMJSiv4/wEkZkJGdAANwD5fg1uH
         Dxtcb3+bVj/bnSIPBJUe41WqdHcMo1y3I59VP+narWG1aATxWTYBcHXH1PezPGWhQZ4x
         OA0Eir7Rb/ekNHKCB7wxZ8w212oreUncV8flnbnV2gca3vxgP7eR2ut8uiBAG0C6ed+k
         yFoQ==
X-Gm-Message-State: AOAM531Jqew88YwLtZm+Bo6Ux2APca0QbjRPjaE3c03KmOuI9nCnUAnG
        Vs6+vxRGrKK2HdW0UyxYdS8=
X-Google-Smtp-Source: ABdhPJxNe4d8Bt/+gXuULDhEE7Du6W4Z3WuAR+wHH/y/7VjksEgQU7VYJ9taztcqsXGRsrZerle4tw==
X-Received: by 2002:a37:e16:: with SMTP id 22mr4045380qko.145.1616267206329;
        Sat, 20 Mar 2021 12:06:46 -0700 (PDT)
Received: from localhost.localdomain ([138.199.13.205])
        by smtp.gmail.com with ESMTPSA id o7sm7555054qkb.104.2021.03.20.12.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 12:06:45 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] KVM: x86: A typo fix
Date:   Sun, 21 Mar 2021 00:34:25 +0530
Message-Id: <20210320190425.18743-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


s/resued/resumed/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9bc091ecaaeb..eae82551acb1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1470,7 +1470,7 @@ extern u64 kvm_mce_cap_supported;
 /*
  * EMULTYPE_NO_DECODE - Set when re-emulating an instruction (after completing
  *			userspace I/O) to indicate that the emulation context
- *			should be resued as is, i.e. skip initialization of
+ *			should be resumed as is, i.e. skip initialization of
  *			emulation context, instruction fetch and decode.
  *
  * EMULTYPE_TRAP_UD - Set when emulating an intercepted #UD from hardware.
--
2.26.2

