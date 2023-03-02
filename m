Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BF06A84AE
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 15:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCBOyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 09:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjCBOyQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 09:54:16 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6041B196A1
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 06:53:47 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id o8so10492603ilt.13
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 06:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677768786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BjgJXi3Jz9F/CoBXBuw9zE1EYEueoUSZmduadnrhg2A=;
        b=KfV5Y9B5IJP0VdnoJZy9dG0y96EUw5uiE2Itybt3mEmdubrO8ciMHrlBdml1+CKVOe
         Fqb2zS9VptCNMzeQ7dBhSb9Ev+btXiPnVxlLulnadnQ2soXUA9WqlWH+PQcj78up7YZ0
         mLuCqQevUMRzpX4wbBju1ie82wBhPuNgAvM2o/y7X2/VT/eSPZ7N6NaB9SdH9nfgTUtX
         xj/nRGfXyszEH3PIqhzKz2LGVfxPtIYasICQOIYWx2mEl+4gcVBFO+VL8DftH0TbukIC
         VoB+Ne3GnNFoG3N25mLjlxqv/hbJ8Pe3071H5dlaVovD9ZP9+xLEA88wDvOySr0WLqCe
         1inw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677768786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BjgJXi3Jz9F/CoBXBuw9zE1EYEueoUSZmduadnrhg2A=;
        b=yNj7289YwnYhSNkMLO48mgUi9VxtNzFRUj9rvTqLpqBqlloVcU5iox1piuXgQkKp/R
         mpcMfEa/fftpKXqob6Cd81qqLjgGeZVRWHWRJsWxXreqqKrAfkSJ3Ni25Iqlm/VIxLqy
         g8zkP5RyMfAAMLKinb9vqx4YKO1Cpx/Y0EsitwZEXzk7vQHXi4ohxMi+4WwV6ay/nf7x
         d5w0/JZC3/t8/rFarTjxeOMOColec1337BTduRQu4/KFUmpc2uQFXSlYTLuGILfK+MpK
         xFnvBgb7lmPJ2wirYAKkQvWBKQeJjAhR14nF2TTIyG24Bkhfwrk2SrhxUE4XNCTAbfaO
         nbfg==
X-Gm-Message-State: AO0yUKXw26P7fzYm2GRSnlNwcUvF3UQOZmm9XSlGkhHwbgy0GlEfBr2j
        utFgui12ymbdDHwcTHnocbY5SYge+cNb2+mQSD2ZcWn8YS4kcR5y
X-Google-Smtp-Source: AK7set/uFcS3YXH9waex3HZr4Z8rimyzTtw7f3wZwR59YfrYxRxUspPS08LiRvEh/CEYhrd6m6sujpfw6atVxAU/WiM=
X-Received: by 2002:a92:a005:0:b0:316:ff39:6bbf with SMTP id
 e5-20020a92a005000000b00316ff396bbfmr4694568ili.6.1677768786130; Thu, 02 Mar
 2023 06:53:06 -0800 (PST)
MIME-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com>
 <20230301053425.3880773-8-aaronlewis@google.com> <65a7d0da-2840-58c5-db19-3e3e94c6c59c@redhat.com>
In-Reply-To: <65a7d0da-2840-58c5-db19-3e3e94c6c59c@redhat.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 2 Mar 2023 06:52:55 -0800
Message-ID: <CAAAPnDE3Yw5DrVXrYUjjiSpcrUxPW6qmG5MM3TvY1582UEiYdA@mail.gmail.com>
Subject: Re: [PATCH 7/8] KVM: selftests: Add string formatting options to ucall
To:     Shaoqin Huang <shahuang@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 1, 2023 at 12:07=E2=80=AFAM Shaoqin Huang <shahuang@redhat.com>=
 wrote:
>
>
>
> On 3/1/23 13:34, Aaron Lewis wrote:
> > Add more flexibility to guest debugging and testing by adding
> > GUEST_PRINTF() and GUEST_ASSERT_FMT() to the ucall framework.
> >
> > A buffer to hold the formatted string was added to the ucall struct.
> > That allows the guest/host to avoid the problem of passing an
> > arbitrary number of parameters between themselves when resolving the
> > string.  Instead, the string is resolved in the guest then passed
> > back to the host to be logged.
> >
> > The formatted buffer is set to 1024 bytes which increases the size
> > of the ucall struct.  As a result, this will increase the number of
> > pages requested for the guest.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> >   .../selftests/kvm/include/ucall_common.h      | 19 ++++++++++++++++++=
+
> >   .../testing/selftests/kvm/lib/ucall_common.c  | 19 ++++++++++++++++++=
+
> >   2 files changed, 38 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools=
/testing/selftests/kvm/include/ucall_common.h
> > index 0b1fde23729b..2a4400b6761a 100644
> > --- a/tools/testing/selftests/kvm/include/ucall_common.h
> > +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> > @@ -13,15 +13,18 @@ enum {
> >       UCALL_NONE,
> >       UCALL_SYNC,
> >       UCALL_ABORT,
> > +     UCALL_PRINTF,
> >       UCALL_DONE,
> >       UCALL_UNHANDLED,
> >   };
> >
> >   #define UCALL_MAX_ARGS 7
> > +#define UCALL_BUFFER_LEN 1024
> >
> >   struct ucall {
> >       uint64_t cmd;
> >       uint64_t args[UCALL_MAX_ARGS];
> > +     char buffer[UCALL_BUFFER_LEN];
> Hi Aaron,
>
> A simple question, what if someone print too long in guest which exceed
> the UCALL_BUFFER_LEN, it seems buffer overflow will happen since
> vsprintf will not check the buffer length.
>
> Just in case, someone may don't know the limit and print too long.
>
> Thanks,
> Shaoqin
> >

In the followup I can check the length of the string written in
ucall_fmt() and return an overflow assert to the host instead if one
is detected.

> >       /* Host virtual address of this struct. */
> >       struct ucall *hva;
> > @@ -32,6 +35,7 @@ void ucall_arch_do_ucall(vm_vaddr_t uc);
> >   void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
> >
> >   void ucall(uint64_t cmd, int nargs, ...);
> > +void ucall_fmt(uint64_t cmd, const char *fmt, ...);
> >   uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
> >   void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
> >   int ucall_header_size(void);
> > @@ -47,6 +51,7 @@ int ucall_header_size(void);
> >   #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)      \
> >                               ucall(UCALL_SYNC, 6, "hello", stage, arg1=
, arg2, arg3, arg4)
> >   #define GUEST_SYNC(stage)   ucall(UCALL_SYNC, 2, "hello", stage)
> > +#define GUEST_PRINTF(fmt, _args...) ucall_fmt(UCALL_PRINTF, fmt, ##_ar=
gs)
> >   #define GUEST_DONE()                ucall(UCALL_DONE, 0)
> >
> >   enum guest_assert_builtin_args {
> > @@ -56,6 +61,18 @@ enum guest_assert_builtin_args {
> >       GUEST_ASSERT_BUILTIN_NARGS
> >   };
> >
> > +#define __GUEST_ASSERT_FMT(_condition, _condstr, format, _args...)   \
> > +do {                                                                 \
> > +     if (!(_condition))                                              \
> > +             ucall_fmt(UCALL_ABORT,                                  \
> > +                       "Failed guest assert: " _condstr              \
> > +                       " at %s:%ld\n  " format,                      \
> > +                       __FILE__, __LINE__, ##_args);                 \
> > +} while (0)
> > +
> > +#define GUEST_ASSERT_FMT(_condition, format, _args...)       \
> > +     __GUEST_ASSERT_FMT(_condition, #_condition, format, ##_args)
> > +
> >   #define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...)       =
       \
> >   do {                                                                 =
       \
> >       if (!(_condition))                                              \
> > @@ -81,6 +98,8 @@ do {                                                 =
                       \
> >
> >   #define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) =3D=3D (b), #a " =3D=
=3D " #b, 2, a, b)
> >
> > +#define REPORT_GUEST_ASSERT_FMT(_ucall) TEST_FAIL("%s", _ucall.buffer)
> > +
> >   #define __REPORT_GUEST_ASSERT(_ucall, fmt, _args...)                 =
       \
> >       TEST_FAIL("%s at %s:%ld\n" fmt,                                 \
> >                 (const char *)(_ucall).args[GUEST_ERROR_STRING],      \
> > diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/tes=
ting/selftests/kvm/lib/ucall_common.c
> > index b6a75858fe0d..92ebc5db1c41 100644
> > --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> > +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> > @@ -54,7 +54,9 @@ static struct ucall *ucall_alloc(void)
> >       for (i =3D 0; i < KVM_MAX_VCPUS; ++i) {
> >               if (!test_and_set_bit(i, ucall_pool->in_use)) {
> >                       uc =3D &ucall_pool->ucalls[i];
> > +                     uc->cmd =3D UCALL_NONE;
> >                       memset(uc->args, 0, sizeof(uc->args));
> > +                     memset(uc->buffer, 0, sizeof(uc->buffer));
> >                       return uc;
> >               }
> >       }
> > @@ -75,6 +77,23 @@ static void ucall_free(struct ucall *uc)
> >       clear_bit(uc - ucall_pool->ucalls, ucall_pool->in_use);
> >   }
> >
> > +void ucall_fmt(uint64_t cmd, const char *fmt, ...)
> > +{
> > +     struct ucall *uc;
> > +     va_list va;
> > +
> > +     uc =3D ucall_alloc();
> > +     uc->cmd =3D cmd;
> > +
> > +     va_start(va, fmt);
> > +     vsprintf(uc->buffer, fmt, va);
> > +     va_end(va);
> > +
> > +     ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
> > +
> > +     ucall_free(uc);
> > +}
> > +
> >   void ucall(uint64_t cmd, int nargs, ...)
> >   {
> >       struct ucall *uc;
>
