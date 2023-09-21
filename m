Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896C97AA25C
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjIUVPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbjIUVPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:15:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C0A2114;
        Thu, 21 Sep 2023 10:02:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED51C00444;
        Thu, 21 Sep 2023 07:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695281415;
        bh=0bQtjj08lQ7hZmIm0vxcQccxzsqdYVfn5uDbCn+u2Wo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nDXhmIoqswRZf6OZwxkKd+b2w/PZSNX3p73vVn+sIczXPP90Re+yrYaPNGnyYEUdk
         GDoOYo2r3RaxQdyin23+xfJKFERvWCsLJWfYkK6Nhjwv0bJwUNsxFwk3AK8bOfnEys
         V+PR7WbCG5Y+7ZkX/NJxleqjbO9XEWz2HFb/0dqj6QPw0OC5B0AdhPjMWqJ2n86hUE
         WU6xN/Jaey1db+YaDjcwrC/6NCRExhhVzB99aFokesVVSpPEsu6Hg8a3iAUwBBMDQD
         s8cmzut5E6sk49Jc9+ukLvo0OXcS6XPQvFjI7V8wjNmwnW8IRw3cQPOlNDRpRqQZX2
         q/cjEartPJD/g==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-532bf1943ebso692519a12.0;
        Thu, 21 Sep 2023 00:30:15 -0700 (PDT)
X-Gm-Message-State: AOJu0YzJvgGDsbvzuK7bhlIw5DRwLewIAHKvCQI7xZbalmG8Yzy147cU
        rl/9elygfRuMSZNw2I+RxXC/sU/uQTHufuak4iU=
X-Google-Smtp-Source: AGHT+IFJ26dacuxbCaSY19LvtayzyHj7zwflLmuyY/j24DkQ4afyqJ9S4hS8w5NXT67uXj/IC4wkcXjisCEvqkQhJgc=
X-Received: by 2002:a05:6402:88e:b0:522:2dcc:afb6 with SMTP id
 e14-20020a056402088e00b005222dccafb6mr4337061edy.7.1695281414022; Thu, 21 Sep
 2023 00:30:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
 <CAAhV-H5fbyoMk9XWsejU0zVg4jPq_t2PT3ODKiAnc1LNARpBzA@mail.gmail.com>
 <fed0bbb0-9c94-7dac-4956-f6c9b231fc0d@loongson.cn> <CAAhV-H5_KwmkEczws2diHpk5gDUZSAmy_7Zgi=CowhGZN9_d_A@mail.gmail.com>
 <e53a4428-7533-61cd-81c5-0a65877041fd@loongson.cn> <CAAhV-H7QKBEV_dSfX8nprZ838HRCcDt8cziPip4UdSMuYvERzQ@mail.gmail.com>
 <CABgObfaWiNYWFhR5528=3_1RBqTwTDqNpBHDRbvkd-9UyrCDpg@mail.gmail.com>
In-Reply-To: <CABgObfaWiNYWFhR5528=3_1RBqTwTDqNpBHDRbvkd-9UyrCDpg@mail.gmail.com>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Thu, 21 Sep 2023 15:30:02 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6YormmC7DC4Ar9Rwu16OHKP0G8+=7eShxkWjjQ7kq5mA@mail.gmail.com>
Message-ID: <CAAhV-H6YormmC7DC4Ar9Rwu16OHKP0G8+=7eShxkWjjQ7kq5mA@mail.gmail.com>
Subject: Re: [PATCH v21 00/29] Add KVM LoongArch support
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     zhaotianrui <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Paolo,

On Wed, Sep 20, 2023 at 11:23=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
>
> On Sat, Sep 16, 2023 at 5:17=E2=80=AFAM Huacai Chen <chenhuacai@kernel.or=
g> wrote:
> > I can test now, during my tests I may ask some other questions about
> > your patches. You just need to answer my questions and I will adjust
> > the code myself if needed. After that I will give you a final version
> > with Tested-by and you can simply send that as V22.
>
> Since you are preparing yourself the v22, you could also send it to me
> as a pull request.
OK, after Tianrui sends v22 to the maillist, if there are no more
comments, I will send you a pull request after one or two weeks.
Thanks.

Huacai

>
> Thanks,
>
> Paolo
>
