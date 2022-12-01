Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459AD63F896
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 20:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiLATw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 14:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiLATwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 14:52:55 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6298391DD
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 11:52:54 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3b0af5bcbd3so26717097b3.0
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 11:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C5a0McCcpuNoh7+abFH/FyD//PHCPdcmVmgtIkm+rNg=;
        b=dkOyk7aLowF4xnX8Rvbrx/SoT9LIgx3eq/miK+BC/MOrbzjqziJVt+kvCfast77x7+
         uvrFhmY1eBP/6qKCUQ0hkSUvgCHIlRnDbjoYLR+x4IEXjmlUKZS441g5vvckbswFMYIK
         v+YkqWk6RiKKOD4U8nKj8CYjVPlggHS+O4KUkcGRW7QqTiCIJriyvacDsy7LNO2i2WaV
         D5AK/eMDyeNyaA69yWc4MBjDe33p/f/NeCFby0xx4zyqHI7vcVpa4QFiLwX2tWy3fcAV
         vL6VCTb/IJWabhNmwy+QIIzvodPDDkL0u3Izx4lSQ5TaZkV4NpNO++Gyqp7XZFpDzB8z
         IRSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C5a0McCcpuNoh7+abFH/FyD//PHCPdcmVmgtIkm+rNg=;
        b=x7cwWKi89oV6dcSIe8EO+MbNA2tIAXnbRYB1JLkr9RWVlK7GzbkDnC2msz/TUXUFDo
         YxDLCSog/v8bBOd3rYdf8ibBWUuJAGN3fqNHjYZvMHeKcZnJBZsJYLK/AM8XfI7UMZrb
         UM+FzYhf+C/jMrZj8HpOIiJxQAjlpvqalTQqJ7+zs5MMvW+f7Q/I1aXvkRJ0v/ALUPOf
         een23ndVQGNXMOIAEscHWil9oTJOI7XWOjw7AkX6ARgB9m1Ri/WykDZnuVi6f2f4VeX7
         1LZFEPgD9b6SNX0qtPVUVXUpvWPZu4kxl/VaFpHq4p9SnP5I8ovR7/xhEA/+xW3weu78
         Y92A==
X-Gm-Message-State: ANoB5pmnJA460gjVKgSRAPhPUvJLyl0sThofiU8CZQb/672OyL3p22Ag
        FYoMPIPIiUO4cHNxomX3AdaK3sKYeeQdew==
X-Google-Smtp-Source: AA0mqf5OJaDmzvLxYqIM8hv6il26qk4XpnSzjurHnRCDWgEU5qGaSFJo4i9u6HvvLp1XHxelOezUTOalVooRJw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:adc1:0:b0:6f7:e78d:cae5 with SMTP id
 d1-20020a25adc1000000b006f7e78dcae5mr18498179ybe.290.1669924373964; Thu, 01
 Dec 2022 11:52:53 -0800 (PST)
Date:   Thu,  1 Dec 2022 11:52:48 -0800
In-Reply-To: <20221201195249.3369720-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221201195249.3369720-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221201195249.3369720-2-dmatlack@google.com>
Subject: [PATCH 1/2] KVM: Move halt-polling documentation into common directory
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
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

Move halt-polling.rst into the common KVM documentation directory and
out of the x86-specific directory. Halt-polling is a common feature and
the existing documentation is already written as such.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/virt/kvm/{x86 => }/halt-polling.rst | 0
 Documentation/virt/kvm/index.rst                  | 1 +
 Documentation/virt/kvm/x86/index.rst              | 1 -
 3 files changed, 1 insertion(+), 1 deletion(-)
 rename Documentation/virt/kvm/{x86 => }/halt-polling.rst (100%)

diff --git a/Documentation/virt/kvm/x86/halt-polling.rst b/Documentation/virt/kvm/halt-polling.rst
similarity index 100%
rename from Documentation/virt/kvm/x86/halt-polling.rst
rename to Documentation/virt/kvm/halt-polling.rst
diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index e0a2c74e1043..ad13ec55ddfe 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -17,4 +17,5 @@ KVM
 
    locking
    vcpu-requests
+   halt-polling
    review-checklist
diff --git a/Documentation/virt/kvm/x86/index.rst b/Documentation/virt/kvm/x86/index.rst
index 7ff588826b9f..9ece6b8dc817 100644
--- a/Documentation/virt/kvm/x86/index.rst
+++ b/Documentation/virt/kvm/x86/index.rst
@@ -10,7 +10,6 @@ KVM for x86 systems
    amd-memory-encryption
    cpuid
    errata
-   halt-polling
    hypercalls
    mmu
    msr
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

