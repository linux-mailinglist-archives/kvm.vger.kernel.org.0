Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA4A21B101
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 10:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgGJIHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 04:07:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60256 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727050AbgGJIG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 04:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594368417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U4jS1QoQjjeHX3nPPzYjEddY3DRl7Jsr2mcq4h0i1jc=;
        b=BtVEkmGyeiLf1NmxwEisL0pgA/fXYsAzjvm7IvGNMzI5Dmrb+P5tPUmzesic+F0EH/lBj4
        +BOobClErGeXU57p3mnY6H6x0DL+Wkg6k8M60/IBm/VZmhTgvach14O+DbWG1tw2CpJhIT
        gzXgHz0KKDuvkdNYqQmeD8my8zhcqzU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-4X3hDKHNO26U1aVFtrt1EQ-1; Fri, 10 Jul 2020 04:06:55 -0400
X-MC-Unique: 4X3hDKHNO26U1aVFtrt1EQ-1
Received: by mail-wr1-f71.google.com with SMTP id y16so5083996wrr.20
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 01:06:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U4jS1QoQjjeHX3nPPzYjEddY3DRl7Jsr2mcq4h0i1jc=;
        b=f/IZ03xGZid/Yh6bMKXiwO22iaQuw80pju1EpZRSndvTxpj7zQ0K1gRtIyjkuQ2jXz
         e54v7sndCsbj/kxYBxut03gJ+O+VJAD/OrStSaHsvpV9UWZb7nrNDAAsMJKd6RCKimNN
         tuMYLkdHZ7+3Hsb1B8nqreGZdlLwh3wil5xaedQVhTey22kw9F1KLDGfPlGgwY0wHjN8
         Z76Ve1d42YGnM79PZEigd76JmFbsxXrWitRDWLMa4uU58tvS5+jfGOforuITzTfr8gel
         tUtNCXmBVapPt+W2rbAu2euVgY9vWzF9Odlue0leki2XCBclgUU12ur9mDufscWUXcwQ
         zdLA==
X-Gm-Message-State: AOAM532yL+gnxvJDE3f3NDXpPk8AJODUarpcMIWCTC2FPUOPoFFOO9+z
        uBhSsR3Q63Q/6LAjXhztVcyO2gM59vpG67KJKotzYQcsPf4IcgSjBz/XqPjeme+Sy2nNDDe4joD
        a7yjqsbMwGbvI
X-Received: by 2002:a1c:1fd1:: with SMTP id f200mr3838409wmf.162.1594368414523;
        Fri, 10 Jul 2020 01:06:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJjT5tWv9/nRHPZPlasSYyXK0UFRsIXqd7zkWACOymjphFAEJPu8OB7fs8YgXWFmbnz1f6Yg==
X-Received: by 2002:a1c:1fd1:: with SMTP id f200mr3838385wmf.162.1594368414271;
        Fri, 10 Jul 2020 01:06:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id v3sm9130496wrq.57.2020.07.10.01.06.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 01:06:53 -0700 (PDT)
Subject: Re: [PATCH v6 0/5] clean up redundant 'kvm_run' parameters
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        tsbogend@alpha.franken.de, paulus@ozlabs.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com,
        chenhuacai@gmail.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200623131418.31473-1-tianjia.zhang@linux.alibaba.com>
 <6604e273-d7b1-5007-8721-75c4a4dec68e@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <433ae9a7-ee86-28ea-e600-8769f9759513@redhat.com>
Date:   Fri, 10 Jul 2020 10:06:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <6604e273-d7b1-5007-8721-75c4a4dec68e@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/20 09:32, Tianjia Zhang wrote:
> Hi Paolo,
> 
> Any opinion on this series patches? Can I help with this patchset ?

I was hoping to have some Tested-by, for now I'm queuing patches 1 and
2.  Thanks,

Paolo

> Thanks and best,
> Tianjia
> 
> On 2020/6/23 21:14, Tianjia Zhang wrote:
>> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
>> structure. For historical reasons, many kvm-related function parameters
>> retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
>> patch does a unified cleanup of these remaining redundant parameters.
>>
>> This series of patches has completely cleaned the architecture of
>> arm64, mips, ppc, and s390 (no such redundant code on x86). Due to
>> the large number of modified codes, a separate patch is made for each
>> platform. On the ppc platform, there is also a redundant structure
>> pointer of 'kvm_run' in 'vcpu_arch', which has also been cleaned
>> separately.
>>
>> ---
>> v6 changes:
>>    Rearrange patch sets, only keep the unmerged patch.
>>    rebase on mainline.
>>
>> v5 change:
>>    ppc: fix for review.
>>
>> v4 change:
>>    mips: fixes two errors in entry.c.
>>
>> v3 change:
>>    Keep the existing `vcpu->run` in the function body unchanged.
>>
>> v2 change:
>>    s390 retains the original variable name and minimizes modification.
>>
>> Tianjia Zhang (5):
>>    KVM: s390: clean up redundant 'kvm_run' parameters
>>    KVM: arm64: clean up redundant 'kvm_run' parameters
>>    KVM: PPC: clean up redundant kvm_run parameters in assembly
>>    KVM: MIPS: clean up redundant 'kvm_run' parameters
>>    KVM: MIPS: clean up redundant kvm_run parameters in assembly
>>
>>   arch/arm64/include/asm/kvm_coproc.h   |  12 +--
>>   arch/arm64/include/asm/kvm_host.h     |  11 +--
>>   arch/arm64/include/asm/kvm_mmu.h      |   2 +-
>>   arch/arm64/kvm/arm.c                  |   6 +-
>>   arch/arm64/kvm/handle_exit.c          |  36 ++++----
>>   arch/arm64/kvm/mmio.c                 |  11 +--
>>   arch/arm64/kvm/mmu.c                  |   5 +-
>>   arch/arm64/kvm/sys_regs.c             |  13 ++-
>>   arch/mips/include/asm/kvm_host.h      |  32 ++------
>>   arch/mips/kvm/emulate.c               |  59 +++++--------
>>   arch/mips/kvm/entry.c                 |  21 ++---
>>   arch/mips/kvm/mips.c                  |  14 ++--
>>   arch/mips/kvm/trap_emul.c             | 114 +++++++++++---------------
>>   arch/mips/kvm/vz.c                    |  26 +++---
>>   arch/powerpc/include/asm/kvm_ppc.h    |   2 +-
>>   arch/powerpc/kvm/book3s_interrupts.S  |  22 +++--
>>   arch/powerpc/kvm/book3s_pr.c          |   9 +-
>>   arch/powerpc/kvm/booke.c              |   9 +-
>>   arch/powerpc/kvm/booke_interrupts.S   |   9 +-
>>   arch/powerpc/kvm/bookehv_interrupts.S |  10 +--
>>   arch/s390/kvm/kvm-s390.c              |  23 ++++--
>>   21 files changed, 188 insertions(+), 258 deletions(-)
>>
> 

