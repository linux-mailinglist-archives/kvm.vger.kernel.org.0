Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DEA1BAFC1
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 22:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgD0Uut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 16:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726233AbgD0Uut (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 16:50:49 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0CBC0610D5
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 13:50:47 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id x4so418252wmj.1
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 13:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d5HJp8ytw+WF6w8CWQAXWegbZHxFLiJtIvJYhuwFUs4=;
        b=QpSYbnupClteTVnHLdPep8uPFZJf8YplaUEZETktCDnwp2S38FqYI6/Vy3eWtc7mnU
         pXxHCxTAGYX3SEuqj863Ga8+BYvUYqYOmrPOypKxy6VWhYckl3LHYRaEpaovBkfaT97G
         JcWyJ9PrU1v4RdK0OvkWeqjftmFRfwqny+t7KwBst2WSE+5PlNDAyqtzXibYITPs/YEm
         6KioDDUTbSynDTSeTF4TBhFqR0HvGRqLdSxFlKEw7jH7s2Ekwj1hjm2uEY/rsPSA4gO1
         2tLkfjyI32MCC6VlMDwE7j2udDwXEt8ZoJj6EqVaWjaSmT41+MYFNngvqFo9DHc8Lug0
         bSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d5HJp8ytw+WF6w8CWQAXWegbZHxFLiJtIvJYhuwFUs4=;
        b=gGv/t7fL+zCgGb95+yYi28WTMYzYNCVxn70DBHddo8hphW3n9djIa0bCxB41Rvpad7
         XuaqghLX8Aa5Vvv+QSql6ublx3JqyL/LVMJPlMJxqtJcjum4NRGYT4I7d+xapq3JPbjP
         DwazOvnSRKnrfRx1vQGlO64s5jRFSDIVjk0pCYQaJOsk/9NcXiCOYmpfAM3uzAFk98Lu
         qf//oKqujulULzvwuBn6Ys0HpM5UqMooyPoFq7KVtsmnQq1zYU+x4k6zOsBe8p2TAAhE
         RSK926heE5SAALYo8xAKagTJWsk+IS89q0k5f67UJ4mSJJsUP8rWlxWh31FDKTwHCNXP
         Ut6Q==
X-Gm-Message-State: AGi0PuYjy4m6v8n5KUK+E08flMQzYvXbaTuQGEERkbZoOCF4HPJmc+CX
        Jjw1Hi4MvmbxDEt6zZQd0kBuyiSdFsM=
X-Google-Smtp-Source: APiQypJItIIHmzqXkzdy9UxZyBMZJHkiZTsHxHw3rxbbj0GVqY/LeH41O0snXpDDJqCQRA02VT8dFA==
X-Received: by 2002:a7b:c5d4:: with SMTP id n20mr628912wmk.92.1588020646214;
        Mon, 27 Apr 2020 13:50:46 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id w10sm23515491wrg.52.2020.04.27.13.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 13:50:45 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2] KVM: VMX: Remove unneeded __ASM_SIZE usage with POP instruction
Date:   Mon, 27 Apr 2020 22:50:35 +0200
Message-Id: <20200427205035.1594232-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

POP [mem] defaults to the word size, and the only legal non-default
size is 16 bits, e.g. a 32-bit POP will #UD in 64-bit mode and vice
versa, no need to use __ASM_SIZE macro to force operating mode.

Changes since v1:
- Fix commit message.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/vmenter.S | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 87f3f24fef37..94b8794bdd2a 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -163,13 +163,13 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	mov WORD_SIZE(%_ASM_SP), %_ASM_AX
 
 	/* Save all guest registers, including RAX from the stack */
-	__ASM_SIZE(pop) VCPU_RAX(%_ASM_AX)
-	mov %_ASM_CX,   VCPU_RCX(%_ASM_AX)
-	mov %_ASM_DX,   VCPU_RDX(%_ASM_AX)
-	mov %_ASM_BX,   VCPU_RBX(%_ASM_AX)
-	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
-	mov %_ASM_SI,   VCPU_RSI(%_ASM_AX)
-	mov %_ASM_DI,   VCPU_RDI(%_ASM_AX)
+	pop           VCPU_RAX(%_ASM_AX)
+	mov %_ASM_CX, VCPU_RCX(%_ASM_AX)
+	mov %_ASM_DX, VCPU_RDX(%_ASM_AX)
+	mov %_ASM_BX, VCPU_RBX(%_ASM_AX)
+	mov %_ASM_BP, VCPU_RBP(%_ASM_AX)
+	mov %_ASM_SI, VCPU_RSI(%_ASM_AX)
+	mov %_ASM_DI, VCPU_RDI(%_ASM_AX)
 #ifdef CONFIG_X86_64
 	mov %r8,  VCPU_R8 (%_ASM_AX)
 	mov %r9,  VCPU_R9 (%_ASM_AX)
-- 
2.25.4

