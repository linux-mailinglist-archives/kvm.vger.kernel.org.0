Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9ABA1637A2
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgBRXyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:54:46 -0500
Received: from mga04.intel.com ([192.55.52.120]:40044 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbgBRXyo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:54:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:54:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="224313180"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 18 Feb 2020 15:54:39 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: [PATCH v2 9/9] KVM: SVM: Annotate svm_x86_ops as __initdata
Date:   Tue, 18 Feb 2020 15:54:37 -0800
Message-Id: <20200218235437.20533-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218235437.20533-1-sean.j.christopherson@intel.com>
References: <20200218235437.20533-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tag svm_x86_ops with __initdata now the the struct is copied by value to
a common x86 instance of kvm_x86_ops as part of kvm_init().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 59af4f5386de..69d63e6dce0e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7374,7 +7374,7 @@ static void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate)
 	avic_update_access_page(kvm, activate);
 }
 
-static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
+static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.hardware_unsetup = svm_hardware_unsetup,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
-- 
2.24.1

