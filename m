Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB12474A751
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 00:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjGFWxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 18:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjGFWxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 18:53:03 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2212107
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 15:52:38 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id 71dfb90a1353d-47e844aac5bso354120e0c.3
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 15:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688683944; x=1691275944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xFM5vvARO4VuyjeAA2Dj/k0wZ3/yn5NXGhIXXP9dftY=;
        b=MHUkGf3/fge9q66ZxvPEmK65FMOZ8VR+wmtd2Zvk7hh1wGZloXnuwcl7kCrtmwEY5C
         ftQjgPiBYe8JoRAuH5ij6mP7Pkpv/fheILEj0kFC+IZMC5336Qchxhualm/zy47y3q+A
         /RITyAs8mYErrLRrLwZCm6KX4NXEcrO8Zw7RHVQkUCy7rTjEb5iFxhYxUvLjNWLkB14f
         GdIyZkbOz454L+ieerH5u9M/p6KpWrAH+v57zCIfWHKgSb8Yf8VqLvs3DEiAMQERqKIo
         mJ1v1VRWBnns1nPLlhKlfjQrzHAv16kF+drGTnrW592pYutm/H322OTLmCrqaqBuGA2c
         jflw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688683944; x=1691275944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xFM5vvARO4VuyjeAA2Dj/k0wZ3/yn5NXGhIXXP9dftY=;
        b=c36dRGTew5waI7O7RHm48FZ+UyqunA2FUfJN51vBnMm7HbwYJHkqHZuOv+fUhzpm5r
         znRpypqoqE6TFja5i4sxl4MVU5dPD0XkGV0tIaANmJpuXwME86OIDBMQnFlRe5Wr44Eo
         tdflV2+Fr0QozPtrZFZvtUFeAwFQxbXugvkJqQ8r/VvMQJftavBaFI8re3UtVj8sZJKy
         N5f4+FcTzXsjMh6S+vb5Lz7o8858LR+qBNFHs0bFvzQSLrUV3TH+AODGF9U9l/qov31H
         F+GZuuineF8t8ONmKP1kKzZlidhm2ks83RL+4xZj5qwpUS9/EUwoluPAq+2PVu5wo7Do
         2j1w==
X-Gm-Message-State: ABy/qLYOgjq4mm00wBbSI9JbuePjZMECZMItQNMJJ8N2YAQ84IiqSPN/
        Ou29mlNN2YPkQ07c+0j/3ma/bWUFzcjXH1JzaBaT4Q==
X-Google-Smtp-Source: APBJJlE6OuavnbaXWp2fxmaTb2w2owpzmowMWj1JftHly7x35c+8VnAE/uji/O8u8se8gY7tDrZf+b6qSx4yEgHqrS0=
X-Received: by 2002:a1f:458f:0:b0:47e:3dc0:ed1 with SMTP id
 s137-20020a1f458f000000b0047e3dc00ed1mr1658229vka.6.1688683943985; Thu, 06
 Jul 2023 15:52:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-6-amoorthy@google.com>
 <ZIoQoIe+UF6qix5v@google.com>
In-Reply-To: <ZIoQoIe+UF6qix5v@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 6 Jul 2023 15:51:48 -0700
Message-ID: <CAF7b7mrxNdMJZT=BQC5VP2EK7SdihW_BfaSywbtJpFz0bgiUbw@mail.gmail.com>
Subject: Re: [PATCH v4 05/16] KVM: Annotate -EFAULTs from kvm_vcpu_write_guest_page()
To:     Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
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

On Wed, Jun 14, 2023 at 12:10=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> For future reference, the 80 char limit is a soft limit, and with a lot o=
f
> subjectivity, can be breached.  In this case, this...

Oh neat, I thought it looked pretty ugly too: done.

> Newline after variable declarations.  Double demerits for breaking what w=
as
> originally correct :-)

:(

>
> As mentioned in a previous mail, put this in the (one) caller.  If more c=
allers
> come along, which is highly unlikely, we can revisit that decision.  Righ=
t now,
> it just adds noise, both here and in the helper.
>
> ...
>
> With my various suggestions, something like
>
>         struct kvm_memory_slot *slot =3D kvm_vcpu_gfn_to_memslot(vcpu, gf=
n);
>         int r;
>
>         r =3D __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, =
len);
>         if (r)
>                 kvm_handle_guest_uaccess_fault(...);
>         return r;
>

So, the reason I had the logic within the helper was that it also
returns -EFAULT on gfn_to_hva_memslot() failures.

> static int __kvm_write_guest_page(struct kvm *kvm,
>     struct kvm_memory_slot *memslot, gfn_t gfn,
>     const void *data, int offset, int len)
> {
>     int r;
>     unsigned long addr;
>
>     addr =3D gfn_to_hva_memslot(memslot, gfn);
>     if (kvm_is_error_hva(addr))
>         return -EFAULT;
> ...

Is it ok to catch these with an annotated efault? Strictly speaking
they don't seem to arise from a failed user access (perhaps my
definition is wrong: I'm looking at uaccess.h) so I'm not sure that
annotating them is valid.
