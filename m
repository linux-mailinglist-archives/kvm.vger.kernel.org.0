Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9755B2EEAED
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 02:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbhAHB3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 20:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729637AbhAHB3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 20:29:40 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BF5C0612F9
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 17:29:00 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id 32so5240153plf.3
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 17:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=UMAjKymYTdkz3wAZcW0ar3R52PKBGQEKlAaIA5W8JIc=;
        b=VkP6PA7UE9/mTi1zArELyLAnbHzFz9zmWujz5LV472BF45d0K+LOCwmZjUewY/CnlL
         5p08Q87+7zDNT2cVA3FY2+GOOoMq399zFzY5srDg8xvmG+GEeACkNboVC/dBsSlAKIP/
         Tr3OBHba424Ambsx8muEqncyjt6Rcs56TQ7LAs9usMK5Y9Bh6eRMyWUSTwYvbRufYK5d
         btoxwHV6D1NXm3145EaHKhuIZzt3l9zAbeetJaubCXA43wZx7xdjgpSDCQvPlIDI9czw
         inPhXzb6umDZQYFrj1YJPJqlloNBcrEflq1i7le/blUzlVf0QOo9X+I9bdi0wQXQk95l
         mGew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=UMAjKymYTdkz3wAZcW0ar3R52PKBGQEKlAaIA5W8JIc=;
        b=Q9cZyZO4vcHrECOfYjnUZVduZBWSJKmqZfKuquIkow5Y4of9iZU81C9TUpr2Id9JNa
         zooW0iyXs5/B7c0JPLUMwyXB4gL9AUKlxNYUndDKR4gQRDzimr/qRNyE0qvHIbMRqbQF
         fwUFuANXArErpJ2XwXjdwIYIkhFvunMB1lihqZ/rsZBxEjCZfjnm2GwPdAM6VYnpwjKC
         wCp1syIBEOFDXS0nVe3AaQZIMAXs3xagTlodImjCwoh9QiXBDoBa/cRsbJRSV4JDTGks
         GgSwEalHDRi9r4zuQ6KC7+1nfT2rFZCDr8yPbuhR176xaJmYhL1FQLGp3153CbN7bChY
         M/2A==
X-Gm-Message-State: AOAM533/jWdJoQM/jn8IViXKdgZ89xbrDg11vpZXqcTk+PRpzDpqKTlk
        C4eUUiG8i2yGV4+gpeu71iQ3QBJNdQty
X-Google-Smtp-Source: ABdhPJywgrK9jyMUDKCNz3m0wFnLKznB0xVRQSlCqGFsJdE96eJQiXYDVSV4yV82EEY/h+cPxsoBC4cwL/qw
Sender: "vipinsh via sendgmr" <vipinsh@vipinsh.kir.corp.google.com>
X-Received: from vipinsh.kir.corp.google.com ([2620:0:1008:10:1ea0:b8ff:fe75:b885])
 (user=vipinsh job=sendgmr) by 2002:aa7:8813:0:b029:19d:cd3b:6f89 with SMTP id
 c19-20020aa788130000b029019dcd3b6f89mr1241032pfo.42.1610069339726; Thu, 07
 Jan 2021 17:28:59 -0800 (PST)
Date:   Thu,  7 Jan 2021 17:28:44 -0800
Message-Id: <20210108012846.4134815-1-vipinsh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [Patch v4 0/2] cgroup: KVM: New Encryption IDs cgroup controller
From:   Vipin Sharma <vipinsh@google.com>
To:     thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com,
        tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net
Cc:     joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

This patch adds a new cgroup controller, Encryption IDs, to track and
limit the usage of encryption IDs on a host.

AMD provides Secure Encrypted Virtualization (SEV) and SEV with
Encrypted State (SEV-ES) to encrypt the guest OS's memory using limited
number of Address Space Identifiers (ASIDs).

This limited number of ASIDs creates issues like SEV ASID starvation and
unoptimized scheduling in the cloud infrastucture.

In the RFC patch v1, I provided only SEV cgroup controller but based
on the feedback and discussion it became clear that this cgroup
controller can be extended to be used by Intel's Trusted Domain
Extension (TDX) and s390's protected virtualization Secure Execution IDs
(SEID)

This patch series provides a generic Encryption IDs controller with
tracking support of the SEV and SEV-ES ASIDs.

Changes in v4:
- The max value can be set lower than the current.
- Added SEV-ES support.

Changes in v3:
- Fixes a build error when CONFIG_CGROUP is disabled.

Changes in v2:
- Changed cgroup name from sev to encryption_ids.
- Replaced SEV specific names in APIs and documentations with generic
  encryption IDs.
- Providing 3 cgroup files per encryption ID type. For example in SEV,
  - encryption_ids.sev.stat (only in the root cgroup directory).
  - encryption_ids.sev.max
  - encryption_ids.sev.current

[1] https://lore.kernel.org/lkml/20200922004024.3699923-1-vipinsh@google.com/
[2] https://lore.kernel.org/lkml/20201208213531.2626955-1-vipinsh@google.com/
[3] https://lore.kernel.org/lkml/20201209205413.3391139-1-vipinsh@google.com/

Vipin Sharma (2):
  cgroup: svm: Add Encryption ID controller
  cgroup: svm: Encryption IDs cgroup documentation.

 .../admin-guide/cgroup-v1/encryption_ids.rst  | 108 +++++
 Documentation/admin-guide/cgroup-v2.rst       |  78 +++-
 arch/x86/kvm/svm/sev.c                        |  52 ++-
 include/linux/cgroup_subsys.h                 |   4 +
 include/linux/encryption_ids_cgroup.h         |  72 +++
 include/linux/kvm_host.h                      |   4 +
 init/Kconfig                                  |  14 +
 kernel/cgroup/Makefile                        |   1 +
 kernel/cgroup/encryption_ids.c                | 422 ++++++++++++++++++
 9 files changed, 741 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/encryption_ids.rst
 create mode 100644 include/linux/encryption_ids_cgroup.h
 create mode 100644 kernel/cgroup/encryption_ids.c

-- 
2.29.2.729.g45daf8777d-goog

