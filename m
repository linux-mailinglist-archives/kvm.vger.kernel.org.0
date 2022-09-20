Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14115BDB8C
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 06:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiITE0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 00:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiITE0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 00:26:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C880354675
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:25:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id q84-20020a25d957000000b006aeb2dba911so1113558ybg.8
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=qjLjZKvyeIeRGOesNjjS3cTK/aOXc6uRAWIPLUpvrd8=;
        b=p9b3BJlyK/xx0kc1n4jrz4NOkmP/E44tN2jGWvb5s0PcagXYBrHqp0hWXeENhXfgwJ
         2hbCkK/TEEJDrE9cLerHKEy4bJxHMyYnD4TcoDDebSFEJGmrkiN1G1VXU2zl1i3EVR7P
         R3gBxmTbKpOCI1llN214a5jPPu38guQZsHPYSaC7UJOIBW+VMHLh9262hNPVm0OpYoj1
         VvfP6S0GIX0iVCv4kGuPKN3sHF/xyJqI6OHsm13M3IcEbtQCEhBJRfdqJ4ZL93wAvD6B
         jaslgqZv8c8XtqOymwE7B8d6jkXFFRG7o8UuSjylhM4xAk9ZbReA//imiAYOjoWvDp+c
         btzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=qjLjZKvyeIeRGOesNjjS3cTK/aOXc6uRAWIPLUpvrd8=;
        b=Y0VMKjmL3MDgnv00BssrNtAB5TETguPdguUPku1eqo/JKOoYigg0ziQabhbLRonNjs
         Xkr6AsEXX89ZnN4kX2+vKFHTiE6OO+cFA0cFosxMGGRVm9es3ppIXkzNXFJP3G03UesV
         R1Hz5xkKgR+7Fxf/Npqu7ZqDCOZOvSc9D3oFBDJvj3ExVR/uQtciHpnBLdQz8sUME1H0
         wPhFrjKQ6532twB5QXvd4//z15dKa8c9MMZbDhUJPuITgJFj8AkeTwWzLgMQT3Sa4lVJ
         pL5mlyBv6WuvsV/xL/c7tMx3vD7d4iIp56vBMyghsNEcq08VMAM8gcoXTVp5eCRXKspc
         zG3w==
X-Gm-Message-State: ACrzQf3UjIA7uyyLd+scMSoFGKC8V4PT83HwfCtOTyyvEMHxr76xXLGK
        IhYSM8c0pI4+LyOj32nJFLjDw59ex4YvzjuinMR3zAT/pKYC/2axLX9xVJOEl9w0RqutF81g/HG
        3snib3rkbC5YUgA4suOPc+iMjT+ix0OTO/OEbSSeg5iicv9cAiIYr9SpiddIiM5g=
X-Google-Smtp-Source: AMsMyM5NeIBoSbQIjYC9IGSltG/CyuMY5IR1gm9/YeISFgoG3OEz5dIPhdCQjt7X8rjyq48WA6JhTpOFQwfzqQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a5b:848:0:b0:683:58d:ea95 with SMTP id
 v8-20020a5b0848000000b00683058dea95mr16671577ybq.565.1663647958467; Mon, 19
 Sep 2022 21:25:58 -0700 (PDT)
Date:   Tue, 20 Sep 2022 04:25:41 +0000
In-Reply-To: <20220920042551.3154283-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920042551.3154283-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920042551.3154283-4-ricarkol@google.com>
Subject: [PATCH v7 03/13] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete()
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

