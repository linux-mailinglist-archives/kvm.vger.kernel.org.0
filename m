Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2913652B8FC
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 13:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235765AbiERLpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 07:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbiERLpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 07:45:13 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE32179942
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 04:45:11 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-2fed823dd32so20839627b3.12
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 04:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=DOk/qBx6CR/E5thDmJakrzJzG3N8bnuiBmzG+2mcKuw=;
        b=pMc4+IlM3LZWWpY+A7JvfxUHz8ekRsy4vNEyAp5IL8bFfdbPtzkptZ7ToGLDrcVRqo
         dqlInWeySsq/7Jr8ktAiJZ09bLndX+7/Y4iNNgi0Ruz72F7NQ9FRgt+be1XTIZMnBBez
         GHwue/eAORwA7q+bnLjYaf09Buh5TIl69UBnRiAxEPmjDn1+edUHPJbhkHoWxMFHRIG+
         avH7D+o1l8iAAMDFZ+SelqGhcCutYv1MxKNLVoqajNBiTeZLQIsOxnddLGlGBuH9u8Zh
         Rg2xMGnllqIF0MY9zB3xhEVuKMS9qoInxDV9FFAHPP+LsRBsWANjx+cT2G7Cm1Fdsohr
         pymQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=DOk/qBx6CR/E5thDmJakrzJzG3N8bnuiBmzG+2mcKuw=;
        b=4tZ0/5ozUct/n7UIGcoS8owOmnitgGD2xy3THcQ0y1O4BH4NPhelyn/5OtafQoqNM8
         UhaRVBGcKiuWzIRcr3xHfwwgLZzCYs+8KlW4vQofGt9A23JkRH2tX1xYwnDmIwpKtCJp
         H649L1sX35T452FbmX2takKnvufy37hfliEcyhQUI6spEdWwRgHwhusUuFd3dFXFWn8Y
         B+GflaVTsLhcvr1/sPO3pm0DrSnKkJQdLXWpk+TCY1j9SvyzHZJddw73W+FO0k0IlqMe
         HPaLIpshjMl/a4mSXCin7+b12A/RKZKeZ947XpS6er1C3mMpvkp4TjZYo+WRk0FTmeEz
         lmXA==
X-Gm-Message-State: AOAM530FRWKdwF67viPbXL6tFaWeXfqe5bknbz1mMdjhVLQx6jtZeM5D
        jmUmTDVgqSqOs2CzfoCgbwK3XEi3h5zoQv90UbG1uCFk7Kq6bg==
X-Google-Smtp-Source: ABdhPJynCw04e4sf2MsGWKyiofLoDdDiVsJs/Qxu/4NFTytGVli9L2DA2TRDwMRQNUYfH/vDi/0m/83fz8gY4G+thN4=
X-Received: by 2002:a0d:caca:0:b0:2ff:47bc:ed48 with SMTP id
 m193-20020a0dcaca000000b002ff47bced48mr1563369ywd.64.1652874310937; Wed, 18
 May 2022 04:45:10 -0700 (PDT)
MIME-Version: 1.0
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Wed, 18 May 2022 12:45:00 +0100
Message-ID: <CAFEAcA958zYQrgncpJWpSpjoYoL-VC3-YjObhD96JL87Qh65ww@mail.gmail.com>
Subject: CFP Reminder: KVM Forum 2022
To:     kvm-devel <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        rust-vmm@lists.opendev.org,
        kata-hypervisor@lists.katacontainers.io,
        Libvirt <libvir-list@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

================================================================
KVM Forum 2022
September 12-14, 2022
Dublin, Ireland & Virtual
All submissions must be received before
 *** Friday June 3rd, 2022 at 23:59 PDT ***
================================================================


KVM Forum is an annual event that presents a rare opportunity for
developers and users to discuss the state of Linux virtualization
technology and plan for the challenges ahead. This highly technical
conference unites the developers who drive KVM development and the
users who depend on KVM as part of their offerings, or to power
their data centers and clouds. Sessions include updates on the state
of the KVM virtualization stack, planning for the future, and many
opportunities for attendees to collaborate. Over the years since
its inclusion in the mainline kernel, KVM has become a critical part
of the FOSS cloud infrastructure. Come join us in continuing to
improve the KVM ecosystem.

This year's event is in Dublin, Ireland, but it is a combined
physical+virtual conference: both speaking and attending can be
virtual if you prefer. For more details, registration, travel
and health and safety information, visit:
 https://events.linuxfoundation.org/kvm-forum/

For more information, some suggested topics, and to submit
proposals, please see:
 https://events.linuxfoundation.org/kvm-forum/program/cfp/

We encourage you to submit and reach out to us should you have any
questions. The program committee may be contacted as a group via
email: kvm-forum-2022-pc@redhat.com.

Apologies from the Program Committee for not posting an
announcement of the CFP to these lists sooner.
