Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E744F6E9B20
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 19:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjDTR40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 13:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjDTR4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 13:56:25 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E10126A9
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 10:56:23 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id e13-20020a05600c4e4d00b003f18e479d9aso724156wmq.1
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 10:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682013381; x=1684605381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8BaEiCrvc7KHwNEBjlvfuESnMRe56w2uz4DYBpQhgGA=;
        b=LFrilngd0JDFJ4I4Fn9xBdLU91w/njcH+2iySGD3GKESYjXD6I2V8yqSkeVttOZwDr
         BZza3/5VaBJQiN4R6ozXX1IazA+wrRpwESzz3OECYvIvkRQfBOAxPajrRKOfPuTHV5rv
         2mRb+RjZKManQR9wXK1PxeGoz7NU+VtD6asMprmQPqhYBMAHGTkKMiEQl9qrwZs35Xmv
         s6EC1p3rHr6LzYc97XAeGOGO1mJVAk41IDMDKa1Fcp/s6zdU+jtGAgaclqR6r8WsA1wg
         0RSQs5SWpeZJj3nZ61ndHH0OottFBeXt4XCZGAA6XtyHS5LlJlTHhgGiIMj76Z8tTV22
         DhMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682013381; x=1684605381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8BaEiCrvc7KHwNEBjlvfuESnMRe56w2uz4DYBpQhgGA=;
        b=lSh9pytI+h7qFQfJqZufqHvpCkJn7WO9PVbD8Gu37EE7/lnOgm3dKubIJBqQjvOIhL
         oXmyDHbfu4nciR3eBJ6kUHhOo2kUw3BD4Nu9RIYBNAQ6gx99RALVgyoSUPZq/oKSaLjg
         q4Q5dWw6Rk4u27W+AQXBTPWtMt2KEcZiDwKhwTRQ5SDZlgyNDn0wQREriVp4PkWUaOpW
         6n6LMQ0pyMV7bocY1Z4kqn9Ldkv5ydQZeHsXgyUJebp1AqMGFZPR2qrUzgHaRYvJM6gv
         U9GxNipCpINMMN5EQRSoEm7ytOVTX1rJ7baUJ0DOjpfWeEG6/+Cwb3Y2ebJtQUtma3Dt
         gMpw==
X-Gm-Message-State: AAQBX9fVU7MFKNCzHtS/6okbOMj7UUp3fV0QRNqekYmByT6+rtPn7BMw
        b8XqPuL3lkpNuK1zRyAZL14e1JDnAPF7ArNXmqbWQQ==
X-Google-Smtp-Source: AKy350YwV+jvclmodNud5gT0zhJyILcSdQUr6vuo6/97MQp31mny4Bs372lriE7b/+mPQPLW0sFtt6u788yfyNof3uA=
X-Received: by 2002:a7b:cd11:0:b0:3f0:310c:e3cf with SMTP id
 f17-20020a7bcd11000000b003f0310ce3cfmr2009926wmj.37.1682013381593; Thu, 20
 Apr 2023 10:56:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-2-amoorthy@google.com>
 <e73e9a97-3c76-fa71-b481-c0673e8562de@gmail.com>
In-Reply-To: <e73e9a97-3c76-fa71-b481-c0673e8562de@gmail.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 20 Apr 2023 10:55:44 -0700
Message-ID: <CAF7b7mqMhQmQzJEhZJvEXGUzFB=jSXXOQUr22=Ef+oT-EDyEkg@mail.gmail.com>
Subject: Re: [PATCH v3 01/22] KVM: selftests: Allow many vCPUs and reader
 threads per UFFD in demand paging test
To:     Hoo Robert <robert.hoo.linux@gmail.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, jthoughton@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 19, 2023 at 6:51=E2=80=AFAM Hoo Robert <robert.hoo.linux@gmail.=
com> wrote:
>
> On 4/13/2023 5:34 AM, Anish Moorthy wrote:
> > At the moment, demand_paging_test does not support profiling/testing
> > multiple vCPU threads concurrently faulting on a single uffd because
> >
> >      (a) "-u" (run test in userfaultfd mode) creates a uffd for each vC=
PU's
> >          region, so that each uffd services a single vCPU thread.
> >      (b) "-u -o" (userfaultfd mode + overlapped vCPU memory accesses)
> >          simply doesn't work: the test tries to register the same memor=
y
> >          to multiple uffds, causing an error.
> >
> > Add support for many vcpus per uffd by
> >      (1) Keeping "-u" behavior unchanged.
> >      (2) Making "-u -a" create a single uffd for all of guest memory.
> >      (3) Making "-u -o" implicitly pass "-a", solving the problem in (b=
).
> > In cases (2) and (3) all vCPU threads fault on a single uffd.
> >
> > With multiple potentially multiple vCPU per UFFD, it makes sense to
>         ^^^^^^^^
> redundant "multiple"?

Thanks, fixed

> > --- a/tools/testing/selftests/kvm/demand_paging_test.c
> > +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> > @@ -77,9 +77,15 @@ static int handle_uffd_page_request(int uffd_mode, i=
nt uffd,
> >               copy.mode =3D 0;
> >
> >               r =3D ioctl(uffd, UFFDIO_COPY, &copy);
> > -             if (r =3D=3D -1) {
> > -                     pr_info("Failed UFFDIO_COPY in 0x%lx from thread =
%d with errno: %d\n",
> > -                             addr, tid, errno);
> > +             /*
> > +              * With multiple vCPU threads fault on a single page and =
there are
> > +              * multiple readers for the UFFD, at least one of the UFF=
DIO_COPYs
> > +              * will fail with EEXIST: handle that case without signal=
ing an
> > +              * error.
> > +              */
>
> But this code path is also gone through in other cases, isn't it? In
> those cases, is it still safe to ignore EEXIST?

Good point: the answer is no, it's not always safe to ignore EEXISTs
here. For instance the first UFFDIO_CONTINUE for a page shouldn't be
allowed to EEXIST, and that's swept under the rug here. I've added the
following to the comment

+ * Note that this does sweep under the rug any EEXISTs occurring
+ * from, e.g., the first UFFDIO_COPY/CONTINUEs on a page. A
+ * realistic VMM would maintain some other state to correctly
+ * surface EEXISTs to userspace or prevent duplicate
+ * COPY/CONTINUEs from happening in the first place.

I could add that extra state to the self test (via for instance, an
atomic bitmap that threads "or" into before issuing any
COPY/CONTINUEs) but it's a bit of an extra complication without any
real payoff. Let me know if you think the comment's inadequate though.

> > +             if (r =3D=3D -1 && errno !=3D EEXIST) {
> > +                     pr_info("Failed UFFDIO_COPY in 0x%lx from thread =
%d, errno =3D %d\n",
> > +                                     addr, tid, errno);
>
> unintended indent changes I think.
>
> >                       return r;
> >               }
> >       } else if (uffd_mode =3D=3D UFFDIO_REGISTER_MODE_MINOR) {
> > @@ -89,9 +95,10 @@ static int handle_uffd_page_request(int uffd_mode, i=
nt uffd,
> >               cont.range.len =3D demand_paging_size;
> >
> >               r =3D ioctl(uffd, UFFDIO_CONTINUE, &cont);
> > -             if (r =3D=3D -1) {
> > -                     pr_info("Failed UFFDIO_CONTINUE in 0x%lx from thr=
ead %d with errno: %d\n",
> > -                             addr, tid, errno);
> > +             /* See the note about EEXISTs in the UFFDIO_COPY branch. =
*/
>
> Personally I would suggest copy the comments here. what if some day above
> code/comment was changed/deleted?

You might be right: on the other hand, if the comment ever gets
updated then it would have to be done in two places. Anyone to break
the tie? :)

> > @@ -148,18 +158,32 @@ struct uffd_desc *uffd_setup_demand_paging(int uf=
fd_mode, useconds_t delay,
> >       TEST_ASSERT((uffdio_register.ioctls & expected_ioctls) =3D=3D
> >                   expected_ioctls, "missing userfaultfd ioctls");
> >
> > -     ret =3D pipe2(uffd_desc->pipefds, O_CLOEXEC | O_NONBLOCK);
> > -     TEST_ASSERT(!ret, "Failed to set up pipefd");
> > -
> >       uffd_desc->uffd_mode =3D uffd_mode;
> >       uffd_desc->uffd =3D uffd;
> >       uffd_desc->delay =3D delay;
> >       uffd_desc->handler =3D handler;
>
> Now that these info are encapsulated into reader args below, looks
> unnecessary to have them in uffd_desc here.

Good point. I've removed uffd_mode, delay, and handler from uffd_desc.
I left the "uffd" field in because that's a shared resource, and
close()ing it as "close(desc->uffd)" makes more sense than, say,
"close(desc->reader_args[0].uffd)"
