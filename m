Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C9B1529FA
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 12:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbgBELex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 06:34:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25322 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727170AbgBELex (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 06:34:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580902492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=b+0W+7i9dVLLAYCaMhmoAtbhqa1LPVVuoSpp0bmu9kU=;
        b=hG6YWOVBy5gts0gDKKWx42MwuogwQxk/LqX6CfhKuyQk4jC+SPjBoMAojtInHtFmRBf0fX
        VVV7nHMQc/thAQMyDT/Ty8EwNAvx2+WeiL2gIt7feMxMi/D8KMGgl5Cu9W1DBttAZ1AxR6
        L0aJiyaZaiaKuQv2b4DwSv9yOFcQTQE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-qKnelNBdMo-pZi4u4c7ASA-1; Wed, 05 Feb 2020 06:34:48 -0500
X-MC-Unique: qKnelNBdMo-pZi4u4c7ASA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 122A61063BA0;
        Wed,  5 Feb 2020 11:34:47 +0000 (UTC)
Received: from [10.36.116.217] (ovpn-116-217.ams2.redhat.com [10.36.116.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55FBF212E;
        Wed,  5 Feb 2020 11:34:45 +0000 (UTC)
Subject: Re: [RFCv2 00/37] KVM: s390: Add support for protected VMs
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <8297d9a4-0d4a-1df0-d2a9-c980e4b2827c@redhat.com>
Date:   Wed, 5 Feb 2020 12:34:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.02.20 14:19, Christian Borntraeger wrote:
> Protected VMs (PVM) are KVM VMs, where KVM can't access the VM's state
> like guest memory and guest registers anymore. Instead the PVMs are
> mostly managed by a new entity called Ultravisor (UV), which provides
> an API, so KVM and the PV can request management actions.
> 
> PVMs are encrypted at rest and protected from hypervisor access while
> running. They switch from a normal operation into protected mode, so
> we can still use the standard boot process to load a encrypted blob
> and then move it into protected mode.
> 
> Rebooting is only possible by passing through the unprotected/normal
> mode and switching to protected again.
> 
> All patches are in the protvirtv2 branch of the korg s390 kvm git
> (on top of Janoschs reset rework).
> 
> Claudio presented the technology at his presentation at KVM Forum
> 2019.
> 
> This contains a "pretty small" common code memory management change that
> will allow paging, guest backing with files etc almost just like normal
> VMs. Please note that the memory management part will still see some
> changes to deal with a corner case for the adapter interrupt indicator
> pages. So please focus on the non-mm parts (which hopefully has
> everthing addressed in the next version). Claudio will work with Andrea
> regarding this.
> 
> Christian Borntraeger (3):
>   KVM: s390/mm: Make pages accessible before destroying the guest
>   KVM: s390: protvirt: Add SCLP interrupt handling
>   KVM: s390: protvirt: do not inject interrupts after start
> 
> Claudio Imbrenda (3):
>   mm:gup/writeback: add callbacks for inaccessible pages
>   s390/mm: provide memory management functions for protected KVM guests
>   KVM: s390/mm: handle guest unpin events
> 
> Janosch Frank (24):
>   DOCUMENTATION: protvirt: Protected virtual machine introduction
>   KVM: s390: add new variants of UV CALL
>   KVM: s390: protvirt: Add initial lifecycle handling
>   KVM: s390: protvirt: Add KVM api documentation
>   KVM: s390: protvirt: Secure memory is not mergeable
>   KVM: s390: protvirt: Handle SE notification interceptions
>   KVM: s390: protvirt: Instruction emulation
>   KVM: s390: protvirt: Handle spec exception loops
>   KVM: s390: protvirt: Add new gprs location handling
>   KVM: S390: protvirt: Introduce instruction data area bounce buffer
>   KVM: s390: protvirt: handle secure guest prefix pages
>   KVM: s390: protvirt: Write sthyi data to instruction data area
>   KVM: s390: protvirt: STSI handling
>   KVM: s390: protvirt: disallow one_reg
>   KVM: s390: protvirt: Only sync fmt4 registers
>   KVM: s390: protvirt: Add program exception injection
>   DOCUMENTATION: protvirt: Diag 308 IPL
>   KVM: s390: protvirt: Add diag 308 subcode 8 - 10 handling
>   KVM: s390: protvirt: UV calls diag308 0, 1
>   KVM: s390: protvirt: Report CPU state to Ultravisor
>   KVM: s390: protvirt: Support cmd 5 operation state
>   KVM: s390: protvirt: Add UV debug trace
>   KVM: s390: protvirt: Mask PSW interrupt bits for interception 104 and
>     112
>   KVM: s390: protvirt: Add UV cpu reset calls
> 
> Michael Mueller (4):
>   KVM: s390: protvirt: Add interruption injection controls
>   KVM: s390: protvirt: Implement interruption injection
>   KVM: s390: protvirt: Add machine-check interruption injection controls
>   KVM: s390: protvirt: Implement machine-check interruption injection
> 
> Vasily Gorbik (3):
>   s390/protvirt: introduce host side setup
>   s390/protvirt: add ultravisor initialization
>   s390: add (non)secure page access exceptions handlers
> 
>  .../admin-guide/kernel-parameters.txt         |   5 +
>  Documentation/virt/kvm/api.txt                |  62 +++
>  Documentation/virt/kvm/s390-pv-boot.rst       |  64 +++
>  Documentation/virt/kvm/s390-pv.rst            | 103 ++++
>  MAINTAINERS                                   |   1 +
>  arch/s390/boot/Makefile                       |   2 +-
>  arch/s390/boot/uv.c                           |  20 +-
>  arch/s390/include/asm/gmap.h                  |   3 +
>  arch/s390/include/asm/kvm_host.h              | 112 +++-
>  arch/s390/include/asm/mmu.h                   |   2 +
>  arch/s390/include/asm/mmu_context.h           |   1 +
>  arch/s390/include/asm/page.h                  |   5 +
>  arch/s390/include/asm/pgtable.h               |  35 +-
>  arch/s390/include/asm/uv.h                    | 265 +++++++++-
>  arch/s390/kernel/Makefile                     |   1 +
>  arch/s390/kernel/pgm_check.S                  |   4 +-
>  arch/s390/kernel/setup.c                      |   7 +-
>  arch/s390/kernel/uv.c                         | 271 ++++++++++
>  arch/s390/kvm/Kconfig                         |  19 +
>  arch/s390/kvm/Makefile                        |   2 +-
>  arch/s390/kvm/diag.c                          |   7 +
>  arch/s390/kvm/intercept.c                     | 107 +++-
>  arch/s390/kvm/interrupt.c                     | 211 ++++++--
>  arch/s390/kvm/kvm-s390.c                      | 486 ++++++++++++++++--
>  arch/s390/kvm/kvm-s390.h                      |  56 ++
>  arch/s390/kvm/priv.c                          |   9 +-
>  arch/s390/kvm/pv.c                            | 293 +++++++++++
>  arch/s390/mm/fault.c                          |  87 ++++
>  arch/s390/mm/gmap.c                           |  63 ++-
>  include/linux/gfp.h                           |   6 +
>  include/uapi/linux/kvm.h                      |  47 +-
>  mm/gup.c                                      |   2 +
>  mm/page-writeback.c                           |   1 +
>  33 files changed, 2217 insertions(+), 142 deletions(-)
>  create mode 100644 Documentation/virt/kvm/s390-pv-boot.rst
>  create mode 100644 Documentation/virt/kvm/s390-pv.rst
>  create mode 100644 arch/s390/kernel/uv.c
>  create mode 100644 arch/s390/kvm/pv.c
> 

Due to the huge amount of review feedback (which makestime-consuming to
review if one doesn't want to comment the same thing again), I suggest
sending a new RFC rather soon-ish (e.g., on a weekly basis) - if nobody
objects. Would at least make my life easier :)

-- 
Thanks,

David / dhildenb

