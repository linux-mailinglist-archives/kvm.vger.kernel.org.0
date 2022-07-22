Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2800057EA66
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 01:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235822AbiGVXsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 19:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiGVXsn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 19:48:43 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732DEBF9BD
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:48:42 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31e619dcbbaso49701877b3.14
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=LDZmz11aCSYEVg05fPmunXr6uAMRHdpGu3qh7wCVrmk=;
        b=VnDSxerR7WLX8t2mlYqAcUKFg5CGRuGUirUTWpEvVqHf6hATzmCFJOfARBOjZEQBxT
         f6Og6vx5ozZX3KH8XI/6lthf7qvMHu2GUKXMTOqlc6h0wdd95aRYV/+M3OlJ0cKy1Z9+
         i8Wo4Yn4Wxg4ZI85nGT2CH4DgSNPA3Qofb89jpu6Y4CxY9UKFUnuyWshApST+aS8wM+5
         mjGzBXTDw7253wEyuFuU+l7mBB4gMUbYrkhol9K+fmvSLxC3Uj4nlUwmtsrbIcODiyhV
         W6nI+xGTLOg3bsm3vHjqAQ5PH4aQBLvtH8U0TnCgrhe3kmHRaC/qV5yD1QLVydNuesSP
         QqyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=LDZmz11aCSYEVg05fPmunXr6uAMRHdpGu3qh7wCVrmk=;
        b=y+o8KH5Lu09zP4VgXLmnwBZ/kihfopQdXnsbK0N+QRXLvgknxI9/3d7mxlWTi4/c34
         d2ePj7rVtgPPWVkpiksQxiQ2762nabiO+ZcGDibOvCIIFb4kDPuv7ZB5Lnmw/kKXJ80w
         gbxnLOKL5MgtGMIpBKAoJjTv0NtPUc/g8MlGxJYw8gbNPgEzN/SPGBlCJUix5vMVpd/r
         916xliTRg/4/mN2FO9ngKQVJ479OKKsof9fZwFaFrw6eiO9jt0OufRYAQQIs/uMvqOi3
         XAwQLo1nvrv0Cyf7K4tnCXPZQ13ZQx4GVpbsappvN7hibJw/cjG1mNvrEL6yWW0zI73i
         WPXg==
X-Gm-Message-State: AJIora924FX3xZ6DtDoLc6B9jRR3Eusvoxpi+3XW8NPHfjc4Vloa3ia7
        sS6o1lnMtYNt0WanKdZqvdnFiFHVWzIMOg==
X-Google-Smtp-Source: AGRyM1uN/09X+oV51ELVoC3KtQ63wgjhD6XYFbwe7uoamv1x+crjWtCyQPxyDzXP29mFPwKB6uBpvQ1nMo8hXQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:2603:0:b0:66f:774d:e222 with SMTP id
 m3-20020a252603000000b0066f774de222mr1916279ybm.407.1658533721775; Fri, 22
 Jul 2022 16:48:41 -0700 (PDT)
Date:   Fri, 22 Jul 2022 23:48:36 +0000
Message-Id: <20220722234838.2160385-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH 0/2] KVM: selftests: Fix Clang build issues in KVM_ASM_SAFE()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        "open list:CLANG/LLVM BUILD SUPPORT" <llvm@lists.linux.dev>,
        kvm@vger.kernel.org
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

The LLVM integrated assembler has some differences from the GNU
assembler, and recent commit 3b23054cd3f5 ("KVM: selftests: Add x86-64
support for exception fixup") seems to be tripping over a few of those
differences.

David Matlack (2):
  KVM: selftests: Fix KVM_EXCEPTION_MAGIC build with Clang
  KVM: selftests: Fix ambiguous mov in KVM_ASM_SAFE()

 tools/testing/selftests/kvm/include/x86_64/processor.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


base-commit: 1a4d88a361af4f2e91861d632c6a1fe87a9665c2
-- 
2.37.1.359.gd136c6c3e2-goog

