Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3926E85E9
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 01:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbjDSX0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 19:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjDSX0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 19:26:46 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338311FD3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 16:26:44 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o29-20020a05600c511d00b003f1739de43cso286082wms.4
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 16:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681946802; x=1684538802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tPEpl165mfYvy9T7s6K/AOw86FzBzrStc3Zob8MFFuc=;
        b=om5ZDWcpQHhZivxtfcJiW0+S6OuX9kPpTw9FcDnas8O6UirVWJ57HimdRJaSMMsvnt
         m5caIkfbLvFQcAadWubhwR6Ua9HJ7DbcGNK/pDXxJhFqSgNowchEUSMvHlbHiflnMGCT
         ZjDn/kqdX2/5gf7Se9GAIQHXqf1u33EO5jo8MHiFz9TEHJsWdubdibG4FJEi4+7w0enR
         +sNGkItAVqMKdsxrWTYwU97cTriqKit8kiNPNk7sPNzysuAzVAPESuB5Z042xhRKq/jP
         gj6MlRWWgFBqJ1OBTkwzJXjSpsRe3H9+SbzRJFEZB6+vzz9wUGXIhriCAjvKMLpZBRU1
         V6ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681946802; x=1684538802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tPEpl165mfYvy9T7s6K/AOw86FzBzrStc3Zob8MFFuc=;
        b=aSGecJ+o7K5ljievyosDy6LM3ixqGFOiXoRMl6Qkmg6IMuthsxXdk2ZktAaZQKcYiF
         0uwd4A+rFN4ShX66hQqtdHprU9MB27cE1/TSScz5o8OuSSyU7ojDgHaV9Xz6ruaSfWHt
         SD0qKEavvr6McYmiqBogQkc3pNS2GMrri9LqrQa8xCrvlS80wXWEyy1AAF9gaHhi9yZ4
         QVgxf+PSlHSzuJqOvvXr5RrFJnPRczK3JxLvjOFcz/BCUHWf3pbMa8Eorb9hZMZ+fp5m
         0LQ23tzepgLcN9KX8giamN92Z23NorlBI3d5uQ4TqxFqSiP2cYeuM6fUt8CeZJtGyjI5
         zyvA==
X-Gm-Message-State: AAQBX9cPMIGUGNbQW8melsF7+EI0uIoTVJKe9MwUiKnwfnhy2+AEUh1M
        uZMLWLPB12EbTlqFCKDGZnocpt67Y70q4mDXi9yUiQ==
X-Google-Smtp-Source: AKy350aGgjiad/WfnyK+DyOn2eUk1ngiL9OPNmn0Iw+laUeHPShxAtPDZHc9saeNfFGGYcThkWWxETPyg/vvgCqDj1U=
X-Received: by 2002:a1c:f402:0:b0:3f0:9f44:c7ce with SMTP id
 z2-20020a1cf402000000b003f09f44c7cemr17828816wma.22.1681946802599; Wed, 19
 Apr 2023 16:26:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-3-amoorthy@google.com>
 <a43e5deb-211a-c4c0-6b1d-7715c3665017@gmail.com>
In-Reply-To: <a43e5deb-211a-c4c0-6b1d-7715c3665017@gmail.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 19 Apr 2023 16:26:05 -0700
Message-ID: <CAF7b7mph_3gtYc=EEJ4fiVLZHRPUpSUY5eYzTsitdXG=pu_1kg@mail.gmail.com>
Subject: Re: [PATCH v3 02/22] KVM: selftests: Use EPOLL in userfaultfd_util
 reader threads and signal errors via TEST_ASSERT
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
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 19, 2023 at 6:36=E2=80=AFAM Hoo Robert <robert.hoo.linux@gmail.=
com> wrote:
>
> How about goto
>         ts_diff =3D timespec_elapsed(start);
> Otherwise last stats won't get chances to be calc'ed.

Good idea, done.

> > +             TEST_ASSERT(r =3D=3D 1,
> > +                                     "Unexpected number of events (%d)=
 from epoll, errno =3D %d",
> > +                                     r, errno);
> >
> too much indentation, also seen elsewhere.

Augh, my editor has been set to a tab width of 4 this entire time.
That... explains a lot >:(

> >               }
> >
> > -             if (!(pollfd[0].revents & POLLIN))
> > -                     continue;
> > +             TEST_ASSERT(!(evt.events & (EPOLLERR | EPOLLHUP)),
> > +                                     "Reader thread received EPOLLERR =
or EPOLLHUP on uffd.");
> >
> >               r =3D read(uffd, &msg, sizeof(msg));
> >               if (r =3D=3D -1) {
> > -                     if (errno =3D=3D EAGAIN)
> > -                             continue;
> > -                     pr_info("Read of uffd got errno %d\n", errno);
> > -                     return NULL;
> > +                     TEST_ASSERT(errno =3D=3D EAGAIN,
> > +                                             "Error reading from UFFD:=
 errno =3D %d", errno);
> > +                     continue;
> >               }
> >
> > -             if (r !=3D sizeof(msg)) {
> > -                     pr_info("Read on uffd returned unexpected size: %=
d bytes", r);
> > -                     return NULL;
> > -             }
> > +             TEST_ASSERT(r =3D=3D sizeof(msg),
> > +                                     "Read on uffd returned unexpected=
 number of bytes (%d)", r);
> >
> >               if (!(msg.event & UFFD_EVENT_PAGEFAULT))
> >                       continue;
> > @@ -93,8 +89,8 @@ static void *uffd_handler_thread_fn(void *arg)
> >               if (reader_args->delay)
> >                       usleep(reader_args->delay);
> >               r =3D reader_args->handler(reader_args->uffd_mode, uffd, =
&msg);
> > -             if (r < 0)
> > -                     return NULL;
> > +             TEST_ASSERT(r >=3D 0,
> > +                                     "Reader thread handler fn returne=
d negative value %d", r);
> >               pages++;
> >       }
> >
>
