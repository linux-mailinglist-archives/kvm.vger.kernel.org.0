Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A29288805
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 13:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732810AbgJILqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 07:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732494AbgJILqV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 07:46:21 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4072DC0613D2
        for <kvm@vger.kernel.org>; Fri,  9 Oct 2020 04:46:20 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id c21so6444377pfd.16
        for <kvm@vger.kernel.org>; Fri, 09 Oct 2020 04:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=8iM9xn/WrbdOnFuGxBykwqYFqH+U6wmGWc28LA7ANGA=;
        b=vmHM3u9Fk5vGa5l4B4N8xfOMT21uq3Ldl8xcsNjyz1krtriX3lI8OWQcSh1oPn24Vv
         QTPsmqCu7WG2daYFSW5rexLXzWuF+0kQ/3eIpSOt0v3JmHAA5pgu26g1u0UxKVDN+pZ9
         eBaJwPJ5rQBQlSjQ4lwQEnVKI/TxUYTQmBN30sz05LFDo2EpYJLUVg41hibbx3ucUAyN
         O4Sam7RfW2VKoPWDk4CvWwOwnBxH1ZbBjlm9/Rw0QAAEsjti6+zTxsD+o6FwRk9T4d/w
         S19IqDnLCwH9dU5NF3GDyjVRqWtXgqoYbndyG8+P5MGJsPmWmzFTkcodhwUwstN0TFyU
         V2iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=8iM9xn/WrbdOnFuGxBykwqYFqH+U6wmGWc28LA7ANGA=;
        b=KOyOkiFhkFThW42OsTKOfZMLXE4evWjQiFG37Ck7oD/AnkC5mE6v2o+B91Vq75mYIR
         QrsYkD6bHye7ph86t4He93QBkkgQrYQZy8n8wPC1Y+bs852DH75qiW4OLKhiLPMXVtKN
         4cXumRadCzgE0YPnVvZpyYIrgbFyqdMGFVt4cyAEIPamlP6X/EyOiQ8LI8/FOTTYeo8I
         7Ah6EqKAgBpZI242I7qgCw4l5BpRVkaBjuEZNneRXvYSIfnxNs32ClTCxXWct+VfTyiC
         JCVkE9TvHMP863R5nv5GAcfgKLK5MpoHsZMmlHMlM4Jq+OiBshIlzPYRPgmLBh9vxNyg
         u7pA==
X-Gm-Message-State: AOAM530+PktkEbjamd9nZdzaqVbiJvdzVkip3ok9hN0QxVQ0FxGQ7WSs
        /NYORlBjxl7xYh2iOyxBSozhn31L1aTlbiYF
X-Google-Smtp-Source: ABdhPJws9cAPQxzbscQZD02qD18Rzeegqki4zpTvVnJ41clMz5tqZglma1vrY/k0ackWAqQ6PGmSPfPIMSM+H8Hd
Sender: "aaronlewis via sendgmr" <aaronlewis@aaronlewis1.sea.corp.google.com>
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:940c:: with SMTP id
 r12mr1676173pjo.1.1602243979403; Fri, 09 Oct 2020 04:46:19 -0700 (PDT)
Date:   Fri,  9 Oct 2020 04:46:11 -0700
Message-Id: <20201009114615.2187411-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 0/4] Test MSR exits to userspace
From:   Aaron Lewis <aaronlewis@google.com>
To:     graf@amazon.com
Cc:     pshier@google.com, jmattson@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset adds additional testing to the series ("Allow user space to
restrict and augment MSR emulation") by Alexander Graf <graf@amazon.com>,
and supliments the selftest in that series.

This patchset introduces exception handling into the kvm selftest framework
which is then used in the test to be able to handle #GPs that are injected
into the guest from userspace.

The test focuses on two main areas:
  1) It tests the MSR filter API.
  2) It tests MSR permission bitmaps.

v1 -> v2:

  - Use exception_handlers instead of gs base to pass table to the guest.
  - Move unexpected vector assert to processor.c.

Aaron Lewis (4):
  selftests: kvm: Fix the segment descriptor layout to match the actual
    layout
  selftests: kvm: Clear uc so UCALL_NONE is being properly reported
  selftests: kvm: Add exception handling to selftests
  selftests: kvm: Test MSR exiting to userspace

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |  20 +-
 .../selftests/kvm/include/x86_64/processor.h  |  27 +-
 .../testing/selftests/kvm/lib/aarch64/ucall.c |   3 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   7 +
 .../selftests/kvm/lib/kvm_util_internal.h     |   2 +
 tools/testing/selftests/kvm/lib/s390x/ucall.c |   3 +
 .../selftests/kvm/lib/x86_64/handlers.S       |  81 +++
 .../selftests/kvm/lib/x86_64/processor.c      | 117 +++-
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |   3 +
 .../kvm/x86_64/userspace_msr_exit_test.c      | 547 ++++++++++++++++++
 11 files changed, 800 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/handlers.S
 create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c

-- 
2.28.0.1011.ga647a8990f-goog

