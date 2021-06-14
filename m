Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1273A5DD2
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 09:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhFNHmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 03:42:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55902 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232492AbhFNHmZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 03:42:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623656422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pO1bs4aCeAGMi6QoUevwRlfOuXmOwF8LHg6aMdXgv4A=;
        b=hYLKn+44wPWyjXfOHUpW3g+7Q/VZqyfvPr2mqS8QinqL74T3LkVCgOPeqLwncUop5o9Fuh
        iucUHp6NqHcgFCQlf5T9dWqrfb+Qur2Supj1YdGJLa96bV3DVA1HRTgNpTIe1vsBRqb9wE
        FcpfVRpJdBDTdMtjApcWQiLsnM6aRXo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-ZKfjLBnmOe2Lhz30pr2rwQ-1; Mon, 14 Jun 2021 03:40:21 -0400
X-MC-Unique: ZKfjLBnmOe2Lhz30pr2rwQ-1
Received: by mail-ed1-f71.google.com with SMTP id p24-20020aa7c8980000b0290393c37fdcb8so8621380eds.6
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 00:40:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=pO1bs4aCeAGMi6QoUevwRlfOuXmOwF8LHg6aMdXgv4A=;
        b=eUm06L54UX9vRhHqjoiFdq92PlfFIimW+HoCNr3sVN4VN5Afm0X/xZdrkWy6G7MrXS
         K/EiCwXE9xK853MHFYjaSPhDILEZb59PqkSBEhMdrc1CEiV3f0iRw/KwcRmzhy9xOTzK
         T2wsiQbjl38gA15oeJIjLUqkbE06CpZJ1Qjixuc259EHSOf/qMXXrL2WP9hhny8iHVKP
         uywVLJ1jMmwWZM2NPNm+IOFSQYFlOo9hE0MtV+p1bB8Paa1KDw3kzxFVjzXVvmsBbc0x
         pgEoAr2+8xqhPomF+3Ai7/DLprSv0giPQNSRgFrvCUbO7HXXNWgJhwVBq88oGYQvIQfz
         xRPA==
X-Gm-Message-State: AOAM530gf23s1vON7yns2JdfvAsNi0JPWUv6+E2oOGRu4zHE19J8sekt
        xoB2GweTFEiAzqgQ14sw7J2/hWOarNOf7x/vOu5uHIKv6X5jvPd78XQNMTdgPDCNrQSKgLr2ioj
        IVJa/5fziFNwd
X-Received: by 2002:a17:906:5f99:: with SMTP id a25mr14108181eju.45.1623656420104;
        Mon, 14 Jun 2021 00:40:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHtYGUGNum+bcwXR+N/ohsUHAg9NGqifx/V1ATCaqzSQSYy3WvGVLoJyEXGm5FMnXAxqJu6w==
X-Received: by 2002:a17:906:5f99:: with SMTP id a25mr14108166eju.45.1623656419835;
        Mon, 14 Jun 2021 00:40:19 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id au11sm6707061ejc.88.2021.06.14.00.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:40:19 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 0/4] KVM: x86: hyper-v: Conditionally allow SynIC
 with APICv/AVIC
In-Reply-To: <f294faba4e5d25aba8773f36170d1309236edd3b.camel@redhat.com>
References: <20210609150911.1471882-1-vkuznets@redhat.com>
 <f294faba4e5d25aba8773f36170d1309236edd3b.camel@redhat.com>
Date:   Mon, 14 Jun 2021 09:40:18 +0200
Message-ID: <87zgvsx5b1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Wed, 2021-06-09 at 17:09 +0200, Vitaly Kuznetsov wrote:
>> Changes since v2:
>> - First two patches got merged, rebase.
>> - Use 'enable_apicv =3D avic =3D ...' in PATCH1 [Paolo]
>> - Collect R-b tags for PATCH2 [Sean, Max]
>> - Use hv_apicv_update_work() to get out of SRCU lock [Max]
>> - "KVM: x86: Check for pending interrupts when APICv is getting disabled"
>>   added.
>>=20
>> Original description:
>>=20
>> APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
>> SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It =
is,
>> however, possible to track whether the feature was actually used by the
>> guest and only inhibit APICv/AVIC when needed.
>>=20
>> The series can be tested with the followin hack:
>>=20
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 9a48f138832d..65a9974f80d9 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -147,6 +147,13 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>>                                            vcpu->arch.ia32_misc_enable_m=
sr &
>>                                            MSR_IA32_MISC_ENABLE_MWAIT);
>>         }
>> +
>> +       /* Dirty hack: force HV_DEPRECATING_AEOI_RECOMMENDED. Not to be =
merged! */
>> +       best =3D kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INF=
O, 0);
>> +       if (best) {
>> +               best->eax &=3D ~HV_X64_APIC_ACCESS_RECOMMENDED;
>> +               best->eax |=3D HV_DEPRECATING_AEOI_RECOMMENDED;
>> +       }
>>  }
>>  EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
>>=20=20
>> Vitaly Kuznetsov (4):
>>   KVM: x86: Use common 'enable_apicv' variable for both APICv and AVIC
>>   KVM: x86: Drop vendor specific functions for APICv/AVIC enablement
>>   KVM: x86: Check for pending interrupts when APICv is getting disabled
>>   KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in
>>     use
>>=20
>>  arch/x86/include/asm/kvm_host.h |  9 +++++-
>>  arch/x86/kvm/hyperv.c           | 51 +++++++++++++++++++++++++++++----
>>  arch/x86/kvm/svm/avic.c         | 14 ++++-----
>>  arch/x86/kvm/svm/svm.c          | 22 ++++++++------
>>  arch/x86/kvm/svm/svm.h          |  2 --
>>  arch/x86/kvm/vmx/capabilities.h |  1 -
>>  arch/x86/kvm/vmx/vmx.c          |  2 --
>>  arch/x86/kvm/x86.c              | 18 ++++++++++--
>>  8 files changed, 86 insertions(+), 33 deletions(-)
>>=20
>
> Hi!
>
> I hate to say it, but at least one of my VMs doesn't boot amymore
> with avic=3D1, after the recent updates. I'll bisect this soon,
> but this is likely related to this series.
>
> I will also review this series very soon.
>
> When the VM fails, it hangs on the OVMF screen and I see this
> in qemu logs:
>
> KVM: injection failed, MSI lost (Operation not permitted)
> KVM: injection failed, MSI lost (Operation not permitted)
> KVM: injection failed, MSI lost (Operation not permitted)
> KVM: injection failed, MSI lost (Operation not permitted)
> KVM: injection failed, MSI lost (Operation not permitted)
> KVM: injection failed, MSI lost (Operation not permitted)
>

-EPERM?? Interesting... strace(1) may come handy...

$ git grep EPERM kvm/queue arch/x86/kvm/=20
kvm/queue:arch/x86/kvm/x86.c:           ret =3D -KVM_EPERM;
(just this one)

kvm_emulate_hypercall():
...
b3646477d458f arch/x86/kvm/x86.c (Jason Baron                2021-01-14 22:=
27:56 -0500  8433)   if (static_call(kvm_x86_get_cpl)(vcpu) !=3D 0) {
07708c4af1346 arch/x86/kvm/x86.c (Jan Kiszka                 2009-08-03 18:=
43:28 +0200  8434)           ret =3D -KVM_EPERM;
696ca779a928d arch/x86/kvm/x86.c (Radim Kr=C4=8Dm=C3=A1=C5=99              =
 2018-05-24 17:50:56 +0200  8435)           goto out;
07708c4af1346 arch/x86/kvm/x86.c (Jan Kiszka                 2009-08-03 18:=
43:28 +0200  8436)   }
...

Doesn't seem we have any updates here, curious what your bisection will
point us to.

--=20
Vitaly

