Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0EFD1B17
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 23:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732066AbfJIVk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 17:40:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54759 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727046AbfJIVk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 17:40:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570657258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=WkEbaPVprh4Acsf+Z35609KMfGiXvWlsJOUAfH34FGc=;
        b=Zk0isjN/U1bfybS/eoexBowqVnBl1qa6hH3ZqEhtmKz+gIDBtl6OKephkKuIDZkIcwPiXU
        ooFDBzI29DQvvj3MLMDob7nZXDxQ7ipmIO48b/6oR8karGW6QEFkd1lQF1OFlXIvuv4wWy
        fjDAKlKdOXyw/L2KDgUIdaZqYxox9oo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-s1bpaoAaMfe3LaJzE1Vsdg-1; Wed, 09 Oct 2019 17:40:56 -0400
Received: by mail-wr1-f72.google.com with SMTP id v17so1691103wru.12
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 14:40:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oQSUHesOt5gIUmxQ8I5L3/IuLF87Zv3d2RRJ1GfhDIY=;
        b=uRydy5MM2dbJlfbe5mVkDvAz9eVIGft72ShZTniXErqGKMmm9Dnlsa7WljTkQ2i3yX
         LnrKyTbTUDjd7xQwu8Yrb2YeLUJXp/VEnqqDmr0onejL5JKpq2vRBesMQKz4+EXcQv8e
         R151Kacr62wf1elrxy+ynnR4jX7DzCZulNOKMJ415zKTVBEfV4rTwxsDUXHAgAKKIJtA
         lFsVqNFwxVsuhnFQFPC0bZK7TtVupEfME8sVJCjgI5ioEwSrGBLBTZ4/Su9VRbcM5mRg
         Ir4Kac8Za8j09j7zucIEmaRQBlYQqmsNgiR/zg8LwNOCBWXAUR/q9bjN/3UJR/FFecYh
         yK5w==
X-Gm-Message-State: APjAAAWzT6hQO1Led+gvy4F2FHUWY5LX7FNZ2s8FkHd5xawqPgMSaWIn
        XnqCAtf7FotcEwlhswcdbswX3zRUEPOPGJ+x7d3eE/Lk7QSA0smKh1NTPJ/Cw37Dxzo0YOpJ2mR
        /bkuEEEL6caxP
X-Received: by 2002:a5d:6592:: with SMTP id q18mr5107014wru.382.1570657254865;
        Wed, 09 Oct 2019 14:40:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwkEHyazs91cPBTMO58HvyOlx0eMIE3WdKx0qyoP4RDzO8Pngel5U6NGIquH7E4sf9Put1UJg==
X-Received: by 2002:a5d:6592:: with SMTP id q18mr5107005wru.382.1570657254594;
        Wed, 09 Oct 2019 14:40:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1032:7ea1:7f8f:1e5? ([2001:b07:6468:f312:1032:7ea1:7f8f:1e5])
        by smtp.gmail.com with ESMTPSA id w125sm7359506wmg.32.2019.10.09.14.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 14:40:54 -0700 (PDT)
Subject: Re: [Patch 3/6] kvm: svm: Add support for XSAVES on AMD
To:     Jim Mattson <jmattson@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm list <kvm@vger.kernel.org>,
        Luwei Kang <luwei.kang@intel.com>
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-3-aaronlewis@google.com>
 <56cf7ca1-d488-fc6e-1c20-b477dd855d84@redhat.com>
 <CALMp9eRNdLdb7zR=wwx2tTc8n-ewCKuhrw9pxXGVQVUBjNpRow@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9335c3c7-e2dd-cb2d-454a-c41143c94b63@redhat.com>
Date:   Wed, 9 Oct 2019 23:40:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRNdLdb7zR=wwx2tTc8n-ewCKuhrw9pxXGVQVUBjNpRow@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: s1bpaoAaMfe3LaJzE1Vsdg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/19 23:29, Jim Mattson wrote:
> On Wed, Oct 9, 2019 at 12:02 AM Paolo Bonzini <pbonzini@redhat.com> wrote=
:
>>
>> On 09/10/19 02:41, Aaron Lewis wrote:
>>> -             /*
>>> -              * The only supported bit as of Skylake is bit 8, but
>>> -              * it is not supported on KVM.
>>> -              */
>>> -             if (data !=3D 0)
>>> -                     return 1;
>>
>> This comment is actually not true anymore; Intel supports PT (bit 8) on
>> Cascade Lake, so it could be changed to something like
>>
>>         /*
>>          * We do support PT (bit 8) if kvm_x86_ops->pt_supported(), but
>>          * guests will have to configure it using WRMSR rather than
>>          * XSAVES.
>>          */
>>
>> Paolo
>=20
> Isn't it necessary for the host to set IA32_XSS to a superset of the
> guest IA32_XSS for proper host-level context-switching?

Yes, this is why we cannot allow the guest to set bit 8.  But the
comment is obsolete:

1) of course Skylake is not the newest model

2) processor tracing was not supported at all when the comment was
written; but on CascadeLake, guest PT is now supported---just not the
processor tracing XSAVES component.

Paolo

> arch/x86/kernel/fpu/xstate.c has this comment:
>=20
>  * Note that we do not currently set any bits on IA32_XSS so
>  * 'XCR0 | IA32_XSS =3D=3D XCR0' for now.
>=20

