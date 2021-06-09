Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801E53A1B79
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 19:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhFIRHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 13:07:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32378 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231290AbhFIRHA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 13:07:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623258305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z/0IZRZoC3ri5K//x8QvcCXoHJZ9nYpVsoZ41efk2hc=;
        b=akInbz7/04tuGfCbEEK0LLxoPDitAzaCphk1HD6D2a0CU4uWrSOHJjqAcoWxZph6zWkfLe
        GBqMoTxVbXk68K0+74maUALtxze81yuKHxNdNqJNkE4vxBpzAJFF+HI7AW0dFeui9yvKCk
        XH2lhAUDwW3DLe3Oti2aI7NlQluU+zw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-1pxUGADjNSWJ3XOjs2S4zQ-1; Wed, 09 Jun 2021 13:05:04 -0400
X-MC-Unique: 1pxUGADjNSWJ3XOjs2S4zQ-1
Received: by mail-wr1-f72.google.com with SMTP id e11-20020a056000178bb0290119c11bd29eso6164641wrg.2
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 10:05:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z/0IZRZoC3ri5K//x8QvcCXoHJZ9nYpVsoZ41efk2hc=;
        b=Koh7qTWoP05f6AAY784kJTB8mJ3R7EcCtQEDJJ39H1QA/iMWL4v7nbSXnGXs9BiIjP
         cb5kPR+8+2HQOXkR0Ar9MncM/oux5hFs3HK1l7Xn+fvQ/O4+Ey/AubFD1pw1fILFUxL+
         AmoUA3iQy2I7V+27sQU0NowExJKygnku8h/Grw3+op969dHNkMdP1LoHzCXSSZvKjCYK
         QyJSHFszepnbIhZamjeuFpcHNld/EaPNQucj3YW3es1TrpiS8Drir7fl23lPDvG6BE1+
         2jqRRvngm2w9njfFWtcrcEbbYWgzgnCHHpAUQaC20NOQR/LsptoiyDtr7u5iFnnqrHbK
         dIoQ==
X-Gm-Message-State: AOAM532P9seiQzO2kUd/urDOeaDeAESv6c7Pio7nlpTAX0USAi97IB9G
        91Lv2589YntZrr9yzkEhMIKErF8di2/hzkdKgvQ7treyaC7V0qE00sQMd4fvPTnx2WZzXXaNHtN
        0c2w9FjTRQOh1
X-Received: by 2002:adf:ebc6:: with SMTP id v6mr826823wrn.398.1623258302701;
        Wed, 09 Jun 2021 10:05:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaW3OOmEAQH+v0OvxZ0vKkU470FzSpAi/RT8NhguIjbrHXsEL8uvseKqREFNzGs715WEKSsw==
X-Received: by 2002:adf:ebc6:: with SMTP id v6mr826808wrn.398.1623258302507;
        Wed, 09 Jun 2021 10:05:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j18sm528979wrw.30.2021.06.09.10.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 10:05:01 -0700 (PDT)
To:     Oliver Upton <oupton@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
References: <20210608214742.1897483-1-oupton@google.com>
 <63db3823-b8a3-578d-4baa-146104bb977f@redhat.com>
 <CAOQ_QsgPHAUuzeLy5sX=EhE8tKs7yEF3rxM47YeM_Pk3DUXMcg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 00/10] KVM: Add idempotent controls for migrating system
 counter state
Message-ID: <d5a79989-6866-a405-5501-a3b1223b2ecd@redhat.com>
Date:   Wed, 9 Jun 2021 19:05:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOQ_QsgPHAUuzeLy5sX=EhE8tKs7yEF3rxM47YeM_Pk3DUXMcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 17:11, Oliver Upton wrote:
> Perhaps this will clarify the motivation for my approach: what if the
> kernel wasn't the authoritative source for wall time in a system?
> Furthermore, VMMs may wish to define their own heuristics for counter
> migration (e.g. we only allow the counter to 'jump' by X seconds
> during migration blackout). If a VMM tried to assert its whims on the
> TSC state before handing it down to the kernel, we would inadvertently
> be sampling the host counter twice again. And, anything can happen
> between the time we assert elapsed time is within SLO and KVM
> computing the TSC offset (scheduling, L0 hypervisor preemption).
> 
> So, Maxim's changes would address my concerns in the general case, but
> maybe not as much in edge cases where an operator may make decisions
> about how much time can elapse while the guest hasn't had CPU time.

I think I understand.  We still need a way to get a consistent 
(host_TSC, nanosecond) pair on the source, the TSC offset is not enough. 
  This is arguably not a KVM issue, but we're still the one having to 
provide a solution, so we would need a slightly more complicated interface.

1) In the kernel:

* KVM_GET_CLOCK should also return kvmclock_ns - realtime_ns and 
host_TSC.  It should set two flags in struct kvm_clock_data saying that 
the respective fields are valid.

* KVM_SET_CLOCK checks the flag for kvmclock_ns - realtime_ns.  If set, 
it looks at the kvmclock_ns - realtime_ns field and disregards the 
kvmclock_ns field.

2) On the source, userspace will:

* per-VM: invoke KVM_GET_CLOCK.  Migrate kvmclock_ns - realtime_ns and 
kvmclock_ns.  Stash host_TSC for subsequent use.

* per-vCPU: retrieve guest_TSC - host_TSC with your new ioctl.  Sum it 
to the stashed host_TSC value; migrate the resulting value (a guest TSC).

3) On the destination:

* per-VM: Pass the migrated kvmclock_ns - realtime_ns to KVM_SET_CLOCK. 
  Use KVM_GET_CLOCK to get a consistent pair of kvmclock_ns ("newNS" 
below) and host TSC ("newHostTSC").  Stash them for subsequent use, 
together with the migrated kvmclock_ns value ("sourceNS") that you 
haven't used yet.

* per-vCPU: using the data of the previous step, and the sourceGuestTSC 
in the migration stream, compute sourceGuestTSC + (newNS - sourceNS) * 
freq - newHostTSC.  This is the TSC offset to be passed to your new ioctl.

Your approach still needs to use the "quirky" approach to host-initiated 
MSR_IA32_TSC_ADJUST writes, which write the MSR without affecting the 
VMCS offset.  This is just a documentation issue.

Does this make sense?

Paolo

