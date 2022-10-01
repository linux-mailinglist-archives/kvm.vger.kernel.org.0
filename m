Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F7D5F1C2B
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 14:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiJAMhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Oct 2022 08:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJAMhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Oct 2022 08:37:47 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE86EC5BED
        for <kvm@vger.kernel.org>; Sat,  1 Oct 2022 05:37:45 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id l22so7660273edj.5
        for <kvm@vger.kernel.org>; Sat, 01 Oct 2022 05:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=KvoW78AAzLT7ogprsLkszyOkAENilZD0ZsEjEIY7x0Y=;
        b=DFj9co/s7Si11tq78pS0zSw2gbw+Tb+WKkxc28fGQUGrUfLtzLs1Q3MI4kpUD46dGa
         NwAVCwApxbS6WizMyL8P7D562jyBRCaYv5Dw552oYAbeHum0paFabcUC3KhJpEEQnLIW
         QvHVqNsHijnKo+wUYXVmX+VU3tPSsI5i1/5L04MDJK660hCBk9vdUuX8rfocbx88Q34Y
         qsjcnKBUa+Ibn+gVEOSD5BmlDGZHkRCMd5qsR+IjFg70g9z++SnpRGnGMM+rwYk0UrRs
         QUq9x9RbgyqV+ii8DSvWPt/CMpIvSt19TVO91MYrHUo1MscOuJ9hUhP/065oo9u22pBh
         8qoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=KvoW78AAzLT7ogprsLkszyOkAENilZD0ZsEjEIY7x0Y=;
        b=cFlMzYaeJl8KRWJ14mLb6OITQJukdaFjeVTyQ3XsZOjDn6KfwqN+I49Cu4a4ITNhho
         E/AcCWg8KyWMRVtzWqoCsWmcYXMdBC4+uU4AV0yadI4di+dSOYZipCyly3VvPaEdusyo
         +h8Ba7sunv5nWhKrfQ0LcRB83onfxMHA7Oc+1c8ZGjquWyVk8CZ4ce6Xdch1Q1stBH9T
         5xFbBQpHXox+9LPjIH6oySrCvs70abJhkJsAnOztV4pfN6HVUp9MaqL/SQ/5ruBoLYly
         dezLkw3+iQ3kWQMtYNs+e8t4i2e7GgIfwSkE2wWiFy0vv6PsG5CqFiN0Z4ifmoQfE5Yu
         WiDQ==
X-Gm-Message-State: ACrzQf27NAn+UjthJAx3RRmFIdDNQX2XN15J64PMEI30OGAA/c6/7pN+
        Zpov9LA+39TATt1Td1P8eL+SrtRmWiB9goP3jCjSUw==
X-Google-Smtp-Source: AMsMyM5Rn68oIVyanTIFge59Tc6+8hXWa4NwyznUv2aygvathNANcu50e/yq0hAeqQd89XVbRJqBQAwDhSZIuB4NTmM=
X-Received: by 2002:a05:6402:b4e:b0:458:9b11:da56 with SMTP id
 bx14-20020a0564020b4e00b004589b11da56mr4132875edb.140.1664627864469; Sat, 01
 Oct 2022 05:37:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220925162400.1606-1-jszhang@kernel.org>
In-Reply-To: <20220925162400.1606-1-jszhang@kernel.org>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 1 Oct 2022 18:07:33 +0530
Message-ID: <CAAhSdy0qtH=N_LQ8KfiYTJFoNLeO_wYzhmQD8-TtSTNE5doLBw@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] riscv: kvm: use generic entry for
 TIF_NOTIFY_RESUME and misc
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 25, 2022 at 10:03 PM Jisheng Zhang <jszhang@kernel.org> wrote:
>
> This series is a preparation series to add PREEMPT_RT support to riscv:
> patch1 adds the missing number of signal exits in vCPU stat
> patch2 switches to the generic guest entry infrastructure
> patch3 select HAVE_POSIX_CPU_TIMERS_TASK_WORK which is a requirement for
> RT
>
> After these three patches merged, the left RT patches are similar as
> other arch.
>
> Since v2:
>   - splict the series into two separate ones, one for next another for
>     RT.
>
> Since v1:
>   - send to related maillist, I press ENTER too quickly when sending v1
>   - remove the signal_pending() handling because that's covered by
>     generic guest entry infrastructure
>
> Jisheng Zhang (3):
>   RISC-V: KVM: Record number of signal exits as a vCPU stat
>   RISC-V: KVM: Use generic guest entry infrastructure
>   riscv: select HAVE_POSIX_CPU_TIMERS_TASK_WORK

I have queued this series for Linux-6.1

Thanks,
Anup

>
>  arch/riscv/Kconfig                |  1 +
>  arch/riscv/include/asm/kvm_host.h |  1 +
>  arch/riscv/kvm/Kconfig            |  1 +
>  arch/riscv/kvm/vcpu.c             | 18 +++++++-----------
>  4 files changed, 10 insertions(+), 11 deletions(-)
>
> --
> 2.34.1
>
