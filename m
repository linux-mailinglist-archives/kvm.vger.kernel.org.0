Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1211CA979
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 13:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgEHLXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 07:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726618AbgEHLXY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 07:23:24 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AFCC05BD43
        for <kvm@vger.kernel.org>; Fri,  8 May 2020 04:23:24 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id y3so1441111wrt.1
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 04:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bWU6zlynIfW1qhiMuwM2Wph5uDsDlfbABaGeEVTQWfU=;
        b=fMYmUryVpDa9Czd920mdsI5wH3fvqg0UXkKauH8ZH4w3Js888m/+EEIE/0BqRTHltP
         6mb3nRbgJoBru8144W7Fs0SLiQT6GfQRrFN07SaUIXow5H25SoAxv0+rpYKaSBFYqXsU
         vszxFX88V+ilRSx6YHPBbc4HeoP24imuslBw78OHNYXD8e7Nwen5SWuHg5c+0F4sHYt2
         RdngWhXtDzpPhNryCowJZyV3K32BWlnaP87Q6HTxBsqs2g6VuNZnvb+33CtXwXHYsY3T
         wxxf3YBselWW3FWZtOc3YyQe7jAWTh9EuVKj2RwlYhDjozC0pXYF6EZNw0UXUdYbH2EN
         r/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bWU6zlynIfW1qhiMuwM2Wph5uDsDlfbABaGeEVTQWfU=;
        b=YXoUOEMrkxBfNjYnIruj/WGyAsweUm1dcb2liwSmGdWGIV/iy7Dn76UElJ0jZS86pU
         SdSimT7TyJIbSzUjfjfNqkh8Pf5uClEUAv9h4GIL0BtZThQex6m6ZhacwdiCCHYzTiuc
         yclQNhiWJl8f1Rfur2A1kRQC+fqBio/VXT1GWUIiW5PKK7fAy70efEW8X+UwT6QEvV3b
         yPPlx0gbZb3Y+WFiW7i504CCVuhmlaVmKLh8Aw5HOso5QHU0hX0WfMtQKEmTT/cCUEvn
         AULF5QzSICStjguq1M+vAlcDWMoER3a0UCgA6gI++ReCAZfuvmGWCzlWO1MNgjGYh1S7
         HYGA==
X-Gm-Message-State: AGi0PuZbybC2AHWGARVYfdAKWhEnyz7NP1yjBgwuX9PTR2znLQfMH26n
        LPhwak/NlGIXqLHnreBxzVPwQJU7aWQ=
X-Google-Smtp-Source: APiQypL+amOT71OXAYlZlxzEDBJCWZ0wAdYZVVZ6wDv5LXbjFTQqsQUDmiP251PupGULSgyyfi0myw==
X-Received: by 2002:adf:b1c9:: with SMTP id r9mr2554304wra.271.1588937002851;
        Fri, 08 May 2020 04:23:22 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id p7sm2569854wrf.31.2020.05.08.04.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 04:23:21 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: x86: Use VMCALL and VMMCALL mnemonics in kvm_para.h
Date:   Fri,  8 May 2020 13:23:05 +0200
Message-Id: <20200508112305.215742-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current minimum required version of binutils is 2.23,
which supports VMCALL and VMMCALL instruction mnemonics.

Replace the byte-wise specification of VMCALL and
VMMCALL with these proper mnemonics.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_para.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 9b4df6eaa11a..5e5e6c027424 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -18,7 +18,7 @@ static inline bool kvm_check_and_clear_guest_paused(void)
 #endif /* CONFIG_KVM_GUEST */
 
 #define KVM_HYPERCALL \
-        ALTERNATIVE(".byte 0x0f,0x01,0xc1", ".byte 0x0f,0x01,0xd9", X86_FEATURE_VMMCALL)
+        ALTERNATIVE("vmcall", "vmmcall", X86_FEATURE_VMMCALL)
 
 /* For KVM hypercalls, a three-byte sequence of either the vmcall or the vmmcall
  * instruction.  The hypervisor may replace it with something else but only the
-- 
2.25.4

