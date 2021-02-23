Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34903227FD
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 10:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhBWJpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 04:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbhBWJor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 04:44:47 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECFFC06178A
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 01:44:07 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id n14so16423192iog.3
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 01:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JdsAw7/h4oboN/mNZWenmJqgLQu48+ys8E7jatHzI40=;
        b=puP4kCuFBTo4v5DZgeEJWwQTGfOd7XkA27KZA4hQlu3hZHrqqSMbPiOMp43dA9ZklD
         7/zp1hsnkE/ICFEoYgwACZK8M3iyXtvougYwA2yUfVEduBDH5Pik7MGMloLRaURIuWgI
         boqjpT80BC6CT2uXNTxnnJ1SdnZsn2BXh3v9LutgLhtjEFIYxUoEaTZXh/XBcsugeyJ2
         bbtBDGYcXJvU3Gl37zdWSTfqYGc4saEW5WjRDVooGTgcPY36SXpvsJucUSACU7sZ1lf+
         6OmCKY88AsekH1kCYT6TK47LeRR/OAsfFKpKNrV4SgsT2A52fSNDI43ix3W44/Lk78/T
         UD7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JdsAw7/h4oboN/mNZWenmJqgLQu48+ys8E7jatHzI40=;
        b=B4xpZeYYqalwx4Z6HwEAPQGNsXhc3MAOJ44fSh3WGu1rFn8nhIlyVvCS/g075uKvLs
         1OxLU8DRpmWF6dQVD9KxXi1pmTJ/7Yph/K7AUhIHwzDVB0wjowpXHdMMLSai3zes++MY
         ZlmGROdtSIAx1DG8YMpMQv5EhV5M73YKxsOoAjy74eVSmIXt+5BgNcGOMgiAwp+SpMea
         gdisHlbV7EONZu3T8tHN0iul3GyfZqbcfNBHZoB7rO1K2joAfKw5/W0LlUQdK/I/nYV1
         UIDy4Mt9aJp5Jz9wDeQRZMObVkki0jDUEnr/VRYd7ILA+JGzdVzDEQWZzQeK4FLBwDw5
         3g7w==
X-Gm-Message-State: AOAM530qf6DgIUYhWygFuWmdsQQALSCJzP2jefOk0foRaa35iBAjVzwR
        heRBdbk7RhMJ43xtMIxNTFe/blTcQqwi3pGyIS60
X-Google-Smtp-Source: ABdhPJxu7RAynJq/1YTWqpI2BlKM2eHwZ1Ujeu1UDzeF/fK9xbZydWwxuIQobx87wJ9t28WDVeFaIgtnt7UTDt91xHA=
X-Received: by 2002:a5e:9612:: with SMTP id a18mr18931244ioq.13.1614073446969;
 Tue, 23 Feb 2021 01:44:06 -0800 (PST)
MIME-Version: 1.0
References: <20201210160002.1407373-1-maz@kernel.org> <CAJc+Z1FQmUFS=5xEG8mPkJCUZ+ecBt4G=YbxGJTO4YFbfGMg3w@mail.gmail.com>
 <CAJc+Z1HE2oFWM8oerrM_3VDNuTOoc3D1Ao7sB2tYj7n6doNBbA@mail.gmail.com> <87blcis5ua.wl-maz@kernel.org>
In-Reply-To: <87blcis5ua.wl-maz@kernel.org>
From:   Haibo Xu <haibo.xu@linaro.org>
Date:   Tue, 23 Feb 2021 17:43:54 +0800
Message-ID: <CAJc+Z1HUeetx=7xm_U5S2Ay9GC5X93S6wh5LshvzKy1ZpVovFw@mail.gmail.com>
Subject: Re: [PATCH v3 00/66] KVM: arm64: ARMv8.3/8.4 Nested Virtualization support
To:     Marc Zyngier <maz@kernel.org>
Cc:     arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>, kvm@vger.kernel.org,
        kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Feb 2021 at 06:10, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 04 Feb 2021 07:51:37 +0000,
> Haibo Xu <haibo.xu@linaro.org> wrote:
> >
> > Kindly ping!
> >
> > On Thu, 21 Jan 2021 at 11:03, Haibo Xu <haibo.xu@linaro.org> wrote:
> > >
> > > Re-send in case the previous email was blocked for the inlined hyper-link.
> > >
> > > Hi Marc,
> > >
> > > I have tried to enable the NV support in Qemu, and now I can
> > > successfully boot a L2 guest
> > > in Qemu KVM mode.
> > >
> > > This patch series looks good from the Qemu side except for two minor
> > > requirements:
> > > (1) Qemu will check whether a feature was supported by the KVM cap
> > > when the user tries to enable it in the command line, so a new
> > > capability was prefered for the NV(KVM_CAP_ARM_NV?).
>
> I have added KVM_CAP_ARM_EL2 (rather than NV) to that effect.
>
> > > (2) According to the Documentation/virt/kvm/api.rst, userspace can
> > > call KVM_ARM_VCPU_INIT multiple times for a given vcpu, but the
> > > kvm_vcpu_init_nested() do have some issue when called multiple
> > > times(please refer to the detailed comments in patch 63)
>
> This is now fixed, I believe.
>
> I have pushed out a branch [1] that addresses all the reported
> issues, though it currently lack some testing. Please let me know if
> it works for you.
>

Hi Marc,

I have verified the fix, and it works well with Qemu.

thanks,
Haibo

> Thanks,
>
>         M.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-5.12-WIP
>
> --
> Without deviation from the norm, progress is not possible.
