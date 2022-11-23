Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B99636100
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 15:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238459AbiKWOD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 09:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238377AbiKWODi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 09:03:38 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2836BB1F4
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 05:58:45 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id i64-20020a1c3b43000000b003d016c21100so1488726wma.3
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 05:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b1Quh2S4Mqiz+mnmyB9nbm+e1ppPa6f3UhLHFNBAwqA=;
        b=RtArgD6+Z8rmyrUSFbh8yCVa5eEuQ0iy1z/3lv/Pmpd0w0tSDdpujqmsSNJX0x4mmd
         WIqT4YBwZWrDyaCzY1bdpaGY+t7jMv9Pmu8HJe4Ndtz5E587A2I0rUl3lg5TwjHg/xPH
         yYn/G0QQkQ52ZgshAgQCyG0Ebv3wSa1WZWYBwjQJxwIssdAKD9kSMNAAuet4myzGnmBB
         RIfNzvIIMxrxOIKnK6F0MMkFixiH8KV09xVtHfISjKrgPaerVMMXn6TFlMfNteX48vha
         Ly17fqLt5ylR2IGFfF3VVsfXofaivmpU9lSqRo2pxgwVH54gPAxL/HT55x90YlejspCV
         GZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1Quh2S4Mqiz+mnmyB9nbm+e1ppPa6f3UhLHFNBAwqA=;
        b=zdqKIWoVaTzW1IkARS3NcHh7QhxTWddc8nymL9c9M7NIlCX77HE0EwzUf6uuxAzR1A
         KXnATVlIWPTQlg43PTswUpwDRi0K8pjpHwW/yl/g0tFj+QYZIm8WzHpzufRU3j44TksA
         zhtqKCTRl596JPeScUYY+w/p4hveWBcmO3zV3aHtKT2ihUqyAR4s1GgKRXjlcooA7KWz
         blPnvwJqLUnbpzZuP3bEiqlrBSgEsK5zw6Wzr4nyDy4S+FtacO1JDySEyLGj0o99H8OK
         3EH1LXxzrXOlVG4hDCyaRb5CmU80VGK+gXWbzFQTku9lnxAUN+2av0GpCgTaw2842j6V
         Lxdw==
X-Gm-Message-State: ANoB5plUzZM1myn7MS6+puaRUqLvSr8gz7rKFi7Q/Y6evztEyucbYhY2
        S5j2Olq1kTnWuLjEADDARsKf5A==
X-Google-Smtp-Source: AA0mqf4VrPbtxMqRs2lUsgDIfzAcYJfq1GzhGZj+v9rkaPfsGzHMCFlz1vXX8UzjKJAqIn3aEELWwg==
X-Received: by 2002:a05:600c:4f55:b0:3cf:729b:d4b4 with SMTP id m21-20020a05600c4f5500b003cf729bd4b4mr14142344wmq.48.1669211923651;
        Wed, 23 Nov 2022 05:58:43 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-748-2a9a-a2a6-1362.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:748:2a9a:a2a6:1362])
        by smtp.gmail.com with ESMTPSA id y10-20020a5d620a000000b002366dd0e030sm16751799wru.68.2022.11.23.05.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 05:58:43 -0800 (PST)
Date:   Wed, 23 Nov 2022 14:58:42 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>, Guo Ren <guoren@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [RFC 6/9] RISC-V: KVM: Add SBI PMU extension support
Message-ID: <20221123135842.uyw46kbybgb7unm2@kamzik>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
 <20220718170205.2972215-7-atishp@rivosinc.com>
 <20221101142631.du54p4kyhlgf54cr@kamzik>
 <CAOnJCUJfakcoiWh4vFk5_BcTKfoSDbx+wtmh7MW4cPYog7q4BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOnJCUJfakcoiWh4vFk5_BcTKfoSDbx+wtmh7MW4cPYog7q4BQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 22, 2022 at 03:08:34PM -0800, Atish Patra wrote:
> On Tue, Nov 1, 2022 at 7:26 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > On Mon, Jul 18, 2022 at 10:02:02AM -0700, Atish Patra wrote:
...
> > > +static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > > +                                unsigned long *out_val,
> > > +                                struct kvm_cpu_trap *utrap,
> > > +                                bool *exit)
> > > +{
> > > +     int ret = -EOPNOTSUPP;
> > > +     struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> > > +     unsigned long funcid = cp->a6;
> > > +     uint64_t temp;
> >
> > I think we need something like
> >
> >    if (!vcpu_to_pmu(vcpu)->enabled)
> >       return -EOPNOTSUPP;
> >
> > here. Where 'enabled' is only true when we successfully initialize
> > the pmu. And, successful initialization depends on
> 
> Yes. I have added the flag. But should we do the check here or
> respective function
> as a paranoia sanity check ?

I think something like above that returns a not-supported error should be
in all the entry points, like the top level SBI call handler. Functions
that should never be called unless the PMU is active could have WARNs
added for sanity checks.

> 
> > IS_ENABLED(CONFIG_RISCV_PMU_SBI) and
> 
> Why do we need to guard under CONFIG_RISCV_PMU_SBI ?
> vcpu_sbi_pmu.c is only compiled under CONFIG_RISCV_PMU_SBI
> 
> If CONFIG_RISCV_PMU_SBI is not enabled, probe function will return failure.

You're right. We don't need explicit config checks for things that can't
exist without the config.

> 
> In fact, I think we should also add the pmu enabled check in the probe function
> itself. Probe function(kvm_sbi_ext_pmu_probe) should only true when
> both vcpu_to_pmu(vcpu)->enabled and
> riscv_isa_extension_available(NULL, SSCOFPMF) are true.
> 
> Thoughts?

Agreed.

> 
> > riscv_isa_extension_available(NULL, SSCOFPMF) as well as not
> > failing other things. And, KVM userspace should be able to
> > disable the pmu, which keep enabled from being set as well.
> >
> We already have provisions for disabling sscofpmf from guests via ISA
> one reg interface.
> Do you mean disable the entire PMU from userspace ?

Yes. We may need to configure a VM without a PMU to increase its
migratability, workaround errata, or just for testing/debugging purposes.

> 
> Currently, ARM64 enables pmu from user space using device control APIs
> on vcpu fd.
> Are you suggesting we should do something like that ?

Yes. Although choosing which KVM API should be used could probably be
thought-out again. x86 uses VM ioctls.

> 
> If PMU needs to have device control APIs (either via vcpu fd or its
> own), we can retrieve
> the hpmcounter width and count from there as well.

Right. We need to decide how the VM/VCPU + PMU user interface should look.
A separate PMU device, like arm64 has, sounds good, but the ioctl
sequences for initialization may get more tricky.

Thanks,
drew
