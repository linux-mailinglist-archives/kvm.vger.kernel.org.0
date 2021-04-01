Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E426351A3B
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236833AbhDAR6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:58:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236960AbhDAR4I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:56:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CqTbGA2nnEQCoezWyE1Fpgf0IZLhERcQWs6PZNwBkg4=;
        b=jFiEEP1ySKt+P33XvxoDDxTYKWJSCcrP6KcaK1ncFumMvSJSIyDlhkiDVVQ+YJJCh0b6B3
        oW/crAi4Jc+xaGNTetGQrHI8f65REIM8SsY9AC5DQlEzKNenm8Y+DD4sjJrCOkJio4y0pa
        DDAXlb8AGKCzQbZfOc2xwboeHxiSUaA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-PwIa3jVQOJCoHvlqWy6ukQ-1; Thu, 01 Apr 2021 09:55:06 -0400
X-MC-Unique: PwIa3jVQOJCoHvlqWy6ukQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A55FC107B789;
        Thu,  1 Apr 2021 13:55:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D0E15D6B1;
        Thu,  1 Apr 2021 13:54:52 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org (open list),
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Will Deacon <will@kernel.org>,
        kvmarm@lists.cs.columbia.edu (open list:KERNEL VIRTUAL MACHINE FOR
        ARM64 (KVM/arm64)), Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Jim Mattson <jmattson@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org (open list:S390),
        Heiko Carstens <hca@linux.ibm.com>,
        Kieran Bingham <kbingham@kernel.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-arm-kernel@lists.infradead.org (moderated list:KERNEL VIRTUAL
        MACHINE FOR ARM64 (KVM/arm64)), James Morse <james.morse@arm.com>
Subject: [PATCH v2 0/9] KVM: my debug patch queue
Date:   Thu,  1 Apr 2021 16:54:42 +0300
Message-Id: <20210401135451.1004564-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!=0D
=0D
I would like to publish two debug features which were needed for other stuf=
f=0D
I work on.=0D
=0D
One is the reworked lx-symbols script which now actually works on at least=
=0D
gdb 9.1 (gdb 9.2 was reported to fail to load the debug symbols from the ke=
rnel=0D
for some reason, not related to this patch) and upstream qemu.=0D
=0D
The other feature is the ability to trap all guest exceptions (on SVM for n=
ow)=0D
and see them in kvmtrace prior to potential merge to double/triple fault.=0D
=0D
This can be very useful and I already had to manually patch KVM a few=0D
times for this.=0D
I will, once time permits, implement this feature on Intel as well.=0D
=0D
V2:=0D
=0D
 * Some more refactoring and workarounds for lx-symbols script=0D
=0D
 * added KVM_GUESTDBG_BLOCKEVENTS flag to enable 'block interrupts on=0D
   single step' together with KVM_CAP_SET_GUEST_DEBUG2 capability=0D
   to indicate which guest debug flags are supported.=0D
=0D
   This is a replacement for unconditional block of interrupts on single=0D
   step that was done in previous version of this patch set.=0D
   Patches to qemu to use that feature will be sent soon.=0D
=0D
 * Reworked the the 'intercept all exceptions for debug' feature according=
=0D
   to the review feedback:=0D
=0D
   - renamed the parameter that enables the feature and=0D
     moved it to common kvm module.=0D
     (only SVM part is currently implemented though)=0D
=0D
   - disable the feature for SEV guests as was suggested during the review=
=0D
   - made the vmexit table const again, as was suggested in the review as w=
ell.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (9):=0D
  scripts/gdb: rework lx-symbols gdb script=0D
  KVM: introduce KVM_CAP_SET_GUEST_DEBUG2=0D
  KVM: x86: implement KVM_CAP_SET_GUEST_DEBUG2=0D
  KVM: aarch64: implement KVM_CAP_SET_GUEST_DEBUG2=0D
  KVM: s390x: implement KVM_CAP_SET_GUEST_DEBUG2=0D
  KVM: x86: implement KVM_GUESTDBG_BLOCKEVENTS=0D
  KVM: SVM: split svm_handle_invalid_exit=0D
  KVM: x86: add force_intercept_exceptions_mask=0D
  KVM: SVM: implement force_intercept_exceptions_mask=0D
=0D
 Documentation/virt/kvm/api.rst    |   4 +=0D
 arch/arm64/include/asm/kvm_host.h |   4 +=0D
 arch/arm64/kvm/arm.c              |   2 +=0D
 arch/arm64/kvm/guest.c            |   5 -=0D
 arch/s390/include/asm/kvm_host.h  |   4 +=0D
 arch/s390/kvm/kvm-s390.c          |   3 +=0D
 arch/x86/include/asm/kvm_host.h   |  12 ++=0D
 arch/x86/include/uapi/asm/kvm.h   |   1 +=0D
 arch/x86/kvm/svm/svm.c            |  87 +++++++++++--=0D
 arch/x86/kvm/svm/svm.h            |   6 +-=0D
 arch/x86/kvm/x86.c                |  14 ++-=0D
 arch/x86/kvm/x86.h                |   2 +=0D
 include/uapi/linux/kvm.h          |   1 +=0D
 kernel/module.c                   |   8 +-=0D
 scripts/gdb/linux/symbols.py      | 203 ++++++++++++++++++++----------=0D
 15 files changed, 272 insertions(+), 84 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

