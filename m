Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB7123D384
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 23:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgHEVQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 17:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgHEVQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 17:16:21 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9535FC061575
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 14:16:21 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y13so8927523pfp.5
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 14:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=o0c8+R/G+PRbA64Z+pWqNQDnbLfSRBJEpSpCp6nbDmE=;
        b=iUH43Uyn3hglXOycjOqF4nv/9uF/H9i59F/A78hqlf91/mk5tXq3cbVu+5zZ6uNw7O
         w+71gQr2PxBb2Wpu8ypVADZgEWB5PQPSmULDS2rYMZyaSsztSjyjPFP1wUmFcdiF/TgM
         Xe84r2bRXRcMOkFk218Pr2mL5o57KanD6oVVEuODKzhQxLpTXZ7cjwdxxydr/Q9oijQv
         HZuTEqf6MMM2gK5FS6OyCwAMOYIHn87l1vChJljY8cuhWmn35G3XQe39Z4OjdLZlVcsN
         8arChWjEYLRKbDhPmwCTS4/Va16ifQz0lUlxIpzx7zJFQ562P7pZNzo0fxqMpiwgqFi2
         1Xbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=o0c8+R/G+PRbA64Z+pWqNQDnbLfSRBJEpSpCp6nbDmE=;
        b=dmryp6NXAzb/ajFrgYv/RTv3ZPE3mfEwIs7c8DWYr8B8XgjmXJo6euNBXvF+wN9hXC
         nGpLCUVedID2OMTs1QZfv970YbLp48Gl4RC3uXVAIPxRvlZrXQbb6oyn6BNUvEsh3PA5
         D2NWpzHTi1dui8nBxFWchEPO+9Ux05q+jUi8Gt3q6+2sNlUrwIDeO7JNSKesIKPbgZNO
         2IsGWWOaq5Vxig4uFwtaVdkRAgGQRFNeQt9SEIsSj4MIbcVPKD2hDcED11TwYEfU5MQw
         6JRYYCLpui6sJp3KFiiYrSh3h3SFdI8bAe4sTf261Ia2DiwnktUOruaz1VWcU+XViN55
         imTw==
X-Gm-Message-State: AOAM5328rzMZKmpSGNnjL0Z2YnphPcE7l13vnexGtygmYOLE2WlqGyL8
        +VnXPyxuvcTcq6U5bmjZE7csLXdXVT7k9XA1fglJjM9XaFfw3FevVZDg3xqrA6mlBvK6pdawM4x
        eJXJNWdC1DAJ+8dQYTgBjgE0S8327hmX/xu7TMhqn6n8U637PhDlkjWyf3A==
X-Google-Smtp-Source: ABdhPJzIirgEGq0frpd8p8Gmn2cuYMiyR6fp8hAd4RyyNH0jnSMIwL7YbDxCl5zqemqRKERmzMNDSRm1b2E=
X-Received: by 2002:aa7:9a12:: with SMTP id w18mr4964768pfj.128.1596662180900;
 Wed, 05 Aug 2020 14:16:20 -0700 (PDT)
Date:   Wed,  5 Aug 2020 21:16:07 +0000
In-Reply-To: <20200805211607.2048862-1-oupton@google.com>
Message-Id: <20200805211607.2048862-5-oupton@google.com>
Mime-Version: 1.0
References: <20200805211607.2048862-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH 4/4] Documentation: kvm: fix some typos in cpuid.rst
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
2.28.0.236.gb10cc79966-goog

