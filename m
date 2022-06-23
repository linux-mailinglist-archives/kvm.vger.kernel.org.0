Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673C45578F0
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 13:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiFWLqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 07:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiFWLqV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 07:46:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AEB124BFF5
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 04:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655984779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=uR5+Zkk6yrnJbps9wNMzV8Rp89GBDb7meHwZjOCv9Yk=;
        b=be3JkdSTprBGtXaJm9IglfKjwyhgnd28dTRoc9BMFxOYuzY7K1wjlioQebNckr9UWkMjiy
        kcZ33bEPdnUOCmVGelvwuolnh56oDXpWidj2WsW1dh7QmWD+5tEB+5ZqoVQz0qrMGALN5k
        Rzfqo0t7ZI8XoSPKz2x/VjJYNQpfuZ4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-JtwwhmT2OF-JAKIOM2mj4w-1; Thu, 23 Jun 2022 07:46:16 -0400
X-MC-Unique: JtwwhmT2OF-JAKIOM2mj4w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE0CC185A7B2;
        Thu, 23 Jun 2022 11:46:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 635C5C2810D;
        Thu, 23 Jun 2022 11:46:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] MAINTAINERS: Reorganize KVM/x86 maintainership
Date:   Thu, 23 Jun 2022 07:46:15 -0400
Message-Id: <20220623114615.2600316-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
  has been the main interest of Wanpeng.  Jim and Joerg have not been
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

(Man, this commit message sounds emotional).

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
 MAINTAINERS | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 97014ae3e5ed..3f7c485195d9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10897,28 +10897,47 @@ F:	tools/testing/selftests/kvm/*/s390x/
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

