Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52893774E76
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 00:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjHHWlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 18:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjHHWlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 18:41:03 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711EC10E
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 15:41:02 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58440eb872aso80735577b3.3
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 15:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691534461; x=1692139261;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3rNBj6786+N1k32eHRRlayZnJaz3TtrdUsSjOGUYzq0=;
        b=3ZqoyMsmInjqXfLrhhQo3PmaKb4aK/U3mYdCHpVvru5JheoWVyAk7sYiYRcVwL9dpq
         V0pqPbbRLmNLOJrWYIfGS67Au7hiWO3Vz95IBlKApSJelhVNpJY2RIkyb8nhYheTKQ69
         LL/RVxaE99OBa9+pGsngWbYgn9Pz/XEdLG1MGfiVI/hNhd+ZTBqotzZQeJZistGxnGvd
         d8yne52FcFYEhfwd6swj2mlxRB0f6w2iyI9expZ+Xc+q2DsH/3UvvD33pKWaRksyZJna
         F0Czv86+YHqEIkQR/h76PYg62M7N5afvK5DkAuXmdLIE9QTqgSlVxNABCeA48U3/Pri+
         +Rbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691534461; x=1692139261;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3rNBj6786+N1k32eHRRlayZnJaz3TtrdUsSjOGUYzq0=;
        b=KbdcPA7lL2JBxnqS+Qv+CEa1BcpXmPVjprrWlTrrZ5rDONyrmd2vVHy1XEGml/X4FS
         DIOIQL/9FuBqhkBDs6+liSsWnwPGAXIBiAqR0RnDETRSVn3wbR+CuvUgidSeA1GC4QMk
         M1KGkm6uxwNhnvIy6AhJ/pqNpkeXxn1KfAfnX14AXnm8QGGt0fYvvhafx3+0CGu5qGgD
         JAxxaMgsSVpLtqMQhckZ8rcUhPB+u4JY5yyo3GfqSdOWyBm4aTBtlgPq9hihqQs8wCpL
         U4X7KxAhDvhGp02Hk8jz9AiBmxy6B25fBfKXczIruKWvST/cGHLKThi4pH+dcC/nCfy3
         uQwA==
X-Gm-Message-State: AOJu0Yy1kTFsEsmXsi07oR8dSdmJwkPOqO3U/PAKC+GLTyPlJwFmJCvZ
        qa3Qz8fACW7u1dYU6QMZXtG3dbQB+O4=
X-Google-Smtp-Source: AGHT+IGc1h7XTB7+xg8mBM4QFplLeZIjv0hdDbovIRNMtMDEFpAgGy+/lWVn/UQwSSVabwzQ6Dr8OOuQtrA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7456:0:b0:d05:7ba4:67f9 with SMTP id
 p83-20020a257456000000b00d057ba467f9mr20788ybc.3.1691534461716; Tue, 08 Aug
 2023 15:41:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  8 Aug 2023 15:40:59 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808224059.2492476-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/mmu: Include mmu.h in spte.h
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly include mmu.h in spte.h instead of relying on the "parent" to
include mmu.h.  spte.h references a variety of macros and variables that
are defined/declared in mmu.h, and so including spte.h before (or instead
of) mmu.h will result in build errors, e.g.

  arch/x86/kvm/mmu/spte.h: In function =E2=80=98is_mmio_spte=E2=80=99:
  arch/x86/kvm/mmu/spte.h:242:23: error: =E2=80=98enable_mmio_caching=E2=80=
=99 undeclared
    242 |                likely(enable_mmio_caching);
        |                       ^~~~~~~~~~~~~~~~~~~

  arch/x86/kvm/mmu/spte.h: In function =E2=80=98is_large_pte=E2=80=99:
  arch/x86/kvm/mmu/spte.h:302:22: error: =E2=80=98PT_PAGE_SIZE_MASK=E2=80=
=99 undeclared
    302 |         return pte & PT_PAGE_SIZE_MASK;
        |                      ^~~~~~~~~~~~~~~~~

  arch/x86/kvm/mmu/spte.h: In function =E2=80=98is_dirty_spte=E2=80=99:
  arch/x86/kvm/mmu/spte.h:332:56: error: =E2=80=98PT_WRITABLE_MASK=E2=80=99=
 undeclared
    332 |         return dirty_mask ? spte & dirty_mask : spte & PT_WRITABL=
E_MASK;
        |                                                        ^~~~~~~~~~=
~~~~~~

Fixes: 5a9624affe7c ("KVM: mmu: extract spte.h and spte.c")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 83e6614f3720..6215f4c60ed5 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -3,6 +3,7 @@
 #ifndef KVM_X86_MMU_SPTE_H
 #define KVM_X86_MMU_SPTE_H
=20
+#include "mmu.h"
 #include "mmu_internal.h"
=20
 /*

base-commit: 240f736891887939571854bd6d734b6c9291f22e
--=20
2.41.0.640.ga95def55d0-goog

