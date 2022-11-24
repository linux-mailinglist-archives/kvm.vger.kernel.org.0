Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88BDD637982
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 13:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiKXM7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 07:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiKXM7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 07:59:16 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30F9950CE
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 04:59:15 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id e205so1471564oif.11
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 04:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jWhjZ8Ik6udAxmU7OrnkH0fp8I0zGCvkX7BlR9Epea8=;
        b=IC3tTQJtWUJQyjZrGL6F6TYNH5H29hlmfBUQkgCMCV/wz5PfN4ovrgjSXVW62CedRi
         QARU0pDSP2eRrKKPXeyJVL5Iuo2p7Zgxd0GtDE4j3fmQPMr/6YYTg+O0YkBYsab8T/tQ
         pdrDU0ljJOb85kDxDoU/GNjcYFxJO1APG9R/aaVJCCRqNw0NUld3q0P/3gDEugJqw80c
         1zYvWHi2PK9FyJt+tN8GjidSP+kggtDWAnklLwAyHXuXhK5SarF7ki1tYcWBkMXe6zFa
         pp+4OsdhAzd2LNEfaXIYcD5Tu5tx4Xx0y8u3fEBmG6CsIi6hg8GmIRZO5kqq6DeG7Xcy
         FJMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jWhjZ8Ik6udAxmU7OrnkH0fp8I0zGCvkX7BlR9Epea8=;
        b=wPdYlY5bYif+eiLhRY2zqavpjntRehYZXRlCJRpdxlETzYfJd8hq53Yqlm60yVO3J0
         uUp50ZxyCyDfNmyhLeAejTx7L1ZlZcJQ6pHQNcZDEJMD4iuB8rGmB860i7TPH70QJrZm
         sobsCEAPQ1HyiXcXQ52m7QcrUUdxDDB2xyZa86qoyARDh28RFpJmZVjg5Tge4yeWyM6Y
         33mtSrlaARCMS3uOLgu0TVe0aYZplTpsWet03wKnPaCcWM/codRmduH3+UxUU0kBVjLi
         7z0qF+BLvVmUAY9OqtDy0l+39yknMGa8KHErotCKGeR0vUpEq9HdGfjGceGzthvSwtPG
         LP4g==
X-Gm-Message-State: ANoB5pnw/ajEc6lxAGKWGrpmZxaoU+7eRhHio1PbhMw1kQxG9/oH6q/3
        StQquZZu1DshcIkfbh/ewWXz/xDfzrB3rowpmmcW/g==
X-Google-Smtp-Source: AA0mqf58ktcA3pHdBUjrxW6zFt+WYodi0RAr78fTSZX+SH39xGLFckk74X32aAuTirPTsS6SUqgoUXYBSEubV3jo5Ec=
X-Received: by 2002:a05:6808:2102:b0:359:ac8d:4227 with SMTP id
 r2-20020a056808210200b00359ac8d4227mr6186334oiw.17.1669294754893; Thu, 24 Nov
 2022 04:59:14 -0800 (PST)
MIME-Version: 1.0
References: <20220718170205.2972215-1-atishp@rivosinc.com> <20220718170205.2972215-7-atishp@rivosinc.com>
 <20221101142631.du54p4kyhlgf54cr@kamzik> <CAOnJCUJfakcoiWh4vFk5_BcTKfoSDbx+wtmh7MW4cPYog7q4BQ@mail.gmail.com>
 <20221123135842.uyw46kbybgb7unm2@kamzik> <CAOnJCUKZV+0Xts6C4QY7X+Wak0ZR_f8wPtEAtH4PEmh2-_AcWw@mail.gmail.com>
 <20221124105051.hbsavj3bgf4mvlzb@kamzik>
In-Reply-To: <20221124105051.hbsavj3bgf4mvlzb@kamzik>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Thu, 24 Nov 2022 18:29:04 +0530
Message-ID: <CAK9=C2XifUiOdA4cTFbQq7SNVJn+1Xup_giw4jo_z6bRdng4hQ@mail.gmail.com>
Subject: Re: [RFC 6/9] RISC-V: KVM: Add SBI PMU extension support
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Atish Patra <atishp@atishpatra.org>,
        Atish Patra <atishp@rivosinc.com>,
        linux-kernel@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
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

On Thu, Nov 24, 2022 at 4:21 PM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Thu, Nov 24, 2022 at 02:18:26AM -0800, Atish Patra wrote:
> > On Wed, Nov 23, 2022 at 5:58 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> > >
> > > On Tue, Nov 22, 2022 at 03:08:34PM -0800, Atish Patra wrote:
> ...
> > > > Currently, ARM64 enables pmu from user space using device control APIs
> > > > on vcpu fd.
> > > > Are you suggesting we should do something like that ?
> > >
> > > Yes. Although choosing which KVM API should be used could probably be
> > > thought-out again. x86 uses VM ioctls.
> > >
> >
> > How does it handle hetergenous systems in per VM ioctls ?
>
> I don't think it does, but neither does arm64. Afaik, the only way to run
> KVM VMs on heterogeneous systems is to pin the VM to one set of the CPUs,
> i.e. make sure the system it runs on is homogeneous.
>
> I agree we shouldn't paint ourselves into a homogeneous-only corner for
> riscv, though, so if it's possible to use VCPU APIs, then I guess we
> should. Although, one thing to keep in mind is that if the same ioctl
> needs to be run on each VCPU, then, when we start building VMs with
> hundreds of VCPUs, we'll see slow VM starts.
>
> >
> > > >
> > > > If PMU needs to have device control APIs (either via vcpu fd or its
> > > > own), we can retrieve
> > > > the hpmcounter width and count from there as well.
> > >
> > > Right. We need to decide how the VM/VCPU + PMU user interface should look.
> > > A separate PMU device, like arm64 has, sounds good, but the ioctl
> > > sequences for initialization may get more tricky.
> > >
> >
> > Do we really need a per VM interface ? I was thinking we can just
> > continue to use
> > one reg interface for PMU as well. We probably need two of them.
> >
> > 1. To enable/disable SBI extension
> >     -- The probe function will depend on this
> > 2. PMU specific get/set
> >     -- Number of hpmcounters
> >     -- hpmcounter width
> >     -- enable PMU
>
> ONE_REG is good for registers and virtual registers, which means the
> number of hpmcounters and the hpmcounter width are probably good
> candidates, but I'm not sure we should use it for enable/init types of
> purposes.

We are already using ONE_REG interface to enable/disable
ISA extensions so we should follow the same pattern and have
ONE_REG interface to enable/disable SBI extensions as well.

Regards,
Anup
