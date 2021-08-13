Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2A43EB127
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 09:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239297AbhHMHM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 03:12:58 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:57007 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239273AbhHMHMv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 03:12:51 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6F3C5194082F;
        Fri, 13 Aug 2021 03:12:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 13 Aug 2021 03:12:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Na61p0whGR1uV8+GWb5lTvOwW2DcHuUQ9yjAwPQAWmc=; b=W3Y/bJyJ
        s/TaP4kL5tof0EPODzquOwz633HBOZLRNMSEm/Hq2HImr6tFhslaY/U3zwWmyILZ
        FawhNfKFIp4eDAqFglzeShF7uuEoVqRmuTRrD7vyHkJpLK+bqvZIM1fBNmANKZfo
        FZ3sbWG6P0txP3Vd71oQIDCLFkY72Ixd32qAVXSDgnQhFOEhnJXRdo00XvlX347p
        jEh6R5MngjM82+xjpMYeefIMpiORG4nRH/Irn8O9mqmthLEUQ+XYALChaPD5Qwk9
        PRE8ZB7eHKHOGfUGmoaxdMp8Sd6ZQ1O9PxLuSuNpGMZJEqeyRt+JZEWN1T8FMMdw
        QaCtEmcXB6v9yw==
X-ME-Sender: <xms:VRsWYY86sqtmj7jKJBq3ouAeivbCIzG9vp4z4A_PVIpe_N43SMaOdA>
    <xme:VRsWYQuFSYG8oGzJRbi7dV83z1RHmSQoEp2dli1o1aXZ-6DWTXz6pBu4p7AT1sN9G
    Oa7z30Mwiw286VfBtg>
X-ME-Received: <xmr:VRsWYeDfWUH0bb8nyEGI-IchxjDHA2Mz3NjRIruy6A00mcLy6s0575taWYlX2AtGPOSsEv4ld7kw4mGHk-8_zc5iFfBPMc-ieLvNImG91Go>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeeggdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtgho
    mh
X-ME-Proxy: <xmx:VRsWYYf-ynmFY7tEK14iT2xe8fDPk0EX_wpbQrsnJszIJvDzdvl9Mg>
    <xmx:VRsWYdNt0y4WQbwrGcW7ySgbK6-Rxb5g4r2v5JTA2NQcR5kpG7bWsQ>
    <xmx:VRsWYSnxG54vOIChmcE3RRaPOLcXd_UemQVwBkvuHgE-WvchiTrDTw>
    <xmx:VRsWYf3IbWbdjTDavkMuRIizTPCpOoiNYfGHdepQo4pdip8Fkz_3QbZuCrs>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Aug 2021 03:12:19 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 8c26ee67;
        Fri, 13 Aug 2021 07:12:12 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v4 4/4] KVM: x86: SGX must obey the KVM_INTERNAL_ERROR_EMULATION protocol
Date:   Fri, 13 Aug 2021 08:12:11 +0100
Message-Id: <20210813071211.1635310-5-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813071211.1635310-1-david.edmondson@oracle.com>
References: <20210813071211.1635310-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When passing the failing address and size out to user space, SGX must
ensure not to trample on the earlier fields of the emulation_failure
sub-union of struct kvm_run.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/vmx/sgx.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 6693ebdc0770..35e7ec91ae86 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -53,11 +53,9 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
 static void sgx_handle_emulation_failure(struct kvm_vcpu *vcpu, u64 addr,
 					 unsigned int size)
 {
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	vcpu->run->internal.ndata = 2;
-	vcpu->run->internal.data[0] = addr;
-	vcpu->run->internal.data[1] = size;
+	uint64_t data[2] = { addr, size };
+
+	__kvm_prepare_emulation_failure_exit(vcpu, data, ARRAY_SIZE(data));
 }
 
 static int sgx_read_hva(struct kvm_vcpu *vcpu, unsigned long hva, void *data,
@@ -112,9 +110,7 @@ static int sgx_inject_fault(struct kvm_vcpu *vcpu, gva_t gva, int trapnr)
 	 * but the error code isn't (yet) plumbed through the ENCLS helpers.
 	 */
 	if (trapnr == PF_VECTOR && !boot_cpu_has(X86_FEATURE_SGX2)) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		kvm_prepare_emulation_failure_exit(vcpu);
 		return 0;
 	}
 
@@ -155,9 +151,7 @@ static int __handle_encls_ecreate(struct kvm_vcpu *vcpu,
 	sgx_12_0 = kvm_find_cpuid_entry(vcpu, 0x12, 0);
 	sgx_12_1 = kvm_find_cpuid_entry(vcpu, 0x12, 1);
 	if (!sgx_12_0 || !sgx_12_1) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		kvm_prepare_emulation_failure_exit(vcpu);
 		return 0;
 	}
 
-- 
2.30.2

