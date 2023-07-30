Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A517684B8
	for <lists+kvm@lfdr.de>; Sun, 30 Jul 2023 12:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjG3KDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jul 2023 06:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjG3KDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jul 2023 06:03:44 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33BC10F
        for <kvm@vger.kernel.org>; Sun, 30 Jul 2023 03:03:41 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-348d333e441so16157285ab.2
        for <kvm@vger.kernel.org>; Sun, 30 Jul 2023 03:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690711421; x=1691316221;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+QtAKHLWWdpFsqlgQ4Ct5h+g9IOLm0iehWzHC46M1b8=;
        b=K4VzamVarYLUOAYS0cGXR9k6+/TDj0fkIk3OI39YeeoMLlgrv/QlHz+iJ7wrxGNfwx
         5QxgJ56IA1WvjMukWVOOd+OttzaqTKnv5I60k/yFlZqtN+1FKgmekMgBh8TanJjLs6CO
         7MQhQxCyd9BYZcrRK0kNit+EvrPAH3MhFBkudDaam9svHFZyHQuYVfZwIgMd7XBdGzmT
         qzGKZ36yc4iUap1inTjGvqtkkHI431huNlWzGYNJj1ldiX3Dh6zzPyivZyoVmNenAlMi
         AR8Vl3spahrjaewqOF2RGldCRv80/oWtEUHgcjHPSNk7ei7xJY8+OpS02t7nUm7knIl5
         dOsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690711421; x=1691316221;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+QtAKHLWWdpFsqlgQ4Ct5h+g9IOLm0iehWzHC46M1b8=;
        b=MNN3/aYYNE7QJ54W8Ff8gzBIUfo0bCECGXFAsisb3v+ATs9Jl0C7dGtwsLq5WFdxMy
         TMKeLTDZiJmZUY8hJ8cvvgwfZFYz8WxivB0u9EtknaM/tTblBE1CCZ9zulPnvI3CjjkP
         I38aO4winDQSCSQ5fsTkaYeqmqcfBabyk81U0kzov4LuQ/RZkZwbcDzXiLSbqTLN2ouc
         4wnLFsf6hrWRw+Zu/lxq7cdUWoGKqjBaRVoQ+yR5eYuqY4ePE0HHKAsXhnczztnkVRoC
         dgSraOQHhmmwipyHFByjv8Z5/DRDoONKGDf1I7Fz+hxwX88e0QxCCyEZ14PTJ+bghfXa
         U9qQ==
X-Gm-Message-State: ABy/qLaiXHZ4/1IZMVQAi2zkNBYh3nD3vg6xu4zwM3OHMalqVCX5JGLb
        FfAQpY6ZpbYH4aR5RPcDrjPEzvNPcMY=
X-Google-Smtp-Source: APBJJlE+TzHJSplw8vjsN0tdaP2/vXvfYI6WTvy5lsPvlP1aqYWMEii5simdK4l5uuAyY3lMdNhXOQ==
X-Received: by 2002:a92:cd86:0:b0:348:7d72:86f3 with SMTP id r6-20020a92cd86000000b003487d7286f3mr6369220ilb.17.1690711420998;
        Sun, 30 Jul 2023 03:03:40 -0700 (PDT)
Received: from localhost (110-174-143-94.tpgi.com.au. [110.174.143.94])
        by smtp.gmail.com with ESMTPSA id kx14-20020a170902f94e00b001b890009634sm6422352plb.139.2023.07.30.03.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Jul 2023 03:03:40 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 30 Jul 2023 20:03:36 +1000
Message-Id: <CUFF6E1RB78K.QT91UG08M495@wheely>
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Nico Boehr" <nrb@linux.ibm.com>, <kvm@vger.kernel.org>
Cc:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Thomas Huth" <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 2/3] migration: Fix test harness hang if
 source does not reach migration point
X-Mailer: aerc 0.15.2
References: <20230725033937.277156-1-npiggin@gmail.com>
 <20230725033937.277156-3-npiggin@gmail.com>
 <169052965551.15205.2179571087904012453@t14-nrb>
In-Reply-To: <169052965551.15205.2179571087904012453@t14-nrb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri Jul 28, 2023 at 5:34 PM AEST, Nico Boehr wrote:
> Quoting Nicholas Piggin (2023-07-25 05:39:36)
> > After starting the test, the harness waits polling for "migrate" in the
> > output. If the test does not print for some reason, the harness hangs.
> >=20
> > Test that the pid is still alive while polling to fix this hang.
> >=20
> > While here, wait for the full string "Now migrate the VM", which I thin=
k
> > makes it more obvious to read and could avoid an unfortunate collision
> > with some debugging output in a test case.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>
> Thanks for attempting to fix this!
>
> > ---
> >  scripts/arch-run.bash | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index 518607f4..30e535c7 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -142,6 +142,7 @@ run_migration ()
> > =20
> >         eval "$@" -chardev socket,id=3Dmon1,path=3D${qmp1},server=3Don,=
wait=3Doff \
> >                 -mon chardev=3Dmon1,mode=3Dcontrol | tee ${migout1} &
> > +       live_pid=3D`jobs -l %+ | grep "eval" | awk '{print$2}'`
>
> Pardon my ignorance, but why would $! not work here?

My mastery of bash is poor, I copied the incoming_pid line. It seems
to work, but if you think $! is better I can try it.

Thanks,
Nick
