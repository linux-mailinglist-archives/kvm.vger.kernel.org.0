Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B271CA3D7
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 08:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgEHG2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 02:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726009AbgEHG2P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 02:28:15 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59B6C05BD43
        for <kvm@vger.kernel.org>; Thu,  7 May 2020 23:28:14 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u16so9337776wmc.5
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 23:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JKemrS/nzNf0fJmxK8GiyXOkbcPtsp55SlKT7ZKdxkk=;
        b=aVK1uqUlziSJOYj9tAQs1q/ny43Tj8h/SlRP9iNrV+9Hh0zc4XZVXZ1piMNHxdruUs
         wUt4k/tez67ABbSxmHNMqUWoVH/3HLUHi1CkYnzKTUmbAcUxfTxHb+8nciaf6qCtJ9NJ
         HE17gb87QQudszJS7PCtm7H60muaBB5KgsaHfILi6ywL5k9KyngTK68P+R+4H7FXxaGJ
         0TzyNGQNinC7AHP3U+5lj5fHhSccZAYX5z6p6pOqkftMS5Ud4LINenOoY3YzB4FBzUw9
         MJIeN4/LV3c/50TOBbB0CQRBiYokz/XKaykr2ySDpV5Lxyao8b9wLHJPbWQ53QIeTutz
         orjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JKemrS/nzNf0fJmxK8GiyXOkbcPtsp55SlKT7ZKdxkk=;
        b=C4vwS5UM3FVGWuz89e2PqFCMIREMC5+F0+nN0PBt+8HFoyZRsEdq0wKtd/Lyail/aS
         2jW5F7mw2tlMA7bLeSeEGickqkZQacM2EKvwBNogLPYzk/zMj9B5ZB+Y1ya9dcUAcLmU
         iIb0nIHXF6iIqeI11XnFpQVbrzMnNrCDZgC6CK/0PBTsq2ERHyJ5cKQdDdC3L69eM1y4
         X7cIm5mK28s7qOzjOYDiaW425fC0Ux505xs9+V+8UwawPLDlopds7cRwuXxeXW9JGUiA
         FEsdxV8t3Wp4Z3efSywl+txBs8bMi70Kibz5ypWvsu468z16AWGl1wXlLFEKT2Dfnemv
         9BzQ==
X-Gm-Message-State: AGi0PuZ9rShvgQYWhMTzZSgTUkgf4VZ338oAbWU86Ea3D3Lc2tspLxqj
        +pAs55/siSVsyrDymvd5h3GwPz1VRpg=
X-Google-Smtp-Source: APiQypIYA9aYUj7KHJpu9f3gXejqXxO3Ocld5Ir0ds4cw/hdkLJ11cPkg4YHvVGykOTW0cOV69M+OQ==
X-Received: by 2002:a1c:7513:: with SMTP id o19mr11790871wmc.9.1588919291092;
        Thu, 07 May 2020 23:28:11 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id r11sm99873wrv.14.2020.05.07.23.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 23:28:10 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: x86: Move definition of __ex to kvm_host.h
Date:   Fri,  8 May 2020 08:27:53 +0200
Message-Id: <20200508062753.10889-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the definition of __ex to a common include to be
shared between VMX and SVM.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/svm/svm.c          | 2 --
 arch/x86/kvm/vmx/ops.h          | 2 --
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 35a915787559..4df0c07b0a62 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1620,6 +1620,8 @@ asmlinkage void kvm_spurious_fault(void);
 	"668: \n\t"							\
 	_ASM_EXTABLE(666b, 667b)
 
+#define __ex(x) __kvm_handle_fault_on_reboot(x)
+
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 57fdd752d2bb..9ea0a69d7fee 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -42,8 +42,6 @@
 
 #include "svm.h"
 
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
-
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/ops.h
index 5f1ac002b4b6..3cec799837e8 100644
--- a/arch/x86/kvm/vmx/ops.h
+++ b/arch/x86/kvm/vmx/ops.h
@@ -10,8 +10,6 @@
 #include "evmcs.h"
 #include "vmcs.h"
 
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
-
 asmlinkage void vmread_error(unsigned long field, bool fault);
 __attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
 							 bool fault);
-- 
2.25.4

