Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C90D3A5BA4
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 04:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhFNC4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Jun 2021 22:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbhFNC4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Jun 2021 22:56:03 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D412CC0617AF
        for <kvm@vger.kernel.org>; Sun, 13 Jun 2021 19:54:01 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id c29-20020ac86e9d0000b0290247b267c8e4so6544668qtv.22
        for <kvm@vger.kernel.org>; Sun, 13 Jun 2021 19:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EFssac9rz7i/Qr9EpSWwLvB4XY7qiCj+W7+6Jhxuqag=;
        b=LYERAZ7y42UfbmbPlfdmiRT+5SUAlpPUpcnKAJ06pnxNMruCW5nQs9eoLdhY4QqimU
         Bw60ALBxFeHcd/4Y9jIRzBOR9/jMvrFmonm5knRkEcDKOB3k8Nb4pdzKFF+bTNo8qSkm
         LW4hKTBMV2DNjCzUzntynYfjW6IAKSv/c/Xb2y6CY8rqY5Rw4e+W4wgtv7ZA858F3JCH
         Zl4LhituKwhgS7GcTCyVhu28y+SbW3QLn/N4f5Iatuc8SttyxjK8JXA4Tnh9QopWwUl4
         oZCcRWH9m6pqfBku+n2hHpfC7LViqfP68y/Fz+T5Qfck+/1uBFBrVHOLCvaP8cjdEJAO
         vTUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EFssac9rz7i/Qr9EpSWwLvB4XY7qiCj+W7+6Jhxuqag=;
        b=ud4qXru7V95VRnHkT3u+7qXbSbfvEc8aW6enGHLeDO9F90gEYL1flzsjUg2x8CmR5x
         OU6kAdh39kAdB7QI3uRoALiEiLreDbX+pOmJisx7WbK4PUQo+BHidSLP8oKefLgjGIEZ
         NXsEVVX145t0RuZ9MSWwKy/5QFbYLF/wweaMCyFIGanzZ4vK2zK2JgEiOzLp9QrBTUvu
         0zhnaA8hB1ltUWv96K3glE4aYt2nK1BIbvcF9AJyA6vrVNWhv7P2EmIzWn5w4WCDOibn
         CvLRlKP3wn2RgQx6eUeeKhYpWEJb+mvXm3xzC00lasvJBMXMEDuyCG2Qf9yyVs2Xjo/T
         ZcJw==
X-Gm-Message-State: AOAM532evxp/3QwfG0KFFz2FjfS6tcRFpZiHXyc43vwD9kuna8h9bShO
        cLbuadojBUlCj6RaK9356uU9kZ3fCC8XFfAzU4ovgKquj5MSZGsCNt5mFzuUldFOBLvT+OspAxn
        xycwK+JUXkN3orxAjKK0Zbfcy59rmhxabmaL+IGRLuYU996mQYEgoZtLJoWdGtMJkyysDC4w=
X-Google-Smtp-Source: ABdhPJx06RmEFcd18ZQJLMbPbZxx739B0LLW3SWUDB8V4bqvcXAZJX+M+bK78AWrb7OsWvWt/mmcsnPMfO++tuNCdA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6214:20c4:: with SMTP id
 4mr8552573qve.1.1623639240966; Sun, 13 Jun 2021 19:54:00 -0700 (PDT)
Date:   Mon, 14 Jun 2021 02:53:50 +0000
In-Reply-To: <20210614025351.365284-1-jingzhangos@google.com>
Message-Id: <20210614025351.365284-4-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210614025351.365284-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 3/4] KVM: stats: Update documentation supporting stats mode
 and offset
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fuad Tabba <tabba@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update documentation to reflect that stats descriptor supports new
flags for read/write mode and an offset field is added in stats
descriptor.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 Documentation/virt/kvm/api.rst | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d1ad30212726..67979700a90e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5160,12 +5160,19 @@ below code block::
 	#define KVM_STATS_BASE_POW2		(0x1 << KVM_STATS_BASE_SHIFT)
 	#define KVM_STATS_BASE_MAX		KVM_STATS_BASE_POW2
 
+        #define KVM_STATS_MODE_SHIFT		12
+        #define KVM_STATS_MODE_MASK		(0xF << KVM_STATS_MODE_SHIFT)
+        #define KVM_STATS_MODE_RW		(0x0 << KVM_STATS_MODE_SHIFT)
+        #define KVM_STATS_MODE_READ		(0x1 << KVM_STATS_MODE_SHIFT)
+        #define KVM_STATS_MODE_WRITE		(0x2 << KVM_STATS_MODE_SHIFT)
+        #define KVM_STATS_MODE_MAX		KVM_STATS_MODE_WRITE
+
 	struct kvm_stats_desc {
 		__u32 flags;
 		__s16 exponent;
 		__u16 size;
-		__u32 unused1;
-		__u32 unused2;
+		__u32 offset;
+		__u32 unused;
 		char name[0];
 	};
 
@@ -5212,23 +5219,35 @@ Bits 4-7 of ``flags`` encode the unit:
     value is 200, ``exponent`` is 4, we can get the number of CPU clock cycles
     by ``value * pow(10, exponent) = 200 * pow(10, 4) = 2000000``.
 
-Bits 7-11 of ``flags`` encode the base:
+Bits 8-11 of ``flags`` encode the base:
   * ``KVM_STATS_BASE_POW10``
     The scale is based on power of 10. It is used for measurement of time and
     CPU clock cycles.
   * ``KVM_STATS_BASE_POW2``
     The scale is based on power of 2. It is used for measurement of memory size.
 
+Bits 12-15 of ``flags`` encode the mode:
+  * ``KVM_STATS_MODE_RW``
+    The corresponding statistics supports both read and write (clear).
+  * ``KVM_STATS_MODE_READ``
+    The corresponding statistics supports read only.
+  * ``KVM_STATS_MODE_WRITE``
+    The corresponding statistics supports write only. (Not used for now, added
+    for completeness)
+
 The ``exponent`` field is the scale of corresponding statistics data. For
 example, if the unit is ``KVM_STATS_UNIT_BYTES``, the base is
 ``KVM_STATS_BASE_POW2``, the ``exponent`` is 10, then we know that the real
 unit of the statistics data is KBytes a.k.a pow(2, 10) = 1024 bytes.
 
-The ``size`` field is the number of values of this statistics data. It is in the
-unit of ``unsigned long`` for VM or ``__u64`` for VCPU.
+The ``size`` field is the number of values (u64) of this statistics data. Its
+value is usually 1 for most of simple statistics.
+
+The ``offset`` field is the offset from the start of Data Block to the start of
+the corresponding statistics data.
 
-The ``unused1`` and ``unused2`` fields are reserved for future
-support for other types of statistics data, like log/linear histogram.
+The ``unused`` fields are reserved for future support for other types of
+statistics data, like log/linear histogram.
 
 The ``name`` field points to the name string of the statistics data. The name
 string starts at the end of ``struct kvm_stats_desc``.
-- 
2.32.0.272.g935e593368-goog

