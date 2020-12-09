Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138972D4C4C
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 21:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgLIUzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 15:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387648AbgLIUzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 15:55:46 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88C6C061257
        for <kvm@vger.kernel.org>; Wed,  9 Dec 2020 12:54:31 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id 102so2185631qva.0
        for <kvm@vger.kernel.org>; Wed, 09 Dec 2020 12:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=UEByDBKZVfTm3zy0Um+iwW/BbeQm2aD/QnGz0kihyFg=;
        b=ZZcz5w8hLfLOHxneGPYFFfwps7INc5OkoifJ8uaoPPNzHPSzaFyHjKNbeiszev3376
         gVaF7bqgcQNoojSX/zVNbMZU73kTPEzxDIzg/EyLoeQ07RudCAySFyqNV5SXjfn5wFzh
         GjwV5Ro3ShF3QR4bGFy5OMH8ZURWRYYP/xeJfTz+whbrMCZ0f3slMUdJHLXeuaFdDLTB
         Qn9FGu+Iux2lU/r42Qt9LlkW8agnSxOYzA8eotGCcHD9Igy+Py7jrMlECZQ15nGUHF/h
         ATu2T23OR2/IfBikzQt7IqPXYGsHLr51rgp1yASWNNpSf244KljiHIekIG+lmb8E0+Gp
         d6Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UEByDBKZVfTm3zy0Um+iwW/BbeQm2aD/QnGz0kihyFg=;
        b=Kxus4ykjXQlGwSQ103xOdPv0EjFnSo9xWs2/KPVUQzN6pIapD9G6E/k8gZ+M8Fn3Bc
         tM0PiPl83dCSekTJb+IIePSfPIOIetBOMUgxO547tHLRFAqdcjaCneLgE2+5kgrqYAtQ
         RzjYoPLjgzeMnoxBjSm3LxZQwF5HBgN0mVHtfWzDi2W/5CaARpTRYFQusipzz/+j5Wby
         huI9Ni8xpSYMLL2nCI4OU4pr3oh+IqprNCJLUKForZCTjFPCeg0uLrOHdx0sgRgd5GL+
         0uI+wAPVs/Pykb4X9GIQa0fQglcSB5A9squk4HyTMhOv4U5nL39p+xWTpVjaPnbfIgzf
         IM2w==
X-Gm-Message-State: AOAM532OdGVxHbLiWFHcvUJfdrUOkzi+ZzBHpMIQBxeHq8Czh+Si7KRv
        S/OHvBAi+GJBJZrK7Rol58UIY5aVwH8T
X-Google-Smtp-Source: ABdhPJwRaDFLklc1Iv+Fy/OO2ENd2HnFDKRU3vISs9nP//YZj71qFSXL/VRYveDPTqEd3mJU5/chYHeiQvNM
Sender: "vipinsh via sendgmr" <vipinsh@vipinsh.kir.corp.google.com>
X-Received: from vipinsh.kir.corp.google.com ([2620:0:1008:10:1ea0:b8ff:fe75:b885])
 (user=vipinsh job=sendgmr) by 2002:ad4:4b67:: with SMTP id
 m7mr5153138qvx.5.1607547270856; Wed, 09 Dec 2020 12:54:30 -0800 (PST)
Date:   Wed,  9 Dec 2020 12:54:13 -0800
In-Reply-To: <20201209205413.3391139-1-vipinsh@google.com>
Message-Id: <20201209205413.3391139-3-vipinsh@google.com>
Mime-Version: 1.0
References: <20201209205413.3391139-1-vipinsh@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [Patch v3 2/2] cgroup: svm: Encryption IDs cgroup documentation.
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

Documentation for both cgroup versions, v1 and v2, of Encryption IDs
controller. This new controller is used to track and limit usage of
hardware memory encryption capabilities on the CPUs.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Rientjes <rientjes@google.com>
Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
---
 .../admin-guide/cgroup-v1/encryption_ids.rst  | 108 ++++++++++++++++++
 Documentation/admin-guide/cgroup-v2.rst       |  78 ++++++++++++-
 2 files changed, 184 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/encryption_ids.rst

diff --git a/Documentation/admin-guide/cgroup-v1/encryption_ids.rst b/Documentation/admin-guide/cgroup-v1/encryption_ids.rst
new file mode 100644
index 000000000000..891143b4e229
--- /dev/null
+++ b/Documentation/admin-guide/cgroup-v1/encryption_ids.rst
@@ -0,0 +1,108 @@
+=========================
+Encryption IDs Controller
+=========================
+
+Overview
+========
+There are multiple hardware memory encryption capabilities provided by the
+hardware vendors, like Secure Encrypted Virtualization (SEV) and SEV Encrypted
+State (SEV-ES) from AMD.
+
+These features are being used in encrypting virtual machines (VMs) and user
+space programs. However, only a small number of keys/IDs can be used
+simultaneously.
+
+This limited availability of these IDs requires system admin to optimize
+allocation, control, and track the usage of the resources in the cloud
+infrastructure. This resource also needs to be protected from getting exhausted
+by some malicious program and causing starvation for other programs.
+
+Encryption IDs controller provides capability to register the resource for
+controlling and tracking through the cgroups.
+
+How to Enable Controller
+========================
+
+- Enable Encryption controller::
+
+        CONFIG_CGROUP_ENCRYPTION_IDS=y
+
+- Above options will build Encryption controller support in the kernel.
+  To mount the Encryption controller::
+
+        mount -t cgroup -o encryption none /sys/fs/cgroup/encryption
+
+
+Interface Files
+===============
+Each encryption ID type have their own interface files,
+encryption_id.[ID TYPE].{max, current, stat}, where "ID TYPE" can be sev and
+sev-es.
+
+  encryption_ids.[ID TYPE].stat
+        A read-only flat-keyed single value file. This file exists only in the
+        root cgroup.
+
+        It shows the total number of encryption IDs available and currently in
+        use on the platform::
+          # cat encryption.sev.stat
+          total 509
+          used 0
+
+  encryption_ids.[ID TYPE].max
+        A read-write file which exists on the non-root cgroups. File is used to
+        set maximum count of "[ID TYPE]" which can be used in the cgroup.
+
+        Limit can be set to max by::
+          # echo max > encryption.sev.max
+
+        Limit can be set by::
+          # echo 100 > encryption.sev.max
+
+        This file shows the max limit of the encryption ID in the cgroup::
+          # cat encryption.sev.max
+          max
+
+        OR::
+          # cat encryption.sev.max
+          100
+
+        Limits can be set more than the "total" capacity value in the
+        encryption_ids.[ID TYPE].stat file, however, the controller ensures
+        that the usage never exceeds the "total" and the max limit.
+
+  encryption_ids.[ID TYPE].current
+        A read-only single value file which exists on non-root cgroups.
+
+        Shows the total number of encrypted IDs being used in the cgroup.
+
+Hierarchy
+=========
+
+Encryption IDs controller supports hierarchical accounting. It supports
+following features:
+
+1. Current usage in the cgroup shows IDs used in the cgroup and its descendent cgroups.
+2. Current usage can never exceed the corresponding max limit set in the cgroup
+   and its ancestor's chain up to the root.
+
+Suppose the following example hierarchy::
+
+                        root
+                        /  \
+                       A    B
+                       |
+                       C
+
+1. A will show the count of IDs used in A and C.
+2. C's current IDs usage may not exceed any of the max limits set in C, A, or
+   root.
+
+Migration and ownership
+=======================
+
+An encryption ID is charged to the cgroup in which it is used first, and
+stays charged to that cgroup until that ID is freed. Migrating a process
+to a different cgroup do not move the charge to the destination cgroup
+where the process has moved.
+
diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 608d7c279396..7938bb7c6e1c 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -63,8 +63,11 @@ v1 is available under :ref:`Documentation/admin-guide/cgroup-v1/index.rst <cgrou
        5-7-1. RDMA Interface Files
      5-8. HugeTLB
        5.8-1. HugeTLB Interface Files
-     5-8. Misc
-       5-8-1. perf_event
+     5-9. Encryption IDs
+       5.9-1 Encryption IDs Interface Files
+       5.9-2 Migration and Ownership
+     5-10. Misc
+       5-10-1. perf_event
      5-N. Non-normative information
        5-N-1. CPU controller root cgroup process behaviour
        5-N-2. IO controller root cgroup process behaviour
@@ -2149,6 +2152,77 @@ HugeTLB Interface Files
 	are local to the cgroup i.e. not hierarchical. The file modified event
 	generated on this file reflects only the local events.
 
+Encryption IDs
+--------------
+
+There are multiple hardware memory encryption capabilities provided by the
+hardware vendors, like Secure Encrypted Virtualization (SEV) and SEV Encrypted
+State (SEV-ES) from AMD.
+
+These features are being used in encrypting virtual machines (VMs) and user
+space programs. However, only a small number of keys/IDs can be used
+simultaneously.
+
+This limited availability of these IDs requires system admin to optimize
+allocation, control, and track the usage of the resources in the cloud
+infrastructure. This resource also needs to be protected from getting exhausted
+by some malicious program and causing starvation for other programs.
+
+Encryption IDs controller provides capability to register the resource for
+controlling and tracking through the cgroups.
+
+Encryption IDs Interface Files
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Each encryption ID type have their own interface files,
+encryption_id.[ID TYPE].{max, current, stat}, where "ID TYPE" can be sev and
+sev-es.
+
+  encryption_ids.[ID TYPE].stat
+        A read-only flat-keyed single value file. This file exists only in the
+        root cgroup.
+
+        It shows the total number of encryption IDs available and currently in
+        use on the platform::
+          # cat encryption.sev.stat
+          total 509
+          used 0
+
+  encryption_ids.[ID TYPE].max
+        A read-write file which exists on the non-root cgroups. File is used to
+        set maximum count of "[ID TYPE]" which can be used in the cgroup.
+
+        Limit can be set to max by::
+          # echo max > encryption.sev.max
+
+        Limit can be set by::
+          # echo 100 > encryption.sev.max
+
+        This file shows the max limit of the encryption ID in the cgroup::
+          # cat encryption.sev.max
+          max
+
+        OR::
+          # cat encryption.sev.max
+          100
+
+        Limits can be set more than the "total" capacity value in the
+        encryption_ids.[ID TYPE].stat file, however, the controller ensures
+        that the usage never exceeds the "total" and the max limit.
+
+  encryption_ids.[ID TYPE].current
+        A read-only single value file which exists on non-root cgroups.
+
+        Shows the total number of encrypted IDs being used in the cgroup.
+
+Migration and Ownership
+~~~~~~~~~~~~~~~~~~~~~~~
+
+An encryption ID is charged to the cgroup in which it is used first, and
+stays charged to that cgroup until that ID is freed. Migrating a process
+to a different cgroup do not move the charge to the destination cgroup
+where the process has moved.
+
 Misc
 ----
 
-- 
2.29.2.576.ga3fc446d84-goog

