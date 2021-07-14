Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57A33C93D9
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 00:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhGNWdc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 18:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhGNWdb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 18:33:31 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED853C061760
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 15:30:38 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id j17-20020a63cf110000b0290226eb0c27acso2710288pgg.23
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 15:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oy+6fSOgVvelfBYqm9I93gxvw6Do50+x0vRkEpIyCfY=;
        b=tz16AEtKfG2EUdC15bPbUk+WUL8riHoR54VGvb+lkRLbJSzwSKPUphDFP2c8XJB2oD
         tRYeCifFwWDoNGRPbOXzhhikKdnEbrV+GSotLdSVMUToZ9YZRkeyBxMJ2fGBXQVSsO/K
         CES1+CuKoDT1pf7ZHWoVYbxUSeqhJo64Pp0QRbSgnD1IltKWfSHsYw/I46T2ge7j91fu
         wTffFeqfZi+q0Ejvj6N6HCQObQkcXDAYGTcT77s3U+QmKH9wk9M5r4wUFq7pXrjDGmFq
         nh1G3rMYh80gn1phbAK8odckwhq3QmEjs9AZA9nzXcUwXS0di14/5auHXCNJ1ZJeheAY
         yOWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oy+6fSOgVvelfBYqm9I93gxvw6Do50+x0vRkEpIyCfY=;
        b=jn0e6un98cVrMFqMuk+oPr9gEIlnyKxUFp8a8wspttWmzn3E1S9f7rjs4Uf1V3CYPG
         j7w9oxdbZLQADEzokGXQN0vDgYzC6rAYBoUaRwU8BtqjUF/4kse7Z80+slWPfYrkXKA+
         e1vBXjmUh/V/2M+42cC0sqn1eiWT8D+0Lq3sChLOP18tqRTPdFkypGO64XeybcScTdgh
         Zz0uUHpmOUHadxQcJ6juM6FaDZnTXnZfvYOOO4803yNuRHd6U48Qm8t1ioVr64IhVUH2
         52SUJjwy3MPfmFelFtVDKG0Np/COG6cvaPYUhCgPxNyzoNfhIZNzs4Lr46G6Q6sz3fyf
         saLA==
X-Gm-Message-State: AOAM5304Ag9rJEKxXZC7xyFLoHE2Ro/IULb0tPoB9179tr1iO41wv7Uv
        XclVwiQfYuXuWqyAJ7+3vV4He/tOstkJ6JIB+tzi2HMMcCjAaytlhfkefZnzSb8Fli0aIGC6HtO
        A8Bd0ry3MKhRcNcUb5bpkQUqv8vFHbTDRL2d1GWiTF9kXcP3BRyL6qAcdsGDz7kBOmONWyMQ=
X-Google-Smtp-Source: ABdhPJyiuRd2/a1tYiN3eAIKGn0ap+o/F3PZnCFaTGnmlVbtxFslorqTMKuMd+q3l23RLWc4YyKMa8KF4idDns/yFQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:b288:b029:12b:533e:5ea0 with
 SMTP id u8-20020a170902b288b029012b533e5ea0mr209491plr.44.1626301838387; Wed,
 14 Jul 2021 15:30:38 -0700 (PDT)
Date:   Wed, 14 Jul 2021 22:30:28 +0000
In-Reply-To: <20210714223033.742261-1-jingzhangos@google.com>
Message-Id: <20210714223033.742261-2-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210714223033.742261-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 1/6] KVM: stats: Add capability description for KVM binary stats
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The binary stats capability description was lost during merge of
the binary stats patch.

Fixes: fdc09ddd4064 ("KVM: stats: Add documentation for binary statistics interface")

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 Documentation/virt/kvm/api.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index b9ddce5638f5..889b19a58b33 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7241,3 +7241,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_BINARY_STATS_FD
+----------------------------
+
+:Architectures: all
+
+This capability indicates the feature that userspace can get a file descriptor
+for every VM and VCPU to read statistics data in binary format.
-- 
2.32.0.402.g57bb445576-goog

