Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F465E5992
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 05:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbiIVDWg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 23:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiIVDVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 23:21:43 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CAE6DAC2
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:05 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y5-20020a25bb85000000b006af8f244604so6970509ybg.7
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=qjLjZKvyeIeRGOesNjjS3cTK/aOXc6uRAWIPLUpvrd8=;
        b=kF4yRiS/Rd5ThscLooK8PSbxVEKD+XJPZZemQ1CB4rSRDSOlf/5CLq0rgxG0Iqoq4N
         IuwFx01fTIxVzcYe7oZRxhOF3e51bSQc0lgkOlvjRrMC287hpEqGHWz/Dlc+XN7DjEzm
         xdKJBwX3MX0Vxcb35Ke2lH1GbqMSO+YQyrNzLltFHmOzYvg0HqMxOker8n61wkBfN5IZ
         BjQ8u1giqEVt783IdBSzR6KlLQhe9eMNBoryTt2Zg9ZsKDcHBYAQYTXa91eTuPuetFFb
         nOc6tREpi27L6D/JIEVc3KWe0eYIl/kUxkLdomlx8SkK27KtRkEMSMqtNlnV6JOoszEQ
         VsIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=qjLjZKvyeIeRGOesNjjS3cTK/aOXc6uRAWIPLUpvrd8=;
        b=ZHbQleh5lRIQ7Mvr9OAK7cN4T/I817Y8d7cDQT1NnE6IBNYiO4KiJXtEeNlcm/EO9Q
         eCbjPZJuJwu+YrWuLwu9KcBKLRo6bEy8yO3+xS6dAudmCRJGWoGAsuI4dox4MOX9UFfb
         LpwUMxXfqcCqB2b9+RdIgkLydeELw8d+vr4v1wzsvbsOz+qkPUCxdBEs2hfhN8dYAtYV
         z2qf4HnGKSyexwM8Pkd+ao62lEJMKZqP5kHj3pBZJDmrOcP4r8otQuFQLibbClbEwc+o
         RkIC66MlR86keAEOJwcsBrd/6tOXMIF02FkOMfDpLMza9IHSAqbdw0sHKYOUVEf8bnur
         aBcQ==
X-Gm-Message-State: ACrzQf047SwYvPctyoLJRZuoI4gr25ojY/ms91GSFg9x+lKYkULdEmlc
        0zbJwlojKBZWl3ZyWBvMAl8LC4/60SdzNUOecLGPRcKxHFH+cYF9T0FfVAU6G5tQpibwrYrk39K
        3bM9wBhU0pqdrzK75XKvresWXEH/dcp0hNMhIRRwTu3A6cpTSbvHsFnXqrrtqUo4=
X-Google-Smtp-Source: AMsMyM7PMMbrQ4oKyuP+30wOQa0mWaPz18dLT/Ogo59kam5aTXyJF6FbF/krZJb3XY3A2cxtntFt+PqH2J0x0w==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:2d4b:0:b0:6b0:cc1:8cc with SMTP id
 s11-20020a252d4b000000b006b00cc108ccmr1495774ybe.570.1663816744338; Wed, 21
 Sep 2022 20:19:04 -0700 (PDT)
Date:   Thu, 22 Sep 2022 03:18:46 +0000
In-Reply-To: <20220922031857.2588688-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220922031857.2588688-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-4-ricarkol@google.com>
Subject: [PATCH v8 03/14] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete()
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
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

Deleting a memslot (when freeing a VM) is not closing the backing fd,
nor it's unmapping the alias mapping. Fix by adding the missing close
and munmap.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9889fe0d8919..9dd03eda2eb9 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -544,6 +544,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	sparsebit_free(&region->unused_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+	if (region->fd >= 0) {
+		/* There's an extra map when using shared memory. */
+		ret = munmap(region->mmap_alias, region->mmap_size);
+		TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+		close(region->fd);
+	}
 
 	free(region);
 }
-- 
2.37.3.968.ga6b4b080e4-goog

