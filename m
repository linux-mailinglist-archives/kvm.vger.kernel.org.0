Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F67F3EE80F
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 10:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238667AbhHQIMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 04:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238193AbhHQIMM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 04:12:12 -0400
Received: from mail-ed1-x549.google.com (mail-ed1-x549.google.com [IPv6:2a00:1450:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FC3C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:39 -0700 (PDT)
Received: by mail-ed1-x549.google.com with SMTP id u4-20020a50eac40000b02903bddc52675eso10195988edp.4
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+tR0t5ZUJ91bnVp6oIhXSHEsqTp4Y29yczYOBvuJUDo=;
        b=NkOZvmbOv9x7PRjOB97t/mkx29EdEllMNyS1WbW9rr6vvm55DXlOL+NC8ig0QTdjE7
         B0GabQwAfdMe6C43xuYpSxLYBcoRBhgVbUE0tQTQNimpEflvOT0w067ujp74lgdKdM7C
         nhEpQC/34RYPE7t0RpUBx0dsexU9U+VkSgvni3sZDem72nxGUMRPHl/zo1gU0f3hSGGU
         J3aQFvR+GkR6+FEd70H9mmM3ItdbPf//Moto1u1lGfTs1BaNShyRYEJlz5Tb1+HR5gMl
         qq6ICC9g/Chjg/h/fHkx+qUV4mU3zz+0fDGprCZaV4GaQ1BTYrLvpbHHFmUfXnAFGhAk
         vowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+tR0t5ZUJ91bnVp6oIhXSHEsqTp4Y29yczYOBvuJUDo=;
        b=Y20WUnnH8QNaSWN/np/VtxhgIy6YmD2W4SWHgq6bkI+DEMbS5P5u4pQTDamCdlUIWz
         2VWV2ZX38+zSLvP8L6W4gv9KXml9unKggMEJ4VEeAkiGMe+BGtteB9VujUd41UgwMLFb
         VqJq4IO3jL7N7gbOZkMEmxEmUfjhemSIYWvf6tkiEWMpqWPiS0+Xmyb6bR1Vb3tTrK4s
         oy5X8OFZK7PoLbBzaCKQ4ghA4n8q9i8C/sleWGmLBE73JcESYfu+mt0xubk+p0mBPX0M
         csxRJIeEb4E7WQPUHUvx3ow7yAqu7/nV5hdmE/cyr02GgsIqLHMwe3+P3+NJ6fpwj42b
         ZgrA==
X-Gm-Message-State: AOAM530bUVR3Z7mC8p07z4hCur0xSrxoZSgVI55jEJA4iw2cd3HWcX9z
        eZ/8nIQojDZ1a54SChlQ89LxAa1SrA==
X-Google-Smtp-Source: ABdhPJxrm0L18Up0kCD8WqZDsdLtZDpsbuBf9GX5oRdLeJAUH+fDDBpze0tGJ+Zd9PZQHh79BqPRr1gzjg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a17:907:1750:: with SMTP id
 lf16mr2655793ejc.242.1629187898060; Tue, 17 Aug 2021 01:11:38 -0700 (PDT)
Date:   Tue, 17 Aug 2021 09:11:20 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-2-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 01/15] KVM: arm64: placeholder to check if VM is protected
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

Add a function to check whether a VM is protected (under pKVM).
Since the creation of protected VMs isn't enabled yet, this is a
placeholder that always returns false. The intention is for this
to become a check for protected VMs in the future (see Will's RFC).

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>

Link: https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/
---
 arch/arm64/include/asm/kvm_host.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 41911585ae0c..347781f99b6a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -771,6 +771,11 @@ void kvm_arch_free_vm(struct kvm *kvm);
 
 int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
 
+static inline bool kvm_vm_is_protected(struct kvm *kvm)
+{
+	return false;
+}
+
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
-- 
2.33.0.rc1.237.g0d66db33f3-goog

