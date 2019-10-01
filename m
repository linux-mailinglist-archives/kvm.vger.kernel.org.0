Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 288B4C2B32
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 02:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbfJAAMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 20:12:31 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38196 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfJAAMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 20:12:30 -0400
Received: by mail-wm1-f68.google.com with SMTP id 3so1228690wmi.3
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 17:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BsVXr/c6Em/TnCoCs6uQh7SFQa0YrnCXi+0sEFA1DkQ=;
        b=XzNYZrXWMmdI1V8cCAOrskUnHR5AH7GmuN20xNLnxe556oh4eF6ssdst8PvkSb3EyC
         OJSTzgJTnz9ZkzLPxyrKUWMFaNSvApTnyzkS6I0s3KcCmtopu79KiDmUKcsOCDau5wfn
         NUS6su/Ki32c9qExBhDcOlw9BqoGgbULKGysW2fl1skwkN4f/XvgFmWRnT7JvnRhv5Gn
         FGY921pmk/vq1OhCOiPmqYVqMytW9Hl5wmGeT58vjpwa6Ukp5zEU7pN8bYgPeS0PRq10
         iCbUInFpJuyv4/XlnYCuq5Ajm6UNng49Z4mTyRa45v5GmyVTXyVRHQfJEUjPRcB0WxVV
         F9UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BsVXr/c6Em/TnCoCs6uQh7SFQa0YrnCXi+0sEFA1DkQ=;
        b=tcfkfJ85AM/ik8q8fqw+5EXH8s41pbCXA1Wpu4IAREW+TitFPKtnxiBrsp0oxeYfVR
         WNXnXS7cAaYOf3DVMm57kRrIfphGUyNuu4EBrBdBlY336WNwLsHKj/JH50TaYQZv1S9F
         bC03tuKSY4PA2zDLlRhaag+XJbhbIwmoYf0iqEwTGU00pm6/iL6uNP8JbB73AF9w0p/t
         +Sy2sz2/7sXJr5z2sRN7VI+x+Zb2bw/BxJFX3YWGcxhbsyfBG222lYRn6LmmSTjoTFLG
         EftSYVk0m1RkLkrPDUz6muFf0SoyNj9/bsreU82yM8KcyK536j7FPj3lyzQRhtVaas60
         fdBA==
X-Gm-Message-State: APjAAAXkW/ksQjEGKBO+89u7/UANquWAYvUEX9TGJ/TPr34hFEtYguB8
        pCMfztnOQ0mUOMzGhnpN1xyrnfPvIZeAixa2G2b45w==
X-Google-Smtp-Source: APXvYqxxTGGN/vnv7+f3IqayvnRHqBUrxjeru2xyCV3cEWmDbsZgg4vwlQrL0Qr6BDkGlgkxOk7SqL16eN3MPWsm+pI=
X-Received: by 2002:a7b:c40c:: with SMTP id k12mr1320917wmi.151.1569888748609;
 Mon, 30 Sep 2019 17:12:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190925011821.24523-1-marcorr@google.com> <20190925011821.24523-2-marcorr@google.com>
 <91eb40a0-c436-5737-aa8a-c657b7221be2@redhat.com> <20190926143201.GA4738@linux.intel.com>
 <C94E79EE-EACF-40C1-AF7A-69E2A8EFAA35@gmail.com> <CAA03e5FPBdHhVY5AyOd68UkriG=+poWf0PCcsUVBOHW7YPF3VA@mail.gmail.com>
 <DDBD57EF-C9A9-40EE-ACFE-0E3B30C275F9@gmail.com> <CAA03e5EZ-e0RemkakTab+CFo=P2kLLaLi0UROpsVtQEVt8p1Bw@mail.gmail.com>
 <C8510239-CEDD-496B-A772-12A8A8C03ADD@gmail.com>
In-Reply-To: <C8510239-CEDD-496B-A772-12A8A8C03ADD@gmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 30 Sep 2019 17:12:16 -0700
Message-ID: <CAA03e5F6WRN8UdUHxCFen3YkPbNQTQFQtMVkC_rexuPTNry0Ug@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v7 2/2] x86: nvmx: test max atomic switch MSRs
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> >>>> Thanks for caring, but it would be better to explicitly skip the tes=
t if it
> >>>> is not running on bare-metal. For instance, I missed this thread and=
 needed
> >>>> to check why the test fails on bare-metal...
> >>>>
> >>>> Besides, it seems that v6 was used and not v7, so the error messages=
 are
> >>>> strange:
> >>>>
> >>>> Test suite: atomic_switch_overflow_msrs_test
> >>>> FAIL: exit_reason, 18, is 2147483682.
> >>>> FAIL: exit_qual, 0, is 513.
> >>>> SUMMARY: 11 tests, 2 unexpected failures
> >>>>
> >>>> I also think that printing the exit-reason in hex format would be mo=
re
> >>>> readable.
> >>>
> >>> Exit reasons are enumerated in decimal rather than hex in the SDM
> >>> (volume 3, appendix C).
> >>
> >> I know, but when the failed VM entry indication is on, it is just a hu=
ge
> >> mess. Never mind, this is a minor issue.
> >>
> >>> To be clear, are you saying you "opted in" to the test on bare metal,
> >>> and got confused when it failed? Or, are you saying that our patch on
> >>> unittest.cfg to make the test not run by default didn't work?
> >>
> >> I ran it on bare-metal and needed to spend some time to realize that i=
t is
> >> expected to fail on bare-metal =E2=80=9Cby design=E2=80=9D.
> >
> > Ack. Maybe we should move tests like this into a *_virt_only.c
> > counter-part? E.g., we could create a new, opt-in, file,
> > vmx_tests_virt_only.c for this test. When similar scenarios arise in
> > the future, this new precedent could be replicated, to make it obvious
> > which tests are expected to fail on bare metal.
>
> Thanks for the willingness, but I don=E2=80=99t know whether any intrusiv=
e change is
> needed at the moment. Even just getting the print-out to have something l=
ike
> =E2=80=9C(KVM-specific)=E2=80=9D comment would be enough, assuming the te=
st can easily be
> disabled (as is the case with atomic_switch_overflow_msrs_test).

"(as is the case with atomic_switch_overflow_msrs_test)" --> now I'm
confused. Are you saying that the first test,
atomic_switch_max_msrs_test() failed on bare metal? That test is
expected to pass on bare metal. However, I did not test it on bare
metal.
