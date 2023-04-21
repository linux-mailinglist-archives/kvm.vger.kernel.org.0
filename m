Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BF16EAA1C
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 14:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjDUMPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 08:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjDUMPk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 08:15:40 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB61C67C
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 05:15:37 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id af79cd13be357-74e17099772so179426685a.1
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 05:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682079336; x=1684671336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H9/EvIBO6003bReGPwzhrCqzDZS/9nB8KFyXDCCManY=;
        b=RyGGvRx21Gvu9bCVR7WXsyfEZERJ4efGvQYat2k7T3Z4tCfzyARLmxI55H1VFK1Gyy
         6yCTR8NJoqPuIlUmaYl4NhjH6IjqKySDXtvzNoHv4QzIu5dRDdeAiNt1MqjrDkC32nqR
         i4/1S6FaaiyWP4m53IZcZ7/EVXp3K2r2e6h7yfub8+uXxbRK6DlQXP+a9LPSEwZ0hmwi
         ZjVweaY+s+t6kPXETa1d9/8Zn7uD3ntTPiZwIyDIj71TdIqLywgWcXqmK1dM2kMBkIl9
         /PevvgiNtDknioSMj6Z1LsmV9hX9ZcIo0/eI697vUsXlfB1q3GWJu1i+p9/MtFAzj+Wl
         YwxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682079336; x=1684671336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H9/EvIBO6003bReGPwzhrCqzDZS/9nB8KFyXDCCManY=;
        b=IgFqemJNdosKT3TV5SlJX00DcdCkCtt0HiSldxZ9F04mkWSHbVVvgzcurC+79ywBt2
         xgmlM2c0ZqFplFfGSH4HRJWaXLk9LBvlEvvAeGrTyK4UgVTfGSixsRVjoBCMCL+uQXec
         5godMg4DnHCKSbx6k4wVppnszHW3IThEh6yCgHFwSnTfZXb9DZ+sZvazY63/CmrhjCmi
         bPkcZ7pX+B7zIssJeOcRS+zXXtTUF++1iOAnXG79ynAV82cvCRL2tUJBIMn3yi2qgH94
         ioa+YB1FOvabeusjdhSlfbIpLdkD2aSfIxhSS2fwRvtblDGy42ITUQ7MWan7jLqFjMrW
         V1EA==
X-Gm-Message-State: AAQBX9e2DsZyHWAqi+P7yiyvndDd/9vucCFj1lrDAzBLpC0ch3bUqKC4
        boHVknIwD4ajxitK3NAnnFquudXaiAo4eLvyS/Y=
X-Google-Smtp-Source: AKy350YLS3W9xq9O8P+qwMVax20PnqooSRm+/+382MwZ/9aQU7mLN3y+tHBuySoAh6eEMcQdzbv7lIzvbSHx3G9/0eI=
X-Received: by 2002:a05:622a:64a:b0:3ef:4cc1:ce9 with SMTP id
 a10-20020a05622a064a00b003ef4cc10ce9mr8156539qtb.9.1682079335666; Fri, 21 Apr
 2023 05:15:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-2-amoorthy@google.com>
 <e73e9a97-3c76-fa71-b481-c0673e8562de@gmail.com> <CAF7b7mqMhQmQzJEhZJvEXGUzFB=jSXXOQUr22=Ef+oT-EDyEkg@mail.gmail.com>
In-Reply-To: <CAF7b7mqMhQmQzJEhZJvEXGUzFB=jSXXOQUr22=Ef+oT-EDyEkg@mail.gmail.com>
From:   Robert Hoo <robert.hoo.linux@gmail.com>
Date:   Fri, 21 Apr 2023 20:15:24 +0800
Message-ID: <CA+wubQC0rqteeDdU04vhWahBiwTU5ty5V+pTUXGYu9xd4ppM0g@mail.gmail.com>
Subject: Re: [PATCH v3 01/22] KVM: selftests: Allow many vCPUs and reader
 threads per UFFD in demand paging test
To:     Anish Moorthy <amoorthy@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, jthoughton@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

Anish Moorthy <amoorthy@google.com> =E4=BA=8E2023=E5=B9=B44=E6=9C=8821=E6=
=97=A5=E5=91=A8=E4=BA=94 01:56=E5=86=99=E9=81=93=EF=BC=9A
>
> > > +             /*
> > > +              * With multiple vCPU threads fault on a single page an=
d there are
> > > +              * multiple readers for the UFFD, at least one of the U=
FFDIO_COPYs
> > > +              * will fail with EEXIST: handle that case without sign=
aling an
> > > +              * error.
> > > +              */
> >
> > But this code path is also gone through in other cases, isn't it? In
> > those cases, is it still safe to ignore EEXIST?
>
> Good point: the answer is no, it's not always safe to ignore EEXISTs
> here. For instance the first UFFDIO_CONTINUE for a page shouldn't be
> allowed to EEXIST, and that's swept under the rug here. I've added the
> following to the comment
>
> + * Note that this does sweep under the rug any EEXISTs occurring
> + * from, e.g., the first UFFDIO_COPY/CONTINUEs on a page. A
> + * realistic VMM would maintain some other state to correctly
> + * surface EEXISTs to userspace or prevent duplicate
> + * COPY/CONTINUEs from happening in the first place.
>
> I could add that extra state to the self test (via for instance, an
> atomic bitmap that threads "or" into before issuing any
> COPY/CONTINUEs) but it's a bit of an extra complication without any
> real payoff. Let me know if you think the comment's inadequate though.
>
IIUC, you could say: in this on demand paging test case, even
duplicate copy/continue doesn't do harm anyway. Am I right?

> > > +             /* See the note about EEXISTs in the UFFDIO_COPY branch=
. */
> >
> > Personally I would suggest copy the comments here. what if some day abo=
ve
> > code/comment was changed/deleted?
>
> You might be right: on the other hand, if the comment ever gets
> updated then it would have to be done in two places. Anyone to break
> the tie? :)

The one who updates the place is responsible for the comments. make sense?:=
)
>
> > > @@ -148,18 +158,32 @@ struct uffd_desc *uffd_setup_demand_paging(int =
uffd_mode, useconds_t delay,
> > >       TEST_ASSERT((uffdio_register.ioctls & expected_ioctls) =3D=3D
> > >                   expected_ioctls, "missing userfaultfd ioctls");
> > >
> > > -     ret =3D pipe2(uffd_desc->pipefds, O_CLOEXEC | O_NONBLOCK);
> > > -     TEST_ASSERT(!ret, "Failed to set up pipefd");
> > > -
> > >       uffd_desc->uffd_mode =3D uffd_mode;
> > >       uffd_desc->uffd =3D uffd;
> > >       uffd_desc->delay =3D delay;
> > >       uffd_desc->handler =3D handler;
> >
> > Now that these info are encapsulated into reader args below, looks
> > unnecessary to have them in uffd_desc here.
>
> Good point. I've removed uffd_mode, delay, and handler from uffd_desc.
> I left the "uffd" field in because that's a shared resource, and
> close()ing it as "close(desc->uffd)" makes more sense than, say,
> "close(desc->reader_args[0].uffd)"

Sure, that's also what I originally changed on my side. sorry didn't
mention it earlier.
