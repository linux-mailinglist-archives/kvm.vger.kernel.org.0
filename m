Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E69A720753
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbjFBQUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbjFBQTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:19:55 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DCBB6
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:19:54 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5693861875fso24618627b3.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722793; x=1688314793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lyZUHE9/fyNrrbCY+2awKzeCg8s/o8YA8lAkE85HkUA=;
        b=5KQr/N/vL8WS85s3yvYVvDH060if/rqEHZclIifsEOMW5RjhqBu8cEpUBR1EsXAJiK
         CvAmfgCxBqe1xlh4pYKqPw6lv5F6iu5NTPblKg3PzcP/gDnSvHBIknCqxnTw0VGCB/d4
         ekH8oK3P/gn+D/e55I8dkJuesutlDZnHIl10n2lRL3MHVShuomENwFNhrUHIE6IKzxCY
         W1dAyBDugyJdrO8giQIfmhpNxMO/scWRsdfG64Uwd52Xl4B+MoacP0grXr+LqgHMpgm9
         CF6cBMYk3xRSzR7CZxX5Zufji1l7oszkaYIvfyFFsvnamY0fqemW545JacjhVd9ndRi1
         Pn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722793; x=1688314793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lyZUHE9/fyNrrbCY+2awKzeCg8s/o8YA8lAkE85HkUA=;
        b=ebYwsWBdWlZfJGjXWCbw6d8u+PfNiU5RrAstReZKxri1wZB7eUMrgXCI1IsXoAfa33
         i6FyqKCwM23b+e4++etbH2BH10ULf6aKklL1e5k9QmHlPwC3inKFO/iul+f9c+me/8MQ
         2h2n24TZescZBum7zPMOJphjorTCnoAqMNi979fC34+LBFqw0fRaJqxglL/gTVI4gSXq
         JcDvXmd84ur2wbl+qY2Q4DC3lh4xKB9jKWBLb93lco7DFdsGGaZ4R9Lj1iw9a7FfaQzC
         ySLUdAgSh2foqeFwbh5gnK5Gv5PJsacRVLJervWWGAT86X1oGUJg54gP81Ew+WBbUqCN
         Gxxw==
X-Gm-Message-State: AC+VfDw1b2OXFyDLeZc5qWPMZ6FG4L9sXROALBGGnj5/PNsSC8XOwjHw
        4w2pwSiOUGhchxuujiMz74NNlbWrGMDMyg==
X-Google-Smtp-Source: ACHHUZ5xagS7Qj6bDef2zTXcmIPJ0OibSez/salGei0Ga5GomMaZ50IiZeSgtu2e40duF3DhLlFNe55hQwjkDg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:b512:0:b0:568:a244:d8e5 with SMTP id
 t18-20020a81b512000000b00568a244d8e5mr192120ywh.9.1685722793529; Fri, 02 Jun
 2023 09:19:53 -0700 (PDT)
Date:   Fri,  2 Jun 2023 16:19:09 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-5-amoorthy@google.com>
Subject: [PATCH v4 04/16] KVM: Add docstrings to __kvm_write_guest_page() and __kvm_read_guest_page()
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
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

The order of parameters in these function signature is a little strange,
with "offset" actually applying to "gfn" rather than to "data". Add
short comments to make things perfectly clear.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 09d4d85691e1..d9c0fa7c907f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2984,6 +2984,9 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
+/*
+ * Copy 'len' bytes from guest memory at '(gfn * PAGE_SIZE) + offset' to 'data'
+ */
 static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 				 void *data, int offset, int len)
 {
@@ -3085,6 +3088,9 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
+/*
+ * Copy 'len' bytes from 'data' into guest memory at '(gfn * PAGE_SIZE) + offset'
+ */
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
-- 
2.41.0.rc0.172.g3f132b7071-goog

