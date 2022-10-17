Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C30C601852
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 21:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiJQT6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 15:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiJQT6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 15:58:48 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0127786F9
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:58:47 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id q18-20020aa79832000000b00562d921e30aso6595184pfl.4
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f+96/JvEAuWePUN7O/aZOKRhlXrvVXfk8Y5jpPQ95es=;
        b=fgWWpUPTATZoObqhmudipHE1rbimOoJyI+54OfwH0kvktKoHrRezhrx8scWRrlgMw3
         R9fqTrITvnJxkHRGObhA9IygDkwfDAkNo5fZW58sIZ9j7CkQCf7yKBSSBOzOlygv3cEX
         WqQqU2nOcWbJnZnUqakS42G8OGsJ1yEQ3sl4cEpytYa+dH63gdc08lDiNWKEEtToWTiG
         gDkhd6zCSHx2QEbNkAAlw0pSB+KQ1K/BnEIypAUi+drLyyjBB/UqJI/pjgYlNGleGayr
         wVamIBpZzR1ep0WZE7pYHhZXtx9d0noSwsAqFq0yLs1MOARtOloT/o7sqRgUK+vYl5sr
         ot7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f+96/JvEAuWePUN7O/aZOKRhlXrvVXfk8Y5jpPQ95es=;
        b=WYyC2Jayu4dswDkRvgnH3l9TsK4ym6LyZM7bSyBbg4gVsGdHcxEQTaOU3g5QC22t+f
         4+V1MWKeMS8x/mE3NvKzLFNFtOjwk9R40Pe6Iwrp6QS9XikZzQAujecvK+GrQ0bGaodl
         7cdoaKmL+8OShjRxFT3sQMobQv0gPmV+xwp+FWJyrTjbcR0olRHgGD9EwMqxSubFmrzC
         1RsVncH3jSQlLqnUhc4kvFCBZyEVKczuFhNsqycsmSlflsaun9jvXillVYrTD9QIpCXS
         PcUol6giDEu3uQdI4Cme4wvqL+o2A8jCgJRdkOn5kepuA4e8VovSCBSg8RU2+f3aNSdw
         CLBA==
X-Gm-Message-State: ACrzQf1lCKlxuEQm9XTsZHze7OQoT3wPQKAgJ5TDQVWIQuYDXuAicq9Y
        WENG3mWFCQSso3KA90EbA8ehp/gmXcUo9ZthHDWkdV4KCvbfH6t7PAm0g7G5P46U88eTa4ALSkL
        keO6rIstmzKsC+3EFq4gptNPkfIdD/tnFtYD41luxaHwgQrUj/O55DZ62KyIVvIQ=
X-Google-Smtp-Source: AMsMyM4H8tFUm5rFlQxBAMa9WbaF7a7ibX/iAyJ0SH1yF0izF7uxbK7MzSL5/AADU6b1oJGCrLQySyhxETmSLA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:e52:0:b0:438:ebec:363e with SMTP id
 18-20020a630e52000000b00438ebec363emr12257328pgo.437.1666036727104; Mon, 17
 Oct 2022 12:58:47 -0700 (PDT)
Date:   Mon, 17 Oct 2022 19:58:26 +0000
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-7-ricarkol@google.com>
Subject: [PATCH v10 06/14] KVM: selftests: Stash backing_src_type in struct userspace_mem_region
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
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
index e42a09cd24a0..a9264ed22cca 100644
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
index 19e37fb7de7c..6affce47e899 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -929,6 +929,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 			    vm_mem_backing_src_alias(src_type)->name);
 	}
 
+	region->backing_src_type = src_type;
 	region->unused_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
-- 
2.38.0.413.g74048e4d9e-goog

