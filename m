Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235B06E00F7
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 23:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjDLVf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 17:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjDLVfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 17:35:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F627DB0
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e199-20020a2550d0000000b00b8db8a4530dso15857153ybb.5
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335320; x=1683927320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wl6iG0DOT7sovg486sG/qtkYJxnYf7LGgKWwCJBoMuk=;
        b=e6oJMJAXHkG1GgpSvcna+UUqOW6jAVvShZ5EdXAucj6cFMXDvMYAc7fhW6BNAkflBZ
         gm9HtIbwRa7Mr1HBJgRmG0sivVcTDY1okRzGulVzvhKujEyWGbAYRj86jyOiqogTK+HX
         zH8eZ3I8wLGkEHq1RFtbhG54176VhNBW3ppd1Ufcer0GgeLbG6KjSbVn/r4X6GGrQIQD
         A1FhT5EwCxIJqg6EK4njGOlZSUi/o8lzcPsHzbnG0kbKu5XN+8lpYIaw2cgMsvSarZ1I
         K4RUM2haY6aKr8ttVscTRXWARYqk68+ZtfFUhh2enJPcDEUR6B8Or5xBWdMFY2O3GXPG
         6Qzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335320; x=1683927320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wl6iG0DOT7sovg486sG/qtkYJxnYf7LGgKWwCJBoMuk=;
        b=QXRQoGeExmaSNb8/VhQCBsgUIKg8/F/acrY4XtdJiD2VfwyVJKSnxabqA4PsFL+F2M
         tmAHH69LPmpQgUTKYPAI8F8zF4zX9FT5nCuMirNjTM0u4Agh09rJgxEUe7MVO5fGCoUX
         Jov8CYEZCIQVD+hxAKPWpRVEHxeeKppjIVaH0VpdTWXHk0hqgV/JeGnyBtpDGDV5JJys
         gTr5NWjeHuSbM1Rpe2BJRw3jcaxbtLLRx1kEo9kI2Wy5qkZd7wnKBeM9bInF7oKwoQVv
         DucDHmYLHaAmHlu5GP++g6e7mDz/q4rvciL9gIFNufgOUlcdBH037RDYBBOC/OZ1yRWS
         4B+Q==
X-Gm-Message-State: AAQBX9cqVth4TGxJ6oyLwQlFy17eoL9Uky7KYld0k1vFczMi289mzvkp
        ae3IodcVi6hjfpnO6L8jY2RG2QytBETMAg==
X-Google-Smtp-Source: AKy350ZEHPQmI8hm7Ol6t1Lr3Upb/g72LKo6Tr5VDajGP6irllnJy24C2tTFtoEJLO01pwL6l2QifUQCzDsdNQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:40f:0:b0:b26:884:c35e with SMTP id
 15-20020a25040f000000b00b260884c35emr3043114ybe.4.1681335320281; Wed, 12 Apr
 2023 14:35:20 -0700 (PDT)
Date:   Wed, 12 Apr 2023 21:34:54 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-7-amoorthy@google.com>
Subject: [PATCH v3 06/22] KVM: Add docstrings to __kvm_write_guest_page() and __kvm_read_guest_page()
From:   Anish Moorthy <amoorthy@google.com>
To:     pbonzini@redhat.com, maz@kernel.org
Cc:     oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com,
        amoorthy@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

The order of parameters in these function signature is a little strange,
with "offset" actually applying to "gfn" rather than to "data". Add
short comments to make things perfectly clear.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f3effc93cbef3..63b4285d858d1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2982,6 +2982,9 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
+/*
+ * Copy 'len' bytes from guest memory at '(gfn * PAGE_SIZE) + offset' to 'data'
+ */
 static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 				 void *data, int offset, int len)
 {
@@ -3083,6 +3086,9 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
+/*
+ * Copy 'len' bytes from 'data' into guest memory at '(gfn * PAGE_SIZE) + offset'
+ */
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
-- 
2.40.0.577.gac1e443424-goog

