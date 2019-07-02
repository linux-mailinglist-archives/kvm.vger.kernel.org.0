Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAC035D58A
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 19:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfGBRpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 13:45:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36787 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfGBRpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 13:45:44 -0400
Received: by mail-pf1-f196.google.com with SMTP id r7so8628673pfl.3
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 10:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=1hvWk2dmaR3L/ph3+393c1HUZUvwBsMa4MDeML4wjGc=;
        b=Xw1brA/78L/+d12bf3Cd6fiaMDMG/bqfbvUqpGemSc/drQs/pTPu04WPQoMoZlZVSF
         787wlJNhkBqGbGvSh824P0+EcW2ICty5QMiNFnDPUMuGdVGEs/iTYSDp/QJhuw2Xxi6W
         IlyuSTXkAMaefv926WX4v70Um4C0u/T3pQsjV1KcnAG5KeAHiiEA0/9pfI8vJbXVyKtY
         5Vkbh0Cn3lJqd5hCQsIrzHSB2BmQsj1ZW4wroQHR28XwosuIzWGlMOaVeAAp4kP7zgGu
         IozGNUNRvZ36datAw3KDt8w5BbTmqZORMpPNcY7zIyQGaUCPj5P9fHqdkwfWJw9SSfXp
         3DWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=1hvWk2dmaR3L/ph3+393c1HUZUvwBsMa4MDeML4wjGc=;
        b=clTUiLVHUYDB2oS/GEpWquitfG/HulIZqJKsl29xwXgK1w+oaPxDFDS59omlxyEEqB
         UF0CXjle9OVTUeklE3uGePqyKshZ5cA9/NKmCeNOqoT5JdvI/BmoBYT8gKT6oD4gUko7
         C7nHf6UEJBfI3wVoXmBK/7JfYFTVMTbjGDNVrpi1mEHGRPfJsn4Xq+pp7TD9H36bqmSq
         de6dr2OCQB7R825y68pEgX2Y6Aa2tIfLtjotqL2uoWI9o+P5/43Kh7ifhjIrdGBpo2qD
         QG6mSPec1dFgoLexVFvV0JmKxEdtLreIt5s0bB8fpx74svg7nqj1nV4/8mh14aq3Ivr5
         4EEg==
X-Gm-Message-State: APjAAAU0FBRpU2ehSjzJPXYVyTKiud1Pznylz39leRxyg96cJGXIrkSb
        DpjiffegBDRFcUeJBwMUKIo=
X-Google-Smtp-Source: APXvYqwHh/rMVM1hqPLygFBKHyc2sQOqHfPLHl9O9+4IrvhWf8I4jCtSBwFaZeoH2T9i5qEI1tGmEg==
X-Received: by 2002:a63:490a:: with SMTP id w10mr31325421pga.6.1562089543351;
        Tue, 02 Jul 2019 10:45:43 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id f17sm11985654pgv.16.2019.07.02.10.45.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 10:45:42 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Support environments without
 test-devices
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <73f56921-cb61-92fa-018a-5673e721dbef@redhat.com>
Date:   Tue, 2 Jul 2019 10:45:41 -0700
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <39BF29A2-D14B-4AC7-AE19-66EA8C136D98@gmail.com>
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-4-nadav.amit@gmail.com>
 <2e359eb2-4b2a-0a52-6c43-cd6037bb72ae@redhat.com>
 <F3480C92-28D8-470A-9E34-E87ECCE4FDD1@gmail.com>
 <73f56921-cb61-92fa-018a-5673e721dbef@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 2, 2019, at 10:24 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 02/07/19 18:43, Nadav Amit wrote:
>>>> Remember that the output goes to the serial port.
>>>=20
>>> RAM size can use the multiboot info (see lib/x86/setup.c).
>>=20
>> The multiboot info, as provided by the boot-loader is not good enough =
as far
>> as I remember. The info just defines where to kernel can be loaded, =
but does
>> not say how big the memory is. For that, e820 decoding is needed, =
which I
>> was too lazy to do.
>=20
> The multiboot info has both e801 memory size and e820 memory map info.
> e801 is basically the first contiguous chunk of memory below 4GB, it
> should be enough for kvm-unit-tests.

It is not enough for some of the access/ept_access tests, and 1GB page
allocation can fail on certain configurations. But anyhow I didn=E2=80=99t=
 solve
this problem (IIRC the allocator only allocates from addresses that are
below 4GB). So, I can do that (using e801).

>>> For the # of CPUs I'm not sure what you're supposed to do on bare =
metal
>>> though. :)
>>=20
>> I know you are not =E2=80=9Cserious=E2=80=9D, but I=E2=80=99ll use =
this opportunity for a small
>> clarification. You do need to provide the real number of CPUs as =
otherwise
>> things will fail. I do not use cpuid, as my machine, for example has =
two
>> sockets. Decoding the ACPI tables is the right way, but I was too =
lazy to
>> implement it.
>=20
> What about the mptables, too?

If you mean to reuse mptable.c from [1] or [2] - I can give it a shot. I =
am
not about to write my own parser.

[1] https://github.com/kernelslacker/x86info/blob/master/mptable.c
[2] https://people.freebsd.org/~fsmp/SMP/mptable/mptable.c=
