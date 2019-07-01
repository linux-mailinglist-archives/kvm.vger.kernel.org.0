Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D92074388F
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbfFMPGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:06:46 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40891 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732411AbfFMPGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 11:06:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id p11so21192415wre.7
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 08:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HtM1AGVc1eVIFXQ1sHldEbu1uEQVRa418S5hEsNYqe0=;
        b=sfPXo6e/cP29vyikvR/r9yfo/lKMstC8lfp1L2QuHIQu0/HbXNiAoV6a4tqCnd2BH5
         ktYeI4TXcBdXn9+KUIZDOTzaqEVnPrXPBTq4LRBFgket7mNTq4IcKbMgQD4fvuQ6dt+2
         XXcvt6706/iHPeFxESkEtOT0bQfVpDQ8IwrtwJWgUuHrOV8c/GN6/2cmcHa8Qxl5Xwo5
         W/JoEcG0Eeup9T/DGnZFa8qCdGlHf3FlNHIuGFjUjoXgdiluQV/oUDR+7PF++nR7B3hG
         H6IsGou19870mQApjVFUdRE6ao1k1c7BQ/ew+F3rfdgV3AEiSydJVs3BXD4pLwZ5Jflv
         mZNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HtM1AGVc1eVIFXQ1sHldEbu1uEQVRa418S5hEsNYqe0=;
        b=H/brYxCp6hvq/vhTsPWtfzH4oWD4FcPIc/rUsR1YPdGOmbGHVR+J7kGIdPLhlg9Vcd
         NRNC+Cex534nZRN6OY1gmiwhrLf1uZ442qSrrDc2zGLPEGKkV92HBpzujwrL1VLae+Vu
         /L1M1ZnuKp4d4sSlLDD+IkHXEMF54Ann4GtyenC5ieMbtZlQSm3EB4oonW6mPz/hWMfr
         xmRnJmwXh08s9WuFJWVsplALptgIaOkhJ6QU0KduAC9qOzCit9X0L4j/jiuc4P/y85xG
         Lu4MYALj8t7bxH9xfFikJU0hAH9tsaKoCAe5IT9wTGCvsyTOXMtg4FtKaMxcBplYRpX9
         YciA==
X-Gm-Message-State: APjAAAVKOClUb45pXfmpkoqRefDnqSVR5gBv/HWC0o4lJf6r3Z2A8glV
        XekzijkQ9TmEeKmQ4e6uP0I0Z0kQKb/Dxw==
X-Google-Smtp-Source: APXvYqwz80pXXz6U+4/LYbV7C5O28gkrNjLAxNlNRWV3gM0yABrne78/eSLPmDHocS4qh6FyZLw4Kg==
X-Received: by 2002:a5d:4941:: with SMTP id r1mr51029774wrs.225.1560438404216;
        Thu, 13 Jun 2019 08:06:44 -0700 (PDT)
Received: from hackbox2.linaro.org ([81.128.185.34])
        by smtp.gmail.com with ESMTPSA id j7sm5252873wru.54.2019.06.13.08.06.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 08:06:43 -0700 (PDT)
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     lkft-triage@lists.linaro.org,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [kvm-unit-tests PATCH] x86: fix syntax error
Date:   Thu, 13 Jun 2019 16:06:41 +0100
Message-Id: <20190613150641.4304-1-naresh.kamboju@linaro.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch fixes this build error,
kvm-unit-tests/lib/x86/processor.h:497:45: error: expected ‘)’ before ‘;’ token
  return !!((cpuid(0x80000001).d & (1 << 20));
           ~                                 ^
                                             )

Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
---
 lib/x86/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 0a65808..823d65d 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -494,7 +494,7 @@ static inline int has_spec_ctrl(void)
 
 static inline int cpu_has_efer_nx(void)
 {
-	return !!((cpuid(0x80000001).d & (1 << 20));
+	return !!((cpuid(0x80000001).d & (1 << 20)));
 }
 
 #endif
-- 
2.18.0

