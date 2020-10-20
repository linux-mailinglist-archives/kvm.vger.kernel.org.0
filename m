Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A504285396
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 23:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgJFVEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 17:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727176AbgJFVEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 17:04:52 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA353C061755
        for <kvm@vger.kernel.org>; Tue,  6 Oct 2020 14:04:51 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id a6so2055756plm.5
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 14:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=MFre2+dcFzdHRgPZJmfgfvp9RN1biBCw0qHlmo0+6ho=;
        b=nmOfGm8qbIS9vS716qew27tWEbd9Vl50uOHN7t7Zqyn1KYoSSluuq+Wc64dKtsS2p+
         M/sEfOpKIclbf2ikyVxJgv9UnHyQEsiNlY7+J1glDHQdlVkI3NZgFu754l/8r4k4eQ3f
         QIWQgbmoIpXR+d18fL4p6901A8iUW72UNuNAR3rBTF/HT/wSrEWrv9PwPdg+pTnQSTcV
         OhxDaIE6A7YMPKJrihbwRuU53HIM2GJS6jQtmBu03wCS3MFhYP8+4P14S1R5DC89oReQ
         td1BoMW4RpliHEXp4PKuGEXSgfyHf+Wg0gzJ8yeQWen+EesmYOyziZKsMbFVeK6Xsk+L
         kVcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=MFre2+dcFzdHRgPZJmfgfvp9RN1biBCw0qHlmo0+6ho=;
        b=Yb+mQsBgvtR6TeWqzZY9mbijwSvXHm/SsgsXT9qMgASWH4DaqlMdvQMSRuQ9wAubXl
         MB0hgApphDWHpwHC/Hfcrs3MMKZ4zjsE/iLQrNjGbAndcQXKXvnfv1NuNDc3stgMcIJI
         3jBQiCu0y2pNLvSexfIMtuyATYjYk53BZ9aozQsd2qL0lSEsxaPuk/8bY1pYcQj9KqPl
         VTSkfqzyDevYLynWVG3BplEqXF5gCTADcFtAMLKJiSRDxH99VtaRx9RvX3meQL3pOX2+
         60LddTgbZ7VRsNBHDroC5N5pTREwUP9L3mWP5NNR5VoQcIRASq5gYbfzywCAciBhddi+
         u4uA==
X-Gm-Message-State: AOAM532aFBShBtR2px8NAUuQfhiIX/Cw9/BwTm10F6mJ0nxoxkSxX4Uj
        2VbRYNopbJO0xzXW3ukeEGoRO0qBl+3yMQ9d
X-Google-Smtp-Source: ABdhPJwRF3ugv7AFp4UqFcNH2ZthNDxpR1qtMgYgz4BQI+AchCgivf1BshBYHxT2cn4bUqde3GT47M5IqmzIX73h
Sender: "aaronlewis via sendgmr" <aaronlewis@aaronlewis1.sea.corp.google.com>
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:b087:b029:d3:e6c5:5271 with
 SMTP id p7-20020a170902b087b02900d3e6c55271mr4973254plr.47.1602018290987;
 Tue, 06 Oct 2020 14:04:50 -0700 (PDT)
Date:   Tue,  6 Oct 2020 14:04:40 -0700
Message-Id: <20201006210444.1342641-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH 0/4] Test MSR exits to userspace
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

Aaron Lewis (4):
  selftests: kvm: Fix the segment descriptor layout to match the actual
    layout
  selftests: kvm: Clear uc so UCALL_NONE is being properly reported
  selftests: kvm: Add exception handling to selftests
  selftests: kvm: Test MSR exiting to userspace

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |  20 +-
 .../selftests/kvm/include/x86_64/processor.h  |  26 +-
 .../testing/selftests/kvm/lib/aarch64/ucall.c |   3 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  17 +
 .../selftests/kvm/lib/kvm_util_internal.h     |   2 +
 tools/testing/selftests/kvm/lib/s390x/ucall.c |   3 +
 .../selftests/kvm/lib/x86_64/handlers.S       |  81 +++
 .../selftests/kvm/lib/x86_64/processor.c      | 103 +++-
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |   3 +
 .../kvm/x86_64/userspace_msr_exit_test.c      | 547 ++++++++++++++++++
 11 files changed, 795 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/handlers.S
 create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c

-- 
2.28.0.709.gb0816b6eb0-goog

