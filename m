Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45611417599
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345971AbhIXN0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345752AbhIXNZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:25:20 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED50C03402E
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:55:05 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id x7-20020a5d6507000000b0015dada209b1so7960217wru.15
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pSU+osLY3SNvsXyTiQYlyo1U/eLzGKvNKDW/e+/rj1k=;
        b=Xi9NRBx5XZozH8rB7huHuBAd6SihWjX6Jrjnf64+NQTSXskvNul2GqBxfiIf7CNmuT
         0iKOKMJ44cK4ZU6Rwz1/SGVVEFbq8t5ri3zkvZ2XFXGbIfk1wobzhlceO01k5FRItErx
         5m5N8vhxsF9ZucNOiJrzQxW+YlmxiRqOMNbZajajDFlgvy9PcYT3txzcp1UEEK+HymzZ
         mZ88QWv7zrABazvTZ2E7mEGuKfuhe+OlDRgTvEyth3hWEwU/z3vdsXhBin4ahImA9ziu
         kvrQd+XmUbwiD6UW0Cszh1IwSROmmsu/e32zONjnwXCme8AzBqfD3Btll6it+ZzXJu+X
         bzoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pSU+osLY3SNvsXyTiQYlyo1U/eLzGKvNKDW/e+/rj1k=;
        b=LoCIDBiR1/U7FzRnTsCk7T4RsL2w+KsLalWkac4fxkR/qzVqtompAtE4bEhEvd7M/c
         DJLq8X+k6NGaCoCXk0GlNRK/NTOz+lSknBdizUKxbgcNhM5td5+WOctcay0djOUC4GbZ
         yuu9sfE4nbfFemnpVpFaRX8Vcm/LVOvDfDrwPplfqYxJNcX/Ms09cjNykbjvD2ocS2M1
         6LsoWNpzTEbuOZ71zXaWQevp6Y9jMwyFmcHJ3MCBWTys9FyuaEEOn5vtVFU43fzh9zUn
         i3YwQhg8F+wOlzMWY1pEGP15Tl425RHh3QxngZ4EZzfMQzaADioNpBOAvbyTvSZKs5Kf
         RKCA==
X-Gm-Message-State: AOAM5308KGHkGO/+OJBvWqycKStCE/PjxGrufLgaeCmlByn64VPr4bJB
        Ir2EU3gFD0VpgGoRR6M55/dmqGD4pQ==
X-Google-Smtp-Source: ABdhPJyxAytgyRlwjG9Opamr3QJB1iEdrxd/ybpglcgq8dr0JcPPiKb6K3AtAV5QDJY8zF5YOBaDzRTtbA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:a757:: with SMTP id q84mr1960176wme.26.1632488104470;
 Fri, 24 Sep 2021 05:55:04 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:59 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-31-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 30/30] [DONOTMERGE] Re-enable warnings
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 0278bd28bd97..ed669b2d705d 100644
--- a/Makefile
+++ b/Makefile
@@ -504,7 +504,7 @@ KBUILD_CFLAGS   := -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE \
 		   -Werror=implicit-function-declaration -Werror=implicit-int \
 		   -Werror=return-type -Wno-format-security \
-		   -std=gnu89 -Wno-unused-variable -Wno-unused-function
+		   -std=gnu89
 KBUILD_CPPFLAGS := -D__KERNEL__
 KBUILD_AFLAGS_KERNEL :=
 KBUILD_CFLAGS_KERNEL :=
-- 
2.33.0.685.g46640cef36-goog

