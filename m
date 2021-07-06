Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBE83BDFD3
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 01:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhGFXsh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 19:48:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55002 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229811AbhGFXsg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 19:48:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625615156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yr4WUm89dKDrxc5hIfFE2ijmw1i1ZnrGEAO7zl2utLI=;
        b=OTNFR4iUoQLATfg5RuTaEyWLOCg4UZyxZQBqw4rciN+gBXeBccLpm/aZ3G9mc2avJaZnAi
        G4kt/JOEBcWwdmPnA+VDKj02TTdtXzz5tgSXGNZGitHiSjawG39Cv64op/Nz2GOYze3MVS
        RY1PwQuCaO8APxG1j5gFFHBOKNvHpYI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-y9o5_30WP66DtRArQAlLag-1; Tue, 06 Jul 2021 19:45:55 -0400
X-MC-Unique: y9o5_30WP66DtRArQAlLag-1
Received: by mail-ej1-f70.google.com with SMTP id d2-20020a1709072722b02904c99c7e6ddfso18998ejl.15
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 16:45:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yr4WUm89dKDrxc5hIfFE2ijmw1i1ZnrGEAO7zl2utLI=;
        b=kma5AptDMDdFFegMRQiFQrr8Ng6QW5j2TpFy5Dp3UfG49sHw98llB/cICm5LknsRXm
         bbVba++zKzjuAnSMUE6w4uJvBiDmhfSrAkFuqgB19lZGdeUTle9V4f04K9GAoW14N9uG
         153XyOZ60Q1eL0buk0lSqrpx5rE+0n5PvZL71j8M1Q4gXxgS7Yw2c/+AicvlDFszqTFp
         cZol+BDiRFGVynFLnK2C+J674Al6DDlM9dQ66DH4eKbYQU6kolI9AQNHlAUtO7hWkRYZ
         1HGGxTdQ6IzzakYMK17ecoVaJ9KUsTPXu9FCrWQ0rCH1gkXyU/eejljwcVUz5PekcXkD
         /EHg==
X-Gm-Message-State: AOAM530X0x7FaPZ5GytJnHHuBWt9R9sJyEUNhdEdB8PPGjyLRlZtBPaF
        sqdfQgjCBjuni10ytzcyIqJgk/chINSQxLEJ5ekfbPE5iJqZRDWZnFBO+RXxtAPdABoaTGRR1gw
        zy5E14LxZExu8Z0UrBHHyOEXfJuOm5bWSB3ckaFSpc5zLlqcVqWBnTihr7ZOgEiek
X-Received: by 2002:a17:906:3c14:: with SMTP id h20mr3202738ejg.176.1625615154516;
        Tue, 06 Jul 2021 16:45:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxT6fX8Em3z/9BpjiNPUc52gPe0B8qjJzhD3CpGM2uKMW/hkjcl0ogK2RNMZaDLXGxyo8SKgQ==
X-Received: by 2002:a17:906:3c14:: with SMTP id h20mr3202711ejg.176.1625615154303;
        Tue, 06 Jul 2021 16:45:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id l26sm8049448edt.40.2021.07.06.16.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 16:45:53 -0700 (PDT)
To:     stsp <stsp2@yandex.ru>, Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jan Kiszka <jan.kiszka@siemens.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
References: <20210628124814.1001507-1-stsp2@yandex.ru>
 <32451d4990cad450f6c8269dbd5fa6a59d126221.camel@redhat.com>
 <7969ff6b1406329a5a931c4ae39cb810db3eefcd.camel@redhat.com>
 <7f264d9f-cb59-0d10-d435-b846f9b61333@yandex.ru>
 <71e0308e9e289208b8457306b3cb6d6f23e795f9.camel@redhat.com>
 <20b01f9d-de7a-91a3-e086-ddd4ae27629f@yandex.ru>
 <6c0a0ffe6103272b648dbc3099f0445d5458059b.camel@redhat.com>
 <dc6a64d0-a77e-b85e-6a8e-c5ca3b42dd59@yandex.ru>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: X86: Fix exception untrigger on ret to user
Message-ID: <b1976445-1b88-8a6c-24ee-8a3844db3885@redhat.com>
Date:   Wed, 7 Jul 2021 01:45:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <dc6a64d0-a77e-b85e-6a8e-c5ca3b42dd59@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/21 01:06, stsp wrote:
> What I ask is how SHOULD the
> KVM_SET_REGS and KVM_SET_SREGS
> behave when someone (mistakenly)
> calls them with the exception pending.
> Should they return an error
> instead of canceling exception?

In theory, KVM_SET_REGS and KVM_SET_SREGS should do nothing but set the 
value of the registers.  They not should clear either 
vcpu->arch.exception.pending or vcpu->arch.exception.injected.  I'm wary 
of changing that and breaking users of KVM, though.

In this case the problem is that, with a pending exception, you should 
not inject the interrupt (doesn't matter if it's with KVM_SET_REGS or 
KVM_INTERRUPT).  Raising a page fault is part of executing the previous 
instruction, and interrupts are only recognized at instruction 
boundaries.  Therefore, you need to test ready_for_interrupt_injection, 
and possibly use request_interrupt_window, before calling KVM_SET_REGS.

The patch you identified as the culprit does have a bug, but that's 
fixed in kvm_cpu_accept_dm_intr as I suggested in the other thread.

Paolo

