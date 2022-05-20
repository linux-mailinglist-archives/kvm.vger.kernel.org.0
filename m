Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B18152F636
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 01:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354124AbiETXdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 19:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354151AbiETXdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 19:33:01 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B02B19FF4E
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:32:59 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id p16-20020a170902e75000b00161d96620c4so3414959plf.14
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xju6GI4UHmGb+5whaNbhMW72VwBo+kXPtVjs0cWh6sY=;
        b=K9W9t8d0J6nFr8X58dID4UIOp0pxQlk60VQsFcW/MHyVMMA2LzSTbh3EA9/wvNmHkQ
         LDXLvASr69ejIHOny9r8jidrE/HFUoxWVq+1vNx0Y5/4RN1I2F7kAeeo/k71XEEA8Y4Z
         0d5BJ5qB5ZlC+3jrvDE95sHKFt7T9+mS32KPfoXQnSm5/9SyUpW8MN0Kk6S3ko5pHRVf
         fnRj5V5MCEqDhpJBfIhb9iAvLFZkhleRxcGmc7KellgsWz0S9ZMBFFy7w2kSlDDYDhor
         g4HNG3JuyGvyKNZuF0x0BTS1xcnQ0z9lvwQzyBRNTmUcC9sgMbO/yO6NRPFE8/tTmyUh
         bsRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xju6GI4UHmGb+5whaNbhMW72VwBo+kXPtVjs0cWh6sY=;
        b=BwuJYwwuQTtbovWTVNcZJHd3zdCH9ACyySPqzlN42lWdS+5cW7EM6fifDeE9ANDxDY
         yKBbg8jBgwG+I+DrH/Uqfp2JzZrodRS8bUbnPZ4KABEFUWtDoFPCjNY/2dozxvW2paQM
         7TM71Ei2+6aljSR0PfEta+5TtMBAQfTk0gv3x7pf8GSwl3NjOiOmU9bS8hTpTOkw+mmv
         eJLMdBcZLWQ010pHx5exKt8d5TzpYwMh4/xRPHUQJp4krJAgKJ7dGN4iFvW+gWaNTeSi
         G0sKUTn35Q8T80Y4ipBxGCwleWFifpXY8/TQ66FdshIpv7XiGoaBjTQbaInhOzwdCdFl
         ++6g==
X-Gm-Message-State: AOAM530RhmbJFfpP7PmFEXVmP5wRREQ75OV+mzXE1jZuWQVLdt7oRENH
        C1Cb+uBEP9I6wbpVaxqpKMA6v+d7j0WiSA==
X-Google-Smtp-Source: ABdhPJw0h0nPIGsstcGnRc98E2t70Gv2DGQJFcGqALQcaaO7BOIIbv0DbCKP4IM6ytF1hFr+P4rNBlR1L0VB1A==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:cc:b0:518:1348:8dc2 with SMTP id
 e12-20020a056a0000cc00b0051813488dc2mr12635809pfj.52.1653089578864; Fri, 20
 May 2022 16:32:58 -0700 (PDT)
Date:   Fri, 20 May 2022 23:32:41 +0000
In-Reply-To: <20220520233249.3776001-1-dmatlack@google.com>
Message-Id: <20220520233249.3776001-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520233249.3776001-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 03/11] KVM: selftests: Drop stale function parameter
 comment for nested_map()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>
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

nested_map() does not take a parameter named eptp_memslot. Drop the
comment referring to it.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/vmx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index fdc1e6deb922..baeaa35de113 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -486,7 +486,6 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
  *   nested_paddr - Nested guest physical address to map
  *   paddr - VM Physical Address
  *   size - The size of the range to map
- *   eptp_memslot - Memory region slot for new virtual translation tables
  *
  * Output Args: None
  *
-- 
2.36.1.124.g0e6072fb45-goog

