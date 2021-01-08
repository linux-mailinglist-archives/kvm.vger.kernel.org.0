Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B742EF60D
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 17:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbhAHQyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 11:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727242AbhAHQyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 11:54:39 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4B0C061380
        for <kvm@vger.kernel.org>; Fri,  8 Jan 2021 08:53:59 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id f33so8736963qtb.1
        for <kvm@vger.kernel.org>; Fri, 08 Jan 2021 08:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=B4cmagUJvqsvM8KJ5vcfLLw3GzVKlYfhlZ7WKpaii2Q=;
        b=g2ySYlslVFQEhuaHS7k+EtkU/c4zzrCRoDUa5ArebteqUm80XrjjPCM4k5ePja3PTf
         qMSdK4AimLDRv70ypB97L9lzMmDlMKy8CQa20AuroYeZ77AgtpjzOVnSrBBIENWRCiRc
         elogZg/UOmOgI7nNL130bYIZLGwLdXGrrlet16+9hTkz8+KIIm61s7BR7QTYN4jiyT4q
         FKyIvCM9A5g8Pb3dSmMJ1wdl+FpqLtZSAmz+n+MOu9VkEs4exSOPOL2S0nyTe6ZpKd1G
         4WrFtJwhRkmCU0w9t4p8S+zYE3EcshcBme0wKw0umqaH7oY8YeIYWFYShcjhV37gYQM+
         RNhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=B4cmagUJvqsvM8KJ5vcfLLw3GzVKlYfhlZ7WKpaii2Q=;
        b=YbfweHOi2Tz+s2wXm4d/Li2WaVleLC4DC69RdcXy/rLrSze5/hdkN/8gbAMxmHrXdd
         Lii1o1SxlArwNaqkK62O+Zwmxht/NC1JtLxYDmCRaaPse9PINALJdtCCUUZFvkvuhHFM
         CvxaHAGVIWPZ11a3KwGIncQTLsZyMUyURimOTtQ5Bf7mF0NG4gfe5C+WBHixOzuGkoGB
         vEf4Wi0Eyhw5BxGBpnNH83znVO0Lb1aD0vHK2RMHS1BdbgAQKZ2YS09k7J+uP5s336G3
         4r7a7+9VLhVPXcM4YOYltVjZrWrbhXQkASq7JLYsbkUlnqnL1qRQsuPAwGtWyZ+ezVxA
         8GrQ==
X-Gm-Message-State: AOAM532fJdY1Hwk4XOeDHVv99N8vFxnJiC1f7n4my1vo1+1Qv/dTnQ7k
        9syzw+XZPpgJS9a+nUofHn60JioiWQ8V
X-Google-Smtp-Source: ABdhPJz0ATVlqOcvXwgcYlNfRWv/oEcTQtMpwLVM4J6J727f8fSNNP+cR7MOSfTNDQ2kHT21jmqtIgkIu85h
Sender: "qperret via sendgmr" <qperret@r2d2-qp.c.googlers.com>
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:ad4:4f41:: with SMTP id
 eu1mr4188454qvb.1.1610124838785; Fri, 08 Jan 2021 08:53:58 -0800 (PST)
Date:   Fri,  8 Jan 2021 16:53:49 +0000
Message-Id: <20210108165349.747359-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH] KVM: Documentation: Fix spec for KVM_CAP_ENABLE_CAP_VM
From:   Quentin Perret <qperret@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     android-kvm@google.com, kernel-team@android.com,
        Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The documentation classifies KVM_ENABLE_CAP with KVM_CAP_ENABLE_CAP_VM
as a vcpu ioctl, which is incorrect. Fix it by specifying it as a VM
ioctl.

Fixes: e5d83c74a580 ("kvm: make KVM_CAP_ENABLE_CAP_VM architecture agnostic")
Signed-off-by: Quentin Perret <qperret@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 70254eaa5229..68898b623d86 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1328,7 +1328,7 @@ documentation when it pops into existence).
 
 :Capability: KVM_CAP_ENABLE_CAP_VM
 :Architectures: all
-:Type: vcpu ioctl
+:Type: vm ioctl
 :Parameters: struct kvm_enable_cap (in)
 :Returns: 0 on success; -1 on error
 
-- 
2.30.0.284.gd98b1dd5eaa7-goog

