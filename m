Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307B8557DCA
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 16:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiFWObH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 10:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiFWObF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 10:31:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 856B73B2B2
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 07:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655994663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=f44BmoT5VI53ZLm+VY/qF0ngGFO/sl/5MRxUDlVHH3c=;
        b=KYmC/fyaQL4UzbgtfODipzH/tIsASVlpYwxO+jzZ4EGOFLGfC3j3KSTsbisA+/B/ns5KPb
        D+IrWJjoHXak31ZKdGxW9LEC7nj4PenLq5qPgmDDkQ4+69NLO0QAz3r6k/3Dw+Kb0YCAGR
        VZEv3FdIWqsP/dNhAGMuSF6nV16Tmms=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-bmvzgMHuNAKbeI3yJAGBfA-1; Thu, 23 Jun 2022 10:31:00 -0400
X-MC-Unique: bmvzgMHuNAKbeI3yJAGBfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C895A38173C8;
        Thu, 23 Jun 2022 14:30:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A867404E4DE;
        Thu, 23 Jun 2022 14:30:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2] MAINTAINERS: Reorganize KVM/x86 maintainership
Date:   Thu, 23 Jun 2022 10:30:59 -0400
Message-Id: <20220623143059.2626661-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the last few years I have been the sole maintainer of KVM, albeit
getting serious help from all the people who have reviewed hundreds of
patches.  The volume of KVM x86 alone has gotten to the point where one
maintainer is not enough; especially if that maintainer is not doing it
full time and if they want to keep up with the evolution of ARM64 and
RISC-V at both the architecture and the hypervisor level.

So, this patch is the first step in restoring double maintainership
or even transitioning to the submaintainer model of other architectures.

The changes here were mostly proposed by Sean offlist and they are twofold:

- revisiting the set of KVM x86 reviewers.  It's important to have an
  an accurate list of people that are actively reviewing patches ("R"),
  as well as people that are able to act on bug reports ("M").  Otherwise,
  voids to be filled are not easily visible.  The proposal is to split
  KVM on Hyper-V, which is where Vitaly has been the main contributor
  for quite some time now; likewise for KVM paravirt support, which
  has been the main interest of Wanpeng and to which Vitaly has also
  contributed (e.g., for async page faults).  Jim and Joerg have not been
  particularly active (though Joerg has worked on guest support for AMD
  SEV); knowing them a bit, I can't imagine they would object to their
  removal or even be surprised, but please speak up if you do.

- promoting Sean to maintainer for KVM x86 host support.  While for
  now this changes little, let's treat it as a harbinger for future
  changes.  The plan is that I would keep the final integration testing
  for quite some time, and probably focus more on -rc work.  This will
  give me more time to clean up my ad hoc setup and moving towards a
  more public CI, with Sean focusing instead on next-release patches,
  and the testing up to where kvm-unit-tests and selftests pass.  In
  order to facilitate collaboration between Sean and myself, we'll
  also formalize a bit more the various branches of kvm.git.

Nothing is going to change with respect to handling pull requests to Linus
and from other architectures, as well as maintainance of the generic code
(which I expect and hope to be more important as architectures try to
share more code) and documentation.  However, it's not a coincidence
that my entry is now the last for x86, ready to be demoted to reviewer
if/when the right time comes.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 MAINTAINERS | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 97014ae3e5ed..968b622bc3ce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10897,28 +10897,50 @@ F:	tools/testing/selftests/kvm/*/s390x/
 F:	tools/testing/selftests/kvm/s390x/
 
 KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
+M:	Sean Christopherson <seanjc@google.com>
 M:	Paolo Bonzini <pbonzini@redhat.com>
-R:	Sean Christopherson <seanjc@google.com>
-R:	Vitaly Kuznetsov <vkuznets@redhat.com>
-R:	Wanpeng Li <wanpengli@tencent.com>
-R:	Jim Mattson <jmattson@google.com>
-R:	Joerg Roedel <joro@8bytes.org>
 L:	kvm@vger.kernel.org
 S:	Supported
-W:	http://www.linux-kvm.org
 T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
 F:	arch/x86/include/asm/kvm*
-F:	arch/x86/include/asm/pvclock-abi.h
 F:	arch/x86/include/asm/svm.h
 F:	arch/x86/include/asm/vmx*.h
 F:	arch/x86/include/uapi/asm/kvm*
 F:	arch/x86/include/uapi/asm/svm.h
 F:	arch/x86/include/uapi/asm/vmx.h
-F:	arch/x86/kernel/kvm.c
-F:	arch/x86/kernel/kvmclock.c
 F:	arch/x86/kvm/
 F:	arch/x86/kvm/*/
 
+KVM PARAVIRT (KVM/paravirt)
+M:	Paolo Bonzini <pbonzini@redhat.com>
+R:	Wanpeng Li <wanpengli@tencent.com>
+R:	Vitaly Kuznetsov <vkuznets@redhat.com>
+L:	kvm@vger.kernel.org
+S:	Supported
+T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
+F:	arch/x86/kernel/kvm.c
+F:	arch/x86/kernel/kvmclock.c
+F:	arch/x86/include/asm/pvclock-abi.h
+F:	include/linux/kvm_para.h
+F:	include/uapi/linux/kvm_para.h
+F:	include/uapi/asm-generic/kvm_para.h
+F:	include/asm-generic/kvm_para.h
+F:	arch/um/include/asm/kvm_para.h
+F:	arch/x86/include/asm/kvm_para.h
+F:	arch/x86/include/uapi/asm/kvm_para.h
+
+KVM X86 HYPER-V (KVM/hyper-v)
+M:	Vitaly Kuznetsov <vkuznets@redhat.com>
+M:	Sean Christopherson <seanjc@google.com>
+M:	Paolo Bonzini <pbonzini@redhat.com>
+L:	kvm@vger.kernel.org
+S:	Supported
+T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
+F:	arch/x86/kvm/hyperv.*
+F:	arch/x86/kvm/kvm_onhyperv.*
+F:	arch/x86/kvm/svm/svm_onhyperv.*
+F:	arch/x86/kvm/vmx/evmcs.*
+
 KERNFS
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 M:	Tejun Heo <tj@kernel.org>
-- 
2.31.1

