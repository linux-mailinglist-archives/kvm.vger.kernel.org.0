Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5A72642D5
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 11:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbgIJJvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 05:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729781AbgIJJu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 05:50:58 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30099C061573;
        Thu, 10 Sep 2020 02:50:58 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d9so4329841pfd.3;
        Thu, 10 Sep 2020 02:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=OgkTz9HeACnxw9UKomrR35bJybah4ILZigVJyKdJFAk=;
        b=bT2deRD9cdMr7UlHENM4BxShWiRI2zk5deFCpYY9GDQ/c2k6s1Ffh5MJQmx7OM+EeM
         woUytm2M5vOcJ6/T8E0PshQL7GSAIo9mE9i9slya6VfDSE5Jwb6RiTB9BZLuFd9oohZL
         FjExujdtHQbFw7MT517OEGcfF2xaeb+Tg+4hnBiddMJQgTDDKPKYHvK8lAcOkI4ds3qm
         YFDG0int/YhiYxw3WEWoqKPgh4WHDD2na+V+wGVHZ2cL+1nf9S8ftHobuFVdAXGNlZ4d
         ZYGwD3MONdsW/Pu8YK7NQ+OgmkQvOFZKw1g1hXI02M7pj9dwygSlZGAq5it4IG+30Wvr
         JAKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OgkTz9HeACnxw9UKomrR35bJybah4ILZigVJyKdJFAk=;
        b=ohx1u08PKJmcrGmlqvIZN2kTIsEugvrPL8lZtXY7l8AMuQJH8dkmk+uJQ2eP2VIzdG
         yVWc7g8TVnHHplB53g4jJmpBBti9xtNosb4hFuBVFSQ+QKV0um63MKaHqEcwsNwkQVhE
         hb8AY+tFBRMjk3Ed218OH+9PzZzX5Iajj/8iZetN0P+IuPQJCuvZUgrTIMZyILZ0hrrz
         RL944qQtYzbUGNa0ResQg6y4Yr1gsLF4/yg/bXffJINecz88nq9cG5AoGfrAnYHKHBfg
         e49xwLNiQTcQr0KdHXlJCXiuJ37TwLiz+65uiudBgtoljrlG9cmVD6BnDzaLNZdqao0U
         Vg8A==
X-Gm-Message-State: AOAM532ukEXyiFUWD+9Ei3uwFYYk48tGThC1msgSTHIXG66ol6Tv4ShK
        rBU2DrfYQiYas6WfRzYXkgP0pxw/cpw=
X-Google-Smtp-Source: ABdhPJyYpFpYKlL5dwUrH8CJ5X/Nzsu7FTw6xwzLZxscv4LQXYoiisi3Raz6kgq1x8doMUPwZgHWFA==
X-Received: by 2002:a62:92c8:0:b029:13e:d13d:a106 with SMTP id o191-20020a6292c80000b029013ed13da106mr4754123pfd.34.1599731457503;
        Thu, 10 Sep 2020 02:50:57 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id e1sm2576534pfl.162.2020.09.10.02.50.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 02:50:56 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 0/9] KVM: collect sporadic patches
Date:   Thu, 10 Sep 2020 17:50:35 +0800
Message-Id: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Collect sporadic patches for easy apply.

Wanpeng Li (9):
  KVM: LAPIC: Return 0 when getting the tscdeadline timer if the lapic
    is hw disabled
  KVM: LAPIC: Guarantee the timer is in tsc-deadline mode when setting
  KVM: LAPIC: Fix updating DFR missing apic map recalculation
  KVM: VMX: Don't freeze guest when event delivery causes an APIC-access
    exit
  KVM: LAPIC: Narrow down the kick target vCPU
  KVM: LAPIC: Reduce world switch latency caused by timer_advance_ns
  KVM: SVM: Get rid of handle_fastpath_set_msr_irqoff()
  KVM: SVM: Move svm_complete_interrupts() into svm_vcpu_run()
  KVM: SVM: Reenable handle_fastpath_set_msr_irqoff() after
    complete_interrupts()

 arch/x86/kvm/lapic.c   | 36 ++++++++++++++++++++----------------
 arch/x86/kvm/svm/svm.c | 17 +++++++++--------
 arch/x86/kvm/vmx/vmx.c |  5 ++---
 arch/x86/kvm/x86.c     |  6 ------
 arch/x86/kvm/x86.h     |  1 -
 5 files changed, 31 insertions(+), 34 deletions(-)

-- 
2.7.4

