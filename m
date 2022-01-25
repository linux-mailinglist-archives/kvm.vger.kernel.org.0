Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31F349B11E
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238952AbiAYKC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238496AbiAYJ7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:37 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42E3C061744;
        Tue, 25 Jan 2022 01:59:34 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id a8so13907222pfa.6;
        Tue, 25 Jan 2022 01:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=scA+WO/7zy1xEMVYISep/dAL7wm6VBA9xpopPadR530=;
        b=mZN8F9BJMrFhJhSJVwScLdFEt8dhtp6iOh0kBzJye9ur29QN3+jVxB+5+UJsqojwht
         jJeNXxT4C74bxDAFgfh2VQcC4RlzsYizLG8gtXFzRa1op4dp3fJxltsvd2tTboN2IOxk
         L3tIBILIRKwjGUF1Os9oi59SRVOHCjE5wrKMfqBq8SrrKF9jMO4K7id3YOcPaF6I44fB
         TDeHnSHFBB0Cc1kBIfAD7czYkh0Qs6wqq3uPTsvgpn0JoweE+OyHMo5jd7e0DR90wTFu
         ZzRnS67P/X3i0GRjFPld2Qo7UVzYETUomV8TTrr56WEziUR6u5mBLsxl2nIuBjUk5XLa
         xLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=scA+WO/7zy1xEMVYISep/dAL7wm6VBA9xpopPadR530=;
        b=cPWLXZlbluYqEVf3FMddr78LTuzDEzmSQxVrwJ6Zmxarhtj34j7fKCel8blhh0KrRC
         qkoPilOXohjy1AgI7MNdrCvJUOFKwDuEJmxoYKxhZc3fbzIer56v0mZX8f0dV+FH+fgx
         j3lMQetddXU6JXnVlHMY6JhEd4OJ1QKmWuvB+BuawzZQWxESj5nFpyX3wP0uHkwwbaRy
         NWxTmsb4ca3Nxr0swmQqaNeshYKtxlGmxkC5aS31r6Gi4uyfGRpfpfH+paVFYbCLjJ64
         xVDiNtu3P7toqDE7eYh8bG20j2mivGtbSzorjLxWTQpaYtqV979yfVDph2DC+gAw34c/
         Bnlw==
X-Gm-Message-State: AOAM532WF6ZvDadgp/4vzR5zlPEPx6mcZDFw5zI2ije98ympgLgZRFS2
        RqCJ/WLXNbWB+UFCj8uiJZ0=
X-Google-Smtp-Source: ABdhPJxwOLoU1nzuWo/msDqKR1WDXqXoaEO9O2aNuVN6/BK251EHfGQyFCnlmL2XZ1VJmbr+PKN7pw==
X-Received: by 2002:a63:7019:: with SMTP id l25mr2991454pgc.321.1643104774522;
        Tue, 25 Jan 2022 01:59:34 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:34 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/19] KVM: x86/svm: Remove unused "vcpu" of nested_svm_check_tlb_ctl()
Date:   Tue, 25 Jan 2022 17:58:57 +0800
Message-Id: <20220125095909.38122-8-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "struct kvm_vcpu *vcpu" parameter of nested_svm_check_tlb_ctl()
is not used, so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index cf206855ebf0..5a1a2678a2b1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -209,7 +209,7 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
 	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
 }
 
-static bool nested_svm_check_tlb_ctl(struct kvm_vcpu *vcpu, u8 tlb_ctl)
+static bool nested_svm_check_tlb_ctl(u8 tlb_ctl)
 {
 	/* Nested FLUSHBYASID is not supported yet.  */
 	switch(tlb_ctl) {
@@ -240,7 +240,7 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 					   IOPM_SIZE)))
 		return false;
 
-	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
+	if (CC(!nested_svm_check_tlb_ctl(control->tlb_ctl)))
 		return false;
 
 	return true;
-- 
2.33.1

