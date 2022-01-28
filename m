Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1066049F016
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345010AbiA1AyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345049AbiA1Axx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:53 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6E8C061757
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:42 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 127-20020a630585000000b0035de5e88314so2397672pgf.2
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=noH9rc43NtcZZk3qKXNAM68WagyoFBJqh2/OYWzzfPU=;
        b=tPUaKMnIg2K86mUTwaL+noJBuc8zQTKSlcBDAq7cGRCmkzbgoMWo3lKRW9jH9Vw0hG
         mSQ53Y5dDDhFoXXDcfoKceDkHi6UnTY5xv9fRtaEE4Dt10tTl4Ne5kTUUnTWyiYp8Ido
         VfD3s07xyStDdnjUvEV3lzb67QSHfEA/xqmozOiDsK01KULTy9x6fbZ521r8Dp42ZQ1S
         qIdMITmRSPk8vsUhPS4LYeJEl8+Op3kQtH13HhifHQO/QbMUqvTD82vlJ5OMBslY2pxY
         kTea3f0utvsdMi0aCg6aIuN/jf8/Q9vmW6sTrVXefu9TSu2JR3RfdrjwSGH5BMTru9Ca
         qkPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=noH9rc43NtcZZk3qKXNAM68WagyoFBJqh2/OYWzzfPU=;
        b=N0JnO4j9w/RqbkSijl9UhI0DJHl/AGbXWG7MzOnNoSpznvUC1zUKWsDHYrJK51eH+5
         0dHMLydx6WYneb7GhrNYULOWXNZQsfkVq6AjyQeMg+Alar/lma5gNRTIEvQD2FTve8En
         O0VCDATltta38p2f+VNxBH5sggLQp93/NQZ9Uohsr0SpQzcc5EtIcB1Okj5mcMInS9xx
         iboj309klBCwAiKEew4JTtpPE7ViRfzxbWPGZ2k62THw4h0pGkhWh6UDPa+B/yl8TWR9
         rnE4i6rKaf49WGp+HoMn5sNJGsNpPbysJNXP6YS0bkLqNBNpWnOWzSruOTx9A4II4yu4
         ab1A==
X-Gm-Message-State: AOAM5329JsEAkVQ7pfprYjXkJbl3UbCORcvkiqcnH9+ANAXiHP/HvG7M
        6jRKX/DgOAnlstcxM8S0YlPEItAFVK0=
X-Google-Smtp-Source: ABdhPJyr6LlxPKDUE8fsLXXo5l1/1ZdCXWljHyCpawtXxfcExphqhBvD2MToVMzZUnc1PH+jzCcY8eh7qoc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:15d6:: with SMTP id
 o22mr5788714pfu.35.1643331222083; Thu, 27 Jan 2022 16:53:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:52:03 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-18-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 17/22] KVM: SVM: Remove unused MAX_INST_SIZE #define
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove SVM's MAX_INST_SIZE, which has long since been obsoleted by the
common MAX_INSN_SIZE.  Note, the latter's "insn" is also the generally
preferred abbreviation of instruction.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5382710ba106..87e136b81991 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -263,8 +263,6 @@ u32 svm_msrpm_offset(u32 msr)
 	return MSR_INVALID;
 }
 
-#define MAX_INST_SIZE 15
-
 static void svm_flush_tlb_current(struct kvm_vcpu *vcpu);
 
 static int get_npt_level(void)
-- 
2.35.0.rc0.227.g00780c9af4-goog

