Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1C150C568
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 02:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbiDWAHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 20:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiDWAGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 20:06:47 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBEC20E4B4
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 17:03:44 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id j10-20020a170903024a00b0015a1050d608so5585105plh.8
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 17:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sdFwv4QOKQ0jeXWPyN4VUYX/H7RbUcJ0vbpn1yYPEyc=;
        b=RrpFGYvp7DB0zpi/p9fPXe2bKVeiBYp0jhtzVd/kzok9FjMImSds+yJMsy1mPB2jBM
         Pc/25pFrZY9wn6UXYYewXgpC0sErsU3mNJ5kdcRVHUMk4iPjqEatKHdWsfGRe7mx0mwc
         I03Dlvr9fVukqTXpJqC/a0EyG5Sw36fifc9b+eztAm5ig5aY8e5YU+BFiVIES7oK2OmU
         54Sf3N3DoNZeU/lnYZEmXG3WA4g38D6muhtaj+82hlf7g0ygDIRNUdvE1gzxyJ2zhLJA
         I9rhSV5jR6jlLNd6Jl5NmZXTbB3nyH1YbSnsbfq0nBpel/TSYmQysjt1gX4K8nUt1kpe
         MW5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sdFwv4QOKQ0jeXWPyN4VUYX/H7RbUcJ0vbpn1yYPEyc=;
        b=aPzCx7BG0kmbkZuO/Kfjwr3WQXJRyQp+FciCpFN96gTTiD6qnR2HW34HlK4ehX3OpZ
         H6uvDIQnTj3RSCaLHCnwMBcaGfJGkVz7koBbMzDmHa7fCfwXzGS7Jg44cPB5vfj04gQz
         8VzdEKsMRnBM+HwKJ5n9l4e8YoGzj6GZccnpQ9E3IfQwwoA/9i8RflH6BvjEYQf4tiTJ
         4Rxu+tgs2Jg5d0OK8uFBIubKYIl4QxXfxrnyYgua692pKI/HBgjuX3+9wUAyMpvypgCm
         X8xaCuKEZBmgMVet0T5Q1xGWHzvvnSpVS1OgZ7Qzizjwss1a7LCCI+HftlqYZQlKqwIi
         HGXQ==
X-Gm-Message-State: AOAM531/KUHetEK5p7cAuWAHWnVic/V7vP7MtPqBx1HroOHaWoH2JNzL
        ENCuadUvkCa2qPoy7kdzfngqmH0FpP/v
X-Google-Smtp-Source: ABdhPJwyiCQV5aOz4d8q5vkO769ik1uoEnJKBmVI1VlNyGlAUSokwnIIXmeToHFef7GFvLqhbdf9fkhk7QLi
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:4b89:b0:1c7:d452:4bc1 with SMTP id
 lr9-20020a17090b4b8900b001c7d4524bc1mr8190635pjb.134.1650672224061; Fri, 22
 Apr 2022 17:03:44 -0700 (PDT)
Date:   Sat, 23 Apr 2022 00:03:24 +0000
In-Reply-To: <20220423000328.2103733-1-rananta@google.com>
Message-Id: <20220423000328.2103733-6-rananta@google.com>
Mime-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v6 5/9] Docs: KVM: Rename psci.rst to hypercalls.rst
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the doc also covers general hypercalls' details,
rather than just PSCI, and the fact that the bitmap firmware
registers' details will be added to this doc, rename the file
to a more appropriate name- hypercalls.rst.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (100%)

diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/psci.rst
rename to Documentation/virt/kvm/arm/hypercalls.rst
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

