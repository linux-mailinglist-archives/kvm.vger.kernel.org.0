Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB88C3EE810
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 10:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238893AbhHQIMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 04:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238727AbhHQIMN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 04:12:13 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F4EC061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:40 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id d20-20020a05620a1414b02903d24f3e6540so1632340qkj.7
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gw2LswsJmGwYXUvemUxTnggwwTkhoQCT+deYh5e54GU=;
        b=IvyYurtwJCZW0dkFujHS6ilPFANox0AtHkdYRyiKJCtJ4973Eso0xUyexV0vfmzgs2
         7o386Y9WY1mm0cmgG9RC9amfrRtuCbPVCQ2C/eRwIk88QzxGonk9hA/22vGzDOHPmdAU
         dVS3o36GV566Rg5ZaLyKERcqv1hYP7WpCWZqEoGne3aYYHrvkQoKYvBFKPPuCfGn+MfN
         pwKF71bqOZoGFZ1tVpTMYhrXQjRYP8EnW5XgIBvImeout1vK3T7MlcnrWnSgXqL7co66
         0xYQngJRfHHibCgF/64bHJCcsGYuBoOtej+9PWwthQiMwn68ajx0PSncD6C+gMt774KJ
         Z5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gw2LswsJmGwYXUvemUxTnggwwTkhoQCT+deYh5e54GU=;
        b=lOSsi2TNp6jnYmAtLC+/pEHcHXkhHvf/s5D9jEEoA2krZfDaQnLoPy7gG8MG2TouG7
         MuY+aOcDt46DA5mY+Tkr7Y0wuapwVVFg8TISPnXMWma49UfJRnJbY+KKb37YlYCB4LIu
         iobMPN5KEx7EUcvOgEcyPBp4gZ1XaO6BuxuqTQunHKOCc8YueY8GtBAYfao0Z/GNBAks
         ANyx3jhFkbXuUiVPZsOxX8NmXrol/+00/9r2rrNYFYFoVQhWyrKlWnKc1s/eNfvSPvWO
         q6q+S9TW7LDsHU3+y/y8/1zYItH5c4aJ96kd3OXTookmQNDjNhU0sRX/E2R52iupc3IX
         Ej4g==
X-Gm-Message-State: AOAM530Jp2N/dWVYFn5pUw6Dv1B6T9xZojbOsTGTRj1UQLC6SxCTZThi
        kOMZZJWTRY8IchJ9gPUlc1TXcQ1rYw==
X-Google-Smtp-Source: ABdhPJwEf+noobKDIMb8yGxWg5hsBK+Cx5/cHbuKhsdc9IPXIZtXX4a8CpfwqCj/Z6egtP8X7XkIYRMzCQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:58cc:: with SMTP id dh12mr2069199qvb.32.1629187899986;
 Tue, 17 Aug 2021 01:11:39 -0700 (PDT)
Date:   Tue, 17 Aug 2021 09:11:21 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-3-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 02/15] KVM: arm64: Remove trailing whitespace in comment
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove trailing whitespace from comment in trap_dbgauthstatus_el1().

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f6f126eb6ac1..80a6e41cadad 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -318,14 +318,14 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
 /*
  * We want to avoid world-switching all the DBG registers all the
  * time:
- * 
+ *
  * - If we've touched any debug register, it is likely that we're
  *   going to touch more of them. It then makes sense to disable the
  *   traps and start doing the save/restore dance
  * - If debug is active (DBG_MDSCR_KDE or DBG_MDSCR_MDE set), it is
  *   then mandatory to save/restore the registers, as the guest
  *   depends on them.
- * 
+ *
  * For this, we use a DIRTY bit, indicating the guest has modified the
  * debug registers, used as follow:
  *
-- 
2.33.0.rc1.237.g0d66db33f3-goog

