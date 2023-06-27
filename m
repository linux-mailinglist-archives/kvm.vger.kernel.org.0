Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D543273EFBE
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 02:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjF0AdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 20:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjF0AdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 20:33:20 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACDD1716
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 17:33:19 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53f06f7cc74so2132540a12.1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 17:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687825999; x=1690417999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=M479X8BzT9EyUvB0vw68D3v0mDUftpC8reH4txRhECo=;
        b=0O/XWPOLVoN2w0+hzLQL+azS/KKmtaprESqtEKXNCzBwucOBeaSz7X+lvxgloL/1jq
         ourz/nDRhpUg413NFvJY+Y7+hmJQdpEa6vcKD+f74sXGin+FQy1qNXy6AyGulm7iP+J2
         3TPQg7GioLLuhC9RgIkjYSYCFerWY0cyNiG8lGcLu2lSZ7gF/1zlh/FI9SXSGrWo8Xxd
         jG97Tg2y2hHEfmUlVL965hFTiFZP4iZi233sQMNVWF0nKQcOc6lL2Jg7ABF5zopazzG2
         iKjWRhkCn3vpC1UrH6fZEeAq+5lm8CJNCsZxybVvZOay0Ho9Jh3dXfXYsdgCFOFwpX6M
         Pvsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687825999; x=1690417999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M479X8BzT9EyUvB0vw68D3v0mDUftpC8reH4txRhECo=;
        b=GRO365XM7p9+mU4ofS0BcihvVAHf3hWShNXUO3a3xGW+9/slXW5NjhETrIrFJiWj1M
         cpRUChfzPUzLmq0JMGemB88L+ipbWvzy+fmt91v8C5c+iCMOpcCAuO7+SuiV24XkPuV3
         0iem38BFgICIWaFbSEWAoyOPgGUOTSddPpivhOeqglUDJO0KCsR4LXz2NAPi/LhpxcLG
         mPsGL2p3hgJustS1XbJrJASO/Qyz0DDft1j0wsOedEV1rhEDDTrPEYexcAMYYfnBPkuj
         X0r/b/BH6oyp1MEvEDKapS4oIRqg3DmK4qDE37N1dOufcJKlBAfKIc2bdbl8tinrBf+O
         0QPw==
X-Gm-Message-State: AC+VfDxLEqPXE21rmzM23likxBogN8GPtQHgJ8mjTplVXrkee7vXYwq4
        57xv439SABBxeFBjwe3XmEw8RfLwrVE=
X-Google-Smtp-Source: ACHHUZ47i9u3jKY14hSfci3XHhcjldznPlh6ukEG9NZLO9YA/S51X3yh/on1/0gUINqCaX8SWkaklVmBlaM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:f902:0:b0:53f:9a37:c199 with SMTP id
 h2-20020a63f902000000b0053f9a37c199mr3422081pgi.1.1687825998948; Mon, 26 Jun
 2023 17:33:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 26 Jun 2023 17:33:03 -0700
In-Reply-To: <20230627003306.2841058-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230627003306.2841058-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230627003306.2841058-5-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Selftests changes for 6.5
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
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

KVM selftests changes for 6.5.  The most notable change is adding dependency
generation, and it's also the one I'm least confident about because my Makefile
knowledge is abysmal.  Please give that one an extra pass or two.

The following changes since commit b9846a698c9aff4eb2214a06ac83638ad098f33f:

  KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save (2023-05-21 04:05:51 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.5

for you to fetch changes up to 5ed19528db8ddcf0113d721f67a381be3e30c65a:

  KVM: selftests: Add new CFLAGS to generate dependency files (2023-06-13 14:26:22 -0700)

----------------------------------------------------------------
KVM selftests changes for 6.5:

 - Add a test for splitting and reconstituting hugepages during and after
   dirty logging

 - Add support for CPU pinning in demand paging test

 - Generate dependency files so that partial rebuilds work as expected

 - Misc cleanups and fixes

----------------------------------------------------------------
Ben Gardon (2):
      KVM: selftests: Move dirty logging functions to memstress.(c|h)
      KVM: selftests: Add dirty logging page splitting test

Colin Ian King (1):
      KVM: selftests: Fix spelling mistake "miliseconds" -> "milliseconds"

Paolo Bonzini (1):
      KVM: selftests: touch all pages of args on each memstress iteration

Peter Xu (3):
      KVM: selftests: Setup vcpu_alias only for minor mode test
      KVM: selftests: Allow dumping per-vcpu info for uffd threads
      KVM: selftests: Allow specify physical cpu list in demand paging test

Sean Christopherson (1):
      KVM: selftests: Refactor stable TSC check to use TEST_REQUIRE()

Yu Zhang (1):
      KVM: selftests: Add new CFLAGS to generate dependency files

 tools/testing/selftests/kvm/Makefile               |  18 +-
 tools/testing/selftests/kvm/demand_paging_test.c   |  32 ++-
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |  96 +-------
 .../testing/selftests/kvm/include/kvm_util_base.h  |   1 +
 tools/testing/selftests/kvm/include/memstress.h    |   8 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |  17 ++
 tools/testing/selftests/kvm/lib/memstress.c        |  75 ++++++
 tools/testing/selftests/kvm/lib/userfaultfd_util.c |   4 +-
 .../kvm/x86_64/dirty_log_page_splitting_test.c     | 259 +++++++++++++++++++++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c      |   2 +-
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c       |  22 +-
 11 files changed, 416 insertions(+), 118 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
