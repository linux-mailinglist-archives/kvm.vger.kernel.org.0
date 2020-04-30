Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A1C1BF706
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 13:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgD3LnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 07:43:20 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34196 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726511AbgD3LnU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 07:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588246998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=01ghgmgORZJIZqqxFNV1EG+OflwkdPLMWHhmL4P1sPU=;
        b=FdXrECkeMVmJXhQLstYe7xHOSfqcLgrqHm8J3qUkyS+PFOPWZBfScV7ChXDFf6MoN3Vlp3
        twQGbGwOHygDlc5dh6SfkUKe5Njmd/beHEijnmqtXKPrRv6r0KO8yTnaj+swbcAOvScF1K
        CaF+Q/IO0vrbfdUbgdMv8I/OQfK57eI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-SVWPY8iqN1Oj67MFkp-kyw-1; Thu, 30 Apr 2020 07:43:17 -0400
X-MC-Unique: SVWPY8iqN1Oj67MFkp-kyw-1
Received: by mail-wm1-f70.google.com with SMTP id n127so474596wme.4
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 04:43:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=01ghgmgORZJIZqqxFNV1EG+OflwkdPLMWHhmL4P1sPU=;
        b=mIGdQjHE1fM3Jkv7dOSytG0HD1BlmsRgkNkg/rxMPFCS9ispv6Ci1gp9I9R8HM1v52
         2N1LE4yvIzLH4c3Nuy9EvbmzDUQn+tt8+DpFcnMw2KKVhy7gZ/EAeXF1QQG9re+5HqgB
         iLyHib2kvM0nuD75hcFcg3VRhd7C8KZKfQXUlJ9dOY/b+BgNCvdXAgQbATZZ2cNHyxRE
         lHCVlOmg1DZk+BIUqwYiysl+eid1llbVRnuh1lqYnUsoiCi7CZFGi3e7gCvlTDivWvD1
         AhEkouDaRrH9rWLCK1C4QtfLHKFRwzD+vZP+JwBl142rgmWoTMxZ7RckFaVAZSkIDqn4
         mnYQ==
X-Gm-Message-State: AGi0PuaxUX9VzutDeernWtfcXQdxDFeTUComdpHpAiW/rhNXmDjEL72t
        swu2p9y1SYg2UHeap1XmqA1c+0rE0oheQdLxEgyLQQ+p4E1uMhBRImULC+7ykrBJfEkXKaG9TZH
        33q/CYG5YR9YZ
X-Received: by 2002:adf:f604:: with SMTP id t4mr3492989wrp.399.1588246995848;
        Thu, 30 Apr 2020 04:43:15 -0700 (PDT)
X-Google-Smtp-Source: APiQypICjmRb9Tq+KJtCaNKbRBGX7wvpOe2201Kcc13c42lW2P7T/Z37mLHNY3t+WUJDZtj7WdZ7uw==
X-Received: by 2002:adf:f604:: with SMTP id t4mr3492963wrp.399.1588246995544;
        Thu, 30 Apr 2020 04:43:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac19:d1fb:3f5f:d54f? ([2001:b07:6468:f312:ac19:d1fb:3f5f:d54f])
        by smtp.gmail.com with ESMTPSA id c1sm3732638wrc.4.2020.04.30.04.43.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 04:43:15 -0700 (PDT)
Subject: Re: [PATCH RFC 4/6] KVM: x86: acknowledgment mechanism for async pf
 page ready notifications
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-5-vkuznets@redhat.com>
 <b1297936-cf69-227b-d758-c3f3ca09ae5d@redhat.com>
 <87sgglfjt9.fsf@vitty.brq.redhat.com>
 <18b66e2e-9256-0ef0-4783-f89211eeda88@redhat.com>
 <87k11xfbsh.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0ff17250-1943-837a-734d-73a8b4a97ae2@redhat.com>
Date:   Thu, 30 Apr 2020 13:43:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87k11xfbsh.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/20 13:33, Vitaly Kuznetsov wrote:
>> I would expect that it needs to keep it in a global variable anyway, but
>> yes this is a good point.  You can also keep the ACK MSR and store the
>> pending bit in the other MSR, kind of like you have separate ISR and EOI
>> registers in the LAPIC.
>>
> Honestly I was inspired by Hyper-V's HV_X64_MSR_EOM MSR as the protocol
> we're trying to come up with here is very similar to HV messaging)

Oh, that's true actually.

> I'm not exactly sure why we need the pending bit after we drop #PF. When
> we call kvm_check_async_pf_completion() from MSR_KVM_ASYNC_PF_ACK write
> it will (in case there are page ready events in the queue) check if the
> slot is empty, put one there and raise IRQ regardless of guest's current
> state. It may or may not get injected immediately but we don't care.> The second invocation of kvm_check_async_pf_completion() from vcpu_run()
> will just go away.

You're right, you can just use the value in the guest to see if the
guest is ready.  This is also similar to how #VE handles re-entrancy,
however because this is an interrupt we have IF to delay the IRQ until
after the interrupt handler has finished.

By dropping the #PF page ready case, we can also drop the ugly case
where WRMSR injects a page ready page fault even if IF=0.  That one is
safe on Linux, but Andy didn't like it.

Paolo

