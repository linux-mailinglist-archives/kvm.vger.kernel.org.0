Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8470C79892
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 22:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbfG2UIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 16:08:43 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33053 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730283AbfG2UId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 16:08:33 -0400
Received: by mail-wm1-f65.google.com with SMTP id h19so43764203wme.0
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2019 13:08:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6rsC8apArHKEVoNHEE6WG1aGK7OUBEY0mfmbG+EETjA=;
        b=RAk37K+cf/qWsWBFTDkqJhAeee0TSUXI+fxkkOKq+IW8/zts8GGpHLmKW0oBA+xarR
         ZWz3SSQbJrZuyEzOQ5TiyDCE123fYLmDhMmB6X1dlOq8/+v67rkI2uPDo/EmC1x2Ux98
         CJpoOaR1jo1OfC0DweQJYBEI1CMKMDQkLZgnjGOy60a6lUhM98uJwaMWMBcmHlHtBzaj
         ZgaGxuAr+QtHbz1CYvaT3UwR8opPVTcl0JKHy/6dJ+bBhP8EypWr28xq3hVb0B6XlNgX
         xnqGE+vG8A1EnnGZLm/lt3NmIelCpJZkKiyEl+PG92Ec6+FkyTMbEOL2v/k0d+TOvCTi
         1RJQ==
X-Gm-Message-State: APjAAAU6uEYM7vMt0ilfP1cEzOZDX1SGUt4fcDyGzGp2BeoURqXAP02o
        jiTrBp74cXnpRduVzxwcSwJMUw==
X-Google-Smtp-Source: APXvYqxyEEo5XtUOjp1CdVRP84iqaQNMR2dGcZMgh/1fmCKwlmEs/P5oV9wEcoLLXuWQbjicsjgaWQ==
X-Received: by 2002:a1c:d10c:: with SMTP id i12mr101100699wmg.152.1564430911427;
        Mon, 29 Jul 2019 13:08:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29d3:6123:6d5f:2c04? ([2001:b07:6468:f312:29d3:6123:6d5f:2c04])
        by smtp.gmail.com with ESMTPSA id j33sm131236463wre.42.2019.07.29.13.08.30
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 13:08:30 -0700 (PDT)
Subject: Re: [RFC PATCH 15/16] RISC-V: KVM: Add SBI v0.1 support
To:     Atish Patra <Atish.Patra@wdc.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "palmer@sifive.com" <palmer@sifive.com>,
        Anup Patel <Anup.Patel@wdc.com>
Cc:     "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190729115544.17895-1-anup.patel@wdc.com>
 <20190729115544.17895-16-anup.patel@wdc.com>
 <b461c82f-960a-306e-b76b-f2c329cabf21@redhat.com>
 <0e19ff14a51e210af91c4b0f2e649b8f5e140ce1.camel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b6c884cc-e156-d125-b3a2-c8a843de34c2@redhat.com>
Date:   Mon, 29 Jul 2019 22:08:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0e19ff14a51e210af91c4b0f2e649b8f5e140ce1.camel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/19 21:51, Atish Patra wrote:
> On Mon, 2019-07-29 at 21:40 +0200, Paolo Bonzini wrote:
>> On 29/07/19 13:57, Anup Patel wrote:
>>> +	csr_write(CSR_HSTATUS, vcpu->arch.guest_context.hstatus |
>>> HSTATUS_SPRV);
>>> +	csr_write(CSR_SSTATUS, vcpu->arch.guest_context.sstatus);
>>> +	val = *addr;
>>
>> What happens if this load faults?
>>
> 
> It should redirect the trap back to VS mode. Currently, it is not
> implemented. It is on the TO-DO list for future iteration of the
> series.

Ok, please add TODO comments for the more important tasks like this one
(and/or post a somewhat complete list in reply to 00/16).

Thanks!

Paolo

