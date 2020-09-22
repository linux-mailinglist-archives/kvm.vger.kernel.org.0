Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FC927379D
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 02:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729350AbgIVAlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 20:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729036AbgIVAk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 20:40:59 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6569C061755
        for <kvm@vger.kernel.org>; Mon, 21 Sep 2020 17:40:59 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id q131so12355700qke.22
        for <kvm@vger.kernel.org>; Mon, 21 Sep 2020 17:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=kaVjY3pUnRyNkcqQ+wVStnw4aNjDpVWSIpiyJwQk3hM=;
        b=NzlEG3pMa4LAPyw5A4qMlN21mE2oVkOifW4wsp0GltmmOJdRWj73QzooJxEB84Aeh7
         dwyd04/U+wB+LB+pHb2q2J6TsMz5x9WJM3GZw3qrcdILExfo1xSoRGLpskcjOjOMiYcH
         P405BPOdXAP8cd8kT1ihZkBOWSWKE33ZM7WtagvKbUuwNk4Mr6EDeyi8M6vuAEwGrbr8
         Gk2Q266kF5ND2MP+GdfP/fwrNhKxaPgBU6Y4Tp2fI4Dt/MW4CS1aq6FnfZuBSJMVc5lG
         YyNz/thr7BtjOH8GCEu3gfy8iOI1WT9e7iUYiCk1fiIDlIofQnWlD+jKYadkPUisVbcs
         V/IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kaVjY3pUnRyNkcqQ+wVStnw4aNjDpVWSIpiyJwQk3hM=;
        b=p1Bp+xhuTwRk2V6F0d5UeRTPKYV6VnPh5YNMM2JeQ97KGHe/5V0XiSkwVjNyPiv7Zh
         SJC+kNBZy1DUPEcoBeeptFtc5zVagKbIPD9Fh6VbgEvzf7iMLNeStpIUoS7gioaX7PbZ
         Xmybwb3dxKGAeRsP06d5SE325fo9YNYyS1zLe4b6YWG1XzQNMy+tCVQ0enQUNQ9gymSI
         QSgU3AIbvVwqT5rBaYRdAjzunRkWKJJQqJTEjzAO0R1LYZDpPYQK2sSDHYIwyEU2JtC9
         +ppoNsBBxMZk1LM29zZfk9078kkM/QKqWMjPAm8G1scP3u5J7ojYhMcdfoAlprE4dV2o
         pCjw==
X-Gm-Message-State: AOAM532nnZ5mQomP5ihSObLzLjra8KPzM0OPW7FMHdBuNDWp8VGu6ZCW
        IiKb07wWjh+vMoSyYcjEQn57N+KRyUH9
X-Google-Smtp-Source: ABdhPJym5F9+vtb5khA7NMloj/CkMeW16IPsfEOaDbOQHBkE0JF4HAwxB6Ap8U3NqmZ9VPQD048sv8IIVaZi
Sender: "vipinsh via sendgmr" <vipinsh@vipinsh.kir.corp.google.com>
X-Received: from vipinsh.kir.corp.google.com ([2620:0:1008:10:1ea0:b8ff:fe75:b885])
 (user=vipinsh job=sendgmr) by 2002:a0c:e2c9:: with SMTP id
 t9mr3215691qvl.48.1600735258933; Mon, 21 Sep 2020 17:40:58 -0700 (PDT)
Date:   Mon, 21 Sep 2020 17:40:24 -0700
In-Reply-To: <20200922004024.3699923-1-vipinsh@google.com>
Message-Id: <20200922004024.3699923-3-vipinsh@google.com>
Mime-Version: 1.0
References: <20200922004024.3699923-1-vipinsh@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [RFC Patch 2/2] KVM: SVM: SEV cgroup controller documentation
From:   Vipin Sharma <vipinsh@google.com>
To:     thomas.lendacky@amd.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, tj@kernel.org, lizefan@huawei.com
Cc:     joro@8bytes.org, corbet@lwn.net, brijesh.singh@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, gingell@google.com,
        rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Erdem Aktas <erdemaktas@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV cgroup controller documentation.

Documentation for both cgroup versions, v1 and v2, of SEV cgroup
controller. SEV controller is used to distribute and account SEV ASIDs
usage by KVM on AMD processor.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Rientjes <rientjes@google.com>
Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
Reviewed-by: Erdem Aktas <erdemaktas@google.com>
---
 Documentation/admin-guide/cgroup-v1/sev.rst | 94 +++++++++++++++++++++
 Documentation/admin-guide/cgroup-v2.rst     | 56 +++++++++++-
 2 files changed, 147 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/sev.rst

diff --git a/Documentation/admin-guide/cgroup-v1/sev.rst b/Documentation/admin-guide/cgroup-v1/sev.rst
new file mode 100644
index 000000000000..04d0024360a1
--- /dev/null
+++ b/Documentation/admin-guide/cgroup-v1/sev.rst
@@ -0,0 +1,94 @@
+==============
+SEV Controller
+==============
+
+Overview
+========
+
+The SEV controller regulates the distribution of SEV ASIDs. SEV ASIDs are used
+in creating encrypted VMs on AMD processors. SEV ASIDs are stateful and one
+ASID is only used in one KVM object at a time. It cannot be used with other KVM
+before unbinding it from the previous KVM.
+
+All SEV ASIDs are tracked by this controller and it allows for accounting and
+distribution of this resource.
+
+How to Enable Controller
+========================
+
+- Enable memory encryption on AMD platform::
+
+        CONFIG_KVM_AMD_SEV=y
+
+- Enable SEV controller::
+
+        CONFIG_CGROUP_SEV=y
+
+- Above options will build SEV controller support in the kernel.
+  To mount sev controller::
+
+        mount -t cgroup -o sev none /sys/fs/cgroup/sev
+
+Interface Files
+==============
+
+  sev.current
+        A read-only single value file which exists on non-root cgroups.
+
+        The total number of SEV ASIDs currently in use by the cgroup and its
+        descendants.
+
+  sev.max
+        A read-write single value file which exists on non-root cgroups. The
+        default is "max".
+
+        SEV ASIDs usage hard limit. If the cgroup's current SEV ASIDs usage
+        reach this limit then the new SEV VMs creation will return error
+        -EBUSY.  This limit cannot be set lower than sev.current.
+
+  sev.events
+        A read-only flat-keyed single value file which exists on non-root
+        cgroups. A value change in this file generates a file modified event.
+
+          max
+                 The number of times the cgroup's SEV ASIDs usage was about to
+                 go over the max limit. This is a tally of SEV VM creation
+                 failures in the cgroup.
+
+Hierarchy
+=========
+
+SEV controller supports hierarchical accounting. It supports following
+features:
+
+1. SEV ASID usage in the cgroup includes itself and its descendent cgroups.
+2. SEV ASID usage can never exceed the max limit set in the cgroup and its
+   ancestor's chain up to the root.
+3. SEV events keep a tally of SEV VM creation failures in the cgroup and not in
+   its child subtree.
+
+Suppose the following example hierarchy::
+
+                        root
+                        /  \
+                       A    B
+                       |
+                       C
+
+1. A will show the count of SEV ASID used in A and C.
+2. C's SEV ASID usage may not exceed any of the max limits set in C, A, or
+   root.
+3. A's event file lists only SEV VM creation failed in A, and not the ones in
+   C.
+
+Migration and SEV ASID ownership
+================================
+
+An SEV ASID is charged to the cgroup which instantiated it, and stays charged
+to that cgroup until that SEV ASID is freed. Migrating a process to a different
+cgroup do not move the SEV ASID charge to the destination cgroup where the
+process has moved.
+
+Deletion of a cgroup with existing ASIDs charges will migrate those ASIDs to
+the parent cgroup.
+
diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6be43781ec7f..66b8bdee8ff3 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -63,8 +63,11 @@ v1 is available under :ref:`Documentation/admin-guide/cgroup-v1/index.rst <cgrou
        5-7-1. RDMA Interface Files
      5-8. HugeTLB
        5.8-1. HugeTLB Interface Files
-     5-8. Misc
-       5-8-1. perf_event
+     5-9 SEV
+       5-9-1 SEV Interface Files
+       5-9-2 SEV ASIDs Ownership
+     5-10. Misc
+       5-10-1. perf_event
      5-N. Non-normative information
        5-N-1. CPU controller root cgroup process behaviour
        5-N-2. IO controller root cgroup process behaviour
@@ -2109,6 +2112,54 @@ HugeTLB Interface Files
 	are local to the cgroup i.e. not hierarchical. The file modified event
 	generated on this file reflects only the local events.
 
+SEV
+---
+
+The SEV controller regulates the distribution of SEV ASIDs. SEV ASIDs are used
+in creating encrypted VMs on AMD processors. SEV ASIDs are stateful and one
+ASID is only used in one KVM object at a time. It cannot be used with other KVM
+before unbinding it from the previous KVM.
+
+All SEV ASIDs are tracked by this controller and it allows for accounting and
+distribution of this resource.
+
+SEV Interface Files
+~~~~~~~~~~~~~~~~~~~
+
+  sev.current
+        A read-only single value file which exists on non-root cgroups.
+
+        The total number of SEV ASIDs currently in use by the cgroup and its
+        descendants.
+
+  sev.max
+        A read-write single value file which exists on non-root cgroups. The
+        default is "max".
+
+        SEV ASIDs usage hard limit. If the cgroup's current SEV ASIDs usage
+        reach this limit then the new SEV VMs creation will return error
+        -EBUSY.  This limit cannot be set lower than sev.current.
+
+  sev.events
+        A read-only flat-keyed single value file which exists on non-root
+        cgroups. A value change in this file generates a file modified event.
+
+          max
+                 The number of times the cgroup's SEV ASIDs usage was about to
+                 go over the max limit. This is a tally of SEV VM creation
+                 failures in the cgroup.
+
+SEV ASIDs Ownership
+~~~~~~~~~~~~~~~~~~~
+
+An SEV ASID is charged to the cgroup which instantiated it, and stays charged
+to the cgroup until the ASID is freed. Migrating a process to a different
+cgroup do not move the SEV ASID charge to the destination cgroup where the
+process has moved.
+
+Deletion of a cgroup with existing ASIDs charges will migrate those ASIDs to
+the parent cgroup.
+
 Misc
 ----
 
@@ -2120,7 +2171,6 @@ automatically enabled on the v2 hierarchy so that perf events can
 always be filtered by cgroup v2 path.  The controller can still be
 moved to a legacy hierarchy after v2 hierarchy is populated.
 
-
 Non-normative information
 -------------------------
 
-- 
2.28.0.681.g6f77f65b4e-goog

