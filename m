Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3033615B0DA
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 20:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgBLTTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 14:19:34 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28192 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728958AbgBLTTb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 14:19:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581535170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ALtsPsHoJJ/yr/NY82gjbpHubR4mBebZy4GAbdTJqzM=;
        b=dYl0w06gTBlDDuT/cwWaN8yaKoSNW/BKDCotNM1A4GQlMXjT5omgzcVMP735cpxaRGILsU
        Mdb7zKn3rGpVoGjSmK2sKAOjyrxAAJD1288G0yem2c01VsW1W8dYHmrOCQblur2wBUbfP+
        I/a7E+7JWVDqkP8q69ykX16/LXIkilw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-szrHIJuVP_6vrbm94hI1Zg-1; Wed, 12 Feb 2020 14:19:29 -0500
X-MC-Unique: szrHIJuVP_6vrbm94hI1Zg-1
Received: by mail-wr1-f72.google.com with SMTP id z15so1246346wrw.0
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 11:19:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ALtsPsHoJJ/yr/NY82gjbpHubR4mBebZy4GAbdTJqzM=;
        b=XW3g8qFZVoUb7tZhE2WlMIddlc/Bd6kVKeCze9QRlFhnHeeB56snJoI7VD1uDWO5w/
         XOj1G0/DB3qfF12adZwuDJWJ1zbJb9O6lGMclUp9IyfzhSRo79GoDwPwVznX4XUHnaar
         irPyEr9qKxZdPbv5EN+w4Y89aw4OorP+t1Ek1GSe0M/aqKqjToicczLptQw2WN9LB7dz
         y1f8ZQCLtXQQ/16gDPtO7vVx/9ct+eQ8bXYFOOYqUF8igM1KQLJuzGokzP2c3mK2ZCBn
         ivrM2Zqe+nca1+iegTEfSf0e/8IXUmfLbzvmJceqjGObzGWxgsD0WUAOo0l0IuPLNG/f
         tavw==
X-Gm-Message-State: APjAAAXya0so9BxQhF16HTfoPXjrcskwfDWgFilobh36nw7WYDfgZjZX
        XFUe1emsvHTHbWX1SHNAfRGT5H9+9nW1HnKjj56gSdGcHeJuQZHdSISlfc5YbhzxQdVzfQkvfhs
        tUVo/kfRfogzc
X-Received: by 2002:a1c:3b09:: with SMTP id i9mr560744wma.31.1581535167689;
        Wed, 12 Feb 2020 11:19:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqyeyaA14PxiDCO4uOSF5JvBIm+xF1sF2jVONkZ/53zgfRVuwKC20eBEA1OtGwEYi/yLlQpFbg==
X-Received: by 2002:a1c:3b09:: with SMTP id i9mr560716wma.31.1581535167364;
        Wed, 12 Feb 2020 11:19:27 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id d204sm1919873wmd.30.2020.02.12.11.19.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 11:19:26 -0800 (PST)
Subject: Re: [GIT PULL] KVM changes for Linux 5.6-rc2
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
References: <20200212164714.7733-1-pbonzini@redhat.com>
 <CAHk-=wh6KEgPz_7TFqSgg3T29SrCBU+h64t=BWyCKwJOrk3RLQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b90a886e-b320-43d3-b2b6-7032aac57abe@redhat.com>
Date:   Wed, 12 Feb 2020 20:19:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAHk-=wh6KEgPz_7TFqSgg3T29SrCBU+h64t=BWyCKwJOrk3RLQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/02/20 19:53, Linus Torvalds wrote:
> It doesn't even compile. Just in the patch itself - so this is not a
> merge issue, I see this:
> 
>           int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
>   ..
>   @@ -1599,6 +1599,40 @@ static int skip_emulated_instruction(struct
> kvm_vcpu *vcpu)
>   ..
>   +static void vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)
>   +       return skip_emulated_instruction(vcpu);
>   ..
>   -       .skip_emulated_instruction = skip_emulated_instruction,
>   +       .skip_emulated_instruction = vmx_skip_emulated_instruction,
> 
> ie note how that vmx_skip_emulated_instruction() is a void function,
> and then you have
> 
>          return skip_emulated_instruction(vcpu);
> 
> in it, and you assign that garbage to ".skip_emulated_instruction"
> which is supposed to be returning 'int'.

Indeed I missed the warning.  Of course the return value is in %rax so,
despite the patch being shitty (it is), it is also true that it
*happens* to pass the corresponding unit test.

Not a particularly high bar to clear I admit, but enough to explain the
mistake and ensure it doesn't happen again; I have now added "ccflags-y
+= -Werror" to the KVM makefile.

> So this clearly never even got a _whiff_ of build-testing.

Oh come on.

> You're now on my shit-list, which means that I want to see only (a)
> pure fixes and (b) well-tested such. Nothing else will be pulled.

Fair enough, I removed the following patches from the pull request and
will resend:

 KVM: nVMX: Emulate MTF when performing instruction emulation
 KVM: nVMX: Rename nested_ept_get_cr3() to nested_ept_get_eptp()
 KVM: nVMX: Rename EPTP validity helper and associated variables
 KVM: nVMX: Drop unnecessary check on ept caps for execute-only
 KVM: Provide kvm_flush_remote_tlbs_common()
 KVM: MIPS: Drop flush_shadow_memslot() callback
 KVM: MIPS: Replace all the kvm_flush_remote_tlbs() references
 KVM: MIPS: Define arch-specific kvm_flush_remote_tlbs()

The first one is a bug fix, but since it's the one that caused all the
mess I guess it's not really a good idea to argue about it.

Paolo

