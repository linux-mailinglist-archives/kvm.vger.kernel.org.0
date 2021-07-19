Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073CB3CE4FC
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346995AbhGSPrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350252AbhGSPpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:45 -0400
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B356C0225AF
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 08:38:07 -0700 (PDT)
Received: by mail-ed1-x54a.google.com with SMTP id m21-20020a50ef150000b029039c013d5b80so9548591eds.7
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 09:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7wkujqQey68d/8KAgY7QxLbL3Tk3E6zx35InqbFhZk8=;
        b=cI1pqIS70PpjVvFSr5jOtpULbEY43W4Q5k3H2M3+Pe6zycfUQ8J+47luWmyhdcQtj7
         LNxHqrAvDi7k9ZrQ99sbopcAZrp3nHUyLPCcBPNXNHZvx6IO2Sjq+TT+uUNxgcRWX4D0
         hrK/zoz2PS3l1iEKbpT8oLy9lelodxEKSRRmt9VX3F0p6thfu4rojU+4Yd/qLgMHp/ez
         VpGefh79ZC7n9pleIODX29EDlrGxzFeLjbnMF+IlxpHlSfvFqr0ESZ0EtoJF7DVEoOGw
         ZvzS7Ubj2jPwojVsgNF86jX6jRATNvOjxY9RH1HXtLXAJxT+9Z3pMek+apc2yM7iYbcI
         +qxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7wkujqQey68d/8KAgY7QxLbL3Tk3E6zx35InqbFhZk8=;
        b=MN8xXu6jl1AfA11M5yYPqEdmQ5gDQz99ATAcHFH6HMtxVBsKWejKfTYq1aTn4hCPrC
         XBcu4xWP6uS5lug0AOHkhKeaQ9IyJpDjBfYyCFgkcP+9HolHbuQkBXqsL2yqiASYS+zJ
         NzZhAKeAiXagoPjBv+TfA0uo8MSojcbjU0CIV4+Vf1Qxs+zs+iF9yrhI3qb+3DHiMjEi
         L+Res7kkQRxdC2ql8gQB51GRu5qv+oNYTcC7wgcKDxZkkzDwL9LHp6VRieht3hhhu5NQ
         c2AmtDBakNGA/WD3K5RnON4swCHktnT9RMa5Ff81mY25crQV+yBGgZgf75M+ex5SNOwE
         relQ==
X-Gm-Message-State: AOAM533CrfJCBULfS1g0Q8hwqFrA+mbUq+R+LsxU4x9jE7Hef2rXGZ0G
        uvzenxDN4ocC46aUfNHCrB8/FljJ0Q==
X-Google-Smtp-Source: ABdhPJw45jb2VfQ2x2siX2+8lyhQyXfGajRdkU6yAqPnufGi+Y4rw/053/SjjPHbtJCrsvDdQe7auRMpSw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6402:2228:: with SMTP id
 cr8mr35901384edb.309.1626710630758; Mon, 19 Jul 2021 09:03:50 -0700 (PDT)
Date:   Mon, 19 Jul 2021 17:03:32 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-2-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 01/15] KVM: arm64: placeholder to check if VM is protected
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

Add a function to check whether a VM is protected (under pKVM).
Since the creation of protected VMs isn't enabled yet, this is a
placeholder that always returns false. The intention is for this
to become a check for protected VMs in the future (see Will's RFC
[*]).

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>

[*] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/
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
2.32.0.402.g57bb445576-goog

