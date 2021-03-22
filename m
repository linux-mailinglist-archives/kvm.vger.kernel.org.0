Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0334343926
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 07:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhCVGEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 02:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhCVGEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 02:04:38 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C67BC061574;
        Sun, 21 Mar 2021 23:04:38 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id u7so11506822qtq.12;
        Sun, 21 Mar 2021 23:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lwaHqCUEUERMsP+lSCCck+2lPknx9eDdkaf0NX52J94=;
        b=as2anY9IFqju8x6xmgL5aH/SQphhMHkDAgXdwcLNMU13gTcRuXYE44AmAZWjM5gwE2
         8X+J8KJmgUqvCplTWsiw7JMWKfmGSG+x0mEgk+jP3CpO7C7gVynfY1qpWd0x99BI5AiA
         zQc+CMFC6jwVg3l3r+CgB2o7XLnmmjKaKP0sANg4RODIJDlfVRKZyV7ffhHP5ilHvusw
         a++3Q7Oes0TARj/hVRgkwbtBiL/ruQmHxPKdTjUMdirGsw8oXLIYS606FamkJBThHCwb
         tq+pB75OVLo2ZhXd4Tofnqw/I1+bspgyHBbpOGo5UKg6PaLGK8RS94T6LNXnlphRSKO2
         vesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lwaHqCUEUERMsP+lSCCck+2lPknx9eDdkaf0NX52J94=;
        b=fEuFvrFbo2zAJSmoWEXbtsIpIhnmqrJShX92RvC4i9wuM3b0ED14IPSOZ5S2ltTohm
         1fceRfy/QDMfXy8wK/7a2mi+IgyXWa5EGZpo2cb2RGtf3Fxegkw3XxT9vS+NjeuzGLMe
         doJ0XMkVtJ1Dsp5Xhjv+wEXNEdpAgKuFl0p6gvCYby+8FOw3Oc/XUvXoCnm16feDD8+3
         QmGYQFe/onbiT8cr62cBFn43D++WzUSx++Xuxtmot3YMGfWiw4S/dgRgmDzpTg6TyouG
         LX/V/CvSlgQdpZkVAEM9VyYwURscnwWz3e0UZ7Q7kW26txwhiE5GKI6MPvKRKk0qZfAE
         squQ==
X-Gm-Message-State: AOAM530Zz/wgwKPZZa15877/XsedWl2pBGaR1FJjHR/0OLYVrtgIuzkR
        lEPH/0Fr+8BiY0ooaxWyvIw=
X-Google-Smtp-Source: ABdhPJyX6kPawbK5ls3W+DAKqZ3kKOxuwuIlod6H79ptvldVx6BkKPOe2vmjJ39w3EYwDOHkRRO/cw==
X-Received: by 2002:a05:622a:114:: with SMTP id u20mr8193244qtw.317.1616393077407;
        Sun, 21 Mar 2021 23:04:37 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.40])
        by smtp.gmail.com with ESMTPSA id r7sm8387041qtm.88.2021.03.21.23.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 23:04:36 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH V2] KVM: x86: A typo fix
Date:   Mon, 22 Mar 2021 11:34:09 +0530
Message-Id: <20210322060409.2605006-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


s/resued/reused/


Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 Changes from V1:
 As Ingo found the correct word for replacement, so incorporating.

 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3768819693e5..e37c2ebc02e5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1488,7 +1488,7 @@ extern u64 kvm_mce_cap_supported;
 /*
  * EMULTYPE_NO_DECODE - Set when re-emulating an instruction (after completing
  *			userspace I/O) to indicate that the emulation context
- *			should be resued as is, i.e. skip initialization of
+ *			should be reused as is, i.e. skip initialization of
  *			emulation context, instruction fetch and decode.
  *
  * EMULTYPE_TRAP_UD - Set when emulating an intercepted #UD from hardware.
--
2.31.0

