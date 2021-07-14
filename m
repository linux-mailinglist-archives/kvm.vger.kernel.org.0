Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD213C93DB
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 00:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbhGNWdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 18:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbhGNWdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 18:33:35 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C775C061760
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 15:30:42 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id k3-20020a6568c30000b029022887377adeso2712483pgt.15
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 15:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8XizaOLNigUNpC9Dwn5fRe5kCM6P7X2OH+X0AAfHNv0=;
        b=lIHJIUEhYgsfIVcuXOj2x2gJyZJ5gPcUGG1iXf69ABeEA1PwhadTIpxNzqSuICnqG6
         AlJ01r7cEHXvgt3w4CCcFSAA4W4jBRUOX+zbi/mkdGTz+VHTZLDNBGk0rNS6dKefPpRY
         Umt211MalkIkAKFSTjMTnlKgXWmkuAZdzijWpKYPZwdW7A/CLpFoRT1PdkV/aZreLVvf
         d66Qy7seRwzxghkXBrfvvDhKAcMCC5umCmmlJVdMLpweQHtUrkGmBVeqQFRdBRQuBeN5
         w9Jbf/+ulDFMUq3dlgoBqIC36NA0Wb00jZb2QBUuas/9nU6M+HUn2fqxBaX/ta9LHUug
         Su7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8XizaOLNigUNpC9Dwn5fRe5kCM6P7X2OH+X0AAfHNv0=;
        b=lta9c5eCxYt6rlCuYCDS+s5dYwxIchGyMmha+aJTeQBJ4Ti1TiZozMWGs87cO9ScXn
         UFntCPNNrmgIxOZDdUQ+jlDYUz/Zcu+PhPfSzdvpwkzQg/Bkju2FzohrpiNVrIN+n7r9
         aq32QCDuWkIdi2a9hP78BZtT9txERKb9Hq5hQWkgoXW+L3NiKLFGUFGmeeWW9Upy0oFi
         65vyGyYbm9QVZ/A+EqHBGzhswGaDMA8beCU1moNVDiKSFLTphWLQD5nrdnRcT7lWbalG
         r1xm/RPZTLPDOjrdaQfx0asGvf5CULD7ZgGrAaUficpJtYEYsQ/aTqpid0XpENrwb5hA
         A1ow==
X-Gm-Message-State: AOAM532XEZ8hzQIL4E5Syu3OlbAYFA4HQN+8oVqAAI2tFB7RCiAe9VAr
        AuhK4Pe5Ph+zzMTasPksu7l3t2qj8B7c4E5gWrLHLBXLk1TWrtUotCEGsg2i//EN6SVMDX3uKo3
        xaPrdZ+FhiC04zlj+nTToCv+FzRdWYDoWgC+xKRBgHZbZ3lcJYTsgCgE7q7hGOxo4rAgG5ZM=
X-Google-Smtp-Source: ABdhPJxkquTJrpafWNjf+vRDCUU2OXKY+VTtAtXkQF0Rw1LqYiv4dAYfxoh+IGLNHgt3T363WDQU3Bo7uW5JxHS0TA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:778f:b029:128:b3e1:15f8 with
 SMTP id o15-20020a170902778fb0290128b3e115f8mr248466pll.14.1626301841672;
 Wed, 14 Jul 2021 15:30:41 -0700 (PDT)
Date:   Wed, 14 Jul 2021 22:30:30 +0000
In-Reply-To: <20210714223033.742261-1-jingzhangos@google.com>
Message-Id: <20210714223033.742261-4-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210714223033.742261-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 3/6] KVM: stats: Update doc for histogram statistics
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add documentations for linear and logarithmic histogram statistics.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 Documentation/virt/kvm/api.rst | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 889b19a58b33..bcd3b77fa4e8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5207,6 +5207,9 @@ by a string of size ``name_size``.
 	#define KVM_STATS_TYPE_CUMULATIVE	(0x0 << KVM_STATS_TYPE_SHIFT)
 	#define KVM_STATS_TYPE_INSTANT		(0x1 << KVM_STATS_TYPE_SHIFT)
 	#define KVM_STATS_TYPE_PEAK		(0x2 << KVM_STATS_TYPE_SHIFT)
+	#define KVM_STATS_TYPE_LINEAR_HIST	(0x3 << KVM_STATS_TYPE_SHIFT)
+	#define KVM_STATS_TYPE_LOG_HIST		(0x4 << KVM_STATS_TYPE_SHIFT)
+	#define KVM_STATS_TYPE_MAX		KVM_STATS_TYPE_LOG_HIST
 
 	#define KVM_STATS_UNIT_SHIFT		4
 	#define KVM_STATS_UNIT_MASK		(0xF << KVM_STATS_UNIT_SHIFT)
@@ -5214,18 +5217,20 @@ by a string of size ``name_size``.
 	#define KVM_STATS_UNIT_BYTES		(0x1 << KVM_STATS_UNIT_SHIFT)
 	#define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
 	#define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
+	#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_CYCLES
 
 	#define KVM_STATS_BASE_SHIFT		8
 	#define KVM_STATS_BASE_MASK		(0xF << KVM_STATS_BASE_SHIFT)
 	#define KVM_STATS_BASE_POW10		(0x0 << KVM_STATS_BASE_SHIFT)
 	#define KVM_STATS_BASE_POW2		(0x1 << KVM_STATS_BASE_SHIFT)
+	#define KVM_STATS_BASE_MAX		KVM_STATS_BASE_POW2
 
 	struct kvm_stats_desc {
 		__u32 flags;
 		__s16 exponent;
 		__u16 size;
 		__u32 offset;
-		__u32 unused;
+		__u32 bucket_size;
 		char name[];
 	};
 
@@ -5250,6 +5255,21 @@ Bits 0-3 of ``flags`` encode the type:
     represents a peak value for a measurement, for example the maximum number
     of items in a hash table bucket, the longest time waited and so on.
     The corresponding ``size`` field for this type is always 1.
+  * ``KVM_STATS_TYPE_LINEAR_HIST``
+    The statistics data is in the form of linear histogram. The number of
+    buckets is specified by the ``size`` field. The size of buckets is specified
+    by the ``hist_param`` field. The range of the Nth bucket (1 <= N < ``size``)
+    is [``hist_param``*(N-1), ``hist_param``*N), while the range of the last
+    bucket is [``hist_param``*(``size``-1), +INF). (+INF means positive infinity
+    value.) The bucket value indicates how many times the statistics data is in
+    the bucket's range.
+  * ``KVM_STATS_TYPE_LOG_HIST``
+    The statistics data is in the form of logarithmic histogram. The number of
+    buckets is specified by the ``size`` field. The range of the first bucket is
+    [0, 1), while the range of the last bucket is [pow(2, ``size``-2), +INF).
+    Otherwise, The Nth bucket (1 < N < ``size``) covers
+    [pow(2, N-2), pow(2, N-1)). The bucket value indicates how many times the
+    statistics data is in the bucket's range.
 
 Bits 4-7 of ``flags`` encode the unit:
   * ``KVM_STATS_UNIT_NONE``
@@ -5282,9 +5302,9 @@ unsigned 64bit data.
 The ``offset`` field is the offset from the start of Data Block to the start of
 the corresponding statistics data.
 
-The ``unused`` field is reserved for future support for other types of
-statistics data, like log/linear histogram. Its value is always 0 for the types
-defined above.
+The ``bucket_size`` field is used as a parameter for histogram statistics data.
+It is only used by linear histogram statistics data, specifying the size of a
+bucket.
 
 The ``name`` field is the name string of the statistics data. The name string
 starts at the end of ``struct kvm_stats_desc``.  The maximum length including
-- 
2.32.0.402.g57bb445576-goog

