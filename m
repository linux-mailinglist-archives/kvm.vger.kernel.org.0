Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECBC5896F
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 20:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfF0SDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 14:03:53 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38975 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfF0SDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 14:03:52 -0400
Received: by mail-pg1-f193.google.com with SMTP id 196so1369503pgc.6
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 11:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nFAxrUEgaXiq6tDI3E2dVjIkXZSuyJW+Iee+z9k5Kr4=;
        b=hXUQT2fseosLrNW71gtyHtTpLhOy09GHMJCuA9YzzTh61PamZeMsAUgyacXegxnfBn
         4vw/SqZ1jmisOOGrOFDxAk/d8eeXihYWtXoX+TGa2ys+dGQD4L4P4ZUSB5RGBI8ZiH8y
         3aLeVylVPE4cTmGw1w5rP0odjJAGCaYFVrQ83bBSDkKBNn+SOGcZEXNyQf2Yn46rUiqg
         Kt5QXX+jw1Srvs5KfWHS3x1kUas+SLH7o0/36KzjrR/Sn2BX+KH9D8ff4SHMhRE/UeUX
         lE2mT6Qg/vjpJ8W7BVAiI4wIt4hOtjAWczo3wJzJfHeAwJh95O2iteDbMcbnNo7B7pBg
         fR+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nFAxrUEgaXiq6tDI3E2dVjIkXZSuyJW+Iee+z9k5Kr4=;
        b=NJsXqq0FOJYeMurtrHT5xpKOeq5lr13V7LXzREwJKi82xWk2+be7ky40wim3JUaMAb
         joIee7g8RG5fkCDJ+13krlyXWBXnFAFOtwtPceRHJBjQu6QRy2RNqFte6r57Wp5bfpgG
         awo+w89/EsIawkdINgAhT96+W5NoiQS3lAvrLjdRRO0Xx/JRucH8xH4kEXJgYc+LolMw
         d3fXzwlzjkx+33rrsJJDCY0ZxCxyYpNnXAMUJ2/foAikAqLl+a7PSlGazQqGMVyFyt0h
         o4IF1Ih2S4pvyKJtGW6jNnS5hIanqYl3Lg76r9CjfD0HPViHnL9sal8DmmGhm5Edf2tR
         TIPQ==
X-Gm-Message-State: APjAAAUPqjI+x7uoWBUMSaFPtmKuFqAia9ha/BG4zSBAizcWaAwMMXjz
        gvK0BOQqAcpSbznqQKtoF1U=
X-Google-Smtp-Source: APXvYqxXIelCwlS+d0fPnL5nKpFbMCn8J5T65eCJWBeoIJK1OghSMEe/d0kNFPqMi9z3HLf/R7TOAg==
X-Received: by 2002:a17:90a:21ac:: with SMTP id q41mr7661029pjc.31.1561658631859;
        Thu, 27 Jun 2019 11:03:51 -0700 (PDT)
Received: from [10.33.114.148] ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id h1sm3491979pfo.152.2019.06.27.11.03.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 11:03:51 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH] x86: Remove assumptions on CR4.MCE
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CAA03e5EZTQbX_-_=KKcOaVgMUDS2=MO6CgdnOO8yHt+9v5zK6w@mail.gmail.com>
Date:   Thu, 27 Jun 2019 11:03:50 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <88414639-D2BA-47EF-BF3B-A7B69FEA92E6@gmail.com>
References: <20190625120322.8483-1-nadav.amit@gmail.com>
 <CAA03e5EZTQbX_-_=KKcOaVgMUDS2=MO6CgdnOO8yHt+9v5zK6w@mail.gmail.com>
To:     Marc Orr <marcorr@google.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 26, 2019, at 5:35 PM, Marc Orr <marcorr@google.com> wrote:
>=20
> On Tue, Jun 25, 2019 at 12:25 PM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>> CR4.MCE might be set after boot. Remove the assertion that checks =
that
>> it is clear. Change the test to toggle the bit instead of setting it.
>>=20
>> Cc: Marc Orr <marcorr@google.com>
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> ---
>> x86/vmx_tests.c | 29 +++++++++++++++--------------
>> 1 file changed, 15 insertions(+), 14 deletions(-)
>>=20
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index b50d858..3731757 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -7096,8 +7096,11 @@ static int write_cr4_checking(unsigned long =
val)
>>=20
>> static void vmx_cr_load_test(void)
>> {
>> +       unsigned long cr3, cr4, orig_cr3, orig_cr4;
>>        struct cpuid _cpuid =3D cpuid(1);
>> -       unsigned long cr4 =3D read_cr4(), cr3 =3D read_cr3();
>> +
>> +       orig_cr4 =3D read_cr4();
>> +       orig_cr3 =3D read_cr3();
>>=20
>>        if (!(_cpuid.c & X86_FEATURE_PCID)) {
>>                report_skip("PCID not detected");
>> @@ -7108,12 +7111,11 @@ static void vmx_cr_load_test(void)
>>                return;
>>        }
>>=20
>> -       TEST_ASSERT(!(cr4 & (X86_CR4_PCIDE | X86_CR4_MCE)));
>> -       TEST_ASSERT(!(cr3 & X86_CR3_PCID_MASK));
>> +       TEST_ASSERT(!(orig_cr3 & X86_CR3_PCID_MASK));
>>=20
>>        /* Enable PCID for L1. */
>> -       cr4 |=3D X86_CR4_PCIDE;
>> -       cr3 |=3D 0x1;
>> +       cr4 =3D orig_cr4 | X86_CR4_PCIDE;
>> +       cr3 =3D orig_cr3 | 0x1;
>>        TEST_ASSERT(!write_cr4_checking(cr4));
>>        write_cr3(cr3);
>>=20
>> @@ -7126,17 +7128,16 @@ static void vmx_cr_load_test(void)
>>         * No exception is expected.
>>         *
>>         * NB. KVM loads the last guest write to CR4 into CR4 read
>> -        *     shadow. In order to trigger an exit to KVM, we can set =
a
>> -        *     bit that was zero in the above CR4 write and is owned =
by
>> -        *     KVM. We choose to set CR4.MCE, which shall have no =
side
>> -        *     effect because normally no guest MCE (e.g., as the =
result
>> -        *     of bad memory) would happen during this test.
>> +        *     shadow. In order to trigger an exit to KVM, we can =
toggle a
>> +        *     bit that is owned by KVM. We choose to set CR4.MCE, =
which shall
>=20
> "set ..." doesn't make sense, right? Maybe just delete "We choose to
> ... during this test.".

Will do on v2. Thanks.

