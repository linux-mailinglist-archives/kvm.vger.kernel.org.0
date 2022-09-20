Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220655BDB94
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 06:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiITE0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 00:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiITE0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 00:26:11 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2616558C7
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:26:03 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id np18-20020a17090b4c5200b00202c7bf5849so456298pjb.0
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=MpiWeS5yT9XQtTMvfOWTUplS/QmLd1Rz7gB7rSz3ANA=;
        b=QxaQjNEOBDnusu2qkcgUEhIz5e/Ww6Dm+kK5u4PD5jYLMNd3KoeWYKMdQ4abBg+IZ4
         DDHAdlqIgfouDwWio46wIDvot2FekExykgoHaDB8achLsH4g9Usx8akp4W+s+eAfHF7h
         /GI6hpsopKlPh07YKMXechsoW+Dxq7NuIbYozTzyqWF4N6yX6Iw017RDq6h/tHWxZmd/
         lpDwjPaY+EM+OmDKbEisojt7Yu/vD3Gkriupmq7bcfNXIma9cLyKYTCCTiCeRaTLbhPP
         r67zIPaskZpvfx+0rfmS/QKGxVlJQrWYEEMRD0l2XxPhYl0vUP2OLEKfcVVRF9Hklat2
         +nQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=MpiWeS5yT9XQtTMvfOWTUplS/QmLd1Rz7gB7rSz3ANA=;
        b=R5OXAKQzKpmYbZ2tnNZiZTbXFjQ64f7xE+J60BaTkxdI0js+mV3h2z8x8wvJXTWBJx
         Yp3YbBSxZIVkHRSOv/arZKez3ugc/moXmidTjvY+rwhHEx4yotrhIXhe+syENoJWYK3E
         AEYNDpApqVU1zNn9/rOMyIzRvGiXUfLo2Y44u4PAaYW1GqfCVHYGIiCi2BO8YwXVHDn9
         T373n1A8eLPht1iu2Y4H75+bXMJatgckmc8HoYKHNt0oUphZY47tgO7wn2+vG+KCmph6
         3EVXUrOaK/YbuTNxsH2I6YUODQ8eOrm8t+xFsBqqXWDr4hb26aAH7Lpu/ajFFbpdnU43
         Lpbw==
X-Gm-Message-State: ACrzQf3ocIYWK6Tg5cwaeW3i4HDCBXKwLGv9G9ag06iColqJTj8YPTSZ
        2GGCq3WABmakfrkPQGrTBOP21laogew1g09V2BTgYK4zdbA1YvxgF6hQtyzSPlWsjD1Cvqxw1+4
        7JpPE9u1iiczLK/vi7DKs8zi80NJyXvmQebG6DW82mBHSXRsxS2Wqi3EKf8FSAOY=
X-Google-Smtp-Source: AMsMyM5SUzY8xCCQhDd0p56bLKQpUUnYjAdA2w6tayk2PFpxKzMRKgn2eI5jMjxPGilgXI82xX9/TMvzwXtp6Q==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a65:4303:0:b0:439:f026:ccee with SMTP id
 j3-20020a654303000000b00439f026cceemr10682373pgq.322.1663647963297; Mon, 19
 Sep 2022 21:26:03 -0700 (PDT)
Date:   Tue, 20 Sep 2022 04:25:44 +0000
In-Reply-To: <20220920042551.3154283-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920042551.3154283-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920042551.3154283-7-ricarkol@google.com>
Subject: [PATCH v7 06/13] KVM: selftests: Stash backing_src_type in struct userspace_mem_region
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

Add the backing_src_type into struct userspace_mem_region. This struct already
stores a lot of info about memory regions, except the backing source type.
This info will be used by a future commit in order to determine the method for
punching a hole.

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

