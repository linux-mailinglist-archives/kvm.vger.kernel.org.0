Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC196C2B2D
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 02:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731281AbfJAADq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 20:03:46 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:38005 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbfJAADq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 20:03:46 -0400
Received: by mail-wr1-f42.google.com with SMTP id w12so13253000wro.5
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 17:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FRreZpk5IcrTan35C6l/wggcu5wACu3BgZUvbSSZMHI=;
        b=KBfrWeNv4wXTX3GkSVtJKdFhE4o8IuXNg8V7gl+58PZVncU8z/Qyh/RTMj6rrxp42U
         AvZ9ndOpakwD+kL7nfwns1yX0wzv23PF6hrCCazJHO/r2OE2b7bamlF5ui7LB5va6z8Y
         Ah+H+c7P/JmmqCx6jDRxRgh1eIqymqsglLNSaClxv1eG7tMhcz6qV/tKWHvfnc/C55En
         dKxmylJMs24xUYHW8BkAUPc4llA5ECH5U2ORVaznBWYLAtQ4IwBr8TlujsEtCoczUnpo
         EayUq5iWlOTK51a/8p6kkOxouHA4p/46tk1sFz2mNV2KzStKSq58ksjt6bMOSCr/CmDT
         YLEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FRreZpk5IcrTan35C6l/wggcu5wACu3BgZUvbSSZMHI=;
        b=YZDebjbd1gaBsGIrIlE24KaoihjLGXV7C5pT/+eAxF2NAte3CgKwMly8e3jKQT/37q
         obVlFzAoBl23sd2wdZDIqKYtvrBHSi0qgwJzE3v4MKIjbmpUjxpvYF/mqqmq8ckt60BP
         C/r68Zk3/e890LhVXuiedTi2mMD0adKps+GoyaDFeSPI2x7kxaiMojaunBBhcYdOKyYI
         uYXx7iK+BB7eyhKjAD5F4BPvlE8bOElB3HJHyx97ZdZF+wY3HZO26HhvaUi/vra2uBzI
         a0+zvOwAtt9KdNCvrwVMfpXjzkMiE+6PbhzdiftAut2Pkr6zxccSeZBZmfqd0VUw1g4k
         rr4w==
X-Gm-Message-State: APjAAAWKeRE0cAglM3EUEWHXIRTkHdagOjP2wWm326R+4Ss/6WCaSZLf
        e190K0ZL31YYf+H2KYt4fNH3TxvKo6KPiVI3jD1yBw==
X-Google-Smtp-Source: APXvYqxGR+Vd51U4zdTw6tzB0xn9gF41CuqSjrH70fTqC9xrFQcgGbZnP3q73DaEWrwDwW0MDotwGLlScdIT8nq9Ji0=
X-Received: by 2002:adf:dc4b:: with SMTP id m11mr1245636wrj.269.1569888222927;
 Mon, 30 Sep 2019 17:03:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190925011821.24523-1-marcorr@google.com> <20190925011821.24523-2-marcorr@google.com>
 <91eb40a0-c436-5737-aa8a-c657b7221be2@redhat.com> <20190926143201.GA4738@linux.intel.com>
 <C94E79EE-EACF-40C1-AF7A-69E2A8EFAA35@gmail.com> <CAA03e5FPBdHhVY5AyOd68UkriG=+poWf0PCcsUVBOHW7YPF3VA@mail.gmail.com>
 <DDBD57EF-C9A9-40EE-ACFE-0E3B30C275F9@gmail.com>
In-Reply-To: <DDBD57EF-C9A9-40EE-ACFE-0E3B30C275F9@gmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 30 Sep 2019 17:03:31 -0700
Message-ID: <CAA03e5EZ-e0RemkakTab+CFo=P2kLLaLi0UROpsVtQEVt8p1Bw@mail.gmail.com>
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

> >> Thanks for caring, but it would be better to explicitly skip the test =
if it
> >> is not running on bare-metal. For instance, I missed this thread and n=
eeded
> >> to check why the test fails on bare-metal...
> >>
> >> Besides, it seems that v6 was used and not v7, so the error messages a=
re
> >> strange:
> >>
> >> Test suite: atomic_switch_overflow_msrs_test
> >> FAIL: exit_reason, 18, is 2147483682.
> >> FAIL: exit_qual, 0, is 513.
> >> SUMMARY: 11 tests, 2 unexpected failures
> >>
> >> I also think that printing the exit-reason in hex format would be more
> >> readable.
> >
> > Exit reasons are enumerated in decimal rather than hex in the SDM
> > (volume 3, appendix C).
>
> I know, but when the failed VM entry indication is on, it is just a huge
> mess. Never mind, this is a minor issue.
>
> > To be clear, are you saying you "opted in" to the test on bare metal,
> > and got confused when it failed? Or, are you saying that our patch on
> > unittest.cfg to make the test not run by default didn't work?
>
> I ran it on bare-metal and needed to spend some time to realize that it i=
s
> expected to fail on bare-metal =E2=80=9Cby design=E2=80=9D.

Ack. Maybe we should move tests like this into a *_virt_only.c
counter-part? E.g., we could create a new, opt-in, file,
vmx_tests_virt_only.c for this test. When similar scenarios arise in
the future, this new precedent could be replicated, to make it obvious
which tests are expected to fail on bare metal.
