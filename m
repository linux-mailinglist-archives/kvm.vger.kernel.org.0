Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572DD7C918E
	for <lists+kvm@lfdr.de>; Sat, 14 Oct 2023 01:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbjJMXsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 19:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbjJMXsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 19:48:22 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122FAE0
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 16:48:18 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7be940fe1so40987187b3.2
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 16:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697240897; x=1697845697; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=B0H/DWogKBB461msJyCD0Uj3l81698KKVi8MC7sVdKQ=;
        b=w77lEzLp0DzMA4VU506ejzPsLowH/C3zewUTTJXPYF1euMFrkthvNnVc3xMy9Ym7+g
         SrIQP4zA9ggCNfR2OUu22a+t0Z09nOOLx0H5OeCYlJhpuGJsELpyA3Omth8Ni+P4NOve
         ltKrE1I5YCRBQJ7udxwO+JmP1eT6vLn1NlgbrWtb6B+UQ1EqjwYRnD1Girf1jrzmtt9N
         DSq8t9s/eAxVAQW+VUfKS0hUWvnV3eGOIcv+mbRzRLBFe8okM6r5lpPhaP03s3Q70tZv
         NLhOvp4Zh4h98uT32e7p7piWcUcEV/0xJHB9Ij0g8fnoSfV7oVFN84Elcm78B9LS61+z
         w23g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697240897; x=1697845697;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B0H/DWogKBB461msJyCD0Uj3l81698KKVi8MC7sVdKQ=;
        b=wno83mh7vOXY1CxW95ol+Ce9roHxtsJrR8rvscG2YsrGn8++8Y1daOT93VK7BD1/Vd
         saIHI+jRt8/oIJpjQxgUJ/7Oy8c00OvrMtJpHhbJ5sfxIokPRRltjwk4EuR9wqzDqeR2
         CLpA5hVSN3vpVe4LPmAyLN2Sk7EU2cg+Nq0NVUmfv/CYvt6SQRmtxoKuukiJJtabOSdK
         FQvs5yJUEgpAZNhBD8PoHC8uQWKsucrgTnW6Lp/jPEtSVACEgQKbS4v0NGmCYI3dIJnK
         xJxTbh3qI0x8z/UzI9hzO0hf78GHs5Mr8TnMLcZVdl6ShZIXXCU6jrOFycLXTGn9DMbT
         1KLg==
X-Gm-Message-State: AOJu0YxQHXXoWZmSMUEHfsoAvgya0QsEAlbrBU8D+rNkd2rZRRHOh7/p
        eTTBVhmL1EZWGfCeDyRYflVXQK39jwk=
X-Google-Smtp-Source: AGHT+IHCd5zJ9oHMVPoEjf9Tyr1W5uhUmBT2YpLSDf5qPA13nsbb8WOccqnRZu9B+2s7uN5XcdphKWpX1nw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ec46:0:b0:59b:eea4:a5a6 with SMTP id
 r6-20020a0dec46000000b0059beea4a5a6mr550473ywn.0.1697240897278; Fri, 13 Oct
 2023 16:48:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 13 Oct 2023 16:48:08 -0700
In-Reply-To: <20231013234808.1115781-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231013234808.1115781-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231013234808.1115781-2-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Selftests fixes for 6.6
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please pull a fix, a cleanup, and a workaround for 6.6.  The guest printf change
really should go into 6.6, as it fixes an issue introduced in 6.6 that causes
affected guest asserts to print garbage.  The other two changes are much less
urgent, but I couldn't think of a any reason to hold them back.

The following changes since commit 5804c19b80bf625c6a9925317f845e497434d6d3:

  Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux into HEAD (2023-09-23 05:35:55 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.6-fixes

for you to fetch changes up to 6313e096dbfaf1377ba8f5f8ccd720cc36c576c6:

  KVM: selftests: Zero-initialize entire test_result in memslot perf test (2023-10-05 19:23:47 -0700)

----------------------------------------------------------------
KVM selftests fixes for 6.6:

 - Play nice with %llx when formatting guest printf and assert statements.

 - Clean up stale test metadata.

 - Zero-initialize structures in memslot perf test to workaround a suspected
   "may be used uninitialized" false positives from GCC.

----------------------------------------------------------------
Like Xu (1):
      KVM: selftests: Remove obsolete and incorrect test case metadata

Sean Christopherson (2):
      KVM: selftests: Treat %llx like %lx when formatting guest printf
      KVM: selftests: Zero-initialize entire test_result in memslot perf test

 tools/testing/selftests/kvm/include/ucall_common.h       | 2 --
 tools/testing/selftests/kvm/lib/guest_sprintf.c          | 7 +++++++
 tools/testing/selftests/kvm/lib/x86_64/apic.c            | 2 --
 tools/testing/selftests/kvm/memslot_perf_test.c          | 9 +++------
 tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c     | 2 --
 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c  | 2 --
 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh | 1 -
 tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c    | 4 ----
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c     | 4 ----
 9 files changed, 10 insertions(+), 23 deletions(-)
