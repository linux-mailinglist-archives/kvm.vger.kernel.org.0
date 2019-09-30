Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5440C2B1F
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 01:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731281AbfI3X6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 19:58:16 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44554 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfI3X6Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 19:58:16 -0400
Received: by mail-pf1-f194.google.com with SMTP id q21so6539190pfn.11
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 16:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=rvvfzjhpLezHj4YJd8Bny1mkIllooV3Nbdt88gocYTc=;
        b=uR+pZprdrcUDF4TNKl2VnbAT8H80vppC/25ECEy69PLShSrT6oJ3UnnA2GO9rh4OJy
         8gycvtM5LsvIhbTr3ebv97Egb3CQ7jb2bBlznLfZs5KzDa1CoJDl84munSEYlC3Nb4bT
         YUaRgGXaUmKzddt/qc4IIPki4AG75duIg9H2R7uwDHonAptLpkYN26YrqG/F11KZ5Rs9
         oFJ09EWzpXngS7xs6pu11pzwVi3KwLD4fIwMAjKyQLVWyBVXmIqeYG4U2z0GOO9zi/i3
         LefrA5v/A3+sgW8ovVSbKWAzRLkAF+ugH12ocHfC+6ENKe/z25weeHsMMWG+rqhYUix1
         OKYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=rvvfzjhpLezHj4YJd8Bny1mkIllooV3Nbdt88gocYTc=;
        b=SiXtWCPBR5qkJQ9M1Tn1s/I7gc3n2TODy1io0cKhAEkuN0LYjP5QMfAMOuR4/cFgRK
         naSw9a6PpwBLD3ZmsYPycwGkMYRFFctJ8Kmaa8XxfeCM6Dq1aaU3veKjmy6rcB0cNqv5
         sIBYi8fjwvd/w12mgQ+nHdTyywgQyj1nWGCz9LQYMpwX9cxQwI/Kuyaf8K8pZy7cikrI
         Uc3SPglFXSCgRlU8FhEYilKLZXq21kuIQjexuLA3e2WnJYOmJqAU/MPhrwO6btK6d2PQ
         mmQO3HkF6bod+kHf6WjNFxm0NQU3mstE4lcWdfcXP/onzNtKuF7dVB2pyYCI1Alnu2Q7
         bz1g==
X-Gm-Message-State: APjAAAVJeCV/dptEa9qFzAIdIii8f/6oisIsf+boJinqaacPbIuHRAcY
        +p25YTsJ5bbSeJHjC/vWa1A=
X-Google-Smtp-Source: APXvYqyzZHESnlcfUQaCpqSbIn0dieGI7gr4ALy7ORjZLIsJ44atcTeOseyDUBK3ur6+dJbbuRCg9g==
X-Received: by 2002:a17:90a:e50b:: with SMTP id t11mr2104135pjy.50.1569887895051;
        Mon, 30 Sep 2019 16:58:15 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id c8sm13668884pgw.37.2019.09.30.16.58.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 16:58:14 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH v7 2/2] x86: nvmx: test max atomic switch
 MSRs
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CAA03e5FPBdHhVY5AyOd68UkriG=+poWf0PCcsUVBOHW7YPF3VA@mail.gmail.com>
Date:   Mon, 30 Sep 2019 16:58:12 -0700
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DDBD57EF-C9A9-40EE-ACFE-0E3B30C275F9@gmail.com>
References: <20190925011821.24523-1-marcorr@google.com>
 <20190925011821.24523-2-marcorr@google.com>
 <91eb40a0-c436-5737-aa8a-c657b7221be2@redhat.com>
 <20190926143201.GA4738@linux.intel.com>
 <C94E79EE-EACF-40C1-AF7A-69E2A8EFAA35@gmail.com>
 <CAA03e5FPBdHhVY5AyOd68UkriG=+poWf0PCcsUVBOHW7YPF3VA@mail.gmail.com>
To:     Marc Orr <marcorr@google.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Sep 30, 2019, at 4:34 PM, Marc Orr <marcorr@google.com> wrote:
>=20
>> Thanks for caring, but it would be better to explicitly skip the test =
if it
>> is not running on bare-metal. For instance, I missed this thread and =
needed
>> to check why the test fails on bare-metal...
>>=20
>> Besides, it seems that v6 was used and not v7, so the error messages =
are
>> strange:
>>=20
>> Test suite: atomic_switch_overflow_msrs_test
>> FAIL: exit_reason, 18, is 2147483682.
>> FAIL: exit_qual, 0, is 513.
>> SUMMARY: 11 tests, 2 unexpected failures
>>=20
>> I also think that printing the exit-reason in hex format would be =
more
>> readable.
>=20
> Exit reasons are enumerated in decimal rather than hex in the SDM
> (volume 3, appendix C).

I know, but when the failed VM entry indication is on, it is just a huge
mess. Never mind, this is a minor issue.

> To be clear, are you saying you "opted in" to the test on bare metal,
> and got confused when it failed? Or, are you saying that our patch on
> unittest.cfg to make the test not run by default didn't work?

I ran it on bare-metal and needed to spend some time to realize that it =
is
expected to fail on bare-metal =E2=80=9Cby design=E2=80=9D.

