Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6716D5E5999
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 05:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiIVDWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 23:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiIVDVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 23:21:44 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CFA91D33
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:10 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3454647ff7dso67553977b3.12
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=+QOeE+p9XPKEQJzF+WIS+zt2pkS7/YZHn+1BD5zz4Z0=;
        b=luVHMEWPH+Yd5BdgHDoxwgya5Q0SpmEdJATYkEiyfovMC3E8G+6MTJ4QQIf5wjPjAj
         TZoRl+s8E4wk4e4nNwbSa5QsQoKk1DQ7JvQsff1j5NEx6AeLhm6V3Pv6Gyfj3uKRknoN
         FdrC/FQ65AQQpzI+fRfaL0Pi9b8MQxCRSZAyIC1eCKtt2A1ZmLCJwIje1W2y81vzLwNJ
         t+InhbMXzSCw+Hw2noV/0BIyYfsturwqrvLUYJOpWxWP2rI+EjbDhx70Rkn0ss89UBrF
         8ldQQBnVdrXpy9GqZNNt8Pc1HvXWY5i2GKnuNrYknTyXb/BpWoySjsioScqVfK7YuMuz
         gqng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=+QOeE+p9XPKEQJzF+WIS+zt2pkS7/YZHn+1BD5zz4Z0=;
        b=azTZFZWjxq4gjENWzOBqqeS9rQbOtRpR3si6qpsjg6tZbh7EwhUo826Xybr++Yl8cR
         sBTOTzIAxWKtUyoUJjoR6uJ5amRGWk1F08thbt4uUxzReI8lvBpEEB5q/aoHyEaof5oD
         jtPCGzHRUoPiim2FCByt/GJm9/EioxZiGx4E8RGh4pqJQgdiy7rXXleoiRMwbR9SBr4i
         HdsD4vCtfX1224whnr1SHUCmkJugGYlIAPVIyUIJ1kCYS3/3+gy9gK0RxWu8FltZekkC
         fE0JjXlZLBHcugU8/A4V/nwP92wJHZAVpfQvHDyYi0/IY6AJXk6MoLvZuprm/4zWdLS/
         p4Ew==
X-Gm-Message-State: ACrzQf25bnmcZLR0DqdbU6Eswx6jaVsMs1QxFq6v2Vx+Ay05kvPuXOBC
        Sd5+ClpBle8OB/3wBatxO8U/gPUXIDBLGU8aq3otOggF37JxxSTkQaIpB8u2rRNU7/vAb2GOTT5
        /1mJjYYtkZTpCPOg24PXTEeYauFw8ybbsBe89JokAjaj/YO62MXEYtrMrVwsIXeU=
X-Google-Smtp-Source: AMsMyM68RC+1q2crajg2CdNq5asHX1kj7q5tPPmCcQ+GHi7uygjwZsAtKwEv3OK9VXrDqZAMZJiRnna/2X7dew==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6902:70f:b0:6af:281e:39ad with SMTP
 id k15-20020a056902070f00b006af281e39admr1667812ybt.136.1663816749901; Wed,
 21 Sep 2022 20:19:09 -0700 (PDT)
Date:   Thu, 22 Sep 2022 03:18:49 +0000
In-Reply-To: <20220922031857.2588688-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220922031857.2588688-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-7-ricarkol@google.com>
Subject: [PATCH v8 06/14] KVM: selftests: Stash backing_src_type in struct userspace_mem_region
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
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

Add the backing_src_type into struct userspace_mem_region. This struct
already stores a lot of info about memory regions, except the backing
source type.  This info will be used by a future commit in order to
determine the method for punching a hole.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 24fde97f6121..b2dbe253d4d0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -34,6 +34,7 @@ struct userspace_mem_region {
 	struct sparsebit *unused_phy_pages;
 	int fd;
 	off_t offset;
+	enum vm_mem_backing_src_type backing_src_type;
 	void *host_mem;
 	void *host_alias;
 	void *mmap_start;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9dd03eda2eb9..5a9f080ff888 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -887,6 +887,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 			    vm_mem_backing_src_alias(src_type)->name);
 	}
 
+	region->backing_src_type = src_type;
 	region->unused_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
-- 
2.37.3.968.ga6b4b080e4-goog

