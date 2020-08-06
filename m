Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8458623DFC7
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 19:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgHFRxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 13:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728337AbgHFQbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 12:31:03 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105F9C008686
        for <kvm@vger.kernel.org>; Thu,  6 Aug 2020 08:14:45 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id p6so35217164plo.8
        for <kvm@vger.kernel.org>; Thu, 06 Aug 2020 08:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OH4M4A2tRqFAq/VO6fLf2hKWyVzHSTEuFuDzJJzFqVk=;
        b=elhOl0MxsVpva63g9u2Seo9661v/jptcPCu7ksbFFaqk/cp3Hatt8bpqlE6O3MJCba
         h2WrGV+Z5sXHfD8CWvH5uLRPC/S5+31/NhHPf08Yu2gOZKUtOldPxp6LnBdswrjwICvA
         DTfKqoNE6FC3r1hMj/81MMMzyKYR2CS/NN9UupT8zMzpexet34tOQ+9HHHIfU2KIsNwz
         9pMe4AVLn5N9s5zPT25FZ3FDKpPbNzUnw62jsTahFt+7nprGPwl4pklVDbJca55Y7ude
         DYObBzO+LgHt46NQAdXRTPTVFUvW4RXnBeKKgwt6fc8F5n6/MPc7r/Bi8RtBg1ZAoFWW
         g2Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OH4M4A2tRqFAq/VO6fLf2hKWyVzHSTEuFuDzJJzFqVk=;
        b=FuwOGD4U8D6GLGKxSSTnnMqZVW6ZJMoheC4uKV22qKeWM3CTx9nPbM2gRnotngLt8H
         xAmW+9YIGI68pXJPjMgOewTfDUTzNfQHBRCkdbM+xukJAWoAFgBwws3byhIMk2cYy8sY
         r1LKbIzDKprpc4YTr6gHB/NQ/oDYkGAhr4WariTvP/pdz/O9iM5dh0U20KBXXcxfVJeH
         irxlAtIcf+yAqOgPn4ZYx7CccO7AP+e0SCQFs/IX6+R4o3UM5VDcv4ZS2zzzd/d25Ii4
         xRnThXV8R46wE5iVKTFg7hDCYRWwPLCxl/HvdSFsCDC2p9r7Tv7irwc8S+Qp4nrZ0NB+
         bOMQ==
X-Gm-Message-State: AOAM533jCm2gbPez5a/Yy+rwLZmK8CyHJ2lEcrB/nH2WZaXCn7zj+UEM
        eDn9lIKz8OwgDugn7/S1N21qFWU6W9HVmQr+i3Obs+VVgtmxW8vYvq3CP68GOWeLLGKggLFEbWr
        vwYG9tLN9q5g3GweRCmza79ioHnJRPz9riCauKgbtsafHx95yD3/Jn+HLdQ==
X-Google-Smtp-Source: ABdhPJwZDKNQlsUnHZraFFPcE7A3H4P+YPGaj/qrgSCw6NcEqrnJWEnXnHuiI1GtNHjgEe+RC23lwe2TQOQ=
X-Received: by 2002:a17:902:d341:: with SMTP id l1mr8177774plk.134.1596726882920;
 Thu, 06 Aug 2020 08:14:42 -0700 (PDT)
Date:   Thu,  6 Aug 2020 15:14:33 +0000
In-Reply-To: <20200806151433.2747952-1-oupton@google.com>
Message-Id: <20200806151433.2747952-5-oupton@google.com>
Mime-Version: 1.0
References: <20200806151433.2747952-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v3 4/4] Documentation: kvm: fix some typos in cpuid.rst
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

