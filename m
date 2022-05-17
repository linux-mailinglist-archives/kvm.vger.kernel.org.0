Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEE752AB76
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 21:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352489AbiEQTFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 15:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352462AbiEQTFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 15:05:31 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DB93F30C
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:31 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b21-20020a170902d41500b0015906c1ea31so3191735ple.20
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ecf/OxwjsoOUdz0RU+HgOiOcKGsVEGU/eMrvKCCxZII=;
        b=KU0xRRVFNiKlqWOa2Z9OuzHQAxZ+8ougvy9otCMxFKCQgs2+ihsYR1zLJpR7Lu9XjH
         5xkvGRcszeJanksk/tMrzehQ5tU8Xijzo7GLSMi9Jb/fszBRKGuSzZBJunRC7hOw0Bll
         xBiAqf5pqAiH2Ysu7G+pvJOF0GldY4nNeUqg7tLn9UtCzBctv2S5sXLcgMy7x8ZWA32m
         18nBBfawI1COyXpAYyafiUjcACcH5CUXQmNH4HCfSX/b0O6FyCNTD2jGSZYHCTBb+m7k
         JUaILjAjiGJj36baJq+sqN22w82wpD/jRpVuHTOhFVs4w+L4RLuSY6Z5fJxdgFN4xrQ+
         ppzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ecf/OxwjsoOUdz0RU+HgOiOcKGsVEGU/eMrvKCCxZII=;
        b=EiGAeNOCm+4Ob/086sDpPCWabY426O8Yy6NHX+3RX1GtNWsXQVpegj2wNInrwAO/oq
         6lrE2DQA7PEPGzBw3DDt0qfy9ALgBX/05QufkRHBPX4ZKc9vo2YpVP8sSU7e39CHTItZ
         cgSHtkatlJyo5U7pHpv7RMNf3SF3y6DDHtpRj4D6/sVm1omNxb1+AICZ+aY1W3yt3mEp
         CQIPAUKKwNeoQSxcgVFo3f7nuNf68s7x/NA3dQcc6UzsQlpWEGtUQ5UN41a+PlzelIhc
         fKHlW8KYrHMuB+AnsmPZUZ3wrUJw+Nva8VqcQWU3hjmvzGKC/DH5JvKfPvdxWSk97b1u
         DIog==
X-Gm-Message-State: AOAM533kNUvBOPtamtf+dUqifO1wk8bUwOm43c1TwoH7oQ/UYrGKo5c+
        fW/NCZhJjz3u6Kc5ALmeXoeMipirL7FmmQ==
X-Google-Smtp-Source: ABdhPJxClgy1VBK3919rSE32N8hbc74FsM5w+7jsa9en4gSGtXBSHngQOkgz5SjfxyaDAOJjvVMrd5+EnpzHKQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:33ce:b0:1dc:690e:acef with SMTP
 id lk14-20020a17090b33ce00b001dc690eacefmr37068126pjb.121.1652814330875; Tue,
 17 May 2022 12:05:30 -0700 (PDT)
Date:   Tue, 17 May 2022 19:05:17 +0000
In-Reply-To: <20220517190524.2202762-1-dmatlack@google.com>
Message-Id: <20220517190524.2202762-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20220517190524.2202762-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v2 03/10] KVM: selftests: Drop stale function parameter
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
2.36.0.550.gb090851708-goog

