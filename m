Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3190A428206
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 16:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhJJO6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 10:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbhJJO6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Oct 2021 10:58:42 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B898C061570
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:56:43 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id z10-20020ac83e0a000000b002a732692afaso11524721qtf.2
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2yxyszH2o0l7PmvxhJ6rJ+q2kN5pLUdYHnvLPGFqiZk=;
        b=T1apfSHiw0BEncB76X8A+leVkZjV5dDbjRgeJHlBhIbdjj2bwXGzl8IWHzCFzzg8FD
         tJyqCZ0TXhV1qEqmZ2+ldqCD6ABEh8d6In2njfTxPpEV5PJw8TA17PBGyCYqIBcKnTiT
         viT3TiZb/hUlhXGayVK5f9K0fTWc4MAzb8tCI/uVcmNFeTJ56BoWIUMpIHCad8UAWeO7
         kMVy6jmhuOKR+sP6odiKul8y/ToG3qSw2IEGC7GdcgcHg1/52z7eC1+R0/3bh14+m6YD
         s6HvrTz2NXnD5f0CenqdeA4ewPA81LYej1N3zS+AvIZ0hLag6ag1YvEZcFdEYxRw1C6n
         ZTDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2yxyszH2o0l7PmvxhJ6rJ+q2kN5pLUdYHnvLPGFqiZk=;
        b=fYppfyVImO4YSniNSRlRcJ0WbO2hrB2yAcF9uUSQw1+O96cV2yeCiHDDWlvBtDNAqN
         Fvr6nq3EyqZ4trVpvBmnqFydz/Gzc4Uofatt+JXEGaqx9xID9+oYlu8ADOS+rXxwFJPu
         9CZ5TBaGnjc425Mmn9JqqbshGaKUj66G3mAD+4y/5Klakpwpm//IlT71pX2h8/HquNjL
         RjXo2vylIFPA8DlqNyGWR3gSKdGDze4S/5ID8kuRJIkHHEvxV7oLgv+JPsMgzw1hGaHw
         /JJ6OHJ7trhW5HKe/EzmRm/j+6/PICkBj8AvBAB4rnurN/NBF+hOn+5jLkc7N+CNCJkF
         QQng==
X-Gm-Message-State: AOAM531/kguaTAfqAxWOpwRYcLcrtJ/VcwnAjXoVcCf5V2PuG4gk2A5C
        ESrwev7kOemrmq3P9WgMNvRLKhneBg==
X-Google-Smtp-Source: ABdhPJzj3B4OpNfjLvAOsVB/XzS3C09XWa44/mwOZkz7b4EAq/m+irtZsK0VzwPEfzObqrs9x98Hz993Ow==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ac8:5bcf:: with SMTP id b15mr9860202qtb.178.1633877802740;
 Sun, 10 Oct 2021 07:56:42 -0700 (PDT)
Date:   Sun, 10 Oct 2021 15:56:27 +0100
In-Reply-To: <20211010145636.1950948-1-tabba@google.com>
Message-Id: <20211010145636.1950948-3-tabba@google.com>
Mime-Version: 1.0
References: <20211010145636.1950948-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 02/11] KVM: arm64: Don't include switch.h into nvhe/kvm-main.c
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

From: Marc Zyngier <maz@kernel.org>

hyp-main.c includes switch.h while it only requires adjust-pc.h.
Fix it to remove an unnecessary dependency.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2da6aa8da868..8ca1104f4774 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -4,7 +4,7 @@
  * Author: Andrew Scull <ascull@google.com>
  */
 
-#include <hyp/switch.h>
+#include <hyp/adjust_pc.h>
 
 #include <asm/pgtable-types.h>
 #include <asm/kvm_asm.h>
-- 
2.33.0.882.g93a45727a2-goog

