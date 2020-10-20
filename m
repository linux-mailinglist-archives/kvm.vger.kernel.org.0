Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C81828C19D
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 21:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391443AbgJLTre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 15:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391413AbgJLTrd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 15:47:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E063DC0613D0
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 12:47:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x1so18693708ybi.4
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 12:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=DWoogOPzifjrjox3Xp7XZd0Vq+PlvblBZZlxSc6Gj2U=;
        b=qP5M0MyXRz61ZFFuMWYy5rOqtxjbMNIoQjkMmZdjAWsC/zgueYE0qYe+3wbpJehQ9Y
         pQiRNNpcCHHhhaeIOBBvWk4T+tSHVCTU4lcLZ96Z3vwA8rK8f03FnNnnRUB4NNJ0nZ4l
         O4jhgQmZpAs4Du1VjoBsD+mK+CA07J7Mjq/hUB8f9JyWW3TmjqICdemCXIX2hCJelHu/
         MHhzmIE9VysB8JrJ8/4U8F+pmYTi7UDIVGi7oCOOAk01mN7SvjGlhRigQRiLWlujZToh
         TX84Z+OXWlN8STPCZ47CtGEM7cD6+koilEA0XdEHrtyaN6D0WlmyYS3WcyL+SPBQAuoM
         M+gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=DWoogOPzifjrjox3Xp7XZd0Vq+PlvblBZZlxSc6Gj2U=;
        b=Ig0jmMicqEl+oN58rHKEjVKJMLf5DCIg403WjeOuoRC4F+zKJfGklD8rWFSeq47Yko
         ttR+UjDIA4RUdieyJpuzKEZ/cPShpkDHu9L1i+U/Ivgt3dwL3Fr30r1tV4HFBLtvSh0b
         oR6R81vNt85a12ItrC/fOjAXDK1V/SGMEROdln4aNCPejsbcd1Off2PoriBJYrpjXogH
         DldBc52uW0sugBMEmpIdTuJg+lTmcRtK6xKU9hZQbey9vwCf5/uSNTO55yDKH7K/JyAF
         g0Q3G1aBCQqWIw6gE/ZEWrpWAqVeCYxBYgE6EqrMVj6Np9yN6wvrbABuxkY9VMvvFU7Z
         UHOQ==
X-Gm-Message-State: AOAM531ycb+oMYwjnQja11GjSpgu74JTAufFvGKHcv8kQIYx8kUk5PS3
        SSs9JXp2bYFncYwgxh1p9fz/wznjb0kXraGG
X-Google-Smtp-Source: ABdhPJzwxsa35ENsFO6q9F8B619B8tLXLcvgCJycFYM8H4NfkvXJbHMJx8MfWzhsJS3osiKLfVWM6I69Kptm103A
Sender: "aaronlewis via sendgmr" <aaronlewis@aaronlewis1.sea.corp.google.com>
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:a05:6902:1025:: with SMTP id
 x5mr32983524ybt.131.1602532050999; Mon, 12 Oct 2020 12:47:30 -0700 (PDT)
Date:   Mon, 12 Oct 2020 12:47:12 -0700
Message-Id: <20201012194716.3950330-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v3 0/4] Test MSR exits to userspace
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

v2 -> v3:

  - Add stubs for assert_on_unhandled_exception() in aarch64 and s390x.

Aaron Lewis (4):
  selftests: kvm: Fix the segment descriptor layout to match the actual
    layout
  selftests: kvm: Clear uc so UCALL_NONE is being properly reported
  selftests: kvm: Add exception handling to selftests
  selftests: kvm: Test MSR exiting to userspace

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |  20 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 .../selftests/kvm/include/x86_64/processor.h  |  26 +-
 .../selftests/kvm/lib/aarch64/processor.c     |   4 +
 .../testing/selftests/kvm/lib/aarch64/ucall.c |   3 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   5 +
 .../selftests/kvm/lib/kvm_util_internal.h     |   2 +
 .../selftests/kvm/lib/s390x/processor.c       |   4 +
 tools/testing/selftests/kvm/lib/s390x/ucall.c |   3 +
 .../selftests/kvm/lib/x86_64/handlers.S       |  81 +++
 .../selftests/kvm/lib/x86_64/processor.c      | 117 +++-
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |   3 +
 .../kvm/x86_64/userspace_msr_exit_test.c      | 560 ++++++++++++++++++
 14 files changed, 820 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/handlers.S
 create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c

-- 
2.28.0.1011.ga647a8990f-goog

