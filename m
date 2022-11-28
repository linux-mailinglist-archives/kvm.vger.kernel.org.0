Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2701F63B3D0
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 22:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbiK1VB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 16:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbiK1VBK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 16:01:10 -0500
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7220F252A2
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:01:02 -0800 (PST)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-142b72a728fso14574859fac.9
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C0LXIJI7Jwrp9irbYPVuZ/zATeld30E9BF4kDpuOTMY=;
        b=sychVsIuyCs1J6sBN39fZaWelxUucVukYj9mRGoF1TcGNnYpdd/Yeb/uvh6XlBjUWD
         +XvcyKtqpdr9+WPiouT7bCvHKPAfcsqUB8ouoz8ATXbrAmLyWmW+IATIRgfOCUamzen4
         A3AERg4lfY92/gZfNXiNubTPsFjR4uDuhDyZs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C0LXIJI7Jwrp9irbYPVuZ/zATeld30E9BF4kDpuOTMY=;
        b=gvlq785XwQqUEEekSTBm+FyGQ4PCgfUx1kPHk+2rlyuks3pJp2tQNdUMZomPHWuYKx
         +YkIkcO96oOQOb4KiZUazLY4570b/Yn/y/frUnQynKj9IEvGxmaSIhjE7kck0NoJmMG9
         8J38H8HMkGNuQvF/LdCrZR82qT80sgNV8KoL+jUdC/q/sOmLrk/5yHmd6Av2EgiDmE1v
         SPuv627oIsvlXxzha2e+xsA6qvyYI7UsD+SN0Ak9Ap/HPRYwGDt5OoxBG6fu05nWmfYG
         AV/VbyGN4lh1CrPtMambYloeMTsaYIUomD4epd3JIlMUAXjkWpD9YD9SNodoT+UI6VJL
         yJDw==
X-Gm-Message-State: ANoB5pnQi1DrVRPFY5QJE5aZBE0ziJ1AXIjJPT9b8xPvI5lvp407Kl5A
        0732rgSIkKMN8ZJOMANmbl+zNyd+HHrwnQv+lRM6GhdDDQ==
X-Google-Smtp-Source: AA0mqf5V4JXvrkWngJfl026KheDUhSJ3FXXcX5xGXvT8T4Cp3XBlpcG+E3IH/EnL11AB0oCM+6HqccSMUkRa7wiMuuE=
X-Received: by 2002:a05:6870:c18a:b0:142:870e:bd06 with SMTP id
 h10-20020a056870c18a00b00142870ebd06mr26790617oad.181.1669669261652; Mon, 28
 Nov 2022 13:01:01 -0800 (PST)
MIME-Version: 1.0
References: <20220718170205.2972215-1-atishp@rivosinc.com> <20220718170205.2972215-7-atishp@rivosinc.com>
 <20221101142631.du54p4kyhlgf54cr@kamzik> <CAOnJCUJfakcoiWh4vFk5_BcTKfoSDbx+wtmh7MW4cPYog7q4BQ@mail.gmail.com>
 <20221123135842.uyw46kbybgb7unm2@kamzik> <CAOnJCUKZV+0Xts6C4QY7X+Wak0ZR_f8wPtEAtH4PEmh2-_AcWw@mail.gmail.com>
 <20221124105051.hbsavj3bgf4mvlzb@kamzik> <CAK9=C2XifUiOdA4cTFbQq7SNVJn+1Xup_giw4jo_z6bRdng4hQ@mail.gmail.com>
In-Reply-To: <CAK9=C2XifUiOdA4cTFbQq7SNVJn+1Xup_giw4jo_z6bRdng4hQ@mail.gmail.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Mon, 28 Nov 2022 13:00:50 -0800
Message-ID: <CAOnJCU+fxyLbLMEPbo+FA_DK+R872rJTeXrEeZGXwzxh6LyR0A@mail.gmail.com>
Subject: Re: [RFC 6/9] RISC-V: KVM: Add SBI PMU extension support
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Andrew Jones <ajones@ventanamicro.com>,
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

On Thu, Nov 24, 2022 at 4:59 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> On Thu, Nov 24, 2022 at 4:21 PM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > On Thu, Nov 24, 2022 at 02:18:26AM -0800, Atish Patra wrote:
> > > On Wed, Nov 23, 2022 at 5:58 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> > > >
> > > > On Tue, Nov 22, 2022 at 03:08:34PM -0800, Atish Patra wrote:
> > ...
> > > > > Currently, ARM64 enables pmu from user space using device control APIs
> > > > > on vcpu fd.
> > > > > Are you suggesting we should do something like that ?
> > > >
> > > > Yes. Although choosing which KVM API should be used could probably be
> > > > thought-out again. x86 uses VM ioctls.
> > > >
> > >
> > > How does it handle hetergenous systems in per VM ioctls ?
> >
> > I don't think it does, but neither does arm64. Afaik, the only way to run
> > KVM VMs on heterogeneous systems is to pin the VM to one set of the CPUs,
> > i.e. make sure the system it runs on is homogeneous.
> >
> > I agree we shouldn't paint ourselves into a homogeneous-only corner for
> > riscv, though, so if it's possible to use VCPU APIs, then I guess we
> > should. Although, one thing to keep in mind is that if the same ioctl
> > needs to be run on each VCPU, then, when we start building VMs with
> > hundreds of VCPUs, we'll see slow VM starts.
> >
> > >
> > > > >
> > > > > If PMU needs to have device control APIs (either via vcpu fd or its
> > > > > own), we can retrieve
> > > > > the hpmcounter width and count from there as well.
> > > >
> > > > Right. We need to decide how the VM/VCPU + PMU user interface should look.
> > > > A separate PMU device, like arm64 has, sounds good, but the ioctl
> > > > sequences for initialization may get more tricky.
> > > >
> > >
> > > Do we really need a per VM interface ? I was thinking we can just
> > > continue to use
> > > one reg interface for PMU as well. We probably need two of them.
> > >
> > > 1. To enable/disable SBI extension
> > >     -- The probe function will depend on this
> > > 2. PMU specific get/set
> > >     -- Number of hpmcounters
> > >     -- hpmcounter width
> > >     -- enable PMU
> >
> > ONE_REG is good for registers and virtual registers, which means the
> > number of hpmcounters and the hpmcounter width are probably good
> > candidates, but I'm not sure we should use it for enable/init types of
> > purposes.
>
> We are already using ONE_REG interface to enable/disable
> ISA extensions so we should follow the same pattern and have
> ONE_REG interface to enable/disable SBI extensions as well.
>

Thinking about it more, it may end up in vcpus with heterogeneous
capabilities (different SBI extension).
Most likely, it will be a bug and incorrect configuration from VMM but
it's a possibility.
For example: There will be two different scenarios for PMU extension

1. Boot vcpu disabled PMU extension - probably okay as guest queries
the PMU extension on boot cpu only.
The PMU extension won't be available for any other vcpu.

2. Boot vcpu has PMU extension enabled but others have it disabled.
The run time SBI PMU calls will
fail with EOPNOTSUPP and the user gets confused.

There will be similar cases for HSM extension as well.

As the entire extension won't be available to the guest if the SBI
extension is disabled for the boot cpu only.
There is also a slow VM start issue Andrew pointed about earlier.

This makes me think if a VM ioctl to disable/enable the SBI extension
for all vcpus makes more sense in this case.


> Regards,
> Anup



-- 
Regards,
Atish
