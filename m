Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6093E355301
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 13:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343639AbhDFL7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 07:59:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34532 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343631AbhDFL7l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 07:59:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617710373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2esLg1da59fOJXVhXC5LxhBQc2Y9aIayppe+mCmRoS0=;
        b=JcsZGyg/blrTAcR2iUSgx0xigkgz+ps7n+RI+07FRl2COQLTzdFF86kyLpKRQ6R5fF3LdW
        Eo34GkNr3qUBuORn6qwN8g6klDMajunoVMAPK8VpeiLGZJSd12CnSe4uqIuWipsSb7CV7e
        S5J+qdP3HbXmUgiBDSyieuCymShruho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-trrCjbsPNv6uojW5o92q1A-1; Tue, 06 Apr 2021 07:59:32 -0400
X-MC-Unique: trrCjbsPNv6uojW5o92q1A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5B6F81746A;
        Tue,  6 Apr 2021 11:59:28 +0000 (UTC)
Received: from starship (unknown [10.35.206.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA0176B8E8;
        Tue,  6 Apr 2021 11:59:15 +0000 (UTC)
Message-ID: <27193ea74081023b67ab9c98d7050b1e22655e79.camel@redhat.com>
Subject: Re: [PATCH v2 0/9] KVM: my debug patch queue
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Will Deacon <will@kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Jim Mattson <jmattson@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Kieran Bingham <kbingham@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>
Date:   Tue, 06 Apr 2021 14:59:14 +0300
In-Reply-To: <cb7f918c-932f-d558-76ec-801ed8ed1f62@redhat.com>
References: <20210401135451.1004564-1-mlevitsk@redhat.com>
         <cb7f918c-932f-d558-76ec-801ed8ed1f62@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-04-02 at 19:38 +0200, Paolo Bonzini wrote:
> On 01/04/21 15:54, Maxim Levitsky wrote:
> > Hi!
> > 
> > I would like to publish two debug features which were needed for other stuff
> > I work on.
> > 
> > One is the reworked lx-symbols script which now actually works on at least
> > gdb 9.1 (gdb 9.2 was reported to fail to load the debug symbols from the kernel
> > for some reason, not related to this patch) and upstream qemu.
> 
> Queued patches 2-5 for now.  6 is okay but it needs a selftest. (e.g. 
> using KVM_VCPU_SET_EVENTS) and the correct name for the constant.

Thanks!
I will do this very soon.

Best regards,
	Maxim Levitsky
> 
> Paolo
> 
> > The other feature is the ability to trap all guest exceptions (on SVM for now)
> > and see them in kvmtrace prior to potential merge to double/triple fault.
> > 
> > This can be very useful and I already had to manually patch KVM a few
> > times for this.
> > I will, once time permits, implement this feature on Intel as well.
> > 
> > V2:
> > 
> >   * Some more refactoring and workarounds for lx-symbols script
> > 
> >   * added KVM_GUESTDBG_BLOCKEVENTS flag to enable 'block interrupts on
> >     single step' together with KVM_CAP_SET_GUEST_DEBUG2 capability
> >     to indicate which guest debug flags are supported.
> > 
> >     This is a replacement for unconditional block of interrupts on single
> >     step that was done in previous version of this patch set.
> >     Patches to qemu to use that feature will be sent soon.
> > 
> >   * Reworked the the 'intercept all exceptions for debug' feature according
> >     to the review feedback:
> > 
> >     - renamed the parameter that enables the feature and
> >       moved it to common kvm module.
> >       (only SVM part is currently implemented though)
> > 
> >     - disable the feature for SEV guests as was suggested during the review
> >     - made the vmexit table const again, as was suggested in the review as well.
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > Maxim Levitsky (9):
> >    scripts/gdb: rework lx-symbols gdb script
> >    KVM: introduce KVM_CAP_SET_GUEST_DEBUG2
> >    KVM: x86: implement KVM_CAP_SET_GUEST_DEBUG2
> >    KVM: aarch64: implement KVM_CAP_SET_GUEST_DEBUG2
> >    KVM: s390x: implement KVM_CAP_SET_GUEST_DEBUG2
> >    KVM: x86: implement KVM_GUESTDBG_BLOCKEVENTS
> >    KVM: SVM: split svm_handle_invalid_exit
> >    KVM: x86: add force_intercept_exceptions_mask
> >    KVM: SVM: implement force_intercept_exceptions_mask
> > 
> >   Documentation/virt/kvm/api.rst    |   4 +
> >   arch/arm64/include/asm/kvm_host.h |   4 +
> >   arch/arm64/kvm/arm.c              |   2 +
> >   arch/arm64/kvm/guest.c            |   5 -
> >   arch/s390/include/asm/kvm_host.h  |   4 +
> >   arch/s390/kvm/kvm-s390.c          |   3 +
> >   arch/x86/include/asm/kvm_host.h   |  12 ++
> >   arch/x86/include/uapi/asm/kvm.h   |   1 +
> >   arch/x86/kvm/svm/svm.c            |  87 +++++++++++--
> >   arch/x86/kvm/svm/svm.h            |   6 +-
> >   arch/x86/kvm/x86.c                |  14 ++-
> >   arch/x86/kvm/x86.h                |   2 +
> >   include/uapi/linux/kvm.h          |   1 +
> >   kernel/module.c                   |   8 +-
> >   scripts/gdb/linux/symbols.py      | 203 ++++++++++++++++++++----------
> >   15 files changed, 272 insertions(+), 84 deletions(-)
> > 


