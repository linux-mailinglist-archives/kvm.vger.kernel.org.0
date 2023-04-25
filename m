Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27506EE127
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 13:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbjDYLjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 07:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbjDYLjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 07:39:51 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9018A468A;
        Tue, 25 Apr 2023 04:39:50 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-9505214c47fso1051246566b.1;
        Tue, 25 Apr 2023 04:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682422789; x=1685014789;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Uhlme4gt9b2fIoSYooiRDG3nPCx1SJPD3Moq8dts520=;
        b=fbWcdU0NnREyJWMw07Co+ZsxBZbKAj1Cx9JfSqAwf3b2I48vKE9GJQXbX8wPUe4teX
         frAT8e9R7SVXOsR2Jw++gkW+IgJZOjxKHBemFCK5GtgfkPhBzm7rTqSHUa2LRj/EmVJH
         SnkIdWk/hQCSxGdr1Kq5L1/hU0i/kHh/d+Q/h02KMIAwSuZr5GQn2GCvNPLDRhUFdtr8
         cKywu+/X3WHqyjnPUgNL8UzYy0WEOxe91zBQqCrabLYL2I3qTUNRW7phU8BPcgYNo0qL
         M4wa9wkN6nA9pK3CKNqzkCQXZuMYHKS2QMCTMCvmRTDBj2GQkr0NYhEkNNFjgc+UsOkO
         IUgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682422789; x=1685014789;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uhlme4gt9b2fIoSYooiRDG3nPCx1SJPD3Moq8dts520=;
        b=V3ypEVbEejzmp/FgSll7IqtBXnYViZQVIyQKQXf4QNHC12NTaPLr357f2cI6r/mQdL
         UFD3Otq7ND2yNqBdSZrzXBgUcZETMAmLNrmkJjp2gePaFH26cNhmu0ttbAdgxDMlIY+a
         9JZE820ThBgfA/N5YlU/6vS5AbNtEMHA4TjWsA2a7xQkZi0xGdlVB3G2wJdMCjflGXVQ
         82xeZm4QFQf4rM+bldx654RApB1YF7PGMhQ/lfPELJWTwiU+nXZaHqdD81MA9ST9WTFe
         CFJnD0kHbEVgoNDr8yiTFNir2iLqFzlSy95vV+IWz0yZYIVgp7ychkrAYZW4S3MHYXkq
         IMqw==
X-Gm-Message-State: AAQBX9f2q9aRCb0lEKnr6slw3rTLsujW6JJ2/c4+4E+V7nfXM2NuNooj
        sE7CDqQcgSkbhVqlDfXID2RCaKiOo6rp5g==
X-Google-Smtp-Source: AKy350YEc8MxPrvdXklvc0+f/36x5cuiax3Yc3EXcEg6VE1CFp59poyc100VNtaRzdDsb7fpGfMt9Q==
X-Received: by 2002:a17:906:b314:b0:94f:3521:396 with SMTP id n20-20020a170906b31400b0094f35210396mr12750769ejz.23.1682422788691;
        Tue, 25 Apr 2023 04:39:48 -0700 (PDT)
Received: from localhost.localdomain ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm6703216ejb.140.2023.04.25.04.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 04:39:47 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH] KVM: x86/mmu: Add comment on try_cmpxchg64 usage in tdp_mmu_set_spte_atomic
Date:   Tue, 25 Apr 2023 13:39:32 +0200
Message-Id: <20230425113932.3148-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit aee98a6838d5 ("KVM: x86/mmu: Use try_cmpxchg64 in
tdp_mmu_set_spte_atomic") removed the comment that iter->old_spte is
updated when different logical CPU modifies the page table entry.
Although this is what try_cmpxchg does implicitly, it won't hurt
if this fact is explicitly mentioned in a restored comment.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7c25dbf32ecc..5d126b015086 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -655,8 +655,16 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
 	 * does not hold the mmu_lock.
 	 */
-	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
+	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte)) {
+		/*
+		 * The page table entry was modified by a different logical
+		 * CPU. In this case the above try_cmpxchg updates
+		 * iter->old_spte with the current value, so the caller
+		 * operates on fresh data, e.g. if it retries
+		 * tdp_mmu_set_spte_atomic().
+		 */
 		return -EBUSY;
+	}
 
 	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
 			      new_spte, iter->level, true);
-- 
2.40.0

