Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A25060184C
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 21:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiJQT6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 15:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiJQT6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 15:58:45 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1088479626
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:58:42 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-35076702654so119580887b3.17
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=frMbmYegxOtgtF+Jjq9ubWz1wi/u8FMIRL0o35ogzl4=;
        b=FVyKm8AJ9lqnXFMnIVBf1tOS8wOQDtJ+Xy2Uop4XBqDNwL3RFWY+6erwzCG4KmxWyA
         WZy+dunuyl1K6cd9rROWRme5kGxDBVofrIEsB3JBAKNLqikP1XSuHM9j14eHUUeImxqk
         qX1+Dll/EhKGvxElhbloQzt2Lhb7zAmFtayUrXTAoCHswiZl5ohjLjTsqMTTh7zgp3mA
         nhe1psiyPBvpZW/NFmG+yf3uxq0ibbR1GQ59RjnF+lJvUqyZqNf0q+03LpGnBEk9YPRk
         RXbOgoJpQfT9u9z4ldIcQPCmSwQ/sveTptXYaLP+g658y8kJAW218iP5/44HgdcEZA7e
         r+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=frMbmYegxOtgtF+Jjq9ubWz1wi/u8FMIRL0o35ogzl4=;
        b=YceaJ+XH7HYHPA3UyzS6aNv+uBVJfnt6R5FcDRa9XowVnQSpp3HwnptSB9dD2vhmck
         zDl/zN45Gnq6l4aJONlcvVosYsnhCodAB31kUt3WEJVREbqB+c/xF5L/Ul6a+rUAfzuw
         +ZErXr3KZwTdNTQyBeOuSaBjblPgRW3G4zZZ7qZWrTH5M0kV9IYtulPBD9h99YY1U8We
         piQefPrJWpV8dlGnz3sr4LiOb9dsYzYNILsj+598OJZiFoBrWjBhixu2Xpt8zp5Mxzjr
         tmPNgryzv3u4p0oyqpgZS7kfdyNgW9dqdmvrrJkQpAJNd6wuGgPD185Bo4Rj4rg14aVg
         /EDQ==
X-Gm-Message-State: ACrzQf3IUXVnUKQki2SKQDbJW9KiAeO77YgBhRpo2qeviXp6AeywImij
        e2xFo3qn4dLuOB9a5fwfH9LzvI25iI9yoOiuHiun3yaEn+oLu4NUwxd7BmNdY13zM7VlTFgtF1P
        R54JNmcfspgahdaskmc1ZLg8wD1YQF1WIuHdtfy1a3Z85EHnKSg49hnTzUPBHn+E=
X-Google-Smtp-Source: AMsMyM4tK2eFk3WKl8NqSllJ5w9+Cb5/5+XGTB1ov7n5qva2uCfQFWIm97I3xkvFqYDqfYIWH+X6VbW9OzHK4g==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:4004:0:b0:6bd:5cd:9f60 with SMTP id
 n4-20020a254004000000b006bd05cd9f60mr11379639yba.292.1666036721981; Mon, 17
 Oct 2022 12:58:41 -0700 (PDT)
Date:   Mon, 17 Oct 2022 19:58:23 +0000
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-4-ricarkol@google.com>
Subject: [PATCH v10 03/14] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete()
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
2.38.0.413.g74048e4d9e-goog

