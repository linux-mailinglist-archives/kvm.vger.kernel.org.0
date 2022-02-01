Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEDD4A5E06
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 15:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239121AbiBAOOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 09:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239105AbiBAOO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 09:14:29 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F08DC061714
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 06:14:29 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id 4so9048285oil.11
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 06:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1hzC5kA94MkC0GLnHZxQLOF3z9T2okGq6QSaPNCp6Bs=;
        b=L2rrAtc5Bxp1kiX/SmSs9h7mN4kqGARLQxGoLX7jPAkXCmRSfJBQH5H0sBqdQlsgE5
         Og1UXoJb/lM+neYYXkS628jfo8p7TU1oQGNmBzw9MOB1AGiMuTh2Rl7Dmt0eE/WE7fqK
         KHQ1cX/6w79LsiyETQ8xapa+MEdHkJGtRxJISJc53WMvb5ycMhRPfDG2+gQ+Kvny+dP2
         tnal53P+Se0y2F+vdwm3H3S7k3T37KHiD0w4nJfzGZnf2ctfncFrYWFHU17whfIU4FX0
         y2U+Kcs+cRj/cZrZ2PeI35Wamsky4mnF61gWO/zgnjLZ1QggLCtFQ47yZOwBSlxJiEKM
         DKDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1hzC5kA94MkC0GLnHZxQLOF3z9T2okGq6QSaPNCp6Bs=;
        b=iEPtG1kvtipcC+o8DRjInzuFHFMrVMw8gmyfDEOSkLm6dLu/9//3AdwYs489M8xotf
         xqiNVainTC6YXriC/0p0jSKMU1Cadgsl3++BbLmRnK5QCMLC+BbjGPkI2fiPSakKVbJo
         Ke/lDc91VMUEWG5limhTJRPKF6ChNXmAklN486LKESspUWVvVQho1J/8sIvVde3Oz3Qp
         RIybB0WFr95x2OpsCg6bfCJdIJtieguTZScU5WbNgQzLnW3nBLmTKhhMhYkKrOwiL6uw
         YJtxF47RPkuL4uxBjC6c336GBjLnfZrVgWNWytCeoEXnV4G0onEOyCXlxStPDSiwm6RJ
         C6FQ==
X-Gm-Message-State: AOAM532DEkO6DLH9u2Ast31F7ccSLNHUd6Y5rSdJCItRufvBKD5+06ir
        gRdcjF0oS8BT+NBRixkA8qP32VSTYXDKK21hDOpYEg==
X-Google-Smtp-Source: ABdhPJyc+gLrzhK5McV1s3POSFDxJ0vZgQau3r0WA3lSzrJGO3Z4Wz+mvnT9IX4AKiE4COwrk9DKb/JyvxPHTu676A0=
X-Received: by 2002:a05:6808:2394:: with SMTP id bp20mr1251698oib.171.1643724868554;
 Tue, 01 Feb 2022 06:14:28 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-4-reijiw@google.com>
 <CA+EHjTx65scqNVvHci6fge7C5qQ=fiqqHKGwOvOKySQwsCy8Jg@mail.gmail.com> <CAAeT=Fzi2JSuVGijM0x7_w8osRWMFUupz3r10NduO6r5hN+HKw@mail.gmail.com>
In-Reply-To: <CAAeT=Fzi2JSuVGijM0x7_w8osRWMFUupz3r10NduO6r5hN+HKw@mail.gmail.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Tue, 1 Feb 2022 14:13:52 +0000
Message-ID: <CA+EHjTws=ie4XoSBdR3WO4q+A6Q3H1zZ9fq+s90GNbswx+aEaQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 03/26] KVM: arm64: Introduce struct id_reg_info
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

...


> > > @@ -2862,11 +3077,12 @@ void set_default_id_regs(struct kvm *kvm)
> > >         u32 id;
> > >         const struct sys_reg_desc *rd;
> > >         u64 val;
> > > +       struct id_reg_info *idr;
> > >
> > >         for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> > >                 rd = &sys_reg_descs[i];
> > >                 if (rd->access != access_id_reg)
> > > -                       /* Not ID register, or hidden/reserved ID register */
> > > +                       /* Not ID register or hidden/reserved ID register */
> > >                         continue;
> > >
> > >                 id = reg_to_encoding(rd);
> > > @@ -2874,7 +3090,8 @@ void set_default_id_regs(struct kvm *kvm)
> > >                         /* Shouldn't happen */
> > >                         continue;
> > >
> > > -               val = read_sanitised_ftr_reg(id);
> > > -               kvm->arch.id_regs[IDREG_IDX(id)] = val;
> > > +               idr = GET_ID_REG_INFO(id);
> > > +               val = idr ? idr->vcpu_limit_val : read_sanitised_ftr_reg(id);
> > > +               (void)write_kvm_id_reg(kvm, id, val);
> >
> > Rather than ignoring the return value of write_kvm_id_reg(), wouldn't
> > it be better if set_default_id_regs were to propagate it back to
> > kvm_arch_init_vm in case there's a problem?
>
> Since write_kvm_id_reg() should never return an error for this
> case, returning an error to kvm_arch_init_vm() adds a practically
> unnecessary error handling, which I would like to avoid.
> So, how about putting WARN_ON_ONCE on its return value ?

I think this makes sense in this case.

Thanks,
/fuad

> Thanks,
> Reiji
