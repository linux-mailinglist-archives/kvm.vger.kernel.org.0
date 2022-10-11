Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50705FA9A5
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 03:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiJKBGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 21:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiJKBGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 21:06:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0673F5A8AA
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 18:06:46 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u16-20020a250950000000b006be72659056so12067289ybm.3
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 18:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NChdwDXJfPmnfWf5atW/Yp9il5xPVGNMebBCfEdWL2k=;
        b=UkcJ/bp46qwS500IUMujefCobrQShOfuHj8ioURU3a0xRbWbiAY1dJoK1tX+sNtP7T
         CxqJV0TdJjgLOcXmL2VYIE88pJHrCcVSAno3rTBfypXy9epKFlZfxIB6U3TkUx+Ct/6/
         Lb348Bq/LWI2EvD9u2tDQF93FpdduOF1jjL+wMv5+jU2mIXLqg0PjXfVJdA5r0nI2gCR
         MpVB7KFa0SrftyMS7OlytdguZ8mjXhb8fCxo5BAIiDEWdHcJ820STx57+6hU5d3myWRp
         uWQinnUUJs4HUVh/fvW/4AjczmuWdPPkEHt6MxzKBMGeYirap0BsWWRr+qPTe+/tkdOM
         c3gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NChdwDXJfPmnfWf5atW/Yp9il5xPVGNMebBCfEdWL2k=;
        b=XXpaCuzcG0c6PCrjqWvczCat1mETjox5k95+fGSGSuBq0bIYQCJUmvtYY2XPVva32W
         ax2iErw3fhcym/w5UUEaKVnFAPoN8N/TytkpLPrYvcI6QcmhaZR+py0SmV1hJAC6MMKX
         I3P2YsmuIqACYx+IsGCciNt1TSWZYduACkGP10ZrXu34OqmJ6kmlQ1YPHHYogrtSGVdX
         zvggg6PQhx36TA4UWcndJbUsq7CJplVBP/6PJPq+6hsRHoahCuw/UykTN6kw/cMgw1oh
         EF1pHlUQECIYqKAVBNONwDJUto8LUHQAySIMXBNnIczLXgrdDnTHMefdXAS24/SmBh3S
         uYRw==
X-Gm-Message-State: ACrzQf1ih9auU8+H0qr2TMjsy/HPDhoYXSe1WOexfCLSBp3hmFciigvo
        K+88CHPDjmYNcOJX3uLoUiTkHHoBuxr6TqSkXDk8U9o1W9c6xspSV6Vft+SIBhZAvD0rmU+t5Pl
        ddas/8dhFpWEF183gPlYRUoSFN2TKqFKEzvyqDk1lAwx0MdTIw+qaZWTKN674Vsk=
X-Google-Smtp-Source: AMsMyM6DvDW7RQp/vT3H4oz3eGzG6d941XFf+LY4Plq3XF9A4zKfPJxqaSk6SkRxtj0iUkgns4BqjOw8cl41tA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:d7c3:0:b0:6be:28a9:b8ec with SMTP id
 o186-20020a25d7c3000000b006be28a9b8ecmr20504274ybg.443.1665450406087; Mon, 10
 Oct 2022 18:06:46 -0700 (PDT)
Date:   Tue, 11 Oct 2022 01:06:20 +0000
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221011010628.1734342-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221011010628.1734342-7-ricarkol@google.com>
Subject: [PATCH v9 06/14] KVM: selftests: Stash backing_src_type in struct userspace_mem_region
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
2.38.0.rc1.362.ged0d419d3c-goog

