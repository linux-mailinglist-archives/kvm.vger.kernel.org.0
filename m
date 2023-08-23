Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D1578613F
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 22:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbjHWULe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 16:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236407AbjHWUL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 16:11:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9696310CC
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 13:11:25 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d66c957e1b2so6626769276.0
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 13:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692821485; x=1693426285;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z0FP+hPub/nKJVBpaXkcDppbwPaEend4VotzFjUig+0=;
        b=UKFqCpIuAooV9vJHdFvVxIzAXGLWB66zKCrFfCWgSV2+jPU+aeEbY3vriBeckSXM+E
         DhpXZsssDa/ql4yMzYv4lsuaFbBX0DGOGQdNRBTy3IJRScVafk+3AcyLFiMszGddb1vo
         REGV0hn2+a//Zk3JQn1RDTfM6tRmuPsd7SRjSFH5Tbt594/RTZ2zDEfj0+W3piazAjJF
         ruQQjMygv9E+p/B1ty7L9mDGGOPlspUW4m20CcUnOrno0OmCLQsEv+EV6V8plyFW7T5t
         0BlUedSpTtnENVbwSXwSPiGmIHY3aC3Hrd3UYQ16IA15wxkVE+a6Yy9cOuxIvP77xF+p
         TQwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692821485; x=1693426285;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z0FP+hPub/nKJVBpaXkcDppbwPaEend4VotzFjUig+0=;
        b=De5KpG+zje0RMHyJpAUiwmtyixm5dUxWnR7p40PN6FvSBjdRh3BXWPQlvVx+I7IV+/
         qV+bA/CISrNlvZBwnLqaiuzT3ZNYy88aGOhjUN0MElQpAMyM1YZaE0LEp2EL6jx0y5u/
         8Rluc2hNaZzP+O4c/0trAuSRq8PeGLY0gASyTHoSKBU6uZ0iMiVCzXehkVzumvI/0pin
         Q4YcSYi8vFBnR0RHksNhaeCrjZRZkJV9AkCNWjWDCjn7D5qD0YFM2A5nfg6j7R9IMmQt
         gJg/35Jql3brMnnAK6HT/dBm3bm8+gb6zH44GgaUYwtqd6UR/b3c3FPGkGbbIiaBelrh
         R+XQ==
X-Gm-Message-State: AOJu0YxUne0sPexyIjUDKCufRu8Sg6JHrQ2JWK5CW0cKPVi+aLYm26+B
        bkvGFH0pp9bxElvRXPeepxK8eZiXumdyguvDip3621dSA25GO6VKlhCAOU/I7sTnWX3OcXd39xV
        9iQ2b2gCHICLRbU5UVX4X6ynQkmhULMzBUmz4qSMOIVvcZf1blV5A4LP1vAUGrZEQOYKMxsE=
X-Google-Smtp-Source: AGHT+IGTqSfTI5bR/0j1hk91mJSFgF9aSd9HvOFQB8d1/WPp9UdimxMPsLgl8W2nNetxghJu0FgyfzGO3pfev32XYg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:d809:0:b0:d01:60ec:d0e with SMTP
 id p9-20020a25d809000000b00d0160ec0d0emr190756ybg.9.1692821484792; Wed, 23
 Aug 2023 13:11:24 -0700 (PDT)
Date:   Wed, 23 Aug 2023 20:04:08 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230823200408.1214332-1-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH] arm64: microbench: Benchmark with virtual
 instead of physical timer
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
        Colton Lewis <coltonlewis@google.com>
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

Use the virtual instead of the physical timer for measuring the time
taken to execute the microbenchmark.

Internal testing discovered a performance regression on this test
starting with Linux commit 680232a94c12 "KVM: arm64: timers: Allow
save/restoring of the physical timer". Oliver Upton speculates QEMU is
changing the guest physical counter to have a nonzero offset since it
gained the ability as of that commit. As a consequence KVM is
trap-and-emulating here on architectures without FEAT_ECV.

While this isn't a correctness issue, the trap-and-emulate overhead of
physical counter emulation on systems without ECV leads to surprising
microbenchmark results.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arm/micro-bench.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index bfd181dc..fbe59d03 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -348,10 +348,10 @@ static void loop_test(struct exit_test *test)

 	while (ntimes < test->times && total_ns.ns < NS_5_SECONDS) {
 		isb();
-		start = read_sysreg(cntpct_el0);
+		start = read_sysreg(cntvct_el0);
 		test->exec();
 		isb();
-		end = read_sysreg(cntpct_el0);
+		end = read_sysreg(cntvct_el0);

 		ntimes++;
 		total_ticks += (end - start);
--
2.42.0.rc1.204.g551eb34607-goog
