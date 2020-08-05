Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D7323D38C
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 23:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgHEVVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 17:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbgHEVVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 17:21:45 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8D8C06174A
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 14:21:44 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id a73so12859835pfa.10
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 14:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OH4M4A2tRqFAq/VO6fLf2hKWyVzHSTEuFuDzJJzFqVk=;
        b=m/LFUUB5oWDDCfTueb5Q2K0brXhWaD5I1SnD69iFPSYn9tHeER/nKYElKNtywgSH1H
         Cpl6lHEBLf4+IpTMr1W2d6IOvwU00DXUJNtzuk/hgpGeDtA5uuybkDqPSEsoBSNAcVes
         7iVA36X4aZ8wB9nx+mLiek8KOiByXk+9+zBeumNwklzV+uWAr44q9JhkNuEYdLyP0iHE
         ysc8AFFtcQSukSC1mlmtnDvSTFsYl7fbV0o06leNpEzfmXbiGSW4NJ4DZkrkwJXwcD4U
         1/JQ9HuYCVEIphpXFzdx3gC1OviKftZp3JleGWWhIaO+A2VU5eyJcsa92yqISA3bdmMw
         W7Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OH4M4A2tRqFAq/VO6fLf2hKWyVzHSTEuFuDzJJzFqVk=;
        b=rBcgVcdBbAOnM3UKEcMRC1gM+/oyzH8JaOlxcOSEeEJViwymyDTwLhUVqIrB97I9fP
         qYFlP1b55In6fWpcvkvcxEzgcRA6k+BxSvFqAPfkppQJD+YmP+BrKUgC75RdAY5LsqbC
         NycH7dVw76TvKob1Jk183JF0etOCJYMjf5MFknzQATrNdt06cv18ddPc4K1LzVvTGz2h
         l6EwycSMfkFu2v0Ny7kd5Q+R5s4Tqe8BOtCQ16ywY+FS3tOt4Pv45/wZkZqGcidPZyGH
         lV0EABWcuupuWntQtmXgvlXtIcv3fT2QfwRSIoS0CAaMqyUufJf7d9qNwxg1S1KaKO1B
         ZZcA==
X-Gm-Message-State: AOAM531YqIQ0jKNUtSWaOPzRPukik7usT5nwNkQmIYOTSj3byXgJYGAY
        gEG9PuROHx2/A8qyRwghrpIRM+dUNC9benh4lzjUN6iHdB6EWoVrL7SH4UpFnjUawY6e3/mAsnB
        85u1qp2LXbp9hi5DtODNzsULXakrhrH3jIv21THEUrqfiyeaxPz+wE/0ouA==
X-Google-Smtp-Source: ABdhPJzUz3wxyTncXylKyeIBz3+ZxF8tUl9xBkO9A9ERve3Ls2LbS0y4Mixsuh1FxhUrI30PfdGGxBXc4DY=
X-Received: by 2002:a17:90a:e687:: with SMTP id s7mr5192197pjy.48.1596662504377;
 Wed, 05 Aug 2020 14:21:44 -0700 (PDT)
Date:   Wed,  5 Aug 2020 21:21:31 +0000
In-Reply-To: <20200805212131.2059634-1-oupton@google.com>
Message-Id: <20200805212131.2059634-5-oupton@google.com>
Mime-Version: 1.0
References: <20200805212131.2059634-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v2 4/4] Documentation: kvm: fix some typos in cpuid.rst
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
2.28.0.236.gb10cc79966-goog

