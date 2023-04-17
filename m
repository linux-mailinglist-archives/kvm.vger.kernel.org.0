Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44026E4E46
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 18:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjDQQ0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 12:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDQQ0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 12:26:53 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC7DE53
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 09:26:51 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4ec8148f73eso1557361e87.1
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 09:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1681748810; x=1684340810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fc9CAPaVpkJctXfsZlqqV20QxzF/PQB/adI+baqjcD8=;
        b=iL6znh5GR8oosa9rL6uJVoky5+f2hBn4M87bQIRlX2KlbMZVujYwljyTdO54pPlQn/
         FElmGA62P6lB/KufhDaVpMtNSfhmkaDR8mh1iGq5kG/9wWwy1AhTEYmq7wb5B/QqOBxs
         HN/aYkofWjzPuVZwDsErWrEhSKuAjkemOEOXSGGlMiVoQ++l1XwkaVHVcntOi52stxF1
         NPlPfQZtHUfuOJk8v4AXXQLMjrcmfDPhqy/RXh2+jp9sl1PxpJg8pZVlO6VOogsi6Bpf
         VwxpXCPddL8mmaxI0YGjKxtZs7RL3j8GZa5hn9SbdOb5TPbFR97ss1QYsjNYLvYr5YDK
         k8Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681748810; x=1684340810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fc9CAPaVpkJctXfsZlqqV20QxzF/PQB/adI+baqjcD8=;
        b=cMwLg1VrkD9QwlBQm9mU7cn3ap7UkrxFcAyTajsiadHhuLCJKAodHyuVGaBvm1rMDk
         xP6C5d8ouNjNmluWJMemVMg5vW6TRpIb9REAXFOnZU4XyWzmtpWTb/52RjhWpmSKbMeO
         STWr1Dlh+BqSpT21qDx5rXxVHHFnIjTxie3+0tL6oPpZVWAjNR9HHg9j8SNEceWZLMml
         mlH7FyU1uvGG5c1vE1M1/ZPLm+LV8BTz5c+w90XytT9VC9DSdY47A1Te6uR06rSIc6tv
         jJewNMe7x6b2tGNcHxLjLRyl/+0svU9+0htP6IgfM++jeOKv0XD3mxkrshBwZKvG5PzG
         38/w==
X-Gm-Message-State: AAQBX9dq6h/ePIvV1dQDSIERP/IfFzkwFCKr32fuPnW10OdphaWdMJs0
        jY2zwXtahmnJivIv3TZ1tOI2/SbFDNPjr/pzWAJvaA==
X-Google-Smtp-Source: AKy350ZvkTCGazJNdSfIMp24oXdlgrSSq3R97mEnBScc701HboTp8ViRgvYwP04GNq5+ouw1iJjhwt3+Xo/xjNRghlc=
X-Received: by 2002:a05:6512:96b:b0:4ec:8a46:d1e with SMTP id
 v11-20020a056512096b00b004ec8a460d1emr2431242lft.4.1681748809923; Mon, 17 Apr
 2023 09:26:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230414155843.12963-1-andy.chiu@sifive.com> <eae19ece-0d56-a91c-3417-f00b9b71f04d@codethink.co.uk>
In-Reply-To: <eae19ece-0d56-a91c-3417-f00b9b71f04d@codethink.co.uk>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Tue, 18 Apr 2023 00:26:37 +0800
Message-ID: <CABgGipWwj=3pCefAUkv0fHDKoyqXxuXfqji4KGPo=2hixTgv_A@mail.gmail.com>
Subject: Re: [PATCH -next v18 00/20] riscv: Add vector ISA support
To:     Ben Dooks <ben.dooks@codethink.co.uk>
Cc:     linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ben,

On Mon, Apr 17, 2023 at 11:56=E2=80=AFPM Ben Dooks <ben.dooks@codethink.co.=
uk> wrote:
>
> On 14/04/2023 16:58, Andy Chiu wrote:
> > This patchset is implemented based on vector 1.0 spec to add vector sup=
port
> > in riscv Linux kernel. There are some assumptions for this implementati=
ons.
> >
> > 1. We assume all harts has the same ISA in the system.
> > 2. We disable vector in both kernel and user space [1] by default. Only
> >     enable an user's vector after an illegal instruction trap where it
> >     actually starts executing vector (the first-use trap [2]).
> > 3. We detect "riscv,isa" to determine whether vector is support or not.
> >
> > We defined a new structure __riscv_v_ext_state in struct thread_struct =
to
> > save/restore the vector related registers. It is used for both kernel s=
pace
> > and user space.
> >   - In kernel space, the datap pointer in __riscv_v_ext_state will be
> >     allocated to save vector registers.
> >   - In user space,
> >       - In signal handler of user space, the structure is placed
> >         right after __riscv_ctx_hdr, which is embedded in fp reserved
> >         aera. This is required to avoid ABI break [2]. And datap points
> >         to the end of __riscv_v_ext_state.
> >       - In ptrace, the data will be put in ubuf in which we use
> >         riscv_vr_get()/riscv_vr_set() to get or set the
> >         __riscv_v_ext_state data structure from/to it, datap pointer
> >         would be zeroed and vector registers will be copied to the
> >         address right after the __riscv_v_ext_state structure in ubuf.
> >
> > This patchset is rebased to v6.3-rc1 and it is tested by running severa=
l
> > vector programs simultaneously. It delivers signals correctly in a test
> > where we can see a valid ucontext_t in a signal handler, and a correct =
V
> > context returing back from it. And the ptrace interface is tested by
> > PTRACE_{GET,SET}REGSET. Lastly, KVM is tested by running above tests in
> > a guest using the same kernel image. All tests are done on an rv64gcv
> > virt QEMU.
>
> Ok, are there plans for in-kernel vector patches, or have I missed
> something in this list? I expect once things like the vector-crypto
> hit then people will be wanting in-kernel accelerators.
>

Yes, I am redesigning and planning to submit the in-kernel Vector
support recently. Currently the original one is carried by Heiko's
vector crypto series. The API interface of the refined one should
remain the same but with some optimizations.

> --
> Ben Dooks                               http://www.codethink.co.uk/
> Senior Engineer                         Codethink - Providing Genius
>
> https://www.codethink.co.uk/privacy.html
>

Cheers,
Andy
