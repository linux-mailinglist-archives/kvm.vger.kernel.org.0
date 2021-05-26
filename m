Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7900391D10
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 18:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbhEZQeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 12:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbhEZQeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 12:34:05 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F86C061574
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 09:32:33 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id p17-20020a056a0026d1b02902df90210ec4so1125097pfw.2
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 09:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=caF9LzYAWQOtjPTggq/bnzEfl9ot4TqQynXIGBOZbug=;
        b=HcRAhBv/e0Cg2/Mvjs7KOblzFbzeqx0F4cqDG9AQb6PxpiqTRsLlSddaZSkIFO+d3y
         hKk+IAwpBBdD5BF94GVMV9/oS6l35u+aN9l485v2LjWqL087dvgYqtkonJlfMey5p8PA
         u3VRBCzDnlrlGv0jQLOsyhBH5P0UKv70Jo0NluSs4tC5qPcE124yt/gZ649GSfIdO7fL
         hsqquuzg7sJGgRTH5hc8GRgNHdhl6q0ZxzDyzK44UXNS8T2JkldRlnvoiRw/OHfFGliq
         ggkaQlyW56my/tUo27akwq/XWJIc0yW29eoMKfnE9PlLLK4LUzYZRAcCG4CV2Qx5oFPX
         Va5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=caF9LzYAWQOtjPTggq/bnzEfl9ot4TqQynXIGBOZbug=;
        b=mzEQ5Y5wy6DEby/NM9NGmmB7J6iItPndZrw7JA33+RNsW5qIcAcyY8L/xtVZyaqzwj
         IidoAjHoNot+wZW3t3T7BVvHYGfBdx9QaXqKuy6/EgisIg02UKmoTGLa5a7K1cMBgCxD
         z311FLG48Zx7klgmLook+a7xnOb4mcZXZ3k8s45MmZayq8DU1QklzXzOOycjmScq4CjM
         vqJAb/scjS6eSQwOCnLRob9zlMinlPKNRaSqLnf+elIfDTy6Ks/rgytAtwUZ1RA+vZw+
         Il+zk3wPyjpm2dxbczjkZlj9D0HcQXWJ+7cDAPj1GxQgGReYw2IpeVIyq8lIVEL/UPwU
         N0mw==
X-Gm-Message-State: AOAM533BCj4+id7EvEq9aiad4dv7I5yVo9GPmiaaJbc9o0WHENehetPA
        rooKaUC+Lzul2XoJBL8Ceud5W9g3U4slLalbi15/13Ew3GSf9XGFNP4ACv2B6NDcK+yNzef+BCV
        wFMf5g25P35bZWQWkeJnMbFmWpmDuFmDSVt/dGJw+D4ZIXO9Bpkz6wvyiGRc4WRs=
X-Google-Smtp-Source: ABdhPJzGs8OkAGH7hEQvWrOvzJs1Gf3SIYSneHYbao2JZNtCRmPS1czxu2xKwxnTTCXUTZkeQNoT1vSmsqzRwQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:e016:: with SMTP id
 u22mr1077958pjy.1.1622046752362; Wed, 26 May 2021 09:32:32 -0700 (PDT)
Date:   Wed, 26 May 2021 16:32:27 +0000
Message-Id: <20210526163227.3113557-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
Subject: [PATCH] KVM: x86/mmu: Fix comment mentioning skip_4k
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This comment was left over from a previous version of the patch that
introduced wrprot_gfn_range, when skip_4k was passed in instead of
min_level.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 95eeb5ac6a8a..237317b1eddd 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1192,9 +1192,9 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 }
 
 /*
- * Remove write access from all the SPTEs mapping GFNs [start, end). If
- * skip_4k is set, SPTEs that map 4k pages, will not be write-protected.
- * Returns true if an SPTE has been changed and the TLBs need to be flushed.
+ * Remove write access from all SPTEs at or above min_level that map GFNs
+ * [start, end). Returns true if an SPTE has been changed and the TLBs need to
+ * be flushed.
  */
 static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			     gfn_t start, gfn_t end, int min_level)
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

