Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9692EB1B24
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 11:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbfIMJvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 05:51:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59908 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728026AbfIMJvk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 05:51:40 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D9B76796FC
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 09:51:39 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id n11so1042928wmc.8
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 02:51:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YHn+lgx3KH3nZ7vvGzR2tsrfN+sBUuJK+hZ3hDebNeE=;
        b=VMGTt0OGRJlAgNx90VBdnhRlZSQ07eZX1b9tB3xx/Zvi5cjhsG9sUh8j+eD/vy+njq
         wlDlFXwZsMJSvmnDviGBZO+XshyWIj4DCNnYpWgQEIZ27+EPu1gUU259aBNYeExH2VVe
         2X8anFa+E7KmEmS1N+YaimDY4b0H98mgYGl7wk2zRnTpus0n8DYEYhweTKFLME+E6D2x
         JpObEwdYsjzPjVMiL0hhNTpO27tPuaZtvDo68y7y48lIkRFjdtkD/ihKVlMNvRG70PgO
         ClysQTuv8oEtLLfof92RMuTWpENRlTrS4AQGHy9VM8uNGK2JPUHDWmZ2+dSppv24KkAW
         s0Cw==
X-Gm-Message-State: APjAAAV83h9U+vFXEElilWjdZ5nf4nK35OxAAZWQj+I03XB8vaXmlNyt
        yiWS1EiBGNdeSw1/OWw8ANTGrBxnEPkQqtHj64kAo/EM/EJWfX8E/GX7muL671pbGoB+Q5i5IfQ
        +l413pjTgv8zQ
X-Received: by 2002:adf:e485:: with SMTP id i5mr37460756wrm.175.1568368298368;
        Fri, 13 Sep 2019 02:51:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzxoEtYyiIrtD+sRoaOShW6tq+/DZp2oqi7KnZb2EInrwcUyNPzLvE174ZhgAJUiU4wK5xV6w==
X-Received: by 2002:adf:e485:: with SMTP id i5mr37460724wrm.175.1568368298099;
        Fri, 13 Sep 2019 02:51:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c5d2:4bb2:a923:3a9a? ([2001:b07:6468:f312:c5d2:4bb2:a923:3a9a])
        by smtp.gmail.com with ESMTPSA id a15sm1590919wmj.25.2019.09.13.02.51.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Sep 2019 02:51:37 -0700 (PDT)
Subject: Re: [PATCH 0/3] fix emulation error on Windows bootup
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jan Dakinevich <jan.dakinevich@virtuozzo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Denis Lunev <den@virtuozzo.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Denis Plotnikov <dplotnikov@virtuozzo.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1566911210-30059-1-git-send-email-jan.dakinevich@virtuozzo.com>
 <b35c8b24-7531-5a5d-1518-eaf9567359ae@redhat.com>
 <20190911195359.GK1045@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4a4c71d8-c29a-d04c-e7d3-4ea9ec916a29@redhat.com>
Date:   Fri, 13 Sep 2019 11:51:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190911195359.GK1045@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/09/19 21:53, Sean Christopherson wrote:
> On Wed, Sep 11, 2019 at 05:51:05PM +0200, Paolo Bonzini wrote:
>> On 27/08/19 15:07, Jan Dakinevich wrote:
>>> This series intended to fix (again) a bug that was a subject of the 
>>> following change:
>>>
>>>   6ea6e84 ("KVM: x86: inject exceptions produced by x86_decode_insn")
>>>
>>> Suddenly, that fix had a couple mistakes. First, ctxt->have_exception was 
>>> not set if fault happened during instruction decoding. Second, returning 
>>> value of inject_emulated_instruction was used to make the decision to 
>>> reenter guest, but this could happen iff on nested page fault, that is not 
>>> the scope where this bug could occur.
>>>
>>> However, I have still deep doubts about 3rd commit in the series. Could
>>> you please, make me an advise if it is the correct handling of guest page 
>>> fault?
>>>
>>> Jan Dakinevich (3):
>>>   KVM: x86: fix wrong return code
>>>   KVM: x86: set ctxt->have_exception in x86_decode_insn()
>>>   KVM: x86: always stop emulation on page fault
>>>
>>>  arch/x86/kvm/emulate.c | 4 +++-
>>>  arch/x86/kvm/x86.c     | 4 +++-
>>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>>
>>
>> Queued, thanks.  I added the WARN_ON_ONCE that Sean suggested.
> 
> Which version did you queue?  It sounds like you queued v1, which breaks
> VMware backdoor emulation due to incorrect patch ordering.  v3[*] fixes
> the ordering issue and adds the WARN_ON_ONCE.

I applied v1 with all the fixes, then found out v3 existed and replaced
with it (but still added a comment).

Paolo

