Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB2314BF0D
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 18:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgA1R75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 12:59:57 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:43766 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgA1R75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 12:59:57 -0500
Received: by mail-il1-f196.google.com with SMTP id o13so10845328ilg.10
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2020 09:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NSU7vmLhak1r7gudqkZPk9FBjlT+75EpT7LmQFfKUAQ=;
        b=Ll3WUucWBY4iIeiEzYrjg0GfRoD8UJYsuRUkNwfIzJnh8t20A5l2/IHyb4zZ2/D7pY
         BYBG9ZqbAka2MYh6W4hh5t3Yjh8kVWdfWM0APW90DSO88HtjqmjIBD1UfPIixOhfFAaA
         I9Ur5gm6AC4d1ZNlnIaYhr7X2IWk9NdOVPNyehOpdM0M1ylDV/Ddch54K+clHwlmPJbo
         CgvhmeOOfma935QvOcY3LCYA0J19XztpTqfw1mm0X9NBtzacCews81tZzm/p/PnM2t3+
         LGG+PDojpaAP8Y67y5DjTB3Q3/jh1LUY6AuEpiLmw56dq1dDpyXAYAvzxkYnf5eeRdKd
         ooAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NSU7vmLhak1r7gudqkZPk9FBjlT+75EpT7LmQFfKUAQ=;
        b=MgcnZNUpuk2mBMFU/hXESHpXoMgT4pzpIzDp51iWfH9jaWXn9kM1uHDnmd7wsBLsUv
         n+6zFJwutRRTgtYn2nt7DeFLnWtDWFa4HEkodIox9XUizJsnvTrgCY5BiEBaAxWtEVXZ
         dmgWhAN7hplB8J3rRCFTTJq9Mg/Vxl+RhEBtCSVhO6xGcfby6kIW/7UR0qsJTNn8SsFD
         6tB1vIZFuF41cA1ZifwvH/yq6oG7Vuxdy6v/ia3AoPl8F2Y158Oh1uRHFKH6xyQCAEj9
         oELynU8vv+jEP+8m7AG5KheHkn2N/qUc8CpZout93pLmmQ4LF78iW0hOGm81bK5hj57Y
         N3HQ==
X-Gm-Message-State: APjAAAVinErZU0LLovv8ZKoqKW6hvlN9nskMHqfh6/Oh1pYKzfPvb4UP
        E8z/q1timpbuWcd0Kx5UcopS6XPaPnZuCVEB7M9n01w3
X-Google-Smtp-Source: APXvYqyDkGI8EJ1VC6McjGoAI0IFgythK7OAxCHP1kpYC2xtRh8j1xl9M9NIn8W6foV2pqZgLrj1X4MlhhknBeUbgOQ=
X-Received: by 2002:a92:8141:: with SMTP id e62mr20733283ild.119.1580234396231;
 Tue, 28 Jan 2020 09:59:56 -0800 (PST)
MIME-Version: 1.0
References: <20191202204356.250357-1-aaronlewis@google.com>
 <4EFDEFF2-D1CD-4AF3-9EF8-5F160A4D93CD@gmail.com> <20200124233835.GT2109@linux.intel.com>
 <1A882E15-4F22-463E-AD03-460FA9251489@gmail.com> <CALMp9eTXVhCA=-t1S-bVn-5ZVyh7UkR2Kqe26b8c5gfxW11F+Q@mail.gmail.com>
 <436117EB-5017-4FF0-A89B-16B206951804@gmail.com> <CALMp9eQYS3W5_PB8wP36UBBGHRHSoJmBDUEJ95AUcXYQ1sC9mQ@mail.gmail.com>
 <20200127205606.GC2523@linux.intel.com>
In-Reply-To: <20200127205606.GC2523@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Jan 2020 09:59:45 -0800
Message-ID: <CALMp9eRrE5onJT4HgfCqrxMYYVjaeVMDT4YKVA2mr4jfT7jkaA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3] x86: Add RDTSC test
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 27, 2020 at 12:56 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Jan 27, 2020 at 11:24:31AM -0800, Jim Mattson wrote:
> > On Sun, Jan 26, 2020 at 8:36 PM Nadav Amit <nadav.amit@gmail.com> wrote:
> > >
> > > > On Jan 26, 2020, at 2:06 PM, Jim Mattson <jmattson@google.com> wrote:
> > > >
> > > > If I had to guess, you probably have SMM malware on your host. Remove
> > > > the malware, and the test should pass.
> > >
> > > Well, malware will always be an option, but I doubt this is the case.
> >
> > Was my innuendo too subtle? I consider any code executing in SMM to be malware.
>
> SMI complications seem unlikely.  The straw that broke the camel's back
> was a 1152 cyle delta, presumably the other failing runs had similar deltas.
> I've never benchmarked SMI+RSM, but I highly doubt it comes anywhere close
> to VM-Enter/VM-Exit's super optimized ~400 cycle round trip.  E.g. I
> wouldn't be surprised if just SMI+RSM is over 1500 cycles.

Good point. What generation of hardware are you running on, Nadav?

> > > Interestingly, in the last few times the failure did not reproduce. Yet,
> > > thinking about it made me concerned about MTRRs configuration, and that
> > > perhaps performance is affected by memory marked as UC after boot, since
> > > kvm-unit-test does not reset MTRRs.
> > >
> > > Reading the variable range MTRRs, I do see some ranges marked as UC (most of
> > > the range 2GB-4GB, if I read the MTRRs correctly):
> > >
> > >   MSR 0x200 = 0x80000000
> > >   MSR 0x201 = 0x3fff80000800
> > >   MSR 0x202 = 0xff000005
> > >   MSR 0x203 = 0x3fffff000800
> > >   MSR 0x204 = 0x38000000000
> > >   MSR 0x205 = 0x3f8000000800
> > >
> > > Do you think we should set the MTRRs somehow in KVM-unit-tests? If yes, can
> > > you suggest a reasonable configuration?
> >
> > I would expect MTRR issues to result in repeatable failures. For
> > instance, if your VMCS ended up in UC memory, that might slow things
> > down quite a bit. But, I would expect the VMCS to end up at the same
> > address each time the test is run.
>
> Agreed on the repeatable failures part, but putting the VMCS in UC memory
> shouldn't affect this type of test.  The CPU's internal VMCS cache isn't
> coherent, and IIRC isn't disabled if the MTRRs for the VMCS happen to be
> UC.

But the internal VMCS cache only contains selected fields, doesn't it?
Uncached fields would have to be written to memory on VM-exit. Or are
all of the mutable fields in the internal VMCS cache?
