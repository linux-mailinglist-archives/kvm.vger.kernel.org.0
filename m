Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995FB6CA2F8
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 14:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbjC0MAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 08:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjC0MAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 08:00:06 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041471BE2
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:00:05 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so11570979pjt.2
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679918404;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2m/VPMZ9VUPe2DDK1+4k3UgKO74YBFNpfH20hjp6/9g=;
        b=kQLEJlTwUgj0W7F6oAbJoD+jugOc+3XWCTCPdZzUTUhUO6fOQB9y0bPtpaIKGl+r3z
         7Vpj+EnO3pjmerPeXJNSH+kqoMND18vStnO3ScBiC3GpQ1GUu1yPjWxkjXEfjBJvH86m
         9QsfVNRFMi1c3sJBVsFVbhhQHlFr4qtlZzsM7jZJdMA/fCUKd/QghNkryvmTy6FHwtsC
         djjhmjW0M4t2VNUrsCyHhAJTUP5Scgwzv4LJC37de+0nA81aTsh6CPN1GENiArTozLwv
         aixJT6EuzurjhZPdzSUg+z30VPbBx65/o5hiGADvNipx+1AIuuEToPYSqfbchP9uY8Xw
         GjFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679918404;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2m/VPMZ9VUPe2DDK1+4k3UgKO74YBFNpfH20hjp6/9g=;
        b=a2oQsbJtC3hOznKbHsUPV20v958wau8xhGbhfmRz5QUfbTGg0JjmbIf8cIQJ8yP+Fk
         /nMLMjP7uGFlFowMOx5cslWg/uEaz2Q9g8mhJ27QYKkLyJHO8MQemJyTwgjShXKKkj9X
         hLZ1bO9+ESvxGJ6oJ01p4D67dhF5pjb2ORaKkeOhRcO8pEHsaRUbft3xU9sW09yZlKCz
         v5ntdmIscmbC7wt5XtyrYWVVPzRtMpjoO0sKwCJAmibJ4Y2uu60bSMsVJuNh7h86J4WH
         dGAD8DgsWvw253cpiBm88YLW835fGe9YxFHOLBWutpEwsS0C7KFx2RaOL9NC4YkCEBB5
         LirA==
X-Gm-Message-State: AAQBX9dKC5Mvcz1FWcR3P+fk/q/BcgeU4SaG5vOmQ4Nk2PdiPzGO4r/9
        ixYaIs+f/xq01P2C+REUlJ5KpQ+CRx8=
X-Google-Smtp-Source: AKy350ZjljCoQLxO01Xg7ySmstFnt3j9gOxc7uScBfPzNsQ4S9SIY7prAnI9U+kM2Qz6tGqn229I1A==
X-Received: by 2002:a17:90b:4b0a:b0:23f:7625:49b6 with SMTP id lx10-20020a17090b4b0a00b0023f762549b6mr13059754pjb.37.1679918404438;
        Mon, 27 Mar 2023 05:00:04 -0700 (PDT)
Received: from localhost ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id jm2-20020a17090304c200b001a04d27ee92sm13968626plb.241.2023.03.27.05.00.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 05:00:03 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 27 Mar 2023 21:59:59 +1000
Message-Id: <CRH5DEP0G8PU.3VNYL9SG2G0TF@bobo>
Subject: Re: [kvm-unit-tests v2 06/10] powerpc/sprs: Specify SPRs with data
 rather than code
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>
Cc:     <linuxppc-dev@lists.ozlabs.org>,
        "Laurent Vivier" <lvivier@redhat.com>
X-Mailer: aerc 0.13.0
References: <20230320070339.915172-1-npiggin@gmail.com>
 <20230320070339.915172-7-npiggin@gmail.com>
 <f03084cc-8ac6-b2cb-b2e8-39bc73843ab7@redhat.com>
In-Reply-To: <f03084cc-8ac6-b2cb-b2e8-39bc73843ab7@redhat.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu Mar 23, 2023 at 10:36 PM AEST, Thomas Huth wrote:
> On 20/03/2023 08.03, Nicholas Piggin wrote:
> > +/* SPRs common denominator back to PowerPC Operating Environment Archi=
tecture */
> > +static const struct spr sprs_common[1024] =3D {
> > +  [1] =3D {"XER",		64,	RW,		SPR_HARNESS, }, /* Compiler */
> > +  [8] =3D {"LR", 		64,	RW,		SPR_HARNESS, }, /* Compiler, mfspr/mtspr *=
/
> > +  [9] =3D {"CTR",		64,	RW,		SPR_HARNESS, }, /* Compiler, mfspr/mtspr *=
/
> > + [18] =3D {"DSISR",	32,	OS_RW,		SPR_INT, },
> > + [19] =3D {"DAR",		64,	OS_RW,		SPR_INT, },
> > + [26] =3D {"SRR0",	64,	OS_RW,		SPR_INT, },
> > + [27] =3D {"SRR1",	64,	OS_RW,		SPR_INT, },
> > +[268] =3D {"TB",		64,	RO	,	SPR_ASYNC, },
> > +[269] =3D {"TBU",		32,	RO,		SPR_ASYNC, },
> > +[272] =3D {"SPRG0",	64,	OS_RW,		SPR_HARNESS, }, /* Int stack */
> > +[273] =3D {"SPRG1",	64,	OS_RW,		SPR_HARNESS, }, /* Scratch */
> > +[274] =3D {"SPRG2",	64,	OS_RW, },
> > +[275] =3D {"SPRG3",	64,	OS_RW, },
> > +[287] =3D {"PVR",		32,	OS_RO, },
> > +};
>
> Using a size of 1024 for each of these arrays looks weird. Why don't you =
add=20
> a "nr" field to struct spr and specify the register number via that field=
=20
> instead of using the index into the array as register number?

Oh I meant to reply to this. I did try it that way at first. When it
came manipulating the arrays like merging them or adding and
subtracing some SPRs, it required a bit of code to search, sort, add,
remove, etc. This way takes almost nothing. It is a dumb data structure
but it works okay here.

Thanks,
Nick
