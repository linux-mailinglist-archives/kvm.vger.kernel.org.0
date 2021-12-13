Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1218F47368F
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 22:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243117AbhLMV1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 16:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236782AbhLMV1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 16:27:33 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6CAC061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 13:27:33 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id d10so41632034ybe.3
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 13:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tS/h42aoWNvC9F09YRt3IPscSl6Go2TabGZNpFMjr1Q=;
        b=SqJqF6KfjAHG+SeRMuPoCEqf0e/o/Y+PV6/bBLvnCli36DmKOoeFeyh6z46zS/SaE9
         BRRHa/3ViRSvPyYD/GxN0Ze6zMSmy0gkyS8R9ezmn/5L+88Cc8V+c2hb8Rr+y3XFKa20
         qhUqUlPVqlyvZv4YvFxzWzKGuZjj4iwQBmFoo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tS/h42aoWNvC9F09YRt3IPscSl6Go2TabGZNpFMjr1Q=;
        b=FX9cHZSSOTZ/3IrdLNDHUshopccD3fl3I8nf8ku9kjJ52r8m2gdEh+nZ6bDN/Lw+ot
         hGy2yPGNHD2SXq+ACYM937KWLZ9JyNXcacP50QsIheODywGrfuJIjEReHjP6A6h5KIMM
         NoLVU0bgprzyCpLZgcgx1X1tMias5x9aL+sesITHohADof5oPR47p5BVyKmJpfc/v/pN
         6E5avVuX7oLrOlSa5IPBsUIv3SgwjECOG6jQ/P8tvL8pFDdhKOgZRWl6G+qc3D/xWy3h
         n4SgEkL0s7KtRFXCjyCxxh4l4IeSFY8+1QDhC+oaiMhM1hQVKKpHVTExihSCPca3aELR
         ohtQ==
X-Gm-Message-State: AOAM532MQ1/2vnroqDm5RwI0MFrG1GvaVoAaExQ4o7n+ZXLYBCe/ZYfj
        vyUbkvkzeJkpN/wn/b+XeekScppJVMhsXefkeQGz
X-Google-Smtp-Source: ABdhPJzslT8/6oXCsZUd9W7eJu9fAn0X/Rv9oKsdYACWvB/fLMbHtNl1F6uZ+CVQ9FJUh+Dwghg2dQVRfT2vBmV5zUg=
X-Received: by 2002:a25:bf8d:: with SMTP id l13mr1136880ybk.713.1639430852154;
 Mon, 13 Dec 2021 13:27:32 -0800 (PST)
MIME-Version: 1.0
References: <20211204002038.113653-1-atishp@atishpatra.org> <Ya4sDX974/dVEOQw@robh.at.kernel.org>
In-Reply-To: <Ya4sDX974/dVEOQw@robh.at.kernel.org>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Mon, 13 Dec 2021 13:27:21 -0800
Message-ID: <CAOnJCUKcYeWaDXY6OxQPrNwKV=4t9zbpSjfQLsL70P+3GE7F7A@mail.gmail.com>
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

On Mon, Dec 6, 2021 at 7:28 AM Rob Herring <robh@kernel.org> wrote:
>
> On Fri, Dec 03, 2021 at 04:20:32PM -0800, Atish Patra wrote:
> > Currently, sparse hartid is not supported for Linux RISC-V for the following
> > reasons.
> > 1. Both spinwait and ordered booting method uses __cpu_up_stack/task_pointer
> >    which is an array size of NR_CPUs.
> > 2. During early booting, any hartid greater than NR_CPUs are not booted at all.
> > 3. riscv_cpuid_to_hartid_mask uses struct cpumask for generating hartid bitmap.
> > 4. SBI v0.2 implementation uses NR_CPUs as the maximum hartid number while
> >    generating hartmask.
> >
> > In order to support sparse hartid, the hartid & NR_CPUS needs to be disassociated
> > which was logically incorrect anyways. NR_CPUs represent the maximum logical|
> > CPU id configured in the kernel while the hartid represent the physical hartid
> > stored in mhartid CSR defined by the privilege specification. Thus, hartid
> > can have much greater value than logical cpuid.
>
> We already have a couple of architectures with logical to physical CPU
> id maps. See cpu_logical_map. Can we make that common and use it here?

Yes. We can move the cpu_logical_map(which is a macro) &
__cpu_logical_map(actual array with NR_CPUS size)
to common code so that all the architecture can use it instead of
defining it separately.

> That would also possibly allow for common populating the map from DT.
>

I didn't understand this part. The mapping is populated at run time
[1] as the boot cpu can be any hart in RISC-V.
That booting hart will be mapped to cpu 0. All others will be mapped
based on how the cpu node is laid out in the DT.
Do you mean we can move the 2nd part to common code as well ?

[1] RISC-V: https://elixir.bootlin.com/linux/v5.16-rc5/source/arch/riscv/kernel/smpboot.c#L102

> Rob



-- 
Regards,
Atish
