Return-Path: <kvm+bounces-527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 419687E0973
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 20:29:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE2DD281B7A
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 19:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C9823740;
	Fri,  3 Nov 2023 19:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yYZ3gicv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7864522F0F
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 19:29:29 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8ED1BC
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 12:29:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d99ec34829aso2816061276.1
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 12:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699039767; x=1699644567; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bEAfZyWhlsWU6we+1WUOdwYhBvWIiGNcSe/GN4oT0oY=;
        b=yYZ3gicvqOGcDeqfd0qvzKnZmp5x/qG2inVH89hAoF0ChgqDO8Ie71I680nE/JOVq3
         EfUM61Ov73lav9eKxVCEhEb1oZodVe+bKzhg5hi6T2wppCn32v40F1hN2G4KQAk9uJ86
         7oCUYrsWXgRNOapN/RpzYGc64xO5N4WbEgU7KLrTvRbWNDn+gEBvNiTeF4E7HeQJ6w8Z
         Hqw/dsnAnMrMeKOQYxbkqVZfc+zHKq9Mj9Q7MZYvGwrZNrj3wwzjVVTmhmmyAAmtDgtb
         nOByZY7r/2pVvbIZpN7863NCuLizpH9C//COqq9x0pEuC64UcrA5w1WgQ65O2zcIWpkh
         Pe3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699039767; x=1699644567;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bEAfZyWhlsWU6we+1WUOdwYhBvWIiGNcSe/GN4oT0oY=;
        b=YUBdY7PXILdbnfRXwKPpGzbmWBX7LM6Dlrfwv4eFNsiOxi1s39KaI87PxiSX8FBgvU
         NLndXR8WePUJMrNjF7nMsz+SCeoKG1vpO/3ApSC9McFXfMTtYvcmEBgBAEMNNLHT7xrj
         ZY0/1BjrHronDdLUI3MB9iGrY+r329eQ6DBXxQGcbqUM+rUce/aK6xM4KJPSIPfGTp3S
         UTk8Ijbv9GkXy+SIRdnYwZ6lLpFwTMRZ4V8XF9omJTjbBzM11Rdk7DLl42ABpIpfDbGK
         wwo1Ry0vEtOZbFdxnn5AKe//nNrG6gopVzmFXNUg0sQVp5gnMyNrSF+DR2Cd2z/BQZzk
         0UTw==
X-Gm-Message-State: AOJu0Yx3XWyNvpl67fK8opwtB0lFTg6F4qK+kvYAh/OghFbakO+1ooZP
	N/9aZK6qnB5He9CNYoykf9Q/kIfCeUvl2Vryjca1QvJ8JRf3A8R36+Ay1aIzKsHbVFeEepDJ0l0
	Mx3ovIxVZLX5XBObJGqKRXx6UJAJ4ozcpKS8+P8HWrImu8RNOpBVd5YXA4SPqgQmol9hhdSw=
X-Google-Smtp-Source: AGHT+IHKhte6SyveleGfndRKN5qF5FiLzkyOQTSM6UmB/7Ca1BYcGNMFHiQ2xWtcgmwtm27r2JFQyaL2fqKGSpkBeA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:2688:0:b0:da0:29ba:668c with SMTP
 id m130-20020a252688000000b00da029ba668cmr412348ybm.10.1699039766978; Fri, 03
 Nov 2023 12:29:26 -0700 (PDT)
Date: Fri,  3 Nov 2023 19:29:12 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231103192915.2209393-1-coltonlewis@google.com>
Subject: [PATCH v3 0/3] Add arch_timer_edge_cases selftest
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add arch_timer_edge_cases selftest to test various corner cases of the
ARM timers such as:

* timers above the max TVAL value
* timers in the past
* moving counters ahead and behind pending timers
* reprograming timers
* timers fired multiple times
* masking/unmasking using the timer control mask

These are intentionally unusual scenarios to stress compliance with
the arm architecture.

v3:
* Rebase to v6.6
* Patch to standardize GIC base addresses across tests
* Patch to guarantee interrupt handling in vgic_irq with context sync,
  fixing an error there that was caught here
* Expand sync_cmd enum for more logical arguments to waiting functions

v2:
https://lore.kernel.org/kvmarm/20230928210201.1310536-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvm/20230516213731.387132-1-coltonlewis@google.com/

Colton Lewis (3):
  KVM: arm64: selftests: Standardize GIC base addresses
  KVM: arm64: selftests: Guarantee interrupts are handled
  KVM: arm64: selftests: Add arch_timer_edge_cases selftest

 tools/testing/selftests/kvm/Makefile          |    1 +
 .../selftests/kvm/aarch64/arch_timer.c        |    8 +-
 .../kvm/aarch64/arch_timer_edge_cases.c       | 1104 +++++++++++++++++
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |   23 +-
 .../selftests/kvm/dirty_log_perf_test.c       |    5 +-
 .../kvm/include/aarch64/arch_timer.h          |   18 +-
 .../selftests/kvm/include/aarch64/gic.h       |    8 +-
 .../selftests/kvm/include/aarch64/vgic.h      |    3 +-
 tools/testing/selftests/kvm/lib/aarch64/gic.c |   12 +-
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |    7 +-
 10 files changed, 1159 insertions(+), 30 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

--
2.42.0.869.gea05f2083d-goog

