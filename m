Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D17B1CFC05
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 16:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfJHOJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 10:09:48 -0400
Received: from mail-lf1-f46.google.com ([209.85.167.46]:40316 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfJHOJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 10:09:47 -0400
Received: by mail-lf1-f46.google.com with SMTP id d17so12072746lfa.7
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 07:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0y11M04RiHmfFe5VWz2GRqnj1j2Z9OZp4rgGSwD3+LI=;
        b=mfguu/aCvFib40fILo+/y+AG0Vu3tYWnYLbivNyUWONlzEZe1MOxv3n66E5jaecS2W
         xXXuEQ0BHa0oWPxE22pWXWwWbU/AMioMnX4DRTRmu2Q1euxnOo3hO1Z7+7/mhs0nlAGw
         ktoOTCXdU7H9QRQAhfmJqhdEc82wGi/+t/VvB9T6po8ppaG4sgZGYL2j1qR2Ah8TtD3O
         Fk70pJiryFI8NmM4L6ym9vPS8mtGNheDteCzabl707l8Z9ZNTxDKDTzA5Fy5337pxkXd
         cLHUjYFBqKPrqIl3DZqvXoAWqIoB3OgLp57lhsYfdOVoqvOnWJLYb9EXWqshIa6W3Xgd
         ZwfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0y11M04RiHmfFe5VWz2GRqnj1j2Z9OZp4rgGSwD3+LI=;
        b=C5XjkKnlsBGiOb24Eh/93Yg/nvU0iHyCT3YlDiK5bOPBQpJqOEpvnfgPMGzAAtxz5W
         z+lNEsssDR82gkTwQOJFzF8+VVnCZxzaKZVXQCoveKxt1P2t9oIWwjYDcmSR1+K9nW40
         LTtkM2UGGfGu3I8kZrYou1WW7XOaGHWknYcjVFIbIWjon/aeuxO2DtY1rryS/lRYb0V9
         pF2r4Gs8rqY7bJ/KqLZ10JxhwUNZFoa0o9GEDHMQDHuxYFRHieBTn87yV+MTYc9Zp3LA
         4MRS/rVdJ5suimCZP7MfqGS4LeQgGR0wqS7hOBEPBwDcTlKOBuLT8A9tVsskTz9gKqK+
         PpLg==
X-Gm-Message-State: APjAAAXnilMKOxYr4c8MtFyBq5pznCrscEgKD6r9QqjGZuOFugY+Ei6W
        LJr0VbSTtBJPfyzXqGYlXjYhH0QurTjKLz0YJGw=
X-Google-Smtp-Source: APXvYqzppIPV+Nf+iRL+O3qrTyC0Wyp/Anb4S/3YV6Vy3At5bkChOku1eITWlaG0g2iqumHagJLGnRzNGKv7w/OlXtM=
X-Received: by 2002:ac2:4a89:: with SMTP id l9mr13647704lfp.122.1570543785464;
 Tue, 08 Oct 2019 07:09:45 -0700 (PDT)
MIME-Version: 1.0
References: <E15A5945-440C-4E59-A82A-B22B61769884@gmail.com> <875zkz1lbh.fsf@vitty.brq.redhat.com>
In-Reply-To: <875zkz1lbh.fsf@vitty.brq.redhat.com>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Tue, 8 Oct 2019 16:09:32 +0200
Message-ID: <CA+res+QTrLv7Hr9RcGZDua6JAdaC3tfZXRM4e9+_kbsU72OfdA@mail.gmail.com>
Subject: Re: KVM-unit-tests on AMD
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        cavery@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> =E4=BA=8E2019=E5=B9=B410=E6=9C=888=
=E6=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=882:20=E5=86=99=E9=81=93=EF=BC=
=9A
>
> Nadav Amit <nadav.amit@gmail.com> writes:
>
> > Is kvm-unit-test supposed to pass on AMD machines or AMD VMs?.
> >
>
> It is supposed to but it doesn't :-) Actually, not only kvm-unit-tests
> but the whole SVM would appreciate some love ...
>
> > Clearly, I ask since they do not pass on AMD on bare-metal.
>
> On my AMD EPYC 7401P 24-Core Processor bare metal I get the following
> failures:
>
> FAIL vmware_backdoors (11 tests, 8 unexpected failures)
>
> (Why can't we just check
> /sys/module/kvm/parameters/enable_vmware_backdoor btw???)
>
> FAIL svm (15 tests, 1 unexpected failures)
>
> There is a patch for that:
>
> https://lore.kernel.org/kvm/d3eeb3b5-13d7-34d2-4ce0-fdd534f2bcc3@redhat.c=
om/T/#t
>

> Are you seeing different failures?
>
> --
> Vitaly
On my test machine AMD Opteron(tm) Processor 6386 SE, bare metal:
I got similar result:
vmware_backdoors (11 tests, 8 unexpected failures)
svm (13 tests, 1 unexpected failures), it failed on
FAIL: tsc_adjust
    Latency VMRUN : max: 181451 min: 13150 avg: 13288
    Latency VMEXIT: max: 270048 min: 13455 avg: 13623
