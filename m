Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D562EEAF2
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 02:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbhAHBaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 20:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729552AbhAHBaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 20:30:04 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB36C061282
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 17:29:07 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id m8so7015791qvt.14
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 17:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ZHuHq1gX+rq+gSbDq4B8XNZLvR61GpcraAJJ94pG5jI=;
        b=n3wOhNlwvyXw4HZZk7N77vwCHd/iR01CfCyBgoB0P4g5WYyP9L4b/JLXPZX6lUKD+C
         LVQeyta6aZyaSpnIA1WLGCK60IK9lm6I9BwRlKijkskFOcLqLkxfjYw4iQJkrYHRKEfB
         wIg0N6KnqF95/looJaAv6BGrD8C0RxqhISgjozlHJzjZaLzW7tpxULLbKAQiyQ/BADAA
         GtOj1cRzgOILZnCqWiyGwiHVTY1VE0gp/XqlI6emnrhOnC4POLIGcjvArNe0i6Xmd38Z
         WcHMfyoeiQEg3eoQCIauLC5Zgt1Brrdni9kIXFsvnSfbNhcvYDuIsKglZyGoMideN5/4
         9faA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZHuHq1gX+rq+gSbDq4B8XNZLvR61GpcraAJJ94pG5jI=;
        b=kWRWMeerXZ/aqGq5psn65bXh8der67EmmDUGr+oAKJ+s1mszaCuAdYbPDBkdfME5OP
         8Z3RvXSsQzWlFLJKYx8UGv6YmO49cOhJmXHPUtqUVIZK7vwWDVHmo6OZsCCk/KLWd0v2
         SWRqgk5R9oIBCxbb72H5kAaF7dutrnmO3UeJTGBP+lopOsl90FQr1Hs9AItX4+VSzeYt
         Du8z39759xZ6wBma9Klm+cULt80VcYPkNVFyS2y8dL0fBRhVAIVB3njdN07ag00a788u
         dsQWZ+xcSfEJfmXyXwS6sCbht1iw9oCR/gc2tlIiEGuEHyXiD3/f885Uykw8AbhTX0IA
         V76Q==
X-Gm-Message-State: AOAM5321SB4sico7T1oaqcjiNUjtLiwY4liDYtx+l89WFKpYFaFJcAca
        ErA20MfV2eeBCfkIdbLNYRZdB6Lmo1Cd
X-Google-Smtp-Source: ABdhPJxtCr1FuLGd3jUgdrALOLHJ3pQLuqVJ8xwNqCOs0HZRNRe/Kj6a1CL5fBPQ4THyxzd2Di1MC3ME9aMm
Sender: "vipinsh via sendgmr" <vipinsh@vipinsh.kir.corp.google.com>
X-Received: from vipinsh.kir.corp.google.com ([2620:0:1008:10:1ea0:b8ff:fe75:b885])
 (user=vipinsh job=sendgmr) by 2002:ad4:4f11:: with SMTP id
 fb17mr1429085qvb.46.1610069346396; Thu, 07 Jan 2021 17:29:06 -0800 (PST)
Date:   Thu,  7 Jan 2021 17:28:46 -0800
In-Reply-To: <20210108012846.4134815-1-vipinsh@google.com>
Message-Id: <20210108012846.4134815-3-vipinsh@google.com>
Mime-Version: 1.0
References: <20210108012846.4134815-1-vipinsh@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [Patch v4 2/2] cgroup: svm: Encryption IDs cgroup documentation.
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
index 63521cd36ce5..b6ea47b9e882 100644
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
@@ -2160,6 +2163,77 @@ HugeTLB Interface Files
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
2.29.2.729.g45daf8777d-goog

