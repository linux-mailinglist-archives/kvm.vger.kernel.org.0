Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DE63E42D2
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 11:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbhHIJe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 05:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbhHIJex (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 05:34:53 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B91C0613D3;
        Mon,  9 Aug 2021 02:34:33 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id k2so15672547plk.13;
        Mon, 09 Aug 2021 02:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=biNAy5h7oVY1q9CMKi2TrD2G8iCaEg6EwP+zpkG0x9I=;
        b=KOFlhkZ8VT9Gg9IfumWNsU68mB6qyhv3ke4WeNu4vQGPDja7D1rSsGobfSJIEz+trR
         tO10tcI5Hsvj8CxNRUpQLmai/t3R9HPXZ5Hmed/L/L7VveGjC9KkQOocGuCJ2kT9PodI
         wJdX5yFTlyHJ/2XcQS23jBgqwZPNeHKskN59LNx5u5k+qRP8DlSvjgPrPR6MPqSQhK+b
         jeUio+sEk/0O7teaVuE4PNUumxMPAsUNNedzbRoTF/xU0ZDvauzppZXLw4npMgEMbNlQ
         ZxhZeWFhU+fCA4cbtTIW8adOo9zshLEb0xohK0qyccRqe729ErkEWDbBBat+wdIF74sV
         2eBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=biNAy5h7oVY1q9CMKi2TrD2G8iCaEg6EwP+zpkG0x9I=;
        b=Y2Zjz5eF0dec/wfwAww9DYRJozS+ezuT92sFM88W8ijJHKK7yDRUGlTrs15IVuavKH
         zZeL0o/3DtgJkoHLXQmZwdRJgu8dtrkoDjAKArGy3XqaArJz5lvXK0HDMBNJ8lVsYOcU
         +YPLDEKiKXuAgOtC+CWUFVkutPk3E8mU326fMZQjc+RLdYQ7ro/VcrCNMVYKzJoDyayU
         izPkk58vRLBozsxGhWdM4LKqSs9OmOz0QdyHAExzflanYqaXAhFBRqLh4R0DWlCm30CY
         lrSooBGE6Zdo/5VXXBKu8d3jzGD4Luznqn0MiXV0Xn0ITl20phP+XDETAGEauhi0srOg
         1sbA==
X-Gm-Message-State: AOAM531iZ8wQwzN7TM3EzI89yLIIPJYgpAY4YOvmpvcgcbZiFpglH0qb
        3FJHI+f7jAOQKUWP7bbBwJU=
X-Google-Smtp-Source: ABdhPJxKQ+0mIcms3UnGJli7b+FS7AElw6vbE0y7uJR2PIKScPY3i57ziCBYSkdhDkTL5xfz7FhBKA==
X-Received: by 2002:a17:903:31c3:b029:ed:6f74:49c7 with SMTP id v3-20020a17090331c3b02900ed6f7449c7mr19366644ple.12.1628501673150;
        Mon, 09 Aug 2021 02:34:33 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h188sm10839982pfg.45.2021.08.09.02.34.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 02:34:32 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] KVM: x86: Clean up redundant pr_fmt(fmt) macro definition for svm
Date:   Mon,  9 Aug 2021 17:34:10 +0800
Message-Id: <20210809093410.59304-6-likexu@tencent.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809093410.59304-1-likexu@tencent.com>
References: <20210809093410.59304-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The svm specific pr_fmt(fmt) macro is repeatedly defined in svm code
and the new one has never been used outside the svm context.

Let's move it to svm.h without any intended functional changes.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/avic.c   | 2 --
 arch/x86/kvm/svm/nested.c | 2 --
 arch/x86/kvm/svm/svm.c    | 2 --
 arch/x86/kvm/svm/svm.h    | 3 +++
 4 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a8ad78a2faa1..8b055f9ad9fe 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -12,8 +12,6 @@
  *   Avi Kivity   <avi@qumranet.com>
  */
 
-#define pr_fmt(fmt) "SVM: " fmt
-
 #include <linux/kvm_types.h>
 #include <linux/hashtable.h>
 #include <linux/amd-iommu.h>
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 57c288ba6ef0..3080776a55a5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -12,8 +12,6 @@
  *   Avi Kivity   <avi@qumranet.com>
  */
 
-#define pr_fmt(fmt) "SVM: " fmt
-
 #include <linux/kvm_types.h>
 #include <linux/kvm_host.h>
 #include <linux/kernel.h>
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2b6632d4c76f..4a3f8ef56daa 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1,5 +1,3 @@
-#define pr_fmt(fmt) "SVM: " fmt
-
 #include <linux/kvm_host.h>
 
 #include "irq.h"
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index bd0fe94c2920..76d5fe3f00dc 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -15,6 +15,9 @@
 #ifndef __SVM_SVM_H
 #define __SVM_SVM_H
 
+#undef pr_fmt
+#define pr_fmt(fmt) "SVM: " fmt
+
 #include <linux/kvm_types.h>
 #include <linux/kvm_host.h>
 #include <linux/bits.h>
-- 
2.32.0

