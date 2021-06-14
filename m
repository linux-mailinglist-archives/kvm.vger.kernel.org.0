Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8673A5F67
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 11:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhFNJwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 05:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbhFNJwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 05:52:43 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F45C061766
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 02:50:28 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id 67-20020a4a01460000b0290245b81f6261so2503876oor.6
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 02:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ozeCrBWe056dvCFaSIn+YQtzRjUNyCG2jQsSBdsH6g=;
        b=K2qC92mVnZ7jUjofUEv4H+1w+qvltenXJMO5pP5zAQH9F9zzM6cma5PhaHyikSIE3D
         dgQc6WK4VWss1I8rQpcUAa+kknrISK1OThLKqPD0Ynu3YYr8NHxDjWdGBi55WyPUNLif
         i3JnBKWMJgfPTrRirLFRa8yVdEoj3gif50MFdkhnQ7QcHt3pdY8TR72cKPAlAymhZAhy
         fE+SeGXJkHhWdl5z0so4A3sE6OP4b04IsNaed/cw6QlyOjQcCpURRrlseuX+X6B4TqU1
         wFpbS04rbYoW9naTxekf9c4HpCWGlieaJNAtYseO4lXhzKvQiMv8Gd3ijQNtsUu8qwFY
         4JHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ozeCrBWe056dvCFaSIn+YQtzRjUNyCG2jQsSBdsH6g=;
        b=cBIrpHmJcV/N0esTT+js837tW13XdM6Ik8spRtI8YN51N1raQR5SwJOlveIICUN66E
         0VuaLa0BoS2w4HhCJGi9rvD+AkBkAjMckFrLJLtQyCIpBcrhZMOLzgoxUTu7TJawoqoi
         UZMSROBuBCbhr/N2LftRm+H0jDrPvdLbfHyXyLRrAU3lxXY8OA2a27xGrS5qrywW88vK
         XvPu7a2dmY2BxAQpKcihr96/YOkY9AU5shpM74bW5SNfLNrJ12c2Q5KKMaL5Qitf18NS
         tlqz/i3xjCFXCyWHGlRHaZJUmgwo4h8ieojm3m9wUip9oL8wJZlyUAM7LlumUmZoDs3k
         OciQ==
X-Gm-Message-State: AOAM530yogfzargkxe1JeyeCQYw2Hc+2lTh5z/R3W0MaIwKpGCNEFNIa
        Dvzdxnx4qGhgNdEN+scUBwTxznyDf5BRkwTOdIcI/A==
X-Google-Smtp-Source: ABdhPJyJwQ95jW5MLr7rUkCdRFLkVYE33n19WoUneoHj3ZP6RKTjyoGOcQr4wTLfnQTTpVHh3eZs+F2r0ncYGstNVYw=
X-Received: by 2002:a4a:5482:: with SMTP id t124mr12435372ooa.42.1623664227170;
 Mon, 14 Jun 2021 02:50:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210614025351.365284-1-jingzhangos@google.com> <20210614025351.365284-2-jingzhangos@google.com>
In-Reply-To: <20210614025351.365284-2-jingzhangos@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 14 Jun 2021 10:49:50 +0100
Message-ID: <CA+EHjTybUkOVVByL5r_MwLfzc_aaPybY8AzdCLYmS8aiR-RkSA@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: stats: Make sure no missing or mismatched binary
 stats definition
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

On Mon, Jun 14, 2021 at 3:53 AM Jing Zhang <jingzhangos@google.com> wrote:
>
> Add static check to make sure the number of stats descriptors equals
> the number of stats defined in vm/vcpu stats structures.
> Add offset field in stats descriptor to let us define stats
> descriptors freely, don't have to be in the same order as
> stats in vm/vcpu stats structures.
> Also fix some missing/mismatched stats from previous patch.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>

I tested this for arm64, and it does assert if there's a mismatch. I
couldn't find any missing statistics under any of the architectures
either.

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 5e77f32abef5..692af9177c9f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1296,119 +1296,152 @@ struct _kvm_stats_desc {
>         { n, offsetof(struct kvm_vcpu, stat.generic.x),                        \
>           KVM_STAT_VCPU, ## __VA_ARGS__ }
>
> -#define STATS_DESC(stat, type, unit, base, exp)                               \
> +#define STATS_DESC_COMMON(type, unit, base, exp)                              \
> +       .flags = type | unit | base |                                          \
> +           BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |                   \
> +           BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |                   \
> +           BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),                    \
> +       .exponent = exp,                                                       \
> +       .size = 1
> +

nit: you seem to be mixing tabs and spaces here

> +#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp)                    \
>         {                                                                      \
>                 {                                                              \
> -                       .flags = type | unit | base |                          \
> -                           BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |   \
> -                           BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |   \
> -                           BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),    \
> -                       .exponent = exp,                                       \
> -                       .size = 1                                              \
> +                       STATS_DESC_COMMON(type, unit, base, exp),              \
> +                       .offset = offsetof(struct kvm_vm_stat, generic.stat)   \
>                 },                                                             \
> -               .name = stat,                                                  \
> +               .name = #stat,                                                 \
>         }

nit: also here, mixing of tabs and spaces

Tested-by: Fuad Tabba <tabba@google.com> #arm64
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad
