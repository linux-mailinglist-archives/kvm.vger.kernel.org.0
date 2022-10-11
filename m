Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B320B5FA99F
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 03:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiJKBGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 21:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiJKBGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 21:06:42 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F4B5A2C9
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 18:06:40 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33dc888dc62so119181397b3.4
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 18:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+2DRG2ktbVgPO8gWevB+QacaOchvfaRovAISZPDw15A=;
        b=Ru9bE6+5i93s4ljKiceTT8ECQbHky9nEIOqC8q7N246aJaSCSRd6yJpd3YA9r1JH3q
         MZNmq1Rh8HknqDV5/Y2ef3KeOA7gbWjKkOJjtZKLNy6CwzObUCvwuJ94MZUdQIdIt3t5
         rld6OQuiY7EwKvi6HlTVjSt8Zzn8vTi/7K8RkPUIaQm+SIfAYNXoQc2gpna93DMy6OhN
         S+TjEJvpHNq292kKLI8g5vsyjiA4WSQ3iBMt7uYFt0nSjVAfsB56XIbr5tgEoyM6Uurs
         Q3Wcm3O2LaM+77RJBgCbdjEBwKVFy++ZvYW3DeyDmySmR7oaC3hawVRK/q2WuRrFpVwc
         h7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+2DRG2ktbVgPO8gWevB+QacaOchvfaRovAISZPDw15A=;
        b=GukmJRVcXnvjxkmkhmxvw+9uWsAkuOk6ye3vi/jTW5t6xxoXwhxofMi+Vk8Dbk1Utl
         uwQTrlru5BA6pxIrpYXbsdRyuppjcLM341zG5f+C1rpu20+YQZQndFBOJ1bXDUwyNAnT
         7WRjcXIR7w4FwM0TkXbNvco/xO792+8txQYdGyV2bZQC+V2vMAW4Zs1G1J7tMzkxJ9Cc
         gMUXc1UKUtoBEfEkXUghp4+wdo6zel/fxpK0ANamkCBeD0rqmu3kDt1gYb24aA0SfKcb
         x6T0HlUvUa5CVWthWprLA52bZMsykAYHTNp9j4maaKpaK1QsqYZqpPsMW+qdx7AUfzhs
         VYhw==
X-Gm-Message-State: ACrzQf1bPtW8/at2kc8oiwynQOEbc+1Pq9c2HYyA8caqmF+kW1/V2cgC
        GEA6+UXUESwBPdb3cDrzFT/eOJDFjxNYWdh+Wa5RlRHOXCsZmxmFum/sMmPT0UPr4LFGlEPdY9q
        BCzk1M3BxRJxCVncpVHdlD8LlG4IfPG9IRqAML/L5Xr4uUX8pYKakYJrGIz62z/8=
X-Google-Smtp-Source: AMsMyM519m9aB8GgfmipRWMBbUudlcoeRl8tTANXBJmjT5KugghKlNS7g1jd54VKWTbbPMxzI7dyinv9UFoveA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:d78c:0:b0:360:bbf0:ef88 with SMTP id
 z134-20020a0dd78c000000b00360bbf0ef88mr8633791ywd.206.1665450399492; Mon, 10
 Oct 2022 18:06:39 -0700 (PDT)
Date:   Tue, 11 Oct 2022 01:06:17 +0000
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221011010628.1734342-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221011010628.1734342-4-ricarkol@google.com>
Subject: [PATCH v9 03/14] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete()
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
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
index f1cb1627161f..19e37fb7de7c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -586,6 +586,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
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
2.38.0.rc1.362.ged0d419d3c-goog

