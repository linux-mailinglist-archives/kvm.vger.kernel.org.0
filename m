Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF7C7CC910
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 18:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbjJQQtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 12:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbjJQQtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 12:49:22 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF04EED
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 09:49:20 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1c9c145bb5bso1585ad.1
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 09:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697561360; x=1698166160; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lbOnMkAmys4ATC1jemLgDhyPYnDB7jZJzNIoSnmf3pM=;
        b=0MlnR9pSqpGABMZCepnMMmTm1gy7ENMSm68zmr4+HVzNdosZ4NR14K7cWf+J1Ep7eH
         x1qLn6urc5oEimxUWg6bFtaIsqJ2oDaRp8u1DlSpI53grKVcfCz047VYox3nKZcrFt/d
         TrYe3qQPV9TrxoaNbMdrWOHPqL7tjZ0ct4dL+zmK9vrBdi7w/rJs/eM90BixrkwMXv1F
         PN09J1OgrU9pek3UX/oWTSHn4xyCEW8r55hKBhZizPsuo1PeE11d2AHy1B1apLfZXDOp
         dwStLSMcP40AHM0PhL89ywTO3AbjfHb9dfGqcj5KBn273ZxV4fT5Fi33KlsMitceQOxa
         4nbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697561360; x=1698166160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lbOnMkAmys4ATC1jemLgDhyPYnDB7jZJzNIoSnmf3pM=;
        b=M8ZWpfWXIcltsRIQe0L5jr438rB6vbAmdfVpxxQLHyhe/6DL9As+klqPzY7Ab9Vjzd
         NDab8gtIFnKmjztwnSrtaGV/qdXwbtVANkV3OTzQ6P8VLOdt/NE+xmyhLlUsYLkSWOXO
         Q5VeRntVE+uHN/xn6aOvo/0TdaE/+4wKfDvAS27m9fSdwI2oH6mK3d11AiYp0pJmjeHv
         a18P0MgOK1pAEfSMpfWH7gRt0xhyGv9ppl0ZZv28KQwrBZ929a71K1zqMe/eWbPDPlrG
         WBbdeBfQoGtus7Oz0MRuR3UROkfg85P6JVzml+piB0w/UX0l6ETm8I2F9I0nfjr41z33
         yrog==
X-Gm-Message-State: AOJu0YzEhxniT8ibwK6IXRFOEaEq0CbgIiYhzShi6wgPRHsjBX0Ixn/u
        3vHSR8gEDJOfBWu85JDJElgCIdA+u8vOtEozD6BNiQ==
X-Google-Smtp-Source: AGHT+IHBs3xzGbOBxozI0mr9y6ZRlkWvaDBFuz2bQqZAf7GpLb7JfbwGUaiEHntwkG/81KgXoUiV2DoZ3Q51zSTkyZo=
X-Received: by 2002:a17:903:290:b0:1ca:16b8:b541 with SMTP id
 j16-20020a170903029000b001ca16b8b541mr2851plr.24.1697561359975; Tue, 17 Oct
 2023 09:49:19 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-9-rananta@google.com>
 <5d35c9f3-455e-6aa9-fd6a-4433cf70803a@redhat.com>
In-Reply-To: <5d35c9f3-455e-6aa9-fd6a-4433cf70803a@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 17 Oct 2023 09:49:07 -0700
Message-ID: <CAJHc60z7U1-irTy-6URb_V0PTW+TYS4qodf2akSg33_7CJgjyw@mail.gmail.com>
Subject: Re: [PATCH v7 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
To:     Sebastian Ott <sebott@redhat.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 8:52=E2=80=AFAM Sebastian Ott <sebott@redhat.com> w=
rote:
>
> On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
> > +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
r,
> > +                 u64 val)
> > +{
> > +     struct kvm *kvm =3D vcpu->kvm;
> > +     u64 new_n, mutable_mask;
> > +
> > +     mutex_lock(&kvm->arch.config_lock);
> > +
> > +     /*
> > +      * Make PMCR immutable once the VM has started running, but do
> > +      * not return an error (-EBUSY) to meet the existing expectations=
.
> > +      */
>
> Why should we mention which error we're _not_ returning?
>
Oh, it's not to break the existing userspace expectations. Before this
series, any 'write' from userspace was possible. Returning -EBUSY all
of a sudden might tamper with this expectation.

Thank you.
Raghavendra
>
> > +     if (kvm_vm_has_ran_once(vcpu->kvm)) {
> > +             mutex_unlock(&kvm->arch.config_lock);
> > +             return 0;
> > +     }
>
