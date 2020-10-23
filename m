Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8EF296BFE
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 11:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S461365AbgJWJWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 05:22:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54470 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S461351AbgJWJW3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 05:22:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603444948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zFy8cKDrlOK1vlR1rPZ1yB4Mtk+7r9jVofEsE3/FjNs=;
        b=WZhse79o2PD+XYU6fUFocjqEkzk/uQw7bvpdElUMZ6q+z32yWMQ6p8rBidhzTQ1llKN+bz
        EP2PtnPGzWJfyZal9Arpo5/uML4X0ND01giTtlv1YeZ7S3C8jLAr9Kz5bS7A+3Gb7tlXUH
        9+TKNAwuW33qEK0wnUp8m7kME0qcqAU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-oUk9aMJEOSiTfMEjdeXKXA-1; Fri, 23 Oct 2020 05:22:26 -0400
X-MC-Unique: oUk9aMJEOSiTfMEjdeXKXA-1
Received: by mail-wr1-f71.google.com with SMTP id p6so358820wrm.23
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 02:22:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zFy8cKDrlOK1vlR1rPZ1yB4Mtk+7r9jVofEsE3/FjNs=;
        b=G6fOQPPxbRuu3qM4Tn/2y/6cVCRhGDxD18UjLczfR4GDyKk4UorAkmH96w+w6wuq9O
         LucnpS4EKs0wbTYyk3JNUCLf+ihhLfEzimjBEG+NJwl8wixazcW3RzK4ZgW6aGiqM7Fo
         ktgoeG7/aeD+HbdkEBPxKewSaoZc9WZaoyQ83pmKbhM6SmuYqmTuGWX6sYVS/QJOGcV2
         QJfRUE6+QwyN0MyzkCrpESm5uyiRU+l4KXxqGMGWGSWPuJHNNfSk/hdzUTcWvqH+ctuM
         nALOyyfPZ8VuzcF5l/06L0ke3mbie53vM8h723P6nkQrMNerGTKmzfXNK8NcKmdaV4F0
         HL/w==
X-Gm-Message-State: AOAM530L119knkO7QD/Uxs/Y0louKoeUHkuxhsezAPX1Ei7WPdgmKwXW
        DwgMBdFu/k2hYFhv7mu638Lx9wfei/TL/jXRc8isKiLFhS+uimuE9FQ2xIacO6eUChX8b5J2LKv
        Tr9+R0Z42vWtX
X-Received: by 2002:adf:f4ca:: with SMTP id h10mr1528198wrp.89.1603444944947;
        Fri, 23 Oct 2020 02:22:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3ds5i6Jy9xzhnQs1hXxTjYyriEn+pFklF0XOxau77zxYKeBo36Gsgq5Oa8cvPmD7wkyXiEg==
X-Received: by 2002:adf:f4ca:: with SMTP id h10mr1528179wrp.89.1603444944727;
        Fri, 23 Oct 2020 02:22:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 205sm2081202wme.38.2020.10.23.02.22.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 02:22:24 -0700 (PDT)
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Mohammed Gamal <mgamal@redhat.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200710154811.418214-1-mgamal@redhat.com>
 <20200710154811.418214-8-mgamal@redhat.com>
 <CALMp9eSbY6FjZAXt7ojQrX_SC_Lyg24dTGFZdKZK7fARGA=3hg@mail.gmail.com>
 <CALMp9eTFzQMpsrGhN4uJxyUHMKd5=yFwxLoBy==2BTHwmv_UGQ@mail.gmail.com>
 <20201023031433.GF23681@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 7/9] KVM: VMX: Add guest physical address check in EPT
 violation and misconfig
Message-ID: <498cfe12-f3e4-c4a2-f36b-159ccc10cdc4@redhat.com>
Date:   Fri, 23 Oct 2020 11:22:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201023031433.GF23681@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/20 05:14, Sean Christopherson wrote:
>>>> +
>>>> +       /*
>>>> +        * Check that the GPA doesn't exceed physical memory limits, as that is
>>>> +        * a guest page fault.  We have to emulate the instruction here, because
>>>> +        * if the illegal address is that of a paging structure, then
>>>> +        * EPT_VIOLATION_ACC_WRITE bit is set.  Alternatively, if supported we
>>>> +        * would also use advanced VM-exit information for EPT violations to
>>>> +        * reconstruct the page fault error code.
>>>> +        */
>>>> +       if (unlikely(kvm_mmu_is_illegal_gpa(vcpu, gpa)))
>>>> +               return kvm_emulate_instruction(vcpu, 0);
>>>> +
>>> Is kvm's in-kernel emulator up to the task? What if the instruction in
>>> question is AVX-512, or one of the myriad instructions that the
>>> in-kernel emulator can't handle? Ice Lake must support the advanced
>>> VM-exit information for EPT violations, so that would seem like a
>>> better choice.
>>>
>> Anyone?
>
> Using "advanced info" if it's supported seems like the way to go.  Outright
> requiring it is probably overkill; if userspace wants to risk having to kill a
> (likely broken) guest, so be it.

Yeah, the instruction is expected to page-fault here.  However the
comment is incorrect and advanced information does not help here.

The problem is that page fault error code bits cannot be reconstructed
from bits 0..2 of the EPT violation exit qualification, if bit 8 is
clear in the exit qualification (that is, if the access causing the EPT
violation is to a paging-structure entry).  In that case bits 0..2 refer
to the paging-structure access rather than to the final access.  In fact
advanced information is not available at all for paging-structure access
EPT violations.

Thanks,

Paolo

