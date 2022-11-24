Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9096374D3
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 10:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiKXJJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 04:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiKXJJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 04:09:17 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9FFBBDE9
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 01:09:14 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id a7-20020a056830008700b0066c82848060so580559oto.4
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 01:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lL7gdTpCNiKpeiKlTVZOoHHb+mH3E43X9VCyLiDvIVI=;
        b=XAEBxd6zFeZMWT09hA1sp4UtdtJIgi3oHr3R+60kZhZDYNWX5QqftD8ETthMbErJFN
         Q57WPdj89Ut97SoctXJkPc1a58dZeEI+2pA4m5s2UwGnwPgFrSAjh9m1MtW2JHUPgvGk
         CvxcvmlTr1bw9aS6pVUw41X/EWNEY4m2H09xg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lL7gdTpCNiKpeiKlTVZOoHHb+mH3E43X9VCyLiDvIVI=;
        b=5wcZiY0H0oLayx1i/5I32sAy9Mqx2FTkgPZOeD/tUGxm4Ajt+3XmSx+adb8Bndkkuu
         YyqggWxEwt4tQApy+JVhl0kYlsavJ12vgzD6bJWd0vgy31vi9Lz2BoLa+JKNqaIQ/CaC
         AJ2jYR1wSRVIktbGlKtjcEFrJ4DAf9yHEjeqeTuOzijST9nwCpWMFn6QeW+RfS7Pymcw
         JuQN94hByKXIKo0Ji4gH4KlPabwJ2zaYJwfd8xRK02Cy8LtJd/r3gitPQBUrtU+dk5FL
         6Js2XO0s+WfZ0xPi5phKbFc2fbM+WdATD+cIMLVq0PQJBhA4Q8ntOBdrloaOMUbLWc7j
         1lFg==
X-Gm-Message-State: ANoB5pkYrjM3Kj8325I2dz/TuOj4SThtdsApkaBKGh5T9diJgUUoOYRz
        yfTk0CX1/Fg9vQacGz/KusRPfgB6Jp1SSd+SRY37
X-Google-Smtp-Source: AA0mqf4A90at0hGw7uFrk/vHI3ASzvDpqG1jZS+ElZMyGTWmbGCzjTmbNB/1dzUwPeHb3xtj5+s885kLmAHTKag5fPc=
X-Received: by 2002:a9d:4812:0:b0:66d:1e19:684b with SMTP id
 c18-20020a9d4812000000b0066d1e19684bmr16755831otf.44.1669280954244; Thu, 24
 Nov 2022 01:09:14 -0800 (PST)
MIME-Version: 1.0
References: <20220718170205.2972215-1-atishp@rivosinc.com> <20220718170205.2972215-6-atishp@rivosinc.com>
 <20221101141329.j4qtvjf6kmqixt2r@kamzik> <CAOnJCULMbTp6WhVRWHxzFnUgCJJV01hcyukQxSEih-sYt5TJWg@mail.gmail.com>
 <20221123131104.zglb3osa5tsgkkkb@kamzik>
In-Reply-To: <20221123131104.zglb3osa5tsgkkkb@kamzik>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Thu, 24 Nov 2022 01:09:03 -0800
Message-ID: <CAOnJCUK0PcSXxt-Qvomy-4UoP5993-bVfPvWn_Rd5=ELC9n1gA@mail.gmail.com>
Subject: Re: [RFC 5/9] RISC-V: KVM: Add skeleton support for perf
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>, Guo Ren <guoren@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 5:11 AM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Tue, Nov 22, 2022 at 04:46:14PM -0800, Atish Patra wrote:
> ...
> > > > +     kvpmu->num_hw_ctrs = num_hw_ctrs;
> > > > +     kvpmu->num_fw_ctrs = num_fw_ctrs;
> > >
> > > Maybe it's coming later, but we need to give KVM userspace control over
> > > the number of counters to allow it to migrate to a larger set of hosts.
> > > Also, a previous patch said the virtual width must be the same as the
> > > host width for the hw counters, so we need userspace to know what that
> > > is in order to determine to which hosts it can migrate a guest.
> > >
> >
> > Yes. The entire user space access control needs to be sketched out.
> > We probably need another one reg interface to set/get the number of
> > counters/width.
> >
> > However, Is it a common to migrate a guest between different hosts
> > with different PMU capabilities ?
> >
>
> Ideally we'd be able to define a virtual CPU+PMU which represents the
> least common denominator of a set of hosts, allowing VMs which use that
> VCPU model to migrate among all the hosts. x86 pulls this off pretty well,
> but arm64 doesn't. In the least, I think a goal should be to enable
> migration of VMs from hosts with less extensions and less PMU counters to
> hosts with more, as that would support host upgrades without having to
> recreate VMs.
>

We also have hpmwidth to worry about. I guess the policy details will be
VMM specific one. We need to think through the parameters that can be
varied between
hosts. As you pointed out earlier,

1. hpmcounter wdith
2. Number of hpmcounters
3. PMU related ISA extension - this will be applicable for all the extensions.

Anything else ?


> Thanks,
> drew



--
Regards,
Atish
