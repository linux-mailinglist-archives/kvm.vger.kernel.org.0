Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F0F473846
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 00:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244095AbhLMXLj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 18:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbhLMXLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 18:11:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F304C061574;
        Mon, 13 Dec 2021 15:11:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39099B816D9;
        Mon, 13 Dec 2021 23:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2A0C34600;
        Mon, 13 Dec 2021 23:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639437096;
        bh=PEAcjN37oxZX/9iYX69bn4bF0yxfwXfCPZeIHGvag1o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WGgkedP1ZGyFUChVrHAG2xisYq1ae4jaEMuEDN8TPsxg4A+2nNp8IA7HpBLt4Pg/y
         NppgwW/qXmVl/19MDI+RwV9i6+Jk/1DU3BiKT0BLrQ+Cmxl7JkRMmHWIEZ7ebVrRtJ
         3OOZIET6UL2kKjt5bCiTjHct1vj0O/D2kxOdtXQvrSBt83AaTZ7jSZZsDeeLajkdtF
         hBcCoOXoc00p7c5R5B3zORKpXuI+ea5BF9SQNww8Ep+uYm170K+aLZ5zlm1WKGb4FU
         LuVNHCTA9Z3bCb/19fFwYWLdBC+YMSU96WUoKyIlTArJo52YroV4lAnjJS6A1r9Jtg
         0qLPmFu2w+hIw==
Received: by mail-ed1-f51.google.com with SMTP id r25so56724442edq.7;
        Mon, 13 Dec 2021 15:11:35 -0800 (PST)
X-Gm-Message-State: AOAM531rt4yzKaei7VR5u7r1acLR5ery8PE7kFeX2ConaaLmcrBWwwil
        IxytB3FzVLiXm5qb2RSnKPbA/UnycI0dpZMV/w==
X-Google-Smtp-Source: ABdhPJwWE2mZhgSkGIpbmG4K7J0EkVEt1f+A9VeATTghLyvHR5AeReFxWiF3WIzNM5rkdd1zS1o+iWUBbFMYvX58O/0=
X-Received: by 2002:a17:907:94c2:: with SMTP id dn2mr1439977ejc.325.1639437094406;
 Mon, 13 Dec 2021 15:11:34 -0800 (PST)
MIME-Version: 1.0
References: <20211204002038.113653-1-atishp@atishpatra.org>
 <Ya4sDX974/dVEOQw@robh.at.kernel.org> <CAOnJCUKcYeWaDXY6OxQPrNwKV=4t9zbpSjfQLsL70P+3GE7F7A@mail.gmail.com>
In-Reply-To: <CAOnJCUKcYeWaDXY6OxQPrNwKV=4t9zbpSjfQLsL70P+3GE7F7A@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 13 Dec 2021 17:11:21 -0600
X-Gmail-Original-Message-ID: <CAL_JsqL_DXTJMdUGVwa1T9HqzcJkae=PS12dBbhFS9A22XK6=w@mail.gmail.com>
Message-ID: <CAL_JsqL_DXTJMdUGVwa1T9HqzcJkae=PS12dBbhFS9A22XK6=w@mail.gmail.com>
Subject: Re: [RFC 0/6] Sparse HART id support
To:     Atish Patra <atishp@atishpatra.org>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Anup Patel <anup.patel@wdc.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Ingo Molnar <mingo@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Nanyong Sun <sunnanyong@huawei.com>,
        Nick Kossifidis <mick@ics.forth.gr>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Pekka Enberg <penberg@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021 at 3:27 PM Atish Patra <atishp@atishpatra.org> wrote:
>
> On Mon, Dec 6, 2021 at 7:28 AM Rob Herring <robh@kernel.org> wrote:
> >
> > On Fri, Dec 03, 2021 at 04:20:32PM -0800, Atish Patra wrote:
> > > Currently, sparse hartid is not supported for Linux RISC-V for the following
> > > reasons.
> > > 1. Both spinwait and ordered booting method uses __cpu_up_stack/task_pointer
> > >    which is an array size of NR_CPUs.
> > > 2. During early booting, any hartid greater than NR_CPUs are not booted at all.
> > > 3. riscv_cpuid_to_hartid_mask uses struct cpumask for generating hartid bitmap.
> > > 4. SBI v0.2 implementation uses NR_CPUs as the maximum hartid number while
> > >    generating hartmask.
> > >
> > > In order to support sparse hartid, the hartid & NR_CPUS needs to be disassociated
> > > which was logically incorrect anyways. NR_CPUs represent the maximum logical|
> > > CPU id configured in the kernel while the hartid represent the physical hartid
> > > stored in mhartid CSR defined by the privilege specification. Thus, hartid
> > > can have much greater value than logical cpuid.
> >
> > We already have a couple of architectures with logical to physical CPU
> > id maps. See cpu_logical_map. Can we make that common and use it here?
>
> Yes. We can move the cpu_logical_map(which is a macro) &
> __cpu_logical_map(actual array with NR_CPUS size)
> to common code so that all the architecture can use it instead of
> defining it separately.

IIRC, the macro is what varies by arch and I would move to static
inlines rather than supporting:

cpu_logical_map(cpu) = 0xdeadbeef;

>
> > That would also possibly allow for common populating the map from DT.
> >
>
> I didn't understand this part. The mapping is populated at run time
> [1] as the boot cpu can be any hart in RISC-V.
> That booting hart will be mapped to cpu 0. All others will be mapped
> based on how the cpu node is laid out in the DT.
> Do you mean we can move the 2nd part to common code as well ?

Yes, as the DT platforms just loop thru the cpu nodes and fill the
logical map based on 'reg', I don't think that needs to be per arch
once we have a common map. But not asking for that now.

Rob
