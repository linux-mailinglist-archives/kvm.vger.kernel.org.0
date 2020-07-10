Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B698C21BC06
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 19:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgGJRQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 13:16:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29076 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727864AbgGJRQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 13:16:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594401380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VYYAKT69qJC8cXBBjJthRJSXfG2nYGjV6nWSQ+iUBs0=;
        b=C4VnwFxKat56xXuJxAV8yTzw8jAQ8sidEs79WBJTNmFvVDhTdY0tDV6kJzyrx9aPeYOi87
        TVnlz10rxeyUSt86vUzbYe+HNwB8ZQqkNPDS1f6ySSxt6fZsl8IIITq+nBfOnHskfAa1AQ
        fkuaKMn5xsG+GMr6rd7jMy5UR7mEcdg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-pvR2pw7-PLum4euxn9lsyw-1; Fri, 10 Jul 2020 13:16:18 -0400
X-MC-Unique: pvR2pw7-PLum4euxn9lsyw-1
Received: by mail-wm1-f69.google.com with SMTP id w25so9751668wmc.0
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 10:16:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VYYAKT69qJC8cXBBjJthRJSXfG2nYGjV6nWSQ+iUBs0=;
        b=hhswC1L03hLxBNBog62POsAg3ykkHd/bLAeQvoxlXjj5JOCbLSKQ60OOpcvADKk3pU
         1FryJZmhzs7RUe/VKfgmknkyCN4M8mWbpAqrZ+zcYZn39kE8rYMyvRLtSfYSoc9E4RNG
         1lk4PHc13ghVQrnaSJEtRu2pqvVI6po0zp0nzFeybzJ7b+iTluzwg1eK40U7kQ9gnC+u
         TRDdjRjqbk9etSqIANLDsNo51JSiG+nnenJdeg/a++yWpZY1EFzoed5ImdDEwMAPOVZC
         6Ozr3J/67qjhyIO74Au+ps+fTkk5OUCNMid/ZItaXsI65uT/NMZF7P0x6gw2vwsX32pz
         +jZw==
X-Gm-Message-State: AOAM530zCkysadgIT+/40ogzMlZwajMLxSwaPmGCPl6zSytqyuG7C8dM
        YJ+Lg7jXQp1cBReFmpNPYAY+FLSk09xT03BdJmeVUvKMQwU6IfDqL4j/AT1/xkmejENpDzNP/av
        o5seLx6SQZ4eN
X-Received: by 2002:adf:db42:: with SMTP id f2mr68136082wrj.298.1594401377384;
        Fri, 10 Jul 2020 10:16:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXnEfdioHVFKguZS3kZcS8dBW7ubOyBPqnpSZpaWNF4miTy+T6IbMEcoEtCVas5nZXP6TxGw==
X-Received: by 2002:adf:db42:: with SMTP id f2mr68136068wrj.298.1594401377138;
        Fri, 10 Jul 2020 10:16:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id r1sm10847140wrt.73.2020.07.10.10.16.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 10:16:16 -0700 (PDT)
Subject: Re: [PATCH v3 0/9] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Jim Mattson <jmattson@google.com>
Cc:     Mohammed Gamal <mgamal@redhat.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200710154811.418214-1-mgamal@redhat.com>
 <CALMp9eRfZ50iyrED0-LU75VWhHu_kVoB2Qw55VzEFzZ=0QCGow@mail.gmail.com>
 <0c892b1e-6fe6-2aa7-602e-f5fadc54c257@redhat.com>
 <CALMp9eQXHGnXo4ACX2-qYww4XdRODMn-O6CAvhupib67Li9S2w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9e784c62-15ee-63b7-4942-474493bac536@redhat.com>
Date:   Fri, 10 Jul 2020 19:16:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQXHGnXo4ACX2-qYww4XdRODMn-O6CAvhupib67Li9S2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/20 19:13, Jim Mattson wrote:
> On Fri, Jul 10, 2020 at 10:06 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 10/07/20 18:30, Jim Mattson wrote:
>>>>
>>>> This can be problem when having a mixed setup of machines with 5-level page
>>>> tables and machines with 4-level page tables, as live migration can change
>>>> MAXPHYADDR while the guest runs, which can theoretically introduce bugs.
>>>
>>> Huh? Changing MAXPHYADDR while the guest runs should be illegal. Or
>>> have I missed some peculiarity of LA57 that makes MAXPHYADDR a dynamic
>>> CPUID information field?
>>
>> Changing _host_ MAXPHYADDR while the guest runs, such as if you migrate
>> from a host-maxphyaddr==46 to a host-maxphyaddr==52 machine (while
>> keeping guest-maxphyaddr==46).
> 
> Ah, but what does that have to do with LA57?

Intel only has MAXPHYADDR > 46 on LA57 machines (because in general OSes
like to have a physical 1:1 map into the kernel part of the virtual
address space, so having a higher MAXPHYADDR would be of limited use
with 48-bit linear addresses).

In other words, while this issue has existed forever it could be ignored
until IceLake introduced MAXPHYADDR==52 machines.  I'll introduce
something like this in a commit message.

Paolo

