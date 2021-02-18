Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C9431F0B1
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 21:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhBRUBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 15:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbhBRT7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 14:59:22 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4C0C061797
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 11:56:18 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id u3so3923710ybj.13
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 11:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=zhEDZA4JbZSAj5/ePKSx+KCgThTXAMSnv6lc/wPfgfs=;
        b=QME2l0CHS+bmS8ezIa3F+1hGntliqb4UvifKWFGGVmp9YGFOfca7qXz9i8ZsYCofh+
         EK03WC0fEogRlgwusm44pcfMBH8OdNwALCgg3nfK0N0tJOfpJgAUxPkQIU8L+Q4gG8/z
         T908c5y4ixfiOlGrrd6mIqKVNKP8e3DD+Bke1tA8smqaO2/JBRHz1VVjI3YtPhRjDldf
         Vz2jceBvzK/fv98k17OAfxq06E6qx++CgjKm4j2r3bMbpl7Kx/YlXa8nsd54Ny7QnNpK
         CdvaAtKU6AEcA91VHbO3K2/+LMKEu1mBCBGGUQXPee1G7nMamaiDjeT3mksBSdcn/1Wr
         51Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zhEDZA4JbZSAj5/ePKSx+KCgThTXAMSnv6lc/wPfgfs=;
        b=XxOz21HLPhQi3caeFnP88bqbQKWun6fAw5TLrfVqB6uxKk7SpL0iwEnvzYtLRi14ku
         sDG+c3ep8UCRVevItRr2Ia3zT2qKIUINi1bc5nLN0rqBQfnKvszh1Ael6qsi6EORD7kS
         Bd20GhuGNVxF8z7h1Jzcc826e9ix46Ujl+f5SC83i3WmoZL11lUfLrSwufxQqwtgTYn1
         1qpfozBte2CfmLnxih1XyNsglhDnGN/Pm2sTw6EdKzOUFLlE+Abj/PFKybnnKeV88uV3
         rIonPsqihzVCGZvve7eQFVq7rt4OOgvUb0XXYXwJEKAE/3TA7kQBcwtAwdzNm2GQPAN1
         fYwA==
X-Gm-Message-State: AOAM532aSYm6J9Tm/3u/rhLFQbVXqs29hQNRWQFUQm0LXnnFBq7LVoSs
        L354eW52Da21Qj+ZNdu/2iH7h/DexKL0
X-Google-Smtp-Source: ABdhPJxlLzfcvaG6UiGLb/A8n8lgC3FBoqtt2XP9SFO3BanNkp0ndOPvc9Y7ml9fisxFfjC7C188z0a5mDwF
Sender: "vipinsh via sendgmr" <vipinsh@vipinsh.kir.corp.google.com>
X-Received: from vipinsh.kir.corp.google.com ([2620:0:1008:10:580f:a4a0:74ce:b3b4])
 (user=vipinsh job=sendgmr) by 2002:a25:3104:: with SMTP id
 x4mr8725771ybx.141.1613678177550; Thu, 18 Feb 2021 11:56:17 -0800 (PST)
Date:   Thu, 18 Feb 2021 11:55:49 -0800
In-Reply-To: <20210218195549.1696769-1-vipinsh@google.com>
Message-Id: <20210218195549.1696769-3-vipinsh@google.com>
Mime-Version: 1.0
References: <20210218195549.1696769-1-vipinsh@google.com>
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
Subject: [RFC 2/2] cgroup: sev: Miscellaneous cgroup documentation.
From:   Vipin Sharma <vipinsh@google.com>
To:     tj@kernel.org, thomas.lendacky@amd.com, brijesh.singh@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com,
        hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com
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
used to track and limit usage of scalar resources.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Rientjes <rientjes@google.com>
---
 Documentation/admin-guide/cgroup-v1/misc.rst |  1 +
 Documentation/admin-guide/cgroup-v2.rst      | 64 +++++++++++++++++++-
 2 files changed, 63 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/misc.rst

diff --git a/Documentation/admin-guide/cgroup-v1/misc.rst b/Documentation/admin-guide/cgroup-v1/misc.rst
new file mode 100644
index 000000000000..8e9e9311daeb
--- /dev/null
+++ b/Documentation/admin-guide/cgroup-v1/misc.rst
@@ -0,0 +1 @@
+/Documentation/admin-guide/cgroup-v2.rst
diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 1de8695c264b..1a41a3623b9b 100644
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
@@ -2161,6 +2164,63 @@ HugeTLB Interface Files
 	generated on this file reflects only the local events.
 
 Misc
+--------------
+
+The Miscellaneous cgroup provides the resource allocation and tracking
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
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Miscellaneous controller provides 3 interface files:
+
+  misc.capacity
+        A read-only flat-keyed file shown only in the root cgroup.  It shows
+        miscellaneous scalar resources available on the platform along with
+        their quantities::
+	  $ cat misc.capacity
+	  sev 50
+	  sev_es 10
+
+  misc.current
+        A read-only flat-keyed file shown in the non-root cgroups.  It shows
+        the current usage of the resources in the cgroup and its children.::
+	  $ cat misc.current
+	  sev 3
+	  sev_es 0
+
+  misc.max
+        A read-write flat-keyed file shown in the non root cgroups. Allowed
+        maximum usage of the resources in the cgroup and its children.::
+	  $ cat misc.max
+	  sev max
+	  sev_es 4
+
+	Limit can be set by::
+	  # echo sev 1 > misc.max
+
+	Limit can be set to max by::
+	  # echo sev max > misc.max
+
+        Limits can be set more than the capacity value in the misc.capacity
+        file.
+
+Migration and Ownership
+~~~~~~~~~~~~~~~~~~~~~~~
+
+A miscellaneous scalar resource is charged to the cgroup in which it is used
+first, and stays charged to that cgroup until that resource is freed. Migrating
+a process to a different cgroup do not move the charge to the destination
+cgroup where the process has moved.
+
+Others
 ----
 
 perf_event
-- 
2.30.0.617.g56c4b15f3c-goog

