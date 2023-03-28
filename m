Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAD26CB783
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 08:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjC1Gxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 02:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjC1Gxc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 02:53:32 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614A6E0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 23:53:31 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mp3-20020a17090b190300b0023fcc8ce113so14184321pjb.4
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 23:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679986411;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NtnCUz/Z4iXZV6iYXbbsymcTGbAhqU8t0l4dnsbYOU8=;
        b=RhAoxNcHJ0Xyin7wZ0JGQZ5J9Mlohi0V3RVGoVxR+RMHPTS88uCGN+GqIvmIfjcvMe
         PJ/fLIBpan4JOTN0S9Y8XYAMpDvJXlivSIFiAHN+BmOuqMuQenDO2dD0ekRRel6uEaNH
         6So+x0Um7VNMwnNrj+sFO7t0hma9aKKQfK6J+PhrVyv/xFu/yzVTh7fjZaEF3wcaOEBp
         y+78OgIX8BjflxL2YyEYrabisvSvWi8GiAnElmvHfr8LLqhGjK3xY0yn4y5F6mnzuo8j
         24TNEE2/A7ZIGbMTLQ7TsvDjGyHYetzjXVde2SpvYlH/gc7Fmf549759UBa+tpqjOpgv
         Ttbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679986411;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NtnCUz/Z4iXZV6iYXbbsymcTGbAhqU8t0l4dnsbYOU8=;
        b=hZMqRDYQUdfR9nFi6mzQwbJ6Lpp1c3nOMBX++VNW0L+CIwy9rCxePFWVadVqeLR9V1
         WCzeKhNcDQ8xz8og6eZFXKnpwodWdQGAct9XUNBnonaNNVeQZqUE7Kx0C0DEQN2WiSwq
         c8XUEEb5CoOdpkuZIiupq2Svxo99fZU2FDF980Kyze0xfirATNBzOTbGwbOdHoEJjZzs
         97JVhJGe3EWovDBSb5jWlXzZx3Xa3a6+l74ypkBkcKrecnJORdko5vxRdjVRYoPnufcf
         uPx8fNVtBRTKdcJvdwP4Kr9pBx/Hk6H8k8spwxi8seag+1wr1dgdGA5xFh5Dv2aFBjy4
         vopQ==
X-Gm-Message-State: AO0yUKWYmKoeQ2agTJOFc87LFI1OYm6axTj3aQ4LuW5eoBvQd4+jqAV4
        DESBMFP0rpe0EdnAphQYnbY=
X-Google-Smtp-Source: AK7set+w1Jyeovc8T3Hj6tVvC0KVS0ElNBxL11VTGj18amGdUMV149QQKck/gPQQe+tv7r3cIkRxMg==
X-Received: by 2002:a05:6a20:4faa:b0:cc:eb3b:56e9 with SMTP id gh42-20020a056a204faa00b000cceb3b56e9mr12095774pzb.1.1679986410870;
        Mon, 27 Mar 2023 23:53:30 -0700 (PDT)
Received: from localhost (118-211-28-230.tpgi.com.au. [118.211.28.230])
        by smtp.gmail.com with ESMTPSA id z20-20020aa791d4000000b00625c37469a4sm20863759pfa.97.2023.03.27.23.53.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 23:53:30 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 28 Mar 2023 16:53:26 +1000
Message-Id: <CRHTH8OWIYJ3.3MR13UEJQXEN@bobo>
Cc:     <linuxppc-dev@lists.ozlabs.org>,
        "Laurent Vivier" <lvivier@redhat.com>
Subject: Re: [kvm-unit-tests v3 03/13] powerpc: Add some checking to
 exception handler install
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.13.0
References: <20230327124520.2707537-1-npiggin@gmail.com>
 <20230327124520.2707537-4-npiggin@gmail.com>
 <229dd5e2-b757-d28b-b9db-0d9efce4c5d1@redhat.com>
In-Reply-To: <229dd5e2-b757-d28b-b9db-0d9efce4c5d1@redhat.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue Mar 28, 2023 at 12:39 AM AEST, Thomas Huth wrote:
> On 27/03/2023 14.45, Nicholas Piggin wrote:
> > Check to ensure exception handlers are not being overwritten or
> > invalid exception numbers are used.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> > Since v2:
> > - New patch
> >=20
> >   lib/powerpc/processor.c | 12 ++++++++++++
> >   1 file changed, 12 insertions(+)
> >=20
> > diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
> > index ec85b9d..70391aa 100644
> > --- a/lib/powerpc/processor.c
> > +++ b/lib/powerpc/processor.c
> > @@ -19,11 +19,23 @@ static struct {
> >   void handle_exception(int trap, void (*func)(struct pt_regs *, void *=
),
> >   		      void * data)
> >   {
> > +	if (trap & 0xff) {
>
> You could check for the other "invalid exception handler" condition here=
=20
> already, i.e. if (trap & ~0xf00) ...
>
> I'd maybe simply do an "assert(!(trap & ~0xf00))" here.
>
> > +		printf("invalid exception handler %#x\n", trap);
> > +		abort();
> > +	}
> > +
> >   	trap >>=3D 8;
> >  =20
> >   	if (trap < 16) {
>
> ... then you could get rid of the if-statement here and remove one level =
of=20
> indentation in the code below.

Yes that's the  way to do it. I feel embarrassed for not thinking
of it :)

Thanks,
Nick

>
> > +		if (func && handlers[trap].func) {
> > +			printf("exception handler installed twice %#x\n", trap);
> > +			abort();
> > +		}
> >   		handlers[trap].func =3D func;
> >   		handlers[trap].data =3D data;
> > +	} else {
> > +		printf("invalid exception handler %#x\n", trap);
> > +		abort();
> >   	}
> >   }
> >  =20
>
>   Thomas

