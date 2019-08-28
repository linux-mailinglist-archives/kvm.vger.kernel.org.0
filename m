Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2819FC66
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 09:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfH1H7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 03:59:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48746 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbfH1H7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 03:59:10 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2A3F9C0568FA
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 07:59:10 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id k15so905166wrw.18
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 00:59:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lBboHqcZl+GeeqMr+xhVz73awkXrj2sOIO6d13g0iRE=;
        b=hwAgKVbVCk0yCwvqgeT2jo45OSCNg6Iuww63xF0YVrPMXdt32fNAZ6iI4IfRsrv6/y
         PYnSI+ZqZf9YgP2zA21x4YH/oFfWtbBaIWAlOChFAj7SbfkOXZQqMQTg2i2fme7IsCR9
         AHZ84iI2FCJOynlGpyF+UPEDni1j6CY4GJeHY19MOMxXSsA/1cvAlu0Q/JrZQGwhtXoL
         B474D15tvlFQ7n/Ly8jhgkTUQWrAcLAv+PT22Qf/mQXRaOwS+Es3mPTWtf6S3KZgWWMW
         rv26LMqjGgFS3ltGBXO2FEqvZtqAFyV7HBvDJ63i8UCz9IEpXkF0hZP//Lk+WBfnls0U
         B1fw==
X-Gm-Message-State: APjAAAVfvC2d9GTULm2ZpAXIKHEV8bNWfJxx2MjCugDZdbCDGTmydAMp
        VKdFPu60cujnujtX7IJwE5umTRVulis1xv2JTHIDodDsjrlIs1h6Tsud6TFsQfYII530O+qEtDa
        Dwo/d6cKQs2Pn
X-Received: by 2002:adf:f18c:: with SMTP id h12mr2713824wro.47.1566979148632;
        Wed, 28 Aug 2019 00:59:08 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyg75w3y/I6ECh2ht91PCD+cPI1HSKMT6eKRHsTiLiLoq2ckp9NA9BsenuangkEk7V6n9c+3A==
X-Received: by 2002:adf:f18c:: with SMTP id h12mr2713808wro.47.1566979148444;
        Wed, 28 Aug 2019 00:59:08 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a190sm2448469wme.8.2019.08.28.00.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 00:59:07 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH v2 1/2] KVM: x86: svm: remove unneeded nested_enable_evmcs() hook
Date:   Wed, 28 Aug 2019 09:59:04 +0200
Message-Id: <20190828075905.24744-2-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190828075905.24744-1-vkuznets@redhat.com>
References: <20190828075905.24744-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit 5158917c7b019 ("KVM: x86: nVMX: Allow nested_enable_evmcs to
be NULL") the code in x86.c is prepared to see nested_enable_evmcs being
NULL and in VMX case it actually is when nesting is disabled. Remove the
unneeded stub from SVM code.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 40175c42f116..6d52c65d625b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7122,13 +7122,6 @@ static int svm_unregister_enc_region(struct kvm *kvm,
 	return ret;
 }
 
-static int nested_enable_evmcs(struct kvm_vcpu *vcpu,
-				   uint16_t *vmcs_version)
-{
-	/* Intel-only feature */
-	return -ENODEV;
-}
-
 static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 {
 	unsigned long cr4 = kvm_read_cr4(vcpu);
@@ -7337,7 +7330,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.mem_enc_reg_region = svm_register_enc_region,
 	.mem_enc_unreg_region = svm_unregister_enc_region,
 
-	.nested_enable_evmcs = nested_enable_evmcs,
+	.nested_enable_evmcs = NULL,
 	.nested_get_evmcs_version = NULL,
 
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
-- 
2.20.1

