Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD3064169F
	for <lists+kvm@lfdr.de>; Sat,  3 Dec 2022 13:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiLCMTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Dec 2022 07:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiLCMTJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Dec 2022 07:19:09 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FFB1D644
        for <kvm@vger.kernel.org>; Sat,  3 Dec 2022 04:19:08 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id o13so17353377ejm.1
        for <kvm@vger.kernel.org>; Sat, 03 Dec 2022 04:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VJ2kBMQnTepOO13Yg4zjy23GC+GH4PK0ByMWiXCv1l0=;
        b=EelzAQi3ycgYepqgRvsBBEs+oyuo1oGZME9colgRqhzm23WFvFS9xLfmZ8oRofI4T9
         tG76KxqFYz67nxCILvi6RtIGKP9Y1mAooEB8cQcY9PAYt0IVg6NcyQ0qYKS7WgEgRsQe
         jLW7ZzdtpjL7iwQeN8jZOZ6MGHWYfCVTz+1Jr5CL4xp9LHnkh1Sx6e356qHRyRQ9QMjw
         j2GjAK844p3DdwnenZfa/u90h73CeajspKfPG88u4eOK4ePvYcAvA8h1ra1qe12w2EAA
         /iB35lWi++12T+9Y2PnnsmQVXr8D5ARFQNAXIWK/hCMYNOOfaQ8i3sU9tz4r+zZHqIgZ
         w2ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VJ2kBMQnTepOO13Yg4zjy23GC+GH4PK0ByMWiXCv1l0=;
        b=z7IVGN/hqvvXY8Qbrj7+vmj0hnIjI3isN1SR2+uzrNBkIH0W5/5OzTzxZ72Svg/kBZ
         0IXmLsq1OEHl5g2qjbpOpmK0l4QxfFn4BJt/RJWLEmUt1KwVmkt4QqIwqxxVjxt29mKV
         Pqd6LXb6FOprK//gdBRYAk25Fyd2xA5YjzirTL2mU7dRAYETn2RQcaUy+X+zNT1rdiQ0
         m2AeiR4gVSkcHMyAnTNBIjUvrhwJNizaQguPVn59ip6xEkkURMB2UWEQjIFbNWr6UNoX
         lTnlu8zVdRUHsTR6hQleg131jqCaHZbbMi5YBH1DN1rjJQjvX/jNekuth/37ygJ2J5QU
         To1w==
X-Gm-Message-State: ANoB5plLOUGEpk4VQWuIG+jlcM78InttLyHejCsch93xANPmjf0aSaw8
        1lPJusmoHmdp5o3Dk4QnOgsBe8KivrvOnld7CVgG+CV80djZ0Qkl
X-Google-Smtp-Source: AA0mqf42U73DS4TfDbhqtcz7mgFaF9usPI8rxDs5j07XpjMEhRSkYS6lYQXtiByWoSeu+cChyKsuwtNQAO6afy9uE+o=
X-Received: by 2002:a17:906:6dd5:b0:78d:a633:b55 with SMTP id
 j21-20020a1709066dd500b0078da6330b55mr66234095ejt.106.1670069947041; Sat, 03
 Dec 2022 04:19:07 -0800 (PST)
MIME-Version: 1.0
References: <20221128161424.608889-1-apatel@ventanamicro.com>
 <20221128161424.608889-9-apatel@ventanamicro.com> <20221129054616.4zju5z7ipg6wki7l@kamzik>
In-Reply-To: <20221129054616.4zju5z7ipg6wki7l@kamzik>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 3 Dec 2022 17:48:54 +0530
Message-ID: <CAAhSdy3CnkK7=zombN4zH=g8+buz_rEhgXCzOE-WdSTYtcfdMA@mail.gmail.com>
Subject: Re: [PATCH 8/9] RISC-V: KVM: Add ONE_REG interface for mvendorid,
 marchid, and mimpid
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29, 2022 at 11:16 AM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Mon, Nov 28, 2022 at 09:44:23PM +0530, Anup Patel wrote:
> > We add ONE_REG interface for VCPU mvendorid, marchid, and mimpid
> > so that KVM user-space can change this details to support migration
> > across heterogeneous hosts.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/uapi/asm/kvm.h |  3 +++
> >  arch/riscv/kvm/vcpu.c             | 27 +++++++++++++++++++++++++++
> >  2 files changed, 30 insertions(+)
> >
> > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> > index 8985ff234c01..92af6f3f057c 100644
> > --- a/arch/riscv/include/uapi/asm/kvm.h
> > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > @@ -49,6 +49,9 @@ struct kvm_sregs {
> >  struct kvm_riscv_config {
> >       unsigned long isa;
> >       unsigned long zicbom_block_size;
> > +     unsigned long mvendorid;
> > +     unsigned long marchid;
> > +     unsigned long mimpid;
> >  };
> >
> >  /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 312a8a926867..7c08567097f0 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -276,6 +276,15 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
> >                       return -EINVAL;
> >               reg_val = riscv_cbom_block_size;
> >               break;
> > +     case KVM_REG_RISCV_CONFIG_REG(mvendorid):
> > +             reg_val = vcpu->arch.mvendorid;
> > +             break;
> > +     case KVM_REG_RISCV_CONFIG_REG(marchid):
> > +             reg_val = vcpu->arch.marchid;
> > +             break;
> > +     case KVM_REG_RISCV_CONFIG_REG(mimpid):
> > +             reg_val = vcpu->arch.mimpid;
> > +             break;
> >       default:
> >               return -EINVAL;
> >       }
> > @@ -338,6 +347,24 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
> >               break;
> >       case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
> >               return -EOPNOTSUPP;
> > +     case KVM_REG_RISCV_CONFIG_REG(mvendorid):
> > +             if (!vcpu->arch.ran_atleast_once)
> > +                     vcpu->arch.mvendorid = reg_val;
> > +             else
> > +                     return -EBUSY;
> > +             break;
> > +     case KVM_REG_RISCV_CONFIG_REG(marchid):
> > +             if (!vcpu->arch.ran_atleast_once)
> > +                     vcpu->arch.marchid = reg_val;
> > +             else
> > +                     return -EBUSY;
> > +             break;
> > +     case KVM_REG_RISCV_CONFIG_REG(mimpid):
> > +             if (!vcpu->arch.ran_atleast_once)
> > +                     vcpu->arch.mimpid = reg_val;
> > +             else
> > +                     return -EBUSY;
> > +             break;
> >       default:
> >               return -EINVAL;
> >       }
> > --
> > 2.34.1
> >
>
> At some point we should patch Documentation/virt/kvm/api.rst to describe
> the possible errors we have. It's missing EOPNOTSUPP and EBUSY.
>
> Also, I see a couple places were we use EOPNOTSUPP that would be better
> as EBUSY. And finally I wonder if we shouldn't use ENOENT when the reg_num
> is wrong/unknown, which would allow us to differentiate between bad
> reg_num and bad reg_val in set-one ioctls.
>
> I can send an RFC series to better describe these thoughts.

Sure, go ahead.

>
> And for this patch,
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>
> Thanks,
> drew

Regards,
Anup
