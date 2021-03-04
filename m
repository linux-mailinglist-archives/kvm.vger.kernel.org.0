Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D357732DDB8
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 00:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhCDXUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 18:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbhCDXT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 18:19:58 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D09C06175F
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 15:19:58 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id h10so21733698qvf.19
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 15:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=9IvSzdbIQqhRyiLJGvOnZfh3hjug63Y1v74jXsaZzZ4=;
        b=VUg8JS9esKxgJWQYeNlIzJMv7J5UCwAEn9AMSgO287mOoiWqXjSpqdssGtIduTiM4C
         2CCOvYag+IijZjoV9/WVXuJF2mWAH15yxfEnXdcauXFD+5BrdwRNxA0YtL7GNYKIRM8O
         FPrE/nHGdjLL5z2m6gnnfO0uw3uSCDpHBarfDEvXOVa/9Wbddi+9EhLffgVfeOtECb30
         UhH8JlovXbpoZAwIijoUlGUKuHPTedj6B0bBL6+wgHcgfnoR+2VrjqV/m0MUbjylNJaS
         Xvr/XyqAMkdEBc/gNRZqG5MUu1icZGhhm1XywvN9o5ymWWCeV8FsjtYCLDumfLnpXN7w
         I0Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9IvSzdbIQqhRyiLJGvOnZfh3hjug63Y1v74jXsaZzZ4=;
        b=feLkWtNWlOiHzJMfnmeWFGo9IOXi7+kE3hSnCjogVd/7h+sRzymbWcj05rvlcZqMiN
         23pOACLPGVTAr5W4Bav4WyM7CGNdGlG3QM3XUGbChBxutFygsEYAj34WuYvAAQHvppwV
         M5hte4DU2AVbxIIH/+0SZjQI09aToDTHZkASl3KbuhNl3+SCNoFDuLxo9H4l7W5lSpIA
         7WQDBvfyASH8hKB2SxZK7r2d0/DcK9uIV6hjcOFi9HTcH0bo2Qq/gzBXaIXs2e386vUA
         sYfcSyenC8ZPOwqUMLyOm6iua+GpIOtrMSXA0FxPz6BOl/WnQ29yUAjQwe7DmmUqw+8j
         /9og==
X-Gm-Message-State: AOAM531WjiEUH89k7EyFWYW3EfUWHCL1YzIQX4cXLjT7+mHSEZZ5HbIf
        E6kuh145s1fL5bt+m9PZy0f29pYtpnXu
X-Google-Smtp-Source: ABdhPJzQ4UL90vQgpQH42Fu9aOvSGIfVFVvsaXTA5xGaLFstkGCwyeaT6vZtX18j0w5LBvPvs35Oen1A1UJb
Sender: "vipinsh via sendgmr" <vipinsh@vipinsh.kir.corp.google.com>
X-Received: from vipinsh.kir.corp.google.com ([2620:0:1008:10:1b1:4021:52a5:84d])
 (user=vipinsh job=sendgmr) by 2002:a05:6214:d4b:: with SMTP id
 11mr6511589qvr.42.1614899997447; Thu, 04 Mar 2021 15:19:57 -0800 (PST)
Date:   Thu,  4 Mar 2021 15:19:46 -0800
In-Reply-To: <20210304231946.2766648-1-vipinsh@google.com>
Message-Id: <20210304231946.2766648-3-vipinsh@google.com>
Mime-Version: 1.0
References: <20210304231946.2766648-1-vipinsh@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [Patch v3 2/2] cgroup: sev: Miscellaneous cgroup documentation.
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

Documentation of miscellaneous cgroup controller. This new controller is
used to track and limit the usage of scalar resources.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Rientjes <rientjes@google.com>
---
 Documentation/admin-guide/cgroup-v1/index.rst |  1 +
 Documentation/admin-guide/cgroup-v1/misc.rst  |  4 ++
 Documentation/admin-guide/cgroup-v2.rst       | 69 ++++++++++++++++++-
 3 files changed, 72 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/misc.rst

diff --git a/Documentation/admin-guide/cgroup-v1/index.rst b/Documentation/admin-guide/cgroup-v1/index.rst
index 226f64473e8e..99fbc8a64ba9 100644
--- a/Documentation/admin-guide/cgroup-v1/index.rst
+++ b/Documentation/admin-guide/cgroup-v1/index.rst
@@ -17,6 +17,7 @@ Control Groups version 1
     hugetlb
     memcg_test
     memory
+    misc
     net_cls
     net_prio
     pids
diff --git a/Documentation/admin-guide/cgroup-v1/misc.rst b/Documentation/admin-guide/cgroup-v1/misc.rst
new file mode 100644
index 000000000000..661614c24df3
--- /dev/null
+++ b/Documentation/admin-guide/cgroup-v1/misc.rst
@@ -0,0 +1,4 @@
+===============
+Misc controller
+===============
+Please refer "Misc" documentation in Documentation/admin-guide/cgroup-v2.rst
diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 1de8695c264b..74777323b7fd 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -63,8 +63,11 @@ v1 is available under :ref:`Documentation/admin-guide/cgroup-v1/index.rst <cgrou
        5-7-1. RDMA Interface Files
      5-8. HugeTLB
        5.8-1. HugeTLB Interface Files
-     5-8. Misc
-       5-8-1. perf_event
+     5-9. Misc
+       5.9-1 Miscellaneous cgroup Interface Files
+       5.9-2 Migration and Ownership
+     5-10. Others
+       5-10-1. perf_event
      5-N. Non-normative information
        5-N-1. CPU controller root cgroup process behaviour
        5-N-2. IO controller root cgroup process behaviour
@@ -2163,6 +2166,68 @@ HugeTLB Interface Files
 Misc
 ----
 
+The Miscellaneous cgroup provides the resource limiting and tracking
+mechanism for the scalar resources which cannot be abstracted like the other
+cgroup resources. Controller is enabled by the CONFIG_CGROUP_MISC config
+option.
+
+The first two resources added to the miscellaneous controller are Secure
+Encrypted Virtualization (SEV) ASIDs and SEV - Encrypted State (SEV-ES) ASIDs.
+These limited ASIDs are used for encrypting virtual machines memory on the AMD
+platform.
+
+Misc Interface Files
+~~~~~~~~~~~~~~~~~~~~
+
+Miscellaneous controller provides 3 interface files:
+
+  misc.capacity
+        A read-only flat-keyed file shown only in the root cgroup.  It shows
+        miscellaneous scalar resources available on the platform along with
+        their quantities::
+
+	  $ cat misc.capacity
+	  sev 50
+	  sev_es 10
+
+  misc.current
+        A read-only flat-keyed file shown in the non-root cgroups.  It shows
+        the current usage of the resources in the cgroup and its children.::
+
+	  $ cat misc.current
+	  sev 3
+	  sev_es 0
+
+  misc.max
+        A read-write flat-keyed file shown in the non root cgroups. Allowed
+        maximum usage of the resources in the cgroup and its children.::
+
+	  $ cat misc.max
+	  sev max
+	  sev_es 4
+
+	Limit can be set by::
+
+	  # echo sev 1 > misc.max
+
+	Limit can be set to max by::
+
+	  # echo sev max > misc.max
+
+        Limits can be set higher than the capacity value in the misc.capacity
+        file.
+
+Migration and Ownership
+~~~~~~~~~~~~~~~~~~~~~~~
+
+A miscellaneous scalar resource is charged to the cgroup in which it is used
+first, and stays charged to that cgroup until that resource is freed. Migrating
+a process to a different cgroup does not move the charge to the destination
+cgroup where the process has moved.
+
+Others
+------
+
 perf_event
 ~~~~~~~~~~
 
-- 
2.30.1.766.gb4fecdf3b7-goog

