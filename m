Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39ED4F1EF4
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236962AbiDDWXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350354AbiDDWUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:20:45 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9650103C
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 14:46:46 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id c6-20020a621c06000000b004fa7307e2e0so6646043pfc.6
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 14:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=vUdWzFrtPhSM1t/d7+UY/dP+cyIa6smY9TFzKXaIHpA=;
        b=V4vwKaWAkxqTgX2AzXs0gs0B3RUKxIy/ZcyRrVX+S2KTcAyTChPxqM8UfpbheoXIlm
         ZtQQ/WOTZ9GtjhPHGtNgZ4X7d/l6AjxO38FTCxUmy8VQ1IZg22h+vdE0YysZkBpfNcB8
         hNb+uI8g2KTOiWfyPpfqUBagNO+5ZvpSpoLoLaX9iOBvUDe7Kkuf4mxrrO9OIuyWFlhG
         wiAFPwEpNFqe0eLAAViQ5rkEaSH+KR1ebfSteZwgzREt46t7200BztrXYeadZ+CVI2jD
         UPZaCiZ+8X3fHIc1pyE2SaFsGNB7qAECecHutAJC+z5L/Fo7jTtrRxRbj5yuK6Q4uVEd
         CqnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=vUdWzFrtPhSM1t/d7+UY/dP+cyIa6smY9TFzKXaIHpA=;
        b=E/zNT+nhJNLDUAX/E3ZqbV4I71B6ZjKLHTPquxCORHaub0UqkwqdB77Xy5H9Q7Fwq7
         egAHCT35nX6LEDclaeXVhC2C/bBD5GBwz18sZJhud1EjZP2yJ4EOpKBJghHqczf/enps
         N6+fazBOU4IcIr12VE1frGa5csGA2T9GvJlNS7e/qAur2gxQO8qVnYr+9Pz50y8LvkBD
         zmeOuhQIXMOPCkETThPYisAyaS1ZIualq0LJQzFHF7D/7x5wxF3LFKezd1KFJAOFX3hH
         VY7MmDdCHOGE+ZTT0HB8R5fhVBdGb/HO91upNX9gCvRAZVGS6ayZb3XDdGtM9CwSCW/9
         bzsQ==
X-Gm-Message-State: AOAM533o/K5/Zuh5FftZdlbSLw6xzai2JmUDgUpGyugstq/cmwsVjFdy
        QAgWFON+k9GKyXF8Or3S3zw9RHxEOF61tivR8ha+n1sV2VTOH5NgVgG6lj05aWyIMCQXBA6Tw4D
        EY4vstfeEAYA3FUhL/YqROVE4csQcHFZzo+jvlhLkcm7s9i736Bhcbt30m4R1mrI=
X-Google-Smtp-Source: ABdhPJx3wtgMXfXkSOgJuNWH/gD+BQjjw3/wZz2AUGKgXDMbpUHr5B1iER2pE+Nbz2Hw6rypSj4a9vxSUnkQWw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a65:5c48:0:b0:382:2c7:28e9 with SMTP id
 v8-20020a655c48000000b0038202c728e9mr187143pgr.472.1649108806206; Mon, 04 Apr
 2022 14:46:46 -0700 (PDT)
Date:   Mon,  4 Apr 2022 14:46:38 -0700
Message-Id: <20220404214642.3201659-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v4 0/4] KVM: arm64: selftests: Add edge cases tests for the
 arch timer
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, Ricardo Koller <ricarkol@google.com>
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

Add a new selftests that validates some edge cases related to the virtual
arch-timer, for example:
- timers across counter roll-overs.
- moving counters ahead and behind pending timers.
- having the same timer condition firing multiple times.

The tests run while checking the state of the IRQs (e.g., pending when they
are supposed to be) and stressing things a bit by waiting for interrupts
while: re-scheduling the vcpu (with sched_yield()), by migrating the vcpu
between cores, or by sleeping in userspace (with usleep()).

The first commit adds a timer utility function.  The second commit adds
some sanity checks and basic tests for the timer. The third commit adds
the actual edge case tests (like forcing rollovers).

v3 ->v4:
- Fix is_cpu_online to also check whether the cpu is allowed to run the current
  process (on top of being online). Renamed is_cpu_online() to
  is_cpu_eligible_to_run(). [Sean]

v2 -> v3: https://lore.kernel.org/kvmarm/20220322172319.2943101-1-ricarkol@google.com/
- Add missing isb when polling for IRQ being handled. [Oliver, Marc]
- Wait for a counter pass by polling on it (instead of the previous isb).
  [Oliver, Marc]
- Edits in some comments. [Oliver]
- Dropping the msecs_to_usecs macro. [Oliver]
- Skipping test if desired pcpus are not online. This needed adding a
  library function (is_cpu_online). [Oliver]

v1 -> v2: https://lore.kernel.org/kvmarm/20220317045127.124602-1-ricarkol@google.com/
- Remove the checks for timers firing within some margin; only leave the
  checks for timers not firing ahead of time. Also remove the tests that
  depend on timers firing within some margin. [Oliver, Marc]
- Collect R-b tag from Oliver (first commit). [Oliver]
- Multiple nits: replace wfi_ functions with wait_, reduce use of macros,
  drop typedefs, use IAR_SPURIOUS from header, move some comments functions
  to top. [Oliver]
- Don't fail if the test has a single cpu available. [Oliver]
- Don't fail if there's no GICv3 available. [Oliver]

v1: https://lore.kernel.org/kvmarm/20220302172144.2734258-1-ricarkol@google.com/

Ricardo Koller (4):
  KVM: arm64: selftests: add timer_get_tval() lib function
  KVM: selftests: add is_cpu_eligible_to_run() utility function
  KVM: arm64: selftests: add arch_timer_edge_cases
  KVM: arm64: selftests: add edge cases tests into arch_timer_edge_cases

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/arch_timer_edge_cases.c       | 904 ++++++++++++++++++
 .../kvm/include/aarch64/arch_timer.h          |  18 +-
 .../testing/selftests/kvm/include/test_util.h |   2 +
 tools/testing/selftests/kvm/lib/test_util.c   |  20 +-
 6 files changed, 944 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

-- 
2.35.1.1094.g7c7d902a7c-goog

