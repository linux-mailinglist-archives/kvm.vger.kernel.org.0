Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B065E42ED63
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 11:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbhJOJTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 05:19:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231273AbhJOJTd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 05:19:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634289447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1KdI1b95Ma9fj82jtMmONBjcr0AQBV2wvVKzB96XPbs=;
        b=fboVt1BfUKE1mQ9xOJgzb/x5lR+arT2gkNTKeYaCnC5Y3b2n8bZTliHlRS7l6lva0+04D5
        /RShCeBVIY89BvRDGZDV13khX7JY/yWrGco4IJCezFKCBR4ELsRIAD1NWqlOuyJzhzZIOp
        XF3T2TXczL472p3+V17g226uCJk1U8Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-BZ0UYVPEPKKUc99E7Kvs2Q-1; Fri, 15 Oct 2021 05:17:26 -0400
X-MC-Unique: BZ0UYVPEPKKUc99E7Kvs2Q-1
Received: by mail-wm1-f72.google.com with SMTP id s26-20020a7bc39a000000b0030d9db6c428so460741wmj.6
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 02:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=1KdI1b95Ma9fj82jtMmONBjcr0AQBV2wvVKzB96XPbs=;
        b=j+rI3yu2Sl7zoPwD8LdukT81z+uZptUm490ZqWZl0ExuFodwxINdb3jJog/3TO7Dob
         jRwusIbo5XM6r/ly8Tk1/8ftl9vi5z2mtHwh9RWd4zNlHaWxActW9LsDB60KM4hCvU79
         AgDpebolYWB7tQsFoAKhfZ1zKWMlEzBB8d02Gx1zq5P6EDV6oG/O1Y/Ayvwsye1iaOwl
         OwZ5sO8Py8quSLEb2hLYYduEO0SF3JuhaiQXa8HZQ/gLSxcepEt83w+qxCIFDbyI8Wpj
         FS/Z73vZ22XF26mL78K2FKe5u2KO04cLpNLvAlv2Om9YVwZKOmX72gxwhrZkSNnnkpKS
         Zd3w==
X-Gm-Message-State: AOAM530g3fL+vCC2jQ4+RFJlRdMDAiyU0h+7UaifRhb0hL3IhPc4MLp1
        nm08J2JExRpPk3hn7oOo1KBArGZ28ZvNDGbbSlRBvMiLr13BFmo6tS5dc8V9mknO3leANmwVgHV
        OjszrO1M5HBAU
X-Received: by 2002:a7b:c386:: with SMTP id s6mr25302229wmj.183.1634289444885;
        Fri, 15 Oct 2021 02:17:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHMWc5BlwaRILOSv4LqsRXCXOvU26NnAoPb3/TeCePM3GlKLRXnpPWiu9jHQLYw72aPn5o9w==
X-Received: by 2002:a7b:c386:: with SMTP id s6mr25302215wmj.183.1634289444691;
        Fri, 15 Oct 2021 02:17:24 -0700 (PDT)
Received: from smtpclient.apple ([2a01:e0a:466:71c0:b1f7:fa09:b694:af37])
        by smtp.gmail.com with ESMTPSA id n12sm4593102wms.27.2021.10.15.02.17.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Oct 2021 02:17:23 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [BUG] [5.15] Compilation error in arch/x86/kvm/mmu/spte.h with
 clang-14
From:   Christophe de Dinechin <cdupontd@redhat.com>
In-Reply-To: <fb1da4d3-9e3e-4604-2f30-30292f9d13aa@redhat.com>
Date:   Fri, 15 Oct 2021 11:17:22 +0200
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Jim Mattson <jmattson@google.com>, torvic9@mailbox.org,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9F0C48F4-A62B-456C-9EBD-DB02026631D1@redhat.com>
References: <1446878298.170497.1633338512925@office.mailbox.org>
 <b6abc5a3-39ea-b463-9df5-f50bdcb16d08@redhat.com>
 <936688112.157288.1633339838738@office.mailbox.org>
 <c4773ecc-053f-9bc6-03af-5039397a4531@redhat.com>
 <CAKwvOd=rrM4fGdGMkD5+kdA49a6K+JcUiR4K2-go=MMt++ukPA@mail.gmail.com>
 <CALMp9eRzadC50n=d=NFm7osVgKr+=UG7r2cWV2nOCfoPN41vvQ@mail.gmail.com>
 <YWht7v/1RuAiHIvC@archlinux-ax161> <YWh3iBoitI9UNmqV@google.com>
 <CAKwvOdkC7ydAWs+nB3cxEOrbb7uEjiyBWg1nOOBtKqaCh3zhBg@mail.gmail.com>
 <fb1da4d3-9e3e-4604-2f30-30292f9d13aa@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 14 Oct 2021, at 22:50, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 14/10/21 21:06, Nick Desaulniers wrote:
>>> If we want to fix this, my vote is for casting to an int and =
updating the comment
>> At the least, I think bitwise operations should only be performed on
>> unsigned types.
>=20
> This is not a bitwise operation, it's a non-short-circuiting boolean =
operation.  I'll apply Jim's suggestion.

What about making it an inline function, which would require evaluation =
of arguments:

	static __always_inline bool BITWISE_BOOLEAN_OR(bool a, bool b)
	{
	    return a || b; // Safe here, because arguments have been =
evaluated
	}

Suggesting that because I'm always nervous about casts in macros hiding =
something that the type  system would otherwise catch.


Christophe
>=20
> Paolo
>=20

