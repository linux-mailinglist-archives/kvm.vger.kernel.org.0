Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3584B4A571C
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 07:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbiBAGBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 01:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiBAGA5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 01:00:57 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E69C061714
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 22:00:57 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id g2so14367020pgo.9
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 22:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rj5HQhQyptq1prqqLiR0JYrAw/J6DdBaPhsGSRewuxA=;
        b=O2IqdcrI8j0Fqi0KLhNgLfYvcMZ+S5gfnYs5VGOXc+eq31DvL1WRmHgOcbuf3PNREL
         P6AZcPXN5ToMiFIcW6coJ7bhgKkYcUlVqxfDvGRyZo3aTU5AwV9eWsHLbUKVMUP12oyE
         sa+Iue/3E32CRtHwt5vVuAGaGg8JLCtk69eABQICMWUF2f5mVN6QMObTbPmPdd3u7wlH
         3O3W+bgX/B/R71yMf6doM+Ycw4bFIjy0jbZBgZl+oBW79vO2+3r2Eg1RcyI/ZohXHb4p
         LrmULTQvqy2unNtfUCmIQwwrOsi04Uv5uwi/vHFROe6v/+11rAdmK+TIs8Vtyie4n5mf
         LFdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rj5HQhQyptq1prqqLiR0JYrAw/J6DdBaPhsGSRewuxA=;
        b=SN6V607F5tHSg7iPKO380fzFLuswCw91uLMqCi2bzjZvVLkV5I7JVk+yq4g/WRCyNa
         mh+qdQovM4caxlUPyg1b0EhAJdAkg9AmjWxG7o9p+RvLzg+Du/R4JwbKrgU0EEXyattJ
         VtSaKilooPLDPi/ZYXjIpHf/Ahz03vVyWQdCOqtgfVJ2GAw0IJvIyFZPqEeKAr7cfjpZ
         zY5yYRlLvvkQ2B1zbGZy5aUOKxujN80aw0XvjFIL5OSS5QdAFyIQ16rtr/jj1rY6RKzH
         smlGqZhOFTVO0NvWO/UaGe3bjgk/7jjYxd5LiZocdJdWUEcsiZC2AmtMKYTpqBrXu7kF
         HMeQ==
X-Gm-Message-State: AOAM532WNYxKX/5kDJO38rTXJ29nyl2a7696xXFYEgU/YGFiJyTTSsKY
        eR+nzgP50FUSHLpWDWHY/c/QIf/TZt6tBqJWhvXmgg==
X-Google-Smtp-Source: ABdhPJx45aOEpU8XeKqNCF1T0wz5+DGu/Vk0J6PTyadiSbYSNQNorBZhyf+hidGFrdlNDTX4Oly9AlOgikkUK7Nr0OE=
X-Received: by 2002:aa7:95b2:: with SMTP id a18mr23381629pfk.39.1643695256681;
 Mon, 31 Jan 2022 22:00:56 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-3-reijiw@google.com>
 <YfDaiUbSkpi9/5YY@google.com> <CAAeT=FzNSvzz-Ok0Ka95=kkdDGsAMmzf9xiRfD5gYCdvmEfifg@mail.gmail.com>
 <CAOHnOrwBoQncTPngxqWgD_mEDWT6AwcmB_QC=j-eUPY2fwHa2Q@mail.gmail.com>
 <CAAeT=FyqPX_XQ+LDuRBZhApeiWD4s81bTMe=qiKDOZkBWm5ARg@mail.gmail.com> <YfdaKpBqFkULxgX/@google.com>
In-Reply-To: <YfdaKpBqFkULxgX/@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 31 Jan 2022 22:00:40 -0800
Message-ID: <CAAeT=Fw7Fr2=sWyMZ85Ky-rhQJ3WQTa8fE8tNDHinwFYm3ksBQ@mail.gmail.com>
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

On Sun, Jan 30, 2022 at 7:40 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Fri, Jan 28, 2022 at 09:52:21PM -0800, Reiji Watanabe wrote:
> > Hi Ricardo,
> >
> > > > > > +
> > > > > > +/*
> > > > > > + * Set the guest's ID registers that are defined in sys_reg_descs[]
> > > > > > + * with ID_SANITISED() to the host's sanitized value.
> > > > > > + */
> > > > > > +void set_default_id_regs(struct kvm *kvm)
> > > > > > +{
> > > > > > +     int i;
> > > > > > +     u32 id;
> > > > > > +     const struct sys_reg_desc *rd;
> > > > > > +     u64 val;
> > > > > > +
> > > > > > +     for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> > > > > > +             rd = &sys_reg_descs[i];
> > > > > > +             if (rd->access != access_id_reg)
> > > > > > +                     /* Not ID register, or hidden/reserved ID register */
> > > > > > +                     continue;
> > > > > > +
> > > > > > +             id = reg_to_encoding(rd);
> > > > > > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > > > > > +                     /* Shouldn't happen */
> > > > > > +                     continue;
> > > > > > +
> > > > > > +             val = read_sanitised_ftr_reg(id);
> > > > >
> > > > > I'm a bit confused. Shouldn't the default+sanitized values already use
> > > > > arm64_ftr_bits_kvm (instead of arm64_ftr_regs)?
> > > >
> > > > I'm not sure if I understand your question.
> > > > arm64_ftr_bits_kvm is used for feature support checkings when
> > > > userspace tries to modify a value of ID registers.
> > > > With this patch, KVM just saves the sanitized values in the kvm's
> > > > buffer, but userspace is still not allowed to modify values of ID
> > > > registers yet.
> > > > I hope it answers your question.
> > >
> > > Based on the previous commit I was assuming that some registers, like
> > > id_aa64dfr0,
> > > would default to the overwritten values as the sanitized values. More
> > > specifically: if
> > > userspace doesn't modify any ID reg, shouldn't the defaults have the
> > > KVM overwritten
> > > values (arm64_ftr_bits_kvm)?
> >
> > arm64_ftr_bits_kvm doesn't have arm64_ftr_reg but arm64_ftr_bits,
> > and arm64_ftr_bits_kvm doesn't have the sanitized values.
> >
> > Thanks,
>
> Hey Reiji,
>
> Sorry, I wasn't very clear. This is what I meant.
>
> If I set DEBUGVER to 0x5 (w/ FTR_EXACT) using this patch on top of the
> series:
>
>  static struct arm64_ftr_bits ftr_id_aa64dfr0_kvm[MAX_FTR_BITS_LEN] = {
>         S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_PMUVER_SHIFT, 4, 0),
> -       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x6),
> +       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x5),
>
> it means that userspace would not be able to set DEBUGVER to anything
> but 0x5. But I'm not sure what it should mean for the default KVM value
> of DEBUGVER, specifically the value calculated in set_default_id_regs().
> As it is, KVM is still setting the guest-visible value to 0x6, and my
> "desire" to only allow booting VMs with DEBUGVER=0x5 is being ignored: I
> booted a VM and the DEBUGVER value from inside is still 0x6. I was
> expecting it to not boot, or to show a warning.

Thank you for the explanation!

FTR_EXACT (in the existing code) means that the safe_val should be
used if values of the field are not identical between CPUs (see how
update_cpu_ftr_reg() uses arm64_ftr_safe_value()). For KVM usage,
it means that if the field value for a vCPU is different from the one
for the host's sanitized value, only the safe_val can be used safely
for the guest (purely in terms of CPU feature).

If KVM wants to restrict some features due to some reasons (e.g.
a feature for guests is not supported by the KVM yet), it should
be done by KVM (not by cpufeature.c), and  'validate' function in
"struct id_reg_info", which is introduced in patch-3, will be used
for such cases (the following patches actually use).

Thanks,
Reiji

>
> I think this has some implications for migrations. It would not be
> possible to migrate the example VM on the patched kernel from above: you
> can boot a VM with DEBUGVER=0x5 but you can't migrate it.
>
> Thanks,
> Ricardo
