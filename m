Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1619E54A352
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 02:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239605AbiFNAwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 20:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239132AbiFNAwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 20:52:47 -0400
Received: from mail-yw1-x1143.google.com (mail-yw1-x1143.google.com [IPv6:2607:f8b0:4864:20::1143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B50A47D;
        Mon, 13 Jun 2022 17:52:46 -0700 (PDT)
Received: by mail-yw1-x1143.google.com with SMTP id 00721157ae682-31336535373so14984037b3.2;
        Mon, 13 Jun 2022 17:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OJVToNO7CfirM2mS/wmfpYjagzrj98GWvj0UuFFVilo=;
        b=VtO4WhW0LTva8izAKf2cjLEEVNuc00h/nyH5oRd+R0dxDmyDOBwVkQm3haSlubjltK
         mLPCLmBGsqSIPBcwTmJsB1mi0eOhaaypjvveq2CX82fmLerrKW+5RSWbeqjQGzaYNyTm
         4OKpcFgzNh7Cf3y/QW5y0TCNiVA2Oc8tG7zqSHChA2w8KQUuFVnCW1g4A15MCQwyTNDz
         axjeL1j5PGxzZzUgfrg6coWHmvMQTAi9IsXdcczJtzaG9Q8iM6FB/sCa/wkkFQTj1ikd
         Cps6HcjWp/I5wtrsEALQViMgXDMiaO9ORrdQ/AW7NsYYOcVFcD+n7PILkvqUk+l8oJOR
         pFZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OJVToNO7CfirM2mS/wmfpYjagzrj98GWvj0UuFFVilo=;
        b=Fu1VqRtaNDo7IB+uveh2oQa0nO5lC5/6P32TmvkCp1gy3AvweeXbzbIHprQ8rofsMP
         OEeX1C+QTOeklRAo0dkUdz4dpCZ71gjNqvfIC0u4poxLFdaLJyDNzIDROTLr904UNcVz
         Yie5GGpbVTuHGppp5lDA/EJKoSH+s1cawhsBxpzlpqbujokgK2utd7DjNBSqIaqHOoif
         qvH4EG1VkTGIi1aa5e4eFFCbqNKA891p2+ObHSJCdTLj/+1zrYf0YobJwQjk3HZOzXNt
         zWNvuzeSHKV4dpl6ssczxfai2RYwsjn9Qkn9oVp5KiWHW2eg7Vuqb7X4938tiPsSg4iD
         KIVg==
X-Gm-Message-State: AJIora/36imUHcemZo0yTCPxK6sCU/lYCXngmq0e0mECxHmAjGD7PPlw
        D5qxmm/hTrusHH1f/fqpK446PATJJJNQAkj6PA==
X-Google-Smtp-Source: AGRyM1voaKvM7WL9yh0uhoHYjcQwH/vjf54SJBxEEiBT75sTy5z1IUD20MbAuQK1UAm6t97oeaa7ZaehvkFXi05T4No=
X-Received: by 2002:a81:2fd8:0:b0:314:eaa:bbc1 with SMTP id
 v207-20020a812fd8000000b003140eaabbc1mr2748956ywv.141.1655167965520; Mon, 13
 Jun 2022 17:52:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220612035641.1161945-1-sunliming@kylinos.cn> <66c1cf3a-9f2a-e05a-3c76-62b1ee056385@intel.com>
In-Reply-To: <66c1cf3a-9f2a-e05a-3c76-62b1ee056385@intel.com>
From:   sunliming <kelulanainsley@gmail.com>
Date:   Tue, 14 Jun 2022 08:52:34 +0800
Message-ID: <CAJncD7Tn4i59SR=Ee-dEXkXq74g8LEzRQ7X=fE92kM26BFocig@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove unused "type" of split_page_type()
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     isaku.yamahata@intel.com, pbonzini@redhat.com, seanjc@google.com,
        mingo@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I got it, I am sorry aboot it , thanks.

Xiaoyao Li <xiaoyao.li@intel.com> =E4=BA=8E2022=E5=B9=B46=E6=9C=8813=E6=97=
=A5=E5=91=A8=E4=B8=80 10:48=E5=86=99=E9=81=93=EF=BC=9A

>
> On 6/12/2022 11:56 AM, sunliming wrote:
> > The variable 'type' in split_page_type() is set but not used, so remove
> > it.
> >
> > Fixes the following w1 warning:
> >
> > arch/x86/kvm/mmu/mmu.c:982:28: warning: variable 'type' set but not use=
d [-Wunused-but-set-variable]
>
> Please note, the code doesn't get into upstream yet.
>
> The fix shouldn't be sent to upstream maillist.
>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: sunliming <sunliming@kylinos.cn>
> > ---
> >   arch/x86/kvm/mmu/mmu.c | 2 --
> >   1 file changed, 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 7b3df91a93cf..f4d577335f94 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -979,14 +979,12 @@ static void split_page_type(gfn_t gfn, struct kvm=
_memory_slot *slot,
> >                           enum pg_level level)
> >   {
> >       struct kvm_page_attr *page_attr =3D page_attr_slot(gfn, slot, lev=
el);
> > -     enum kvm_page_type type;
> >       gfn_t base_gfn;
> >
> >       if (WARN_ON_ONCE(!kvm_page_type_valid(page_attr) || level <=3D PG=
_LEVEL_4K))
> >               return;
> >
> >       base_gfn =3D gfn & ~(KVM_PAGES_PER_HPAGE(level) - 1);
> > -     type =3D page_attr->type;
> >
> >       /*
> >        * Set the type to KVM_PAGE_TYPE_MIXED in advance since when a la=
rge
>
