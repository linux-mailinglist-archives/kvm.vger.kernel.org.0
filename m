Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D584F1DF5CE
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 09:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387718AbgEWH6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 03:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387500AbgEWH6Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 03:58:16 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0908C061A0E;
        Sat, 23 May 2020 00:58:15 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ci21so6000373pjb.3;
        Sat, 23 May 2020 00:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p7gcKiXZHRnvuvHPL32ueIkTT7PTkn2ALsQ2li3G5xk=;
        b=hzg7SNl5FoYMgUsKMg+R7hNoZW8b2CLdKSsVf3b3mKRkOkC03QEg1+yUmR9MixkLIO
         1xKZf/QCfKriogBtI2qnlba1n+1iWjbxm3ewGIC8QfUNgwF+NdL+PdrzRDHQAxAHKkOR
         GWLlL70pUPDQUgLl4jNAKqEXEVLNEajwo/ImdkxwS2ywagHoareDM65L1+K/LfT5nAvi
         g3gFC3vitMCeNOBQuU8CIS1DXNx98FrtBvML93M41rhj4DNttB9O24jmZqCKpIynAW9j
         q+AOMYPEb795LYgACDlF4tu6IYUUcCAecGAytpHwpDmUQtw+lAHKlfJ+jYtC3dybxMfs
         GxLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=p7gcKiXZHRnvuvHPL32ueIkTT7PTkn2ALsQ2li3G5xk=;
        b=m1kFujfSP2bLs5nGMma1wpWAisSiWyHjk3jygq1Mc0Ht8g2YFkRfbZkczoT+sZqvoa
         vN5Ikk15YIE96Myk3nywstOC6SsPRG+LkZ4UBsO6AS6yKUrvgHC9A2rux6Ss9az3YDXD
         f9EZrmUjhRCXnnn99Zd+M+aNGEhsoyZrdmZo8RW5sjo6Du9IUNh0Q4ICUxF58uxbNW7c
         rEUadZDNuuMiE5z/M7nYO7Nm/8Ih2JOjkzb1+UovxnI0A79avrqhSgIkQ5s1zCFZMVof
         /tcY0SIiCGYUmo18PaSbAVp5JhqrRxXPvUgAk2ohOh9NSLZ5iiAQi864g9UNWsq15Uvu
         qZEQ==
X-Gm-Message-State: AOAM531WJgPA5Lk7GivdESZpTJMyKsWzkOjmy80yDcOg3jocIoNDDyjv
        Xjpoic5uJDJKnyTWCfC82kn/yuBFWEF8UQ==
X-Google-Smtp-Source: ABdhPJyfCLBxszkCtZF8JPaFYDCw3lQUk3DY0M6abKLrgn2fFXGuOpmTpZKTlSV7S9yfYHBzn2ebJg==
X-Received: by 2002:a17:902:bd07:: with SMTP id p7mr17815395pls.293.1590220695550;
        Sat, 23 May 2020 00:58:15 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id w7sm678491pfu.117.2020.05.23.00.58.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 May 2020 00:58:14 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V7 03/15] KVM: MIPS: Increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16
Date:   Sat, 23 May 2020 15:56:30 +0800
Message-Id: <1590220602-3547-4-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
References: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3 based machines can have as many as 16 CPUs, and so does
memory slots, so increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16.

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
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

