Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56913CE4F9
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346872AbhGSPrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350251AbhGSPpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:45 -0400
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2955AC0225B0
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 08:38:09 -0700 (PDT)
Received: by mail-wm1-x349.google.com with SMTP id m6-20020a05600c4f46b0290205f5e73b37so174907wmq.3
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 09:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zOaafQqyYiyHibWQyje/Aynnw7U7p4mRVaT60bMRHgo=;
        b=nWlb7jQnf7aLbh5SVAzsTk/wgS94APyUEE+NCtodxaQ41ISqv64Pg4TTOdKa31klUM
         2IFPHGIdLyBb1r/924z1/CVUfJ6Gbh9MyThu10slfEElIanSTaK2Xrvme76pgvmbSFCH
         N5nni3DLR4raUtJ524bPh8IxjbJL+3zBUV2mUbvmiWkw5MAmQuE1OaDOKDIh57Knac5k
         ft7C1wO51OpA4Fbmn8A5ZC5EVkDZqaUXb7cLz0/gmcHieLgWkokq9ChNC4M8t8wtaMzp
         DjWp23vlGA2BSdE5f7Ci94dCtmP8KdhytQACldFy38d2towoK/fUUMqNhfVSX0RwLwHW
         AmbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zOaafQqyYiyHibWQyje/Aynnw7U7p4mRVaT60bMRHgo=;
        b=f2/2bEQUVToWipYzZzgndkuIh6DYSfNsAZelkORMuOakSpJ/9qd6nmXIH135Q2C/9Q
         omFe+RcC+CZBjJlxzpV9Ps7l9WmZbYpa3ZWiAKDTDdRWLK3ZhtDG27BLkz6STZNt7SAK
         jnXxWIEvg1dFQHE0PTU1ysS0WnOZUH2FTFQVuc9WfT8Po1b+b4ZkaFhcbVDNKHC3dJ2q
         n2+uPZlKp0siqE9jZraVEDp+Z4jCXx8p6VaFzdWUwCpOmhYDic4KsJiNV/XPVdctJfd2
         41V59gwiZRoZkvlo5Lf2lWmDKkqQfcLP6RqGs9NuqunGRHKP1ePfO7Ka5v2AT0xTYtxd
         Gdog==
X-Gm-Message-State: AOAM530zXCQE1xKrdjKnY+pGyUQV4/8SPhjzkQROi/d0uONSMes7XRH2
        XfW96/aeLQISHF7FeRcg5TIJVotJxg==
X-Google-Smtp-Source: ABdhPJzgAMHslu1b44ODrq5vEN3TN0CYJuhq+aKYnb5flV5+UR/uab1rElFZAm5fgeicP7WXI7gWQnwCFw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:c083:: with SMTP id r3mr26930447wmh.97.1626710632666;
 Mon, 19 Jul 2021 09:03:52 -0700 (PDT)
Date:   Mon, 19 Jul 2021 17:03:33 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-3-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 02/15] KVM: arm64: Remove trailing whitespace in comment
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

Remove trailing whitespace from comment in trap_dbgauthstatus_el1().

No functional change intended.

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
2.32.0.402.g57bb445576-goog

