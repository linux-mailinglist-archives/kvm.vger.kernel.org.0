Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CC62C8679
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 15:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbgK3OQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 09:16:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52286 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727394AbgK3OQt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 09:16:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606745722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jy2WUd8qluzxUHyAVJZ0iTyH/i+egdeldCJel1aWn4Y=;
        b=WbAR6USDMq9gX/HOqyaDX292Tv+pu1r1G6swvjne+R51VqAEqV3H7lENqpleH2j2S8d6wD
        AS7uFgViUVFBxxp8bRDVEqzanBuiBst5n2mqfZAnNYCfeLlKFc8apeVspZpFAX5QJUkHoi
        MbdwUWv4cx555HFf9NKPL68KJ3UEa0k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-sDU7WYnGMMKNDQCmZmYkLg-1; Mon, 30 Nov 2020 09:15:17 -0500
X-MC-Unique: sDU7WYnGMMKNDQCmZmYkLg-1
Received: by mail-wm1-f70.google.com with SMTP id n18so1103470wmk.0
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 06:15:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jy2WUd8qluzxUHyAVJZ0iTyH/i+egdeldCJel1aWn4Y=;
        b=M7biJe00ZEOJaXGM+SWet0S3ZLmKKqqlDL08SHk8y6QGjZpY8ue73G6V3+Mkp/H++k
         oGhH6/7rLhZijgpKnuHmvkCCIBt195jarG9oMYSjWxQIYQoqhPg7XwjckoSm3XqVrQG7
         OWpHRVI7aBBFpuHQrYJIxdn+WfT1UKfo5EwZq/xqlRsgmPoSdXCujv4wwWYcBnJTku9z
         c60ZQ1F4TsZ++Om0d0wn1rtb1GAtiJu9MLOz4Wd8me62Cw6grWFwgDO+4RZIcmbDpIeX
         DAg+z0QcucTUtEbZobOKRMy7Go6UbBhAxAJ37BNKTABuAcqLwdi87ETnmOd/vC0o1eJl
         p1zw==
X-Gm-Message-State: AOAM531lMZiMR3LWoU7+UVh2Yxx/jOXBsTqGrWbAiAv2DSvXPkhalrFR
        aXKgATh6DzQcVSNzlxSSfDmSXHJS/CI9eU725EWA/q+QeSOEXc6xps6XFK8M3qbHzIA+Q9ODOeN
        7V2+eLreNLOns
X-Received: by 2002:a1c:e142:: with SMTP id y63mr10768997wmg.28.1606745716252;
        Mon, 30 Nov 2020 06:15:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy4NO6q15SbHWukyBJ8MRyRFWENoejaNPVjxMUi4v5OO3B+V6ojxrsSeiVtMWCnB1wM/pytUg==
X-Received: by 2002:a1c:e142:: with SMTP id y63mr10768795wmg.28.1606745713286;
        Mon, 30 Nov 2020 06:15:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s2sm24357624wmh.37.2020.11.30.06.15.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 06:15:12 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: x86: introduce KVM_X86_QUIRK_TSC_HOST_ACCESS
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Oliver Upton <oupton@google.com>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        open list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20201130133559.233242-1-mlevitsk@redhat.com>
 <20201130133559.233242-3-mlevitsk@redhat.com>
 <c093973e-c8da-4d09-11f2-61cc0918f55f@redhat.com>
 <638a2919cf7c11c55108776beecafdd8e2da2995.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5e77e912-893b-0c8f-a9a6-b43eaee24ed3@redhat.com>
Date:   Mon, 30 Nov 2020 15:15:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <638a2919cf7c11c55108776beecafdd8e2da2995.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/11/20 15:11, Maxim Levitsky wrote:
> On Mon, 2020-11-30 at 14:54 +0100, Paolo Bonzini wrote:
>> On 30/11/20 14:35, Maxim Levitsky wrote:
>>> This quirk reflects the fact that we currently treat MSR_IA32_TSC
>>> and MSR_TSC_ADJUST access by the host (e.g qemu) in a way that is different
>>> compared to an access from the guest.
>>>
>>> For host's MSR_IA32_TSC read we currently always return L1 TSC value, and for
>>> host's write we do the tsc synchronization.
>>>
>>> For host's MSR_TSC_ADJUST write, we don't make the tsc 'jump' as we should
>>> for this msr.
>>>
>>> When the hypervisor uses the new TSC GET/SET state ioctls, all of this is no
>>> longer needed, thus leave this enabled only with a quirk
>>> which the hypervisor can disable.
>>>
>>> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>>> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>>
>> This needs to be covered by a variant of the existing selftests testcase
>> (running the same guest code, but different host code of course).
> Do you think that the test should go to the kernel's kvm unit tests,
> or to kvm-unit-tests project?

The latter already has x86_64/tsc_msrs_test.c (which I created in 
preparation for this exact change :)).

Paolo

