Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF73450756
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 15:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhKOOpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 09:45:06 -0500
Received: from mail.xenproject.org ([104.130.215.37]:47896 "EHLO
        mail.xenproject.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236465AbhKOOow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 09:44:52 -0500
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1mmdAw-0001u9-TN; Mon, 15 Nov 2021 14:41:38 +0000
Received: from host86-165-42-146.range86-165.btcentralplus.com ([86.165.42.146] helo=debian.home)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1mmdAw-0006IQ-KE; Mon, 15 Nov 2021 14:41:38 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     kvm@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        kernel test robot <lkp@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] cpuid: kvm_find_kvm_cpuid_features() should be declared 'static'
Date:   Mon, 15 Nov 2021 14:41:31 +0000
Message-Id: <20211115144131.5943-1-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The lack a static decalaration currently results in:

arch/x86/kvm/cpuid.c:128:26: warning: no previous prototype for function 'kvm_find_kvm_cpuid_features'

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 17cd23d68fdf ("KVM: x86: Make sure KVM_CPUID_FEATURES really are KVM_CPUID_FEATURES")
Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e19dabf1848b..07e9215e911d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -125,7 +125,7 @@ static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
 	}
 }
 
-struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu)
+static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu)
 {
 	u32 base = vcpu->arch.kvm_cpuid_base;
 
-- 
2.20.1

