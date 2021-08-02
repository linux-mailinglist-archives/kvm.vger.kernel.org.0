Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B253DDE18
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 18:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhHBQ4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 12:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhHBQ4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 12:56:50 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B079C061760
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 09:56:40 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id p1-20020a17090a3481b029017757e8c762so539224pjb.1
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 09:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=n7kvyUwvmN2lWlXICtvoUP2GwE5hnziRhEMEYcR9kvU=;
        b=Zc72S8MgPQ6tqfASIqWQtoZnFmBJaUhfzOCzTiZpGvzciT1q4orsWxy53rNUX1+lDc
         Ub82uoOX1yR3ES1G5uwHdK0O2uy3yzUEkQC+35W/8YuvK/QaJmtn2/4kLzURnFVgySFr
         zJl5uReeaL8XAddh5HspCI7nuX4Ahs4DRREEDpHanIhjtUAYtM/5rgpzmLJF3SPSeWHR
         kVMfdfJwDDPnTg3OnRObEDKE2ShQZaLDb2I5XADdhnb5O/SAcqpn6OP3v5SulsxLoiCj
         vx2Xqr9NxmK6+A2BwGpYXD2ITaRVdT7dwF5M7jlIR7wugacn0krGjHPy+nr4kT+whSHW
         EFpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=n7kvyUwvmN2lWlXICtvoUP2GwE5hnziRhEMEYcR9kvU=;
        b=i16xorfXSMIdc5uxbCpJj504Slc4d7pR1fWqS+gQvh/C94e7JMQ87PFKTrwRKkWLyM
         mvNhHVwh+uChiLmlNjzMl3uQ8Xfvwhi6xLU4sxkSdiMCC+wzlx7a10xpOPUa3iVyeCJC
         jj8vSpmg0I2OnBwgO5fbJRiKxdRIJF9q3kI1QZX3ABXdX4NpgJ2MyCcB/RX6dqTkBf17
         6Zqf62P2jfloJPODypTethe+6WA1lHRW9153/bdWcBNB6T5mUOk7wjiJVgC58VzZtPgs
         tcLd/bGlO1ZT6KdjTX0fOWnXsgV62G6yMAhBUX0UtVUscJCGWexjy/m+r5RmdzuuRBdz
         v+7Q==
X-Gm-Message-State: AOAM5326wfHyj0lu7HinWLghOW0lZtBbDCmI5gJYvwUuIbnuf3JJf92e
        IbdlcXdAFk/J913Yh8wnuuLadiMovYZbAh06sTg7H58Ffqc99huBLSd5ot5Uyb+qBtfSW+SuqqJ
        ME75Mgl2cpCjMExVQnxH8g1g2wkFYPmIDBhDR78CyFJgcuHgiK0BEiWfx8fNYhLAAYhEYaes=
X-Google-Smtp-Source: ABdhPJwE3IZTCnHS7M6tPiGGDshf1eVqEiN0WFQv+g3f61Q+ROt5ht6ZfF3loZzdCm1wGVlE878ZbfVA+10kRckunA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:25c7:: with SMTP id
 l190mr2972782pgl.165.1627923399710; Mon, 02 Aug 2021 09:56:39 -0700 (PDT)
Date:   Mon,  2 Aug 2021 16:56:30 +0000
In-Reply-To: <20210802165633.1866976-1-jingzhangos@google.com>
Message-Id: <20210802165633.1866976-3-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210802165633.1866976-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 2/5] KVM: stats: Update doc for histogram statistics
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
index dae68e68ca23..095a32f968c6 100644
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
2.32.0.554.ge1b32706d8-goog

