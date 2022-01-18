Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F0F49287E
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 15:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238089AbiAROfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 09:35:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28196 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235461AbiAROfh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 09:35:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642516536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zO56Q09aUpTDvis1ATNxTEf5i/l2MGs9tufQPSMA4GM=;
        b=Tf/HpNOcAluzHswEmI7MpXdVyhH6VmAq8xhZomHe4nz8ivLWjMtxhGJUoMyuth8pi1gqye
        bIyLF1py1WfSMiscgRs9NF9tjSafedDhudPFceQ2Ut+exn+oMo+ZA+/i8CI50IXVZnY/W1
        VVVRB/ks2GSAbB/qPDc5GdRIYYGoNA0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-bDn00gdPNBi-dF5h556Kkw-1; Tue, 18 Jan 2022 09:35:35 -0500
X-MC-Unique: bDn00gdPNBi-dF5h556Kkw-1
Received: by mail-ed1-f69.google.com with SMTP id s9-20020aa7d789000000b004021d03e2dfso6936220edq.18
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 06:35:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zO56Q09aUpTDvis1ATNxTEf5i/l2MGs9tufQPSMA4GM=;
        b=jNwE4d76N0FXALJrmQRfph6F50KYZDJ/0+/qopj8o36DCFl1vyPPmhaLlFaQqBASM3
         fv0zdyoFMf8hMIopR5hXBJBkkncGouMYE+G2oO5JV+wXvJxO4mmQA5bIog8irXktIzD9
         UjfVc/1cgb88MDWmRYUCrIB1v/Bfc9hHj9owGQ63ImFo1boeEibcFFbQP2smZLqMQf3K
         +ACOINwo+to91zv/64sGmjzbeljWmfkcTGtGMVdlCKolg/ZFoRuj8Oi/0NlrIuMsnkE5
         fd/DqcIQpxnywiNVT6RPTeC2/aXQr4TyYhTzUbC0fojFOsK2In4OHAxNINd30xm1+lZb
         gl3A==
X-Gm-Message-State: AOAM53034qeZX2AO35dG42/9vP6A0XChxz7u3l9GtmQHR5CJ2Zh/pUwc
        UDYpXchKJoJa+Sw1aOS3CqvXbrf9SH5o1AWNWuWxn325GPKBPqOHSj4eA3VjU80ZGCFM4PkaZop
        T3wpVHHajWKHs
X-Received: by 2002:a17:907:3d01:: with SMTP id gm1mr20279304ejc.749.1642516533973;
        Tue, 18 Jan 2022 06:35:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwss7y31/0dF5od58DVlTkQA8CaCauTNMQEa0nCt8L/Pa5H1yYps+xfo6rOrrwvuZTC0MVFDA==
X-Received: by 2002:a17:907:3d01:: with SMTP id gm1mr20279293ejc.749.1642516533755;
        Tue, 18 Jan 2022 06:35:33 -0800 (PST)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id mp5sm5413623ejc.46.2022.01.18.06.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 06:35:33 -0800 (PST)
Date:   Tue, 18 Jan 2022 15:35:31 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] KVM: x86: Partially allow KVM_SET_CPUID{,2}
 after KVM_RUN for CPU hotplug
Message-ID: <20220118153531.11e73048@redhat.com>
In-Reply-To: <20220117150542.2176196-1-vkuznets@redhat.com>
References: <20220117150542.2176196-1-vkuznets@redhat.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Jan 2022 16:05:38 +0100
Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> Changes since v1:
> - Drop the allowlist of items which were allowed to change and just allow
> the exact same CPUID data [Sean, Paolo]. Adjust selftest accordingly.
> - Drop PATCH1 as the exact same change got merged upstream.
> 
> Recently, KVM made it illegal to change CPUID after KVM_RUN but
> unfortunately this change is not fully compatible with existing VMMs.
> In particular, QEMU reuses vCPU fds for CPU hotplug after unplug and it
> calls KVM_SET_CPUID2. Relax the requirement by implementing an allowing
> KVM_SET_CPUID{,2} with the exact same data.


Can you check following scenario:
 * on host that has IA32_TSX_CTRL and TSX enabled (RTM/HLE cpuid bits present)
 * boot 2 vcpus VM with TSX enabled on VMM side but with tsx=off on kernel CLI

     that should cause kernel to set MSR_IA32_TSX_CTRL to 3H from initial 0H
     and clear RTM+HLE bits in CPUID, check that RTM/HLE cpuid it cleared

 * hotunplug a VCPU and then replug it again
    if IA32_TSX_CTRL is reset to initial state, that should re-enable
    RTM/HLE cpuid bits and KVM_SET_CPUID2 might fail due to difference

and as Sean pointed out there might be other non constant leafs,
where exact match check could leave userspace broken.
     

> Vitaly Kuznetsov (4):
>   KVM: x86: Do runtime CPUID update before updating
>     vcpu->arch.cpuid_entries
>   KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN
>   KVM: selftests: Rename 'get_cpuid_test' to 'cpuid_test'
>   KVM: selftests: Test KVM_SET_CPUID2 after KVM_RUN
> 
>  arch/x86/kvm/cpuid.c                          | 67 ++++++++++++++++---
>  arch/x86/kvm/x86.c                            | 19 ------
>  tools/testing/selftests/kvm/.gitignore        |  2 +-
>  tools/testing/selftests/kvm/Makefile          |  4 +-
>  .../selftests/kvm/include/x86_64/processor.h  |  7 ++
>  .../selftests/kvm/lib/x86_64/processor.c      | 33 +++++++--
>  .../x86_64/{get_cpuid_test.c => cpuid_test.c} | 30 +++++++++
>  7 files changed, 126 insertions(+), 36 deletions(-)
>  rename tools/testing/selftests/kvm/x86_64/{get_cpuid_test.c => cpuid_test.c} (83%)
> 

