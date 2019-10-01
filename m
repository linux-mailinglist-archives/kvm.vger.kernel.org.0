Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9993DC2B2E
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 02:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbfJAAIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 20:08:43 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45662 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbfJAAIn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 20:08:43 -0400
Received: by mail-pg1-f196.google.com with SMTP id q7so8300108pgi.12
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 17:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qzNv40NLzWThBXJPgX2nx3MO+ppg/Ys/jFZDszfTqXA=;
        b=tkKfIlJGysNRqommMIawpjXJlSVh44rjC8SBbwWNBQfxCYeINHRWQE1hvkyGC3T8qu
         AWJ/QXf9+47LT8QBOIrpBUjUQgiPw6QQXszQtvt4u4cWsfBEWDi9OCOAW8iymjchWF/s
         9dTGPA3J8EUGkcaAsCMt3y/B8FoqjslcT16LDta3g9YqHjDIuiHH8mo1qdnjvf9IVCt/
         YBk8uC8A6CkhYCfC+oChK/b3Lrlo4BC61M5sQFNgHwOrT5GzhcRLqIAfOIikKOKuPWQC
         FrDDZbgBek933QFJhcmt10PoUDXQaxEjivg2L8QNAo3Kg4eGQL3yB7kTLX7m3eA0C44p
         xz2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qzNv40NLzWThBXJPgX2nx3MO+ppg/Ys/jFZDszfTqXA=;
        b=m87p6cTOU66HnHbcuEl66IsQbo2mGelgDzSjdd8seGEknhaP8hltqmTqKhYlrR4F5i
         yy5sEquDAJnFofoZYqO1AKur00Wm2xg0soUQYpTVg5MaLMuEkBfpM2t3KcAay/OXvSgd
         XX3qKSlDwlhEhK34IrcwSNBq/T/tKvgbRUBpuf+kn2emp9jOUF+9C1UVk4i4XCrvpfys
         I4k1PGBfkQl2hGRZb3bV7w0lN4z+KsRe+a5K2BOZb2xUcxjFnrYR6YTEdExxzaAiP1Wk
         TFpnvBxPYBREBCPmNp60nr9JEjofoSpkKYPyef4lbV8yZSLGsPLe++EKYN+rGpsCxBYh
         aGlA==
X-Gm-Message-State: APjAAAVe7RqaqKTJXpWuSwlRj81qSAOhjlzLmSjBjPl4Hreay0CfKhEM
        wogIl61W1TbX9kcBIhTHQns=
X-Google-Smtp-Source: APXvYqzYK87AfYGUcupUDbTP1u2f4YrQ1MfR6chWOCtWXd6aEMiEUOCIvxDfPM2GSiUpnvE35I/nAw==
X-Received: by 2002:a63:2581:: with SMTP id l123mr20000129pgl.293.1569888522413;
        Mon, 30 Sep 2019 17:08:42 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id s14sm11752001pfe.52.2019.09.30.17.08.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 17:08:41 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH v7 2/2] x86: nvmx: test max atomic switch
 MSRs
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CAA03e5EZ-e0RemkakTab+CFo=P2kLLaLi0UROpsVtQEVt8p1Bw@mail.gmail.com>
Date:   Mon, 30 Sep 2019 17:08:39 -0700
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C8510239-CEDD-496B-A772-12A8A8C03ADD@gmail.com>
References: <20190925011821.24523-1-marcorr@google.com>
 <20190925011821.24523-2-marcorr@google.com>
 <91eb40a0-c436-5737-aa8a-c657b7221be2@redhat.com>
 <20190926143201.GA4738@linux.intel.com>
 <C94E79EE-EACF-40C1-AF7A-69E2A8EFAA35@gmail.com>
 <CAA03e5FPBdHhVY5AyOd68UkriG=+poWf0PCcsUVBOHW7YPF3VA@mail.gmail.com>
 <DDBD57EF-C9A9-40EE-ACFE-0E3B30C275F9@gmail.com>
 <CAA03e5EZ-e0RemkakTab+CFo=P2kLLaLi0UROpsVtQEVt8p1Bw@mail.gmail.com>
To:     Marc Orr <marcorr@google.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Sep 30, 2019, at 5:03 PM, Marc Orr <marcorr@google.com> wrote:
>=20
>>>> Thanks for caring, but it would be better to explicitly skip the =
test if it
>>>> is not running on bare-metal. For instance, I missed this thread =
and needed
>>>> to check why the test fails on bare-metal...
>>>>=20
>>>> Besides, it seems that v6 was used and not v7, so the error =
messages are
>>>> strange:
>>>>=20
>>>> Test suite: atomic_switch_overflow_msrs_test
>>>> FAIL: exit_reason, 18, is 2147483682.
>>>> FAIL: exit_qual, 0, is 513.
>>>> SUMMARY: 11 tests, 2 unexpected failures
>>>>=20
>>>> I also think that printing the exit-reason in hex format would be =
more
>>>> readable.
>>>=20
>>> Exit reasons are enumerated in decimal rather than hex in the SDM
>>> (volume 3, appendix C).
>>=20
>> I know, but when the failed VM entry indication is on, it is just a =
huge
>> mess. Never mind, this is a minor issue.
>>=20
>>> To be clear, are you saying you "opted in" to the test on bare =
metal,
>>> and got confused when it failed? Or, are you saying that our patch =
on
>>> unittest.cfg to make the test not run by default didn't work?
>>=20
>> I ran it on bare-metal and needed to spend some time to realize that =
it is
>> expected to fail on bare-metal =E2=80=9Cby design=E2=80=9D.
>=20
> Ack. Maybe we should move tests like this into a *_virt_only.c
> counter-part? E.g., we could create a new, opt-in, file,
> vmx_tests_virt_only.c for this test. When similar scenarios arise in
> the future, this new precedent could be replicated, to make it obvious
> which tests are expected to fail on bare metal.

Thanks for the willingness, but I don=E2=80=99t know whether any =
intrusive change is
needed at the moment. Even just getting the print-out to have something =
like
=E2=80=9C(KVM-specific)=E2=80=9D comment would be enough, assuming the =
test can easily be
disabled (as is the case with atomic_switch_overflow_msrs_test).

