Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AA879D8F8
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 20:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbjILSqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 14:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237642AbjILSqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 14:46:16 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EB11991
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 11:46:08 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58fb8933e18so64459437b3.3
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 11:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694544368; x=1695149168; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8NSnv/WTj9TePiwJ3e7yhez5Y5Fg6PSmoubFG+0am4I=;
        b=lpm26PFNLDdB5U8I7PH2zsOgtkh+8n0wJP0UoVJtwGT+9Xu+VjkiJVDdx4zHQPubY/
         S8cijbfRWnpZ4dxhQtu7bZEsr5tPu7vz4wKAaEXNU25dTmwMf4i4Bfk/5WUapQXcjymE
         gWlyxfXlsgTZ0rLMBweEaxkezHhe54GKjk+xJX10cnAbRo/DzGoYz9DKYc7FdecAAy4F
         +NZanwJDCYaHoSGcPIUZ3Tq3awy+/KTrOPQr2Dm6JuMqOuq4EqopP0epCmdTT/gwL/3S
         U1bICPIiYBRO3KwhC+2Nv0/+tVVWPyjhegLFMhUiFDZBtn1ilkZSfk/7jbSW7wrlWfPt
         2yHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694544368; x=1695149168;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8NSnv/WTj9TePiwJ3e7yhez5Y5Fg6PSmoubFG+0am4I=;
        b=saHq4BcbuibCAXUZqqo8VAMfw3bdns6LpIUcP8v4V3YWZ/uAd8uuFl/6F9DCO9aNlh
         4UJFKBVae9uNC6nER51q409yBW1D3TR0piVYHE4628m10oaGto0PjSUF/0rSmdjXiIsV
         HSy5MbxBwqZ1WmlpuWA3BnZwrEI3e6ey4CYcNTWJG2V8JeSj2xcKRqMFShOhoFBEn6hf
         WmjUQa8foLm7t8HuBTNRt6kQ3LJn/kwyTUt04hP8SCl3e/WZL+MpsB0O/mXbiGepPL9c
         CeSbu0/HwtZ/l8ZL1RRQgJMVfrsyYUILe7eho/Mv33Fi1cXtxTuk59MH5Vbx2rw8nkYN
         Nvvw==
X-Gm-Message-State: AOJu0YyN1Qi9yVknENsVdgxkD6qLEwCUZYzTfTpqpk9G5tfL5yneDYL+
        mtMBZnieh51KnMlvmOCh5Kfl5KtVq9KB
X-Google-Smtp-Source: AGHT+IFADHJrwy/aa2LM6dPwu4H3fm1xiVyTj+CcoUMEvy5vi37pxe5Yg8FlnTokO/LcSVDIT1ldwzVEBl20
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a81:400c:0:b0:589:a855:7af with SMTP id
 l12-20020a81400c000000b00589a85507afmr8853ywn.7.1694544367876; Tue, 12 Sep
 2023 11:46:07 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 12 Sep 2023 18:45:53 +0000
In-Reply-To: <20230912184553.1887764-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230912184553.1887764-1-mizhang@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230912184553.1887764-7-mizhang@google.com>
Subject: [PATCH v4 6/6] KVM: Documentation: Add the missing description for
 tdp_mmu_page into kvm_mmu_page
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the description for tdp_mmu_page into kvm_mmu_page description.
tdp_mmu_page is a field to differentiate shadow pages from TDP MMU and
non-TDP MMU.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
---
 Documentation/virt/kvm/x86/mmu.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
index 16d5d6a1c174..82c5c6a6da2c 100644
--- a/Documentation/virt/kvm/x86/mmu.rst
+++ b/Documentation/virt/kvm/x86/mmu.rst
@@ -282,6 +282,10 @@ Shadow pages contain the following information:
     since the last time the page table was actually used; if emulation
     is triggered too frequently on this page, KVM will unmap the page
     to avoid emulation in the future.
+  tdp_mmu_page:
+    Is 1 if the shadow page is a TDP MMU page. This variable is used to
+    bifurcate the control flows for KVM when walking any data structure that may
+    contain pages from both TDP MMU and shadow MMU.
 
 Reverse map
 ===========
-- 
2.42.0.283.g2d96d420d3-goog

