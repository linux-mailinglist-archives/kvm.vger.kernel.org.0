Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42377FE575
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 20:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfKOTPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 14:15:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35007 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726075AbfKOTPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 14:15:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573845342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=zU5bYctc1qUH26YtSFniAvtxlDs+0f34tnCeObLNTZg=;
        b=hn9iASWWxTgbSIRM08F+fL7BYSZTddPRrnNdMHe65RpxIZsgPqiCDwhD/4FdIr8PzMg0W3
        9KQXCgmqHrTcbzW35l6o76eKSR7cW5ca3oMqRmoUbjygP94JfZLp1uRqJvFHjLXAztZiBq
        EVHvD14DoIfovwxVQYJM0YmLYJgBMME=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-1GvkSH8yNeOnjCc8G2m15A-1; Fri, 15 Nov 2019 14:15:41 -0500
Received: by mail-wr1-f71.google.com with SMTP id m17so8333347wrb.20
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 11:15:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i/uZmcWM/QR1RIgZlInxV18JT+HKf4HC+GWixFMuLSk=;
        b=hw14ICzsJ7/LulMwC15yp5lW8ksz/PlZ5VAU65IgxWhnXO64QkA8GKIQsO31lO14Ta
         fBVVqpqEnJGVkmsuBZel5IMI+4m9lTy3aO7K6c5i5wB0/6omlqTO7OXSWuUsd3/8QqpE
         6lp7gyQPp6BIf/OsPPv50NcNkN15alYPtziOqVL5IA2vE94WHMn9IgWKl6xtVEKawgUQ
         L/tvkt3SR7me5/4RBNH3XbiS4e3XNVb+o29ApLmA2FWTe5ij2DpQq507GwUhTMN/J049
         ++9A1UJPPUYCFxluys4JL5KgQz94ZgWTO2PZXQVCLpUATjJzZ3+KYYK0NlAqjCiRYDCR
         RBiA==
X-Gm-Message-State: APjAAAUQVMJ98VJn79IEtO3BCpSpDj9LmYaLhRrO0QOYj33mLN7IgcQG
        T07HWrm5m1zrfED7vfN/3GJZEeYvOFu3JsVfxRBQFWMhHwLBhC0XdYGhZocowesXWskr9lVr7B/
        JhChtgEcJgAbj
X-Received: by 2002:a05:600c:2248:: with SMTP id a8mr16767460wmm.139.1573845339574;
        Fri, 15 Nov 2019 11:15:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqyX3BZytaceFvNysZGVC+W6mCC7UcTKjLNyZDXeDIArGh/IIosJYD3uQkAiOndjhFxQFgg3CA==
X-Received: by 2002:a05:600c:2248:: with SMTP id a8mr16767421wmm.139.1573845339168;
        Fri, 15 Nov 2019 11:15:39 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id b15sm12135049wrx.77.2019.11.15.11.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 11:15:38 -0800 (PST)
Subject: Re: KVM_GET_SUPPORTED_CPUID
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
References: <CALMp9eQ3NcXOJ9MDMBhm2Fi2cvMW7X5GxVgDw97zS=H5vOMvgw@mail.gmail.com>
 <a5845d60-fe38-afc6-e433-4c5a12813026@redhat.com>
 <CALMp9eRdWCbN689WrB2WKG3N3_vqpYa6G+1CB+kUbO_sig026w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <aedec687-ca9c-5468-baf4-343202965489@redhat.com>
Date:   Fri, 15 Nov 2019 20:15:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRdWCbN689WrB2WKG3N3_vqpYa6G+1CB+kUbO_sig026w@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: 1GvkSH8yNeOnjCc8G2m15A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/11/19 19:33, Jim Mattson wrote:
> On Fri, Nov 15, 2019 at 3:42 AM Paolo Bonzini <pbonzini@redhat.com> wrote=
:
>>
>> On 14/11/19 21:09, Jim Mattson wrote:
>>> Can someone explain this ioctl to me? The more I look at it, the less
>>> sense it makes to me.
>>
>> It certainly has some historical baggage in it, much like
>> KVM_GET_MSR_INDEX_LIST.  But (unlike KVM_GET_MSR_INDEX_LIST) it's mostly
>> okay; the issues you report boil down to one of:
>>
>> 1) KVM_GET_SUPPORTED_CPUID being a system ioctl
>>
>> 2) supporting the simple case of taking the output of
>> KVM_GET_SUPPORTED_CPUID and passing it to KVM_SET_CPUID2
>=20
> For this purpose, wouldn't 'DEFAULT' make a lot more sense than
> 'SUPPORTED' in the name of this ioctl?

I'm not sure, this only applies to some relatively unimportant leaves,
such as cache topology or vendor/model name.  So *in general* SUPPORTED
is accurate for leaves that userspace will want to look at in the output
of KVM_GET_SUPPORTED_CPUID.

DEFAULT would imply that it's what you get if you skip KVM_SET_CPUID2.
However, this is not the case.

>> 3) CPUID information being poorly designed, or just Intel doing
>> undesirable things
>>
>>> Let's start with leaf 0. If I see 0xd in EAX, does that indicate the
>>> *maximum* supported value in EAX?
>>
>> This is easy, you can always supply a subset of the values to the guest,
>=20
> Maybe you can reduce CPUID.0H:EAX, but there are some integer values
> that you can't reduce (e.g. CPUID.(EAX=3D0Dh,ECX=3D0):ECX). So, I'd argue
> that this isn't "easy."

True, "easy" referred to leaf 0 only.  Other leaves may have nasty
interdependencies.  The values of EBX and ECX depend on the ECX>1
subleaves, and EAX (as well as the presence of those subleaves)
generally depends on feature bits from other CPUID leaves.  However, all
this is dependent only on processor features and not on KVM's
implementation.  You can still reduce them if you pay enough attention.
 For example you can reduce CPUID(0Dh,0).ECX as long as you hide some
bits from CPUID(0Dh,0).EDX:EAX.

The only thing you need to know about the KVM implementation, is that it
takes into account CPUID(0Dh,0).EDX:EAX and CPUID(0Dh,1).EDX:ECX to
decide whether to raise an exception on XSETBV or WRMSR(IA32_XSS)
respectively.  So to some extent this is also a documentation issue.

[Aside: fixing leaf 0Dh was my first serious KVM patch. :)]

>>> What about leaf 7 EBX? If a bit is clear, does that mean setting the
>>> bit is unsupported? If a bit is set, does that mean clearing the bit
>>> is unsupported? Do those answers still apply for bits 6 and 13, where
>>> a '1' indicates the absence of a feature?
>>
>> Again, clearing bits is always supported in theory, but I say "in
>> theory" because of course bits 6 and 13 are indeed problematic. And
>> unfortunately the only solutions for those is to stick your head in the
>> sand and pretend they don't exist.  If bits 6 and 13 were handled
>> strictly, people would not be able to migrate VMs between e.g. Haswell
>> and Ivy Bridge machines within the same fleet, which is something people
>> want to do.  So, this is (3).
>=20
> For these two bits, one could argue that *setting* them is always
> supported, at least insofar as *clearing* the normal polarity bits is
> supported.

True, they just have reversed polarity.  The issues are that you might
have old VMs started even before the bits were defined, or before you
added support for the bits in your stack.  Setting them might cause
problems in userspace if they were written to know about CPUID(7,0).EBX
but not about the reversed polarity of these bits (this may not apply
exactly to these two bits---I don't know if they were part of the first
batch of features documented for leaf 7---but the same situation may
arise in the future).  At least CPUID(0Ah).EBX is better in this
respect, because you know it exists and what it is going to be used in
the future.  They are just defined backwards.

Of course as you point out those x87 CPUID bits are useless anyway
because nobody checks them.

> If you say that FCS and FDS are "deprecated [sic]" on your
> Ivy Bridge platform, but software relies on it, then that software is
> just as ill-behaved as software that depends on any other feature that
> has been masked off. (Of course, none of the software that actually
> depends on this feature actually checks the CPUID bit, since the CPUID
> bit was defined after-the-fact.) So, even if you're strict about it,
> you can migrate between Haswell and Ivy Bridge. [...]

>> With KVM_ENABLE_CAP, the only one that is _absent_ from
>> KVM_GET_SUPPORTED_CPUID the MONITOR bit.
>=20
> And leaf 5?

Hmm I thought all zeroes would be fine.  What does "(default is
processor's monitor granularity)" mean for EAX and EBX?

Paolo

