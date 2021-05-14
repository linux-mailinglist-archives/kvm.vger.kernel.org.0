Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA4238067E
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 11:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhENJv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 05:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhENJv6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 05:51:58 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF4FC061574;
        Fri, 14 May 2021 02:50:46 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id a11so27567675ioo.0;
        Fri, 14 May 2021 02:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pLzrBtO1gQwFkCLdLSh3i2l9ImIcdooh5mscm5IsPX4=;
        b=Dt31hvVBPkS+h0JDCJLjRonzSMn+esichlQQs21ECAHfPtffMcQopvUz745Ejeg7qR
         EGnvuJSSRypRTUK6+EXUvdqBKy/CgvVb2J7gpZRaHjlQOCtp1z8C9nmkVJtZKt6vdH4Y
         GtHgxRGseoLq4RcD0RhKAHhbqvIirNd2hUOHwS0N+A4J9QeUb3FYDysNRB55OfbBjAJd
         imIPS+9IGowgiBIhtDzwpB888MCAc60Dh0WmZ/rTIVo9pKuLA1v9ofUyc5JXSNspYEOS
         H3G9vttB4lfxs+AdpV90uiGgntfRRCdvZ3OTPE/0Dm/67eN13CsyvqyUcGTdZfmGXTq3
         7E6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pLzrBtO1gQwFkCLdLSh3i2l9ImIcdooh5mscm5IsPX4=;
        b=k7rnHhsvDPO0Qvd3hHLk3IvGZ88t+MO9FCEdvcxCQhJ4GqsTmpTOG/LI9uWUzkayID
         3OA3yVVNln152GrTKzM9g7djyHb+4UOtEUpcMKmYyvmfHDUECCkRmHGQV9qz7BYqhvz6
         1Md0lBasuWgPnUfQb/GELFKO2yavC1ZPmptFJBf2IikXZFq48rkbTa77efXVIh4b6K15
         JUWQq4q54oPV5fYGgPYLtgse3ZYJxuN5mEiExB+lhhNCloRl5Hv9+6WvywnHTJB5YRtv
         wOaPDTcHNviOYlcUhN6gv1vxVSEKXSp6Dv0n0Fa/H8OqRxCCVkM9Mbozu0K0PBNzzFoX
         803A==
X-Gm-Message-State: AOAM5312VMymOEwv036eLuqcwq44G9xhTXqVEp/pK8hqn2nIfPf6WuFl
        qywp/hCXoMu6BkJ8Z3KLLT7gHmSoYfw06SLpKY4=
X-Google-Smtp-Source: ABdhPJy1Z6wOsZ16XloAXzALFt0MoJUMEFQg2VQ7o1K/o96Y3mDZlnnOj1Uivnki+pZlLxHYIddtbj+pM+6QAGbJldE=
X-Received: by 2002:a5e:8305:: with SMTP id x5mr33454798iom.112.1620985846256;
 Fri, 14 May 2021 02:50:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210406024911.2008046-1-chenhuacai@loongson.cn>
In-Reply-To: <20210406024911.2008046-1-chenhuacai@loongson.cn>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Fri, 14 May 2021 17:50:35 +0800
Message-ID: <CAAhV-H6LBsZkJq8DCtZM1Haa+9TU2CYWAksciiv3s0poHABFLQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: MIPS: Remove a "set but not used" variable
To:     Huacai Chen <chenhuacai@loongson.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping

On Tue, Apr 6, 2021 at 10:48 AM Huacai Chen <chenhuacai@loongson.cn> wrote:
>
> This fix a build warning:
>
>    arch/mips/kvm/vz.c: In function '_kvm_vz_restore_htimer':
> >> arch/mips/kvm/vz.c:392:10: warning: variable 'freeze_time' set but not used [-Wunused-but-set-variable]
>      392 |  ktime_t freeze_time;
>          |          ^~~~~~~~~~~
>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>  arch/mips/kvm/vz.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index d0d03bddbbba..e81dfdf7309e 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -388,7 +388,6 @@ static void _kvm_vz_restore_htimer(struct kvm_vcpu *vcpu,
>                                    u32 compare, u32 cause)
>  {
>         u32 start_count, after_count;
> -       ktime_t freeze_time;
>         unsigned long flags;
>
>         /*
> @@ -396,7 +395,7 @@ static void _kvm_vz_restore_htimer(struct kvm_vcpu *vcpu,
>          * this with interrupts disabled to avoid latency.
>          */
>         local_irq_save(flags);
> -       freeze_time = kvm_mips_freeze_hrtimer(vcpu, &start_count);
> +       kvm_mips_freeze_hrtimer(vcpu, &start_count);
>         write_c0_gtoffset(start_count - read_c0_count());
>         local_irq_restore(flags);
>
> --
> 2.27.0
>
