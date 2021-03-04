Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B6F32DDB3
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 00:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhCDXT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 18:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbhCDXTw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 18:19:52 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D923C061574
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 15:19:52 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id q77so398379ybq.0
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 15:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=/tCag2eM5nibLNaUG4o5xV/pF/skcGVt2I4xreL6gfI=;
        b=LQXYw+cnQ5skNeBCxADkh40ZLQqdcnVS3py7rRwFSc5jFkf7xMzj9/kzaAN030I1cc
         ALcihEajKRdWwIjzVkdnEEJ5clsDxKQCKHquzcrv8S9dEvFia/6LDSqmEcIN11QY9L6s
         saub2b4HcnLstNNeZJqAxnWxq24Uy7PY/kp2g+fFrOD3byGvmkozYDdoNEj/CKOcCnzr
         mAe6R+sOd5omrR9C1LNlE2Xm/myYz5zAmPVWmxnMkeZ0NlyjRM2duTuxU/21B5qSsWFQ
         jaWvUqgeCXHh+Gdf8ecYjuYDFAHn+R3NKCwzyTigP2dz/HK4C6F8nONvHgpXHdCe/Efg
         uRcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=/tCag2eM5nibLNaUG4o5xV/pF/skcGVt2I4xreL6gfI=;
        b=cpSmces3SP2L/Wkg9SSzmLWTmpIuiSsi/7numMUxoJkc042lpXmFYIzw9Q9MDdLvlW
         vYYJxulkoF28nJLs5ha42Qka1Fl4Tyq+T9FFYpSYU4oxlSviULLKbae17SqqwLy9v7lU
         KwLku57DOcvOVC67qhcQw34KQ8Tv2EMOYEe3Snx0dj9M/EWRB1tMJ8imzxTysGWIvs6X
         rZJSJCdhmRyFonq86AttxGuBF7HG3O++lFAyqwQE0W1oReFhadd0xeYpYeNbG3FPyxjc
         CcPyYxdoom7JFQxNWhiIu0MJCUy3yCmEzcMw43bh01p7WUUqoyY+0MT7cyIdk5QcKSSw
         99CA==
X-Gm-Message-State: AOAM533wOqB4xbvv4emkZhO6zM1k6tVPnqJV5/b2ktDxAv3oBfUavVgw
        a8FZC9hhrqyk4F2vBluj0cWCnIue54q6
X-Google-Smtp-Source: ABdhPJzCDUXR9u2rQTEwXTd/5pmu8kU2aaY9EivX2IsEE/Kg4Magvz6cMaCrKA0IcEd5OAkrrgrDlwzPON77
Sender: "vipinsh via sendgmr" <vipinsh@vipinsh.kir.corp.google.com>
X-Received: from vipinsh.kir.corp.google.com ([2620:0:1008:10:1b1:4021:52a5:84d])
 (user=vipinsh job=sendgmr) by 2002:a25:c707:: with SMTP id
 w7mr9662857ybe.225.1614899991739; Thu, 04 Mar 2021 15:19:51 -0800 (PST)
Date:   Thu,  4 Mar 2021 15:19:44 -0800
Message-Id: <20210304231946.2766648-1-vipinsh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [Patch v3 0/2] cgroup: New misc cgroup controller
From:   Vipin Sharma <vipinsh@google.com>
To:     tj@kernel.org, mkoutny@suse.com, rdunlap@infradead.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com
Cc:     corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, rientjes@google.com, dionnaglaze@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello

This patch series is creating a new misc cgroup controller for limiting
and tracking of resources which are not abstract like other cgroup
controllers.

This controller was initially proposed as encryption_id but after
the feedbacks, it is now changed to misc cgroup.
https://lore.kernel.org/lkml/20210108012846.4134815-2-vipinsh@google.com/

Changes in RFC v3:
1. Changed implementation to support 64 bit counters.
2. Print kernel logs only once per resource per cgroup.
3. Capacity can be set less than the current usage.

Changes in RFC v2:
1. Documentation fixes.
2. Added kernel log messages.
3. Changed charge API to treat misc_cg as input parameter.
4. Added helper APIs to get and release references on the cgroup.

[1] https://lore.kernel.org/lkml/20210218195549.1696769-1-vipinsh@google.com
[2] https://lore.kernel.org/lkml/20210302081705.1990283-1-vipinsh@google.com/

Vipin Sharma (2):
  cgroup: sev: Add misc cgroup controller
  cgroup: sev: Miscellaneous cgroup documentation.

 Documentation/admin-guide/cgroup-v1/index.rst |   1 +
 Documentation/admin-guide/cgroup-v1/misc.rst  |   4 +
 Documentation/admin-guide/cgroup-v2.rst       |  69 ++-
 arch/x86/kvm/svm/sev.c                        |  65 ++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 include/linux/cgroup_subsys.h                 |   4 +
 include/linux/misc_cgroup.h                   | 130 ++++++
 init/Kconfig                                  |  14 +
 kernel/cgroup/Makefile                        |   1 +
 kernel/cgroup/misc.c                          | 402 ++++++++++++++++++
 10 files changed, 679 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/misc.rst
 create mode 100644 include/linux/misc_cgroup.h
 create mode 100644 kernel/cgroup/misc.c

-- 
2.30.1.766.gb4fecdf3b7-goog

