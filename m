Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3EA1BF6E3
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 13:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgD3Ldx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 07:33:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27347 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726053AbgD3Ldx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 07:33:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588246431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nYHjyQZB66u0Ewnyj3ClGluuIthhdPA1Z2vZ3odLsss=;
        b=RxVCouHGijFCONd0sGEZBSVY/EhgRnrOHjsQjL1Q2sprnC3L2j1fNNLmZ6G4DbVv5fTNrD
        cyhOg17+XXBe3nTLxDvSeeqJ85VgXugBr/HS0jMVjX3i56+dW6bXoJUdpHloYvdsarvUaJ
        IzGxAcCcEilYPjY8DzxOGU5rFpk6dto=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-hp7qaPLyPfGfGaV_XOzfYg-1; Thu, 30 Apr 2020 07:33:49 -0400
X-MC-Unique: hp7qaPLyPfGfGaV_XOzfYg-1
Received: by mail-wm1-f69.google.com with SMTP id h6so708302wmi.7
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 04:33:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=nYHjyQZB66u0Ewnyj3ClGluuIthhdPA1Z2vZ3odLsss=;
        b=FaOOpjnu2LlBbnVdFiRXaxDFTBK6uPd4H+dK9KW/HzoowS3guRFNJn+OCXY5Lczd+b
         HFi5sQGcbAAAZ6bhNMkWXr2KEbrB6jl5YbtMk6omK7sgdHgVPVmPeywsfmi/qzruZCt2
         q/BFMdqF1pSZ8zXPeReRfdSVrt85MbRTZ0iL1XDS2QVhfoh/3nvDNDUqo6x/yFJgNzh9
         LEmZxGdKqYy4SwGe6Kqug6ck8MxQ370LmHtjl3Low70lvYdloutpK1mUXyA6+YQNhlGQ
         AKrfdROTx5QYDs1+e2gXGHFpR7jznq1nNYPOCRfX7nGdwxHu7JGPNy4mRHfvGOD5uwuo
         qZDA==
X-Gm-Message-State: AGi0PuYgBIOVUDD5PI2S3si06528ad6Fi8092uCuQJi7fAsycbaYkw1d
        gxVOSMz0j8/zW/k/WfrCmyh/fafPG31Fn63YFtIticO00FuOVW2IqN3+BeOGu1TFJV5/KKZt55F
        nqCsmJOMB2VmI
X-Received: by 2002:adf:f10c:: with SMTP id r12mr3433686wro.409.1588246428708;
        Thu, 30 Apr 2020 04:33:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypJoZaH2lPDWe0GJpyQePdThFimTFd28mPxMCRnVLbCUn/3Kpq62ADMYononpBhZV+7wN64Dbw==
X-Received: by 2002:adf:f10c:: with SMTP id r12mr3432706wro.409.1588246416469;
        Thu, 30 Apr 2020 04:33:36 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f2sm3762196wro.59.2020.04.30.04.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 04:33:35 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 4/6] KVM: x86: acknowledgment mechanism for async pf page ready notifications
In-Reply-To: <18b66e2e-9256-0ef0-4783-f89211eeda88@redhat.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com> <20200429093634.1514902-5-vkuznets@redhat.com> <b1297936-cf69-227b-d758-c3f3ca09ae5d@redhat.com> <87sgglfjt9.fsf@vitty.brq.redhat.com> <18b66e2e-9256-0ef0-4783-f89211eeda88@redhat.com>
Date:   Thu, 30 Apr 2020 13:33:34 +0200
Message-ID: <87k11xfbsh.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 30/04/20 10:40, Vitaly Kuznetsov wrote:
>>>  I think in that case
>>> kvm_check_async_pf_completion will refuse to make progress.
>>> You need to make this bit stateful (e.g. 1 = async PF in progress, 0 =
>>> not in progress), and check that for page ready notifications instead of
>>> EFLAGS.IF.  
>>> This probably means that;
>>>
>>> - it might be simpler to move it to the vector MSR
>> I didn't want to merge 'ACK' with the vector MSR as it forces the guest
>> to remember the setting. It doesn't matter at all for Linux as we
>> hardcode the interrupt number but I can imaging an OS assigning IRQ
>> numbers dynamically, it'll need to keep record to avoid doing rdmsr.
>
> I would expect that it needs to keep it in a global variable anyway, but
> yes this is a good point.  You can also keep the ACK MSR and store the
> pending bit in the other MSR, kind of like you have separate ISR and EOI
> registers in the LAPIC.
>

Honestly I was inspired by Hyper-V's HV_X64_MSR_EOM MSR as the protocol
we're trying to come up with here is very similar to HV messaging)

I'm not exactly sure why we need the pending bit after we drop #PF. When
we call kvm_check_async_pf_completion() from MSR_KVM_ASYNC_PF_ACK write
it will (in case there are page ready events in the queue) check if the
slot is empty, put one there and raise IRQ regardless of guest's current
state. It may or may not get injected immediately but we don't care.
The second invocation of kvm_check_async_pf_completion() from vcpu_run()
will just go away.

I'm probably just missing something, will think of it again while
working on v1, it seems nobody is against the idea in general. Thanks!

-- 
Vitaly

