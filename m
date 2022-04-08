Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609584F8B86
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 02:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbiDHAng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 20:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbiDHAnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 20:43:31 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5B81770A7
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 17:41:28 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id n22-20020a056a00213600b005056a13e1c1so1562203pfj.20
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 17:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4i8vkVYTpMI8sgCODcyEo+cLvfdtqAncn9Gw8372e+k=;
        b=SEvnDyhP5Eaj73KDVpVzZJA7xQaM+5EXBgQvOedS4v7Sp4iwcAtMpm93TDhBlUx8HC
         p39VVoh0d54k+2oHuWizmDPlEUIFVJGOf2bLgWJvv96kgnpWowBMqrggmwcfdF8MTKer
         NUZ7VnB7Yt0BmOkmTtcHh8WAbsM/yjLXYLBWE7z0BdCWtYSRQGGXnlkuv0G3L+o9V5WU
         FCy+CpQWbmjc21VjuGBCu/rEKBOK27LcV8IeX+CXJ23rGfPbQbAAbNNfXNlNaC3zfaOX
         ekanpHOBpTRaYjdr+V4KkNkIKwtsq+cjeDEKdZZczw39vp7vIg1DhPn27SokxJs9rKMQ
         g6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4i8vkVYTpMI8sgCODcyEo+cLvfdtqAncn9Gw8372e+k=;
        b=hLhRiMTraLvgEf1iDVlBCtvaRrhh363VUhgu8R9ZyXJ/yVMo2ZrAA9rt776Mye4a9R
         jOtC0vxUk7MQooBsi/CLbv2s8mNXtbD8P/GFYbh+r5AHyphVZHMcIi/XcjuiCEcpRNEP
         Ch4cq4J4k9ByUyVYk7KjLMRbwnyDgOGeq7VvBiQbMW5rc2WRCr1Jdhmd0FdGQsS6ARQn
         bVIK2tE0RZCi1uo43nyChkI7cO57GP3vbIm93fiBRgBfuPkBxdQ6wkHSIOr/KCsuLdtO
         07r83UNQhbJNUy446ZKjGjqXJ76RsZXp6lF/cxxN/WMOlg2LVp8ufGP0TsEGitKOxB9E
         bx5Q==
X-Gm-Message-State: AOAM532YswDMwO9GCfJM+aS0YcspMNrNN49BluzmGhpYAy48nCLtP0ee
        NZmyEZmStgBQmT1YazkyagZu37W3efX8mWpX8Hv2F/wUxfhdNc7h2L5IhN1/JM0m2Ik8tHkJoaf
        4PhK8Vjw21uHnTaZDtnXxYB+FKVZdQA/qM/XZo2wOfv7Lmzn5da9IXcCjlvaCX2s=
X-Google-Smtp-Source: ABdhPJzen0F2bMdEJMcNp95xTNKQXKaQ6OIyor32CpS2Lnwc27cP2WP3RwfdBMdsdRt73fT1Uhd/kZ6oQLYhlA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:8b88:b0:156:2b14:cb6e with SMTP
 id ay8-20020a1709028b8800b001562b14cb6emr16819381plb.14.1649378488058; Thu,
 07 Apr 2022 17:41:28 -0700 (PDT)
Date:   Thu,  7 Apr 2022 17:41:10 -0700
In-Reply-To: <20220408004120.1969099-1-ricarkol@google.com>
Message-Id: <20220408004120.1969099-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220408004120.1969099-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 03/13] KVM: selftests: Add vm_alloc_page_table_in_memslot
 library function
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a library function to allocate a page-table physical page in a
particular memslot.  The default behavior is to create new page-table
pages in memslot 0.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 4ed6aa049a91..3a69b35e37cc 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -306,6 +306,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
+vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot);
 
 /*
  * Create a VM with reasonable defaults
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index d8cf851ab119..e18f1c93e4b4 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2386,9 +2386,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 /* Arbitrary minimum physical address used for virtual translation tables. */
 #define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
 
+vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot)
+{
+	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+			pt_memslot);
+}
+
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
 {
-	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+	return vm_alloc_page_table_in_memslot(vm, 0);
 }
 
 /*
-- 
2.35.1.1178.g4f1659d476-goog

