Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67CC2C5B42
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 19:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404595AbgKZR74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 12:59:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404587AbgKZR7z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Nov 2020 12:59:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606413594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BupbTkuyTH72z7AhxoGJU5Vwvl1ffLYSQY5ogUJ5LtU=;
        b=O6jeGbZGWp5va7GSPYXDgzXfmxam5D2om+VALjYHaEKiBX5O5/fTt+MpWJ8QLx/vPIFXu8
        1249GWhqbQOX8DRFUonmUhT4iTiU44wixaM6TLCIxZjxtwPIRKeE/8J75S4OqgxUQuyG0a
        v3Ppc+BoGjhDnzGwMI8lpPZktiVPv9A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-2h6cZdZFMLC6WEKWiY_97A-1; Thu, 26 Nov 2020 12:59:52 -0500
X-MC-Unique: 2h6cZdZFMLC6WEKWiY_97A-1
Received: by mail-wm1-f71.google.com with SMTP id g125so1536386wme.9
        for <kvm@vger.kernel.org>; Thu, 26 Nov 2020 09:59:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BupbTkuyTH72z7AhxoGJU5Vwvl1ffLYSQY5ogUJ5LtU=;
        b=o9orqFxF2ACqcAOo4lMS2PGbbNIc9iJc+bh9BIWHHF20bJX+o9bAs6LmnUnUwLjmh2
         oWQw2MKgqZdOp9ftNZzit4TP188M7FxuGKFbuiyP7aiAjc3c1RZmBNRHoB8Ur4kIJB2g
         HYMhV6WXZpD1epwQizRdjuLwURDVeOzyaavfLNVTKVRkks4bMbz9DPHJrl3z1qXcAubs
         E+Alte7ndy71WVvUboVcg5BUYDDUqQzu8SrPQjQnc+5Uc1CkYYuAvJx+m1kSMZpE3MC2
         osvvLn9ajB3M7d38Byntl5gHZpABtZ9UYf+/nifB9dJfNg+wt2ra/cECapXwHWmvVp7q
         KWEQ==
X-Gm-Message-State: AOAM533LP/60GNR6HI4e3+5+MSG7sy0h1MX7EkasceJzJtzisU3yUBIt
        H22mB2/dD4IVAfimdS6pb8fI6Jm/oYuofjFOJohIlkyqyi3rcPr0feaX7YPVhXjaffCkq6+Bufu
        C+3yAuXb3nEaO
X-Received: by 2002:adf:dd52:: with SMTP id u18mr5147577wrm.44.1606413591629;
        Thu, 26 Nov 2020 09:59:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJydtNq1AzHuzhclNXBGzJt+ulc4VByy6Zk8pZRnBEvxpHStWe9W6FpuCejPftN4U4yXqMTbsQ==
X-Received: by 2002:adf:dd52:: with SMTP id u18mr5147556wrm.44.1606413591442;
        Thu, 26 Nov 2020 09:59:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id g186sm11176094wma.1.2020.11.26.09.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2020 09:59:50 -0800 (PST)
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm <kvm@vger.kernel.org>, "Sironi, Filippo" <sironi@amazon.de>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Matt Gingell <gingell@google.com>,
        Steve Rutherford <srutherford@google.com>, liran@amazon.com
References: <62918f65ec78f8990278a6a0db0567968fa23e49.camel@infradead.org>
 <017de9019136b5d2ec34132b96b9f0273c21d6f1.camel@infradead.org>
 <20201125211955.GA450871@google.com>
 <99a9c1dfbb21744e5081d924291d3b09ab055813.camel@infradead.org>
 <95c0c9a01ea9692b3b18ac677d7e7c6e7636bfe4.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH] Fix split-irqchip vs interrupt injection window
 request.
Message-ID: <26940473-6bd0-fc2b-f9bd-35a6a502baff@redhat.com>
Date:   Thu, 26 Nov 2020 18:59:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <95c0c9a01ea9692b3b18ac677d7e7c6e7636bfe4.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/11/20 18:29, David Woodhouse wrote:
> On Thu, 2020-11-26 at 11:10 +0000, David Woodhouse wrote:
>>
>>> whether or not there's an IRQ in the
>>> LAPIC should be irrelevant when deciding to exit to userspace.  Note, the
>>> reinjection check covers vcpu->arch.interrupt.injected for the case where LAPIC
>>> is in userspace.
>>>
>>>          return kvm_arch_interrupt_allowed(vcpu) &&
>>>                 (!lapic_in_kernel(vcpu) || !kvm_cpu_has_extint(vcpu)) &&
>>>                 !kvm_event_needs_reinjection(vcpu) &&
>>>                 kvm_cpu_accept_dm_intr(vcpu);
>>> }
>>
>> Makes sense. I'm putting this version through some testing and will
>> post it later...
> 
> Hm, that survived enough test iterations to persuade me to post it, but
> then seems to have fallen over later. I'm reverting to the
> kvm_cpu_has_injectable_intr() version to leave that one running too and
> be sure it's gone in that.

!kvm_cpu_has_injectable_intr(vcpu) boils down (assuming no nested virt) to

         if (!lapic_in_kernel(v))
                 return !v->arch.interrupt.injected;

         if (kvm_cpu_has_extint(v))
                 return 0;

         return 1;

and Sean's proposal instead is the same indeed (the first "if" doesn't 
matter), so there may be more than one bug.

But it turns out that with some more inlining and Boolean algebra, we 
can actually figure out what the code does. :)  I had just finished 
writing a looong review of your patch starting from that idea, so I'll 
post it.

Paolo

