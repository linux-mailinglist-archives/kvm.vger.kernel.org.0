Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2864A4739DA
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 01:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237455AbhLNA6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 19:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbhLNA6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 19:58:53 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6E3C06173F
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 16:58:51 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id q74so42478050ybq.11
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 16:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DK6zjNxaM56y08cW9l0/eZH6KA52RZRKXCnMSTZm6GQ=;
        b=r4oUCYh501EXd/gZuQfYAt0s2rTbK6MmxmU3077cEJ1QHC/9Gnc5rm5+B0cI19otfG
         uVgz8H2hl5oDWhbF3NXerx7LUMB2Y2uYgCgXHFW0tY14V8dXov1MN5y4lr5rt6DTzhzq
         zxZhoRvI5m0wJa7ptIO44i1Gv/VsIG2lUEAmw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DK6zjNxaM56y08cW9l0/eZH6KA52RZRKXCnMSTZm6GQ=;
        b=Mg8+XBL1oloJnxwZOvf7iwShFzxmK2LWPUj7ZYc3FBSMEKoLh5OZk2CBVnPEtL/b/k
         qE8tFTIiXWHNCJ+0rFrtamorvaToBSSyFQWWwsA30Xbz+ki5fmkC4kWc8VuOykxK5wJH
         TaMOK7d0msQrNWhnBPJ/swq6HkMAZAnMm7rcdHmA3ggxooZ5Z89q5fMAG8CvsYpBIS62
         y4mie5YFF/3JU9EVcPbBmExptIlCgk9fx2Rx/Eh3Tvdp4swba9X8ZsQKt56pUjePar2p
         Zl7L0lhDHI8+KYN3MTT8GPS2qXHatowdOs0opFH4f4/dO/753a2Rl0BT64Ib9SADsbCS
         I2Gg==
X-Gm-Message-State: AOAM530ZYcpHAJgZpJvY1xJzIDrrgWHjuHPlAL8rb1tWk+widUR10iOO
        tMq6bMlw6fgZJAchqZTqjy44Ozc5YtK5A9kF8rUZ
X-Google-Smtp-Source: ABdhPJzA01obrLKIOu5kQ51Q+3jIBhNOiwn4TybiXernS3MqCho7FRBxYDqhPVkB86beDZQMZo7IJ5Kw9mvGTIVLh7Y=
X-Received: by 2002:a25:2412:: with SMTP id k18mr2267818ybk.121.1639443531041;
 Mon, 13 Dec 2021 16:58:51 -0800 (PST)
MIME-Version: 1.0
References: <20211204002038.113653-1-atishp@atishpatra.org>
 <Ya4sDX974/dVEOQw@robh.at.kernel.org> <CAOnJCUKcYeWaDXY6OxQPrNwKV=4t9zbpSjfQLsL70P+3GE7F7A@mail.gmail.com>
 <CAL_JsqL_DXTJMdUGVwa1T9HqzcJkae=PS12dBbhFS9A22XK6=w@mail.gmail.com>
In-Reply-To: <CAL_JsqL_DXTJMdUGVwa1T9HqzcJkae=PS12dBbhFS9A22XK6=w@mail.gmail.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Mon, 13 Dec 2021 16:58:40 -0800
Message-ID: <CAOnJCU+3cxXDZcnzFpXb+2CLYk7=0aiD6zyCU5=SCWMCFLKPzw@mail.gmail.com>
Subject: Re: [RFC 0/6] Sparse HART id support
To:     Rob Herring <robh@kernel.org>
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

On Mon, Dec 13, 2021 at 3:11 PM Rob Herring <robh@kernel.org> wrote:
>
> On Mon, Dec 13, 2021 at 3:27 PM Atish Patra <atishp@atishpatra.org> wrote:
> >
> > On Mon, Dec 6, 2021 at 7:28 AM Rob Herring <robh@kernel.org> wrote:
> > >
> > > On Fri, Dec 03, 2021 at 04:20:32PM -0800, Atish Patra wrote:
> > > > Currently, sparse hartid is not supported for Linux RISC-V for the following
> > > > reasons.
> > > > 1. Both spinwait and ordered booting method uses __cpu_up_stack/task_pointer
> > > >    which is an array size of NR_CPUs.
> > > > 2. During early booting, any hartid greater than NR_CPUs are not booted at all.
> > > > 3. riscv_cpuid_to_hartid_mask uses struct cpumask for generating hartid bitmap.
> > > > 4. SBI v0.2 implementation uses NR_CPUs as the maximum hartid number while
> > > >    generating hartmask.
> > > >
> > > > In order to support sparse hartid, the hartid & NR_CPUS needs to be disassociated
> > > > which was logically incorrect anyways. NR_CPUs represent the maximum logical|
> > > > CPU id configured in the kernel while the hartid represent the physical hartid
> > > > stored in mhartid CSR defined by the privilege specification. Thus, hartid
> > > > can have much greater value than logical cpuid.
> > >
> > > We already have a couple of architectures with logical to physical CPU
> > > id maps. See cpu_logical_map. Can we make that common and use it here?
> >
> > Yes. We can move the cpu_logical_map(which is a macro) &
> > __cpu_logical_map(actual array with NR_CPUS size)
> > to common code so that all the architecture can use it instead of
> > defining it separately.
>
> IIRC, the macro is what varies by arch and I would move to static
> inlines rather than supporting:
>
> cpu_logical_map(cpu) = 0xdeadbeef;
>

Sounds good.


> >
> > > That would also possibly allow for common populating the map from DT.
> > >
> >
> > I didn't understand this part. The mapping is populated at run time
> > [1] as the boot cpu can be any hart in RISC-V.
> > That booting hart will be mapped to cpu 0. All others will be mapped
> > based on how the cpu node is laid out in the DT.
> > Do you mean we can move the 2nd part to common code as well ?
>
> Yes, as the DT platforms just loop thru the cpu nodes and fill the
> logical map based on 'reg', I don't think that needs to be per arch
> once we have a common map. But not asking for that now.
>

It would make sense to keep them together in a series. I can take a stab
at it once this series is merged so that we don't end up in
conflicting changes between
two series.

> Rob



-- 
Regards,
Atish
