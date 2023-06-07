Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9A9726687
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 18:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjFGQzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 12:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjFGQze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 12:55:34 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48B1188
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 09:55:33 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f7e81f0624so2635e9.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 09:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686156932; x=1688748932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ruE04cfvVeW8CCsUWxHjT2VIGz9iXx0ct6ERdVykOrs=;
        b=mTM9stELptDetTxhlwwSyjv/kIr0WOri0zWnGPqEdxd0zir3q2uh2H3etl1h+QlUnx
         IOP4eyJHhBlxRG0zLcAgasGPRhMK1dWYb3JlIAcTRVk5kbI5QT60Lxn1O+NBWFmUlFVG
         tuAL20xCY0Q7slo5hhjz3kv9f4pgfO6gydFBh1uLgZbd3SZ4vWbSW91dkrjZJtdzIGC6
         4uzcG5TzSzElRfdo1WgyS5wqwMaDv8OlJ0PdGjinXZbKj8bzfrBpwS8T2AkNwfdOwB2u
         u8sYJ8aiTCHQilgKHhUgDsIdnEilPdcK4xedwAk2BAr2kMMKUhWKP5S/jGGk9yWL95EQ
         hv9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686156932; x=1688748932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ruE04cfvVeW8CCsUWxHjT2VIGz9iXx0ct6ERdVykOrs=;
        b=iGklQ73q27r2Rp9Dz/mXx96uptWjlxi5Gc7kllxVOROUi8eCXvLrsgDF193n/Sj/J0
         9cwsHen0z4mUnvTxgy27aIfcmlDC20sar6lSd/N+J9htEZc1vppqkf6gPdEt4AAYfWwk
         qfTPJ5vdnymd1rvPM/ztucLZrOYZeTlOLaViECqreBcFjAEgEbp+hqDpUZV4gAJHwAXL
         o3QIC6blQWfAeltprDIlr5EXK8TvKHUMRty5sxBOdbqbEUjumM6Y1Js8Mr10kT7SQ83i
         z9XBj1i0M4XZd7yumK+QmL2uTTJ80uJhEYvPviMFa6YIty2C1EdbmJSmyzlLLESbPtjo
         sh3g==
X-Gm-Message-State: AC+VfDwEFloOV/0xszBYIWu0KOgv4q4khfEWxNXmrjjoU63TulBxMiNo
        0HSdbsRgzsOjVE+Z7mBPs4yWbWUhkv7wYt1Zx19nJA==
X-Google-Smtp-Source: ACHHUZ7mNacqlI+5GpD43LnhGP0aMi7pLJK+ei3+31ZToKc7B6sAVLAcuZHV5bElNjHD4r4sF148npi9I/1uh1Mi/LQ=
X-Received: by 2002:a05:600c:880f:b0:3f7:e4d8:2569 with SMTP id
 gy15-20020a05600c880f00b003f7e4d82569mr175583wmb.5.1686156932014; Wed, 07 Jun
 2023 09:55:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230424225854.4023978-1-aaronlewis@google.com>
 <20230424225854.4023978-5-aaronlewis@google.com> <ZH5XVOIb2GtwAKNC@google.com>
In-Reply-To: <ZH5XVOIb2GtwAKNC@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 7 Jun 2023 16:55:20 +0000
Message-ID: <CAAAPnDEr+w0N9jis_D9i5Hx1nQswqyg0Wq_0QRNFMuhL6yo3Mw@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: selftests: Add string formatting options to ucall
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
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

On Mon, Jun 5, 2023 at 9:44=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, Apr 24, 2023, Aaron Lewis wrote:
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
> > The buffer size was chosen to accommodate most use cases, and based on
> > similar usage.  E.g. printf() uses the same size buffer in
> > arch/x86/boot/printf.c.
>
> ...
> >  #define UCALL_MAX_ARGS 7
> > +#define UCALL_BUFFER_LEN 1024
> >
> >  struct ucall {
> >       uint64_t cmd;
> >       uint64_t args[UCALL_MAX_ARGS];
> > +     char buffer[UCALL_BUFFER_LEN];
>
> ...
>
> > diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/tes=
ting/selftests/kvm/lib/ucall_common.c
> > index 77ada362273d..c09e57c8ef77 100644
> > --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> > +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> > @@ -55,6 +55,7 @@ static struct ucall *ucall_alloc(void)
> >               if (!test_and_set_bit(i, ucall_pool->in_use)) {
> >                       uc =3D &ucall_pool->ucalls[i];
> >                       memset(uc->args, 0, sizeof(uc->args));
> > +                     memset(uc->buffer, 0, sizeof(uc->buffer));
>
> The use in boot/printf.c isn't a great reference point.  That "allocation=
" is
> on-stack and effectively free, whereas the use here "requires" zeroing th=
e buffer
> during allocation.  I usually tell people to not worry about selftests pe=
rformance,
> but zeroing 1KiB on every ucall seems a bit excessive.
>
> However, that's more of an argument to not zero than it is to try and squ=
eak by
> with a smaller size.  The guest really should explicitly tell the host ho=
w much
> of the buffer.  And with that, there should be no need to zero the buffer=
 because
> the host isn't relying on the memory being zeroed.

I don't think zeroing the buffer is actually necessary.  It is more of
a nice-to-have for extra paranoia.  The printf function ensures the
string is NULL terminated, so I think it should be safe to just drop
it and save the cycles.

With the added assert in patch 2, plus a few more I'm planning on
adding, guest_printf() either properly writes a string or dies.  You
brought up a good point in that selftests generally fail hard rather
than hiding errors, so asserting makes sense there.  That also means
there is no real need to pass the length of the string to the host.
The string should be properly written if guest_printf() returns
successfully.

>
> On a somehwat related topic, this patch should also introduce a macro/hel=
per to
> retrieve and print the buffer on the backend.  Partly to reduce copy+past=
e, partly
> to make it easier to review (i.e. show the end-to-end), and partly so tha=
t the
> ucall code can craft a more explicit contract.

If guest_printf() returns successfully, then the expectation is that
the string was correctly written, which makes the contract pretty
simple.  I'm thinking something like this?

#define REPORT_GUEST_PRINTF(_ucall) pr_info("%s", _ucall.buffer)
