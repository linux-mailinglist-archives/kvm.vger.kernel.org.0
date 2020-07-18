Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05E9224D25
	for <lists+kvm@lfdr.de>; Sat, 18 Jul 2020 18:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgGRQva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jul 2020 12:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbgGRQv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jul 2020 12:51:29 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF02CC0619D2;
        Sat, 18 Jul 2020 09:51:29 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id l6so11557988qkc.6;
        Sat, 18 Jul 2020 09:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lIGof6uhpVZKmwpXjgyNaJcaBa8FLlzcFqyZDPjbpOc=;
        b=FHaO/NxHUOFcOqsNLqkObDHrJ8NKtxIFBDdP7zoImnujezq0cfyHkpz4CvGR+iBlNu
         tKr6ljahu9FVRmldf82wqWgjTTrVZk9C+rVGr2NG9e4zBsNLrzsaGGXDMvMfoF2dzLSK
         tM3Dl/26+BRVZjJMg2iDIDcJaYoZ1aAFIKenaLkMo6s70zPo6ehETtiAH92tYo1Qh2Vb
         5gVH8aUlLKgyhkyFRdyAVM/RSJ4ggLNTbHEDzTxtf/VoK8Bcsr/SgooMA/Qr9pr3Fu0C
         ei0Y8yrA8iK3G/rM5HGkYqk5xNcuWI2yZaFNN4MLl8grVxvVb19hilzgbADagMztdknS
         y0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lIGof6uhpVZKmwpXjgyNaJcaBa8FLlzcFqyZDPjbpOc=;
        b=dSZq97GQCbapVGOn2j+wgJO3OSzUFIpclSAjlo2Twda+HJ8ggLRnjEbwT2x/HtnUSV
         nGxkojOVTOCjCPOyTkFlrVuWGFxqi4VqsD/QBtposGp0LrDsRny6uEpe2pFckMozxkZ0
         RZNEo7eprgEDZVQ9L2wIeCD6mNQpKkMoMNnyqpRfLZiQHSBXozYuGnNmvK795xPzYv2F
         SgbTFvPFD830YmUeZ2rvK+iDhomtcAG6zFJglneHCEZi5Hkuvfj/8AQzjYksdDlrweHl
         In4z2C/jEqAK6H52ND+p8vKpdQxDgGIsT/Rt8BGYgldmppRoe0uu+8XBf/vfn6rwLKX/
         a4WA==
X-Gm-Message-State: AOAM531tLFTv3KTD+geB0/eUkwZ1TTs89W45PjmTcFRfw6E8PPIjPSVO
        RZXPPCqYCWD+gshqm4awSNM=
X-Google-Smtp-Source: ABdhPJwAyyLQgydCgRLXXu7r8kcxHE/psJ0c6rdQ+7sbtq2ogG+Z9LOekUBi78aoG+v7Vt+7MIPiow==
X-Received: by 2002:a05:620a:40c1:: with SMTP id g1mr14360069qko.391.1595091088912;
        Sat, 18 Jul 2020 09:51:28 -0700 (PDT)
Received: from localhost.localdomain ([2804:18:602d:16d:d038:1a92:190d:65d2])
        by smtp.gmail.com with ESMTPSA id q5sm15361801qtf.12.2020.07.18.09.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 09:51:28 -0700 (PDT)
From:   "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>
X-Google-Original-From: Daniel W. S. Almeida
To:     corbet@lwn.net, pbonzini@redhat.com
Cc:     "Daniel W . S . Almeida" <dwlsalmeida@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH] docs: kvm/api.rst: Fix indentation
Date:   Sat, 18 Jul 2020 13:50:57 -0300
Message-Id: <20200718165107.625847-3-dwlsalmeida@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200718165107.625847-1-dwlsalmeida@gmail.com>
References: <20200718165107.625847-1-dwlsalmeida@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Daniel W. S. Almeida <dwlsalmeida@gmail.com>

Fix the following warnings:

WARNING: Definition list ends without a blank line; unexpected unindent

Signed-off-by: Daniel W. S. Almeida <dwlsalmeida@gmail.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index cdfd981553111..7f24af2760ccd 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4340,7 +4340,7 @@ Errors:
   #define KVM_STATE_NESTED_VMX_SMM_GUEST_MODE	0x00000001
   #define KVM_STATE_NESTED_VMX_SMM_VMXON	0x00000002
 
-#define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE 0x00000001
+  #define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE 0x00000001
 
   struct kvm_vmx_nested_state_hdr {
 	__u64 vmxon_pa;
-- 
2.27.0

