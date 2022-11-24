Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613A4637615
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 11:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiKXKSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 05:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiKXKSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 05:18:39 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56141D92ED
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 02:18:38 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id q186so1117278oia.9
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 02:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zGiZlBvNiwhpkqsR+b3pszQBQ7Auh+g6CaM/s8BUrYg=;
        b=YDyoj+Zi8XAnNDRzcGL99v05D7zM8bWz+3OqIzyD2w4N2pJALRtx8fJ8jFEHjuO6DL
         Mu+mYCeMpo/gbYQ5WroHlgcWIZHJ69btnS3eLz5Ww0okQo6qof1zG2bsnzX7kNEOJJ/z
         6wUTLbB8asyfYc7hleNjb2knO4EabRB9LnoeQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zGiZlBvNiwhpkqsR+b3pszQBQ7Auh+g6CaM/s8BUrYg=;
        b=xXcWXzKKZtwMqmVNycTUL4JImwgDKREqXynjxypR6dLziryGy0NgWLlYAHSgP44E9Y
         /qtal/6o98lhiZSebqPqtU8OWglI4MDXgxTtReCi9PGHwKL2QEUXOFjkSy/a3XVrkULE
         eLl3rBx1Us1QAgrqvqyL5REZvWvIqdfgwOgd3RUrDNxVFkaoMMXfsz3/WzujoOxrTJmS
         bcxlebsR+2J92pwNLj21UVn9FwOYBlwY2lM8rOf4poy6UXqpmBGnZqSCnDdxPLQG1uW/
         0vfIwU3SDFKIJgmraCfB+nMbWDQAmKiOv5QQnksuM8OaL9QcYIVqVsUBmWua4/uUKuwc
         mKQA==
X-Gm-Message-State: ANoB5pnIj4dBDNobKn4iyAlZvc+cDAL4WQDpZU7RwPIfG+gf8dVI4bzb
        mu0rIhmF5sU60LTDjTlDFD5pm94zFkgu9InANwQgkrlvAA==
X-Google-Smtp-Source: AA0mqf6C5dlDvnPsT44KvSrCnZApXT9e7P7KCYteZn1aOOsjl4G37U/m6ORn0KcUFQTwHGkePw8WKf/CRMGz0a8DiPo=
X-Received: by 2002:a05:6808:51:b0:359:f091:104 with SMTP id
 v17-20020a056808005100b00359f0910104mr19097584oic.274.1669285117693; Thu, 24
 Nov 2022 02:18:37 -0800 (PST)
MIME-Version: 1.0
References: <20220718170205.2972215-1-atishp@rivosinc.com> <20220718170205.2972215-7-atishp@rivosinc.com>
 <20221101142631.du54p4kyhlgf54cr@kamzik> <CAOnJCUJfakcoiWh4vFk5_BcTKfoSDbx+wtmh7MW4cPYog7q4BQ@mail.gmail.com>
 <20221123135842.uyw46kbybgb7unm2@kamzik>
In-Reply-To: <20221123135842.uyw46kbybgb7unm2@kamzik>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Thu, 24 Nov 2022 02:18:26 -0800
Message-ID: <CAOnJCUKZV+0Xts6C4QY7X+Wak0ZR_f8wPtEAtH4PEmh2-_AcWw@mail.gmail.com>
Subject: Re: [RFC 6/9] RISC-V: KVM: Add SBI PMU extension support
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

On Wed, Nov 23, 2022 at 5:58 AM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Tue, Nov 22, 2022 at 03:08:34PM -0800, Atish Patra wrote:
> > On Tue, Nov 1, 2022 at 7:26 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> > >
> > > On Mon, Jul 18, 2022 at 10:02:02AM -0700, Atish Patra wrote:
> ...
> > > > +static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > > > +                                unsigned long *out_val,
> > > > +                                struct kvm_cpu_trap *utrap,
> > > > +                                bool *exit)
> > > > +{
> > > > +     int ret = -EOPNOTSUPP;
> > > > +     struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> > > > +     unsigned long funcid = cp->a6;
> > > > +     uint64_t temp;
> > >
> > > I think we need something like
> > >
> > >    if (!vcpu_to_pmu(vcpu)->enabled)
> > >       return -EOPNOTSUPP;
> > >
> > > here. Where 'enabled' is only true when we successfully initialize
> > > the pmu. And, successful initialization depends on
> >
> > Yes. I have added the flag. But should we do the check here or
> > respective function
> > as a paranoia sanity check ?
>
> I think something like above that returns a not-supported error should be
> in all the entry points, like the top level SBI call handler. Functions
> that should never be called unless the PMU is active could have WARNs
> added for sanity checks.
>

Sure. Will add those checks.

> >
> > > IS_ENABLED(CONFIG_RISCV_PMU_SBI) and
> >
> > Why do we need to guard under CONFIG_RISCV_PMU_SBI ?
> > vcpu_sbi_pmu.c is only compiled under CONFIG_RISCV_PMU_SBI
> >
> > If CONFIG_RISCV_PMU_SBI is not enabled, probe function will return failure.
>
> You're right. We don't need explicit config checks for things that can't
> exist without the config.
>
> >
> > In fact, I think we should also add the pmu enabled check in the probe function
> > itself. Probe function(kvm_sbi_ext_pmu_probe) should only true when
> > both vcpu_to_pmu(vcpu)->enabled and
> > riscv_isa_extension_available(NULL, SSCOFPMF) are true.
> >
> > Thoughts?
>
> Agreed.
>
> >
> > > riscv_isa_extension_available(NULL, SSCOFPMF) as well as not
> > > failing other things. And, KVM userspace should be able to
> > > disable the pmu, which keep enabled from being set as well.
> > >
> > We already have provisions for disabling sscofpmf from guests via ISA
> > one reg interface.
> > Do you mean disable the entire PMU from userspace ?
>
> Yes. We may need to configure a VM without a PMU to increase its
> migratability, workaround errata, or just for testing/debugging purposes.
>
> >
> > Currently, ARM64 enables pmu from user space using device control APIs
> > on vcpu fd.
> > Are you suggesting we should do something like that ?
>
> Yes. Although choosing which KVM API should be used could probably be
> thought-out again. x86 uses VM ioctls.
>

How does it handle hetergenous systems in per VM ioctls ?

> >
> > If PMU needs to have device control APIs (either via vcpu fd or its
> > own), we can retrieve
> > the hpmcounter width and count from there as well.
>
> Right. We need to decide how the VM/VCPU + PMU user interface should look.
> A separate PMU device, like arm64 has, sounds good, but the ioctl
> sequences for initialization may get more tricky.
>

Do we really need a per VM interface ? I was thinking we can just
continue to use
one reg interface for PMU as well. We probably need two of them.

1. To enable/disable SBI extension
    -- The probe function will depend on this
2. PMU specific get/set
    -- Number of hpmcounters
    -- hpmcounter width
    -- enable PMU


> Thanks,
> drew



-- 
Regards,
Atish
