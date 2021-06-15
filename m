Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F963A80E2
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 15:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhFONmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 09:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhFONmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 09:42:21 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387C5C061198
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:39:56 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id 205-20020a3707d60000b02903aa9208caa2so18853170qkh.13
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3CDZtfonJ6Kn0YHhhj73hjP54PoBU2rnCZTJCgmS6Ek=;
        b=JwmZkhwZ0+KjEQ3/dK0BZHYgAZwsVcpyKPxOiybVfwZM7HxKzOvL9ECy20QZQCuDdH
         Y/gkSzrqWNwnI9h0nwDwprMsEipVhr/Eu2ESMTLqDQ0YmHVOuZKNKur2hikmhArCr1q1
         tNBc9T+04c62v/wohI+qHWPudpvjhj2gEYdK5Zx0inaHlVlthoxZAeOwtPPfZ10tm7wA
         JM5Gf0QzlKZu4aZTJaj7SrHQ2LHHFDPY6iluxTiMZVJsmoz/WA6UJ0ZV3wlXo7k0mQjI
         wy3CkKZtNkK2E6ApH1rjqC7WVlIJZY8nYOTehL/WO0r5e1EUpAf+x4IyUVpH3kuLJOnJ
         kvaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3CDZtfonJ6Kn0YHhhj73hjP54PoBU2rnCZTJCgmS6Ek=;
        b=gSvBXYgQJErmAAT3fbByErsNifdrpQRbbV9lSVDxwEV0u1zZ89TrM3MLXLUjdggTjg
         Fb9XU2BCmP9ac8YHqy5+9CTwBaBDmmcYfjTCdFxSoWOlv7nO6fyiEjdEAg5bs4Tk4lR/
         qpPbnhDB++d+IvxIMc/mcPsaOHA3RhAvlm3RXCDghQcufT2fYjJxbyNFhdMhcvBPDqBj
         8Th3SOi8iI60nzvYmJKm3E+BwjrLAqqIJ6zv9+IPII5NpskTu968b6fC/e/SCy/F/33+
         yDloflF3k/VPDOzyYd1igQ6YquB0Yn2g6z5UnwtqJ5TbM9YbzsBvq+XQL6FdNxPA+BTi
         dZVA==
X-Gm-Message-State: AOAM533mfASe+0L6ZDuAq4Z0E8ZiVC0oyPX/VVkV/cQXDLH4MnU/kVq+
        4HXHW1gFqEfmBw9BbaengN0fUMSFiw==
X-Google-Smtp-Source: ABdhPJx9VNK6pVq9QAAsYb7IoPgKgLtqLpsG5afdZqLH2tZYOQNCIUUUbr3GlXuAnKQu+b0JevOAo+NnnQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:ca94:: with SMTP id a20mr5113188qvk.49.1623764395363;
 Tue, 15 Jun 2021 06:39:55 -0700 (PDT)
Date:   Tue, 15 Jun 2021 14:39:38 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-2-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 01/13] KVM: arm64: Remove trailing whitespace in comments
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Editing this file later, and my editor always cleans up trailing
whitespace. Removing it earler for clearer future patches.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1a7968ad078c..15c247fc9f0c 100644
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
2.32.0.272.g935e593368-goog

