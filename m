Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D49414FB7
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 20:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbhIVSSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 14:18:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60158 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237006AbhIVSSj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 14:18:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632334628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X1RNdzwECzWOd3skE6jAuBuPxRlUo2QTTfIOpVKuePE=;
        b=WSPnp3CYXp9BTi/ZepKJI21bN/dyQNIQkgOZ85sjE7g/6PTNXhMQRgMzh4zA7P4deplmHg
        O2qwov0XiM/5K5WpATfoeBsJ9WM7QwFzTneq4tUW3GFxqUSv4lQmd0Wur+KynI4ks4Ju7k
        +AYElgJX629NC1yDCYnGrWZ25ECeTz0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-peEErgsWMP6Yz4s1M4PSdg-1; Wed, 22 Sep 2021 14:17:07 -0400
X-MC-Unique: peEErgsWMP6Yz4s1M4PSdg-1
Received: by mail-ed1-f69.google.com with SMTP id b7-20020a50e787000000b003d59cb1a923so4083767edn.5
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 11:17:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X1RNdzwECzWOd3skE6jAuBuPxRlUo2QTTfIOpVKuePE=;
        b=BOIxX0CxpwLV0xpJjCN3H/6Ex7MylygDMZ3mEW4StARzbsoDAtlkFHS2DKTYNGz3X5
         2dykoyLQujX1zVqQR2593jbnZmsrONeSALJcB4VdfIxtXDyHAk7tFBY15U0u0McvEEuH
         Y6/xiBasa2Zsem/XZcl7JNB5BWEJLtQVLT2tbfjgR5XENgt0UgPrW6go4AJQ4twUhybU
         jmbIAZf/KKsXWsvI2EkJgEOQlsqzs6iREtyPgY3TWLWJhmPDru07hpxpFc393J1AOczc
         lIIhSJ0XZyEeD3c+JiphTTWIXd/lEKFPjzTSbHyPRxe3Z3weOEpIRDb0G/Z2xnHHQddV
         FTWw==
X-Gm-Message-State: AOAM531kqxKpmUNGbsqBIH6CvpitDbFFseqY6wN0/Fpd9UBZRMv83hDq
        i5+BtIa2a7kxlkwO/ZVX9+ZEnoGw5zU/kki4yTzHCGTCeQblyorPRu3KZObWWNx5zfxPUxvgT5p
        uzD3YQ7SDnea5
X-Received: by 2002:a17:906:3854:: with SMTP id w20mr558549ejc.537.1632334626250;
        Wed, 22 Sep 2021 11:17:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy16BuPQRa+6D5Hn397FwBp1Z/87NfPihYAA2nSbTOPhV+4HrB5uje403kIuyAR9tJ2Kna6xw==
X-Received: by 2002:a17:906:3854:: with SMTP id w20mr558525ejc.537.1632334625991;
        Wed, 22 Sep 2021 11:17:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r2sm1555167edo.59.2021.09.22.11.17.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 11:17:05 -0700 (PDT)
Subject: Re: [PATCH v3 0/7] KVM: few more SMM fixes
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>
References: <20210913140954.165665-1-mlevitsk@redhat.com>
 <22916f0c-2e3a-1fd6-905e-5d647c15c45b@redhat.com>
 <YUtBqsiur6uFWh3o@google.com>
 <427038b4-a856-826c-e9f4-01678d33ab83@redhat.com>
 <YUtRSK8SwMfEZ2ca@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a7343926-b0a1-db2a-c78d-fe2f708ce5c0@redhat.com>
Date:   Wed, 22 Sep 2021 20:17:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YUtRSK8SwMfEZ2ca@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/21 17:52, Sean Christopherson wrote:
> On Wed, Sep 22, 2021, Paolo Bonzini wrote:
>> On 22/09/21 16:46, Sean Christopherson wrote:
>>> On Wed, Sep 22, 2021, Paolo Bonzini wrote:
>>>> On 13/09/21 16:09, Maxim Levitsky wrote:
>>>>>      KVM: x86: nVMX: re-evaluate emulation_required on nested VM exit
>>>
>>> ...
>>>> Queued, thanks.  However, I'm keeping patch 1 for 5.16 only.
>>>
>>> I'm pretty sure the above patch is wrong, emulation_required can simply be
>>> cleared on emulated VM-Exit.
>>
>> Are you sure?
> 
> Pretty sure, but not 100% sure :-)
> 
>> I think you can at least set the host segment fields to a data segment that
>> requires emulation.  For example the DPL of the host DS is hardcoded to zero,
>> but the RPL comes from the selector field and the DS selector is not
>> validated.
> 
> HOST_DS_SEL is validated:
> 
>    In the selector field for each of CS, SS, DS, ES, FS, GS and TR, the RPL
>    (bits 1:0) and the TI flag (bit 2) must be 0.

Ah, I think that's a bug in the manual.  In "27.5.2 Loading Host Segment 
and Descriptor-Table Registers" the reference to 26.3.1.2 should be 
26.2.3 ("Checks on Host Segment and Descriptor-Table Registers").  That 
one does cover all segment registers.  Hmm, who do we ask now about 
fixing Intel manuals?

So yeah, a WARN_ON_ONCE might be in order.  But I don't feel super safe 
making it false when it is possible to make KVM do something that is at 
least sensible.

Paolo

>> Therefore a subsequent vmentry could fail the access rights tests of 26.3.1.2
>> Checks on Guest Segment Registers:
> 
> Yes, but this path is loading host state on VM-Exit.
> 
>> DS, ES, FS, GS. The DPL cannot be less than the RPL in the selector field if
>> (1) the “unrestricted guest” VM-execution control is 0; (2) the register is
>> usable; and (3) the Type in the access-rights field is in the range 0 – 11
>> (data segment or non-conforming code segment).
>>
>> Paolo
>>
> 

