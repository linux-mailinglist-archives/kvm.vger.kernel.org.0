Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F5150E6A2
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 19:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241920AbiDYRPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 13:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbiDYRPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 13:15:50 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA7313DD7
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 10:12:45 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id q185so9479903ljb.5
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 10:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N7fee2Yrx0qNzoi9PdXZ5hx4nrnlVdrW/GV2fmMxG2M=;
        b=acRadtvAlYLUZrCmq9O5iI5dPYliXwwNI96yUgxN2vvYnQyHFYWbIq3YSk6wxSOnDA
         GX9RTiQdnHyQtA4OQ7FAx/eRuBe2F7nW7K20QiBw/g4p0zT/aDNIb6GoMhyOYCqluUsp
         w966oKCZq/KG44LRlyljtZupZ4wx32aOVe7+Hy5Wp+N7xnx+tccplGXtnJVAGCdgqJyB
         1sBDmWynVnSD+y20tg/j5uLrhve94nndrnKPQyKku8wVj2d2fT/EX/EyAnZIXYqJGaZp
         x6AKN+qlvspopkwCnb+v9+yZhH/oDM5Srj9sWSLPXfpmXjBom7/BSqtbI/xONPkGOToT
         8cJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N7fee2Yrx0qNzoi9PdXZ5hx4nrnlVdrW/GV2fmMxG2M=;
        b=K9Q+DCRKgWK5acCSoT7VJOJ5kMqlvmwpLaTGi5E7aVeg09L9BtK0+FoGE2BjUnMpQ9
         J3Xarjvv71ArtODkERRq1N4yJvgXaJFNq/2CWwy33gxOw5tp6X1wTzsf5xC7C9NCZS3C
         3dp4d+Wc52xwtFSN5JnUDCuCIY6QW/1DjG4gUNb9YQYhNiefNmqgw0jacjt8QQNv28V4
         xRZuG8yQVE5z+iaKkz3NUDs3W1qhmWzDDH50PG3ONMishONAo652iud5Po3r2xPzuO0V
         4LL3k2ysssVLMr7ZLNqYfY+d0dFMyUmVBWbHL/WzkaoeOyJz85yr8PUnjNXBshlpT4UX
         dfSQ==
X-Gm-Message-State: AOAM5326B97+jyGihRmz9D5jZqeO/V7+vhLo13jGIKW12cMpQuLbUGz4
        LBJXX9ukBp9rV1rjR43AkHirDrtNwFbgzVdK8dbGmg==
X-Google-Smtp-Source: ABdhPJxUrJi15zmGDPYrRdXhEhm6WWYpITF+DKeRbw52izZPXspEXizuIrsiftQCpGs1t6FoJos6DDldjOwxUQ8ZRFY=
X-Received: by 2002:a2e:5c6:0:b0:24f:5bd:5f89 with SMTP id 189-20020a2e05c6000000b0024f05bd5f89mr7433707ljf.170.1650906763210;
 Mon, 25 Apr 2022 10:12:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com> <20220423000328.2103733-5-rananta@google.com>
 <CAAeT=Fyc3=uoOdeXrLKfYxKtL3PFV0U_Bwj_g+bca_Em63wGhw@mail.gmail.com> <CAJHc60zR4Pa=y-Y4Dp27FoAvqpBrONCN727KbnhSoxNGRiBGuA@mail.gmail.com>
In-Reply-To: <CAJHc60zR4Pa=y-Y4Dp27FoAvqpBrONCN727KbnhSoxNGRiBGuA@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 25 Apr 2022 10:12:32 -0700
Message-ID: <CAOQ_QsjFtyy1AFq5c-jLSY-r9fWEL4H5fuKNbt9QcFirnU2wmg@mail.gmail.com>
Subject: Re: [PATCH v6 4/9] KVM: arm64: Add vendor hypervisor firmware register
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 25, 2022 at 9:52 AM Raghavendra Rao Ananta
<rananta@google.com> wrote:

[...]

> > > +#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX    1
> >
> > Nit: IMHO perhaps it might be more convenient to define the MAX macro
> > in arch/arm64/include/uapi/asm/kvm.h like below for maintenance ?
> > (The same comments are applied to other KVM_REG_ARM_*_BMAP_BIT_MAX)
> >
> > #define KVM_REG_ARM_VENDOR_HYP_BIT_MAX KVM_REG_ARM_VENDOR_HYP_BIT_PTP
> >
> We have been going back and forth on this :)
> It made sense for me to keep it in uapi as well, but I took Oliver's
> suggestion of keeping it outside of uapi since this is something that
> could be constantly changing [1].

The maximum set of features in a given bitmap register is a property
of the running system, not the headers chosen at compile time. There
is an illusion of ABI breakage when adding new bits to the registers
if we've declared the max bit in UAPI. We also define
KVM_VCPU_MAX_FEATURES outside of UAPI, even though it is related to
the KVM_ARM_VCPU_INIT ioctl.

--
Thanks,
Oliver
