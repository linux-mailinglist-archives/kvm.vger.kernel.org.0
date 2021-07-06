Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5413BDCA7
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 20:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhGFSGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 14:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhGFSGg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jul 2021 14:06:36 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDDEC06175F
        for <kvm@vger.kernel.org>; Tue,  6 Jul 2021 11:03:57 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id t6-20020ac80dc60000b029024e988e8277so11678038qti.23
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 11:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tuY40cRvRjb7LOqoOokdd2WJ/UxGgrW/aY+HZzkwyxg=;
        b=JKuSvh3Qc1mRz3g4jUBCdl2w09FhmvGwIfnYfp9xP+FtJqgtmVsQABLLq8SzosvZeG
         XQMAcz5oNR0Kvpm88UUF1Hv0nJAawGBAz44WgC1zlL8snKRmCDelTxJ6zXewwInLreho
         gRT23nzYjyFztpPSTgbNYqnLvTNG5JQa96PZie7dURMDxsp3f6KF70LiCr/rdeEJTf/p
         cR6PF87TowUIMfWwBUrRikvODGnpghvGqfDHeCoLqSRabTJk439L6LECYGzOkO5YjF/2
         Ghqii2tje0ASDIf4jbGE/4HxZ1PzyPt7R8UNXAgZz8WcjJEgrEew3FerGZR5aYBWfLmH
         2Uzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tuY40cRvRjb7LOqoOokdd2WJ/UxGgrW/aY+HZzkwyxg=;
        b=Qbht7PcT4QunIgAVdqCmAqgfS2WpKJooTceq0ayf1ernOqhT7T3g/JvpjCXiosA3cl
         E2Mjv81J6p7q30zIilTc03gqEf3qQHUPpBRRr0QmlrczkeHN07sB0dy7Wvxfwtaw4PD+
         upu3CITXOQbf+qz1/OgqmVNTmGSI2RR66lVd3YqKfR0sy1W1di3NvEM6RCIWfGc2BPME
         8CfpurZlORyJ1vE9qUjh8iphKGhV6h6VPTfnVui7KCCfBgKwK8PaLBtQXTVnkg88MUzH
         RNV01ga0ayxoWbkLzMCedWBeumOFyeUKRJNNZ/SaW5jVEGfZF4+1/ZMKDSuHoIr5b/sn
         qqqw==
X-Gm-Message-State: AOAM533C+nIa8aisjmgWfAbxD7wut6t5kl2+eT7qKY+2my771u6Lq9yJ
        gzImbu47tt/QSOsjXUK44Tuz+rb0M3g7OJFBOF1GkCAmUIPYOcSeLdfB75kX/g6oMqOjBUvCiNR
        RoVqWXzIF/k2j1CteC8XTpKnKySeVUGAijee9CqmH8A2cD6CZyFNhdHAZf/u005/HfiTAIrY=
X-Google-Smtp-Source: ABdhPJzESY6ESFJ2Ic1TWEY5cky+ur7M+9iz9D+Pqke5K3ovUn094YlKNjld75ok0TZ4vd3AePg6RNxzDS9NOtgRzw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a0c:b38c:: with SMTP id
 t12mr19376471qve.44.1625594636671; Tue, 06 Jul 2021 11:03:56 -0700 (PDT)
Date:   Tue,  6 Jul 2021 18:03:48 +0000
In-Reply-To: <20210706180350.2838127-1-jingzhangos@google.com>
Message-Id: <20210706180350.2838127-3-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210706180350.2838127-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v1 2/4] KVM: stats: Update doc for histogram statistics
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
Add binary stats capability text which is missing during merge of
the binary stats patch.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 Documentation/virt/kvm/api.rst | 36 +++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3b6e3b1628b4..948d33c26704 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5171,6 +5171,9 @@ by a string of size ``name_size``.
 	#define KVM_STATS_TYPE_CUMULATIVE	(0x0 << KVM_STATS_TYPE_SHIFT)
 	#define KVM_STATS_TYPE_INSTANT		(0x1 << KVM_STATS_TYPE_SHIFT)
 	#define KVM_STATS_TYPE_PEAK		(0x2 << KVM_STATS_TYPE_SHIFT)
+	#define KVM_STATS_TYPE_LINEAR_HIST	(0x3 << KVM_STATS_TYPE_SHIFT)
+	#define KVM_STATS_TYPE_LOG_HIST		(0x4 << KVM_STATS_TYPE_SHIFT)
+	#define KVM_STATS_TYPE_MAX		KVM_STATS_TYPE_LOG_HIST
 
 	#define KVM_STATS_UNIT_SHIFT		4
 	#define KVM_STATS_UNIT_MASK		(0xF << KVM_STATS_UNIT_SHIFT)
@@ -5178,11 +5181,13 @@ by a string of size ``name_size``.
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
@@ -5214,6 +5219,22 @@ Bits 0-3 of ``flags`` encode the type:
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
+    buckets is specified by the ``size`` field. The base of logarithm is
+    specified by the ``hist_param`` field. The range of the Nth bucket (1 < N <
+    ``size``) is [pow(``hist_param``, N-2), pow(``hist_param``, N-1)). The range
+    of the first bucket is [0, 1), while the range of the last bucket is
+    [pow(``hist_param``, ``size``-2), +INF). The bucket value indicates how many
+    times the statistics data is in the bucket's range.
 
 Bits 4-7 of ``flags`` encode the unit:
   * ``KVM_STATS_UNIT_NONE``
@@ -5246,9 +5267,10 @@ unsigned 64bit data.
 The ``offset`` field is the offset from the start of Data Block to the start of
 the corresponding statistics data.
 
-The ``unused`` field is reserved for future support for other types of
-statistics data, like log/linear histogram. Its value is always 0 for the types
-defined above.
+The ``hist_param`` field is used as a parameter for histogram statistics data.
+For linear histogram statistics data, it indicates the size of a bucket. For
+logarithmic histogram statistics data, it indicates the base of the logarithm.
+Only base of 2 is supported fo logarithmic histogram.
 
 The ``name`` field is the name string of the statistics data. The name string
 starts at the end of ``struct kvm_stats_desc``.  The maximum length including
@@ -7182,3 +7204,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_STATS_BINARY_FD
+----------------------------
+
+:Architectures: all
+
+This capability indicates the feature that userspace can get a file descriptor
+for every VM and VCPU to read statistics data in binary format.
-- 
2.32.0.93.g670b81a890-goog

