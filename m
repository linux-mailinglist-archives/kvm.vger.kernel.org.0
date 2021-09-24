Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF76417902
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343643AbhIXQpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:45:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233969AbhIXQo7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:44:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xrd9wID+O6lXydA/auUdyoLz8h/dNJ6woqTmdu062kc=;
        b=hMAmEt4Gqd3tuMia+U0dQiHb7nCR/qkuPH/OpzLfMHgBzGUqWoUXcQYapq2qCwiaMEtrJm
        GiMlPCoTsTnL4za8JLiRVSbh6kX1Sgt2vPerQ6/R8qHwVRa0YqibTZfhm7vI+ItAEzOGqW
        B1UOwKpF93UtDI3sIF1PekKRPPS4hiU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-ctTK7b3CNfGKyVLRkNXybg-1; Fri, 24 Sep 2021 12:43:24 -0400
X-MC-Unique: ctTK7b3CNfGKyVLRkNXybg-1
Received: by mail-ed1-f70.google.com with SMTP id m30-20020a50999e000000b003cdd7680c8cso10831574edb.11
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 09:43:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Xrd9wID+O6lXydA/auUdyoLz8h/dNJ6woqTmdu062kc=;
        b=fEyKtRQiZILkEXmML8MTx9tJDMSONOoIT2BrWnqCgYVogL30XJwNw89xcoRj3kF4Bl
         wygr/h/5NalMflf1heMJn7I8oDRoXs4djZjJjM2zz6t9BRDYmrpcLNr2n68j1hS3gUYl
         ZUVtfRDXxkCtZe/I9fHiV93e6TsD8AnulknH1H6oIkf0yztDiM+wBqKmATZd9HnO0laK
         D4VkieTTQptoV6U1T9UW14CZWLqJcxtf96Ipz2UQxjpFSaggvgso85wzdeeEg8kaHk+V
         VRTF4cAjWygL0xYXTPpb2/in1mOHvJ81JuPM+tSe/5LypCINL7HBqb8zFTpBriShU9iO
         t9DA==
X-Gm-Message-State: AOAM532uYpaKaw/D/T3riM+n1YqnbSh7Mai8OsI4C9TcbitmqcEJa9Ql
        IHSndfmrxVewP3z+fPdVUZPnyGfMV9kRkDMfUab4/wXpJb8Xw/GlC/TE1sgVFMz2suiLQ0UA2WC
        UE3CyIZYtkXHb
X-Received: by 2002:a17:906:32c9:: with SMTP id k9mr12526948ejk.218.1632501803387;
        Fri, 24 Sep 2021 09:43:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycJysgKh7IfROIXy7X+AKIfF9Ahyp8Cqy6RCpIsmYlwjlA3xpaOkwlN4ADHD6VhHck9ohNyA==
X-Received: by 2002:a17:906:32c9:: with SMTP id k9mr12526912ejk.218.1632501803170;
        Fri, 24 Sep 2021 09:43:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x7sm6009332ede.86.2021.09.24.09.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 09:43:22 -0700 (PDT)
Message-ID: <bceb41e9-164e-0a84-5205-daef58e13097@redhat.com>
Date:   Fri, 24 Sep 2021 18:43:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 0/7] KVM: x86: Add idempotent controls for migrating
 system counter state
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210916181538.968978-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210916181538.968978-1-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/21 20:15, Oliver Upton wrote:
> KVM's current means of saving/restoring system counters is plagued with
> temporal issues. On x86, we migrate the guest's system counter by-value
> through the respective guest's IA32_TSC value. Restoring system counters
> by-value is brittle as the state is not idempotent: the host system
> counter is still oscillating between the attempted save and restore.
> Furthermore, VMMs may wish to transparently live migrate guest VMs,
> meaning that they include the elapsed time due to live migration blackout
> in the guest system counter view. The VMM thread could be preempted for
> any number of reasons (scheduler, L0 hypervisor under nested) between the
> time that it calculates the desired guest counter value and when
> KVM actually sets this counter state.
> 
> Despite the value-based interface that we present to userspace, KVM
> actually has idempotent guest controls by way of the TSC offset.
> We can avoid all of the issues associated with a value-based interface
> by abstracting these offset controls in a new device attribute. This
> series introduces new vCPU device attributes to provide userspace access
> to the vCPU's system counter offset.
> 
> Patches 1-2 are Paolo's refactorings around locking and the
> KVM_{GET,SET}_CLOCK ioctls.
> 
> Patch 3 cures a race where use_master_clock is read outside of the
> pvclock lock in the KVM_GET_CLOCK ioctl.
> 
> Patch 4 adopts Paolo's suggestion, augmenting the KVM_{GET,SET}_CLOCK
> ioctls to provide userspace with a (host_tsc, realtime) instant. This is
> essential for a VMM to perform precise migration of the guest's system
> counters.
> 
> Patch 5 does away with the pvclock spin lock in favor of a sequence
> lock based on the tsc_write_lock. The original patch is from Paolo, I
> touched it up a bit to fix a deadlock and some unused variables that
> caused -Werror to scream.
> 
> Patch 6 extracts the TSC synchronization tracking code in a way that it
> can be used for both offset-based and value-based TSC synchronization
> schemes.
> 
> Finally, patch 7 implements a vCPU device attribute which allows VMMs to
> get at the TSC offset of a vCPU.
> 
> This series was tested with the new KVM selftests for the KVM clock and
> system counter offset controls on Haswell hardware. Kernel was built
> with CONFIG_LOCKDEP given the new locking changes/lockdep assertions
> here.
> 
> Note that these tests are mailed as a separate series due to the
> dependencies in both x86 and arm64.
> 
> Applies cleanly to 5.15-rc1
> 
> v8: http://lore.kernel.org/r/20210816001130.3059564-1-oupton@google.com
> 
> v7 -> v8:
>   - Rebased to 5.15-rc1
>   - Picked up Paolo's version of the series, which includes locking
>     changes
>   - Make KVM advertise KVM_CAP_VCPU_ATTRIBUTES
> 
> Oliver Upton (4):
>    KVM: x86: Fix potential race in KVM_GET_CLOCK
>    KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK
>    KVM: x86: Refactor tsc synchronization code
>    KVM: x86: Expose TSC offset controls to userspace
> 
> Paolo Bonzini (3):
>    kvm: x86: abstract locking around pvclock_update_vm_gtod_copy
>    KVM: x86: extract KVM_GET_CLOCK/KVM_SET_CLOCK to separate functions
>    kvm: x86: protect masterclock with a seqcount
> 
>   Documentation/virt/kvm/api.rst          |  42 ++-
>   Documentation/virt/kvm/devices/vcpu.rst |  57 +++
>   arch/x86/include/asm/kvm_host.h         |  12 +-
>   arch/x86/include/uapi/asm/kvm.h         |   4 +
>   arch/x86/kvm/x86.c                      | 458 ++++++++++++++++--------
>   include/uapi/linux/kvm.h                |   7 +-
>   6 files changed, 419 insertions(+), 161 deletions(-)
> 

Queued, thanks.

Paolo

