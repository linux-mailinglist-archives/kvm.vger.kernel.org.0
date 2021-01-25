Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FA130297D
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 19:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731274AbhAYSDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 13:03:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24687 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731247AbhAYSCl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 13:02:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611597664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kj8WnD/Av6xcMsQoIXxz2MAQOClQaGXeQfmUh1k3o8A=;
        b=Mn/6NSydLK+Nmg9UCWVsdZo56Qk+HZchxM+8SCK3ywyrONNvfRvjT8sydl0biG3v4eeeqW
        R60m8lVyfI09vLTu3ZWp5d597NHeKToFnYZ99Gv1W8Iu09wosKC4uks2EG8y1UIQJOcijH
        2sYrcuOY5VoYGEQWf2ESsTFkj9ihXAE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-asUsQQwpOUGEnb89K8HqSQ-1; Mon, 25 Jan 2021 13:01:02 -0500
X-MC-Unique: asUsQQwpOUGEnb89K8HqSQ-1
Received: by mail-ed1-f72.google.com with SMTP id a24so7910363eda.14
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 10:01:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kj8WnD/Av6xcMsQoIXxz2MAQOClQaGXeQfmUh1k3o8A=;
        b=IZOqsD0QDvvWrrL2naIAO+BOGckBMdvhDu2IlcSDDp4jCKqabx94I/ysQeGPJKUEQU
         MKOxtYcSwWHGtVq6pgwK7b6lSV/4WrkP60MXgimf7MwxJniv2rThUhGOYnf4z+baBqVp
         Ezykiv6NqgquGWVyWP7p745BrtE3abHqXiWptLCClH2ofM3iolsr/x2x+Kl7hC7cUZxS
         wQOaqZm6gmSKFUUCspHNwTBQ3Zmtlm6fgmX8ZTIHfVUG00YY1ABkAQe/k198HhoHbyZN
         dHCe83csspbHpiMxEKDkEGukGiif3IreDlKApnlet7tHjOylixdWXn/2fg3oOdXmf14a
         Mxuw==
X-Gm-Message-State: AOAM530mgvmS+DeD8SQPb2klVDMkxWE7TdTTtcg0Jpcsv64IIaCshi0t
        akso4QQeBCnZtCCFom8G9xBj9kzEcS4/MzHi1sscaolzL+zJVeO3JQoZTUMhbasprTtGIneRn3H
        UziVpa3Li5rj7
X-Received: by 2002:a17:906:eca7:: with SMTP id qh7mr1097672ejb.437.1611597660710;
        Mon, 25 Jan 2021 10:01:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxeiEgicdT3pEGVyqBj+RfipVTpizJIEG1yxBOTpx3zmJo8WRd8bAmyPonXBZuA7ck3e+VyWA==
X-Received: by 2002:a17:906:eca7:: with SMTP id qh7mr1097662ejb.437.1611597660523;
        Mon, 25 Jan 2021 10:01:00 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x25sm10802093edv.65.2021.01.25.10.00.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 10:00:59 -0800 (PST)
Subject: Re: [PATCH v5 0/4] Add bus lock VM exit support
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201106090315.18606-1-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <95477feb-b92d-8f26-fc59-11bbdcc8354b@redhat.com>
Date:   Mon, 25 Jan 2021 19:00:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201106090315.18606-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/20 10:03, Chenyi Qiang wrote:
> This patch series add the support for bus lock VM exit in KVM. It is a
> sub-feature of bus lock detection. When it is enabled by the VMM, the
> processor generates a "Bus Lock" VM exit following execution of an
> instruction if the processor detects that one or more bus locks were
> caused the instruction was being executed (due to either direct access
> by the instruction or stuffed accesses like through A/D updates).
> 
> Bus lock VM exit will introduce a new modifier bit (bit 26) in
> exit_reason field in VMCS which indicates bus lock VM exit is preempted
> by a higher priority VM exit. The first patch is to apply Sean's
> refactor for vcpu_vmx.exit_reason as a preparation patch for bus lock
> VM exit support.
> 
> The second patch is the refactor for vcpu->run->flags. Bus lock VM exit
> will introduce a new field in the flags to inform the userspace that
> there's a bus lock detected in guest. It's also a preparation patch.
> 
> The third patch is the concrete enabling working for bus lock VM exit.
> Add the support to set the capability to enable bus lock VM exit. The
> current implementation is just exiting to userspace when handling the
> bus lock detected in guest.
> 
> The detail of throttling policy in user space is still to be discussed.
> We may enforce ratelimit on bus lock in guest, inject some sleep time,
> or... We hope to get more ideas on this.
> 
> Document for Bus Lock Detection is now available at the latest "Intel
> Architecture Instruction Set Extensions Programming Reference".
> 
> Document Link:
> https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html
> 
> ---
> 
> Changelogs
> 
> v4->v5:
> - rebase on top on v5.10-rc2
> - add preparation patch that reset the vcpu->run->flags at the beginning
>    of the vcpu_run.(Suggested by Sean)
> - set the KVM_RUN_BUS_LOCK for all bus lock exit to avoid checking both
>    exit_reason and run->flags
> - add the document to introduce the new kvm capability
>    (KVM_CAP_X86_BUS_LOCK_EXIT)
> - v4:https://lore.kernel.org/lkml/20201012033542.4696-1-chenyi.qiang@intel.com/
> 
> 
> v3->v4:
> - rebase on top of v5.9
> - some code cleanup.
> - v3:https://lore.kernel.org/lkml/20200910083751.26686-1-chenyi.qiang@intel.com/
> 
> v2->v3:
> - use a bitmap to get/set the capability of bus lock detection. we support
>    exit and off mode currently.
> - put the handle of exiting to userspace in vmx.c, thus no need to
>    define a shadow to track vmx->exit_reason.bus_lock_detected.
> - remove the vcpu->stats.bus_locks since every bus lock exits to userspace.
> - v2:https://lore.kernel.org/lkml/20200817033604.5836-1-chenyi.qiang@intel.com/
> 
> v1->v2:
> - resolve Vitaly's comment to introduce the KVM_EXIT_BUS_LOCK and a
>    capability to enable it.
> - add the support to exit to user space when handling bus locks.
> - extend the vcpu->run->flags to indicate bus lock detected for other
>    exit reasons when exiting to user space.
> - v1:https://lore.kernel.org/lkml/20200628085341.5107-1-chenyi.qiang@intel.com/
> 
> ---
> 
> Chenyi Qiang (3):
>    KVM: X86: Reset the vcpu->run->flags at the beginning of vcpu_run
>    KVM: VMX: Enable bus lock VM exit
>    KVM: X86: Add the Document for KVM_CAP_X86_BUS_LOCK_EXIT
> 
> Sean Christopherson (1):
>    KVM: VMX: Convert vcpu_vmx.exit_reason to a union
> 
>   Documentation/virt/kvm/api.rst     |  45 ++++++++++++-
>   arch/x86/include/asm/kvm_host.h    |   7 ++
>   arch/x86/include/asm/vmx.h         |   1 +
>   arch/x86/include/asm/vmxfeatures.h |   1 +
>   arch/x86/include/uapi/asm/kvm.h    |   1 +
>   arch/x86/include/uapi/asm/vmx.h    |   4 +-
>   arch/x86/kvm/vmx/capabilities.h    |   6 ++
>   arch/x86/kvm/vmx/nested.c          |  42 +++++++-----
>   arch/x86/kvm/vmx/vmx.c             | 105 +++++++++++++++++++----------
>   arch/x86/kvm/vmx/vmx.h             |  25 ++++++-
>   arch/x86/kvm/x86.c                 |  28 +++++++-
>   include/uapi/linux/kvm.h           |   5 ++
>   12 files changed, 214 insertions(+), 56 deletions(-)
> 

Queued, thanks.  I have replaced KVM_RUN_BUS_LOCK with 
KVM_RUN_X86_BUS_LOCK, though.

Paolo

