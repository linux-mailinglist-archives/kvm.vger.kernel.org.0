Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14BAB77BEE2
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 19:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjHNR0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 13:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbjHNR0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 13:26:06 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D2B10C1
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 10:26:04 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2b9aa1d3029so70985481fa.2
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 10:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692033963; x=1692638763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dHxmrdCePoUqIzSXCIXwM34KYJsPYFh6NJ6Wh+gnmsI=;
        b=r2uHFOiA5ciFaude5QhUyCx0VtHHjcB1mo9ATxg+zSnWITEBxwppqBk7UT3gmL2Scg
         p6hvgxAv9KZ6AxvaPk3uTHhRJdptHZaR8bs8s4BCsTd7ZCnt7A4mwI9haoGf2WOvfeag
         2CBX4YgX4MPBR57j7dPd9V6dqVszlmXx26DjqopwRoBMyUfAvodxo7LsGtZKSkC5CT2J
         BT+qENyOSpoVpiBrWz5b5VZkWZaVgTZuOcm/CE++8uTcC/8OVedx44j4NioXr8p139WF
         bHzFIVqPGC/36ITOKcuSs7fItQL1qP65GxyZ2f7rNtv/yvaUWgG/BlK0t1RB2dlEJTVc
         5uTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692033963; x=1692638763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dHxmrdCePoUqIzSXCIXwM34KYJsPYFh6NJ6Wh+gnmsI=;
        b=hbOctOb4fu98zWHi8nMacdh3E1RlP/D2N0wK+e/3vZwXhr3/2fXym+blfZGgJ/ssFL
         UgPK/OWwLiBwED8vYmB5niTWuYyV82xaz47I5QUUDNGOJGWfNEFl5HNq2aI1B/SZL9+s
         dxFM/CuOn8K305UkKibk4ToU1C/rQYK+umMKGuDRWo0BJ65cLUJHoAf7C5T4FcWkjkGJ
         Rh4TXrKtHJGz2ROR+ZxmlZlSIghbeQTSqDIdbe0+QXlrVM0Y6EVifwW63vySoi/mklRS
         y8PTPXoG+zwBtjxdA2waOimZeC8Li+mdidczaA9JMF4tSujh6JqefOKmTt1FWdzvTTia
         kmBQ==
X-Gm-Message-State: AOJu0Yzb2J+VA4Dl/KitSJetyyCACvssBjzfOLOH1j3dUqCikpEzG8Sl
        t6jib502jRnUtCAE/YGO5QfsFYzFakFeM2NvL5SQLQ==
X-Google-Smtp-Source: AGHT+IEvx93qXFm31EQx1g9kLgdZVLbmq0ikWNBsU81HycBg7bjfUMdmtwNMJShtvqZaEdMGjKolTwK33HGQ1mTqrkc=
X-Received: by 2002:a2e:87cc:0:b0:2b5:80e0:f18e with SMTP id
 v12-20020a2e87cc000000b002b580e0f18emr7319550ljj.3.1692033963034; Mon, 14 Aug
 2023 10:26:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-3-jingzhangos@google.com> <878raex8g0.fsf@redhat.com>
In-Reply-To: <878raex8g0.fsf@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 14 Aug 2023 10:25:51 -0700
Message-ID: <CAAdAUtivsxqpSE_0BL_OftxzwR=e5Rnugb69Ln841ooJqVXgmA@mail.gmail.com>
Subject: Re: [PATCH v8 02/11] KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
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

On Mon, Aug 14, 2023 at 2:46=E2=80=AFAM Cornelia Huck <cohuck@redhat.com> w=
rote:
>
> On Mon, Aug 07 2023, Jing Zhang <jingzhangos@google.com> wrote:
>
> > Add some basic documentation on how to get feature ID register writable
> > masks from userspace.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 29 +++++++++++++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/ap=
i.rst
> > index c0ddd3035462..92a9b20f970e 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6068,6 +6068,35 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 register=
s using the SET_ONE_REG
> >  interface. No error will be returned, but the resulting offset will no=
t be
> >  applied.
> >
> > +4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
> > +-------------------------------------------
> > +
> > +:Capability: none
> > +:Architectures: arm64
> > +:Type: vm ioctl
> > +:Parameters: struct reg_mask_range (in/out)
> > +:Returns: 0 on success, < 0 on error
> > +
> > +
> > +::
> > +
> > +        #define ARM64_FEATURE_ID_SPACE_SIZE  (3 * 8 * 8)
> > +
> > +        struct reg_mask_range {
> > +                __u64 addr;             /* Pointer to mask array */
> > +                __u64 reserved[7];
> > +        };
> > +
> > +This ioctl would copy the writable masks for feature ID registers to u=
serspace.
> > +The Feature ID space is defined as the System register space in AArch6=
4 with
> > +op0=3D=3D3, op1=3D=3D{0, 1, 3}, CRn=3D=3D0, CRm=3D=3D{0-7}, op2=3D=3D{=
0-7}.
> > +To get the index in the mask array pointed by ``addr`` for a specified=
 feature
> > +ID register, use the macro ``ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn,=
 crm, op2)``.
> > +This allows the userspace to know upfront whether it can actually twea=
k the
> > +contents of a feature ID register or not.
> > +The ``reserved[7]`` is reserved for future use to add other register s=
pace. For
> > +feature ID registers, it should be 0, otherwise, KVM may return error.
>
> In case of future extensions, this means that userspace needs to figure
> out what the kernel supports via different content in reg_mask_range
> (i.e. try with a value in one of the currently reserved fields and fall
> back to using addr only if that doesn't work.) Can we do better?
>
> Maybe we could introduce a capability that returns the supported ranges
> as flags, i.e. now we would return 1 for id regs masks, and for the
> future case where we have some values in the next reserved field we
> could return 1 & 2 etc. Would make life easier for userspace that needs
> to work with different kernels, but might be overkill if reserved[] is
> more like an insurance without any concrete plans for extensions.
>

Maybe it'd be better to leave this to whenever we do need to add other
range support?

Jing
