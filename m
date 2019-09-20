Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA4ACB8F16
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 13:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408762AbfITLlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 07:41:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34681 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2406069AbfITLlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 07:41:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1568979663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=ilxWQy8sG6MjlMoqaOOr/MY68ZyzFYgIrBcfczKCdT8=;
        b=FK1T0wjc3VCDjWVmCH3RvhkMWw2/99yFN0IHxLN2shXdNLNXF9RtV/gzaV1pVzdHeTF61g
        Jcm3M+r/MRur8rmXsN+ubcVqNBqD1GJ8RMGlCbrd4TjmkBrSG//6vkgItbvoqdXtf8wm85
        N+K1XFO9CYm4WNnRaEoJOXk3zt84K+4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-u2qgqsZaPW-l27BYjdeXAw-1; Fri, 20 Sep 2019 07:41:01 -0400
Received: by mail-wr1-f69.google.com with SMTP id h6so2183008wrh.6
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 04:41:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DRigndlYcBvd7g46JLvZo+ihMinmxu2VntKh0cTR2Og=;
        b=TPgSVz1J417lyUYSEcPiAc8wlS1A1uc3UNY6DE5uuhQr/PLDVs07EdLa7GdmFa9XHF
         YEm2h2JN9kAK7Hi3ODb6ysYHWzFwn9DFImLR2InP14c7O7TNPagwJx8XzNwNSLPXY48m
         B9z90w3FntGyX8kb92bGVCdSD2gRXg5ZVOvw11fQQwsHi4ECgYOXuRRDNqSr3l38iDyb
         5+8FbWyb5yy1p4DUmq8GzUjv/eB2nS3H70brv7gHBBwmHSxN6oLN8TEkBWvaxcmNhn3c
         zAHB+28RiqAKw5EX9cfgkLwX7uL66JWJfw/lOCrd50qOzGTzwuIUASvZhwyItyiRuKKk
         DSpw==
X-Gm-Message-State: APjAAAUXdXUqj71OLwlCgbxW27hKEaudM/nTUX895xDj+L00FWH+euaZ
        ZZoOUysF4J25c2EjSDB1/EFx6IQoogl6AZZFNBQT1+Euljv9x92M1/LEEUCYWnAwMsMAcvn+n0E
        AwlyVtXx7rwQf
X-Received: by 2002:adf:e6c4:: with SMTP id y4mr11013810wrm.238.1568979660146;
        Fri, 20 Sep 2019 04:41:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyJqOwOyySrkIEK/6vDskDk5zBUf53dtdaBrVzAECfqYNn78NxAfeCWNKlJWjGxlV7gMMM5XA==
X-Received: by 2002:adf:e6c4:: with SMTP id y4mr11013800wrm.238.1568979659881;
        Fri, 20 Sep 2019 04:40:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id h63sm2248057wmf.15.2019.09.20.04.40.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Sep 2019 04:40:59 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Add "significant index" flag to a few CPUID
 leaves
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190912165503.190905-1-jmattson@google.com>
 <900bfd96-f9da-0660-4746-6605c0ae06c4@oracle.com>
 <CALMp9eRBqPhcCgNbPLskvwGiV=vAJPx8TxqjOp8NApq8JV5V2Q@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ecf49ff4-e495-e6e7-4181-4a8a63fa2380@redhat.com>
Date:   Fri, 20 Sep 2019 13:40:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRBqPhcCgNbPLskvwGiV=vAJPx8TxqjOp8NApq8JV5V2Q@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: u2qgqsZaPW-l27BYjdeXAw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/09/19 01:05, Jim Mattson wrote:
> On Thu, Sep 12, 2019 at 10:41 AM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>>
>>
>> On 9/12/19 9:55 AM, Jim Mattson wrote:
>>> According to the Intel SDM, volume 2, "CPUID," the index is
>>> significant (or partially significant) for CPUID leaves 0FH, 10H, 12H,
>>> 17H, 18H, and 1FH.
>>>
>>> Add the corresponding flag to these CPUID leaves in do_host_cpuid().
>>>
>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>> Reviewed-by: Peter Shier <pshier@google.com>
>>> Reviewed-by: Steve Rutherford <srutherford@google.com>
>>> Fixes: a87f2d3a6eadab ("KVM: x86: Add Intel CPUID.1F cpuid emulation su=
pport")
>>> ---
>>>   arch/x86/kvm/cpuid.c | 6 ++++++
>>>   1 file changed, 6 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index 22c2720cd948e..e7d25f4364664 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -304,7 +304,13 @@ static void do_host_cpuid(struct kvm_cpuid_entry2 =
*entry, u32 function,
>>>       case 7:
>>>       case 0xb:
>>>       case 0xd:
>>> +     case 0xf:
>>> +     case 0x10:
>>> +     case 0x12:
>>>       case 0x14:
>>> +     case 0x17:
>>> +     case 0x18:
>>> +     case 0x1f:
>>>       case 0x8000001d:
>>>               entry->flags |=3D KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>>>               break;
>>
>>
>> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>=20
>=20
> Ping.
>=20

Queued, thanks.

Paolo

