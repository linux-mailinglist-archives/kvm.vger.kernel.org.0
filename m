Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A192937F8
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 11:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405110AbgJTJ1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 05:27:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34202 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391502AbgJTJ13 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Oct 2020 05:27:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603186048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DnylEQH4n9hWhzK7f59LBMUXW92Rw5bQiSSzPC/Izyo=;
        b=QaviqZ/nfufTurJAV3TUbGO4biRuG1sctCu0f1XQsrDej7g2OYkN4fwBEkMidGAMPxskb3
        ZdHJSVwnDIaO1LpGI84lFvD3Y7C3bKfqjzpIG+hJ+7ks57HM/+aHv1fVZhJiZOBIR8ed49
        NB/ZZ+/MxcXS8PfbvBVP1bXmMo/gOzc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-qxuVNcTLNym5V_7dUgtSBw-1; Tue, 20 Oct 2020 05:27:26 -0400
X-MC-Unique: qxuVNcTLNym5V_7dUgtSBw-1
Received: by mail-wr1-f70.google.com with SMTP id i1so555636wrb.18
        for <kvm@vger.kernel.org>; Tue, 20 Oct 2020 02:27:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DnylEQH4n9hWhzK7f59LBMUXW92Rw5bQiSSzPC/Izyo=;
        b=StXSedDI4Rj809AVynhFKYJJt3e5OmAm5+G8+uJ17cHrDDQTLHdBHvXCC7QYYZ7rJm
         btMaGKbUOrGAL2Cs33Sk+hwiYCMNS5bBb08A5cH/5f1CSY6Ua2cv7B/Yus9ABUqnu2fe
         SOqIs60PmJbYVveyPn0ENW3F/fXzFI6Bjqgl09SF9WRFB4bndFQrCIQJ0dm2PJjINzSc
         7WiD1A+kKFwrl4mG0xSx8VBtFval04z+wy7iJTGf95ICy+PXNERaVbOM1y19s8zRgWYt
         eCIfuYN+Pa/3g1a92nMYCztT88gEkGKZ4p4vJ7c5vIqbZAA7eX0kec3E1E0nKY0S2CFr
         j2Fg==
X-Gm-Message-State: AOAM530Eb5F/XfxiGfWFqN0NXIbL7H8HR1Rnla02qIGTa0xosFRxqdTf
        RMBdig4DsvZnN1htDqqGmUxaOjPX1/FNWVR5gTtrhNAyVPJyt3rTILwXN6ucmMgningjG+brnmA
        h7BvMBot7RtSR
X-Received: by 2002:adf:94e6:: with SMTP id 93mr2347101wrr.190.1603186045434;
        Tue, 20 Oct 2020 02:27:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7Jek1YX/2KobyuunbxE84LzHkzOOCSXGHiJqUqHye0XVMpFbBGt8U+0/+U/omHpcLazDFPw==
X-Received: by 2002:adf:94e6:: with SMTP id 93mr2347074wrr.190.1603186045198;
        Tue, 20 Oct 2020 02:27:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t6sm2180005wre.30.2020.10.20.02.27.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 02:27:24 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Forbid userspace MSR filters for x2APIC
To:     "Graf (AWS), Alexander" <graf@amazon.de>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20201019170519.1855564-1-pbonzini@redhat.com>
 <618E2129-7AB5-4F0D-A6C9-E782937FE935@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c9dd6726-2783-2dfd-14d1-5cec6f69f051@redhat.com>
Date:   Tue, 20 Oct 2020 11:27:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <618E2129-7AB5-4F0D-A6C9-E782937FE935@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/20 19:45, Graf (AWS), Alexander wrote:
>> +        * In principle it would be possible to trap x2apic ranges
>> +        * if !lapic_in_kernel.  This however would be complicated
>> +        * because KVM_X86_SET_MSR_FILTER can be called before
>> +        * KVM_CREATE_IRQCHIP or KVM_ENABLE_CAP.
>> +        */
>> +       for (i = 0; i < ARRAY_SIZE(filter.ranges); i++)
>> +               if (range_overlaps_x2apic(&filter.ranges[i]))
>> +                       return -EINVAL;
>
> What if the default action of the filter is to "deny"? Then only an
> MSR filter to allow access to x2apic MSRs would make the full
> filtering logic adhere to the constraints, no?

Right; or more precisely, that is handled by Sean's patch that he had
posted earlier.  This patch only makes it impossible to set up such a
filter.

(That said, this is a quick patch that I posted yesterday just before
dinner.  I'll send out the real deal with docs fixes and better commit
message).

Paolo

> Also, this really deserves a comment in the API documentation :).
> 
> In fact, I think a pure comment in documentation is enough. Just make
> x2apic && filter on them "undefined behavior".

