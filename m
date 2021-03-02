Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4119432A6F5
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1838912AbhCBPzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377322AbhCBISs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 03:18:48 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E2FC061356
        for <kvm@vger.kernel.org>; Tue,  2 Mar 2021 00:17:18 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id e12so10812562plh.2
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 00:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=9IvSzdbIQqhRyiLJGvOnZfh3hjug63Y1v74jXsaZzZ4=;
        b=vjq0i7utFQfq/ROgloM8fVCwD3GgQjSjJzxE39PPfoolW/2BTnmUwVxfnbfg/xE8xf
         nurEyFcMwK9nSlqkfz+TWWrBExl5stjBN3maC6gC31KMD3tBteKgPHUq12s7UUgkwI9M
         vp0ePmNo9Ra+e+AbeLvDNxW6QBHsadhycldlmZuWH02z7uHsyD1QYqllyYU3eT01p+fk
         N2vJPKSArl7dvqr7FyBPla3CszX6Ce2ByDzrrm12jXWuSi0kZ2yktEAiVYRWZrBI7lA/
         KBQ/BHPJUdBBRMuJLk+UJD/X8LruP9bdJ6Fiw9PV3Pmud28l2jlck5kQNw4n2qMFnBC6
         lbqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9IvSzdbIQqhRyiLJGvOnZfh3hjug63Y1v74jXsaZzZ4=;
        b=EfehRYuQW/4BpfRXuiJfGZia67hiyDrxi3dFkwGBiKeHKu5GxbtyguaOXvcSoxGiYv
         850/Cul/mp/0gx1LqAO8Rw9QMOYJOSSt3lV6RQS+jRmYQG/pAE2pVuoVd4WUfzzLNEYR
         XsfjLOA4STyFp7jcyVxB0s5R9Uq4xVSoZWZ8ZgJRAWc9gmzZ57NOflvmmDthh36vkBjV
         N8uZpt2ytrWkUf3yqAeQIugbrBNro5Grjkr1JnbiRURFAD+DN5fkX2Fr3oRF2zBI9ZhT
         XLVMw+2dj9gGqN+Z22nBNx5cBJ1eKnWolXNvCVK59XvUQM28RfI3eO/efcDYydhcbbJj
         mTsA==
X-Gm-Message-State: AOAM531mxhwOhmg/Pdu6K0fyNiuyKVPgC/E5sc9H9XIxxmBtEqvvDPvO
        Ypt2OXRHf4qFdIkv48GEdckk7Bczai10
X-Google-Smtp-Source: ABdhPJyCXCm/dfyyzcTbG52l5hOFatdhe7phOhVOcb2mXZhlI38K9zFUo51+s70nURdhIGdIur5gyGdzY6gm
Sender: "vipinsh via sendgmr" <vipinsh@vipinsh.kir.corp.google.com>
X-Received: from vipinsh.kir.corp.google.com ([2620:0:1008:10:e829:dc2a:968a:1370])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:23c5:b029:1e6:2f2e:a438 with SMTP
 id g5-20020a056a0023c5b02901e62f2ea438mr19154226pfc.75.1614673038114; Tue, 02
 Mar 2021 00:17:18 -0800 (PST)
Date:   Tue,  2 Mar 2021 00:17:05 -0800
In-Reply-To: <20210302081705.1990283-1-vipinsh@google.com>
Message-Id: <20210302081705.1990283-3-vipinsh@google.com>
Mime-Version: 1.0
References: <20210302081705.1990283-1-vipinsh@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
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

