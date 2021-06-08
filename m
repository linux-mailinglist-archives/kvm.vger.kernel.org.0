Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B0539F8A8
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 16:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbhFHOOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 10:14:39 -0400
Received: from mail-wm1-f73.google.com ([209.85.128.73]:55983 "EHLO
        mail-wm1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbhFHOOi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 10:14:38 -0400
Received: by mail-wm1-f73.google.com with SMTP id k8-20020a05600c1c88b02901b7134fb829so118757wms.5
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 07:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KfCyzLjYvtfjVAu2B5vrfApkB1qN2fyodQIgINGEiTQ=;
        b=aCRbqylSf2xclCPrzcK21cGpJ42WwdS2xxkiUcDI5rJGyVysXv0RyuECMvmGBOIo9f
         4e843nuXCj6TaO82nhrhkd3ABl3GWsCAeb9R5a0MPfmVnEfdjCuDRVTgTGTBvuxz58y+
         OBSKt642xMNFQxyLqBD+Xahyo4jlFJvg2NHMba+pX8jccHI766dgiwA3XLmfkhfGJHzw
         T4BOf6Ga4pB+IR6V9vih/peEidZ//ysloqxfjGNabwUymu09f4ulvkr67KK54ff/f3l1
         ra80fmWLjpL0lij2kaKuTQJ22e7QjGnXqd78UnIhflR3WVhdwMY/EMtSgUoHiJHhekeK
         07YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KfCyzLjYvtfjVAu2B5vrfApkB1qN2fyodQIgINGEiTQ=;
        b=XR03msKE/DL+i0xKyE35pquX10l+0qvOrebMOm2rjmxEiLNTCTyviHV1Brt9b7h5Fc
         EhX5kzCr/Ls6+6Re1CMdKrc8xf5T04DX3FaVh6+Ei0rn/2fOBF6HNZjhARq0yIxLJ0hH
         kPw51qYyHxydmJTkOtZtLAW/yoIj2D81pWYGbYp1UxzEGHDAWVaMAKzb6t2FbD/VA+TJ
         6kZGrNV79F1L/w3Fh3hyhpIlTOr7LGyDtAIcIhSNo+T5ngY8dN7zhaTnaQed5YEGPGbv
         WI+nAxFnSFv9XjlGo1Vx5IgltDNcP3o9rOgotnZTtp1ltDT8kknk+JeWHoHPD0J+LnXj
         X0bQ==
X-Gm-Message-State: AOAM533+2TvQARi0Y1O9Xk4Z92lrbilp0pTDd+CcIwNzu2IaRqofxOz+
        3sDPdQtJXHx+xHHzvdodTx5RJX3/AQ==
X-Google-Smtp-Source: ABdhPJyRDNGkYEpQKyC8K8EuRMO4oTBOQ99EavtyeC4T4OfyBXHvNt/BP9UvYfKkUFL4MTMUm3itodZJAw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a5d:4ecf:: with SMTP id s15mr22738532wrv.80.1623161505308;
 Tue, 08 Jun 2021 07:11:45 -0700 (PDT)
Date:   Tue,  8 Jun 2021 15:11:29 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-2-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 01/13] KVM: arm64: Remove trailing whitespace in comments
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
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
2.32.0.rc1.229.g3e70b5a671-goog

