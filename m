Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDF6D14AA68
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 20:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgA0TYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 14:24:43 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:33837 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgA0TYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 14:24:43 -0500
Received: by mail-io1-f66.google.com with SMTP id z193so11366151iof.1
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2020 11:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uB+J4evyaWZrRvHnSyLT/vTzWpPj7y0Jq/TgrcGiI/U=;
        b=SPXkgU6cSqhFxwQdtXLsZYIyK1HcTfWob+/KY5RQkAsn888aVer90gzCJO0DIZ+KUk
         kj1hxM75xzxGYdk5AsabfuQVlz1LHrXfikRKTqtVzRJL3f0fs9WX3qlqNhEfKxPY1Xwa
         fkvJZio8icwUbPbHbeZvp+42CHn0rPNKWoneasL4W/MLAS9ETSadBP/3QhGoROZbh0WN
         eczGYnZSA/EeutskF7meVZwxITefIH7qjUBmcho8ATDY2A8vrreIgQycLWEDCR0wV3Z8
         KYoj22fIHyE9964oOm0umi6Ks+Ci2ZZKTVxUASYq/oB1BJEMn8Q4brQeFWDm3/qS6fGz
         w6zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uB+J4evyaWZrRvHnSyLT/vTzWpPj7y0Jq/TgrcGiI/U=;
        b=k/K+D0nDe6Ng64X1fM60e8xN0qp9lTkgC8M6I5HJtMH6fMc+Jt8r3uRvJa6/zCYYhM
         kHrD5U2l5LmijMLc12Svz46Y18fL5MC8TzRhCV2JPFpa+VrI2zd4RsqmHxhTqpcdmwjN
         UpGS2PbKkoFKV8B+AYj4wlY6VfzV9sHf++0TPCfkIcamt5MefZlb/HafQa//scpAREg/
         ZvIVN+fg4MhriCWLg86CNrLakvHF0+DaFB1RY9/na8J3uscAtv9cPwFmJVqPziyad7lM
         1CotKXmQBYhddayu2k885+tE8VsLFzzMUtbv7sSxyEvhBA2H482mSQ2UrD98SWVzzudy
         3UYA==
X-Gm-Message-State: APjAAAVqA0QNU90+imjLH6NUhOj930KVT9IMkaLDkv0we0za62uF2UTR
        r8jeDB2yxTZaudri24C5wknTCj3IBRu1WoAXyz+K+Q==
X-Google-Smtp-Source: APXvYqzHN2Cdw7WYZ4N+JPy+QJ0/Sn09wAJtwsAwzZ+T/seOkbhECjFTujithTTPQjlrdkZbG8e06STe+m6aSHEWhEs=
X-Received: by 2002:a5d:8cda:: with SMTP id k26mr14061933iot.26.1580153082117;
 Mon, 27 Jan 2020 11:24:42 -0800 (PST)
MIME-Version: 1.0
References: <20191202204356.250357-1-aaronlewis@google.com>
 <4EFDEFF2-D1CD-4AF3-9EF8-5F160A4D93CD@gmail.com> <20200124233835.GT2109@linux.intel.com>
 <1A882E15-4F22-463E-AD03-460FA9251489@gmail.com> <CALMp9eTXVhCA=-t1S-bVn-5ZVyh7UkR2Kqe26b8c5gfxW11F+Q@mail.gmail.com>
 <436117EB-5017-4FF0-A89B-16B206951804@gmail.com>
In-Reply-To: <436117EB-5017-4FF0-A89B-16B206951804@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 27 Jan 2020 11:24:31 -0800
Message-ID: <CALMp9eQYS3W5_PB8wP36UBBGHRHSoJmBDUEJ95AUcXYQ1sC9mQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3] x86: Add RDTSC test
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 26, 2020 at 8:36 PM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Jan 26, 2020, at 2:06 PM, Jim Mattson <jmattson@google.com> wrote:
> >
> > If I had to guess, you probably have SMM malware on your host. Remove
> > the malware, and the test should pass.
>
> Well, malware will always be an option, but I doubt this is the case.

Was my innuendo too subtle? I consider any code executing in SMM to be malw=
are.

> Interestingly, in the last few times the failure did not reproduce. Yet,
> thinking about it made me concerned about MTRRs configuration, and that
> perhaps performance is affected by memory marked as UC after boot, since
> kvm-unit-test does not reset MTRRs.
>
> Reading the variable range MTRRs, I do see some ranges marked as UC (most=
 of
> the range 2GB-4GB, if I read the MTRRs correctly):
>
>   MSR 0x200 =3D 0x80000000
>   MSR 0x201 =3D 0x3fff80000800
>   MSR 0x202 =3D 0xff000005
>   MSR 0x203 =3D 0x3fffff000800
>   MSR 0x204 =3D 0x38000000000
>   MSR 0x205 =3D 0x3f8000000800
>
> Do you think we should set the MTRRs somehow in KVM-unit-tests? If yes, c=
an
> you suggest a reasonable configuration?

I would expect MTRR issues to result in repeatable failures. For
instance, if your VMCS ended up in UC memory, that might slow things
down quite a bit. But, I would expect the VMCS to end up at the same
address each time the test is run.

> >
> > On Fri, Jan 24, 2020 at 4:06 PM Nadav Amit <nadav.amit@gmail.com> wrote=
:
> >>> On Jan 24, 2020, at 3:38 PM, Sean Christopherson <sean.j.christophers=
on@intel.com> wrote:
> >>>
> >>> On Fri, Jan 24, 2020 at 03:13:44PM -0800, Nadav Amit wrote:
> >>>>> On Dec 2, 2019, at 12:43 PM, Aaron Lewis <aaronlewis@google.com> wr=
ote:
> >>>>>
> >>>>> Verify that the difference between a guest RDTSC instruction and th=
e
> >>>>> IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12's VM-exit
> >>>>> MSR-store list is less than 750 cycles, 99.9% of the time.
> >>>>>
> >>>>> 662f1d1d1931 ("KVM: nVMX: Add support for capturing highest observa=
ble L2 TSC=E2=80=9D)
> >>>>>
> >>>>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> >>>>> Reviewed-by: Jim Mattson <jmattson@google.com>
> >>>>
> >>>> Running this test on bare-metal I get:
> >>>>
> >>>> Test suite: rdtsc_vmexit_diff_test
> >>>> FAIL: RDTSC to VM-exit delta too high in 117 of 100000 iterations
> >>>>
> >>>> Any idea why? Should I just play with the 750 cycles magic number?
> >>>
> >>> Argh, this reminds me that I have a patch for this test to improve th=
e
> >>> error message to makes things easier to debug.  Give me a few minutes=
 to
> >>> get it sent out, might help a bit.
> >>
> >> Thanks for the quick response. With this patch I get on my bare-metal =
Skylake:
> >>
> >> FAIL: RDTSC to VM-exit delta too high in 100 of 49757 iterations, last=
 =3D 1152
> >> FAIL: Guest didn't run to completion.
> >>
> >> I=E2=80=99ll try to raise the delta and see what happens.
> >>
> >> Sorry for my laziness - it is just that like ~30% of the tests that ar=
e
> >> added fail on bare-metal :(
>
>
