Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A81F2489B1
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 17:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgHRPZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 11:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbgHRPYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 11:24:55 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D302C061344
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 08:24:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w17so22316852ybl.9
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 08:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ss9Mm6++2J6/bl4nk0srPijFVv+n5iynw0aopEfHAP8=;
        b=bRdidz6ciEQKTHEBe8HFfV2yYMnxPuvNxt/bibWg+1By92BYN3dIviveUk8q/W9JwA
         /nR44Bd49/AvmeViZD/mxbf7OXuCQw1bjdShVitXvoVA42kZbbXMIPDxc3Ki7AoHmXlf
         kuFv4T+XH/UpeHadRfwxfu1wpyx6V5JJ8pcyqp14vIE/8G76QUBPUWF7h4XEHc6Kv32Z
         2iQnKiRguaO3AyoqDdfgRuLTLzfIkABHkQXJliyVKygj6S+Q8JN4tNyJ1C3Y1QVdv2BH
         8RWsYtPS6BRnpXkqXgcwKWbBeSRE4j9nXY+lh3YZTWfj4EW7PTVNnuNV5ogDAJIOe9aI
         xkGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ss9Mm6++2J6/bl4nk0srPijFVv+n5iynw0aopEfHAP8=;
        b=B6DBzxhWFMe5U//khMr/kJr72IlMUNMWLrAa/nCFWwhXMxtuLI2KYsvCRlliAuxHR8
         RjfP1n4FDi9g+gxP21eVxKAxNdzKsRXLd7KWylVYGcV5AY+TKCYRV5m2X40LPj5troTn
         6jsqqdSui3lxmGKNnrg0OkXEnCV3hSJa/l4DeyjQntKJbxGMb/3rtYaazxsqkc59vAtN
         RVKdTMppmeTEu4y/1Sc+SIDptb/Vo4q0Jp3rWZ5Bb4iVvNxsNNsRoJcqeS/89YhEClPL
         tbRK3cwYc1Rnf+vAkWUwkfvLAtHIe2rECXK+dmqG0otpT/jAnzzww3FCG9i/E4xqPA+L
         zPQg==
X-Gm-Message-State: AOAM532E9irzXzByxiffZ8VvNx1s5pbFADQWWmSlLNCof3NV4L9FkmkY
        ud2IagLwywaWeuuR/smHiSR4kA3omU3RE0fs4n+P85vljdQiPH+MkCxFpKS3BwTYZNjA0ScV8Eq
        t/Od7YeNkFTOcZ7nSoYDHb1sI0miJ/F7wSPcU7ZqKb1SGuwZXexOD60wemw==
X-Google-Smtp-Source: ABdhPJz0R8oJfiZQxKsTcoDdGNpoOe2G30i1NmbyK8g7YffSHnyouM1ztL43yv8Vw74vEW2ulBn0Z8hnWYY=
X-Received: by 2002:a25:4846:: with SMTP id v67mr27778033yba.103.1597764294715;
 Tue, 18 Aug 2020 08:24:54 -0700 (PDT)
Date:   Tue, 18 Aug 2020 15:24:29 +0000
In-Reply-To: <20200818152429.1923996-1-oupton@google.com>
Message-Id: <20200818152429.1923996-5-oupton@google.com>
Mime-Version: 1.0
References: <20200818152429.1923996-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v4 4/4] Documentation: kvm: fix some typos in cpuid.rst
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Change-Id: I0c6355b09fedf8f9cc4cc5f51be418e2c1c82b7b
---
 Documentation/virt/kvm/cpuid.rst | 88 ++++++++++++++++----------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index a7dff9186bed..f1583e682cc8 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -38,64 +38,64 @@ returns::
 
 where ``flag`` is defined as below:
 
-================================= =========== ================================
-flag                              value       meaning
-================================= =========== ================================
-KVM_FEATURE_CLOCKSOURCE           0           kvmclock available at msrs
-                                              0x11 and 0x12
+================================== =========== ================================
+flag                               value       meaning
+================================== =========== ================================
+KVM_FEATURE_CLOCKSOURCE            0           kvmclock available at msrs
+                                               0x11 and 0x12
 
-KVM_FEATURE_NOP_IO_DELAY          1           not necessary to perform delays
-                                              on PIO operations
+KVM_FEATURE_NOP_IO_DELAY           1           not necessary to perform delays
+                                               on PIO operations
 
-KVM_FEATURE_MMU_OP                2           deprecated
+KVM_FEATURE_MMU_OP                 2           deprecated
 
-KVM_FEATURE_CLOCKSOURCE2          3           kvmclock available at msrs
-                                              0x4b564d00 and 0x4b564d01
+KVM_FEATURE_CLOCKSOURCE2           3           kvmclock available at msrs
+                                               0x4b564d00 and 0x4b564d01
 
-KVM_FEATURE_ASYNC_PF              4           async pf can be enabled by
-                                              writing to msr 0x4b564d02
+KVM_FEATURE_ASYNC_PF               4           async pf can be enabled by
+                                               writing to msr 0x4b564d02
 
-KVM_FEATURE_STEAL_TIME            5           steal time can be enabled by
-                                              writing to msr 0x4b564d03
+KVM_FEATURE_STEAL_TIME             5           steal time can be enabled by
+                                               writing to msr 0x4b564d03
 
-KVM_FEATURE_PV_EOI                6           paravirtualized end of interrupt
-                                              handler can be enabled by
-                                              writing to msr 0x4b564d04
+KVM_FEATURE_PV_EOI                 6           paravirtualized end of interrupt
+                                               handler can be enabled by
+                                               writing to msr 0x4b564d04
 
-KVM_FEATURE_PV_UNHAULT            7           guest checks this feature bit
-                                              before enabling paravirtualized
-                                              spinlock support
+KVM_FEATURE_PV_UNHALT              7           guest checks this feature bit
+                                               before enabling paravirtualized
+                                               spinlock support
 
-KVM_FEATURE_PV_TLB_FLUSH          9           guest checks this feature bit
-                                              before enabling paravirtualized
-                                              tlb flush
+KVM_FEATURE_PV_TLB_FLUSH           9           guest checks this feature bit
+                                               before enabling paravirtualized
+                                               tlb flush
 
-KVM_FEATURE_ASYNC_PF_VMEXIT       10          paravirtualized async PF VM EXIT
-                                              can be enabled by setting bit 2
-                                              when writing to msr 0x4b564d02
+KVM_FEATURE_ASYNC_PF_VMEXIT        10          paravirtualized async PF VM EXIT
+                                               can be enabled by setting bit 2
+                                               when writing to msr 0x4b564d02
 
-KVM_FEATURE_PV_SEND_IPI           11          guest checks this feature bit
-                                              before enabling paravirtualized
-                                              sebd IPIs
+KVM_FEATURE_PV_SEND_IPI            11          guest checks this feature bit
+                                               before enabling paravirtualized
+                                               send IPIs
 
-KVM_FEATURE_PV_POLL_CONTROL       12          host-side polling on HLT can
-                                              be disabled by writing
-                                              to msr 0x4b564d05.
+KVM_FEATURE_PV_POLL_CONTROL        12          host-side polling on HLT can
+                                               be disabled by writing
+                                               to msr 0x4b564d05.
 
-KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
-                                              before using paravirtualized
-                                              sched yield.
+KVM_FEATURE_PV_SCHED_YIELD         13          guest checks this feature bit
+                                               before using paravirtualized
+                                               sched yield.
 
-KVM_FEATURE_ASYNC_PF_INT          14          guest checks this feature bit
-                                              before using the second async
-                                              pf control msr 0x4b564d06 and
-                                              async pf acknowledgment msr
-                                              0x4b564d07.
+KVM_FEATURE_ASYNC_PF_INT           14          guest checks this feature bit
+                                               before using the second async
+                                               pf control msr 0x4b564d06 and
+                                               async pf acknowledgment msr
+                                               0x4b564d07.
 
-KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
-                                              per-cpu warps are expeced in
-                                              kvmclock
-================================= =========== ================================
+KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
+                                               per-cpu warps are expected in
+                                               kvmclock
+================================== =========== ================================
 
 ::
 
-- 
2.28.0.220.ged08abb693-goog

