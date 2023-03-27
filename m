Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66AA6C9AE3
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 07:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbjC0Fhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 01:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjC0Fhp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 01:37:45 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACD5449C
        for <kvm@vger.kernel.org>; Sun, 26 Mar 2023 22:37:45 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso10203473pjf.0
        for <kvm@vger.kernel.org>; Sun, 26 Mar 2023 22:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679895465;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=frRkG9EFesbSFyKUiG2SU+/T/4pUUQR9yjunJGxY6E0=;
        b=WU8U3lYrmz7ghd1rtctKxA3h2tqXDIpBzJquQZEslXwxa/Td5JGikQWfuAfwYx/7EX
         0/BOQ1ZXqaTNF0/2P1oRn9VGLY9iLHXKUpgn8enR9GR1Iys6STXJRUKSX0pYjMzStK4Z
         izpnPvYJ+uoeuTfmF6EXDiX7XMjOI7cPCGhjDSM/jE6srq4PMQDZX2FrCqJMvT+YLzBe
         dxybcc0qAReRcQbV8Cbi/1uT5ZDU1GQUBQ77fmtiRMfbTE2+0jQhbpchUMEF9tZW8gAG
         NZE1cbS7b0nXt3Gp9PaRxGwVr9Y2OuAiQTeZSaJxZVL2C23XEf+hXbYz9Q1M8h8s9/VL
         Z4Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679895465;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=frRkG9EFesbSFyKUiG2SU+/T/4pUUQR9yjunJGxY6E0=;
        b=OEb7Wrsg+3uXaJGQwdhRBhEY6Bp38vSBAbnD0Bjon6/JxSQRbE0/olhQXhiC8R5uFG
         Sp5gWJ61r7uel9rbKuYO1jDvfPprZoGkCqDFgLBu05GsChF8yI3WsUHh4kHssXobF6A/
         R6eBB/uwitnuFGR9vQB95PU+LlrRwsAGkPAdLsh5NNLa211IaL6Quy+DD2HMReQFhRAX
         ExSrAlai4zu+VS2y0QiNyOtSUjhv70wM6z73prpDvu4I8UlzrsDMSE1hsGhvlcKDWfBI
         WgcZNhEObMIJapGUeb3kRhc0qyJdHv0nAZ4BYKtyoe4+GaVdnhIDWS1JEwZDJV31m30z
         ZQ8Q==
X-Gm-Message-State: AAQBX9cZQea2I8FATfMXyYw+2qghTLXp7YObbbUR+sFoEQJBDYl2M6XS
        fmiUWHSGJwENzDRdfDkVlMw=
X-Google-Smtp-Source: AKy350agVAxGLjxtTnt3fT3/DmwRJBtRvGn4UVdOQKXTpC2UznZv2xx7al60pDlkUuMe2s7MXpCu7A==
X-Received: by 2002:a17:90b:3a83:b0:23b:569d:fe41 with SMTP id om3-20020a17090b3a8300b0023b569dfe41mr11855601pjb.7.1679895464770;
        Sun, 26 Mar 2023 22:37:44 -0700 (PDT)
Received: from localhost ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id d7-20020a17090a498700b002340d317f3esm6552442pjh.52.2023.03.26.22.37.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Mar 2023 22:37:44 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 27 Mar 2023 15:37:40 +1000
Message-Id: <CRGX8OIDBRI5.1J3X5ZHZUIQE6@bobo>
Cc:     <linuxppc-dev@lists.ozlabs.org>,
        "Laurent Vivier" <lvivier@redhat.com>
Subject: Re: [kvm-unit-tests v2 02/10] powerpc: add local variant of SPR
 test
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.13.0
References: <20230320070339.915172-1-npiggin@gmail.com>
 <20230320070339.915172-3-npiggin@gmail.com>
 <ec852041-dc53-f50c-534c-a0f5c1dd153b@redhat.com>
In-Reply-To: <ec852041-dc53-f50c-534c-a0f5c1dd153b@redhat.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu Mar 23, 2023 at 9:26 PM AEST, Thomas Huth wrote:
> On 20/03/2023 08.03, Nicholas Piggin wrote:
> > This adds the non-migration variant of the SPR test to the matrix,
> > which can be simpler to run and debug.
> >=20
> > Reviewed-by: Thomas Huth <thuth@redhat.com>
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   powerpc/unittests.cfg | 4 ++++
> >   1 file changed, 4 insertions(+)
> >=20
> > diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
> > index 1e74948..3e41598 100644
> > --- a/powerpc/unittests.cfg
> > +++ b/powerpc/unittests.cfg
> > @@ -68,5 +68,9 @@ groups =3D h_cede_tm
> >  =20
> >   [sprs]
> >   file =3D sprs.elf
> > +groups =3D sprs
>
> Looking at this again, I think you don't really need a "groups =3D" entry=
 here=20
> ... I'd suggest to drop that line.

Okay, will do.

Thanks,
Nick
