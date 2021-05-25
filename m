Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4372390C53
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 00:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhEYWgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 18:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhEYWg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 18:36:29 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3BDC061574
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 15:34:58 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id h10-20020a0cab0a0000b029020282c64ecfso12845164qvb.19
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 15:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9d9t5dJ12Os/4DAPwHE3tGZsThBrqTsgew7zPVqDUSo=;
        b=QytIuGjIu11Ei0x6P6NHL/SZK7P2eUxDTrKL4DSjW4XG/mfukCipiCuD3dDdWqDYln
         7M4ff2XJzR0e8CLHM4gEwgmyGD6w0X8YlJGJCVENvP3nAT3G0Z9BYzl/Z5vkq78RabFW
         RSw1nqkB+xy2nG5nXbequKB4vEU1KeU0fH+svaFZGW/EOS24GX/VU4/lQ9xxilcXpCca
         znDCyKfjZSvQiFSEC7Wl1KDnuzNb6E6AHeoWtagtM7IbqYGDxHqhdqYcfSjg5UmGjsN3
         dNb+G5DNkU0r30d5bfh0wloTIByBtYocyAUce8nVD/DhCHVeSOFAXRJOaBvIhDo6wLh/
         J2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9d9t5dJ12Os/4DAPwHE3tGZsThBrqTsgew7zPVqDUSo=;
        b=a3esDqWUPrkTtS/ZLYXIOk+vUl2cLYKib7JGP7h9jWTX+S8IIEbOGvM0ETb7I3W99U
         DV3911cU8YwOC4v7TQ5fnuhCZS9s9ZFCp2v75odyeCpBhdbjJr+22hpZnzfB9Zfh5ir1
         O6v4LcKhWDt7DXayEW4Cu7/1FjbnYJhUzeIuN3ojXp2+AOvliK6+PYOVxmJLK51xkfpq
         TVc80zAuPCLbITZAsGl+7xLY/uooKmiP7NfNZPfamLxOEIs0+ofRRkCBKrhlQP+QfHNX
         0h8Hrbw//iy2o5Nn3p6kYbgjCBGiZ1pE31U67NV3zambGU2fnO9y3i08yguPy3x1htZ5
         AibA==
X-Gm-Message-State: AOAM531DG8/Y1UETAfnmb+Zma4OT5eS5sWnoGzSw6KWB4WNtdhEZm/VW
        JAT16WW78gK4y2paZF9zqey6jbdSvZBPPrxms2hAqWKgmgnOQzCXZ+Vr3B06mNuS12xJCzf5dDh
        sX6qtHSIRafnE4OQPibMBnuJjo5nOiKf8r3Y4CPBx1MHREtP33FBm3kOTrlUsyz0=
X-Google-Smtp-Source: ABdhPJx/+Gwdfu0C55uR2fdzg/kb0LEcg9fZ/FeigdNwYOHO6IhB5w0loLvmDk0+hl+Nl/hg4qhvNfTSetC2dg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6214:f05:: with SMTP id
 gw5mr39823776qvb.44.1621982097162; Tue, 25 May 2021 15:34:57 -0700 (PDT)
Date:   Tue, 25 May 2021 22:34:47 +0000
Message-Id: <20210525223447.2724663-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
Subject: [PATCH] KVM: x86/mmu: Remove stale comment mentioning skip_4k
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

Remove the comment (instead of fixing it) since wrprot_gfn_range has
only one caller and min_level is documented there.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 95eeb5ac6a8a..97f273912764 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1192,8 +1192,7 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 }
 
 /*
- * Remove write access from all the SPTEs mapping GFNs [start, end). If
- * skip_4k is set, SPTEs that map 4k pages, will not be write-protected.
+ * Remove write access from all the SPTEs mapping GFNs [start, end).
  * Returns true if an SPTE has been changed and the TLBs need to be flushed.
  */
 static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

