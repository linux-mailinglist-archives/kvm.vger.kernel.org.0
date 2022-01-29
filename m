Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D1C4A2C0A
	for <lists+kvm@lfdr.de>; Sat, 29 Jan 2022 06:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238600AbiA2Fwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Jan 2022 00:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbiA2Fwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Jan 2022 00:52:38 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33358C061714
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 21:52:38 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id i30so8083584pfk.8
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 21:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l6hkYLQY0UCA5be7Mdwd+JiBebqPxJBCfUkmLUP1xhY=;
        b=L6UsPboR4n47sCBNGg/CpG3bNJHiQ1+mWJ3JNZZp3A86D9DwCFD2eJbDGtnJHHAVYY
         TGWz7PTtCxd23ANfsshxJYtcN99/rBMjPgNET8VcAimKP6hOPdMU6bsjx0WyyeRF46+2
         ph0rvOwNxbTE6BE/umr7YKENHEmlsBuq96/DurhHt3D1LS0OMET7/k3LVsUil4Yj5kPT
         aHm/OJI+M+MluufgBAg3SXlJKr0rgeSH/7PfqbTFu9rtI2IUNq7QgUorm6a1yd9Bl+m1
         Y+YI7NIvwdfAozaXGCLquTLLZbxvE84WcP4O1ygSgndmd1sUxcfvUowbuvZ9PQcTvdzg
         Wh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l6hkYLQY0UCA5be7Mdwd+JiBebqPxJBCfUkmLUP1xhY=;
        b=iyq0vGdbxFtIfB8Ob2N9rez6Wbacfb8vlnz0D/LDzKiltsAkq16gUuRIprI/wvOVow
         nhfOnIBn4kI8KKu2cS9BG/WqqzjAkXdsreOfNd4TAe5lZturab+I+06NgRoGkF2V0WeP
         rSgp5q8PiC2QiaK+pJiJM/squ5Mp+B3BIGLAaa6UPzigTGLI3qhdinsCNr2n4ZxKZS4T
         TLEkzpLS0XgoILeDNzoVeWk+giYP6C4MLQh43OukLmwz/5deOVmzGas4W9NQyIWENI5j
         uLJJu6aTGV+BpPAVUMwwWdSfyGY4OTG/rcrCqYOwQyxJ1K+1V2B8tA5HU9XoxHjny1j4
         pcvw==
X-Gm-Message-State: AOAM533aQrHqDQThKX2omeVCJNu7P/hxLjuFooV2WzQ/l2I9k069IJSm
        BZ7RbsyQSSar5di9lp54TpF2bdsDJn+voMAHMTNHwg==
X-Google-Smtp-Source: ABdhPJxhT2S1yun+rYZwdqcoyg3XJchS0/6aFbHnaj6sCBRUYYYt5fH3tZD/5jSKbjVwrJZXzYV51QvKN5olPkqQ1wI=
X-Received: by 2002:a05:6a00:98e:: with SMTP id u14mr11484137pfg.12.1643435557410;
 Fri, 28 Jan 2022 21:52:37 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-3-reijiw@google.com>
 <YfDaiUbSkpi9/5YY@google.com> <CAAeT=FzNSvzz-Ok0Ka95=kkdDGsAMmzf9xiRfD5gYCdvmEfifg@mail.gmail.com>
 <CAOHnOrwBoQncTPngxqWgD_mEDWT6AwcmB_QC=j-eUPY2fwHa2Q@mail.gmail.com>
In-Reply-To: <CAOHnOrwBoQncTPngxqWgD_mEDWT6AwcmB_QC=j-eUPY2fwHa2Q@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 28 Jan 2022 21:52:21 -0800
Message-ID: <CAAeT=FyqPX_XQ+LDuRBZhApeiWD4s81bTMe=qiKDOZkBWm5ARg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 02/26] KVM: arm64: Save ID registers' sanitized
 value per guest
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

> > > > +
> > > > +/*
> > > > + * Set the guest's ID registers that are defined in sys_reg_descs[]
> > > > + * with ID_SANITISED() to the host's sanitized value.
> > > > + */
> > > > +void set_default_id_regs(struct kvm *kvm)
> > > > +{
> > > > +     int i;
> > > > +     u32 id;
> > > > +     const struct sys_reg_desc *rd;
> > > > +     u64 val;
> > > > +
> > > > +     for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> > > > +             rd = &sys_reg_descs[i];
> > > > +             if (rd->access != access_id_reg)
> > > > +                     /* Not ID register, or hidden/reserved ID register */
> > > > +                     continue;
> > > > +
> > > > +             id = reg_to_encoding(rd);
> > > > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > > > +                     /* Shouldn't happen */
> > > > +                     continue;
> > > > +
> > > > +             val = read_sanitised_ftr_reg(id);
> > >
> > > I'm a bit confused. Shouldn't the default+sanitized values already use
> > > arm64_ftr_bits_kvm (instead of arm64_ftr_regs)?
> >
> > I'm not sure if I understand your question.
> > arm64_ftr_bits_kvm is used for feature support checkings when
> > userspace tries to modify a value of ID registers.
> > With this patch, KVM just saves the sanitized values in the kvm's
> > buffer, but userspace is still not allowed to modify values of ID
> > registers yet.
> > I hope it answers your question.
>
> Based on the previous commit I was assuming that some registers, like
> id_aa64dfr0,
> would default to the overwritten values as the sanitized values. More
> specifically: if
> userspace doesn't modify any ID reg, shouldn't the defaults have the
> KVM overwritten
> values (arm64_ftr_bits_kvm)?

arm64_ftr_bits_kvm doesn't have arm64_ftr_reg but arm64_ftr_bits,
and arm64_ftr_bits_kvm doesn't have the sanitized values.

Thanks,
Reiji
