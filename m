Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF144DAECC
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 12:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355296AbiCPLW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 07:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348209AbiCPLWZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 07:22:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C029F403EA
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 04:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647429670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/TL583DEkbDyjI2lISe6tf0W0oZtMhVFkrT7h414pGk=;
        b=BYnNWJeX/FV4n5wD8ceq6ffq/z5Lj20WupZIORYAICtCFWXQ7Y5EOFzz29wEJ7TXSjXoHf
        ojft9y638Rebtlr3Y9KHhshDbIC3L+PWp7Bi6X/jbmvRP1XfJQB86sy6yrNqF5NcKlL+yg
        WhzVbq6YGYx1kqY/9+xHO5dQlfH52IE=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-LODNs0bcNb23QUEijqcc-Q-1; Wed, 16 Mar 2022 07:21:09 -0400
X-MC-Unique: LODNs0bcNb23QUEijqcc-Q-1
Received: by mail-yb1-f200.google.com with SMTP id x127-20020a25e085000000b0063372775c9aso1697699ybg.17
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 04:21:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/TL583DEkbDyjI2lISe6tf0W0oZtMhVFkrT7h414pGk=;
        b=XMFRsVSXCzRifqCTaUzUZeY1bbKQa7VyFIvOPlzsGEkz26JFzQ4+Hx9wbTkNvADDY/
         3wkdL92c1q8Mi43X/K48n1mbEJvatqEnEJ28pr5CkBsi3KuURrte5F+mYeX0eVkNfB0o
         qW/bfqPiiHIWg6fSgJa40QB6UGeAynE3Y4dWLOf71K3Ll6xifa1/8BKR3wHp0A8sPeiz
         Ucx8XtjrIzZE27xkNnxTf5Aqdk8PRWyPwMWA5oQrKWrRLhTQbllkeNvg8k5ggshnx2b7
         wA+YoEj3dW5pct2uj0nXZEXeB/ngNn4CMV+vHM3WEAWaTMZnR4VQ9bBywhViTiTweUrk
         TUpQ==
X-Gm-Message-State: AOAM532GKj94QdzZs8uyIVWy2O9M03NngrGZGK/jpAFMM4GRd7e480xX
        gQQr+PHMuTOUoYBmxXH8uqDGrF9YnNWvinwIOsOWlARfgWZgq1SHnKVEHObKE0JBtMSIxAotqQH
        dlT7JCCAJ4JuLApL1PZwwVcFNPMXz
X-Received: by 2002:a81:5dd5:0:b0:2dc:19cf:17ac with SMTP id r204-20020a815dd5000000b002dc19cf17acmr29007702ywb.312.1647429669272;
        Wed, 16 Mar 2022 04:21:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysU1nQ1vExu2W7Wpq+SqXhNmkXldO9veWJlMB2rGlBq+e+M8MHMrYczbsW9bkpOSaf+yfhZ8+NOLyVtGvuMg4=
X-Received: by 2002:a81:5dd5:0:b0:2dc:19cf:17ac with SMTP id
 r204-20020a815dd5000000b002dc19cf17acmr29007686ywb.312.1647429669039; Wed, 16
 Mar 2022 04:21:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220316095308.2613651-1-marcandre.lureau@redhat.com>
 <9c101703-6aff-4188-a56a-8114281f75f4@redhat.com> <20220316121535.16631f9c.pasic@linux.ibm.com>
In-Reply-To: <20220316121535.16631f9c.pasic@linux.ibm.com>
From:   =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Date:   Wed, 16 Mar 2022 15:20:58 +0400
Message-ID: <CAMxuvayNSQxv_fkSE9z1acMk-D3bC+rxyh9q9CLzsDqyADHvNw@mail.gmail.com>
Subject: Re: [PATCH 10/27] Replace config-time define HOST_WORDS_BIGENDIAN
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>, qemu-devel <qemu-devel@nongnu.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bin Meng <bin.meng@windriver.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Peter Xu <peterx@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Yanan Wang <wangyanan55@huawei.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Vikram Garhwal <fnu.vikram@xilinx.com>,
        "open list:virtio-blk" <qemu-block@nongnu.org>,
        David Hildenbrand <david@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Huacai Chen <chenhuacai@kernel.org>,
        Eric Farman <farman@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Greg Kurz <groug@kaod.org>,
        "open list:S390 SCLP-backed..." <qemu-s390x@nongnu.org>,
        "open list:ARM PrimeCell and..." <qemu-arm@nongnu.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "open list:PowerPC TCG CPUs" <qemu-ppc@nongnu.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eduardo Habkost <eduardo@habkost.net>,
        "open list:RISC-V TCG CPUs" <qemu-riscv@nongnu.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Coiby Xu <Coiby.Xu@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi

On Wed, Mar 16, 2022 at 3:16 PM Halil Pasic <pasic@linux.ibm.com> wrote:
>
> On Wed, 16 Mar 2022 11:28:59 +0100
> Thomas Huth <thuth@redhat.com> wrote:
>
> > On 16/03/2022 10.53, marcandre.lureau@redhat.com wrote:
> > > From: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
> > >
> > > Replace a config-time define with a compile time condition
> > > define (compatible with clang and gcc) that must be declared prior to
> > > its usage. This avoids having a global configure time define, but als=
o
> > > prevents from bad usage, if the config header wasn't included before.
> > >
> > > This can help to make some code independent from qemu too.
> > >
> > > gcc supports __BYTE_ORDER__ from about 4.6 and clang from 3.2.
> > >
> > > Signed-off-by: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
> > > ---
> > [...]
> > > @@ -188,7 +188,7 @@ CPU_CONVERT(le, 64, uint64_t)
> > >    * a compile-time constant if you pass in a constant.  So this can =
be
> > >    * used to initialize static variables.
> > >    */
> > > -#if defined(HOST_WORDS_BIGENDIAN)
> > > +#if HOST_BIG_ENDIAN
> > >   # define const_le32(_x)                          \
> > >       ((((_x) & 0x000000ffU) << 24) |              \
> > >        (((_x) & 0x0000ff00U) <<  8) |              \
> > > @@ -211,7 +211,7 @@ typedef union {
> > >
> > >   typedef union {
> > >       float64 d;
> > > -#if defined(HOST_WORDS_BIGENDIAN)
> > > +#if HOST_BIG_ENDIAN
> > >       struct {
> > >           uint32_t upper;
> > >           uint32_t lower;
> > > @@ -235,7 +235,7 @@ typedef union {
> > >
> > >   typedef union {
> > >       float128 q;
> > > -#if defined(HOST_WORDS_BIGENDIAN)
> > > +#if HOST_BIG_ENDIAN
> > >       struct {
> > >           uint32_t upmost;
> > >           uint32_t upper;
> > > diff --git a/include/qemu/compiler.h b/include/qemu/compiler.h
> > > index 0a5e67fb970e..7fdd88adb368 100644
> > > --- a/include/qemu/compiler.h
> > > +++ b/include/qemu/compiler.h
> > > @@ -7,6 +7,8 @@
> > >   #ifndef COMPILER_H
> > >   #define COMPILER_H
> > >
> > > +#define HOST_BIG_ENDIAN (__BYTE_ORDER__ =3D=3D __ORDER_BIG_ENDIAN__)
> >
> > Why don't you do it this way instead:
> >
> > #if __BYTE_ORDER__ =3D=3D __ORDER_BIG_ENDIAN__
> > #define HOST_WORDS_BIGENDIAN 1
> > #endif
> >
> > ... that way you could avoid the churn in all the other files?
> >
>
> I guess "prevents from bad usage, if the config header wasn't included
> before" from the commit message is the answer to that question. I agree
> that it is more robust. If we keep the #if defined we really can't
> differentiate between "not defined because not big-endian" and "not
> defined because the appropriate header was not included."

That's right, thanks

