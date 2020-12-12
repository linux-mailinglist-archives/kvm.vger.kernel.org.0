Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D472D835A
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 01:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407307AbgLLATQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 19:19:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407299AbgLLASi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 19:18:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607732231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8HnEp95H6Cj/L1NiOjOIURqCHoJCueCAOJ0vn4hPY1s=;
        b=NIlVIQXSZoDubTlTbb8Bdebmibx5gqvYoLZvjk915E3YpIq0B6i1typ5dWKK3XY0ZO7hvz
        5HXNWUzO1Yhf4k6RsqhrXUWiSskdoJRJCvR+oIVYMi4XDOfKJ9q7SCYrjEQQGSOalrH3Zd
        3Noltbxo4UT61cybvF/vlljtP2bvqgs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-RIF5iqdrMsCTmtShR-LlXw-1; Fri, 11 Dec 2020 19:17:10 -0500
X-MC-Unique: RIF5iqdrMsCTmtShR-LlXw-1
Received: by mail-wr1-f72.google.com with SMTP id r8so3930321wro.22
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 16:17:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8HnEp95H6Cj/L1NiOjOIURqCHoJCueCAOJ0vn4hPY1s=;
        b=iBDRxDRQbgi9do+GYBO7LWgUdJk1rr4ZUZ6dyE9RI7RGdYLorOmPYHOBbfA4Xjc8bE
         87NX9ORWGYCi7LmpWMTajn4slXrO/B/CaxOmAQnufHclOG0WdFVcqnjtQBZF2GA+UJWx
         Uv9+F/nj4OTln6QXVbGz2IPhFCMcZGLFb+MZsMO//7+V+PUEGGFxJfjUwU/TRr/dLoDt
         UBLXYprG8q2rs8iwLGywtoO3dWukHApaZColCIgYHQqjH7BGdxieRcxPLvnZVss5ryJo
         l2FrgWU+q+S0vA8w9ZEJPRskkaKn7vGYwX21BY0dQtoxSWDdAwEBCU6s/Wu7NGhNuLKx
         a2fw==
X-Gm-Message-State: AOAM533m0mHwoKJ3qfO6+uHEk2yQRKWGiGqbvtWCG7esYoJh1lfTDI2f
        4NROEQGJFGwCTjhCYDD/n14P7qM65XX/d2w+r9miFrRVe8JTEcvur8e9pyWN6ammWJcSUqKLNa5
        2zIrMvOWr3Qdu
X-Received: by 2002:a1c:6055:: with SMTP id u82mr16542342wmb.61.1607732228498;
        Fri, 11 Dec 2020 16:17:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxafgEV96P5fIG0IcPCdnNpX7bKtZSxTlxYKVtfAr73+YlHMtvxRiiK/CtDyfYDK+az6YaHGw==
X-Received: by 2002:a1c:c2d4:: with SMTP id s203mr16012670wmf.58.1607732227409;
        Fri, 11 Dec 2020 16:17:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z17sm16782340wrh.88.2020.12.11.16.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 16:17:06 -0800 (PST)
To:     Oliver Upton <oupton@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20201006212556.882066-1-oupton@google.com>
 <18085741-6370-bde6-0f28-fa788d5b68e5@redhat.com>
 <CAOQ_QsjABDVuaKJYSxZOMga4JbJkzQFnZPQJkx2F-XVEahtDqQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: add regression test for posted
 interrupts
Message-ID: <ec7287a9-70e0-3e00-eab9-8288669b6e2e@redhat.com>
Date:   Sat, 12 Dec 2020 01:17:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAOQ_QsjABDVuaKJYSxZOMga4JbJkzQFnZPQJkx2F-XVEahtDqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/20 00:41, Oliver Upton wrote:
> On Fri, Dec 11, 2020 at 5:20 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 06/10/20 23:25, Oliver Upton wrote:
>>> If a guest blocks interrupts for the entirety of running in root mode
>>> (RFLAGS.IF=0), a pending interrupt corresponding to the posted-interrupt
>>> vector set in the VMCS should result in an interrupt posting to the vIRR
>>> at VM-entry. However, on KVM this is not the case. The pending interrupt
>>> is not recognized as the posted-interrupt vector and instead results in
>>> an external interrupt VM-exit.
>>>
>>> Add a regression test to exercise this issue.
>>>
>>> Signed-off-by: Oliver Upton <oupton@google.com>
>>
>> I am a bit confused.  Is this testing the KVM or the bare metal
>> behavior?  Or was this fixed in KVM already?
> 
> This is a directed test case for
> 25bb2cf97139 ("KVM: nVMX: Morph notification vector IRQ on nested
> VM-Enter to pending PI")

Ok, thanks.  However, the patch currently fails like this:

	Test suite: vmx_posted_interrupt_test
	VM-Fail on vmlaunch: error number is 7. See Intel 30.4.

I haven't debugged it, so for now I suggest that you just move it to a 
separate suite.

Paolo

