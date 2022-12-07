Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAC964507A
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 01:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiLGAhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 19:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiLGAhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 19:37:13 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862C937F8A
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 16:36:40 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3d3769a8103so174801637b3.17
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 16:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=62EGeFEMBZyYp+itlwZq+NNn4g2Is1savivfamQujGU=;
        b=VDhYGGnEhkawbxSr5eKbU7at+thNJzM6vSm941xH9pwMAaDdNMUfwod2BpG6Mo+rdO
         JcJ+eAcdPSwVGX91V95BZrpAc6K32SLyRNnwlnHAIqxYg+1tIgN3BnNAAeLqMbGKRjhd
         FniGuxp8C4sB47Ki5FWVxcUavnUn6RHYvN4030I9jyxg1MOxEnwx4R96j2dAo9XCCNX2
         0qRYE438vo017a1MIAv66YxXd9Fc0ypizgPtYRqNdGCs5mQ3e/BilCCTosNbwoMPnand
         WeXECAYLmOkA/z5yfEY223hAyOG/HeP0ACTKt6Ep1O6PYRNeH6+tNaYDIMhxnOT4Anvu
         D+Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=62EGeFEMBZyYp+itlwZq+NNn4g2Is1savivfamQujGU=;
        b=KmkMNzrzGLZBvNxrD30bkURLDdACc/ZRjj7tACijxnr6EpH0ajF1Of0w2zV1KDFcyG
         yemUVBMxevEr7BZ3nZoDT6PIuo7OhvBc/sbN6EP+S1xYaUyCmwGxo3SZdkJX8wK1ZMBZ
         3bHMyyTkjxFj2/EtWQMDIPWrWpNO/6eFUgu2c2lBFzm9fVxaMlxS3mnsRpkKheabI3wd
         M9Jc7XMSSfNQ4aSeGS9O9GFmNny6/blkQW4mclrIAQVdLOUEhSuxl0nbrsJhLO0H1qyw
         x/a6oEbBsOcyrD+kiiVIvjJn6rzZ0Fi8S5ad1jAH5jEyEO7YAmhwckHTMVme65V17zl9
         76RA==
X-Gm-Message-State: ANoB5plEw9La3902XaWDNHePJFSPLfplZbcxpxZ2Mu77Pz/N+AXJ94GK
        RInk8+I9HEg8G2rS+Ph+jHJZVINSPHQ=
X-Google-Smtp-Source: AA0mqf5LgkbBbvGM/FL/y/jn9/jCI4RrPYc1rQe2nCJ2Hu9CnlUuYpjEpmCoRq8+o4LtrnyOcLRLvW8HjTg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:120d:0:b0:3d5:ecbb:2923 with SMTP id
 13-20020a81120d000000b003d5ecbb2923mr29309362yws.485.1670373399803; Tue, 06
 Dec 2022 16:36:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  7 Dec 2022 00:36:37 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221207003637.2041211-1-seanjc@google.com>
Subject: [PATCH] KVM: Delete extra block of "};" in the KVM API documentation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Delete an extra block of code/documentation that snuck in when KVM's
documentation was converted to ReST format.

Fixes: 106ee47dc633 ("docs: kvm: Convert api.txt to ReST format")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c618fae44ad7..6fd348f88700 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6575,11 +6575,6 @@ Please note that the kernel is allowed to use the kvm_run structure as the
 primary storage for certain register types. Therefore, the kernel may use the
 values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
-::
-
-  };
-
-
 
 6. Capabilities that can be enabled on vCPUs
 ============================================

base-commit: 3d7af7c5e000c68581429d533ed63414e4a48e6d
-- 
2.39.0.rc1.256.g54fd8350bd-goog

