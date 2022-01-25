Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D518849B126
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239273AbiAYKEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238517AbiAYJ7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:46 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BBEC06175E;
        Tue, 25 Jan 2022 01:59:44 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id q63so14779972pja.1;
        Tue, 25 Jan 2022 01:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gJXu3XDntG3sYuZsaAy93XgNQyjjQDdCF6KOBgCQ6T8=;
        b=l4Qf+2yFfQZKC8zuNjxLmbGXa1WmfnQIutDsVBe4VjYUa30G4bJXmx8CRWmeXK9tAO
         16zdGhUe2dZtpd41xgzg4prgqcEizIpe/A/MBeTbUei/FcP4l08vTIU9A4WfOBlt7a2I
         vOJ9FkxOGwfBlEUY5drA+6kClr19yU/LSKTG8l9iRo9LRycWlOChrLg4brdA3ymmGFSS
         IlgsK2WmixCkmUNCbglGLRHXZ5UX8KtYPFh+k2yXkFp0y61KdH/JjUb5ZNEXFcWE6fnF
         mkaNdk2YBpuwgT7J74DUQoOFXdDTmih93v9KsoISfsi6D1fompENqtP+1AESiVvFjT8a
         164w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gJXu3XDntG3sYuZsaAy93XgNQyjjQDdCF6KOBgCQ6T8=;
        b=GaVBo7CJ4tPTAsq4LCI6AS7VvgSdmqOLe5rEqPKjuYof9mrTAaVRKH1GZtXkkAe8Ms
         c0lPVUPK/YN+k4A3QA3klvfzcPMKWJF2zbutLDEWl8gXu637sGrNc+foFVaCS0TfTKe0
         sx1A0mixSVxHXmbObE4MzC2xpaOuvTqgpxEqHjxZ4nkqX6ieniPflF9LDsB/6083m+aq
         sjNwLeqx9P+0bwxOTPdzPWX2Dvl96Q+qy43ebSYqB9FdyTBiHPQLStsTnmG7j8G2oo+6
         sHFnoTtzRAIkq9DrQU+A6SAogWItFFd+/z6MfN5mfrRWDlcWFiNePBTMUvdMsS7fgpUT
         KRFw==
X-Gm-Message-State: AOAM532kGCLTdyeSVKCH2YpPSaWOWg1mHUZbnIICJ1qIFTBYqd3L1PuC
        SLUkf76IakwcvbHpqv1u/Izw9TFkWJsqUQ==
X-Google-Smtp-Source: ABdhPJxmvtMII3KhHayu1fLjLASIEeiLAP6uRb1v+w7SNfbXr/hHJ4ol7JH0ir2ec2HDUxEViqz3vg==
X-Received: by 2002:a17:90b:3148:: with SMTP id ip8mr2731496pjb.72.1643104784108;
        Tue, 25 Jan 2022 01:59:44 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:43 -0800 (PST)
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
Subject: [PATCH 11/19] KVM: x86/svm: Remove unused "vector" of sev_vcpu_deliver_sipi_vector()
Date:   Tue, 25 Jan 2022 17:59:01 +0800
Message-Id: <20220125095909.38122-12-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "struct kvm_vcpu *vcpu" parameter of sev_vcpu_deliver_sipi_vector()
is not used, so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 arch/x86/kvm/svm/svm.c | 2 +-
 arch/x86/kvm/svm/svm.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0727ac7221d7..2fd1e91054b3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2925,7 +2925,7 @@ void sev_es_prepare_guest_switch(unsigned int cpu)
 	hostsa->xss = host_xss;
 }
 
-void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
+void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3e75ae834412..aead235a90ee 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4348,7 +4348,7 @@ static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	if (!sev_es_guest(vcpu->kvm))
 		return kvm_vcpu_deliver_sipi_vector(vcpu, vector);
 
-	sev_vcpu_deliver_sipi_vector(vcpu, vector);
+	sev_vcpu_deliver_sipi_vector(vcpu);
 }
 
 static void svm_vm_destroy(struct kvm *kvm)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0a749bbda738..61c96f4a7006 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -621,7 +621,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_vcpu_reset(struct vcpu_svm *svm);
-void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
+void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu);
 void sev_es_prepare_guest_switch(unsigned int cpu);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
-- 
2.33.1

