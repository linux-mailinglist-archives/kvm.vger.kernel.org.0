Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD2549B121
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239064AbiAYKDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238516AbiAYJ7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:40 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B13C061755;
        Tue, 25 Jan 2022 01:59:39 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id v3so12559877pgc.1;
        Tue, 25 Jan 2022 01:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nE41yYPMv1zFtz9X94ECgyvNJnmsVPwBnhbwEvP7f3E=;
        b=QOHgBqmr88TELjvu7ow7qs6mVlO/IpLLPivcSo971gunDB2aTWTaeDwJILuJ2jnGeN
         eBQiNhAid2Lwe1phF9w7FiAQM/kk9Zdrn3Bphr53O4R8bh+CNN7CJwSSeiMA/+nyvsv8
         zwNmADVbtIZaII1GLULpDWwSY/kPQUFI3BveVcftx4UoV62yXgpmAVsx6xJ1hdZtJFMc
         0ME6VsXJwrq+XbwPRvyR5e+Yu/ianA7FtRCMMC8k00hbpoBb51DBXXwTTN/SWspJIl1E
         TFwatVo2/Wt4+pvBFspqQCDIG0fPXPipnZRrSROxTsUSACaqvdMSMhmVOCxM+Ri5Og3q
         FhNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nE41yYPMv1zFtz9X94ECgyvNJnmsVPwBnhbwEvP7f3E=;
        b=fURvZI38tldXZfHMp8JeGuAeomfmGy8gpJUCh+v2VUYZamGgG1WQj5EQHdFSGR45wI
         SgtnwhDnqS3DA915Fcx4SkXtv6MEPKDkbE2nld+GEbabY2vvk+KhB29KJQHG6ow+a17R
         VXwZsct4kj8cAvPOeJgAeqeQyk75aj9DD7bgTGdVd/cw3gjri05wSvQa5wogxTWOd7w4
         xsYGwYpA9/R//gp+Gr8tltoMJt8zB2CAkPdadmuVN743bR4JCoS7q0FcotvoRMelQEWS
         oy96fAfHgpJFgau+/EMSOouxcIyKatj1PoQTMqXS4yBQTfEyoEw/PjXPPA1/auFEhR+P
         BJaQ==
X-Gm-Message-State: AOAM533o72sa7WSpwBb5vlsfWGFhpvNQj97N11JvXEDfuOXI89xPntWh
        DlWANyg9c/YVUMHz1IWk0Cg=
X-Google-Smtp-Source: ABdhPJzHX7bMzjHlAQz7S1myug705M1pTgB4K+zlQhlFPEQCrmaQ6lkr7d7MP/x7zngSMZPAKYfDrA==
X-Received: by 2002:a63:1053:: with SMTP id 19mr14746034pgq.478.1643104779383;
        Tue, 25 Jan 2022 01:59:39 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:39 -0800 (PST)
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
Subject: [PATCH 09/19] KVM: x86/svm: Remove unused "svm" of sev_es_prepare_guest_switch()
Date:   Tue, 25 Jan 2022 17:58:59 +0800
Message-Id: <20220125095909.38122-10-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "struct vcpu_svm *svm" parameter of sev_es_prepare_guest_switch()
is not used, so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 arch/x86/kvm/svm/svm.c | 2 +-
 arch/x86/kvm/svm/svm.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6a22798eaaee..eae234afe04e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2902,7 +2902,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 					    sev_enc_bit));
 }
 
-void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu)
+void sev_es_prepare_guest_switch(unsigned int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
 	struct vmcb_save_area *hostsa;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 744ddc7ad6ad..3e75ae834412 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1276,7 +1276,7 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 	 * or subsequent vmload of host save area.
 	 */
 	if (sev_es_guest(vcpu->kvm)) {
-		sev_es_prepare_guest_switch(svm, vcpu->cpu);
+		sev_es_prepare_guest_switch(vcpu->cpu);
 	} else {
 		vmsave(__sme_page_pa(sd->save_area));
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 47ef8f4a9358..0a749bbda738 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -622,7 +622,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
-void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
+void sev_es_prepare_guest_switch(unsigned int cpu);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
 /* vmenter.S */
-- 
2.33.1

